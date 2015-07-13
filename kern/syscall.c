/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/ns.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/syscall.h>
#include <kern/console.h>
#include <kern/sched.h>
#include <kern/time.h>
#include <kern/e1000.h>

// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.

static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.

	user_mem_assert(curenv, s, len, PTE_P|PTE_U);

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
}

// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
}

static int
sys_env_cleanup(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;
	assert(curenv==e);
	
	cprintf("[%08x] cleaning %08x\n", curenv->env_id, e->env_id);
	env_cleanup(e);
	env_init_trapframe(e);
	return 0;
}

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;
	if (e == curenv)
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
	env_destroy(e);
	return 0;
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.

	//panic("sys_exofork not implemented");
	struct Env *newEnv = NULL;
	//cprintf("\nsysexofork\n");
	int status = env_alloc(&newEnv, curenv->env_id);
	if(status<0)
	{
		//error occurred while allocating new environment
		return status;
	}
	else if(newEnv && (status>=0))
	{
		//successfully allocated newEnvironment
		newEnv->env_status = ENV_NOT_RUNNABLE;
		newEnv->env_tf = curenv->env_tf;
		newEnv->env_tf.tf_regs.reg_eax = 0;
	}
	//what do tweak mean as so sys_exofork will appear to return 0
	//return address of syscall is stored in env->env_tf.eax. So set newEnv->env_tf.eax=0 for 
	return newEnv->env_id;
}

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	//panic("sys_env_set_status not implemented");
	struct Env *newEnv = NULL;
	int error=0;
	if(status==ENV_NOT_RUNNABLE || status==ENV_RUNNABLE)
	{
		error = envid2env(envid, &newEnv, 1);
		if((!error) && newEnv)
		{
			newEnv->env_status = status;
			return 0;
		}
		return error;

	}
	return -E_INVAL;
}

// Set envid's trap frame to 'tf'.
// tf is modified to make sure that user environments always run at code
// protection level 3 (CPL 3) with interrupts enabled.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	//panic("sys_env_set_trapframe not implemented");
	struct Env *newEnv = NULL;
	int error= -E_BAD_ENV;
	error = envid2env(envid, &newEnv, 1);
	if((!error) && newEnv)
	{
		newEnv->env_tf = *tf;
		newEnv->env_tf.tf_eflags |= FL_IF;
		return 0;
	}
	return error;
}

// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	//panic("sys_env_set_pgfault_upcall not implemented");
	struct Env *newEnv = NULL;
	int error=-1;
	error = envid2env(envid, &newEnv, 1);
	if((!error) && newEnv)
	{
		newEnv->env_pgfault_upcall = func;
		return 0;
	}
		
	return error;
}

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_SYSCALL in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
	//panic("sys_page_alloc not implemented");
	struct Env *newEnv = NULL;
	struct PageInfo *newPage = NULL;
	int allowed_perm = PTE_U | PTE_P | PTE_AVAIL | PTE_W;
	int status=0, error=0;
	//cprintf("\npage alloc permissions:%d", perm);
	//cprintf("\nPA:va:%p",(char *)va);
	if(((~allowed_perm) & perm)!=0)
		return -E_INVAL;
	if(((uint32_t)va >= UTOP) || ((uint32_t)va % PGSIZE))
		return -E_INVAL;
	error = envid2env(envid, &newEnv, 1);
	if((!error) && newEnv)
	{
		newPage = page_alloc(ALLOC_ZERO);
		//cprintf("\nnewPage in page alloc:%p",newPage);
		if(!newPage)
			return -E_NO_MEM;
		//no need to increment reference of the newPage as insert increments it for us.
		error = page_insert(newEnv->env_pgdir, newPage, va, perm);
		if(error)
		{
			page_free(newPage);
			return error;
		}
		return 0;
	}
	return error;
}

// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.

	//panic("sys_page_map not implemented");
	//PTE_SYSCALL
	int allowed_perm = PTE_U | PTE_P | PTE_AVAIL | PTE_W;
	int status=0, srcErr=0, dstErr=0, error=0;
	struct PageInfo *reqPage = NULL;
	struct Env *srcEnv = NULL;
	struct Env *dstEnv = NULL;
	pte_t *entry;
	int isWritable = 0;
	if(((~allowed_perm) & perm)!=0){
		cprintf("\npermission mismatch\n");
		return -E_INVAL;
	}
	if(((uint32_t)srcva >= UTOP) || ((uint32_t)srcva % PGSIZE)){
		cprintf("\nsrcva voilated\n");
		return -E_INVAL;
	}
	if(((uint32_t)dstva >= UTOP) || ((uint32_t)dstva % PGSIZE)){
		cprintf("\ndstva violated\n");
		return -E_INVAL;
	}
	//cprintf("\nSysmap problem: source ENV:%d\n",srcenvid);
	srcErr = envid2env(srcenvid, &srcEnv, 1);
	//Doubt - Can nly parent or sibling is allowed to touch dst env dir
	// or all are allowed? I am assuming that src and dst should have common ancester
	//cprintf("\nSysmap problem: destination ENV:%d\n",dstenvid);
	dstErr = envid2env(dstenvid, &dstEnv, 1);
	//cprintf("\nsrcerror:%d dsterror:%d srcEnv:%p dstEnv:%p\n",srcErr, dstErr, srcEnv, dstEnv);
	if(((!srcErr) && srcEnv) && ((!dstErr) && dstEnv))
	{
		reqPage = page_lookup(srcEnv->env_pgdir, srcva, &entry);
		//cprintf("\nmap:reqPage:%p\n",reqPage);
		//srcva not mapped in src_env_pgdir
		if(!reqPage){
			//cprintf("\n no source mapping");
			return -E_INVAL;
		}
		//cprintf("entry:%p\n",*entry);
		isWritable = *entry & PTE_W;
		if(!isWritable)
		{
			if(perm & PTE_W){
				//cprintf("\n writing to readable page\n");
				return -E_INVAL;
			}
		}
		//mapping the page to dst environment
		error = page_insert(dstEnv->env_pgdir, reqPage, dstva, perm);
		return error;
	}
	return -E_BAD_ENV;
}

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	//panic("sys_page_unmap not implemented");
	int error=0;
	struct Env *newEnv = NULL;

	error = envid2env(envid, &newEnv, 1);
	if(error)
		return error;
	if(((uint32_t)va >= UTOP) || ((uint32_t)va % PGSIZE))
		return -E_INVAL;
	page_remove(newEnv->env_pgdir, va);

	return 0;
}

// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target is not blocked, waiting for an IPC.
//
// The send also can fail for the other reasons listed below.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused sys_ipc_recv system call.  (Hint: does the
// sys_ipc_recv function ever actually return?)
//
// If the sender wants to send a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success, < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.
	//panic("sys_ipc_try_send not implemented");
	//cprintf("\nsend syscall.c\n");
	int error=0, page_status=-1;
	struct Env *newEnv = NULL;
	struct PageInfo *reqPage = NULL;
	pte_t *entry;
	int isWritable = 0;
	int allowed_perm = PTE_U | PTE_P | PTE_AVAIL | PTE_W;
	int set_perm=0;
	error = envid2env(envid, &newEnv, 0);
	//cprintf("\nnewEnv:%p",newEnv);
	
	//error checking and all stuff
	//1. checking if dst envid is genuine
	//cprintf("\nchk1 pass\n");
	if(error || (newEnv==NULL)){
		cprintf("\nenvid error\n");
		return error;
	}
	//2. checking if receive env is waiting or not
	//cprintf("\nreceiving state:%d",newEnv->env_ipc_recving);

	if(!newEnv->env_ipc_recving){
		//cprintf("\nrecv not ready\n");
		return -E_IPC_NOT_RECV;
	}
	//cprintf("\nchk2 pass\n");
	//3. checking alignment of srcva if valid
	if((uintptr_t)srcva < UTOP)
	{
		//cprintf("\nsrcva less than UTOP\n");
		if((uintptr_t)srcva % PGSIZE)
			return -E_INVAL;	
	}
	//cprintf("\nchk3 pass\n");
	//4. permission check and 5. mapping existence and 6. will be checked in sys_map funtion itself.
	if(((uint32_t)srcva < UTOP) && ((uint32_t)newEnv->env_ipc_dstva < UTOP))
	{
		//cprintf("\nmapping pages\n");
		//checking permissions
		if(((~allowed_perm) & perm)!=0){
		//cprintf("\npermission mismatch\n");
		return -E_INVAL;
		}
		reqPage = page_lookup(curenv->env_pgdir, srcva, &entry);
		//cprintf("\nmap:reqPage:%p",reqPage);
		//srcva not mapped in src_env_pgdir
		if(!reqPage){
			cprintf("\n no source mapping\n");
			return -E_INVAL;
		}
		//cprintf("entry:%p",*entry);
		isWritable = *entry & PTE_W;
		if(!isWritable)
		{
			if(perm & PTE_W){
				cprintf("\n writing to readable page\n");
				return -E_INVAL;
			}
		}
		//mapping the page to dst environment
		page_status = page_insert(newEnv->env_pgdir, reqPage, newEnv->env_ipc_dstva, perm);
		if(!page_status)
		{
			set_perm = perm;
		}
		else
			return page_status;
	}

	

	//if control reaches here then we can assume that send operation is successful.
	//Main IPC transfer
	//1. Mapping the page if dstva and srcva are valid
	//cprintf("\nsetting the send output\n");
	newEnv->env_ipc_recving = 0;
	newEnv->env_ipc_from = curenv->env_id;
	newEnv->env_ipc_value = value;
	newEnv->env_ipc_perm = set_perm;
	newEnv->env_status = ENV_RUNNABLE;
	//cprintf("\nsent the data. Receiver should receive\n");
	return 0;
}

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.

	//panic("sys_ipc_recv not implemented");
	
	if((uintptr_t)dstva < UTOP)
	{
		if((uintptr_t)dstva % PGSIZE)
			return -E_INVAL;	
	}
	curenv->env_ipc_recving = 1;
	curenv->env_ipc_dstva = dstva;
	curenv->env_status = ENV_NOT_RUNNABLE;
	curenv->env_tf.tf_regs.reg_eax = 0;
	sys_yield();
	//cprintf("\n returning from sys recv\n");
	return 0;
}

