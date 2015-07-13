
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 15 05 00 00       	call   800546 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004c:	89 34 24             	mov    %esi,(%esp)
  80004f:	e8 60 1e 00 00       	call   801eb4 <seek>
	seek(kfd, off);
  800054:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800058:	89 3c 24             	mov    %edi,(%esp)
  80005b:	e8 54 1e 00 00       	call   801eb4 <seek>

	cprintf("shell produced incorrect output.\n");
  800060:	c7 04 24 80 37 80 00 	movl   $0x803780,(%esp)
  800067:	e8 34 06 00 00       	call   8006a0 <cprintf>
	cprintf("expected:\n===\n");
  80006c:	c7 04 24 eb 37 80 00 	movl   $0x8037eb,(%esp)
  800073:	e8 28 06 00 00       	call   8006a0 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	eb 0c                	jmp    800089 <wrong+0x56>
		sys_cputs(buf, n);
  80007d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800081:	89 1c 24             	mov    %ebx,(%esp)
  800084:	e8 dd 0f 00 00       	call   801066 <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800089:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  800090:	00 
  800091:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800095:	89 3c 24             	mov    %edi,(%esp)
  800098:	e8 ad 1c 00 00       	call   801d4a <read>
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f dc                	jg     80007d <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000a1:	c7 04 24 fa 37 80 00 	movl   $0x8037fa,(%esp)
  8000a8:	e8 f3 05 00 00       	call   8006a0 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ad:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b0:	eb 0c                	jmp    8000be <wrong+0x8b>
		sys_cputs(buf, n);
  8000b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b6:	89 1c 24             	mov    %ebx,(%esp)
  8000b9:	e8 a8 0f 00 00       	call   801066 <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000be:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000c5:	00 
  8000c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ca:	89 34 24             	mov    %esi,(%esp)
  8000cd:	e8 78 1c 00 00       	call   801d4a <read>
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	7f dc                	jg     8000b2 <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000d6:	c7 04 24 f5 37 80 00 	movl   $0x8037f5,(%esp)
  8000dd:	e8 be 05 00 00       	call   8006a0 <cprintf>
	exit();
  8000e2:	e8 a7 04 00 00       	call   80058e <exit>
}
  8000e7:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000ed:	5b                   	pop    %ebx
  8000ee:	5e                   	pop    %esi
  8000ef:	5f                   	pop    %edi
  8000f0:	5d                   	pop    %ebp
  8000f1:	c3                   	ret    

008000f2 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  8000fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800102:	e8 e0 1a 00 00       	call   801be7 <close>
	close(1);
  800107:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010e:	e8 d4 1a 00 00       	call   801be7 <close>
	opencons();
  800113:	e8 d3 03 00 00       	call   8004eb <opencons>
	opencons();
  800118:	e8 ce 03 00 00       	call   8004eb <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80011d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800124:	00 
  800125:	c7 04 24 08 38 80 00 	movl   $0x803808,(%esp)
  80012c:	e8 63 21 00 00       	call   802294 <open>
  800131:	89 c3                	mov    %eax,%ebx
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 15 38 80 	movl   $0x803815,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 2b 38 80 00 	movl   $0x80382b,(%esp)
  800152:	e8 50 04 00 00       	call   8005a7 <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800157:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 72 2f 00 00       	call   8030d4 <pipe>
  800162:	85 c0                	test   %eax,%eax
  800164:	79 20                	jns    800186 <umain+0x94>
		panic("pipe: %e", wfd);
  800166:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016a:	c7 44 24 08 3c 38 80 	movl   $0x80383c,0x8(%esp)
  800171:	00 
  800172:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800179:	00 
  80017a:	c7 04 24 2b 38 80 00 	movl   $0x80382b,(%esp)
  800181:	e8 21 04 00 00       	call   8005a7 <_panic>
	wfd = pfds[1];
  800186:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  800189:	c7 04 24 a4 37 80 00 	movl   $0x8037a4,(%esp)
  800190:	e8 0b 05 00 00       	call   8006a0 <cprintf>
	if ((r = fork()) < 0)
  800195:	e8 05 15 00 00       	call   80169f <fork>
  80019a:	85 c0                	test   %eax,%eax
  80019c:	79 20                	jns    8001be <umain+0xcc>
		panic("fork: %e", r);
  80019e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a2:	c7 44 24 08 45 38 80 	movl   $0x803845,0x8(%esp)
  8001a9:	00 
  8001aa:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8001b1:	00 
  8001b2:	c7 04 24 2b 38 80 00 	movl   $0x80382b,(%esp)
  8001b9:	e8 e9 03 00 00       	call   8005a7 <_panic>
	if (r == 0) {
  8001be:	85 c0                	test   %eax,%eax
  8001c0:	0f 85 9f 00 00 00    	jne    800265 <umain+0x173>
		dup(rfd, 0);
  8001c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001cd:	00 
  8001ce:	89 1c 24             	mov    %ebx,(%esp)
  8001d1:	e8 66 1a 00 00       	call   801c3c <dup>
		dup(wfd, 1);
  8001d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001dd:	00 
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 56 1a 00 00       	call   801c3c <dup>
		close(rfd);
  8001e6:	89 1c 24             	mov    %ebx,(%esp)
  8001e9:	e8 f9 19 00 00       	call   801be7 <close>
		close(wfd);
  8001ee:	89 34 24             	mov    %esi,(%esp)
  8001f1:	e8 f1 19 00 00       	call   801be7 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  8001f6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001fd:	00 
  8001fe:	c7 44 24 08 4e 38 80 	movl   $0x80384e,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 12 38 80 	movl   $0x803812,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 51 38 80 00 	movl   $0x803851,(%esp)
  800215:	e8 58 27 00 00       	call   802972 <spawnl>
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	85 c0                	test   %eax,%eax
  80021e:	79 20                	jns    800240 <umain+0x14e>
			panic("spawn: %e", r);
  800220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800224:	c7 44 24 08 55 38 80 	movl   $0x803855,0x8(%esp)
  80022b:	00 
  80022c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800233:	00 
  800234:	c7 04 24 2b 38 80 00 	movl   $0x80382b,(%esp)
  80023b:	e8 67 03 00 00       	call   8005a7 <_panic>
		close(0);
  800240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800247:	e8 9b 19 00 00       	call   801be7 <close>
		close(1);
  80024c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800253:	e8 8f 19 00 00       	call   801be7 <close>
		wait(r);
  800258:	89 3c 24             	mov    %edi,(%esp)
  80025b:	e8 1a 30 00 00       	call   80327a <wait>
		exit();
  800260:	e8 29 03 00 00       	call   80058e <exit>
	}
	close(rfd);
  800265:	89 1c 24             	mov    %ebx,(%esp)
  800268:	e8 7a 19 00 00       	call   801be7 <close>
	close(wfd);
  80026d:	89 34 24             	mov    %esi,(%esp)
  800270:	e8 72 19 00 00       	call   801be7 <close>

	rfd = pfds[0];
  800275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800278:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  80027b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800282:	00 
  800283:	c7 04 24 5f 38 80 00 	movl   $0x80385f,(%esp)
  80028a:	e8 05 20 00 00       	call   802294 <open>
  80028f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800292:	85 c0                	test   %eax,%eax
  800294:	79 20                	jns    8002b6 <umain+0x1c4>
		panic("open testshell.key for reading: %e", kfd);
  800296:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029a:	c7 44 24 08 c8 37 80 	movl   $0x8037c8,0x8(%esp)
  8002a1:	00 
  8002a2:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002a9:	00 
  8002aa:	c7 04 24 2b 38 80 00 	movl   $0x80382b,(%esp)
  8002b1:	e8 f1 02 00 00       	call   8005a7 <_panic>
	}
	close(rfd);
	close(wfd);

	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002b6:	be 01 00 00 00       	mov    $0x1,%esi
  8002bb:	bf 00 00 00 00       	mov    $0x0,%edi
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  8002c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002c7:	00 
  8002c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d2:	89 04 24             	mov    %eax,(%esp)
  8002d5:	e8 70 1a 00 00       	call   801d4a <read>
  8002da:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002e3:	00 
  8002e4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	e8 54 1a 00 00       	call   801d4a <read>
		if (n1 < 0)
  8002f6:	85 db                	test   %ebx,%ebx
  8002f8:	79 20                	jns    80031a <umain+0x228>
			panic("reading testshell.out: %e", n1);
  8002fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002fe:	c7 44 24 08 6d 38 80 	movl   $0x80386d,0x8(%esp)
  800305:	00 
  800306:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80030d:	00 
  80030e:	c7 04 24 2b 38 80 00 	movl   $0x80382b,(%esp)
  800315:	e8 8d 02 00 00       	call   8005a7 <_panic>
		if (n2 < 0)
  80031a:	85 c0                	test   %eax,%eax
  80031c:	79 20                	jns    80033e <umain+0x24c>
			panic("reading testshell.key: %e", n2);
  80031e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800322:	c7 44 24 08 87 38 80 	movl   $0x803887,0x8(%esp)
  800329:	00 
  80032a:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800331:	00 
  800332:	c7 04 24 2b 38 80 00 	movl   $0x80382b,(%esp)
  800339:	e8 69 02 00 00       	call   8005a7 <_panic>
		if (n1 == 0 && n2 == 0)
  80033e:	89 c2                	mov    %eax,%edx
  800340:	09 da                	or     %ebx,%edx
  800342:	74 38                	je     80037c <umain+0x28a>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800344:	83 fb 01             	cmp    $0x1,%ebx
  800347:	75 0e                	jne    800357 <umain+0x265>
  800349:	83 f8 01             	cmp    $0x1,%eax
  80034c:	75 09                	jne    800357 <umain+0x265>
  80034e:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  800352:	38 45 e7             	cmp    %al,-0x19(%ebp)
  800355:	74 16                	je     80036d <umain+0x27b>
			wrong(rfd, kfd, nloff);
  800357:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80035b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800362:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	e8 c6 fc ff ff       	call   800033 <wrong>
		if (c1 == '\n')
			nloff = off+1;
  80036d:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  800371:	0f 44 fe             	cmove  %esi,%edi
  800374:	83 c6 01             	add    $0x1,%esi
	}
  800377:	e9 44 ff ff ff       	jmp    8002c0 <umain+0x1ce>
	cprintf("shell ran correctly\n");
  80037c:	c7 04 24 a1 38 80 00 	movl   $0x8038a1,(%esp)
  800383:	e8 18 03 00 00       	call   8006a0 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800388:	cc                   	int3   

	breakpoint();
}
  800389:	83 c4 3c             	add    $0x3c,%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    
  800391:	66 90                	xchg   %ax,%ax
  800393:	66 90                	xchg   %ax,%ax
  800395:	66 90                	xchg   %ax,%ax
  800397:	66 90                	xchg   %ax,%ax
  800399:	66 90                	xchg   %ax,%ax
  80039b:	66 90                	xchg   %ax,%ax
  80039d:	66 90                	xchg   %ax,%ax
  80039f:	90                   	nop

008003a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8003b0:	c7 44 24 04 b6 38 80 	movl   $0x8038b6,0x4(%esp)
  8003b7:	00 
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	e8 54 09 00 00       	call   800d17 <strcpy>
	return 0;
}
  8003c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
  8003d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003e1:	eb 31                	jmp    800414 <devcons_write+0x4a>
		m = n - tot;
  8003e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8003e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8003e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8003eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8003f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003f7:	03 45 0c             	add    0xc(%ebp),%eax
  8003fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fe:	89 3c 24             	mov    %edi,(%esp)
  800401:	e8 ae 0a 00 00       	call   800eb4 <memmove>
		sys_cputs(buf, m);
  800406:	89 74 24 04          	mov    %esi,0x4(%esp)
  80040a:	89 3c 24             	mov    %edi,(%esp)
  80040d:	e8 54 0c 00 00       	call   801066 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800412:	01 f3                	add    %esi,%ebx
  800414:	89 d8                	mov    %ebx,%eax
  800416:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800419:	72 c8                	jb     8003e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80041b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80042c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800431:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800435:	75 07                	jne    80043e <devcons_read+0x18>
  800437:	eb 2a                	jmp    800463 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800439:	e8 28 0d 00 00       	call   801166 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80043e:	66 90                	xchg   %ax,%ax
  800440:	e8 3f 0c 00 00       	call   801084 <sys_cgetc>
  800445:	85 c0                	test   %eax,%eax
  800447:	74 f0                	je     800439 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800449:	85 c0                	test   %eax,%eax
  80044b:	78 16                	js     800463 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80044d:	83 f8 04             	cmp    $0x4,%eax
  800450:	74 0c                	je     80045e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	88 02                	mov    %al,(%edx)
	return 1;
  800457:	b8 01 00 00 00       	mov    $0x1,%eax
  80045c:	eb 05                	jmp    800463 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80045e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800471:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800478:	00 
  800479:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80047c:	89 04 24             	mov    %eax,(%esp)
  80047f:	e8 e2 0b 00 00       	call   801066 <sys_cputs>
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <getchar>:

int
getchar(void)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80048c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800493:	00 
  800494:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004a2:	e8 a3 18 00 00       	call   801d4a <read>
	if (r < 0)
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	78 0f                	js     8004ba <getchar+0x34>
		return r;
	if (r < 1)
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	7e 06                	jle    8004b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8004af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8004b3:	eb 05                	jmp    8004ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8004b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	89 04 24             	mov    %eax,(%esp)
  8004cf:	e8 e2 15 00 00       	call   801ab6 <fd_lookup>
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	78 11                	js     8004e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8004d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004db:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8004e1:	39 10                	cmp    %edx,(%eax)
  8004e3:	0f 94 c0             	sete   %al
  8004e6:	0f b6 c0             	movzbl %al,%eax
}
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <opencons>:

int
opencons(void)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004f4:	89 04 24             	mov    %eax,(%esp)
  8004f7:	e8 6b 15 00 00       	call   801a67 <fd_alloc>
		return r;
  8004fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004fe:	85 c0                	test   %eax,%eax
  800500:	78 40                	js     800542 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800502:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800509:	00 
  80050a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800518:	e8 68 0c 00 00       	call   801185 <sys_page_alloc>
		return r;
  80051d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80051f:	85 c0                	test   %eax,%eax
  800521:	78 1f                	js     800542 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800523:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80052e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800531:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	e8 00 15 00 00       	call   801a40 <fd2num>
  800540:	89 c2                	mov    %eax,%edx
}
  800542:	89 d0                	mov    %edx,%eax
  800544:	c9                   	leave  
  800545:	c3                   	ret    

00800546 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	56                   	push   %esi
  80054a:	53                   	push   %ebx
  80054b:	83 ec 10             	sub    $0x10,%esp
  80054e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800551:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800554:	e8 ee 0b 00 00       	call   801147 <sys_getenvid>
  800559:	25 ff 03 00 00       	and    $0x3ff,%eax
  80055e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800561:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800566:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80056b:	85 db                	test   %ebx,%ebx
  80056d:	7e 07                	jle    800576 <libmain+0x30>
		binaryname = argv[0];
  80056f:	8b 06                	mov    (%esi),%eax
  800571:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800576:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057a:	89 1c 24             	mov    %ebx,(%esp)
  80057d:	e8 70 fb ff ff       	call   8000f2 <umain>

	// exit gracefully
	exit();
  800582:	e8 07 00 00 00       	call   80058e <exit>
}
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5e                   	pop    %esi
  80058c:	5d                   	pop    %ebp
  80058d:	c3                   	ret    

0080058e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800594:	e8 81 16 00 00       	call   801c1a <close_all>
	sys_env_destroy(0);
  800599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005a0:	e8 fe 0a 00 00       	call   8010a3 <sys_env_destroy>
}
  8005a5:	c9                   	leave  
  8005a6:	c3                   	ret    

008005a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	56                   	push   %esi
  8005ab:	53                   	push   %ebx
  8005ac:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8005af:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005b2:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8005b8:	e8 8a 0b 00 00       	call   801147 <sys_getenvid>
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005cb:	89 74 24 08          	mov    %esi,0x8(%esp)
  8005cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d3:	c7 04 24 cc 38 80 00 	movl   $0x8038cc,(%esp)
  8005da:	e8 c1 00 00 00       	call   8006a0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e6:	89 04 24             	mov    %eax,(%esp)
  8005e9:	e8 51 00 00 00       	call   80063f <vcprintf>
	cprintf("\n");
  8005ee:	c7 04 24 f8 37 80 00 	movl   $0x8037f8,(%esp)
  8005f5:	e8 a6 00 00 00       	call   8006a0 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005fa:	cc                   	int3   
  8005fb:	eb fd                	jmp    8005fa <_panic+0x53>

008005fd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	53                   	push   %ebx
  800601:	83 ec 14             	sub    $0x14,%esp
  800604:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800607:	8b 13                	mov    (%ebx),%edx
  800609:	8d 42 01             	lea    0x1(%edx),%eax
  80060c:	89 03                	mov    %eax,(%ebx)
  80060e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800611:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800615:	3d ff 00 00 00       	cmp    $0xff,%eax
  80061a:	75 19                	jne    800635 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80061c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800623:	00 
  800624:	8d 43 08             	lea    0x8(%ebx),%eax
  800627:	89 04 24             	mov    %eax,(%esp)
  80062a:	e8 37 0a 00 00       	call   801066 <sys_cputs>
		b->idx = 0;
  80062f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800635:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800639:	83 c4 14             	add    $0x14,%esp
  80063c:	5b                   	pop    %ebx
  80063d:	5d                   	pop    %ebp
  80063e:	c3                   	ret    

0080063f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800648:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064f:	00 00 00 
	b.cnt = 0;
  800652:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800659:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	89 44 24 08          	mov    %eax,0x8(%esp)
  80066a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800670:	89 44 24 04          	mov    %eax,0x4(%esp)
  800674:	c7 04 24 fd 05 80 00 	movl   $0x8005fd,(%esp)
  80067b:	e8 74 01 00 00       	call   8007f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800680:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800686:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800690:	89 04 24             	mov    %eax,(%esp)
  800693:	e8 ce 09 00 00       	call   801066 <sys_cputs>

	return b.cnt;
}
  800698:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80069e:	c9                   	leave  
  80069f:	c3                   	ret    

008006a0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006a6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 04 24             	mov    %eax,(%esp)
  8006b3:	e8 87 ff ff ff       	call   80063f <vcprintf>
	va_end(ap);

	return cnt;
}
  8006b8:	c9                   	leave  
  8006b9:	c3                   	ret    
  8006ba:	66 90                	xchg   %ax,%ax
  8006bc:	66 90                	xchg   %ax,%ax
  8006be:	66 90                	xchg   %ax,%ax

008006c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	57                   	push   %edi
  8006c4:	56                   	push   %esi
  8006c5:	53                   	push   %ebx
  8006c6:	83 ec 3c             	sub    $0x3c,%esp
  8006c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cc:	89 d7                	mov    %edx,%edi
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d7:	89 c3                	mov    %eax,%ebx
  8006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8006df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ed:	39 d9                	cmp    %ebx,%ecx
  8006ef:	72 05                	jb     8006f6 <printnum+0x36>
  8006f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006f4:	77 69                	ja     80075f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8006fd:	83 ee 01             	sub    $0x1,%esi
  800700:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800704:	89 44 24 08          	mov    %eax,0x8(%esp)
  800708:	8b 44 24 08          	mov    0x8(%esp),%eax
  80070c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800710:	89 c3                	mov    %eax,%ebx
  800712:	89 d6                	mov    %edx,%esi
  800714:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800717:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80071a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80071e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800725:	89 04 24             	mov    %eax,(%esp)
  800728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072f:	e8 bc 2d 00 00       	call   8034f0 <__udivdi3>
  800734:	89 d9                	mov    %ebx,%ecx
  800736:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80073a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80073e:	89 04 24             	mov    %eax,(%esp)
  800741:	89 54 24 04          	mov    %edx,0x4(%esp)
  800745:	89 fa                	mov    %edi,%edx
  800747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80074a:	e8 71 ff ff ff       	call   8006c0 <printnum>
  80074f:	eb 1b                	jmp    80076c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800751:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800755:	8b 45 18             	mov    0x18(%ebp),%eax
  800758:	89 04 24             	mov    %eax,(%esp)
  80075b:	ff d3                	call   *%ebx
  80075d:	eb 03                	jmp    800762 <printnum+0xa2>
  80075f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800762:	83 ee 01             	sub    $0x1,%esi
  800765:	85 f6                	test   %esi,%esi
  800767:	7f e8                	jg     800751 <printnum+0x91>
  800769:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80076c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800770:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800774:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800777:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80077a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80077e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800782:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80078b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078f:	e8 8c 2e 00 00       	call   803620 <__umoddi3>
  800794:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800798:	0f be 80 ef 38 80 00 	movsbl 0x8038ef(%eax),%eax
  80079f:	89 04 24             	mov    %eax,(%esp)
  8007a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
}
  8007a7:	83 c4 3c             	add    $0x3c,%esp
  8007aa:	5b                   	pop    %ebx
  8007ab:	5e                   	pop    %esi
  8007ac:	5f                   	pop    %edi
  8007ad:	5d                   	pop    %ebp
  8007ae:	c3                   	ret    

