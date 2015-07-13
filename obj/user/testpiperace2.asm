
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 b9 01 00 00       	call   8001ea <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	c7 04 24 e0 2e 80 00 	movl   $0x802ee0,(%esp)
  800043:	e8 fc 02 00 00       	call   800344 <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 91 26 00 00       	call   8026e4 <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x44>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 2e 2f 80 	movl   $0x802f2e,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 37 2f 80 00 	movl   $0x802f37,(%esp)
  800072:	e8 d4 01 00 00       	call   80024b <_panic>
	if ((r = fork()) < 0)
  800077:	e8 c3 12 00 00       	call   80133f <fork>
  80007c:	89 c7                	mov    %eax,%edi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6f>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 4c 2f 80 	movl   $0x802f4c,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 37 2f 80 00 	movl   $0x802f37,(%esp)
  80009d:	e8 a9 01 00 00       	call   80024b <_panic>
	if (r == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	75 75                	jne    80011b <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000a9:	89 04 24             	mov    %eax,(%esp)
  8000ac:	e8 d6 17 00 00       	call   801887 <close>
		for (i = 0; i < 200; i++) {
  8000b1:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (i % 10 == 0)
  8000b6:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	f7 ee                	imul   %esi
  8000bf:	c1 fa 02             	sar    $0x2,%edx
  8000c2:	89 d8                	mov    %ebx,%eax
  8000c4:	c1 f8 1f             	sar    $0x1f,%eax
  8000c7:	29 c2                	sub    %eax,%edx
  8000c9:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cc:	01 c0                	add    %eax,%eax
  8000ce:	39 c3                	cmp    %eax,%ebx
  8000d0:	75 10                	jne    8000e2 <umain+0xaf>
				cprintf("%d.", i);
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  8000dd:	e8 62 02 00 00       	call   800344 <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000e9:	00 
  8000ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 e7 17 00 00       	call   8018dc <dup>
			sys_yield();
  8000f5:	e8 0c 0d 00 00       	call   800e06 <sys_yield>
			close(10);
  8000fa:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800101:	e8 81 17 00 00       	call   801887 <close>
			sys_yield();
  800106:	e8 fb 0c 00 00       	call   800e06 <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010b:	83 c3 01             	add    $0x1,%ebx
  80010e:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800114:	75 a5                	jne    8000bb <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800116:	e8 17 01 00 00       	call   800232 <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011b:	89 fb                	mov    %edi,%ebx
  80011d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800123:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800126:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012c:	eb 28                	jmp    800156 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  80012e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800131:	89 04 24             	mov    %eax,(%esp)
  800134:	e8 1c 27 00 00       	call   802855 <pipeisclosed>
  800139:	85 c0                	test   %eax,%eax
  80013b:	74 19                	je     800156 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013d:	c7 04 24 59 2f 80 00 	movl   $0x802f59,(%esp)
  800144:	e8 fb 01 00 00       	call   800344 <cprintf>
			sys_env_destroy(r);
  800149:	89 3c 24             	mov    %edi,(%esp)
  80014c:	e8 f2 0b 00 00       	call   800d43 <sys_env_destroy>
			exit();
  800151:	e8 dc 00 00 00       	call   800232 <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800156:	8b 43 54             	mov    0x54(%ebx),%eax
  800159:	83 f8 02             	cmp    $0x2,%eax
  80015c:	74 d0                	je     80012e <umain+0xfb>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80015e:	c7 04 24 75 2f 80 00 	movl   $0x802f75,(%esp)
  800165:	e8 da 01 00 00       	call   800344 <cprintf>
	if (pipeisclosed(p[0]))
  80016a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016d:	89 04 24             	mov    %eax,(%esp)
  800170:	e8 e0 26 00 00       	call   802855 <pipeisclosed>
  800175:	85 c0                	test   %eax,%eax
  800177:	74 1c                	je     800195 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  800179:	c7 44 24 08 04 2f 80 	movl   $0x802f04,0x8(%esp)
  800180:	00 
  800181:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800188:	00 
  800189:	c7 04 24 37 2f 80 00 	movl   $0x802f37,(%esp)
  800190:	e8 b6 00 00 00       	call   80024b <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800195:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	89 04 24             	mov    %eax,(%esp)
  8001a2:	e8 af 15 00 00       	call   801756 <fd_lookup>
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	79 20                	jns    8001cb <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001af:	c7 44 24 08 8b 2f 80 	movl   $0x802f8b,0x8(%esp)
  8001b6:	00 
  8001b7:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001be:	00 
  8001bf:	c7 04 24 37 2f 80 00 	movl   $0x802f37,(%esp)
  8001c6:	e8 80 00 00 00       	call   80024b <_panic>
	(void) fd2data(fd);
  8001cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ce:	89 04 24             	mov    %eax,(%esp)
  8001d1:	e8 1a 15 00 00       	call   8016f0 <fd2data>
	cprintf("race didn't happen\n");
  8001d6:	c7 04 24 a3 2f 80 00 	movl   $0x802fa3,(%esp)
  8001dd:	e8 62 01 00 00       	call   800344 <cprintf>
}
  8001e2:	83 c4 2c             	add    $0x2c,%esp
  8001e5:	5b                   	pop    %ebx
  8001e6:	5e                   	pop    %esi
  8001e7:	5f                   	pop    %edi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	83 ec 10             	sub    $0x10,%esp
  8001f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8001f8:	e8 ea 0b 00 00       	call   800de7 <sys_getenvid>
  8001fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  800202:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800205:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020a:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020f:	85 db                	test   %ebx,%ebx
  800211:	7e 07                	jle    80021a <libmain+0x30>
		binaryname = argv[0];
  800213:	8b 06                	mov    (%esi),%eax
  800215:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80021a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80021e:	89 1c 24             	mov    %ebx,(%esp)
  800221:	e8 0d fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800226:	e8 07 00 00 00       	call   800232 <exit>
}
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	5b                   	pop    %ebx
  80022f:	5e                   	pop    %esi
  800230:	5d                   	pop    %ebp
  800231:	c3                   	ret    

00800232 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800238:	e8 7d 16 00 00       	call   8018ba <close_all>
	sys_env_destroy(0);
  80023d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800244:	e8 fa 0a 00 00       	call   800d43 <sys_env_destroy>
}
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	56                   	push   %esi
  80024f:	53                   	push   %ebx
  800250:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800253:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800256:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80025c:	e8 86 0b 00 00       	call   800de7 <sys_getenvid>
  800261:	8b 55 0c             	mov    0xc(%ebp),%edx
  800264:	89 54 24 10          	mov    %edx,0x10(%esp)
  800268:	8b 55 08             	mov    0x8(%ebp),%edx
  80026b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80026f:	89 74 24 08          	mov    %esi,0x8(%esp)
  800273:	89 44 24 04          	mov    %eax,0x4(%esp)
  800277:	c7 04 24 c4 2f 80 00 	movl   $0x802fc4,(%esp)
  80027e:	e8 c1 00 00 00       	call   800344 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800283:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	89 04 24             	mov    %eax,(%esp)
  80028d:	e8 51 00 00 00       	call   8002e3 <vcprintf>
	cprintf("\n");
  800292:	c7 04 24 cb 34 80 00 	movl   $0x8034cb,(%esp)
  800299:	e8 a6 00 00 00       	call   800344 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029e:	cc                   	int3   
  80029f:	eb fd                	jmp    80029e <_panic+0x53>

008002a1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 14             	sub    $0x14,%esp
  8002a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ab:	8b 13                	mov    (%ebx),%edx
  8002ad:	8d 42 01             	lea    0x1(%edx),%eax
  8002b0:	89 03                	mov    %eax,(%ebx)
  8002b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002be:	75 19                	jne    8002d9 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002c0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002c7:	00 
  8002c8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002cb:	89 04 24             	mov    %eax,(%esp)
  8002ce:	e8 33 0a 00 00       	call   800d06 <sys_cputs>
		b->idx = 0;
  8002d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002d9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002dd:	83 c4 14             	add    $0x14,%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5d                   	pop    %ebp
  8002e2:	c3                   	ret    

008002e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f3:	00 00 00 
	b.cnt = 0;
  8002f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80030e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800314:	89 44 24 04          	mov    %eax,0x4(%esp)
  800318:	c7 04 24 a1 02 80 00 	movl   $0x8002a1,(%esp)
  80031f:	e8 70 01 00 00       	call   800494 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800324:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800334:	89 04 24             	mov    %eax,(%esp)
  800337:	e8 ca 09 00 00       	call   800d06 <sys_cputs>

	return b.cnt;
}
  80033c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800351:	8b 45 08             	mov    0x8(%ebp),%eax
  800354:	89 04 24             	mov    %eax,(%esp)
  800357:	e8 87 ff ff ff       	call   8002e3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    
  80035e:	66 90                	xchg   %ax,%ax

00800360 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 3c             	sub    $0x3c,%esp
  800369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036c:	89 d7                	mov    %edx,%edi
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800374:	8b 45 0c             	mov    0xc(%ebp),%eax
  800377:	89 c3                	mov    %eax,%ebx
  800379:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800382:	b9 00 00 00 00       	mov    $0x0,%ecx
  800387:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80038d:	39 d9                	cmp    %ebx,%ecx
  80038f:	72 05                	jb     800396 <printnum+0x36>
  800391:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800394:	77 69                	ja     8003ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800396:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800399:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80039d:	83 ee 01             	sub    $0x1,%esi
  8003a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003b0:	89 c3                	mov    %eax,%ebx
  8003b2:	89 d6                	mov    %edx,%esi
  8003b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c5:	89 04 24             	mov    %eax,(%esp)
  8003c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cf:	e8 6c 28 00 00       	call   802c40 <__udivdi3>
  8003d4:	89 d9                	mov    %ebx,%ecx
  8003d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003de:	89 04 24             	mov    %eax,(%esp)
  8003e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003e5:	89 fa                	mov    %edi,%edx
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	e8 71 ff ff ff       	call   800360 <printnum>
  8003ef:	eb 1b                	jmp    80040c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	ff d3                	call   *%ebx
  8003fd:	eb 03                	jmp    800402 <printnum+0xa2>
  8003ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800402:	83 ee 01             	sub    $0x1,%esi
  800405:	85 f6                	test   %esi,%esi
  800407:	7f e8                	jg     8003f1 <printnum+0x91>
  800409:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800410:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800414:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800417:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80041a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80041e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800425:	89 04 24             	mov    %eax,(%esp)
  800428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80042b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80042f:	e8 3c 29 00 00       	call   802d70 <__umoddi3>
  800434:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800438:	0f be 80 e7 2f 80 00 	movsbl 0x802fe7(%eax),%eax
  80043f:	89 04 24             	mov    %eax,(%esp)
  800442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800445:	ff d0                	call   *%eax
}
  800447:	83 c4 3c             	add    $0x3c,%esp
  80044a:	5b                   	pop    %ebx
  80044b:	5e                   	pop    %esi
  80044c:	5f                   	pop    %edi
  80044d:	5d                   	pop    %ebp
  80044e:	c3                   	ret    

