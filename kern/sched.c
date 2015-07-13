#include <inc/assert.h>
#include <inc/x86.h>
#include <kern/spinlock.h>
#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>

void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
	struct Env *idle;
	int i, stop;
	// Implement simple round-robin scheduling.
	//
	// Search through 'envs' for an ENV_RUNNABLE environment in
	// circular fashion starting just after the env this CPU was
	// last running.  Switch to the first such environment found.
	//
	// If no envs are runnable, but the environment previously
	// running on this CPU is still ENV_RUNNING, it's okay to
	// choose that environment.
	//
	// Never choose an environment that's currently running on
	// another CPU (env_status == ENV_RUNNING). If there are
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.

	// LAB 4: Your code here.

	//cprintf("this cpu-id:%d",thiscpu->cpu_id);
	//cprintf("addr of env running on this cpu:%x",thiscpu->cpu_env);
	
	//if previously running any environments then still that env(here idle) will be in running state
	//previously running state env is set to runnable in env_run() when cpu finds new env
	//cprintf("\nentered sched_yield: curenv\n");
	idle = thiscpu->cpu_env;
	if(idle==NULL)
	{
		//cprintf("\nidle\n");
		for(i=0;i<NENV;i++)
		{
			if(envs[i].env_status == ENV_RUNNABLE)
			{
				env_run(&envs[i]);
				//env_run sets curenv i.e thiscpu->cpu_env 
			}
		}
	}
	else
	{
		//cprintf("\nnot idle");
		i = (curenv - envs) + 1;
		stop = (curenv - envs);
		//cprintf("\ncurenv:%p stop:%d\n",curenv, stop);
		while(i!=stop)
		{
			
			if(envs[i].env_status == ENV_RUNNABLE)
			{
				//cprintf("\nnew curenv:%p id:%x",&envs[i], (&envs[i])->env_id);
				env_run(&envs[i]);
				//env_run sets curenv i.e thiscpu->cpu_env 
			}
			i++;
			i = i % NENV;
			//cprintf("\nblocked in loop:%d",i);
		}
		//if control reaches here that means curenv is the only running environment
		//cprintf("running current env");
		if(curenv->env_status == ENV_RUNNABLE || curenv->env_status == ENV_RUNNING)
			env_run(curenv);
	}
	// sched_halt never returns
	sched_halt();
}

// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
		while (1)
			monitor(NULL);
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
	lcr3(PADDR(kern_pgdir));

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
		"movl $0, %%ebp\n"
		"movl %0, %%esp\n"
		"pushl $0\n"
		"pushl $0\n"
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
}