008007af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007b5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007b9:	8b 10                	mov    (%eax),%edx
  8007bb:	3b 50 04             	cmp    0x4(%eax),%edx
  8007be:	73 0a                	jae    8007ca <sprintputch+0x1b>
		*b->buf++ = ch;
  8007c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007c3:	89 08                	mov    %ecx,(%eax)
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	88 02                	mov    %al,(%edx)
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007d2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	89 04 24             	mov    %eax,(%esp)
  8007ed:	e8 02 00 00 00       	call   8007f4 <vprintfmt>
	va_end(ap);
}
  8007f2:	c9                   	leave  
  8007f3:	c3                   	ret    

008007f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	57                   	push   %edi
  8007f8:	56                   	push   %esi
  8007f9:	53                   	push   %ebx
  8007fa:	83 ec 3c             	sub    $0x3c,%esp
  8007fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800800:	eb 17                	jmp    800819 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800802:	85 c0                	test   %eax,%eax
  800804:	0f 84 4b 04 00 00    	je     800c55 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80080a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800811:	89 04 24             	mov    %eax,(%esp)
  800814:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800817:	89 fb                	mov    %edi,%ebx
  800819:	8d 7b 01             	lea    0x1(%ebx),%edi
  80081c:	0f b6 03             	movzbl (%ebx),%eax
  80081f:	83 f8 25             	cmp    $0x25,%eax
  800822:	75 de                	jne    800802 <vprintfmt+0xe>
  800824:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800828:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80082f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800834:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80083b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800840:	eb 18                	jmp    80085a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800842:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800844:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800848:	eb 10                	jmp    80085a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800850:	eb 08                	jmp    80085a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800852:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800855:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80085a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80085d:	0f b6 17             	movzbl (%edi),%edx
  800860:	0f b6 c2             	movzbl %dl,%eax
  800863:	83 ea 23             	sub    $0x23,%edx
  800866:	80 fa 55             	cmp    $0x55,%dl
  800869:	0f 87 c2 03 00 00    	ja     800c31 <vprintfmt+0x43d>
  80086f:	0f b6 d2             	movzbl %dl,%edx
  800872:	ff 24 95 40 3a 80 00 	jmp    *0x803a40(,%edx,4)
  800879:	89 df                	mov    %ebx,%edi
  80087b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800880:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800883:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800887:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80088a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80088d:	83 fa 09             	cmp    $0x9,%edx
  800890:	77 33                	ja     8008c5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800892:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800895:	eb e9                	jmp    800880 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8b 30                	mov    (%eax),%esi
  80089c:	8d 40 04             	lea    0x4(%eax),%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008a2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8008a4:	eb 1f                	jmp    8008c5 <vprintfmt+0xd1>
  8008a6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8008a9:	85 ff                	test   %edi,%edi
  8008ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b0:	0f 49 c7             	cmovns %edi,%eax
  8008b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b6:	89 df                	mov    %ebx,%edi
  8008b8:	eb a0                	jmp    80085a <vprintfmt+0x66>
  8008ba:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8008bc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8008c3:	eb 95                	jmp    80085a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8008c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008c9:	79 8f                	jns    80085a <vprintfmt+0x66>
  8008cb:	eb 85                	jmp    800852 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008cd:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8008d2:	eb 86                	jmp    80085a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	8d 70 04             	lea    0x4(%eax),%esi
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	89 04 24             	mov    %eax,(%esp)
  8008e9:	ff 55 08             	call   *0x8(%ebp)
  8008ec:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8008ef:	e9 25 ff ff ff       	jmp    800819 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	8d 70 04             	lea    0x4(%eax),%esi
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	99                   	cltd   
  8008fd:	31 d0                	xor    %edx,%eax
  8008ff:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800901:	83 f8 15             	cmp    $0x15,%eax
  800904:	7f 0b                	jg     800911 <vprintfmt+0x11d>
  800906:	8b 14 85 a0 3b 80 00 	mov    0x803ba0(,%eax,4),%edx
  80090d:	85 d2                	test   %edx,%edx
  80090f:	75 26                	jne    800937 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800911:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800915:	c7 44 24 08 07 39 80 	movl   $0x803907,0x8(%esp)
  80091c:	00 
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	89 44 24 04          	mov    %eax,0x4(%esp)
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	89 04 24             	mov    %eax,(%esp)
  80092a:	e8 9d fe ff ff       	call   8007cc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800932:	e9 e2 fe ff ff       	jmp    800819 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800937:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80093b:	c7 44 24 08 ba 3d 80 	movl   $0x803dba,0x8(%esp)
  800942:	00 
  800943:	8b 45 0c             	mov    0xc(%ebp),%eax
  800946:	89 44 24 04          	mov    %eax,0x4(%esp)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	89 04 24             	mov    %eax,(%esp)
  800950:	e8 77 fe ff ff       	call   8007cc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800955:	89 75 14             	mov    %esi,0x14(%ebp)
  800958:	e9 bc fe ff ff       	jmp    800819 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800963:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800966:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80096a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80096c:	85 ff                	test   %edi,%edi
  80096e:	b8 00 39 80 00       	mov    $0x803900,%eax
  800973:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800976:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80097a:	0f 84 94 00 00 00    	je     800a14 <vprintfmt+0x220>
  800980:	85 c9                	test   %ecx,%ecx
  800982:	0f 8e 94 00 00 00    	jle    800a1c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800988:	89 74 24 04          	mov    %esi,0x4(%esp)
  80098c:	89 3c 24             	mov    %edi,(%esp)
  80098f:	e8 64 03 00 00       	call   800cf8 <strnlen>
  800994:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800997:	29 c1                	sub    %eax,%ecx
  800999:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80099c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8009a0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8009a3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8009a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009ac:	89 cb                	mov    %ecx,%ebx
  8009ae:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b0:	eb 0f                	jmp    8009c1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b9:	89 3c 24             	mov    %edi,(%esp)
  8009bc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	83 eb 01             	sub    $0x1,%ebx
  8009c1:	85 db                	test   %ebx,%ebx
  8009c3:	7f ed                	jg     8009b2 <vprintfmt+0x1be>
  8009c5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8009cb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009ce:	85 c9                	test   %ecx,%ecx
  8009d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d5:	0f 49 c1             	cmovns %ecx,%eax
  8009d8:	29 c1                	sub    %eax,%ecx
  8009da:	89 cb                	mov    %ecx,%ebx
  8009dc:	eb 44                	jmp    800a22 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e2:	74 1e                	je     800a02 <vprintfmt+0x20e>
  8009e4:	0f be d2             	movsbl %dl,%edx
  8009e7:	83 ea 20             	sub    $0x20,%edx
  8009ea:	83 fa 5e             	cmp    $0x5e,%edx
  8009ed:	76 13                	jbe    800a02 <vprintfmt+0x20e>
					putch('?', putdat);
  8009ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009fd:	ff 55 08             	call   *0x8(%ebp)
  800a00:	eb 0d                	jmp    800a0f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800a02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a05:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a09:	89 04 24             	mov    %eax,(%esp)
  800a0c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0f:	83 eb 01             	sub    $0x1,%ebx
  800a12:	eb 0e                	jmp    800a22 <vprintfmt+0x22e>
  800a14:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a17:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a1a:	eb 06                	jmp    800a22 <vprintfmt+0x22e>
  800a1c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a22:	83 c7 01             	add    $0x1,%edi
  800a25:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800a29:	0f be c2             	movsbl %dl,%eax
  800a2c:	85 c0                	test   %eax,%eax
  800a2e:	74 27                	je     800a57 <vprintfmt+0x263>
  800a30:	85 f6                	test   %esi,%esi
  800a32:	78 aa                	js     8009de <vprintfmt+0x1ea>
  800a34:	83 ee 01             	sub    $0x1,%esi
  800a37:	79 a5                	jns    8009de <vprintfmt+0x1ea>
  800a39:	89 d8                	mov    %ebx,%eax
  800a3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a41:	89 c3                	mov    %eax,%ebx
  800a43:	eb 18                	jmp    800a5d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a45:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a49:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a50:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a52:	83 eb 01             	sub    $0x1,%ebx
  800a55:	eb 06                	jmp    800a5d <vprintfmt+0x269>
  800a57:	8b 75 08             	mov    0x8(%ebp),%esi
  800a5a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	7f e4                	jg     800a45 <vprintfmt+0x251>
  800a61:	89 75 08             	mov    %esi,0x8(%ebp)
  800a64:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a6a:	e9 aa fd ff ff       	jmp    800819 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a6f:	83 f9 01             	cmp    $0x1,%ecx
  800a72:	7e 10                	jle    800a84 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	8b 30                	mov    (%eax),%esi
  800a79:	8b 78 04             	mov    0x4(%eax),%edi
  800a7c:	8d 40 08             	lea    0x8(%eax),%eax
  800a7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a82:	eb 26                	jmp    800aaa <vprintfmt+0x2b6>
	else if (lflag)
  800a84:	85 c9                	test   %ecx,%ecx
  800a86:	74 12                	je     800a9a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	8b 30                	mov    (%eax),%esi
  800a8d:	89 f7                	mov    %esi,%edi
  800a8f:	c1 ff 1f             	sar    $0x1f,%edi
  800a92:	8d 40 04             	lea    0x4(%eax),%eax
  800a95:	89 45 14             	mov    %eax,0x14(%ebp)
  800a98:	eb 10                	jmp    800aaa <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	8b 30                	mov    (%eax),%esi
  800a9f:	89 f7                	mov    %esi,%edi
  800aa1:	c1 ff 1f             	sar    $0x1f,%edi
  800aa4:	8d 40 04             	lea    0x4(%eax),%eax
  800aa7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aaa:	89 f0                	mov    %esi,%eax
  800aac:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800aae:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800ab3:	85 ff                	test   %edi,%edi
  800ab5:	0f 89 3a 01 00 00    	jns    800bf5 <vprintfmt+0x401>
				putch('-', putdat);
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ac9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800acc:	89 f0                	mov    %esi,%eax
  800ace:	89 fa                	mov    %edi,%edx
  800ad0:	f7 d8                	neg    %eax
  800ad2:	83 d2 00             	adc    $0x0,%edx
  800ad5:	f7 da                	neg    %edx
			}
			base = 10;
  800ad7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800adc:	e9 14 01 00 00       	jmp    800bf5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ae1:	83 f9 01             	cmp    $0x1,%ecx
  800ae4:	7e 13                	jle    800af9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	8b 50 04             	mov    0x4(%eax),%edx
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	8b 75 14             	mov    0x14(%ebp),%esi
  800af1:	8d 4e 08             	lea    0x8(%esi),%ecx
  800af4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800af7:	eb 2c                	jmp    800b25 <vprintfmt+0x331>
	else if (lflag)
  800af9:	85 c9                	test   %ecx,%ecx
  800afb:	74 15                	je     800b12 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  800afd:	8b 45 14             	mov    0x14(%ebp),%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	ba 00 00 00 00       	mov    $0x0,%edx
  800b07:	8b 75 14             	mov    0x14(%ebp),%esi
  800b0a:	8d 76 04             	lea    0x4(%esi),%esi
  800b0d:	89 75 14             	mov    %esi,0x14(%ebp)
  800b10:	eb 13                	jmp    800b25 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800b12:	8b 45 14             	mov    0x14(%ebp),%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1c:	8b 75 14             	mov    0x14(%ebp),%esi
  800b1f:	8d 76 04             	lea    0x4(%esi),%esi
  800b22:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800b25:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800b2a:	e9 c6 00 00 00       	jmp    800bf5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b2f:	83 f9 01             	cmp    $0x1,%ecx
  800b32:	7e 13                	jle    800b47 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	8b 50 04             	mov    0x4(%eax),%edx
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8b 75 14             	mov    0x14(%ebp),%esi
  800b3f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800b42:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b45:	eb 24                	jmp    800b6b <vprintfmt+0x377>
	else if (lflag)
  800b47:	85 c9                	test   %ecx,%ecx
  800b49:	74 11                	je     800b5c <vprintfmt+0x368>
		return va_arg(*ap, long);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	99                   	cltd   
  800b51:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800b54:	8d 71 04             	lea    0x4(%ecx),%esi
  800b57:	89 75 14             	mov    %esi,0x14(%ebp)
  800b5a:	eb 0f                	jmp    800b6b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  800b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	99                   	cltd   
  800b62:	8b 75 14             	mov    0x14(%ebp),%esi
  800b65:	8d 76 04             	lea    0x4(%esi),%esi
  800b68:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  800b6b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800b70:	e9 80 00 00 00       	jmp    800bf5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b75:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b7f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b86:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b90:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b97:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b9a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b9e:	8b 06                	mov    (%esi),%eax
  800ba0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800ba5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800baa:	eb 49                	jmp    800bf5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800bac:	83 f9 01             	cmp    $0x1,%ecx
  800baf:	7e 13                	jle    800bc4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb4:	8b 50 04             	mov    0x4(%eax),%edx
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8b 75 14             	mov    0x14(%ebp),%esi
  800bbc:	8d 4e 08             	lea    0x8(%esi),%ecx
  800bbf:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800bc2:	eb 2c                	jmp    800bf0 <vprintfmt+0x3fc>
	else if (lflag)
  800bc4:	85 c9                	test   %ecx,%ecx
  800bc6:	74 15                	je     800bdd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcb:	8b 00                	mov    (%eax),%eax
  800bcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800bd5:	8d 71 04             	lea    0x4(%ecx),%esi
  800bd8:	89 75 14             	mov    %esi,0x14(%ebp)
  800bdb:	eb 13                	jmp    800bf0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  800bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800be0:	8b 00                	mov    (%eax),%eax
  800be2:	ba 00 00 00 00       	mov    $0x0,%edx
  800be7:	8b 75 14             	mov    0x14(%ebp),%esi
  800bea:	8d 76 04             	lea    0x4(%esi),%esi
  800bed:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800bf0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800bf9:	89 74 24 10          	mov    %esi,0x10(%esp)
  800bfd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800c00:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c04:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c08:	89 04 24             	mov    %eax,(%esp)
  800c0b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	e8 a6 fa ff ff       	call   8006c0 <printnum>
			break;
  800c1a:	e9 fa fb ff ff       	jmp    800819 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c26:	89 04 24             	mov    %eax,(%esp)
  800c29:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c2c:	e9 e8 fb ff ff       	jmp    800819 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c38:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c3f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c42:	89 fb                	mov    %edi,%ebx
  800c44:	eb 03                	jmp    800c49 <vprintfmt+0x455>
  800c46:	83 eb 01             	sub    $0x1,%ebx
  800c49:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c4d:	75 f7                	jne    800c46 <vprintfmt+0x452>
  800c4f:	90                   	nop
  800c50:	e9 c4 fb ff ff       	jmp    800819 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800c55:	83 c4 3c             	add    $0x3c,%esp
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5f                   	pop    %edi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    

00800c5d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	83 ec 28             	sub    $0x28,%esp
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c6c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c70:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c7a:	85 c0                	test   %eax,%eax
  800c7c:	74 30                	je     800cae <vsnprintf+0x51>
  800c7e:	85 d2                	test   %edx,%edx
  800c80:	7e 2c                	jle    800cae <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c82:	8b 45 14             	mov    0x14(%ebp),%eax
  800c85:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c89:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c90:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c97:	c7 04 24 af 07 80 00 	movl   $0x8007af,(%esp)
  800c9e:	e8 51 fb ff ff       	call   8007f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cac:	eb 05                	jmp    800cb3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800cae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cbb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cbe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 04 24             	mov    %eax,(%esp)
  800cd6:	e8 82 ff ff ff       	call   800c5d <vsnprintf>
	va_end(ap);

	return rc;
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    
  800cdd:	66 90                	xchg   %ax,%ax
  800cdf:	90                   	nop

