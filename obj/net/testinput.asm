
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 fc 08 00 00       	call   80092d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	envid_t ns_envid = sys_getenvid();
  80004c:	e8 e6 14 00 00       	call   801537 <sys_getenvid>
  800051:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800053:	c7 05 00 40 80 00 20 	movl   $0x803620,0x804000
  80005a:	36 80 00 

	output_envid = fork();
  80005d:	e8 2d 1a 00 00       	call   801a8f <fork>
  800062:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800067:	85 c0                	test   %eax,%eax
  800069:	79 1c                	jns    800087 <umain+0x47>
		panic("error forking");
  80006b:	c7 44 24 08 2a 36 80 	movl   $0x80362a,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  80007a:	00 
  80007b:	c7 04 24 38 36 80 00 	movl   $0x803638,(%esp)
  800082:	e8 07 09 00 00       	call   80098e <_panic>
	else if (output_envid == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 0d                	jne    800098 <umain+0x58>
		output(ns_envid);
  80008b:	89 1c 24             	mov    %ebx,(%esp)
  80008e:	e8 ed 04 00 00       	call   800580 <output>
		return;
  800093:	e9 98 03 00 00       	jmp    800430 <umain+0x3f0>
	}

	input_envid = fork();
  800098:	e8 f2 19 00 00       	call   801a8f <fork>
  80009d:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 1c                	jns    8000c2 <umain+0x82>
		panic("error forking");
  8000a6:	c7 44 24 08 2a 36 80 	movl   $0x80362a,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 38 36 80 00 	movl   $0x803638,(%esp)
  8000bd:	e8 cc 08 00 00       	call   80098e <_panic>
	else if (input_envid == 0) {
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	75 0f                	jne    8000d5 <umain+0x95>
		input(ns_envid);
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 37 04 00 00       	call   800505 <input>
		return;
  8000ce:	66 90                	xchg   %ax,%ax
  8000d0:	e9 5b 03 00 00       	jmp    800430 <umain+0x3f0>
	}

	cprintf("Sending ARP announcement...\n");
  8000d5:	c7 04 24 48 36 80 00 	movl   $0x803648,(%esp)
  8000dc:	e8 a6 09 00 00       	call   800a87 <cprintf>
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	uint8_t mac[6]; //= {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
	sys_read_mac(mac);
  8000e1:	8d 45 98             	lea    -0x68(%ebp),%eax
  8000e4:	89 04 24             	mov    %eax,(%esp)
  8000e7:	e8 72 17 00 00       	call   80185e <sys_read_mac>
	int i=0;
	uint32_t myip = inet_addr(IP);
  8000ec:	c7 04 24 65 36 80 00 	movl   $0x803665,(%esp)
  8000f3:	e8 fd 07 00 00       	call   8008f5 <inet_addr>
  8000f8:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000fb:	c7 04 24 6f 36 80 00 	movl   $0x80366f,(%esp)
  800102:	e8 ee 07 00 00       	call   8008f5 <inet_addr>
  800107:	89 45 94             	mov    %eax,-0x6c(%ebp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80010a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800111:	00 
  800112:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800119:	0f 
  80011a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800121:	e8 4f 14 00 00       	call   801575 <sys_page_alloc>
  800126:	85 c0                	test   %eax,%eax
  800128:	79 20                	jns    80014a <umain+0x10a>
		panic("sys_page_map: %e", r);
  80012a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80012e:	c7 44 24 08 78 36 80 	movl   $0x803678,0x8(%esp)
  800135:	00 
  800136:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  80013d:	00 
  80013e:	c7 04 24 38 36 80 00 	movl   $0x803638,(%esp)
  800145:	e8 44 08 00 00       	call   80098e <_panic>

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
	pkt->jp_len = sizeof(*arp);
  80014a:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  800151:	00 00 00 

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  800154:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80015b:	00 
  80015c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800163:	00 
  800164:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  80016b:	e8 e7 10 00 00       	call   801257 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800170:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800177:	00 
  800178:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  80017b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80017f:	c7 04 24 0a b0 fe 0f 	movl   $0xffeb00a,(%esp)
  800186:	e8 81 11 00 00       	call   80130c <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80018b:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  800192:	e8 2f 05 00 00       	call   8006c6 <htons>
  800197:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  80019d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001a4:	e8 1d 05 00 00       	call   8006c6 <htons>
  8001a9:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  8001af:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8001b6:	e8 0b 05 00 00       	call   8006c6 <htons>
  8001bb:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001c1:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  8001c8:	e8 f9 04 00 00       	call   8006c6 <htons>
  8001cd:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  8001d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001da:	e8 e7 04 00 00       	call   8006c6 <htons>
  8001df:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001e5:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8001ec:	00 
  8001ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f1:	c7 04 24 1a b0 fe 0f 	movl   $0xffeb01a,(%esp)
  8001f8:	e8 0f 11 00 00       	call   80130c <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  8001fd:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800204:	00 
  800205:	8d 45 90             	lea    -0x70(%ebp),%eax
  800208:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020c:	c7 04 24 20 b0 fe 0f 	movl   $0xffeb020,(%esp)
  800213:	e8 f4 10 00 00       	call   80130c <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800218:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80021f:	00 
  800220:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800227:	00 
  800228:	c7 04 24 24 b0 fe 0f 	movl   $0xffeb024,(%esp)
  80022f:	e8 23 10 00 00       	call   801257 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  800234:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80023b:	00 
  80023c:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80023f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800243:	c7 04 24 2a b0 fe 0f 	movl   $0xffeb02a,(%esp)
  80024a:	e8 bd 10 00 00       	call   80130c <memcpy>

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80024f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800256:	00 
  800257:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  80025e:	0f 
  80025f:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800266:	00 
  800267:	a1 04 50 80 00       	mov    0x805004,%eax
  80026c:	89 04 24             	mov    %eax,(%esp)
  80026f:	e8 24 1c 00 00       	call   801e98 <ipc_send>
	sys_page_unmap(0, pkt);
  800274:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80027b:	0f 
  80027c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800283:	e8 94 13 00 00       	call   80161c <sys_page_unmap>

void
umain(int argc, char **argv)
{
	envid_t ns_envid = sys_getenvid();
	int i, r, first = 1;
  800288:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
  80028f:	00 00 00 
	announce();
	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  800292:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800295:	89 44 24 08          	mov    %eax,0x8(%esp)
  800299:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8002a0:	0f 
  8002a1:	8d 45 90             	lea    -0x70(%ebp),%eax
  8002a4:	89 04 24             	mov    %eax,(%esp)
  8002a7:	e8 84 1b 00 00       	call   801e30 <ipc_recv>
		if (req < 0)
  8002ac:	85 c0                	test   %eax,%eax
  8002ae:	79 20                	jns    8002d0 <umain+0x290>
			panic("ipc_recv: %e", req);
  8002b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b4:	c7 44 24 08 89 36 80 	movl   $0x803689,0x8(%esp)
  8002bb:	00 
  8002bc:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
  8002c3:	00 
  8002c4:	c7 04 24 38 36 80 00 	movl   $0x803638,(%esp)
  8002cb:	e8 be 06 00 00       	call   80098e <_panic>
		if (whom != input_envid)
  8002d0:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002d3:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  8002d9:	74 20                	je     8002fb <umain+0x2bb>
			panic("IPC from unexpected environment %08x", whom);
  8002db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002df:	c7 44 24 08 e0 36 80 	movl   $0x8036e0,0x8(%esp)
  8002e6:	00 
  8002e7:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8002ee:	00 
  8002ef:	c7 04 24 38 36 80 00 	movl   $0x803638,(%esp)
  8002f6:	e8 93 06 00 00       	call   80098e <_panic>
		if (req != NSREQ_INPUT)
  8002fb:	83 f8 0a             	cmp    $0xa,%eax
  8002fe:	74 20                	je     800320 <umain+0x2e0>
			panic("Unexpected IPC %d", req);
  800300:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800304:	c7 44 24 08 96 36 80 	movl   $0x803696,0x8(%esp)
  80030b:	00 
  80030c:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  800313:	00 
  800314:	c7 04 24 38 36 80 00 	movl   $0x803638,(%esp)
  80031b:	e8 6e 06 00 00       	call   80098e <_panic>

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800320:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800325:	89 45 84             	mov    %eax,-0x7c(%ebp)
hexdump(const char *prefix, const void *data, int len)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
  800328:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < len; i++) {
  80032d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
		if (i % 16 == 15 || i == len - 1)
  800332:	83 e8 01             	sub    $0x1,%eax
  800335:	89 45 80             	mov    %eax,-0x80(%ebp)
  800338:	e9 ba 00 00 00       	jmp    8003f7 <umain+0x3b7>
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
  80033d:	89 df                	mov    %ebx,%edi
  80033f:	f6 c3 0f             	test   $0xf,%bl
  800342:	75 2d                	jne    800371 <umain+0x331>
			out = buf + snprintf(buf, end - buf,
  800344:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800348:	c7 44 24 0c a8 36 80 	movl   $0x8036a8,0xc(%esp)
  80034f:	00 
  800350:	c7 44 24 08 b0 36 80 	movl   $0x8036b0,0x8(%esp)
  800357:	00 
  800358:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80035f:	00 
  800360:	8d 45 98             	lea    -0x68(%ebp),%eax
  800363:	89 04 24             	mov    %eax,(%esp)
  800366:	e8 3a 0d 00 00       	call   8010a5 <snprintf>
  80036b:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  80036e:	8d 34 01             	lea    (%ecx,%eax,1),%esi
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800371:	b8 04 b0 fe 0f       	mov    $0xffeb004,%eax
  800376:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
  80037a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80037e:	c7 44 24 08 ba 36 80 	movl   $0x8036ba,0x8(%esp)
  800385:	00 
  800386:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800389:	29 f0                	sub    %esi,%eax
  80038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038f:	89 34 24             	mov    %esi,(%esp)
  800392:	e8 0e 0d 00 00       	call   8010a5 <snprintf>
  800397:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  800399:	89 d8                	mov    %ebx,%eax
  80039b:	c1 f8 1f             	sar    $0x1f,%eax
  80039e:	c1 e8 1c             	shr    $0x1c,%eax
  8003a1:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  8003a4:	83 e7 0f             	and    $0xf,%edi
  8003a7:	29 c7                	sub    %eax,%edi
  8003a9:	83 ff 0f             	cmp    $0xf,%edi
  8003ac:	74 05                	je     8003b3 <umain+0x373>
  8003ae:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  8003b1:	75 1e                	jne    8003d1 <umain+0x391>
			cprintf("%.*s\n", out - buf, buf);
  8003b3:	8d 45 98             	lea    -0x68(%ebp),%eax
  8003b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ba:	89 f0                	mov    %esi,%eax
  8003bc:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  8003bf:	29 c8                	sub    %ecx,%eax
  8003c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c5:	c7 04 24 bf 36 80 00 	movl   $0x8036bf,(%esp)
  8003cc:	e8 b6 06 00 00       	call   800a87 <cprintf>
		if (i % 2 == 1)
  8003d1:	89 d8                	mov    %ebx,%eax
  8003d3:	c1 e8 1f             	shr    $0x1f,%eax
  8003d6:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8003d9:	83 e2 01             	and    $0x1,%edx
  8003dc:	29 c2                	sub    %eax,%edx
  8003de:	83 fa 01             	cmp    $0x1,%edx
  8003e1:	75 06                	jne    8003e9 <umain+0x3a9>
			*(out++) = ' ';
  8003e3:	c6 06 20             	movb   $0x20,(%esi)
  8003e6:	8d 76 01             	lea    0x1(%esi),%esi
		if (i % 16 == 7)
  8003e9:	83 ff 07             	cmp    $0x7,%edi
  8003ec:	75 06                	jne    8003f4 <umain+0x3b4>
			*(out++) = ' ';
  8003ee:	c6 06 20             	movb   $0x20,(%esi)
  8003f1:	8d 76 01             	lea    0x1(%esi),%esi
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  8003f4:	83 c3 01             	add    $0x1,%ebx
  8003f7:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  8003fa:	0f 8f 3d ff ff ff    	jg     80033d <umain+0x2fd>
			panic("IPC from unexpected environment %08x", whom);
		if (req != NSREQ_INPUT)
			panic("Unexpected IPC %d", req);

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
		cprintf("\n");
  800400:	c7 04 24 db 36 80 00 	movl   $0x8036db,(%esp)
  800407:	e8 7b 06 00 00       	call   800a87 <cprintf>

		// Only indicate that we're waiting for packets once
		// we've received the ARP reply
		if (first)
  80040c:	83 bd 7c ff ff ff 00 	cmpl   $0x0,-0x84(%ebp)
  800413:	74 0c                	je     800421 <umain+0x3e1>
			cprintf("Waiting for packets...\n");
  800415:	c7 04 24 c5 36 80 00 	movl   $0x8036c5,(%esp)
  80041c:	e8 66 06 00 00       	call   800a87 <cprintf>
		first = 0;
  800421:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  800428:	00 00 00 
	}
  80042b:	e9 62 fe ff ff       	jmp    800292 <umain+0x252>
}
  800430:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  800436:	5b                   	pop    %ebx
  800437:	5e                   	pop    %esi
  800438:	5f                   	pop    %edi
  800439:	5d                   	pop    %ebp
  80043a:	c3                   	ret    
  80043b:	66 90                	xchg   %ax,%ax
  80043d:	66 90                	xchg   %ax,%ax
  80043f:	90                   	nop

00800440 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	57                   	push   %edi
  800444:	56                   	push   %esi
  800445:	53                   	push   %ebx
  800446:	83 ec 2c             	sub    $0x2c,%esp
  800449:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80044c:	e8 ac 13 00 00       	call   8017fd <sys_time_msec>
  800451:	03 45 0c             	add    0xc(%ebp),%eax
  800454:	89 c6                	mov    %eax,%esi

	binaryname = "ns_timer";
  800456:	c7 05 00 40 80 00 05 	movl   $0x803705,0x804000
  80045d:	37 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800460:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800463:	eb 05                	jmp    80046a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800465:	e8 ec 10 00 00       	call   801556 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80046a:	e8 8e 13 00 00       	call   8017fd <sys_time_msec>
  80046f:	39 c6                	cmp    %eax,%esi
  800471:	76 06                	jbe    800479 <timer+0x39>
  800473:	85 c0                	test   %eax,%eax
  800475:	79 ee                	jns    800465 <timer+0x25>
  800477:	eb 09                	jmp    800482 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800479:	85 c0                	test   %eax,%eax
  80047b:	90                   	nop
  80047c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800480:	79 20                	jns    8004a2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  800482:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800486:	c7 44 24 08 0e 37 80 	movl   $0x80370e,0x8(%esp)
  80048d:	00 
  80048e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800495:	00 
  800496:	c7 04 24 20 37 80 00 	movl   $0x803720,(%esp)
  80049d:	e8 ec 04 00 00       	call   80098e <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8004a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004a9:	00 
  8004aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004b1:	00 
  8004b2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8004b9:	00 
  8004ba:	89 1c 24             	mov    %ebx,(%esp)
  8004bd:	e8 d6 19 00 00       	call   801e98 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8004c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004c9:	00 
  8004ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004d1:	00 
  8004d2:	89 3c 24             	mov    %edi,(%esp)
  8004d5:	e8 56 19 00 00       	call   801e30 <ipc_recv>
  8004da:	89 c6                	mov    %eax,%esi

			if (whom != ns_envid) {
  8004dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004df:	39 c3                	cmp    %eax,%ebx
  8004e1:	74 12                	je     8004f5 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8004e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e7:	c7 04 24 2c 37 80 00 	movl   $0x80372c,(%esp)
  8004ee:	e8 94 05 00 00       	call   800a87 <cprintf>
  8004f3:	eb cd                	jmp    8004c2 <timer+0x82>
				continue;
			}

			stop = sys_time_msec() + to;
  8004f5:	e8 03 13 00 00       	call   8017fd <sys_time_msec>
  8004fa:	01 c6                	add    %eax,%esi
  8004fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800500:	e9 65 ff ff ff       	jmp    80046a <timer+0x2a>

00800505 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	53                   	push   %ebx
  800509:	83 ec 14             	sub    $0x14,%esp
  80050c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int ret;
	binaryname = "ns_input";
  80050f:	c7 05 00 40 80 00 67 	movl   $0x803767,0x804000
  800516:	37 80 00 
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
	while(1)
	{
		sys_page_alloc(0, &nsipcbuf, PTE_W|PTE_U|PTE_P);
  800519:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800520:	00 
  800521:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  800528:	00 
  800529:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800530:	e8 40 10 00 00       	call   801575 <sys_page_alloc>

		while((ret = sys_rx_packet(&nsipcbuf.pkt.jp_data, &nsipcbuf.pkt.jp_len)) < 0)
  800535:	eb 05                	jmp    80053c <input+0x37>
			sys_yield();
  800537:	e8 1a 10 00 00       	call   801556 <sys_yield>
	// another packet in to the same physical page.
	while(1)
	{
		sys_page_alloc(0, &nsipcbuf, PTE_W|PTE_U|PTE_P);

		while((ret = sys_rx_packet(&nsipcbuf.pkt.jp_data, &nsipcbuf.pkt.jp_len)) < 0)
  80053c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  800543:	00 
  800544:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80054b:	e8 ed 12 00 00       	call   80183d <sys_rx_packet>
  800550:	85 c0                	test   %eax,%eax
  800552:	78 e3                	js     800537 <input+0x32>
			sys_yield();


		//cprintf("\ndata:%s",nsipcbuf.pkt.jp_data);
		while((sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U)) < 0);	
  800554:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80055b:	00 
  80055c:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  800563:	00 
  800564:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  80056b:	00 
  80056c:	89 1c 24             	mov    %ebx,(%esp)
  80056f:	e8 14 12 00 00       	call   801788 <sys_ipc_try_send>
  800574:	85 c0                	test   %eax,%eax
  800576:	78 dc                	js     800554 <input+0x4f>
  800578:	eb 9f                	jmp    800519 <input+0x14>
  80057a:	66 90                	xchg   %ax,%ax
  80057c:	66 90                	xchg   %ax,%ax
  80057e:	66 90                	xchg   %ax,%ax

00800580 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 2c             	sub    $0x2c,%esp
  800589:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int32_t reqno;
	uint32_t whom;
	int i, perm;
	void *va;
	int ret;
	binaryname = "ns_output";
  80058c:	c7 05 00 40 80 00 70 	movl   $0x803770,0x804000
  800593:	37 80 00 
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
	while(1)
	{
		reqno = ipc_recv((int32_t *) &whom, (void *)&nsipcbuf, &perm);
  800596:	8d 7d e0             	lea    -0x20(%ebp),%edi
  800599:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80059d:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8005a4:	00 
  8005a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005a8:	89 04 24             	mov    %eax,(%esp)
  8005ab:	e8 80 18 00 00       	call   801e30 <ipc_recv>
  8005b0:	89 c6                	mov    %eax,%esi
		while(1)
		{

			if((reqno == NSREQ_OUTPUT) && (whom == ns_envid))
  8005b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b5:	83 fe 0b             	cmp    $0xb,%esi
  8005b8:	75 49                	jne    800603 <output+0x83>
  8005ba:	39 c3                	cmp    %eax,%ebx
  8005bc:	75 fc                	jne    8005ba <output+0x3a>
			{
				//cprintf("\nreceived packet from ns server\n");
				//cprintf("\nlength of packet:%d\n",nsipcbuf.pkt.jp_len);
				//cprintf("\ndata:");
				ret = sys_tx_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  8005be:	a1 00 70 80 00       	mov    0x807000,%eax
  8005c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8005ce:	e8 49 12 00 00       	call   80181c <sys_tx_packet>
				if(ret == E_TX_DESC_SUCCESS)
  8005d3:	83 f8 10             	cmp    $0x10,%eax
  8005d6:	74 c1                	je     800599 <output+0x19>
					break;
				else if(ret == -E_TX_DESC_FAILURE)
  8005d8:	83 f8 ef             	cmp    $0xffffffef,%eax
  8005db:	75 0a                	jne    8005e7 <output+0x67>
				{
					sys_yield();
  8005dd:	8d 76 00             	lea    0x0(%esi),%esi
  8005e0:	e8 71 0f 00 00       	call   801556 <sys_yield>
  8005e5:	eb cb                	jmp    8005b2 <output+0x32>
				}
				else
					panic("\nError while sending transmittong packet\n");	
  8005e7:	c7 44 24 08 88 37 80 	movl   $0x803788,0x8(%esp)
  8005ee:	00 
  8005ef:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8005f6:	00 
  8005f7:	c7 04 24 7a 37 80 00 	movl   $0x80377a,(%esp)
  8005fe:	e8 8b 03 00 00       	call   80098e <_panic>
  800603:	eb fe                	jmp    800603 <output+0x83>
  800605:	66 90                	xchg   %ax,%ax
  800607:	66 90                	xchg   %ax,%ax
  800609:	66 90                	xchg   %ax,%ax
  80060b:	66 90                	xchg   %ax,%ax
  80060d:	66 90                	xchg   %ax,%ax
  80060f:	90                   	nop

00800610 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800610:	55                   	push   %ebp
  800611:	89 e5                	mov    %esp,%ebp
  800613:	57                   	push   %edi
  800614:	56                   	push   %esi
  800615:	53                   	push   %ebx
  800616:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80061f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800623:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800626:	c7 45 dc 08 50 80 00 	movl   $0x805008,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80062d:	be 00 00 00 00       	mov    $0x0,%esi
  800632:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800635:	eb 02                	jmp    800639 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800637:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800639:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80063c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80063f:	0f b6 c2             	movzbl %dl,%eax
  800642:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800645:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800648:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80064b:	66 c1 e8 0b          	shr    $0xb,%ax
  80064f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800651:	8d 4e 01             	lea    0x1(%esi),%ecx
  800654:	89 f3                	mov    %esi,%ebx
  800656:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800659:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80065c:	01 ff                	add    %edi,%edi
  80065e:	89 fb                	mov    %edi,%ebx
  800660:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800662:	83 c2 30             	add    $0x30,%edx
  800665:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800669:	84 c0                	test   %al,%al
  80066b:	75 ca                	jne    800637 <inet_ntoa+0x27>
  80066d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800670:	89 c8                	mov    %ecx,%eax
  800672:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800675:	89 cf                	mov    %ecx,%edi
  800677:	eb 0d                	jmp    800686 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800679:	0f b6 f0             	movzbl %al,%esi
  80067c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800681:	88 0a                	mov    %cl,(%edx)
  800683:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800686:	83 e8 01             	sub    $0x1,%eax
  800689:	3c ff                	cmp    $0xff,%al
  80068b:	75 ec                	jne    800679 <inet_ntoa+0x69>
  80068d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800690:	89 f9                	mov    %edi,%ecx
  800692:	0f b6 c9             	movzbl %cl,%ecx
  800695:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800698:	8d 41 01             	lea    0x1(%ecx),%eax
  80069b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80069e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8006a2:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  8006a6:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  8006aa:	77 0a                	ja     8006b6 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8006ac:	c6 01 2e             	movb   $0x2e,(%ecx)
  8006af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b4:	eb 81                	jmp    800637 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  8006b6:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  8006b9:	b8 08 50 80 00       	mov    $0x805008,%eax
  8006be:	83 c4 19             	add    $0x19,%esp
  8006c1:	5b                   	pop    %ebx
  8006c2:	5e                   	pop    %esi
  8006c3:	5f                   	pop    %edi
  8006c4:	5d                   	pop    %ebp
  8006c5:	c3                   	ret    

008006c6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8006c9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8006cd:	66 c1 c0 08          	rol    $0x8,%ax
}
  8006d1:	5d                   	pop    %ebp
  8006d2:	c3                   	ret    

008006d3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8006d6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8006da:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8006de:	5d                   	pop    %ebp
  8006df:	c3                   	ret    

008006e0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8006e6:	89 d1                	mov    %edx,%ecx
  8006e8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8006eb:	89 d0                	mov    %edx,%eax
  8006ed:	c1 e0 18             	shl    $0x18,%eax
  8006f0:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8006f2:	89 d1                	mov    %edx,%ecx
  8006f4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8006fa:	c1 e1 08             	shl    $0x8,%ecx
  8006fd:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  8006ff:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800705:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800708:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80070a:	5d                   	pop    %ebp
  80070b:	c3                   	ret    

0080070c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	57                   	push   %edi
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800718:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80071b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80071e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800721:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800724:	80 f9 09             	cmp    $0x9,%cl
  800727:	0f 87 a6 01 00 00    	ja     8008d3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80072d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800734:	83 fa 30             	cmp    $0x30,%edx
  800737:	75 2b                	jne    800764 <inet_aton+0x58>
      c = *++cp;
  800739:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80073d:	89 d1                	mov    %edx,%ecx
  80073f:	83 e1 df             	and    $0xffffffdf,%ecx
  800742:	80 f9 58             	cmp    $0x58,%cl
  800745:	74 0f                	je     800756 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800747:	83 c0 01             	add    $0x1,%eax
  80074a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80074d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800754:	eb 0e                	jmp    800764 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800756:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80075a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80075d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800764:	83 c0 01             	add    $0x1,%eax
  800767:	bf 00 00 00 00       	mov    $0x0,%edi
  80076c:	eb 03                	jmp    800771 <inet_aton+0x65>
  80076e:	83 c0 01             	add    $0x1,%eax
  800771:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800774:	89 d3                	mov    %edx,%ebx
  800776:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800779:	80 f9 09             	cmp    $0x9,%cl
  80077c:	77 0d                	ja     80078b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80077e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800782:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800786:	0f be 10             	movsbl (%eax),%edx
  800789:	eb e3                	jmp    80076e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80078b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80078f:	75 30                	jne    8007c1 <inet_aton+0xb5>
  800791:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800794:	88 4d df             	mov    %cl,-0x21(%ebp)
  800797:	89 d1                	mov    %edx,%ecx
  800799:	83 e1 df             	and    $0xffffffdf,%ecx
  80079c:	83 e9 41             	sub    $0x41,%ecx
  80079f:	80 f9 05             	cmp    $0x5,%cl
  8007a2:	77 23                	ja     8007c7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8007a4:	89 fb                	mov    %edi,%ebx
  8007a6:	c1 e3 04             	shl    $0x4,%ebx
  8007a9:	8d 7a 0a             	lea    0xa(%edx),%edi
  8007ac:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  8007b0:	19 c9                	sbb    %ecx,%ecx
  8007b2:	83 e1 20             	and    $0x20,%ecx
  8007b5:	83 c1 41             	add    $0x41,%ecx
  8007b8:	29 cf                	sub    %ecx,%edi
  8007ba:	09 df                	or     %ebx,%edi
        c = *++cp;
  8007bc:	0f be 10             	movsbl (%eax),%edx
  8007bf:	eb ad                	jmp    80076e <inet_aton+0x62>
  8007c1:	89 d0                	mov    %edx,%eax
  8007c3:	89 f9                	mov    %edi,%ecx
  8007c5:	eb 04                	jmp    8007cb <inet_aton+0xbf>
  8007c7:	89 d0                	mov    %edx,%eax
  8007c9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8007cb:	83 f8 2e             	cmp    $0x2e,%eax
  8007ce:	75 22                	jne    8007f2 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8007d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8007d6:	0f 84 fe 00 00 00    	je     8008da <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8007dc:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8007e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8007e6:	8d 46 01             	lea    0x1(%esi),%eax
  8007e9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8007ed:	e9 2f ff ff ff       	jmp    800721 <inet_aton+0x15>
  8007f2:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8007f4:	85 d2                	test   %edx,%edx
  8007f6:	74 27                	je     80081f <inet_aton+0x113>
    return (0);
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8007fd:	80 fb 1f             	cmp    $0x1f,%bl
  800800:	0f 86 e7 00 00 00    	jbe    8008ed <inet_aton+0x1e1>
  800806:	84 d2                	test   %dl,%dl
  800808:	0f 88 d3 00 00 00    	js     8008e1 <inet_aton+0x1d5>
  80080e:	83 fa 20             	cmp    $0x20,%edx
  800811:	74 0c                	je     80081f <inet_aton+0x113>
  800813:	83 ea 09             	sub    $0x9,%edx
  800816:	83 fa 04             	cmp    $0x4,%edx
  800819:	0f 87 ce 00 00 00    	ja     8008ed <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80081f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800822:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800825:	29 c2                	sub    %eax,%edx
  800827:	c1 fa 02             	sar    $0x2,%edx
  80082a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80082d:	83 fa 02             	cmp    $0x2,%edx
  800830:	74 22                	je     800854 <inet_aton+0x148>
  800832:	83 fa 02             	cmp    $0x2,%edx
  800835:	7f 0f                	jg     800846 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800837:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80083c:	85 d2                	test   %edx,%edx
  80083e:	0f 84 a9 00 00 00    	je     8008ed <inet_aton+0x1e1>
  800844:	eb 73                	jmp    8008b9 <inet_aton+0x1ad>
  800846:	83 fa 03             	cmp    $0x3,%edx
  800849:	74 26                	je     800871 <inet_aton+0x165>
  80084b:	83 fa 04             	cmp    $0x4,%edx
  80084e:	66 90                	xchg   %ax,%ax
  800850:	74 40                	je     800892 <inet_aton+0x186>
  800852:	eb 65                	jmp    8008b9 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800854:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800859:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80085f:	0f 87 88 00 00 00    	ja     8008ed <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800868:	c1 e0 18             	shl    $0x18,%eax
  80086b:	89 cf                	mov    %ecx,%edi
  80086d:	09 c7                	or     %eax,%edi
    break;
  80086f:	eb 48                	jmp    8008b9 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800876:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80087c:	77 6f                	ja     8008ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80087e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800881:	c1 e2 10             	shl    $0x10,%edx
  800884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800887:	c1 e0 18             	shl    $0x18,%eax
  80088a:	09 d0                	or     %edx,%eax
  80088c:	09 c8                	or     %ecx,%eax
  80088e:	89 c7                	mov    %eax,%edi
    break;
  800890:	eb 27                	jmp    8008b9 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800892:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800897:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80089d:	77 4e                	ja     8008ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80089f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a2:	c1 e2 10             	shl    $0x10,%edx
  8008a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008a8:	c1 e0 18             	shl    $0x18,%eax
  8008ab:	09 c2                	or     %eax,%edx
  8008ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b0:	c1 e0 08             	shl    $0x8,%eax
  8008b3:	09 d0                	or     %edx,%eax
  8008b5:	09 c8                	or     %ecx,%eax
  8008b7:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  8008b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008bd:	74 29                	je     8008e8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  8008bf:	89 3c 24             	mov    %edi,(%esp)
  8008c2:	e8 19 fe ff ff       	call   8006e0 <htonl>
  8008c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008ca:	89 06                	mov    %eax,(%esi)
  return (1);
  8008cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8008d1:	eb 1a                	jmp    8008ed <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d8:	eb 13                	jmp    8008ed <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
  8008df:	eb 0c                	jmp    8008ed <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8008e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e6:	eb 05                	jmp    8008ed <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8008e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8008ed:	83 c4 20             	add    $0x20,%esp
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5f                   	pop    %edi
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8008fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	89 04 24             	mov    %eax,(%esp)
  800908:	e8 ff fd ff ff       	call   80070c <inet_aton>
  80090d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80090f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800914:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800918:	c9                   	leave  
  800919:	c3                   	ret    

0080091a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	89 04 24             	mov    %eax,(%esp)
  800926:	e8 b5 fd ff ff       	call   8006e0 <htonl>
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	56                   	push   %esi
  800931:	53                   	push   %ebx
  800932:	83 ec 10             	sub    $0x10,%esp
  800935:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800938:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80093b:	e8 f7 0b 00 00       	call   801537 <sys_getenvid>
  800940:	25 ff 03 00 00       	and    $0x3ff,%eax
  800945:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800948:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80094d:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800952:	85 db                	test   %ebx,%ebx
  800954:	7e 07                	jle    80095d <libmain+0x30>
		binaryname = argv[0];
  800956:	8b 06                	mov    (%esi),%eax
  800958:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80095d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800961:	89 1c 24             	mov    %ebx,(%esp)
  800964:	e8 d7 f6 ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800969:	e8 07 00 00 00       	call   800975 <exit>
}
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	5b                   	pop    %ebx
  800972:	5e                   	pop    %esi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80097b:	e8 9a 17 00 00       	call   80211a <close_all>
	sys_env_destroy(0);
  800980:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800987:	e8 07 0b 00 00       	call   801493 <sys_env_destroy>
}
  80098c:	c9                   	leave  
  80098d:	c3                   	ret    

0080098e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	56                   	push   %esi
  800992:	53                   	push   %ebx
  800993:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800996:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800999:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80099f:	e8 93 0b 00 00       	call   801537 <sys_getenvid>
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009b2:	89 74 24 08          	mov    %esi,0x8(%esp)
  8009b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ba:	c7 04 24 bc 37 80 00 	movl   $0x8037bc,(%esp)
  8009c1:	e8 c1 00 00 00       	call   800a87 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cd:	89 04 24             	mov    %eax,(%esp)
  8009d0:	e8 51 00 00 00       	call   800a26 <vcprintf>
	cprintf("\n");
  8009d5:	c7 04 24 db 36 80 00 	movl   $0x8036db,(%esp)
  8009dc:	e8 a6 00 00 00       	call   800a87 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009e1:	cc                   	int3   
  8009e2:	eb fd                	jmp    8009e1 <_panic+0x53>

008009e4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	53                   	push   %ebx
  8009e8:	83 ec 14             	sub    $0x14,%esp
  8009eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8009ee:	8b 13                	mov    (%ebx),%edx
  8009f0:	8d 42 01             	lea    0x1(%edx),%eax
  8009f3:	89 03                	mov    %eax,(%ebx)
  8009f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8009fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a01:	75 19                	jne    800a1c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800a03:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800a0a:	00 
  800a0b:	8d 43 08             	lea    0x8(%ebx),%eax
  800a0e:	89 04 24             	mov    %eax,(%esp)
  800a11:	e8 40 0a 00 00       	call   801456 <sys_cputs>
		b->idx = 0;
  800a16:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800a1c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800a20:	83 c4 14             	add    $0x14,%esp
  800a23:	5b                   	pop    %ebx
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800a2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a36:	00 00 00 
	b.cnt = 0;
  800a39:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a40:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a51:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a5b:	c7 04 24 e4 09 80 00 	movl   $0x8009e4,(%esp)
  800a62:	e8 7d 01 00 00       	call   800be4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800a67:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a71:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a77:	89 04 24             	mov    %eax,(%esp)
  800a7a:	e8 d7 09 00 00       	call   801456 <sys_cputs>

	return b.cnt;
}
  800a7f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a85:	c9                   	leave  
  800a86:	c3                   	ret    

00800a87 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a8d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	89 04 24             	mov    %eax,(%esp)
  800a9a:	e8 87 ff ff ff       	call   800a26 <vcprintf>
	va_end(ap);

	return cnt;
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    
  800aa1:	66 90                	xchg   %ax,%ax
  800aa3:	66 90                	xchg   %ax,%ax
  800aa5:	66 90                	xchg   %ax,%ax
  800aa7:	66 90                	xchg   %ax,%ax
  800aa9:	66 90                	xchg   %ax,%ax
  800aab:	66 90                	xchg   %ax,%ax
  800aad:	66 90                	xchg   %ax,%ax
  800aaf:	90                   	nop

00800ab0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	57                   	push   %edi
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	83 ec 3c             	sub    $0x3c,%esp
  800ab9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800abc:	89 d7                	mov    %edx,%edi
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac7:	89 c3                	mov    %eax,%ebx
  800ac9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800acc:	8b 45 10             	mov    0x10(%ebp),%eax
  800acf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ad2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ada:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800add:	39 d9                	cmp    %ebx,%ecx
  800adf:	72 05                	jb     800ae6 <printnum+0x36>
  800ae1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800ae4:	77 69                	ja     800b4f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ae6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ae9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800aed:	83 ee 01             	sub    $0x1,%esi
  800af0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800af4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af8:	8b 44 24 08          	mov    0x8(%esp),%eax
  800afc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800b00:	89 c3                	mov    %eax,%ebx
  800b02:	89 d6                	mov    %edx,%esi
  800b04:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b07:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b0a:	89 54 24 08          	mov    %edx,0x8(%esp)
  800b0e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b15:	89 04 24             	mov    %eax,(%esp)
  800b18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b1f:	e8 6c 28 00 00       	call   803390 <__udivdi3>
  800b24:	89 d9                	mov    %ebx,%ecx
  800b26:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b2a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b2e:	89 04 24             	mov    %eax,(%esp)
  800b31:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b35:	89 fa                	mov    %edi,%edx
  800b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3a:	e8 71 ff ff ff       	call   800ab0 <printnum>
  800b3f:	eb 1b                	jmp    800b5c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b41:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b45:	8b 45 18             	mov    0x18(%ebp),%eax
  800b48:	89 04 24             	mov    %eax,(%esp)
  800b4b:	ff d3                	call   *%ebx
  800b4d:	eb 03                	jmp    800b52 <printnum+0xa2>
  800b4f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b52:	83 ee 01             	sub    $0x1,%esi
  800b55:	85 f6                	test   %esi,%esi
  800b57:	7f e8                	jg     800b41 <printnum+0x91>
  800b59:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b5c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b60:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b75:	89 04 24             	mov    %eax,(%esp)
  800b78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b7f:	e8 3c 29 00 00       	call   8034c0 <__umoddi3>
  800b84:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b88:	0f be 80 df 37 80 00 	movsbl 0x8037df(%eax),%eax
  800b8f:	89 04 24             	mov    %eax,(%esp)
  800b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b95:	ff d0                	call   *%eax
}
  800b97:	83 c4 3c             	add    $0x3c,%esp
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5f                   	pop    %edi
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800ba5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba9:	8b 10                	mov    (%eax),%edx
  800bab:	3b 50 04             	cmp    0x4(%eax),%edx
  800bae:	73 0a                	jae    800bba <sprintputch+0x1b>
		*b->buf++ = ch;
  800bb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb3:	89 08                	mov    %ecx,(%eax)
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	88 02                	mov    %al,(%edx)
}
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800bc5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 04 24             	mov    %eax,(%esp)
  800bdd:	e8 02 00 00 00       	call   800be4 <vprintfmt>
	va_end(ap);
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
  800bea:	83 ec 3c             	sub    $0x3c,%esp
  800bed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf0:	eb 17                	jmp    800c09 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800bf2:	85 c0                	test   %eax,%eax
  800bf4:	0f 84 4b 04 00 00    	je     801045 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  800bfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c01:	89 04 24             	mov    %eax,(%esp)
  800c04:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800c07:	89 fb                	mov    %edi,%ebx
  800c09:	8d 7b 01             	lea    0x1(%ebx),%edi
  800c0c:	0f b6 03             	movzbl (%ebx),%eax
  800c0f:	83 f8 25             	cmp    $0x25,%eax
  800c12:	75 de                	jne    800bf2 <vprintfmt+0xe>
  800c14:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800c18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800c1f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800c24:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800c2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c30:	eb 18                	jmp    800c4a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c32:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800c34:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800c38:	eb 10                	jmp    800c4a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c3c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800c40:	eb 08                	jmp    800c4a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800c42:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800c45:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c4a:	8d 5f 01             	lea    0x1(%edi),%ebx
  800c4d:	0f b6 17             	movzbl (%edi),%edx
  800c50:	0f b6 c2             	movzbl %dl,%eax
  800c53:	83 ea 23             	sub    $0x23,%edx
  800c56:	80 fa 55             	cmp    $0x55,%dl
  800c59:	0f 87 c2 03 00 00    	ja     801021 <vprintfmt+0x43d>
  800c5f:	0f b6 d2             	movzbl %dl,%edx
  800c62:	ff 24 95 20 39 80 00 	jmp    *0x803920(,%edx,4)
  800c69:	89 df                	mov    %ebx,%edi
  800c6b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800c70:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800c73:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800c77:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  800c7a:	8d 50 d0             	lea    -0x30(%eax),%edx
  800c7d:	83 fa 09             	cmp    $0x9,%edx
  800c80:	77 33                	ja     800cb5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c82:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c85:	eb e9                	jmp    800c70 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	8b 30                	mov    (%eax),%esi
  800c8c:	8d 40 04             	lea    0x4(%eax),%eax
  800c8f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c92:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800c94:	eb 1f                	jmp    800cb5 <vprintfmt+0xd1>
  800c96:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800c99:	85 ff                	test   %edi,%edi
  800c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca0:	0f 49 c7             	cmovns %edi,%eax
  800ca3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ca6:	89 df                	mov    %ebx,%edi
  800ca8:	eb a0                	jmp    800c4a <vprintfmt+0x66>
  800caa:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800cac:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800cb3:	eb 95                	jmp    800c4a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800cb5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cb9:	79 8f                	jns    800c4a <vprintfmt+0x66>
  800cbb:	eb 85                	jmp    800c42 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cbd:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cc0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800cc2:	eb 86                	jmp    800c4a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc7:	8d 70 04             	lea    0x4(%eax),%esi
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	89 04 24             	mov    %eax,(%esp)
  800cd9:	ff 55 08             	call   *0x8(%ebp)
  800cdc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  800cdf:	e9 25 ff ff ff       	jmp    800c09 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce7:	8d 70 04             	lea    0x4(%eax),%esi
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	99                   	cltd   
  800ced:	31 d0                	xor    %edx,%eax
  800cef:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cf1:	83 f8 15             	cmp    $0x15,%eax
  800cf4:	7f 0b                	jg     800d01 <vprintfmt+0x11d>
  800cf6:	8b 14 85 80 3a 80 00 	mov    0x803a80(,%eax,4),%edx
  800cfd:	85 d2                	test   %edx,%edx
  800cff:	75 26                	jne    800d27 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800d01:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d05:	c7 44 24 08 f7 37 80 	movl   $0x8037f7,0x8(%esp)
  800d0c:	00 
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	89 04 24             	mov    %eax,(%esp)
  800d1a:	e8 9d fe ff ff       	call   800bbc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800d22:	e9 e2 fe ff ff       	jmp    800c09 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d2b:	c7 44 24 08 ba 3c 80 	movl   $0x803cba,0x8(%esp)
  800d32:	00 
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	89 04 24             	mov    %eax,(%esp)
  800d40:	e8 77 fe ff ff       	call   800bbc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d45:	89 75 14             	mov    %esi,0x14(%ebp)
  800d48:	e9 bc fe ff ff       	jmp    800c09 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d50:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d53:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d56:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800d5a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800d5c:	85 ff                	test   %edi,%edi
  800d5e:	b8 f0 37 80 00       	mov    $0x8037f0,%eax
  800d63:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800d66:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  800d6a:	0f 84 94 00 00 00    	je     800e04 <vprintfmt+0x220>
  800d70:	85 c9                	test   %ecx,%ecx
  800d72:	0f 8e 94 00 00 00    	jle    800e0c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d78:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d7c:	89 3c 24             	mov    %edi,(%esp)
  800d7f:	e8 64 03 00 00       	call   8010e8 <strnlen>
  800d84:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800d87:	29 c1                	sub    %eax,%ecx
  800d89:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  800d8c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800d90:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800d93:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800d96:	8b 75 08             	mov    0x8(%ebp),%esi
  800d99:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d9c:	89 cb                	mov    %ecx,%ebx
  800d9e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da0:	eb 0f                	jmp    800db1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da9:	89 3c 24             	mov    %edi,(%esp)
  800dac:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dae:	83 eb 01             	sub    $0x1,%ebx
  800db1:	85 db                	test   %ebx,%ebx
  800db3:	7f ed                	jg     800da2 <vprintfmt+0x1be>
  800db5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800db8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800dbb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800dbe:	85 c9                	test   %ecx,%ecx
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc5:	0f 49 c1             	cmovns %ecx,%eax
  800dc8:	29 c1                	sub    %eax,%ecx
  800dca:	89 cb                	mov    %ecx,%ebx
  800dcc:	eb 44                	jmp    800e12 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800dce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd2:	74 1e                	je     800df2 <vprintfmt+0x20e>
  800dd4:	0f be d2             	movsbl %dl,%edx
  800dd7:	83 ea 20             	sub    $0x20,%edx
  800dda:	83 fa 5e             	cmp    $0x5e,%edx
  800ddd:	76 13                	jbe    800df2 <vprintfmt+0x20e>
					putch('?', putdat);
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800de6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800ded:	ff 55 08             	call   *0x8(%ebp)
  800df0:	eb 0d                	jmp    800dff <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800df9:	89 04 24             	mov    %eax,(%esp)
  800dfc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dff:	83 eb 01             	sub    $0x1,%ebx
  800e02:	eb 0e                	jmp    800e12 <vprintfmt+0x22e>
  800e04:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e07:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800e0a:	eb 06                	jmp    800e12 <vprintfmt+0x22e>
  800e0c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800e12:	83 c7 01             	add    $0x1,%edi
  800e15:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800e19:	0f be c2             	movsbl %dl,%eax
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	74 27                	je     800e47 <vprintfmt+0x263>
  800e20:	85 f6                	test   %esi,%esi
  800e22:	78 aa                	js     800dce <vprintfmt+0x1ea>
  800e24:	83 ee 01             	sub    $0x1,%esi
  800e27:	79 a5                	jns    800dce <vprintfmt+0x1ea>
  800e29:	89 d8                	mov    %ebx,%eax
  800e2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e2e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e31:	89 c3                	mov    %eax,%ebx
  800e33:	eb 18                	jmp    800e4d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800e35:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e39:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800e40:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e42:	83 eb 01             	sub    $0x1,%ebx
  800e45:	eb 06                	jmp    800e4d <vprintfmt+0x269>
  800e47:	8b 75 08             	mov    0x8(%ebp),%esi
  800e4a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e4d:	85 db                	test   %ebx,%ebx
  800e4f:	7f e4                	jg     800e35 <vprintfmt+0x251>
  800e51:	89 75 08             	mov    %esi,0x8(%ebp)
  800e54:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800e57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5a:	e9 aa fd ff ff       	jmp    800c09 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800e5f:	83 f9 01             	cmp    $0x1,%ecx
  800e62:	7e 10                	jle    800e74 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800e64:	8b 45 14             	mov    0x14(%ebp),%eax
  800e67:	8b 30                	mov    (%eax),%esi
  800e69:	8b 78 04             	mov    0x4(%eax),%edi
  800e6c:	8d 40 08             	lea    0x8(%eax),%eax
  800e6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e72:	eb 26                	jmp    800e9a <vprintfmt+0x2b6>
	else if (lflag)
  800e74:	85 c9                	test   %ecx,%ecx
  800e76:	74 12                	je     800e8a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800e78:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7b:	8b 30                	mov    (%eax),%esi
  800e7d:	89 f7                	mov    %esi,%edi
  800e7f:	c1 ff 1f             	sar    $0x1f,%edi
  800e82:	8d 40 04             	lea    0x4(%eax),%eax
  800e85:	89 45 14             	mov    %eax,0x14(%ebp)
  800e88:	eb 10                	jmp    800e9a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  800e8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8d:	8b 30                	mov    (%eax),%esi
  800e8f:	89 f7                	mov    %esi,%edi
  800e91:	c1 ff 1f             	sar    $0x1f,%edi
  800e94:	8d 40 04             	lea    0x4(%eax),%eax
  800e97:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e9a:	89 f0                	mov    %esi,%eax
  800e9c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800e9e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800ea3:	85 ff                	test   %edi,%edi
  800ea5:	0f 89 3a 01 00 00    	jns    800fe5 <vprintfmt+0x401>
				putch('-', putdat);
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eb2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800eb9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800ebc:	89 f0                	mov    %esi,%eax
  800ebe:	89 fa                	mov    %edi,%edx
  800ec0:	f7 d8                	neg    %eax
  800ec2:	83 d2 00             	adc    $0x0,%edx
  800ec5:	f7 da                	neg    %edx
			}
			base = 10;
  800ec7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ecc:	e9 14 01 00 00       	jmp    800fe5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ed1:	83 f9 01             	cmp    $0x1,%ecx
  800ed4:	7e 13                	jle    800ee9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	8b 50 04             	mov    0x4(%eax),%edx
  800edc:	8b 00                	mov    (%eax),%eax
  800ede:	8b 75 14             	mov    0x14(%ebp),%esi
  800ee1:	8d 4e 08             	lea    0x8(%esi),%ecx
  800ee4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800ee7:	eb 2c                	jmp    800f15 <vprintfmt+0x331>
	else if (lflag)
  800ee9:	85 c9                	test   %ecx,%ecx
  800eeb:	74 15                	je     800f02 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  800eed:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef7:	8b 75 14             	mov    0x14(%ebp),%esi
  800efa:	8d 76 04             	lea    0x4(%esi),%esi
  800efd:	89 75 14             	mov    %esi,0x14(%ebp)
  800f00:	eb 13                	jmp    800f15 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800f02:	8b 45 14             	mov    0x14(%ebp),%eax
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0c:	8b 75 14             	mov    0x14(%ebp),%esi
  800f0f:	8d 76 04             	lea    0x4(%esi),%esi
  800f12:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800f15:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800f1a:	e9 c6 00 00 00       	jmp    800fe5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f1f:	83 f9 01             	cmp    $0x1,%ecx
  800f22:	7e 13                	jle    800f37 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800f24:	8b 45 14             	mov    0x14(%ebp),%eax
  800f27:	8b 50 04             	mov    0x4(%eax),%edx
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	8b 75 14             	mov    0x14(%ebp),%esi
  800f2f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800f32:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800f35:	eb 24                	jmp    800f5b <vprintfmt+0x377>
	else if (lflag)
  800f37:	85 c9                	test   %ecx,%ecx
  800f39:	74 11                	je     800f4c <vprintfmt+0x368>
		return va_arg(*ap, long);
  800f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	99                   	cltd   
  800f41:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800f44:	8d 71 04             	lea    0x4(%ecx),%esi
  800f47:	89 75 14             	mov    %esi,0x14(%ebp)
  800f4a:	eb 0f                	jmp    800f5b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  800f4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4f:	8b 00                	mov    (%eax),%eax
  800f51:	99                   	cltd   
  800f52:	8b 75 14             	mov    0x14(%ebp),%esi
  800f55:	8d 76 04             	lea    0x4(%esi),%esi
  800f58:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  800f5b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800f60:	e9 80 00 00 00       	jmp    800fe5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f65:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f6f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800f76:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f80:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800f87:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800f8a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f8e:	8b 06                	mov    (%esi),%eax
  800f90:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800f95:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800f9a:	eb 49                	jmp    800fe5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f9c:	83 f9 01             	cmp    $0x1,%ecx
  800f9f:	7e 13                	jle    800fb4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800fa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa4:	8b 50 04             	mov    0x4(%eax),%edx
  800fa7:	8b 00                	mov    (%eax),%eax
  800fa9:	8b 75 14             	mov    0x14(%ebp),%esi
  800fac:	8d 4e 08             	lea    0x8(%esi),%ecx
  800faf:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800fb2:	eb 2c                	jmp    800fe0 <vprintfmt+0x3fc>
	else if (lflag)
  800fb4:	85 c9                	test   %ecx,%ecx
  800fb6:	74 15                	je     800fcd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800fb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbb:	8b 00                	mov    (%eax),%eax
  800fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800fc5:	8d 71 04             	lea    0x4(%ecx),%esi
  800fc8:	89 75 14             	mov    %esi,0x14(%ebp)
  800fcb:	eb 13                	jmp    800fe0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  800fcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd0:	8b 00                	mov    (%eax),%eax
  800fd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd7:	8b 75 14             	mov    0x14(%ebp),%esi
  800fda:	8d 76 04             	lea    0x4(%esi),%esi
  800fdd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800fe0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fe5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800fe9:	89 74 24 10          	mov    %esi,0x10(%esp)
  800fed:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800ff0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800ff4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ff8:	89 04 24             	mov    %eax,(%esp)
  800ffb:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	e8 a6 fa ff ff       	call   800ab0 <printnum>
			break;
  80100a:	e9 fa fb ff ff       	jmp    800c09 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80100f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801012:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801016:	89 04 24             	mov    %eax,(%esp)
  801019:	ff 55 08             	call   *0x8(%ebp)
			break;
  80101c:	e9 e8 fb ff ff       	jmp    800c09 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	89 44 24 04          	mov    %eax,0x4(%esp)
  801028:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80102f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801032:	89 fb                	mov    %edi,%ebx
  801034:	eb 03                	jmp    801039 <vprintfmt+0x455>
  801036:	83 eb 01             	sub    $0x1,%ebx
  801039:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80103d:	75 f7                	jne    801036 <vprintfmt+0x452>
  80103f:	90                   	nop
  801040:	e9 c4 fb ff ff       	jmp    800c09 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801045:	83 c4 3c             	add    $0x3c,%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 28             	sub    $0x28,%esp
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801059:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801060:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801063:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80106a:	85 c0                	test   %eax,%eax
  80106c:	74 30                	je     80109e <vsnprintf+0x51>
  80106e:	85 d2                	test   %edx,%edx
  801070:	7e 2c                	jle    80109e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801072:	8b 45 14             	mov    0x14(%ebp),%eax
  801075:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801080:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801083:	89 44 24 04          	mov    %eax,0x4(%esp)
  801087:	c7 04 24 9f 0b 80 00 	movl   $0x800b9f,(%esp)
  80108e:	e8 51 fb ff ff       	call   800be4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801096:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109c:	eb 05                	jmp    8010a3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80109e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010ab:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8010ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 04 24             	mov    %eax,(%esp)
  8010c6:	e8 82 ff ff ff       	call   80104d <vsnprintf>
	va_end(ap);

	return rc;
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    
  8010cd:	66 90                	xchg   %ax,%ax
  8010cf:	90                   	nop

