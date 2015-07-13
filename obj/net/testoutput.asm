
obj/net/testoutput:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 f4 02 00 00       	call   800325 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t ns_envid = sys_getenvid();
  80003b:	e8 e7 0e 00 00       	call   800f27 <sys_getenvid>
  800040:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  800042:	c7 05 00 40 80 00 20 	movl   $0x803020,0x804000
  800049:	30 80 00 

	output_envid = fork();
  80004c:	e8 2e 14 00 00       	call   80147f <fork>
  800051:	a3 00 50 80 00       	mov    %eax,0x805000
	if (output_envid < 0)
  800056:	85 c0                	test   %eax,%eax
  800058:	79 1c                	jns    800076 <umain+0x43>
		panic("error forking");
  80005a:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 39 30 80 00 	movl   $0x803039,(%esp)
  800071:	e8 10 03 00 00       	call   800386 <_panic>
	else if (output_envid == 0) {
  800076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80007b:	85 c0                	test   %eax,%eax
  80007d:	75 0d                	jne    80008c <umain+0x59>
		output(ns_envid);
  80007f:	89 34 24             	mov    %esi,(%esp)
  800082:	e8 19 02 00 00       	call   8002a0 <output>
		return;
  800087:	e9 c6 00 00 00       	jmp    800152 <umain+0x11f>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80008c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80009b:	0f 
  80009c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a3:	e8 bd 0e 00 00       	call   800f65 <sys_page_alloc>
  8000a8:	85 c0                	test   %eax,%eax
  8000aa:	79 20                	jns    8000cc <umain+0x99>
			panic("sys_page_alloc: %e", r);
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 4a 30 80 	movl   $0x80304a,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 39 30 80 00 	movl   $0x803039,(%esp)
  8000c7:	e8 ba 02 00 00       	call   800386 <_panic>
		pkt->jp_len = snprintf(pkt->jp_data,
  8000cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000d0:	c7 44 24 08 5d 30 80 	movl   $0x80305d,0x8(%esp)
  8000d7:	00 
  8000d8:	c7 44 24 04 fc 0f 00 	movl   $0xffc,0x4(%esp)
  8000df:	00 
  8000e0:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  8000e7:	e8 a9 09 00 00       	call   800a95 <snprintf>
  8000ec:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000f5:	c7 04 24 69 30 80 00 	movl   $0x803069,(%esp)
  8000fc:	e8 7e 03 00 00       	call   80047f <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800101:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800108:	00 
  800109:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800110:	0f 
  800111:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800118:	00 
  800119:	a1 00 50 80 00       	mov    0x805000,%eax
  80011e:	89 04 24             	mov    %eax,(%esp)
  800121:	e8 62 17 00 00       	call   801888 <ipc_send>
		sys_page_unmap(0, pkt);
  800126:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80012d:	0f 
  80012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800135:	e8 d2 0e 00 00       	call   80100c <sys_page_unmap>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80013a:	83 c3 01             	add    $0x1,%ebx
  80013d:	83 fb 0a             	cmp    $0xa,%ebx
  800140:	0f 85 46 ff ff ff    	jne    80008c <umain+0x59>
  800146:	b3 14                	mov    $0x14,%bl
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  800148:	e8 f9 0d 00 00       	call   800f46 <sys_yield>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  80014d:	83 eb 01             	sub    $0x1,%ebx
  800150:	75 f6                	jne    800148 <umain+0x115>
		sys_yield();
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	66 90                	xchg   %ax,%ax
  80015b:	66 90                	xchg   %ax,%ax
  80015d:	66 90                	xchg   %ax,%ax
  80015f:	90                   	nop

00800160 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	57                   	push   %edi
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	83 ec 2c             	sub    $0x2c,%esp
  800169:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80016c:	e8 7c 10 00 00       	call   8011ed <sys_time_msec>
  800171:	03 45 0c             	add    0xc(%ebp),%eax
  800174:	89 c6                	mov    %eax,%esi

	binaryname = "ns_timer";
  800176:	c7 05 00 40 80 00 81 	movl   $0x803081,0x804000
  80017d:	30 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800180:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800183:	eb 05                	jmp    80018a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800185:	e8 bc 0d 00 00       	call   800f46 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80018a:	e8 5e 10 00 00       	call   8011ed <sys_time_msec>
  80018f:	39 c6                	cmp    %eax,%esi
  800191:	76 06                	jbe    800199 <timer+0x39>
  800193:	85 c0                	test   %eax,%eax
  800195:	79 ee                	jns    800185 <timer+0x25>
  800197:	eb 09                	jmp    8001a2 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	90                   	nop
  80019c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8001a0:	79 20                	jns    8001c2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  8001a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a6:	c7 44 24 08 8a 30 80 	movl   $0x80308a,0x8(%esp)
  8001ad:	00 
  8001ae:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8001b5:	00 
  8001b6:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  8001bd:	e8 c4 01 00 00       	call   800386 <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8001c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001c9:	00 
  8001ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001d1:	00 
  8001d2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8001d9:	00 
  8001da:	89 1c 24             	mov    %ebx,(%esp)
  8001dd:	e8 a6 16 00 00       	call   801888 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8001e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001e9:	00 
  8001ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001f1:	00 
  8001f2:	89 3c 24             	mov    %edi,(%esp)
  8001f5:	e8 26 16 00 00       	call   801820 <ipc_recv>
  8001fa:	89 c6                	mov    %eax,%esi

			if (whom != ns_envid) {
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	39 c3                	cmp    %eax,%ebx
  800201:	74 12                	je     800215 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800203:	89 44 24 04          	mov    %eax,0x4(%esp)
  800207:	c7 04 24 a8 30 80 00 	movl   $0x8030a8,(%esp)
  80020e:	e8 6c 02 00 00       	call   80047f <cprintf>
  800213:	eb cd                	jmp    8001e2 <timer+0x82>
				continue;
			}

			stop = sys_time_msec() + to;
  800215:	e8 d3 0f 00 00       	call   8011ed <sys_time_msec>
  80021a:	01 c6                	add    %eax,%esi
  80021c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800220:	e9 65 ff ff ff       	jmp    80018a <timer+0x2a>

00800225 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	53                   	push   %ebx
  800229:	83 ec 14             	sub    $0x14,%esp
  80022c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int ret;
	binaryname = "ns_input";
  80022f:	c7 05 00 40 80 00 e3 	movl   $0x8030e3,0x804000
  800236:	30 80 00 
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
	while(1)
	{
		sys_page_alloc(0, &nsipcbuf, PTE_W|PTE_U|PTE_P);
  800239:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800240:	00 
  800241:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  800248:	00 
  800249:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800250:	e8 10 0d 00 00       	call   800f65 <sys_page_alloc>

		while((ret = sys_rx_packet(&nsipcbuf.pkt.jp_data, &nsipcbuf.pkt.jp_len)) < 0)
  800255:	eb 05                	jmp    80025c <input+0x37>
			sys_yield();
  800257:	e8 ea 0c 00 00       	call   800f46 <sys_yield>
	// another packet in to the same physical page.
	while(1)
	{
		sys_page_alloc(0, &nsipcbuf, PTE_W|PTE_U|PTE_P);

		while((ret = sys_rx_packet(&nsipcbuf.pkt.jp_data, &nsipcbuf.pkt.jp_len)) < 0)
  80025c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  800263:	00 
  800264:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80026b:	e8 bd 0f 00 00       	call   80122d <sys_rx_packet>
  800270:	85 c0                	test   %eax,%eax
  800272:	78 e3                	js     800257 <input+0x32>
			sys_yield();


		//cprintf("\ndata:%s",nsipcbuf.pkt.jp_data);
		while((sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U)) < 0);	
  800274:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80027b:	00 
  80027c:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  80028b:	00 
  80028c:	89 1c 24             	mov    %ebx,(%esp)
  80028f:	e8 e4 0e 00 00       	call   801178 <sys_ipc_try_send>
  800294:	85 c0                	test   %eax,%eax
  800296:	78 dc                	js     800274 <input+0x4f>
  800298:	eb 9f                	jmp    800239 <input+0x14>
  80029a:	66 90                	xchg   %ax,%ax
  80029c:	66 90                	xchg   %ax,%ax
  80029e:	66 90                	xchg   %ax,%ax

008002a0 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 2c             	sub    $0x2c,%esp
  8002a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int32_t reqno;
	uint32_t whom;
	int i, perm;
	void *va;
	int ret;
	binaryname = "ns_output";
  8002ac:	c7 05 00 40 80 00 ec 	movl   $0x8030ec,0x804000
  8002b3:	30 80 00 
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
	while(1)
	{
		reqno = ipc_recv((int32_t *) &whom, (void *)&nsipcbuf, &perm);
  8002b6:	8d 7d e0             	lea    -0x20(%ebp),%edi
  8002b9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8002bd:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8002c4:	00 
  8002c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8002c8:	89 04 24             	mov    %eax,(%esp)
  8002cb:	e8 50 15 00 00       	call   801820 <ipc_recv>
  8002d0:	89 c6                	mov    %eax,%esi
		while(1)
		{

			if((reqno == NSREQ_OUTPUT) && (whom == ns_envid))
  8002d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d5:	83 fe 0b             	cmp    $0xb,%esi
  8002d8:	75 49                	jne    800323 <output+0x83>
  8002da:	39 c3                	cmp    %eax,%ebx
  8002dc:	75 fc                	jne    8002da <output+0x3a>
			{
				//cprintf("\nreceived packet from ns server\n");
				//cprintf("\nlength of packet:%d\n",nsipcbuf.pkt.jp_len);
				//cprintf("\ndata:");
				ret = sys_tx_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  8002de:	a1 00 70 80 00       	mov    0x807000,%eax
  8002e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8002ee:	e8 19 0f 00 00       	call   80120c <sys_tx_packet>
				if(ret == E_TX_DESC_SUCCESS)
  8002f3:	83 f8 10             	cmp    $0x10,%eax
  8002f6:	74 c1                	je     8002b9 <output+0x19>
					break;
				else if(ret == -E_TX_DESC_FAILURE)
  8002f8:	83 f8 ef             	cmp    $0xffffffef,%eax
  8002fb:	75 0a                	jne    800307 <output+0x67>
				{
					sys_yield();
  8002fd:	8d 76 00             	lea    0x0(%esi),%esi
  800300:	e8 41 0c 00 00       	call   800f46 <sys_yield>
  800305:	eb cb                	jmp    8002d2 <output+0x32>
				}
				else
					panic("\nError while sending transmittong packet\n");	
  800307:	c7 44 24 08 04 31 80 	movl   $0x803104,0x8(%esp)
  80030e:	00 
  80030f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800316:	00 
  800317:	c7 04 24 f6 30 80 00 	movl   $0x8030f6,(%esp)
  80031e:	e8 63 00 00 00       	call   800386 <_panic>
  800323:	eb fe                	jmp    800323 <output+0x83>

00800325 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	56                   	push   %esi
  800329:	53                   	push   %ebx
  80032a:	83 ec 10             	sub    $0x10,%esp
  80032d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800330:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800333:	e8 ef 0b 00 00       	call   800f27 <sys_getenvid>
  800338:	25 ff 03 00 00       	and    $0x3ff,%eax
  80033d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800340:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800345:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80034a:	85 db                	test   %ebx,%ebx
  80034c:	7e 07                	jle    800355 <libmain+0x30>
		binaryname = argv[0];
  80034e:	8b 06                	mov    (%esi),%eax
  800350:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800355:	89 74 24 04          	mov    %esi,0x4(%esp)
  800359:	89 1c 24             	mov    %ebx,(%esp)
  80035c:	e8 d2 fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800361:	e8 07 00 00 00       	call   80036d <exit>
}
  800366:	83 c4 10             	add    $0x10,%esp
  800369:	5b                   	pop    %ebx
  80036a:	5e                   	pop    %esi
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800373:	e8 92 17 00 00       	call   801b0a <close_all>
	sys_env_destroy(0);
  800378:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80037f:	e8 ff 0a 00 00       	call   800e83 <sys_env_destroy>
}
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	56                   	push   %esi
  80038a:	53                   	push   %ebx
  80038b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80038e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800391:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800397:	e8 8b 0b 00 00       	call   800f27 <sys_getenvid>
  80039c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039f:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003aa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b2:	c7 04 24 38 31 80 00 	movl   $0x803138,(%esp)
  8003b9:	e8 c1 00 00 00       	call   80047f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c5:	89 04 24             	mov    %eax,(%esp)
  8003c8:	e8 51 00 00 00       	call   80041e <vcprintf>
	cprintf("\n");
  8003cd:	c7 04 24 6b 36 80 00 	movl   $0x80366b,(%esp)
  8003d4:	e8 a6 00 00 00       	call   80047f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003d9:	cc                   	int3   
  8003da:	eb fd                	jmp    8003d9 <_panic+0x53>

008003dc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	53                   	push   %ebx
  8003e0:	83 ec 14             	sub    $0x14,%esp
  8003e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003e6:	8b 13                	mov    (%ebx),%edx
  8003e8:	8d 42 01             	lea    0x1(%edx),%eax
  8003eb:	89 03                	mov    %eax,(%ebx)
  8003ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003f4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f9:	75 19                	jne    800414 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003fb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800402:	00 
  800403:	8d 43 08             	lea    0x8(%ebx),%eax
  800406:	89 04 24             	mov    %eax,(%esp)
  800409:	e8 38 0a 00 00       	call   800e46 <sys_cputs>
		b->idx = 0;
  80040e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800414:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800418:	83 c4 14             	add    $0x14,%esp
  80041b:	5b                   	pop    %ebx
  80041c:	5d                   	pop    %ebp
  80041d:	c3                   	ret    

0080041e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800427:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80042e:	00 00 00 
	b.cnt = 0;
  800431:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800438:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80043b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	89 44 24 08          	mov    %eax,0x8(%esp)
  800449:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800453:	c7 04 24 dc 03 80 00 	movl   $0x8003dc,(%esp)
  80045a:	e8 75 01 00 00       	call   8005d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80045f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800465:	89 44 24 04          	mov    %eax,0x4(%esp)
  800469:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80046f:	89 04 24             	mov    %eax,(%esp)
  800472:	e8 cf 09 00 00       	call   800e46 <sys_cputs>

	return b.cnt;
}
  800477:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800485:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800488:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	89 04 24             	mov    %eax,(%esp)
  800492:	e8 87 ff ff ff       	call   80041e <vcprintf>
	va_end(ap);

	return cnt;
}
  800497:	c9                   	leave  
  800498:	c3                   	ret    
  800499:	66 90                	xchg   %ax,%ax
  80049b:	66 90                	xchg   %ax,%ax
  80049d:	66 90                	xchg   %ax,%ax
  80049f:	90                   	nop

008004a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	57                   	push   %edi
  8004a4:	56                   	push   %esi
  8004a5:	53                   	push   %ebx
  8004a6:	83 ec 3c             	sub    $0x3c,%esp
  8004a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ac:	89 d7                	mov    %edx,%edi
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	89 c3                	mov    %eax,%ebx
  8004b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004cd:	39 d9                	cmp    %ebx,%ecx
  8004cf:	72 05                	jb     8004d6 <printnum+0x36>
  8004d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d4:	77 69                	ja     80053f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004dd:	83 ee 01             	sub    $0x1,%esi
  8004e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004f0:	89 c3                	mov    %eax,%ebx
  8004f2:	89 d6                	mov    %edx,%esi
  8004f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 6c 28 00 00       	call   802d80 <__udivdi3>
  800514:	89 d9                	mov    %ebx,%ecx
  800516:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80051a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	89 54 24 04          	mov    %edx,0x4(%esp)
  800525:	89 fa                	mov    %edi,%edx
  800527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052a:	e8 71 ff ff ff       	call   8004a0 <printnum>
  80052f:	eb 1b                	jmp    80054c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800531:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800535:	8b 45 18             	mov    0x18(%ebp),%eax
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	ff d3                	call   *%ebx
  80053d:	eb 03                	jmp    800542 <printnum+0xa2>
  80053f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800542:	83 ee 01             	sub    $0x1,%esi
  800545:	85 f6                	test   %esi,%esi
  800547:	7f e8                	jg     800531 <printnum+0x91>
  800549:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800550:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800554:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800557:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80055e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800565:	89 04 24             	mov    %eax,(%esp)
  800568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056f:	e8 3c 29 00 00       	call   802eb0 <__umoddi3>
  800574:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800578:	0f be 80 5b 31 80 00 	movsbl 0x80315b(%eax),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800585:	ff d0                	call   *%eax
}
  800587:	83 c4 3c             	add    $0x3c,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5e                   	pop    %esi
  80058c:	5f                   	pop    %edi
  80058d:	5d                   	pop    %ebp
  80058e:	c3                   	ret    

0080058f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800595:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	3b 50 04             	cmp    0x4(%eax),%edx
  80059e:	73 0a                	jae    8005aa <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005a3:	89 08                	mov    %ecx,(%eax)
  8005a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a8:	88 02                	mov    %al,(%edx)
}
  8005aa:	5d                   	pop    %ebp
  8005ab:	c3                   	ret    

