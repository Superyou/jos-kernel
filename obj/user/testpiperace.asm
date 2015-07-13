
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 ed 01 00 00       	call   80021e <libmain>
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
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800048:	c7 04 24 00 2f 80 00 	movl   $0x802f00,(%esp)
  80004f:	e8 24 03 00 00       	call   800378 <cprintf>
	if ((r = pipe(p)) < 0)
  800054:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800057:	89 04 24             	mov    %eax,(%esp)
  80005a:	e8 05 28 00 00       	call   802864 <pipe>
  80005f:	85 c0                	test   %eax,%eax
  800061:	79 20                	jns    800083 <umain+0x43>
		panic("pipe: %e", r);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 19 2f 80 	movl   $0x802f19,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 22 2f 80 00 	movl   $0x802f22,(%esp)
  80007e:	e8 fc 01 00 00       	call   80027f <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800083:	e8 f7 12 00 00       	call   80137f <fork>
  800088:	89 c6                	mov    %eax,%esi
  80008a:	85 c0                	test   %eax,%eax
  80008c:	79 20                	jns    8000ae <umain+0x6e>
		panic("fork: %e", r);
  80008e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800092:	c7 44 24 08 36 2f 80 	movl   $0x802f36,0x8(%esp)
  800099:	00 
  80009a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  8000a1:	00 
  8000a2:	c7 04 24 22 2f 80 00 	movl   $0x802f22,(%esp)
  8000a9:	e8 d1 01 00 00       	call   80027f <_panic>
	if (r == 0) {
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 56                	jne    800108 <umain+0xc8>
		close(p[1]);
  8000b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b5:	89 04 24             	mov    %eax,(%esp)
  8000b8:	e8 1a 19 00 00       	call   8019d7 <close>
  8000bd:	bb c8 00 00 00       	mov    $0xc8,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	89 04 24             	mov    %eax,(%esp)
  8000c8:	e8 08 29 00 00       	call   8029d5 <pipeisclosed>
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	74 11                	je     8000e2 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000d1:	c7 04 24 3f 2f 80 00 	movl   $0x802f3f,(%esp)
  8000d8:	e8 9b 02 00 00       	call   800378 <cprintf>
				exit();
  8000dd:	e8 84 01 00 00       	call   800266 <exit>
			}
			sys_yield();
  8000e2:	e8 5f 0d 00 00       	call   800e46 <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000e7:	83 eb 01             	sub    $0x1,%ebx
  8000ea:	75 d6                	jne    8000c2 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000f3:	00 
  8000f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fb:	00 
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 18 16 00 00       	call   801720 <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800108:	89 74 24 04          	mov    %esi,0x4(%esp)
  80010c:	c7 04 24 5a 2f 80 00 	movl   $0x802f5a,(%esp)
  800113:	e8 60 02 00 00       	call   800378 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800118:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80011e:	6b f6 7c             	imul   $0x7c,%esi,%esi
	cprintf("kid is %d\n", kid-envs);
  800121:	8d 9e 00 00 c0 ee    	lea    -0x11400000(%esi),%ebx
  800127:	c1 ee 02             	shr    $0x2,%esi
  80012a:	69 f6 df 7b ef bd    	imul   $0xbdef7bdf,%esi,%esi
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	c7 04 24 65 2f 80 00 	movl   $0x802f65,(%esp)
  80013b:	e8 38 02 00 00       	call   800378 <cprintf>
	dup(p[0], 10);
  800140:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800147:	00 
  800148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80014b:	89 04 24             	mov    %eax,(%esp)
  80014e:	e8 d9 18 00 00       	call   801a2c <dup>
	while (kid->env_status == ENV_RUNNABLE)
  800153:	eb 13                	jmp    800168 <umain+0x128>
		dup(p[0], 10);
  800155:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  80015c:	00 
  80015d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800160:	89 04 24             	mov    %eax,(%esp)
  800163:	e8 c4 18 00 00       	call   801a2c <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800168:	8b 43 54             	mov    0x54(%ebx),%eax
  80016b:	83 f8 02             	cmp    $0x2,%eax
  80016e:	74 e5                	je     800155 <umain+0x115>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800170:	c7 04 24 70 2f 80 00 	movl   $0x802f70,(%esp)
  800177:	e8 fc 01 00 00       	call   800378 <cprintf>
	if (pipeisclosed(p[0]))
  80017c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 4e 28 00 00       	call   8029d5 <pipeisclosed>
  800187:	85 c0                	test   %eax,%eax
  800189:	74 1c                	je     8001a7 <umain+0x167>
		panic("somehow the other end of p[0] got closed!");
  80018b:	c7 44 24 08 cc 2f 80 	movl   $0x802fcc,0x8(%esp)
  800192:	00 
  800193:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  80019a:	00 
  80019b:	c7 04 24 22 2f 80 00 	movl   $0x802f22,(%esp)
  8001a2:	e8 d8 00 00 00       	call   80027f <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b1:	89 04 24             	mov    %eax,(%esp)
  8001b4:	e8 ed 16 00 00       	call   8018a6 <fd_lookup>
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	79 20                	jns    8001dd <umain+0x19d>
		panic("cannot look up p[0]: %e", r);
  8001bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c1:	c7 44 24 08 86 2f 80 	movl   $0x802f86,0x8(%esp)
  8001c8:	00 
  8001c9:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001d0:	00 
  8001d1:	c7 04 24 22 2f 80 00 	movl   $0x802f22,(%esp)
  8001d8:	e8 a2 00 00 00       	call   80027f <_panic>
	va = fd2data(fd);
  8001dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e0:	89 04 24             	mov    %eax,(%esp)
  8001e3:	e8 58 16 00 00       	call   801840 <fd2data>
	if (pageref(va) != 3+1)
  8001e8:	89 04 24             	mov    %eax,(%esp)
  8001eb:	e8 52 1f 00 00       	call   802142 <pageref>
  8001f0:	83 f8 04             	cmp    $0x4,%eax
  8001f3:	74 0e                	je     800203 <umain+0x1c3>
		cprintf("\nchild detected race\n");
  8001f5:	c7 04 24 9e 2f 80 00 	movl   $0x802f9e,(%esp)
  8001fc:	e8 77 01 00 00       	call   800378 <cprintf>
  800201:	eb 14                	jmp    800217 <umain+0x1d7>
	else
		cprintf("\nrace didn't happen\n", max);
  800203:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  80020a:	00 
  80020b:	c7 04 24 b4 2f 80 00 	movl   $0x802fb4,(%esp)
  800212:	e8 61 01 00 00       	call   800378 <cprintf>
}
  800217:	83 c4 20             	add    $0x20,%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 10             	sub    $0x10,%esp
  800226:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800229:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80022c:	e8 f6 0b 00 00       	call   800e27 <sys_getenvid>
  800231:	25 ff 03 00 00       	and    $0x3ff,%eax
  800236:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800239:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80023e:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800243:	85 db                	test   %ebx,%ebx
  800245:	7e 07                	jle    80024e <libmain+0x30>
		binaryname = argv[0];
  800247:	8b 06                	mov    (%esi),%eax
  800249:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80024e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800252:	89 1c 24             	mov    %ebx,(%esp)
  800255:	e8 e6 fd ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  80025a:	e8 07 00 00 00       	call   800266 <exit>
}
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	5b                   	pop    %ebx
  800263:	5e                   	pop    %esi
  800264:	5d                   	pop    %ebp
  800265:	c3                   	ret    

00800266 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80026c:	e8 99 17 00 00       	call   801a0a <close_all>
	sys_env_destroy(0);
  800271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800278:	e8 06 0b 00 00       	call   800d83 <sys_env_destroy>
}
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800287:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80028a:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800290:	e8 92 0b 00 00       	call   800e27 <sys_getenvid>
  800295:	8b 55 0c             	mov    0xc(%ebp),%edx
  800298:	89 54 24 10          	mov    %edx,0x10(%esp)
  80029c:	8b 55 08             	mov    0x8(%ebp),%edx
  80029f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ab:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8002b2:	e8 c1 00 00 00       	call   800378 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002be:	89 04 24             	mov    %eax,(%esp)
  8002c1:	e8 51 00 00 00       	call   800317 <vcprintf>
	cprintf("\n");
  8002c6:	c7 04 24 17 2f 80 00 	movl   $0x802f17,(%esp)
  8002cd:	e8 a6 00 00 00       	call   800378 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d2:	cc                   	int3   
  8002d3:	eb fd                	jmp    8002d2 <_panic+0x53>

008002d5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	53                   	push   %ebx
  8002d9:	83 ec 14             	sub    $0x14,%esp
  8002dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002df:	8b 13                	mov    (%ebx),%edx
  8002e1:	8d 42 01             	lea    0x1(%edx),%eax
  8002e4:	89 03                	mov    %eax,(%ebx)
  8002e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f2:	75 19                	jne    80030d <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002f4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002fb:	00 
  8002fc:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ff:	89 04 24             	mov    %eax,(%esp)
  800302:	e8 3f 0a 00 00       	call   800d46 <sys_cputs>
		b->idx = 0;
  800307:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80030d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800311:	83 c4 14             	add    $0x14,%esp
  800314:	5b                   	pop    %ebx
  800315:	5d                   	pop    %ebp
  800316:	c3                   	ret    

00800317 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800320:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800327:	00 00 00 
	b.cnt = 0;
  80032a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800331:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800334:	8b 45 0c             	mov    0xc(%ebp),%eax
  800337:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800342:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034c:	c7 04 24 d5 02 80 00 	movl   $0x8002d5,(%esp)
  800353:	e8 7c 01 00 00       	call   8004d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800358:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80035e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800362:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	e8 d6 09 00 00       	call   800d46 <sys_cputs>

	return b.cnt;
}
  800370:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80037e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800381:	89 44 24 04          	mov    %eax,0x4(%esp)
  800385:	8b 45 08             	mov    0x8(%ebp),%eax
  800388:	89 04 24             	mov    %eax,(%esp)
  80038b:	e8 87 ff ff ff       	call   800317 <vcprintf>
	va_end(ap);

	return cnt;
}
  800390:	c9                   	leave  
  800391:	c3                   	ret    
  800392:	66 90                	xchg   %ax,%ax
  800394:	66 90                	xchg   %ax,%ax
  800396:	66 90                	xchg   %ax,%ax
  800398:	66 90                	xchg   %ax,%ax
  80039a:	66 90                	xchg   %ax,%ax
  80039c:	66 90                	xchg   %ax,%ax
  80039e:	66 90                	xchg   %ax,%ax

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 3c             	sub    $0x3c,%esp
  8003a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ac:	89 d7                	mov    %edx,%edi
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	89 c3                	mov    %eax,%ebx
  8003b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003cd:	39 d9                	cmp    %ebx,%ecx
  8003cf:	72 05                	jb     8003d6 <printnum+0x36>
  8003d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d4:	77 69                	ja     80043f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003dd:	83 ee 01             	sub    $0x1,%esi
  8003e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003f0:	89 c3                	mov    %eax,%ebx
  8003f2:	89 d6                	mov    %edx,%esi
  8003f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 5c 28 00 00       	call   802c70 <__udivdi3>
  800414:	89 d9                	mov    %ebx,%ecx
  800416:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80041a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80041e:	89 04 24             	mov    %eax,(%esp)
  800421:	89 54 24 04          	mov    %edx,0x4(%esp)
  800425:	89 fa                	mov    %edi,%edx
  800427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80042a:	e8 71 ff ff ff       	call   8003a0 <printnum>
  80042f:	eb 1b                	jmp    80044c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800431:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800435:	8b 45 18             	mov    0x18(%ebp),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	ff d3                	call   *%ebx
  80043d:	eb 03                	jmp    800442 <printnum+0xa2>
  80043f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800442:	83 ee 01             	sub    $0x1,%esi
  800445:	85 f6                	test   %esi,%esi
  800447:	7f e8                	jg     800431 <printnum+0x91>
  800449:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80044c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800450:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800457:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80045a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80045e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800465:	89 04 24             	mov    %eax,(%esp)
  800468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046f:	e8 2c 29 00 00       	call   802da0 <__umoddi3>
  800474:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800478:	0f be 80 23 30 80 00 	movsbl 0x803023(%eax),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800485:	ff d0                	call   *%eax
}
  800487:	83 c4 3c             	add    $0x3c,%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    

0080048f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800495:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800499:	8b 10                	mov    (%eax),%edx
  80049b:	3b 50 04             	cmp    0x4(%eax),%edx
  80049e:	73 0a                	jae    8004aa <sprintputch+0x1b>
		*b->buf++ = ch;
  8004a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004a3:	89 08                	mov    %ecx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	88 02                	mov    %al,(%edx)
}
  8004aa:	5d                   	pop    %ebp
  8004ab:	c3                   	ret    

008004ac <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004b2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	89 04 24             	mov    %eax,(%esp)
  8004cd:	e8 02 00 00 00       	call   8004d4 <vprintfmt>
	va_end(ap);
}
  8004d2:	c9                   	leave  
  8004d3:	c3                   	ret    