008010d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010db:	eb 03                	jmp    8010e0 <strlen+0x10>
		n++;
  8010dd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8010e4:	75 f7                	jne    8010dd <strlen+0xd>
		n++;
	return n;
}
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f6:	eb 03                	jmp    8010fb <strnlen+0x13>
		n++;
  8010f8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fb:	39 d0                	cmp    %edx,%eax
  8010fd:	74 06                	je     801105 <strnlen+0x1d>
  8010ff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801103:	75 f3                	jne    8010f8 <strnlen+0x10>
		n++;
	return n;
}
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	53                   	push   %ebx
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801111:	89 c2                	mov    %eax,%edx
  801113:	83 c2 01             	add    $0x1,%edx
  801116:	83 c1 01             	add    $0x1,%ecx
  801119:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80111d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801120:	84 db                	test   %bl,%bl
  801122:	75 ef                	jne    801113 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801124:	5b                   	pop    %ebx
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	53                   	push   %ebx
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801131:	89 1c 24             	mov    %ebx,(%esp)
  801134:	e8 97 ff ff ff       	call   8010d0 <strlen>
	strcpy(dst + len, src);
  801139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801140:	01 d8                	add    %ebx,%eax
  801142:	89 04 24             	mov    %eax,(%esp)
  801145:	e8 bd ff ff ff       	call   801107 <strcpy>
	return dst;
}
  80114a:	89 d8                	mov    %ebx,%eax
  80114c:	83 c4 08             	add    $0x8,%esp
  80114f:	5b                   	pop    %ebx
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	56                   	push   %esi
  801156:	53                   	push   %ebx
  801157:	8b 75 08             	mov    0x8(%ebp),%esi
  80115a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115d:	89 f3                	mov    %esi,%ebx
  80115f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801162:	89 f2                	mov    %esi,%edx
  801164:	eb 0f                	jmp    801175 <strncpy+0x23>
		*dst++ = *src;
  801166:	83 c2 01             	add    $0x1,%edx
  801169:	0f b6 01             	movzbl (%ecx),%eax
  80116c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80116f:	80 39 01             	cmpb   $0x1,(%ecx)
  801172:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801175:	39 da                	cmp    %ebx,%edx
  801177:	75 ed                	jne    801166 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801179:	89 f0                	mov    %esi,%eax
  80117b:	5b                   	pop    %ebx
  80117c:	5e                   	pop    %esi
  80117d:	5d                   	pop    %ebp
  80117e:	c3                   	ret    