00800ce0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ceb:	eb 03                	jmp    800cf0 <strlen+0x10>
		n++;
  800ced:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cf4:	75 f7                	jne    800ced <strlen+0xd>
		n++;
	return n;
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	eb 03                	jmp    800d0b <strnlen+0x13>
		n++;
  800d08:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0b:	39 d0                	cmp    %edx,%eax
  800d0d:	74 06                	je     800d15 <strnlen+0x1d>
  800d0f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d13:	75 f3                	jne    800d08 <strnlen+0x10>
		n++;
	return n;
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	53                   	push   %ebx
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d21:	89 c2                	mov    %eax,%edx
  800d23:	83 c2 01             	add    $0x1,%edx
  800d26:	83 c1 01             	add    $0x1,%ecx
  800d29:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d2d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d30:	84 db                	test   %bl,%bl
  800d32:	75 ef                	jne    800d23 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d34:	5b                   	pop    %ebx
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d41:	89 1c 24             	mov    %ebx,(%esp)
  800d44:	e8 97 ff ff ff       	call   800ce0 <strlen>
	strcpy(dst + len, src);
  800d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d50:	01 d8                	add    %ebx,%eax
  800d52:	89 04 24             	mov    %eax,(%esp)
  800d55:	e8 bd ff ff ff       	call   800d17 <strcpy>
	return dst;
}
  800d5a:	89 d8                	mov    %ebx,%eax
  800d5c:	83 c4 08             	add    $0x8,%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	8b 75 08             	mov    0x8(%ebp),%esi
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	89 f3                	mov    %esi,%ebx
  800d6f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d72:	89 f2                	mov    %esi,%edx
  800d74:	eb 0f                	jmp    800d85 <strncpy+0x23>
		*dst++ = *src;
  800d76:	83 c2 01             	add    $0x1,%edx
  800d79:	0f b6 01             	movzbl (%ecx),%eax
  800d7c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d7f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d82:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d85:	39 da                	cmp    %ebx,%edx
  800d87:	75 ed                	jne    800d76 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d89:	89 f0                	mov    %esi,%eax
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	8b 75 08             	mov    0x8(%ebp),%esi
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d9d:	89 f0                	mov    %esi,%eax
  800d9f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800da3:	85 c9                	test   %ecx,%ecx
  800da5:	75 0b                	jne    800db2 <strlcpy+0x23>
  800da7:	eb 1d                	jmp    800dc6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800da9:	83 c0 01             	add    $0x1,%eax
  800dac:	83 c2 01             	add    $0x1,%edx
  800daf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800db2:	39 d8                	cmp    %ebx,%eax
  800db4:	74 0b                	je     800dc1 <strlcpy+0x32>
  800db6:	0f b6 0a             	movzbl (%edx),%ecx
  800db9:	84 c9                	test   %cl,%cl
  800dbb:	75 ec                	jne    800da9 <strlcpy+0x1a>
  800dbd:	89 c2                	mov    %eax,%edx
  800dbf:	eb 02                	jmp    800dc3 <strlcpy+0x34>
  800dc1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800dc3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800dc6:	29 f0                	sub    %esi,%eax
}
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0x11>
		p++, q++;
  800dd7:	83 c1 01             	add    $0x1,%ecx
  800dda:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	0f b6 01             	movzbl (%ecx),%eax
  800de0:	84 c0                	test   %al,%al
  800de2:	74 04                	je     800de8 <strcmp+0x1c>
  800de4:	3a 02                	cmp    (%edx),%al
  800de6:	74 ef                	je     800dd7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de8:	0f b6 c0             	movzbl %al,%eax
  800deb:	0f b6 12             	movzbl (%edx),%edx
  800dee:	29 d0                	sub    %edx,%eax
}
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	53                   	push   %ebx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfc:	89 c3                	mov    %eax,%ebx
  800dfe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e01:	eb 06                	jmp    800e09 <strncmp+0x17>
		n--, p++, q++;
  800e03:	83 c0 01             	add    $0x1,%eax
  800e06:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e09:	39 d8                	cmp    %ebx,%eax
  800e0b:	74 15                	je     800e22 <strncmp+0x30>
  800e0d:	0f b6 08             	movzbl (%eax),%ecx
  800e10:	84 c9                	test   %cl,%cl
  800e12:	74 04                	je     800e18 <strncmp+0x26>
  800e14:	3a 0a                	cmp    (%edx),%cl
  800e16:	74 eb                	je     800e03 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e18:	0f b6 00             	movzbl (%eax),%eax
  800e1b:	0f b6 12             	movzbl (%edx),%edx
  800e1e:	29 d0                	sub    %edx,%eax
  800e20:	eb 05                	jmp    800e27 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e22:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e27:	5b                   	pop    %ebx
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e34:	eb 07                	jmp    800e3d <strchr+0x13>
		if (*s == c)
  800e36:	38 ca                	cmp    %cl,%dl
  800e38:	74 0f                	je     800e49 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3a:	83 c0 01             	add    $0x1,%eax
  800e3d:	0f b6 10             	movzbl (%eax),%edx
  800e40:	84 d2                	test   %dl,%dl
  800e42:	75 f2                	jne    800e36 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e55:	eb 07                	jmp    800e5e <strfind+0x13>
		if (*s == c)
  800e57:	38 ca                	cmp    %cl,%dl
  800e59:	74 0a                	je     800e65 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e5b:	83 c0 01             	add    $0x1,%eax
  800e5e:	0f b6 10             	movzbl (%eax),%edx
  800e61:	84 d2                	test   %dl,%dl
  800e63:	75 f2                	jne    800e57 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e73:	85 c9                	test   %ecx,%ecx
  800e75:	74 36                	je     800ead <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e77:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e7d:	75 28                	jne    800ea7 <memset+0x40>
  800e7f:	f6 c1 03             	test   $0x3,%cl
  800e82:	75 23                	jne    800ea7 <memset+0x40>
		c &= 0xFF;
  800e84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e88:	89 d3                	mov    %edx,%ebx
  800e8a:	c1 e3 08             	shl    $0x8,%ebx
  800e8d:	89 d6                	mov    %edx,%esi
  800e8f:	c1 e6 18             	shl    $0x18,%esi
  800e92:	89 d0                	mov    %edx,%eax
  800e94:	c1 e0 10             	shl    $0x10,%eax
  800e97:	09 f0                	or     %esi,%eax
  800e99:	09 c2                	or     %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e9f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ea2:	fc                   	cld    
  800ea3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ea5:	eb 06                	jmp    800ead <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	fc                   	cld    
  800eab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ead:	89 f8                	mov    %edi,%eax
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ebf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ec2:	39 c6                	cmp    %eax,%esi
  800ec4:	73 35                	jae    800efb <memmove+0x47>
  800ec6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ec9:	39 d0                	cmp    %edx,%eax
  800ecb:	73 2e                	jae    800efb <memmove+0x47>
		s += n;
		d += n;
  800ecd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ed0:	89 d6                	mov    %edx,%esi
  800ed2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ed4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eda:	75 13                	jne    800eef <memmove+0x3b>
  800edc:	f6 c1 03             	test   $0x3,%cl
  800edf:	75 0e                	jne    800eef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ee1:	83 ef 04             	sub    $0x4,%edi
  800ee4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ee7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800eea:	fd                   	std    
  800eeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800eed:	eb 09                	jmp    800ef8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800eef:	83 ef 01             	sub    $0x1,%edi
  800ef2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ef5:	fd                   	std    
  800ef6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ef8:	fc                   	cld    
  800ef9:	eb 1d                	jmp    800f18 <memmove+0x64>
  800efb:	89 f2                	mov    %esi,%edx
  800efd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eff:	f6 c2 03             	test   $0x3,%dl
  800f02:	75 0f                	jne    800f13 <memmove+0x5f>
  800f04:	f6 c1 03             	test   $0x3,%cl
  800f07:	75 0a                	jne    800f13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f09:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800f0c:	89 c7                	mov    %eax,%edi
  800f0e:	fc                   	cld    
  800f0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f11:	eb 05                	jmp    800f18 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f13:	89 c7                	mov    %eax,%edi
  800f15:	fc                   	cld    
  800f16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	89 04 24             	mov    %eax,(%esp)
  800f36:	e8 79 ff ff ff       	call   800eb4 <memmove>
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	89 d6                	mov    %edx,%esi
  800f4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f4d:	eb 1a                	jmp    800f69 <memcmp+0x2c>
		if (*s1 != *s2)
  800f4f:	0f b6 02             	movzbl (%edx),%eax
  800f52:	0f b6 19             	movzbl (%ecx),%ebx
  800f55:	38 d8                	cmp    %bl,%al
  800f57:	74 0a                	je     800f63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f59:	0f b6 c0             	movzbl %al,%eax
  800f5c:	0f b6 db             	movzbl %bl,%ebx
  800f5f:	29 d8                	sub    %ebx,%eax
  800f61:	eb 0f                	jmp    800f72 <memcmp+0x35>
		s1++, s2++;
  800f63:	83 c2 01             	add    $0x1,%edx
  800f66:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f69:	39 f2                	cmp    %esi,%edx
  800f6b:	75 e2                	jne    800f4f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f7f:	89 c2                	mov    %eax,%edx
  800f81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f84:	eb 07                	jmp    800f8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	38 08                	cmp    %cl,(%eax)
  800f88:	74 07                	je     800f91 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f8a:	83 c0 01             	add    $0x1,%eax
  800f8d:	39 d0                	cmp    %edx,%eax
  800f8f:	72 f5                	jb     800f86 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9f:	eb 03                	jmp    800fa4 <strtol+0x11>
		s++;
  800fa1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa4:	0f b6 0a             	movzbl (%edx),%ecx
  800fa7:	80 f9 09             	cmp    $0x9,%cl
  800faa:	74 f5                	je     800fa1 <strtol+0xe>
  800fac:	80 f9 20             	cmp    $0x20,%cl
  800faf:	74 f0                	je     800fa1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fb1:	80 f9 2b             	cmp    $0x2b,%cl
  800fb4:	75 0a                	jne    800fc0 <strtol+0x2d>
		s++;
  800fb6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbe:	eb 11                	jmp    800fd1 <strtol+0x3e>
  800fc0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800fc5:	80 f9 2d             	cmp    $0x2d,%cl
  800fc8:	75 07                	jne    800fd1 <strtol+0x3e>
		s++, neg = 1;
  800fca:	8d 52 01             	lea    0x1(%edx),%edx
  800fcd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800fd6:	75 15                	jne    800fed <strtol+0x5a>
  800fd8:	80 3a 30             	cmpb   $0x30,(%edx)
  800fdb:	75 10                	jne    800fed <strtol+0x5a>
  800fdd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800fe1:	75 0a                	jne    800fed <strtol+0x5a>
		s += 2, base = 16;
  800fe3:	83 c2 02             	add    $0x2,%edx
  800fe6:	b8 10 00 00 00       	mov    $0x10,%eax
  800feb:	eb 10                	jmp    800ffd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 0c                	jne    800ffd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ff1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ff3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ff6:	75 05                	jne    800ffd <strtol+0x6a>
		s++, base = 8;
  800ff8:	83 c2 01             	add    $0x1,%edx
  800ffb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ffd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801002:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801005:	0f b6 0a             	movzbl (%edx),%ecx
  801008:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	3c 09                	cmp    $0x9,%al
  80100f:	77 08                	ja     801019 <strtol+0x86>
			dig = *s - '0';
  801011:	0f be c9             	movsbl %cl,%ecx
  801014:	83 e9 30             	sub    $0x30,%ecx
  801017:	eb 20                	jmp    801039 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801019:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80101c:	89 f0                	mov    %esi,%eax
  80101e:	3c 19                	cmp    $0x19,%al
  801020:	77 08                	ja     80102a <strtol+0x97>
			dig = *s - 'a' + 10;
  801022:	0f be c9             	movsbl %cl,%ecx
  801025:	83 e9 57             	sub    $0x57,%ecx
  801028:	eb 0f                	jmp    801039 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80102a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80102d:	89 f0                	mov    %esi,%eax
  80102f:	3c 19                	cmp    $0x19,%al
  801031:	77 16                	ja     801049 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801033:	0f be c9             	movsbl %cl,%ecx
  801036:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801039:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80103c:	7d 0f                	jge    80104d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80103e:	83 c2 01             	add    $0x1,%edx
  801041:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801045:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801047:	eb bc                	jmp    801005 <strtol+0x72>
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	eb 02                	jmp    80104f <strtol+0xbc>
  80104d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80104f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801053:	74 05                	je     80105a <strtol+0xc7>
		*endptr = (char *) s;
  801055:	8b 75 0c             	mov    0xc(%ebp),%esi
  801058:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80105a:	f7 d8                	neg    %eax
  80105c:	85 ff                	test   %edi,%edi
  80105e:	0f 44 c3             	cmove  %ebx,%eax
}
  801061:	5b                   	pop    %ebx
  801062:	5e                   	pop    %esi
  801063:	5f                   	pop    %edi
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    

00801066 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	57                   	push   %edi
  80106a:	56                   	push   %esi
  80106b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	8b 55 08             	mov    0x8(%ebp),%edx
  801077:	89 c3                	mov    %eax,%ebx
  801079:	89 c7                	mov    %eax,%edi
  80107b:	89 c6                	mov    %eax,%esi
  80107d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5f                   	pop    %edi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <sys_cgetc>:

int
sys_cgetc(void)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108a:	ba 00 00 00 00       	mov    $0x0,%edx
  80108f:	b8 01 00 00 00       	mov    $0x1,%eax
  801094:	89 d1                	mov    %edx,%ecx
  801096:	89 d3                	mov    %edx,%ebx
  801098:	89 d7                	mov    %edx,%edi
  80109a:	89 d6                	mov    %edx,%esi
  80109c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
  8010a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	89 cb                	mov    %ecx,%ebx
  8010bb:	89 cf                	mov    %ecx,%edi
  8010bd:	89 ce                	mov    %ecx,%esi
  8010bf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	7e 28                	jle    8010ed <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010d0:	00 
  8010d1:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  8010d8:	00 
  8010d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e0:	00 
  8010e1:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  8010e8:	e8 ba f4 ff ff       	call   8005a7 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010ed:	83 c4 2c             	add    $0x2c,%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
  8010fb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801103:	b8 04 00 00 00       	mov    $0x4,%eax
  801108:	8b 55 08             	mov    0x8(%ebp),%edx
  80110b:	89 cb                	mov    %ecx,%ebx
  80110d:	89 cf                	mov    %ecx,%edi
  80110f:	89 ce                	mov    %ecx,%esi
  801111:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801113:	85 c0                	test   %eax,%eax
  801115:	7e 28                	jle    80113f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801117:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801122:	00 
  801123:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  80112a:	00 
  80112b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801132:	00 
  801133:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  80113a:	e8 68 f4 ff ff       	call   8005a7 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  80113f:	83 c4 2c             	add    $0x2c,%esp
  801142:	5b                   	pop    %ebx
  801143:	5e                   	pop    %esi
  801144:	5f                   	pop    %edi
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	57                   	push   %edi
  80114b:	56                   	push   %esi
  80114c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114d:	ba 00 00 00 00       	mov    $0x0,%edx
  801152:	b8 02 00 00 00       	mov    $0x2,%eax
  801157:	89 d1                	mov    %edx,%ecx
  801159:	89 d3                	mov    %edx,%ebx
  80115b:	89 d7                	mov    %edx,%edi
  80115d:	89 d6                	mov    %edx,%esi
  80115f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <sys_yield>:

void
sys_yield(void)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116c:	ba 00 00 00 00       	mov    $0x0,%edx
  801171:	b8 0c 00 00 00       	mov    $0xc,%eax
  801176:	89 d1                	mov    %edx,%ecx
  801178:	89 d3                	mov    %edx,%ebx
  80117a:	89 d7                	mov    %edx,%edi
  80117c:	89 d6                	mov    %edx,%esi
  80117e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801180:	5b                   	pop    %ebx
  801181:	5e                   	pop    %esi
  801182:	5f                   	pop    %edi
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    

00801185 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	57                   	push   %edi
  801189:	56                   	push   %esi
  80118a:	53                   	push   %ebx
  80118b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80118e:	be 00 00 00 00       	mov    $0x0,%esi
  801193:	b8 05 00 00 00       	mov    $0x5,%eax
  801198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119b:	8b 55 08             	mov    0x8(%ebp),%edx
  80119e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011a1:	89 f7                	mov    %esi,%edi
  8011a3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	7e 28                	jle    8011d1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ad:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011b4:	00 
  8011b5:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  8011bc:	00 
  8011bd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c4:	00 
  8011c5:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  8011cc:	e8 d6 f3 ff ff       	call   8005a7 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011d1:	83 c4 2c             	add    $0x2c,%esp
  8011d4:	5b                   	pop    %ebx
  8011d5:	5e                   	pop    %esi
  8011d6:	5f                   	pop    %edi
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    

008011d9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	57                   	push   %edi
  8011dd:	56                   	push   %esi
  8011de:	53                   	push   %ebx
  8011df:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e2:	b8 06 00 00 00       	mov    $0x6,%eax
  8011e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011f3:	8b 75 18             	mov    0x18(%ebp),%esi
  8011f6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	7e 28                	jle    801224 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801200:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801207:	00 
  801208:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  80120f:	00 
  801210:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801217:	00 
  801218:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  80121f:	e8 83 f3 ff ff       	call   8005a7 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801224:	83 c4 2c             	add    $0x2c,%esp
  801227:	5b                   	pop    %ebx
  801228:	5e                   	pop    %esi
  801229:	5f                   	pop    %edi
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
  801232:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123a:	b8 07 00 00 00       	mov    $0x7,%eax
  80123f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801242:	8b 55 08             	mov    0x8(%ebp),%edx
  801245:	89 df                	mov    %ebx,%edi
  801247:	89 de                	mov    %ebx,%esi
  801249:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80124b:	85 c0                	test   %eax,%eax
  80124d:	7e 28                	jle    801277 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801253:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80125a:	00 
  80125b:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  801262:	00 
  801263:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126a:	00 
  80126b:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  801272:	e8 30 f3 ff ff       	call   8005a7 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801277:	83 c4 2c             	add    $0x2c,%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5f                   	pop    %edi
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    

0080127f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	57                   	push   %edi
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801285:	b9 00 00 00 00       	mov    $0x0,%ecx
  80128a:	b8 10 00 00 00       	mov    $0x10,%eax
  80128f:	8b 55 08             	mov    0x8(%ebp),%edx
  801292:	89 cb                	mov    %ecx,%ebx
  801294:	89 cf                	mov    %ecx,%edi
  801296:	89 ce                	mov    %ecx,%esi
  801298:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80129a:	5b                   	pop    %ebx
  80129b:	5e                   	pop    %esi
  80129c:	5f                   	pop    %edi
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    

0080129f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	57                   	push   %edi
  8012a3:	56                   	push   %esi
  8012a4:	53                   	push   %ebx
  8012a5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ad:	b8 09 00 00 00       	mov    $0x9,%eax
  8012b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b8:	89 df                	mov    %ebx,%edi
  8012ba:	89 de                	mov    %ebx,%esi
  8012bc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	7e 28                	jle    8012ea <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8012cd:	00 
  8012ce:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  8012d5:	00 
  8012d6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012dd:	00 
  8012de:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  8012e5:	e8 bd f2 ff ff       	call   8005a7 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012ea:	83 c4 2c             	add    $0x2c,%esp
  8012ed:	5b                   	pop    %ebx
  8012ee:	5e                   	pop    %esi
  8012ef:	5f                   	pop    %edi
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    

008012f2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	57                   	push   %edi
  8012f6:	56                   	push   %esi
  8012f7:	53                   	push   %ebx
  8012f8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801300:	b8 0a 00 00 00       	mov    $0xa,%eax
  801305:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
  80130b:	89 df                	mov    %ebx,%edi
  80130d:	89 de                	mov    %ebx,%esi
  80130f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801311:	85 c0                	test   %eax,%eax
  801313:	7e 28                	jle    80133d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801315:	89 44 24 10          	mov    %eax,0x10(%esp)
  801319:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801320:	00 
  801321:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  801328:	00 
  801329:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801330:	00 
  801331:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  801338:	e8 6a f2 ff ff       	call   8005a7 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80133d:	83 c4 2c             	add    $0x2c,%esp
  801340:	5b                   	pop    %ebx
  801341:	5e                   	pop    %esi
  801342:	5f                   	pop    %edi
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    

00801345 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	57                   	push   %edi
  801349:	56                   	push   %esi
  80134a:	53                   	push   %ebx
  80134b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80134e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801353:	b8 0b 00 00 00       	mov    $0xb,%eax
  801358:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135b:	8b 55 08             	mov    0x8(%ebp),%edx
  80135e:	89 df                	mov    %ebx,%edi
  801360:	89 de                	mov    %ebx,%esi
  801362:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801364:	85 c0                	test   %eax,%eax
  801366:	7e 28                	jle    801390 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801368:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801373:	00 
  801374:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  80137b:	00 
  80137c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801383:	00 
  801384:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  80138b:	e8 17 f2 ff ff       	call   8005a7 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801390:	83 c4 2c             	add    $0x2c,%esp
  801393:	5b                   	pop    %ebx
  801394:	5e                   	pop    %esi
  801395:	5f                   	pop    %edi
  801396:	5d                   	pop    %ebp
  801397:	c3                   	ret    

00801398 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	57                   	push   %edi
  80139c:	56                   	push   %esi
  80139d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80139e:	be 00 00 00 00       	mov    $0x0,%esi
  8013a3:	b8 0d 00 00 00       	mov    $0xd,%eax
  8013a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013b1:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013b4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8013b6:	5b                   	pop    %ebx
  8013b7:	5e                   	pop    %esi
  8013b8:	5f                   	pop    %edi
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	57                   	push   %edi
  8013bf:	56                   	push   %esi
  8013c0:	53                   	push   %ebx
  8013c1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013c9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d1:	89 cb                	mov    %ecx,%ebx
  8013d3:	89 cf                	mov    %ecx,%edi
  8013d5:	89 ce                	mov    %ecx,%esi
  8013d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	7e 28                	jle    801405 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8013e8:	00 
  8013e9:	c7 44 24 08 17 3c 80 	movl   $0x803c17,0x8(%esp)
  8013f0:	00 
  8013f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013f8:	00 
  8013f9:	c7 04 24 34 3c 80 00 	movl   $0x803c34,(%esp)
  801400:	e8 a2 f1 ff ff       	call   8005a7 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801405:	83 c4 2c             	add    $0x2c,%esp
  801408:	5b                   	pop    %ebx
  801409:	5e                   	pop    %esi
  80140a:	5f                   	pop    %edi
  80140b:	5d                   	pop    %ebp
  80140c:	c3                   	ret    

0080140d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	57                   	push   %edi
  801411:	56                   	push   %esi
  801412:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801413:	ba 00 00 00 00       	mov    $0x0,%edx
  801418:	b8 0f 00 00 00       	mov    $0xf,%eax
  80141d:	89 d1                	mov    %edx,%ecx
  80141f:	89 d3                	mov    %edx,%ebx
  801421:	89 d7                	mov    %edx,%edi
  801423:	89 d6                	mov    %edx,%esi
  801425:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801427:	5b                   	pop    %ebx
  801428:	5e                   	pop    %esi
  801429:	5f                   	pop    %edi
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	57                   	push   %edi
  801430:	56                   	push   %esi
  801431:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801432:	bb 00 00 00 00       	mov    $0x0,%ebx
  801437:	b8 11 00 00 00       	mov    $0x11,%eax
  80143c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143f:	8b 55 08             	mov    0x8(%ebp),%edx
  801442:	89 df                	mov    %ebx,%edi
  801444:	89 de                	mov    %ebx,%esi
  801446:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801448:	5b                   	pop    %ebx
  801449:	5e                   	pop    %esi
  80144a:	5f                   	pop    %edi
  80144b:	5d                   	pop    %ebp
  80144c:	c3                   	ret    

0080144d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	57                   	push   %edi
  801451:	56                   	push   %esi
  801452:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801453:	bb 00 00 00 00       	mov    $0x0,%ebx
  801458:	b8 12 00 00 00       	mov    $0x12,%eax
  80145d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801460:	8b 55 08             	mov    0x8(%ebp),%edx
  801463:	89 df                	mov    %ebx,%edi
  801465:	89 de                	mov    %ebx,%esi
  801467:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801469:	5b                   	pop    %ebx
  80146a:	5e                   	pop    %esi
  80146b:	5f                   	pop    %edi
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	57                   	push   %edi
  801472:	56                   	push   %esi
  801473:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801474:	b9 00 00 00 00       	mov    $0x0,%ecx
  801479:	b8 13 00 00 00       	mov    $0x13,%eax
  80147e:	8b 55 08             	mov    0x8(%ebp),%edx
  801481:	89 cb                	mov    %ecx,%ebx
  801483:	89 cf                	mov    %ecx,%edi
  801485:	89 ce                	mov    %ecx,%esi
  801487:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801489:	5b                   	pop    %ebx
  80148a:	5e                   	pop    %esi
  80148b:	5f                   	pop    %edi
  80148c:	5d                   	pop    %ebp
  80148d:	c3                   	ret    