008005ac <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005b2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	89 04 24             	mov    %eax,(%esp)
  8005cd:	e8 02 00 00 00       	call   8005d4 <vprintfmt>
	va_end(ap);
}
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	57                   	push   %edi
  8005d8:	56                   	push   %esi
  8005d9:	53                   	push   %ebx
  8005da:	83 ec 3c             	sub    $0x3c,%esp
  8005dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005e0:	eb 17                	jmp    8005f9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8005e2:	85 c0                	test   %eax,%eax
  8005e4:	0f 84 4b 04 00 00    	je     800a35 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8005ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f1:	89 04 24             	mov    %eax,(%esp)
  8005f4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8005f7:	89 fb                	mov    %edi,%ebx
  8005f9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8005fc:	0f b6 03             	movzbl (%ebx),%eax
  8005ff:	83 f8 25             	cmp    $0x25,%eax
  800602:	75 de                	jne    8005e2 <vprintfmt+0xe>
  800604:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800608:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80060f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800614:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80061b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800620:	eb 18                	jmp    80063a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800622:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800624:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800628:	eb 10                	jmp    80063a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80062c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800630:	eb 08                	jmp    80063a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800632:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800635:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80063d:	0f b6 17             	movzbl (%edi),%edx
  800640:	0f b6 c2             	movzbl %dl,%eax
  800643:	83 ea 23             	sub    $0x23,%edx
  800646:	80 fa 55             	cmp    $0x55,%dl
  800649:	0f 87 c2 03 00 00    	ja     800a11 <vprintfmt+0x43d>
  80064f:	0f b6 d2             	movzbl %dl,%edx
  800652:	ff 24 95 a0 32 80 00 	jmp    *0x8032a0(,%edx,4)
  800659:	89 df                	mov    %ebx,%edi
  80065b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800660:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800663:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800667:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80066a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80066d:	83 fa 09             	cmp    $0x9,%edx
  800670:	77 33                	ja     8006a5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800672:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800675:	eb e9                	jmp    800660 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 30                	mov    (%eax),%esi
  80067c:	8d 40 04             	lea    0x4(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800682:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800684:	eb 1f                	jmp    8006a5 <vprintfmt+0xd1>
  800686:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800689:	85 ff                	test   %edi,%edi
  80068b:	b8 00 00 00 00       	mov    $0x0,%eax
  800690:	0f 49 c7             	cmovns %edi,%eax
  800693:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800696:	89 df                	mov    %ebx,%edi
  800698:	eb a0                	jmp    80063a <vprintfmt+0x66>
  80069a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80069c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8006a3:	eb 95                	jmp    80063a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8006a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a9:	79 8f                	jns    80063a <vprintfmt+0x66>
  8006ab:	eb 85                	jmp    800632 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ad:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006b2:	eb 86                	jmp    80063a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 70 04             	lea    0x4(%eax),%esi
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 04 24             	mov    %eax,(%esp)
  8006c9:	ff 55 08             	call   *0x8(%ebp)
  8006cc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8006cf:	e9 25 ff ff ff       	jmp    8005f9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8d 70 04             	lea    0x4(%eax),%esi
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	99                   	cltd   
  8006dd:	31 d0                	xor    %edx,%eax
  8006df:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006e1:	83 f8 15             	cmp    $0x15,%eax
  8006e4:	7f 0b                	jg     8006f1 <vprintfmt+0x11d>
  8006e6:	8b 14 85 00 34 80 00 	mov    0x803400(,%eax,4),%edx
  8006ed:	85 d2                	test   %edx,%edx
  8006ef:	75 26                	jne    800717 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8006f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006f5:	c7 44 24 08 73 31 80 	movl   $0x803173,0x8(%esp)
  8006fc:	00 
  8006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800700:	89 44 24 04          	mov    %eax,0x4(%esp)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	89 04 24             	mov    %eax,(%esp)
  80070a:	e8 9d fe ff ff       	call   8005ac <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80070f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800712:	e9 e2 fe ff ff       	jmp    8005f9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800717:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80071b:	c7 44 24 08 3a 36 80 	movl   $0x80363a,0x8(%esp)
  800722:	00 
  800723:	8b 45 0c             	mov    0xc(%ebp),%eax
  800726:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	89 04 24             	mov    %eax,(%esp)
  800730:	e8 77 fe ff ff       	call   8005ac <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800735:	89 75 14             	mov    %esi,0x14(%ebp)
  800738:	e9 bc fe ff ff       	jmp    8005f9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800743:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800746:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80074a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80074c:	85 ff                	test   %edi,%edi
  80074e:	b8 6c 31 80 00       	mov    $0x80316c,%eax
  800753:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800756:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80075a:	0f 84 94 00 00 00    	je     8007f4 <vprintfmt+0x220>
  800760:	85 c9                	test   %ecx,%ecx
  800762:	0f 8e 94 00 00 00    	jle    8007fc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800768:	89 74 24 04          	mov    %esi,0x4(%esp)
  80076c:	89 3c 24             	mov    %edi,(%esp)
  80076f:	e8 64 03 00 00       	call   800ad8 <strnlen>
  800774:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800777:	29 c1                	sub    %eax,%ecx
  800779:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80077c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800780:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800783:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800786:	8b 75 08             	mov    0x8(%ebp),%esi
  800789:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80078c:	89 cb                	mov    %ecx,%ebx
  80078e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800790:	eb 0f                	jmp    8007a1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800792:	8b 45 0c             	mov    0xc(%ebp),%eax
  800795:	89 44 24 04          	mov    %eax,0x4(%esp)
  800799:	89 3c 24             	mov    %edi,(%esp)
  80079c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80079e:	83 eb 01             	sub    $0x1,%ebx
  8007a1:	85 db                	test   %ebx,%ebx
  8007a3:	7f ed                	jg     800792 <vprintfmt+0x1be>
  8007a5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ae:	85 c9                	test   %ecx,%ecx
  8007b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b5:	0f 49 c1             	cmovns %ecx,%eax
  8007b8:	29 c1                	sub    %eax,%ecx
  8007ba:	89 cb                	mov    %ecx,%ebx
  8007bc:	eb 44                	jmp    800802 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c2:	74 1e                	je     8007e2 <vprintfmt+0x20e>
  8007c4:	0f be d2             	movsbl %dl,%edx
  8007c7:	83 ea 20             	sub    $0x20,%edx
  8007ca:	83 fa 5e             	cmp    $0x5e,%edx
  8007cd:	76 13                	jbe    8007e2 <vprintfmt+0x20e>
					putch('?', putdat);
  8007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007dd:	ff 55 08             	call   *0x8(%ebp)
  8007e0:	eb 0d                	jmp    8007ef <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8007e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007e9:	89 04 24             	mov    %eax,(%esp)
  8007ec:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ef:	83 eb 01             	sub    $0x1,%ebx
  8007f2:	eb 0e                	jmp    800802 <vprintfmt+0x22e>
  8007f4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8007fa:	eb 06                	jmp    800802 <vprintfmt+0x22e>
  8007fc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007ff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800802:	83 c7 01             	add    $0x1,%edi
  800805:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800809:	0f be c2             	movsbl %dl,%eax
  80080c:	85 c0                	test   %eax,%eax
  80080e:	74 27                	je     800837 <vprintfmt+0x263>
  800810:	85 f6                	test   %esi,%esi
  800812:	78 aa                	js     8007be <vprintfmt+0x1ea>
  800814:	83 ee 01             	sub    $0x1,%esi
  800817:	79 a5                	jns    8007be <vprintfmt+0x1ea>
  800819:	89 d8                	mov    %ebx,%eax
  80081b:	8b 75 08             	mov    0x8(%ebp),%esi
  80081e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800821:	89 c3                	mov    %eax,%ebx
  800823:	eb 18                	jmp    80083d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800825:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800829:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800830:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800832:	83 eb 01             	sub    $0x1,%ebx
  800835:	eb 06                	jmp    80083d <vprintfmt+0x269>
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80083d:	85 db                	test   %ebx,%ebx
  80083f:	7f e4                	jg     800825 <vprintfmt+0x251>
  800841:	89 75 08             	mov    %esi,0x8(%ebp)
  800844:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800847:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80084a:	e9 aa fd ff ff       	jmp    8005f9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80084f:	83 f9 01             	cmp    $0x1,%ecx
  800852:	7e 10                	jle    800864 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8b 30                	mov    (%eax),%esi
  800859:	8b 78 04             	mov    0x4(%eax),%edi
  80085c:	8d 40 08             	lea    0x8(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	eb 26                	jmp    80088a <vprintfmt+0x2b6>
	else if (lflag)
  800864:	85 c9                	test   %ecx,%ecx
  800866:	74 12                	je     80087a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 30                	mov    (%eax),%esi
  80086d:	89 f7                	mov    %esi,%edi
  80086f:	c1 ff 1f             	sar    $0x1f,%edi
  800872:	8d 40 04             	lea    0x4(%eax),%eax
  800875:	89 45 14             	mov    %eax,0x14(%ebp)
  800878:	eb 10                	jmp    80088a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8b 30                	mov    (%eax),%esi
  80087f:	89 f7                	mov    %esi,%edi
  800881:	c1 ff 1f             	sar    $0x1f,%edi
  800884:	8d 40 04             	lea    0x4(%eax),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	89 f0                	mov    %esi,%eax
  80088c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80088e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800893:	85 ff                	test   %edi,%edi
  800895:	0f 89 3a 01 00 00    	jns    8009d5 <vprintfmt+0x401>
				putch('-', putdat);
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008a9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008ac:	89 f0                	mov    %esi,%eax
  8008ae:	89 fa                	mov    %edi,%edx
  8008b0:	f7 d8                	neg    %eax
  8008b2:	83 d2 00             	adc    $0x0,%edx
  8008b5:	f7 da                	neg    %edx
			}
			base = 10;
  8008b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008bc:	e9 14 01 00 00       	jmp    8009d5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008c1:	83 f9 01             	cmp    $0x1,%ecx
  8008c4:	7e 13                	jle    8008d9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	8b 50 04             	mov    0x4(%eax),%edx
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8b 75 14             	mov    0x14(%ebp),%esi
  8008d1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8008d4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008d7:	eb 2c                	jmp    800905 <vprintfmt+0x331>
	else if (lflag)
  8008d9:	85 c9                	test   %ecx,%ecx
  8008db:	74 15                	je     8008f2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e7:	8b 75 14             	mov    0x14(%ebp),%esi
  8008ea:	8d 76 04             	lea    0x4(%esi),%esi
  8008ed:	89 75 14             	mov    %esi,0x14(%ebp)
  8008f0:	eb 13                	jmp    800905 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fc:	8b 75 14             	mov    0x14(%ebp),%esi
  8008ff:	8d 76 04             	lea    0x4(%esi),%esi
  800902:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800905:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80090a:	e9 c6 00 00 00       	jmp    8009d5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80090f:	83 f9 01             	cmp    $0x1,%ecx
  800912:	7e 13                	jle    800927 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	8b 50 04             	mov    0x4(%eax),%edx
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	8b 75 14             	mov    0x14(%ebp),%esi
  80091f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800922:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800925:	eb 24                	jmp    80094b <vprintfmt+0x377>
	else if (lflag)
  800927:	85 c9                	test   %ecx,%ecx
  800929:	74 11                	je     80093c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	99                   	cltd   
  800931:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800934:	8d 71 04             	lea    0x4(%ecx),%esi
  800937:	89 75 14             	mov    %esi,0x14(%ebp)
  80093a:	eb 0f                	jmp    80094b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	99                   	cltd   
  800942:	8b 75 14             	mov    0x14(%ebp),%esi
  800945:	8d 76 04             	lea    0x4(%esi),%esi
  800948:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80094b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800950:	e9 80 00 00 00       	jmp    8009d5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800955:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800966:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800970:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800977:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80097a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80097e:	8b 06                	mov    (%esi),%eax
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800985:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80098a:	eb 49                	jmp    8009d5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80098c:	83 f9 01             	cmp    $0x1,%ecx
  80098f:	7e 13                	jle    8009a4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8b 50 04             	mov    0x4(%eax),%edx
  800997:	8b 00                	mov    (%eax),%eax
  800999:	8b 75 14             	mov    0x14(%ebp),%esi
  80099c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80099f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8009a2:	eb 2c                	jmp    8009d0 <vprintfmt+0x3fc>
	else if (lflag)
  8009a4:	85 c9                	test   %ecx,%ecx
  8009a6:	74 15                	je     8009bd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8009a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8009b5:	8d 71 04             	lea    0x4(%ecx),%esi
  8009b8:	89 75 14             	mov    %esi,0x14(%ebp)
  8009bb:	eb 13                	jmp    8009d0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	8b 75 14             	mov    0x14(%ebp),%esi
  8009ca:	8d 76 04             	lea    0x4(%esi),%esi
  8009cd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8009d0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009d5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8009d9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8009dd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8009e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009e8:	89 04 24             	mov    %eax,(%esp)
  8009eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	e8 a6 fa ff ff       	call   8004a0 <printnum>
			break;
  8009fa:	e9 fa fb ff ff       	jmp    8005f9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a06:	89 04 24             	mov    %eax,(%esp)
  800a09:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a0c:	e9 e8 fb ff ff       	jmp    8005f9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a18:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a1f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a22:	89 fb                	mov    %edi,%ebx
  800a24:	eb 03                	jmp    800a29 <vprintfmt+0x455>
  800a26:	83 eb 01             	sub    $0x1,%ebx
  800a29:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800a2d:	75 f7                	jne    800a26 <vprintfmt+0x452>
  800a2f:	90                   	nop
  800a30:	e9 c4 fb ff ff       	jmp    8005f9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800a35:	83 c4 3c             	add    $0x3c,%esp
  800a38:	5b                   	pop    %ebx
  800a39:	5e                   	pop    %esi
  800a3a:	5f                   	pop    %edi
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	83 ec 28             	sub    $0x28,%esp
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a50:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a5a:	85 c0                	test   %eax,%eax
  800a5c:	74 30                	je     800a8e <vsnprintf+0x51>
  800a5e:	85 d2                	test   %edx,%edx
  800a60:	7e 2c                	jle    800a8e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a69:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a77:	c7 04 24 8f 05 80 00 	movl   $0x80058f,(%esp)
  800a7e:	e8 51 fb ff ff       	call   8005d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a86:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a8c:	eb 05                	jmp    800a93 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a93:	c9                   	leave  
  800a94:	c3                   	ret    

00800a95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a9b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800aa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	89 04 24             	mov    %eax,(%esp)
  800ab6:	e8 82 ff ff ff       	call   800a3d <vsnprintf>
	va_end(ap);

	return rc;
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    
  800abd:	66 90                	xchg   %ax,%ax
  800abf:	90                   	nop

00800ac0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  800acb:	eb 03                	jmp    800ad0 <strlen+0x10>
		n++;
  800acd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ad4:	75 f7                	jne    800acd <strlen+0xd>
		n++;
	return n;
}
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ade:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae6:	eb 03                	jmp    800aeb <strnlen+0x13>
		n++;
  800ae8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aeb:	39 d0                	cmp    %edx,%eax
  800aed:	74 06                	je     800af5 <strnlen+0x1d>
  800aef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800af3:	75 f3                	jne    800ae8 <strnlen+0x10>
		n++;
	return n;
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	53                   	push   %ebx
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b01:	89 c2                	mov    %eax,%edx
  800b03:	83 c2 01             	add    $0x1,%edx
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b0d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b10:	84 db                	test   %bl,%bl
  800b12:	75 ef                	jne    800b03 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b14:	5b                   	pop    %ebx
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b21:	89 1c 24             	mov    %ebx,(%esp)
  800b24:	e8 97 ff ff ff       	call   800ac0 <strlen>
	strcpy(dst + len, src);
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b30:	01 d8                	add    %ebx,%eax
  800b32:	89 04 24             	mov    %eax,(%esp)
  800b35:	e8 bd ff ff ff       	call   800af7 <strcpy>
	return dst;
}
  800b3a:	89 d8                	mov    %ebx,%eax
  800b3c:	83 c4 08             	add    $0x8,%esp
  800b3f:	5b                   	pop    %ebx
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	56                   	push   %esi
  800b46:	53                   	push   %ebx
  800b47:	8b 75 08             	mov    0x8(%ebp),%esi
  800b4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4d:	89 f3                	mov    %esi,%ebx
  800b4f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b52:	89 f2                	mov    %esi,%edx
  800b54:	eb 0f                	jmp    800b65 <strncpy+0x23>
		*dst++ = *src;
  800b56:	83 c2 01             	add    $0x1,%edx
  800b59:	0f b6 01             	movzbl (%ecx),%eax
  800b5c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b5f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b62:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b65:	39 da                	cmp    %ebx,%edx
  800b67:	75 ed                	jne    800b56 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b69:	89 f0                	mov    %esi,%eax
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	8b 75 08             	mov    0x8(%ebp),%esi
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b83:	85 c9                	test   %ecx,%ecx
  800b85:	75 0b                	jne    800b92 <strlcpy+0x23>
  800b87:	eb 1d                	jmp    800ba6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b92:	39 d8                	cmp    %ebx,%eax
  800b94:	74 0b                	je     800ba1 <strlcpy+0x32>
  800b96:	0f b6 0a             	movzbl (%edx),%ecx
  800b99:	84 c9                	test   %cl,%cl
  800b9b:	75 ec                	jne    800b89 <strlcpy+0x1a>
  800b9d:	89 c2                	mov    %eax,%edx
  800b9f:	eb 02                	jmp    800ba3 <strlcpy+0x34>
  800ba1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800ba3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800ba6:	29 f0                	sub    %esi,%eax
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bb5:	eb 06                	jmp    800bbd <strcmp+0x11>
		p++, q++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bbd:	0f b6 01             	movzbl (%ecx),%eax
  800bc0:	84 c0                	test   %al,%al
  800bc2:	74 04                	je     800bc8 <strcmp+0x1c>
  800bc4:	3a 02                	cmp    (%edx),%al
  800bc6:	74 ef                	je     800bb7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc8:	0f b6 c0             	movzbl %al,%eax
  800bcb:	0f b6 12             	movzbl (%edx),%edx
  800bce:	29 d0                	sub    %edx,%eax
}
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	53                   	push   %ebx
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdc:	89 c3                	mov    %eax,%ebx
  800bde:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800be1:	eb 06                	jmp    800be9 <strncmp+0x17>
		n--, p++, q++;
  800be3:	83 c0 01             	add    $0x1,%eax
  800be6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800be9:	39 d8                	cmp    %ebx,%eax
  800beb:	74 15                	je     800c02 <strncmp+0x30>
  800bed:	0f b6 08             	movzbl (%eax),%ecx
  800bf0:	84 c9                	test   %cl,%cl
  800bf2:	74 04                	je     800bf8 <strncmp+0x26>
  800bf4:	3a 0a                	cmp    (%edx),%cl
  800bf6:	74 eb                	je     800be3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf8:	0f b6 00             	movzbl (%eax),%eax
  800bfb:	0f b6 12             	movzbl (%edx),%edx
  800bfe:	29 d0                	sub    %edx,%eax
  800c00:	eb 05                	jmp    800c07 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c14:	eb 07                	jmp    800c1d <strchr+0x13>
		if (*s == c)
  800c16:	38 ca                	cmp    %cl,%dl
  800c18:	74 0f                	je     800c29 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	0f b6 10             	movzbl (%eax),%edx
  800c20:	84 d2                	test   %dl,%dl
  800c22:	75 f2                	jne    800c16 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800c24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c35:	eb 07                	jmp    800c3e <strfind+0x13>
		if (*s == c)
  800c37:	38 ca                	cmp    %cl,%dl
  800c39:	74 0a                	je     800c45 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c3b:	83 c0 01             	add    $0x1,%eax
  800c3e:	0f b6 10             	movzbl (%eax),%edx
  800c41:	84 d2                	test   %dl,%dl
  800c43:	75 f2                	jne    800c37 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c53:	85 c9                	test   %ecx,%ecx
  800c55:	74 36                	je     800c8d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c57:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c5d:	75 28                	jne    800c87 <memset+0x40>
  800c5f:	f6 c1 03             	test   $0x3,%cl
  800c62:	75 23                	jne    800c87 <memset+0x40>
		c &= 0xFF;
  800c64:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c68:	89 d3                	mov    %edx,%ebx
  800c6a:	c1 e3 08             	shl    $0x8,%ebx
  800c6d:	89 d6                	mov    %edx,%esi
  800c6f:	c1 e6 18             	shl    $0x18,%esi
  800c72:	89 d0                	mov    %edx,%eax
  800c74:	c1 e0 10             	shl    $0x10,%eax
  800c77:	09 f0                	or     %esi,%eax
  800c79:	09 c2                	or     %eax,%edx
  800c7b:	89 d0                	mov    %edx,%eax
  800c7d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c7f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c82:	fc                   	cld    
  800c83:	f3 ab                	rep stos %eax,%es:(%edi)
  800c85:	eb 06                	jmp    800c8d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8a:	fc                   	cld    
  800c8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c8d:	89 f8                	mov    %edi,%eax
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca2:	39 c6                	cmp    %eax,%esi
  800ca4:	73 35                	jae    800cdb <memmove+0x47>
  800ca6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ca9:	39 d0                	cmp    %edx,%eax
  800cab:	73 2e                	jae    800cdb <memmove+0x47>
		s += n;
		d += n;
  800cad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800cb0:	89 d6                	mov    %edx,%esi
  800cb2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cba:	75 13                	jne    800ccf <memmove+0x3b>
  800cbc:	f6 c1 03             	test   $0x3,%cl
  800cbf:	75 0e                	jne    800ccf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cc1:	83 ef 04             	sub    $0x4,%edi
  800cc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800cca:	fd                   	std    
  800ccb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ccd:	eb 09                	jmp    800cd8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ccf:	83 ef 01             	sub    $0x1,%edi
  800cd2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800cd5:	fd                   	std    
  800cd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cd8:	fc                   	cld    
  800cd9:	eb 1d                	jmp    800cf8 <memmove+0x64>
  800cdb:	89 f2                	mov    %esi,%edx
  800cdd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cdf:	f6 c2 03             	test   $0x3,%dl
  800ce2:	75 0f                	jne    800cf3 <memmove+0x5f>
  800ce4:	f6 c1 03             	test   $0x3,%cl
  800ce7:	75 0a                	jne    800cf3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ce9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cec:	89 c7                	mov    %eax,%edi
  800cee:	fc                   	cld    
  800cef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf1:	eb 05                	jmp    800cf8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cf3:	89 c7                	mov    %eax,%edi
  800cf5:	fc                   	cld    
  800cf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	89 04 24             	mov    %eax,(%esp)
  800d16:	e8 79 ff ff ff       	call   800c94 <memmove>
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	89 d6                	mov    %edx,%esi
  800d2a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d2d:	eb 1a                	jmp    800d49 <memcmp+0x2c>
		if (*s1 != *s2)
  800d2f:	0f b6 02             	movzbl (%edx),%eax
  800d32:	0f b6 19             	movzbl (%ecx),%ebx
  800d35:	38 d8                	cmp    %bl,%al
  800d37:	74 0a                	je     800d43 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800d39:	0f b6 c0             	movzbl %al,%eax
  800d3c:	0f b6 db             	movzbl %bl,%ebx
  800d3f:	29 d8                	sub    %ebx,%eax
  800d41:	eb 0f                	jmp    800d52 <memcmp+0x35>
		s1++, s2++;
  800d43:	83 c2 01             	add    $0x1,%edx
  800d46:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d49:	39 f2                	cmp    %esi,%edx
  800d4b:	75 e2                	jne    800d2f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d5f:	89 c2                	mov    %eax,%edx
  800d61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d64:	eb 07                	jmp    800d6d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d66:	38 08                	cmp    %cl,(%eax)
  800d68:	74 07                	je     800d71 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d6a:	83 c0 01             	add    $0x1,%eax
  800d6d:	39 d0                	cmp    %edx,%eax
  800d6f:	72 f5                	jb     800d66 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7f:	eb 03                	jmp    800d84 <strtol+0x11>
		s++;
  800d81:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d84:	0f b6 0a             	movzbl (%edx),%ecx
  800d87:	80 f9 09             	cmp    $0x9,%cl
  800d8a:	74 f5                	je     800d81 <strtol+0xe>
  800d8c:	80 f9 20             	cmp    $0x20,%cl
  800d8f:	74 f0                	je     800d81 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d91:	80 f9 2b             	cmp    $0x2b,%cl
  800d94:	75 0a                	jne    800da0 <strtol+0x2d>
		s++;
  800d96:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d99:	bf 00 00 00 00       	mov    $0x0,%edi
  800d9e:	eb 11                	jmp    800db1 <strtol+0x3e>
  800da0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800da5:	80 f9 2d             	cmp    $0x2d,%cl
  800da8:	75 07                	jne    800db1 <strtol+0x3e>
		s++, neg = 1;
  800daa:	8d 52 01             	lea    0x1(%edx),%edx
  800dad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800db6:	75 15                	jne    800dcd <strtol+0x5a>
  800db8:	80 3a 30             	cmpb   $0x30,(%edx)
  800dbb:	75 10                	jne    800dcd <strtol+0x5a>
  800dbd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800dc1:	75 0a                	jne    800dcd <strtol+0x5a>
		s += 2, base = 16;
  800dc3:	83 c2 02             	add    $0x2,%edx
  800dc6:	b8 10 00 00 00       	mov    $0x10,%eax
  800dcb:	eb 10                	jmp    800ddd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	75 0c                	jne    800ddd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dd1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dd3:	80 3a 30             	cmpb   $0x30,(%edx)
  800dd6:	75 05                	jne    800ddd <strtol+0x6a>
		s++, base = 8;
  800dd8:	83 c2 01             	add    $0x1,%edx
  800ddb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ddd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800de5:	0f b6 0a             	movzbl (%edx),%ecx
  800de8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800deb:	89 f0                	mov    %esi,%eax
  800ded:	3c 09                	cmp    $0x9,%al
  800def:	77 08                	ja     800df9 <strtol+0x86>
			dig = *s - '0';
  800df1:	0f be c9             	movsbl %cl,%ecx
  800df4:	83 e9 30             	sub    $0x30,%ecx
  800df7:	eb 20                	jmp    800e19 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800df9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dfc:	89 f0                	mov    %esi,%eax
  800dfe:	3c 19                	cmp    $0x19,%al
  800e00:	77 08                	ja     800e0a <strtol+0x97>
			dig = *s - 'a' + 10;
  800e02:	0f be c9             	movsbl %cl,%ecx
  800e05:	83 e9 57             	sub    $0x57,%ecx
  800e08:	eb 0f                	jmp    800e19 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800e0a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e0d:	89 f0                	mov    %esi,%eax
  800e0f:	3c 19                	cmp    $0x19,%al
  800e11:	77 16                	ja     800e29 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800e13:	0f be c9             	movsbl %cl,%ecx
  800e16:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e19:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800e1c:	7d 0f                	jge    800e2d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800e1e:	83 c2 01             	add    $0x1,%edx
  800e21:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800e25:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800e27:	eb bc                	jmp    800de5 <strtol+0x72>
  800e29:	89 d8                	mov    %ebx,%eax
  800e2b:	eb 02                	jmp    800e2f <strtol+0xbc>
  800e2d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800e2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e33:	74 05                	je     800e3a <strtol+0xc7>
		*endptr = (char *) s;
  800e35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e38:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e3a:	f7 d8                	neg    %eax
  800e3c:	85 ff                	test   %edi,%edi
  800e3e:	0f 44 c3             	cmove  %ebx,%eax
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	89 c3                	mov    %eax,%ebx
  800e59:	89 c7                	mov    %eax,%edi
  800e5b:	89 c6                	mov    %eax,%esi
  800e5d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e74:	89 d1                	mov    %edx,%ecx
  800e76:	89 d3                	mov    %edx,%ebx
  800e78:	89 d7                	mov    %edx,%edi
  800e7a:	89 d6                	mov    %edx,%esi
  800e7c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e91:	b8 03 00 00 00       	mov    $0x3,%eax
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	89 cb                	mov    %ecx,%ebx
  800e9b:	89 cf                	mov    %ecx,%edi
  800e9d:	89 ce                	mov    %ecx,%esi
  800e9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	7e 28                	jle    800ecd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  800eb8:	00 
  800eb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec0:	00 
  800ec1:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  800ec8:	e8 b9 f4 ff ff       	call   800386 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ecd:	83 c4 2c             	add    $0x2c,%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
  800edb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ede:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee3:	b8 04 00 00 00       	mov    $0x4,%eax
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	89 cb                	mov    %ecx,%ebx
  800eed:	89 cf                	mov    %ecx,%edi
  800eef:	89 ce                	mov    %ecx,%esi
  800ef1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7e 28                	jle    800f1f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f02:	00 
  800f03:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  800f0a:	00 
  800f0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f12:	00 
  800f13:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  800f1a:	e8 67 f4 ff ff       	call   800386 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800f1f:	83 c4 2c             	add    $0x2c,%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5f                   	pop    %edi
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	57                   	push   %edi
  800f2b:	56                   	push   %esi
  800f2c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f32:	b8 02 00 00 00       	mov    $0x2,%eax
  800f37:	89 d1                	mov    %edx,%ecx
  800f39:	89 d3                	mov    %edx,%ebx
  800f3b:	89 d7                	mov    %edx,%edi
  800f3d:	89 d6                	mov    %edx,%esi
  800f3f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_yield>:

void
sys_yield(void)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f51:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f56:	89 d1                	mov    %edx,%ecx
  800f58:	89 d3                	mov    %edx,%ebx
  800f5a:	89 d7                	mov    %edx,%edi
  800f5c:	89 d6                	mov    %edx,%esi
  800f5e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
  800f6b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6e:	be 00 00 00 00       	mov    $0x0,%esi
  800f73:	b8 05 00 00 00       	mov    $0x5,%eax
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f81:	89 f7                	mov    %esi,%edi
  800f83:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	7e 28                	jle    800fb1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f89:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f94:	00 
  800f95:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  800f9c:	00 
  800f9d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa4:	00 
  800fa5:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  800fac:	e8 d5 f3 ff ff       	call   800386 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fb1:	83 c4 2c             	add    $0x2c,%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    

00800fb9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc2:	b8 06 00 00 00       	mov    $0x6,%eax
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd3:	8b 75 18             	mov    0x18(%ebp),%esi
  800fd6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	7e 28                	jle    801004 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fe7:	00 
  800fe8:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  800fef:	00 
  800ff0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff7:	00 
  800ff8:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  800fff:	e8 82 f3 ff ff       	call   800386 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801004:	83 c4 2c             	add    $0x2c,%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5f                   	pop    %edi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
  801012:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801015:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101a:	b8 07 00 00 00       	mov    $0x7,%eax
  80101f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801022:	8b 55 08             	mov    0x8(%ebp),%edx
  801025:	89 df                	mov    %ebx,%edi
  801027:	89 de                	mov    %ebx,%esi
  801029:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	7e 28                	jle    801057 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80102f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801033:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80103a:	00 
  80103b:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  801042:	00 
  801043:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104a:	00 
  80104b:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  801052:	e8 2f f3 ff ff       	call   800386 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801057:	83 c4 2c             	add    $0x2c,%esp
  80105a:	5b                   	pop    %ebx
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801065:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106a:	b8 10 00 00 00       	mov    $0x10,%eax
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	89 cb                	mov    %ecx,%ebx
  801074:	89 cf                	mov    %ecx,%edi
  801076:	89 ce                	mov    %ecx,%esi
  801078:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
  801085:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801088:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108d:	b8 09 00 00 00       	mov    $0x9,%eax
  801092:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	89 df                	mov    %ebx,%edi
  80109a:	89 de                	mov    %ebx,%esi
  80109c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	7e 28                	jle    8010ca <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010ad:	00 
  8010ae:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  8010b5:	00 
  8010b6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010bd:	00 
  8010be:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  8010c5:	e8 bc f2 ff ff       	call   800386 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010ca:	83 c4 2c             	add    $0x2c,%esp
  8010cd:	5b                   	pop    %ebx
  8010ce:	5e                   	pop    %esi
  8010cf:	5f                   	pop    %edi
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	89 df                	mov    %ebx,%edi
  8010ed:	89 de                	mov    %ebx,%esi
  8010ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	7e 28                	jle    80111d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801100:	00 
  801101:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  801108:	00 
  801109:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801110:	00 
  801111:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  801118:	e8 69 f2 ff ff       	call   800386 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80111d:	83 c4 2c             	add    $0x2c,%esp
  801120:	5b                   	pop    %ebx
  801121:	5e                   	pop    %esi
  801122:	5f                   	pop    %edi
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	b8 0b 00 00 00       	mov    $0xb,%eax
  801138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	89 df                	mov    %ebx,%edi
  801140:	89 de                	mov    %ebx,%esi
  801142:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801144:	85 c0                	test   %eax,%eax
  801146:	7e 28                	jle    801170 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801148:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801153:	00 
  801154:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  80115b:	00 
  80115c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801163:	00 
  801164:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  80116b:	e8 16 f2 ff ff       	call   800386 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801170:	83 c4 2c             	add    $0x2c,%esp
  801173:	5b                   	pop    %ebx
  801174:	5e                   	pop    %esi
  801175:	5f                   	pop    %edi
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    

00801178 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	57                   	push   %edi
  80117c:	56                   	push   %esi
  80117d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117e:	be 00 00 00 00       	mov    $0x0,%esi
  801183:	b8 0d 00 00 00       	mov    $0xd,%eax
  801188:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118b:	8b 55 08             	mov    0x8(%ebp),%edx
  80118e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801191:	8b 7d 14             	mov    0x14(%ebp),%edi
  801194:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801196:	5b                   	pop    %ebx
  801197:	5e                   	pop    %esi
  801198:	5f                   	pop    %edi
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	57                   	push   %edi
  80119f:	56                   	push   %esi
  8011a0:	53                   	push   %ebx
  8011a1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	89 cb                	mov    %ecx,%ebx
  8011b3:	89 cf                	mov    %ecx,%edi
  8011b5:	89 ce                	mov    %ecx,%esi
  8011b7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	7e 28                	jle    8011e5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8011c8:	00 
  8011c9:	c7 44 24 08 77 34 80 	movl   $0x803477,0x8(%esp)
  8011d0:	00 
  8011d1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d8:	00 
  8011d9:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  8011e0:	e8 a1 f1 ff ff       	call   800386 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011e5:	83 c4 2c             	add    $0x2c,%esp
  8011e8:	5b                   	pop    %ebx
  8011e9:	5e                   	pop    %esi
  8011ea:	5f                   	pop    %edi
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	57                   	push   %edi
  8011f1:	56                   	push   %esi
  8011f2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011fd:	89 d1                	mov    %edx,%ecx
  8011ff:	89 d3                	mov    %edx,%ebx
  801201:	89 d7                	mov    %edx,%edi
  801203:	89 d6                	mov    %edx,%esi
  801205:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	57                   	push   %edi
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801212:	bb 00 00 00 00       	mov    $0x0,%ebx
  801217:	b8 11 00 00 00       	mov    $0x11,%eax
  80121c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	89 df                	mov    %ebx,%edi
  801224:	89 de                	mov    %ebx,%esi
  801226:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801228:	5b                   	pop    %ebx
  801229:	5e                   	pop    %esi
  80122a:	5f                   	pop    %edi
  80122b:	5d                   	pop    %ebp
  80122c:	c3                   	ret    

0080122d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801233:	bb 00 00 00 00       	mov    $0x0,%ebx
  801238:	b8 12 00 00 00       	mov    $0x12,%eax
  80123d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801240:	8b 55 08             	mov    0x8(%ebp),%edx
  801243:	89 df                	mov    %ebx,%edi
  801245:	89 de                	mov    %ebx,%esi
  801247:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801249:	5b                   	pop    %ebx
  80124a:	5e                   	pop    %esi
  80124b:	5f                   	pop    %edi
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801254:	b9 00 00 00 00       	mov    $0x0,%ecx
  801259:	b8 13 00 00 00       	mov    $0x13,%eax
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 cb                	mov    %ecx,%ebx
  801263:	89 cf                	mov    %ecx,%edi
  801265:	89 ce                	mov    %ecx,%esi
  801267:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801269:	5b                   	pop    %ebx
  80126a:	5e                   	pop    %esi
  80126b:	5f                   	pop    %edi
  80126c:	5d                   	pop    %ebp
  80126d:	c3                   	ret    