0080044f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800455:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800459:	8b 10                	mov    (%eax),%edx
  80045b:	3b 50 04             	cmp    0x4(%eax),%edx
  80045e:	73 0a                	jae    80046a <sprintputch+0x1b>
		*b->buf++ = ch;
  800460:	8d 4a 01             	lea    0x1(%edx),%ecx
  800463:	89 08                	mov    %ecx,(%eax)
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	88 02                	mov    %al,(%edx)
}
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800472:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800475:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800479:	8b 45 10             	mov    0x10(%ebp),%eax
  80047c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800480:	8b 45 0c             	mov    0xc(%ebp),%eax
  800483:	89 44 24 04          	mov    %eax,0x4(%esp)
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	89 04 24             	mov    %eax,(%esp)
  80048d:	e8 02 00 00 00       	call   800494 <vprintfmt>
	va_end(ap);
}
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	57                   	push   %edi
  800498:	56                   	push   %esi
  800499:	53                   	push   %ebx
  80049a:	83 ec 3c             	sub    $0x3c,%esp
  80049d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004a0:	eb 17                	jmp    8004b9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8004a2:	85 c0                	test   %eax,%eax
  8004a4:	0f 84 4b 04 00 00    	je     8008f5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8004aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004b1:	89 04 24             	mov    %eax,(%esp)
  8004b4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8004b7:	89 fb                	mov    %edi,%ebx
  8004b9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8004bc:	0f b6 03             	movzbl (%ebx),%eax
  8004bf:	83 f8 25             	cmp    $0x25,%eax
  8004c2:	75 de                	jne    8004a2 <vprintfmt+0xe>
  8004c4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8004c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8004d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004e0:	eb 18                	jmp    8004fa <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004e4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8004e8:	eb 10                	jmp    8004fa <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004ec:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8004f0:	eb 08                	jmp    8004fa <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004f2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8004f5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	8d 5f 01             	lea    0x1(%edi),%ebx
  8004fd:	0f b6 17             	movzbl (%edi),%edx
  800500:	0f b6 c2             	movzbl %dl,%eax
  800503:	83 ea 23             	sub    $0x23,%edx
  800506:	80 fa 55             	cmp    $0x55,%dl
  800509:	0f 87 c2 03 00 00    	ja     8008d1 <vprintfmt+0x43d>
  80050f:	0f b6 d2             	movzbl %dl,%edx
  800512:	ff 24 95 20 31 80 00 	jmp    *0x803120(,%edx,4)
  800519:	89 df                	mov    %ebx,%edi
  80051b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800520:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800523:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800527:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80052a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80052d:	83 fa 09             	cmp    $0x9,%edx
  800530:	77 33                	ja     800565 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800532:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800535:	eb e9                	jmp    800520 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8b 30                	mov    (%eax),%esi
  80053c:	8d 40 04             	lea    0x4(%eax),%eax
  80053f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800542:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800544:	eb 1f                	jmp    800565 <vprintfmt+0xd1>
  800546:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800549:	85 ff                	test   %edi,%edi
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	0f 49 c7             	cmovns %edi,%eax
  800553:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800556:	89 df                	mov    %ebx,%edi
  800558:	eb a0                	jmp    8004fa <vprintfmt+0x66>
  80055a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80055c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800563:	eb 95                	jmp    8004fa <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800565:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800569:	79 8f                	jns    8004fa <vprintfmt+0x66>
  80056b:	eb 85                	jmp    8004f2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80056d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800570:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800572:	eb 86                	jmp    8004fa <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 70 04             	lea    0x4(%eax),%esi
  80057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	89 04 24             	mov    %eax,(%esp)
  800589:	ff 55 08             	call   *0x8(%ebp)
  80058c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80058f:	e9 25 ff ff ff       	jmp    8004b9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 70 04             	lea    0x4(%eax),%esi
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	99                   	cltd   
  80059d:	31 d0                	xor    %edx,%eax
  80059f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005a1:	83 f8 15             	cmp    $0x15,%eax
  8005a4:	7f 0b                	jg     8005b1 <vprintfmt+0x11d>
  8005a6:	8b 14 85 80 32 80 00 	mov    0x803280(,%eax,4),%edx
  8005ad:	85 d2                	test   %edx,%edx
  8005af:	75 26                	jne    8005d7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8005b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005b5:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  8005bc:	00 
  8005bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	89 04 24             	mov    %eax,(%esp)
  8005ca:	e8 9d fe ff ff       	call   80046c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005cf:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005d2:	e9 e2 fe ff ff       	jmp    8004b9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005db:	c7 44 24 08 9a 34 80 	movl   $0x80349a,0x8(%esp)
  8005e2:	00 
  8005e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	89 04 24             	mov    %eax,(%esp)
  8005f0:	e8 77 fe ff ff       	call   80046c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f5:	89 75 14             	mov    %esi,0x14(%ebp)
  8005f8:	e9 bc fe ff ff       	jmp    8004b9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800603:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800606:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80060a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80060c:	85 ff                	test   %edi,%edi
  80060e:	b8 f8 2f 80 00       	mov    $0x802ff8,%eax
  800613:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800616:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80061a:	0f 84 94 00 00 00    	je     8006b4 <vprintfmt+0x220>
  800620:	85 c9                	test   %ecx,%ecx
  800622:	0f 8e 94 00 00 00    	jle    8006bc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800628:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062c:	89 3c 24             	mov    %edi,(%esp)
  80062f:	e8 64 03 00 00       	call   800998 <strnlen>
  800634:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800637:	29 c1                	sub    %eax,%ecx
  800639:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80063c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800640:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800643:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800646:	8b 75 08             	mov    0x8(%ebp),%esi
  800649:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80064c:	89 cb                	mov    %ecx,%ebx
  80064e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800650:	eb 0f                	jmp    800661 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800652:	8b 45 0c             	mov    0xc(%ebp),%eax
  800655:	89 44 24 04          	mov    %eax,0x4(%esp)
  800659:	89 3c 24             	mov    %edi,(%esp)
  80065c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80065e:	83 eb 01             	sub    $0x1,%ebx
  800661:	85 db                	test   %ebx,%ebx
  800663:	7f ed                	jg     800652 <vprintfmt+0x1be>
  800665:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800668:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80066b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80066e:	85 c9                	test   %ecx,%ecx
  800670:	b8 00 00 00 00       	mov    $0x0,%eax
  800675:	0f 49 c1             	cmovns %ecx,%eax
  800678:	29 c1                	sub    %eax,%ecx
  80067a:	89 cb                	mov    %ecx,%ebx
  80067c:	eb 44                	jmp    8006c2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80067e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800682:	74 1e                	je     8006a2 <vprintfmt+0x20e>
  800684:	0f be d2             	movsbl %dl,%edx
  800687:	83 ea 20             	sub    $0x20,%edx
  80068a:	83 fa 5e             	cmp    $0x5e,%edx
  80068d:	76 13                	jbe    8006a2 <vprintfmt+0x20e>
					putch('?', putdat);
  80068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800692:	89 44 24 04          	mov    %eax,0x4(%esp)
  800696:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80069d:	ff 55 08             	call   *0x8(%ebp)
  8006a0:	eb 0d                	jmp    8006af <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8006a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006a9:	89 04 24             	mov    %eax,(%esp)
  8006ac:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006af:	83 eb 01             	sub    $0x1,%ebx
  8006b2:	eb 0e                	jmp    8006c2 <vprintfmt+0x22e>
  8006b4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006b7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006ba:	eb 06                	jmp    8006c2 <vprintfmt+0x22e>
  8006bc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006bf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006c2:	83 c7 01             	add    $0x1,%edi
  8006c5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006c9:	0f be c2             	movsbl %dl,%eax
  8006cc:	85 c0                	test   %eax,%eax
  8006ce:	74 27                	je     8006f7 <vprintfmt+0x263>
  8006d0:	85 f6                	test   %esi,%esi
  8006d2:	78 aa                	js     80067e <vprintfmt+0x1ea>
  8006d4:	83 ee 01             	sub    $0x1,%esi
  8006d7:	79 a5                	jns    80067e <vprintfmt+0x1ea>
  8006d9:	89 d8                	mov    %ebx,%eax
  8006db:	8b 75 08             	mov    0x8(%ebp),%esi
  8006de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006e1:	89 c3                	mov    %eax,%ebx
  8006e3:	eb 18                	jmp    8006fd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006f0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f2:	83 eb 01             	sub    $0x1,%ebx
  8006f5:	eb 06                	jmp    8006fd <vprintfmt+0x269>
  8006f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006fd:	85 db                	test   %ebx,%ebx
  8006ff:	7f e4                	jg     8006e5 <vprintfmt+0x251>
  800701:	89 75 08             	mov    %esi,0x8(%ebp)
  800704:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800707:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80070a:	e9 aa fd ff ff       	jmp    8004b9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80070f:	83 f9 01             	cmp    $0x1,%ecx
  800712:	7e 10                	jle    800724 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 30                	mov    (%eax),%esi
  800719:	8b 78 04             	mov    0x4(%eax),%edi
  80071c:	8d 40 08             	lea    0x8(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
  800722:	eb 26                	jmp    80074a <vprintfmt+0x2b6>
	else if (lflag)
  800724:	85 c9                	test   %ecx,%ecx
  800726:	74 12                	je     80073a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 30                	mov    (%eax),%esi
  80072d:	89 f7                	mov    %esi,%edi
  80072f:	c1 ff 1f             	sar    $0x1f,%edi
  800732:	8d 40 04             	lea    0x4(%eax),%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
  800738:	eb 10                	jmp    80074a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 30                	mov    (%eax),%esi
  80073f:	89 f7                	mov    %esi,%edi
  800741:	c1 ff 1f             	sar    $0x1f,%edi
  800744:	8d 40 04             	lea    0x4(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80074a:	89 f0                	mov    %esi,%eax
  80074c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80074e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800753:	85 ff                	test   %edi,%edi
  800755:	0f 89 3a 01 00 00    	jns    800895 <vprintfmt+0x401>
				putch('-', putdat);
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800762:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800769:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80076c:	89 f0                	mov    %esi,%eax
  80076e:	89 fa                	mov    %edi,%edx
  800770:	f7 d8                	neg    %eax
  800772:	83 d2 00             	adc    $0x0,%edx
  800775:	f7 da                	neg    %edx
			}
			base = 10;
  800777:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80077c:	e9 14 01 00 00       	jmp    800895 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800781:	83 f9 01             	cmp    $0x1,%ecx
  800784:	7e 13                	jle    800799 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 50 04             	mov    0x4(%eax),%edx
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8b 75 14             	mov    0x14(%ebp),%esi
  800791:	8d 4e 08             	lea    0x8(%esi),%ecx
  800794:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800797:	eb 2c                	jmp    8007c5 <vprintfmt+0x331>
	else if (lflag)
  800799:	85 c9                	test   %ecx,%ecx
  80079b:	74 15                	je     8007b2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a7:	8b 75 14             	mov    0x14(%ebp),%esi
  8007aa:	8d 76 04             	lea    0x4(%esi),%esi
  8007ad:	89 75 14             	mov    %esi,0x14(%ebp)
  8007b0:	eb 13                	jmp    8007c5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bc:	8b 75 14             	mov    0x14(%ebp),%esi
  8007bf:	8d 76 04             	lea    0x4(%esi),%esi
  8007c2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8007c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007ca:	e9 c6 00 00 00       	jmp    800895 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007cf:	83 f9 01             	cmp    $0x1,%ecx
  8007d2:	7e 13                	jle    8007e7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8b 50 04             	mov    0x4(%eax),%edx
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	8b 75 14             	mov    0x14(%ebp),%esi
  8007df:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007e2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007e5:	eb 24                	jmp    80080b <vprintfmt+0x377>
	else if (lflag)
  8007e7:	85 c9                	test   %ecx,%ecx
  8007e9:	74 11                	je     8007fc <vprintfmt+0x368>
		return va_arg(*ap, long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	99                   	cltd   
  8007f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007f4:	8d 71 04             	lea    0x4(%ecx),%esi
  8007f7:	89 75 14             	mov    %esi,0x14(%ebp)
  8007fa:	eb 0f                	jmp    80080b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	8b 75 14             	mov    0x14(%ebp),%esi
  800805:	8d 76 04             	lea    0x4(%esi),%esi
  800808:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80080b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800810:	e9 80 00 00 00       	jmp    800895 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800815:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800826:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800830:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800837:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80083a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80083e:	8b 06                	mov    (%esi),%eax
  800840:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800845:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80084a:	eb 49                	jmp    800895 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80084c:	83 f9 01             	cmp    $0x1,%ecx
  80084f:	7e 13                	jle    800864 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 50 04             	mov    0x4(%eax),%edx
  800857:	8b 00                	mov    (%eax),%eax
  800859:	8b 75 14             	mov    0x14(%ebp),%esi
  80085c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80085f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800862:	eb 2c                	jmp    800890 <vprintfmt+0x3fc>
	else if (lflag)
  800864:	85 c9                	test   %ecx,%ecx
  800866:	74 15                	je     80087d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	ba 00 00 00 00       	mov    $0x0,%edx
  800872:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800875:	8d 71 04             	lea    0x4(%ecx),%esi
  800878:	89 75 14             	mov    %esi,0x14(%ebp)
  80087b:	eb 13                	jmp    800890 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	ba 00 00 00 00       	mov    $0x0,%edx
  800887:	8b 75 14             	mov    0x14(%ebp),%esi
  80088a:	8d 76 04             	lea    0x4(%esi),%esi
  80088d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800890:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800895:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800899:	89 74 24 10          	mov    %esi,0x10(%esp)
  80089d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8008a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008a4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008a8:	89 04 24             	mov    %eax,(%esp)
  8008ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	e8 a6 fa ff ff       	call   800360 <printnum>
			break;
  8008ba:	e9 fa fb ff ff       	jmp    8004b9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008c6:	89 04 24             	mov    %eax,(%esp)
  8008c9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008cc:	e9 e8 fb ff ff       	jmp    8004b9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008df:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e2:	89 fb                	mov    %edi,%ebx
  8008e4:	eb 03                	jmp    8008e9 <vprintfmt+0x455>
  8008e6:	83 eb 01             	sub    $0x1,%ebx
  8008e9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008ed:	75 f7                	jne    8008e6 <vprintfmt+0x452>
  8008ef:	90                   	nop
  8008f0:	e9 c4 fb ff ff       	jmp    8004b9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008f5:	83 c4 3c             	add    $0x3c,%esp
  8008f8:	5b                   	pop    %ebx
  8008f9:	5e                   	pop    %esi
  8008fa:	5f                   	pop    %edi
  8008fb:	5d                   	pop    %ebp
  8008fc:	c3                   	ret    

008008fd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	83 ec 28             	sub    $0x28,%esp
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800909:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80090c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800910:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800913:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80091a:	85 c0                	test   %eax,%eax
  80091c:	74 30                	je     80094e <vsnprintf+0x51>
  80091e:	85 d2                	test   %edx,%edx
  800920:	7e 2c                	jle    80094e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800929:	8b 45 10             	mov    0x10(%ebp),%eax
  80092c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800930:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800933:	89 44 24 04          	mov    %eax,0x4(%esp)
  800937:	c7 04 24 4f 04 80 00 	movl   $0x80044f,(%esp)
  80093e:	e8 51 fb ff ff       	call   800494 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800946:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094c:	eb 05                	jmp    800953 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80094e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800953:	c9                   	leave  
  800954:	c3                   	ret    

00800955 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80095b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80095e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800962:	8b 45 10             	mov    0x10(%ebp),%eax
  800965:	89 44 24 08          	mov    %eax,0x8(%esp)
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	89 04 24             	mov    %eax,(%esp)
  800976:	e8 82 ff ff ff       	call   8008fd <vsnprintf>
	va_end(ap);

	return rc;
}
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    
  80097d:	66 90                	xchg   %ax,%ax
  80097f:	90                   	nop

00800980 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	eb 03                	jmp    800990 <strlen+0x10>
		n++;
  80098d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800990:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800994:	75 f7                	jne    80098d <strlen+0xd>
		n++;
	return n;
}
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a6:	eb 03                	jmp    8009ab <strnlen+0x13>
		n++;
  8009a8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ab:	39 d0                	cmp    %edx,%eax
  8009ad:	74 06                	je     8009b5 <strnlen+0x1d>
  8009af:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009b3:	75 f3                	jne    8009a8 <strnlen+0x10>
		n++;
	return n;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	83 c2 01             	add    $0x1,%edx
  8009c6:	83 c1 01             	add    $0x1,%ecx
  8009c9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009cd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d0:	84 db                	test   %bl,%bl
  8009d2:	75 ef                	jne    8009c3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009d4:	5b                   	pop    %ebx
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	53                   	push   %ebx
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009e1:	89 1c 24             	mov    %ebx,(%esp)
  8009e4:	e8 97 ff ff ff       	call   800980 <strlen>
	strcpy(dst + len, src);
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009f0:	01 d8                	add    %ebx,%eax
  8009f2:	89 04 24             	mov    %eax,(%esp)
  8009f5:	e8 bd ff ff ff       	call   8009b7 <strcpy>
	return dst;
}
  8009fa:	89 d8                	mov    %ebx,%eax
  8009fc:	83 c4 08             	add    $0x8,%esp
  8009ff:	5b                   	pop    %ebx
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 75 08             	mov    0x8(%ebp),%esi
  800a0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0d:	89 f3                	mov    %esi,%ebx
  800a0f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a12:	89 f2                	mov    %esi,%edx
  800a14:	eb 0f                	jmp    800a25 <strncpy+0x23>
		*dst++ = *src;
  800a16:	83 c2 01             	add    $0x1,%edx
  800a19:	0f b6 01             	movzbl (%ecx),%eax
  800a1c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a1f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a22:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a25:	39 da                	cmp    %ebx,%edx
  800a27:	75 ed                	jne    800a16 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a29:	89 f0                	mov    %esi,%eax
  800a2b:	5b                   	pop    %ebx
  800a2c:	5e                   	pop    %esi
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	56                   	push   %esi
  800a33:	53                   	push   %ebx
  800a34:	8b 75 08             	mov    0x8(%ebp),%esi
  800a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a3d:	89 f0                	mov    %esi,%eax
  800a3f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a43:	85 c9                	test   %ecx,%ecx
  800a45:	75 0b                	jne    800a52 <strlcpy+0x23>
  800a47:	eb 1d                	jmp    800a66 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	83 c2 01             	add    $0x1,%edx
  800a4f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a52:	39 d8                	cmp    %ebx,%eax
  800a54:	74 0b                	je     800a61 <strlcpy+0x32>
  800a56:	0f b6 0a             	movzbl (%edx),%ecx
  800a59:	84 c9                	test   %cl,%cl
  800a5b:	75 ec                	jne    800a49 <strlcpy+0x1a>
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	eb 02                	jmp    800a63 <strlcpy+0x34>
  800a61:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a63:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a66:	29 f0                	sub    %esi,%eax
}
  800a68:	5b                   	pop    %ebx
  800a69:	5e                   	pop    %esi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a72:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a75:	eb 06                	jmp    800a7d <strcmp+0x11>
		p++, q++;
  800a77:	83 c1 01             	add    $0x1,%ecx
  800a7a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a7d:	0f b6 01             	movzbl (%ecx),%eax
  800a80:	84 c0                	test   %al,%al
  800a82:	74 04                	je     800a88 <strcmp+0x1c>
  800a84:	3a 02                	cmp    (%edx),%al
  800a86:	74 ef                	je     800a77 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a88:	0f b6 c0             	movzbl %al,%eax
  800a8b:	0f b6 12             	movzbl (%edx),%edx
  800a8e:	29 d0                	sub    %edx,%eax
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	89 c3                	mov    %eax,%ebx
  800a9e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa1:	eb 06                	jmp    800aa9 <strncmp+0x17>
		n--, p++, q++;
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800aa9:	39 d8                	cmp    %ebx,%eax
  800aab:	74 15                	je     800ac2 <strncmp+0x30>
  800aad:	0f b6 08             	movzbl (%eax),%ecx
  800ab0:	84 c9                	test   %cl,%cl
  800ab2:	74 04                	je     800ab8 <strncmp+0x26>
  800ab4:	3a 0a                	cmp    (%edx),%cl
  800ab6:	74 eb                	je     800aa3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab8:	0f b6 00             	movzbl (%eax),%eax
  800abb:	0f b6 12             	movzbl (%edx),%edx
  800abe:	29 d0                	sub    %edx,%eax
  800ac0:	eb 05                	jmp    800ac7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ac7:	5b                   	pop    %ebx
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad4:	eb 07                	jmp    800add <strchr+0x13>
		if (*s == c)
  800ad6:	38 ca                	cmp    %cl,%dl
  800ad8:	74 0f                	je     800ae9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	0f b6 10             	movzbl (%eax),%edx
  800ae0:	84 d2                	test   %dl,%dl
  800ae2:	75 f2                	jne    800ad6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af5:	eb 07                	jmp    800afe <strfind+0x13>
		if (*s == c)
  800af7:	38 ca                	cmp    %cl,%dl
  800af9:	74 0a                	je     800b05 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	0f b6 10             	movzbl (%eax),%edx
  800b01:	84 d2                	test   %dl,%dl
  800b03:	75 f2                	jne    800af7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b13:	85 c9                	test   %ecx,%ecx
  800b15:	74 36                	je     800b4d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b17:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b1d:	75 28                	jne    800b47 <memset+0x40>
  800b1f:	f6 c1 03             	test   $0x3,%cl
  800b22:	75 23                	jne    800b47 <memset+0x40>
		c &= 0xFF;
  800b24:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b28:	89 d3                	mov    %edx,%ebx
  800b2a:	c1 e3 08             	shl    $0x8,%ebx
  800b2d:	89 d6                	mov    %edx,%esi
  800b2f:	c1 e6 18             	shl    $0x18,%esi
  800b32:	89 d0                	mov    %edx,%eax
  800b34:	c1 e0 10             	shl    $0x10,%eax
  800b37:	09 f0                	or     %esi,%eax
  800b39:	09 c2                	or     %eax,%edx
  800b3b:	89 d0                	mov    %edx,%eax
  800b3d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b3f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b42:	fc                   	cld    
  800b43:	f3 ab                	rep stos %eax,%es:(%edi)
  800b45:	eb 06                	jmp    800b4d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	fc                   	cld    
  800b4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b4d:	89 f8                	mov    %edi,%eax
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b62:	39 c6                	cmp    %eax,%esi
  800b64:	73 35                	jae    800b9b <memmove+0x47>
  800b66:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b69:	39 d0                	cmp    %edx,%eax
  800b6b:	73 2e                	jae    800b9b <memmove+0x47>
		s += n;
		d += n;
  800b6d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b70:	89 d6                	mov    %edx,%esi
  800b72:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b74:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b7a:	75 13                	jne    800b8f <memmove+0x3b>
  800b7c:	f6 c1 03             	test   $0x3,%cl
  800b7f:	75 0e                	jne    800b8f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b81:	83 ef 04             	sub    $0x4,%edi
  800b84:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b87:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b8a:	fd                   	std    
  800b8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b8d:	eb 09                	jmp    800b98 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b8f:	83 ef 01             	sub    $0x1,%edi
  800b92:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b95:	fd                   	std    
  800b96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b98:	fc                   	cld    
  800b99:	eb 1d                	jmp    800bb8 <memmove+0x64>
  800b9b:	89 f2                	mov    %esi,%edx
  800b9d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b9f:	f6 c2 03             	test   $0x3,%dl
  800ba2:	75 0f                	jne    800bb3 <memmove+0x5f>
  800ba4:	f6 c1 03             	test   $0x3,%cl
  800ba7:	75 0a                	jne    800bb3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ba9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bac:	89 c7                	mov    %eax,%edi
  800bae:	fc                   	cld    
  800baf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bb1:	eb 05                	jmp    800bb8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bb3:	89 c7                	mov    %eax,%edi
  800bb5:	fc                   	cld    
  800bb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 04 24             	mov    %eax,(%esp)
  800bd6:	e8 79 ff ff ff       	call   800b54 <memmove>
}
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	8b 55 08             	mov    0x8(%ebp),%edx
  800be5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be8:	89 d6                	mov    %edx,%esi
  800bea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bed:	eb 1a                	jmp    800c09 <memcmp+0x2c>
		if (*s1 != *s2)
  800bef:	0f b6 02             	movzbl (%edx),%eax
  800bf2:	0f b6 19             	movzbl (%ecx),%ebx
  800bf5:	38 d8                	cmp    %bl,%al
  800bf7:	74 0a                	je     800c03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800bf9:	0f b6 c0             	movzbl %al,%eax
  800bfc:	0f b6 db             	movzbl %bl,%ebx
  800bff:	29 d8                	sub    %ebx,%eax
  800c01:	eb 0f                	jmp    800c12 <memcmp+0x35>
		s1++, s2++;
  800c03:	83 c2 01             	add    $0x1,%edx
  800c06:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c09:	39 f2                	cmp    %esi,%edx
  800c0b:	75 e2                	jne    800bef <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c1f:	89 c2                	mov    %eax,%edx
  800c21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c24:	eb 07                	jmp    800c2d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c26:	38 08                	cmp    %cl,(%eax)
  800c28:	74 07                	je     800c31 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	39 d0                	cmp    %edx,%eax
  800c2f:	72 f5                	jb     800c26 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c3f:	eb 03                	jmp    800c44 <strtol+0x11>
		s++;
  800c41:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c44:	0f b6 0a             	movzbl (%edx),%ecx
  800c47:	80 f9 09             	cmp    $0x9,%cl
  800c4a:	74 f5                	je     800c41 <strtol+0xe>
  800c4c:	80 f9 20             	cmp    $0x20,%cl
  800c4f:	74 f0                	je     800c41 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c51:	80 f9 2b             	cmp    $0x2b,%cl
  800c54:	75 0a                	jne    800c60 <strtol+0x2d>
		s++;
  800c56:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c59:	bf 00 00 00 00       	mov    $0x0,%edi
  800c5e:	eb 11                	jmp    800c71 <strtol+0x3e>
  800c60:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c65:	80 f9 2d             	cmp    $0x2d,%cl
  800c68:	75 07                	jne    800c71 <strtol+0x3e>
		s++, neg = 1;
  800c6a:	8d 52 01             	lea    0x1(%edx),%edx
  800c6d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c71:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c76:	75 15                	jne    800c8d <strtol+0x5a>
  800c78:	80 3a 30             	cmpb   $0x30,(%edx)
  800c7b:	75 10                	jne    800c8d <strtol+0x5a>
  800c7d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c81:	75 0a                	jne    800c8d <strtol+0x5a>
		s += 2, base = 16;
  800c83:	83 c2 02             	add    $0x2,%edx
  800c86:	b8 10 00 00 00       	mov    $0x10,%eax
  800c8b:	eb 10                	jmp    800c9d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	75 0c                	jne    800c9d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c91:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c93:	80 3a 30             	cmpb   $0x30,(%edx)
  800c96:	75 05                	jne    800c9d <strtol+0x6a>
		s++, base = 8;
  800c98:	83 c2 01             	add    $0x1,%edx
  800c9b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ca5:	0f b6 0a             	movzbl (%edx),%ecx
  800ca8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800cab:	89 f0                	mov    %esi,%eax
  800cad:	3c 09                	cmp    $0x9,%al
  800caf:	77 08                	ja     800cb9 <strtol+0x86>
			dig = *s - '0';
  800cb1:	0f be c9             	movsbl %cl,%ecx
  800cb4:	83 e9 30             	sub    $0x30,%ecx
  800cb7:	eb 20                	jmp    800cd9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800cb9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cbc:	89 f0                	mov    %esi,%eax
  800cbe:	3c 19                	cmp    $0x19,%al
  800cc0:	77 08                	ja     800cca <strtol+0x97>
			dig = *s - 'a' + 10;
  800cc2:	0f be c9             	movsbl %cl,%ecx
  800cc5:	83 e9 57             	sub    $0x57,%ecx
  800cc8:	eb 0f                	jmp    800cd9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800cca:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800ccd:	89 f0                	mov    %esi,%eax
  800ccf:	3c 19                	cmp    $0x19,%al
  800cd1:	77 16                	ja     800ce9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800cd3:	0f be c9             	movsbl %cl,%ecx
  800cd6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cd9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800cdc:	7d 0f                	jge    800ced <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cde:	83 c2 01             	add    $0x1,%edx
  800ce1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ce5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ce7:	eb bc                	jmp    800ca5 <strtol+0x72>
  800ce9:	89 d8                	mov    %ebx,%eax
  800ceb:	eb 02                	jmp    800cef <strtol+0xbc>
  800ced:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	74 05                	je     800cfa <strtol+0xc7>
		*endptr = (char *) s;
  800cf5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cf8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cfa:	f7 d8                	neg    %eax
  800cfc:	85 ff                	test   %edi,%edi
  800cfe:	0f 44 c3             	cmove  %ebx,%eax
}
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	89 c3                	mov    %eax,%ebx
  800d19:	89 c7                	mov    %eax,%edi
  800d1b:	89 c6                	mov    %eax,%esi
  800d1d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d34:	89 d1                	mov    %edx,%ecx
  800d36:	89 d3                	mov    %edx,%ebx
  800d38:	89 d7                	mov    %edx,%edi
  800d3a:	89 d6                	mov    %edx,%esi
  800d3c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d51:	b8 03 00 00 00       	mov    $0x3,%eax
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	89 cb                	mov    %ecx,%ebx
  800d5b:	89 cf                	mov    %ecx,%edi
  800d5d:	89 ce                	mov    %ecx,%esi
  800d5f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d61:	85 c0                	test   %eax,%eax
  800d63:	7e 28                	jle    800d8d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d65:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d69:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d70:	00 
  800d71:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  800d78:	00 
  800d79:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d80:	00 
  800d81:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  800d88:	e8 be f4 ff ff       	call   80024b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d8d:	83 c4 2c             	add    $0x2c,%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da3:	b8 04 00 00 00       	mov    $0x4,%eax
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	89 cb                	mov    %ecx,%ebx
  800dad:	89 cf                	mov    %ecx,%edi
  800daf:	89 ce                	mov    %ecx,%esi
  800db1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db3:	85 c0                	test   %eax,%eax
  800db5:	7e 28                	jle    800ddf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dbb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800dc2:	00 
  800dc3:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  800dca:	00 
  800dcb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd2:	00 
  800dd3:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  800dda:	e8 6c f4 ff ff       	call   80024b <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800ddf:	83 c4 2c             	add    $0x2c,%esp
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ded:	ba 00 00 00 00       	mov    $0x0,%edx
  800df2:	b8 02 00 00 00       	mov    $0x2,%eax
  800df7:	89 d1                	mov    %edx,%ecx
  800df9:	89 d3                	mov    %edx,%ebx
  800dfb:	89 d7                	mov    %edx,%edi
  800dfd:	89 d6                	mov    %edx,%esi
  800dff:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_yield>:

void
sys_yield(void)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e16:	89 d1                	mov    %edx,%ecx
  800e18:	89 d3                	mov    %edx,%ebx
  800e1a:	89 d7                	mov    %edx,%edi
  800e1c:	89 d6                	mov    %edx,%esi
  800e1e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    

00800e25 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2e:	be 00 00 00 00       	mov    $0x0,%esi
  800e33:	b8 05 00 00 00       	mov    $0x5,%eax
  800e38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e41:	89 f7                	mov    %esi,%edi
  800e43:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	7e 28                	jle    800e71 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e54:	00 
  800e55:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  800e5c:	00 
  800e5d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e64:	00 
  800e65:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  800e6c:	e8 da f3 ff ff       	call   80024b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e71:	83 c4 2c             	add    $0x2c,%esp
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e82:	b8 06 00 00 00       	mov    $0x6,%eax
  800e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e90:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e93:	8b 75 18             	mov    0x18(%ebp),%esi
  800e96:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	7e 28                	jle    800ec4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ea7:	00 
  800ea8:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  800eaf:	00 
  800eb0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb7:	00 
  800eb8:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  800ebf:	e8 87 f3 ff ff       	call   80024b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ec4:	83 c4 2c             	add    $0x2c,%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eda:	b8 07 00 00 00       	mov    $0x7,%eax
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	89 df                	mov    %ebx,%edi
  800ee7:	89 de                	mov    %ebx,%esi
  800ee9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	7e 28                	jle    800f17 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eef:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800efa:	00 
  800efb:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  800f02:	00 
  800f03:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0a:	00 
  800f0b:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  800f12:	e8 34 f3 ff ff       	call   80024b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f17:	83 c4 2c             	add    $0x2c,%esp
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f2a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	89 cb                	mov    %ecx,%ebx
  800f34:	89 cf                	mov    %ecx,%edi
  800f36:	89 ce                	mov    %ecx,%esi
  800f38:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5f                   	pop    %edi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4d:	b8 09 00 00 00       	mov    $0x9,%eax
  800f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f55:	8b 55 08             	mov    0x8(%ebp),%edx
  800f58:	89 df                	mov    %ebx,%edi
  800f5a:	89 de                	mov    %ebx,%esi
  800f5c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	7e 28                	jle    800f8a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f62:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f66:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f6d:	00 
  800f6e:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  800f75:	00 
  800f76:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7d:	00 
  800f7e:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  800f85:	e8 c1 f2 ff ff       	call   80024b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f8a:	83 c4 2c             	add    $0x2c,%esp
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
  800f98:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fab:	89 df                	mov    %ebx,%edi
  800fad:	89 de                	mov    %ebx,%esi
  800faf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	7e 28                	jle    800fdd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  800fc8:	00 
  800fc9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd0:	00 
  800fd1:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  800fd8:	e8 6e f2 ff ff       	call   80024b <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fdd:	83 c4 2c             	add    $0x2c,%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
  800feb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	89 df                	mov    %ebx,%edi
  801000:	89 de                	mov    %ebx,%esi
  801002:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801004:	85 c0                	test   %eax,%eax
  801006:	7e 28                	jle    801030 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801008:	89 44 24 10          	mov    %eax,0x10(%esp)
  80100c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801013:	00 
  801014:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  80101b:	00 
  80101c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801023:	00 
  801024:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  80102b:	e8 1b f2 ff ff       	call   80024b <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801030:	83 c4 2c             	add    $0x2c,%esp
  801033:	5b                   	pop    %ebx
  801034:	5e                   	pop    %esi
  801035:	5f                   	pop    %edi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103e:	be 00 00 00 00       	mov    $0x0,%esi
  801043:	b8 0d 00 00 00       	mov    $0xd,%eax
  801048:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801051:	8b 7d 14             	mov    0x14(%ebp),%edi
  801054:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5f                   	pop    %edi
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
  801061:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801064:	b9 00 00 00 00       	mov    $0x0,%ecx
  801069:	b8 0e 00 00 00       	mov    $0xe,%eax
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	89 cb                	mov    %ecx,%ebx
  801073:	89 cf                	mov    %ecx,%edi
  801075:	89 ce                	mov    %ecx,%esi
  801077:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801079:	85 c0                	test   %eax,%eax
  80107b:	7e 28                	jle    8010a5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801081:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801088:	00 
  801089:	c7 44 24 08 f7 32 80 	movl   $0x8032f7,0x8(%esp)
  801090:	00 
  801091:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801098:	00 
  801099:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  8010a0:	e8 a6 f1 ff ff       	call   80024b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010a5:	83 c4 2c             	add    $0x2c,%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010bd:	89 d1                	mov    %edx,%ecx
  8010bf:	89 d3                	mov    %edx,%ebx
  8010c1:	89 d7                	mov    %edx,%edi
  8010c3:	89 d6                	mov    %edx,%esi
  8010c5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	57                   	push   %edi
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d7:	b8 11 00 00 00       	mov    $0x11,%eax
  8010dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010df:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e2:	89 df                	mov    %ebx,%edi
  8010e4:	89 de                	mov    %ebx,%esi
  8010e6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8010e8:	5b                   	pop    %ebx
  8010e9:	5e                   	pop    %esi
  8010ea:	5f                   	pop    %edi
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
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
  8010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f8:	b8 12 00 00 00       	mov    $0x12,%eax
  8010fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	89 df                	mov    %ebx,%edi
  801105:	89 de                	mov    %ebx,%esi
  801107:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801109:	5b                   	pop    %ebx
  80110a:	5e                   	pop    %esi
  80110b:	5f                   	pop    %edi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	57                   	push   %edi
  801112:	56                   	push   %esi
  801113:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801114:	b9 00 00 00 00       	mov    $0x0,%ecx
  801119:	b8 13 00 00 00       	mov    $0x13,%eax
  80111e:	8b 55 08             	mov    0x8(%ebp),%edx
  801121:	89 cb                	mov    %ecx,%ebx
  801123:	89 cf                	mov    %ecx,%edi
  801125:	89 ce                	mov    %ecx,%esi
  801127:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801129:	5b                   	pop    %ebx
  80112a:	5e                   	pop    %esi
  80112b:	5f                   	pop    %edi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	57                   	push   %edi
  801132:	56                   	push   %esi
  801133:	53                   	push   %ebx
  801134:	83 ec 2c             	sub    $0x2c,%esp
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80113a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80113c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80113f:	89 f8                	mov    %edi,%eax
  801141:	c1 e8 0c             	shr    $0xc,%eax
  801144:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801147:	e8 9b fc ff ff       	call   800de7 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80114c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801152:	0f 84 de 00 00 00    	je     801236 <pgfault+0x108>
  801158:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80115a:	85 c0                	test   %eax,%eax
  80115c:	79 20                	jns    80117e <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80115e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801162:	c7 44 24 08 22 33 80 	movl   $0x803322,0x8(%esp)
  801169:	00 
  80116a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801171:	00 
  801172:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  801179:	e8 cd f0 ff ff       	call   80024b <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  80117e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801181:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801188:	25 05 08 00 00       	and    $0x805,%eax
  80118d:	3d 05 08 00 00       	cmp    $0x805,%eax
  801192:	0f 85 ba 00 00 00    	jne    801252 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801198:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80119f:	00 
  8011a0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011a7:	00 
  8011a8:	89 1c 24             	mov    %ebx,(%esp)
  8011ab:	e8 75 fc ff ff       	call   800e25 <sys_page_alloc>
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	79 20                	jns    8011d4 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  8011b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011b8:	c7 44 24 08 49 33 80 	movl   $0x803349,0x8(%esp)
  8011bf:	00 
  8011c0:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8011c7:	00 
  8011c8:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  8011cf:	e8 77 f0 ff ff       	call   80024b <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  8011d4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8011da:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011e1:	00 
  8011e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011e6:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011ed:	e8 62 f9 ff ff       	call   800b54 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  8011f2:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011f9:	00 
  8011fa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801202:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801209:	00 
  80120a:	89 1c 24             	mov    %ebx,(%esp)
  80120d:	e8 67 fc ff ff       	call   800e79 <sys_page_map>
  801212:	85 c0                	test   %eax,%eax
  801214:	79 3c                	jns    801252 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801216:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80121a:	c7 44 24 08 5c 33 80 	movl   $0x80335c,0x8(%esp)
  801221:	00 
  801222:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801229:	00 
  80122a:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  801231:	e8 15 f0 ff ff       	call   80024b <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801236:	c7 44 24 08 80 33 80 	movl   $0x803380,0x8(%esp)
  80123d:	00 
  80123e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801245:	00 
  801246:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  80124d:	e8 f9 ef ff ff       	call   80024b <_panic>
}
  801252:	83 c4 2c             	add    $0x2c,%esp
  801255:	5b                   	pop    %ebx
  801256:	5e                   	pop    %esi
  801257:	5f                   	pop    %edi
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	56                   	push   %esi
  80125e:	53                   	push   %ebx
  80125f:	83 ec 20             	sub    $0x20,%esp
  801262:	8b 75 08             	mov    0x8(%ebp),%esi
  801265:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801268:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80126f:	00 
  801270:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801274:	89 34 24             	mov    %esi,(%esp)
  801277:	e8 a9 fb ff ff       	call   800e25 <sys_page_alloc>
  80127c:	85 c0                	test   %eax,%eax
  80127e:	79 20                	jns    8012a0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801280:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801284:	c7 44 24 08 49 33 80 	movl   $0x803349,0x8(%esp)
  80128b:	00 
  80128c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801293:	00 
  801294:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  80129b:	e8 ab ef ff ff       	call   80024b <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8012a0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012a7:	00 
  8012a8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8012af:	00 
  8012b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012b7:	00 
  8012b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012bc:	89 34 24             	mov    %esi,(%esp)
  8012bf:	e8 b5 fb ff ff       	call   800e79 <sys_page_map>
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	79 20                	jns    8012e8 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  8012c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012cc:	c7 44 24 08 5c 33 80 	movl   $0x80335c,0x8(%esp)
  8012d3:	00 
  8012d4:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8012db:	00 
  8012dc:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  8012e3:	e8 63 ef ff ff       	call   80024b <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8012e8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012ef:	00 
  8012f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012f4:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8012fb:	e8 54 f8 ff ff       	call   800b54 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801300:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801307:	00 
  801308:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80130f:	e8 b8 fb ff ff       	call   800ecc <sys_page_unmap>
  801314:	85 c0                	test   %eax,%eax
  801316:	79 20                	jns    801338 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801318:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80131c:	c7 44 24 08 6d 33 80 	movl   $0x80336d,0x8(%esp)
  801323:	00 
  801324:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80132b:	00 
  80132c:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  801333:	e8 13 ef ff ff       	call   80024b <_panic>

}
  801338:	83 c4 20             	add    $0x20,%esp
  80133b:	5b                   	pop    %ebx
  80133c:	5e                   	pop    %esi
  80133d:	5d                   	pop    %ebp
  80133e:	c3                   	ret    