0080148e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	57                   	push   %edi
  801492:	56                   	push   %esi
  801493:	53                   	push   %ebx
  801494:	83 ec 2c             	sub    $0x2c,%esp
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80149a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80149c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80149f:	89 f8                	mov    %edi,%eax
  8014a1:	c1 e8 0c             	shr    $0xc,%eax
  8014a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  8014a7:	e8 9b fc ff ff       	call   801147 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  8014ac:	f7 c6 02 00 00 00    	test   $0x2,%esi
  8014b2:	0f 84 de 00 00 00    	je     801596 <pgfault+0x108>
  8014b8:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	79 20                	jns    8014de <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  8014be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014c2:	c7 44 24 08 42 3c 80 	movl   $0x803c42,0x8(%esp)
  8014c9:	00 
  8014ca:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8014d1:	00 
  8014d2:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  8014d9:	e8 c9 f0 ff ff       	call   8005a7 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  8014de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  8014e8:	25 05 08 00 00       	and    $0x805,%eax
  8014ed:	3d 05 08 00 00       	cmp    $0x805,%eax
  8014f2:	0f 85 ba 00 00 00    	jne    8015b2 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8014f8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014ff:	00 
  801500:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801507:	00 
  801508:	89 1c 24             	mov    %ebx,(%esp)
  80150b:	e8 75 fc ff ff       	call   801185 <sys_page_alloc>
  801510:	85 c0                	test   %eax,%eax
  801512:	79 20                	jns    801534 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801514:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801518:	c7 44 24 08 69 3c 80 	movl   $0x803c69,0x8(%esp)
  80151f:	00 
  801520:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801527:	00 
  801528:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  80152f:	e8 73 f0 ff ff       	call   8005a7 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801534:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80153a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801541:	00 
  801542:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801546:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80154d:	e8 62 f9 ff ff       	call   800eb4 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801552:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801559:	00 
  80155a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80155e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801562:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801569:	00 
  80156a:	89 1c 24             	mov    %ebx,(%esp)
  80156d:	e8 67 fc ff ff       	call   8011d9 <sys_page_map>
  801572:	85 c0                	test   %eax,%eax
  801574:	79 3c                	jns    8015b2 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801576:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80157a:	c7 44 24 08 7c 3c 80 	movl   $0x803c7c,0x8(%esp)
  801581:	00 
  801582:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801589:	00 
  80158a:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  801591:	e8 11 f0 ff ff       	call   8005a7 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801596:	c7 44 24 08 a0 3c 80 	movl   $0x803ca0,0x8(%esp)
  80159d:	00 
  80159e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8015a5:	00 
  8015a6:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  8015ad:	e8 f5 ef ff ff       	call   8005a7 <_panic>
}
  8015b2:	83 c4 2c             	add    $0x2c,%esp
  8015b5:	5b                   	pop    %ebx
  8015b6:	5e                   	pop    %esi
  8015b7:	5f                   	pop    %edi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	56                   	push   %esi
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 20             	sub    $0x20,%esp
  8015c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8015c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8015c8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015cf:	00 
  8015d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015d4:	89 34 24             	mov    %esi,(%esp)
  8015d7:	e8 a9 fb ff ff       	call   801185 <sys_page_alloc>
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	79 20                	jns    801600 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  8015e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015e4:	c7 44 24 08 69 3c 80 	movl   $0x803c69,0x8(%esp)
  8015eb:	00 
  8015ec:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8015f3:	00 
  8015f4:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  8015fb:	e8 a7 ef ff ff       	call   8005a7 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801600:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801607:	00 
  801608:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  80160f:	00 
  801610:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801617:	00 
  801618:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80161c:	89 34 24             	mov    %esi,(%esp)
  80161f:	e8 b5 fb ff ff       	call   8011d9 <sys_page_map>
  801624:	85 c0                	test   %eax,%eax
  801626:	79 20                	jns    801648 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801628:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80162c:	c7 44 24 08 7c 3c 80 	movl   $0x803c7c,0x8(%esp)
  801633:	00 
  801634:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80163b:	00 
  80163c:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  801643:	e8 5f ef ff ff       	call   8005a7 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801648:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80164f:	00 
  801650:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801654:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80165b:	e8 54 f8 ff ff       	call   800eb4 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801660:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801667:	00 
  801668:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80166f:	e8 b8 fb ff ff       	call   80122c <sys_page_unmap>
  801674:	85 c0                	test   %eax,%eax
  801676:	79 20                	jns    801698 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801678:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80167c:	c7 44 24 08 8d 3c 80 	movl   $0x803c8d,0x8(%esp)
  801683:	00 
  801684:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80168b:	00 
  80168c:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  801693:	e8 0f ef ff ff       	call   8005a7 <_panic>

}
  801698:	83 c4 20             	add    $0x20,%esp
  80169b:	5b                   	pop    %ebx
  80169c:	5e                   	pop    %esi
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	57                   	push   %edi
  8016a3:	56                   	push   %esi
  8016a4:	53                   	push   %ebx
  8016a5:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  8016a8:	c7 04 24 8e 14 80 00 	movl   $0x80148e,(%esp)
  8016af:	e8 26 1c 00 00       	call   8032da <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8016b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8016b9:	cd 30                	int    $0x30
  8016bb:	89 c6                	mov    %eax,%esi
  8016bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	79 20                	jns    8016e4 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  8016c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016c8:	c7 44 24 08 c4 3c 80 	movl   $0x803cc4,0x8(%esp)
  8016cf:	00 
  8016d0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  8016d7:	00 
  8016d8:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  8016df:	e8 c3 ee ff ff       	call   8005a7 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8016e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	75 21                	jne    80170e <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8016ed:	e8 55 fa ff ff       	call   801147 <sys_getenvid>
  8016f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8016fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016ff:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  801704:	b8 00 00 00 00       	mov    $0x0,%eax
  801709:	e9 88 01 00 00       	jmp    801896 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  80170e:	89 d8                	mov    %ebx,%eax
  801710:	c1 e8 16             	shr    $0x16,%eax
  801713:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80171a:	a8 01                	test   $0x1,%al
  80171c:	0f 84 e0 00 00 00    	je     801802 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801722:	89 df                	mov    %ebx,%edi
  801724:	c1 ef 0c             	shr    $0xc,%edi
  801727:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80172e:	a8 01                	test   $0x1,%al
  801730:	0f 84 c4 00 00 00    	je     8017fa <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801736:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80173d:	f6 c4 04             	test   $0x4,%ah
  801740:	74 0d                	je     80174f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801742:	25 07 0e 00 00       	and    $0xe07,%eax
  801747:	83 c8 05             	or     $0x5,%eax
  80174a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80174d:	eb 1b                	jmp    80176a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80174f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801754:	83 f8 01             	cmp    $0x1,%eax
  801757:	19 c0                	sbb    %eax,%eax
  801759:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80175c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801763:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80176a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80176d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801770:	89 44 24 10          	mov    %eax,0x10(%esp)
  801774:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801778:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80177f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801783:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80178a:	e8 4a fa ff ff       	call   8011d9 <sys_page_map>
  80178f:	85 c0                	test   %eax,%eax
  801791:	79 20                	jns    8017b3 <fork+0x114>
		panic("sys_page_map: %e", r);
  801793:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801797:	c7 44 24 08 7c 3c 80 	movl   $0x803c7c,0x8(%esp)
  80179e:	00 
  80179f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  8017a6:	00 
  8017a7:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  8017ae:	e8 f4 ed ff ff       	call   8005a7 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  8017b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017ba:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017be:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017c5:	00 
  8017c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d1:	e8 03 fa ff ff       	call   8011d9 <sys_page_map>
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	79 20                	jns    8017fa <fork+0x15b>
		panic("sys_page_map: %e", r);
  8017da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017de:	c7 44 24 08 7c 3c 80 	movl   $0x803c7c,0x8(%esp)
  8017e5:	00 
  8017e6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  8017ed:	00 
  8017ee:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  8017f5:	e8 ad ed ff ff       	call   8005a7 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8017fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801800:	eb 06                	jmp    801808 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801802:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801808:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  80180e:	0f 86 fa fe ff ff    	jbe    80170e <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801814:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80181b:	00 
  80181c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801823:	ee 
  801824:	89 34 24             	mov    %esi,(%esp)
  801827:	e8 59 f9 ff ff       	call   801185 <sys_page_alloc>
  80182c:	85 c0                	test   %eax,%eax
  80182e:	79 20                	jns    801850 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801830:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801834:	c7 44 24 08 69 3c 80 	movl   $0x803c69,0x8(%esp)
  80183b:	00 
  80183c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801843:	00 
  801844:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  80184b:	e8 57 ed ff ff       	call   8005a7 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801850:	c7 44 24 04 6d 33 80 	movl   $0x80336d,0x4(%esp)
  801857:	00 
  801858:	89 34 24             	mov    %esi,(%esp)
  80185b:	e8 e5 fa ff ff       	call   801345 <sys_env_set_pgfault_upcall>
  801860:	85 c0                	test   %eax,%eax
  801862:	79 20                	jns    801884 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801864:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801868:	c7 44 24 08 e8 3c 80 	movl   $0x803ce8,0x8(%esp)
  80186f:	00 
  801870:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801877:	00 
  801878:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  80187f:	e8 23 ed ff ff       	call   8005a7 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801884:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80188b:	00 
  80188c:	89 34 24             	mov    %esi,(%esp)
  80188f:	e8 0b fa ff ff       	call   80129f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801894:	89 f0                	mov    %esi,%eax

}
  801896:	83 c4 2c             	add    $0x2c,%esp
  801899:	5b                   	pop    %ebx
  80189a:	5e                   	pop    %esi
  80189b:	5f                   	pop    %edi
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    

0080189e <sfork>:

// Challenge!
int
sfork(void)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	57                   	push   %edi
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  8018a7:	c7 04 24 8e 14 80 00 	movl   $0x80148e,(%esp)
  8018ae:	e8 27 1a 00 00       	call   8032da <set_pgfault_handler>
  8018b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8018b8:	cd 30                	int    $0x30
  8018ba:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	79 20                	jns    8018e0 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  8018c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018c4:	c7 44 24 08 c4 3c 80 	movl   $0x803cc4,0x8(%esp)
  8018cb:	00 
  8018cc:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  8018d3:	00 
  8018d4:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  8018db:	e8 c7 ec ff ff       	call   8005a7 <_panic>
  8018e0:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8018e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	75 2d                	jne    801918 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8018eb:	e8 57 f8 ff ff       	call   801147 <sys_getenvid>
  8018f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8018f5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8018f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8018fd:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  801902:	c7 04 24 8e 14 80 00 	movl   $0x80148e,(%esp)
  801909:	e8 cc 19 00 00       	call   8032da <set_pgfault_handler>
		return 0;
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax
  801913:	e9 1d 01 00 00       	jmp    801a35 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801918:	89 d8                	mov    %ebx,%eax
  80191a:	c1 e8 16             	shr    $0x16,%eax
  80191d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801924:	a8 01                	test   $0x1,%al
  801926:	74 69                	je     801991 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801928:	89 d8                	mov    %ebx,%eax
  80192a:	c1 e8 0c             	shr    $0xc,%eax
  80192d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801934:	f6 c2 01             	test   $0x1,%dl
  801937:	74 50                	je     801989 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801939:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801940:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801943:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801949:	89 54 24 10          	mov    %edx,0x10(%esp)
  80194d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801951:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801955:	89 44 24 04          	mov    %eax,0x4(%esp)
  801959:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801960:	e8 74 f8 ff ff       	call   8011d9 <sys_page_map>
  801965:	85 c0                	test   %eax,%eax
  801967:	79 20                	jns    801989 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801969:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80196d:	c7 44 24 08 7c 3c 80 	movl   $0x803c7c,0x8(%esp)
  801974:	00 
  801975:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80197c:	00 
  80197d:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  801984:	e8 1e ec ff ff       	call   8005a7 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801989:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80198f:	eb 06                	jmp    801997 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801991:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801997:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80199d:	0f 86 75 ff ff ff    	jbe    801918 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  8019a3:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  8019aa:	ee 
  8019ab:	89 34 24             	mov    %esi,(%esp)
  8019ae:	e8 07 fc ff ff       	call   8015ba <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8019b3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8019ba:	00 
  8019bb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8019c2:	ee 
  8019c3:	89 34 24             	mov    %esi,(%esp)
  8019c6:	e8 ba f7 ff ff       	call   801185 <sys_page_alloc>
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	79 20                	jns    8019ef <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  8019cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019d3:	c7 44 24 08 69 3c 80 	movl   $0x803c69,0x8(%esp)
  8019da:	00 
  8019db:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  8019e2:	00 
  8019e3:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  8019ea:	e8 b8 eb ff ff       	call   8005a7 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8019ef:	c7 44 24 04 6d 33 80 	movl   $0x80336d,0x4(%esp)
  8019f6:	00 
  8019f7:	89 34 24             	mov    %esi,(%esp)
  8019fa:	e8 46 f9 ff ff       	call   801345 <sys_env_set_pgfault_upcall>
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	79 20                	jns    801a23 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801a03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a07:	c7 44 24 08 e8 3c 80 	movl   $0x803ce8,0x8(%esp)
  801a0e:	00 
  801a0f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801a16:	00 
  801a17:	c7 04 24 5e 3c 80 00 	movl   $0x803c5e,(%esp)
  801a1e:	e8 84 eb ff ff       	call   8005a7 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801a23:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801a2a:	00 
  801a2b:	89 34 24             	mov    %esi,(%esp)
  801a2e:	e8 6c f8 ff ff       	call   80129f <sys_env_set_status>
	return envid;
  801a33:	89 f0                	mov    %esi,%eax

}
  801a35:	83 c4 2c             	add    $0x2c,%esp
  801a38:	5b                   	pop    %ebx
  801a39:	5e                   	pop    %esi
  801a3a:	5f                   	pop    %edi
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    
  801a3d:	66 90                	xchg   %ax,%ax
  801a3f:	90                   	nop

00801a40 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	05 00 00 00 30       	add    $0x30000000,%eax
  801a4b:	c1 e8 0c             	shr    $0xc,%eax
}
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    

00801a50 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801a5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a60:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801a65:	5d                   	pop    %ebp
  801a66:	c3                   	ret    

00801a67 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801a72:	89 c2                	mov    %eax,%edx
  801a74:	c1 ea 16             	shr    $0x16,%edx
  801a77:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801a7e:	f6 c2 01             	test   $0x1,%dl
  801a81:	74 11                	je     801a94 <fd_alloc+0x2d>
  801a83:	89 c2                	mov    %eax,%edx
  801a85:	c1 ea 0c             	shr    $0xc,%edx
  801a88:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a8f:	f6 c2 01             	test   $0x1,%dl
  801a92:	75 09                	jne    801a9d <fd_alloc+0x36>
			*fd_store = fd;
  801a94:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a96:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9b:	eb 17                	jmp    801ab4 <fd_alloc+0x4d>
  801a9d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801aa2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801aa7:	75 c9                	jne    801a72 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801aa9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801aaf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    

00801ab6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801abc:	83 f8 1f             	cmp    $0x1f,%eax
  801abf:	77 36                	ja     801af7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801ac1:	c1 e0 0c             	shl    $0xc,%eax
  801ac4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ac9:	89 c2                	mov    %eax,%edx
  801acb:	c1 ea 16             	shr    $0x16,%edx
  801ace:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801ad5:	f6 c2 01             	test   $0x1,%dl
  801ad8:	74 24                	je     801afe <fd_lookup+0x48>
  801ada:	89 c2                	mov    %eax,%edx
  801adc:	c1 ea 0c             	shr    $0xc,%edx
  801adf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ae6:	f6 c2 01             	test   $0x1,%dl
  801ae9:	74 1a                	je     801b05 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aee:	89 02                	mov    %eax,(%edx)
	return 0;
  801af0:	b8 00 00 00 00       	mov    $0x0,%eax
  801af5:	eb 13                	jmp    801b0a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801af7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801afc:	eb 0c                	jmp    801b0a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801afe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b03:	eb 05                	jmp    801b0a <fd_lookup+0x54>
  801b05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    

00801b0c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 18             	sub    $0x18,%esp
  801b12:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801b15:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1a:	eb 13                	jmp    801b2f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  801b1c:	39 08                	cmp    %ecx,(%eax)
  801b1e:	75 0c                	jne    801b2c <dev_lookup+0x20>
			*dev = devtab[i];
  801b20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b23:	89 01                	mov    %eax,(%ecx)
			return 0;
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2a:	eb 38                	jmp    801b64 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801b2c:	83 c2 01             	add    $0x1,%edx
  801b2f:	8b 04 95 88 3d 80 00 	mov    0x803d88(,%edx,4),%eax
  801b36:	85 c0                	test   %eax,%eax
  801b38:	75 e2                	jne    801b1c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b3a:	a1 08 50 80 00       	mov    0x805008,%eax
  801b3f:	8b 40 48             	mov    0x48(%eax),%eax
  801b42:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4a:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
  801b51:	e8 4a eb ff ff       	call   8006a0 <cprintf>
	*dev = 0;
  801b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801b5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	56                   	push   %esi
  801b6a:	53                   	push   %ebx
  801b6b:	83 ec 20             	sub    $0x20,%esp
  801b6e:	8b 75 08             	mov    0x8(%ebp),%esi
  801b71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b77:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b7b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801b81:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b84:	89 04 24             	mov    %eax,(%esp)
  801b87:	e8 2a ff ff ff       	call   801ab6 <fd_lookup>
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 05                	js     801b95 <fd_close+0x2f>
	    || fd != fd2)
  801b90:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801b93:	74 0c                	je     801ba1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801b95:	84 db                	test   %bl,%bl
  801b97:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9c:	0f 44 c2             	cmove  %edx,%eax
  801b9f:	eb 3f                	jmp    801be0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ba1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba8:	8b 06                	mov    (%esi),%eax
  801baa:	89 04 24             	mov    %eax,(%esp)
  801bad:	e8 5a ff ff ff       	call   801b0c <dev_lookup>
  801bb2:	89 c3                	mov    %eax,%ebx
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 16                	js     801bce <fd_close+0x68>
		if (dev->dev_close)
  801bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801bbe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	74 07                	je     801bce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801bc7:	89 34 24             	mov    %esi,(%esp)
  801bca:	ff d0                	call   *%eax
  801bcc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801bce:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bd9:	e8 4e f6 ff ff       	call   80122c <sys_page_unmap>
	return r;
  801bde:	89 d8                	mov    %ebx,%eax
}
  801be0:	83 c4 20             	add    $0x20,%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5d                   	pop    %ebp
  801be6:	c3                   	ret    

00801be7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	89 04 24             	mov    %eax,(%esp)
  801bfa:	e8 b7 fe ff ff       	call   801ab6 <fd_lookup>
  801bff:	89 c2                	mov    %eax,%edx
  801c01:	85 d2                	test   %edx,%edx
  801c03:	78 13                	js     801c18 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801c05:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c0c:	00 
  801c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c10:	89 04 24             	mov    %eax,(%esp)
  801c13:	e8 4e ff ff ff       	call   801b66 <fd_close>
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <close_all>:

void
close_all(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801c21:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801c26:	89 1c 24             	mov    %ebx,(%esp)
  801c29:	e8 b9 ff ff ff       	call   801be7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801c2e:	83 c3 01             	add    $0x1,%ebx
  801c31:	83 fb 20             	cmp    $0x20,%ebx
  801c34:	75 f0                	jne    801c26 <close_all+0xc>
		close(i);
}
  801c36:	83 c4 14             	add    $0x14,%esp
  801c39:	5b                   	pop    %ebx
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    

00801c3c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	57                   	push   %edi
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801c45:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	89 04 24             	mov    %eax,(%esp)
  801c52:	e8 5f fe ff ff       	call   801ab6 <fd_lookup>
  801c57:	89 c2                	mov    %eax,%edx
  801c59:	85 d2                	test   %edx,%edx
  801c5b:	0f 88 e1 00 00 00    	js     801d42 <dup+0x106>
		return r;
	close(newfdnum);
  801c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	e8 7b ff ff ff       	call   801be7 <close>

	newfd = INDEX2FD(newfdnum);
  801c6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801c6f:	c1 e3 0c             	shl    $0xc,%ebx
  801c72:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c7b:	89 04 24             	mov    %eax,(%esp)
  801c7e:	e8 cd fd ff ff       	call   801a50 <fd2data>
  801c83:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801c85:	89 1c 24             	mov    %ebx,(%esp)
  801c88:	e8 c3 fd ff ff       	call   801a50 <fd2data>
  801c8d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801c8f:	89 f0                	mov    %esi,%eax
  801c91:	c1 e8 16             	shr    $0x16,%eax
  801c94:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c9b:	a8 01                	test   $0x1,%al
  801c9d:	74 43                	je     801ce2 <dup+0xa6>
  801c9f:	89 f0                	mov    %esi,%eax
  801ca1:	c1 e8 0c             	shr    $0xc,%eax
  801ca4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801cab:	f6 c2 01             	test   $0x1,%dl
  801cae:	74 32                	je     801ce2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801cb0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801cb7:	25 07 0e 00 00       	and    $0xe07,%eax
  801cbc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801cc0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cc4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ccb:	00 
  801ccc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cd7:	e8 fd f4 ff ff       	call   8011d9 <sys_page_map>
  801cdc:	89 c6                	mov    %eax,%esi
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 3e                	js     801d20 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ce5:	89 c2                	mov    %eax,%edx
  801ce7:	c1 ea 0c             	shr    $0xc,%edx
  801cea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cf1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801cf7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801cfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801cff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d06:	00 
  801d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d12:	e8 c2 f4 ff ff       	call   8011d9 <sys_page_map>
  801d17:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801d19:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801d1c:	85 f6                	test   %esi,%esi
  801d1e:	79 22                	jns    801d42 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801d20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2b:	e8 fc f4 ff ff       	call   80122c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801d30:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3b:	e8 ec f4 ff ff       	call   80122c <sys_page_unmap>
	return r;
  801d40:	89 f0                	mov    %esi,%eax
}
  801d42:	83 c4 3c             	add    $0x3c,%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5e                   	pop    %esi
  801d47:	5f                   	pop    %edi
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    

00801d4a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	53                   	push   %ebx
  801d4e:	83 ec 24             	sub    $0x24,%esp
  801d51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d54:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5b:	89 1c 24             	mov    %ebx,(%esp)
  801d5e:	e8 53 fd ff ff       	call   801ab6 <fd_lookup>
  801d63:	89 c2                	mov    %eax,%edx
  801d65:	85 d2                	test   %edx,%edx
  801d67:	78 6d                	js     801dd6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d73:	8b 00                	mov    (%eax),%eax
  801d75:	89 04 24             	mov    %eax,(%esp)
  801d78:	e8 8f fd ff ff       	call   801b0c <dev_lookup>
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	78 55                	js     801dd6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d84:	8b 50 08             	mov    0x8(%eax),%edx
  801d87:	83 e2 03             	and    $0x3,%edx
  801d8a:	83 fa 01             	cmp    $0x1,%edx
  801d8d:	75 23                	jne    801db2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d8f:	a1 08 50 80 00       	mov    0x805008,%eax
  801d94:	8b 40 48             	mov    0x48(%eax),%eax
  801d97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9f:	c7 04 24 4d 3d 80 00 	movl   $0x803d4d,(%esp)
  801da6:	e8 f5 e8 ff ff       	call   8006a0 <cprintf>
		return -E_INVAL;
  801dab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db0:	eb 24                	jmp    801dd6 <read+0x8c>
	}
	if (!dev->dev_read)
  801db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db5:	8b 52 08             	mov    0x8(%edx),%edx
  801db8:	85 d2                	test   %edx,%edx
  801dba:	74 15                	je     801dd1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801dbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dca:	89 04 24             	mov    %eax,(%esp)
  801dcd:	ff d2                	call   *%edx
  801dcf:	eb 05                	jmp    801dd6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801dd1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801dd6:	83 c4 24             	add    $0x24,%esp
  801dd9:	5b                   	pop    %ebx
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    