0080117f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	56                   	push   %esi
  801183:	53                   	push   %ebx
  801184:	8b 75 08             	mov    0x8(%ebp),%esi
  801187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80118d:	89 f0                	mov    %esi,%eax
  80118f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801193:	85 c9                	test   %ecx,%ecx
  801195:	75 0b                	jne    8011a2 <strlcpy+0x23>
  801197:	eb 1d                	jmp    8011b6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801199:	83 c0 01             	add    $0x1,%eax
  80119c:	83 c2 01             	add    $0x1,%edx
  80119f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011a2:	39 d8                	cmp    %ebx,%eax
  8011a4:	74 0b                	je     8011b1 <strlcpy+0x32>
  8011a6:	0f b6 0a             	movzbl (%edx),%ecx
  8011a9:	84 c9                	test   %cl,%cl
  8011ab:	75 ec                	jne    801199 <strlcpy+0x1a>
  8011ad:	89 c2                	mov    %eax,%edx
  8011af:	eb 02                	jmp    8011b3 <strlcpy+0x34>
  8011b1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8011b3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8011b6:	29 f0                	sub    %esi,%eax
}
  8011b8:	5b                   	pop    %ebx
  8011b9:	5e                   	pop    %esi
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    

008011bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8011c5:	eb 06                	jmp    8011cd <strcmp+0x11>
		p++, q++;
  8011c7:	83 c1 01             	add    $0x1,%ecx
  8011ca:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011cd:	0f b6 01             	movzbl (%ecx),%eax
  8011d0:	84 c0                	test   %al,%al
  8011d2:	74 04                	je     8011d8 <strcmp+0x1c>
  8011d4:	3a 02                	cmp    (%edx),%al
  8011d6:	74 ef                	je     8011c7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d8:	0f b6 c0             	movzbl %al,%eax
  8011db:	0f b6 12             	movzbl (%edx),%edx
  8011de:	29 d0                	sub    %edx,%eax
}
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    

008011e2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	53                   	push   %ebx
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ec:	89 c3                	mov    %eax,%ebx
  8011ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8011f1:	eb 06                	jmp    8011f9 <strncmp+0x17>
		n--, p++, q++;
  8011f3:	83 c0 01             	add    $0x1,%eax
  8011f6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011f9:	39 d8                	cmp    %ebx,%eax
  8011fb:	74 15                	je     801212 <strncmp+0x30>
  8011fd:	0f b6 08             	movzbl (%eax),%ecx
  801200:	84 c9                	test   %cl,%cl
  801202:	74 04                	je     801208 <strncmp+0x26>
  801204:	3a 0a                	cmp    (%edx),%cl
  801206:	74 eb                	je     8011f3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801208:	0f b6 00             	movzbl (%eax),%eax
  80120b:	0f b6 12             	movzbl (%edx),%edx
  80120e:	29 d0                	sub    %edx,%eax
  801210:	eb 05                	jmp    801217 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801212:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801217:	5b                   	pop    %ebx
  801218:	5d                   	pop    %ebp
  801219:	c3                   	ret    

0080121a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801224:	eb 07                	jmp    80122d <strchr+0x13>
		if (*s == c)
  801226:	38 ca                	cmp    %cl,%dl
  801228:	74 0f                	je     801239 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80122a:	83 c0 01             	add    $0x1,%eax
  80122d:	0f b6 10             	movzbl (%eax),%edx
  801230:	84 d2                	test   %dl,%dl
  801232:	75 f2                	jne    801226 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801245:	eb 07                	jmp    80124e <strfind+0x13>
		if (*s == c)
  801247:	38 ca                	cmp    %cl,%dl
  801249:	74 0a                	je     801255 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80124b:	83 c0 01             	add    $0x1,%eax
  80124e:	0f b6 10             	movzbl (%eax),%edx
  801251:	84 d2                	test   %dl,%dl
  801253:	75 f2                	jne    801247 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801255:	5d                   	pop    %ebp
  801256:	c3                   	ret    

00801257 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	57                   	push   %edi
  80125b:	56                   	push   %esi
  80125c:	53                   	push   %ebx
  80125d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801260:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801263:	85 c9                	test   %ecx,%ecx
  801265:	74 36                	je     80129d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801267:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80126d:	75 28                	jne    801297 <memset+0x40>
  80126f:	f6 c1 03             	test   $0x3,%cl
  801272:	75 23                	jne    801297 <memset+0x40>
		c &= 0xFF;
  801274:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801278:	89 d3                	mov    %edx,%ebx
  80127a:	c1 e3 08             	shl    $0x8,%ebx
  80127d:	89 d6                	mov    %edx,%esi
  80127f:	c1 e6 18             	shl    $0x18,%esi
  801282:	89 d0                	mov    %edx,%eax
  801284:	c1 e0 10             	shl    $0x10,%eax
  801287:	09 f0                	or     %esi,%eax
  801289:	09 c2                	or     %eax,%edx
  80128b:	89 d0                	mov    %edx,%eax
  80128d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80128f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801292:	fc                   	cld    
  801293:	f3 ab                	rep stos %eax,%es:(%edi)
  801295:	eb 06                	jmp    80129d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	fc                   	cld    
  80129b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80129d:	89 f8                	mov    %edi,%eax
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5f                   	pop    %edi
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    

008012a4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	57                   	push   %edi
  8012a8:	56                   	push   %esi
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012b2:	39 c6                	cmp    %eax,%esi
  8012b4:	73 35                	jae    8012eb <memmove+0x47>
  8012b6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8012b9:	39 d0                	cmp    %edx,%eax
  8012bb:	73 2e                	jae    8012eb <memmove+0x47>
		s += n;
		d += n;
  8012bd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8012c0:	89 d6                	mov    %edx,%esi
  8012c2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012c4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8012ca:	75 13                	jne    8012df <memmove+0x3b>
  8012cc:	f6 c1 03             	test   $0x3,%cl
  8012cf:	75 0e                	jne    8012df <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012d1:	83 ef 04             	sub    $0x4,%edi
  8012d4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8012d7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012da:	fd                   	std    
  8012db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012dd:	eb 09                	jmp    8012e8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012df:	83 ef 01             	sub    $0x1,%edi
  8012e2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012e5:	fd                   	std    
  8012e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012e8:	fc                   	cld    
  8012e9:	eb 1d                	jmp    801308 <memmove+0x64>
  8012eb:	89 f2                	mov    %esi,%edx
  8012ed:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012ef:	f6 c2 03             	test   $0x3,%dl
  8012f2:	75 0f                	jne    801303 <memmove+0x5f>
  8012f4:	f6 c1 03             	test   $0x3,%cl
  8012f7:	75 0a                	jne    801303 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012f9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012fc:	89 c7                	mov    %eax,%edi
  8012fe:	fc                   	cld    
  8012ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801301:	eb 05                	jmp    801308 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801303:	89 c7                	mov    %eax,%edi
  801305:	fc                   	cld    
  801306:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801308:	5e                   	pop    %esi
  801309:	5f                   	pop    %edi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	89 44 24 08          	mov    %eax,0x8(%esp)
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	89 04 24             	mov    %eax,(%esp)
  801326:	e8 79 ff ff ff       	call   8012a4 <memmove>
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	8b 55 08             	mov    0x8(%ebp),%edx
  801335:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801338:	89 d6                	mov    %edx,%esi
  80133a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80133d:	eb 1a                	jmp    801359 <memcmp+0x2c>
		if (*s1 != *s2)
  80133f:	0f b6 02             	movzbl (%edx),%eax
  801342:	0f b6 19             	movzbl (%ecx),%ebx
  801345:	38 d8                	cmp    %bl,%al
  801347:	74 0a                	je     801353 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801349:	0f b6 c0             	movzbl %al,%eax
  80134c:	0f b6 db             	movzbl %bl,%ebx
  80134f:	29 d8                	sub    %ebx,%eax
  801351:	eb 0f                	jmp    801362 <memcmp+0x35>
		s1++, s2++;
  801353:	83 c2 01             	add    $0x1,%edx
  801356:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801359:	39 f2                	cmp    %esi,%edx
  80135b:	75 e2                	jne    80133f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80135d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801362:	5b                   	pop    %ebx
  801363:	5e                   	pop    %esi
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    

00801366 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80136f:	89 c2                	mov    %eax,%edx
  801371:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801374:	eb 07                	jmp    80137d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801376:	38 08                	cmp    %cl,(%eax)
  801378:	74 07                	je     801381 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80137a:	83 c0 01             	add    $0x1,%eax
  80137d:	39 d0                	cmp    %edx,%eax
  80137f:	72 f5                	jb     801376 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    

