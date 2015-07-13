#include <kern/e1000.h>
#include <kern/pmap.h>
#include <inc/x86.h>
#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/error.h>
#include <inc/ns.h>

__attribute__((__aligned__(16))) struct e1000_tx_desc tx_desc[E1000_TXD_TOTAL];
__attribute__((__aligned__(16))) struct e1000_rx_desc rx_desc[E1000_TXD_TOTAL];


// LAB 6: your driver code here
volatile uint32_t *nw_mmio = NULL;
char txd_buffer[E1000_TXD_TOTAL][E1000_TXD_BUFFER_SIZE];
char rxd_buffer[E1000_RXD_TOTAL][E1000_RXD_BUFFER_SIZE];

void nw_init()
{
	//initializing the transmit descriptor. Already memory allocated for 
	//transmit descriptor array and associated packet buffer in mem_init()
	uint8_t data[6];
	txd_init();
	rcv_init();
	get_mac(data);
}

int get_mac(uint8_t *data)
{
	uint16_t mac[3];
	int i=0;
	
	for(i=0;i<3;i++)
	{
		nw_mmio[E1000_EERD/sizeof(uint32_t)] = 0;
		nw_mmio[E1000_EERD/sizeof(uint32_t)] |= (i<<E1000_EEPROM_RW_ADDR_SHIFT);
		nw_mmio[E1000_EERD/sizeof(uint32_t)] |= E1000_EEPROM_RW_REG_START;
		while(!(nw_mmio[E1000_EERD/sizeof(uint32_t)] & (1<<4)));
		//cprintf("\nmac:%x",nw_mmio[E1000_EERD/sizeof(uint32_t)]);
		mac[i] = nw_mmio[E1000_EERD/sizeof(uint32_t)]>>16;
		cprintf("\nmac-i:%d : %x",i,(mac[i]&0xff00)>>8);
		data[(2*i)+1] = ((mac[i]&0xff00)>>8);
		data[(2*i)] = mac[i] & 0xff;
	}
	return 0;
}

static void
hexdump(const char *prefix, const void *data, int len)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
		if (i % 16 == 15 || i == len - 1)
			cprintf("%.*s\n", out - buf, buf);
		if (i % 2 == 1)
			*(out++) = ' ';
		if (i % 16 == 7)
			*(out++) = ' ';
	}
}


static void txd_init()
{
	
	//1. set TDBAL to assigned descriptor array memory
	//address should be 16 byte aligned
	int i=0;
	memset(tx_desc, 0, sizeof(struct e1000_tx_desc)*E1000_TXD_TOTAL);
	for(i=0;i<E1000_TXD_TOTAL;i++)
	{
		memset(&txd_buffer[i], 0, E1000_TXD_BUFFER_SIZE);
	}

	nw_mmio[E1000_TDBAL/sizeof(uint32_t)] = PADDR(tx_desc);
	nw_mmio[E1000_TDBAH/sizeof(uint32_t)] = 0;
	// what do you mean by register should be 128 byte aligned
	//2. set TDLEN to size of descriptor ring. should be multiple of 128
	//TDLEN ignores first 7 bits
	nw_mmio[E1000_TDLEN/sizeof(uint32_t)] = (sizeof(struct e1000_tx_desc)*E1000_TXD_TOTAL)<<7;
	txd_setup();
	//3. initialize TDH/TDT to 0
	nw_mmio[E1000_TDH/sizeof(uint32_t)] = 0;
	nw_mmio[E1000_TDT/sizeof(uint32_t)] = 0;
	//4. set TCTL.EN bit = 1
	nw_mmio[E1000_TCTL/sizeof(uint32_t)] |= E1000_TCTL_EN;
	//5. set TCTL.PSP bit = 1
	nw_mmio[E1000_TCTL/sizeof(uint32_t)] |= E1000_TCTL_PSP;
	nw_mmio[E1000_TCTL/sizeof(uint32_t)] |= (E1000_TCTL_CT & (0x10<<4));
	//6. set TCTL.COLD = 0x40
	nw_mmio[E1000_TCTL/sizeof(uint32_t)] |= (E1000_TCTL_COLD & (0x40<<12));
	//7. set E1000_TIPG /* TX Inter-packet gap -RW */
	nw_mmio[E1000_TIPG/sizeof(uint32_t)] = 10|(8<<10)|(6<<20);

}