00801ddc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	57                   	push   %edi
  801de0:	56                   	push   %esi
  801de1:	53                   	push   %ebx
  801de2:	83 ec 1c             	sub    $0x1c,%esp
  801de5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801de8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801deb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801df0:	eb 23                	jmp    801e15 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801df2:	89 f0                	mov    %esi,%eax
  801df4:	29 d8                	sub    %ebx,%eax
  801df6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dfa:	89 d8                	mov    %ebx,%eax
  801dfc:	03 45 0c             	add    0xc(%ebp),%eax
  801dff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e03:	89 3c 24             	mov    %edi,(%esp)
  801e06:	e8 3f ff ff ff       	call   801d4a <read>
		if (m < 0)
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	78 10                	js     801e1f <readn+0x43>
			return m;
		if (m == 0)
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	74 0a                	je     801e1d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801e13:	01 c3                	add    %eax,%ebx
  801e15:	39 f3                	cmp    %esi,%ebx
  801e17:	72 d9                	jb     801df2 <readn+0x16>
  801e19:	89 d8                	mov    %ebx,%eax
  801e1b:	eb 02                	jmp    801e1f <readn+0x43>
  801e1d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801e1f:	83 c4 1c             	add    $0x1c,%esp
  801e22:	5b                   	pop    %ebx
  801e23:	5e                   	pop    %esi
  801e24:	5f                   	pop    %edi
  801e25:	5d                   	pop    %ebp
  801e26:	c3                   	ret    

00801e27 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	53                   	push   %ebx
  801e2b:	83 ec 24             	sub    $0x24,%esp
  801e2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e31:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e38:	89 1c 24             	mov    %ebx,(%esp)
  801e3b:	e8 76 fc ff ff       	call   801ab6 <fd_lookup>
  801e40:	89 c2                	mov    %eax,%edx
  801e42:	85 d2                	test   %edx,%edx
  801e44:	78 68                	js     801eae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e50:	8b 00                	mov    (%eax),%eax
  801e52:	89 04 24             	mov    %eax,(%esp)
  801e55:	e8 b2 fc ff ff       	call   801b0c <dev_lookup>
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	78 50                	js     801eae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e61:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e65:	75 23                	jne    801e8a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e67:	a1 08 50 80 00       	mov    0x805008,%eax
  801e6c:	8b 40 48             	mov    0x48(%eax),%eax
  801e6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e77:	c7 04 24 69 3d 80 00 	movl   $0x803d69,(%esp)
  801e7e:	e8 1d e8 ff ff       	call   8006a0 <cprintf>
		return -E_INVAL;
  801e83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e88:	eb 24                	jmp    801eae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801e8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e8d:	8b 52 0c             	mov    0xc(%edx),%edx
  801e90:	85 d2                	test   %edx,%edx
  801e92:	74 15                	je     801ea9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801e94:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ea2:	89 04 24             	mov    %eax,(%esp)
  801ea5:	ff d2                	call   *%edx
  801ea7:	eb 05                	jmp    801eae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801ea9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801eae:	83 c4 24             	add    $0x24,%esp
  801eb1:	5b                   	pop    %ebx
  801eb2:	5d                   	pop    %ebp
  801eb3:	c3                   	ret    

00801eb4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	89 04 24             	mov    %eax,(%esp)
  801ec7:	e8 ea fb ff ff       	call   801ab6 <fd_lookup>
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	78 0e                	js     801ede <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 24             	sub    $0x24,%esp
  801ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801eea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef1:	89 1c 24             	mov    %ebx,(%esp)
  801ef4:	e8 bd fb ff ff       	call   801ab6 <fd_lookup>
  801ef9:	89 c2                	mov    %eax,%edx
  801efb:	85 d2                	test   %edx,%edx
  801efd:	78 61                	js     801f60 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801eff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f09:	8b 00                	mov    (%eax),%eax
  801f0b:	89 04 24             	mov    %eax,(%esp)
  801f0e:	e8 f9 fb ff ff       	call   801b0c <dev_lookup>
  801f13:	85 c0                	test   %eax,%eax
  801f15:	78 49                	js     801f60 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801f1e:	75 23                	jne    801f43 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801f20:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f25:	8b 40 48             	mov    0x48(%eax),%eax
  801f28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f30:	c7 04 24 2c 3d 80 00 	movl   $0x803d2c,(%esp)
  801f37:	e8 64 e7 ff ff       	call   8006a0 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801f3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f41:	eb 1d                	jmp    801f60 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f46:	8b 52 18             	mov    0x18(%edx),%edx
  801f49:	85 d2                	test   %edx,%edx
  801f4b:	74 0e                	je     801f5b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f50:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f54:	89 04 24             	mov    %eax,(%esp)
  801f57:	ff d2                	call   *%edx
  801f59:	eb 05                	jmp    801f60 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801f5b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801f60:	83 c4 24             	add    $0x24,%esp
  801f63:	5b                   	pop    %ebx
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	53                   	push   %ebx
  801f6a:	83 ec 24             	sub    $0x24,%esp
  801f6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f70:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	89 04 24             	mov    %eax,(%esp)
  801f7d:	e8 34 fb ff ff       	call   801ab6 <fd_lookup>
  801f82:	89 c2                	mov    %eax,%edx
  801f84:	85 d2                	test   %edx,%edx
  801f86:	78 52                	js     801fda <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	8b 00                	mov    (%eax),%eax
  801f94:	89 04 24             	mov    %eax,(%esp)
  801f97:	e8 70 fb ff ff       	call   801b0c <dev_lookup>
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	78 3a                	js     801fda <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801fa7:	74 2c                	je     801fd5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801fa9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801fac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801fb3:	00 00 00 
	stat->st_isdir = 0;
  801fb6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fbd:	00 00 00 
	stat->st_dev = dev;
  801fc0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801fc6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fcd:	89 14 24             	mov    %edx,(%esp)
  801fd0:	ff 50 14             	call   *0x14(%eax)
  801fd3:	eb 05                	jmp    801fda <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801fd5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801fda:	83 c4 24             	add    $0x24,%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	56                   	push   %esi
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801fe8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fef:	00 
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	89 04 24             	mov    %eax,(%esp)
  801ff6:	e8 99 02 00 00       	call   802294 <open>
  801ffb:	89 c3                	mov    %eax,%ebx
  801ffd:	85 db                	test   %ebx,%ebx
  801fff:	78 1b                	js     80201c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  802001:	8b 45 0c             	mov    0xc(%ebp),%eax
  802004:	89 44 24 04          	mov    %eax,0x4(%esp)
  802008:	89 1c 24             	mov    %ebx,(%esp)
  80200b:	e8 56 ff ff ff       	call   801f66 <fstat>
  802010:	89 c6                	mov    %eax,%esi
	close(fd);
  802012:	89 1c 24             	mov    %ebx,(%esp)
  802015:	e8 cd fb ff ff       	call   801be7 <close>
	return r;
  80201a:	89 f0                	mov    %esi,%eax
}
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5d                   	pop    %ebp
  802022:	c3                   	ret    

00802023 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	83 ec 10             	sub    $0x10,%esp
  80202b:	89 c6                	mov    %eax,%esi
  80202d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80202f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  802036:	75 11                	jne    802049 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802038:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80203f:	e8 2b 14 00 00       	call   80346f <ipc_find_env>
  802044:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802049:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802050:	00 
  802051:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  802058:	00 
  802059:	89 74 24 04          	mov    %esi,0x4(%esp)
  80205d:	a1 00 50 80 00       	mov    0x805000,%eax
  802062:	89 04 24             	mov    %eax,(%esp)
  802065:	e8 9e 13 00 00       	call   803408 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80206a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802071:	00 
  802072:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802076:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80207d:	e8 1e 13 00 00       	call   8033a0 <ipc_recv>
}
  802082:	83 c4 10             	add    $0x10,%esp
  802085:	5b                   	pop    %ebx
  802086:	5e                   	pop    %esi
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    

00802089 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	8b 40 0c             	mov    0xc(%eax),%eax
  802095:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80209a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8020a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8020ac:	e8 72 ff ff ff       	call   802023 <fsipc>
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8020bf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8020c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8020ce:	e8 50 ff ff ff       	call   802023 <fsipc>
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	53                   	push   %ebx
  8020d9:	83 ec 14             	sub    $0x14,%esp
  8020dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8020ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8020f4:	e8 2a ff ff ff       	call   802023 <fsipc>
  8020f9:	89 c2                	mov    %eax,%edx
  8020fb:	85 d2                	test   %edx,%edx
  8020fd:	78 2b                	js     80212a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8020ff:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802106:	00 
  802107:	89 1c 24             	mov    %ebx,(%esp)
  80210a:	e8 08 ec ff ff       	call   800d17 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80210f:	a1 80 60 80 00       	mov    0x806080,%eax
  802114:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80211a:	a1 84 60 80 00       	mov    0x806084,%eax
  80211f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212a:	83 c4 14             	add    $0x14,%esp
  80212d:	5b                   	pop    %ebx
  80212e:	5d                   	pop    %ebp
  80212f:	c3                   	ret    

00802130 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	53                   	push   %ebx
  802134:	83 ec 14             	sub    $0x14,%esp
  802137:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80213a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  802140:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  802145:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802148:	8b 55 08             	mov    0x8(%ebp),%edx
  80214b:	8b 52 0c             	mov    0xc(%edx),%edx
  80214e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  802154:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  802159:	89 44 24 08          	mov    %eax,0x8(%esp)
  80215d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802160:	89 44 24 04          	mov    %eax,0x4(%esp)
  802164:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80216b:	e8 44 ed ff ff       	call   800eb4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  802170:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  802177:	00 
  802178:	c7 04 24 9c 3d 80 00 	movl   $0x803d9c,(%esp)
  80217f:	e8 1c e5 ff ff       	call   8006a0 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802184:	ba 00 00 00 00       	mov    $0x0,%edx
  802189:	b8 04 00 00 00       	mov    $0x4,%eax
  80218e:	e8 90 fe ff ff       	call   802023 <fsipc>
  802193:	85 c0                	test   %eax,%eax
  802195:	78 53                	js     8021ea <devfile_write+0xba>
		return r;
	assert(r <= n);
  802197:	39 c3                	cmp    %eax,%ebx
  802199:	73 24                	jae    8021bf <devfile_write+0x8f>
  80219b:	c7 44 24 0c a1 3d 80 	movl   $0x803da1,0xc(%esp)
  8021a2:	00 
  8021a3:	c7 44 24 08 a8 3d 80 	movl   $0x803da8,0x8(%esp)
  8021aa:	00 
  8021ab:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8021b2:	00 
  8021b3:	c7 04 24 bd 3d 80 00 	movl   $0x803dbd,(%esp)
  8021ba:	e8 e8 e3 ff ff       	call   8005a7 <_panic>
	assert(r <= PGSIZE);
  8021bf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8021c4:	7e 24                	jle    8021ea <devfile_write+0xba>
  8021c6:	c7 44 24 0c c8 3d 80 	movl   $0x803dc8,0xc(%esp)
  8021cd:	00 
  8021ce:	c7 44 24 08 a8 3d 80 	movl   $0x803da8,0x8(%esp)
  8021d5:	00 
  8021d6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8021dd:	00 
  8021de:	c7 04 24 bd 3d 80 00 	movl   $0x803dbd,(%esp)
  8021e5:	e8 bd e3 ff ff       	call   8005a7 <_panic>
	return r;
}
  8021ea:	83 c4 14             	add    $0x14,%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5d                   	pop    %ebp
  8021ef:	c3                   	ret    

008021f0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	56                   	push   %esi
  8021f4:	53                   	push   %ebx
  8021f5:	83 ec 10             	sub    $0x10,%esp
  8021f8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802201:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802206:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80220c:	ba 00 00 00 00       	mov    $0x0,%edx
  802211:	b8 03 00 00 00       	mov    $0x3,%eax
  802216:	e8 08 fe ff ff       	call   802023 <fsipc>
  80221b:	89 c3                	mov    %eax,%ebx
  80221d:	85 c0                	test   %eax,%eax
  80221f:	78 6a                	js     80228b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802221:	39 c6                	cmp    %eax,%esi
  802223:	73 24                	jae    802249 <devfile_read+0x59>
  802225:	c7 44 24 0c a1 3d 80 	movl   $0x803da1,0xc(%esp)
  80222c:	00 
  80222d:	c7 44 24 08 a8 3d 80 	movl   $0x803da8,0x8(%esp)
  802234:	00 
  802235:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80223c:	00 
  80223d:	c7 04 24 bd 3d 80 00 	movl   $0x803dbd,(%esp)
  802244:	e8 5e e3 ff ff       	call   8005a7 <_panic>
	assert(r <= PGSIZE);
  802249:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80224e:	7e 24                	jle    802274 <devfile_read+0x84>
  802250:	c7 44 24 0c c8 3d 80 	movl   $0x803dc8,0xc(%esp)
  802257:	00 
  802258:	c7 44 24 08 a8 3d 80 	movl   $0x803da8,0x8(%esp)
  80225f:	00 
  802260:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802267:	00 
  802268:	c7 04 24 bd 3d 80 00 	movl   $0x803dbd,(%esp)
  80226f:	e8 33 e3 ff ff       	call   8005a7 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802274:	89 44 24 08          	mov    %eax,0x8(%esp)
  802278:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80227f:	00 
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	89 04 24             	mov    %eax,(%esp)
  802286:	e8 29 ec ff ff       	call   800eb4 <memmove>
	return r;
}
  80228b:	89 d8                	mov    %ebx,%eax
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	5b                   	pop    %ebx
  802291:	5e                   	pop    %esi
  802292:	5d                   	pop    %ebp
  802293:	c3                   	ret    

00802294 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	53                   	push   %ebx
  802298:	83 ec 24             	sub    $0x24,%esp
  80229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80229e:	89 1c 24             	mov    %ebx,(%esp)
  8022a1:	e8 3a ea ff ff       	call   800ce0 <strlen>
  8022a6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8022ab:	7f 60                	jg     80230d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8022ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b0:	89 04 24             	mov    %eax,(%esp)
  8022b3:	e8 af f7 ff ff       	call   801a67 <fd_alloc>
  8022b8:	89 c2                	mov    %eax,%edx
  8022ba:	85 d2                	test   %edx,%edx
  8022bc:	78 54                	js     802312 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8022be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022c2:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  8022c9:	e8 49 ea ff ff       	call   800d17 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8022ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8022d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022de:	e8 40 fd ff ff       	call   802023 <fsipc>
  8022e3:	89 c3                	mov    %eax,%ebx
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	79 17                	jns    802300 <open+0x6c>
		fd_close(fd, 0);
  8022e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022f0:	00 
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	89 04 24             	mov    %eax,(%esp)
  8022f7:	e8 6a f8 ff ff       	call   801b66 <fd_close>
		return r;
  8022fc:	89 d8                	mov    %ebx,%eax
  8022fe:	eb 12                	jmp    802312 <open+0x7e>
	}

	return fd2num(fd);
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	89 04 24             	mov    %eax,(%esp)
  802306:	e8 35 f7 ff ff       	call   801a40 <fd2num>
  80230b:	eb 05                	jmp    802312 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80230d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802312:	83 c4 24             	add    $0x24,%esp
  802315:	5b                   	pop    %ebx
  802316:	5d                   	pop    %ebp
  802317:	c3                   	ret    

00802318 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80231e:	ba 00 00 00 00       	mov    $0x0,%edx
  802323:	b8 08 00 00 00       	mov    $0x8,%eax
  802328:	e8 f6 fc ff ff       	call   802023 <fsipc>
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <evict>:

int evict(void)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802335:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  80233c:	e8 5f e3 ff ff       	call   8006a0 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802341:	ba 00 00 00 00       	mov    $0x0,%edx
  802346:	b8 09 00 00 00       	mov    $0x9,%eax
  80234b:	e8 d3 fc ff ff       	call   802023 <fsipc>
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    
  802352:	66 90                	xchg   %ax,%ax
  802354:	66 90                	xchg   %ax,%ax
  802356:	66 90                	xchg   %ax,%ax
  802358:	66 90                	xchg   %ax,%ax
  80235a:	66 90                	xchg   %ax,%ax
  80235c:	66 90                	xchg   %ax,%ax
  80235e:	66 90                	xchg   %ax,%ax