0080126e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	57                   	push   %edi
  801272:	56                   	push   %esi
  801273:	53                   	push   %ebx
  801274:	83 ec 2c             	sub    $0x2c,%esp
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80127a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80127c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80127f:	89 f8                	mov    %edi,%eax
  801281:	c1 e8 0c             	shr    $0xc,%eax
  801284:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801287:	e8 9b fc ff ff       	call   800f27 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80128c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801292:	0f 84 de 00 00 00    	je     801376 <pgfault+0x108>
  801298:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80129a:	85 c0                	test   %eax,%eax
  80129c:	79 20                	jns    8012be <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80129e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012a2:	c7 44 24 08 a2 34 80 	movl   $0x8034a2,0x8(%esp)
  8012a9:	00 
  8012aa:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8012b1:	00 
  8012b2:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  8012b9:	e8 c8 f0 ff ff       	call   800386 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  8012be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  8012c8:	25 05 08 00 00       	and    $0x805,%eax
  8012cd:	3d 05 08 00 00       	cmp    $0x805,%eax
  8012d2:	0f 85 ba 00 00 00    	jne    801392 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8012d8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012df:	00 
  8012e0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012e7:	00 
  8012e8:	89 1c 24             	mov    %ebx,(%esp)
  8012eb:	e8 75 fc ff ff       	call   800f65 <sys_page_alloc>
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	79 20                	jns    801314 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  8012f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f8:	c7 44 24 08 4a 30 80 	movl   $0x80304a,0x8(%esp)
  8012ff:	00 
  801300:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801307:	00 
  801308:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  80130f:	e8 72 f0 ff ff       	call   800386 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801314:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80131a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801321:	00 
  801322:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801326:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80132d:	e8 62 f9 ff ff       	call   800c94 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801332:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801339:	00 
  80133a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80133e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801342:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801349:	00 
  80134a:	89 1c 24             	mov    %ebx,(%esp)
  80134d:	e8 67 fc ff ff       	call   800fb9 <sys_page_map>
  801352:	85 c0                	test   %eax,%eax
  801354:	79 3c                	jns    801392 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801356:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80135a:	c7 44 24 08 c9 34 80 	movl   $0x8034c9,0x8(%esp)
  801361:	00 
  801362:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801369:	00 
  80136a:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  801371:	e8 10 f0 ff ff       	call   800386 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801376:	c7 44 24 08 f0 34 80 	movl   $0x8034f0,0x8(%esp)
  80137d:	00 
  80137e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801385:	00 
  801386:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  80138d:	e8 f4 ef ff ff       	call   800386 <_panic>
}
  801392:	83 c4 2c             	add    $0x2c,%esp
  801395:	5b                   	pop    %ebx
  801396:	5e                   	pop    %esi
  801397:	5f                   	pop    %edi
  801398:	5d                   	pop    %ebp
  801399:	c3                   	ret    

0080139a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	56                   	push   %esi
  80139e:	53                   	push   %ebx
  80139f:	83 ec 20             	sub    $0x20,%esp
  8013a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8013a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8013a8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013af:	00 
  8013b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013b4:	89 34 24             	mov    %esi,(%esp)
  8013b7:	e8 a9 fb ff ff       	call   800f65 <sys_page_alloc>
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	79 20                	jns    8013e0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  8013c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013c4:	c7 44 24 08 4a 30 80 	movl   $0x80304a,0x8(%esp)
  8013cb:	00 
  8013cc:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8013d3:	00 
  8013d4:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  8013db:	e8 a6 ef ff ff       	call   800386 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8013e0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8013e7:	00 
  8013e8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8013ef:	00 
  8013f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013f7:	00 
  8013f8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013fc:	89 34 24             	mov    %esi,(%esp)
  8013ff:	e8 b5 fb ff ff       	call   800fb9 <sys_page_map>
  801404:	85 c0                	test   %eax,%eax
  801406:	79 20                	jns    801428 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801408:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80140c:	c7 44 24 08 c9 34 80 	movl   $0x8034c9,0x8(%esp)
  801413:	00 
  801414:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80141b:	00 
  80141c:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  801423:	e8 5e ef ff ff       	call   800386 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801428:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80142f:	00 
  801430:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801434:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80143b:	e8 54 f8 ff ff       	call   800c94 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801440:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801447:	00 
  801448:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80144f:	e8 b8 fb ff ff       	call   80100c <sys_page_unmap>
  801454:	85 c0                	test   %eax,%eax
  801456:	79 20                	jns    801478 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801458:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80145c:	c7 44 24 08 da 34 80 	movl   $0x8034da,0x8(%esp)
  801463:	00 
  801464:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80146b:	00 
  80146c:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  801473:	e8 0e ef ff ff       	call   800386 <_panic>

}
  801478:	83 c4 20             	add    $0x20,%esp
  80147b:	5b                   	pop    %ebx
  80147c:	5e                   	pop    %esi
  80147d:	5d                   	pop    %ebp
  80147e:	c3                   	ret    

0080147f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	57                   	push   %edi
  801483:	56                   	push   %esi
  801484:	53                   	push   %ebx
  801485:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801488:	c7 04 24 6e 12 80 00 	movl   $0x80126e,(%esp)
  80148f:	e8 f2 17 00 00       	call   802c86 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801494:	b8 08 00 00 00       	mov    $0x8,%eax
  801499:	cd 30                	int    $0x30
  80149b:	89 c6                	mov    %eax,%esi
  80149d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	79 20                	jns    8014c4 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  8014a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014a8:	c7 44 24 08 14 35 80 	movl   $0x803514,0x8(%esp)
  8014af:	00 
  8014b0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  8014b7:	00 
  8014b8:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  8014bf:	e8 c2 ee ff ff       	call   800386 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8014c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	75 21                	jne    8014ee <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8014cd:	e8 55 fa ff ff       	call   800f27 <sys_getenvid>
  8014d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014d7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014df:	a3 0c 50 80 00       	mov    %eax,0x80500c
		//set_pgfault_handler(pgfault);
		return 0;
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e9:	e9 88 01 00 00       	jmp    801676 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8014ee:	89 d8                	mov    %ebx,%eax
  8014f0:	c1 e8 16             	shr    $0x16,%eax
  8014f3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014fa:	a8 01                	test   $0x1,%al
  8014fc:	0f 84 e0 00 00 00    	je     8015e2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801502:	89 df                	mov    %ebx,%edi
  801504:	c1 ef 0c             	shr    $0xc,%edi
  801507:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80150e:	a8 01                	test   $0x1,%al
  801510:	0f 84 c4 00 00 00    	je     8015da <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801516:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80151d:	f6 c4 04             	test   $0x4,%ah
  801520:	74 0d                	je     80152f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801522:	25 07 0e 00 00       	and    $0xe07,%eax
  801527:	83 c8 05             	or     $0x5,%eax
  80152a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80152d:	eb 1b                	jmp    80154a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80152f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801534:	83 f8 01             	cmp    $0x1,%eax
  801537:	19 c0                	sbb    %eax,%eax
  801539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80153c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801543:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80154a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80154d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801550:	89 44 24 10          	mov    %eax,0x10(%esp)
  801554:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80155f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801563:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80156a:	e8 4a fa ff ff       	call   800fb9 <sys_page_map>
  80156f:	85 c0                	test   %eax,%eax
  801571:	79 20                	jns    801593 <fork+0x114>
		panic("sys_page_map: %e", r);
  801573:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801577:	c7 44 24 08 c9 34 80 	movl   $0x8034c9,0x8(%esp)
  80157e:	00 
  80157f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801586:	00 
  801587:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  80158e:	e8 f3 ed ff ff       	call   800386 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801596:	89 44 24 10          	mov    %eax,0x10(%esp)
  80159a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80159e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015a5:	00 
  8015a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b1:	e8 03 fa ff ff       	call   800fb9 <sys_page_map>
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	79 20                	jns    8015da <fork+0x15b>
		panic("sys_page_map: %e", r);
  8015ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015be:	c7 44 24 08 c9 34 80 	movl   $0x8034c9,0x8(%esp)
  8015c5:	00 
  8015c6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  8015cd:	00 
  8015ce:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  8015d5:	e8 ac ed ff ff       	call   800386 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8015da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015e0:	eb 06                	jmp    8015e8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  8015e2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  8015e8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  8015ee:	0f 86 fa fe ff ff    	jbe    8014ee <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8015f4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015fb:	00 
  8015fc:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801603:	ee 
  801604:	89 34 24             	mov    %esi,(%esp)
  801607:	e8 59 f9 ff ff       	call   800f65 <sys_page_alloc>
  80160c:	85 c0                	test   %eax,%eax
  80160e:	79 20                	jns    801630 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801610:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801614:	c7 44 24 08 4a 30 80 	movl   $0x80304a,0x8(%esp)
  80161b:	00 
  80161c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801623:	00 
  801624:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  80162b:	e8 56 ed ff ff       	call   800386 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801630:	c7 44 24 04 19 2d 80 	movl   $0x802d19,0x4(%esp)
  801637:	00 
  801638:	89 34 24             	mov    %esi,(%esp)
  80163b:	e8 e5 fa ff ff       	call   801125 <sys_env_set_pgfault_upcall>
  801640:	85 c0                	test   %eax,%eax
  801642:	79 20                	jns    801664 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801644:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801648:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  80164f:	00 
  801650:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801657:	00 
  801658:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  80165f:	e8 22 ed ff ff       	call   800386 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801664:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80166b:	00 
  80166c:	89 34 24             	mov    %esi,(%esp)
  80166f:	e8 0b fa ff ff       	call   80107f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801674:	89 f0                	mov    %esi,%eax

}
  801676:	83 c4 2c             	add    $0x2c,%esp
  801679:	5b                   	pop    %ebx
  80167a:	5e                   	pop    %esi
  80167b:	5f                   	pop    %edi
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    

0080167e <sfork>:

// Challenge!
int
sfork(void)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	57                   	push   %edi
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
  801684:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801687:	c7 04 24 6e 12 80 00 	movl   $0x80126e,(%esp)
  80168e:	e8 f3 15 00 00       	call   802c86 <set_pgfault_handler>
  801693:	b8 08 00 00 00       	mov    $0x8,%eax
  801698:	cd 30                	int    $0x30
  80169a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80169c:	85 c0                	test   %eax,%eax
  80169e:	79 20                	jns    8016c0 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  8016a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016a4:	c7 44 24 08 14 35 80 	movl   $0x803514,0x8(%esp)
  8016ab:	00 
  8016ac:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  8016b3:	00 
  8016b4:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  8016bb:	e8 c6 ec ff ff       	call   800386 <_panic>
  8016c0:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8016c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	75 2d                	jne    8016f8 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8016cb:	e8 57 f8 ff ff       	call   800f27 <sys_getenvid>
  8016d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8016d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016dd:	a3 0c 50 80 00       	mov    %eax,0x80500c
		set_pgfault_handler(pgfault);
  8016e2:	c7 04 24 6e 12 80 00 	movl   $0x80126e,(%esp)
  8016e9:	e8 98 15 00 00       	call   802c86 <set_pgfault_handler>
		return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	e9 1d 01 00 00       	jmp    801815 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8016f8:	89 d8                	mov    %ebx,%eax
  8016fa:	c1 e8 16             	shr    $0x16,%eax
  8016fd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801704:	a8 01                	test   $0x1,%al
  801706:	74 69                	je     801771 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801708:	89 d8                	mov    %ebx,%eax
  80170a:	c1 e8 0c             	shr    $0xc,%eax
  80170d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801714:	f6 c2 01             	test   $0x1,%dl
  801717:	74 50                	je     801769 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801719:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801720:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801723:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801729:	89 54 24 10          	mov    %edx,0x10(%esp)
  80172d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801731:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801735:	89 44 24 04          	mov    %eax,0x4(%esp)
  801739:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801740:	e8 74 f8 ff ff       	call   800fb9 <sys_page_map>
  801745:	85 c0                	test   %eax,%eax
  801747:	79 20                	jns    801769 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801749:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80174d:	c7 44 24 08 c9 34 80 	movl   $0x8034c9,0x8(%esp)
  801754:	00 
  801755:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80175c:	00 
  80175d:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  801764:	e8 1d ec ff ff       	call   800386 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80176f:	eb 06                	jmp    801777 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801771:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801777:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80177d:	0f 86 75 ff ff ff    	jbe    8016f8 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801783:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80178a:	ee 
  80178b:	89 34 24             	mov    %esi,(%esp)
  80178e:	e8 07 fc ff ff       	call   80139a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801793:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80179a:	00 
  80179b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8017a2:	ee 
  8017a3:	89 34 24             	mov    %esi,(%esp)
  8017a6:	e8 ba f7 ff ff       	call   800f65 <sys_page_alloc>
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	79 20                	jns    8017cf <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  8017af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017b3:	c7 44 24 08 4a 30 80 	movl   $0x80304a,0x8(%esp)
  8017ba:	00 
  8017bb:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  8017c2:	00 
  8017c3:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  8017ca:	e8 b7 eb ff ff       	call   800386 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8017cf:	c7 44 24 04 19 2d 80 	movl   $0x802d19,0x4(%esp)
  8017d6:	00 
  8017d7:	89 34 24             	mov    %esi,(%esp)
  8017da:	e8 46 f9 ff ff       	call   801125 <sys_env_set_pgfault_upcall>
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	79 20                	jns    801803 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  8017e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017e7:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  8017ee:	00 
  8017ef:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  8017f6:	00 
  8017f7:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  8017fe:	e8 83 eb ff ff       	call   800386 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801803:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80180a:	00 
  80180b:	89 34 24             	mov    %esi,(%esp)
  80180e:	e8 6c f8 ff ff       	call   80107f <sys_env_set_status>
	return envid;
  801813:	89 f0                	mov    %esi,%eax

}
  801815:	83 c4 2c             	add    $0x2c,%esp
  801818:	5b                   	pop    %ebx
  801819:	5e                   	pop    %esi
  80181a:	5f                   	pop    %edi
  80181b:	5d                   	pop    %ebp
  80181c:	c3                   	ret    
  80181d:	66 90                	xchg   %ax,%ax
  80181f:	90                   	nop

00801820 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	56                   	push   %esi
  801824:	53                   	push   %ebx
  801825:	83 ec 10             	sub    $0x10,%esp
  801828:	8b 75 08             	mov    0x8(%ebp),%esi
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  801831:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  801833:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801838:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80183b:	89 04 24             	mov    %eax,(%esp)
  80183e:	e8 58 f9 ff ff       	call   80119b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  801843:	85 c0                	test   %eax,%eax
  801845:	75 26                	jne    80186d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  801847:	85 f6                	test   %esi,%esi
  801849:	74 0a                	je     801855 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80184b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801850:	8b 40 74             	mov    0x74(%eax),%eax
  801853:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  801855:	85 db                	test   %ebx,%ebx
  801857:	74 0a                	je     801863 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  801859:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80185e:	8b 40 78             	mov    0x78(%eax),%eax
  801861:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801863:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801868:	8b 40 70             	mov    0x70(%eax),%eax
  80186b:	eb 14                	jmp    801881 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80186d:	85 f6                	test   %esi,%esi
  80186f:	74 06                	je     801877 <ipc_recv+0x57>
			*from_env_store = 0;
  801871:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801877:	85 db                	test   %ebx,%ebx
  801879:	74 06                	je     801881 <ipc_recv+0x61>
			*perm_store = 0;
  80187b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	5b                   	pop    %ebx
  801885:	5e                   	pop    %esi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	57                   	push   %edi
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
  80188e:	83 ec 1c             	sub    $0x1c,%esp
  801891:	8b 7d 08             	mov    0x8(%ebp),%edi
  801894:	8b 75 0c             	mov    0xc(%ebp),%esi
  801897:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80189a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80189c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8018a1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8018a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018b3:	89 3c 24             	mov    %edi,(%esp)
  8018b6:	e8 bd f8 ff ff       	call   801178 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	74 28                	je     8018e7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8018bf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8018c2:	74 1c                	je     8018e0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8018c4:	c7 44 24 08 5c 35 80 	movl   $0x80355c,0x8(%esp)
  8018cb:	00 
  8018cc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8018d3:	00 
  8018d4:	c7 04 24 7d 35 80 00 	movl   $0x80357d,(%esp)
  8018db:	e8 a6 ea ff ff       	call   800386 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8018e0:	e8 61 f6 ff ff       	call   800f46 <sys_yield>
	}
  8018e5:	eb bd                	jmp    8018a4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8018e7:	83 c4 1c             	add    $0x1c,%esp
  8018ea:	5b                   	pop    %ebx
  8018eb:	5e                   	pop    %esi
  8018ec:	5f                   	pop    %edi
  8018ed:	5d                   	pop    %ebp
  8018ee:	c3                   	ret    

008018ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8018fa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8018fd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801903:	8b 52 50             	mov    0x50(%edx),%edx
  801906:	39 ca                	cmp    %ecx,%edx
  801908:	75 0d                	jne    801917 <ipc_find_env+0x28>
			return envs[i].env_id;
  80190a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80190d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801912:	8b 40 40             	mov    0x40(%eax),%eax
  801915:	eb 0e                	jmp    801925 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801917:	83 c0 01             	add    $0x1,%eax
  80191a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80191f:	75 d9                	jne    8018fa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801921:	66 b8 00 00          	mov    $0x0,%ax
}
  801925:	5d                   	pop    %ebp
  801926:	c3                   	ret    
  801927:	66 90                	xchg   %ax,%ax
  801929:	66 90                	xchg   %ax,%ax
  80192b:	66 90                	xchg   %ax,%ax
  80192d:	66 90                	xchg   %ax,%ax
  80192f:	90                   	nop

00801930 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	05 00 00 00 30       	add    $0x30000000,%eax
  80193b:	c1 e8 0c             	shr    $0xc,%eax
}
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    

00801940 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80194b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801950:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801955:	5d                   	pop    %ebp
  801956:	c3                   	ret    

00801957 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80195d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801962:	89 c2                	mov    %eax,%edx
  801964:	c1 ea 16             	shr    $0x16,%edx
  801967:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80196e:	f6 c2 01             	test   $0x1,%dl
  801971:	74 11                	je     801984 <fd_alloc+0x2d>
  801973:	89 c2                	mov    %eax,%edx
  801975:	c1 ea 0c             	shr    $0xc,%edx
  801978:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80197f:	f6 c2 01             	test   $0x1,%dl
  801982:	75 09                	jne    80198d <fd_alloc+0x36>
			*fd_store = fd;
  801984:	89 01                	mov    %eax,(%ecx)
			return 0;
  801986:	b8 00 00 00 00       	mov    $0x0,%eax
  80198b:	eb 17                	jmp    8019a4 <fd_alloc+0x4d>
  80198d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801992:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801997:	75 c9                	jne    801962 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801999:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80199f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    