0080133f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	57                   	push   %edi
  801343:	56                   	push   %esi
  801344:	53                   	push   %ebx
  801345:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801348:	c7 04 24 2e 11 80 00 	movl   $0x80112e,(%esp)
  80134f:	e8 e2 16 00 00       	call   802a36 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801354:	b8 08 00 00 00       	mov    $0x8,%eax
  801359:	cd 30                	int    $0x30
  80135b:	89 c6                	mov    %eax,%esi
  80135d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801360:	85 c0                	test   %eax,%eax
  801362:	79 20                	jns    801384 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801364:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801368:	c7 44 24 08 a4 33 80 	movl   $0x8033a4,0x8(%esp)
  80136f:	00 
  801370:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801377:	00 
  801378:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  80137f:	e8 c7 ee ff ff       	call   80024b <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801384:	bb 00 00 00 00       	mov    $0x0,%ebx
  801389:	85 c0                	test   %eax,%eax
  80138b:	75 21                	jne    8013ae <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80138d:	e8 55 fa ff ff       	call   800de7 <sys_getenvid>
  801392:	25 ff 03 00 00       	and    $0x3ff,%eax
  801397:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80139a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80139f:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	e9 88 01 00 00       	jmp    801536 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8013ae:	89 d8                	mov    %ebx,%eax
  8013b0:	c1 e8 16             	shr    $0x16,%eax
  8013b3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013ba:	a8 01                	test   $0x1,%al
  8013bc:	0f 84 e0 00 00 00    	je     8014a2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8013c2:	89 df                	mov    %ebx,%edi
  8013c4:	c1 ef 0c             	shr    $0xc,%edi
  8013c7:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  8013ce:	a8 01                	test   $0x1,%al
  8013d0:	0f 84 c4 00 00 00    	je     80149a <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  8013d6:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  8013dd:	f6 c4 04             	test   $0x4,%ah
  8013e0:	74 0d                	je     8013ef <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  8013e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e7:	83 c8 05             	or     $0x5,%eax
  8013ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013ed:	eb 1b                	jmp    80140a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  8013ef:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  8013f4:	83 f8 01             	cmp    $0x1,%eax
  8013f7:	19 c0                	sbb    %eax,%eax
  8013f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013fc:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801403:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80140a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80140d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801410:	89 44 24 10          	mov    %eax,0x10(%esp)
  801414:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80141f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801423:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142a:	e8 4a fa ff ff       	call   800e79 <sys_page_map>
  80142f:	85 c0                	test   %eax,%eax
  801431:	79 20                	jns    801453 <fork+0x114>
		panic("sys_page_map: %e", r);
  801433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801437:	c7 44 24 08 5c 33 80 	movl   $0x80335c,0x8(%esp)
  80143e:	00 
  80143f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801446:	00 
  801447:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  80144e:	e8 f8 ed ff ff       	call   80024b <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801456:	89 44 24 10          	mov    %eax,0x10(%esp)
  80145a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80145e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801465:	00 
  801466:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80146a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801471:	e8 03 fa ff ff       	call   800e79 <sys_page_map>
  801476:	85 c0                	test   %eax,%eax
  801478:	79 20                	jns    80149a <fork+0x15b>
		panic("sys_page_map: %e", r);
  80147a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80147e:	c7 44 24 08 5c 33 80 	movl   $0x80335c,0x8(%esp)
  801485:	00 
  801486:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  80148d:	00 
  80148e:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  801495:	e8 b1 ed ff ff       	call   80024b <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  80149a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014a0:	eb 06                	jmp    8014a8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  8014a2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  8014a8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  8014ae:	0f 86 fa fe ff ff    	jbe    8013ae <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8014b4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014bb:	00 
  8014bc:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014c3:	ee 
  8014c4:	89 34 24             	mov    %esi,(%esp)
  8014c7:	e8 59 f9 ff ff       	call   800e25 <sys_page_alloc>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	79 20                	jns    8014f0 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  8014d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d4:	c7 44 24 08 49 33 80 	movl   $0x803349,0x8(%esp)
  8014db:	00 
  8014dc:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  8014e3:	00 
  8014e4:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  8014eb:	e8 5b ed ff ff       	call   80024b <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8014f0:	c7 44 24 04 c9 2a 80 	movl   $0x802ac9,0x4(%esp)
  8014f7:	00 
  8014f8:	89 34 24             	mov    %esi,(%esp)
  8014fb:	e8 e5 fa ff ff       	call   800fe5 <sys_env_set_pgfault_upcall>
  801500:	85 c0                	test   %eax,%eax
  801502:	79 20                	jns    801524 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801504:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801508:	c7 44 24 08 c8 33 80 	movl   $0x8033c8,0x8(%esp)
  80150f:	00 
  801510:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801517:	00 
  801518:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  80151f:	e8 27 ed ff ff       	call   80024b <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801524:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80152b:	00 
  80152c:	89 34 24             	mov    %esi,(%esp)
  80152f:	e8 0b fa ff ff       	call   800f3f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801534:	89 f0                	mov    %esi,%eax

}
  801536:	83 c4 2c             	add    $0x2c,%esp
  801539:	5b                   	pop    %ebx
  80153a:	5e                   	pop    %esi
  80153b:	5f                   	pop    %edi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    

0080153e <sfork>:

// Challenge!
int
sfork(void)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	57                   	push   %edi
  801542:	56                   	push   %esi
  801543:	53                   	push   %ebx
  801544:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801547:	c7 04 24 2e 11 80 00 	movl   $0x80112e,(%esp)
  80154e:	e8 e3 14 00 00       	call   802a36 <set_pgfault_handler>
  801553:	b8 08 00 00 00       	mov    $0x8,%eax
  801558:	cd 30                	int    $0x30
  80155a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80155c:	85 c0                	test   %eax,%eax
  80155e:	79 20                	jns    801580 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801560:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801564:	c7 44 24 08 a4 33 80 	movl   $0x8033a4,0x8(%esp)
  80156b:	00 
  80156c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801573:	00 
  801574:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  80157b:	e8 cb ec ff ff       	call   80024b <_panic>
  801580:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801582:	bb 00 00 00 00       	mov    $0x0,%ebx
  801587:	85 c0                	test   %eax,%eax
  801589:	75 2d                	jne    8015b8 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80158b:	e8 57 f8 ff ff       	call   800de7 <sys_getenvid>
  801590:	25 ff 03 00 00       	and    $0x3ff,%eax
  801595:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801598:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80159d:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  8015a2:	c7 04 24 2e 11 80 00 	movl   $0x80112e,(%esp)
  8015a9:	e8 88 14 00 00       	call   802a36 <set_pgfault_handler>
		return 0;
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b3:	e9 1d 01 00 00       	jmp    8016d5 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8015b8:	89 d8                	mov    %ebx,%eax
  8015ba:	c1 e8 16             	shr    $0x16,%eax
  8015bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c4:	a8 01                	test   $0x1,%al
  8015c6:	74 69                	je     801631 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8015c8:	89 d8                	mov    %ebx,%eax
  8015ca:	c1 e8 0c             	shr    $0xc,%eax
  8015cd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015d4:	f6 c2 01             	test   $0x1,%dl
  8015d7:	74 50                	je     801629 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  8015d9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8015e0:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  8015e3:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8015e9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015f1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8015f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801600:	e8 74 f8 ff ff       	call   800e79 <sys_page_map>
  801605:	85 c0                	test   %eax,%eax
  801607:	79 20                	jns    801629 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801609:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80160d:	c7 44 24 08 5c 33 80 	movl   $0x80335c,0x8(%esp)
  801614:	00 
  801615:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80161c:	00 
  80161d:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  801624:	e8 22 ec ff ff       	call   80024b <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801629:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80162f:	eb 06                	jmp    801637 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801631:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801637:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80163d:	0f 86 75 ff ff ff    	jbe    8015b8 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801643:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80164a:	ee 
  80164b:	89 34 24             	mov    %esi,(%esp)
  80164e:	e8 07 fc ff ff       	call   80125a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801653:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80165a:	00 
  80165b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801662:	ee 
  801663:	89 34 24             	mov    %esi,(%esp)
  801666:	e8 ba f7 ff ff       	call   800e25 <sys_page_alloc>
  80166b:	85 c0                	test   %eax,%eax
  80166d:	79 20                	jns    80168f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80166f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801673:	c7 44 24 08 49 33 80 	movl   $0x803349,0x8(%esp)
  80167a:	00 
  80167b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801682:	00 
  801683:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  80168a:	e8 bc eb ff ff       	call   80024b <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80168f:	c7 44 24 04 c9 2a 80 	movl   $0x802ac9,0x4(%esp)
  801696:	00 
  801697:	89 34 24             	mov    %esi,(%esp)
  80169a:	e8 46 f9 ff ff       	call   800fe5 <sys_env_set_pgfault_upcall>
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	79 20                	jns    8016c3 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  8016a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016a7:	c7 44 24 08 c8 33 80 	movl   $0x8033c8,0x8(%esp)
  8016ae:	00 
  8016af:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  8016b6:	00 
  8016b7:	c7 04 24 3e 33 80 00 	movl   $0x80333e,(%esp)
  8016be:	e8 88 eb ff ff       	call   80024b <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8016c3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8016ca:	00 
  8016cb:	89 34 24             	mov    %esi,(%esp)
  8016ce:	e8 6c f8 ff ff       	call   800f3f <sys_env_set_status>
	return envid;
  8016d3:	89 f0                	mov    %esi,%eax

}
  8016d5:	83 c4 2c             	add    $0x2c,%esp
  8016d8:	5b                   	pop    %ebx
  8016d9:	5e                   	pop    %esi
  8016da:	5f                   	pop    %edi
  8016db:	5d                   	pop    %ebp
  8016dc:	c3                   	ret    
  8016dd:	66 90                	xchg   %ax,%ax
  8016df:	90                   	nop

008016e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8016eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8016fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801700:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801712:	89 c2                	mov    %eax,%edx
  801714:	c1 ea 16             	shr    $0x16,%edx
  801717:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80171e:	f6 c2 01             	test   $0x1,%dl
  801721:	74 11                	je     801734 <fd_alloc+0x2d>
  801723:	89 c2                	mov    %eax,%edx
  801725:	c1 ea 0c             	shr    $0xc,%edx
  801728:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80172f:	f6 c2 01             	test   $0x1,%dl
  801732:	75 09                	jne    80173d <fd_alloc+0x36>
			*fd_store = fd;
  801734:	89 01                	mov    %eax,(%ecx)
			return 0;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
  80173b:	eb 17                	jmp    801754 <fd_alloc+0x4d>
  80173d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801742:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801747:	75 c9                	jne    801712 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801749:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80174f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    

00801756 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80175c:	83 f8 1f             	cmp    $0x1f,%eax
  80175f:	77 36                	ja     801797 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801761:	c1 e0 0c             	shl    $0xc,%eax
  801764:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801769:	89 c2                	mov    %eax,%edx
  80176b:	c1 ea 16             	shr    $0x16,%edx
  80176e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801775:	f6 c2 01             	test   $0x1,%dl
  801778:	74 24                	je     80179e <fd_lookup+0x48>
  80177a:	89 c2                	mov    %eax,%edx
  80177c:	c1 ea 0c             	shr    $0xc,%edx
  80177f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801786:	f6 c2 01             	test   $0x1,%dl
  801789:	74 1a                	je     8017a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80178b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178e:	89 02                	mov    %eax,(%edx)
	return 0;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 13                	jmp    8017aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801797:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179c:	eb 0c                	jmp    8017aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80179e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a3:	eb 05                	jmp    8017aa <fd_lookup+0x54>
  8017a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8017aa:	5d                   	pop    %ebp
  8017ab:	c3                   	ret    

008017ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 18             	sub    $0x18,%esp
  8017b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ba:	eb 13                	jmp    8017cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8017bc:	39 08                	cmp    %ecx,(%eax)
  8017be:	75 0c                	jne    8017cc <dev_lookup+0x20>
			*dev = devtab[i];
  8017c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ca:	eb 38                	jmp    801804 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017cc:	83 c2 01             	add    $0x1,%edx
  8017cf:	8b 04 95 68 34 80 00 	mov    0x803468(,%edx,4),%eax
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	75 e2                	jne    8017bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017da:	a1 08 50 80 00       	mov    0x805008,%eax
  8017df:	8b 40 48             	mov    0x48(%eax),%eax
  8017e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ea:	c7 04 24 ec 33 80 00 	movl   $0x8033ec,(%esp)
  8017f1:	e8 4e eb ff ff       	call   800344 <cprintf>
	*dev = 0;
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	56                   	push   %esi
  80180a:	53                   	push   %ebx
  80180b:	83 ec 20             	sub    $0x20,%esp
  80180e:	8b 75 08             	mov    0x8(%ebp),%esi
  801811:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801814:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801817:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80181b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801821:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801824:	89 04 24             	mov    %eax,(%esp)
  801827:	e8 2a ff ff ff       	call   801756 <fd_lookup>
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 05                	js     801835 <fd_close+0x2f>
	    || fd != fd2)
  801830:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801833:	74 0c                	je     801841 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801835:	84 db                	test   %bl,%bl
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
  80183c:	0f 44 c2             	cmove  %edx,%eax
  80183f:	eb 3f                	jmp    801880 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801841:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801844:	89 44 24 04          	mov    %eax,0x4(%esp)
  801848:	8b 06                	mov    (%esi),%eax
  80184a:	89 04 24             	mov    %eax,(%esp)
  80184d:	e8 5a ff ff ff       	call   8017ac <dev_lookup>
  801852:	89 c3                	mov    %eax,%ebx
  801854:	85 c0                	test   %eax,%eax
  801856:	78 16                	js     80186e <fd_close+0x68>
		if (dev->dev_close)
  801858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80185e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801863:	85 c0                	test   %eax,%eax
  801865:	74 07                	je     80186e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801867:	89 34 24             	mov    %esi,(%esp)
  80186a:	ff d0                	call   *%eax
  80186c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80186e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801872:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801879:	e8 4e f6 ff ff       	call   800ecc <sys_page_unmap>
	return r;
  80187e:	89 d8                	mov    %ebx,%eax
}
  801880:	83 c4 20             	add    $0x20,%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5d                   	pop    %ebp
  801886:	c3                   	ret    

00801887 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80188d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801890:	89 44 24 04          	mov    %eax,0x4(%esp)
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	89 04 24             	mov    %eax,(%esp)
  80189a:	e8 b7 fe ff ff       	call   801756 <fd_lookup>
  80189f:	89 c2                	mov    %eax,%edx
  8018a1:	85 d2                	test   %edx,%edx
  8018a3:	78 13                	js     8018b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8018a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018ac:	00 
  8018ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b0:	89 04 24             	mov    %eax,(%esp)
  8018b3:	e8 4e ff ff ff       	call   801806 <fd_close>
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <close_all>:

void
close_all(void)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018c6:	89 1c 24             	mov    %ebx,(%esp)
  8018c9:	e8 b9 ff ff ff       	call   801887 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8018ce:	83 c3 01             	add    $0x1,%ebx
  8018d1:	83 fb 20             	cmp    $0x20,%ebx
  8018d4:	75 f0                	jne    8018c6 <close_all+0xc>
		close(i);
}
  8018d6:	83 c4 14             	add    $0x14,%esp
  8018d9:	5b                   	pop    %ebx
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	57                   	push   %edi
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	89 04 24             	mov    %eax,(%esp)
  8018f2:	e8 5f fe ff ff       	call   801756 <fd_lookup>
  8018f7:	89 c2                	mov    %eax,%edx
  8018f9:	85 d2                	test   %edx,%edx
  8018fb:	0f 88 e1 00 00 00    	js     8019e2 <dup+0x106>
		return r;
	close(newfdnum);
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	e8 7b ff ff ff       	call   801887 <close>

	newfd = INDEX2FD(newfdnum);
  80190c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80190f:	c1 e3 0c             	shl    $0xc,%ebx
  801912:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80191b:	89 04 24             	mov    %eax,(%esp)
  80191e:	e8 cd fd ff ff       	call   8016f0 <fd2data>
  801923:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801925:	89 1c 24             	mov    %ebx,(%esp)
  801928:	e8 c3 fd ff ff       	call   8016f0 <fd2data>
  80192d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80192f:	89 f0                	mov    %esi,%eax
  801931:	c1 e8 16             	shr    $0x16,%eax
  801934:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80193b:	a8 01                	test   $0x1,%al
  80193d:	74 43                	je     801982 <dup+0xa6>
  80193f:	89 f0                	mov    %esi,%eax
  801941:	c1 e8 0c             	shr    $0xc,%eax
  801944:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80194b:	f6 c2 01             	test   $0x1,%dl
  80194e:	74 32                	je     801982 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801950:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801957:	25 07 0e 00 00       	and    $0xe07,%eax
  80195c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801960:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801964:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80196b:	00 
  80196c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801970:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801977:	e8 fd f4 ff ff       	call   800e79 <sys_page_map>
  80197c:	89 c6                	mov    %eax,%esi
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 3e                	js     8019c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801985:	89 c2                	mov    %eax,%edx
  801987:	c1 ea 0c             	shr    $0xc,%edx
  80198a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801991:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801997:	89 54 24 10          	mov    %edx,0x10(%esp)
  80199b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80199f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019a6:	00 
  8019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b2:	e8 c2 f4 ff ff       	call   800e79 <sys_page_map>
  8019b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019bc:	85 f6                	test   %esi,%esi
  8019be:	79 22                	jns    8019e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8019c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cb:	e8 fc f4 ff ff       	call   800ecc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019db:	e8 ec f4 ff ff       	call   800ecc <sys_page_unmap>
	return r;
  8019e0:	89 f0                	mov    %esi,%eax
}
  8019e2:	83 c4 3c             	add    $0x3c,%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5f                   	pop    %edi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    

008019ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 24             	sub    $0x24,%esp
  8019f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fb:	89 1c 24             	mov    %ebx,(%esp)
  8019fe:	e8 53 fd ff ff       	call   801756 <fd_lookup>
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	85 d2                	test   %edx,%edx
  801a07:	78 6d                	js     801a76 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	89 04 24             	mov    %eax,(%esp)
  801a18:	e8 8f fd ff ff       	call   8017ac <dev_lookup>
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 55                	js     801a76 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a24:	8b 50 08             	mov    0x8(%eax),%edx
  801a27:	83 e2 03             	and    $0x3,%edx
  801a2a:	83 fa 01             	cmp    $0x1,%edx
  801a2d:	75 23                	jne    801a52 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a2f:	a1 08 50 80 00       	mov    0x805008,%eax
  801a34:	8b 40 48             	mov    0x48(%eax),%eax
  801a37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3f:	c7 04 24 2d 34 80 00 	movl   $0x80342d,(%esp)
  801a46:	e8 f9 e8 ff ff       	call   800344 <cprintf>
		return -E_INVAL;
  801a4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a50:	eb 24                	jmp    801a76 <read+0x8c>
	}
	if (!dev->dev_read)
  801a52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a55:	8b 52 08             	mov    0x8(%edx),%edx
  801a58:	85 d2                	test   %edx,%edx
  801a5a:	74 15                	je     801a71 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a6a:	89 04 24             	mov    %eax,(%esp)
  801a6d:	ff d2                	call   *%edx
  801a6f:	eb 05                	jmp    801a76 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801a71:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801a76:	83 c4 24             	add    $0x24,%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    

00801a7c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	57                   	push   %edi
  801a80:	56                   	push   %esi
  801a81:	53                   	push   %ebx
  801a82:	83 ec 1c             	sub    $0x1c,%esp
  801a85:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a88:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a90:	eb 23                	jmp    801ab5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a92:	89 f0                	mov    %esi,%eax
  801a94:	29 d8                	sub    %ebx,%eax
  801a96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a9a:	89 d8                	mov    %ebx,%eax
  801a9c:	03 45 0c             	add    0xc(%ebp),%eax
  801a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa3:	89 3c 24             	mov    %edi,(%esp)
  801aa6:	e8 3f ff ff ff       	call   8019ea <read>
		if (m < 0)
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 10                	js     801abf <readn+0x43>
			return m;
		if (m == 0)
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	74 0a                	je     801abd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ab3:	01 c3                	add    %eax,%ebx
  801ab5:	39 f3                	cmp    %esi,%ebx
  801ab7:	72 d9                	jb     801a92 <readn+0x16>
  801ab9:	89 d8                	mov    %ebx,%eax
  801abb:	eb 02                	jmp    801abf <readn+0x43>
  801abd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801abf:	83 c4 1c             	add    $0x1c,%esp
  801ac2:	5b                   	pop    %ebx
  801ac3:	5e                   	pop    %esi
  801ac4:	5f                   	pop    %edi
  801ac5:	5d                   	pop    %ebp
  801ac6:	c3                   	ret    

00801ac7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	53                   	push   %ebx
  801acb:	83 ec 24             	sub    $0x24,%esp
  801ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad8:	89 1c 24             	mov    %ebx,(%esp)
  801adb:	e8 76 fc ff ff       	call   801756 <fd_lookup>
  801ae0:	89 c2                	mov    %eax,%edx
  801ae2:	85 d2                	test   %edx,%edx
  801ae4:	78 68                	js     801b4e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af0:	8b 00                	mov    (%eax),%eax
  801af2:	89 04 24             	mov    %eax,(%esp)
  801af5:	e8 b2 fc ff ff       	call   8017ac <dev_lookup>
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 50                	js     801b4e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b01:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b05:	75 23                	jne    801b2a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b07:	a1 08 50 80 00       	mov    0x805008,%eax
  801b0c:	8b 40 48             	mov    0x48(%eax),%eax
  801b0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b17:	c7 04 24 49 34 80 00 	movl   $0x803449,(%esp)
  801b1e:	e8 21 e8 ff ff       	call   800344 <cprintf>
		return -E_INVAL;
  801b23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b28:	eb 24                	jmp    801b4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2d:	8b 52 0c             	mov    0xc(%edx),%edx
  801b30:	85 d2                	test   %edx,%edx
  801b32:	74 15                	je     801b49 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b42:	89 04 24             	mov    %eax,(%esp)
  801b45:	ff d2                	call   *%edx
  801b47:	eb 05                	jmp    801b4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801b49:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801b4e:	83 c4 24             	add    $0x24,%esp
  801b51:	5b                   	pop    %ebx
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    

00801b54 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b5a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	89 04 24             	mov    %eax,(%esp)
  801b67:	e8 ea fb ff ff       	call   801756 <fd_lookup>
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 0e                	js     801b7e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 24             	sub    $0x24,%esp
  801b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b91:	89 1c 24             	mov    %ebx,(%esp)
  801b94:	e8 bd fb ff ff       	call   801756 <fd_lookup>
  801b99:	89 c2                	mov    %eax,%edx
  801b9b:	85 d2                	test   %edx,%edx
  801b9d:	78 61                	js     801c00 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba9:	8b 00                	mov    (%eax),%eax
  801bab:	89 04 24             	mov    %eax,(%esp)
  801bae:	e8 f9 fb ff ff       	call   8017ac <dev_lookup>
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 49                	js     801c00 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bbe:	75 23                	jne    801be3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801bc0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bc5:	8b 40 48             	mov    0x48(%eax),%eax
  801bc8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd0:	c7 04 24 0c 34 80 00 	movl   $0x80340c,(%esp)
  801bd7:	e8 68 e7 ff ff       	call   800344 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801bdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801be1:	eb 1d                	jmp    801c00 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be6:	8b 52 18             	mov    0x18(%edx),%edx
  801be9:	85 d2                	test   %edx,%edx
  801beb:	74 0e                	je     801bfb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf4:	89 04 24             	mov    %eax,(%esp)
  801bf7:	ff d2                	call   *%edx
  801bf9:	eb 05                	jmp    801c00 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801bfb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801c00:	83 c4 24             	add    $0x24,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    

00801c06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	53                   	push   %ebx
  801c0a:	83 ec 24             	sub    $0x24,%esp
  801c0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	89 04 24             	mov    %eax,(%esp)
  801c1d:	e8 34 fb ff ff       	call   801756 <fd_lookup>
  801c22:	89 c2                	mov    %eax,%edx
  801c24:	85 d2                	test   %edx,%edx
  801c26:	78 52                	js     801c7a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c32:	8b 00                	mov    (%eax),%eax
  801c34:	89 04 24             	mov    %eax,(%esp)
  801c37:	e8 70 fb ff ff       	call   8017ac <dev_lookup>
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 3a                	js     801c7a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c43:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c47:	74 2c                	je     801c75 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c49:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c53:	00 00 00 
	stat->st_isdir = 0;
  801c56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c5d:	00 00 00 
	stat->st_dev = dev;
  801c60:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c6d:	89 14 24             	mov    %edx,(%esp)
  801c70:	ff 50 14             	call   *0x14(%eax)
  801c73:	eb 05                	jmp    801c7a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801c75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801c7a:	83 c4 24             	add    $0x24,%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c8f:	00 
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	89 04 24             	mov    %eax,(%esp)
  801c96:	e8 99 02 00 00       	call   801f34 <open>
  801c9b:	89 c3                	mov    %eax,%ebx
  801c9d:	85 db                	test   %ebx,%ebx
  801c9f:	78 1b                	js     801cbc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca8:	89 1c 24             	mov    %ebx,(%esp)
  801cab:	e8 56 ff ff ff       	call   801c06 <fstat>
  801cb0:	89 c6                	mov    %eax,%esi
	close(fd);
  801cb2:	89 1c 24             	mov    %ebx,(%esp)
  801cb5:	e8 cd fb ff ff       	call   801887 <close>
	return r;
  801cba:	89 f0                	mov    %esi,%eax
}
  801cbc:	83 c4 10             	add    $0x10,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 10             	sub    $0x10,%esp
  801ccb:	89 c6                	mov    %eax,%esi
  801ccd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ccf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cd6:	75 11                	jne    801ce9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801cdf:	e8 db 0e 00 00       	call   802bbf <ipc_find_env>
  801ce4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ce9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801cf0:	00 
  801cf1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801cf8:	00 
  801cf9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cfd:	a1 00 50 80 00       	mov    0x805000,%eax
  801d02:	89 04 24             	mov    %eax,(%esp)
  801d05:	e8 4e 0e 00 00       	call   802b58 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d11:	00 
  801d12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d1d:	e8 ce 0d 00 00       	call   802af0 <ipc_recv>
}
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	8b 40 0c             	mov    0xc(%eax),%eax
  801d35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d42:	ba 00 00 00 00       	mov    $0x0,%edx
  801d47:	b8 02 00 00 00       	mov    $0x2,%eax
  801d4c:	e8 72 ff ff ff       	call   801cc3 <fsipc>
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d64:	ba 00 00 00 00       	mov    $0x0,%edx
  801d69:	b8 06 00 00 00       	mov    $0x6,%eax
  801d6e:	e8 50 ff ff ff       	call   801cc3 <fsipc>
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	53                   	push   %ebx
  801d79:	83 ec 14             	sub    $0x14,%esp
  801d7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	8b 40 0c             	mov    0xc(%eax),%eax
  801d85:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d94:	e8 2a ff ff ff       	call   801cc3 <fsipc>
  801d99:	89 c2                	mov    %eax,%edx
  801d9b:	85 d2                	test   %edx,%edx
  801d9d:	78 2b                	js     801dca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d9f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801da6:	00 
  801da7:	89 1c 24             	mov    %ebx,(%esp)
  801daa:	e8 08 ec ff ff       	call   8009b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801daf:	a1 80 60 80 00       	mov    0x806080,%eax
  801db4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dba:	a1 84 60 80 00       	mov    0x806084,%eax
  801dbf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dca:	83 c4 14             	add    $0x14,%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    

00801dd0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 14             	sub    $0x14,%esp
  801dd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801dda:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801de0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801de5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801de8:	8b 55 08             	mov    0x8(%ebp),%edx
  801deb:	8b 52 0c             	mov    0xc(%edx),%edx
  801dee:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801df4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801df9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e0b:	e8 44 ed ff ff       	call   800b54 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801e10:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801e17:	00 
  801e18:	c7 04 24 7c 34 80 00 	movl   $0x80347c,(%esp)
  801e1f:	e8 20 e5 ff ff       	call   800344 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e24:	ba 00 00 00 00       	mov    $0x0,%edx
  801e29:	b8 04 00 00 00       	mov    $0x4,%eax
  801e2e:	e8 90 fe ff ff       	call   801cc3 <fsipc>
  801e33:	85 c0                	test   %eax,%eax
  801e35:	78 53                	js     801e8a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801e37:	39 c3                	cmp    %eax,%ebx
  801e39:	73 24                	jae    801e5f <devfile_write+0x8f>
  801e3b:	c7 44 24 0c 81 34 80 	movl   $0x803481,0xc(%esp)
  801e42:	00 
  801e43:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  801e4a:	00 
  801e4b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801e52:	00 
  801e53:	c7 04 24 9d 34 80 00 	movl   $0x80349d,(%esp)
  801e5a:	e8 ec e3 ff ff       	call   80024b <_panic>
	assert(r <= PGSIZE);
  801e5f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e64:	7e 24                	jle    801e8a <devfile_write+0xba>
  801e66:	c7 44 24 0c a8 34 80 	movl   $0x8034a8,0xc(%esp)
  801e6d:	00 
  801e6e:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  801e75:	00 
  801e76:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801e7d:	00 
  801e7e:	c7 04 24 9d 34 80 00 	movl   $0x80349d,(%esp)
  801e85:	e8 c1 e3 ff ff       	call   80024b <_panic>
	return r;
}
  801e8a:	83 c4 14             	add    $0x14,%esp
  801e8d:	5b                   	pop    %ebx
  801e8e:	5d                   	pop    %ebp
  801e8f:	c3                   	ret    

00801e90 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	56                   	push   %esi
  801e94:	53                   	push   %ebx
  801e95:	83 ec 10             	sub    $0x10,%esp
  801e98:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ea6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801eac:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb1:	b8 03 00 00 00       	mov    $0x3,%eax
  801eb6:	e8 08 fe ff ff       	call   801cc3 <fsipc>
  801ebb:	89 c3                	mov    %eax,%ebx
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	78 6a                	js     801f2b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ec1:	39 c6                	cmp    %eax,%esi
  801ec3:	73 24                	jae    801ee9 <devfile_read+0x59>
  801ec5:	c7 44 24 0c 81 34 80 	movl   $0x803481,0xc(%esp)
  801ecc:	00 
  801ecd:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  801ed4:	00 
  801ed5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801edc:	00 
  801edd:	c7 04 24 9d 34 80 00 	movl   $0x80349d,(%esp)
  801ee4:	e8 62 e3 ff ff       	call   80024b <_panic>
	assert(r <= PGSIZE);
  801ee9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eee:	7e 24                	jle    801f14 <devfile_read+0x84>
  801ef0:	c7 44 24 0c a8 34 80 	movl   $0x8034a8,0xc(%esp)
  801ef7:	00 
  801ef8:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  801eff:	00 
  801f00:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f07:	00 
  801f08:	c7 04 24 9d 34 80 00 	movl   $0x80349d,(%esp)
  801f0f:	e8 37 e3 ff ff       	call   80024b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f14:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f18:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f1f:	00 
  801f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f23:	89 04 24             	mov    %eax,(%esp)
  801f26:	e8 29 ec ff ff       	call   800b54 <memmove>
	return r;
}
  801f2b:	89 d8                	mov    %ebx,%eax
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5d                   	pop    %ebp
  801f33:	c3                   	ret    

00801f34 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	53                   	push   %ebx
  801f38:	83 ec 24             	sub    $0x24,%esp
  801f3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f3e:	89 1c 24             	mov    %ebx,(%esp)
  801f41:	e8 3a ea ff ff       	call   800980 <strlen>
  801f46:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f4b:	7f 60                	jg     801fad <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f50:	89 04 24             	mov    %eax,(%esp)
  801f53:	e8 af f7 ff ff       	call   801707 <fd_alloc>
  801f58:	89 c2                	mov    %eax,%edx
  801f5a:	85 d2                	test   %edx,%edx
  801f5c:	78 54                	js     801fb2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f62:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f69:	e8 49 ea ff ff       	call   8009b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f71:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f79:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7e:	e8 40 fd ff ff       	call   801cc3 <fsipc>
  801f83:	89 c3                	mov    %eax,%ebx
  801f85:	85 c0                	test   %eax,%eax
  801f87:	79 17                	jns    801fa0 <open+0x6c>
		fd_close(fd, 0);
  801f89:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f90:	00 
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	89 04 24             	mov    %eax,(%esp)
  801f97:	e8 6a f8 ff ff       	call   801806 <fd_close>
		return r;
  801f9c:	89 d8                	mov    %ebx,%eax
  801f9e:	eb 12                	jmp    801fb2 <open+0x7e>
	}

	return fd2num(fd);
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	89 04 24             	mov    %eax,(%esp)
  801fa6:	e8 35 f7 ff ff       	call   8016e0 <fd2num>
  801fab:	eb 05                	jmp    801fb2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801fad:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801fb2:	83 c4 24             	add    $0x24,%esp
  801fb5:	5b                   	pop    %ebx
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    

