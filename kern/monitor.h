#ifndef JOS_KERN_MONITOR_H
#define JOS_KERN_MONITOR_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

struct Trapframe;

// Activate the kernel monitor,
// optionally providing a trap frame indicating the current state
// (NULL if none).
void monitor(struct Trapframe *tf);

// Functions implementing monitor commands.

extern int mon_help(int argc, char **argv, struct Trapframe *tf);
extern int mon_kerninfo(int argc, char **argv, struct Trapframe *tf);
extern int mon_backtrace(int argc, char **argv, struct Trapframe *tf);
extern int mon_showmap(int argc, char **argv, struct Trapframe *tf);
extern void print_mapping(const void *vaStart, const void *vaEnd);
extern void change_perm(const void *vaddr, int perm);
extern int mon_chperm(int argc, char **argv, struct Trapframe *tf);
extern int mon_dump(int argc, char **argv, struct Trapframe *tf);
extern void print_memval(const void *vaStart, const void *vaEnd);
extern int mon_break(int argc, char **argv, struct Trapframe *tf);
extern int mon_continue(int argc, char **argv, struct Trapframe *tf);
extern int mon_step(int argc, char **argv, struct Trapframe *tf);


#endif	// !JOS_KERN_MONITOR_H