008004d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	57                   	push   %edi
  8004d8:	56                   	push   %esi
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 3c             	sub    $0x3c,%esp
  8004dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004e0:	eb 17                	jmp    8004f9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8004e2:	85 c0                	test   %eax,%eax
  8004e4:	0f 84 4b 04 00 00    	je     800935 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8004ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004f1:	89 04 24             	mov    %eax,(%esp)
  8004f4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8004f7:	89 fb                	mov    %edi,%ebx
  8004f9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8004fc:	0f b6 03             	movzbl (%ebx),%eax
  8004ff:	83 f8 25             	cmp    $0x25,%eax
  800502:	75 de                	jne    8004e2 <vprintfmt+0xe>
  800504:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800508:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80050f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800514:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80051b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800520:	eb 18                	jmp    80053a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800522:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800524:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800528:	eb 10                	jmp    80053a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80052c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800530:	eb 08                	jmp    80053a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800532:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800535:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80053d:	0f b6 17             	movzbl (%edi),%edx
  800540:	0f b6 c2             	movzbl %dl,%eax
  800543:	83 ea 23             	sub    $0x23,%edx
  800546:	80 fa 55             	cmp    $0x55,%dl
  800549:	0f 87 c2 03 00 00    	ja     800911 <vprintfmt+0x43d>
  80054f:	0f b6 d2             	movzbl %dl,%edx
  800552:	ff 24 95 60 31 80 00 	jmp    *0x803160(,%edx,4)
  800559:	89 df                	mov    %ebx,%edi
  80055b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800560:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800563:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800567:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80056a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80056d:	83 fa 09             	cmp    $0x9,%edx
  800570:	77 33                	ja     8005a5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800572:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800575:	eb e9                	jmp    800560 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 30                	mov    (%eax),%esi
  80057c:	8d 40 04             	lea    0x4(%eax),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800582:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800584:	eb 1f                	jmp    8005a5 <vprintfmt+0xd1>
  800586:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800589:	85 ff                	test   %edi,%edi
  80058b:	b8 00 00 00 00       	mov    $0x0,%eax
  800590:	0f 49 c7             	cmovns %edi,%eax
  800593:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800596:	89 df                	mov    %ebx,%edi
  800598:	eb a0                	jmp    80053a <vprintfmt+0x66>
  80059a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80059c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8005a3:	eb 95                	jmp    80053a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8005a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a9:	79 8f                	jns    80053a <vprintfmt+0x66>
  8005ab:	eb 85                	jmp    800532 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ad:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005b2:	eb 86                	jmp    80053a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 70 04             	lea    0x4(%eax),%esi
  8005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	89 04 24             	mov    %eax,(%esp)
  8005c9:	ff 55 08             	call   *0x8(%ebp)
  8005cc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8005cf:	e9 25 ff ff ff       	jmp    8004f9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8d 70 04             	lea    0x4(%eax),%esi
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	99                   	cltd   
  8005dd:	31 d0                	xor    %edx,%eax
  8005df:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e1:	83 f8 15             	cmp    $0x15,%eax
  8005e4:	7f 0b                	jg     8005f1 <vprintfmt+0x11d>
  8005e6:	8b 14 85 c0 32 80 00 	mov    0x8032c0(,%eax,4),%edx
  8005ed:	85 d2                	test   %edx,%edx
  8005ef:	75 26                	jne    800617 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8005f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005f5:	c7 44 24 08 3b 30 80 	movl   $0x80303b,0x8(%esp)
  8005fc:	00 
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	89 44 24 04          	mov    %eax,0x4(%esp)
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	89 04 24             	mov    %eax,(%esp)
  80060a:	e8 9d fe ff ff       	call   8004ac <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80060f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800612:	e9 e2 fe ff ff       	jmp    8004f9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800617:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80061b:	c7 44 24 08 0a 35 80 	movl   $0x80350a,0x8(%esp)
  800622:	00 
  800623:	8b 45 0c             	mov    0xc(%ebp),%eax
  800626:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	89 04 24             	mov    %eax,(%esp)
  800630:	e8 77 fe ff ff       	call   8004ac <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800635:	89 75 14             	mov    %esi,0x14(%ebp)
  800638:	e9 bc fe ff ff       	jmp    8004f9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800643:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800646:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80064a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80064c:	85 ff                	test   %edi,%edi
  80064e:	b8 34 30 80 00       	mov    $0x803034,%eax
  800653:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800656:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80065a:	0f 84 94 00 00 00    	je     8006f4 <vprintfmt+0x220>
  800660:	85 c9                	test   %ecx,%ecx
  800662:	0f 8e 94 00 00 00    	jle    8006fc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800668:	89 74 24 04          	mov    %esi,0x4(%esp)
  80066c:	89 3c 24             	mov    %edi,(%esp)
  80066f:	e8 64 03 00 00       	call   8009d8 <strnlen>
  800674:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800677:	29 c1                	sub    %eax,%ecx
  800679:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80067c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800680:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800683:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800686:	8b 75 08             	mov    0x8(%ebp),%esi
  800689:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80068c:	89 cb                	mov    %ecx,%ebx
  80068e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800690:	eb 0f                	jmp    8006a1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800692:	8b 45 0c             	mov    0xc(%ebp),%eax
  800695:	89 44 24 04          	mov    %eax,0x4(%esp)
  800699:	89 3c 24             	mov    %edi,(%esp)
  80069c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069e:	83 eb 01             	sub    $0x1,%ebx
  8006a1:	85 db                	test   %ebx,%ebx
  8006a3:	7f ed                	jg     800692 <vprintfmt+0x1be>
  8006a5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006ae:	85 c9                	test   %ecx,%ecx
  8006b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b5:	0f 49 c1             	cmovns %ecx,%eax
  8006b8:	29 c1                	sub    %eax,%ecx
  8006ba:	89 cb                	mov    %ecx,%ebx
  8006bc:	eb 44                	jmp    800702 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c2:	74 1e                	je     8006e2 <vprintfmt+0x20e>
  8006c4:	0f be d2             	movsbl %dl,%edx
  8006c7:	83 ea 20             	sub    $0x20,%edx
  8006ca:	83 fa 5e             	cmp    $0x5e,%edx
  8006cd:	76 13                	jbe    8006e2 <vprintfmt+0x20e>
					putch('?', putdat);
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006d6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006dd:	ff 55 08             	call   *0x8(%ebp)
  8006e0:	eb 0d                	jmp    8006ef <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8006e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006e5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006e9:	89 04 24             	mov    %eax,(%esp)
  8006ec:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ef:	83 eb 01             	sub    $0x1,%ebx
  8006f2:	eb 0e                	jmp    800702 <vprintfmt+0x22e>
  8006f4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006fa:	eb 06                	jmp    800702 <vprintfmt+0x22e>
  8006fc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006ff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800702:	83 c7 01             	add    $0x1,%edi
  800705:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800709:	0f be c2             	movsbl %dl,%eax
  80070c:	85 c0                	test   %eax,%eax
  80070e:	74 27                	je     800737 <vprintfmt+0x263>
  800710:	85 f6                	test   %esi,%esi
  800712:	78 aa                	js     8006be <vprintfmt+0x1ea>
  800714:	83 ee 01             	sub    $0x1,%esi
  800717:	79 a5                	jns    8006be <vprintfmt+0x1ea>
  800719:	89 d8                	mov    %ebx,%eax
  80071b:	8b 75 08             	mov    0x8(%ebp),%esi
  80071e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800721:	89 c3                	mov    %eax,%ebx
  800723:	eb 18                	jmp    80073d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800725:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800729:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800730:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800732:	83 eb 01             	sub    $0x1,%ebx
  800735:	eb 06                	jmp    80073d <vprintfmt+0x269>
  800737:	8b 75 08             	mov    0x8(%ebp),%esi
  80073a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80073d:	85 db                	test   %ebx,%ebx
  80073f:	7f e4                	jg     800725 <vprintfmt+0x251>
  800741:	89 75 08             	mov    %esi,0x8(%ebp)
  800744:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800747:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80074a:	e9 aa fd ff ff       	jmp    8004f9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80074f:	83 f9 01             	cmp    $0x1,%ecx
  800752:	7e 10                	jle    800764 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8b 30                	mov    (%eax),%esi
  800759:	8b 78 04             	mov    0x4(%eax),%edi
  80075c:	8d 40 08             	lea    0x8(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	eb 26                	jmp    80078a <vprintfmt+0x2b6>
	else if (lflag)
  800764:	85 c9                	test   %ecx,%ecx
  800766:	74 12                	je     80077a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 30                	mov    (%eax),%esi
  80076d:	89 f7                	mov    %esi,%edi
  80076f:	c1 ff 1f             	sar    $0x1f,%edi
  800772:	8d 40 04             	lea    0x4(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
  800778:	eb 10                	jmp    80078a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 30                	mov    (%eax),%esi
  80077f:	89 f7                	mov    %esi,%edi
  800781:	c1 ff 1f             	sar    $0x1f,%edi
  800784:	8d 40 04             	lea    0x4(%eax),%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80078a:	89 f0                	mov    %esi,%eax
  80078c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80078e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800793:	85 ff                	test   %edi,%edi
  800795:	0f 89 3a 01 00 00    	jns    8008d5 <vprintfmt+0x401>
				putch('-', putdat);
  80079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007a9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007ac:	89 f0                	mov    %esi,%eax
  8007ae:	89 fa                	mov    %edi,%edx
  8007b0:	f7 d8                	neg    %eax
  8007b2:	83 d2 00             	adc    $0x0,%edx
  8007b5:	f7 da                	neg    %edx
			}
			base = 10;
  8007b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007bc:	e9 14 01 00 00       	jmp    8008d5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007c1:	83 f9 01             	cmp    $0x1,%ecx
  8007c4:	7e 13                	jle    8007d9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 50 04             	mov    0x4(%eax),%edx
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	8b 75 14             	mov    0x14(%ebp),%esi
  8007d1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007d4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007d7:	eb 2c                	jmp    800805 <vprintfmt+0x331>
	else if (lflag)
  8007d9:	85 c9                	test   %ecx,%ecx
  8007db:	74 15                	je     8007f2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	8b 75 14             	mov    0x14(%ebp),%esi
  8007ea:	8d 76 04             	lea    0x4(%esi),%esi
  8007ed:	89 75 14             	mov    %esi,0x14(%ebp)
  8007f0:	eb 13                	jmp    800805 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fc:	8b 75 14             	mov    0x14(%ebp),%esi
  8007ff:	8d 76 04             	lea    0x4(%esi),%esi
  800802:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800805:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80080a:	e9 c6 00 00 00       	jmp    8008d5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80080f:	83 f9 01             	cmp    $0x1,%ecx
  800812:	7e 13                	jle    800827 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 50 04             	mov    0x4(%eax),%edx
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	8b 75 14             	mov    0x14(%ebp),%esi
  80081f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800822:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800825:	eb 24                	jmp    80084b <vprintfmt+0x377>
	else if (lflag)
  800827:	85 c9                	test   %ecx,%ecx
  800829:	74 11                	je     80083c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	99                   	cltd   
  800831:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800834:	8d 71 04             	lea    0x4(%ecx),%esi
  800837:	89 75 14             	mov    %esi,0x14(%ebp)
  80083a:	eb 0f                	jmp    80084b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	99                   	cltd   
  800842:	8b 75 14             	mov    0x14(%ebp),%esi
  800845:	8d 76 04             	lea    0x4(%esi),%esi
  800848:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80084b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800850:	e9 80 00 00 00       	jmp    8008d5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800855:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800866:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800870:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800877:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80087a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80087e:	8b 06                	mov    (%esi),%eax
  800880:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800885:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80088a:	eb 49                	jmp    8008d5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80088c:	83 f9 01             	cmp    $0x1,%ecx
  80088f:	7e 13                	jle    8008a4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8b 50 04             	mov    0x4(%eax),%edx
  800897:	8b 00                	mov    (%eax),%eax
  800899:	8b 75 14             	mov    0x14(%ebp),%esi
  80089c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80089f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008a2:	eb 2c                	jmp    8008d0 <vprintfmt+0x3fc>
	else if (lflag)
  8008a4:	85 c9                	test   %ecx,%ecx
  8008a6:	74 15                	je     8008bd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008b5:	8d 71 04             	lea    0x4(%ecx),%esi
  8008b8:	89 75 14             	mov    %esi,0x14(%ebp)
  8008bb:	eb 13                	jmp    8008d0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c7:	8b 75 14             	mov    0x14(%ebp),%esi
  8008ca:	8d 76 04             	lea    0x4(%esi),%esi
  8008cd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8008d0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008d5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8008d9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8008dd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8008e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008e8:	89 04 24             	mov    %eax,(%esp)
  8008eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	e8 a6 fa ff ff       	call   8003a0 <printnum>
			break;
  8008fa:	e9 fa fb ff ff       	jmp    8004f9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800902:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800906:	89 04 24             	mov    %eax,(%esp)
  800909:	ff 55 08             	call   *0x8(%ebp)
			break;
  80090c:	e9 e8 fb ff ff       	jmp    8004f9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800911:	8b 45 0c             	mov    0xc(%ebp),%eax
  800914:	89 44 24 04          	mov    %eax,0x4(%esp)
  800918:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80091f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800922:	89 fb                	mov    %edi,%ebx
  800924:	eb 03                	jmp    800929 <vprintfmt+0x455>
  800926:	83 eb 01             	sub    $0x1,%ebx
  800929:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80092d:	75 f7                	jne    800926 <vprintfmt+0x452>
  80092f:	90                   	nop
  800930:	e9 c4 fb ff ff       	jmp    8004f9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800935:	83 c4 3c             	add    $0x3c,%esp
  800938:	5b                   	pop    %ebx
  800939:	5e                   	pop    %esi
  80093a:	5f                   	pop    %edi
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	83 ec 28             	sub    $0x28,%esp
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800949:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800950:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800953:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80095a:	85 c0                	test   %eax,%eax
  80095c:	74 30                	je     80098e <vsnprintf+0x51>
  80095e:	85 d2                	test   %edx,%edx
  800960:	7e 2c                	jle    80098e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800969:	8b 45 10             	mov    0x10(%ebp),%eax
  80096c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800970:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800973:	89 44 24 04          	mov    %eax,0x4(%esp)
  800977:	c7 04 24 8f 04 80 00 	movl   $0x80048f,(%esp)
  80097e:	e8 51 fb ff ff       	call   8004d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800986:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098c:	eb 05                	jmp    800993 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80098e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80099b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	89 04 24             	mov    %eax,(%esp)
  8009b6:	e8 82 ff ff ff       	call   80093d <vsnprintf>
	va_end(ap);

	return rc;
}
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    
  8009bd:	66 90                	xchg   %ax,%ax
  8009bf:	90                   	nop

008009c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	eb 03                	jmp    8009d0 <strlen+0x10>
		n++;
  8009cd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009d4:	75 f7                	jne    8009cd <strlen+0xd>
		n++;
	return n;
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e6:	eb 03                	jmp    8009eb <strnlen+0x13>
		n++;
  8009e8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009eb:	39 d0                	cmp    %edx,%eax
  8009ed:	74 06                	je     8009f5 <strnlen+0x1d>
  8009ef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009f3:	75 f3                	jne    8009e8 <strnlen+0x10>
		n++;
	return n;
}
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	53                   	push   %ebx
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a01:	89 c2                	mov    %eax,%edx
  800a03:	83 c2 01             	add    $0x1,%edx
  800a06:	83 c1 01             	add    $0x1,%ecx
  800a09:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a0d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a10:	84 db                	test   %bl,%bl
  800a12:	75 ef                	jne    800a03 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a14:	5b                   	pop    %ebx
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	53                   	push   %ebx
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a21:	89 1c 24             	mov    %ebx,(%esp)
  800a24:	e8 97 ff ff ff       	call   8009c0 <strlen>
	strcpy(dst + len, src);
  800a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a30:	01 d8                	add    %ebx,%eax
  800a32:	89 04 24             	mov    %eax,(%esp)
  800a35:	e8 bd ff ff ff       	call   8009f7 <strcpy>
	return dst;
}
  800a3a:	89 d8                	mov    %ebx,%eax
  800a3c:	83 c4 08             	add    $0x8,%esp
  800a3f:	5b                   	pop    %ebx
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	56                   	push   %esi
  800a46:	53                   	push   %ebx
  800a47:	8b 75 08             	mov    0x8(%ebp),%esi
  800a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4d:	89 f3                	mov    %esi,%ebx
  800a4f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a52:	89 f2                	mov    %esi,%edx
  800a54:	eb 0f                	jmp    800a65 <strncpy+0x23>
		*dst++ = *src;
  800a56:	83 c2 01             	add    $0x1,%edx
  800a59:	0f b6 01             	movzbl (%ecx),%eax
  800a5c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a5f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a62:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a65:	39 da                	cmp    %ebx,%edx
  800a67:	75 ed                	jne    800a56 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a69:	89 f0                	mov    %esi,%eax
  800a6b:	5b                   	pop    %ebx
  800a6c:	5e                   	pop    %esi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	8b 75 08             	mov    0x8(%ebp),%esi
  800a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a7d:	89 f0                	mov    %esi,%eax
  800a7f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a83:	85 c9                	test   %ecx,%ecx
  800a85:	75 0b                	jne    800a92 <strlcpy+0x23>
  800a87:	eb 1d                	jmp    800aa6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	83 c2 01             	add    $0x1,%edx
  800a8f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a92:	39 d8                	cmp    %ebx,%eax
  800a94:	74 0b                	je     800aa1 <strlcpy+0x32>
  800a96:	0f b6 0a             	movzbl (%edx),%ecx
  800a99:	84 c9                	test   %cl,%cl
  800a9b:	75 ec                	jne    800a89 <strlcpy+0x1a>
  800a9d:	89 c2                	mov    %eax,%edx
  800a9f:	eb 02                	jmp    800aa3 <strlcpy+0x34>
  800aa1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800aa3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800aa6:	29 f0                	sub    %esi,%eax
}
  800aa8:	5b                   	pop    %ebx
  800aa9:	5e                   	pop    %esi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ab5:	eb 06                	jmp    800abd <strcmp+0x11>
		p++, q++;
  800ab7:	83 c1 01             	add    $0x1,%ecx
  800aba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800abd:	0f b6 01             	movzbl (%ecx),%eax
  800ac0:	84 c0                	test   %al,%al
  800ac2:	74 04                	je     800ac8 <strcmp+0x1c>
  800ac4:	3a 02                	cmp    (%edx),%al
  800ac6:	74 ef                	je     800ab7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac8:	0f b6 c0             	movzbl %al,%eax
  800acb:	0f b6 12             	movzbl (%edx),%edx
  800ace:	29 d0                	sub    %edx,%eax
}
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    

00800ad2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	53                   	push   %ebx
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	89 c3                	mov    %eax,%ebx
  800ade:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ae1:	eb 06                	jmp    800ae9 <strncmp+0x17>
		n--, p++, q++;
  800ae3:	83 c0 01             	add    $0x1,%eax
  800ae6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ae9:	39 d8                	cmp    %ebx,%eax
  800aeb:	74 15                	je     800b02 <strncmp+0x30>
  800aed:	0f b6 08             	movzbl (%eax),%ecx
  800af0:	84 c9                	test   %cl,%cl
  800af2:	74 04                	je     800af8 <strncmp+0x26>
  800af4:	3a 0a                	cmp    (%edx),%cl
  800af6:	74 eb                	je     800ae3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	0f b6 00             	movzbl (%eax),%eax
  800afb:	0f b6 12             	movzbl (%edx),%edx
  800afe:	29 d0                	sub    %edx,%eax
  800b00:	eb 05                	jmp    800b07 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b02:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b07:	5b                   	pop    %ebx
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b14:	eb 07                	jmp    800b1d <strchr+0x13>
		if (*s == c)
  800b16:	38 ca                	cmp    %cl,%dl
  800b18:	74 0f                	je     800b29 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	0f b6 10             	movzbl (%eax),%edx
  800b20:	84 d2                	test   %dl,%dl
  800b22:	75 f2                	jne    800b16 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b35:	eb 07                	jmp    800b3e <strfind+0x13>
		if (*s == c)
  800b37:	38 ca                	cmp    %cl,%dl
  800b39:	74 0a                	je     800b45 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b3b:	83 c0 01             	add    $0x1,%eax
  800b3e:	0f b6 10             	movzbl (%eax),%edx
  800b41:	84 d2                	test   %dl,%dl
  800b43:	75 f2                	jne    800b37 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b53:	85 c9                	test   %ecx,%ecx
  800b55:	74 36                	je     800b8d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b57:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b5d:	75 28                	jne    800b87 <memset+0x40>
  800b5f:	f6 c1 03             	test   $0x3,%cl
  800b62:	75 23                	jne    800b87 <memset+0x40>
		c &= 0xFF;
  800b64:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b68:	89 d3                	mov    %edx,%ebx
  800b6a:	c1 e3 08             	shl    $0x8,%ebx
  800b6d:	89 d6                	mov    %edx,%esi
  800b6f:	c1 e6 18             	shl    $0x18,%esi
  800b72:	89 d0                	mov    %edx,%eax
  800b74:	c1 e0 10             	shl    $0x10,%eax
  800b77:	09 f0                	or     %esi,%eax
  800b79:	09 c2                	or     %eax,%edx
  800b7b:	89 d0                	mov    %edx,%eax
  800b7d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b7f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b82:	fc                   	cld    
  800b83:	f3 ab                	rep stos %eax,%es:(%edi)
  800b85:	eb 06                	jmp    800b8d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	fc                   	cld    
  800b8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8d:	89 f8                	mov    %edi,%eax
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba2:	39 c6                	cmp    %eax,%esi
  800ba4:	73 35                	jae    800bdb <memmove+0x47>
  800ba6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ba9:	39 d0                	cmp    %edx,%eax
  800bab:	73 2e                	jae    800bdb <memmove+0x47>
		s += n;
		d += n;
  800bad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800bb0:	89 d6                	mov    %edx,%esi
  800bb2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bba:	75 13                	jne    800bcf <memmove+0x3b>
  800bbc:	f6 c1 03             	test   $0x3,%cl
  800bbf:	75 0e                	jne    800bcf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bc1:	83 ef 04             	sub    $0x4,%edi
  800bc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bc7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bca:	fd                   	std    
  800bcb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bcd:	eb 09                	jmp    800bd8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bcf:	83 ef 01             	sub    $0x1,%edi
  800bd2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bd5:	fd                   	std    
  800bd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bd8:	fc                   	cld    
  800bd9:	eb 1d                	jmp    800bf8 <memmove+0x64>
  800bdb:	89 f2                	mov    %esi,%edx
  800bdd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bdf:	f6 c2 03             	test   $0x3,%dl
  800be2:	75 0f                	jne    800bf3 <memmove+0x5f>
  800be4:	f6 c1 03             	test   $0x3,%cl
  800be7:	75 0a                	jne    800bf3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800be9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bec:	89 c7                	mov    %eax,%edi
  800bee:	fc                   	cld    
  800bef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf1:	eb 05                	jmp    800bf8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bf3:	89 c7                	mov    %eax,%edi
  800bf5:	fc                   	cld    
  800bf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bf8:	5e                   	pop    %esi
  800bf9:	5f                   	pop    %edi
  800bfa:	5d                   	pop    %ebp
  800bfb:	c3                   	ret    