00801fb8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc3:	b8 08 00 00 00       	mov    $0x8,%eax
  801fc8:	e8 f6 fc ff ff       	call   801cc3 <fsipc>
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <evict>:

int evict(void)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801fd5:	c7 04 24 b4 34 80 00 	movl   $0x8034b4,(%esp)
  801fdc:	e8 63 e3 ff ff       	call   800344 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801fe1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe6:	b8 09 00 00 00       	mov    $0x9,%eax
  801feb:	e8 d3 fc ff ff       	call   801cc3 <fsipc>
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    
  801ff2:	66 90                	xchg   %ax,%ax
  801ff4:	66 90                	xchg   %ax,%ax
  801ff6:	66 90                	xchg   %ax,%ax
  801ff8:	66 90                	xchg   %ax,%ax
  801ffa:	66 90                	xchg   %ax,%ax
  801ffc:	66 90                	xchg   %ax,%ax
  801ffe:	66 90                	xchg   %ax,%ax

00802000 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802006:	c7 44 24 04 cd 34 80 	movl   $0x8034cd,0x4(%esp)
  80200d:	00 
  80200e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802011:	89 04 24             	mov    %eax,(%esp)
  802014:	e8 9e e9 ff ff       	call   8009b7 <strcpy>
	return 0;
}
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	53                   	push   %ebx
  802024:	83 ec 14             	sub    $0x14,%esp
  802027:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80202a:	89 1c 24             	mov    %ebx,(%esp)
  80202d:	e8 c5 0b 00 00       	call   802bf7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802032:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802037:	83 f8 01             	cmp    $0x1,%eax
  80203a:	75 0d                	jne    802049 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80203c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80203f:	89 04 24             	mov    %eax,(%esp)
  802042:	e8 29 03 00 00       	call   802370 <nsipc_close>
  802047:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802049:	89 d0                	mov    %edx,%eax
  80204b:	83 c4 14             	add    $0x14,%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802057:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80205e:	00 
  80205f:	8b 45 10             	mov    0x10(%ebp),%eax
  802062:	89 44 24 08          	mov    %eax,0x8(%esp)
  802066:	8b 45 0c             	mov    0xc(%ebp),%eax
  802069:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 40 0c             	mov    0xc(%eax),%eax
  802073:	89 04 24             	mov    %eax,(%esp)
  802076:	e8 f0 03 00 00       	call   80246b <nsipc_send>
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802083:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80208a:	00 
  80208b:	8b 45 10             	mov    0x10(%ebp),%eax
  80208e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802092:	8b 45 0c             	mov    0xc(%ebp),%eax
  802095:	89 44 24 04          	mov    %eax,0x4(%esp)
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	8b 40 0c             	mov    0xc(%eax),%eax
  80209f:	89 04 24             	mov    %eax,(%esp)
  8020a2:	e8 44 03 00 00       	call   8023eb <nsipc_recv>
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020af:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020b6:	89 04 24             	mov    %eax,(%esp)
  8020b9:	e8 98 f6 ff ff       	call   801756 <fd_lookup>
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	78 17                	js     8020d9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020cb:	39 08                	cmp    %ecx,(%eax)
  8020cd:	75 05                	jne    8020d4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8020cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d2:	eb 05                	jmp    8020d9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8020d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	56                   	push   %esi
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 20             	sub    $0x20,%esp
  8020e3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e8:	89 04 24             	mov    %eax,(%esp)
  8020eb:	e8 17 f6 ff ff       	call   801707 <fd_alloc>
  8020f0:	89 c3                	mov    %eax,%ebx
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 21                	js     802117 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020fd:	00 
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	89 44 24 04          	mov    %eax,0x4(%esp)
  802105:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80210c:	e8 14 ed ff ff       	call   800e25 <sys_page_alloc>
  802111:	89 c3                	mov    %eax,%ebx
  802113:	85 c0                	test   %eax,%eax
  802115:	79 0c                	jns    802123 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802117:	89 34 24             	mov    %esi,(%esp)
  80211a:	e8 51 02 00 00       	call   802370 <nsipc_close>
		return r;
  80211f:	89 d8                	mov    %ebx,%eax
  802121:	eb 20                	jmp    802143 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802123:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80212e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802131:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802138:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80213b:	89 14 24             	mov    %edx,(%esp)
  80213e:	e8 9d f5 ff ff       	call   8016e0 <fd2num>
}
  802143:	83 c4 20             	add    $0x20,%esp
  802146:	5b                   	pop    %ebx
  802147:	5e                   	pop    %esi
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    

0080214a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	e8 51 ff ff ff       	call   8020a9 <fd2sockid>
		return r;
  802158:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80215a:	85 c0                	test   %eax,%eax
  80215c:	78 23                	js     802181 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80215e:	8b 55 10             	mov    0x10(%ebp),%edx
  802161:	89 54 24 08          	mov    %edx,0x8(%esp)
  802165:	8b 55 0c             	mov    0xc(%ebp),%edx
  802168:	89 54 24 04          	mov    %edx,0x4(%esp)
  80216c:	89 04 24             	mov    %eax,(%esp)
  80216f:	e8 45 01 00 00       	call   8022b9 <nsipc_accept>
		return r;
  802174:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802176:	85 c0                	test   %eax,%eax
  802178:	78 07                	js     802181 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80217a:	e8 5c ff ff ff       	call   8020db <alloc_sockfd>
  80217f:	89 c1                	mov    %eax,%ecx
}
  802181:	89 c8                	mov    %ecx,%eax
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	e8 16 ff ff ff       	call   8020a9 <fd2sockid>
  802193:	89 c2                	mov    %eax,%edx
  802195:	85 d2                	test   %edx,%edx
  802197:	78 16                	js     8021af <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802199:	8b 45 10             	mov    0x10(%ebp),%eax
  80219c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a7:	89 14 24             	mov    %edx,(%esp)
  8021aa:	e8 60 01 00 00       	call   80230f <nsipc_bind>
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <shutdown>:

int
shutdown(int s, int how)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	e8 ea fe ff ff       	call   8020a9 <fd2sockid>
  8021bf:	89 c2                	mov    %eax,%edx
  8021c1:	85 d2                	test   %edx,%edx
  8021c3:	78 0f                	js     8021d4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8021c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cc:	89 14 24             	mov    %edx,(%esp)
  8021cf:	e8 7a 01 00 00       	call   80234e <nsipc_shutdown>
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	e8 c5 fe ff ff       	call   8020a9 <fd2sockid>
  8021e4:	89 c2                	mov    %eax,%edx
  8021e6:	85 d2                	test   %edx,%edx
  8021e8:	78 16                	js     802200 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f8:	89 14 24             	mov    %edx,(%esp)
  8021fb:	e8 8a 01 00 00       	call   80238a <nsipc_connect>
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <listen>:

int
listen(int s, int backlog)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	e8 99 fe ff ff       	call   8020a9 <fd2sockid>
  802210:	89 c2                	mov    %eax,%edx
  802212:	85 d2                	test   %edx,%edx
  802214:	78 0f                	js     802225 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802216:	8b 45 0c             	mov    0xc(%ebp),%eax
  802219:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221d:	89 14 24             	mov    %edx,(%esp)
  802220:	e8 a4 01 00 00       	call   8023c9 <nsipc_listen>
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80222d:	8b 45 10             	mov    0x10(%ebp),%eax
  802230:	89 44 24 08          	mov    %eax,0x8(%esp)
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	89 04 24             	mov    %eax,(%esp)
  802241:	e8 98 02 00 00       	call   8024de <nsipc_socket>
  802246:	89 c2                	mov    %eax,%edx
  802248:	85 d2                	test   %edx,%edx
  80224a:	78 05                	js     802251 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80224c:	e8 8a fe ff ff       	call   8020db <alloc_sockfd>
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	53                   	push   %ebx
  802257:	83 ec 14             	sub    $0x14,%esp
  80225a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80225c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802263:	75 11                	jne    802276 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802265:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80226c:	e8 4e 09 00 00       	call   802bbf <ipc_find_env>
  802271:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802276:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80227d:	00 
  80227e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802285:	00 
  802286:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80228a:	a1 04 50 80 00       	mov    0x805004,%eax
  80228f:	89 04 24             	mov    %eax,(%esp)
  802292:	e8 c1 08 00 00       	call   802b58 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802297:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80229e:	00 
  80229f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022a6:	00 
  8022a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022ae:	e8 3d 08 00 00       	call   802af0 <ipc_recv>
}
  8022b3:	83 c4 14             	add    $0x14,%esp
  8022b6:	5b                   	pop    %ebx
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    

008022b9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	56                   	push   %esi
  8022bd:	53                   	push   %ebx
  8022be:	83 ec 10             	sub    $0x10,%esp
  8022c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022cc:	8b 06                	mov    (%esi),%eax
  8022ce:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d8:	e8 76 ff ff ff       	call   802253 <nsipc>
  8022dd:	89 c3                	mov    %eax,%ebx
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	78 23                	js     802306 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022e3:	a1 10 70 80 00       	mov    0x807010,%eax
  8022e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ec:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022f3:	00 
  8022f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f7:	89 04 24             	mov    %eax,(%esp)
  8022fa:	e8 55 e8 ff ff       	call   800b54 <memmove>
		*addrlen = ret->ret_addrlen;
  8022ff:	a1 10 70 80 00       	mov    0x807010,%eax
  802304:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802306:	89 d8                	mov    %ebx,%eax
  802308:	83 c4 10             	add    $0x10,%esp
  80230b:	5b                   	pop    %ebx
  80230c:	5e                   	pop    %esi
  80230d:	5d                   	pop    %ebp
  80230e:	c3                   	ret    

0080230f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	53                   	push   %ebx
  802313:	83 ec 14             	sub    $0x14,%esp
  802316:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802321:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802325:	8b 45 0c             	mov    0xc(%ebp),%eax
  802328:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802333:	e8 1c e8 ff ff       	call   800b54 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802338:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80233e:	b8 02 00 00 00       	mov    $0x2,%eax
  802343:	e8 0b ff ff ff       	call   802253 <nsipc>
}
  802348:	83 c4 14             	add    $0x14,%esp
  80234b:	5b                   	pop    %ebx
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    

0080234e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80235c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802364:	b8 03 00 00 00       	mov    $0x3,%eax
  802369:	e8 e5 fe ff ff       	call   802253 <nsipc>
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <nsipc_close>:

int
nsipc_close(int s)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80237e:	b8 04 00 00 00       	mov    $0x4,%eax
  802383:	e8 cb fe ff ff       	call   802253 <nsipc>
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	53                   	push   %ebx
  80238e:	83 ec 14             	sub    $0x14,%esp
  802391:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80239c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023ae:	e8 a1 e7 ff ff       	call   800b54 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023b3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8023be:	e8 90 fe ff ff       	call   802253 <nsipc>
}
  8023c3:	83 c4 14             	add    $0x14,%esp
  8023c6:	5b                   	pop    %ebx
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    

008023c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023da:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023df:	b8 06 00 00 00       	mov    $0x6,%eax
  8023e4:	e8 6a fe ff ff       	call   802253 <nsipc>
}
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	56                   	push   %esi
  8023ef:	53                   	push   %ebx
  8023f0:	83 ec 10             	sub    $0x10,%esp
  8023f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023fe:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802404:	8b 45 14             	mov    0x14(%ebp),%eax
  802407:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80240c:	b8 07 00 00 00       	mov    $0x7,%eax
  802411:	e8 3d fe ff ff       	call   802253 <nsipc>
  802416:	89 c3                	mov    %eax,%ebx
  802418:	85 c0                	test   %eax,%eax
  80241a:	78 46                	js     802462 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80241c:	39 f0                	cmp    %esi,%eax
  80241e:	7f 07                	jg     802427 <nsipc_recv+0x3c>
  802420:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802425:	7e 24                	jle    80244b <nsipc_recv+0x60>
  802427:	c7 44 24 0c d9 34 80 	movl   $0x8034d9,0xc(%esp)
  80242e:	00 
  80242f:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  802436:	00 
  802437:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80243e:	00 
  80243f:	c7 04 24 ee 34 80 00 	movl   $0x8034ee,(%esp)
  802446:	e8 00 de ff ff       	call   80024b <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80244b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80244f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802456:	00 
  802457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245a:	89 04 24             	mov    %eax,(%esp)
  80245d:	e8 f2 e6 ff ff       	call   800b54 <memmove>
	}

	return r;
}
  802462:	89 d8                	mov    %ebx,%eax
  802464:	83 c4 10             	add    $0x10,%esp
  802467:	5b                   	pop    %ebx
  802468:	5e                   	pop    %esi
  802469:	5d                   	pop    %ebp
  80246a:	c3                   	ret    

0080246b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	53                   	push   %ebx
  80246f:	83 ec 14             	sub    $0x14,%esp
  802472:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80247d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802483:	7e 24                	jle    8024a9 <nsipc_send+0x3e>
  802485:	c7 44 24 0c fa 34 80 	movl   $0x8034fa,0xc(%esp)
  80248c:	00 
  80248d:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  802494:	00 
  802495:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80249c:	00 
  80249d:	c7 04 24 ee 34 80 00 	movl   $0x8034ee,(%esp)
  8024a4:	e8 a2 dd ff ff       	call   80024b <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8024bb:	e8 94 e6 ff ff       	call   800b54 <memmove>
	nsipcbuf.send.req_size = size;
  8024c0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024c9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8024d3:	e8 7b fd ff ff       	call   802253 <nsipc>
}
  8024d8:	83 c4 14             	add    $0x14,%esp
  8024db:	5b                   	pop    %ebx
  8024dc:	5d                   	pop    %ebp
  8024dd:	c3                   	ret    

008024de <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ef:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024fc:	b8 09 00 00 00       	mov    $0x9,%eax
  802501:	e8 4d fd ff ff       	call   802253 <nsipc>
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	56                   	push   %esi
  80250c:	53                   	push   %ebx
  80250d:	83 ec 10             	sub    $0x10,%esp
  802510:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	89 04 24             	mov    %eax,(%esp)
  802519:	e8 d2 f1 ff ff       	call   8016f0 <fd2data>
  80251e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802520:	c7 44 24 04 06 35 80 	movl   $0x803506,0x4(%esp)
  802527:	00 
  802528:	89 1c 24             	mov    %ebx,(%esp)
  80252b:	e8 87 e4 ff ff       	call   8009b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802530:	8b 46 04             	mov    0x4(%esi),%eax
  802533:	2b 06                	sub    (%esi),%eax
  802535:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80253b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802542:	00 00 00 
	stat->st_dev = &devpipe;
  802545:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80254c:	40 80 00 
	return 0;
}
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
  802554:	83 c4 10             	add    $0x10,%esp
  802557:	5b                   	pop    %ebx
  802558:	5e                   	pop    %esi
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    

0080255b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	53                   	push   %ebx
  80255f:	83 ec 14             	sub    $0x14,%esp
  802562:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802565:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802569:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802570:	e8 57 e9 ff ff       	call   800ecc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802575:	89 1c 24             	mov    %ebx,(%esp)
  802578:	e8 73 f1 ff ff       	call   8016f0 <fd2data>
  80257d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802581:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802588:	e8 3f e9 ff ff       	call   800ecc <sys_page_unmap>
}
  80258d:	83 c4 14             	add    $0x14,%esp
  802590:	5b                   	pop    %ebx
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    

00802593 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	57                   	push   %edi
  802597:	56                   	push   %esi
  802598:	53                   	push   %ebx
  802599:	83 ec 2c             	sub    $0x2c,%esp
  80259c:	89 c6                	mov    %eax,%esi
  80259e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8025a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8025a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025a9:	89 34 24             	mov    %esi,(%esp)
  8025ac:	e8 46 06 00 00       	call   802bf7 <pageref>
  8025b1:	89 c7                	mov    %eax,%edi
  8025b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b6:	89 04 24             	mov    %eax,(%esp)
  8025b9:	e8 39 06 00 00       	call   802bf7 <pageref>
  8025be:	39 c7                	cmp    %eax,%edi
  8025c0:	0f 94 c2             	sete   %dl
  8025c3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8025c6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8025cc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8025cf:	39 fb                	cmp    %edi,%ebx
  8025d1:	74 21                	je     8025f4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8025d3:	84 d2                	test   %dl,%dl
  8025d5:	74 ca                	je     8025a1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025d7:	8b 51 58             	mov    0x58(%ecx),%edx
  8025da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025e6:	c7 04 24 0d 35 80 00 	movl   $0x80350d,(%esp)
  8025ed:	e8 52 dd ff ff       	call   800344 <cprintf>
  8025f2:	eb ad                	jmp    8025a1 <_pipeisclosed+0xe>
	}
}
  8025f4:	83 c4 2c             	add    $0x2c,%esp
  8025f7:	5b                   	pop    %ebx
  8025f8:	5e                   	pop    %esi
  8025f9:	5f                   	pop    %edi
  8025fa:	5d                   	pop    %ebp
  8025fb:	c3                   	ret    

