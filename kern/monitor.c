// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display backtrace of stack", mon_backtrace },
	{ "showmappings", "Display physical page mappings", mon_showmap},
	{ "chperm", "Change the permission of corresponding PTE", mon_chperm},
	{ "dumpmem", "Dump the contents of a range of memory", mon_dump},
	{ "break", "enable single step break", mon_break},
	{ "step", "step to next instruction", mon_step},
	{ "continue", "continue to next breakpoint", mon_continue},
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int mon_break(int argc, char **argv, struct Trapframe *tf)
{
	tf->tf_eflags = tf->tf_eflags | SET_TF;
	return 0;
}

int mon_step(int argc, char **argv, struct Trapframe *tf)
{
	//tf->tf_eflags = tf->tf_eflags | SET_TF;
	return -1;
}

int mon_continue(int argc, char **argv, struct Trapframe *tf)
{
	tf->tf_eflags = tf->tf_eflags & !(SET_TF);
	return -1;
}

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_chperm(int argc, char **argv, struct Trapframe *tf)
{
	const void *vaddr;
	int perm, len;
	if(argc!=3){
		cprintf("\nformat expected: chperm [vaddr] [perm]\n");
		return 0;
	}
	len = strlen(argv[1]);
	vaddr = (const void *)strtol(argv[1], ((argv+1)+len), 16);
	len = strlen(argv[2]);
	perm = strtol(argv[2], ((argv+2)+len), 0);
	change_perm(vaddr, perm);
	return 0;
}

int
mon_dump(int argc, char **argv, struct Trapframe *tf)
{
	int len=0;
	const void *vaStart;
	const void *vaEnd;
	if(argc!=3){
		cprintf("\nshowmappings only accepts single address range\n");
		return 0;
	}
	
	//cprintf("strol:%lu\n",strtol(argv[1], ((argv+1)+len), 16));
	//cprintf("strol:%lu\n",strtol(argv[2], ((argv+2)+len), 16));
	len = strlen(argv[1]);
	vaStart = (const void *)strtol(argv[1], ((argv+1)+len), 16);
	len = strlen(argv[2]);
	vaEnd = (const void *)strtol(argv[2], ((argv+2)+len), 16);
	print_memval(vaStart, vaEnd);
	return 0;
}


int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

int
mon_showmap(int argc, char **argv, struct Trapframe *tf)
{
	int len=0;
	const void *vaStart;
	const void *vaEnd;
	if(argc!=3){
		cprintf("\nshowmappings only accepts single address range\n");
		return 0;
	}
	
	//cprintf("strol:%lu\n",strtol(argv[1], ((argv+1)+len), 16));
	//cprintf("strol:%lu\n",strtol(argv[2], ((argv+2)+len), 16));
	len = strlen(argv[1]);
	vaStart = (const void *)strtol(argv[1], ((argv+1)+len), 16);
	len = strlen(argv[2]);
	vaEnd = (const void *)strtol(argv[2], ((argv+2)+len), 16);
	print_mapping(vaStart, vaEnd);

	return 0;
}

void *geteip(void)
{
	void *ebp = (void *)read_ebp();
	cprintf("geteip:ebp:%x\n\n",(uint32_t)ebp);
	return (void *)*((uint32_t *)ebp+1);
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	
	struct Eipdebuginfo info;
	void *ebp = (void *)read_ebp();
	int i=0;
	int j=0;
	int inc=0;
	const char *p = NULL;
	cprintf("Stack backtrace:\n");
	while(ebp!=NULL)
	{
		debuginfo_eip(*((uint32_t *)ebp+1), &info);
		cprintf("\n");
		cprintf("ebp %x eip %x ",(uint32_t)ebp, (uint32_t)*((uint32_t *)ebp+1));
		cprintf("args");
		//(info.eip_fn_narg+1-j))
		for(j=1;j<=5;j++)
		{
			inc = (j+1);
			cprintf(" %08x",*((uint32_t *)ebp+inc));
		}
		cprintf("\n         %s:%d:  ",info.eip_file, info.eip_line);
		p = info.eip_fn_name;
		for(i=0;i<info.eip_fn_namelen;i++,p++)
			cprintf("%c",*p);
		cprintf("+%d", (uint32_t)*((uint32_t *)ebp+1)-info.eip_fn_addr);
		ebp = (void *)*(uint32_t *)ebp;
	}
	cprintf("\n");
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
