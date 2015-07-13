#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>
#include <inc/string.h>
#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/cpu.h>
#include <kern/spinlock.h>
#include <kern/time.h>

static struct Taskstate ts;

/* For debugging, so print_trapframe can distinguish between printing
 * a saved trapframe and printing the current trapframe and print some
 * additional information in the latter case.
 */
static struct Trapframe *last_tf;

/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {
	sizeof(idt) - 1, (uint32_t) idt
};


static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}


void
trap_init(void)
{
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.


	/* My take here is we have to create IDT (fill struct Gatedesc idt[256]) for all interrupts.

	IDT[#]----> handler#(trapentry.S) ----->trap()-->trap_dispatch()
	
	In trapentry.S we have to push old SS, old ESP, old eflags, old cs, old eip, error code if one
	then we store the above values in trapframe and pass it to trap(&trapframe)
	Now trap see's which is current env. Then stores the trapframe in env_tf. This will help us to
	pop this trapframe when the environement is again given control after handling interrupt 
	by calling env_run.
	*/
	// Per-CPU setup 
	//cprintf("\nin trapinit\n");
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0)
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0)
	SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0)
	SETGATE(idt[T_BRKPT], 0, GD_KT, bkpt_handler, 3)
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0)
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0)
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0)
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0)
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0)
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0)
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0)
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0)
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0)
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0)
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0)
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0)
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0)
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 3)
	
	SETGATE(idt[IRQ_OFFSET], 0, GD_KT, irq0_handler, 0)
	SETGATE(idt[IRQ_OFFSET+1], 0, GD_KT, irq1_handler, 0)
	SETGATE(idt[IRQ_OFFSET+2], 0, GD_KT, irq2_handler, 0)
	SETGATE(idt[IRQ_OFFSET+3], 0, GD_KT, irq3_handler, 0)
	SETGATE(idt[IRQ_OFFSET+4], 0, GD_KT, irq4_handler, 0)
	SETGATE(idt[IRQ_OFFSET+5], 0, GD_KT, irq5_handler, 0)
	SETGATE(idt[IRQ_OFFSET+6], 0, GD_KT, irq6_handler, 0)
	SETGATE(idt[IRQ_OFFSET+7], 0, GD_KT, irq7_handler, 0)
	SETGATE(idt[IRQ_OFFSET+8], 0, GD_KT, irq8_handler, 0)
	SETGATE(idt[IRQ_OFFSET+9], 0, GD_KT, irq9_handler, 0)
	SETGATE(idt[IRQ_OFFSET+10], 0, GD_KT, irq10_handler, 0)
	SETGATE(idt[IRQ_OFFSET+11], 0, GD_KT, irq11_handler, 0)
	SETGATE(idt[IRQ_OFFSET+12], 0, GD_KT, irq12_handler, 0)
	SETGATE(idt[IRQ_OFFSET+13], 0, GD_KT, irq13_handler, 0)
	SETGATE(idt[IRQ_OFFSET+14], 0, GD_KT, irq14_handler, 0)
	SETGATE(idt[IRQ_OFFSET+15], 0, GD_KT, irq15_handler, 0)
	

	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3)
	
	trap_init_percpu();
}
// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{

	// The example code here sets up the Task State Segment (TSS) and
	// the TSS descriptor for CPU 0. But it is incorrect if we are
	// running on other CPUs because each CPU has its own kernel stack.
	// Fix the code so that it works for all CPUs.
	//
	// Hints:
	//   - The macro "thiscpu" always refers to the current CPU's
	//     struct CpuInfo;
	//   - The ID of the current CPU is given by cpunum() or
	//     thiscpu->cpu_id;
	//   - Use "thiscpu->cpu_ts" as the TSS for the current CPU,
	//     rather than the global "ts" variable;
	//   - Use gdt[(GD_TSS0 >> 3) + i] for CPU i's TSS descriptor;
	//   - You mapped the per-CPU kernel stacks in mem_init_mp()
	//
	// ltr sets a 'busy' flag in the TSS selector, so if you
	// accidentally load the same TSS on more than one CPU, you'll
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:


	//cprintf("\n in trapinit per cpu\n");
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - ((thiscpu->cpu_id)*(KSTKSIZE + KSTKGAP));
	//doubtful
	thiscpu->cpu_ts.ts_ss0 = GD_KD;

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id].sd_s = 0;

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr((GD_TSS0) + ((thiscpu->cpu_id)<<3) );
	
	// Load the IDT
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
		cprintf("  cr2  0x%08x\n", rcr2());
	cprintf("  err  0x%08x", tf->tf_err);
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
	cprintf("  eip  0x%08x\n", tf->tf_eip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	if ((tf->tf_cs & 3) != 0) {
		cprintf("  esp  0x%08x\n", tf->tf_esp);
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
	}
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  edi  0x%08x\n", regs->reg_edi);
	cprintf("  esi  0x%08x\n", regs->reg_esi);
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
	cprintf("  edx  0x%08x\n", regs->reg_edx);
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
	cprintf("  eax  0x%08x\n", regs->reg_eax);
}

