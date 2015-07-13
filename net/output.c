#include "ns.h"

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	int32_t reqno;
	uint32_t whom;
	int i, perm;
	void *va;
	int ret;
	binaryname = "ns_output";

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
	while(1)
	{
		reqno = ipc_recv((int32_t *) &whom, (void *)&nsipcbuf, &perm);
		while(1)
		{

			if((reqno == NSREQ_OUTPUT) && (whom == ns_envid))
			{
				//cprintf("\nreceived packet from ns server\n");
				//cprintf("\nlength of packet:%d\n",nsipcbuf.pkt.jp_len);
				//cprintf("\ndata:");
				ret = sys_tx_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
				if(ret == E_TX_DESC_SUCCESS)
					break;
				else if(ret == -E_TX_DESC_FAILURE)
				{
					sys_yield();
				}
				else
					panic("\nError while sending transmittong packet\n");	
			}
		}

	}
}