00800bfc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	89 04 24             	mov    %eax,(%esp)
  800c16:	e8 79 ff ff ff       	call   800b94 <memmove>
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	8b 55 08             	mov    0x8(%ebp),%edx
  800c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c28:	89 d6                	mov    %edx,%esi
  800c2a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c2d:	eb 1a                	jmp    800c49 <memcmp+0x2c>
		if (*s1 != *s2)
  800c2f:	0f b6 02             	movzbl (%edx),%eax
  800c32:	0f b6 19             	movzbl (%ecx),%ebx
  800c35:	38 d8                	cmp    %bl,%al
  800c37:	74 0a                	je     800c43 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c39:	0f b6 c0             	movzbl %al,%eax
  800c3c:	0f b6 db             	movzbl %bl,%ebx
  800c3f:	29 d8                	sub    %ebx,%eax
  800c41:	eb 0f                	jmp    800c52 <memcmp+0x35>
		s1++, s2++;
  800c43:	83 c2 01             	add    $0x1,%edx
  800c46:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c49:	39 f2                	cmp    %esi,%edx
  800c4b:	75 e2                	jne    800c2f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c5f:	89 c2                	mov    %eax,%edx
  800c61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c64:	eb 07                	jmp    800c6d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c66:	38 08                	cmp    %cl,(%eax)
  800c68:	74 07                	je     800c71 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c6a:	83 c0 01             	add    $0x1,%eax
  800c6d:	39 d0                	cmp    %edx,%eax
  800c6f:	72 f5                	jb     800c66 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7f:	eb 03                	jmp    800c84 <strtol+0x11>
		s++;
  800c81:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c84:	0f b6 0a             	movzbl (%edx),%ecx
  800c87:	80 f9 09             	cmp    $0x9,%cl
  800c8a:	74 f5                	je     800c81 <strtol+0xe>
  800c8c:	80 f9 20             	cmp    $0x20,%cl
  800c8f:	74 f0                	je     800c81 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c91:	80 f9 2b             	cmp    $0x2b,%cl
  800c94:	75 0a                	jne    800ca0 <strtol+0x2d>
		s++;
  800c96:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c99:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9e:	eb 11                	jmp    800cb1 <strtol+0x3e>
  800ca0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ca5:	80 f9 2d             	cmp    $0x2d,%cl
  800ca8:	75 07                	jne    800cb1 <strtol+0x3e>
		s++, neg = 1;
  800caa:	8d 52 01             	lea    0x1(%edx),%edx
  800cad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800cb6:	75 15                	jne    800ccd <strtol+0x5a>
  800cb8:	80 3a 30             	cmpb   $0x30,(%edx)
  800cbb:	75 10                	jne    800ccd <strtol+0x5a>
  800cbd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cc1:	75 0a                	jne    800ccd <strtol+0x5a>
		s += 2, base = 16;
  800cc3:	83 c2 02             	add    $0x2,%edx
  800cc6:	b8 10 00 00 00       	mov    $0x10,%eax
  800ccb:	eb 10                	jmp    800cdd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800ccd:	85 c0                	test   %eax,%eax
  800ccf:	75 0c                	jne    800cdd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cd3:	80 3a 30             	cmpb   $0x30,(%edx)
  800cd6:	75 05                	jne    800cdd <strtol+0x6a>
		s++, base = 8;
  800cd8:	83 c2 01             	add    $0x1,%edx
  800cdb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800cdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ce5:	0f b6 0a             	movzbl (%edx),%ecx
  800ce8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800ceb:	89 f0                	mov    %esi,%eax
  800ced:	3c 09                	cmp    $0x9,%al
  800cef:	77 08                	ja     800cf9 <strtol+0x86>
			dig = *s - '0';
  800cf1:	0f be c9             	movsbl %cl,%ecx
  800cf4:	83 e9 30             	sub    $0x30,%ecx
  800cf7:	eb 20                	jmp    800d19 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800cf9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cfc:	89 f0                	mov    %esi,%eax
  800cfe:	3c 19                	cmp    $0x19,%al
  800d00:	77 08                	ja     800d0a <strtol+0x97>
			dig = *s - 'a' + 10;
  800d02:	0f be c9             	movsbl %cl,%ecx
  800d05:	83 e9 57             	sub    $0x57,%ecx
  800d08:	eb 0f                	jmp    800d19 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800d0a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800d0d:	89 f0                	mov    %esi,%eax
  800d0f:	3c 19                	cmp    $0x19,%al
  800d11:	77 16                	ja     800d29 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800d13:	0f be c9             	movsbl %cl,%ecx
  800d16:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d19:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d1c:	7d 0f                	jge    800d2d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800d1e:	83 c2 01             	add    $0x1,%edx
  800d21:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d25:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d27:	eb bc                	jmp    800ce5 <strtol+0x72>
  800d29:	89 d8                	mov    %ebx,%eax
  800d2b:	eb 02                	jmp    800d2f <strtol+0xbc>
  800d2d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d33:	74 05                	je     800d3a <strtol+0xc7>
		*endptr = (char *) s;
  800d35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d38:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d3a:	f7 d8                	neg    %eax
  800d3c:	85 ff                	test   %edi,%edi
  800d3e:	0f 44 c3             	cmove  %ebx,%eax
}
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	89 c3                	mov    %eax,%ebx
  800d59:	89 c7                	mov    %eax,%edi
  800d5b:	89 c6                	mov    %eax,%esi
  800d5d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d5f:	5b                   	pop    %ebx
  800d60:	5e                   	pop    %esi
  800d61:	5f                   	pop    %edi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d74:	89 d1                	mov    %edx,%ecx
  800d76:	89 d3                	mov    %edx,%ebx
  800d78:	89 d7                	mov    %edx,%edi
  800d7a:	89 d6                	mov    %edx,%esi
  800d7c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d91:	b8 03 00 00 00       	mov    $0x3,%eax
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	89 cb                	mov    %ecx,%ebx
  800d9b:	89 cf                	mov    %ecx,%edi
  800d9d:	89 ce                	mov    %ecx,%esi
  800d9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7e 28                	jle    800dcd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800db0:	00 
  800db1:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  800db8:	00 
  800db9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc0:	00 
  800dc1:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  800dc8:	e8 b2 f4 ff ff       	call   80027f <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dcd:	83 c4 2c             	add    $0x2c,%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
  800ddb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dde:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de3:	b8 04 00 00 00       	mov    $0x4,%eax
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	89 cb                	mov    %ecx,%ebx
  800ded:	89 cf                	mov    %ecx,%edi
  800def:	89 ce                	mov    %ecx,%esi
  800df1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df3:	85 c0                	test   %eax,%eax
  800df5:	7e 28                	jle    800e1f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dfb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e02:	00 
  800e03:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  800e0a:	00 
  800e0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e12:	00 
  800e13:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  800e1a:	e8 60 f4 ff ff       	call   80027f <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800e1f:	83 c4 2c             	add    $0x2c,%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e32:	b8 02 00 00 00       	mov    $0x2,%eax
  800e37:	89 d1                	mov    %edx,%ecx
  800e39:	89 d3                	mov    %edx,%ebx
  800e3b:	89 d7                	mov    %edx,%edi
  800e3d:	89 d6                	mov    %edx,%esi
  800e3f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_yield>:

void
sys_yield(void)
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
  800e4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e51:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e56:	89 d1                	mov    %edx,%ecx
  800e58:	89 d3                	mov    %edx,%ebx
  800e5a:	89 d7                	mov    %edx,%edi
  800e5c:	89 d6                	mov    %edx,%esi
  800e5e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6e:	be 00 00 00 00       	mov    $0x0,%esi
  800e73:	b8 05 00 00 00       	mov    $0x5,%eax
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e81:	89 f7                	mov    %esi,%edi
  800e83:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	7e 28                	jle    800eb1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e89:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e94:	00 
  800e95:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  800e9c:	00 
  800e9d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea4:	00 
  800ea5:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  800eac:	e8 ce f3 ff ff       	call   80027f <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eb1:	83 c4 2c             	add    $0x2c,%esp
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec2:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	7e 28                	jle    800f04 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ee7:	00 
  800ee8:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  800eef:	00 
  800ef0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef7:	00 
  800ef8:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  800eff:	e8 7b f3 ff ff       	call   80027f <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f04:	83 c4 2c             	add    $0x2c,%esp
  800f07:	5b                   	pop    %ebx
  800f08:	5e                   	pop    %esi
  800f09:	5f                   	pop    %edi
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	57                   	push   %edi
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
  800f12:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1a:	b8 07 00 00 00       	mov    $0x7,%eax
  800f1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f22:	8b 55 08             	mov    0x8(%ebp),%edx
  800f25:	89 df                	mov    %ebx,%edi
  800f27:	89 de                	mov    %ebx,%esi
  800f29:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	7e 28                	jle    800f57 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f33:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800f3a:	00 
  800f3b:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  800f42:	00 
  800f43:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4a:	00 
  800f4b:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  800f52:	e8 28 f3 ff ff       	call   80027f <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f57:	83 c4 2c             	add    $0x2c,%esp
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5f                   	pop    %edi
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    

00800f5f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	89 cb                	mov    %ecx,%ebx
  800f74:	89 cf                	mov    %ecx,%edi
  800f76:	89 ce                	mov    %ecx,%esi
  800f78:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8d:	b8 09 00 00 00       	mov    $0x9,%eax
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	89 df                	mov    %ebx,%edi
  800f9a:	89 de                	mov    %ebx,%esi
  800f9c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f9e:	85 c0                	test   %eax,%eax
  800fa0:	7e 28                	jle    800fca <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fad:	00 
  800fae:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  800fb5:	00 
  800fb6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fbd:	00 
  800fbe:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  800fc5:	e8 b5 f2 ff ff       	call   80027f <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fca:	83 c4 2c             	add    $0x2c,%esp
  800fcd:	5b                   	pop    %ebx
  800fce:	5e                   	pop    %esi
  800fcf:	5f                   	pop    %edi
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
  800fd8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  800feb:	89 df                	mov    %ebx,%edi
  800fed:	89 de                	mov    %ebx,%esi
  800fef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	7e 28                	jle    80101d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801000:	00 
  801001:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  801008:	00 
  801009:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801010:	00 
  801011:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801018:	e8 62 f2 ff ff       	call   80027f <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80101d:	83 c4 2c             	add    $0x2c,%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	57                   	push   %edi
  801029:	56                   	push   %esi
  80102a:	53                   	push   %ebx
  80102b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801033:	b8 0b 00 00 00       	mov    $0xb,%eax
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	89 df                	mov    %ebx,%edi
  801040:	89 de                	mov    %ebx,%esi
  801042:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801044:	85 c0                	test   %eax,%eax
  801046:	7e 28                	jle    801070 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801048:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801053:	00 
  801054:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  80105b:	00 
  80105c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  80106b:	e8 0f f2 ff ff       	call   80027f <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801070:	83 c4 2c             	add    $0x2c,%esp
  801073:	5b                   	pop    %ebx
  801074:	5e                   	pop    %esi
  801075:	5f                   	pop    %edi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    

00801078 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107e:	be 00 00 00 00       	mov    $0x0,%esi
  801083:	b8 0d 00 00 00       	mov    $0xd,%eax
  801088:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108b:	8b 55 08             	mov    0x8(%ebp),%edx
  80108e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801091:	8b 7d 14             	mov    0x14(%ebp),%edi
  801094:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	57                   	push   %edi
  80109f:	56                   	push   %esi
  8010a0:	53                   	push   %ebx
  8010a1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 cb                	mov    %ecx,%ebx
  8010b3:	89 cf                	mov    %ecx,%edi
  8010b5:	89 ce                	mov    %ecx,%esi
  8010b7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	7e 28                	jle    8010e5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8010c8:	00 
  8010c9:	c7 44 24 08 37 33 80 	movl   $0x803337,0x8(%esp)
  8010d0:	00 
  8010d1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d8:	00 
  8010d9:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  8010e0:	e8 9a f1 ff ff       	call   80027f <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010e5:	83 c4 2c             	add    $0x2c,%esp
  8010e8:	5b                   	pop    %ebx
  8010e9:	5e                   	pop    %esi
  8010ea:	5f                   	pop    %edi
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	57                   	push   %edi
  8010f1:	56                   	push   %esi
  8010f2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010fd:	89 d1                	mov    %edx,%ecx
  8010ff:	89 d3                	mov    %edx,%ebx
  801101:	89 d7                	mov    %edx,%edi
  801103:	89 d6                	mov    %edx,%esi
  801105:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801107:	5b                   	pop    %ebx
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	57                   	push   %edi
  801110:	56                   	push   %esi
  801111:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801112:	bb 00 00 00 00       	mov    $0x0,%ebx
  801117:	b8 11 00 00 00       	mov    $0x11,%eax
  80111c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	89 df                	mov    %ebx,%edi
  801124:	89 de                	mov    %ebx,%esi
  801126:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801128:	5b                   	pop    %ebx
  801129:	5e                   	pop    %esi
  80112a:	5f                   	pop    %edi
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	57                   	push   %edi
  801131:	56                   	push   %esi
  801132:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801133:	bb 00 00 00 00       	mov    $0x0,%ebx
  801138:	b8 12 00 00 00       	mov    $0x12,%eax
  80113d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801140:	8b 55 08             	mov    0x8(%ebp),%edx
  801143:	89 df                	mov    %ebx,%edi
  801145:	89 de                	mov    %ebx,%esi
  801147:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801149:	5b                   	pop    %ebx
  80114a:	5e                   	pop    %esi
  80114b:	5f                   	pop    %edi
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    

0080114e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	57                   	push   %edi
  801152:	56                   	push   %esi
  801153:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801154:	b9 00 00 00 00       	mov    $0x0,%ecx
  801159:	b8 13 00 00 00       	mov    $0x13,%eax
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	89 cb                	mov    %ecx,%ebx
  801163:	89 cf                	mov    %ecx,%edi
  801165:	89 ce                	mov    %ecx,%esi
  801167:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801169:	5b                   	pop    %ebx
  80116a:	5e                   	pop    %esi
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	57                   	push   %edi
  801172:	56                   	push   %esi
  801173:	53                   	push   %ebx
  801174:	83 ec 2c             	sub    $0x2c,%esp
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80117a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80117c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80117f:	89 f8                	mov    %edi,%eax
  801181:	c1 e8 0c             	shr    $0xc,%eax
  801184:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801187:	e8 9b fc ff ff       	call   800e27 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80118c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801192:	0f 84 de 00 00 00    	je     801276 <pgfault+0x108>
  801198:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80119a:	85 c0                	test   %eax,%eax
  80119c:	79 20                	jns    8011be <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80119e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011a2:	c7 44 24 08 62 33 80 	movl   $0x803362,0x8(%esp)
  8011a9:	00 
  8011aa:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8011b1:	00 
  8011b2:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8011b9:	e8 c1 f0 ff ff       	call   80027f <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  8011be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  8011c8:	25 05 08 00 00       	and    $0x805,%eax
  8011cd:	3d 05 08 00 00       	cmp    $0x805,%eax
  8011d2:	0f 85 ba 00 00 00    	jne    801292 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8011d8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011df:	00 
  8011e0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011e7:	00 
  8011e8:	89 1c 24             	mov    %ebx,(%esp)
  8011eb:	e8 75 fc ff ff       	call   800e65 <sys_page_alloc>
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	79 20                	jns    801214 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  8011f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011f8:	c7 44 24 08 89 33 80 	movl   $0x803389,0x8(%esp)
  8011ff:	00 
  801200:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801207:	00 
  801208:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80120f:	e8 6b f0 ff ff       	call   80027f <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801214:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80121a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801221:	00 
  801222:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801226:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80122d:	e8 62 f9 ff ff       	call   800b94 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801232:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801239:	00 
  80123a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80123e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801242:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801249:	00 
  80124a:	89 1c 24             	mov    %ebx,(%esp)
  80124d:	e8 67 fc ff ff       	call   800eb9 <sys_page_map>
  801252:	85 c0                	test   %eax,%eax
  801254:	79 3c                	jns    801292 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801256:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80125a:	c7 44 24 08 9c 33 80 	movl   $0x80339c,0x8(%esp)
  801261:	00 
  801262:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801269:	00 
  80126a:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  801271:	e8 09 f0 ff ff       	call   80027f <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801276:	c7 44 24 08 c0 33 80 	movl   $0x8033c0,0x8(%esp)
  80127d:	00 
  80127e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801285:	00 
  801286:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80128d:	e8 ed ef ff ff       	call   80027f <_panic>
}
  801292:	83 c4 2c             	add    $0x2c,%esp
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    