00801383 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	57                   	push   %edi
  801387:	56                   	push   %esi
  801388:	53                   	push   %ebx
  801389:	8b 55 08             	mov    0x8(%ebp),%edx
  80138c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138f:	eb 03                	jmp    801394 <strtol+0x11>
		s++;
  801391:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801394:	0f b6 0a             	movzbl (%edx),%ecx
  801397:	80 f9 09             	cmp    $0x9,%cl
  80139a:	74 f5                	je     801391 <strtol+0xe>
  80139c:	80 f9 20             	cmp    $0x20,%cl
  80139f:	74 f0                	je     801391 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a1:	80 f9 2b             	cmp    $0x2b,%cl
  8013a4:	75 0a                	jne    8013b0 <strtol+0x2d>
		s++;
  8013a6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8013a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8013ae:	eb 11                	jmp    8013c1 <strtol+0x3e>
  8013b0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8013b5:	80 f9 2d             	cmp    $0x2d,%cl
  8013b8:	75 07                	jne    8013c1 <strtol+0x3e>
		s++, neg = 1;
  8013ba:	8d 52 01             	lea    0x1(%edx),%edx
  8013bd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8013c6:	75 15                	jne    8013dd <strtol+0x5a>
  8013c8:	80 3a 30             	cmpb   $0x30,(%edx)
  8013cb:	75 10                	jne    8013dd <strtol+0x5a>
  8013cd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8013d1:	75 0a                	jne    8013dd <strtol+0x5a>
		s += 2, base = 16;
  8013d3:	83 c2 02             	add    $0x2,%edx
  8013d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8013db:	eb 10                	jmp    8013ed <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	75 0c                	jne    8013ed <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8013e1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8013e3:	80 3a 30             	cmpb   $0x30,(%edx)
  8013e6:	75 05                	jne    8013ed <strtol+0x6a>
		s++, base = 8;
  8013e8:	83 c2 01             	add    $0x1,%edx
  8013eb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8013ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013f5:	0f b6 0a             	movzbl (%edx),%ecx
  8013f8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8013fb:	89 f0                	mov    %esi,%eax
  8013fd:	3c 09                	cmp    $0x9,%al
  8013ff:	77 08                	ja     801409 <strtol+0x86>
			dig = *s - '0';
  801401:	0f be c9             	movsbl %cl,%ecx
  801404:	83 e9 30             	sub    $0x30,%ecx
  801407:	eb 20                	jmp    801429 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801409:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80140c:	89 f0                	mov    %esi,%eax
  80140e:	3c 19                	cmp    $0x19,%al
  801410:	77 08                	ja     80141a <strtol+0x97>
			dig = *s - 'a' + 10;
  801412:	0f be c9             	movsbl %cl,%ecx
  801415:	83 e9 57             	sub    $0x57,%ecx
  801418:	eb 0f                	jmp    801429 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80141a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80141d:	89 f0                	mov    %esi,%eax
  80141f:	3c 19                	cmp    $0x19,%al
  801421:	77 16                	ja     801439 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801423:	0f be c9             	movsbl %cl,%ecx
  801426:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801429:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80142c:	7d 0f                	jge    80143d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80142e:	83 c2 01             	add    $0x1,%edx
  801431:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801435:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801437:	eb bc                	jmp    8013f5 <strtol+0x72>
  801439:	89 d8                	mov    %ebx,%eax
  80143b:	eb 02                	jmp    80143f <strtol+0xbc>
  80143d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80143f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801443:	74 05                	je     80144a <strtol+0xc7>
		*endptr = (char *) s;
  801445:	8b 75 0c             	mov    0xc(%ebp),%esi
  801448:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80144a:	f7 d8                	neg    %eax
  80144c:	85 ff                	test   %edi,%edi
  80144e:	0f 44 c3             	cmove  %ebx,%eax
}
  801451:	5b                   	pop    %ebx
  801452:	5e                   	pop    %esi
  801453:	5f                   	pop    %edi
  801454:	5d                   	pop    %ebp
  801455:	c3                   	ret    

00801456 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	57                   	push   %edi
  80145a:	56                   	push   %esi
  80145b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
  801461:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801464:	8b 55 08             	mov    0x8(%ebp),%edx
  801467:	89 c3                	mov    %eax,%ebx
  801469:	89 c7                	mov    %eax,%edi
  80146b:	89 c6                	mov    %eax,%esi
  80146d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80146f:	5b                   	pop    %ebx
  801470:	5e                   	pop    %esi
  801471:	5f                   	pop    %edi
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    

00801474 <sys_cgetc>:

int
sys_cgetc(void)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	57                   	push   %edi
  801478:	56                   	push   %esi
  801479:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80147a:	ba 00 00 00 00       	mov    $0x0,%edx
  80147f:	b8 01 00 00 00       	mov    $0x1,%eax
  801484:	89 d1                	mov    %edx,%ecx
  801486:	89 d3                	mov    %edx,%ebx
  801488:	89 d7                	mov    %edx,%edi
  80148a:	89 d6                	mov    %edx,%esi
  80148c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80148e:	5b                   	pop    %ebx
  80148f:	5e                   	pop    %esi
  801490:	5f                   	pop    %edi
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    

00801493 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	57                   	push   %edi
  801497:	56                   	push   %esi
  801498:	53                   	push   %ebx
  801499:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80149c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 cb                	mov    %ecx,%ebx
  8014ab:	89 cf                	mov    %ecx,%edi
  8014ad:	89 ce                	mov    %ecx,%esi
  8014af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	7e 28                	jle    8014dd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014b9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8014c0:	00 
  8014c1:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  8014c8:	00 
  8014c9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014d0:	00 
  8014d1:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  8014d8:	e8 b1 f4 ff ff       	call   80098e <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014dd:	83 c4 2c             	add    $0x2c,%esp
  8014e0:	5b                   	pop    %ebx
  8014e1:	5e                   	pop    %esi
  8014e2:	5f                   	pop    %edi
  8014e3:	5d                   	pop    %ebp
  8014e4:	c3                   	ret    

008014e5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	57                   	push   %edi
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014f3:	b8 04 00 00 00       	mov    $0x4,%eax
  8014f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fb:	89 cb                	mov    %ecx,%ebx
  8014fd:	89 cf                	mov    %ecx,%edi
  8014ff:	89 ce                	mov    %ecx,%esi
  801501:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801503:	85 c0                	test   %eax,%eax
  801505:	7e 28                	jle    80152f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801507:	89 44 24 10          	mov    %eax,0x10(%esp)
  80150b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801512:	00 
  801513:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  80151a:	00 
  80151b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801522:	00 
  801523:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  80152a:	e8 5f f4 ff ff       	call   80098e <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  80152f:	83 c4 2c             	add    $0x2c,%esp
  801532:	5b                   	pop    %ebx
  801533:	5e                   	pop    %esi
  801534:	5f                   	pop    %edi
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	57                   	push   %edi
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80153d:	ba 00 00 00 00       	mov    $0x0,%edx
  801542:	b8 02 00 00 00       	mov    $0x2,%eax
  801547:	89 d1                	mov    %edx,%ecx
  801549:	89 d3                	mov    %edx,%ebx
  80154b:	89 d7                	mov    %edx,%edi
  80154d:	89 d6                	mov    %edx,%esi
  80154f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801551:	5b                   	pop    %ebx
  801552:	5e                   	pop    %esi
  801553:	5f                   	pop    %edi
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    

00801556 <sys_yield>:

void
sys_yield(void)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	57                   	push   %edi
  80155a:	56                   	push   %esi
  80155b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80155c:	ba 00 00 00 00       	mov    $0x0,%edx
  801561:	b8 0c 00 00 00       	mov    $0xc,%eax
  801566:	89 d1                	mov    %edx,%ecx
  801568:	89 d3                	mov    %edx,%ebx
  80156a:	89 d7                	mov    %edx,%edi
  80156c:	89 d6                	mov    %edx,%esi
  80156e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801570:	5b                   	pop    %ebx
  801571:	5e                   	pop    %esi
  801572:	5f                   	pop    %edi
  801573:	5d                   	pop    %ebp
  801574:	c3                   	ret    

00801575 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	57                   	push   %edi
  801579:	56                   	push   %esi
  80157a:	53                   	push   %ebx
  80157b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80157e:	be 00 00 00 00       	mov    $0x0,%esi
  801583:	b8 05 00 00 00       	mov    $0x5,%eax
  801588:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80158b:	8b 55 08             	mov    0x8(%ebp),%edx
  80158e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801591:	89 f7                	mov    %esi,%edi
  801593:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801595:	85 c0                	test   %eax,%eax
  801597:	7e 28                	jle    8015c1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801599:	89 44 24 10          	mov    %eax,0x10(%esp)
  80159d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8015a4:	00 
  8015a5:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  8015ac:	00 
  8015ad:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015b4:	00 
  8015b5:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  8015bc:	e8 cd f3 ff ff       	call   80098e <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8015c1:	83 c4 2c             	add    $0x2c,%esp
  8015c4:	5b                   	pop    %ebx
  8015c5:	5e                   	pop    %esi
  8015c6:	5f                   	pop    %edi
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    

008015c9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	57                   	push   %edi
  8015cd:	56                   	push   %esi
  8015ce:	53                   	push   %ebx
  8015cf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d2:	b8 06 00 00 00       	mov    $0x6,%eax
  8015d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015da:	8b 55 08             	mov    0x8(%ebp),%edx
  8015dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015e0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8015e6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	7e 28                	jle    801614 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015f0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8015f7:	00 
  8015f8:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  8015ff:	00 
  801600:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801607:	00 
  801608:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  80160f:	e8 7a f3 ff ff       	call   80098e <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801614:	83 c4 2c             	add    $0x2c,%esp
  801617:	5b                   	pop    %ebx
  801618:	5e                   	pop    %esi
  801619:	5f                   	pop    %edi
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	57                   	push   %edi
  801620:	56                   	push   %esi
  801621:	53                   	push   %ebx
  801622:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801625:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162a:	b8 07 00 00 00       	mov    $0x7,%eax
  80162f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801632:	8b 55 08             	mov    0x8(%ebp),%edx
  801635:	89 df                	mov    %ebx,%edi
  801637:	89 de                	mov    %ebx,%esi
  801639:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80163b:	85 c0                	test   %eax,%eax
  80163d:	7e 28                	jle    801667 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80163f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801643:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80164a:	00 
  80164b:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  801652:	00 
  801653:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80165a:	00 
  80165b:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  801662:	e8 27 f3 ff ff       	call   80098e <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801667:	83 c4 2c             	add    $0x2c,%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5f                   	pop    %edi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    

0080166f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	57                   	push   %edi
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801675:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167a:	b8 10 00 00 00       	mov    $0x10,%eax
  80167f:	8b 55 08             	mov    0x8(%ebp),%edx
  801682:	89 cb                	mov    %ecx,%ebx
  801684:	89 cf                	mov    %ecx,%edi
  801686:	89 ce                	mov    %ecx,%esi
  801688:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80168a:	5b                   	pop    %ebx
  80168b:	5e                   	pop    %esi
  80168c:	5f                   	pop    %edi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    

0080168f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	57                   	push   %edi
  801693:	56                   	push   %esi
  801694:	53                   	push   %ebx
  801695:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801698:	bb 00 00 00 00       	mov    $0x0,%ebx
  80169d:	b8 09 00 00 00       	mov    $0x9,%eax
  8016a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a8:	89 df                	mov    %ebx,%edi
  8016aa:	89 de                	mov    %ebx,%esi
  8016ac:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	7e 28                	jle    8016da <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016b2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016b6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8016bd:	00 
  8016be:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  8016c5:	00 
  8016c6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016cd:	00 
  8016ce:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  8016d5:	e8 b4 f2 ff ff       	call   80098e <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8016da:	83 c4 2c             	add    $0x2c,%esp
  8016dd:	5b                   	pop    %ebx
  8016de:	5e                   	pop    %esi
  8016df:	5f                   	pop    %edi
  8016e0:	5d                   	pop    %ebp
  8016e1:	c3                   	ret    

008016e2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	57                   	push   %edi
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fb:	89 df                	mov    %ebx,%edi
  8016fd:	89 de                	mov    %ebx,%esi
  8016ff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801701:	85 c0                	test   %eax,%eax
  801703:	7e 28                	jle    80172d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801705:	89 44 24 10          	mov    %eax,0x10(%esp)
  801709:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801710:	00 
  801711:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  801718:	00 
  801719:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801720:	00 
  801721:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  801728:	e8 61 f2 ff ff       	call   80098e <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80172d:	83 c4 2c             	add    $0x2c,%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5f                   	pop    %edi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	57                   	push   %edi
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80173e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801743:	b8 0b 00 00 00       	mov    $0xb,%eax
  801748:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	89 df                	mov    %ebx,%edi
  801750:	89 de                	mov    %ebx,%esi
  801752:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801754:	85 c0                	test   %eax,%eax
  801756:	7e 28                	jle    801780 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801758:	89 44 24 10          	mov    %eax,0x10(%esp)
  80175c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801763:	00 
  801764:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  80176b:	00 
  80176c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801773:	00 
  801774:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  80177b:	e8 0e f2 ff ff       	call   80098e <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801780:	83 c4 2c             	add    $0x2c,%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	57                   	push   %edi
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80178e:	be 00 00 00 00       	mov    $0x0,%esi
  801793:	b8 0d 00 00 00       	mov    $0xd,%eax
  801798:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179b:	8b 55 08             	mov    0x8(%ebp),%edx
  80179e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017a1:	8b 7d 14             	mov    0x14(%ebp),%edi
  8017a4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5f                   	pop    %edi
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    

008017ab <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	57                   	push   %edi
  8017af:	56                   	push   %esi
  8017b0:	53                   	push   %ebx
  8017b1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8017be:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c1:	89 cb                	mov    %ecx,%ebx
  8017c3:	89 cf                	mov    %ecx,%edi
  8017c5:	89 ce                	mov    %ecx,%esi
  8017c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	7e 28                	jle    8017f5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017d1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8017d8:	00 
  8017d9:	c7 44 24 08 f7 3a 80 	movl   $0x803af7,0x8(%esp)
  8017e0:	00 
  8017e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017e8:	00 
  8017e9:	c7 04 24 14 3b 80 00 	movl   $0x803b14,(%esp)
  8017f0:	e8 99 f1 ff ff       	call   80098e <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8017f5:	83 c4 2c             	add    $0x2c,%esp
  8017f8:	5b                   	pop    %ebx
  8017f9:	5e                   	pop    %esi
  8017fa:	5f                   	pop    %edi
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	57                   	push   %edi
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801803:	ba 00 00 00 00       	mov    $0x0,%edx
  801808:	b8 0f 00 00 00       	mov    $0xf,%eax
  80180d:	89 d1                	mov    %edx,%ecx
  80180f:	89 d3                	mov    %edx,%ebx
  801811:	89 d7                	mov    %edx,%edi
  801813:	89 d6                	mov    %edx,%esi
  801815:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	57                   	push   %edi
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801822:	bb 00 00 00 00       	mov    $0x0,%ebx
  801827:	b8 11 00 00 00       	mov    $0x11,%eax
  80182c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80182f:	8b 55 08             	mov    0x8(%ebp),%edx
  801832:	89 df                	mov    %ebx,%edi
  801834:	89 de                	mov    %ebx,%esi
  801836:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801838:	5b                   	pop    %ebx
  801839:	5e                   	pop    %esi
  80183a:	5f                   	pop    %edi
  80183b:	5d                   	pop    %ebp
  80183c:	c3                   	ret    

0080183d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	57                   	push   %edi
  801841:	56                   	push   %esi
  801842:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801843:	bb 00 00 00 00       	mov    $0x0,%ebx
  801848:	b8 12 00 00 00       	mov    $0x12,%eax
  80184d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801850:	8b 55 08             	mov    0x8(%ebp),%edx
  801853:	89 df                	mov    %ebx,%edi
  801855:	89 de                	mov    %ebx,%esi
  801857:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801859:	5b                   	pop    %ebx
  80185a:	5e                   	pop    %esi
  80185b:	5f                   	pop    %edi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	57                   	push   %edi
  801862:	56                   	push   %esi
  801863:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801864:	b9 00 00 00 00       	mov    $0x0,%ecx
  801869:	b8 13 00 00 00       	mov    $0x13,%eax
  80186e:	8b 55 08             	mov    0x8(%ebp),%edx
  801871:	89 cb                	mov    %ecx,%ebx
  801873:	89 cf                	mov    %ecx,%edi
  801875:	89 ce                	mov    %ecx,%esi
  801877:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801879:	5b                   	pop    %ebx
  80187a:	5e                   	pop    %esi
  80187b:	5f                   	pop    %edi
  80187c:	5d                   	pop    %ebp
  80187d:	c3                   	ret    

0080187e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	57                   	push   %edi
  801882:	56                   	push   %esi
  801883:	53                   	push   %ebx
  801884:	83 ec 2c             	sub    $0x2c,%esp
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80188a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80188c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80188f:	89 f8                	mov    %edi,%eax
  801891:	c1 e8 0c             	shr    $0xc,%eax
  801894:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801897:	e8 9b fc ff ff       	call   801537 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80189c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  8018a2:	0f 84 de 00 00 00    	je     801986 <pgfault+0x108>
  8018a8:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	79 20                	jns    8018ce <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  8018ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018b2:	c7 44 24 08 22 3b 80 	movl   $0x803b22,0x8(%esp)
  8018b9:	00 
  8018ba:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8018c1:	00 
  8018c2:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  8018c9:	e8 c0 f0 ff ff       	call   80098e <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  8018ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  8018d8:	25 05 08 00 00       	and    $0x805,%eax
  8018dd:	3d 05 08 00 00       	cmp    $0x805,%eax
  8018e2:	0f 85 ba 00 00 00    	jne    8019a2 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018e8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8018ef:	00 
  8018f0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8018f7:	00 
  8018f8:	89 1c 24             	mov    %ebx,(%esp)
  8018fb:	e8 75 fc ff ff       	call   801575 <sys_page_alloc>
  801900:	85 c0                	test   %eax,%eax
  801902:	79 20                	jns    801924 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801904:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801908:	c7 44 24 08 49 3b 80 	movl   $0x803b49,0x8(%esp)
  80190f:	00 
  801910:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801917:	00 
  801918:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  80191f:	e8 6a f0 ff ff       	call   80098e <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801924:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80192a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801931:	00 
  801932:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801936:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80193d:	e8 62 f9 ff ff       	call   8012a4 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801942:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801949:	00 
  80194a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80194e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801952:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801959:	00 
  80195a:	89 1c 24             	mov    %ebx,(%esp)
  80195d:	e8 67 fc ff ff       	call   8015c9 <sys_page_map>
  801962:	85 c0                	test   %eax,%eax
  801964:	79 3c                	jns    8019a2 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801966:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80196a:	c7 44 24 08 78 36 80 	movl   $0x803678,0x8(%esp)
  801971:	00 
  801972:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801979:	00 
  80197a:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801981:	e8 08 f0 ff ff       	call   80098e <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801986:	c7 44 24 08 70 3b 80 	movl   $0x803b70,0x8(%esp)
  80198d:	00 
  80198e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801995:	00 
  801996:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  80199d:	e8 ec ef ff ff       	call   80098e <_panic>
}
  8019a2:	83 c4 2c             	add    $0x2c,%esp
  8019a5:	5b                   	pop    %ebx
  8019a6:	5e                   	pop    %esi
  8019a7:	5f                   	pop    %edi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	56                   	push   %esi
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 20             	sub    $0x20,%esp
  8019b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8019b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8019b8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8019bf:	00 
  8019c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019c4:	89 34 24             	mov    %esi,(%esp)
  8019c7:	e8 a9 fb ff ff       	call   801575 <sys_page_alloc>
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	79 20                	jns    8019f0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  8019d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019d4:	c7 44 24 08 49 3b 80 	movl   $0x803b49,0x8(%esp)
  8019db:	00 
  8019dc:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8019e3:	00 
  8019e4:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  8019eb:	e8 9e ef ff ff       	call   80098e <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019f0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8019f7:	00 
  8019f8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8019ff:	00 
  801a00:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a07:	00 
  801a08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a0c:	89 34 24             	mov    %esi,(%esp)
  801a0f:	e8 b5 fb ff ff       	call   8015c9 <sys_page_map>
  801a14:	85 c0                	test   %eax,%eax
  801a16:	79 20                	jns    801a38 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801a18:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a1c:	c7 44 24 08 78 36 80 	movl   $0x803678,0x8(%esp)
  801a23:	00 
  801a24:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  801a2b:	00 
  801a2c:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801a33:	e8 56 ef ff ff       	call   80098e <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801a38:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801a3f:	00 
  801a40:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a44:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801a4b:	e8 54 f8 ff ff       	call   8012a4 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801a50:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a57:	00 
  801a58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5f:	e8 b8 fb ff ff       	call   80161c <sys_page_unmap>
  801a64:	85 c0                	test   %eax,%eax
  801a66:	79 20                	jns    801a88 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801a68:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a6c:	c7 44 24 08 5c 3b 80 	movl   $0x803b5c,0x8(%esp)
  801a73:	00 
  801a74:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801a7b:	00 
  801a7c:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801a83:	e8 06 ef ff ff       	call   80098e <_panic>

}
  801a88:	83 c4 20             	add    $0x20,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	57                   	push   %edi
  801a93:	56                   	push   %esi
  801a94:	53                   	push   %ebx
  801a95:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801a98:	c7 04 24 7e 18 80 00 	movl   $0x80187e,(%esp)
  801a9f:	e8 f2 17 00 00       	call   803296 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801aa4:	b8 08 00 00 00       	mov    $0x8,%eax
  801aa9:	cd 30                	int    $0x30
  801aab:	89 c6                	mov    %eax,%esi
  801aad:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	79 20                	jns    801ad4 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801ab4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ab8:	c7 44 24 08 94 3b 80 	movl   $0x803b94,0x8(%esp)
  801abf:	00 
  801ac0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801ac7:	00 
  801ac8:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801acf:	e8 ba ee ff ff       	call   80098e <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801ad4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	75 21                	jne    801afe <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  801add:	e8 55 fa ff ff       	call   801537 <sys_getenvid>
  801ae2:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ae7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801aea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801aef:	a3 20 50 80 00       	mov    %eax,0x805020
		//set_pgfault_handler(pgfault);
		return 0;
  801af4:	b8 00 00 00 00       	mov    $0x0,%eax
  801af9:	e9 88 01 00 00       	jmp    801c86 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801afe:	89 d8                	mov    %ebx,%eax
  801b00:	c1 e8 16             	shr    $0x16,%eax
  801b03:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b0a:	a8 01                	test   $0x1,%al
  801b0c:	0f 84 e0 00 00 00    	je     801bf2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801b12:	89 df                	mov    %ebx,%edi
  801b14:	c1 ef 0c             	shr    $0xc,%edi
  801b17:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  801b1e:	a8 01                	test   $0x1,%al
  801b20:	0f 84 c4 00 00 00    	je     801bea <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801b26:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  801b2d:	f6 c4 04             	test   $0x4,%ah
  801b30:	74 0d                	je     801b3f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801b32:	25 07 0e 00 00       	and    $0xe07,%eax
  801b37:	83 c8 05             	or     $0x5,%eax
  801b3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b3d:	eb 1b                	jmp    801b5a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  801b3f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801b44:	83 f8 01             	cmp    $0x1,%eax
  801b47:	19 c0                	sbb    %eax,%eax
  801b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b4c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801b53:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801b5a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b60:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b64:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b6f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b7a:	e8 4a fa ff ff       	call   8015c9 <sys_page_map>
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	79 20                	jns    801ba3 <fork+0x114>
		panic("sys_page_map: %e", r);
  801b83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b87:	c7 44 24 08 78 36 80 	movl   $0x803678,0x8(%esp)
  801b8e:	00 
  801b8f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801b96:	00 
  801b97:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801b9e:	e8 eb ed ff ff       	call   80098e <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801ba3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba6:	89 44 24 10          	mov    %eax,0x10(%esp)
  801baa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bae:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bb5:	00 
  801bb6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc1:	e8 03 fa ff ff       	call   8015c9 <sys_page_map>
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	79 20                	jns    801bea <fork+0x15b>
		panic("sys_page_map: %e", r);
  801bca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bce:	c7 44 24 08 78 36 80 	movl   $0x803678,0x8(%esp)
  801bd5:	00 
  801bd6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  801bdd:	00 
  801bde:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801be5:	e8 a4 ed ff ff       	call   80098e <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801bea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bf0:	eb 06                	jmp    801bf8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801bf2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801bf8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  801bfe:	0f 86 fa fe ff ff    	jbe    801afe <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801c04:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c0b:	00 
  801c0c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801c13:	ee 
  801c14:	89 34 24             	mov    %esi,(%esp)
  801c17:	e8 59 f9 ff ff       	call   801575 <sys_page_alloc>
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	79 20                	jns    801c40 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801c20:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c24:	c7 44 24 08 49 3b 80 	movl   $0x803b49,0x8(%esp)
  801c2b:	00 
  801c2c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801c33:	00 
  801c34:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801c3b:	e8 4e ed ff ff       	call   80098e <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801c40:	c7 44 24 04 29 33 80 	movl   $0x803329,0x4(%esp)
  801c47:	00 
  801c48:	89 34 24             	mov    %esi,(%esp)
  801c4b:	e8 e5 fa ff ff       	call   801735 <sys_env_set_pgfault_upcall>
  801c50:	85 c0                	test   %eax,%eax
  801c52:	79 20                	jns    801c74 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801c54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c58:	c7 44 24 08 b8 3b 80 	movl   $0x803bb8,0x8(%esp)
  801c5f:	00 
  801c60:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801c67:	00 
  801c68:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801c6f:	e8 1a ed ff ff       	call   80098e <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801c74:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801c7b:	00 
  801c7c:	89 34 24             	mov    %esi,(%esp)
  801c7f:	e8 0b fa ff ff       	call   80168f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801c84:	89 f0                	mov    %esi,%eax

}
  801c86:	83 c4 2c             	add    $0x2c,%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5f                   	pop    %edi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    