static void txd_setup()
{
	struct e1000_tx_desc *desc;
	int i;
	//1. initialize buffer address of tx_desc
	for(i=0;i<E1000_TXD_TOTAL;i++)
	{
		desc = &tx_desc[i];
		desc->buffer_addr=0;
		desc->buffer_addr = PADDR(&txd_buffer[i]);
		desc->lower.flags.cmd = (1<<3);
		desc->lower.flags.length = 0;
		desc->lower.flags.cso = 0;
		desc->upper.fields.status = 1;
		desc->upper.fields.css = 0;
	}

}

int tx_packet(const char *data, size_t len)
{
	//
	//. copy the data to buffer associated with tail descriptor
	int head_idx, tail_idx, desc_status;
	struct e1000_tx_desc *desc;
	head_idx = nw_mmio[E1000_TDH/sizeof(uint32_t)];
	tail_idx = nw_mmio[E1000_TDT/sizeof(uint32_t)];
	//cprintf("\nhead_idx:%d\n",head_idx);
	//cprintf("\ntail_idx:%d\n",tail_idx);
	//cprintf("\ntx_packet:%.*s\n", len, data);
	desc = &tx_desc[tail_idx];
	if(desc->upper.fields.status == 1)
	{
		//safe to reuse the buffer associated with tail descriptor
		memcpy(&txd_buffer[tail_idx], data, len);
		//set rs bit &in control. just for confirmation
		desc->lower.flags.cmd |= (1<<3 | 1);
		//set dd bit in status = 0
		desc->upper.fields.status = 0;
		//set the length of descriptor
		desc->lower.flags.length = (uint16_t)len;
		//updating TDT register
		nw_mmio[E1000_TDT/sizeof(uint32_t)] = (tail_idx+1) % E1000_TXD_TOTAL;
		return E_TX_DESC_SUCCESS;
	}
	return -E_TX_DESC_FAILURE;
}

static void rcv_init()
{
	int i=0;
	//1. setting the MAC address 52:54:00:12:34:36
	memset(rx_desc, 0, sizeof(struct e1000_rx_desc)*E1000_RXD_TOTAL);
	for(i=0;i<E1000_RXD_TOTAL;i++)
	{
		memset(&rxd_buffer[i], 0, E1000_RXD_BUFFER_SIZE);
	}
	nw_mmio[E1000_RAL/sizeof(uint32_t)] = LOW_MAC_ADDR;
	nw_mmio[E1000_RAH/sizeof(uint32_t)] = HIGH_MAC_ADDR;
	nw_mmio[E1000_RAH/sizeof(uint32_t)] |= 1<<31;
	//2. MTA to 0b
	//nw_mmio[(E1000_MTA/sizeof(uint32_t))+42] = 1<<3;

	//3. IMS registers pg. 297 - > RXT, RXO, RXDMT, RXSEQ, LSC

	//4. Allocate a region of memory for the receive descriptor list
	//address should be 16 byte aligned
	nw_mmio[E1000_RDBAL/sizeof(uint32_t)] = PADDR(rx_desc);
	nw_mmio[E1000_RDBAH/sizeof(uint32_t)] = 0;

	//5. Receive descriptor length
	nw_mmio[E1000_RDLEN/sizeof(uint32_t)] = ((sizeof(struct e1000_rx_desc)*E1000_RXD_TOTAL)<<7);
	
	//6. setting pointer to buffer in rx_descriptors
	rcv_setup();
	//7. setting head and tail.
	nw_mmio[E1000_RDH/sizeof(uint32_t)] = 0;
	nw_mmio[E1000_RDT/sizeof(uint32_t)] = 150;

	//8. Handling receive control register
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] = 0;
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] |= E1000_RCTL_EN;
	
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] |= E1000_RCTL_BAM;
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] |= E1000_RCTL_SECRC;

}

int rx_packet(void *rcv_buf, int *len)
{
	static int i=0;

	if(rx_desc[i].status & 1)
	{
		//cprintf("\nbuffer:%s\n",&rxd_buffer[j]);
		memmove(rcv_buf, &rxd_buffer[i],rx_desc[i].length);
		//hexdump("input: ", &rxd_buffer[i], rx_desc[i].length);
		*len = rx_desc[i].length;
		rx_desc[i].status = 0;
		i = (i+1)%E1000_RXD_TOTAL;
		//cprintf("returning 0");
		return 0;
	}
	return -1;
}



static void rcv_setup()
{
	struct e1000_rx_desc *desc;
	int i;
	//1. initialize buffer address of tx_desc
	for(i=0;i<E1000_RXD_TOTAL;i++)
	{
		desc = &rx_desc[i];
		desc->buffer_addr=0;
		desc->buffer_addr = PADDR(&rxd_buffer[i]);
		desc->length = 0;
		desc->csum = 0;
		desc->status = 0;
		desc->errors = 0;
		desc->special = 0;
	}

}
