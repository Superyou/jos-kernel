#include "ns.h"
#include <inc/mmu.h>

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	int ret;
	binaryname = "ns_input";
	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
	while(1)
	{
		sys_page_alloc(0, &nsipcbuf, PTE_W|PTE_U|PTE_P);

		while((ret = sys_rx_packet(&nsipcbuf.pkt.jp_data, &nsipcbuf.pkt.jp_len)) < 0)
			sys_yield();


		//cprintf("\ndata:%s",nsipcbuf.pkt.jp_data);
		while((sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U)) < 0);	
	}


	
	
}