008025fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	57                   	push   %edi
  802600:	56                   	push   %esi
  802601:	53                   	push   %ebx
  802602:	83 ec 1c             	sub    $0x1c,%esp
  802605:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802608:	89 34 24             	mov    %esi,(%esp)
  80260b:	e8 e0 f0 ff ff       	call   8016f0 <fd2data>
  802610:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802612:	bf 00 00 00 00       	mov    $0x0,%edi
  802617:	eb 45                	jmp    80265e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802619:	89 da                	mov    %ebx,%edx
  80261b:	89 f0                	mov    %esi,%eax
  80261d:	e8 71 ff ff ff       	call   802593 <_pipeisclosed>
  802622:	85 c0                	test   %eax,%eax
  802624:	75 41                	jne    802667 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802626:	e8 db e7 ff ff       	call   800e06 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80262b:	8b 43 04             	mov    0x4(%ebx),%eax
  80262e:	8b 0b                	mov    (%ebx),%ecx
  802630:	8d 51 20             	lea    0x20(%ecx),%edx
  802633:	39 d0                	cmp    %edx,%eax
  802635:	73 e2                	jae    802619 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802637:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80263a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80263e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802641:	99                   	cltd   
  802642:	c1 ea 1b             	shr    $0x1b,%edx
  802645:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802648:	83 e1 1f             	and    $0x1f,%ecx
  80264b:	29 d1                	sub    %edx,%ecx
  80264d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802651:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802655:	83 c0 01             	add    $0x1,%eax
  802658:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80265b:	83 c7 01             	add    $0x1,%edi
  80265e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802661:	75 c8                	jne    80262b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802663:	89 f8                	mov    %edi,%eax
  802665:	eb 05                	jmp    80266c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80266c:	83 c4 1c             	add    $0x1c,%esp
  80266f:	5b                   	pop    %ebx
  802670:	5e                   	pop    %esi
  802671:	5f                   	pop    %edi
  802672:	5d                   	pop    %ebp
  802673:	c3                   	ret    

00802674 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	57                   	push   %edi
  802678:	56                   	push   %esi
  802679:	53                   	push   %ebx
  80267a:	83 ec 1c             	sub    $0x1c,%esp
  80267d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802680:	89 3c 24             	mov    %edi,(%esp)
  802683:	e8 68 f0 ff ff       	call   8016f0 <fd2data>
  802688:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80268a:	be 00 00 00 00       	mov    $0x0,%esi
  80268f:	eb 3d                	jmp    8026ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802691:	85 f6                	test   %esi,%esi
  802693:	74 04                	je     802699 <devpipe_read+0x25>
				return i;
  802695:	89 f0                	mov    %esi,%eax
  802697:	eb 43                	jmp    8026dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802699:	89 da                	mov    %ebx,%edx
  80269b:	89 f8                	mov    %edi,%eax
  80269d:	e8 f1 fe ff ff       	call   802593 <_pipeisclosed>
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	75 31                	jne    8026d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026a6:	e8 5b e7 ff ff       	call   800e06 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026ab:	8b 03                	mov    (%ebx),%eax
  8026ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026b0:	74 df                	je     802691 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026b2:	99                   	cltd   
  8026b3:	c1 ea 1b             	shr    $0x1b,%edx
  8026b6:	01 d0                	add    %edx,%eax
  8026b8:	83 e0 1f             	and    $0x1f,%eax
  8026bb:	29 d0                	sub    %edx,%eax
  8026bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026cb:	83 c6 01             	add    $0x1,%esi
  8026ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026d1:	75 d8                	jne    8026ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8026d3:	89 f0                	mov    %esi,%eax
  8026d5:	eb 05                	jmp    8026dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8026dc:	83 c4 1c             	add    $0x1c,%esp
  8026df:	5b                   	pop    %ebx
  8026e0:	5e                   	pop    %esi
  8026e1:	5f                   	pop    %edi
  8026e2:	5d                   	pop    %ebp
  8026e3:	c3                   	ret    

008026e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	56                   	push   %esi
  8026e8:	53                   	push   %ebx
  8026e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ef:	89 04 24             	mov    %eax,(%esp)
  8026f2:	e8 10 f0 ff ff       	call   801707 <fd_alloc>
  8026f7:	89 c2                	mov    %eax,%edx
  8026f9:	85 d2                	test   %edx,%edx
  8026fb:	0f 88 4d 01 00 00    	js     80284e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802701:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802708:	00 
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802710:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802717:	e8 09 e7 ff ff       	call   800e25 <sys_page_alloc>
  80271c:	89 c2                	mov    %eax,%edx
  80271e:	85 d2                	test   %edx,%edx
  802720:	0f 88 28 01 00 00    	js     80284e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802726:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802729:	89 04 24             	mov    %eax,(%esp)
  80272c:	e8 d6 ef ff ff       	call   801707 <fd_alloc>
  802731:	89 c3                	mov    %eax,%ebx
  802733:	85 c0                	test   %eax,%eax
  802735:	0f 88 fe 00 00 00    	js     802839 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80273b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802742:	00 
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802751:	e8 cf e6 ff ff       	call   800e25 <sys_page_alloc>
  802756:	89 c3                	mov    %eax,%ebx
  802758:	85 c0                	test   %eax,%eax
  80275a:	0f 88 d9 00 00 00    	js     802839 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	89 04 24             	mov    %eax,(%esp)
  802766:	e8 85 ef ff ff       	call   8016f0 <fd2data>
  80276b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80276d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802774:	00 
  802775:	89 44 24 04          	mov    %eax,0x4(%esp)
  802779:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802780:	e8 a0 e6 ff ff       	call   800e25 <sys_page_alloc>
  802785:	89 c3                	mov    %eax,%ebx
  802787:	85 c0                	test   %eax,%eax
  802789:	0f 88 97 00 00 00    	js     802826 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	89 04 24             	mov    %eax,(%esp)
  802795:	e8 56 ef ff ff       	call   8016f0 <fd2data>
  80279a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8027a1:	00 
  8027a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027ad:	00 
  8027ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b9:	e8 bb e6 ff ff       	call   800e79 <sys_page_map>
  8027be:	89 c3                	mov    %eax,%ebx
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	78 52                	js     802816 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8027c4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8027d9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	89 04 24             	mov    %eax,(%esp)
  8027f4:	e8 e7 ee ff ff       	call   8016e0 <fd2num>
  8027f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027fc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802801:	89 04 24             	mov    %eax,(%esp)
  802804:	e8 d7 ee ff ff       	call   8016e0 <fd2num>
  802809:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80280c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80280f:	b8 00 00 00 00       	mov    $0x0,%eax
  802814:	eb 38                	jmp    80284e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802816:	89 74 24 04          	mov    %esi,0x4(%esp)
  80281a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802821:	e8 a6 e6 ff ff       	call   800ecc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80282d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802834:	e8 93 e6 ff ff       	call   800ecc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802840:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802847:	e8 80 e6 ff ff       	call   800ecc <sys_page_unmap>
  80284c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80284e:	83 c4 30             	add    $0x30,%esp
  802851:	5b                   	pop    %ebx
  802852:	5e                   	pop    %esi
  802853:	5d                   	pop    %ebp
  802854:	c3                   	ret    

00802855 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
  802858:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80285b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80285e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	89 04 24             	mov    %eax,(%esp)
  802868:	e8 e9 ee ff ff       	call   801756 <fd_lookup>
  80286d:	89 c2                	mov    %eax,%edx
  80286f:	85 d2                	test   %edx,%edx
  802871:	78 15                	js     802888 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	89 04 24             	mov    %eax,(%esp)
  802879:	e8 72 ee ff ff       	call   8016f0 <fd2data>
	return _pipeisclosed(fd, p);
  80287e:	89 c2                	mov    %eax,%edx
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	e8 0b fd ff ff       	call   802593 <_pipeisclosed>
}
  802888:	c9                   	leave  
  802889:	c3                   	ret    
  80288a:	66 90                	xchg   %ax,%ax
  80288c:	66 90                	xchg   %ax,%ax
  80288e:	66 90                	xchg   %ax,%ax

00802890 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802893:	b8 00 00 00 00       	mov    $0x0,%eax
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    

0080289a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8028a0:	c7 44 24 04 25 35 80 	movl   $0x803525,0x4(%esp)
  8028a7:	00 
  8028a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ab:	89 04 24             	mov    %eax,(%esp)
  8028ae:	e8 04 e1 ff ff       	call   8009b7 <strcpy>
	return 0;
}
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	c9                   	leave  
  8028b9:	c3                   	ret    

008028ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8028ba:	55                   	push   %ebp
  8028bb:	89 e5                	mov    %esp,%ebp
  8028bd:	57                   	push   %edi
  8028be:	56                   	push   %esi
  8028bf:	53                   	push   %ebx
  8028c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028d1:	eb 31                	jmp    802904 <devcons_write+0x4a>
		m = n - tot;
  8028d3:	8b 75 10             	mov    0x10(%ebp),%esi
  8028d6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8028d8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8028db:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8028e0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028e7:	03 45 0c             	add    0xc(%ebp),%eax
  8028ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ee:	89 3c 24             	mov    %edi,(%esp)
  8028f1:	e8 5e e2 ff ff       	call   800b54 <memmove>
		sys_cputs(buf, m);
  8028f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028fa:	89 3c 24             	mov    %edi,(%esp)
  8028fd:	e8 04 e4 ff ff       	call   800d06 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802902:	01 f3                	add    %esi,%ebx
  802904:	89 d8                	mov    %ebx,%eax
  802906:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802909:	72 c8                	jb     8028d3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80290b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802911:	5b                   	pop    %ebx
  802912:	5e                   	pop    %esi
  802913:	5f                   	pop    %edi
  802914:	5d                   	pop    %ebp
  802915:	c3                   	ret    

00802916 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80291c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802921:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802925:	75 07                	jne    80292e <devcons_read+0x18>
  802927:	eb 2a                	jmp    802953 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802929:	e8 d8 e4 ff ff       	call   800e06 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80292e:	66 90                	xchg   %ax,%ax
  802930:	e8 ef e3 ff ff       	call   800d24 <sys_cgetc>
  802935:	85 c0                	test   %eax,%eax
  802937:	74 f0                	je     802929 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802939:	85 c0                	test   %eax,%eax
  80293b:	78 16                	js     802953 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80293d:	83 f8 04             	cmp    $0x4,%eax
  802940:	74 0c                	je     80294e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802942:	8b 55 0c             	mov    0xc(%ebp),%edx
  802945:	88 02                	mov    %al,(%edx)
	return 1;
  802947:	b8 01 00 00 00       	mov    $0x1,%eax
  80294c:	eb 05                	jmp    802953 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80294e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802961:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802968:	00 
  802969:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80296c:	89 04 24             	mov    %eax,(%esp)
  80296f:	e8 92 e3 ff ff       	call   800d06 <sys_cputs>
}
  802974:	c9                   	leave  
  802975:	c3                   	ret    

00802976 <getchar>:

int
getchar(void)
{
  802976:	55                   	push   %ebp
  802977:	89 e5                	mov    %esp,%ebp
  802979:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80297c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802983:	00 
  802984:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802992:	e8 53 f0 ff ff       	call   8019ea <read>
	if (r < 0)
  802997:	85 c0                	test   %eax,%eax
  802999:	78 0f                	js     8029aa <getchar+0x34>
		return r;
	if (r < 1)
  80299b:	85 c0                	test   %eax,%eax
  80299d:	7e 06                	jle    8029a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80299f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8029a3:	eb 05                	jmp    8029aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8029a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	89 04 24             	mov    %eax,(%esp)
  8029bf:	e8 92 ed ff ff       	call   801756 <fd_lookup>
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	78 11                	js     8029d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029d1:	39 10                	cmp    %edx,(%eax)
  8029d3:	0f 94 c0             	sete   %al
  8029d6:	0f b6 c0             	movzbl %al,%eax
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <opencons>:

int
opencons(void)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
  8029de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029e4:	89 04 24             	mov    %eax,(%esp)
  8029e7:	e8 1b ed ff ff       	call   801707 <fd_alloc>
		return r;
  8029ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	78 40                	js     802a32 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029f9:	00 
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a08:	e8 18 e4 ff ff       	call   800e25 <sys_page_alloc>
		return r;
  802a0d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	78 1f                	js     802a32 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a13:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a28:	89 04 24             	mov    %eax,(%esp)
  802a2b:	e8 b0 ec ff ff       	call   8016e0 <fd2num>
  802a30:	89 c2                	mov    %eax,%edx
}
  802a32:	89 d0                	mov    %edx,%eax
  802a34:	c9                   	leave  
  802a35:	c3                   	ret    

00802a36 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a36:	55                   	push   %ebp
  802a37:	89 e5                	mov    %esp,%ebp
  802a39:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a3c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a43:	75 7a                	jne    802abf <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802a45:	e8 9d e3 ff ff       	call   800de7 <sys_getenvid>
  802a4a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a51:	00 
  802a52:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802a59:	ee 
  802a5a:	89 04 24             	mov    %eax,(%esp)
  802a5d:	e8 c3 e3 ff ff       	call   800e25 <sys_page_alloc>
  802a62:	85 c0                	test   %eax,%eax
  802a64:	79 20                	jns    802a86 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802a66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a6a:	c7 44 24 08 49 33 80 	movl   $0x803349,0x8(%esp)
  802a71:	00 
  802a72:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802a79:	00 
  802a7a:	c7 04 24 31 35 80 00 	movl   $0x803531,(%esp)
  802a81:	e8 c5 d7 ff ff       	call   80024b <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802a86:	e8 5c e3 ff ff       	call   800de7 <sys_getenvid>
  802a8b:	c7 44 24 04 c9 2a 80 	movl   $0x802ac9,0x4(%esp)
  802a92:	00 
  802a93:	89 04 24             	mov    %eax,(%esp)
  802a96:	e8 4a e5 ff ff       	call   800fe5 <sys_env_set_pgfault_upcall>
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	79 20                	jns    802abf <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802a9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802aa3:	c7 44 24 08 c8 33 80 	movl   $0x8033c8,0x8(%esp)
  802aaa:	00 
  802aab:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802ab2:	00 
  802ab3:	c7 04 24 31 35 80 00 	movl   $0x803531,(%esp)
  802aba:	e8 8c d7 ff ff       	call   80024b <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802ac7:	c9                   	leave  
  802ac8:	c3                   	ret    

00802ac9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ac9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802aca:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802acf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802ad1:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802ad4:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802ad8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802adc:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802adf:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802ae3:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802ae5:	83 c4 08             	add    $0x8,%esp
	popal
  802ae8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802ae9:	83 c4 04             	add    $0x4,%esp
	popfl
  802aec:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802aed:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802aee:	c3                   	ret    
  802aef:	90                   	nop

00802af0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
  802af3:	56                   	push   %esi
  802af4:	53                   	push   %ebx
  802af5:	83 ec 10             	sub    $0x10,%esp
  802af8:	8b 75 08             	mov    0x8(%ebp),%esi
  802afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802afe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802b01:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802b03:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802b08:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802b0b:	89 04 24             	mov    %eax,(%esp)
  802b0e:	e8 48 e5 ff ff       	call   80105b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802b13:	85 c0                	test   %eax,%eax
  802b15:	75 26                	jne    802b3d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802b17:	85 f6                	test   %esi,%esi
  802b19:	74 0a                	je     802b25 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802b1b:	a1 08 50 80 00       	mov    0x805008,%eax
  802b20:	8b 40 74             	mov    0x74(%eax),%eax
  802b23:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802b25:	85 db                	test   %ebx,%ebx
  802b27:	74 0a                	je     802b33 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802b29:	a1 08 50 80 00       	mov    0x805008,%eax
  802b2e:	8b 40 78             	mov    0x78(%eax),%eax
  802b31:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802b33:	a1 08 50 80 00       	mov    0x805008,%eax
  802b38:	8b 40 70             	mov    0x70(%eax),%eax
  802b3b:	eb 14                	jmp    802b51 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802b3d:	85 f6                	test   %esi,%esi
  802b3f:	74 06                	je     802b47 <ipc_recv+0x57>
			*from_env_store = 0;
  802b41:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802b47:	85 db                	test   %ebx,%ebx
  802b49:	74 06                	je     802b51 <ipc_recv+0x61>
			*perm_store = 0;
  802b4b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802b51:	83 c4 10             	add    $0x10,%esp
  802b54:	5b                   	pop    %ebx
  802b55:	5e                   	pop    %esi
  802b56:	5d                   	pop    %ebp
  802b57:	c3                   	ret    