static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	// LAB 3: Your code here.
	//cprintf("\n trap_dispatch:%d",tf->tf_trapno);
	int32_t sysRet=0;
	int sysno=0;
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
		return;
	}

	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.

	// Add time tick increment to clock interrupts.
	// Be careful! In multiprocessors, clock interrupts are
	// triggered on every CPU.
	// LAB 6: Your code here.


	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	
	if(tf->tf_trapno == T_PGFLT){
		//cprintf("\npgfault\n");
		page_fault_handler(tf);
		//cprintf("\npgfault returning\n");
		return;
	}

	if(tf->tf_trapno == (IRQ_OFFSET+IRQ_TIMER))
	{
		//cprintf("\ntimer interrupt occurred\n");
		//Need to acknowledge interrupt
		time_tick();
		lapic_eoi();
		//cprintf("\nNow time interrupt yielding\n");
		sched_yield();
		//return;
	}
	if(tf->tf_trapno == (IRQ_OFFSET+IRQ_KBD))
	{
		//cprintf("\n keyboard interrupt occurred\n");
		//lapic_eoi();
		kbd_intr();
		sched_yield();
	}
	
	if(tf->tf_trapno == (IRQ_OFFSET+IRQ_SERIAL))
	{
		//cprintf("\n serial interrupt occurred\n");
		//lapic_eoi();
		serial_intr();
		sched_yield();
	}
	
	if(tf->tf_trapno == T_DEBUG){
		monitor(tf);
		return;
	}
	if(tf->tf_trapno == T_BRKPT){
		tf->tf_eflags = tf->tf_eflags | SET_TF;
		monitor(tf);
		return;
	}
	if(tf->tf_trapno == T_SYSCALL){
		sysno = tf->tf_regs.reg_eax;
		//cprintf("\nsystem call received-sid:%d\n",sysno);
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);
		
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
	if (tf->tf_cs == GD_KT)
		panic("unhandled trap in kernel");
	else {
		env_destroy(curenv);
		return;
	}
}

void
trap(struct Trapframe *tf)
{
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
		asm volatile("hlt");

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.

	assert(!(read_eflags() & FL_IF));

	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		assert(curenv);

		lock_kernel();

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
			env_free(curenv);
			curenv = NULL;
			sched_yield();
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
		env_run(curenv);
	else
		sched_yield();
	
}