00802360 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	57                   	push   %edi
  802364:	56                   	push   %esi
  802365:	53                   	push   %ebx
  802366:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80236c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802373:	00 
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	89 04 24             	mov    %eax,(%esp)
  80237a:	e8 15 ff ff ff       	call   802294 <open>
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  802387:	85 c0                	test   %eax,%eax
  802389:	0f 88 41 05 00 00    	js     8028d0 <spawn+0x570>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80238f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802396:	00 
  802397:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80239d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a1:	89 0c 24             	mov    %ecx,(%esp)
  8023a4:	e8 33 fa ff ff       	call   801ddc <readn>
  8023a9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8023ae:	75 0c                	jne    8023bc <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  8023b0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8023b7:	45 4c 46 
  8023ba:	74 36                	je     8023f2 <spawn+0x92>
		close(fd);
  8023bc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8023c2:	89 04 24             	mov    %eax,(%esp)
  8023c5:	e8 1d f8 ff ff       	call   801be7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8023ca:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8023d1:	46 
  8023d2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  8023d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023dc:	c7 04 24 ed 3d 80 00 	movl   $0x803ded,(%esp)
  8023e3:	e8 b8 e2 ff ff       	call   8006a0 <cprintf>
		return -E_NOT_EXEC;
  8023e8:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8023ed:	e9 3d 05 00 00       	jmp    80292f <spawn+0x5cf>
  8023f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8023f7:	cd 30                	int    $0x30
  8023f9:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8023ff:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802405:	85 c0                	test   %eax,%eax
  802407:	0f 88 cb 04 00 00    	js     8028d8 <spawn+0x578>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802415:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802418:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80241e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802424:	b9 11 00 00 00       	mov    $0x11,%ecx
  802429:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80242b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802431:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802437:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80243c:	be 00 00 00 00       	mov    $0x0,%esi
  802441:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802444:	eb 0f                	jmp    802455 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 92 e8 ff ff       	call   800ce0 <strlen>
  80244e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802452:	83 c3 01             	add    $0x1,%ebx
  802455:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80245c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80245f:	85 c0                	test   %eax,%eax
  802461:	75 e3                	jne    802446 <spawn+0xe6>
  802463:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802469:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80246f:	bf 00 10 40 00       	mov    $0x401000,%edi
  802474:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802476:	89 fa                	mov    %edi,%edx
  802478:	83 e2 fc             	and    $0xfffffffc,%edx
  80247b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802482:	29 c2                	sub    %eax,%edx
  802484:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80248a:	8d 42 f8             	lea    -0x8(%edx),%eax
  80248d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802492:	0f 86 50 04 00 00    	jbe    8028e8 <spawn+0x588>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802498:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80249f:	00 
  8024a0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8024a7:	00 
  8024a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024af:	e8 d1 ec ff ff       	call   801185 <sys_page_alloc>
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	0f 88 73 04 00 00    	js     80292f <spawn+0x5cf>
  8024bc:	be 00 00 00 00       	mov    $0x0,%esi
  8024c1:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8024c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8024ca:	eb 30                	jmp    8024fc <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  8024cc:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8024d2:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8024d8:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  8024db:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8024de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e2:	89 3c 24             	mov    %edi,(%esp)
  8024e5:	e8 2d e8 ff ff       	call   800d17 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8024ea:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8024ed:	89 04 24             	mov    %eax,(%esp)
  8024f0:	e8 eb e7 ff ff       	call   800ce0 <strlen>
  8024f5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8024f9:	83 c6 01             	add    $0x1,%esi
  8024fc:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  802502:	7c c8                	jl     8024cc <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802504:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80250a:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802510:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802517:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80251d:	74 24                	je     802543 <spawn+0x1e3>
  80251f:	c7 44 24 0c 74 3e 80 	movl   $0x803e74,0xc(%esp)
  802526:	00 
  802527:	c7 44 24 08 a8 3d 80 	movl   $0x803da8,0x8(%esp)
  80252e:	00 
  80252f:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  802536:	00 
  802537:	c7 04 24 07 3e 80 00 	movl   $0x803e07,(%esp)
  80253e:	e8 64 e0 ff ff       	call   8005a7 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802543:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802549:	89 c8                	mov    %ecx,%eax
  80254b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802550:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802553:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802559:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80255c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802562:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802568:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80256f:	00 
  802570:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802577:	ee 
  802578:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80257e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802582:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802589:	00 
  80258a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802591:	e8 43 ec ff ff       	call   8011d9 <sys_page_map>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 88 79 03 00 00    	js     802919 <spawn+0x5b9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8025a0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8025a7:	00 
  8025a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025af:	e8 78 ec ff ff       	call   80122c <sys_page_unmap>
  8025b4:	89 c3                	mov    %eax,%ebx
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	0f 88 5b 03 00 00    	js     802919 <spawn+0x5b9>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8025be:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8025c4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8025cb:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8025d1:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  8025d8:	00 00 00 
  8025db:	e9 b6 01 00 00       	jmp    802796 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  8025e0:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  8025e6:	83 38 01             	cmpl   $0x1,(%eax)
  8025e9:	0f 85 99 01 00 00    	jne    802788 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8025ef:	89 c2                	mov    %eax,%edx
  8025f1:	8b 40 18             	mov    0x18(%eax),%eax
  8025f4:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  8025f7:	83 f8 01             	cmp    $0x1,%eax
  8025fa:	19 c0                	sbb    %eax,%eax
  8025fc:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802602:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  802609:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802610:	89 d0                	mov    %edx,%eax
  802612:	8b 4a 04             	mov    0x4(%edx),%ecx
  802615:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80261b:	8b 52 10             	mov    0x10(%edx),%edx
  80261e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  802624:	8b 48 14             	mov    0x14(%eax),%ecx
  802627:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  80262d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802630:	89 f0                	mov    %esi,%eax
  802632:	25 ff 0f 00 00       	and    $0xfff,%eax
  802637:	74 14                	je     80264d <spawn+0x2ed>
		va -= i;
  802639:	29 c6                	sub    %eax,%esi
		memsz += i;
  80263b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802641:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  802647:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80264d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802652:	e9 23 01 00 00       	jmp    80277a <spawn+0x41a>
		if (i >= filesz) {
  802657:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  80265d:	77 2b                	ja     80268a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80265f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802665:	89 44 24 08          	mov    %eax,0x8(%esp)
  802669:	89 74 24 04          	mov    %esi,0x4(%esp)
  80266d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802673:	89 04 24             	mov    %eax,(%esp)
  802676:	e8 0a eb ff ff       	call   801185 <sys_page_alloc>
  80267b:	85 c0                	test   %eax,%eax
  80267d:	0f 89 eb 00 00 00    	jns    80276e <spawn+0x40e>
  802683:	89 c3                	mov    %eax,%ebx
  802685:	e9 6f 02 00 00       	jmp    8028f9 <spawn+0x599>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80268a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802691:	00 
  802692:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802699:	00 
  80269a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a1:	e8 df ea ff ff       	call   801185 <sys_page_alloc>
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	0f 88 41 02 00 00    	js     8028ef <spawn+0x58f>
  8026ae:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8026b4:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8026b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ba:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8026c0:	89 04 24             	mov    %eax,(%esp)
  8026c3:	e8 ec f7 ff ff       	call   801eb4 <seek>
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	0f 88 23 02 00 00    	js     8028f3 <spawn+0x593>
  8026d0:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8026d6:	29 f9                	sub    %edi,%ecx
  8026d8:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8026da:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  8026e0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026e5:	0f 47 c2             	cmova  %edx,%eax
  8026e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026ec:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8026f3:	00 
  8026f4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8026fa:	89 04 24             	mov    %eax,(%esp)
  8026fd:	e8 da f6 ff ff       	call   801ddc <readn>
  802702:	85 c0                	test   %eax,%eax
  802704:	0f 88 ed 01 00 00    	js     8028f7 <spawn+0x597>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80270a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802710:	89 44 24 10          	mov    %eax,0x10(%esp)
  802714:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802718:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80271e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802722:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802729:	00 
  80272a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802731:	e8 a3 ea ff ff       	call   8011d9 <sys_page_map>
  802736:	85 c0                	test   %eax,%eax
  802738:	79 20                	jns    80275a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  80273a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80273e:	c7 44 24 08 13 3e 80 	movl   $0x803e13,0x8(%esp)
  802745:	00 
  802746:	c7 44 24 04 a8 01 00 	movl   $0x1a8,0x4(%esp)
  80274d:	00 
  80274e:	c7 04 24 07 3e 80 00 	movl   $0x803e07,(%esp)
  802755:	e8 4d de ff ff       	call   8005a7 <_panic>
			sys_page_unmap(0, UTEMP);
  80275a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802761:	00 
  802762:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802769:	e8 be ea ff ff       	call   80122c <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80276e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802774:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80277a:	89 df                	mov    %ebx,%edi
  80277c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802782:	0f 87 cf fe ff ff    	ja     802657 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802788:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  80278f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802796:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80279d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  8027a3:	0f 8c 37 fe ff ff    	jl     8025e0 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8027a9:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8027af:	89 04 24             	mov    %eax,(%esp)
  8027b2:	e8 30 f4 ff ff       	call   801be7 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
  8027b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027bc:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8027c2:	89 d8                	mov    %ebx,%eax
  8027c4:	c1 e8 16             	shr    $0x16,%eax
  8027c7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8027ce:	a8 01                	test   $0x1,%al
  8027d0:	74 76                	je     802848 <spawn+0x4e8>
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
  8027d2:	89 d8                	mov    %ebx,%eax
  8027d4:	c1 e8 0c             	shr    $0xc,%eax
  8027d7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8027de:	f6 c6 04             	test   $0x4,%dh
  8027e1:	74 5d                	je     802840 <spawn+0x4e0>
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  8027e3:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
				cprintf("\nspawn addr:%p\n",addr);
  8027ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027ee:	c7 04 24 30 3e 80 00 	movl   $0x803e30,(%esp)
  8027f5:	e8 a6 de ff ff       	call   8006a0 <cprintf>
		if(uvpd[PDX(addr)] & PTE_P)
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  8027fa:	81 e7 07 0e 00 00    	and    $0xe07,%edi
				cprintf("\nspawn addr:%p\n",addr);
				if ((r = sys_page_map(0, (void *)addr, child, (void *)addr, perm)) < 0)
  802800:	89 7c 24 10          	mov    %edi,0x10(%esp)
  802804:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802808:	89 74 24 08          	mov    %esi,0x8(%esp)
  80280c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802810:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802817:	e8 bd e9 ff ff       	call   8011d9 <sys_page_map>
  80281c:	85 c0                	test   %eax,%eax
  80281e:	79 20                	jns    802840 <spawn+0x4e0>
					panic("sys_page_map: %e", r);
  802820:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802824:	c7 44 24 08 7c 3c 80 	movl   $0x803c7c,0x8(%esp)
  80282b:	00 
  80282c:	c7 44 24 04 c2 01 00 	movl   $0x1c2,0x4(%esp)
  802833:	00 
  802834:	c7 04 24 07 3e 80 00 	movl   $0x803e07,(%esp)
  80283b:	e8 67 dd ff ff       	call   8005a7 <_panic>
			}
			addr += PGSIZE;
  802840:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802846:	eb 06                	jmp    80284e <spawn+0x4ee>
		}
		else
		{
			addr = addr + PTSIZE;
  802848:	81 c3 00 00 40 00    	add    $0x400000,%ebx
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
  80284e:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  802854:	0f 86 68 ff ff ff    	jbe    8027c2 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80285a:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802860:	89 44 24 04          	mov    %eax,0x4(%esp)
  802864:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80286a:	89 04 24             	mov    %eax,(%esp)
  80286d:	e8 80 ea ff ff       	call   8012f2 <sys_env_set_trapframe>
  802872:	85 c0                	test   %eax,%eax
  802874:	79 20                	jns    802896 <spawn+0x536>
		panic("sys_env_set_trapframe: %e", r);
  802876:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80287a:	c7 44 24 08 40 3e 80 	movl   $0x803e40,0x8(%esp)
  802881:	00 
  802882:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802889:	00 
  80288a:	c7 04 24 07 3e 80 00 	movl   $0x803e07,(%esp)
  802891:	e8 11 dd ff ff       	call   8005a7 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802896:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80289d:	00 
  80289e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8028a4:	89 04 24             	mov    %eax,(%esp)
  8028a7:	e8 f3 e9 ff ff       	call   80129f <sys_env_set_status>
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	79 30                	jns    8028e0 <spawn+0x580>
		panic("sys_env_set_status: %e", r);
  8028b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028b4:	c7 44 24 08 5a 3e 80 	movl   $0x803e5a,0x8(%esp)
  8028bb:	00 
  8028bc:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8028c3:	00 
  8028c4:	c7 04 24 07 3e 80 00 	movl   $0x803e07,(%esp)
  8028cb:	e8 d7 dc ff ff       	call   8005a7 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8028d0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8028d6:	eb 57                	jmp    80292f <spawn+0x5cf>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8028d8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8028de:	eb 4f                	jmp    80292f <spawn+0x5cf>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8028e0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8028e6:	eb 47                	jmp    80292f <spawn+0x5cf>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8028e8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8028ed:	eb 40                	jmp    80292f <spawn+0x5cf>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8028ef:	89 c3                	mov    %eax,%ebx
  8028f1:	eb 06                	jmp    8028f9 <spawn+0x599>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8028f3:	89 c3                	mov    %eax,%ebx
  8028f5:	eb 02                	jmp    8028f9 <spawn+0x599>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8028f7:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8028f9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8028ff:	89 04 24             	mov    %eax,(%esp)
  802902:	e8 9c e7 ff ff       	call   8010a3 <sys_env_destroy>
	close(fd);
  802907:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80290d:	89 04 24             	mov    %eax,(%esp)
  802910:	e8 d2 f2 ff ff       	call   801be7 <close>
	return r;
  802915:	89 d8                	mov    %ebx,%eax
  802917:	eb 16                	jmp    80292f <spawn+0x5cf>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802919:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802920:	00 
  802921:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802928:	e8 ff e8 ff ff       	call   80122c <sys_page_unmap>
  80292d:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80292f:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802935:	5b                   	pop    %ebx
  802936:	5e                   	pop    %esi
  802937:	5f                   	pop    %edi
  802938:	5d                   	pop    %ebp
  802939:	c3                   	ret    

0080293a <exec>:

int
exec(const char *prog, const char **argv)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
	sys_env_destroy(child);
	close(fd);
	return r;*/
	return 0;

}
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
  802942:	5d                   	pop    %ebp
  802943:	c3                   	ret    

00802944 <execl>:


int execl(const char *prog, const char *arg0, ...)
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802947:	8d 45 10             	lea    0x10(%ebp),%eax


int execl(const char *prog, const char *arg0, ...)
{
	//works same as spawnl
	int argc=0;
  80294a:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80294f:	eb 03                	jmp    802954 <execl+0x10>
		argc++;
  802951:	83 c2 01             	add    $0x1,%edx
{
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802954:	83 c0 04             	add    $0x4,%eax
  802957:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80295b:	75 f4                	jne    802951 <execl+0xd>
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80295d:	b8 00 00 00 00       	mov    $0x0,%eax
  802962:	eb 03                	jmp    802967 <execl+0x23>
		argv[i+1] = va_arg(vl, const char *);
  802964:	83 c0 01             	add    $0x1,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802967:	39 d0                	cmp    %edx,%eax
  802969:	75 f9                	jne    802964 <execl+0x20>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
}
  80296b:	b8 00 00 00 00       	mov    $0x0,%eax
  802970:	5d                   	pop    %ebp
  802971:	c3                   	ret    

00802972 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802972:	55                   	push   %ebp
  802973:	89 e5                	mov    %esp,%ebp
  802975:	56                   	push   %esi
  802976:	53                   	push   %ebx
  802977:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80297a:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80297d:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802982:	eb 03                	jmp    802987 <spawnl+0x15>
		argc++;
  802984:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802987:	83 c0 04             	add    $0x4,%eax
  80298a:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80298e:	75 f4                	jne    802984 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802990:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802997:	83 e0 f0             	and    $0xfffffff0,%eax
  80299a:	29 c4                	sub    %eax,%esp
  80299c:	8d 44 24 0b          	lea    0xb(%esp),%eax
  8029a0:	c1 e8 02             	shr    $0x2,%eax
  8029a3:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  8029aa:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8029ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029af:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  8029b6:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  8029bd:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c3:	eb 0a                	jmp    8029cf <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  8029c5:	83 c0 01             	add    $0x1,%eax
  8029c8:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  8029cc:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8029cf:	39 d0                	cmp    %edx,%eax
  8029d1:	75 f2                	jne    8029c5 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8029d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	89 04 24             	mov    %eax,(%esp)
  8029dd:	e8 7e f9 ff ff       	call   802360 <spawn>
}
  8029e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029e5:	5b                   	pop    %ebx
  8029e6:	5e                   	pop    %esi
  8029e7:	5d                   	pop    %ebp
  8029e8:	c3                   	ret    
  8029e9:	66 90                	xchg   %ax,%ax
  8029eb:	66 90                	xchg   %ax,%ax
  8029ed:	66 90                	xchg   %ax,%ax
  8029ef:	90                   	nop

008029f0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
  8029f3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8029f6:	c7 44 24 04 9a 3e 80 	movl   $0x803e9a,0x4(%esp)
  8029fd:	00 
  8029fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a01:	89 04 24             	mov    %eax,(%esp)
  802a04:	e8 0e e3 ff ff       	call   800d17 <strcpy>
	return 0;
}
  802a09:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0e:	c9                   	leave  
  802a0f:	c3                   	ret    

00802a10 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	53                   	push   %ebx
  802a14:	83 ec 14             	sub    $0x14,%esp
  802a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802a1a:	89 1c 24             	mov    %ebx,(%esp)
  802a1d:	e8 85 0a 00 00       	call   8034a7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802a22:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802a27:	83 f8 01             	cmp    $0x1,%eax
  802a2a:	75 0d                	jne    802a39 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  802a2c:	8b 43 0c             	mov    0xc(%ebx),%eax
  802a2f:	89 04 24             	mov    %eax,(%esp)
  802a32:	e8 29 03 00 00       	call   802d60 <nsipc_close>
  802a37:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802a39:	89 d0                	mov    %edx,%eax
  802a3b:	83 c4 14             	add    $0x14,%esp
  802a3e:	5b                   	pop    %ebx
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    

00802a41 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802a41:	55                   	push   %ebp
  802a42:	89 e5                	mov    %esp,%ebp
  802a44:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802a47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802a4e:	00 
  802a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  802a52:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8b 40 0c             	mov    0xc(%eax),%eax
  802a63:	89 04 24             	mov    %eax,(%esp)
  802a66:	e8 f0 03 00 00       	call   802e5b <nsipc_send>
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802a73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802a7a:	00 
  802a7b:	8b 45 10             	mov    0x10(%ebp),%eax
  802a7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a85:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8f:	89 04 24             	mov    %eax,(%esp)
  802a92:	e8 44 03 00 00       	call   802ddb <nsipc_recv>
}
  802a97:	c9                   	leave  
  802a98:	c3                   	ret    

00802a99 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a99:	55                   	push   %ebp
  802a9a:	89 e5                	mov    %esp,%ebp
  802a9c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802aa2:	89 54 24 04          	mov    %edx,0x4(%esp)
  802aa6:	89 04 24             	mov    %eax,(%esp)
  802aa9:	e8 08 f0 ff ff       	call   801ab6 <fd_lookup>
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	78 17                	js     802ac9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  802abb:	39 08                	cmp    %ecx,(%eax)
  802abd:	75 05                	jne    802ac4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802abf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac2:	eb 05                	jmp    802ac9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802ac4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802ac9:	c9                   	leave  
  802aca:	c3                   	ret    

00802acb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
  802ace:	56                   	push   %esi
  802acf:	53                   	push   %ebx
  802ad0:	83 ec 20             	sub    $0x20,%esp
  802ad3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ad5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ad8:	89 04 24             	mov    %eax,(%esp)
  802adb:	e8 87 ef ff ff       	call   801a67 <fd_alloc>
  802ae0:	89 c3                	mov    %eax,%ebx
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	78 21                	js     802b07 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802ae6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802aed:	00 
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802afc:	e8 84 e6 ff ff       	call   801185 <sys_page_alloc>
  802b01:	89 c3                	mov    %eax,%ebx
  802b03:	85 c0                	test   %eax,%eax
  802b05:	79 0c                	jns    802b13 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802b07:	89 34 24             	mov    %esi,(%esp)
  802b0a:	e8 51 02 00 00       	call   802d60 <nsipc_close>
		return r;
  802b0f:	89 d8                	mov    %ebx,%eax
  802b11:	eb 20                	jmp    802b33 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802b13:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b21:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802b28:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  802b2b:	89 14 24             	mov    %edx,(%esp)
  802b2e:	e8 0d ef ff ff       	call   801a40 <fd2num>
}
  802b33:	83 c4 20             	add    $0x20,%esp
  802b36:	5b                   	pop    %ebx
  802b37:	5e                   	pop    %esi
  802b38:	5d                   	pop    %ebp
  802b39:	c3                   	ret    

00802b3a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
  802b3d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	e8 51 ff ff ff       	call   802a99 <fd2sockid>
		return r;
  802b48:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	78 23                	js     802b71 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b4e:	8b 55 10             	mov    0x10(%ebp),%edx
  802b51:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b58:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b5c:	89 04 24             	mov    %eax,(%esp)
  802b5f:	e8 45 01 00 00       	call   802ca9 <nsipc_accept>
		return r;
  802b64:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b66:	85 c0                	test   %eax,%eax
  802b68:	78 07                	js     802b71 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  802b6a:	e8 5c ff ff ff       	call   802acb <alloc_sockfd>
  802b6f:	89 c1                	mov    %eax,%ecx
}
  802b71:	89 c8                	mov    %ecx,%eax
  802b73:	c9                   	leave  
  802b74:	c3                   	ret    

00802b75 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802b75:	55                   	push   %ebp
  802b76:	89 e5                	mov    %esp,%ebp
  802b78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	e8 16 ff ff ff       	call   802a99 <fd2sockid>
  802b83:	89 c2                	mov    %eax,%edx
  802b85:	85 d2                	test   %edx,%edx
  802b87:	78 16                	js     802b9f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802b89:	8b 45 10             	mov    0x10(%ebp),%eax
  802b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b97:	89 14 24             	mov    %edx,(%esp)
  802b9a:	e8 60 01 00 00       	call   802cff <nsipc_bind>
}
  802b9f:	c9                   	leave  
  802ba0:	c3                   	ret    

00802ba1 <shutdown>:

int
shutdown(int s, int how)
{
  802ba1:	55                   	push   %ebp
  802ba2:	89 e5                	mov    %esp,%ebp
  802ba4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	e8 ea fe ff ff       	call   802a99 <fd2sockid>
  802baf:	89 c2                	mov    %eax,%edx
  802bb1:	85 d2                	test   %edx,%edx
  802bb3:	78 0f                	js     802bc4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bbc:	89 14 24             	mov    %edx,(%esp)
  802bbf:	e8 7a 01 00 00       	call   802d3e <nsipc_shutdown>
}
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
  802bc9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	e8 c5 fe ff ff       	call   802a99 <fd2sockid>
  802bd4:	89 c2                	mov    %eax,%edx
  802bd6:	85 d2                	test   %edx,%edx
  802bd8:	78 16                	js     802bf0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  802bda:	8b 45 10             	mov    0x10(%ebp),%eax
  802bdd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be8:	89 14 24             	mov    %edx,(%esp)
  802beb:	e8 8a 01 00 00       	call   802d7a <nsipc_connect>
}
  802bf0:	c9                   	leave  
  802bf1:	c3                   	ret    

00802bf2 <listen>:

int
listen(int s, int backlog)
{
  802bf2:	55                   	push   %ebp
  802bf3:	89 e5                	mov    %esp,%ebp
  802bf5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	e8 99 fe ff ff       	call   802a99 <fd2sockid>
  802c00:	89 c2                	mov    %eax,%edx
  802c02:	85 d2                	test   %edx,%edx
  802c04:	78 0f                	js     802c15 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c0d:	89 14 24             	mov    %edx,(%esp)
  802c10:	e8 a4 01 00 00       	call   802db9 <nsipc_listen>
}
  802c15:	c9                   	leave  
  802c16:	c3                   	ret    

00802c17 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
  802c1a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  802c20:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	89 04 24             	mov    %eax,(%esp)
  802c31:	e8 98 02 00 00       	call   802ece <nsipc_socket>
  802c36:	89 c2                	mov    %eax,%edx
  802c38:	85 d2                	test   %edx,%edx
  802c3a:	78 05                	js     802c41 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  802c3c:	e8 8a fe ff ff       	call   802acb <alloc_sockfd>
}
  802c41:	c9                   	leave  
  802c42:	c3                   	ret    

00802c43 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802c43:	55                   	push   %ebp
  802c44:	89 e5                	mov    %esp,%ebp
  802c46:	53                   	push   %ebx
  802c47:	83 ec 14             	sub    $0x14,%esp
  802c4a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802c4c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802c53:	75 11                	jne    802c66 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802c55:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802c5c:	e8 0e 08 00 00       	call   80346f <ipc_find_env>
  802c61:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802c66:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802c6d:	00 
  802c6e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802c75:	00 
  802c76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c7a:	a1 04 50 80 00       	mov    0x805004,%eax
  802c7f:	89 04 24             	mov    %eax,(%esp)
  802c82:	e8 81 07 00 00       	call   803408 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802c87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802c8e:	00 
  802c8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802c96:	00 
  802c97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c9e:	e8 fd 06 00 00       	call   8033a0 <ipc_recv>
}
  802ca3:	83 c4 14             	add    $0x14,%esp
  802ca6:	5b                   	pop    %ebx
  802ca7:	5d                   	pop    %ebp
  802ca8:	c3                   	ret    

