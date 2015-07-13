// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800
extern void _pgfault_upcall(void);
//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);

	envid_t src_envid = sys_getenvid();



	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
	{
		if(src_envid <0)
			panic("\nenvironment value wrong:%e",src_envid);	
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
				panic("sys_page_alloc: %e", r);
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
			//Now mapping at old address

			/*
				sys_map_page will fetch the pte at PFTEMP which consist of the page number via page_lookup
				Then it will do page_insert at addr. Previously COW page(pte) at mapped at addr will be removed
				in page_insert(). So if another env points to that COW page then its page_ref will
				not become 0 but we will replace the pte for this environment to point at page pointed
				by PFTEMP. So the page ref for page pointed by PFTEMP will become 2. This is must because
				on other page fault we will again do mapping at pftemp which already has the mapping. There a
				are 2 steps in sys_page_alloc()
				   1. Simply allocate blank page
				   2. insert it at given address
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
				panic("sys_page_map: %e", r);
		}

	}
	else
		panic("\nviolation of page fault handler\n");
}

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);

}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
	{
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
		panic("sys_page_map: %e", r);
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
		panic("sys_page_map: %e", r);
	return 0;
}

static int s_duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
		panic("sys_page_map: %e", r);
	return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.

	//panic("fork not implemented");
	envid_t envid=-1;
	pte_t ptentry=0, ptable=0, page_num=0;
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
	if((envid=sys_exofork())<0)
		panic("\nCannot create a child process:%e\n",envid);
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
		}
		else
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
		panic("sys_page_alloc: %e", r);
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
		panic("pagefault upcall setup error: %e", r);
	sys_env_set_status(envid, ENV_RUNNABLE);
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;

}

// Challenge!
int
sfork(void)
{

	//panic("sfork not implemented");
	envid_t envid=-1;
	pte_t ptentry=0, ptable=0, page_num=0;
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
	if((envid=sys_exofork())<0)
		panic("\nCannot create a child process:%e\n",envid);
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
		}
		else
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
	/*addr = USTACKTOP-2*PGSIZE;
	if(uvpd[PDX(addr)] & PTE_P)
	{
		if(uvpt[PGNUM(addr)] & PTE_P)
		{
				//cprintf("\ncalling duppgae for address %x\n",addr);
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
		panic("sys_page_alloc: %e", r);

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
		panic("pagefault upcall setup error: %e", r);
	sys_env_set_status(envid, ENV_RUNNABLE);
	return envid;

}