00802b58 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b58:	55                   	push   %ebp
  802b59:	89 e5                	mov    %esp,%ebp
  802b5b:	57                   	push   %edi
  802b5c:	56                   	push   %esi
  802b5d:	53                   	push   %ebx
  802b5e:	83 ec 1c             	sub    $0x1c,%esp
  802b61:	8b 7d 08             	mov    0x8(%ebp),%edi
  802b64:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b67:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802b6a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802b6c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802b71:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802b74:	8b 45 14             	mov    0x14(%ebp),%eax
  802b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b7f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b83:	89 3c 24             	mov    %edi,(%esp)
  802b86:	e8 ad e4 ff ff       	call   801038 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802b8b:	85 c0                	test   %eax,%eax
  802b8d:	74 28                	je     802bb7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802b8f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b92:	74 1c                	je     802bb0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802b94:	c7 44 24 08 40 35 80 	movl   $0x803540,0x8(%esp)
  802b9b:	00 
  802b9c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802ba3:	00 
  802ba4:	c7 04 24 64 35 80 00 	movl   $0x803564,(%esp)
  802bab:	e8 9b d6 ff ff       	call   80024b <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802bb0:	e8 51 e2 ff ff       	call   800e06 <sys_yield>
	}
  802bb5:	eb bd                	jmp    802b74 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802bb7:	83 c4 1c             	add    $0x1c,%esp
  802bba:	5b                   	pop    %ebx
  802bbb:	5e                   	pop    %esi
  802bbc:	5f                   	pop    %edi
  802bbd:	5d                   	pop    %ebp
  802bbe:	c3                   	ret    

00802bbf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802bbf:	55                   	push   %ebp
  802bc0:	89 e5                	mov    %esp,%ebp
  802bc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802bc5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802bca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802bcd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802bd3:	8b 52 50             	mov    0x50(%edx),%edx
  802bd6:	39 ca                	cmp    %ecx,%edx
  802bd8:	75 0d                	jne    802be7 <ipc_find_env+0x28>
			return envs[i].env_id;
  802bda:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802bdd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802be2:	8b 40 40             	mov    0x40(%eax),%eax
  802be5:	eb 0e                	jmp    802bf5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802be7:	83 c0 01             	add    $0x1,%eax
  802bea:	3d 00 04 00 00       	cmp    $0x400,%eax
  802bef:	75 d9                	jne    802bca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802bf1:	66 b8 00 00          	mov    $0x0,%ax
}
  802bf5:	5d                   	pop    %ebp
  802bf6:	c3                   	ret    

00802bf7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
  802bfa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bfd:	89 d0                	mov    %edx,%eax
  802bff:	c1 e8 16             	shr    $0x16,%eax
  802c02:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802c09:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c0e:	f6 c1 01             	test   $0x1,%cl
  802c11:	74 1d                	je     802c30 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802c13:	c1 ea 0c             	shr    $0xc,%edx
  802c16:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802c1d:	f6 c2 01             	test   $0x1,%dl
  802c20:	74 0e                	je     802c30 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c22:	c1 ea 0c             	shr    $0xc,%edx
  802c25:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802c2c:	ef 
  802c2d:	0f b7 c0             	movzwl %ax,%eax
}
  802c30:	5d                   	pop    %ebp
  802c31:	c3                   	ret    
  802c32:	66 90                	xchg   %ax,%ax
  802c34:	66 90                	xchg   %ax,%ax
  802c36:	66 90                	xchg   %ax,%ax
  802c38:	66 90                	xchg   %ax,%ax
  802c3a:	66 90                	xchg   %ax,%ax
  802c3c:	66 90                	xchg   %ax,%ax
  802c3e:	66 90                	xchg   %ax,%ax

00802c40 <__udivdi3>:
  802c40:	55                   	push   %ebp
  802c41:	57                   	push   %edi
  802c42:	56                   	push   %esi
  802c43:	83 ec 0c             	sub    $0xc,%esp
  802c46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802c4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802c52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c56:	85 c0                	test   %eax,%eax
  802c58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802c5c:	89 ea                	mov    %ebp,%edx
  802c5e:	89 0c 24             	mov    %ecx,(%esp)
  802c61:	75 2d                	jne    802c90 <__udivdi3+0x50>
  802c63:	39 e9                	cmp    %ebp,%ecx
  802c65:	77 61                	ja     802cc8 <__udivdi3+0x88>
  802c67:	85 c9                	test   %ecx,%ecx
  802c69:	89 ce                	mov    %ecx,%esi
  802c6b:	75 0b                	jne    802c78 <__udivdi3+0x38>
  802c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  802c72:	31 d2                	xor    %edx,%edx
  802c74:	f7 f1                	div    %ecx
  802c76:	89 c6                	mov    %eax,%esi
  802c78:	31 d2                	xor    %edx,%edx
  802c7a:	89 e8                	mov    %ebp,%eax
  802c7c:	f7 f6                	div    %esi
  802c7e:	89 c5                	mov    %eax,%ebp
  802c80:	89 f8                	mov    %edi,%eax
  802c82:	f7 f6                	div    %esi
  802c84:	89 ea                	mov    %ebp,%edx
  802c86:	83 c4 0c             	add    $0xc,%esp
  802c89:	5e                   	pop    %esi
  802c8a:	5f                   	pop    %edi
  802c8b:	5d                   	pop    %ebp
  802c8c:	c3                   	ret    
  802c8d:	8d 76 00             	lea    0x0(%esi),%esi
  802c90:	39 e8                	cmp    %ebp,%eax
  802c92:	77 24                	ja     802cb8 <__udivdi3+0x78>
  802c94:	0f bd e8             	bsr    %eax,%ebp
  802c97:	83 f5 1f             	xor    $0x1f,%ebp
  802c9a:	75 3c                	jne    802cd8 <__udivdi3+0x98>
  802c9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802ca0:	39 34 24             	cmp    %esi,(%esp)
  802ca3:	0f 86 9f 00 00 00    	jbe    802d48 <__udivdi3+0x108>
  802ca9:	39 d0                	cmp    %edx,%eax
  802cab:	0f 82 97 00 00 00    	jb     802d48 <__udivdi3+0x108>
  802cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cb8:	31 d2                	xor    %edx,%edx
  802cba:	31 c0                	xor    %eax,%eax
  802cbc:	83 c4 0c             	add    $0xc,%esp
  802cbf:	5e                   	pop    %esi
  802cc0:	5f                   	pop    %edi
  802cc1:	5d                   	pop    %ebp
  802cc2:	c3                   	ret    
  802cc3:	90                   	nop
  802cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cc8:	89 f8                	mov    %edi,%eax
  802cca:	f7 f1                	div    %ecx
  802ccc:	31 d2                	xor    %edx,%edx
  802cce:	83 c4 0c             	add    $0xc,%esp
  802cd1:	5e                   	pop    %esi
  802cd2:	5f                   	pop    %edi
  802cd3:	5d                   	pop    %ebp
  802cd4:	c3                   	ret    
  802cd5:	8d 76 00             	lea    0x0(%esi),%esi
  802cd8:	89 e9                	mov    %ebp,%ecx
  802cda:	8b 3c 24             	mov    (%esp),%edi
  802cdd:	d3 e0                	shl    %cl,%eax
  802cdf:	89 c6                	mov    %eax,%esi
  802ce1:	b8 20 00 00 00       	mov    $0x20,%eax
  802ce6:	29 e8                	sub    %ebp,%eax
  802ce8:	89 c1                	mov    %eax,%ecx
  802cea:	d3 ef                	shr    %cl,%edi
  802cec:	89 e9                	mov    %ebp,%ecx
  802cee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802cf2:	8b 3c 24             	mov    (%esp),%edi
  802cf5:	09 74 24 08          	or     %esi,0x8(%esp)
  802cf9:	89 d6                	mov    %edx,%esi
  802cfb:	d3 e7                	shl    %cl,%edi
  802cfd:	89 c1                	mov    %eax,%ecx
  802cff:	89 3c 24             	mov    %edi,(%esp)
  802d02:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d06:	d3 ee                	shr    %cl,%esi
  802d08:	89 e9                	mov    %ebp,%ecx
  802d0a:	d3 e2                	shl    %cl,%edx
  802d0c:	89 c1                	mov    %eax,%ecx
  802d0e:	d3 ef                	shr    %cl,%edi
  802d10:	09 d7                	or     %edx,%edi
  802d12:	89 f2                	mov    %esi,%edx
  802d14:	89 f8                	mov    %edi,%eax
  802d16:	f7 74 24 08          	divl   0x8(%esp)
  802d1a:	89 d6                	mov    %edx,%esi
  802d1c:	89 c7                	mov    %eax,%edi
  802d1e:	f7 24 24             	mull   (%esp)
  802d21:	39 d6                	cmp    %edx,%esi
  802d23:	89 14 24             	mov    %edx,(%esp)
  802d26:	72 30                	jb     802d58 <__udivdi3+0x118>
  802d28:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d2c:	89 e9                	mov    %ebp,%ecx
  802d2e:	d3 e2                	shl    %cl,%edx
  802d30:	39 c2                	cmp    %eax,%edx
  802d32:	73 05                	jae    802d39 <__udivdi3+0xf9>
  802d34:	3b 34 24             	cmp    (%esp),%esi
  802d37:	74 1f                	je     802d58 <__udivdi3+0x118>
  802d39:	89 f8                	mov    %edi,%eax
  802d3b:	31 d2                	xor    %edx,%edx
  802d3d:	e9 7a ff ff ff       	jmp    802cbc <__udivdi3+0x7c>
  802d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d48:	31 d2                	xor    %edx,%edx
  802d4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802d4f:	e9 68 ff ff ff       	jmp    802cbc <__udivdi3+0x7c>
  802d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d58:	8d 47 ff             	lea    -0x1(%edi),%eax
  802d5b:	31 d2                	xor    %edx,%edx
  802d5d:	83 c4 0c             	add    $0xc,%esp
  802d60:	5e                   	pop    %esi
  802d61:	5f                   	pop    %edi
  802d62:	5d                   	pop    %ebp
  802d63:	c3                   	ret    
  802d64:	66 90                	xchg   %ax,%ax
  802d66:	66 90                	xchg   %ax,%ax
  802d68:	66 90                	xchg   %ax,%ax
  802d6a:	66 90                	xchg   %ax,%ax
  802d6c:	66 90                	xchg   %ax,%ax
  802d6e:	66 90                	xchg   %ax,%ax

00802d70 <__umoddi3>:
  802d70:	55                   	push   %ebp
  802d71:	57                   	push   %edi
  802d72:	56                   	push   %esi
  802d73:	83 ec 14             	sub    $0x14,%esp
  802d76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802d7a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802d7e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802d82:	89 c7                	mov    %eax,%edi
  802d84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d88:	8b 44 24 30          	mov    0x30(%esp),%eax
  802d8c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d90:	89 34 24             	mov    %esi,(%esp)
  802d93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d97:	85 c0                	test   %eax,%eax
  802d99:	89 c2                	mov    %eax,%edx
  802d9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d9f:	75 17                	jne    802db8 <__umoddi3+0x48>
  802da1:	39 fe                	cmp    %edi,%esi
  802da3:	76 4b                	jbe    802df0 <__umoddi3+0x80>
  802da5:	89 c8                	mov    %ecx,%eax
  802da7:	89 fa                	mov    %edi,%edx
  802da9:	f7 f6                	div    %esi
  802dab:	89 d0                	mov    %edx,%eax
  802dad:	31 d2                	xor    %edx,%edx
  802daf:	83 c4 14             	add    $0x14,%esp
  802db2:	5e                   	pop    %esi
  802db3:	5f                   	pop    %edi
  802db4:	5d                   	pop    %ebp
  802db5:	c3                   	ret    
  802db6:	66 90                	xchg   %ax,%ax
  802db8:	39 f8                	cmp    %edi,%eax
  802dba:	77 54                	ja     802e10 <__umoddi3+0xa0>
  802dbc:	0f bd e8             	bsr    %eax,%ebp
  802dbf:	83 f5 1f             	xor    $0x1f,%ebp
  802dc2:	75 5c                	jne    802e20 <__umoddi3+0xb0>
  802dc4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802dc8:	39 3c 24             	cmp    %edi,(%esp)
  802dcb:	0f 87 e7 00 00 00    	ja     802eb8 <__umoddi3+0x148>
  802dd1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802dd5:	29 f1                	sub    %esi,%ecx
  802dd7:	19 c7                	sbb    %eax,%edi
  802dd9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ddd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802de1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802de5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802de9:	83 c4 14             	add    $0x14,%esp
  802dec:	5e                   	pop    %esi
  802ded:	5f                   	pop    %edi
  802dee:	5d                   	pop    %ebp
  802def:	c3                   	ret    
  802df0:	85 f6                	test   %esi,%esi
  802df2:	89 f5                	mov    %esi,%ebp
  802df4:	75 0b                	jne    802e01 <__umoddi3+0x91>
  802df6:	b8 01 00 00 00       	mov    $0x1,%eax
  802dfb:	31 d2                	xor    %edx,%edx
  802dfd:	f7 f6                	div    %esi
  802dff:	89 c5                	mov    %eax,%ebp
  802e01:	8b 44 24 04          	mov    0x4(%esp),%eax
  802e05:	31 d2                	xor    %edx,%edx
  802e07:	f7 f5                	div    %ebp
  802e09:	89 c8                	mov    %ecx,%eax
  802e0b:	f7 f5                	div    %ebp
  802e0d:	eb 9c                	jmp    802dab <__umoddi3+0x3b>
  802e0f:	90                   	nop
  802e10:	89 c8                	mov    %ecx,%eax
  802e12:	89 fa                	mov    %edi,%edx
  802e14:	83 c4 14             	add    $0x14,%esp
  802e17:	5e                   	pop    %esi
  802e18:	5f                   	pop    %edi
  802e19:	5d                   	pop    %ebp
  802e1a:	c3                   	ret    
  802e1b:	90                   	nop
  802e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e20:	8b 04 24             	mov    (%esp),%eax
  802e23:	be 20 00 00 00       	mov    $0x20,%esi
  802e28:	89 e9                	mov    %ebp,%ecx
  802e2a:	29 ee                	sub    %ebp,%esi
  802e2c:	d3 e2                	shl    %cl,%edx
  802e2e:	89 f1                	mov    %esi,%ecx
  802e30:	d3 e8                	shr    %cl,%eax
  802e32:	89 e9                	mov    %ebp,%ecx
  802e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e38:	8b 04 24             	mov    (%esp),%eax
  802e3b:	09 54 24 04          	or     %edx,0x4(%esp)
  802e3f:	89 fa                	mov    %edi,%edx
  802e41:	d3 e0                	shl    %cl,%eax
  802e43:	89 f1                	mov    %esi,%ecx
  802e45:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e49:	8b 44 24 10          	mov    0x10(%esp),%eax
  802e4d:	d3 ea                	shr    %cl,%edx
  802e4f:	89 e9                	mov    %ebp,%ecx
  802e51:	d3 e7                	shl    %cl,%edi
  802e53:	89 f1                	mov    %esi,%ecx
  802e55:	d3 e8                	shr    %cl,%eax
  802e57:	89 e9                	mov    %ebp,%ecx
  802e59:	09 f8                	or     %edi,%eax
  802e5b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802e5f:	f7 74 24 04          	divl   0x4(%esp)
  802e63:	d3 e7                	shl    %cl,%edi
  802e65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e69:	89 d7                	mov    %edx,%edi
  802e6b:	f7 64 24 08          	mull   0x8(%esp)
  802e6f:	39 d7                	cmp    %edx,%edi
  802e71:	89 c1                	mov    %eax,%ecx
  802e73:	89 14 24             	mov    %edx,(%esp)
  802e76:	72 2c                	jb     802ea4 <__umoddi3+0x134>
  802e78:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802e7c:	72 22                	jb     802ea0 <__umoddi3+0x130>
  802e7e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802e82:	29 c8                	sub    %ecx,%eax
  802e84:	19 d7                	sbb    %edx,%edi
  802e86:	89 e9                	mov    %ebp,%ecx
  802e88:	89 fa                	mov    %edi,%edx
  802e8a:	d3 e8                	shr    %cl,%eax
  802e8c:	89 f1                	mov    %esi,%ecx
  802e8e:	d3 e2                	shl    %cl,%edx
  802e90:	89 e9                	mov    %ebp,%ecx
  802e92:	d3 ef                	shr    %cl,%edi
  802e94:	09 d0                	or     %edx,%eax
  802e96:	89 fa                	mov    %edi,%edx
  802e98:	83 c4 14             	add    $0x14,%esp
  802e9b:	5e                   	pop    %esi
  802e9c:	5f                   	pop    %edi
  802e9d:	5d                   	pop    %ebp
  802e9e:	c3                   	ret    
  802e9f:	90                   	nop
  802ea0:	39 d7                	cmp    %edx,%edi
  802ea2:	75 da                	jne    802e7e <__umoddi3+0x10e>
  802ea4:	8b 14 24             	mov    (%esp),%edx
  802ea7:	89 c1                	mov    %eax,%ecx
  802ea9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802ead:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802eb1:	eb cb                	jmp    802e7e <__umoddi3+0x10e>
  802eb3:	90                   	nop
  802eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802eb8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802ebc:	0f 82 0f ff ff ff    	jb     802dd1 <__umoddi3+0x61>
  802ec2:	e9 1a ff ff ff       	jmp    802de1 <__umoddi3+0x71>