0080129a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	83 ec 20             	sub    $0x20,%esp
  8012a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8012a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8012a8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012af:	00 
  8012b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012b4:	89 34 24             	mov    %esi,(%esp)
  8012b7:	e8 a9 fb ff ff       	call   800e65 <sys_page_alloc>
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	79 20                	jns    8012e0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  8012c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012c4:	c7 44 24 08 89 33 80 	movl   $0x803389,0x8(%esp)
  8012cb:	00 
  8012cc:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8012d3:	00 
  8012d4:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8012db:	e8 9f ef ff ff       	call   80027f <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8012e0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012e7:	00 
  8012e8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8012ef:	00 
  8012f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012f7:	00 
  8012f8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012fc:	89 34 24             	mov    %esi,(%esp)
  8012ff:	e8 b5 fb ff ff       	call   800eb9 <sys_page_map>
  801304:	85 c0                	test   %eax,%eax
  801306:	79 20                	jns    801328 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801308:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80130c:	c7 44 24 08 9c 33 80 	movl   $0x80339c,0x8(%esp)
  801313:	00 
  801314:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80131b:	00 
  80131c:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  801323:	e8 57 ef ff ff       	call   80027f <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801328:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80132f:	00 
  801330:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801334:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80133b:	e8 54 f8 ff ff       	call   800b94 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801340:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801347:	00 
  801348:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134f:	e8 b8 fb ff ff       	call   800f0c <sys_page_unmap>
  801354:	85 c0                	test   %eax,%eax
  801356:	79 20                	jns    801378 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801358:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80135c:	c7 44 24 08 ad 33 80 	movl   $0x8033ad,0x8(%esp)
  801363:	00 
  801364:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80136b:	00 
  80136c:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  801373:	e8 07 ef ff ff       	call   80027f <_panic>

}
  801378:	83 c4 20             	add    $0x20,%esp
  80137b:	5b                   	pop    %ebx
  80137c:	5e                   	pop    %esi
  80137d:	5d                   	pop    %ebp
  80137e:	c3                   	ret    

0080137f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	57                   	push   %edi
  801383:	56                   	push   %esi
  801384:	53                   	push   %ebx
  801385:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801388:	c7 04 24 6e 11 80 00 	movl   $0x80116e,(%esp)
  80138f:	e8 22 18 00 00       	call   802bb6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801394:	b8 08 00 00 00       	mov    $0x8,%eax
  801399:	cd 30                	int    $0x30
  80139b:	89 c6                	mov    %eax,%esi
  80139d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	79 20                	jns    8013c4 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  8013a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013a8:	c7 44 24 08 e4 33 80 	movl   $0x8033e4,0x8(%esp)
  8013af:	00 
  8013b0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  8013b7:	00 
  8013b8:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8013bf:	e8 bb ee ff ff       	call   80027f <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8013c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	75 21                	jne    8013ee <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8013cd:	e8 55 fa ff ff       	call   800e27 <sys_getenvid>
  8013d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013d7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013df:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e9:	e9 88 01 00 00       	jmp    801576 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8013ee:	89 d8                	mov    %ebx,%eax
  8013f0:	c1 e8 16             	shr    $0x16,%eax
  8013f3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013fa:	a8 01                	test   $0x1,%al
  8013fc:	0f 84 e0 00 00 00    	je     8014e2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801402:	89 df                	mov    %ebx,%edi
  801404:	c1 ef 0c             	shr    $0xc,%edi
  801407:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80140e:	a8 01                	test   $0x1,%al
  801410:	0f 84 c4 00 00 00    	je     8014da <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801416:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80141d:	f6 c4 04             	test   $0x4,%ah
  801420:	74 0d                	je     80142f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801422:	25 07 0e 00 00       	and    $0xe07,%eax
  801427:	83 c8 05             	or     $0x5,%eax
  80142a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80142d:	eb 1b                	jmp    80144a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80142f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801434:	83 f8 01             	cmp    $0x1,%eax
  801437:	19 c0                	sbb    %eax,%eax
  801439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80143c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801443:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80144a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80144d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801450:	89 44 24 10          	mov    %eax,0x10(%esp)
  801454:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80145f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801463:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80146a:	e8 4a fa ff ff       	call   800eb9 <sys_page_map>
  80146f:	85 c0                	test   %eax,%eax
  801471:	79 20                	jns    801493 <fork+0x114>
		panic("sys_page_map: %e", r);
  801473:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801477:	c7 44 24 08 9c 33 80 	movl   $0x80339c,0x8(%esp)
  80147e:	00 
  80147f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801486:	00 
  801487:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80148e:	e8 ec ed ff ff       	call   80027f <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801496:	89 44 24 10          	mov    %eax,0x10(%esp)
  80149a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80149e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014a5:	00 
  8014a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014b1:	e8 03 fa ff ff       	call   800eb9 <sys_page_map>
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	79 20                	jns    8014da <fork+0x15b>
		panic("sys_page_map: %e", r);
  8014ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014be:	c7 44 24 08 9c 33 80 	movl   $0x80339c,0x8(%esp)
  8014c5:	00 
  8014c6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  8014cd:	00 
  8014ce:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8014d5:	e8 a5 ed ff ff       	call   80027f <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8014da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014e0:	eb 06                	jmp    8014e8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  8014e2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  8014e8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  8014ee:	0f 86 fa fe ff ff    	jbe    8013ee <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8014f4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014fb:	00 
  8014fc:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801503:	ee 
  801504:	89 34 24             	mov    %esi,(%esp)
  801507:	e8 59 f9 ff ff       	call   800e65 <sys_page_alloc>
  80150c:	85 c0                	test   %eax,%eax
  80150e:	79 20                	jns    801530 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801510:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801514:	c7 44 24 08 89 33 80 	movl   $0x803389,0x8(%esp)
  80151b:	00 
  80151c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801523:	00 
  801524:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80152b:	e8 4f ed ff ff       	call   80027f <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801530:	c7 44 24 04 49 2c 80 	movl   $0x802c49,0x4(%esp)
  801537:	00 
  801538:	89 34 24             	mov    %esi,(%esp)
  80153b:	e8 e5 fa ff ff       	call   801025 <sys_env_set_pgfault_upcall>
  801540:	85 c0                	test   %eax,%eax
  801542:	79 20                	jns    801564 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801544:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801548:	c7 44 24 08 08 34 80 	movl   $0x803408,0x8(%esp)
  80154f:	00 
  801550:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801557:	00 
  801558:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  80155f:	e8 1b ed ff ff       	call   80027f <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801564:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80156b:	00 
  80156c:	89 34 24             	mov    %esi,(%esp)
  80156f:	e8 0b fa ff ff       	call   800f7f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801574:	89 f0                	mov    %esi,%eax

}
  801576:	83 c4 2c             	add    $0x2c,%esp
  801579:	5b                   	pop    %ebx
  80157a:	5e                   	pop    %esi
  80157b:	5f                   	pop    %edi
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <sfork>:

// Challenge!
int
sfork(void)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	57                   	push   %edi
  801582:	56                   	push   %esi
  801583:	53                   	push   %ebx
  801584:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801587:	c7 04 24 6e 11 80 00 	movl   $0x80116e,(%esp)
  80158e:	e8 23 16 00 00       	call   802bb6 <set_pgfault_handler>
  801593:	b8 08 00 00 00       	mov    $0x8,%eax
  801598:	cd 30                	int    $0x30
  80159a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80159c:	85 c0                	test   %eax,%eax
  80159e:	79 20                	jns    8015c0 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  8015a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015a4:	c7 44 24 08 e4 33 80 	movl   $0x8033e4,0x8(%esp)
  8015ab:	00 
  8015ac:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  8015b3:	00 
  8015b4:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8015bb:	e8 bf ec ff ff       	call   80027f <_panic>
  8015c0:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8015c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	75 2d                	jne    8015f8 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8015cb:	e8 57 f8 ff ff       	call   800e27 <sys_getenvid>
  8015d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8015d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015dd:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  8015e2:	c7 04 24 6e 11 80 00 	movl   $0x80116e,(%esp)
  8015e9:	e8 c8 15 00 00       	call   802bb6 <set_pgfault_handler>
		return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f3:	e9 1d 01 00 00       	jmp    801715 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8015f8:	89 d8                	mov    %ebx,%eax
  8015fa:	c1 e8 16             	shr    $0x16,%eax
  8015fd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801604:	a8 01                	test   $0x1,%al
  801606:	74 69                	je     801671 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801608:	89 d8                	mov    %ebx,%eax
  80160a:	c1 e8 0c             	shr    $0xc,%eax
  80160d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801614:	f6 c2 01             	test   $0x1,%dl
  801617:	74 50                	je     801669 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801619:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801620:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801623:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801629:	89 54 24 10          	mov    %edx,0x10(%esp)
  80162d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801631:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801635:	89 44 24 04          	mov    %eax,0x4(%esp)
  801639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801640:	e8 74 f8 ff ff       	call   800eb9 <sys_page_map>
  801645:	85 c0                	test   %eax,%eax
  801647:	79 20                	jns    801669 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801649:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80164d:	c7 44 24 08 9c 33 80 	movl   $0x80339c,0x8(%esp)
  801654:	00 
  801655:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80165c:	00 
  80165d:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  801664:	e8 16 ec ff ff       	call   80027f <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80166f:	eb 06                	jmp    801677 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801671:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801677:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80167d:	0f 86 75 ff ff ff    	jbe    8015f8 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801683:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80168a:	ee 
  80168b:	89 34 24             	mov    %esi,(%esp)
  80168e:	e8 07 fc ff ff       	call   80129a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801693:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80169a:	00 
  80169b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8016a2:	ee 
  8016a3:	89 34 24             	mov    %esi,(%esp)
  8016a6:	e8 ba f7 ff ff       	call   800e65 <sys_page_alloc>
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	79 20                	jns    8016cf <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  8016af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016b3:	c7 44 24 08 89 33 80 	movl   $0x803389,0x8(%esp)
  8016ba:	00 
  8016bb:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  8016c2:	00 
  8016c3:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8016ca:	e8 b0 eb ff ff       	call   80027f <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8016cf:	c7 44 24 04 49 2c 80 	movl   $0x802c49,0x4(%esp)
  8016d6:	00 
  8016d7:	89 34 24             	mov    %esi,(%esp)
  8016da:	e8 46 f9 ff ff       	call   801025 <sys_env_set_pgfault_upcall>
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	79 20                	jns    801703 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  8016e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016e7:	c7 44 24 08 08 34 80 	movl   $0x803408,0x8(%esp)
  8016ee:	00 
  8016ef:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  8016f6:	00 
  8016f7:	c7 04 24 7e 33 80 00 	movl   $0x80337e,(%esp)
  8016fe:	e8 7c eb ff ff       	call   80027f <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801703:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80170a:	00 
  80170b:	89 34 24             	mov    %esi,(%esp)
  80170e:	e8 6c f8 ff ff       	call   800f7f <sys_env_set_status>
	return envid;
  801713:	89 f0                	mov    %esi,%eax

}
  801715:	83 c4 2c             	add    $0x2c,%esp
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5f                   	pop    %edi
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    
  80171d:	66 90                	xchg   %ax,%ax
  80171f:	90                   	nop

00801720 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	83 ec 10             	sub    $0x10,%esp
  801728:	8b 75 08             	mov    0x8(%ebp),%esi
  80172b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  801731:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  801733:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801738:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80173b:	89 04 24             	mov    %eax,(%esp)
  80173e:	e8 58 f9 ff ff       	call   80109b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  801743:	85 c0                	test   %eax,%eax
  801745:	75 26                	jne    80176d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  801747:	85 f6                	test   %esi,%esi
  801749:	74 0a                	je     801755 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80174b:	a1 08 50 80 00       	mov    0x805008,%eax
  801750:	8b 40 74             	mov    0x74(%eax),%eax
  801753:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  801755:	85 db                	test   %ebx,%ebx
  801757:	74 0a                	je     801763 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  801759:	a1 08 50 80 00       	mov    0x805008,%eax
  80175e:	8b 40 78             	mov    0x78(%eax),%eax
  801761:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801763:	a1 08 50 80 00       	mov    0x805008,%eax
  801768:	8b 40 70             	mov    0x70(%eax),%eax
  80176b:	eb 14                	jmp    801781 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80176d:	85 f6                	test   %esi,%esi
  80176f:	74 06                	je     801777 <ipc_recv+0x57>
			*from_env_store = 0;
  801771:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801777:	85 db                	test   %ebx,%ebx
  801779:	74 06                	je     801781 <ipc_recv+0x61>
			*perm_store = 0;
  80177b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	5b                   	pop    %ebx
  801785:	5e                   	pop    %esi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	57                   	push   %edi
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
  80178e:	83 ec 1c             	sub    $0x1c,%esp
  801791:	8b 7d 08             	mov    0x8(%ebp),%edi
  801794:	8b 75 0c             	mov    0xc(%ebp),%esi
  801797:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80179a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80179c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8017a1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8017a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017b3:	89 3c 24             	mov    %edi,(%esp)
  8017b6:	e8 bd f8 ff ff       	call   801078 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	74 28                	je     8017e7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8017bf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017c2:	74 1c                	je     8017e0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8017c4:	c7 44 24 08 2c 34 80 	movl   $0x80342c,0x8(%esp)
  8017cb:	00 
  8017cc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8017d3:	00 
  8017d4:	c7 04 24 4d 34 80 00 	movl   $0x80344d,(%esp)
  8017db:	e8 9f ea ff ff       	call   80027f <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8017e0:	e8 61 f6 ff ff       	call   800e46 <sys_yield>
	}
  8017e5:	eb bd                	jmp    8017a4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8017e7:	83 c4 1c             	add    $0x1c,%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5e                   	pop    %esi
  8017ec:	5f                   	pop    %edi
  8017ed:	5d                   	pop    %ebp
  8017ee:	c3                   	ret    

008017ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8017fa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8017fd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801803:	8b 52 50             	mov    0x50(%edx),%edx
  801806:	39 ca                	cmp    %ecx,%edx
  801808:	75 0d                	jne    801817 <ipc_find_env+0x28>
			return envs[i].env_id;
  80180a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80180d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801812:	8b 40 40             	mov    0x40(%eax),%eax
  801815:	eb 0e                	jmp    801825 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801817:	83 c0 01             	add    $0x1,%eax
  80181a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80181f:	75 d9                	jne    8017fa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801821:	66 b8 00 00          	mov    $0x0,%ax
}
  801825:	5d                   	pop    %ebp
  801826:	c3                   	ret    
  801827:	66 90                	xchg   %ax,%ax
  801829:	66 90                	xchg   %ax,%ax
  80182b:	66 90                	xchg   %ax,%ax
  80182d:	66 90                	xchg   %ax,%ax
  80182f:	90                   	nop

00801830 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	05 00 00 00 30       	add    $0x30000000,%eax
  80183b:	c1 e8 0c             	shr    $0xc,%eax
}
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80184b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801850:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80185d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801862:	89 c2                	mov    %eax,%edx
  801864:	c1 ea 16             	shr    $0x16,%edx
  801867:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80186e:	f6 c2 01             	test   $0x1,%dl
  801871:	74 11                	je     801884 <fd_alloc+0x2d>
  801873:	89 c2                	mov    %eax,%edx
  801875:	c1 ea 0c             	shr    $0xc,%edx
  801878:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80187f:	f6 c2 01             	test   $0x1,%dl
  801882:	75 09                	jne    80188d <fd_alloc+0x36>
			*fd_store = fd;
  801884:	89 01                	mov    %eax,(%ecx)
			return 0;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
  80188b:	eb 17                	jmp    8018a4 <fd_alloc+0x4d>
  80188d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801892:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801897:	75 c9                	jne    801862 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801899:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80189f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8018a4:	5d                   	pop    %ebp
  8018a5:	c3                   	ret    