008019a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8019ac:	83 f8 1f             	cmp    $0x1f,%eax
  8019af:	77 36                	ja     8019e7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8019b1:	c1 e0 0c             	shl    $0xc,%eax
  8019b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8019b9:	89 c2                	mov    %eax,%edx
  8019bb:	c1 ea 16             	shr    $0x16,%edx
  8019be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019c5:	f6 c2 01             	test   $0x1,%dl
  8019c8:	74 24                	je     8019ee <fd_lookup+0x48>
  8019ca:	89 c2                	mov    %eax,%edx
  8019cc:	c1 ea 0c             	shr    $0xc,%edx
  8019cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019d6:	f6 c2 01             	test   $0x1,%dl
  8019d9:	74 1a                	je     8019f5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019de:	89 02                	mov    %eax,(%edx)
	return 0;
  8019e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e5:	eb 13                	jmp    8019fa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8019e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ec:	eb 0c                	jmp    8019fa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8019ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019f3:	eb 05                	jmp    8019fa <fd_lookup+0x54>
  8019f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    

008019fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 18             	sub    $0x18,%esp
  801a02:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801a05:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0a:	eb 13                	jmp    801a1f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  801a0c:	39 08                	cmp    %ecx,(%eax)
  801a0e:	75 0c                	jne    801a1c <dev_lookup+0x20>
			*dev = devtab[i];
  801a10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a13:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	eb 38                	jmp    801a54 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801a1c:	83 c2 01             	add    $0x1,%edx
  801a1f:	8b 04 95 08 36 80 00 	mov    0x803608(,%edx,4),%eax
  801a26:	85 c0                	test   %eax,%eax
  801a28:	75 e2                	jne    801a0c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a2a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a2f:	8b 40 48             	mov    0x48(%eax),%eax
  801a32:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3a:	c7 04 24 88 35 80 00 	movl   $0x803588,(%esp)
  801a41:	e8 39 ea ff ff       	call   80047f <cprintf>
	*dev = 0;
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	56                   	push   %esi
  801a5a:	53                   	push   %ebx
  801a5b:	83 ec 20             	sub    $0x20,%esp
  801a5e:	8b 75 08             	mov    0x8(%ebp),%esi
  801a61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a67:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a6b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a71:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	e8 2a ff ff ff       	call   8019a6 <fd_lookup>
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 05                	js     801a85 <fd_close+0x2f>
	    || fd != fd2)
  801a80:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801a83:	74 0c                	je     801a91 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801a85:	84 db                	test   %bl,%bl
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	0f 44 c2             	cmove  %edx,%eax
  801a8f:	eb 3f                	jmp    801ad0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a98:	8b 06                	mov    (%esi),%eax
  801a9a:	89 04 24             	mov    %eax,(%esp)
  801a9d:	e8 5a ff ff ff       	call   8019fc <dev_lookup>
  801aa2:	89 c3                	mov    %eax,%ebx
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	78 16                	js     801abe <fd_close+0x68>
		if (dev->dev_close)
  801aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801aae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	74 07                	je     801abe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801ab7:	89 34 24             	mov    %esi,(%esp)
  801aba:	ff d0                	call   *%eax
  801abc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801abe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac9:	e8 3e f5 ff ff       	call   80100c <sys_page_unmap>
	return r;
  801ace:	89 d8                	mov    %ebx,%eax
}
  801ad0:	83 c4 20             	add    $0x20,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    

00801ad7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801add:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	89 04 24             	mov    %eax,(%esp)
  801aea:	e8 b7 fe ff ff       	call   8019a6 <fd_lookup>
  801aef:	89 c2                	mov    %eax,%edx
  801af1:	85 d2                	test   %edx,%edx
  801af3:	78 13                	js     801b08 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801af5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801afc:	00 
  801afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b00:	89 04 24             	mov    %eax,(%esp)
  801b03:	e8 4e ff ff ff       	call   801a56 <fd_close>
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <close_all>:

void
close_all(void)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	53                   	push   %ebx
  801b0e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b11:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b16:	89 1c 24             	mov    %ebx,(%esp)
  801b19:	e8 b9 ff ff ff       	call   801ad7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801b1e:	83 c3 01             	add    $0x1,%ebx
  801b21:	83 fb 20             	cmp    $0x20,%ebx
  801b24:	75 f0                	jne    801b16 <close_all+0xc>
		close(i);
}
  801b26:	83 c4 14             	add    $0x14,%esp
  801b29:	5b                   	pop    %ebx
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    

00801b2c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	57                   	push   %edi
  801b30:	56                   	push   %esi
  801b31:	53                   	push   %ebx
  801b32:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b35:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	89 04 24             	mov    %eax,(%esp)
  801b42:	e8 5f fe ff ff       	call   8019a6 <fd_lookup>
  801b47:	89 c2                	mov    %eax,%edx
  801b49:	85 d2                	test   %edx,%edx
  801b4b:	0f 88 e1 00 00 00    	js     801c32 <dup+0x106>
		return r;
	close(newfdnum);
  801b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b54:	89 04 24             	mov    %eax,(%esp)
  801b57:	e8 7b ff ff ff       	call   801ad7 <close>

	newfd = INDEX2FD(newfdnum);
  801b5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b5f:	c1 e3 0c             	shl    $0xc,%ebx
  801b62:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b6b:	89 04 24             	mov    %eax,(%esp)
  801b6e:	e8 cd fd ff ff       	call   801940 <fd2data>
  801b73:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801b75:	89 1c 24             	mov    %ebx,(%esp)
  801b78:	e8 c3 fd ff ff       	call   801940 <fd2data>
  801b7d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b7f:	89 f0                	mov    %esi,%eax
  801b81:	c1 e8 16             	shr    $0x16,%eax
  801b84:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b8b:	a8 01                	test   $0x1,%al
  801b8d:	74 43                	je     801bd2 <dup+0xa6>
  801b8f:	89 f0                	mov    %esi,%eax
  801b91:	c1 e8 0c             	shr    $0xc,%eax
  801b94:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b9b:	f6 c2 01             	test   $0x1,%dl
  801b9e:	74 32                	je     801bd2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ba0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ba7:	25 07 0e 00 00       	and    $0xe07,%eax
  801bac:	89 44 24 10          	mov    %eax,0x10(%esp)
  801bb0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bb4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bbb:	00 
  801bbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc7:	e8 ed f3 ff ff       	call   800fb9 <sys_page_map>
  801bcc:	89 c6                	mov    %eax,%esi
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	78 3e                	js     801c10 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd5:	89 c2                	mov    %eax,%edx
  801bd7:	c1 ea 0c             	shr    $0xc,%edx
  801bda:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801be1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801be7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801beb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801bef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bf6:	00 
  801bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c02:	e8 b2 f3 ff ff       	call   800fb9 <sys_page_map>
  801c07:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801c09:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c0c:	85 f6                	test   %esi,%esi
  801c0e:	79 22                	jns    801c32 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801c10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c1b:	e8 ec f3 ff ff       	call   80100c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c2b:	e8 dc f3 ff ff       	call   80100c <sys_page_unmap>
	return r;
  801c30:	89 f0                	mov    %esi,%eax
}
  801c32:	83 c4 3c             	add    $0x3c,%esp
  801c35:	5b                   	pop    %ebx
  801c36:	5e                   	pop    %esi
  801c37:	5f                   	pop    %edi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    

00801c3a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 24             	sub    $0x24,%esp
  801c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4b:	89 1c 24             	mov    %ebx,(%esp)
  801c4e:	e8 53 fd ff ff       	call   8019a6 <fd_lookup>
  801c53:	89 c2                	mov    %eax,%edx
  801c55:	85 d2                	test   %edx,%edx
  801c57:	78 6d                	js     801cc6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c63:	8b 00                	mov    (%eax),%eax
  801c65:	89 04 24             	mov    %eax,(%esp)
  801c68:	e8 8f fd ff ff       	call   8019fc <dev_lookup>
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	78 55                	js     801cc6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c74:	8b 50 08             	mov    0x8(%eax),%edx
  801c77:	83 e2 03             	and    $0x3,%edx
  801c7a:	83 fa 01             	cmp    $0x1,%edx
  801c7d:	75 23                	jne    801ca2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c7f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801c84:	8b 40 48             	mov    0x48(%eax),%eax
  801c87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8f:	c7 04 24 cc 35 80 00 	movl   $0x8035cc,(%esp)
  801c96:	e8 e4 e7 ff ff       	call   80047f <cprintf>
		return -E_INVAL;
  801c9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ca0:	eb 24                	jmp    801cc6 <read+0x8c>
	}
	if (!dev->dev_read)
  801ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca5:	8b 52 08             	mov    0x8(%edx),%edx
  801ca8:	85 d2                	test   %edx,%edx
  801caa:	74 15                	je     801cc1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801cac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801caf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cba:	89 04 24             	mov    %eax,(%esp)
  801cbd:	ff d2                	call   *%edx
  801cbf:	eb 05                	jmp    801cc6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801cc1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801cc6:	83 c4 24             	add    $0x24,%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    

00801ccc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	57                   	push   %edi
  801cd0:	56                   	push   %esi
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 1c             	sub    $0x1c,%esp
  801cd5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cd8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ce0:	eb 23                	jmp    801d05 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ce2:	89 f0                	mov    %esi,%eax
  801ce4:	29 d8                	sub    %ebx,%eax
  801ce6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cea:	89 d8                	mov    %ebx,%eax
  801cec:	03 45 0c             	add    0xc(%ebp),%eax
  801cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf3:	89 3c 24             	mov    %edi,(%esp)
  801cf6:	e8 3f ff ff ff       	call   801c3a <read>
		if (m < 0)
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 10                	js     801d0f <readn+0x43>
			return m;
		if (m == 0)
  801cff:	85 c0                	test   %eax,%eax
  801d01:	74 0a                	je     801d0d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801d03:	01 c3                	add    %eax,%ebx
  801d05:	39 f3                	cmp    %esi,%ebx
  801d07:	72 d9                	jb     801ce2 <readn+0x16>
  801d09:	89 d8                	mov    %ebx,%eax
  801d0b:	eb 02                	jmp    801d0f <readn+0x43>
  801d0d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801d0f:	83 c4 1c             	add    $0x1c,%esp
  801d12:	5b                   	pop    %ebx
  801d13:	5e                   	pop    %esi
  801d14:	5f                   	pop    %edi
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    

00801d17 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	53                   	push   %ebx
  801d1b:	83 ec 24             	sub    $0x24,%esp
  801d1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d21:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	89 1c 24             	mov    %ebx,(%esp)
  801d2b:	e8 76 fc ff ff       	call   8019a6 <fd_lookup>
  801d30:	89 c2                	mov    %eax,%edx
  801d32:	85 d2                	test   %edx,%edx
  801d34:	78 68                	js     801d9e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d40:	8b 00                	mov    (%eax),%eax
  801d42:	89 04 24             	mov    %eax,(%esp)
  801d45:	e8 b2 fc ff ff       	call   8019fc <dev_lookup>
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	78 50                	js     801d9e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d51:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d55:	75 23                	jne    801d7a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d57:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801d5c:	8b 40 48             	mov    0x48(%eax),%eax
  801d5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d67:	c7 04 24 e8 35 80 00 	movl   $0x8035e8,(%esp)
  801d6e:	e8 0c e7 ff ff       	call   80047f <cprintf>
		return -E_INVAL;
  801d73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d78:	eb 24                	jmp    801d9e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d7d:	8b 52 0c             	mov    0xc(%edx),%edx
  801d80:	85 d2                	test   %edx,%edx
  801d82:	74 15                	je     801d99 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d92:	89 04 24             	mov    %eax,(%esp)
  801d95:	ff d2                	call   *%edx
  801d97:	eb 05                	jmp    801d9e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801d99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801d9e:	83 c4 24             	add    $0x24,%esp
  801da1:	5b                   	pop    %ebx
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801daa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	89 04 24             	mov    %eax,(%esp)
  801db7:	e8 ea fb ff ff       	call   8019a6 <fd_lookup>
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 0e                	js     801dce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 24             	sub    $0x24,%esp
  801dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dda:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de1:	89 1c 24             	mov    %ebx,(%esp)
  801de4:	e8 bd fb ff ff       	call   8019a6 <fd_lookup>
  801de9:	89 c2                	mov    %eax,%edx
  801deb:	85 d2                	test   %edx,%edx
  801ded:	78 61                	js     801e50 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801def:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df9:	8b 00                	mov    (%eax),%eax
  801dfb:	89 04 24             	mov    %eax,(%esp)
  801dfe:	e8 f9 fb ff ff       	call   8019fc <dev_lookup>
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 49                	js     801e50 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e0e:	75 23                	jne    801e33 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801e10:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e15:	8b 40 48             	mov    0x48(%eax),%eax
  801e18:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e20:	c7 04 24 a8 35 80 00 	movl   $0x8035a8,(%esp)
  801e27:	e8 53 e6 ff ff       	call   80047f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801e2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e31:	eb 1d                	jmp    801e50 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801e33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e36:	8b 52 18             	mov    0x18(%edx),%edx
  801e39:	85 d2                	test   %edx,%edx
  801e3b:	74 0e                	je     801e4b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e40:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e44:	89 04 24             	mov    %eax,(%esp)
  801e47:	ff d2                	call   *%edx
  801e49:	eb 05                	jmp    801e50 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801e4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801e50:	83 c4 24             	add    $0x24,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    

00801e56 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	53                   	push   %ebx
  801e5a:	83 ec 24             	sub    $0x24,%esp
  801e5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	89 04 24             	mov    %eax,(%esp)
  801e6d:	e8 34 fb ff ff       	call   8019a6 <fd_lookup>
  801e72:	89 c2                	mov    %eax,%edx
  801e74:	85 d2                	test   %edx,%edx
  801e76:	78 52                	js     801eca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e82:	8b 00                	mov    (%eax),%eax
  801e84:	89 04 24             	mov    %eax,(%esp)
  801e87:	e8 70 fb ff ff       	call   8019fc <dev_lookup>
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	78 3a                	js     801eca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e93:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e97:	74 2c                	je     801ec5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e99:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e9c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ea3:	00 00 00 
	stat->st_isdir = 0;
  801ea6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ead:	00 00 00 
	stat->st_dev = dev;
  801eb0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801eb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ebd:	89 14 24             	mov    %edx,(%esp)
  801ec0:	ff 50 14             	call   *0x14(%eax)
  801ec3:	eb 05                	jmp    801eca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ec5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801eca:	83 c4 24             	add    $0x24,%esp
  801ecd:	5b                   	pop    %ebx
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    

00801ed0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	56                   	push   %esi
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ed8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801edf:	00 
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	89 04 24             	mov    %eax,(%esp)
  801ee6:	e8 99 02 00 00       	call   802184 <open>
  801eeb:	89 c3                	mov    %eax,%ebx
  801eed:	85 db                	test   %ebx,%ebx
  801eef:	78 1b                	js     801f0c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef8:	89 1c 24             	mov    %ebx,(%esp)
  801efb:	e8 56 ff ff ff       	call   801e56 <fstat>
  801f00:	89 c6                	mov    %eax,%esi
	close(fd);
  801f02:	89 1c 24             	mov    %ebx,(%esp)
  801f05:	e8 cd fb ff ff       	call   801ad7 <close>
	return r;
  801f0a:	89 f0                	mov    %esi,%eax
}
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5e                   	pop    %esi
  801f11:	5d                   	pop    %ebp
  801f12:	c3                   	ret    

00801f13 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	56                   	push   %esi
  801f17:	53                   	push   %ebx
  801f18:	83 ec 10             	sub    $0x10,%esp
  801f1b:	89 c6                	mov    %eax,%esi
  801f1d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801f1f:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f26:	75 11                	jne    801f39 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801f2f:	e8 bb f9 ff ff       	call   8018ef <ipc_find_env>
  801f34:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f39:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f40:	00 
  801f41:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801f48:	00 
  801f49:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f4d:	a1 04 50 80 00       	mov    0x805004,%eax
  801f52:	89 04 24             	mov    %eax,(%esp)
  801f55:	e8 2e f9 ff ff       	call   801888 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f61:	00 
  801f62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f6d:	e8 ae f8 ff ff       	call   801820 <ipc_recv>
}
  801f72:	83 c4 10             	add    $0x10,%esp
  801f75:	5b                   	pop    %ebx
  801f76:	5e                   	pop    %esi
  801f77:	5d                   	pop    %ebp
  801f78:	c3                   	ret    

00801f79 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	8b 40 0c             	mov    0xc(%eax),%eax
  801f85:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f92:	ba 00 00 00 00       	mov    $0x0,%edx
  801f97:	b8 02 00 00 00       	mov    $0x2,%eax
  801f9c:	e8 72 ff ff ff       	call   801f13 <fsipc>
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	8b 40 0c             	mov    0xc(%eax),%eax
  801faf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801fb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb9:	b8 06 00 00 00       	mov    $0x6,%eax
  801fbe:	e8 50 ff ff ff       	call   801f13 <fsipc>
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	53                   	push   %ebx
  801fc9:	83 ec 14             	sub    $0x14,%esp
  801fcc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801fda:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdf:	b8 05 00 00 00       	mov    $0x5,%eax
  801fe4:	e8 2a ff ff ff       	call   801f13 <fsipc>
  801fe9:	89 c2                	mov    %eax,%edx
  801feb:	85 d2                	test   %edx,%edx
  801fed:	78 2b                	js     80201a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fef:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ff6:	00 
  801ff7:	89 1c 24             	mov    %ebx,(%esp)
  801ffa:	e8 f8 ea ff ff       	call   800af7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801fff:	a1 80 60 80 00       	mov    0x806080,%eax
  802004:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80200a:	a1 84 60 80 00       	mov    0x806084,%eax
  80200f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201a:	83 c4 14             	add    $0x14,%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    

