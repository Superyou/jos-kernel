/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_TRAP_H
#define JOS_KERN_TRAP_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#include <inc/trap.h>
#include <inc/mmu.h>

/* The kernel's interrupt descriptor table */
extern struct Gatedesc idt[];
extern struct Pseudodesc idt_pd;

void trap_init(void);
void trap_init_percpu(void);
void print_regs(struct PushRegs *regs);
void print_trapframe(struct Trapframe *tf);
void page_fault_handler(struct Trapframe *);
void backtrace(struct Trapframe *);

extern void parent_func(int);
extern void divide_handler();
extern void debug_handler();
extern void nmi_handler();
extern void bkpt_handler();
extern void oflow_handler();
extern void bound_handler();
extern void illop_handler();
extern void device_handler();
extern void dblflt_handler();
extern void tss_handler();
extern void segnp_handler();
extern void stack_handler();
extern void gpflt_handler();
extern void pgflt_handler();
extern void fperr_handler();
extern void align_handler();
extern void mchk_handler();
extern void simderr_handler();

extern void irq0_handler();
extern void irq1_handler();
extern void irq2_handler();
extern void irq3_handler();
extern void irq4_handler();
extern void irq5_handler();
extern void irq6_handler();
extern void irq7_handler();
extern void irq8_handler();
extern void irq9_handler();
extern void irq10_handler();
extern void irq11_handler();
extern void irq12_handler();
extern void irq13_handler();
extern void irq14_handler();
extern void irq15_handler();

extern void syscall_handler();
extern void push_fault_frame();
extern void kern_monitor(struct Trapframe *);

#endif /* JOS_KERN_TRAP_H */