00801c8e <sfork>:

// Challenge!
int
sfork(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	57                   	push   %edi
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801c97:	c7 04 24 7e 18 80 00 	movl   $0x80187e,(%esp)
  801c9e:	e8 f3 15 00 00       	call   803296 <set_pgfault_handler>
  801ca3:	b8 08 00 00 00       	mov    $0x8,%eax
  801ca8:	cd 30                	int    $0x30
  801caa:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  801cac:	85 c0                	test   %eax,%eax
  801cae:	79 20                	jns    801cd0 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801cb0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb4:	c7 44 24 08 94 3b 80 	movl   $0x803b94,0x8(%esp)
  801cbb:	00 
  801cbc:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801cc3:	00 
  801cc4:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801ccb:	e8 be ec ff ff       	call   80098e <_panic>
  801cd0:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801cd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	75 2d                	jne    801d08 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  801cdb:	e8 57 f8 ff ff       	call   801537 <sys_getenvid>
  801ce0:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ce5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ce8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ced:	a3 20 50 80 00       	mov    %eax,0x805020
		set_pgfault_handler(pgfault);
  801cf2:	c7 04 24 7e 18 80 00 	movl   $0x80187e,(%esp)
  801cf9:	e8 98 15 00 00       	call   803296 <set_pgfault_handler>
		return 0;
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801d03:	e9 1d 01 00 00       	jmp    801e25 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801d08:	89 d8                	mov    %ebx,%eax
  801d0a:	c1 e8 16             	shr    $0x16,%eax
  801d0d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d14:	a8 01                	test   $0x1,%al
  801d16:	74 69                	je     801d81 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801d18:	89 d8                	mov    %ebx,%eax
  801d1a:	c1 e8 0c             	shr    $0xc,%eax
  801d1d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801d24:	f6 c2 01             	test   $0x1,%dl
  801d27:	74 50                	je     801d79 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801d29:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801d30:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801d33:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801d39:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d41:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801d45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d50:	e8 74 f8 ff ff       	call   8015c9 <sys_page_map>
  801d55:	85 c0                	test   %eax,%eax
  801d57:	79 20                	jns    801d79 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801d59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d5d:	c7 44 24 08 78 36 80 	movl   $0x803678,0x8(%esp)
  801d64:	00 
  801d65:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801d6c:	00 
  801d6d:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801d74:	e8 15 ec ff ff       	call   80098e <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801d79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d7f:	eb 06                	jmp    801d87 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801d81:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801d87:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  801d8d:	0f 86 75 ff ff ff    	jbe    801d08 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801d93:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  801d9a:	ee 
  801d9b:	89 34 24             	mov    %esi,(%esp)
  801d9e:	e8 07 fc ff ff       	call   8019aa <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801da3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801daa:	00 
  801dab:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801db2:	ee 
  801db3:	89 34 24             	mov    %esi,(%esp)
  801db6:	e8 ba f7 ff ff       	call   801575 <sys_page_alloc>
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	79 20                	jns    801ddf <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  801dbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dc3:	c7 44 24 08 49 3b 80 	movl   $0x803b49,0x8(%esp)
  801dca:	00 
  801dcb:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801dd2:	00 
  801dd3:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801dda:	e8 af eb ff ff       	call   80098e <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801ddf:	c7 44 24 04 29 33 80 	movl   $0x803329,0x4(%esp)
  801de6:	00 
  801de7:	89 34 24             	mov    %esi,(%esp)
  801dea:	e8 46 f9 ff ff       	call   801735 <sys_env_set_pgfault_upcall>
  801def:	85 c0                	test   %eax,%eax
  801df1:	79 20                	jns    801e13 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801df3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df7:	c7 44 24 08 b8 3b 80 	movl   $0x803bb8,0x8(%esp)
  801dfe:	00 
  801dff:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801e06:	00 
  801e07:	c7 04 24 3e 3b 80 00 	movl   $0x803b3e,(%esp)
  801e0e:	e8 7b eb ff ff       	call   80098e <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801e13:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801e1a:	00 
  801e1b:	89 34 24             	mov    %esi,(%esp)
  801e1e:	e8 6c f8 ff ff       	call   80168f <sys_env_set_status>
	return envid;
  801e23:	89 f0                	mov    %esi,%eax

}
  801e25:	83 c4 2c             	add    $0x2c,%esp
  801e28:	5b                   	pop    %ebx
  801e29:	5e                   	pop    %esi
  801e2a:	5f                   	pop    %edi
  801e2b:	5d                   	pop    %ebp
  801e2c:	c3                   	ret    
  801e2d:	66 90                	xchg   %ax,%ax
  801e2f:	90                   	nop

00801e30 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	56                   	push   %esi
  801e34:	53                   	push   %ebx
  801e35:	83 ec 10             	sub    $0x10,%esp
  801e38:	8b 75 08             	mov    0x8(%ebp),%esi
  801e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  801e41:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  801e43:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801e48:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801e4b:	89 04 24             	mov    %eax,(%esp)
  801e4e:	e8 58 f9 ff ff       	call   8017ab <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  801e53:	85 c0                	test   %eax,%eax
  801e55:	75 26                	jne    801e7d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  801e57:	85 f6                	test   %esi,%esi
  801e59:	74 0a                	je     801e65 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  801e5b:	a1 20 50 80 00       	mov    0x805020,%eax
  801e60:	8b 40 74             	mov    0x74(%eax),%eax
  801e63:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  801e65:	85 db                	test   %ebx,%ebx
  801e67:	74 0a                	je     801e73 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  801e69:	a1 20 50 80 00       	mov    0x805020,%eax
  801e6e:	8b 40 78             	mov    0x78(%eax),%eax
  801e71:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801e73:	a1 20 50 80 00       	mov    0x805020,%eax
  801e78:	8b 40 70             	mov    0x70(%eax),%eax
  801e7b:	eb 14                	jmp    801e91 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  801e7d:	85 f6                	test   %esi,%esi
  801e7f:	74 06                	je     801e87 <ipc_recv+0x57>
			*from_env_store = 0;
  801e81:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801e87:	85 db                	test   %ebx,%ebx
  801e89:	74 06                	je     801e91 <ipc_recv+0x61>
			*perm_store = 0;
  801e8b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    

00801e98 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	57                   	push   %edi
  801e9c:	56                   	push   %esi
  801e9d:	53                   	push   %ebx
  801e9e:	83 ec 1c             	sub    $0x1c,%esp
  801ea1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ea4:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ea7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  801eaa:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  801eac:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801eb1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ebb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ebf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ec3:	89 3c 24             	mov    %edi,(%esp)
  801ec6:	e8 bd f8 ff ff       	call   801788 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	74 28                	je     801ef7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  801ecf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ed2:	74 1c                	je     801ef0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  801ed4:	c7 44 24 08 dc 3b 80 	movl   $0x803bdc,0x8(%esp)
  801edb:	00 
  801edc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801ee3:	00 
  801ee4:	c7 04 24 fd 3b 80 00 	movl   $0x803bfd,(%esp)
  801eeb:	e8 9e ea ff ff       	call   80098e <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  801ef0:	e8 61 f6 ff ff       	call   801556 <sys_yield>
	}
  801ef5:	eb bd                	jmp    801eb4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  801ef7:	83 c4 1c             	add    $0x1c,%esp
  801efa:	5b                   	pop    %ebx
  801efb:	5e                   	pop    %esi
  801efc:	5f                   	pop    %edi
  801efd:	5d                   	pop    %ebp
  801efe:	c3                   	ret    

00801eff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f0a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f0d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f13:	8b 52 50             	mov    0x50(%edx),%edx
  801f16:	39 ca                	cmp    %ecx,%edx
  801f18:	75 0d                	jne    801f27 <ipc_find_env+0x28>
			return envs[i].env_id;
  801f1a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f1d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f22:	8b 40 40             	mov    0x40(%eax),%eax
  801f25:	eb 0e                	jmp    801f35 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f27:	83 c0 01             	add    $0x1,%eax
  801f2a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f2f:	75 d9                	jne    801f0a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f31:	66 b8 00 00          	mov    $0x0,%ax
}
  801f35:	5d                   	pop    %ebp
  801f36:	c3                   	ret    
  801f37:	66 90                	xchg   %ax,%ax
  801f39:	66 90                	xchg   %ax,%ax
  801f3b:	66 90                	xchg   %ax,%ax
  801f3d:	66 90                	xchg   %ax,%ax
  801f3f:	90                   	nop

00801f40 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	05 00 00 00 30       	add    $0x30000000,%eax
  801f4b:	c1 e8 0c             	shr    $0xc,%eax
}
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    

00801f50 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801f5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f60:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801f65:	5d                   	pop    %ebp
  801f66:	c3                   	ret    

00801f67 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f72:	89 c2                	mov    %eax,%edx
  801f74:	c1 ea 16             	shr    $0x16,%edx
  801f77:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801f7e:	f6 c2 01             	test   $0x1,%dl
  801f81:	74 11                	je     801f94 <fd_alloc+0x2d>
  801f83:	89 c2                	mov    %eax,%edx
  801f85:	c1 ea 0c             	shr    $0xc,%edx
  801f88:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f8f:	f6 c2 01             	test   $0x1,%dl
  801f92:	75 09                	jne    801f9d <fd_alloc+0x36>
			*fd_store = fd;
  801f94:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	eb 17                	jmp    801fb4 <fd_alloc+0x4d>
  801f9d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fa2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801fa7:	75 c9                	jne    801f72 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fa9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801faf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    

00801fb6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fbc:	83 f8 1f             	cmp    $0x1f,%eax
  801fbf:	77 36                	ja     801ff7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801fc1:	c1 e0 0c             	shl    $0xc,%eax
  801fc4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fc9:	89 c2                	mov    %eax,%edx
  801fcb:	c1 ea 16             	shr    $0x16,%edx
  801fce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801fd5:	f6 c2 01             	test   $0x1,%dl
  801fd8:	74 24                	je     801ffe <fd_lookup+0x48>
  801fda:	89 c2                	mov    %eax,%edx
  801fdc:	c1 ea 0c             	shr    $0xc,%edx
  801fdf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801fe6:	f6 c2 01             	test   $0x1,%dl
  801fe9:	74 1a                	je     802005 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fee:	89 02                	mov    %eax,(%edx)
	return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	eb 13                	jmp    80200a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ff7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ffc:	eb 0c                	jmp    80200a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ffe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802003:	eb 05                	jmp    80200a <fd_lookup+0x54>
  802005:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    

0080200c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 18             	sub    $0x18,%esp
  802012:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802015:	ba 00 00 00 00       	mov    $0x0,%edx
  80201a:	eb 13                	jmp    80202f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80201c:	39 08                	cmp    %ecx,(%eax)
  80201e:	75 0c                	jne    80202c <dev_lookup+0x20>
			*dev = devtab[i];
  802020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802023:	89 01                	mov    %eax,(%ecx)
			return 0;
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	eb 38                	jmp    802064 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80202c:	83 c2 01             	add    $0x1,%edx
  80202f:	8b 04 95 88 3c 80 00 	mov    0x803c88(,%edx,4),%eax
  802036:	85 c0                	test   %eax,%eax
  802038:	75 e2                	jne    80201c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80203a:	a1 20 50 80 00       	mov    0x805020,%eax
  80203f:	8b 40 48             	mov    0x48(%eax),%eax
  802042:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204a:	c7 04 24 08 3c 80 00 	movl   $0x803c08,(%esp)
  802051:	e8 31 ea ff ff       	call   800a87 <cprintf>
	*dev = 0;
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80205f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	56                   	push   %esi
  80206a:	53                   	push   %ebx
  80206b:	83 ec 20             	sub    $0x20,%esp
  80206e:	8b 75 08             	mov    0x8(%ebp),%esi
  802071:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802074:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802077:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80207b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802081:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802084:	89 04 24             	mov    %eax,(%esp)
  802087:	e8 2a ff ff ff       	call   801fb6 <fd_lookup>
  80208c:	85 c0                	test   %eax,%eax
  80208e:	78 05                	js     802095 <fd_close+0x2f>
	    || fd != fd2)
  802090:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802093:	74 0c                	je     8020a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  802095:	84 db                	test   %bl,%bl
  802097:	ba 00 00 00 00       	mov    $0x0,%edx
  80209c:	0f 44 c2             	cmove  %edx,%eax
  80209f:	eb 3f                	jmp    8020e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a8:	8b 06                	mov    (%esi),%eax
  8020aa:	89 04 24             	mov    %eax,(%esp)
  8020ad:	e8 5a ff ff ff       	call   80200c <dev_lookup>
  8020b2:	89 c3                	mov    %eax,%ebx
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	78 16                	js     8020ce <fd_close+0x68>
		if (dev->dev_close)
  8020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8020be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	74 07                	je     8020ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8020c7:	89 34 24             	mov    %esi,(%esp)
  8020ca:	ff d0                	call   *%eax
  8020cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d9:	e8 3e f5 ff ff       	call   80161c <sys_page_unmap>
	return r;
  8020de:	89 d8                	mov    %ebx,%eax
}
  8020e0:	83 c4 20             	add    $0x20,%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5d                   	pop    %ebp
  8020e6:	c3                   	ret    

008020e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	89 04 24             	mov    %eax,(%esp)
  8020fa:	e8 b7 fe ff ff       	call   801fb6 <fd_lookup>
  8020ff:	89 c2                	mov    %eax,%edx
  802101:	85 d2                	test   %edx,%edx
  802103:	78 13                	js     802118 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  802105:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80210c:	00 
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	89 04 24             	mov    %eax,(%esp)
  802113:	e8 4e ff ff ff       	call   802066 <fd_close>
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <close_all>:

void
close_all(void)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	53                   	push   %ebx
  80211e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802121:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802126:	89 1c 24             	mov    %ebx,(%esp)
  802129:	e8 b9 ff ff ff       	call   8020e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80212e:	83 c3 01             	add    $0x1,%ebx
  802131:	83 fb 20             	cmp    $0x20,%ebx
  802134:	75 f0                	jne    802126 <close_all+0xc>
		close(i);
}
  802136:	83 c4 14             	add    $0x14,%esp
  802139:	5b                   	pop    %ebx
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	57                   	push   %edi
  802140:	56                   	push   %esi
  802141:	53                   	push   %ebx
  802142:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802145:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802148:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	89 04 24             	mov    %eax,(%esp)
  802152:	e8 5f fe ff ff       	call   801fb6 <fd_lookup>
  802157:	89 c2                	mov    %eax,%edx
  802159:	85 d2                	test   %edx,%edx
  80215b:	0f 88 e1 00 00 00    	js     802242 <dup+0x106>
		return r;
	close(newfdnum);
  802161:	8b 45 0c             	mov    0xc(%ebp),%eax
  802164:	89 04 24             	mov    %eax,(%esp)
  802167:	e8 7b ff ff ff       	call   8020e7 <close>

	newfd = INDEX2FD(newfdnum);
  80216c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80216f:	c1 e3 0c             	shl    $0xc,%ebx
  802172:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80217b:	89 04 24             	mov    %eax,(%esp)
  80217e:	e8 cd fd ff ff       	call   801f50 <fd2data>
  802183:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  802185:	89 1c 24             	mov    %ebx,(%esp)
  802188:	e8 c3 fd ff ff       	call   801f50 <fd2data>
  80218d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80218f:	89 f0                	mov    %esi,%eax
  802191:	c1 e8 16             	shr    $0x16,%eax
  802194:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80219b:	a8 01                	test   $0x1,%al
  80219d:	74 43                	je     8021e2 <dup+0xa6>
  80219f:	89 f0                	mov    %esi,%eax
  8021a1:	c1 e8 0c             	shr    $0xc,%eax
  8021a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8021ab:	f6 c2 01             	test   $0x1,%dl
  8021ae:	74 32                	je     8021e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8021b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8021bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8021c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021cb:	00 
  8021cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d7:	e8 ed f3 ff ff       	call   8015c9 <sys_page_map>
  8021dc:	89 c6                	mov    %eax,%esi
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 3e                	js     802220 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e5:	89 c2                	mov    %eax,%edx
  8021e7:	c1 ea 0c             	shr    $0xc,%edx
  8021ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8021f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8021fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802206:	00 
  802207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802212:	e8 b2 f3 ff ff       	call   8015c9 <sys_page_map>
  802217:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  802219:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80221c:	85 f6                	test   %esi,%esi
  80221e:	79 22                	jns    802242 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802224:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222b:	e8 ec f3 ff ff       	call   80161c <sys_page_unmap>
	sys_page_unmap(0, nva);
  802230:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223b:	e8 dc f3 ff ff       	call   80161c <sys_page_unmap>
	return r;
  802240:	89 f0                	mov    %esi,%eax
}
  802242:	83 c4 3c             	add    $0x3c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    

0080224a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	53                   	push   %ebx
  80224e:	83 ec 24             	sub    $0x24,%esp
  802251:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802254:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225b:	89 1c 24             	mov    %ebx,(%esp)
  80225e:	e8 53 fd ff ff       	call   801fb6 <fd_lookup>
  802263:	89 c2                	mov    %eax,%edx
  802265:	85 d2                	test   %edx,%edx
  802267:	78 6d                	js     8022d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	8b 00                	mov    (%eax),%eax
  802275:	89 04 24             	mov    %eax,(%esp)
  802278:	e8 8f fd ff ff       	call   80200c <dev_lookup>
  80227d:	85 c0                	test   %eax,%eax
  80227f:	78 55                	js     8022d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	8b 50 08             	mov    0x8(%eax),%edx
  802287:	83 e2 03             	and    $0x3,%edx
  80228a:	83 fa 01             	cmp    $0x1,%edx
  80228d:	75 23                	jne    8022b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80228f:	a1 20 50 80 00       	mov    0x805020,%eax
  802294:	8b 40 48             	mov    0x48(%eax),%eax
  802297:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80229b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229f:	c7 04 24 4c 3c 80 00 	movl   $0x803c4c,(%esp)
  8022a6:	e8 dc e7 ff ff       	call   800a87 <cprintf>
		return -E_INVAL;
  8022ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b0:	eb 24                	jmp    8022d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8022b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b5:	8b 52 08             	mov    0x8(%edx),%edx
  8022b8:	85 d2                	test   %edx,%edx
  8022ba:	74 15                	je     8022d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8022bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022ca:	89 04 24             	mov    %eax,(%esp)
  8022cd:	ff d2                	call   *%edx
  8022cf:	eb 05                	jmp    8022d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8022d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8022d6:	83 c4 24             	add    $0x24,%esp
  8022d9:	5b                   	pop    %ebx
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    

008022dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	57                   	push   %edi
  8022e0:	56                   	push   %esi
  8022e1:	53                   	push   %ebx
  8022e2:	83 ec 1c             	sub    $0x1c,%esp
  8022e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022f0:	eb 23                	jmp    802315 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022f2:	89 f0                	mov    %esi,%eax
  8022f4:	29 d8                	sub    %ebx,%eax
  8022f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022fa:	89 d8                	mov    %ebx,%eax
  8022fc:	03 45 0c             	add    0xc(%ebp),%eax
  8022ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802303:	89 3c 24             	mov    %edi,(%esp)
  802306:	e8 3f ff ff ff       	call   80224a <read>
		if (m < 0)
  80230b:	85 c0                	test   %eax,%eax
  80230d:	78 10                	js     80231f <readn+0x43>
			return m;
		if (m == 0)
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 0a                	je     80231d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802313:	01 c3                	add    %eax,%ebx
  802315:	39 f3                	cmp    %esi,%ebx
  802317:	72 d9                	jb     8022f2 <readn+0x16>
  802319:	89 d8                	mov    %ebx,%eax
  80231b:	eb 02                	jmp    80231f <readn+0x43>
  80231d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80231f:	83 c4 1c             	add    $0x1c,%esp
  802322:	5b                   	pop    %ebx
  802323:	5e                   	pop    %esi
  802324:	5f                   	pop    %edi
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    