00802ca9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
  802cac:	56                   	push   %esi
  802cad:	53                   	push   %ebx
  802cae:	83 ec 10             	sub    $0x10,%esp
  802cb1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802cbc:	8b 06                	mov    (%esi),%eax
  802cbe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802cc3:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc8:	e8 76 ff ff ff       	call   802c43 <nsipc>
  802ccd:	89 c3                	mov    %eax,%ebx
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	78 23                	js     802cf6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802cd3:	a1 10 70 80 00       	mov    0x807010,%eax
  802cd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cdc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802ce3:	00 
  802ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce7:	89 04 24             	mov    %eax,(%esp)
  802cea:	e8 c5 e1 ff ff       	call   800eb4 <memmove>
		*addrlen = ret->ret_addrlen;
  802cef:	a1 10 70 80 00       	mov    0x807010,%eax
  802cf4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802cf6:	89 d8                	mov    %ebx,%eax
  802cf8:	83 c4 10             	add    $0x10,%esp
  802cfb:	5b                   	pop    %ebx
  802cfc:	5e                   	pop    %esi
  802cfd:	5d                   	pop    %ebp
  802cfe:	c3                   	ret    

00802cff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802cff:	55                   	push   %ebp
  802d00:	89 e5                	mov    %esp,%ebp
  802d02:	53                   	push   %ebx
  802d03:	83 ec 14             	sub    $0x14,%esp
  802d06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802d11:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d1c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802d23:	e8 8c e1 ff ff       	call   800eb4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802d28:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802d2e:	b8 02 00 00 00       	mov    $0x2,%eax
  802d33:	e8 0b ff ff ff       	call   802c43 <nsipc>
}
  802d38:	83 c4 14             	add    $0x14,%esp
  802d3b:	5b                   	pop    %ebx
  802d3c:	5d                   	pop    %ebp
  802d3d:	c3                   	ret    

00802d3e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802d3e:	55                   	push   %ebp
  802d3f:	89 e5                	mov    %esp,%ebp
  802d41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802d54:	b8 03 00 00 00       	mov    $0x3,%eax
  802d59:	e8 e5 fe ff ff       	call   802c43 <nsipc>
}
  802d5e:	c9                   	leave  
  802d5f:	c3                   	ret    

00802d60 <nsipc_close>:

int
nsipc_close(int s)
{
  802d60:	55                   	push   %ebp
  802d61:	89 e5                	mov    %esp,%ebp
  802d63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802d6e:	b8 04 00 00 00       	mov    $0x4,%eax
  802d73:	e8 cb fe ff ff       	call   802c43 <nsipc>
}
  802d78:	c9                   	leave  
  802d79:	c3                   	ret    

00802d7a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d7a:	55                   	push   %ebp
  802d7b:	89 e5                	mov    %esp,%ebp
  802d7d:	53                   	push   %ebx
  802d7e:	83 ec 14             	sub    $0x14,%esp
  802d81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802d8c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d97:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802d9e:	e8 11 e1 ff ff       	call   800eb4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802da3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802da9:	b8 05 00 00 00       	mov    $0x5,%eax
  802dae:	e8 90 fe ff ff       	call   802c43 <nsipc>
}
  802db3:	83 c4 14             	add    $0x14,%esp
  802db6:	5b                   	pop    %ebx
  802db7:	5d                   	pop    %ebp
  802db8:	c3                   	ret    

00802db9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802db9:	55                   	push   %ebp
  802dba:	89 e5                	mov    %esp,%ebp
  802dbc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dca:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802dcf:	b8 06 00 00 00       	mov    $0x6,%eax
  802dd4:	e8 6a fe ff ff       	call   802c43 <nsipc>
}
  802dd9:	c9                   	leave  
  802dda:	c3                   	ret    

00802ddb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802ddb:	55                   	push   %ebp
  802ddc:	89 e5                	mov    %esp,%ebp
  802dde:	56                   	push   %esi
  802ddf:	53                   	push   %ebx
  802de0:	83 ec 10             	sub    $0x10,%esp
  802de3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802dee:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802df4:	8b 45 14             	mov    0x14(%ebp),%eax
  802df7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802dfc:	b8 07 00 00 00       	mov    $0x7,%eax
  802e01:	e8 3d fe ff ff       	call   802c43 <nsipc>
  802e06:	89 c3                	mov    %eax,%ebx
  802e08:	85 c0                	test   %eax,%eax
  802e0a:	78 46                	js     802e52 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802e0c:	39 f0                	cmp    %esi,%eax
  802e0e:	7f 07                	jg     802e17 <nsipc_recv+0x3c>
  802e10:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802e15:	7e 24                	jle    802e3b <nsipc_recv+0x60>
  802e17:	c7 44 24 0c a6 3e 80 	movl   $0x803ea6,0xc(%esp)
  802e1e:	00 
  802e1f:	c7 44 24 08 a8 3d 80 	movl   $0x803da8,0x8(%esp)
  802e26:	00 
  802e27:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802e2e:	00 
  802e2f:	c7 04 24 bb 3e 80 00 	movl   $0x803ebb,(%esp)
  802e36:	e8 6c d7 ff ff       	call   8005a7 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802e3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e3f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802e46:	00 
  802e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4a:	89 04 24             	mov    %eax,(%esp)
  802e4d:	e8 62 e0 ff ff       	call   800eb4 <memmove>
	}

	return r;
}
  802e52:	89 d8                	mov    %ebx,%eax
  802e54:	83 c4 10             	add    $0x10,%esp
  802e57:	5b                   	pop    %ebx
  802e58:	5e                   	pop    %esi
  802e59:	5d                   	pop    %ebp
  802e5a:	c3                   	ret    

00802e5b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802e5b:	55                   	push   %ebp
  802e5c:	89 e5                	mov    %esp,%ebp
  802e5e:	53                   	push   %ebx
  802e5f:	83 ec 14             	sub    $0x14,%esp
  802e62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802e6d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802e73:	7e 24                	jle    802e99 <nsipc_send+0x3e>
  802e75:	c7 44 24 0c c7 3e 80 	movl   $0x803ec7,0xc(%esp)
  802e7c:	00 
  802e7d:	c7 44 24 08 a8 3d 80 	movl   $0x803da8,0x8(%esp)
  802e84:	00 
  802e85:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802e8c:	00 
  802e8d:	c7 04 24 bb 3e 80 00 	movl   $0x803ebb,(%esp)
  802e94:	e8 0e d7 ff ff       	call   8005a7 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802e99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ea4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  802eab:	e8 04 e0 ff ff       	call   800eb4 <memmove>
	nsipcbuf.send.req_size = size;
  802eb0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802eb6:	8b 45 14             	mov    0x14(%ebp),%eax
  802eb9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802ebe:	b8 08 00 00 00       	mov    $0x8,%eax
  802ec3:	e8 7b fd ff ff       	call   802c43 <nsipc>
}
  802ec8:	83 c4 14             	add    $0x14,%esp
  802ecb:	5b                   	pop    %ebx
  802ecc:	5d                   	pop    %ebp
  802ecd:	c3                   	ret    

00802ece <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802ece:	55                   	push   %ebp
  802ecf:	89 e5                	mov    %esp,%ebp
  802ed1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802eec:	b8 09 00 00 00       	mov    $0x9,%eax
  802ef1:	e8 4d fd ff ff       	call   802c43 <nsipc>
}
  802ef6:	c9                   	leave  
  802ef7:	c3                   	ret    

00802ef8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ef8:	55                   	push   %ebp
  802ef9:	89 e5                	mov    %esp,%ebp
  802efb:	56                   	push   %esi
  802efc:	53                   	push   %ebx
  802efd:	83 ec 10             	sub    $0x10,%esp
  802f00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	89 04 24             	mov    %eax,(%esp)
  802f09:	e8 42 eb ff ff       	call   801a50 <fd2data>
  802f0e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802f10:	c7 44 24 04 d3 3e 80 	movl   $0x803ed3,0x4(%esp)
  802f17:	00 
  802f18:	89 1c 24             	mov    %ebx,(%esp)
  802f1b:	e8 f7 dd ff ff       	call   800d17 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802f20:	8b 46 04             	mov    0x4(%esi),%eax
  802f23:	2b 06                	sub    (%esi),%eax
  802f25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802f2b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802f32:	00 00 00 
	stat->st_dev = &devpipe;
  802f35:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802f3c:	40 80 00 
	return 0;
}
  802f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f44:	83 c4 10             	add    $0x10,%esp
  802f47:	5b                   	pop    %ebx
  802f48:	5e                   	pop    %esi
  802f49:	5d                   	pop    %ebp
  802f4a:	c3                   	ret    

00802f4b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802f4b:	55                   	push   %ebp
  802f4c:	89 e5                	mov    %esp,%ebp
  802f4e:	53                   	push   %ebx
  802f4f:	83 ec 14             	sub    $0x14,%esp
  802f52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802f55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f60:	e8 c7 e2 ff ff       	call   80122c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802f65:	89 1c 24             	mov    %ebx,(%esp)
  802f68:	e8 e3 ea ff ff       	call   801a50 <fd2data>
  802f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f78:	e8 af e2 ff ff       	call   80122c <sys_page_unmap>
}
  802f7d:	83 c4 14             	add    $0x14,%esp
  802f80:	5b                   	pop    %ebx
  802f81:	5d                   	pop    %ebp
  802f82:	c3                   	ret    

00802f83 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f83:	55                   	push   %ebp
  802f84:	89 e5                	mov    %esp,%ebp
  802f86:	57                   	push   %edi
  802f87:	56                   	push   %esi
  802f88:	53                   	push   %ebx
  802f89:	83 ec 2c             	sub    $0x2c,%esp
  802f8c:	89 c6                	mov    %eax,%esi
  802f8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802f91:	a1 08 50 80 00       	mov    0x805008,%eax
  802f96:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802f99:	89 34 24             	mov    %esi,(%esp)
  802f9c:	e8 06 05 00 00       	call   8034a7 <pageref>
  802fa1:	89 c7                	mov    %eax,%edi
  802fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa6:	89 04 24             	mov    %eax,(%esp)
  802fa9:	e8 f9 04 00 00       	call   8034a7 <pageref>
  802fae:	39 c7                	cmp    %eax,%edi
  802fb0:	0f 94 c2             	sete   %dl
  802fb3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802fb6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  802fbc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802fbf:	39 fb                	cmp    %edi,%ebx
  802fc1:	74 21                	je     802fe4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802fc3:	84 d2                	test   %dl,%dl
  802fc5:	74 ca                	je     802f91 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802fc7:	8b 51 58             	mov    0x58(%ecx),%edx
  802fca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802fce:	89 54 24 08          	mov    %edx,0x8(%esp)
  802fd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fd6:	c7 04 24 da 3e 80 00 	movl   $0x803eda,(%esp)
  802fdd:	e8 be d6 ff ff       	call   8006a0 <cprintf>
  802fe2:	eb ad                	jmp    802f91 <_pipeisclosed+0xe>
	}
}
  802fe4:	83 c4 2c             	add    $0x2c,%esp
  802fe7:	5b                   	pop    %ebx
  802fe8:	5e                   	pop    %esi
  802fe9:	5f                   	pop    %edi
  802fea:	5d                   	pop    %ebp
  802feb:	c3                   	ret    

00802fec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fec:	55                   	push   %ebp
  802fed:	89 e5                	mov    %esp,%ebp
  802fef:	57                   	push   %edi
  802ff0:	56                   	push   %esi
  802ff1:	53                   	push   %ebx
  802ff2:	83 ec 1c             	sub    $0x1c,%esp
  802ff5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802ff8:	89 34 24             	mov    %esi,(%esp)
  802ffb:	e8 50 ea ff ff       	call   801a50 <fd2data>
  803000:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803002:	bf 00 00 00 00       	mov    $0x0,%edi
  803007:	eb 45                	jmp    80304e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803009:	89 da                	mov    %ebx,%edx
  80300b:	89 f0                	mov    %esi,%eax
  80300d:	e8 71 ff ff ff       	call   802f83 <_pipeisclosed>
  803012:	85 c0                	test   %eax,%eax
  803014:	75 41                	jne    803057 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803016:	e8 4b e1 ff ff       	call   801166 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80301b:	8b 43 04             	mov    0x4(%ebx),%eax
  80301e:	8b 0b                	mov    (%ebx),%ecx
  803020:	8d 51 20             	lea    0x20(%ecx),%edx
  803023:	39 d0                	cmp    %edx,%eax
  803025:	73 e2                	jae    803009 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803027:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80302a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80302e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803031:	99                   	cltd   
  803032:	c1 ea 1b             	shr    $0x1b,%edx
  803035:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803038:	83 e1 1f             	and    $0x1f,%ecx
  80303b:	29 d1                	sub    %edx,%ecx
  80303d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  803041:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803045:	83 c0 01             	add    $0x1,%eax
  803048:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80304b:	83 c7 01             	add    $0x1,%edi
  80304e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803051:	75 c8                	jne    80301b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803053:	89 f8                	mov    %edi,%eax
  803055:	eb 05                	jmp    80305c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803057:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80305c:	83 c4 1c             	add    $0x1c,%esp
  80305f:	5b                   	pop    %ebx
  803060:	5e                   	pop    %esi
  803061:	5f                   	pop    %edi
  803062:	5d                   	pop    %ebp
  803063:	c3                   	ret    

00803064 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803064:	55                   	push   %ebp
  803065:	89 e5                	mov    %esp,%ebp
  803067:	57                   	push   %edi
  803068:	56                   	push   %esi
  803069:	53                   	push   %ebx
  80306a:	83 ec 1c             	sub    $0x1c,%esp
  80306d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803070:	89 3c 24             	mov    %edi,(%esp)
  803073:	e8 d8 e9 ff ff       	call   801a50 <fd2data>
  803078:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80307a:	be 00 00 00 00       	mov    $0x0,%esi
  80307f:	eb 3d                	jmp    8030be <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803081:	85 f6                	test   %esi,%esi
  803083:	74 04                	je     803089 <devpipe_read+0x25>
				return i;
  803085:	89 f0                	mov    %esi,%eax
  803087:	eb 43                	jmp    8030cc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803089:	89 da                	mov    %ebx,%edx
  80308b:	89 f8                	mov    %edi,%eax
  80308d:	e8 f1 fe ff ff       	call   802f83 <_pipeisclosed>
  803092:	85 c0                	test   %eax,%eax
  803094:	75 31                	jne    8030c7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803096:	e8 cb e0 ff ff       	call   801166 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80309b:	8b 03                	mov    (%ebx),%eax
  80309d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8030a0:	74 df                	je     803081 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030a2:	99                   	cltd   
  8030a3:	c1 ea 1b             	shr    $0x1b,%edx
  8030a6:	01 d0                	add    %edx,%eax
  8030a8:	83 e0 1f             	and    $0x1f,%eax
  8030ab:	29 d0                	sub    %edx,%eax
  8030ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8030b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8030b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8030b8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030bb:	83 c6 01             	add    $0x1,%esi
  8030be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8030c1:	75 d8                	jne    80309b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8030c3:	89 f0                	mov    %esi,%eax
  8030c5:	eb 05                	jmp    8030cc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8030c7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8030cc:	83 c4 1c             	add    $0x1c,%esp
  8030cf:	5b                   	pop    %ebx
  8030d0:	5e                   	pop    %esi
  8030d1:	5f                   	pop    %edi
  8030d2:	5d                   	pop    %ebp
  8030d3:	c3                   	ret    

008030d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030d4:	55                   	push   %ebp
  8030d5:	89 e5                	mov    %esp,%ebp
  8030d7:	56                   	push   %esi
  8030d8:	53                   	push   %ebx
  8030d9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030df:	89 04 24             	mov    %eax,(%esp)
  8030e2:	e8 80 e9 ff ff       	call   801a67 <fd_alloc>
  8030e7:	89 c2                	mov    %eax,%edx
  8030e9:	85 d2                	test   %edx,%edx
  8030eb:	0f 88 4d 01 00 00    	js     80323e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030f8:	00 
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803100:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803107:	e8 79 e0 ff ff       	call   801185 <sys_page_alloc>
  80310c:	89 c2                	mov    %eax,%edx
  80310e:	85 d2                	test   %edx,%edx
  803110:	0f 88 28 01 00 00    	js     80323e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803116:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803119:	89 04 24             	mov    %eax,(%esp)
  80311c:	e8 46 e9 ff ff       	call   801a67 <fd_alloc>
  803121:	89 c3                	mov    %eax,%ebx
  803123:	85 c0                	test   %eax,%eax
  803125:	0f 88 fe 00 00 00    	js     803229 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80312b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803132:	00 
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80313a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803141:	e8 3f e0 ff ff       	call   801185 <sys_page_alloc>
  803146:	89 c3                	mov    %eax,%ebx
  803148:	85 c0                	test   %eax,%eax
  80314a:	0f 88 d9 00 00 00    	js     803229 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	89 04 24             	mov    %eax,(%esp)
  803156:	e8 f5 e8 ff ff       	call   801a50 <fd2data>
  80315b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80315d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803164:	00 
  803165:	89 44 24 04          	mov    %eax,0x4(%esp)
  803169:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803170:	e8 10 e0 ff ff       	call   801185 <sys_page_alloc>
  803175:	89 c3                	mov    %eax,%ebx
  803177:	85 c0                	test   %eax,%eax
  803179:	0f 88 97 00 00 00    	js     803216 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80317f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803182:	89 04 24             	mov    %eax,(%esp)
  803185:	e8 c6 e8 ff ff       	call   801a50 <fd2data>
  80318a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803191:	00 
  803192:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803196:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80319d:	00 
  80319e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031a9:	e8 2b e0 ff ff       	call   8011d9 <sys_page_map>
  8031ae:	89 c3                	mov    %eax,%ebx
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	78 52                	js     803206 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8031b4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031c9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8031d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	89 04 24             	mov    %eax,(%esp)
  8031e4:	e8 57 e8 ff ff       	call   801a40 <fd2num>
  8031e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8031ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f1:	89 04 24             	mov    %eax,(%esp)
  8031f4:	e8 47 e8 ff ff       	call   801a40 <fd2num>
  8031f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8031ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803204:	eb 38                	jmp    80323e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803206:	89 74 24 04          	mov    %esi,0x4(%esp)
  80320a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803211:	e8 16 e0 ff ff       	call   80122c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803219:	89 44 24 04          	mov    %eax,0x4(%esp)
  80321d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803224:	e8 03 e0 ff ff       	call   80122c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803230:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803237:	e8 f0 df ff ff       	call   80122c <sys_page_unmap>
  80323c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80323e:	83 c4 30             	add    $0x30,%esp
  803241:	5b                   	pop    %ebx
  803242:	5e                   	pop    %esi
  803243:	5d                   	pop    %ebp
  803244:	c3                   	ret    

00803245 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803245:	55                   	push   %ebp
  803246:	89 e5                	mov    %esp,%ebp
  803248:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80324b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80324e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	89 04 24             	mov    %eax,(%esp)
  803258:	e8 59 e8 ff ff       	call   801ab6 <fd_lookup>
  80325d:	89 c2                	mov    %eax,%edx
  80325f:	85 d2                	test   %edx,%edx
  803261:	78 15                	js     803278 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	89 04 24             	mov    %eax,(%esp)
  803269:	e8 e2 e7 ff ff       	call   801a50 <fd2data>
	return _pipeisclosed(fd, p);
  80326e:	89 c2                	mov    %eax,%edx
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	e8 0b fd ff ff       	call   802f83 <_pipeisclosed>
}
  803278:	c9                   	leave  
  803279:	c3                   	ret    

0080327a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80327a:	55                   	push   %ebp
  80327b:	89 e5                	mov    %esp,%ebp
  80327d:	56                   	push   %esi
  80327e:	53                   	push   %ebx
  80327f:	83 ec 10             	sub    $0x10,%esp
  803282:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803285:	85 f6                	test   %esi,%esi
  803287:	75 24                	jne    8032ad <wait+0x33>
  803289:	c7 44 24 0c f2 3e 80 	movl   $0x803ef2,0xc(%esp)
  803290:	00 
  803291:	c7 44 24 08 a8 3d 80 	movl   $0x803da8,0x8(%esp)
  803298:	00 
  803299:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8032a0:	00 
  8032a1:	c7 04 24 fd 3e 80 00 	movl   $0x803efd,(%esp)
  8032a8:	e8 fa d2 ff ff       	call   8005a7 <_panic>
	e = &envs[ENVX(envid)];
  8032ad:	89 f3                	mov    %esi,%ebx
  8032af:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8032b5:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8032b8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8032be:	eb 05                	jmp    8032c5 <wait+0x4b>
		sys_yield();
  8032c0:	e8 a1 de ff ff       	call   801166 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8032c5:	8b 43 48             	mov    0x48(%ebx),%eax
  8032c8:	39 f0                	cmp    %esi,%eax
  8032ca:	75 07                	jne    8032d3 <wait+0x59>
  8032cc:	8b 43 54             	mov    0x54(%ebx),%eax
  8032cf:	85 c0                	test   %eax,%eax
  8032d1:	75 ed                	jne    8032c0 <wait+0x46>
		sys_yield();
}
  8032d3:	83 c4 10             	add    $0x10,%esp
  8032d6:	5b                   	pop    %ebx
  8032d7:	5e                   	pop    %esi
  8032d8:	5d                   	pop    %ebp
  8032d9:	c3                   	ret    