008018a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018ac:	83 f8 1f             	cmp    $0x1f,%eax
  8018af:	77 36                	ja     8018e7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018b1:	c1 e0 0c             	shl    $0xc,%eax
  8018b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018b9:	89 c2                	mov    %eax,%edx
  8018bb:	c1 ea 16             	shr    $0x16,%edx
  8018be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018c5:	f6 c2 01             	test   $0x1,%dl
  8018c8:	74 24                	je     8018ee <fd_lookup+0x48>
  8018ca:	89 c2                	mov    %eax,%edx
  8018cc:	c1 ea 0c             	shr    $0xc,%edx
  8018cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018d6:	f6 c2 01             	test   $0x1,%dl
  8018d9:	74 1a                	je     8018f5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	89 02                	mov    %eax,(%edx)
	return 0;
  8018e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e5:	eb 13                	jmp    8018fa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018ec:	eb 0c                	jmp    8018fa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f3:	eb 05                	jmp    8018fa <fd_lookup+0x54>
  8018f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 18             	sub    $0x18,%esp
  801902:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801905:	ba 00 00 00 00       	mov    $0x0,%edx
  80190a:	eb 13                	jmp    80191f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80190c:	39 08                	cmp    %ecx,(%eax)
  80190e:	75 0c                	jne    80191c <dev_lookup+0x20>
			*dev = devtab[i];
  801910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801913:	89 01                	mov    %eax,(%ecx)
			return 0;
  801915:	b8 00 00 00 00       	mov    $0x0,%eax
  80191a:	eb 38                	jmp    801954 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80191c:	83 c2 01             	add    $0x1,%edx
  80191f:	8b 04 95 d8 34 80 00 	mov    0x8034d8(,%edx,4),%eax
  801926:	85 c0                	test   %eax,%eax
  801928:	75 e2                	jne    80190c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80192a:	a1 08 50 80 00       	mov    0x805008,%eax
  80192f:	8b 40 48             	mov    0x48(%eax),%eax
  801932:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801936:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193a:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  801941:	e8 32 ea ff ff       	call   800378 <cprintf>
	*dev = 0;
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80194f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	56                   	push   %esi
  80195a:	53                   	push   %ebx
  80195b:	83 ec 20             	sub    $0x20,%esp
  80195e:	8b 75 08             	mov    0x8(%ebp),%esi
  801961:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801964:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801967:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80196b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801971:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	e8 2a ff ff ff       	call   8018a6 <fd_lookup>
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 05                	js     801985 <fd_close+0x2f>
	    || fd != fd2)
  801980:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801983:	74 0c                	je     801991 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801985:	84 db                	test   %bl,%bl
  801987:	ba 00 00 00 00       	mov    $0x0,%edx
  80198c:	0f 44 c2             	cmove  %edx,%eax
  80198f:	eb 3f                	jmp    8019d0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801991:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	8b 06                	mov    (%esi),%eax
  80199a:	89 04 24             	mov    %eax,(%esp)
  80199d:	e8 5a ff ff ff       	call   8018fc <dev_lookup>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 16                	js     8019be <fd_close+0x68>
		if (dev->dev_close)
  8019a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8019ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	74 07                	je     8019be <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8019b7:	89 34 24             	mov    %esi,(%esp)
  8019ba:	ff d0                	call   *%eax
  8019bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8019be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019c9:	e8 3e f5 ff ff       	call   800f0c <sys_page_unmap>
	return r;
  8019ce:	89 d8                	mov    %ebx,%eax
}
  8019d0:	83 c4 20             	add    $0x20,%esp
  8019d3:	5b                   	pop    %ebx
  8019d4:	5e                   	pop    %esi
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    

008019d7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	89 04 24             	mov    %eax,(%esp)
  8019ea:	e8 b7 fe ff ff       	call   8018a6 <fd_lookup>
  8019ef:	89 c2                	mov    %eax,%edx
  8019f1:	85 d2                	test   %edx,%edx
  8019f3:	78 13                	js     801a08 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8019f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019fc:	00 
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	89 04 24             	mov    %eax,(%esp)
  801a03:	e8 4e ff ff ff       	call   801956 <fd_close>
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <close_all>:

void
close_all(void)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a11:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a16:	89 1c 24             	mov    %ebx,(%esp)
  801a19:	e8 b9 ff ff ff       	call   8019d7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a1e:	83 c3 01             	add    $0x1,%ebx
  801a21:	83 fb 20             	cmp    $0x20,%ebx
  801a24:	75 f0                	jne    801a16 <close_all+0xc>
		close(i);
}
  801a26:	83 c4 14             	add    $0x14,%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	57                   	push   %edi
  801a30:	56                   	push   %esi
  801a31:	53                   	push   %ebx
  801a32:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a35:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	89 04 24             	mov    %eax,(%esp)
  801a42:	e8 5f fe ff ff       	call   8018a6 <fd_lookup>
  801a47:	89 c2                	mov    %eax,%edx
  801a49:	85 d2                	test   %edx,%edx
  801a4b:	0f 88 e1 00 00 00    	js     801b32 <dup+0x106>
		return r;
	close(newfdnum);
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	89 04 24             	mov    %eax,(%esp)
  801a57:	e8 7b ff ff ff       	call   8019d7 <close>

	newfd = INDEX2FD(newfdnum);
  801a5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a5f:	c1 e3 0c             	shl    $0xc,%ebx
  801a62:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	e8 cd fd ff ff       	call   801840 <fd2data>
  801a73:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a75:	89 1c 24             	mov    %ebx,(%esp)
  801a78:	e8 c3 fd ff ff       	call   801840 <fd2data>
  801a7d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a7f:	89 f0                	mov    %esi,%eax
  801a81:	c1 e8 16             	shr    $0x16,%eax
  801a84:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a8b:	a8 01                	test   $0x1,%al
  801a8d:	74 43                	je     801ad2 <dup+0xa6>
  801a8f:	89 f0                	mov    %esi,%eax
  801a91:	c1 e8 0c             	shr    $0xc,%eax
  801a94:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a9b:	f6 c2 01             	test   $0x1,%dl
  801a9e:	74 32                	je     801ad2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801aa0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aa7:	25 07 0e 00 00       	and    $0xe07,%eax
  801aac:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ab0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ab4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801abb:	00 
  801abc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac7:	e8 ed f3 ff ff       	call   800eb9 <sys_page_map>
  801acc:	89 c6                	mov    %eax,%esi
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 3e                	js     801b10 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad5:	89 c2                	mov    %eax,%edx
  801ad7:	c1 ea 0c             	shr    $0xc,%edx
  801ada:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ae1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801ae7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801aeb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801aef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801af6:	00 
  801af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b02:	e8 b2 f3 ff ff       	call   800eb9 <sys_page_map>
  801b07:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801b09:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b0c:	85 f6                	test   %esi,%esi
  801b0e:	79 22                	jns    801b32 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1b:	e8 ec f3 ff ff       	call   800f0c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2b:	e8 dc f3 ff ff       	call   800f0c <sys_page_unmap>
	return r;
  801b30:	89 f0                	mov    %esi,%eax
}
  801b32:	83 c4 3c             	add    $0x3c,%esp
  801b35:	5b                   	pop    %ebx
  801b36:	5e                   	pop    %esi
  801b37:	5f                   	pop    %edi
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    

00801b3a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 24             	sub    $0x24,%esp
  801b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4b:	89 1c 24             	mov    %ebx,(%esp)
  801b4e:	e8 53 fd ff ff       	call   8018a6 <fd_lookup>
  801b53:	89 c2                	mov    %eax,%edx
  801b55:	85 d2                	test   %edx,%edx
  801b57:	78 6d                	js     801bc6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b63:	8b 00                	mov    (%eax),%eax
  801b65:	89 04 24             	mov    %eax,(%esp)
  801b68:	e8 8f fd ff ff       	call   8018fc <dev_lookup>
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	78 55                	js     801bc6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b74:	8b 50 08             	mov    0x8(%eax),%edx
  801b77:	83 e2 03             	and    $0x3,%edx
  801b7a:	83 fa 01             	cmp    $0x1,%edx
  801b7d:	75 23                	jne    801ba2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b7f:	a1 08 50 80 00       	mov    0x805008,%eax
  801b84:	8b 40 48             	mov    0x48(%eax),%eax
  801b87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8f:	c7 04 24 9c 34 80 00 	movl   $0x80349c,(%esp)
  801b96:	e8 dd e7 ff ff       	call   800378 <cprintf>
		return -E_INVAL;
  801b9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba0:	eb 24                	jmp    801bc6 <read+0x8c>
	}
	if (!dev->dev_read)
  801ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba5:	8b 52 08             	mov    0x8(%edx),%edx
  801ba8:	85 d2                	test   %edx,%edx
  801baa:	74 15                	je     801bc1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801bac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801baf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bba:	89 04 24             	mov    %eax,(%esp)
  801bbd:	ff d2                	call   *%edx
  801bbf:	eb 05                	jmp    801bc6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801bc1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801bc6:	83 c4 24             	add    $0x24,%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    

00801bcc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	57                   	push   %edi
  801bd0:	56                   	push   %esi
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 1c             	sub    $0x1c,%esp
  801bd5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bd8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801be0:	eb 23                	jmp    801c05 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801be2:	89 f0                	mov    %esi,%eax
  801be4:	29 d8                	sub    %ebx,%eax
  801be6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bea:	89 d8                	mov    %ebx,%eax
  801bec:	03 45 0c             	add    0xc(%ebp),%eax
  801bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf3:	89 3c 24             	mov    %edi,(%esp)
  801bf6:	e8 3f ff ff ff       	call   801b3a <read>
		if (m < 0)
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	78 10                	js     801c0f <readn+0x43>
			return m;
		if (m == 0)
  801bff:	85 c0                	test   %eax,%eax
  801c01:	74 0a                	je     801c0d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c03:	01 c3                	add    %eax,%ebx
  801c05:	39 f3                	cmp    %esi,%ebx
  801c07:	72 d9                	jb     801be2 <readn+0x16>
  801c09:	89 d8                	mov    %ebx,%eax
  801c0b:	eb 02                	jmp    801c0f <readn+0x43>
  801c0d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801c0f:	83 c4 1c             	add    $0x1c,%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5f                   	pop    %edi
  801c15:	5d                   	pop    %ebp
  801c16:	c3                   	ret    

00801c17 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	53                   	push   %ebx
  801c1b:	83 ec 24             	sub    $0x24,%esp
  801c1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c21:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c28:	89 1c 24             	mov    %ebx,(%esp)
  801c2b:	e8 76 fc ff ff       	call   8018a6 <fd_lookup>
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	85 d2                	test   %edx,%edx
  801c34:	78 68                	js     801c9e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	89 04 24             	mov    %eax,(%esp)
  801c45:	e8 b2 fc ff ff       	call   8018fc <dev_lookup>
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	78 50                	js     801c9e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c51:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c55:	75 23                	jne    801c7a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c57:	a1 08 50 80 00       	mov    0x805008,%eax
  801c5c:	8b 40 48             	mov    0x48(%eax),%eax
  801c5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c67:	c7 04 24 b8 34 80 00 	movl   $0x8034b8,(%esp)
  801c6e:	e8 05 e7 ff ff       	call   800378 <cprintf>
		return -E_INVAL;
  801c73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c78:	eb 24                	jmp    801c9e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c7d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c80:	85 d2                	test   %edx,%edx
  801c82:	74 15                	je     801c99 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c92:	89 04 24             	mov    %eax,(%esp)
  801c95:	ff d2                	call   *%edx
  801c97:	eb 05                	jmp    801c9e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c9e:	83 c4 24             	add    $0x24,%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    

00801ca4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801caa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	89 04 24             	mov    %eax,(%esp)
  801cb7:	e8 ea fb ff ff       	call   8018a6 <fd_lookup>
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	78 0e                	js     801cce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 24             	sub    $0x24,%esp
  801cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cda:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce1:	89 1c 24             	mov    %ebx,(%esp)
  801ce4:	e8 bd fb ff ff       	call   8018a6 <fd_lookup>
  801ce9:	89 c2                	mov    %eax,%edx
  801ceb:	85 d2                	test   %edx,%edx
  801ced:	78 61                	js     801d50 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf9:	8b 00                	mov    (%eax),%eax
  801cfb:	89 04 24             	mov    %eax,(%esp)
  801cfe:	e8 f9 fb ff ff       	call   8018fc <dev_lookup>
  801d03:	85 c0                	test   %eax,%eax
  801d05:	78 49                	js     801d50 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d0e:	75 23                	jne    801d33 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801d10:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d15:	8b 40 48             	mov    0x48(%eax),%eax
  801d18:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d20:	c7 04 24 78 34 80 00 	movl   $0x803478,(%esp)
  801d27:	e8 4c e6 ff ff       	call   800378 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801d2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d31:	eb 1d                	jmp    801d50 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d36:	8b 52 18             	mov    0x18(%edx),%edx
  801d39:	85 d2                	test   %edx,%edx
  801d3b:	74 0e                	je     801d4b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d40:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d44:	89 04 24             	mov    %eax,(%esp)
  801d47:	ff d2                	call   *%edx
  801d49:	eb 05                	jmp    801d50 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801d4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d50:	83 c4 24             	add    $0x24,%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5d                   	pop    %ebp
  801d55:	c3                   	ret    

00801d56 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	53                   	push   %ebx
  801d5a:	83 ec 24             	sub    $0x24,%esp
  801d5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	89 04 24             	mov    %eax,(%esp)
  801d6d:	e8 34 fb ff ff       	call   8018a6 <fd_lookup>
  801d72:	89 c2                	mov    %eax,%edx
  801d74:	85 d2                	test   %edx,%edx
  801d76:	78 52                	js     801dca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d82:	8b 00                	mov    (%eax),%eax
  801d84:	89 04 24             	mov    %eax,(%esp)
  801d87:	e8 70 fb ff ff       	call   8018fc <dev_lookup>
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	78 3a                	js     801dca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d97:	74 2c                	je     801dc5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d99:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d9c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801da3:	00 00 00 
	stat->st_isdir = 0;
  801da6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dad:	00 00 00 
	stat->st_dev = dev;
  801db0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801db6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dbd:	89 14 24             	mov    %edx,(%esp)
  801dc0:	ff 50 14             	call   *0x14(%eax)
  801dc3:	eb 05                	jmp    801dca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801dc5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801dca:	83 c4 24             	add    $0x24,%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    

00801dd0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	56                   	push   %esi
  801dd4:	53                   	push   %ebx
  801dd5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801dd8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ddf:	00 
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	89 04 24             	mov    %eax,(%esp)
  801de6:	e8 99 02 00 00       	call   802084 <open>
  801deb:	89 c3                	mov    %eax,%ebx
  801ded:	85 db                	test   %ebx,%ebx
  801def:	78 1b                	js     801e0c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df8:	89 1c 24             	mov    %ebx,(%esp)
  801dfb:	e8 56 ff ff ff       	call   801d56 <fstat>
  801e00:	89 c6                	mov    %eax,%esi
	close(fd);
  801e02:	89 1c 24             	mov    %ebx,(%esp)
  801e05:	e8 cd fb ff ff       	call   8019d7 <close>
	return r;
  801e0a:	89 f0                	mov    %esi,%eax
}
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 10             	sub    $0x10,%esp
  801e1b:	89 c6                	mov    %eax,%esi
  801e1d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e1f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801e26:	75 11                	jne    801e39 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e2f:	e8 bb f9 ff ff       	call   8017ef <ipc_find_env>
  801e34:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e39:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e40:	00 
  801e41:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e48:	00 
  801e49:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e4d:	a1 00 50 80 00       	mov    0x805000,%eax
  801e52:	89 04 24             	mov    %eax,(%esp)
  801e55:	e8 2e f9 ff ff       	call   801788 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e61:	00 
  801e62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e6d:	e8 ae f8 ff ff       	call   801720 <ipc_recv>
}
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5e                   	pop    %esi
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    

00801e79 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8b 40 0c             	mov    0xc(%eax),%eax
  801e85:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e92:	ba 00 00 00 00       	mov    $0x0,%edx
  801e97:	b8 02 00 00 00       	mov    $0x2,%eax
  801e9c:	e8 72 ff ff ff       	call   801e13 <fsipc>
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb9:	b8 06 00 00 00       	mov    $0x6,%eax
  801ebe:	e8 50 ff ff ff       	call   801e13 <fsipc>
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	53                   	push   %ebx
  801ec9:	83 ec 14             	sub    $0x14,%esp
  801ecc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801eda:	ba 00 00 00 00       	mov    $0x0,%edx
  801edf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ee4:	e8 2a ff ff ff       	call   801e13 <fsipc>
  801ee9:	89 c2                	mov    %eax,%edx
  801eeb:	85 d2                	test   %edx,%edx
  801eed:	78 2b                	js     801f1a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801eef:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ef6:	00 
  801ef7:	89 1c 24             	mov    %ebx,(%esp)
  801efa:	e8 f8 ea ff ff       	call   8009f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801eff:	a1 80 60 80 00       	mov    0x806080,%eax
  801f04:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f0a:	a1 84 60 80 00       	mov    0x806084,%eax
  801f0f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1a:	83 c4 14             	add    $0x14,%esp
  801f1d:	5b                   	pop    %ebx
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    

