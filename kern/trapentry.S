/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <kern/picirq.h>

#include <kern/picirq.h>

###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */


/*PAGEFAULT_HANDLER(push_frame, esp, eflags, eip, eax, ecx, edx, ebx, oesp, ebp, esi, edi, error, fa)*/
TRAPHANDLER_NOEC(divide_handler, T_DIVIDE)
TRAPHANDLER_NOEC(debug_handler, T_DEBUG)
TRAPHANDLER_NOEC(nmi_handler, T_NMI)
TRAPHANDLER_NOEC(bkpt_handler, T_BRKPT)
TRAPHANDLER_NOEC(oflow_handler, T_OFLOW)
TRAPHANDLER_NOEC(bound_handler, T_BOUND)
TRAPHANDLER_NOEC(illop_handler, T_ILLOP)
TRAPHANDLER_NOEC(device_handler, T_DEVICE)
TRAPHANDLER(dblflt_handler, T_DBLFLT) #8
TRAPHANDLER(tss_handler, T_TSS) #10
TRAPHANDLER(segnp_handler, T_SEGNP) #11
TRAPHANDLER(stack_handler, T_STACK) #12
TRAPHANDLER(gpflt_handler, T_GPFLT) #13
TRAPHANDLER(pgflt_handler, T_PGFLT) #14
TRAPHANDLER_NOEC(fperr_handler, T_FPERR) #16
TRAPHANDLER(align_handler, T_ALIGN) #17
TRAPHANDLER_NOEC(mchk_handler, T_MCHK) #18
TRAPHANDLER_NOEC(simderr_handler, T_SIMDERR) #19

TRAPHANDLER_NOEC(irq0_handler, IRQ_OFFSET)
TRAPHANDLER_NOEC(irq1_handler, IRQ_OFFSET+1)
TRAPHANDLER_NOEC(irq2_handler, IRQ_OFFSET+2)
TRAPHANDLER_NOEC(irq3_handler, IRQ_OFFSET+3)
TRAPHANDLER_NOEC(irq4_handler, IRQ_OFFSET+4)
TRAPHANDLER_NOEC(irq5_handler, IRQ_OFFSET+5)
TRAPHANDLER_NOEC(irq6_handler, IRQ_OFFSET+6)
TRAPHANDLER_NOEC(irq7_handler, IRQ_OFFSET+7)
TRAPHANDLER_NOEC(irq8_handler, IRQ_OFFSET+8)
TRAPHANDLER_NOEC(irq9_handler, IRQ_OFFSET+9)
TRAPHANDLER_NOEC(irq10_handler, IRQ_OFFSET+10)
TRAPHANDLER_NOEC(irq11_handler, IRQ_OFFSET+11)
TRAPHANDLER_NOEC(irq12_handler, IRQ_OFFSET+12)
TRAPHANDLER_NOEC(irq13_handler, IRQ_OFFSET+13)
TRAPHANDLER_NOEC(irq14_handler, IRQ_OFFSET+14)
TRAPHANDLER_NOEC(irq15_handler, IRQ_OFFSET+15)


TRAPHANDLER_NOEC(syscall_handler, T_SYSCALL)


/* My comments
    This is the IDT[no] handler.

	When an exception is caused by userland the control comes here from IDT[exp_no]. We are already
	pointing to kernel stack(hopefully). If not then point to it. Now push
	old esp,ss,eip,flags, cs,error code if any. Now you need to jump to trap. As we have now setup the kernel stack
	with this values so trap() has argument trapframe (normal buiding of stack while calling a function)
	Should there be (iret)?? in the end??

	Main doubt how transfer from usermode to kernel mode is done. How kernel gets the control?
	How divide by zero leads control to IDT[0]??
*/
/*
 * Lab 3: Your code here for _alltraps
 */

 _alltraps:
 	push %ds
 	push %es
 	pushal   #reference to struct PushRegs in trap.h
 	mov $GD_KD, %eax
 	mov %eax, %ds
 	mov %eax, %es
 	pushl %esp
 	call trap