008032da <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
  8032dd:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8032e0:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8032e7:	75 7a                	jne    803363 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8032e9:	e8 59 de ff ff       	call   801147 <sys_getenvid>
  8032ee:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8032f5:	00 
  8032f6:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8032fd:	ee 
  8032fe:	89 04 24             	mov    %eax,(%esp)
  803301:	e8 7f de ff ff       	call   801185 <sys_page_alloc>
  803306:	85 c0                	test   %eax,%eax
  803308:	79 20                	jns    80332a <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  80330a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80330e:	c7 44 24 08 69 3c 80 	movl   $0x803c69,0x8(%esp)
  803315:	00 
  803316:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  80331d:	00 
  80331e:	c7 04 24 08 3f 80 00 	movl   $0x803f08,(%esp)
  803325:	e8 7d d2 ff ff       	call   8005a7 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  80332a:	e8 18 de ff ff       	call   801147 <sys_getenvid>
  80332f:	c7 44 24 04 6d 33 80 	movl   $0x80336d,0x4(%esp)
  803336:	00 
  803337:	89 04 24             	mov    %eax,(%esp)
  80333a:	e8 06 e0 ff ff       	call   801345 <sys_env_set_pgfault_upcall>
  80333f:	85 c0                	test   %eax,%eax
  803341:	79 20                	jns    803363 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  803343:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803347:	c7 44 24 08 e8 3c 80 	movl   $0x803ce8,0x8(%esp)
  80334e:	00 
  80334f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  803356:	00 
  803357:	c7 04 24 08 3f 80 00 	movl   $0x803f08,(%esp)
  80335e:	e8 44 d2 ff ff       	call   8005a7 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80336b:	c9                   	leave  
  80336c:	c3                   	ret    

0080336d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80336d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80336e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803373:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803375:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  803378:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  80337c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  803380:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  803383:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  803387:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  803389:	83 c4 08             	add    $0x8,%esp
	popal
  80338c:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  80338d:	83 c4 04             	add    $0x4,%esp
	popfl
  803390:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803391:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803392:	c3                   	ret    
  803393:	66 90                	xchg   %ax,%ax
  803395:	66 90                	xchg   %ax,%ax
  803397:	66 90                	xchg   %ax,%ax
  803399:	66 90                	xchg   %ax,%ax
  80339b:	66 90                	xchg   %ax,%ax
  80339d:	66 90                	xchg   %ax,%ax
  80339f:	90                   	nop

008033a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033a0:	55                   	push   %ebp
  8033a1:	89 e5                	mov    %esp,%ebp
  8033a3:	56                   	push   %esi
  8033a4:	53                   	push   %ebx
  8033a5:	83 ec 10             	sub    $0x10,%esp
  8033a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8033ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8033b1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8033b3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8033b8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8033bb:	89 04 24             	mov    %eax,(%esp)
  8033be:	e8 f8 df ff ff       	call   8013bb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	75 26                	jne    8033ed <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8033c7:	85 f6                	test   %esi,%esi
  8033c9:	74 0a                	je     8033d5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8033cb:	a1 08 50 80 00       	mov    0x805008,%eax
  8033d0:	8b 40 74             	mov    0x74(%eax),%eax
  8033d3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8033d5:	85 db                	test   %ebx,%ebx
  8033d7:	74 0a                	je     8033e3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8033d9:	a1 08 50 80 00       	mov    0x805008,%eax
  8033de:	8b 40 78             	mov    0x78(%eax),%eax
  8033e1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8033e3:	a1 08 50 80 00       	mov    0x805008,%eax
  8033e8:	8b 40 70             	mov    0x70(%eax),%eax
  8033eb:	eb 14                	jmp    803401 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8033ed:	85 f6                	test   %esi,%esi
  8033ef:	74 06                	je     8033f7 <ipc_recv+0x57>
			*from_env_store = 0;
  8033f1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8033f7:	85 db                	test   %ebx,%ebx
  8033f9:	74 06                	je     803401 <ipc_recv+0x61>
			*perm_store = 0;
  8033fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  803401:	83 c4 10             	add    $0x10,%esp
  803404:	5b                   	pop    %ebx
  803405:	5e                   	pop    %esi
  803406:	5d                   	pop    %ebp
  803407:	c3                   	ret    

00803408 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
  80340b:	57                   	push   %edi
  80340c:	56                   	push   %esi
  80340d:	53                   	push   %ebx
  80340e:	83 ec 1c             	sub    $0x1c,%esp
  803411:	8b 7d 08             	mov    0x8(%ebp),%edi
  803414:	8b 75 0c             	mov    0xc(%ebp),%esi
  803417:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80341a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80341c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  803421:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  803424:	8b 45 14             	mov    0x14(%ebp),%eax
  803427:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80342b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80342f:	89 74 24 04          	mov    %esi,0x4(%esp)
  803433:	89 3c 24             	mov    %edi,(%esp)
  803436:	e8 5d df ff ff       	call   801398 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80343b:	85 c0                	test   %eax,%eax
  80343d:	74 28                	je     803467 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80343f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803442:	74 1c                	je     803460 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  803444:	c7 44 24 08 18 3f 80 	movl   $0x803f18,0x8(%esp)
  80344b:	00 
  80344c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  803453:	00 
  803454:	c7 04 24 3c 3f 80 00 	movl   $0x803f3c,(%esp)
  80345b:	e8 47 d1 ff ff       	call   8005a7 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  803460:	e8 01 dd ff ff       	call   801166 <sys_yield>
	}
  803465:	eb bd                	jmp    803424 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  803467:	83 c4 1c             	add    $0x1c,%esp
  80346a:	5b                   	pop    %ebx
  80346b:	5e                   	pop    %esi
  80346c:	5f                   	pop    %edi
  80346d:	5d                   	pop    %ebp
  80346e:	c3                   	ret    

0080346f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80346f:	55                   	push   %ebp
  803470:	89 e5                	mov    %esp,%ebp
  803472:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803475:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80347a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80347d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803483:	8b 52 50             	mov    0x50(%edx),%edx
  803486:	39 ca                	cmp    %ecx,%edx
  803488:	75 0d                	jne    803497 <ipc_find_env+0x28>
			return envs[i].env_id;
  80348a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80348d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  803492:	8b 40 40             	mov    0x40(%eax),%eax
  803495:	eb 0e                	jmp    8034a5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803497:	83 c0 01             	add    $0x1,%eax
  80349a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80349f:	75 d9                	jne    80347a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8034a1:	66 b8 00 00          	mov    $0x0,%ax
}
  8034a5:	5d                   	pop    %ebp
  8034a6:	c3                   	ret    

008034a7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
  8034aa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8034ad:	89 d0                	mov    %edx,%eax
  8034af:	c1 e8 16             	shr    $0x16,%eax
  8034b2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8034b9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8034be:	f6 c1 01             	test   $0x1,%cl
  8034c1:	74 1d                	je     8034e0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8034c3:	c1 ea 0c             	shr    $0xc,%edx
  8034c6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8034cd:	f6 c2 01             	test   $0x1,%dl
  8034d0:	74 0e                	je     8034e0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8034d2:	c1 ea 0c             	shr    $0xc,%edx
  8034d5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8034dc:	ef 
  8034dd:	0f b7 c0             	movzwl %ax,%eax
}
  8034e0:	5d                   	pop    %ebp
  8034e1:	c3                   	ret    
  8034e2:	66 90                	xchg   %ax,%ax
  8034e4:	66 90                	xchg   %ax,%ax
  8034e6:	66 90                	xchg   %ax,%ax
  8034e8:	66 90                	xchg   %ax,%ax
  8034ea:	66 90                	xchg   %ax,%ax
  8034ec:	66 90                	xchg   %ax,%ax
  8034ee:	66 90                	xchg   %ax,%ax

008034f0 <__udivdi3>:
  8034f0:	55                   	push   %ebp
  8034f1:	57                   	push   %edi
  8034f2:	56                   	push   %esi
  8034f3:	83 ec 0c             	sub    $0xc,%esp
  8034f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8034fa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8034fe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803502:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803506:	85 c0                	test   %eax,%eax
  803508:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80350c:	89 ea                	mov    %ebp,%edx
  80350e:	89 0c 24             	mov    %ecx,(%esp)
  803511:	75 2d                	jne    803540 <__udivdi3+0x50>
  803513:	39 e9                	cmp    %ebp,%ecx
  803515:	77 61                	ja     803578 <__udivdi3+0x88>
  803517:	85 c9                	test   %ecx,%ecx
  803519:	89 ce                	mov    %ecx,%esi
  80351b:	75 0b                	jne    803528 <__udivdi3+0x38>
  80351d:	b8 01 00 00 00       	mov    $0x1,%eax
  803522:	31 d2                	xor    %edx,%edx
  803524:	f7 f1                	div    %ecx
  803526:	89 c6                	mov    %eax,%esi
  803528:	31 d2                	xor    %edx,%edx
  80352a:	89 e8                	mov    %ebp,%eax
  80352c:	f7 f6                	div    %esi
  80352e:	89 c5                	mov    %eax,%ebp
  803530:	89 f8                	mov    %edi,%eax
  803532:	f7 f6                	div    %esi
  803534:	89 ea                	mov    %ebp,%edx
  803536:	83 c4 0c             	add    $0xc,%esp
  803539:	5e                   	pop    %esi
  80353a:	5f                   	pop    %edi
  80353b:	5d                   	pop    %ebp
  80353c:	c3                   	ret    
  80353d:	8d 76 00             	lea    0x0(%esi),%esi
  803540:	39 e8                	cmp    %ebp,%eax
  803542:	77 24                	ja     803568 <__udivdi3+0x78>
  803544:	0f bd e8             	bsr    %eax,%ebp
  803547:	83 f5 1f             	xor    $0x1f,%ebp
  80354a:	75 3c                	jne    803588 <__udivdi3+0x98>
  80354c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803550:	39 34 24             	cmp    %esi,(%esp)
  803553:	0f 86 9f 00 00 00    	jbe    8035f8 <__udivdi3+0x108>
  803559:	39 d0                	cmp    %edx,%eax
  80355b:	0f 82 97 00 00 00    	jb     8035f8 <__udivdi3+0x108>
  803561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803568:	31 d2                	xor    %edx,%edx
  80356a:	31 c0                	xor    %eax,%eax
  80356c:	83 c4 0c             	add    $0xc,%esp
  80356f:	5e                   	pop    %esi
  803570:	5f                   	pop    %edi
  803571:	5d                   	pop    %ebp
  803572:	c3                   	ret    
  803573:	90                   	nop
  803574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803578:	89 f8                	mov    %edi,%eax
  80357a:	f7 f1                	div    %ecx
  80357c:	31 d2                	xor    %edx,%edx
  80357e:	83 c4 0c             	add    $0xc,%esp
  803581:	5e                   	pop    %esi
  803582:	5f                   	pop    %edi
  803583:	5d                   	pop    %ebp
  803584:	c3                   	ret    
  803585:	8d 76 00             	lea    0x0(%esi),%esi
  803588:	89 e9                	mov    %ebp,%ecx
  80358a:	8b 3c 24             	mov    (%esp),%edi
  80358d:	d3 e0                	shl    %cl,%eax
  80358f:	89 c6                	mov    %eax,%esi
  803591:	b8 20 00 00 00       	mov    $0x20,%eax
  803596:	29 e8                	sub    %ebp,%eax
  803598:	89 c1                	mov    %eax,%ecx
  80359a:	d3 ef                	shr    %cl,%edi
  80359c:	89 e9                	mov    %ebp,%ecx
  80359e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8035a2:	8b 3c 24             	mov    (%esp),%edi
  8035a5:	09 74 24 08          	or     %esi,0x8(%esp)
  8035a9:	89 d6                	mov    %edx,%esi
  8035ab:	d3 e7                	shl    %cl,%edi
  8035ad:	89 c1                	mov    %eax,%ecx
  8035af:	89 3c 24             	mov    %edi,(%esp)
  8035b2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8035b6:	d3 ee                	shr    %cl,%esi
  8035b8:	89 e9                	mov    %ebp,%ecx
  8035ba:	d3 e2                	shl    %cl,%edx
  8035bc:	89 c1                	mov    %eax,%ecx
  8035be:	d3 ef                	shr    %cl,%edi
  8035c0:	09 d7                	or     %edx,%edi
  8035c2:	89 f2                	mov    %esi,%edx
  8035c4:	89 f8                	mov    %edi,%eax
  8035c6:	f7 74 24 08          	divl   0x8(%esp)
  8035ca:	89 d6                	mov    %edx,%esi
  8035cc:	89 c7                	mov    %eax,%edi
  8035ce:	f7 24 24             	mull   (%esp)
  8035d1:	39 d6                	cmp    %edx,%esi
  8035d3:	89 14 24             	mov    %edx,(%esp)
  8035d6:	72 30                	jb     803608 <__udivdi3+0x118>
  8035d8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035dc:	89 e9                	mov    %ebp,%ecx
  8035de:	d3 e2                	shl    %cl,%edx
  8035e0:	39 c2                	cmp    %eax,%edx
  8035e2:	73 05                	jae    8035e9 <__udivdi3+0xf9>
  8035e4:	3b 34 24             	cmp    (%esp),%esi
  8035e7:	74 1f                	je     803608 <__udivdi3+0x118>
  8035e9:	89 f8                	mov    %edi,%eax
  8035eb:	31 d2                	xor    %edx,%edx
  8035ed:	e9 7a ff ff ff       	jmp    80356c <__udivdi3+0x7c>
  8035f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8035f8:	31 d2                	xor    %edx,%edx
  8035fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ff:	e9 68 ff ff ff       	jmp    80356c <__udivdi3+0x7c>
  803604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803608:	8d 47 ff             	lea    -0x1(%edi),%eax
  80360b:	31 d2                	xor    %edx,%edx
  80360d:	83 c4 0c             	add    $0xc,%esp
  803610:	5e                   	pop    %esi
  803611:	5f                   	pop    %edi
  803612:	5d                   	pop    %ebp
  803613:	c3                   	ret    
  803614:	66 90                	xchg   %ax,%ax
  803616:	66 90                	xchg   %ax,%ax
  803618:	66 90                	xchg   %ax,%ax
  80361a:	66 90                	xchg   %ax,%ax
  80361c:	66 90                	xchg   %ax,%ax
  80361e:	66 90                	xchg   %ax,%ax

00803620 <__umoddi3>:
  803620:	55                   	push   %ebp
  803621:	57                   	push   %edi
  803622:	56                   	push   %esi
  803623:	83 ec 14             	sub    $0x14,%esp
  803626:	8b 44 24 28          	mov    0x28(%esp),%eax
  80362a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80362e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803632:	89 c7                	mov    %eax,%edi
  803634:	89 44 24 04          	mov    %eax,0x4(%esp)
  803638:	8b 44 24 30          	mov    0x30(%esp),%eax
  80363c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803640:	89 34 24             	mov    %esi,(%esp)
  803643:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803647:	85 c0                	test   %eax,%eax
  803649:	89 c2                	mov    %eax,%edx
  80364b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80364f:	75 17                	jne    803668 <__umoddi3+0x48>
  803651:	39 fe                	cmp    %edi,%esi
  803653:	76 4b                	jbe    8036a0 <__umoddi3+0x80>
  803655:	89 c8                	mov    %ecx,%eax
  803657:	89 fa                	mov    %edi,%edx
  803659:	f7 f6                	div    %esi
  80365b:	89 d0                	mov    %edx,%eax
  80365d:	31 d2                	xor    %edx,%edx
  80365f:	83 c4 14             	add    $0x14,%esp
  803662:	5e                   	pop    %esi
  803663:	5f                   	pop    %edi
  803664:	5d                   	pop    %ebp
  803665:	c3                   	ret    
  803666:	66 90                	xchg   %ax,%ax
  803668:	39 f8                	cmp    %edi,%eax
  80366a:	77 54                	ja     8036c0 <__umoddi3+0xa0>
  80366c:	0f bd e8             	bsr    %eax,%ebp
  80366f:	83 f5 1f             	xor    $0x1f,%ebp
  803672:	75 5c                	jne    8036d0 <__umoddi3+0xb0>
  803674:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803678:	39 3c 24             	cmp    %edi,(%esp)
  80367b:	0f 87 e7 00 00 00    	ja     803768 <__umoddi3+0x148>
  803681:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803685:	29 f1                	sub    %esi,%ecx
  803687:	19 c7                	sbb    %eax,%edi
  803689:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80368d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803691:	8b 44 24 08          	mov    0x8(%esp),%eax
  803695:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803699:	83 c4 14             	add    $0x14,%esp
  80369c:	5e                   	pop    %esi
  80369d:	5f                   	pop    %edi
  80369e:	5d                   	pop    %ebp
  80369f:	c3                   	ret    
  8036a0:	85 f6                	test   %esi,%esi
  8036a2:	89 f5                	mov    %esi,%ebp
  8036a4:	75 0b                	jne    8036b1 <__umoddi3+0x91>
  8036a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ab:	31 d2                	xor    %edx,%edx
  8036ad:	f7 f6                	div    %esi
  8036af:	89 c5                	mov    %eax,%ebp
  8036b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036b5:	31 d2                	xor    %edx,%edx
  8036b7:	f7 f5                	div    %ebp
  8036b9:	89 c8                	mov    %ecx,%eax
  8036bb:	f7 f5                	div    %ebp
  8036bd:	eb 9c                	jmp    80365b <__umoddi3+0x3b>
  8036bf:	90                   	nop
  8036c0:	89 c8                	mov    %ecx,%eax
  8036c2:	89 fa                	mov    %edi,%edx
  8036c4:	83 c4 14             	add    $0x14,%esp
  8036c7:	5e                   	pop    %esi
  8036c8:	5f                   	pop    %edi
  8036c9:	5d                   	pop    %ebp
  8036ca:	c3                   	ret    
  8036cb:	90                   	nop
  8036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8036d0:	8b 04 24             	mov    (%esp),%eax
  8036d3:	be 20 00 00 00       	mov    $0x20,%esi
  8036d8:	89 e9                	mov    %ebp,%ecx
  8036da:	29 ee                	sub    %ebp,%esi
  8036dc:	d3 e2                	shl    %cl,%edx
  8036de:	89 f1                	mov    %esi,%ecx
  8036e0:	d3 e8                	shr    %cl,%eax
  8036e2:	89 e9                	mov    %ebp,%ecx
  8036e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036e8:	8b 04 24             	mov    (%esp),%eax
  8036eb:	09 54 24 04          	or     %edx,0x4(%esp)
  8036ef:	89 fa                	mov    %edi,%edx
  8036f1:	d3 e0                	shl    %cl,%eax
  8036f3:	89 f1                	mov    %esi,%ecx
  8036f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8036f9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8036fd:	d3 ea                	shr    %cl,%edx
  8036ff:	89 e9                	mov    %ebp,%ecx
  803701:	d3 e7                	shl    %cl,%edi
  803703:	89 f1                	mov    %esi,%ecx
  803705:	d3 e8                	shr    %cl,%eax
  803707:	89 e9                	mov    %ebp,%ecx
  803709:	09 f8                	or     %edi,%eax
  80370b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80370f:	f7 74 24 04          	divl   0x4(%esp)
  803713:	d3 e7                	shl    %cl,%edi
  803715:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803719:	89 d7                	mov    %edx,%edi
  80371b:	f7 64 24 08          	mull   0x8(%esp)
  80371f:	39 d7                	cmp    %edx,%edi
  803721:	89 c1                	mov    %eax,%ecx
  803723:	89 14 24             	mov    %edx,(%esp)
  803726:	72 2c                	jb     803754 <__umoddi3+0x134>
  803728:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80372c:	72 22                	jb     803750 <__umoddi3+0x130>
  80372e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803732:	29 c8                	sub    %ecx,%eax
  803734:	19 d7                	sbb    %edx,%edi
  803736:	89 e9                	mov    %ebp,%ecx
  803738:	89 fa                	mov    %edi,%edx
  80373a:	d3 e8                	shr    %cl,%eax
  80373c:	89 f1                	mov    %esi,%ecx
  80373e:	d3 e2                	shl    %cl,%edx
  803740:	89 e9                	mov    %ebp,%ecx
  803742:	d3 ef                	shr    %cl,%edi
  803744:	09 d0                	or     %edx,%eax
  803746:	89 fa                	mov    %edi,%edx
  803748:	83 c4 14             	add    $0x14,%esp
  80374b:	5e                   	pop    %esi
  80374c:	5f                   	pop    %edi
  80374d:	5d                   	pop    %ebp
  80374e:	c3                   	ret    
  80374f:	90                   	nop
  803750:	39 d7                	cmp    %edx,%edi
  803752:	75 da                	jne    80372e <__umoddi3+0x10e>
  803754:	8b 14 24             	mov    (%esp),%edx
  803757:	89 c1                	mov    %eax,%ecx
  803759:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80375d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803761:	eb cb                	jmp    80372e <__umoddi3+0x10e>
  803763:	90                   	nop
  803764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803768:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80376c:	0f 82 0f ff ff ff    	jb     803681 <__umoddi3+0x61>
  803772:	e9 1a ff ff ff       	jmp    803691 <__umoddi3+0x71>