static int
sys_share_pages(envid_t dstid)
{
	int error=0;
	int i=0;
	struct Env *dstEnv = NULL;
	error = envid2env(dstid, &dstEnv, 1);
	if(error || (dstEnv==NULL))
		return error;
	//now copy complete source pgdir from USTACKTOP-1 to 0 into dest pgdir
	memcpy(dstEnv->env_pgdir, curenv->env_pgdir, (sizeof(pde_t) * (PDX(USTACKTOP) -1)));
	//cprintf("\nsource pgdir:\n");
	/*for(i=900;i<961;i++)
	{
		cprintf("\n%d: %d<--->%d",i,curenv->env_pgdir[i], dstEnv->env_pgdir[i]);
	}*/
	return 0;
}
// Return the current time.
static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	return time_msec();
}

static int sys_tx_packet(const char *data, size_t len)
{
	user_mem_assert(curenv, data, len, PTE_P|PTE_U);

	// Print the string supplied by the user.
	return tx_packet(data, len);
}

static int sys_rx_packet(void *buf, int *len)
{
	//user_mem_assert(curenv, data, len, PTE_P|PTE_U);

	return rx_packet(buf, len);
}

static int sys_read_mac(uint8_t *data)
{
	return get_mac(data);
}


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	//panic("syscall not implemented");
	//cprintf("\nsyscall no:%d",syscallno);
	int ret = -1;

	switch (syscallno) {
		case SYS_cputs:
			sys_cputs((char *)a1, a2);
			return 0;
		case SYS_cgetc:
			return sys_cgetc();
		case SYS_getenvid:
			a5 = sys_getenvid();
			//cprintf("envid=%d",a5);
			return sys_getenvid();
		case SYS_env_destroy:
			return sys_env_destroy(a1);
		case SYS_env_cleanup:
			return sys_env_cleanup(a1);
		case NSYSCALLS:
			return 0;
		case SYS_yield:
			sys_yield(); 
			return 0;
		case SYS_exofork:
			return sys_exofork();
		case SYS_env_set_status:
			return sys_env_set_status(a1, a2);
		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall(a1, (void *)a2);
		case SYS_page_alloc:
			return sys_page_alloc(a1, (void *)a2, a3);
		case SYS_page_map:
			return sys_page_map(a1, (void *)a2, a3, (void *)a4, a5);
		case SYS_page_unmap:
			return sys_page_unmap(a1, (void *)a2);
		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1, a2, (void *)a3, a4);
		case SYS_ipc_recv:
			return sys_ipc_recv((void *)a1);
		case SYS_share_pages:
			return sys_share_pages(a1);
		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
		case SYS_time_msec:
			return sys_time_msec();
		case SYS_tx_packet:
			return sys_tx_packet((char *)a1, a2);
		case SYS_rx_packet:
			return sys_rx_packet((void *)a1, (int *)a2);
		case SYS_read_mac:
			return sys_read_mac((uint8_t *)a1);
		default:
			return -E_INVAL;
	}
}