void page_fault_handler(struct Trapframe *tf)
{
	uint32_t fault_va;
	struct UTrapframe utf;
	uint32_t err=0;
	//memcpy(&utf, 0, sizeof(struct Utrapframe *));

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	/*if(fault_va > ULIM)
		panic("Page fault occurred in kernel!!Exiting!!");*/
	if(tf->tf_cs == (GD_KT >> 3))
		panic("Page fault occurred in kernel!!Exiting!!");
	// Handle kernel-mode page faults.

	// LAB 3: Your code here.

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.
	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// The trap handler needs one word of scratch space at the top of the
	// trap-time stack in order to return.  In the non-recursive case, we
	// don't have to worry about this because the top of the regular user
	// stack is free.  In the recursive case, this means we have to leave
	// an extra word between the current top of the exception stack and
	// the new stack frame because the exception stack _is_ the trap-time
	// stack.
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
	// Note that the grade script assumes you will first check for the page
	// fault upcall and print the "user fault va" message below if there is
	// none.  The remaining three checks can be combined into a single test.
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.

	if(curenv->env_pgfault_upcall == (void *)0)
	{

	// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
			curenv->env_id, fault_va, tf->tf_eip);
		print_trapframe(tf);
		env_destroy(curenv);
	}
	else
	{
		//cprintf("\nerr:%d eip:%d eflags:%d esp:%x\n",utf.utf_err, utf.utf_eip, utf.utf_eflags, utf.utf_esp);
			//cprintf("\ntf_esp:%x utf_esp:%x\n",tf->tf_esp, utf.utf_esp);
			//cprintf("\ntf registers::\n");
			//print_regs(&tf->tf_regs);
			//cprintf("\nutf-regs\n");
			//print_regs(&utf.utf_regs);
			//copy utrapframe on uxstacktop-sizeof(struct Utrapframe *)
		//cprintf("\ntrap in to pagefault by child---envid:%x\n",curenv->env_id);
		user_mem_assert(curenv, (void *)(UXSTACKTOP-1), 1, PTE_P|PTE_U|PTE_W);
		utf.utf_fault_va = fault_va;
		utf.utf_err = tf->tf_err;
		utf.utf_regs = tf->tf_regs;
		utf.utf_eip = tf->tf_eip;
		utf.utf_eflags = tf->tf_eflags;
		utf.utf_esp = tf->tf_esp;
		//need to check esp of trapframe to see whether its already uxstacktop or ustacktop
		if(tf->tf_esp > USTACKTOP)
		{
			//cprintf("\npagefault occurred in exception stack i.e pagefault handler addr:%x\n",tf->tf_esp);
			if(tf->tf_esp > (UXSTACKTOP-PGSIZE) && tf->tf_esp<=(UXSTACKTOP-1))
			{
				//check if new frame overflows uxstacktop-pgsize
				//if so then allocate a new page at va  uxstacktop-pgsize
				//right now I am not checking that.
				if((tf->tf_esp - sizeof(utf)) < (UXSTACKTOP-PGSIZE))
				{
					//uxstack is overflowing
					//should I need to allocate new reserved page
					user_mem_assert(curenv, (void *)(UXSTACKTOP - (PGSIZE)-1), 1, PTE_P|PTE_U|PTE_W);
					//panic("\nUXSTACK is overflowing\n");
				} 	
			}
			//already allocated the reserved page for exception user stack
			else if((tf->tf_esp - sizeof(utf)) < (UXSTACKTOP-2*PGSIZE))
			{
					//uxstack is overflowing
					//should I need to allocate new reserved page
					panic("\nUXSTACK is overflown. Limit reached. No extra pages\n");
			}
			//1. copying empty word to uxstacktop
			memset((void *)(tf->tf_esp - sizeof(uint32_t)), 0, sizeof(uint32_t));
			//2. Now push Utrapframe to uxstacktop's esp
			memcpy((void *)(tf->tf_esp - sizeof(utf) - sizeof(uint32_t)), &utf, sizeof(utf));
			//point esp correctly before tf_pop
			tf->tf_esp = (tf->tf_esp - sizeof(utf) - sizeof(uint32_t));
			
		}
		else
		{
			//cprintf("\nfault occured in normal user stack---addr:%x\n", tf->tf_esp);
			//copy Utrapframe and push to uxstacktop
			memcpy((void *)(UXSTACKTOP-sizeof(utf)), &utf, sizeof(utf));
			tf->tf_esp = (UXSTACKTOP-sizeof(utf));

		}
		//what all changes are needed to jump to user page fault handler
		//1. change eip to pagefault handler
		//2. change the esp to top of uxstack after push utrapframe. (only when pgfault occured from other than pgfault handler)
		tf->tf_eip = (uintptr_t)curenv->env_pgfault_upcall;

	}
}