00801f20 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	53                   	push   %ebx
  801f24:	83 ec 14             	sub    $0x14,%esp
  801f27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801f2a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801f30:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801f35:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f38:	8b 55 08             	mov    0x8(%ebp),%edx
  801f3b:	8b 52 0c             	mov    0xc(%edx),%edx
  801f3e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801f44:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801f49:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f54:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801f5b:	e8 34 ec ff ff       	call   800b94 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801f60:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801f67:	00 
  801f68:	c7 04 24 ec 34 80 00 	movl   $0x8034ec,(%esp)
  801f6f:	e8 04 e4 ff ff       	call   800378 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f74:	ba 00 00 00 00       	mov    $0x0,%edx
  801f79:	b8 04 00 00 00       	mov    $0x4,%eax
  801f7e:	e8 90 fe ff ff       	call   801e13 <fsipc>
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 53                	js     801fda <devfile_write+0xba>
		return r;
	assert(r <= n);
  801f87:	39 c3                	cmp    %eax,%ebx
  801f89:	73 24                	jae    801faf <devfile_write+0x8f>
  801f8b:	c7 44 24 0c f1 34 80 	movl   $0x8034f1,0xc(%esp)
  801f92:	00 
  801f93:	c7 44 24 08 f8 34 80 	movl   $0x8034f8,0x8(%esp)
  801f9a:	00 
  801f9b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801fa2:	00 
  801fa3:	c7 04 24 0d 35 80 00 	movl   $0x80350d,(%esp)
  801faa:	e8 d0 e2 ff ff       	call   80027f <_panic>
	assert(r <= PGSIZE);
  801faf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fb4:	7e 24                	jle    801fda <devfile_write+0xba>
  801fb6:	c7 44 24 0c 18 35 80 	movl   $0x803518,0xc(%esp)
  801fbd:	00 
  801fbe:	c7 44 24 08 f8 34 80 	movl   $0x8034f8,0x8(%esp)
  801fc5:	00 
  801fc6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801fcd:	00 
  801fce:	c7 04 24 0d 35 80 00 	movl   $0x80350d,(%esp)
  801fd5:	e8 a5 e2 ff ff       	call   80027f <_panic>
	return r;
}
  801fda:	83 c4 14             	add    $0x14,%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	56                   	push   %esi
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 10             	sub    $0x10,%esp
  801fe8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ff6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ffc:	ba 00 00 00 00       	mov    $0x0,%edx
  802001:	b8 03 00 00 00       	mov    $0x3,%eax
  802006:	e8 08 fe ff ff       	call   801e13 <fsipc>
  80200b:	89 c3                	mov    %eax,%ebx
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 6a                	js     80207b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802011:	39 c6                	cmp    %eax,%esi
  802013:	73 24                	jae    802039 <devfile_read+0x59>
  802015:	c7 44 24 0c f1 34 80 	movl   $0x8034f1,0xc(%esp)
  80201c:	00 
  80201d:	c7 44 24 08 f8 34 80 	movl   $0x8034f8,0x8(%esp)
  802024:	00 
  802025:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80202c:	00 
  80202d:	c7 04 24 0d 35 80 00 	movl   $0x80350d,(%esp)
  802034:	e8 46 e2 ff ff       	call   80027f <_panic>
	assert(r <= PGSIZE);
  802039:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80203e:	7e 24                	jle    802064 <devfile_read+0x84>
  802040:	c7 44 24 0c 18 35 80 	movl   $0x803518,0xc(%esp)
  802047:	00 
  802048:	c7 44 24 08 f8 34 80 	movl   $0x8034f8,0x8(%esp)
  80204f:	00 
  802050:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802057:	00 
  802058:	c7 04 24 0d 35 80 00 	movl   $0x80350d,(%esp)
  80205f:	e8 1b e2 ff ff       	call   80027f <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802064:	89 44 24 08          	mov    %eax,0x8(%esp)
  802068:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80206f:	00 
  802070:	8b 45 0c             	mov    0xc(%ebp),%eax
  802073:	89 04 24             	mov    %eax,(%esp)
  802076:	e8 19 eb ff ff       	call   800b94 <memmove>
	return r;
}
  80207b:	89 d8                	mov    %ebx,%eax
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	53                   	push   %ebx
  802088:	83 ec 24             	sub    $0x24,%esp
  80208b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80208e:	89 1c 24             	mov    %ebx,(%esp)
  802091:	e8 2a e9 ff ff       	call   8009c0 <strlen>
  802096:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80209b:	7f 60                	jg     8020fd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80209d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a0:	89 04 24             	mov    %eax,(%esp)
  8020a3:	e8 af f7 ff ff       	call   801857 <fd_alloc>
  8020a8:	89 c2                	mov    %eax,%edx
  8020aa:	85 d2                	test   %edx,%edx
  8020ac:	78 54                	js     802102 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8020ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020b2:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  8020b9:	e8 39 e9 ff ff       	call   8009f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8020be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ce:	e8 40 fd ff ff       	call   801e13 <fsipc>
  8020d3:	89 c3                	mov    %eax,%ebx
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	79 17                	jns    8020f0 <open+0x6c>
		fd_close(fd, 0);
  8020d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020e0:	00 
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	89 04 24             	mov    %eax,(%esp)
  8020e7:	e8 6a f8 ff ff       	call   801956 <fd_close>
		return r;
  8020ec:	89 d8                	mov    %ebx,%eax
  8020ee:	eb 12                	jmp    802102 <open+0x7e>
	}

	return fd2num(fd);
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	89 04 24             	mov    %eax,(%esp)
  8020f6:	e8 35 f7 ff ff       	call   801830 <fd2num>
  8020fb:	eb 05                	jmp    802102 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8020fd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802102:	83 c4 24             	add    $0x24,%esp
  802105:	5b                   	pop    %ebx
  802106:	5d                   	pop    %ebp
  802107:	c3                   	ret    

00802108 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80210e:	ba 00 00 00 00       	mov    $0x0,%edx
  802113:	b8 08 00 00 00       	mov    $0x8,%eax
  802118:	e8 f6 fc ff ff       	call   801e13 <fsipc>
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <evict>:

int evict(void)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802125:	c7 04 24 24 35 80 00 	movl   $0x803524,(%esp)
  80212c:	e8 47 e2 ff ff       	call   800378 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802131:	ba 00 00 00 00       	mov    $0x0,%edx
  802136:	b8 09 00 00 00       	mov    $0x9,%eax
  80213b:	e8 d3 fc ff ff       	call   801e13 <fsipc>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802148:	89 d0                	mov    %edx,%eax
  80214a:	c1 e8 16             	shr    $0x16,%eax
  80214d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802154:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802159:	f6 c1 01             	test   $0x1,%cl
  80215c:	74 1d                	je     80217b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80215e:	c1 ea 0c             	shr    $0xc,%edx
  802161:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802168:	f6 c2 01             	test   $0x1,%dl
  80216b:	74 0e                	je     80217b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80216d:	c1 ea 0c             	shr    $0xc,%edx
  802170:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802177:	ef 
  802178:	0f b7 c0             	movzwl %ax,%eax
}
  80217b:	5d                   	pop    %ebp
  80217c:	c3                   	ret    
  80217d:	66 90                	xchg   %ax,%ax
  80217f:	90                   	nop

00802180 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802186:	c7 44 24 04 3d 35 80 	movl   $0x80353d,0x4(%esp)
  80218d:	00 
  80218e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802191:	89 04 24             	mov    %eax,(%esp)
  802194:	e8 5e e8 ff ff       	call   8009f7 <strcpy>
	return 0;
}
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	53                   	push   %ebx
  8021a4:	83 ec 14             	sub    $0x14,%esp
  8021a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8021aa:	89 1c 24             	mov    %ebx,(%esp)
  8021ad:	e8 90 ff ff ff       	call   802142 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8021b2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8021b7:	83 f8 01             	cmp    $0x1,%eax
  8021ba:	75 0d                	jne    8021c9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8021bc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8021bf:	89 04 24             	mov    %eax,(%esp)
  8021c2:	e8 29 03 00 00       	call   8024f0 <nsipc_close>
  8021c7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8021c9:	89 d0                	mov    %edx,%eax
  8021cb:	83 c4 14             	add    $0x14,%esp
  8021ce:	5b                   	pop    %ebx
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    

008021d1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8021d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021de:	00 
  8021df:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f3:	89 04 24             	mov    %eax,(%esp)
  8021f6:	e8 f0 03 00 00       	call   8025eb <nsipc_send>
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802203:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80220a:	00 
  80220b:	8b 45 10             	mov    0x10(%ebp),%eax
  80220e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802212:	8b 45 0c             	mov    0xc(%ebp),%eax
  802215:	89 44 24 04          	mov    %eax,0x4(%esp)
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	8b 40 0c             	mov    0xc(%eax),%eax
  80221f:	89 04 24             	mov    %eax,(%esp)
  802222:	e8 44 03 00 00       	call   80256b <nsipc_recv>
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80222f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802232:	89 54 24 04          	mov    %edx,0x4(%esp)
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 68 f6 ff ff       	call   8018a6 <fd_lookup>
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 17                	js     802259 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80224b:	39 08                	cmp    %ecx,(%eax)
  80224d:	75 05                	jne    802254 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80224f:	8b 40 0c             	mov    0xc(%eax),%eax
  802252:	eb 05                	jmp    802259 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802254:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	56                   	push   %esi
  80225f:	53                   	push   %ebx
  802260:	83 ec 20             	sub    $0x20,%esp
  802263:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802265:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802268:	89 04 24             	mov    %eax,(%esp)
  80226b:	e8 e7 f5 ff ff       	call   801857 <fd_alloc>
  802270:	89 c3                	mov    %eax,%ebx
  802272:	85 c0                	test   %eax,%eax
  802274:	78 21                	js     802297 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802276:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80227d:	00 
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	89 44 24 04          	mov    %eax,0x4(%esp)
  802285:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80228c:	e8 d4 eb ff ff       	call   800e65 <sys_page_alloc>
  802291:	89 c3                	mov    %eax,%ebx
  802293:	85 c0                	test   %eax,%eax
  802295:	79 0c                	jns    8022a3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802297:	89 34 24             	mov    %esi,(%esp)
  80229a:	e8 51 02 00 00       	call   8024f0 <nsipc_close>
		return r;
  80229f:	89 d8                	mov    %ebx,%eax
  8022a1:	eb 20                	jmp    8022c3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8022a3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8022ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8022b8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8022bb:	89 14 24             	mov    %edx,(%esp)
  8022be:	e8 6d f5 ff ff       	call   801830 <fd2num>
}
  8022c3:	83 c4 20             	add    $0x20,%esp
  8022c6:	5b                   	pop    %ebx
  8022c7:	5e                   	pop    %esi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    

008022ca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	e8 51 ff ff ff       	call   802229 <fd2sockid>
		return r;
  8022d8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	78 23                	js     802301 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8022de:	8b 55 10             	mov    0x10(%ebp),%edx
  8022e1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ec:	89 04 24             	mov    %eax,(%esp)
  8022ef:	e8 45 01 00 00       	call   802439 <nsipc_accept>
		return r;
  8022f4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	78 07                	js     802301 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8022fa:	e8 5c ff ff ff       	call   80225b <alloc_sockfd>
  8022ff:	89 c1                	mov    %eax,%ecx
}
  802301:	89 c8                	mov    %ecx,%eax
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	e8 16 ff ff ff       	call   802229 <fd2sockid>
  802313:	89 c2                	mov    %eax,%edx
  802315:	85 d2                	test   %edx,%edx
  802317:	78 16                	js     80232f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802319:	8b 45 10             	mov    0x10(%ebp),%eax
  80231c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802320:	8b 45 0c             	mov    0xc(%ebp),%eax
  802323:	89 44 24 04          	mov    %eax,0x4(%esp)
  802327:	89 14 24             	mov    %edx,(%esp)
  80232a:	e8 60 01 00 00       	call   80248f <nsipc_bind>
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <shutdown>:

int
shutdown(int s, int how)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	e8 ea fe ff ff       	call   802229 <fd2sockid>
  80233f:	89 c2                	mov    %eax,%edx
  802341:	85 d2                	test   %edx,%edx
  802343:	78 0f                	js     802354 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802345:	8b 45 0c             	mov    0xc(%ebp),%eax
  802348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234c:	89 14 24             	mov    %edx,(%esp)
  80234f:	e8 7a 01 00 00       	call   8024ce <nsipc_shutdown>
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	e8 c5 fe ff ff       	call   802229 <fd2sockid>
  802364:	89 c2                	mov    %eax,%edx
  802366:	85 d2                	test   %edx,%edx
  802368:	78 16                	js     802380 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80236a:	8b 45 10             	mov    0x10(%ebp),%eax
  80236d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	89 44 24 04          	mov    %eax,0x4(%esp)
  802378:	89 14 24             	mov    %edx,(%esp)
  80237b:	e8 8a 01 00 00       	call   80250a <nsipc_connect>
}
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <listen>:

int
listen(int s, int backlog)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
  802385:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	e8 99 fe ff ff       	call   802229 <fd2sockid>
  802390:	89 c2                	mov    %eax,%edx
  802392:	85 d2                	test   %edx,%edx
  802394:	78 0f                	js     8023a5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239d:	89 14 24             	mov    %edx,(%esp)
  8023a0:	e8 a4 01 00 00       	call   802549 <nsipc_listen>
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8023ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	89 04 24             	mov    %eax,(%esp)
  8023c1:	e8 98 02 00 00       	call   80265e <nsipc_socket>
  8023c6:	89 c2                	mov    %eax,%edx
  8023c8:	85 d2                	test   %edx,%edx
  8023ca:	78 05                	js     8023d1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8023cc:	e8 8a fe ff ff       	call   80225b <alloc_sockfd>
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	53                   	push   %ebx
  8023d7:	83 ec 14             	sub    $0x14,%esp
  8023da:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8023dc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8023e3:	75 11                	jne    8023f6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8023e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8023ec:	e8 fe f3 ff ff       	call   8017ef <ipc_find_env>
  8023f1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8023f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023fd:	00 
  8023fe:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802405:	00 
  802406:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80240a:	a1 04 50 80 00       	mov    0x805004,%eax
  80240f:	89 04 24             	mov    %eax,(%esp)
  802412:	e8 71 f3 ff ff       	call   801788 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802417:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80241e:	00 
  80241f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802426:	00 
  802427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80242e:	e8 ed f2 ff ff       	call   801720 <ipc_recv>
}
  802433:	83 c4 14             	add    $0x14,%esp
  802436:	5b                   	pop    %ebx
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	56                   	push   %esi
  80243d:	53                   	push   %ebx
  80243e:	83 ec 10             	sub    $0x10,%esp
  802441:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80244c:	8b 06                	mov    (%esi),%eax
  80244e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802453:	b8 01 00 00 00       	mov    $0x1,%eax
  802458:	e8 76 ff ff ff       	call   8023d3 <nsipc>
  80245d:	89 c3                	mov    %eax,%ebx
  80245f:	85 c0                	test   %eax,%eax
  802461:	78 23                	js     802486 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802463:	a1 10 70 80 00       	mov    0x807010,%eax
  802468:	89 44 24 08          	mov    %eax,0x8(%esp)
  80246c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802473:	00 
  802474:	8b 45 0c             	mov    0xc(%ebp),%eax
  802477:	89 04 24             	mov    %eax,(%esp)
  80247a:	e8 15 e7 ff ff       	call   800b94 <memmove>
		*addrlen = ret->ret_addrlen;
  80247f:	a1 10 70 80 00       	mov    0x807010,%eax
  802484:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802486:	89 d8                	mov    %ebx,%eax
  802488:	83 c4 10             	add    $0x10,%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5d                   	pop    %ebp
  80248e:	c3                   	ret    

0080248f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	53                   	push   %ebx
  802493:	83 ec 14             	sub    $0x14,%esp
  802496:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ac:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8024b3:	e8 dc e6 ff ff       	call   800b94 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024b8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8024be:	b8 02 00 00 00       	mov    $0x2,%eax
  8024c3:	e8 0b ff ff ff       	call   8023d3 <nsipc>
}
  8024c8:	83 c4 14             	add    $0x14,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5d                   	pop    %ebp
  8024cd:	c3                   	ret    

008024ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8024dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024df:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8024e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8024e9:	e8 e5 fe ff ff       	call   8023d3 <nsipc>
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <nsipc_close>:

int
nsipc_close(int s)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8024fe:	b8 04 00 00 00       	mov    $0x4,%eax
  802503:	e8 cb fe ff ff       	call   8023d3 <nsipc>
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	53                   	push   %ebx
  80250e:	83 ec 14             	sub    $0x14,%esp
  802511:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80251c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802520:	8b 45 0c             	mov    0xc(%ebp),%eax
  802523:	89 44 24 04          	mov    %eax,0x4(%esp)
  802527:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80252e:	e8 61 e6 ff ff       	call   800b94 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802533:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802539:	b8 05 00 00 00       	mov    $0x5,%eax
  80253e:	e8 90 fe ff ff       	call   8023d3 <nsipc>
}
  802543:	83 c4 14             	add    $0x14,%esp
  802546:	5b                   	pop    %ebx
  802547:	5d                   	pop    %ebp
  802548:	c3                   	ret    