00802020 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	53                   	push   %ebx
  802024:	83 ec 14             	sub    $0x14,%esp
  802027:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80202a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  802030:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  802035:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802038:	8b 55 08             	mov    0x8(%ebp),%edx
  80203b:	8b 52 0c             	mov    0xc(%edx),%edx
  80203e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  802044:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  802049:	89 44 24 08          	mov    %eax,0x8(%esp)
  80204d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802050:	89 44 24 04          	mov    %eax,0x4(%esp)
  802054:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80205b:	e8 34 ec ff ff       	call   800c94 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  802060:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  802067:	00 
  802068:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  80206f:	e8 0b e4 ff ff       	call   80047f <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802074:	ba 00 00 00 00       	mov    $0x0,%edx
  802079:	b8 04 00 00 00       	mov    $0x4,%eax
  80207e:	e8 90 fe ff ff       	call   801f13 <fsipc>
  802083:	85 c0                	test   %eax,%eax
  802085:	78 53                	js     8020da <devfile_write+0xba>
		return r;
	assert(r <= n);
  802087:	39 c3                	cmp    %eax,%ebx
  802089:	73 24                	jae    8020af <devfile_write+0x8f>
  80208b:	c7 44 24 0c 21 36 80 	movl   $0x803621,0xc(%esp)
  802092:	00 
  802093:	c7 44 24 08 28 36 80 	movl   $0x803628,0x8(%esp)
  80209a:	00 
  80209b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8020a2:	00 
  8020a3:	c7 04 24 3d 36 80 00 	movl   $0x80363d,(%esp)
  8020aa:	e8 d7 e2 ff ff       	call   800386 <_panic>
	assert(r <= PGSIZE);
  8020af:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020b4:	7e 24                	jle    8020da <devfile_write+0xba>
  8020b6:	c7 44 24 0c 48 36 80 	movl   $0x803648,0xc(%esp)
  8020bd:	00 
  8020be:	c7 44 24 08 28 36 80 	movl   $0x803628,0x8(%esp)
  8020c5:	00 
  8020c6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8020cd:	00 
  8020ce:	c7 04 24 3d 36 80 00 	movl   $0x80363d,(%esp)
  8020d5:	e8 ac e2 ff ff       	call   800386 <_panic>
	return r;
}
  8020da:	83 c4 14             	add    $0x14,%esp
  8020dd:	5b                   	pop    %ebx
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    

008020e0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	56                   	push   %esi
  8020e4:	53                   	push   %ebx
  8020e5:	83 ec 10             	sub    $0x10,%esp
  8020e8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8020f6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8020fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802101:	b8 03 00 00 00       	mov    $0x3,%eax
  802106:	e8 08 fe ff ff       	call   801f13 <fsipc>
  80210b:	89 c3                	mov    %eax,%ebx
  80210d:	85 c0                	test   %eax,%eax
  80210f:	78 6a                	js     80217b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802111:	39 c6                	cmp    %eax,%esi
  802113:	73 24                	jae    802139 <devfile_read+0x59>
  802115:	c7 44 24 0c 21 36 80 	movl   $0x803621,0xc(%esp)
  80211c:	00 
  80211d:	c7 44 24 08 28 36 80 	movl   $0x803628,0x8(%esp)
  802124:	00 
  802125:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80212c:	00 
  80212d:	c7 04 24 3d 36 80 00 	movl   $0x80363d,(%esp)
  802134:	e8 4d e2 ff ff       	call   800386 <_panic>
	assert(r <= PGSIZE);
  802139:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80213e:	7e 24                	jle    802164 <devfile_read+0x84>
  802140:	c7 44 24 0c 48 36 80 	movl   $0x803648,0xc(%esp)
  802147:	00 
  802148:	c7 44 24 08 28 36 80 	movl   $0x803628,0x8(%esp)
  80214f:	00 
  802150:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802157:	00 
  802158:	c7 04 24 3d 36 80 00 	movl   $0x80363d,(%esp)
  80215f:	e8 22 e2 ff ff       	call   800386 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802164:	89 44 24 08          	mov    %eax,0x8(%esp)
  802168:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80216f:	00 
  802170:	8b 45 0c             	mov    0xc(%ebp),%eax
  802173:	89 04 24             	mov    %eax,(%esp)
  802176:	e8 19 eb ff ff       	call   800c94 <memmove>
	return r;
}
  80217b:	89 d8                	mov    %ebx,%eax
  80217d:	83 c4 10             	add    $0x10,%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    

00802184 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	53                   	push   %ebx
  802188:	83 ec 24             	sub    $0x24,%esp
  80218b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80218e:	89 1c 24             	mov    %ebx,(%esp)
  802191:	e8 2a e9 ff ff       	call   800ac0 <strlen>
  802196:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80219b:	7f 60                	jg     8021fd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80219d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a0:	89 04 24             	mov    %eax,(%esp)
  8021a3:	e8 af f7 ff ff       	call   801957 <fd_alloc>
  8021a8:	89 c2                	mov    %eax,%edx
  8021aa:	85 d2                	test   %edx,%edx
  8021ac:	78 54                	js     802202 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8021ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021b2:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  8021b9:	e8 39 e9 ff ff       	call   800af7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8021be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8021c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ce:	e8 40 fd ff ff       	call   801f13 <fsipc>
  8021d3:	89 c3                	mov    %eax,%ebx
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	79 17                	jns    8021f0 <open+0x6c>
		fd_close(fd, 0);
  8021d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021e0:	00 
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	89 04 24             	mov    %eax,(%esp)
  8021e7:	e8 6a f8 ff ff       	call   801a56 <fd_close>
		return r;
  8021ec:	89 d8                	mov    %ebx,%eax
  8021ee:	eb 12                	jmp    802202 <open+0x7e>
	}

	return fd2num(fd);
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	89 04 24             	mov    %eax,(%esp)
  8021f6:	e8 35 f7 ff ff       	call   801930 <fd2num>
  8021fb:	eb 05                	jmp    802202 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8021fd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802202:	83 c4 24             	add    $0x24,%esp
  802205:	5b                   	pop    %ebx
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    

00802208 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80220e:	ba 00 00 00 00       	mov    $0x0,%edx
  802213:	b8 08 00 00 00       	mov    $0x8,%eax
  802218:	e8 f6 fc ff ff       	call   801f13 <fsipc>
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <evict>:

int evict(void)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802225:	c7 04 24 54 36 80 00 	movl   $0x803654,(%esp)
  80222c:	e8 4e e2 ff ff       	call   80047f <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802231:	ba 00 00 00 00       	mov    $0x0,%edx
  802236:	b8 09 00 00 00       	mov    $0x9,%eax
  80223b:	e8 d3 fc ff ff       	call   801f13 <fsipc>
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    
  802242:	66 90                	xchg   %ax,%ax
  802244:	66 90                	xchg   %ax,%ax
  802246:	66 90                	xchg   %ax,%ax
  802248:	66 90                	xchg   %ax,%ax
  80224a:	66 90                	xchg   %ax,%ax
  80224c:	66 90                	xchg   %ax,%ax
  80224e:	66 90                	xchg   %ax,%ax

00802250 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802256:	c7 44 24 04 6d 36 80 	movl   $0x80366d,0x4(%esp)
  80225d:	00 
  80225e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802261:	89 04 24             	mov    %eax,(%esp)
  802264:	e8 8e e8 ff ff       	call   800af7 <strcpy>
	return 0;
}
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	53                   	push   %ebx
  802274:	83 ec 14             	sub    $0x14,%esp
  802277:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80227a:	89 1c 24             	mov    %ebx,(%esp)
  80227d:	e8 bd 0a 00 00       	call   802d3f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802282:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802287:	83 f8 01             	cmp    $0x1,%eax
  80228a:	75 0d                	jne    802299 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80228c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80228f:	89 04 24             	mov    %eax,(%esp)
  802292:	e8 29 03 00 00       	call   8025c0 <nsipc_close>
  802297:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802299:	89 d0                	mov    %edx,%eax
  80229b:	83 c4 14             	add    $0x14,%esp
  80229e:	5b                   	pop    %ebx
  80229f:	5d                   	pop    %ebp
  8022a0:	c3                   	ret    

008022a1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8022a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022ae:	00 
  8022af:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c3:	89 04 24             	mov    %eax,(%esp)
  8022c6:	e8 f0 03 00 00       	call   8026bb <nsipc_send>
}
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8022d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022da:	00 
  8022db:	8b 45 10             	mov    0x10(%ebp),%eax
  8022de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ef:	89 04 24             	mov    %eax,(%esp)
  8022f2:	e8 44 03 00 00       	call   80263b <nsipc_recv>
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8022ff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802302:	89 54 24 04          	mov    %edx,0x4(%esp)
  802306:	89 04 24             	mov    %eax,(%esp)
  802309:	e8 98 f6 ff ff       	call   8019a6 <fd_lookup>
  80230e:	85 c0                	test   %eax,%eax
  802310:	78 17                	js     802329 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80231b:	39 08                	cmp    %ecx,(%eax)
  80231d:	75 05                	jne    802324 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80231f:	8b 40 0c             	mov    0xc(%eax),%eax
  802322:	eb 05                	jmp    802329 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802324:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	56                   	push   %esi
  80232f:	53                   	push   %ebx
  802330:	83 ec 20             	sub    $0x20,%esp
  802333:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802335:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802338:	89 04 24             	mov    %eax,(%esp)
  80233b:	e8 17 f6 ff ff       	call   801957 <fd_alloc>
  802340:	89 c3                	mov    %eax,%ebx
  802342:	85 c0                	test   %eax,%eax
  802344:	78 21                	js     802367 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802346:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80234d:	00 
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	89 44 24 04          	mov    %eax,0x4(%esp)
  802355:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80235c:	e8 04 ec ff ff       	call   800f65 <sys_page_alloc>
  802361:	89 c3                	mov    %eax,%ebx
  802363:	85 c0                	test   %eax,%eax
  802365:	79 0c                	jns    802373 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802367:	89 34 24             	mov    %esi,(%esp)
  80236a:	e8 51 02 00 00       	call   8025c0 <nsipc_close>
		return r;
  80236f:	89 d8                	mov    %ebx,%eax
  802371:	eb 20                	jmp    802393 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802373:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80237e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802381:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802388:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80238b:	89 14 24             	mov    %edx,(%esp)
  80238e:	e8 9d f5 ff ff       	call   801930 <fd2num>
}
  802393:	83 c4 20             	add    $0x20,%esp
  802396:	5b                   	pop    %ebx
  802397:	5e                   	pop    %esi
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    

0080239a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	e8 51 ff ff ff       	call   8022f9 <fd2sockid>
		return r;
  8023a8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	78 23                	js     8023d1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8023ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8023b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023bc:	89 04 24             	mov    %eax,(%esp)
  8023bf:	e8 45 01 00 00       	call   802509 <nsipc_accept>
		return r;
  8023c4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	78 07                	js     8023d1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8023ca:	e8 5c ff ff ff       	call   80232b <alloc_sockfd>
  8023cf:	89 c1                	mov    %eax,%ecx
}
  8023d1:	89 c8                	mov    %ecx,%eax
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
  8023d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	e8 16 ff ff ff       	call   8022f9 <fd2sockid>
  8023e3:	89 c2                	mov    %eax,%edx
  8023e5:	85 d2                	test   %edx,%edx
  8023e7:	78 16                	js     8023ff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8023e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f7:	89 14 24             	mov    %edx,(%esp)
  8023fa:	e8 60 01 00 00       	call   80255f <nsipc_bind>
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <shutdown>:

int
shutdown(int s, int how)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	e8 ea fe ff ff       	call   8022f9 <fd2sockid>
  80240f:	89 c2                	mov    %eax,%edx
  802411:	85 d2                	test   %edx,%edx
  802413:	78 0f                	js     802424 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802415:	8b 45 0c             	mov    0xc(%ebp),%eax
  802418:	89 44 24 04          	mov    %eax,0x4(%esp)
  80241c:	89 14 24             	mov    %edx,(%esp)
  80241f:	e8 7a 01 00 00       	call   80259e <nsipc_shutdown>
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80242c:	8b 45 08             	mov    0x8(%ebp),%eax
  80242f:	e8 c5 fe ff ff       	call   8022f9 <fd2sockid>
  802434:	89 c2                	mov    %eax,%edx
  802436:	85 d2                	test   %edx,%edx
  802438:	78 16                	js     802450 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80243a:	8b 45 10             	mov    0x10(%ebp),%eax
  80243d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802441:	8b 45 0c             	mov    0xc(%ebp),%eax
  802444:	89 44 24 04          	mov    %eax,0x4(%esp)
  802448:	89 14 24             	mov    %edx,(%esp)
  80244b:	e8 8a 01 00 00       	call   8025da <nsipc_connect>
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <listen>:

int
listen(int s, int backlog)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	e8 99 fe ff ff       	call   8022f9 <fd2sockid>
  802460:	89 c2                	mov    %eax,%edx
  802462:	85 d2                	test   %edx,%edx
  802464:	78 0f                	js     802475 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802466:	8b 45 0c             	mov    0xc(%ebp),%eax
  802469:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246d:	89 14 24             	mov    %edx,(%esp)
  802470:	e8 a4 01 00 00       	call   802619 <nsipc_listen>
}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80247d:	8b 45 10             	mov    0x10(%ebp),%eax
  802480:	89 44 24 08          	mov    %eax,0x8(%esp)
  802484:	8b 45 0c             	mov    0xc(%ebp),%eax
  802487:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	89 04 24             	mov    %eax,(%esp)
  802491:	e8 98 02 00 00       	call   80272e <nsipc_socket>
  802496:	89 c2                	mov    %eax,%edx
  802498:	85 d2                	test   %edx,%edx
  80249a:	78 05                	js     8024a1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80249c:	e8 8a fe ff ff       	call   80232b <alloc_sockfd>
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	53                   	push   %ebx
  8024a7:	83 ec 14             	sub    $0x14,%esp
  8024aa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8024ac:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  8024b3:	75 11                	jne    8024c6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8024b5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8024bc:	e8 2e f4 ff ff       	call   8018ef <ipc_find_env>
  8024c1:	a3 08 50 80 00       	mov    %eax,0x805008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8024c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8024cd:	00 
  8024ce:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8024d5:	00 
  8024d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024da:	a1 08 50 80 00       	mov    0x805008,%eax
  8024df:	89 04 24             	mov    %eax,(%esp)
  8024e2:	e8 a1 f3 ff ff       	call   801888 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8024e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024ee:	00 
  8024ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024f6:	00 
  8024f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024fe:	e8 1d f3 ff ff       	call   801820 <ipc_recv>
}
  802503:	83 c4 14             	add    $0x14,%esp
  802506:	5b                   	pop    %ebx
  802507:	5d                   	pop    %ebp
  802508:	c3                   	ret    

00802509 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	56                   	push   %esi
  80250d:	53                   	push   %ebx
  80250e:	83 ec 10             	sub    $0x10,%esp
  802511:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80251c:	8b 06                	mov    (%esi),%eax
  80251e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802523:	b8 01 00 00 00       	mov    $0x1,%eax
  802528:	e8 76 ff ff ff       	call   8024a3 <nsipc>
  80252d:	89 c3                	mov    %eax,%ebx
  80252f:	85 c0                	test   %eax,%eax
  802531:	78 23                	js     802556 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802533:	a1 10 70 80 00       	mov    0x807010,%eax
  802538:	89 44 24 08          	mov    %eax,0x8(%esp)
  80253c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802543:	00 
  802544:	8b 45 0c             	mov    0xc(%ebp),%eax
  802547:	89 04 24             	mov    %eax,(%esp)
  80254a:	e8 45 e7 ff ff       	call   800c94 <memmove>
		*addrlen = ret->ret_addrlen;
  80254f:	a1 10 70 80 00       	mov    0x807010,%eax
  802554:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802556:	89 d8                	mov    %ebx,%eax
  802558:	83 c4 10             	add    $0x10,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5d                   	pop    %ebp
  80255e:	c3                   	ret    

0080255f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	53                   	push   %ebx
  802563:	83 ec 14             	sub    $0x14,%esp
  802566:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802571:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802575:	8b 45 0c             	mov    0xc(%ebp),%eax
  802578:	89 44 24 04          	mov    %eax,0x4(%esp)
  80257c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802583:	e8 0c e7 ff ff       	call   800c94 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802588:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80258e:	b8 02 00 00 00       	mov    $0x2,%eax
  802593:	e8 0b ff ff ff       	call   8024a3 <nsipc>
}
  802598:	83 c4 14             	add    $0x14,%esp
  80259b:	5b                   	pop    %ebx
  80259c:	5d                   	pop    %ebp
  80259d:	c3                   	ret    

0080259e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
  8025a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8025ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025af:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8025b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8025b9:	e8 e5 fe ff ff       	call   8024a3 <nsipc>
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8025ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8025d3:	e8 cb fe ff ff       	call   8024a3 <nsipc>
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	53                   	push   %ebx
  8025de:	83 ec 14             	sub    $0x14,%esp
  8025e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8025ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8025fe:	e8 91 e6 ff ff       	call   800c94 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802603:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802609:	b8 05 00 00 00       	mov    $0x5,%eax
  80260e:	e8 90 fe ff ff       	call   8024a3 <nsipc>
}
  802613:	83 c4 14             	add    $0x14,%esp
  802616:	5b                   	pop    %ebx
  802617:	5d                   	pop    %ebp
  802618:	c3                   	ret    