00802327 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	53                   	push   %ebx
  80232b:	83 ec 24             	sub    $0x24,%esp
  80232e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802331:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802334:	89 44 24 04          	mov    %eax,0x4(%esp)
  802338:	89 1c 24             	mov    %ebx,(%esp)
  80233b:	e8 76 fc ff ff       	call   801fb6 <fd_lookup>
  802340:	89 c2                	mov    %eax,%edx
  802342:	85 d2                	test   %edx,%edx
  802344:	78 68                	js     8023ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802346:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802349:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802350:	8b 00                	mov    (%eax),%eax
  802352:	89 04 24             	mov    %eax,(%esp)
  802355:	e8 b2 fc ff ff       	call   80200c <dev_lookup>
  80235a:	85 c0                	test   %eax,%eax
  80235c:	78 50                	js     8023ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80235e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802361:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802365:	75 23                	jne    80238a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802367:	a1 20 50 80 00       	mov    0x805020,%eax
  80236c:	8b 40 48             	mov    0x48(%eax),%eax
  80236f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802373:	89 44 24 04          	mov    %eax,0x4(%esp)
  802377:	c7 04 24 68 3c 80 00 	movl   $0x803c68,(%esp)
  80237e:	e8 04 e7 ff ff       	call   800a87 <cprintf>
		return -E_INVAL;
  802383:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802388:	eb 24                	jmp    8023ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80238a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238d:	8b 52 0c             	mov    0xc(%edx),%edx
  802390:	85 d2                	test   %edx,%edx
  802392:	74 15                	je     8023a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802394:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802397:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80239b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023a2:	89 04 24             	mov    %eax,(%esp)
  8023a5:	ff d2                	call   *%edx
  8023a7:	eb 05                	jmp    8023ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8023a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8023ae:	83 c4 24             	add    $0x24,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    

008023b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	89 04 24             	mov    %eax,(%esp)
  8023c7:	e8 ea fb ff ff       	call   801fb6 <fd_lookup>
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	78 0e                	js     8023de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8023d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 24             	sub    $0x24,%esp
  8023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f1:	89 1c 24             	mov    %ebx,(%esp)
  8023f4:	e8 bd fb ff ff       	call   801fb6 <fd_lookup>
  8023f9:	89 c2                	mov    %eax,%edx
  8023fb:	85 d2                	test   %edx,%edx
  8023fd:	78 61                	js     802460 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802402:	89 44 24 04          	mov    %eax,0x4(%esp)
  802406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	89 04 24             	mov    %eax,(%esp)
  80240e:	e8 f9 fb ff ff       	call   80200c <dev_lookup>
  802413:	85 c0                	test   %eax,%eax
  802415:	78 49                	js     802460 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80241e:	75 23                	jne    802443 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802420:	a1 20 50 80 00       	mov    0x805020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802425:	8b 40 48             	mov    0x48(%eax),%eax
  802428:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80242c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802430:	c7 04 24 28 3c 80 00 	movl   $0x803c28,(%esp)
  802437:	e8 4b e6 ff ff       	call   800a87 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80243c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802441:	eb 1d                	jmp    802460 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  802443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802446:	8b 52 18             	mov    0x18(%edx),%edx
  802449:	85 d2                	test   %edx,%edx
  80244b:	74 0e                	je     80245b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80244d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802450:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802454:	89 04 24             	mov    %eax,(%esp)
  802457:	ff d2                	call   *%edx
  802459:	eb 05                	jmp    802460 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80245b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  802460:	83 c4 24             	add    $0x24,%esp
  802463:	5b                   	pop    %ebx
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	53                   	push   %ebx
  80246a:	83 ec 24             	sub    $0x24,%esp
  80246d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802470:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802473:	89 44 24 04          	mov    %eax,0x4(%esp)
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	89 04 24             	mov    %eax,(%esp)
  80247d:	e8 34 fb ff ff       	call   801fb6 <fd_lookup>
  802482:	89 c2                	mov    %eax,%edx
  802484:	85 d2                	test   %edx,%edx
  802486:	78 52                	js     8024da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802488:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	89 04 24             	mov    %eax,(%esp)
  802497:	e8 70 fb ff ff       	call   80200c <dev_lookup>
  80249c:	85 c0                	test   %eax,%eax
  80249e:	78 3a                	js     8024da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8024a7:	74 2c                	je     8024d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8024a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8024ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8024b3:	00 00 00 
	stat->st_isdir = 0;
  8024b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024bd:	00 00 00 
	stat->st_dev = dev;
  8024c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8024c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024cd:	89 14 24             	mov    %edx,(%esp)
  8024d0:	ff 50 14             	call   *0x14(%eax)
  8024d3:	eb 05                	jmp    8024da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8024d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8024da:	83 c4 24             	add    $0x24,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    

008024e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	56                   	push   %esi
  8024e4:	53                   	push   %ebx
  8024e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024ef:	00 
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	89 04 24             	mov    %eax,(%esp)
  8024f6:	e8 99 02 00 00       	call   802794 <open>
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	85 db                	test   %ebx,%ebx
  8024ff:	78 1b                	js     80251c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  802501:	8b 45 0c             	mov    0xc(%ebp),%eax
  802504:	89 44 24 04          	mov    %eax,0x4(%esp)
  802508:	89 1c 24             	mov    %ebx,(%esp)
  80250b:	e8 56 ff ff ff       	call   802466 <fstat>
  802510:	89 c6                	mov    %eax,%esi
	close(fd);
  802512:	89 1c 24             	mov    %ebx,(%esp)
  802515:	e8 cd fb ff ff       	call   8020e7 <close>
	return r;
  80251a:	89 f0                	mov    %esi,%eax
}
  80251c:	83 c4 10             	add    $0x10,%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5d                   	pop    %ebp
  802522:	c3                   	ret    

00802523 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	83 ec 10             	sub    $0x10,%esp
  80252b:	89 c6                	mov    %eax,%esi
  80252d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80252f:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802536:	75 11                	jne    802549 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802538:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80253f:	e8 bb f9 ff ff       	call   801eff <ipc_find_env>
  802544:	a3 18 50 80 00       	mov    %eax,0x805018
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802549:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802550:	00 
  802551:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  802558:	00 
  802559:	89 74 24 04          	mov    %esi,0x4(%esp)
  80255d:	a1 18 50 80 00       	mov    0x805018,%eax
  802562:	89 04 24             	mov    %eax,(%esp)
  802565:	e8 2e f9 ff ff       	call   801e98 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80256a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802571:	00 
  802572:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80257d:	e8 ae f8 ff ff       	call   801e30 <ipc_recv>
}
  802582:	83 c4 10             	add    $0x10,%esp
  802585:	5b                   	pop    %ebx
  802586:	5e                   	pop    %esi
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    

00802589 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	8b 40 0c             	mov    0xc(%eax),%eax
  802595:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80259a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8025a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8025ac:	e8 72 ff ff ff       	call   802523 <fsipc>
}
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8025c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8025ce:	e8 50 ff ff ff       	call   802523 <fsipc>
}
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
  8025d8:	53                   	push   %ebx
  8025d9:	83 ec 14             	sub    $0x14,%esp
  8025dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8025ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8025f4:	e8 2a ff ff ff       	call   802523 <fsipc>
  8025f9:	89 c2                	mov    %eax,%edx
  8025fb:	85 d2                	test   %edx,%edx
  8025fd:	78 2b                	js     80262a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8025ff:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802606:	00 
  802607:	89 1c 24             	mov    %ebx,(%esp)
  80260a:	e8 f8 ea ff ff       	call   801107 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80260f:	a1 80 60 80 00       	mov    0x806080,%eax
  802614:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80261a:	a1 84 60 80 00       	mov    0x806084,%eax
  80261f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262a:	83 c4 14             	add    $0x14,%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5d                   	pop    %ebp
  80262f:	c3                   	ret    

00802630 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	53                   	push   %ebx
  802634:	83 ec 14             	sub    $0x14,%esp
  802637:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80263a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  802640:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  802645:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802648:	8b 55 08             	mov    0x8(%ebp),%edx
  80264b:	8b 52 0c             	mov    0xc(%edx),%edx
  80264e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  802654:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  802659:	89 44 24 08          	mov    %eax,0x8(%esp)
  80265d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802660:	89 44 24 04          	mov    %eax,0x4(%esp)
  802664:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80266b:	e8 34 ec ff ff       	call   8012a4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  802670:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  802677:	00 
  802678:	c7 04 24 9c 3c 80 00 	movl   $0x803c9c,(%esp)
  80267f:	e8 03 e4 ff ff       	call   800a87 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802684:	ba 00 00 00 00       	mov    $0x0,%edx
  802689:	b8 04 00 00 00       	mov    $0x4,%eax
  80268e:	e8 90 fe ff ff       	call   802523 <fsipc>
  802693:	85 c0                	test   %eax,%eax
  802695:	78 53                	js     8026ea <devfile_write+0xba>
		return r;
	assert(r <= n);
  802697:	39 c3                	cmp    %eax,%ebx
  802699:	73 24                	jae    8026bf <devfile_write+0x8f>
  80269b:	c7 44 24 0c a1 3c 80 	movl   $0x803ca1,0xc(%esp)
  8026a2:	00 
  8026a3:	c7 44 24 08 a8 3c 80 	movl   $0x803ca8,0x8(%esp)
  8026aa:	00 
  8026ab:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8026b2:	00 
  8026b3:	c7 04 24 bd 3c 80 00 	movl   $0x803cbd,(%esp)
  8026ba:	e8 cf e2 ff ff       	call   80098e <_panic>
	assert(r <= PGSIZE);
  8026bf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8026c4:	7e 24                	jle    8026ea <devfile_write+0xba>
  8026c6:	c7 44 24 0c c8 3c 80 	movl   $0x803cc8,0xc(%esp)
  8026cd:	00 
  8026ce:	c7 44 24 08 a8 3c 80 	movl   $0x803ca8,0x8(%esp)
  8026d5:	00 
  8026d6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8026dd:	00 
  8026de:	c7 04 24 bd 3c 80 00 	movl   $0x803cbd,(%esp)
  8026e5:	e8 a4 e2 ff ff       	call   80098e <_panic>
	return r;
}
  8026ea:	83 c4 14             	add    $0x14,%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5d                   	pop    %ebp
  8026ef:	c3                   	ret    

008026f0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
  8026f3:	56                   	push   %esi
  8026f4:	53                   	push   %ebx
  8026f5:	83 ec 10             	sub    $0x10,%esp
  8026f8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8026fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802701:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802706:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80270c:	ba 00 00 00 00       	mov    $0x0,%edx
  802711:	b8 03 00 00 00       	mov    $0x3,%eax
  802716:	e8 08 fe ff ff       	call   802523 <fsipc>
  80271b:	89 c3                	mov    %eax,%ebx
  80271d:	85 c0                	test   %eax,%eax
  80271f:	78 6a                	js     80278b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802721:	39 c6                	cmp    %eax,%esi
  802723:	73 24                	jae    802749 <devfile_read+0x59>
  802725:	c7 44 24 0c a1 3c 80 	movl   $0x803ca1,0xc(%esp)
  80272c:	00 
  80272d:	c7 44 24 08 a8 3c 80 	movl   $0x803ca8,0x8(%esp)
  802734:	00 
  802735:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80273c:	00 
  80273d:	c7 04 24 bd 3c 80 00 	movl   $0x803cbd,(%esp)
  802744:	e8 45 e2 ff ff       	call   80098e <_panic>
	assert(r <= PGSIZE);
  802749:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80274e:	7e 24                	jle    802774 <devfile_read+0x84>
  802750:	c7 44 24 0c c8 3c 80 	movl   $0x803cc8,0xc(%esp)
  802757:	00 
  802758:	c7 44 24 08 a8 3c 80 	movl   $0x803ca8,0x8(%esp)
  80275f:	00 
  802760:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802767:	00 
  802768:	c7 04 24 bd 3c 80 00 	movl   $0x803cbd,(%esp)
  80276f:	e8 1a e2 ff ff       	call   80098e <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802774:	89 44 24 08          	mov    %eax,0x8(%esp)
  802778:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80277f:	00 
  802780:	8b 45 0c             	mov    0xc(%ebp),%eax
  802783:	89 04 24             	mov    %eax,(%esp)
  802786:	e8 19 eb ff ff       	call   8012a4 <memmove>
	return r;
}
  80278b:	89 d8                	mov    %ebx,%eax
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	5b                   	pop    %ebx
  802791:	5e                   	pop    %esi
  802792:	5d                   	pop    %ebp
  802793:	c3                   	ret    

00802794 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	53                   	push   %ebx
  802798:	83 ec 24             	sub    $0x24,%esp
  80279b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80279e:	89 1c 24             	mov    %ebx,(%esp)
  8027a1:	e8 2a e9 ff ff       	call   8010d0 <strlen>
  8027a6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027ab:	7f 60                	jg     80280d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8027ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027b0:	89 04 24             	mov    %eax,(%esp)
  8027b3:	e8 af f7 ff ff       	call   801f67 <fd_alloc>
  8027b8:	89 c2                	mov    %eax,%edx
  8027ba:	85 d2                	test   %edx,%edx
  8027bc:	78 54                	js     802812 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8027be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027c2:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  8027c9:	e8 39 e9 ff ff       	call   801107 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8027ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8027d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027de:	e8 40 fd ff ff       	call   802523 <fsipc>
  8027e3:	89 c3                	mov    %eax,%ebx
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	79 17                	jns    802800 <open+0x6c>
		fd_close(fd, 0);
  8027e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027f0:	00 
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	89 04 24             	mov    %eax,(%esp)
  8027f7:	e8 6a f8 ff ff       	call   802066 <fd_close>
		return r;
  8027fc:	89 d8                	mov    %ebx,%eax
  8027fe:	eb 12                	jmp    802812 <open+0x7e>
	}

	return fd2num(fd);
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	89 04 24             	mov    %eax,(%esp)
  802806:	e8 35 f7 ff ff       	call   801f40 <fd2num>
  80280b:	eb 05                	jmp    802812 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80280d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802812:	83 c4 24             	add    $0x24,%esp
  802815:	5b                   	pop    %ebx
  802816:	5d                   	pop    %ebp
  802817:	c3                   	ret    

00802818 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80281e:	ba 00 00 00 00       	mov    $0x0,%edx
  802823:	b8 08 00 00 00       	mov    $0x8,%eax
  802828:	e8 f6 fc ff ff       	call   802523 <fsipc>
}
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <evict>:

int evict(void)
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
  802832:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802835:	c7 04 24 d4 3c 80 00 	movl   $0x803cd4,(%esp)
  80283c:	e8 46 e2 ff ff       	call   800a87 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802841:	ba 00 00 00 00       	mov    $0x0,%edx
  802846:	b8 09 00 00 00       	mov    $0x9,%eax
  80284b:	e8 d3 fc ff ff       	call   802523 <fsipc>
}
  802850:	c9                   	leave  
  802851:	c3                   	ret    
  802852:	66 90                	xchg   %ax,%ax
  802854:	66 90                	xchg   %ax,%ax
  802856:	66 90                	xchg   %ax,%ax
  802858:	66 90                	xchg   %ax,%ax
  80285a:	66 90                	xchg   %ax,%ax
  80285c:	66 90                	xchg   %ax,%ax
  80285e:	66 90                	xchg   %ax,%ax

00802860 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802866:	c7 44 24 04 ed 3c 80 	movl   $0x803ced,0x4(%esp)
  80286d:	00 
  80286e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802871:	89 04 24             	mov    %eax,(%esp)
  802874:	e8 8e e8 ff ff       	call   801107 <strcpy>
	return 0;
}
  802879:	b8 00 00 00 00       	mov    $0x0,%eax
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
  802883:	53                   	push   %ebx
  802884:	83 ec 14             	sub    $0x14,%esp
  802887:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80288a:	89 1c 24             	mov    %ebx,(%esp)
  80288d:	e8 bd 0a 00 00       	call   80334f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802892:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802897:	83 f8 01             	cmp    $0x1,%eax
  80289a:	75 0d                	jne    8028a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80289c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80289f:	89 04 24             	mov    %eax,(%esp)
  8028a2:	e8 29 03 00 00       	call   802bd0 <nsipc_close>
  8028a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8028a9:	89 d0                	mov    %edx,%eax
  8028ab:	83 c4 14             	add    $0x14,%esp
  8028ae:	5b                   	pop    %ebx
  8028af:	5d                   	pop    %ebp
  8028b0:	c3                   	ret    

008028b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8028b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8028be:	00 
  8028bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d3:	89 04 24             	mov    %eax,(%esp)
  8028d6:	e8 f0 03 00 00       	call   802ccb <nsipc_send>
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8028e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8028ea:	00 
  8028eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ff:	89 04 24             	mov    %eax,(%esp)
  802902:	e8 44 03 00 00       	call   802c4b <nsipc_recv>
}
  802907:	c9                   	leave  
  802908:	c3                   	ret    

00802909 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80290f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802912:	89 54 24 04          	mov    %edx,0x4(%esp)
  802916:	89 04 24             	mov    %eax,(%esp)
  802919:	e8 98 f6 ff ff       	call   801fb6 <fd_lookup>
  80291e:	85 c0                	test   %eax,%eax
  802920:	78 17                	js     802939 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80292b:	39 08                	cmp    %ecx,(%eax)
  80292d:	75 05                	jne    802934 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80292f:	8b 40 0c             	mov    0xc(%eax),%eax
  802932:	eb 05                	jmp    802939 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802934:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
  80293e:	56                   	push   %esi
  80293f:	53                   	push   %ebx
  802940:	83 ec 20             	sub    $0x20,%esp
  802943:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802945:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802948:	89 04 24             	mov    %eax,(%esp)
  80294b:	e8 17 f6 ff ff       	call   801f67 <fd_alloc>
  802950:	89 c3                	mov    %eax,%ebx
  802952:	85 c0                	test   %eax,%eax
  802954:	78 21                	js     802977 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802956:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80295d:	00 
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	89 44 24 04          	mov    %eax,0x4(%esp)
  802965:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80296c:	e8 04 ec ff ff       	call   801575 <sys_page_alloc>
  802971:	89 c3                	mov    %eax,%ebx
  802973:	85 c0                	test   %eax,%eax
  802975:	79 0c                	jns    802983 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802977:	89 34 24             	mov    %esi,(%esp)
  80297a:	e8 51 02 00 00       	call   802bd0 <nsipc_close>
		return r;
  80297f:	89 d8                	mov    %ebx,%eax
  802981:	eb 20                	jmp    8029a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802983:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80298e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802991:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802998:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80299b:	89 14 24             	mov    %edx,(%esp)
  80299e:	e8 9d f5 ff ff       	call   801f40 <fd2num>
}
  8029a3:	83 c4 20             	add    $0x20,%esp
  8029a6:	5b                   	pop    %ebx
  8029a7:	5e                   	pop    %esi
  8029a8:	5d                   	pop    %ebp
  8029a9:	c3                   	ret    

008029aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8029aa:	55                   	push   %ebp
  8029ab:	89 e5                	mov    %esp,%ebp
  8029ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	e8 51 ff ff ff       	call   802909 <fd2sockid>
		return r;
  8029b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	78 23                	js     8029e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8029be:	8b 55 10             	mov    0x10(%ebp),%edx
  8029c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029cc:	89 04 24             	mov    %eax,(%esp)
  8029cf:	e8 45 01 00 00       	call   802b19 <nsipc_accept>
		return r;
  8029d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	78 07                	js     8029e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8029da:	e8 5c ff ff ff       	call   80293b <alloc_sockfd>
  8029df:	89 c1                	mov    %eax,%ecx
}
  8029e1:	89 c8                	mov    %ecx,%eax
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
  8029e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	e8 16 ff ff ff       	call   802909 <fd2sockid>
  8029f3:	89 c2                	mov    %eax,%edx
  8029f5:	85 d2                	test   %edx,%edx
  8029f7:	78 16                	js     802a0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8029f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8029fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a07:	89 14 24             	mov    %edx,(%esp)
  802a0a:	e8 60 01 00 00       	call   802b6f <nsipc_bind>
}
  802a0f:	c9                   	leave  
  802a10:	c3                   	ret    

00802a11 <shutdown>:

int
shutdown(int s, int how)
{
  802a11:	55                   	push   %ebp
  802a12:	89 e5                	mov    %esp,%ebp
  802a14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	e8 ea fe ff ff       	call   802909 <fd2sockid>
  802a1f:	89 c2                	mov    %eax,%edx
  802a21:	85 d2                	test   %edx,%edx
  802a23:	78 0f                	js     802a34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a2c:	89 14 24             	mov    %edx,(%esp)
  802a2f:	e8 7a 01 00 00       	call   802bae <nsipc_shutdown>
}
  802a34:	c9                   	leave  
  802a35:	c3                   	ret    

00802a36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a36:	55                   	push   %ebp
  802a37:	89 e5                	mov    %esp,%ebp
  802a39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	e8 c5 fe ff ff       	call   802909 <fd2sockid>
  802a44:	89 c2                	mov    %eax,%edx
  802a46:	85 d2                	test   %edx,%edx
  802a48:	78 16                	js     802a60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  802a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  802a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a58:	89 14 24             	mov    %edx,(%esp)
  802a5b:	e8 8a 01 00 00       	call   802bea <nsipc_connect>
}
  802a60:	c9                   	leave  
  802a61:	c3                   	ret    

00802a62 <listen>:

int
listen(int s, int backlog)
{
  802a62:	55                   	push   %ebp
  802a63:	89 e5                	mov    %esp,%ebp
  802a65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	e8 99 fe ff ff       	call   802909 <fd2sockid>
  802a70:	89 c2                	mov    %eax,%edx
  802a72:	85 d2                	test   %edx,%edx
  802a74:	78 0f                	js     802a85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a7d:	89 14 24             	mov    %edx,(%esp)
  802a80:	e8 a4 01 00 00       	call   802c29 <nsipc_listen>
}
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  802a90:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	89 04 24             	mov    %eax,(%esp)
  802aa1:	e8 98 02 00 00       	call   802d3e <nsipc_socket>
  802aa6:	89 c2                	mov    %eax,%edx
  802aa8:	85 d2                	test   %edx,%edx
  802aaa:	78 05                	js     802ab1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  802aac:	e8 8a fe ff ff       	call   80293b <alloc_sockfd>
}
  802ab1:	c9                   	leave  
  802ab2:	c3                   	ret    

00802ab3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
  802ab6:	53                   	push   %ebx
  802ab7:	83 ec 14             	sub    $0x14,%esp
  802aba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802abc:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  802ac3:	75 11                	jne    802ad6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802ac5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802acc:	e8 2e f4 ff ff       	call   801eff <ipc_find_env>
  802ad1:	a3 1c 50 80 00       	mov    %eax,0x80501c
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802ad6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802add:	00 
  802ade:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802ae5:	00 
  802ae6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802aea:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802aef:	89 04 24             	mov    %eax,(%esp)
  802af2:	e8 a1 f3 ff ff       	call   801e98 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802af7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802afe:	00 
  802aff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802b06:	00 
  802b07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b0e:	e8 1d f3 ff ff       	call   801e30 <ipc_recv>
}
  802b13:	83 c4 14             	add    $0x14,%esp
  802b16:	5b                   	pop    %ebx
  802b17:	5d                   	pop    %ebp
  802b18:	c3                   	ret    

00802b19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b19:	55                   	push   %ebp
  802b1a:	89 e5                	mov    %esp,%ebp
  802b1c:	56                   	push   %esi
  802b1d:	53                   	push   %ebx
  802b1e:	83 ec 10             	sub    $0x10,%esp
  802b21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802b2c:	8b 06                	mov    (%esi),%eax
  802b2e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802b33:	b8 01 00 00 00       	mov    $0x1,%eax
  802b38:	e8 76 ff ff ff       	call   802ab3 <nsipc>
  802b3d:	89 c3                	mov    %eax,%ebx
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	78 23                	js     802b66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802b43:	a1 10 70 80 00       	mov    0x807010,%eax
  802b48:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b4c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802b53:	00 
  802b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b57:	89 04 24             	mov    %eax,(%esp)
  802b5a:	e8 45 e7 ff ff       	call   8012a4 <memmove>
		*addrlen = ret->ret_addrlen;
  802b5f:	a1 10 70 80 00       	mov    0x807010,%eax
  802b64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802b66:	89 d8                	mov    %ebx,%eax
  802b68:	83 c4 10             	add    $0x10,%esp
  802b6b:	5b                   	pop    %ebx
  802b6c:	5e                   	pop    %esi
  802b6d:	5d                   	pop    %ebp
  802b6e:	c3                   	ret    

00802b6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802b6f:	55                   	push   %ebp
  802b70:	89 e5                	mov    %esp,%ebp
  802b72:	53                   	push   %ebx
  802b73:	83 ec 14             	sub    $0x14,%esp
  802b76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802b81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b8c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802b93:	e8 0c e7 ff ff       	call   8012a4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802b98:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802b9e:	b8 02 00 00 00       	mov    $0x2,%eax
  802ba3:	e8 0b ff ff ff       	call   802ab3 <nsipc>
}
  802ba8:	83 c4 14             	add    $0x14,%esp
  802bab:	5b                   	pop    %ebx
  802bac:	5d                   	pop    %ebp
  802bad:	c3                   	ret    

00802bae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
  802bb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bbf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802bc4:	b8 03 00 00 00       	mov    $0x3,%eax
  802bc9:	e8 e5 fe ff ff       	call   802ab3 <nsipc>
}
  802bce:	c9                   	leave  
  802bcf:	c3                   	ret    

00802bd0 <nsipc_close>:

int
nsipc_close(int s)
{
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
  802bd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802bde:	b8 04 00 00 00       	mov    $0x4,%eax
  802be3:	e8 cb fe ff ff       	call   802ab3 <nsipc>
}
  802be8:	c9                   	leave  
  802be9:	c3                   	ret    

00802bea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802bea:	55                   	push   %ebp
  802beb:	89 e5                	mov    %esp,%ebp
  802bed:	53                   	push   %ebx
  802bee:	83 ec 14             	sub    $0x14,%esp
  802bf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802bfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c07:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802c0e:	e8 91 e6 ff ff       	call   8012a4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802c13:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802c19:	b8 05 00 00 00       	mov    $0x5,%eax
  802c1e:	e8 90 fe ff ff       	call   802ab3 <nsipc>
}
  802c23:	83 c4 14             	add    $0x14,%esp
  802c26:	5b                   	pop    %ebx
  802c27:	5d                   	pop    %ebp
  802c28:	c3                   	ret    

00802c29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802c29:	55                   	push   %ebp
  802c2a:	89 e5                	mov    %esp,%ebp
  802c2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802c3f:	b8 06 00 00 00       	mov    $0x6,%eax
  802c44:	e8 6a fe ff ff       	call   802ab3 <nsipc>
}
  802c49:	c9                   	leave  
  802c4a:	c3                   	ret    

00802c4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802c4b:	55                   	push   %ebp
  802c4c:	89 e5                	mov    %esp,%ebp
  802c4e:	56                   	push   %esi
  802c4f:	53                   	push   %ebx
  802c50:	83 ec 10             	sub    $0x10,%esp
  802c53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802c5e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802c64:	8b 45 14             	mov    0x14(%ebp),%eax
  802c67:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802c6c:	b8 07 00 00 00       	mov    $0x7,%eax
  802c71:	e8 3d fe ff ff       	call   802ab3 <nsipc>
  802c76:	89 c3                	mov    %eax,%ebx
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	78 46                	js     802cc2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802c7c:	39 f0                	cmp    %esi,%eax
  802c7e:	7f 07                	jg     802c87 <nsipc_recv+0x3c>
  802c80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802c85:	7e 24                	jle    802cab <nsipc_recv+0x60>
  802c87:	c7 44 24 0c f9 3c 80 	movl   $0x803cf9,0xc(%esp)
  802c8e:	00 
  802c8f:	c7 44 24 08 a8 3c 80 	movl   $0x803ca8,0x8(%esp)
  802c96:	00 
  802c97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802c9e:	00 
  802c9f:	c7 04 24 0e 3d 80 00 	movl   $0x803d0e,(%esp)
  802ca6:	e8 e3 dc ff ff       	call   80098e <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802cab:	89 44 24 08          	mov    %eax,0x8(%esp)
  802caf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802cb6:	00 
  802cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cba:	89 04 24             	mov    %eax,(%esp)
  802cbd:	e8 e2 e5 ff ff       	call   8012a4 <memmove>
	}

	return r;
}
  802cc2:	89 d8                	mov    %ebx,%eax
  802cc4:	83 c4 10             	add    $0x10,%esp
  802cc7:	5b                   	pop    %ebx
  802cc8:	5e                   	pop    %esi
  802cc9:	5d                   	pop    %ebp
  802cca:	c3                   	ret    

00802ccb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
  802cce:	53                   	push   %ebx
  802ccf:	83 ec 14             	sub    $0x14,%esp
  802cd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802cdd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802ce3:	7e 24                	jle    802d09 <nsipc_send+0x3e>
  802ce5:	c7 44 24 0c 1a 3d 80 	movl   $0x803d1a,0xc(%esp)
  802cec:	00 
  802ced:	c7 44 24 08 a8 3c 80 	movl   $0x803ca8,0x8(%esp)
  802cf4:	00 
  802cf5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802cfc:	00 
  802cfd:	c7 04 24 0e 3d 80 00 	movl   $0x803d0e,(%esp)
  802d04:	e8 85 dc ff ff       	call   80098e <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802d09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d14:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  802d1b:	e8 84 e5 ff ff       	call   8012a4 <memmove>
	nsipcbuf.send.req_size = size;
  802d20:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802d26:	8b 45 14             	mov    0x14(%ebp),%eax
  802d29:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802d2e:	b8 08 00 00 00       	mov    $0x8,%eax
  802d33:	e8 7b fd ff ff       	call   802ab3 <nsipc>
}
  802d38:	83 c4 14             	add    $0x14,%esp
  802d3b:	5b                   	pop    %ebx
  802d3c:	5d                   	pop    %ebp
  802d3d:	c3                   	ret    

00802d3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802d3e:	55                   	push   %ebp
  802d3f:	89 e5                	mov    %esp,%ebp
  802d41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802d54:	8b 45 10             	mov    0x10(%ebp),%eax
  802d57:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802d5c:	b8 09 00 00 00       	mov    $0x9,%eax
  802d61:	e8 4d fd ff ff       	call   802ab3 <nsipc>
}
  802d66:	c9                   	leave  
  802d67:	c3                   	ret    

00802d68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802d68:	55                   	push   %ebp
  802d69:	89 e5                	mov    %esp,%ebp
  802d6b:	56                   	push   %esi
  802d6c:	53                   	push   %ebx
  802d6d:	83 ec 10             	sub    $0x10,%esp
  802d70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	89 04 24             	mov    %eax,(%esp)
  802d79:	e8 d2 f1 ff ff       	call   801f50 <fd2data>
  802d7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802d80:	c7 44 24 04 26 3d 80 	movl   $0x803d26,0x4(%esp)
  802d87:	00 
  802d88:	89 1c 24             	mov    %ebx,(%esp)
  802d8b:	e8 77 e3 ff ff       	call   801107 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802d90:	8b 46 04             	mov    0x4(%esi),%eax
  802d93:	2b 06                	sub    (%esi),%eax
  802d95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802d9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802da2:	00 00 00 
	stat->st_dev = &devpipe;
  802da5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802dac:	40 80 00 
	return 0;
}
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax
  802db4:	83 c4 10             	add    $0x10,%esp
  802db7:	5b                   	pop    %ebx
  802db8:	5e                   	pop    %esi
  802db9:	5d                   	pop    %ebp
  802dba:	c3                   	ret    

00802dbb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802dbb:	55                   	push   %ebp
  802dbc:	89 e5                	mov    %esp,%ebp
  802dbe:	53                   	push   %ebx
  802dbf:	83 ec 14             	sub    $0x14,%esp
  802dc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802dc5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802dc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dd0:	e8 47 e8 ff ff       	call   80161c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802dd5:	89 1c 24             	mov    %ebx,(%esp)
  802dd8:	e8 73 f1 ff ff       	call   801f50 <fd2data>
  802ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802de1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802de8:	e8 2f e8 ff ff       	call   80161c <sys_page_unmap>
}
  802ded:	83 c4 14             	add    $0x14,%esp
  802df0:	5b                   	pop    %ebx
  802df1:	5d                   	pop    %ebp
  802df2:	c3                   	ret    

00802df3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802df3:	55                   	push   %ebp
  802df4:	89 e5                	mov    %esp,%ebp
  802df6:	57                   	push   %edi
  802df7:	56                   	push   %esi
  802df8:	53                   	push   %ebx
  802df9:	83 ec 2c             	sub    $0x2c,%esp
  802dfc:	89 c6                	mov    %eax,%esi
  802dfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802e01:	a1 20 50 80 00       	mov    0x805020,%eax
  802e06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802e09:	89 34 24             	mov    %esi,(%esp)
  802e0c:	e8 3e 05 00 00       	call   80334f <pageref>
  802e11:	89 c7                	mov    %eax,%edi
  802e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e16:	89 04 24             	mov    %eax,(%esp)
  802e19:	e8 31 05 00 00       	call   80334f <pageref>
  802e1e:	39 c7                	cmp    %eax,%edi
  802e20:	0f 94 c2             	sete   %dl
  802e23:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802e26:	8b 0d 20 50 80 00    	mov    0x805020,%ecx
  802e2c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802e2f:	39 fb                	cmp    %edi,%ebx
  802e31:	74 21                	je     802e54 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802e33:	84 d2                	test   %dl,%dl
  802e35:	74 ca                	je     802e01 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802e37:	8b 51 58             	mov    0x58(%ecx),%edx
  802e3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e46:	c7 04 24 2d 3d 80 00 	movl   $0x803d2d,(%esp)
  802e4d:	e8 35 dc ff ff       	call   800a87 <cprintf>
  802e52:	eb ad                	jmp    802e01 <_pipeisclosed+0xe>
	}
}
  802e54:	83 c4 2c             	add    $0x2c,%esp
  802e57:	5b                   	pop    %ebx
  802e58:	5e                   	pop    %esi
  802e59:	5f                   	pop    %edi
  802e5a:	5d                   	pop    %ebp
  802e5b:	c3                   	ret    

00802e5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e5c:	55                   	push   %ebp
  802e5d:	89 e5                	mov    %esp,%ebp
  802e5f:	57                   	push   %edi
  802e60:	56                   	push   %esi
  802e61:	53                   	push   %ebx
  802e62:	83 ec 1c             	sub    $0x1c,%esp
  802e65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e68:	89 34 24             	mov    %esi,(%esp)
  802e6b:	e8 e0 f0 ff ff       	call   801f50 <fd2data>
  802e70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e72:	bf 00 00 00 00       	mov    $0x0,%edi
  802e77:	eb 45                	jmp    802ebe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802e79:	89 da                	mov    %ebx,%edx
  802e7b:	89 f0                	mov    %esi,%eax
  802e7d:	e8 71 ff ff ff       	call   802df3 <_pipeisclosed>
  802e82:	85 c0                	test   %eax,%eax
  802e84:	75 41                	jne    802ec7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802e86:	e8 cb e6 ff ff       	call   801556 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e8b:	8b 43 04             	mov    0x4(%ebx),%eax
  802e8e:	8b 0b                	mov    (%ebx),%ecx
  802e90:	8d 51 20             	lea    0x20(%ecx),%edx
  802e93:	39 d0                	cmp    %edx,%eax
  802e95:	73 e2                	jae    802e79 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802e9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802ea1:	99                   	cltd   
  802ea2:	c1 ea 1b             	shr    $0x1b,%edx
  802ea5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802ea8:	83 e1 1f             	and    $0x1f,%ecx
  802eab:	29 d1                	sub    %edx,%ecx
  802ead:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802eb1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802eb5:	83 c0 01             	add    $0x1,%eax
  802eb8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ebb:	83 c7 01             	add    $0x1,%edi
  802ebe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802ec1:	75 c8                	jne    802e8b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802ec3:	89 f8                	mov    %edi,%eax
  802ec5:	eb 05                	jmp    802ecc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802ec7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802ecc:	83 c4 1c             	add    $0x1c,%esp
  802ecf:	5b                   	pop    %ebx
  802ed0:	5e                   	pop    %esi
  802ed1:	5f                   	pop    %edi
  802ed2:	5d                   	pop    %ebp
  802ed3:	c3                   	ret    

00802ed4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802ed4:	55                   	push   %ebp
  802ed5:	89 e5                	mov    %esp,%ebp
  802ed7:	57                   	push   %edi
  802ed8:	56                   	push   %esi
  802ed9:	53                   	push   %ebx
  802eda:	83 ec 1c             	sub    $0x1c,%esp
  802edd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802ee0:	89 3c 24             	mov    %edi,(%esp)
  802ee3:	e8 68 f0 ff ff       	call   801f50 <fd2data>
  802ee8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802eea:	be 00 00 00 00       	mov    $0x0,%esi
  802eef:	eb 3d                	jmp    802f2e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802ef1:	85 f6                	test   %esi,%esi
  802ef3:	74 04                	je     802ef9 <devpipe_read+0x25>
				return i;
  802ef5:	89 f0                	mov    %esi,%eax
  802ef7:	eb 43                	jmp    802f3c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802ef9:	89 da                	mov    %ebx,%edx
  802efb:	89 f8                	mov    %edi,%eax
  802efd:	e8 f1 fe ff ff       	call   802df3 <_pipeisclosed>
  802f02:	85 c0                	test   %eax,%eax
  802f04:	75 31                	jne    802f37 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802f06:	e8 4b e6 ff ff       	call   801556 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802f0b:	8b 03                	mov    (%ebx),%eax
  802f0d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802f10:	74 df                	je     802ef1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802f12:	99                   	cltd   
  802f13:	c1 ea 1b             	shr    $0x1b,%edx
  802f16:	01 d0                	add    %edx,%eax
  802f18:	83 e0 1f             	and    $0x1f,%eax
  802f1b:	29 d0                	sub    %edx,%eax
  802f1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802f28:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f2b:	83 c6 01             	add    $0x1,%esi
  802f2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802f31:	75 d8                	jne    802f0b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802f33:	89 f0                	mov    %esi,%eax
  802f35:	eb 05                	jmp    802f3c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802f37:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802f3c:	83 c4 1c             	add    $0x1c,%esp
  802f3f:	5b                   	pop    %ebx
  802f40:	5e                   	pop    %esi
  802f41:	5f                   	pop    %edi
  802f42:	5d                   	pop    %ebp
  802f43:	c3                   	ret    

00802f44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
  802f47:	56                   	push   %esi
  802f48:	53                   	push   %ebx
  802f49:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f4f:	89 04 24             	mov    %eax,(%esp)
  802f52:	e8 10 f0 ff ff       	call   801f67 <fd_alloc>
  802f57:	89 c2                	mov    %eax,%edx
  802f59:	85 d2                	test   %edx,%edx
  802f5b:	0f 88 4d 01 00 00    	js     8030ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f61:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802f68:	00 
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f77:	e8 f9 e5 ff ff       	call   801575 <sys_page_alloc>
  802f7c:	89 c2                	mov    %eax,%edx
  802f7e:	85 d2                	test   %edx,%edx
  802f80:	0f 88 28 01 00 00    	js     8030ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f89:	89 04 24             	mov    %eax,(%esp)
  802f8c:	e8 d6 ef ff ff       	call   801f67 <fd_alloc>
  802f91:	89 c3                	mov    %eax,%ebx
  802f93:	85 c0                	test   %eax,%eax
  802f95:	0f 88 fe 00 00 00    	js     803099 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f9b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802fa2:	00 
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802faa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fb1:	e8 bf e5 ff ff       	call   801575 <sys_page_alloc>
  802fb6:	89 c3                	mov    %eax,%ebx
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	0f 88 d9 00 00 00    	js     803099 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	89 04 24             	mov    %eax,(%esp)
  802fc6:	e8 85 ef ff ff       	call   801f50 <fd2data>
  802fcb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fcd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802fd4:	00 
  802fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fe0:	e8 90 e5 ff ff       	call   801575 <sys_page_alloc>
  802fe5:	89 c3                	mov    %eax,%ebx
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	0f 88 97 00 00 00    	js     803086 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	89 04 24             	mov    %eax,(%esp)
  802ff5:	e8 56 ef ff ff       	call   801f50 <fd2data>
  802ffa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803001:	00 
  803002:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803006:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80300d:	00 
  80300e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803012:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803019:	e8 ab e5 ff ff       	call   8015c9 <sys_page_map>
  80301e:	89 c3                	mov    %eax,%ebx
  803020:	85 c0                	test   %eax,%eax
  803022:	78 52                	js     803076 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803024:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803039:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803047:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	89 04 24             	mov    %eax,(%esp)
  803054:	e8 e7 ee ff ff       	call   801f40 <fd2num>
  803059:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80305c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803061:	89 04 24             	mov    %eax,(%esp)
  803064:	e8 d7 ee ff ff       	call   801f40 <fd2num>
  803069:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80306c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80306f:	b8 00 00 00 00       	mov    $0x0,%eax
  803074:	eb 38                	jmp    8030ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803076:	89 74 24 04          	mov    %esi,0x4(%esp)
  80307a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803081:	e8 96 e5 ff ff       	call   80161c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80308d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803094:	e8 83 e5 ff ff       	call   80161c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030a7:	e8 70 e5 ff ff       	call   80161c <sys_page_unmap>
  8030ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8030ae:	83 c4 30             	add    $0x30,%esp
  8030b1:	5b                   	pop    %ebx
  8030b2:	5e                   	pop    %esi
  8030b3:	5d                   	pop    %ebp
  8030b4:	c3                   	ret    

008030b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8030b5:	55                   	push   %ebp
  8030b6:	89 e5                	mov    %esp,%ebp
  8030b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	89 04 24             	mov    %eax,(%esp)
  8030c8:	e8 e9 ee ff ff       	call   801fb6 <fd_lookup>
  8030cd:	89 c2                	mov    %eax,%edx
  8030cf:	85 d2                	test   %edx,%edx
  8030d1:	78 15                	js     8030e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	89 04 24             	mov    %eax,(%esp)
  8030d9:	e8 72 ee ff ff       	call   801f50 <fd2data>
	return _pipeisclosed(fd, p);
  8030de:	89 c2                	mov    %eax,%edx
  8030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e3:	e8 0b fd ff ff       	call   802df3 <_pipeisclosed>
}
  8030e8:	c9                   	leave  
  8030e9:	c3                   	ret    
  8030ea:	66 90                	xchg   %ax,%ax
  8030ec:	66 90                	xchg   %ax,%ax
  8030ee:	66 90                	xchg   %ax,%ax

008030f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8030f0:	55                   	push   %ebp
  8030f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8030f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f8:	5d                   	pop    %ebp
  8030f9:	c3                   	ret    

008030fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8030fa:	55                   	push   %ebp
  8030fb:	89 e5                	mov    %esp,%ebp
  8030fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803100:	c7 44 24 04 45 3d 80 	movl   $0x803d45,0x4(%esp)
  803107:	00 
  803108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310b:	89 04 24             	mov    %eax,(%esp)
  80310e:	e8 f4 df ff ff       	call   801107 <strcpy>
	return 0;
}
  803113:	b8 00 00 00 00       	mov    $0x0,%eax
  803118:	c9                   	leave  
  803119:	c3                   	ret    