00802549 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
  802552:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80255f:	b8 06 00 00 00       	mov    $0x6,%eax
  802564:	e8 6a fe ff ff       	call   8023d3 <nsipc>
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	56                   	push   %esi
  80256f:	53                   	push   %ebx
  802570:	83 ec 10             	sub    $0x10,%esp
  802573:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80257e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802584:	8b 45 14             	mov    0x14(%ebp),%eax
  802587:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80258c:	b8 07 00 00 00       	mov    $0x7,%eax
  802591:	e8 3d fe ff ff       	call   8023d3 <nsipc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	85 c0                	test   %eax,%eax
  80259a:	78 46                	js     8025e2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80259c:	39 f0                	cmp    %esi,%eax
  80259e:	7f 07                	jg     8025a7 <nsipc_recv+0x3c>
  8025a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8025a5:	7e 24                	jle    8025cb <nsipc_recv+0x60>
  8025a7:	c7 44 24 0c 49 35 80 	movl   $0x803549,0xc(%esp)
  8025ae:	00 
  8025af:	c7 44 24 08 f8 34 80 	movl   $0x8034f8,0x8(%esp)
  8025b6:	00 
  8025b7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8025be:	00 
  8025bf:	c7 04 24 5e 35 80 00 	movl   $0x80355e,(%esp)
  8025c6:	e8 b4 dc ff ff       	call   80027f <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025cf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8025d6:	00 
  8025d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025da:	89 04 24             	mov    %eax,(%esp)
  8025dd:	e8 b2 e5 ff ff       	call   800b94 <memmove>
	}

	return r;
}
  8025e2:	89 d8                	mov    %ebx,%eax
  8025e4:	83 c4 10             	add    $0x10,%esp
  8025e7:	5b                   	pop    %ebx
  8025e8:	5e                   	pop    %esi
  8025e9:	5d                   	pop    %ebp
  8025ea:	c3                   	ret    

008025eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	53                   	push   %ebx
  8025ef:	83 ec 14             	sub    $0x14,%esp
  8025f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8025fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802603:	7e 24                	jle    802629 <nsipc_send+0x3e>
  802605:	c7 44 24 0c 6a 35 80 	movl   $0x80356a,0xc(%esp)
  80260c:	00 
  80260d:	c7 44 24 08 f8 34 80 	movl   $0x8034f8,0x8(%esp)
  802614:	00 
  802615:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80261c:	00 
  80261d:	c7 04 24 5e 35 80 00 	movl   $0x80355e,(%esp)
  802624:	e8 56 dc ff ff       	call   80027f <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802629:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80262d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802630:	89 44 24 04          	mov    %eax,0x4(%esp)
  802634:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80263b:	e8 54 e5 ff ff       	call   800b94 <memmove>
	nsipcbuf.send.req_size = size;
  802640:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802646:	8b 45 14             	mov    0x14(%ebp),%eax
  802649:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80264e:	b8 08 00 00 00       	mov    $0x8,%eax
  802653:	e8 7b fd ff ff       	call   8023d3 <nsipc>
}
  802658:	83 c4 14             	add    $0x14,%esp
  80265b:	5b                   	pop    %ebx
  80265c:	5d                   	pop    %ebp
  80265d:	c3                   	ret    

0080265e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
  802661:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80266c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802674:	8b 45 10             	mov    0x10(%ebp),%eax
  802677:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80267c:	b8 09 00 00 00       	mov    $0x9,%eax
  802681:	e8 4d fd ff ff       	call   8023d3 <nsipc>
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	56                   	push   %esi
  80268c:	53                   	push   %ebx
  80268d:	83 ec 10             	sub    $0x10,%esp
  802690:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	89 04 24             	mov    %eax,(%esp)
  802699:	e8 a2 f1 ff ff       	call   801840 <fd2data>
  80269e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8026a0:	c7 44 24 04 76 35 80 	movl   $0x803576,0x4(%esp)
  8026a7:	00 
  8026a8:	89 1c 24             	mov    %ebx,(%esp)
  8026ab:	e8 47 e3 ff ff       	call   8009f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8026b0:	8b 46 04             	mov    0x4(%esi),%eax
  8026b3:	2b 06                	sub    (%esi),%eax
  8026b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8026bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026c2:	00 00 00 
	stat->st_dev = &devpipe;
  8026c5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8026cc:	40 80 00 
	return 0;
}
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	5b                   	pop    %ebx
  8026d8:	5e                   	pop    %esi
  8026d9:	5d                   	pop    %ebp
  8026da:	c3                   	ret    

008026db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	53                   	push   %ebx
  8026df:	83 ec 14             	sub    $0x14,%esp
  8026e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f0:	e8 17 e8 ff ff       	call   800f0c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026f5:	89 1c 24             	mov    %ebx,(%esp)
  8026f8:	e8 43 f1 ff ff       	call   801840 <fd2data>
  8026fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802701:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802708:	e8 ff e7 ff ff       	call   800f0c <sys_page_unmap>
}
  80270d:	83 c4 14             	add    $0x14,%esp
  802710:	5b                   	pop    %ebx
  802711:	5d                   	pop    %ebp
  802712:	c3                   	ret    

00802713 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
  802716:	57                   	push   %edi
  802717:	56                   	push   %esi
  802718:	53                   	push   %ebx
  802719:	83 ec 2c             	sub    $0x2c,%esp
  80271c:	89 c6                	mov    %eax,%esi
  80271e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802721:	a1 08 50 80 00       	mov    0x805008,%eax
  802726:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802729:	89 34 24             	mov    %esi,(%esp)
  80272c:	e8 11 fa ff ff       	call   802142 <pageref>
  802731:	89 c7                	mov    %eax,%edi
  802733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802736:	89 04 24             	mov    %eax,(%esp)
  802739:	e8 04 fa ff ff       	call   802142 <pageref>
  80273e:	39 c7                	cmp    %eax,%edi
  802740:	0f 94 c2             	sete   %dl
  802743:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802746:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80274c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80274f:	39 fb                	cmp    %edi,%ebx
  802751:	74 21                	je     802774 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802753:	84 d2                	test   %dl,%dl
  802755:	74 ca                	je     802721 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802757:	8b 51 58             	mov    0x58(%ecx),%edx
  80275a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80275e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802762:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802766:	c7 04 24 7d 35 80 00 	movl   $0x80357d,(%esp)
  80276d:	e8 06 dc ff ff       	call   800378 <cprintf>
  802772:	eb ad                	jmp    802721 <_pipeisclosed+0xe>
	}
}
  802774:	83 c4 2c             	add    $0x2c,%esp
  802777:	5b                   	pop    %ebx
  802778:	5e                   	pop    %esi
  802779:	5f                   	pop    %edi
  80277a:	5d                   	pop    %ebp
  80277b:	c3                   	ret    

0080277c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	57                   	push   %edi
  802780:	56                   	push   %esi
  802781:	53                   	push   %ebx
  802782:	83 ec 1c             	sub    $0x1c,%esp
  802785:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802788:	89 34 24             	mov    %esi,(%esp)
  80278b:	e8 b0 f0 ff ff       	call   801840 <fd2data>
  802790:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802792:	bf 00 00 00 00       	mov    $0x0,%edi
  802797:	eb 45                	jmp    8027de <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802799:	89 da                	mov    %ebx,%edx
  80279b:	89 f0                	mov    %esi,%eax
  80279d:	e8 71 ff ff ff       	call   802713 <_pipeisclosed>
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	75 41                	jne    8027e7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8027a6:	e8 9b e6 ff ff       	call   800e46 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8027ae:	8b 0b                	mov    (%ebx),%ecx
  8027b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8027b3:	39 d0                	cmp    %edx,%eax
  8027b5:	73 e2                	jae    802799 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8027be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8027c1:	99                   	cltd   
  8027c2:	c1 ea 1b             	shr    $0x1b,%edx
  8027c5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8027c8:	83 e1 1f             	and    $0x1f,%ecx
  8027cb:	29 d1                	sub    %edx,%ecx
  8027cd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8027d1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8027d5:	83 c0 01             	add    $0x1,%eax
  8027d8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027db:	83 c7 01             	add    $0x1,%edi
  8027de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8027e1:	75 c8                	jne    8027ab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8027e3:	89 f8                	mov    %edi,%eax
  8027e5:	eb 05                	jmp    8027ec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8027ec:	83 c4 1c             	add    $0x1c,%esp
  8027ef:	5b                   	pop    %ebx
  8027f0:	5e                   	pop    %esi
  8027f1:	5f                   	pop    %edi
  8027f2:	5d                   	pop    %ebp
  8027f3:	c3                   	ret    

008027f4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	57                   	push   %edi
  8027f8:	56                   	push   %esi
  8027f9:	53                   	push   %ebx
  8027fa:	83 ec 1c             	sub    $0x1c,%esp
  8027fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802800:	89 3c 24             	mov    %edi,(%esp)
  802803:	e8 38 f0 ff ff       	call   801840 <fd2data>
  802808:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80280a:	be 00 00 00 00       	mov    $0x0,%esi
  80280f:	eb 3d                	jmp    80284e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802811:	85 f6                	test   %esi,%esi
  802813:	74 04                	je     802819 <devpipe_read+0x25>
				return i;
  802815:	89 f0                	mov    %esi,%eax
  802817:	eb 43                	jmp    80285c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802819:	89 da                	mov    %ebx,%edx
  80281b:	89 f8                	mov    %edi,%eax
  80281d:	e8 f1 fe ff ff       	call   802713 <_pipeisclosed>
  802822:	85 c0                	test   %eax,%eax
  802824:	75 31                	jne    802857 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802826:	e8 1b e6 ff ff       	call   800e46 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80282b:	8b 03                	mov    (%ebx),%eax
  80282d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802830:	74 df                	je     802811 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802832:	99                   	cltd   
  802833:	c1 ea 1b             	shr    $0x1b,%edx
  802836:	01 d0                	add    %edx,%eax
  802838:	83 e0 1f             	and    $0x1f,%eax
  80283b:	29 d0                	sub    %edx,%eax
  80283d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802845:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802848:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80284b:	83 c6 01             	add    $0x1,%esi
  80284e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802851:	75 d8                	jne    80282b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802853:	89 f0                	mov    %esi,%eax
  802855:	eb 05                	jmp    80285c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80285c:	83 c4 1c             	add    $0x1c,%esp
  80285f:	5b                   	pop    %ebx
  802860:	5e                   	pop    %esi
  802861:	5f                   	pop    %edi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    

00802864 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	56                   	push   %esi
  802868:	53                   	push   %ebx
  802869:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80286c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80286f:	89 04 24             	mov    %eax,(%esp)
  802872:	e8 e0 ef ff ff       	call   801857 <fd_alloc>
  802877:	89 c2                	mov    %eax,%edx
  802879:	85 d2                	test   %edx,%edx
  80287b:	0f 88 4d 01 00 00    	js     8029ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802881:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802888:	00 
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802897:	e8 c9 e5 ff ff       	call   800e65 <sys_page_alloc>
  80289c:	89 c2                	mov    %eax,%edx
  80289e:	85 d2                	test   %edx,%edx
  8028a0:	0f 88 28 01 00 00    	js     8029ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028a9:	89 04 24             	mov    %eax,(%esp)
  8028ac:	e8 a6 ef ff ff       	call   801857 <fd_alloc>
  8028b1:	89 c3                	mov    %eax,%ebx
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	0f 88 fe 00 00 00    	js     8029b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028c2:	00 
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d1:	e8 8f e5 ff ff       	call   800e65 <sys_page_alloc>
  8028d6:	89 c3                	mov    %eax,%ebx
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	0f 88 d9 00 00 00    	js     8029b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	89 04 24             	mov    %eax,(%esp)
  8028e6:	e8 55 ef ff ff       	call   801840 <fd2data>
  8028eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028f4:	00 
  8028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802900:	e8 60 e5 ff ff       	call   800e65 <sys_page_alloc>
  802905:	89 c3                	mov    %eax,%ebx
  802907:	85 c0                	test   %eax,%eax
  802909:	0f 88 97 00 00 00    	js     8029a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	89 04 24             	mov    %eax,(%esp)
  802915:	e8 26 ef ff ff       	call   801840 <fd2data>
  80291a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802921:	00 
  802922:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802926:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80292d:	00 
  80292e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802932:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802939:	e8 7b e5 ff ff       	call   800eb9 <sys_page_map>
  80293e:	89 c3                	mov    %eax,%ebx
  802940:	85 c0                	test   %eax,%eax
  802942:	78 52                	js     802996 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802944:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802959:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802962:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802967:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	89 04 24             	mov    %eax,(%esp)
  802974:	e8 b7 ee ff ff       	call   801830 <fd2num>
  802979:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80297c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	89 04 24             	mov    %eax,(%esp)
  802984:	e8 a7 ee ff ff       	call   801830 <fd2num>
  802989:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80298c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
  802994:	eb 38                	jmp    8029ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802996:	89 74 24 04          	mov    %esi,0x4(%esp)
  80299a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a1:	e8 66 e5 ff ff       	call   800f0c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b4:	e8 53 e5 ff ff       	call   800f0c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c7:	e8 40 e5 ff ff       	call   800f0c <sys_page_unmap>
  8029cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8029ce:	83 c4 30             	add    $0x30,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5d                   	pop    %ebp
  8029d4:	c3                   	ret    

008029d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
  8029d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	89 04 24             	mov    %eax,(%esp)
  8029e8:	e8 b9 ee ff ff       	call   8018a6 <fd_lookup>
  8029ed:	89 c2                	mov    %eax,%edx
  8029ef:	85 d2                	test   %edx,%edx
  8029f1:	78 15                	js     802a08 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	89 04 24             	mov    %eax,(%esp)
  8029f9:	e8 42 ee ff ff       	call   801840 <fd2data>
	return _pipeisclosed(fd, p);
  8029fe:	89 c2                	mov    %eax,%edx
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	e8 0b fd ff ff       	call   802713 <_pipeisclosed>
}
  802a08:	c9                   	leave  
  802a09:	c3                   	ret    
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
  802a18:	5d                   	pop    %ebp
  802a19:	c3                   	ret    

00802a1a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a20:	c7 44 24 04 95 35 80 	movl   $0x803595,0x4(%esp)
  802a27:	00 
  802a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2b:	89 04 24             	mov    %eax,(%esp)
  802a2e:	e8 c4 df ff ff       	call   8009f7 <strcpy>
	return 0;
}
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	c9                   	leave  
  802a39:	c3                   	ret    

00802a3a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a3a:	55                   	push   %ebp
  802a3b:	89 e5                	mov    %esp,%ebp
  802a3d:	57                   	push   %edi
  802a3e:	56                   	push   %esi
  802a3f:	53                   	push   %ebx
  802a40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a46:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a4b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a51:	eb 31                	jmp    802a84 <devcons_write+0x4a>
		m = n - tot;
  802a53:	8b 75 10             	mov    0x10(%ebp),%esi
  802a56:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802a58:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802a5b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802a60:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a63:	89 74 24 08          	mov    %esi,0x8(%esp)
  802a67:	03 45 0c             	add    0xc(%ebp),%eax
  802a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6e:	89 3c 24             	mov    %edi,(%esp)
  802a71:	e8 1e e1 ff ff       	call   800b94 <memmove>
		sys_cputs(buf, m);
  802a76:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a7a:	89 3c 24             	mov    %edi,(%esp)
  802a7d:	e8 c4 e2 ff ff       	call   800d46 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a82:	01 f3                	add    %esi,%ebx
  802a84:	89 d8                	mov    %ebx,%eax
  802a86:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802a89:	72 c8                	jb     802a53 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a8b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a91:	5b                   	pop    %ebx
  802a92:	5e                   	pop    %esi
  802a93:	5f                   	pop    %edi
  802a94:	5d                   	pop    %ebp
  802a95:	c3                   	ret    

00802a96 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
  802a99:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802a9c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802aa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802aa5:	75 07                	jne    802aae <devcons_read+0x18>
  802aa7:	eb 2a                	jmp    802ad3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802aa9:	e8 98 e3 ff ff       	call   800e46 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802aae:	66 90                	xchg   %ax,%ax
  802ab0:	e8 af e2 ff ff       	call   800d64 <sys_cgetc>
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 f0                	je     802aa9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	78 16                	js     802ad3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802abd:	83 f8 04             	cmp    $0x4,%eax
  802ac0:	74 0c                	je     802ace <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac5:	88 02                	mov    %al,(%edx)
	return 1;
  802ac7:	b8 01 00 00 00       	mov    $0x1,%eax
  802acc:	eb 05                	jmp    802ad3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802ad3:	c9                   	leave  
  802ad4:	c3                   	ret    

00802ad5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802ad5:	55                   	push   %ebp
  802ad6:	89 e5                	mov    %esp,%ebp
  802ad8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802ae1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802ae8:	00 
  802ae9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802aec:	89 04 24             	mov    %eax,(%esp)
  802aef:	e8 52 e2 ff ff       	call   800d46 <sys_cputs>
}
  802af4:	c9                   	leave  
  802af5:	c3                   	ret    

00802af6 <getchar>:

int
getchar(void)
{
  802af6:	55                   	push   %ebp
  802af7:	89 e5                	mov    %esp,%ebp
  802af9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802afc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802b03:	00 
  802b04:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b12:	e8 23 f0 ff ff       	call   801b3a <read>
	if (r < 0)
  802b17:	85 c0                	test   %eax,%eax
  802b19:	78 0f                	js     802b2a <getchar+0x34>
		return r;
	if (r < 1)
  802b1b:	85 c0                	test   %eax,%eax
  802b1d:	7e 06                	jle    802b25 <getchar+0x2f>
		return -E_EOF;
	return c;
  802b1f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802b23:	eb 05                	jmp    802b2a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802b25:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
  802b2f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	89 04 24             	mov    %eax,(%esp)
  802b3f:	e8 62 ed ff ff       	call   8018a6 <fd_lookup>
  802b44:	85 c0                	test   %eax,%eax
  802b46:	78 11                	js     802b59 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802b51:	39 10                	cmp    %edx,(%eax)
  802b53:	0f 94 c0             	sete   %al
  802b56:	0f b6 c0             	movzbl %al,%eax
}
  802b59:	c9                   	leave  
  802b5a:	c3                   	ret    

00802b5b <opencons>:

int
opencons(void)
{
  802b5b:	55                   	push   %ebp
  802b5c:	89 e5                	mov    %esp,%ebp
  802b5e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b64:	89 04 24             	mov    %eax,(%esp)
  802b67:	e8 eb ec ff ff       	call   801857 <fd_alloc>
		return r;
  802b6c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	78 40                	js     802bb2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b72:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b79:	00 
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b88:	e8 d8 e2 ff ff       	call   800e65 <sys_page_alloc>
		return r;
  802b8d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	78 1f                	js     802bb2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b93:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ba8:	89 04 24             	mov    %eax,(%esp)
  802bab:	e8 80 ec ff ff       	call   801830 <fd2num>
  802bb0:	89 c2                	mov    %eax,%edx
}
  802bb2:	89 d0                	mov    %edx,%eax
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802bbc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802bc3:	75 7a                	jne    802c3f <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802bc5:	e8 5d e2 ff ff       	call   800e27 <sys_getenvid>
  802bca:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802bd1:	00 
  802bd2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802bd9:	ee 
  802bda:	89 04 24             	mov    %eax,(%esp)
  802bdd:	e8 83 e2 ff ff       	call   800e65 <sys_page_alloc>
  802be2:	85 c0                	test   %eax,%eax
  802be4:	79 20                	jns    802c06 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802be6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bea:	c7 44 24 08 89 33 80 	movl   $0x803389,0x8(%esp)
  802bf1:	00 
  802bf2:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802bf9:	00 
  802bfa:	c7 04 24 a1 35 80 00 	movl   $0x8035a1,(%esp)
  802c01:	e8 79 d6 ff ff       	call   80027f <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802c06:	e8 1c e2 ff ff       	call   800e27 <sys_getenvid>
  802c0b:	c7 44 24 04 49 2c 80 	movl   $0x802c49,0x4(%esp)
  802c12:	00 
  802c13:	89 04 24             	mov    %eax,(%esp)
  802c16:	e8 0a e4 ff ff       	call   801025 <sys_env_set_pgfault_upcall>
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	79 20                	jns    802c3f <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802c1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c23:	c7 44 24 08 08 34 80 	movl   $0x803408,0x8(%esp)
  802c2a:	00 
  802c2b:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802c32:	00 
  802c33:	c7 04 24 a1 35 80 00 	movl   $0x8035a1,(%esp)
  802c3a:	e8 40 d6 ff ff       	call   80027f <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802c47:	c9                   	leave  
  802c48:	c3                   	ret    

00802c49 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c49:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c4a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802c4f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c51:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802c54:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802c58:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802c5c:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802c5f:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802c63:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802c65:	83 c4 08             	add    $0x8,%esp
	popal
  802c68:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802c69:	83 c4 04             	add    $0x4,%esp
	popfl
  802c6c:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802c6d:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802c6e:	c3                   	ret    
  802c6f:	90                   	nop

00802c70 <__udivdi3>:
  802c70:	55                   	push   %ebp
  802c71:	57                   	push   %edi
  802c72:	56                   	push   %esi
  802c73:	83 ec 0c             	sub    $0xc,%esp
  802c76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c7a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802c7e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802c82:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c86:	85 c0                	test   %eax,%eax
  802c88:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802c8c:	89 ea                	mov    %ebp,%edx
  802c8e:	89 0c 24             	mov    %ecx,(%esp)
  802c91:	75 2d                	jne    802cc0 <__udivdi3+0x50>
  802c93:	39 e9                	cmp    %ebp,%ecx
  802c95:	77 61                	ja     802cf8 <__udivdi3+0x88>
  802c97:	85 c9                	test   %ecx,%ecx
  802c99:	89 ce                	mov    %ecx,%esi
  802c9b:	75 0b                	jne    802ca8 <__udivdi3+0x38>
  802c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  802ca2:	31 d2                	xor    %edx,%edx
  802ca4:	f7 f1                	div    %ecx
  802ca6:	89 c6                	mov    %eax,%esi
  802ca8:	31 d2                	xor    %edx,%edx
  802caa:	89 e8                	mov    %ebp,%eax
  802cac:	f7 f6                	div    %esi
  802cae:	89 c5                	mov    %eax,%ebp
  802cb0:	89 f8                	mov    %edi,%eax
  802cb2:	f7 f6                	div    %esi
  802cb4:	89 ea                	mov    %ebp,%edx
  802cb6:	83 c4 0c             	add    $0xc,%esp
  802cb9:	5e                   	pop    %esi
  802cba:	5f                   	pop    %edi
  802cbb:	5d                   	pop    %ebp
  802cbc:	c3                   	ret    
  802cbd:	8d 76 00             	lea    0x0(%esi),%esi
  802cc0:	39 e8                	cmp    %ebp,%eax
  802cc2:	77 24                	ja     802ce8 <__udivdi3+0x78>
  802cc4:	0f bd e8             	bsr    %eax,%ebp
  802cc7:	83 f5 1f             	xor    $0x1f,%ebp
  802cca:	75 3c                	jne    802d08 <__udivdi3+0x98>
  802ccc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802cd0:	39 34 24             	cmp    %esi,(%esp)
  802cd3:	0f 86 9f 00 00 00    	jbe    802d78 <__udivdi3+0x108>
  802cd9:	39 d0                	cmp    %edx,%eax
  802cdb:	0f 82 97 00 00 00    	jb     802d78 <__udivdi3+0x108>
  802ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ce8:	31 d2                	xor    %edx,%edx
  802cea:	31 c0                	xor    %eax,%eax
  802cec:	83 c4 0c             	add    $0xc,%esp
  802cef:	5e                   	pop    %esi
  802cf0:	5f                   	pop    %edi
  802cf1:	5d                   	pop    %ebp
  802cf2:	c3                   	ret    
  802cf3:	90                   	nop
  802cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cf8:	89 f8                	mov    %edi,%eax
  802cfa:	f7 f1                	div    %ecx
  802cfc:	31 d2                	xor    %edx,%edx
  802cfe:	83 c4 0c             	add    $0xc,%esp
  802d01:	5e                   	pop    %esi
  802d02:	5f                   	pop    %edi
  802d03:	5d                   	pop    %ebp
  802d04:	c3                   	ret    
  802d05:	8d 76 00             	lea    0x0(%esi),%esi
  802d08:	89 e9                	mov    %ebp,%ecx
  802d0a:	8b 3c 24             	mov    (%esp),%edi
  802d0d:	d3 e0                	shl    %cl,%eax
  802d0f:	89 c6                	mov    %eax,%esi
  802d11:	b8 20 00 00 00       	mov    $0x20,%eax
  802d16:	29 e8                	sub    %ebp,%eax
  802d18:	89 c1                	mov    %eax,%ecx
  802d1a:	d3 ef                	shr    %cl,%edi
  802d1c:	89 e9                	mov    %ebp,%ecx
  802d1e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d22:	8b 3c 24             	mov    (%esp),%edi
  802d25:	09 74 24 08          	or     %esi,0x8(%esp)
  802d29:	89 d6                	mov    %edx,%esi
  802d2b:	d3 e7                	shl    %cl,%edi
  802d2d:	89 c1                	mov    %eax,%ecx
  802d2f:	89 3c 24             	mov    %edi,(%esp)
  802d32:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d36:	d3 ee                	shr    %cl,%esi
  802d38:	89 e9                	mov    %ebp,%ecx
  802d3a:	d3 e2                	shl    %cl,%edx
  802d3c:	89 c1                	mov    %eax,%ecx
  802d3e:	d3 ef                	shr    %cl,%edi
  802d40:	09 d7                	or     %edx,%edi
  802d42:	89 f2                	mov    %esi,%edx
  802d44:	89 f8                	mov    %edi,%eax
  802d46:	f7 74 24 08          	divl   0x8(%esp)
  802d4a:	89 d6                	mov    %edx,%esi
  802d4c:	89 c7                	mov    %eax,%edi
  802d4e:	f7 24 24             	mull   (%esp)
  802d51:	39 d6                	cmp    %edx,%esi
  802d53:	89 14 24             	mov    %edx,(%esp)
  802d56:	72 30                	jb     802d88 <__udivdi3+0x118>
  802d58:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d5c:	89 e9                	mov    %ebp,%ecx
  802d5e:	d3 e2                	shl    %cl,%edx
  802d60:	39 c2                	cmp    %eax,%edx
  802d62:	73 05                	jae    802d69 <__udivdi3+0xf9>
  802d64:	3b 34 24             	cmp    (%esp),%esi
  802d67:	74 1f                	je     802d88 <__udivdi3+0x118>
  802d69:	89 f8                	mov    %edi,%eax
  802d6b:	31 d2                	xor    %edx,%edx
  802d6d:	e9 7a ff ff ff       	jmp    802cec <__udivdi3+0x7c>
  802d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d78:	31 d2                	xor    %edx,%edx
  802d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802d7f:	e9 68 ff ff ff       	jmp    802cec <__udivdi3+0x7c>
  802d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d88:	8d 47 ff             	lea    -0x1(%edi),%eax
  802d8b:	31 d2                	xor    %edx,%edx
  802d8d:	83 c4 0c             	add    $0xc,%esp
  802d90:	5e                   	pop    %esi
  802d91:	5f                   	pop    %edi
  802d92:	5d                   	pop    %ebp
  802d93:	c3                   	ret    
  802d94:	66 90                	xchg   %ax,%ax
  802d96:	66 90                	xchg   %ax,%ax
  802d98:	66 90                	xchg   %ax,%ax
  802d9a:	66 90                	xchg   %ax,%ax
  802d9c:	66 90                	xchg   %ax,%ax
  802d9e:	66 90                	xchg   %ax,%ax

00802da0 <__umoddi3>:
  802da0:	55                   	push   %ebp
  802da1:	57                   	push   %edi
  802da2:	56                   	push   %esi
  802da3:	83 ec 14             	sub    $0x14,%esp
  802da6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802daa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802dae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802db2:	89 c7                	mov    %eax,%edi
  802db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802db8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802dbc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802dc0:	89 34 24             	mov    %esi,(%esp)
  802dc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	89 c2                	mov    %eax,%edx
  802dcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dcf:	75 17                	jne    802de8 <__umoddi3+0x48>
  802dd1:	39 fe                	cmp    %edi,%esi
  802dd3:	76 4b                	jbe    802e20 <__umoddi3+0x80>
  802dd5:	89 c8                	mov    %ecx,%eax
  802dd7:	89 fa                	mov    %edi,%edx
  802dd9:	f7 f6                	div    %esi
  802ddb:	89 d0                	mov    %edx,%eax
  802ddd:	31 d2                	xor    %edx,%edx
  802ddf:	83 c4 14             	add    $0x14,%esp
  802de2:	5e                   	pop    %esi
  802de3:	5f                   	pop    %edi
  802de4:	5d                   	pop    %ebp
  802de5:	c3                   	ret    
  802de6:	66 90                	xchg   %ax,%ax
  802de8:	39 f8                	cmp    %edi,%eax
  802dea:	77 54                	ja     802e40 <__umoddi3+0xa0>
  802dec:	0f bd e8             	bsr    %eax,%ebp
  802def:	83 f5 1f             	xor    $0x1f,%ebp
  802df2:	75 5c                	jne    802e50 <__umoddi3+0xb0>
  802df4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802df8:	39 3c 24             	cmp    %edi,(%esp)
  802dfb:	0f 87 e7 00 00 00    	ja     802ee8 <__umoddi3+0x148>
  802e01:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802e05:	29 f1                	sub    %esi,%ecx
  802e07:	19 c7                	sbb    %eax,%edi
  802e09:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e11:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e15:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802e19:	83 c4 14             	add    $0x14,%esp
  802e1c:	5e                   	pop    %esi
  802e1d:	5f                   	pop    %edi
  802e1e:	5d                   	pop    %ebp
  802e1f:	c3                   	ret    
  802e20:	85 f6                	test   %esi,%esi
  802e22:	89 f5                	mov    %esi,%ebp
  802e24:	75 0b                	jne    802e31 <__umoddi3+0x91>
  802e26:	b8 01 00 00 00       	mov    $0x1,%eax
  802e2b:	31 d2                	xor    %edx,%edx
  802e2d:	f7 f6                	div    %esi
  802e2f:	89 c5                	mov    %eax,%ebp
  802e31:	8b 44 24 04          	mov    0x4(%esp),%eax
  802e35:	31 d2                	xor    %edx,%edx
  802e37:	f7 f5                	div    %ebp
  802e39:	89 c8                	mov    %ecx,%eax
  802e3b:	f7 f5                	div    %ebp
  802e3d:	eb 9c                	jmp    802ddb <__umoddi3+0x3b>
  802e3f:	90                   	nop
  802e40:	89 c8                	mov    %ecx,%eax
  802e42:	89 fa                	mov    %edi,%edx
  802e44:	83 c4 14             	add    $0x14,%esp
  802e47:	5e                   	pop    %esi
  802e48:	5f                   	pop    %edi
  802e49:	5d                   	pop    %ebp
  802e4a:	c3                   	ret    
  802e4b:	90                   	nop
  802e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e50:	8b 04 24             	mov    (%esp),%eax
  802e53:	be 20 00 00 00       	mov    $0x20,%esi
  802e58:	89 e9                	mov    %ebp,%ecx
  802e5a:	29 ee                	sub    %ebp,%esi
  802e5c:	d3 e2                	shl    %cl,%edx
  802e5e:	89 f1                	mov    %esi,%ecx
  802e60:	d3 e8                	shr    %cl,%eax
  802e62:	89 e9                	mov    %ebp,%ecx
  802e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e68:	8b 04 24             	mov    (%esp),%eax
  802e6b:	09 54 24 04          	or     %edx,0x4(%esp)
  802e6f:	89 fa                	mov    %edi,%edx
  802e71:	d3 e0                	shl    %cl,%eax
  802e73:	89 f1                	mov    %esi,%ecx
  802e75:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e79:	8b 44 24 10          	mov    0x10(%esp),%eax
  802e7d:	d3 ea                	shr    %cl,%edx
  802e7f:	89 e9                	mov    %ebp,%ecx
  802e81:	d3 e7                	shl    %cl,%edi
  802e83:	89 f1                	mov    %esi,%ecx
  802e85:	d3 e8                	shr    %cl,%eax
  802e87:	89 e9                	mov    %ebp,%ecx
  802e89:	09 f8                	or     %edi,%eax
  802e8b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802e8f:	f7 74 24 04          	divl   0x4(%esp)
  802e93:	d3 e7                	shl    %cl,%edi
  802e95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e99:	89 d7                	mov    %edx,%edi
  802e9b:	f7 64 24 08          	mull   0x8(%esp)
  802e9f:	39 d7                	cmp    %edx,%edi
  802ea1:	89 c1                	mov    %eax,%ecx
  802ea3:	89 14 24             	mov    %edx,(%esp)
  802ea6:	72 2c                	jb     802ed4 <__umoddi3+0x134>
  802ea8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802eac:	72 22                	jb     802ed0 <__umoddi3+0x130>
  802eae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802eb2:	29 c8                	sub    %ecx,%eax
  802eb4:	19 d7                	sbb    %edx,%edi
  802eb6:	89 e9                	mov    %ebp,%ecx
  802eb8:	89 fa                	mov    %edi,%edx
  802eba:	d3 e8                	shr    %cl,%eax
  802ebc:	89 f1                	mov    %esi,%ecx
  802ebe:	d3 e2                	shl    %cl,%edx
  802ec0:	89 e9                	mov    %ebp,%ecx
  802ec2:	d3 ef                	shr    %cl,%edi
  802ec4:	09 d0                	or     %edx,%eax
  802ec6:	89 fa                	mov    %edi,%edx
  802ec8:	83 c4 14             	add    $0x14,%esp
  802ecb:	5e                   	pop    %esi
  802ecc:	5f                   	pop    %edi
  802ecd:	5d                   	pop    %ebp
  802ece:	c3                   	ret    
  802ecf:	90                   	nop
  802ed0:	39 d7                	cmp    %edx,%edi
  802ed2:	75 da                	jne    802eae <__umoddi3+0x10e>
  802ed4:	8b 14 24             	mov    (%esp),%edx
  802ed7:	89 c1                	mov    %eax,%ecx
  802ed9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802edd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802ee1:	eb cb                	jmp    802eae <__umoddi3+0x10e>
  802ee3:	90                   	nop
  802ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ee8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802eec:	0f 82 0f ff ff ff    	jb     802e01 <__umoddi3+0x61>
  802ef2:	e9 1a ff ff ff       	jmp    802e11 <__umoddi3+0x71>