00802619 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80262f:	b8 06 00 00 00       	mov    $0x6,%eax
  802634:	e8 6a fe ff ff       	call   8024a3 <nsipc>
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	56                   	push   %esi
  80263f:	53                   	push   %ebx
  802640:	83 ec 10             	sub    $0x10,%esp
  802643:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80264e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802654:	8b 45 14             	mov    0x14(%ebp),%eax
  802657:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80265c:	b8 07 00 00 00       	mov    $0x7,%eax
  802661:	e8 3d fe ff ff       	call   8024a3 <nsipc>
  802666:	89 c3                	mov    %eax,%ebx
  802668:	85 c0                	test   %eax,%eax
  80266a:	78 46                	js     8026b2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80266c:	39 f0                	cmp    %esi,%eax
  80266e:	7f 07                	jg     802677 <nsipc_recv+0x3c>
  802670:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802675:	7e 24                	jle    80269b <nsipc_recv+0x60>
  802677:	c7 44 24 0c 79 36 80 	movl   $0x803679,0xc(%esp)
  80267e:	00 
  80267f:	c7 44 24 08 28 36 80 	movl   $0x803628,0x8(%esp)
  802686:	00 
  802687:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80268e:	00 
  80268f:	c7 04 24 8e 36 80 00 	movl   $0x80368e,(%esp)
  802696:	e8 eb dc ff ff       	call   800386 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80269b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80269f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8026a6:	00 
  8026a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026aa:	89 04 24             	mov    %eax,(%esp)
  8026ad:	e8 e2 e5 ff ff       	call   800c94 <memmove>
	}

	return r;
}
  8026b2:	89 d8                	mov    %ebx,%eax
  8026b4:	83 c4 10             	add    $0x10,%esp
  8026b7:	5b                   	pop    %ebx
  8026b8:	5e                   	pop    %esi
  8026b9:	5d                   	pop    %ebp
  8026ba:	c3                   	ret    

008026bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	53                   	push   %ebx
  8026bf:	83 ec 14             	sub    $0x14,%esp
  8026c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8026cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8026d3:	7e 24                	jle    8026f9 <nsipc_send+0x3e>
  8026d5:	c7 44 24 0c 9a 36 80 	movl   $0x80369a,0xc(%esp)
  8026dc:	00 
  8026dd:	c7 44 24 08 28 36 80 	movl   $0x803628,0x8(%esp)
  8026e4:	00 
  8026e5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8026ec:	00 
  8026ed:	c7 04 24 8e 36 80 00 	movl   $0x80368e,(%esp)
  8026f4:	e8 8d dc ff ff       	call   800386 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8026f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802700:	89 44 24 04          	mov    %eax,0x4(%esp)
  802704:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80270b:	e8 84 e5 ff ff       	call   800c94 <memmove>
	nsipcbuf.send.req_size = size;
  802710:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802716:	8b 45 14             	mov    0x14(%ebp),%eax
  802719:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80271e:	b8 08 00 00 00       	mov    $0x8,%eax
  802723:	e8 7b fd ff ff       	call   8024a3 <nsipc>
}
  802728:	83 c4 14             	add    $0x14,%esp
  80272b:	5b                   	pop    %ebx
  80272c:	5d                   	pop    %ebp
  80272d:	c3                   	ret    

0080272e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80273c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802744:	8b 45 10             	mov    0x10(%ebp),%eax
  802747:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80274c:	b8 09 00 00 00       	mov    $0x9,%eax
  802751:	e8 4d fd ff ff       	call   8024a3 <nsipc>
}
  802756:	c9                   	leave  
  802757:	c3                   	ret    

00802758 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
  80275b:	56                   	push   %esi
  80275c:	53                   	push   %ebx
  80275d:	83 ec 10             	sub    $0x10,%esp
  802760:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802763:	8b 45 08             	mov    0x8(%ebp),%eax
  802766:	89 04 24             	mov    %eax,(%esp)
  802769:	e8 d2 f1 ff ff       	call   801940 <fd2data>
  80276e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802770:	c7 44 24 04 a6 36 80 	movl   $0x8036a6,0x4(%esp)
  802777:	00 
  802778:	89 1c 24             	mov    %ebx,(%esp)
  80277b:	e8 77 e3 ff ff       	call   800af7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802780:	8b 46 04             	mov    0x4(%esi),%eax
  802783:	2b 06                	sub    (%esi),%eax
  802785:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80278b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802792:	00 00 00 
	stat->st_dev = &devpipe;
  802795:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80279c:	40 80 00 
	return 0;
}
  80279f:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a4:	83 c4 10             	add    $0x10,%esp
  8027a7:	5b                   	pop    %ebx
  8027a8:	5e                   	pop    %esi
  8027a9:	5d                   	pop    %ebp
  8027aa:	c3                   	ret    

008027ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
  8027ae:	53                   	push   %ebx
  8027af:	83 ec 14             	sub    $0x14,%esp
  8027b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027c0:	e8 47 e8 ff ff       	call   80100c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8027c5:	89 1c 24             	mov    %ebx,(%esp)
  8027c8:	e8 73 f1 ff ff       	call   801940 <fd2data>
  8027cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d8:	e8 2f e8 ff ff       	call   80100c <sys_page_unmap>
}
  8027dd:	83 c4 14             	add    $0x14,%esp
  8027e0:	5b                   	pop    %ebx
  8027e1:	5d                   	pop    %ebp
  8027e2:	c3                   	ret    

008027e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	57                   	push   %edi
  8027e7:	56                   	push   %esi
  8027e8:	53                   	push   %ebx
  8027e9:	83 ec 2c             	sub    $0x2c,%esp
  8027ec:	89 c6                	mov    %eax,%esi
  8027ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8027f1:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8027f9:	89 34 24             	mov    %esi,(%esp)
  8027fc:	e8 3e 05 00 00       	call   802d3f <pageref>
  802801:	89 c7                	mov    %eax,%edi
  802803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802806:	89 04 24             	mov    %eax,(%esp)
  802809:	e8 31 05 00 00       	call   802d3f <pageref>
  80280e:	39 c7                	cmp    %eax,%edi
  802810:	0f 94 c2             	sete   %dl
  802813:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802816:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  80281c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80281f:	39 fb                	cmp    %edi,%ebx
  802821:	74 21                	je     802844 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802823:	84 d2                	test   %dl,%dl
  802825:	74 ca                	je     8027f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802827:	8b 51 58             	mov    0x58(%ecx),%edx
  80282a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80282e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802832:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802836:	c7 04 24 ad 36 80 00 	movl   $0x8036ad,(%esp)
  80283d:	e8 3d dc ff ff       	call   80047f <cprintf>
  802842:	eb ad                	jmp    8027f1 <_pipeisclosed+0xe>
	}
}
  802844:	83 c4 2c             	add    $0x2c,%esp
  802847:	5b                   	pop    %ebx
  802848:	5e                   	pop    %esi
  802849:	5f                   	pop    %edi
  80284a:	5d                   	pop    %ebp
  80284b:	c3                   	ret    

0080284c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
  80284f:	57                   	push   %edi
  802850:	56                   	push   %esi
  802851:	53                   	push   %ebx
  802852:	83 ec 1c             	sub    $0x1c,%esp
  802855:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802858:	89 34 24             	mov    %esi,(%esp)
  80285b:	e8 e0 f0 ff ff       	call   801940 <fd2data>
  802860:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802862:	bf 00 00 00 00       	mov    $0x0,%edi
  802867:	eb 45                	jmp    8028ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802869:	89 da                	mov    %ebx,%edx
  80286b:	89 f0                	mov    %esi,%eax
  80286d:	e8 71 ff ff ff       	call   8027e3 <_pipeisclosed>
  802872:	85 c0                	test   %eax,%eax
  802874:	75 41                	jne    8028b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802876:	e8 cb e6 ff ff       	call   800f46 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80287b:	8b 43 04             	mov    0x4(%ebx),%eax
  80287e:	8b 0b                	mov    (%ebx),%ecx
  802880:	8d 51 20             	lea    0x20(%ecx),%edx
  802883:	39 d0                	cmp    %edx,%eax
  802885:	73 e2                	jae    802869 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802887:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80288a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80288e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802891:	99                   	cltd   
  802892:	c1 ea 1b             	shr    $0x1b,%edx
  802895:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802898:	83 e1 1f             	and    $0x1f,%ecx
  80289b:	29 d1                	sub    %edx,%ecx
  80289d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8028a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8028a5:	83 c0 01             	add    $0x1,%eax
  8028a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028ab:	83 c7 01             	add    $0x1,%edi
  8028ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8028b1:	75 c8                	jne    80287b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8028b3:	89 f8                	mov    %edi,%eax
  8028b5:	eb 05                	jmp    8028bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8028b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8028bc:	83 c4 1c             	add    $0x1c,%esp
  8028bf:	5b                   	pop    %ebx
  8028c0:	5e                   	pop    %esi
  8028c1:	5f                   	pop    %edi
  8028c2:	5d                   	pop    %ebp
  8028c3:	c3                   	ret    

008028c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
  8028c7:	57                   	push   %edi
  8028c8:	56                   	push   %esi
  8028c9:	53                   	push   %ebx
  8028ca:	83 ec 1c             	sub    $0x1c,%esp
  8028cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8028d0:	89 3c 24             	mov    %edi,(%esp)
  8028d3:	e8 68 f0 ff ff       	call   801940 <fd2data>
  8028d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028da:	be 00 00 00 00       	mov    $0x0,%esi
  8028df:	eb 3d                	jmp    80291e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8028e1:	85 f6                	test   %esi,%esi
  8028e3:	74 04                	je     8028e9 <devpipe_read+0x25>
				return i;
  8028e5:	89 f0                	mov    %esi,%eax
  8028e7:	eb 43                	jmp    80292c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8028e9:	89 da                	mov    %ebx,%edx
  8028eb:	89 f8                	mov    %edi,%eax
  8028ed:	e8 f1 fe ff ff       	call   8027e3 <_pipeisclosed>
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	75 31                	jne    802927 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8028f6:	e8 4b e6 ff ff       	call   800f46 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8028fb:	8b 03                	mov    (%ebx),%eax
  8028fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802900:	74 df                	je     8028e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802902:	99                   	cltd   
  802903:	c1 ea 1b             	shr    $0x1b,%edx
  802906:	01 d0                	add    %edx,%eax
  802908:	83 e0 1f             	and    $0x1f,%eax
  80290b:	29 d0                	sub    %edx,%eax
  80290d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802915:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802918:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80291b:	83 c6 01             	add    $0x1,%esi
  80291e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802921:	75 d8                	jne    8028fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802923:	89 f0                	mov    %esi,%eax
  802925:	eb 05                	jmp    80292c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80292c:	83 c4 1c             	add    $0x1c,%esp
  80292f:	5b                   	pop    %ebx
  802930:	5e                   	pop    %esi
  802931:	5f                   	pop    %edi
  802932:	5d                   	pop    %ebp
  802933:	c3                   	ret    

00802934 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
  802937:	56                   	push   %esi
  802938:	53                   	push   %ebx
  802939:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80293c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80293f:	89 04 24             	mov    %eax,(%esp)
  802942:	e8 10 f0 ff ff       	call   801957 <fd_alloc>
  802947:	89 c2                	mov    %eax,%edx
  802949:	85 d2                	test   %edx,%edx
  80294b:	0f 88 4d 01 00 00    	js     802a9e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802951:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802958:	00 
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802960:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802967:	e8 f9 e5 ff ff       	call   800f65 <sys_page_alloc>
  80296c:	89 c2                	mov    %eax,%edx
  80296e:	85 d2                	test   %edx,%edx
  802970:	0f 88 28 01 00 00    	js     802a9e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802976:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802979:	89 04 24             	mov    %eax,(%esp)
  80297c:	e8 d6 ef ff ff       	call   801957 <fd_alloc>
  802981:	89 c3                	mov    %eax,%ebx
  802983:	85 c0                	test   %eax,%eax
  802985:	0f 88 fe 00 00 00    	js     802a89 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80298b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802992:	00 
  802993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802996:	89 44 24 04          	mov    %eax,0x4(%esp)
  80299a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a1:	e8 bf e5 ff ff       	call   800f65 <sys_page_alloc>
  8029a6:	89 c3                	mov    %eax,%ebx
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	0f 88 d9 00 00 00    	js     802a89 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	89 04 24             	mov    %eax,(%esp)
  8029b6:	e8 85 ef ff ff       	call   801940 <fd2data>
  8029bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029c4:	00 
  8029c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029d0:	e8 90 e5 ff ff       	call   800f65 <sys_page_alloc>
  8029d5:	89 c3                	mov    %eax,%ebx
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	0f 88 97 00 00 00    	js     802a76 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	89 04 24             	mov    %eax,(%esp)
  8029e5:	e8 56 ef ff ff       	call   801940 <fd2data>
  8029ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8029f1:	00 
  8029f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8029fd:	00 
  8029fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a09:	e8 ab e5 ff ff       	call   800fb9 <sys_page_map>
  802a0e:	89 c3                	mov    %eax,%ebx
  802a10:	85 c0                	test   %eax,%eax
  802a12:	78 52                	js     802a66 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802a14:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a29:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a32:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a37:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	89 04 24             	mov    %eax,(%esp)
  802a44:	e8 e7 ee ff ff       	call   801930 <fd2num>
  802a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a4c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	89 04 24             	mov    %eax,(%esp)
  802a54:	e8 d7 ee ff ff       	call   801930 <fd2num>
  802a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a5c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a64:	eb 38                	jmp    802a9e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802a66:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a71:	e8 96 e5 ff ff       	call   80100c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a84:	e8 83 e5 ff ff       	call   80100c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a97:	e8 70 e5 ff ff       	call   80100c <sys_page_unmap>
  802a9c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802a9e:	83 c4 30             	add    $0x30,%esp
  802aa1:	5b                   	pop    %ebx
  802aa2:	5e                   	pop    %esi
  802aa3:	5d                   	pop    %ebp
  802aa4:	c3                   	ret    

00802aa5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802aa5:	55                   	push   %ebp
  802aa6:	89 e5                	mov    %esp,%ebp
  802aa8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802aab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	89 04 24             	mov    %eax,(%esp)
  802ab8:	e8 e9 ee ff ff       	call   8019a6 <fd_lookup>
  802abd:	89 c2                	mov    %eax,%edx
  802abf:	85 d2                	test   %edx,%edx
  802ac1:	78 15                	js     802ad8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	89 04 24             	mov    %eax,(%esp)
  802ac9:	e8 72 ee ff ff       	call   801940 <fd2data>
	return _pipeisclosed(fd, p);
  802ace:	89 c2                	mov    %eax,%edx
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	e8 0b fd ff ff       	call   8027e3 <_pipeisclosed>
}
  802ad8:	c9                   	leave  
  802ad9:	c3                   	ret    
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae8:	5d                   	pop    %ebp
  802ae9:	c3                   	ret    

00802aea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802aea:	55                   	push   %ebp
  802aeb:	89 e5                	mov    %esp,%ebp
  802aed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802af0:	c7 44 24 04 c5 36 80 	movl   $0x8036c5,0x4(%esp)
  802af7:	00 
  802af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802afb:	89 04 24             	mov    %eax,(%esp)
  802afe:	e8 f4 df ff ff       	call   800af7 <strcpy>
	return 0;
}
  802b03:	b8 00 00 00 00       	mov    $0x0,%eax
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	57                   	push   %edi
  802b0e:	56                   	push   %esi
  802b0f:	53                   	push   %ebx
  802b10:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b16:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802b1b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b21:	eb 31                	jmp    802b54 <devcons_write+0x4a>
		m = n - tot;
  802b23:	8b 75 10             	mov    0x10(%ebp),%esi
  802b26:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802b28:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802b2b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802b30:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802b33:	89 74 24 08          	mov    %esi,0x8(%esp)
  802b37:	03 45 0c             	add    0xc(%ebp),%eax
  802b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b3e:	89 3c 24             	mov    %edi,(%esp)
  802b41:	e8 4e e1 ff ff       	call   800c94 <memmove>
		sys_cputs(buf, m);
  802b46:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b4a:	89 3c 24             	mov    %edi,(%esp)
  802b4d:	e8 f4 e2 ff ff       	call   800e46 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b52:	01 f3                	add    %esi,%ebx
  802b54:	89 d8                	mov    %ebx,%eax
  802b56:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802b59:	72 c8                	jb     802b23 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802b5b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802b61:	5b                   	pop    %ebx
  802b62:	5e                   	pop    %esi
  802b63:	5f                   	pop    %edi
  802b64:	5d                   	pop    %ebp
  802b65:	c3                   	ret    

00802b66 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
  802b69:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802b6c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802b71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b75:	75 07                	jne    802b7e <devcons_read+0x18>
  802b77:	eb 2a                	jmp    802ba3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802b79:	e8 c8 e3 ff ff       	call   800f46 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802b7e:	66 90                	xchg   %ax,%ax
  802b80:	e8 df e2 ff ff       	call   800e64 <sys_cgetc>
  802b85:	85 c0                	test   %eax,%eax
  802b87:	74 f0                	je     802b79 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	78 16                	js     802ba3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802b8d:	83 f8 04             	cmp    $0x4,%eax
  802b90:	74 0c                	je     802b9e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b95:	88 02                	mov    %al,(%edx)
	return 1;
  802b97:	b8 01 00 00 00       	mov    $0x1,%eax
  802b9c:	eb 05                	jmp    802ba3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802b9e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802ba3:	c9                   	leave  
  802ba4:	c3                   	ret    

00802ba5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802ba5:	55                   	push   %ebp
  802ba6:	89 e5                	mov    %esp,%ebp
  802ba8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802bb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802bb8:	00 
  802bb9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bbc:	89 04 24             	mov    %eax,(%esp)
  802bbf:	e8 82 e2 ff ff       	call   800e46 <sys_cputs>
}
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <getchar>:

int
getchar(void)
{
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
  802bc9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802bcc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802bd3:	00 
  802bd4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bdb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802be2:	e8 53 f0 ff ff       	call   801c3a <read>
	if (r < 0)
  802be7:	85 c0                	test   %eax,%eax
  802be9:	78 0f                	js     802bfa <getchar+0x34>
		return r;
	if (r < 1)
  802beb:	85 c0                	test   %eax,%eax
  802bed:	7e 06                	jle    802bf5 <getchar+0x2f>
		return -E_EOF;
	return c;
  802bef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802bf3:	eb 05                	jmp    802bfa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802bf5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802bfa:	c9                   	leave  
  802bfb:	c3                   	ret    

00802bfc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
  802bff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	89 04 24             	mov    %eax,(%esp)
  802c0f:	e8 92 ed ff ff       	call   8019a6 <fd_lookup>
  802c14:	85 c0                	test   %eax,%eax
  802c16:	78 11                	js     802c29 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802c21:	39 10                	cmp    %edx,(%eax)
  802c23:	0f 94 c0             	sete   %al
  802c26:	0f b6 c0             	movzbl %al,%eax
}
  802c29:	c9                   	leave  
  802c2a:	c3                   	ret    