0080311a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80311a:	55                   	push   %ebp
  80311b:	89 e5                	mov    %esp,%ebp
  80311d:	57                   	push   %edi
  80311e:	56                   	push   %esi
  80311f:	53                   	push   %ebx
  803120:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803126:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80312b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803131:	eb 31                	jmp    803164 <devcons_write+0x4a>
		m = n - tot;
  803133:	8b 75 10             	mov    0x10(%ebp),%esi
  803136:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  803138:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80313b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  803140:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803143:	89 74 24 08          	mov    %esi,0x8(%esp)
  803147:	03 45 0c             	add    0xc(%ebp),%eax
  80314a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80314e:	89 3c 24             	mov    %edi,(%esp)
  803151:	e8 4e e1 ff ff       	call   8012a4 <memmove>
		sys_cputs(buf, m);
  803156:	89 74 24 04          	mov    %esi,0x4(%esp)
  80315a:	89 3c 24             	mov    %edi,(%esp)
  80315d:	e8 f4 e2 ff ff       	call   801456 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803162:	01 f3                	add    %esi,%ebx
  803164:	89 d8                	mov    %ebx,%eax
  803166:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  803169:	72 c8                	jb     803133 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80316b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803171:	5b                   	pop    %ebx
  803172:	5e                   	pop    %esi
  803173:	5f                   	pop    %edi
  803174:	5d                   	pop    %ebp
  803175:	c3                   	ret    

00803176 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803176:	55                   	push   %ebp
  803177:	89 e5                	mov    %esp,%ebp
  803179:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80317c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803185:	75 07                	jne    80318e <devcons_read+0x18>
  803187:	eb 2a                	jmp    8031b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803189:	e8 c8 e3 ff ff       	call   801556 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80318e:	66 90                	xchg   %ax,%ax
  803190:	e8 df e2 ff ff       	call   801474 <sys_cgetc>
  803195:	85 c0                	test   %eax,%eax
  803197:	74 f0                	je     803189 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  803199:	85 c0                	test   %eax,%eax
  80319b:	78 16                	js     8031b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80319d:	83 f8 04             	cmp    $0x4,%eax
  8031a0:	74 0c                	je     8031ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8031a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a5:	88 02                	mov    %al,(%edx)
	return 1;
  8031a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ac:	eb 05                	jmp    8031b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8031ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8031b3:	c9                   	leave  
  8031b4:	c3                   	ret    

008031b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8031b5:	55                   	push   %ebp
  8031b6:	89 e5                	mov    %esp,%ebp
  8031b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8031c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8031c8:	00 
  8031c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8031cc:	89 04 24             	mov    %eax,(%esp)
  8031cf:	e8 82 e2 ff ff       	call   801456 <sys_cputs>
}
  8031d4:	c9                   	leave  
  8031d5:	c3                   	ret    

008031d6 <getchar>:

int
getchar(void)
{
  8031d6:	55                   	push   %ebp
  8031d7:	89 e5                	mov    %esp,%ebp
  8031d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8031dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8031e3:	00 
  8031e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8031e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031f2:	e8 53 f0 ff ff       	call   80224a <read>
	if (r < 0)
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	78 0f                	js     80320a <getchar+0x34>
		return r;
	if (r < 1)
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	7e 06                	jle    803205 <getchar+0x2f>
		return -E_EOF;
	return c;
  8031ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803203:	eb 05                	jmp    80320a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803205:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80320a:	c9                   	leave  
  80320b:	c3                   	ret    

0080320c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80320c:	55                   	push   %ebp
  80320d:	89 e5                	mov    %esp,%ebp
  80320f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803212:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803215:	89 44 24 04          	mov    %eax,0x4(%esp)
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	89 04 24             	mov    %eax,(%esp)
  80321f:	e8 92 ed ff ff       	call   801fb6 <fd_lookup>
  803224:	85 c0                	test   %eax,%eax
  803226:	78 11                	js     803239 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  803231:	39 10                	cmp    %edx,(%eax)
  803233:	0f 94 c0             	sete   %al
  803236:	0f b6 c0             	movzbl %al,%eax
}
  803239:	c9                   	leave  
  80323a:	c3                   	ret    

0080323b <opencons>:

int
opencons(void)
{
  80323b:	55                   	push   %ebp
  80323c:	89 e5                	mov    %esp,%ebp
  80323e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803241:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803244:	89 04 24             	mov    %eax,(%esp)
  803247:	e8 1b ed ff ff       	call   801f67 <fd_alloc>
		return r;
  80324c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80324e:	85 c0                	test   %eax,%eax
  803250:	78 40                	js     803292 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803252:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803259:	00 
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803261:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803268:	e8 08 e3 ff ff       	call   801575 <sys_page_alloc>
		return r;
  80326d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80326f:	85 c0                	test   %eax,%eax
  803271:	78 1f                	js     803292 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803273:	8b 15 58 40 80 00    	mov    0x804058,%edx
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803288:	89 04 24             	mov    %eax,(%esp)
  80328b:	e8 b0 ec ff ff       	call   801f40 <fd2num>
  803290:	89 c2                	mov    %eax,%edx
}
  803292:	89 d0                	mov    %edx,%eax
  803294:	c9                   	leave  
  803295:	c3                   	ret    

00803296 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803296:	55                   	push   %ebp
  803297:	89 e5                	mov    %esp,%ebp
  803299:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80329c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8032a3:	75 7a                	jne    80331f <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8032a5:	e8 8d e2 ff ff       	call   801537 <sys_getenvid>
  8032aa:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8032b1:	00 
  8032b2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8032b9:	ee 
  8032ba:	89 04 24             	mov    %eax,(%esp)
  8032bd:	e8 b3 e2 ff ff       	call   801575 <sys_page_alloc>
  8032c2:	85 c0                	test   %eax,%eax
  8032c4:	79 20                	jns    8032e6 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  8032c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032ca:	c7 44 24 08 49 3b 80 	movl   $0x803b49,0x8(%esp)
  8032d1:	00 
  8032d2:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8032d9:	00 
  8032da:	c7 04 24 51 3d 80 00 	movl   $0x803d51,(%esp)
  8032e1:	e8 a8 d6 ff ff       	call   80098e <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  8032e6:	e8 4c e2 ff ff       	call   801537 <sys_getenvid>
  8032eb:	c7 44 24 04 29 33 80 	movl   $0x803329,0x4(%esp)
  8032f2:	00 
  8032f3:	89 04 24             	mov    %eax,(%esp)
  8032f6:	e8 3a e4 ff ff       	call   801735 <sys_env_set_pgfault_upcall>
  8032fb:	85 c0                	test   %eax,%eax
  8032fd:	79 20                	jns    80331f <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  8032ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803303:	c7 44 24 08 b8 3b 80 	movl   $0x803bb8,0x8(%esp)
  80330a:	00 
  80330b:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  803312:	00 
  803313:	c7 04 24 51 3d 80 00 	movl   $0x803d51,(%esp)
  80331a:	e8 6f d6 ff ff       	call   80098e <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	a3 00 80 80 00       	mov    %eax,0x808000
}
  803327:	c9                   	leave  
  803328:	c3                   	ret    

00803329 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803329:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80332a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80332f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803331:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  803334:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  803338:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80333c:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  80333f:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  803343:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  803345:	83 c4 08             	add    $0x8,%esp
	popal
  803348:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  803349:	83 c4 04             	add    $0x4,%esp
	popfl
  80334c:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80334d:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80334e:	c3                   	ret    

0080334f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80334f:	55                   	push   %ebp
  803350:	89 e5                	mov    %esp,%ebp
  803352:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803355:	89 d0                	mov    %edx,%eax
  803357:	c1 e8 16             	shr    $0x16,%eax
  80335a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803361:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803366:	f6 c1 01             	test   $0x1,%cl
  803369:	74 1d                	je     803388 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80336b:	c1 ea 0c             	shr    $0xc,%edx
  80336e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803375:	f6 c2 01             	test   $0x1,%dl
  803378:	74 0e                	je     803388 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80337a:	c1 ea 0c             	shr    $0xc,%edx
  80337d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803384:	ef 
  803385:	0f b7 c0             	movzwl %ax,%eax
}
  803388:	5d                   	pop    %ebp
  803389:	c3                   	ret    
  80338a:	66 90                	xchg   %ax,%ax
  80338c:	66 90                	xchg   %ax,%ax
  80338e:	66 90                	xchg   %ax,%ax

00803390 <__udivdi3>:
  803390:	55                   	push   %ebp
  803391:	57                   	push   %edi
  803392:	56                   	push   %esi
  803393:	83 ec 0c             	sub    $0xc,%esp
  803396:	8b 44 24 28          	mov    0x28(%esp),%eax
  80339a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80339e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8033a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8033a6:	85 c0                	test   %eax,%eax
  8033a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8033ac:	89 ea                	mov    %ebp,%edx
  8033ae:	89 0c 24             	mov    %ecx,(%esp)
  8033b1:	75 2d                	jne    8033e0 <__udivdi3+0x50>
  8033b3:	39 e9                	cmp    %ebp,%ecx
  8033b5:	77 61                	ja     803418 <__udivdi3+0x88>
  8033b7:	85 c9                	test   %ecx,%ecx
  8033b9:	89 ce                	mov    %ecx,%esi
  8033bb:	75 0b                	jne    8033c8 <__udivdi3+0x38>
  8033bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8033c2:	31 d2                	xor    %edx,%edx
  8033c4:	f7 f1                	div    %ecx
  8033c6:	89 c6                	mov    %eax,%esi
  8033c8:	31 d2                	xor    %edx,%edx
  8033ca:	89 e8                	mov    %ebp,%eax
  8033cc:	f7 f6                	div    %esi
  8033ce:	89 c5                	mov    %eax,%ebp
  8033d0:	89 f8                	mov    %edi,%eax
  8033d2:	f7 f6                	div    %esi
  8033d4:	89 ea                	mov    %ebp,%edx
  8033d6:	83 c4 0c             	add    $0xc,%esp
  8033d9:	5e                   	pop    %esi
  8033da:	5f                   	pop    %edi
  8033db:	5d                   	pop    %ebp
  8033dc:	c3                   	ret    
  8033dd:	8d 76 00             	lea    0x0(%esi),%esi
  8033e0:	39 e8                	cmp    %ebp,%eax
  8033e2:	77 24                	ja     803408 <__udivdi3+0x78>
  8033e4:	0f bd e8             	bsr    %eax,%ebp
  8033e7:	83 f5 1f             	xor    $0x1f,%ebp
  8033ea:	75 3c                	jne    803428 <__udivdi3+0x98>
  8033ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8033f0:	39 34 24             	cmp    %esi,(%esp)
  8033f3:	0f 86 9f 00 00 00    	jbe    803498 <__udivdi3+0x108>
  8033f9:	39 d0                	cmp    %edx,%eax
  8033fb:	0f 82 97 00 00 00    	jb     803498 <__udivdi3+0x108>
  803401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803408:	31 d2                	xor    %edx,%edx
  80340a:	31 c0                	xor    %eax,%eax
  80340c:	83 c4 0c             	add    $0xc,%esp
  80340f:	5e                   	pop    %esi
  803410:	5f                   	pop    %edi
  803411:	5d                   	pop    %ebp
  803412:	c3                   	ret    
  803413:	90                   	nop
  803414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803418:	89 f8                	mov    %edi,%eax
  80341a:	f7 f1                	div    %ecx
  80341c:	31 d2                	xor    %edx,%edx
  80341e:	83 c4 0c             	add    $0xc,%esp
  803421:	5e                   	pop    %esi
  803422:	5f                   	pop    %edi
  803423:	5d                   	pop    %ebp
  803424:	c3                   	ret    
  803425:	8d 76 00             	lea    0x0(%esi),%esi
  803428:	89 e9                	mov    %ebp,%ecx
  80342a:	8b 3c 24             	mov    (%esp),%edi
  80342d:	d3 e0                	shl    %cl,%eax
  80342f:	89 c6                	mov    %eax,%esi
  803431:	b8 20 00 00 00       	mov    $0x20,%eax
  803436:	29 e8                	sub    %ebp,%eax
  803438:	89 c1                	mov    %eax,%ecx
  80343a:	d3 ef                	shr    %cl,%edi
  80343c:	89 e9                	mov    %ebp,%ecx
  80343e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803442:	8b 3c 24             	mov    (%esp),%edi
  803445:	09 74 24 08          	or     %esi,0x8(%esp)
  803449:	89 d6                	mov    %edx,%esi
  80344b:	d3 e7                	shl    %cl,%edi
  80344d:	89 c1                	mov    %eax,%ecx
  80344f:	89 3c 24             	mov    %edi,(%esp)
  803452:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803456:	d3 ee                	shr    %cl,%esi
  803458:	89 e9                	mov    %ebp,%ecx
  80345a:	d3 e2                	shl    %cl,%edx
  80345c:	89 c1                	mov    %eax,%ecx
  80345e:	d3 ef                	shr    %cl,%edi
  803460:	09 d7                	or     %edx,%edi
  803462:	89 f2                	mov    %esi,%edx
  803464:	89 f8                	mov    %edi,%eax
  803466:	f7 74 24 08          	divl   0x8(%esp)
  80346a:	89 d6                	mov    %edx,%esi
  80346c:	89 c7                	mov    %eax,%edi
  80346e:	f7 24 24             	mull   (%esp)
  803471:	39 d6                	cmp    %edx,%esi
  803473:	89 14 24             	mov    %edx,(%esp)
  803476:	72 30                	jb     8034a8 <__udivdi3+0x118>
  803478:	8b 54 24 04          	mov    0x4(%esp),%edx
  80347c:	89 e9                	mov    %ebp,%ecx
  80347e:	d3 e2                	shl    %cl,%edx
  803480:	39 c2                	cmp    %eax,%edx
  803482:	73 05                	jae    803489 <__udivdi3+0xf9>
  803484:	3b 34 24             	cmp    (%esp),%esi
  803487:	74 1f                	je     8034a8 <__udivdi3+0x118>
  803489:	89 f8                	mov    %edi,%eax
  80348b:	31 d2                	xor    %edx,%edx
  80348d:	e9 7a ff ff ff       	jmp    80340c <__udivdi3+0x7c>
  803492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803498:	31 d2                	xor    %edx,%edx
  80349a:	b8 01 00 00 00       	mov    $0x1,%eax
  80349f:	e9 68 ff ff ff       	jmp    80340c <__udivdi3+0x7c>
  8034a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8034ab:	31 d2                	xor    %edx,%edx
  8034ad:	83 c4 0c             	add    $0xc,%esp
  8034b0:	5e                   	pop    %esi
  8034b1:	5f                   	pop    %edi
  8034b2:	5d                   	pop    %ebp
  8034b3:	c3                   	ret    
  8034b4:	66 90                	xchg   %ax,%ax
  8034b6:	66 90                	xchg   %ax,%ax
  8034b8:	66 90                	xchg   %ax,%ax
  8034ba:	66 90                	xchg   %ax,%ax
  8034bc:	66 90                	xchg   %ax,%ax
  8034be:	66 90                	xchg   %ax,%ax

008034c0 <__umoddi3>:
  8034c0:	55                   	push   %ebp
  8034c1:	57                   	push   %edi
  8034c2:	56                   	push   %esi
  8034c3:	83 ec 14             	sub    $0x14,%esp
  8034c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8034ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8034ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8034d2:	89 c7                	mov    %eax,%edi
  8034d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8034dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8034e0:	89 34 24             	mov    %esi,(%esp)
  8034e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034e7:	85 c0                	test   %eax,%eax
  8034e9:	89 c2                	mov    %eax,%edx
  8034eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034ef:	75 17                	jne    803508 <__umoddi3+0x48>
  8034f1:	39 fe                	cmp    %edi,%esi
  8034f3:	76 4b                	jbe    803540 <__umoddi3+0x80>
  8034f5:	89 c8                	mov    %ecx,%eax
  8034f7:	89 fa                	mov    %edi,%edx
  8034f9:	f7 f6                	div    %esi
  8034fb:	89 d0                	mov    %edx,%eax
  8034fd:	31 d2                	xor    %edx,%edx
  8034ff:	83 c4 14             	add    $0x14,%esp
  803502:	5e                   	pop    %esi
  803503:	5f                   	pop    %edi
  803504:	5d                   	pop    %ebp
  803505:	c3                   	ret    
  803506:	66 90                	xchg   %ax,%ax
  803508:	39 f8                	cmp    %edi,%eax
  80350a:	77 54                	ja     803560 <__umoddi3+0xa0>
  80350c:	0f bd e8             	bsr    %eax,%ebp
  80350f:	83 f5 1f             	xor    $0x1f,%ebp
  803512:	75 5c                	jne    803570 <__umoddi3+0xb0>
  803514:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803518:	39 3c 24             	cmp    %edi,(%esp)
  80351b:	0f 87 e7 00 00 00    	ja     803608 <__umoddi3+0x148>
  803521:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803525:	29 f1                	sub    %esi,%ecx
  803527:	19 c7                	sbb    %eax,%edi
  803529:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80352d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803531:	8b 44 24 08          	mov    0x8(%esp),%eax
  803535:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803539:	83 c4 14             	add    $0x14,%esp
  80353c:	5e                   	pop    %esi
  80353d:	5f                   	pop    %edi
  80353e:	5d                   	pop    %ebp
  80353f:	c3                   	ret    
  803540:	85 f6                	test   %esi,%esi
  803542:	89 f5                	mov    %esi,%ebp
  803544:	75 0b                	jne    803551 <__umoddi3+0x91>
  803546:	b8 01 00 00 00       	mov    $0x1,%eax
  80354b:	31 d2                	xor    %edx,%edx
  80354d:	f7 f6                	div    %esi
  80354f:	89 c5                	mov    %eax,%ebp
  803551:	8b 44 24 04          	mov    0x4(%esp),%eax
  803555:	31 d2                	xor    %edx,%edx
  803557:	f7 f5                	div    %ebp
  803559:	89 c8                	mov    %ecx,%eax
  80355b:	f7 f5                	div    %ebp
  80355d:	eb 9c                	jmp    8034fb <__umoddi3+0x3b>
  80355f:	90                   	nop
  803560:	89 c8                	mov    %ecx,%eax
  803562:	89 fa                	mov    %edi,%edx
  803564:	83 c4 14             	add    $0x14,%esp
  803567:	5e                   	pop    %esi
  803568:	5f                   	pop    %edi
  803569:	5d                   	pop    %ebp
  80356a:	c3                   	ret    
  80356b:	90                   	nop
  80356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803570:	8b 04 24             	mov    (%esp),%eax
  803573:	be 20 00 00 00       	mov    $0x20,%esi
  803578:	89 e9                	mov    %ebp,%ecx
  80357a:	29 ee                	sub    %ebp,%esi
  80357c:	d3 e2                	shl    %cl,%edx
  80357e:	89 f1                	mov    %esi,%ecx
  803580:	d3 e8                	shr    %cl,%eax
  803582:	89 e9                	mov    %ebp,%ecx
  803584:	89 44 24 04          	mov    %eax,0x4(%esp)
  803588:	8b 04 24             	mov    (%esp),%eax
  80358b:	09 54 24 04          	or     %edx,0x4(%esp)
  80358f:	89 fa                	mov    %edi,%edx
  803591:	d3 e0                	shl    %cl,%eax
  803593:	89 f1                	mov    %esi,%ecx
  803595:	89 44 24 08          	mov    %eax,0x8(%esp)
  803599:	8b 44 24 10          	mov    0x10(%esp),%eax
  80359d:	d3 ea                	shr    %cl,%edx
  80359f:	89 e9                	mov    %ebp,%ecx
  8035a1:	d3 e7                	shl    %cl,%edi
  8035a3:	89 f1                	mov    %esi,%ecx
  8035a5:	d3 e8                	shr    %cl,%eax
  8035a7:	89 e9                	mov    %ebp,%ecx
  8035a9:	09 f8                	or     %edi,%eax
  8035ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8035af:	f7 74 24 04          	divl   0x4(%esp)
  8035b3:	d3 e7                	shl    %cl,%edi
  8035b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035b9:	89 d7                	mov    %edx,%edi
  8035bb:	f7 64 24 08          	mull   0x8(%esp)
  8035bf:	39 d7                	cmp    %edx,%edi
  8035c1:	89 c1                	mov    %eax,%ecx
  8035c3:	89 14 24             	mov    %edx,(%esp)
  8035c6:	72 2c                	jb     8035f4 <__umoddi3+0x134>
  8035c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8035cc:	72 22                	jb     8035f0 <__umoddi3+0x130>
  8035ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8035d2:	29 c8                	sub    %ecx,%eax
  8035d4:	19 d7                	sbb    %edx,%edi
  8035d6:	89 e9                	mov    %ebp,%ecx
  8035d8:	89 fa                	mov    %edi,%edx
  8035da:	d3 e8                	shr    %cl,%eax
  8035dc:	89 f1                	mov    %esi,%ecx
  8035de:	d3 e2                	shl    %cl,%edx
  8035e0:	89 e9                	mov    %ebp,%ecx
  8035e2:	d3 ef                	shr    %cl,%edi
  8035e4:	09 d0                	or     %edx,%eax
  8035e6:	89 fa                	mov    %edi,%edx
  8035e8:	83 c4 14             	add    $0x14,%esp
  8035eb:	5e                   	pop    %esi
  8035ec:	5f                   	pop    %edi
  8035ed:	5d                   	pop    %ebp
  8035ee:	c3                   	ret    
  8035ef:	90                   	nop
  8035f0:	39 d7                	cmp    %edx,%edi
  8035f2:	75 da                	jne    8035ce <__umoddi3+0x10e>
  8035f4:	8b 14 24             	mov    (%esp),%edx
  8035f7:	89 c1                	mov    %eax,%ecx
  8035f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8035fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803601:	eb cb                	jmp    8035ce <__umoddi3+0x10e>
  803603:	90                   	nop
  803604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803608:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80360c:	0f 82 0f ff ff ff    	jb     803521 <__umoddi3+0x61>
  803612:	e9 1a ff ff ff       	jmp    803531 <__umoddi3+0x71>