00802c2b <opencons>:

int
opencons(void)
{
  802c2b:	55                   	push   %ebp
  802c2c:	89 e5                	mov    %esp,%ebp
  802c2e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802c31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c34:	89 04 24             	mov    %eax,(%esp)
  802c37:	e8 1b ed ff ff       	call   801957 <fd_alloc>
		return r;
  802c3c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802c3e:	85 c0                	test   %eax,%eax
  802c40:	78 40                	js     802c82 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c42:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c49:	00 
  802c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c58:	e8 08 e3 ff ff       	call   800f65 <sys_page_alloc>
		return r;
  802c5d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	78 1f                	js     802c82 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802c63:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802c78:	89 04 24             	mov    %eax,(%esp)
  802c7b:	e8 b0 ec ff ff       	call   801930 <fd2num>
  802c80:	89 c2                	mov    %eax,%edx
}
  802c82:	89 d0                	mov    %edx,%eax
  802c84:	c9                   	leave  
  802c85:	c3                   	ret    

00802c86 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802c86:	55                   	push   %ebp
  802c87:	89 e5                	mov    %esp,%ebp
  802c89:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802c8c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802c93:	75 7a                	jne    802d0f <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802c95:	e8 8d e2 ff ff       	call   800f27 <sys_getenvid>
  802c9a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ca1:	00 
  802ca2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802ca9:	ee 
  802caa:	89 04 24             	mov    %eax,(%esp)
  802cad:	e8 b3 e2 ff ff       	call   800f65 <sys_page_alloc>
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	79 20                	jns    802cd6 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802cb6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802cba:	c7 44 24 08 4a 30 80 	movl   $0x80304a,0x8(%esp)
  802cc1:	00 
  802cc2:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802cc9:	00 
  802cca:	c7 04 24 d1 36 80 00 	movl   $0x8036d1,(%esp)
  802cd1:	e8 b0 d6 ff ff       	call   800386 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802cd6:	e8 4c e2 ff ff       	call   800f27 <sys_getenvid>
  802cdb:	c7 44 24 04 19 2d 80 	movl   $0x802d19,0x4(%esp)
  802ce2:	00 
  802ce3:	89 04 24             	mov    %eax,(%esp)
  802ce6:	e8 3a e4 ff ff       	call   801125 <sys_env_set_pgfault_upcall>
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	79 20                	jns    802d0f <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802cef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802cf3:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  802cfa:	00 
  802cfb:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802d02:	00 
  802d03:	c7 04 24 d1 36 80 00 	movl   $0x8036d1,(%esp)
  802d0a:	e8 77 d6 ff ff       	call   800386 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802d17:	c9                   	leave  
  802d18:	c3                   	ret    

00802d19 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802d19:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802d1a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802d1f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802d21:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802d24:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802d28:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802d2c:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802d2f:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802d33:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802d35:	83 c4 08             	add    $0x8,%esp
	popal
  802d38:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802d39:	83 c4 04             	add    $0x4,%esp
	popfl
  802d3c:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802d3d:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802d3e:	c3                   	ret    

00802d3f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d3f:	55                   	push   %ebp
  802d40:	89 e5                	mov    %esp,%ebp
  802d42:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d45:	89 d0                	mov    %edx,%eax
  802d47:	c1 e8 16             	shr    $0x16,%eax
  802d4a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d51:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d56:	f6 c1 01             	test   $0x1,%cl
  802d59:	74 1d                	je     802d78 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802d5b:	c1 ea 0c             	shr    $0xc,%edx
  802d5e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d65:	f6 c2 01             	test   $0x1,%dl
  802d68:	74 0e                	je     802d78 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d6a:	c1 ea 0c             	shr    $0xc,%edx
  802d6d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d74:	ef 
  802d75:	0f b7 c0             	movzwl %ax,%eax
}
  802d78:	5d                   	pop    %ebp
  802d79:	c3                   	ret    
  802d7a:	66 90                	xchg   %ax,%ax
  802d7c:	66 90                	xchg   %ax,%ax
  802d7e:	66 90                	xchg   %ax,%ax

00802d80 <__udivdi3>:
  802d80:	55                   	push   %ebp
  802d81:	57                   	push   %edi
  802d82:	56                   	push   %esi
  802d83:	83 ec 0c             	sub    $0xc,%esp
  802d86:	8b 44 24 28          	mov    0x28(%esp),%eax
  802d8a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802d8e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802d92:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802d96:	85 c0                	test   %eax,%eax
  802d98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d9c:	89 ea                	mov    %ebp,%edx
  802d9e:	89 0c 24             	mov    %ecx,(%esp)
  802da1:	75 2d                	jne    802dd0 <__udivdi3+0x50>
  802da3:	39 e9                	cmp    %ebp,%ecx
  802da5:	77 61                	ja     802e08 <__udivdi3+0x88>
  802da7:	85 c9                	test   %ecx,%ecx
  802da9:	89 ce                	mov    %ecx,%esi
  802dab:	75 0b                	jne    802db8 <__udivdi3+0x38>
  802dad:	b8 01 00 00 00       	mov    $0x1,%eax
  802db2:	31 d2                	xor    %edx,%edx
  802db4:	f7 f1                	div    %ecx
  802db6:	89 c6                	mov    %eax,%esi
  802db8:	31 d2                	xor    %edx,%edx
  802dba:	89 e8                	mov    %ebp,%eax
  802dbc:	f7 f6                	div    %esi
  802dbe:	89 c5                	mov    %eax,%ebp
  802dc0:	89 f8                	mov    %edi,%eax
  802dc2:	f7 f6                	div    %esi
  802dc4:	89 ea                	mov    %ebp,%edx
  802dc6:	83 c4 0c             	add    $0xc,%esp
  802dc9:	5e                   	pop    %esi
  802dca:	5f                   	pop    %edi
  802dcb:	5d                   	pop    %ebp
  802dcc:	c3                   	ret    
  802dcd:	8d 76 00             	lea    0x0(%esi),%esi
  802dd0:	39 e8                	cmp    %ebp,%eax
  802dd2:	77 24                	ja     802df8 <__udivdi3+0x78>
  802dd4:	0f bd e8             	bsr    %eax,%ebp
  802dd7:	83 f5 1f             	xor    $0x1f,%ebp
  802dda:	75 3c                	jne    802e18 <__udivdi3+0x98>
  802ddc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802de0:	39 34 24             	cmp    %esi,(%esp)
  802de3:	0f 86 9f 00 00 00    	jbe    802e88 <__udivdi3+0x108>
  802de9:	39 d0                	cmp    %edx,%eax
  802deb:	0f 82 97 00 00 00    	jb     802e88 <__udivdi3+0x108>
  802df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802df8:	31 d2                	xor    %edx,%edx
  802dfa:	31 c0                	xor    %eax,%eax
  802dfc:	83 c4 0c             	add    $0xc,%esp
  802dff:	5e                   	pop    %esi
  802e00:	5f                   	pop    %edi
  802e01:	5d                   	pop    %ebp
  802e02:	c3                   	ret    
  802e03:	90                   	nop
  802e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e08:	89 f8                	mov    %edi,%eax
  802e0a:	f7 f1                	div    %ecx
  802e0c:	31 d2                	xor    %edx,%edx
  802e0e:	83 c4 0c             	add    $0xc,%esp
  802e11:	5e                   	pop    %esi
  802e12:	5f                   	pop    %edi
  802e13:	5d                   	pop    %ebp
  802e14:	c3                   	ret    
  802e15:	8d 76 00             	lea    0x0(%esi),%esi
  802e18:	89 e9                	mov    %ebp,%ecx
  802e1a:	8b 3c 24             	mov    (%esp),%edi
  802e1d:	d3 e0                	shl    %cl,%eax
  802e1f:	89 c6                	mov    %eax,%esi
  802e21:	b8 20 00 00 00       	mov    $0x20,%eax
  802e26:	29 e8                	sub    %ebp,%eax
  802e28:	89 c1                	mov    %eax,%ecx
  802e2a:	d3 ef                	shr    %cl,%edi
  802e2c:	89 e9                	mov    %ebp,%ecx
  802e2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802e32:	8b 3c 24             	mov    (%esp),%edi
  802e35:	09 74 24 08          	or     %esi,0x8(%esp)
  802e39:	89 d6                	mov    %edx,%esi
  802e3b:	d3 e7                	shl    %cl,%edi
  802e3d:	89 c1                	mov    %eax,%ecx
  802e3f:	89 3c 24             	mov    %edi,(%esp)
  802e42:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802e46:	d3 ee                	shr    %cl,%esi
  802e48:	89 e9                	mov    %ebp,%ecx
  802e4a:	d3 e2                	shl    %cl,%edx
  802e4c:	89 c1                	mov    %eax,%ecx
  802e4e:	d3 ef                	shr    %cl,%edi
  802e50:	09 d7                	or     %edx,%edi
  802e52:	89 f2                	mov    %esi,%edx
  802e54:	89 f8                	mov    %edi,%eax
  802e56:	f7 74 24 08          	divl   0x8(%esp)
  802e5a:	89 d6                	mov    %edx,%esi
  802e5c:	89 c7                	mov    %eax,%edi
  802e5e:	f7 24 24             	mull   (%esp)
  802e61:	39 d6                	cmp    %edx,%esi
  802e63:	89 14 24             	mov    %edx,(%esp)
  802e66:	72 30                	jb     802e98 <__udivdi3+0x118>
  802e68:	8b 54 24 04          	mov    0x4(%esp),%edx
  802e6c:	89 e9                	mov    %ebp,%ecx
  802e6e:	d3 e2                	shl    %cl,%edx
  802e70:	39 c2                	cmp    %eax,%edx
  802e72:	73 05                	jae    802e79 <__udivdi3+0xf9>
  802e74:	3b 34 24             	cmp    (%esp),%esi
  802e77:	74 1f                	je     802e98 <__udivdi3+0x118>
  802e79:	89 f8                	mov    %edi,%eax
  802e7b:	31 d2                	xor    %edx,%edx
  802e7d:	e9 7a ff ff ff       	jmp    802dfc <__udivdi3+0x7c>
  802e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e88:	31 d2                	xor    %edx,%edx
  802e8a:	b8 01 00 00 00       	mov    $0x1,%eax
  802e8f:	e9 68 ff ff ff       	jmp    802dfc <__udivdi3+0x7c>
  802e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e98:	8d 47 ff             	lea    -0x1(%edi),%eax
  802e9b:	31 d2                	xor    %edx,%edx
  802e9d:	83 c4 0c             	add    $0xc,%esp
  802ea0:	5e                   	pop    %esi
  802ea1:	5f                   	pop    %edi
  802ea2:	5d                   	pop    %ebp
  802ea3:	c3                   	ret    
  802ea4:	66 90                	xchg   %ax,%ax
  802ea6:	66 90                	xchg   %ax,%ax
  802ea8:	66 90                	xchg   %ax,%ax
  802eaa:	66 90                	xchg   %ax,%ax
  802eac:	66 90                	xchg   %ax,%ax
  802eae:	66 90                	xchg   %ax,%ax

00802eb0 <__umoddi3>:
  802eb0:	55                   	push   %ebp
  802eb1:	57                   	push   %edi
  802eb2:	56                   	push   %esi
  802eb3:	83 ec 14             	sub    $0x14,%esp
  802eb6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802eba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ebe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ec2:	89 c7                	mov    %eax,%edi
  802ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ec8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802ecc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ed0:	89 34 24             	mov    %esi,(%esp)
  802ed3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	89 c2                	mov    %eax,%edx
  802edb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802edf:	75 17                	jne    802ef8 <__umoddi3+0x48>
  802ee1:	39 fe                	cmp    %edi,%esi
  802ee3:	76 4b                	jbe    802f30 <__umoddi3+0x80>
  802ee5:	89 c8                	mov    %ecx,%eax
  802ee7:	89 fa                	mov    %edi,%edx
  802ee9:	f7 f6                	div    %esi
  802eeb:	89 d0                	mov    %edx,%eax
  802eed:	31 d2                	xor    %edx,%edx
  802eef:	83 c4 14             	add    $0x14,%esp
  802ef2:	5e                   	pop    %esi
  802ef3:	5f                   	pop    %edi
  802ef4:	5d                   	pop    %ebp
  802ef5:	c3                   	ret    
  802ef6:	66 90                	xchg   %ax,%ax
  802ef8:	39 f8                	cmp    %edi,%eax
  802efa:	77 54                	ja     802f50 <__umoddi3+0xa0>
  802efc:	0f bd e8             	bsr    %eax,%ebp
  802eff:	83 f5 1f             	xor    $0x1f,%ebp
  802f02:	75 5c                	jne    802f60 <__umoddi3+0xb0>
  802f04:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802f08:	39 3c 24             	cmp    %edi,(%esp)
  802f0b:	0f 87 e7 00 00 00    	ja     802ff8 <__umoddi3+0x148>
  802f11:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802f15:	29 f1                	sub    %esi,%ecx
  802f17:	19 c7                	sbb    %eax,%edi
  802f19:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f21:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f25:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802f29:	83 c4 14             	add    $0x14,%esp
  802f2c:	5e                   	pop    %esi
  802f2d:	5f                   	pop    %edi
  802f2e:	5d                   	pop    %ebp
  802f2f:	c3                   	ret    
  802f30:	85 f6                	test   %esi,%esi
  802f32:	89 f5                	mov    %esi,%ebp
  802f34:	75 0b                	jne    802f41 <__umoddi3+0x91>
  802f36:	b8 01 00 00 00       	mov    $0x1,%eax
  802f3b:	31 d2                	xor    %edx,%edx
  802f3d:	f7 f6                	div    %esi
  802f3f:	89 c5                	mov    %eax,%ebp
  802f41:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f45:	31 d2                	xor    %edx,%edx
  802f47:	f7 f5                	div    %ebp
  802f49:	89 c8                	mov    %ecx,%eax
  802f4b:	f7 f5                	div    %ebp
  802f4d:	eb 9c                	jmp    802eeb <__umoddi3+0x3b>
  802f4f:	90                   	nop
  802f50:	89 c8                	mov    %ecx,%eax
  802f52:	89 fa                	mov    %edi,%edx
  802f54:	83 c4 14             	add    $0x14,%esp
  802f57:	5e                   	pop    %esi
  802f58:	5f                   	pop    %edi
  802f59:	5d                   	pop    %ebp
  802f5a:	c3                   	ret    
  802f5b:	90                   	nop
  802f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f60:	8b 04 24             	mov    (%esp),%eax
  802f63:	be 20 00 00 00       	mov    $0x20,%esi
  802f68:	89 e9                	mov    %ebp,%ecx
  802f6a:	29 ee                	sub    %ebp,%esi
  802f6c:	d3 e2                	shl    %cl,%edx
  802f6e:	89 f1                	mov    %esi,%ecx
  802f70:	d3 e8                	shr    %cl,%eax
  802f72:	89 e9                	mov    %ebp,%ecx
  802f74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f78:	8b 04 24             	mov    (%esp),%eax
  802f7b:	09 54 24 04          	or     %edx,0x4(%esp)
  802f7f:	89 fa                	mov    %edi,%edx
  802f81:	d3 e0                	shl    %cl,%eax
  802f83:	89 f1                	mov    %esi,%ecx
  802f85:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f89:	8b 44 24 10          	mov    0x10(%esp),%eax
  802f8d:	d3 ea                	shr    %cl,%edx
  802f8f:	89 e9                	mov    %ebp,%ecx
  802f91:	d3 e7                	shl    %cl,%edi
  802f93:	89 f1                	mov    %esi,%ecx
  802f95:	d3 e8                	shr    %cl,%eax
  802f97:	89 e9                	mov    %ebp,%ecx
  802f99:	09 f8                	or     %edi,%eax
  802f9b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802f9f:	f7 74 24 04          	divl   0x4(%esp)
  802fa3:	d3 e7                	shl    %cl,%edi
  802fa5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fa9:	89 d7                	mov    %edx,%edi
  802fab:	f7 64 24 08          	mull   0x8(%esp)
  802faf:	39 d7                	cmp    %edx,%edi
  802fb1:	89 c1                	mov    %eax,%ecx
  802fb3:	89 14 24             	mov    %edx,(%esp)
  802fb6:	72 2c                	jb     802fe4 <__umoddi3+0x134>
  802fb8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802fbc:	72 22                	jb     802fe0 <__umoddi3+0x130>
  802fbe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802fc2:	29 c8                	sub    %ecx,%eax
  802fc4:	19 d7                	sbb    %edx,%edi
  802fc6:	89 e9                	mov    %ebp,%ecx
  802fc8:	89 fa                	mov    %edi,%edx
  802fca:	d3 e8                	shr    %cl,%eax
  802fcc:	89 f1                	mov    %esi,%ecx
  802fce:	d3 e2                	shl    %cl,%edx
  802fd0:	89 e9                	mov    %ebp,%ecx
  802fd2:	d3 ef                	shr    %cl,%edi
  802fd4:	09 d0                	or     %edx,%eax
  802fd6:	89 fa                	mov    %edi,%edx
  802fd8:	83 c4 14             	add    $0x14,%esp
  802fdb:	5e                   	pop    %esi
  802fdc:	5f                   	pop    %edi
  802fdd:	5d                   	pop    %ebp
  802fde:	c3                   	ret    
  802fdf:	90                   	nop
  802fe0:	39 d7                	cmp    %edx,%edi
  802fe2:	75 da                	jne    802fbe <__umoddi3+0x10e>
  802fe4:	8b 14 24             	mov    (%esp),%edx
  802fe7:	89 c1                	mov    %eax,%ecx
  802fe9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802fed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802ff1:	eb cb                	jmp    802fbe <__umoddi3+0x10e>
  802ff3:	90                   	nop
  802ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ff8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802ffc:	0f 82 0f ff ff ff    	jb     802f11 <__umoddi3+0x61>
  803002:	e9 1a ff ff ff       	jmp    802f21 <__umoddi3+0x71>
