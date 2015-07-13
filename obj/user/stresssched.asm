
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
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

volatile int counter;

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800048:	e8 ca 0c 00 00       	call   800d17 <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80004f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800054:	e8 16 12 00 00       	call   80126f <fork>
  800059:	85 c0                	test   %eax,%eax
  80005b:	74 0a                	je     800067 <umain+0x27>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80005d:	83 c3 01             	add    $0x1,%ebx
  800060:	83 fb 14             	cmp    $0x14,%ebx
  800063:	75 ef                	jne    800054 <umain+0x14>
  800065:	eb 16                	jmp    80007d <umain+0x3d>
		if (fork() == 0)
			break;
	if (i == 20) {
  800067:	83 fb 14             	cmp    $0x14,%ebx
  80006a:	74 11                	je     80007d <umain+0x3d>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800072:	6b d6 7c             	imul   $0x7c,%esi,%edx
  800075:	81 c2 04 00 c0 ee    	add    $0xeec00004,%edx
  80007b:	eb 0c                	jmp    800089 <umain+0x49>
	// Fork several environments
	for (i = 0; i < 20; i++)
		if (fork() == 0)
			break;
	if (i == 20) {
		sys_yield();
  80007d:	e8 b4 0c 00 00       	call   800d36 <sys_yield>
		return;
  800082:	e9 83 00 00 00       	jmp    80010a <umain+0xca>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");
  800087:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800089:	8b 42 50             	mov    0x50(%edx),%eax
  80008c:	85 c0                	test   %eax,%eax
  80008e:	66 90                	xchg   %ax,%ax
  800090:	75 f5                	jne    800087 <umain+0x47>
  800092:	bb 0a 00 00 00       	mov    $0xa,%ebx
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800097:	e8 9a 0c 00 00       	call   800d36 <sys_yield>
  80009c:	b8 10 27 00 00       	mov    $0x2710,%eax
		for (j = 0; j < 10000; j++)
			counter++;
  8000a1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8000a7:	83 c2 01             	add    $0x1,%edx
  8000aa:	89 15 08 50 80 00    	mov    %edx,0x805008
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  8000b0:	83 e8 01             	sub    $0x1,%eax
  8000b3:	75 ec                	jne    8000a1 <umain+0x61>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000b5:	83 eb 01             	sub    $0x1,%ebx
  8000b8:	75 dd                	jne    800097 <umain+0x57>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  8000ba:	a1 08 50 80 00       	mov    0x805008,%eax
  8000bf:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000c4:	74 25                	je     8000eb <umain+0xab>
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8000cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000cf:	c7 44 24 08 00 2e 80 	movl   $0x802e00,0x8(%esp)
  8000d6:	00 
  8000d7:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8000de:	00 
  8000df:	c7 04 24 28 2e 80 00 	movl   $0x802e28,(%esp)
  8000e6:	e8 87 00 00 00       	call   800172 <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000eb:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8000f0:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000f3:	8b 40 48             	mov    0x48(%eax),%eax
  8000f6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fe:	c7 04 24 3b 2e 80 00 	movl   $0x802e3b,(%esp)
  800105:	e8 61 01 00 00       	call   80026b <cprintf>

}
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	5b                   	pop    %ebx
  80010e:	5e                   	pop    %esi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	83 ec 10             	sub    $0x10,%esp
  800119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80011c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80011f:	e8 f3 0b 00 00       	call   800d17 <sys_getenvid>
  800124:	25 ff 03 00 00       	and    $0x3ff,%eax
  800129:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80012c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800131:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800136:	85 db                	test   %ebx,%ebx
  800138:	7e 07                	jle    800141 <libmain+0x30>
		binaryname = argv[0];
  80013a:	8b 06                	mov    (%esi),%eax
  80013c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800141:	89 74 24 04          	mov    %esi,0x4(%esp)
  800145:	89 1c 24             	mov    %ebx,(%esp)
  800148:	e8 f3 fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  80014d:	e8 07 00 00 00       	call   800159 <exit>
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    

00800159 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80015f:	e8 86 16 00 00       	call   8017ea <close_all>
	sys_env_destroy(0);
  800164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80016b:	e8 03 0b 00 00       	call   800c73 <sys_env_destroy>
}
  800170:	c9                   	leave  
  800171:	c3                   	ret    

00800172 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	56                   	push   %esi
  800176:	53                   	push   %ebx
  800177:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80017a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80017d:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800183:	e8 8f 0b 00 00       	call   800d17 <sys_getenvid>
  800188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018b:	89 54 24 10          	mov    %edx,0x10(%esp)
  80018f:	8b 55 08             	mov    0x8(%ebp),%edx
  800192:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800196:	89 74 24 08          	mov    %esi,0x8(%esp)
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	c7 04 24 64 2e 80 00 	movl   $0x802e64,(%esp)
  8001a5:	e8 c1 00 00 00       	call   80026b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b1:	89 04 24             	mov    %eax,(%esp)
  8001b4:	e8 51 00 00 00       	call   80020a <vcprintf>
	cprintf("\n");
  8001b9:	c7 04 24 6b 33 80 00 	movl   $0x80336b,(%esp)
  8001c0:	e8 a6 00 00 00       	call   80026b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c5:	cc                   	int3   
  8001c6:	eb fd                	jmp    8001c5 <_panic+0x53>

008001c8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	53                   	push   %ebx
  8001cc:	83 ec 14             	sub    $0x14,%esp
  8001cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d2:	8b 13                	mov    (%ebx),%edx
  8001d4:	8d 42 01             	lea    0x1(%edx),%eax
  8001d7:	89 03                	mov    %eax,(%ebx)
  8001d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001dc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e5:	75 19                	jne    800200 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001e7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001ee:	00 
  8001ef:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f2:	89 04 24             	mov    %eax,(%esp)
  8001f5:	e8 3c 0a 00 00       	call   800c36 <sys_cputs>
		b->idx = 0;
  8001fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800200:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800204:	83 c4 14             	add    $0x14,%esp
  800207:	5b                   	pop    %ebx
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    

0080020a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800213:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021a:	00 00 00 
	b.cnt = 0;
  80021d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800224:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 44 24 08          	mov    %eax,0x8(%esp)
  800235:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023f:	c7 04 24 c8 01 80 00 	movl   $0x8001c8,(%esp)
  800246:	e8 79 01 00 00       	call   8003c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800251:	89 44 24 04          	mov    %eax,0x4(%esp)
  800255:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 d3 09 00 00       	call   800c36 <sys_cputs>

	return b.cnt;
}
  800263:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800271:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800274:	89 44 24 04          	mov    %eax,0x4(%esp)
  800278:	8b 45 08             	mov    0x8(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	e8 87 ff ff ff       	call   80020a <vcprintf>
	va_end(ap);

	return cnt;
}
  800283:	c9                   	leave  
  800284:	c3                   	ret    
  800285:	66 90                	xchg   %ax,%ax
  800287:	66 90                	xchg   %ax,%ax
  800289:	66 90                	xchg   %ax,%ax
  80028b:	66 90                	xchg   %ax,%ax
  80028d:	66 90                	xchg   %ax,%ax
  80028f:	90                   	nop

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 3c             	sub    $0x3c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d7                	mov    %edx,%edi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	89 c3                	mov    %eax,%ebx
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8002af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bd:	39 d9                	cmp    %ebx,%ecx
  8002bf:	72 05                	jb     8002c6 <printnum+0x36>
  8002c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c4:	77 69                	ja     80032f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002cd:	83 ee 01             	sub    $0x1,%esi
  8002d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002e0:	89 c3                	mov    %eax,%ebx
  8002e2:	89 d6                	mov    %edx,%esi
  8002e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ff:	e8 6c 28 00 00       	call   802b70 <__udivdi3>
  800304:	89 d9                	mov    %ebx,%ecx
  800306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	89 54 24 04          	mov    %edx,0x4(%esp)
  800315:	89 fa                	mov    %edi,%edx
  800317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031a:	e8 71 ff ff ff       	call   800290 <printnum>
  80031f:	eb 1b                	jmp    80033c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800321:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800325:	8b 45 18             	mov    0x18(%ebp),%eax
  800328:	89 04 24             	mov    %eax,(%esp)
  80032b:	ff d3                	call   *%ebx
  80032d:	eb 03                	jmp    800332 <printnum+0xa2>
  80032f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800332:	83 ee 01             	sub    $0x1,%esi
  800335:	85 f6                	test   %esi,%esi
  800337:	7f e8                	jg     800321 <printnum+0x91>
  800339:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800340:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800344:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800347:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80034a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	89 04 24             	mov    %eax,(%esp)
  800358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035f:	e8 3c 29 00 00       	call   802ca0 <__umoddi3>
  800364:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800368:	0f be 80 87 2e 80 00 	movsbl 0x802e87(%eax),%eax
  80036f:	89 04 24             	mov    %eax,(%esp)
  800372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800375:	ff d0                	call   *%eax
}
  800377:	83 c4 3c             	add    $0x3c,%esp
  80037a:	5b                   	pop    %ebx
  80037b:	5e                   	pop    %esi
  80037c:	5f                   	pop    %edi
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800385:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	3b 50 04             	cmp    0x4(%eax),%edx
  80038e:	73 0a                	jae    80039a <sprintputch+0x1b>
		*b->buf++ = ch;
  800390:	8d 4a 01             	lea    0x1(%edx),%ecx
  800393:	89 08                	mov    %ecx,(%eax)
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	88 02                	mov    %al,(%edx)
}
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	e8 02 00 00 00       	call   8003c4 <vprintfmt>
	va_end(ap);
}
  8003c2:	c9                   	leave  
  8003c3:	c3                   	ret    

008003c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	57                   	push   %edi
  8003c8:	56                   	push   %esi
  8003c9:	53                   	push   %ebx
  8003ca:	83 ec 3c             	sub    $0x3c,%esp
  8003cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d0:	eb 17                	jmp    8003e9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8003d2:	85 c0                	test   %eax,%eax
  8003d4:	0f 84 4b 04 00 00    	je     800825 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003e1:	89 04 24             	mov    %eax,(%esp)
  8003e4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8003e7:	89 fb                	mov    %edi,%ebx
  8003e9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8003ec:	0f b6 03             	movzbl (%ebx),%eax
  8003ef:	83 f8 25             	cmp    $0x25,%eax
  8003f2:	75 de                	jne    8003d2 <vprintfmt+0xe>
  8003f4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8003f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800404:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80040b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800410:	eb 18                	jmp    80042a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800412:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800414:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800418:	eb 10                	jmp    80042a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80041c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800420:	eb 08                	jmp    80042a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800422:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800425:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80042d:	0f b6 17             	movzbl (%edi),%edx
  800430:	0f b6 c2             	movzbl %dl,%eax
  800433:	83 ea 23             	sub    $0x23,%edx
  800436:	80 fa 55             	cmp    $0x55,%dl
  800439:	0f 87 c2 03 00 00    	ja     800801 <vprintfmt+0x43d>
  80043f:	0f b6 d2             	movzbl %dl,%edx
  800442:	ff 24 95 c0 2f 80 00 	jmp    *0x802fc0(,%edx,4)
  800449:	89 df                	mov    %ebx,%edi
  80044b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800450:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800453:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800457:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80045a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80045d:	83 fa 09             	cmp    $0x9,%edx
  800460:	77 33                	ja     800495 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800462:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800465:	eb e9                	jmp    800450 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	8b 30                	mov    (%eax),%esi
  80046c:	8d 40 04             	lea    0x4(%eax),%eax
  80046f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800472:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800474:	eb 1f                	jmp    800495 <vprintfmt+0xd1>
  800476:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800479:	85 ff                	test   %edi,%edi
  80047b:	b8 00 00 00 00       	mov    $0x0,%eax
  800480:	0f 49 c7             	cmovns %edi,%eax
  800483:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800486:	89 df                	mov    %ebx,%edi
  800488:	eb a0                	jmp    80042a <vprintfmt+0x66>
  80048a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80048c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800493:	eb 95                	jmp    80042a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800495:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800499:	79 8f                	jns    80042a <vprintfmt+0x66>
  80049b:	eb 85                	jmp    800422 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80049d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004a2:	eb 86                	jmp    80042a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 70 04             	lea    0x4(%eax),%esi
  8004aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	89 04 24             	mov    %eax,(%esp)
  8004b9:	ff 55 08             	call   *0x8(%ebp)
  8004bc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8004bf:	e9 25 ff ff ff       	jmp    8003e9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 70 04             	lea    0x4(%eax),%esi
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	99                   	cltd   
  8004cd:	31 d0                	xor    %edx,%eax
  8004cf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d1:	83 f8 15             	cmp    $0x15,%eax
  8004d4:	7f 0b                	jg     8004e1 <vprintfmt+0x11d>
  8004d6:	8b 14 85 20 31 80 00 	mov    0x803120(,%eax,4),%edx
  8004dd:	85 d2                	test   %edx,%edx
  8004df:	75 26                	jne    800507 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8004e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e5:	c7 44 24 08 9f 2e 80 	movl   $0x802e9f,0x8(%esp)
  8004ec:	00 
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	89 04 24             	mov    %eax,(%esp)
  8004fa:	e8 9d fe ff ff       	call   80039c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ff:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800502:	e9 e2 fe ff ff       	jmp    8003e9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800507:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80050b:	c7 44 24 08 3a 33 80 	movl   $0x80333a,0x8(%esp)
  800512:	00 
  800513:	8b 45 0c             	mov    0xc(%ebp),%eax
  800516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 77 fe ff ff       	call   80039c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800525:	89 75 14             	mov    %esi,0x14(%ebp)
  800528:	e9 bc fe ff ff       	jmp    8003e9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800533:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800536:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80053a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80053c:	85 ff                	test   %edi,%edi
  80053e:	b8 98 2e 80 00       	mov    $0x802e98,%eax
  800543:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800546:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80054a:	0f 84 94 00 00 00    	je     8005e4 <vprintfmt+0x220>
  800550:	85 c9                	test   %ecx,%ecx
  800552:	0f 8e 94 00 00 00    	jle    8005ec <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800558:	89 74 24 04          	mov    %esi,0x4(%esp)
  80055c:	89 3c 24             	mov    %edi,(%esp)
  80055f:	e8 64 03 00 00       	call   8008c8 <strnlen>
  800564:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800567:	29 c1                	sub    %eax,%ecx
  800569:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80056c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800570:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800573:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800576:	8b 75 08             	mov    0x8(%ebp),%esi
  800579:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80057c:	89 cb                	mov    %ecx,%ebx
  80057e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800580:	eb 0f                	jmp    800591 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800582:	8b 45 0c             	mov    0xc(%ebp),%eax
  800585:	89 44 24 04          	mov    %eax,0x4(%esp)
  800589:	89 3c 24             	mov    %edi,(%esp)
  80058c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80058e:	83 eb 01             	sub    $0x1,%ebx
  800591:	85 db                	test   %ebx,%ebx
  800593:	7f ed                	jg     800582 <vprintfmt+0x1be>
  800595:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800598:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80059b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059e:	85 c9                	test   %ecx,%ecx
  8005a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a5:	0f 49 c1             	cmovns %ecx,%eax
  8005a8:	29 c1                	sub    %eax,%ecx
  8005aa:	89 cb                	mov    %ecx,%ebx
  8005ac:	eb 44                	jmp    8005f2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b2:	74 1e                	je     8005d2 <vprintfmt+0x20e>
  8005b4:	0f be d2             	movsbl %dl,%edx
  8005b7:	83 ea 20             	sub    $0x20,%edx
  8005ba:	83 fa 5e             	cmp    $0x5e,%edx
  8005bd:	76 13                	jbe    8005d2 <vprintfmt+0x20e>
					putch('?', putdat);
  8005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005cd:	ff 55 08             	call   *0x8(%ebp)
  8005d0:	eb 0d                	jmp    8005df <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8005d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005d9:	89 04 24             	mov    %eax,(%esp)
  8005dc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005df:	83 eb 01             	sub    $0x1,%ebx
  8005e2:	eb 0e                	jmp    8005f2 <vprintfmt+0x22e>
  8005e4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005e7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ea:	eb 06                	jmp    8005f2 <vprintfmt+0x22e>
  8005ec:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005ef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f2:	83 c7 01             	add    $0x1,%edi
  8005f5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005f9:	0f be c2             	movsbl %dl,%eax
  8005fc:	85 c0                	test   %eax,%eax
  8005fe:	74 27                	je     800627 <vprintfmt+0x263>
  800600:	85 f6                	test   %esi,%esi
  800602:	78 aa                	js     8005ae <vprintfmt+0x1ea>
  800604:	83 ee 01             	sub    $0x1,%esi
  800607:	79 a5                	jns    8005ae <vprintfmt+0x1ea>
  800609:	89 d8                	mov    %ebx,%eax
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800611:	89 c3                	mov    %eax,%ebx
  800613:	eb 18                	jmp    80062d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800615:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800619:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800620:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800622:	83 eb 01             	sub    $0x1,%ebx
  800625:	eb 06                	jmp    80062d <vprintfmt+0x269>
  800627:	8b 75 08             	mov    0x8(%ebp),%esi
  80062a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80062d:	85 db                	test   %ebx,%ebx
  80062f:	7f e4                	jg     800615 <vprintfmt+0x251>
  800631:	89 75 08             	mov    %esi,0x8(%ebp)
  800634:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800637:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80063a:	e9 aa fd ff ff       	jmp    8003e9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80063f:	83 f9 01             	cmp    $0x1,%ecx
  800642:	7e 10                	jle    800654 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 30                	mov    (%eax),%esi
  800649:	8b 78 04             	mov    0x4(%eax),%edi
  80064c:	8d 40 08             	lea    0x8(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	eb 26                	jmp    80067a <vprintfmt+0x2b6>
	else if (lflag)
  800654:	85 c9                	test   %ecx,%ecx
  800656:	74 12                	je     80066a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 30                	mov    (%eax),%esi
  80065d:	89 f7                	mov    %esi,%edi
  80065f:	c1 ff 1f             	sar    $0x1f,%edi
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
  800668:	eb 10                	jmp    80067a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 30                	mov    (%eax),%esi
  80066f:	89 f7                	mov    %esi,%edi
  800671:	c1 ff 1f             	sar    $0x1f,%edi
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80067a:	89 f0                	mov    %esi,%eax
  80067c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80067e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800683:	85 ff                	test   %edi,%edi
  800685:	0f 89 3a 01 00 00    	jns    8007c5 <vprintfmt+0x401>
				putch('-', putdat);
  80068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800692:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800699:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80069c:	89 f0                	mov    %esi,%eax
  80069e:	89 fa                	mov    %edi,%edx
  8006a0:	f7 d8                	neg    %eax
  8006a2:	83 d2 00             	adc    $0x0,%edx
  8006a5:	f7 da                	neg    %edx
			}
			base = 10;
  8006a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006ac:	e9 14 01 00 00       	jmp    8007c5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006b1:	83 f9 01             	cmp    $0x1,%ecx
  8006b4:	7e 13                	jle    8006c9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8b 50 04             	mov    0x4(%eax),%edx
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8b 75 14             	mov    0x14(%ebp),%esi
  8006c1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006c4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006c7:	eb 2c                	jmp    8006f5 <vprintfmt+0x331>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	74 15                	je     8006e2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006da:	8d 76 04             	lea    0x4(%esi),%esi
  8006dd:	89 75 14             	mov    %esi,0x14(%ebp)
  8006e0:	eb 13                	jmp    8006f5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ec:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ef:	8d 76 04             	lea    0x4(%esi),%esi
  8006f2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8006f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006fa:	e9 c6 00 00 00       	jmp    8007c5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7e 13                	jle    800717 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 50 04             	mov    0x4(%eax),%edx
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	8b 75 14             	mov    0x14(%ebp),%esi
  80070f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800712:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800715:	eb 24                	jmp    80073b <vprintfmt+0x377>
	else if (lflag)
  800717:	85 c9                	test   %ecx,%ecx
  800719:	74 11                	je     80072c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	99                   	cltd   
  800721:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800724:	8d 71 04             	lea    0x4(%ecx),%esi
  800727:	89 75 14             	mov    %esi,0x14(%ebp)
  80072a:	eb 0f                	jmp    80073b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	99                   	cltd   
  800732:	8b 75 14             	mov    0x14(%ebp),%esi
  800735:	8d 76 04             	lea    0x4(%esi),%esi
  800738:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80073b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800740:	e9 80 00 00 00       	jmp    8007c5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800745:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800756:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800760:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800767:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80076a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80076e:	8b 06                	mov    (%esi),%eax
  800770:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800775:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80077a:	eb 49                	jmp    8007c5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80077c:	83 f9 01             	cmp    $0x1,%ecx
  80077f:	7e 13                	jle    800794 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 50 04             	mov    0x4(%eax),%edx
  800787:	8b 00                	mov    (%eax),%eax
  800789:	8b 75 14             	mov    0x14(%ebp),%esi
  80078c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80078f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800792:	eb 2c                	jmp    8007c0 <vprintfmt+0x3fc>
	else if (lflag)
  800794:	85 c9                	test   %ecx,%ecx
  800796:	74 15                	je     8007ad <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007a5:	8d 71 04             	lea    0x4(%ecx),%esi
  8007a8:	89 75 14             	mov    %esi,0x14(%ebp)
  8007ab:	eb 13                	jmp    8007c0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	8b 75 14             	mov    0x14(%ebp),%esi
  8007ba:	8d 76 04             	lea    0x4(%esi),%esi
  8007bd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8007c0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8007c9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007d4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007d8:	89 04 24             	mov    %eax,(%esp)
  8007db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	e8 a6 fa ff ff       	call   800290 <printnum>
			break;
  8007ea:	e9 fa fb ff ff       	jmp    8003e9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007f6:	89 04 24             	mov    %eax,(%esp)
  8007f9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007fc:	e9 e8 fb ff ff       	jmp    8003e9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800801:	8b 45 0c             	mov    0xc(%ebp),%eax
  800804:	89 44 24 04          	mov    %eax,0x4(%esp)
  800808:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80080f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800812:	89 fb                	mov    %edi,%ebx
  800814:	eb 03                	jmp    800819 <vprintfmt+0x455>
  800816:	83 eb 01             	sub    $0x1,%ebx
  800819:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80081d:	75 f7                	jne    800816 <vprintfmt+0x452>
  80081f:	90                   	nop
  800820:	e9 c4 fb ff ff       	jmp    8003e9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800825:	83 c4 3c             	add    $0x3c,%esp
  800828:	5b                   	pop    %ebx
  800829:	5e                   	pop    %esi
  80082a:	5f                   	pop    %edi
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	83 ec 28             	sub    $0x28,%esp
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800839:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80083c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800840:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800843:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084a:	85 c0                	test   %eax,%eax
  80084c:	74 30                	je     80087e <vsnprintf+0x51>
  80084e:	85 d2                	test   %edx,%edx
  800850:	7e 2c                	jle    80087e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800860:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800863:	89 44 24 04          	mov    %eax,0x4(%esp)
  800867:	c7 04 24 7f 03 80 00 	movl   $0x80037f,(%esp)
  80086e:	e8 51 fb ff ff       	call   8003c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800876:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087c:	eb 05                	jmp    800883 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80087e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800892:	8b 45 10             	mov    0x10(%ebp),%eax
  800895:	89 44 24 08          	mov    %eax,0x8(%esp)
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 04 24             	mov    %eax,(%esp)
  8008a6:	e8 82 ff ff ff       	call   80082d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    
  8008ad:	66 90                	xchg   %ax,%ax
  8008af:	90                   	nop

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	eb 03                	jmp    8008c0 <strlen+0x10>
		n++;
  8008bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c4:	75 f7                	jne    8008bd <strlen+0xd>
		n++;
	return n;
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	eb 03                	jmp    8008db <strnlen+0x13>
		n++;
  8008d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	39 d0                	cmp    %edx,%eax
  8008dd:	74 06                	je     8008e5 <strnlen+0x1d>
  8008df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e3:	75 f3                	jne    8008d8 <strnlen+0x10>
		n++;
	return n;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	83 c1 01             	add    $0x1,%ecx
  8008f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800900:	84 db                	test   %bl,%bl
  800902:	75 ef                	jne    8008f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800911:	89 1c 24             	mov    %ebx,(%esp)
  800914:	e8 97 ff ff ff       	call   8008b0 <strlen>
	strcpy(dst + len, src);
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800920:	01 d8                	add    %ebx,%eax
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	e8 bd ff ff ff       	call   8008e7 <strcpy>
	return dst;
}
  80092a:	89 d8                	mov    %ebx,%eax
  80092c:	83 c4 08             	add    $0x8,%esp
  80092f:	5b                   	pop    %ebx
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 75 08             	mov    0x8(%ebp),%esi
  80093a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093d:	89 f3                	mov    %esi,%ebx
  80093f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800942:	89 f2                	mov    %esi,%edx
  800944:	eb 0f                	jmp    800955 <strncpy+0x23>
		*dst++ = *src;
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	0f b6 01             	movzbl (%ecx),%eax
  80094c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094f:	80 39 01             	cmpb   $0x1,(%ecx)
  800952:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800955:	39 da                	cmp    %ebx,%edx
  800957:	75 ed                	jne    800946 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800959:	89 f0                	mov    %esi,%eax
  80095b:	5b                   	pop    %ebx
  80095c:	5e                   	pop    %esi
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	8b 75 08             	mov    0x8(%ebp),%esi
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80096d:	89 f0                	mov    %esi,%eax
  80096f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800973:	85 c9                	test   %ecx,%ecx
  800975:	75 0b                	jne    800982 <strlcpy+0x23>
  800977:	eb 1d                	jmp    800996 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	83 c2 01             	add    $0x1,%edx
  80097f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800982:	39 d8                	cmp    %ebx,%eax
  800984:	74 0b                	je     800991 <strlcpy+0x32>
  800986:	0f b6 0a             	movzbl (%edx),%ecx
  800989:	84 c9                	test   %cl,%cl
  80098b:	75 ec                	jne    800979 <strlcpy+0x1a>
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	eb 02                	jmp    800993 <strlcpy+0x34>
  800991:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800993:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800996:	29 f0                	sub    %esi,%eax
}
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a5:	eb 06                	jmp    8009ad <strcmp+0x11>
		p++, q++;
  8009a7:	83 c1 01             	add    $0x1,%ecx
  8009aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 04                	je     8009b8 <strcmp+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	74 ef                	je     8009a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b8:	0f b6 c0             	movzbl %al,%eax
  8009bb:	0f b6 12             	movzbl (%edx),%edx
  8009be:	29 d0                	sub    %edx,%eax
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	89 c3                	mov    %eax,%ebx
  8009ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d1:	eb 06                	jmp    8009d9 <strncmp+0x17>
		n--, p++, q++;
  8009d3:	83 c0 01             	add    $0x1,%eax
  8009d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009d9:	39 d8                	cmp    %ebx,%eax
  8009db:	74 15                	je     8009f2 <strncmp+0x30>
  8009dd:	0f b6 08             	movzbl (%eax),%ecx
  8009e0:	84 c9                	test   %cl,%cl
  8009e2:	74 04                	je     8009e8 <strncmp+0x26>
  8009e4:	3a 0a                	cmp    (%edx),%cl
  8009e6:	74 eb                	je     8009d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 00             	movzbl (%eax),%eax
  8009eb:	0f b6 12             	movzbl (%edx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
  8009f0:	eb 05                	jmp    8009f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a04:	eb 07                	jmp    800a0d <strchr+0x13>
		if (*s == c)
  800a06:	38 ca                	cmp    %cl,%dl
  800a08:	74 0f                	je     800a19 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	75 f2                	jne    800a06 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a25:	eb 07                	jmp    800a2e <strfind+0x13>
		if (*s == c)
  800a27:	38 ca                	cmp    %cl,%dl
  800a29:	74 0a                	je     800a35 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	0f b6 10             	movzbl (%eax),%edx
  800a31:	84 d2                	test   %dl,%dl
  800a33:	75 f2                	jne    800a27 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	57                   	push   %edi
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a43:	85 c9                	test   %ecx,%ecx
  800a45:	74 36                	je     800a7d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a47:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4d:	75 28                	jne    800a77 <memset+0x40>
  800a4f:	f6 c1 03             	test   $0x3,%cl
  800a52:	75 23                	jne    800a77 <memset+0x40>
		c &= 0xFF;
  800a54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a58:	89 d3                	mov    %edx,%ebx
  800a5a:	c1 e3 08             	shl    $0x8,%ebx
  800a5d:	89 d6                	mov    %edx,%esi
  800a5f:	c1 e6 18             	shl    $0x18,%esi
  800a62:	89 d0                	mov    %edx,%eax
  800a64:	c1 e0 10             	shl    $0x10,%eax
  800a67:	09 f0                	or     %esi,%eax
  800a69:	09 c2                	or     %eax,%edx
  800a6b:	89 d0                	mov    %edx,%eax
  800a6d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a6f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a72:	fc                   	cld    
  800a73:	f3 ab                	rep stos %eax,%es:(%edi)
  800a75:	eb 06                	jmp    800a7d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	fc                   	cld    
  800a7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7d:	89 f8                	mov    %edi,%eax
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5f                   	pop    %edi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	57                   	push   %edi
  800a88:	56                   	push   %esi
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a92:	39 c6                	cmp    %eax,%esi
  800a94:	73 35                	jae    800acb <memmove+0x47>
  800a96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a99:	39 d0                	cmp    %edx,%eax
  800a9b:	73 2e                	jae    800acb <memmove+0x47>
		s += n;
		d += n;
  800a9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800aa0:	89 d6                	mov    %edx,%esi
  800aa2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaa:	75 13                	jne    800abf <memmove+0x3b>
  800aac:	f6 c1 03             	test   $0x3,%cl
  800aaf:	75 0e                	jne    800abf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1d                	jmp    800ae8 <memmove+0x64>
  800acb:	89 f2                	mov    %esi,%edx
  800acd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acf:	f6 c2 03             	test   $0x3,%dl
  800ad2:	75 0f                	jne    800ae3 <memmove+0x5f>
  800ad4:	f6 c1 03             	test   $0x3,%cl
  800ad7:	75 0a                	jne    800ae3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800adc:	89 c7                	mov    %eax,%edi
  800ade:	fc                   	cld    
  800adf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae1:	eb 05                	jmp    800ae8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae3:	89 c7                	mov    %eax,%edi
  800ae5:	fc                   	cld    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 04 24             	mov    %eax,(%esp)
  800b06:	e8 79 ff ff ff       	call   800a84 <memmove>
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b18:	89 d6                	mov    %edx,%esi
  800b1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1d:	eb 1a                	jmp    800b39 <memcmp+0x2c>
		if (*s1 != *s2)
  800b1f:	0f b6 02             	movzbl (%edx),%eax
  800b22:	0f b6 19             	movzbl (%ecx),%ebx
  800b25:	38 d8                	cmp    %bl,%al
  800b27:	74 0a                	je     800b33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b29:	0f b6 c0             	movzbl %al,%eax
  800b2c:	0f b6 db             	movzbl %bl,%ebx
  800b2f:	29 d8                	sub    %ebx,%eax
  800b31:	eb 0f                	jmp    800b42 <memcmp+0x35>
		s1++, s2++;
  800b33:	83 c2 01             	add    $0x1,%edx
  800b36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b39:	39 f2                	cmp    %esi,%edx
  800b3b:	75 e2                	jne    800b1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4f:	89 c2                	mov    %eax,%edx
  800b51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b54:	eb 07                	jmp    800b5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b56:	38 08                	cmp    %cl,(%eax)
  800b58:	74 07                	je     800b61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	39 d0                	cmp    %edx,%eax
  800b5f:	72 f5                	jb     800b56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6f:	eb 03                	jmp    800b74 <strtol+0x11>
		s++;
  800b71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b74:	0f b6 0a             	movzbl (%edx),%ecx
  800b77:	80 f9 09             	cmp    $0x9,%cl
  800b7a:	74 f5                	je     800b71 <strtol+0xe>
  800b7c:	80 f9 20             	cmp    $0x20,%cl
  800b7f:	74 f0                	je     800b71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b81:	80 f9 2b             	cmp    $0x2b,%cl
  800b84:	75 0a                	jne    800b90 <strtol+0x2d>
		s++;
  800b86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b89:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8e:	eb 11                	jmp    800ba1 <strtol+0x3e>
  800b90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b95:	80 f9 2d             	cmp    $0x2d,%cl
  800b98:	75 07                	jne    800ba1 <strtol+0x3e>
		s++, neg = 1;
  800b9a:	8d 52 01             	lea    0x1(%edx),%edx
  800b9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ba6:	75 15                	jne    800bbd <strtol+0x5a>
  800ba8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bab:	75 10                	jne    800bbd <strtol+0x5a>
  800bad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bb1:	75 0a                	jne    800bbd <strtol+0x5a>
		s += 2, base = 16;
  800bb3:	83 c2 02             	add    $0x2,%edx
  800bb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bbb:	eb 10                	jmp    800bcd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	75 0c                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc6:	75 05                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
  800bc8:	83 c2 01             	add    $0x1,%edx
  800bcb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bd5:	0f b6 0a             	movzbl (%edx),%ecx
  800bd8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bdb:	89 f0                	mov    %esi,%eax
  800bdd:	3c 09                	cmp    $0x9,%al
  800bdf:	77 08                	ja     800be9 <strtol+0x86>
			dig = *s - '0';
  800be1:	0f be c9             	movsbl %cl,%ecx
  800be4:	83 e9 30             	sub    $0x30,%ecx
  800be7:	eb 20                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800be9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bec:	89 f0                	mov    %esi,%eax
  800bee:	3c 19                	cmp    $0x19,%al
  800bf0:	77 08                	ja     800bfa <strtol+0x97>
			dig = *s - 'a' + 10;
  800bf2:	0f be c9             	movsbl %cl,%ecx
  800bf5:	83 e9 57             	sub    $0x57,%ecx
  800bf8:	eb 0f                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bfa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bfd:	89 f0                	mov    %esi,%eax
  800bff:	3c 19                	cmp    $0x19,%al
  800c01:	77 16                	ja     800c19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c03:	0f be c9             	movsbl %cl,%ecx
  800c06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c0c:	7d 0f                	jge    800c1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c0e:	83 c2 01             	add    $0x1,%edx
  800c11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c17:	eb bc                	jmp    800bd5 <strtol+0x72>
  800c19:	89 d8                	mov    %ebx,%eax
  800c1b:	eb 02                	jmp    800c1f <strtol+0xbc>
  800c1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c23:	74 05                	je     800c2a <strtol+0xc7>
		*endptr = (char *) s;
  800c25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c2a:	f7 d8                	neg    %eax
  800c2c:	85 ff                	test   %edi,%edi
  800c2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	89 c3                	mov    %eax,%ebx
  800c49:	89 c7                	mov    %eax,%edi
  800c4b:	89 c6                	mov    %eax,%esi
  800c4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c81:	b8 03 00 00 00       	mov    $0x3,%eax
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	89 cb                	mov    %ecx,%ebx
  800c8b:	89 cf                	mov    %ecx,%edi
  800c8d:	89 ce                	mov    %ecx,%esi
  800c8f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7e 28                	jle    800cbd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ca0:	00 
  800ca1:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800ca8:	00 
  800ca9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb0:	00 
  800cb1:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800cb8:	e8 b5 f4 ff ff       	call   800172 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbd:	83 c4 2c             	add    $0x2c,%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd3:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	89 cb                	mov    %ecx,%ebx
  800cdd:	89 cf                	mov    %ecx,%edi
  800cdf:	89 ce                	mov    %ecx,%esi
  800ce1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7e 28                	jle    800d0f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ceb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cf2:	00 
  800cf3:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800cfa:	00 
  800cfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d02:	00 
  800d03:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800d0a:	e8 63 f4 ff ff       	call   800172 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800d0f:	83 c4 2c             	add    $0x2c,%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	b8 02 00 00 00       	mov    $0x2,%eax
  800d27:	89 d1                	mov    %edx,%ecx
  800d29:	89 d3                	mov    %edx,%ebx
  800d2b:	89 d7                	mov    %edx,%edi
  800d2d:	89 d6                	mov    %edx,%esi
  800d2f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <sys_yield>:

void
sys_yield(void)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d46:	89 d1                	mov    %edx,%ecx
  800d48:	89 d3                	mov    %edx,%ebx
  800d4a:	89 d7                	mov    %edx,%edi
  800d4c:	89 d6                	mov    %edx,%esi
  800d4e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5e:	be 00 00 00 00       	mov    $0x0,%esi
  800d63:	b8 05 00 00 00       	mov    $0x5,%eax
  800d68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d71:	89 f7                	mov    %esi,%edi
  800d73:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7e 28                	jle    800da1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d79:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d84:	00 
  800d85:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800d8c:	00 
  800d8d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d94:	00 
  800d95:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800d9c:	e8 d1 f3 ff ff       	call   800172 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da1:	83 c4 2c             	add    $0x2c,%esp
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db2:	b8 06 00 00 00       	mov    $0x6,%eax
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc3:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7e 28                	jle    800df4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dd7:	00 
  800dd8:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800ddf:	00 
  800de0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de7:	00 
  800de8:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800def:	e8 7e f3 ff ff       	call   800172 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df4:	83 c4 2c             	add    $0x2c,%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	b8 07 00 00 00       	mov    $0x7,%eax
  800e0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7e 28                	jle    800e47 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e23:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e2a:	00 
  800e2b:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800e32:	00 
  800e33:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3a:	00 
  800e3b:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800e42:	e8 2b f3 ff ff       	call   800172 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e47:	83 c4 2c             	add    $0x2c,%esp
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	89 cb                	mov    %ecx,%ebx
  800e64:	89 cf                	mov    %ecx,%edi
  800e66:	89 ce                	mov    %ecx,%esi
  800e68:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
  800e75:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	89 df                	mov    %ebx,%edi
  800e8a:	89 de                	mov    %ebx,%esi
  800e8c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8e:	85 c0                	test   %eax,%eax
  800e90:	7e 28                	jle    800eba <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e92:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e96:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e9d:	00 
  800e9e:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800ea5:	00 
  800ea6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ead:	00 
  800eae:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800eb5:	e8 b8 f2 ff ff       	call   800172 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eba:	83 c4 2c             	add    $0x2c,%esp
  800ebd:	5b                   	pop    %ebx
  800ebe:	5e                   	pop    %esi
  800ebf:	5f                   	pop    %edi
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    

00800ec2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	57                   	push   %edi
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	89 df                	mov    %ebx,%edi
  800edd:	89 de                	mov    %ebx,%esi
  800edf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	7e 28                	jle    800f0d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ef0:	00 
  800ef1:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800ef8:	00 
  800ef9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f00:	00 
  800f01:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800f08:	e8 65 f2 ff ff       	call   800172 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f0d:	83 c4 2c             	add    $0x2c,%esp
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
  800f1b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f23:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2e:	89 df                	mov    %ebx,%edi
  800f30:	89 de                	mov    %ebx,%esi
  800f32:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7e 28                	jle    800f60 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f43:	00 
  800f44:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800f4b:	00 
  800f4c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f53:	00 
  800f54:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800f5b:	e8 12 f2 ff ff       	call   800172 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f60:	83 c4 2c             	add    $0x2c,%esp
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    

00800f68 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6e:	be 00 00 00 00       	mov    $0x0,%esi
  800f73:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f84:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
  800f91:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f99:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	89 cb                	mov    %ecx,%ebx
  800fa3:	89 cf                	mov    %ecx,%edi
  800fa5:	89 ce                	mov    %ecx,%esi
  800fa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7e 28                	jle    800fd5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800fb8:	00 
  800fb9:	c7 44 24 08 97 31 80 	movl   $0x803197,0x8(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc8:	00 
  800fc9:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  800fd0:	e8 9d f1 ff ff       	call   800172 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd5:	83 c4 2c             	add    $0x2c,%esp
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fed:	89 d1                	mov    %edx,%ecx
  800fef:	89 d3                	mov    %edx,%ebx
  800ff1:	89 d7                	mov    %edx,%edi
  800ff3:	89 d6                	mov    %edx,%esi
  800ff5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5f                   	pop    %edi
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    

00800ffc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801002:	bb 00 00 00 00       	mov    $0x0,%ebx
  801007:	b8 11 00 00 00       	mov    $0x11,%eax
  80100c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	89 df                	mov    %ebx,%edi
  801014:	89 de                	mov    %ebx,%esi
  801016:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801023:	bb 00 00 00 00       	mov    $0x0,%ebx
  801028:	b8 12 00 00 00       	mov    $0x12,%eax
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	89 df                	mov    %ebx,%edi
  801035:	89 de                	mov    %ebx,%esi
  801037:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801044:	b9 00 00 00 00       	mov    $0x0,%ecx
  801049:	b8 13 00 00 00       	mov    $0x13,%eax
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	89 cb                	mov    %ecx,%ebx
  801053:	89 cf                	mov    %ecx,%edi
  801055:	89 ce                	mov    %ecx,%esi
  801057:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    

0080105e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	57                   	push   %edi
  801062:	56                   	push   %esi
  801063:	53                   	push   %ebx
  801064:	83 ec 2c             	sub    $0x2c,%esp
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80106a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80106c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80106f:	89 f8                	mov    %edi,%eax
  801071:	c1 e8 0c             	shr    $0xc,%eax
  801074:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801077:	e8 9b fc ff ff       	call   800d17 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80107c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801082:	0f 84 de 00 00 00    	je     801166 <pgfault+0x108>
  801088:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80108a:	85 c0                	test   %eax,%eax
  80108c:	79 20                	jns    8010ae <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80108e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801092:	c7 44 24 08 c2 31 80 	movl   $0x8031c2,0x8(%esp)
  801099:	00 
  80109a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8010a1:	00 
  8010a2:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  8010a9:	e8 c4 f0 ff ff       	call   800172 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  8010ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  8010b8:	25 05 08 00 00       	and    $0x805,%eax
  8010bd:	3d 05 08 00 00       	cmp    $0x805,%eax
  8010c2:	0f 85 ba 00 00 00    	jne    801182 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8010c8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010cf:	00 
  8010d0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010d7:	00 
  8010d8:	89 1c 24             	mov    %ebx,(%esp)
  8010db:	e8 75 fc ff ff       	call   800d55 <sys_page_alloc>
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	79 20                	jns    801104 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  8010e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010e8:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  8010ef:	00 
  8010f0:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8010f7:	00 
  8010f8:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  8010ff:	e8 6e f0 ff ff       	call   800172 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801104:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80110a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801111:	00 
  801112:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801116:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80111d:	e8 62 f9 ff ff       	call   800a84 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801122:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801129:	00 
  80112a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80112e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801132:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801139:	00 
  80113a:	89 1c 24             	mov    %ebx,(%esp)
  80113d:	e8 67 fc ff ff       	call   800da9 <sys_page_map>
  801142:	85 c0                	test   %eax,%eax
  801144:	79 3c                	jns    801182 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801146:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80114a:	c7 44 24 08 fc 31 80 	movl   $0x8031fc,0x8(%esp)
  801151:	00 
  801152:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801159:	00 
  80115a:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  801161:	e8 0c f0 ff ff       	call   800172 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801166:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  80116d:	00 
  80116e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801175:	00 
  801176:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  80117d:	e8 f0 ef ff ff       	call   800172 <_panic>
}
  801182:	83 c4 2c             	add    $0x2c,%esp
  801185:	5b                   	pop    %ebx
  801186:	5e                   	pop    %esi
  801187:	5f                   	pop    %edi
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	56                   	push   %esi
  80118e:	53                   	push   %ebx
  80118f:	83 ec 20             	sub    $0x20,%esp
  801192:	8b 75 08             	mov    0x8(%ebp),%esi
  801195:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801198:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80119f:	00 
  8011a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011a4:	89 34 24             	mov    %esi,(%esp)
  8011a7:	e8 a9 fb ff ff       	call   800d55 <sys_page_alloc>
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	79 20                	jns    8011d0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  8011b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011b4:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  8011bb:	00 
  8011bc:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8011c3:	00 
  8011c4:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  8011cb:	e8 a2 ef ff ff       	call   800172 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8011d0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011d7:	00 
  8011d8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8011df:	00 
  8011e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011e7:	00 
  8011e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011ec:	89 34 24             	mov    %esi,(%esp)
  8011ef:	e8 b5 fb ff ff       	call   800da9 <sys_page_map>
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	79 20                	jns    801218 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  8011f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011fc:	c7 44 24 08 fc 31 80 	movl   $0x8031fc,0x8(%esp)
  801203:	00 
  801204:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80120b:	00 
  80120c:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  801213:	e8 5a ef ff ff       	call   800172 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801218:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80121f:	00 
  801220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801224:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80122b:	e8 54 f8 ff ff       	call   800a84 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801230:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801237:	00 
  801238:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80123f:	e8 b8 fb ff ff       	call   800dfc <sys_page_unmap>
  801244:	85 c0                	test   %eax,%eax
  801246:	79 20                	jns    801268 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801248:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80124c:	c7 44 24 08 0d 32 80 	movl   $0x80320d,0x8(%esp)
  801253:	00 
  801254:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80125b:	00 
  80125c:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  801263:	e8 0a ef ff ff       	call   800172 <_panic>

}
  801268:	83 c4 20             	add    $0x20,%esp
  80126b:	5b                   	pop    %ebx
  80126c:	5e                   	pop    %esi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    

0080126f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	57                   	push   %edi
  801273:	56                   	push   %esi
  801274:	53                   	push   %ebx
  801275:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801278:	c7 04 24 5e 10 80 00 	movl   $0x80105e,(%esp)
  80127f:	e8 e2 16 00 00       	call   802966 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801284:	b8 08 00 00 00       	mov    $0x8,%eax
  801289:	cd 30                	int    $0x30
  80128b:	89 c6                	mov    %eax,%esi
  80128d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801290:	85 c0                	test   %eax,%eax
  801292:	79 20                	jns    8012b4 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801294:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801298:	c7 44 24 08 44 32 80 	movl   $0x803244,0x8(%esp)
  80129f:	00 
  8012a0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  8012a7:	00 
  8012a8:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  8012af:	e8 be ee ff ff       	call   800172 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8012b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	75 21                	jne    8012de <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8012bd:	e8 55 fa ff ff       	call   800d17 <sys_getenvid>
  8012c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012c7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012cf:	a3 0c 50 80 00       	mov    %eax,0x80500c
		//set_pgfault_handler(pgfault);
		return 0;
  8012d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d9:	e9 88 01 00 00       	jmp    801466 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8012de:	89 d8                	mov    %ebx,%eax
  8012e0:	c1 e8 16             	shr    $0x16,%eax
  8012e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ea:	a8 01                	test   $0x1,%al
  8012ec:	0f 84 e0 00 00 00    	je     8013d2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8012f2:	89 df                	mov    %ebx,%edi
  8012f4:	c1 ef 0c             	shr    $0xc,%edi
  8012f7:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  8012fe:	a8 01                	test   $0x1,%al
  801300:	0f 84 c4 00 00 00    	je     8013ca <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801306:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80130d:	f6 c4 04             	test   $0x4,%ah
  801310:	74 0d                	je     80131f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801312:	25 07 0e 00 00       	and    $0xe07,%eax
  801317:	83 c8 05             	or     $0x5,%eax
  80131a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80131d:	eb 1b                	jmp    80133a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80131f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801324:	83 f8 01             	cmp    $0x1,%eax
  801327:	19 c0                	sbb    %eax,%eax
  801329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80132c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801333:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80133a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80133d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801340:	89 44 24 10          	mov    %eax,0x10(%esp)
  801344:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80134f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801353:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80135a:	e8 4a fa ff ff       	call   800da9 <sys_page_map>
  80135f:	85 c0                	test   %eax,%eax
  801361:	79 20                	jns    801383 <fork+0x114>
		panic("sys_page_map: %e", r);
  801363:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801367:	c7 44 24 08 fc 31 80 	movl   $0x8031fc,0x8(%esp)
  80136e:	00 
  80136f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801376:	00 
  801377:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  80137e:	e8 ef ed ff ff       	call   800172 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801386:	89 44 24 10          	mov    %eax,0x10(%esp)
  80138a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80138e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801395:	00 
  801396:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80139a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a1:	e8 03 fa ff ff       	call   800da9 <sys_page_map>
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	79 20                	jns    8013ca <fork+0x15b>
		panic("sys_page_map: %e", r);
  8013aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ae:	c7 44 24 08 fc 31 80 	movl   $0x8031fc,0x8(%esp)
  8013b5:	00 
  8013b6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  8013bd:	00 
  8013be:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  8013c5:	e8 a8 ed ff ff       	call   800172 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8013ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013d0:	eb 06                	jmp    8013d8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  8013d2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  8013d8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  8013de:	0f 86 fa fe ff ff    	jbe    8012de <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8013e4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013eb:	00 
  8013ec:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013f3:	ee 
  8013f4:	89 34 24             	mov    %esi,(%esp)
  8013f7:	e8 59 f9 ff ff       	call   800d55 <sys_page_alloc>
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	79 20                	jns    801420 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801400:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801404:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  80140b:	00 
  80140c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801413:	00 
  801414:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  80141b:	e8 52 ed ff ff       	call   800172 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801420:	c7 44 24 04 f9 29 80 	movl   $0x8029f9,0x4(%esp)
  801427:	00 
  801428:	89 34 24             	mov    %esi,(%esp)
  80142b:	e8 e5 fa ff ff       	call   800f15 <sys_env_set_pgfault_upcall>
  801430:	85 c0                	test   %eax,%eax
  801432:	79 20                	jns    801454 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801434:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801438:	c7 44 24 08 68 32 80 	movl   $0x803268,0x8(%esp)
  80143f:	00 
  801440:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801447:	00 
  801448:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  80144f:	e8 1e ed ff ff       	call   800172 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801454:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80145b:	00 
  80145c:	89 34 24             	mov    %esi,(%esp)
  80145f:	e8 0b fa ff ff       	call   800e6f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801464:	89 f0                	mov    %esi,%eax

}
  801466:	83 c4 2c             	add    $0x2c,%esp
  801469:	5b                   	pop    %ebx
  80146a:	5e                   	pop    %esi
  80146b:	5f                   	pop    %edi
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <sfork>:

// Challenge!
int
sfork(void)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	57                   	push   %edi
  801472:	56                   	push   %esi
  801473:	53                   	push   %ebx
  801474:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801477:	c7 04 24 5e 10 80 00 	movl   $0x80105e,(%esp)
  80147e:	e8 e3 14 00 00       	call   802966 <set_pgfault_handler>
  801483:	b8 08 00 00 00       	mov    $0x8,%eax
  801488:	cd 30                	int    $0x30
  80148a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80148c:	85 c0                	test   %eax,%eax
  80148e:	79 20                	jns    8014b0 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801490:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801494:	c7 44 24 08 44 32 80 	movl   $0x803244,0x8(%esp)
  80149b:	00 
  80149c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  8014a3:	00 
  8014a4:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  8014ab:	e8 c2 ec ff ff       	call   800172 <_panic>
  8014b0:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8014b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	75 2d                	jne    8014e8 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8014bb:	e8 57 f8 ff ff       	call   800d17 <sys_getenvid>
  8014c0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014c5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014c8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014cd:	a3 0c 50 80 00       	mov    %eax,0x80500c
		set_pgfault_handler(pgfault);
  8014d2:	c7 04 24 5e 10 80 00 	movl   $0x80105e,(%esp)
  8014d9:	e8 88 14 00 00       	call   802966 <set_pgfault_handler>
		return 0;
  8014de:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e3:	e9 1d 01 00 00       	jmp    801605 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8014e8:	89 d8                	mov    %ebx,%eax
  8014ea:	c1 e8 16             	shr    $0x16,%eax
  8014ed:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014f4:	a8 01                	test   $0x1,%al
  8014f6:	74 69                	je     801561 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8014f8:	89 d8                	mov    %ebx,%eax
  8014fa:	c1 e8 0c             	shr    $0xc,%eax
  8014fd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801504:	f6 c2 01             	test   $0x1,%dl
  801507:	74 50                	je     801559 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801509:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801510:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801513:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801519:	89 54 24 10          	mov    %edx,0x10(%esp)
  80151d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801521:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801525:	89 44 24 04          	mov    %eax,0x4(%esp)
  801529:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801530:	e8 74 f8 ff ff       	call   800da9 <sys_page_map>
  801535:	85 c0                	test   %eax,%eax
  801537:	79 20                	jns    801559 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801539:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80153d:	c7 44 24 08 fc 31 80 	movl   $0x8031fc,0x8(%esp)
  801544:	00 
  801545:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80154c:	00 
  80154d:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  801554:	e8 19 ec ff ff       	call   800172 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801559:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80155f:	eb 06                	jmp    801567 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801561:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801567:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80156d:	0f 86 75 ff ff ff    	jbe    8014e8 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801573:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80157a:	ee 
  80157b:	89 34 24             	mov    %esi,(%esp)
  80157e:	e8 07 fc ff ff       	call   80118a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801583:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80158a:	00 
  80158b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801592:	ee 
  801593:	89 34 24             	mov    %esi,(%esp)
  801596:	e8 ba f7 ff ff       	call   800d55 <sys_page_alloc>
  80159b:	85 c0                	test   %eax,%eax
  80159d:	79 20                	jns    8015bf <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80159f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015a3:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  8015aa:	00 
  8015ab:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  8015b2:	00 
  8015b3:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  8015ba:	e8 b3 eb ff ff       	call   800172 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8015bf:	c7 44 24 04 f9 29 80 	movl   $0x8029f9,0x4(%esp)
  8015c6:	00 
  8015c7:	89 34 24             	mov    %esi,(%esp)
  8015ca:	e8 46 f9 ff ff       	call   800f15 <sys_env_set_pgfault_upcall>
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	79 20                	jns    8015f3 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  8015d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d7:	c7 44 24 08 68 32 80 	movl   $0x803268,0x8(%esp)
  8015de:	00 
  8015df:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  8015e6:	00 
  8015e7:	c7 04 24 de 31 80 00 	movl   $0x8031de,(%esp)
  8015ee:	e8 7f eb ff ff       	call   800172 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8015f3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8015fa:	00 
  8015fb:	89 34 24             	mov    %esi,(%esp)
  8015fe:	e8 6c f8 ff ff       	call   800e6f <sys_env_set_status>
	return envid;
  801603:	89 f0                	mov    %esi,%eax

}
  801605:	83 c4 2c             	add    $0x2c,%esp
  801608:	5b                   	pop    %ebx
  801609:	5e                   	pop    %esi
  80160a:	5f                   	pop    %edi
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    
  80160d:	66 90                	xchg   %ax,%ax
  80160f:	90                   	nop

00801610 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	05 00 00 00 30       	add    $0x30000000,%eax
  80161b:	c1 e8 0c             	shr    $0xc,%eax
}
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80162b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801630:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    

00801637 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80163d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801642:	89 c2                	mov    %eax,%edx
  801644:	c1 ea 16             	shr    $0x16,%edx
  801647:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80164e:	f6 c2 01             	test   $0x1,%dl
  801651:	74 11                	je     801664 <fd_alloc+0x2d>
  801653:	89 c2                	mov    %eax,%edx
  801655:	c1 ea 0c             	shr    $0xc,%edx
  801658:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165f:	f6 c2 01             	test   $0x1,%dl
  801662:	75 09                	jne    80166d <fd_alloc+0x36>
			*fd_store = fd;
  801664:	89 01                	mov    %eax,(%ecx)
			return 0;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 17                	jmp    801684 <fd_alloc+0x4d>
  80166d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801672:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801677:	75 c9                	jne    801642 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801679:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80167f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801684:	5d                   	pop    %ebp
  801685:	c3                   	ret    

00801686 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80168c:	83 f8 1f             	cmp    $0x1f,%eax
  80168f:	77 36                	ja     8016c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801691:	c1 e0 0c             	shl    $0xc,%eax
  801694:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801699:	89 c2                	mov    %eax,%edx
  80169b:	c1 ea 16             	shr    $0x16,%edx
  80169e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016a5:	f6 c2 01             	test   $0x1,%dl
  8016a8:	74 24                	je     8016ce <fd_lookup+0x48>
  8016aa:	89 c2                	mov    %eax,%edx
  8016ac:	c1 ea 0c             	shr    $0xc,%edx
  8016af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b6:	f6 c2 01             	test   $0x1,%dl
  8016b9:	74 1a                	je     8016d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	89 02                	mov    %eax,(%edx)
	return 0;
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c5:	eb 13                	jmp    8016da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016cc:	eb 0c                	jmp    8016da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d3:	eb 05                	jmp    8016da <fd_lookup+0x54>
  8016d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 18             	sub    $0x18,%esp
  8016e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ea:	eb 13                	jmp    8016ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8016ec:	39 08                	cmp    %ecx,(%eax)
  8016ee:	75 0c                	jne    8016fc <dev_lookup+0x20>
			*dev = devtab[i];
  8016f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fa:	eb 38                	jmp    801734 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016fc:	83 c2 01             	add    $0x1,%edx
  8016ff:	8b 04 95 08 33 80 00 	mov    0x803308(,%edx,4),%eax
  801706:	85 c0                	test   %eax,%eax
  801708:	75 e2                	jne    8016ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80170a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80170f:	8b 40 48             	mov    0x48(%eax),%eax
  801712:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171a:	c7 04 24 8c 32 80 00 	movl   $0x80328c,(%esp)
  801721:	e8 45 eb ff ff       	call   80026b <cprintf>
	*dev = 0;
  801726:	8b 45 0c             	mov    0xc(%ebp),%eax
  801729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80172f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	83 ec 20             	sub    $0x20,%esp
  80173e:	8b 75 08             	mov    0x8(%ebp),%esi
  801741:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801744:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801747:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80174b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801751:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801754:	89 04 24             	mov    %eax,(%esp)
  801757:	e8 2a ff ff ff       	call   801686 <fd_lookup>
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 05                	js     801765 <fd_close+0x2f>
	    || fd != fd2)
  801760:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801763:	74 0c                	je     801771 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801765:	84 db                	test   %bl,%bl
  801767:	ba 00 00 00 00       	mov    $0x0,%edx
  80176c:	0f 44 c2             	cmove  %edx,%eax
  80176f:	eb 3f                	jmp    8017b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801771:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801774:	89 44 24 04          	mov    %eax,0x4(%esp)
  801778:	8b 06                	mov    (%esi),%eax
  80177a:	89 04 24             	mov    %eax,(%esp)
  80177d:	e8 5a ff ff ff       	call   8016dc <dev_lookup>
  801782:	89 c3                	mov    %eax,%ebx
  801784:	85 c0                	test   %eax,%eax
  801786:	78 16                	js     80179e <fd_close+0x68>
		if (dev->dev_close)
  801788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80178e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801793:	85 c0                	test   %eax,%eax
  801795:	74 07                	je     80179e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801797:	89 34 24             	mov    %esi,(%esp)
  80179a:	ff d0                	call   *%eax
  80179c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80179e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a9:	e8 4e f6 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  8017ae:	89 d8                	mov    %ebx,%eax
}
  8017b0:	83 c4 20             	add    $0x20,%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	89 04 24             	mov    %eax,(%esp)
  8017ca:	e8 b7 fe ff ff       	call   801686 <fd_lookup>
  8017cf:	89 c2                	mov    %eax,%edx
  8017d1:	85 d2                	test   %edx,%edx
  8017d3:	78 13                	js     8017e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8017d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017dc:	00 
  8017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e0:	89 04 24             	mov    %eax,(%esp)
  8017e3:	e8 4e ff ff ff       	call   801736 <fd_close>
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <close_all>:

void
close_all(void)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017f6:	89 1c 24             	mov    %ebx,(%esp)
  8017f9:	e8 b9 ff ff ff       	call   8017b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017fe:	83 c3 01             	add    $0x1,%ebx
  801801:	83 fb 20             	cmp    $0x20,%ebx
  801804:	75 f0                	jne    8017f6 <close_all+0xc>
		close(i);
}
  801806:	83 c4 14             	add    $0x14,%esp
  801809:	5b                   	pop    %ebx
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    

0080180c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	57                   	push   %edi
  801810:	56                   	push   %esi
  801811:	53                   	push   %ebx
  801812:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801815:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	89 04 24             	mov    %eax,(%esp)
  801822:	e8 5f fe ff ff       	call   801686 <fd_lookup>
  801827:	89 c2                	mov    %eax,%edx
  801829:	85 d2                	test   %edx,%edx
  80182b:	0f 88 e1 00 00 00    	js     801912 <dup+0x106>
		return r;
	close(newfdnum);
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	89 04 24             	mov    %eax,(%esp)
  801837:	e8 7b ff ff ff       	call   8017b7 <close>

	newfd = INDEX2FD(newfdnum);
  80183c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80183f:	c1 e3 0c             	shl    $0xc,%ebx
  801842:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184b:	89 04 24             	mov    %eax,(%esp)
  80184e:	e8 cd fd ff ff       	call   801620 <fd2data>
  801853:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801855:	89 1c 24             	mov    %ebx,(%esp)
  801858:	e8 c3 fd ff ff       	call   801620 <fd2data>
  80185d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80185f:	89 f0                	mov    %esi,%eax
  801861:	c1 e8 16             	shr    $0x16,%eax
  801864:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80186b:	a8 01                	test   $0x1,%al
  80186d:	74 43                	je     8018b2 <dup+0xa6>
  80186f:	89 f0                	mov    %esi,%eax
  801871:	c1 e8 0c             	shr    $0xc,%eax
  801874:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80187b:	f6 c2 01             	test   $0x1,%dl
  80187e:	74 32                	je     8018b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801880:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801887:	25 07 0e 00 00       	and    $0xe07,%eax
  80188c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801890:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801894:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80189b:	00 
  80189c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a7:	e8 fd f4 ff ff       	call   800da9 <sys_page_map>
  8018ac:	89 c6                	mov    %eax,%esi
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 3e                	js     8018f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b5:	89 c2                	mov    %eax,%edx
  8018b7:	c1 ea 0c             	shr    $0xc,%edx
  8018ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8018c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8018cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018d6:	00 
  8018d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e2:	e8 c2 f4 ff ff       	call   800da9 <sys_page_map>
  8018e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018ec:	85 f6                	test   %esi,%esi
  8018ee:	79 22                	jns    801912 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018fb:	e8 fc f4 ff ff       	call   800dfc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801900:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801904:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80190b:	e8 ec f4 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  801910:	89 f0                	mov    %esi,%eax
}
  801912:	83 c4 3c             	add    $0x3c,%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5f                   	pop    %edi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	53                   	push   %ebx
  80191e:	83 ec 24             	sub    $0x24,%esp
  801921:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801924:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	89 1c 24             	mov    %ebx,(%esp)
  80192e:	e8 53 fd ff ff       	call   801686 <fd_lookup>
  801933:	89 c2                	mov    %eax,%edx
  801935:	85 d2                	test   %edx,%edx
  801937:	78 6d                	js     8019a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	8b 00                	mov    (%eax),%eax
  801945:	89 04 24             	mov    %eax,(%esp)
  801948:	e8 8f fd ff ff       	call   8016dc <dev_lookup>
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 55                	js     8019a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	8b 50 08             	mov    0x8(%eax),%edx
  801957:	83 e2 03             	and    $0x3,%edx
  80195a:	83 fa 01             	cmp    $0x1,%edx
  80195d:	75 23                	jne    801982 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80195f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801964:	8b 40 48             	mov    0x48(%eax),%eax
  801967:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80196b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196f:	c7 04 24 cd 32 80 00 	movl   $0x8032cd,(%esp)
  801976:	e8 f0 e8 ff ff       	call   80026b <cprintf>
		return -E_INVAL;
  80197b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801980:	eb 24                	jmp    8019a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801985:	8b 52 08             	mov    0x8(%edx),%edx
  801988:	85 d2                	test   %edx,%edx
  80198a:	74 15                	je     8019a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80198c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801996:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80199a:	89 04 24             	mov    %eax,(%esp)
  80199d:	ff d2                	call   *%edx
  80199f:	eb 05                	jmp    8019a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8019a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8019a6:	83 c4 24             	add    $0x24,%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    

008019ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	57                   	push   %edi
  8019b0:	56                   	push   %esi
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 1c             	sub    $0x1c,%esp
  8019b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c0:	eb 23                	jmp    8019e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019c2:	89 f0                	mov    %esi,%eax
  8019c4:	29 d8                	sub    %ebx,%eax
  8019c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ca:	89 d8                	mov    %ebx,%eax
  8019cc:	03 45 0c             	add    0xc(%ebp),%eax
  8019cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d3:	89 3c 24             	mov    %edi,(%esp)
  8019d6:	e8 3f ff ff ff       	call   80191a <read>
		if (m < 0)
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	78 10                	js     8019ef <readn+0x43>
			return m;
		if (m == 0)
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	74 0a                	je     8019ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019e3:	01 c3                	add    %eax,%ebx
  8019e5:	39 f3                	cmp    %esi,%ebx
  8019e7:	72 d9                	jb     8019c2 <readn+0x16>
  8019e9:	89 d8                	mov    %ebx,%eax
  8019eb:	eb 02                	jmp    8019ef <readn+0x43>
  8019ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8019ef:	83 c4 1c             	add    $0x1c,%esp
  8019f2:	5b                   	pop    %ebx
  8019f3:	5e                   	pop    %esi
  8019f4:	5f                   	pop    %edi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    

008019f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 24             	sub    $0x24,%esp
  8019fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a08:	89 1c 24             	mov    %ebx,(%esp)
  801a0b:	e8 76 fc ff ff       	call   801686 <fd_lookup>
  801a10:	89 c2                	mov    %eax,%edx
  801a12:	85 d2                	test   %edx,%edx
  801a14:	78 68                	js     801a7e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a20:	8b 00                	mov    (%eax),%eax
  801a22:	89 04 24             	mov    %eax,(%esp)
  801a25:	e8 b2 fc ff ff       	call   8016dc <dev_lookup>
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 50                	js     801a7e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a35:	75 23                	jne    801a5a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a37:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a3c:	8b 40 48             	mov    0x48(%eax),%eax
  801a3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	c7 04 24 e9 32 80 00 	movl   $0x8032e9,(%esp)
  801a4e:	e8 18 e8 ff ff       	call   80026b <cprintf>
		return -E_INVAL;
  801a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a58:	eb 24                	jmp    801a7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a60:	85 d2                	test   %edx,%edx
  801a62:	74 15                	je     801a79 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	ff d2                	call   *%edx
  801a77:	eb 05                	jmp    801a7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a79:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a7e:	83 c4 24             	add    $0x24,%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    

00801a84 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	89 04 24             	mov    %eax,(%esp)
  801a97:	e8 ea fb ff ff       	call   801686 <fd_lookup>
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 0e                	js     801aae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 24             	sub    $0x24,%esp
  801ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac1:	89 1c 24             	mov    %ebx,(%esp)
  801ac4:	e8 bd fb ff ff       	call   801686 <fd_lookup>
  801ac9:	89 c2                	mov    %eax,%edx
  801acb:	85 d2                	test   %edx,%edx
  801acd:	78 61                	js     801b30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801acf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad9:	8b 00                	mov    (%eax),%eax
  801adb:	89 04 24             	mov    %eax,(%esp)
  801ade:	e8 f9 fb ff ff       	call   8016dc <dev_lookup>
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 49                	js     801b30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aee:	75 23                	jne    801b13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801af0:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801af5:	8b 40 48             	mov    0x48(%eax),%eax
  801af8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b00:	c7 04 24 ac 32 80 00 	movl   $0x8032ac,(%esp)
  801b07:	e8 5f e7 ff ff       	call   80026b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b11:	eb 1d                	jmp    801b30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b16:	8b 52 18             	mov    0x18(%edx),%edx
  801b19:	85 d2                	test   %edx,%edx
  801b1b:	74 0e                	je     801b2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b24:	89 04 24             	mov    %eax,(%esp)
  801b27:	ff d2                	call   *%edx
  801b29:	eb 05                	jmp    801b30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b30:	83 c4 24             	add    $0x24,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 24             	sub    $0x24,%esp
  801b3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	89 04 24             	mov    %eax,(%esp)
  801b4d:	e8 34 fb ff ff       	call   801686 <fd_lookup>
  801b52:	89 c2                	mov    %eax,%edx
  801b54:	85 d2                	test   %edx,%edx
  801b56:	78 52                	js     801baa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b62:	8b 00                	mov    (%eax),%eax
  801b64:	89 04 24             	mov    %eax,(%esp)
  801b67:	e8 70 fb ff ff       	call   8016dc <dev_lookup>
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 3a                	js     801baa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b77:	74 2c                	je     801ba5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b83:	00 00 00 
	stat->st_isdir = 0;
  801b86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b8d:	00 00 00 
	stat->st_dev = dev;
  801b90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b9d:	89 14 24             	mov    %edx,(%esp)
  801ba0:	ff 50 14             	call   *0x14(%eax)
  801ba3:	eb 05                	jmp    801baa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ba5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801baa:	83 c4 24             	add    $0x24,%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    

00801bb0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bbf:	00 
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	89 04 24             	mov    %eax,(%esp)
  801bc6:	e8 99 02 00 00       	call   801e64 <open>
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	85 db                	test   %ebx,%ebx
  801bcf:	78 1b                	js     801bec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd8:	89 1c 24             	mov    %ebx,(%esp)
  801bdb:	e8 56 ff ff ff       	call   801b36 <fstat>
  801be0:	89 c6                	mov    %eax,%esi
	close(fd);
  801be2:	89 1c 24             	mov    %ebx,(%esp)
  801be5:	e8 cd fb ff ff       	call   8017b7 <close>
	return r;
  801bea:	89 f0                	mov    %esi,%eax
}
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 10             	sub    $0x10,%esp
  801bfb:	89 c6                	mov    %eax,%esi
  801bfd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bff:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c06:	75 11                	jne    801c19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c0f:	e8 db 0e 00 00       	call   802aef <ipc_find_env>
  801c14:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c20:	00 
  801c21:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c28:	00 
  801c29:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c2d:	a1 00 50 80 00       	mov    0x805000,%eax
  801c32:	89 04 24             	mov    %eax,(%esp)
  801c35:	e8 4e 0e 00 00       	call   802a88 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c41:	00 
  801c42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c4d:	e8 ce 0d 00 00       	call   802a20 <ipc_recv>
}
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	8b 40 0c             	mov    0xc(%eax),%eax
  801c65:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c72:	ba 00 00 00 00       	mov    $0x0,%edx
  801c77:	b8 02 00 00 00       	mov    $0x2,%eax
  801c7c:	e8 72 ff ff ff       	call   801bf3 <fsipc>
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c94:	ba 00 00 00 00       	mov    $0x0,%edx
  801c99:	b8 06 00 00 00       	mov    $0x6,%eax
  801c9e:	e8 50 ff ff ff       	call   801bf3 <fsipc>
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	53                   	push   %ebx
  801ca9:	83 ec 14             	sub    $0x14,%esp
  801cac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cba:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801cc4:	e8 2a ff ff ff       	call   801bf3 <fsipc>
  801cc9:	89 c2                	mov    %eax,%edx
  801ccb:	85 d2                	test   %edx,%edx
  801ccd:	78 2b                	js     801cfa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ccf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cd6:	00 
  801cd7:	89 1c 24             	mov    %ebx,(%esp)
  801cda:	e8 08 ec ff ff       	call   8008e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cdf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ce4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cea:	a1 84 60 80 00       	mov    0x806084,%eax
  801cef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfa:	83 c4 14             	add    $0x14,%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    

00801d00 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	53                   	push   %ebx
  801d04:	83 ec 14             	sub    $0x14,%esp
  801d07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801d0a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801d10:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801d15:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d18:	8b 55 08             	mov    0x8(%ebp),%edx
  801d1b:	8b 52 0c             	mov    0xc(%edx),%edx
  801d1e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801d24:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801d29:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d34:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d3b:	e8 44 ed ff ff       	call   800a84 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801d40:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801d47:	00 
  801d48:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  801d4f:	e8 17 e5 ff ff       	call   80026b <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d54:	ba 00 00 00 00       	mov    $0x0,%edx
  801d59:	b8 04 00 00 00       	mov    $0x4,%eax
  801d5e:	e8 90 fe ff ff       	call   801bf3 <fsipc>
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 53                	js     801dba <devfile_write+0xba>
		return r;
	assert(r <= n);
  801d67:	39 c3                	cmp    %eax,%ebx
  801d69:	73 24                	jae    801d8f <devfile_write+0x8f>
  801d6b:	c7 44 24 0c 21 33 80 	movl   $0x803321,0xc(%esp)
  801d72:	00 
  801d73:	c7 44 24 08 28 33 80 	movl   $0x803328,0x8(%esp)
  801d7a:	00 
  801d7b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801d82:	00 
  801d83:	c7 04 24 3d 33 80 00 	movl   $0x80333d,(%esp)
  801d8a:	e8 e3 e3 ff ff       	call   800172 <_panic>
	assert(r <= PGSIZE);
  801d8f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d94:	7e 24                	jle    801dba <devfile_write+0xba>
  801d96:	c7 44 24 0c 48 33 80 	movl   $0x803348,0xc(%esp)
  801d9d:	00 
  801d9e:	c7 44 24 08 28 33 80 	movl   $0x803328,0x8(%esp)
  801da5:	00 
  801da6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801dad:	00 
  801dae:	c7 04 24 3d 33 80 00 	movl   $0x80333d,(%esp)
  801db5:	e8 b8 e3 ff ff       	call   800172 <_panic>
	return r;
}
  801dba:	83 c4 14             	add    $0x14,%esp
  801dbd:	5b                   	pop    %ebx
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    

00801dc0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	56                   	push   %esi
  801dc4:	53                   	push   %ebx
  801dc5:	83 ec 10             	sub    $0x10,%esp
  801dc8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dd6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  801de1:	b8 03 00 00 00       	mov    $0x3,%eax
  801de6:	e8 08 fe ff ff       	call   801bf3 <fsipc>
  801deb:	89 c3                	mov    %eax,%ebx
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 6a                	js     801e5b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801df1:	39 c6                	cmp    %eax,%esi
  801df3:	73 24                	jae    801e19 <devfile_read+0x59>
  801df5:	c7 44 24 0c 21 33 80 	movl   $0x803321,0xc(%esp)
  801dfc:	00 
  801dfd:	c7 44 24 08 28 33 80 	movl   $0x803328,0x8(%esp)
  801e04:	00 
  801e05:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801e0c:	00 
  801e0d:	c7 04 24 3d 33 80 00 	movl   $0x80333d,(%esp)
  801e14:	e8 59 e3 ff ff       	call   800172 <_panic>
	assert(r <= PGSIZE);
  801e19:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e1e:	7e 24                	jle    801e44 <devfile_read+0x84>
  801e20:	c7 44 24 0c 48 33 80 	movl   $0x803348,0xc(%esp)
  801e27:	00 
  801e28:	c7 44 24 08 28 33 80 	movl   $0x803328,0x8(%esp)
  801e2f:	00 
  801e30:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e37:	00 
  801e38:	c7 04 24 3d 33 80 00 	movl   $0x80333d,(%esp)
  801e3f:	e8 2e e3 ff ff       	call   800172 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e44:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e48:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e4f:	00 
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	89 04 24             	mov    %eax,(%esp)
  801e56:	e8 29 ec ff ff       	call   800a84 <memmove>
	return r;
}
  801e5b:	89 d8                	mov    %ebx,%eax
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5e                   	pop    %esi
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    

00801e64 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	53                   	push   %ebx
  801e68:	83 ec 24             	sub    $0x24,%esp
  801e6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e6e:	89 1c 24             	mov    %ebx,(%esp)
  801e71:	e8 3a ea ff ff       	call   8008b0 <strlen>
  801e76:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e7b:	7f 60                	jg     801edd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e80:	89 04 24             	mov    %eax,(%esp)
  801e83:	e8 af f7 ff ff       	call   801637 <fd_alloc>
  801e88:	89 c2                	mov    %eax,%edx
  801e8a:	85 d2                	test   %edx,%edx
  801e8c:	78 54                	js     801ee2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e92:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e99:	e8 49 ea ff ff       	call   8008e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea9:	b8 01 00 00 00       	mov    $0x1,%eax
  801eae:	e8 40 fd ff ff       	call   801bf3 <fsipc>
  801eb3:	89 c3                	mov    %eax,%ebx
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	79 17                	jns    801ed0 <open+0x6c>
		fd_close(fd, 0);
  801eb9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ec0:	00 
  801ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec4:	89 04 24             	mov    %eax,(%esp)
  801ec7:	e8 6a f8 ff ff       	call   801736 <fd_close>
		return r;
  801ecc:	89 d8                	mov    %ebx,%eax
  801ece:	eb 12                	jmp    801ee2 <open+0x7e>
	}

	return fd2num(fd);
  801ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed3:	89 04 24             	mov    %eax,(%esp)
  801ed6:	e8 35 f7 ff ff       	call   801610 <fd2num>
  801edb:	eb 05                	jmp    801ee2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801edd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ee2:	83 c4 24             	add    $0x24,%esp
  801ee5:	5b                   	pop    %ebx
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801eee:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef3:	b8 08 00 00 00       	mov    $0x8,%eax
  801ef8:	e8 f6 fc ff ff       	call   801bf3 <fsipc>
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <evict>:

int evict(void)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801f05:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801f0c:	e8 5a e3 ff ff       	call   80026b <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801f11:	ba 00 00 00 00       	mov    $0x0,%edx
  801f16:	b8 09 00 00 00       	mov    $0x9,%eax
  801f1b:	e8 d3 fc ff ff       	call   801bf3 <fsipc>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    
  801f22:	66 90                	xchg   %ax,%ax
  801f24:	66 90                	xchg   %ax,%ax
  801f26:	66 90                	xchg   %ax,%ax
  801f28:	66 90                	xchg   %ax,%ax
  801f2a:	66 90                	xchg   %ax,%ax
  801f2c:	66 90                	xchg   %ax,%ax
  801f2e:	66 90                	xchg   %ax,%ax

00801f30 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f36:	c7 44 24 04 6d 33 80 	movl   $0x80336d,0x4(%esp)
  801f3d:	00 
  801f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f41:	89 04 24             	mov    %eax,(%esp)
  801f44:	e8 9e e9 ff ff       	call   8008e7 <strcpy>
	return 0;
}
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	53                   	push   %ebx
  801f54:	83 ec 14             	sub    $0x14,%esp
  801f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f5a:	89 1c 24             	mov    %ebx,(%esp)
  801f5d:	e8 c5 0b 00 00       	call   802b27 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f62:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f67:	83 f8 01             	cmp    $0x1,%eax
  801f6a:	75 0d                	jne    801f79 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f6c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f6f:	89 04 24             	mov    %eax,(%esp)
  801f72:	e8 29 03 00 00       	call   8022a0 <nsipc_close>
  801f77:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f79:	89 d0                	mov    %edx,%eax
  801f7b:	83 c4 14             	add    $0x14,%esp
  801f7e:	5b                   	pop    %ebx
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    

00801f81 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f87:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f8e:	00 
  801f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa3:	89 04 24             	mov    %eax,(%esp)
  801fa6:	e8 f0 03 00 00       	call   80239b <nsipc_send>
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fba:	00 
  801fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcf:	89 04 24             	mov    %eax,(%esp)
  801fd2:	e8 44 03 00 00       	call   80231b <nsipc_recv>
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fdf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fe2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fe6:	89 04 24             	mov    %eax,(%esp)
  801fe9:	e8 98 f6 ff ff       	call   801686 <fd_lookup>
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	78 17                	js     802009 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ffb:	39 08                	cmp    %ecx,(%eax)
  801ffd:	75 05                	jne    802004 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801fff:	8b 40 0c             	mov    0xc(%eax),%eax
  802002:	eb 05                	jmp    802009 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802004:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	56                   	push   %esi
  80200f:	53                   	push   %ebx
  802010:	83 ec 20             	sub    $0x20,%esp
  802013:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802015:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802018:	89 04 24             	mov    %eax,(%esp)
  80201b:	e8 17 f6 ff ff       	call   801637 <fd_alloc>
  802020:	89 c3                	mov    %eax,%ebx
  802022:	85 c0                	test   %eax,%eax
  802024:	78 21                	js     802047 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802026:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80202d:	00 
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	89 44 24 04          	mov    %eax,0x4(%esp)
  802035:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80203c:	e8 14 ed ff ff       	call   800d55 <sys_page_alloc>
  802041:	89 c3                	mov    %eax,%ebx
  802043:	85 c0                	test   %eax,%eax
  802045:	79 0c                	jns    802053 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802047:	89 34 24             	mov    %esi,(%esp)
  80204a:	e8 51 02 00 00       	call   8022a0 <nsipc_close>
		return r;
  80204f:	89 d8                	mov    %ebx,%eax
  802051:	eb 20                	jmp    802073 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802053:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80205e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802061:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802068:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80206b:	89 14 24             	mov    %edx,(%esp)
  80206e:	e8 9d f5 ff ff       	call   801610 <fd2num>
}
  802073:	83 c4 20             	add    $0x20,%esp
  802076:	5b                   	pop    %ebx
  802077:	5e                   	pop    %esi
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    

0080207a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	e8 51 ff ff ff       	call   801fd9 <fd2sockid>
		return r;
  802088:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80208a:	85 c0                	test   %eax,%eax
  80208c:	78 23                	js     8020b1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80208e:	8b 55 10             	mov    0x10(%ebp),%edx
  802091:	89 54 24 08          	mov    %edx,0x8(%esp)
  802095:	8b 55 0c             	mov    0xc(%ebp),%edx
  802098:	89 54 24 04          	mov    %edx,0x4(%esp)
  80209c:	89 04 24             	mov    %eax,(%esp)
  80209f:	e8 45 01 00 00       	call   8021e9 <nsipc_accept>
		return r;
  8020a4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	78 07                	js     8020b1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8020aa:	e8 5c ff ff ff       	call   80200b <alloc_sockfd>
  8020af:	89 c1                	mov    %eax,%ecx
}
  8020b1:	89 c8                	mov    %ecx,%eax
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	e8 16 ff ff ff       	call   801fd9 <fd2sockid>
  8020c3:	89 c2                	mov    %eax,%edx
  8020c5:	85 d2                	test   %edx,%edx
  8020c7:	78 16                	js     8020df <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8020c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d7:	89 14 24             	mov    %edx,(%esp)
  8020da:	e8 60 01 00 00       	call   80223f <nsipc_bind>
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <shutdown>:

int
shutdown(int s, int how)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	e8 ea fe ff ff       	call   801fd9 <fd2sockid>
  8020ef:	89 c2                	mov    %eax,%edx
  8020f1:	85 d2                	test   %edx,%edx
  8020f3:	78 0f                	js     802104 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fc:	89 14 24             	mov    %edx,(%esp)
  8020ff:	e8 7a 01 00 00       	call   80227e <nsipc_shutdown>
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	e8 c5 fe ff ff       	call   801fd9 <fd2sockid>
  802114:	89 c2                	mov    %eax,%edx
  802116:	85 d2                	test   %edx,%edx
  802118:	78 16                	js     802130 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80211a:	8b 45 10             	mov    0x10(%ebp),%eax
  80211d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802121:	8b 45 0c             	mov    0xc(%ebp),%eax
  802124:	89 44 24 04          	mov    %eax,0x4(%esp)
  802128:	89 14 24             	mov    %edx,(%esp)
  80212b:	e8 8a 01 00 00       	call   8022ba <nsipc_connect>
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <listen>:

int
listen(int s, int backlog)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	e8 99 fe ff ff       	call   801fd9 <fd2sockid>
  802140:	89 c2                	mov    %eax,%edx
  802142:	85 d2                	test   %edx,%edx
  802144:	78 0f                	js     802155 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802146:	8b 45 0c             	mov    0xc(%ebp),%eax
  802149:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214d:	89 14 24             	mov    %edx,(%esp)
  802150:	e8 a4 01 00 00       	call   8022f9 <nsipc_listen>
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80215d:	8b 45 10             	mov    0x10(%ebp),%eax
  802160:	89 44 24 08          	mov    %eax,0x8(%esp)
  802164:	8b 45 0c             	mov    0xc(%ebp),%eax
  802167:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	89 04 24             	mov    %eax,(%esp)
  802171:	e8 98 02 00 00       	call   80240e <nsipc_socket>
  802176:	89 c2                	mov    %eax,%edx
  802178:	85 d2                	test   %edx,%edx
  80217a:	78 05                	js     802181 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80217c:	e8 8a fe ff ff       	call   80200b <alloc_sockfd>
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	53                   	push   %ebx
  802187:	83 ec 14             	sub    $0x14,%esp
  80218a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80218c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802193:	75 11                	jne    8021a6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802195:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80219c:	e8 4e 09 00 00       	call   802aef <ipc_find_env>
  8021a1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021a6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8021ad:	00 
  8021ae:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8021b5:	00 
  8021b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021ba:	a1 04 50 80 00       	mov    0x805004,%eax
  8021bf:	89 04 24             	mov    %eax,(%esp)
  8021c2:	e8 c1 08 00 00       	call   802a88 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021ce:	00 
  8021cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021d6:	00 
  8021d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021de:	e8 3d 08 00 00       	call   802a20 <ipc_recv>
}
  8021e3:	83 c4 14             	add    $0x14,%esp
  8021e6:	5b                   	pop    %ebx
  8021e7:	5d                   	pop    %ebp
  8021e8:	c3                   	ret    

008021e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	56                   	push   %esi
  8021ed:	53                   	push   %ebx
  8021ee:	83 ec 10             	sub    $0x10,%esp
  8021f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021fc:	8b 06                	mov    (%esi),%eax
  8021fe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802203:	b8 01 00 00 00       	mov    $0x1,%eax
  802208:	e8 76 ff ff ff       	call   802183 <nsipc>
  80220d:	89 c3                	mov    %eax,%ebx
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 23                	js     802236 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802213:	a1 10 70 80 00       	mov    0x807010,%eax
  802218:	89 44 24 08          	mov    %eax,0x8(%esp)
  80221c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802223:	00 
  802224:	8b 45 0c             	mov    0xc(%ebp),%eax
  802227:	89 04 24             	mov    %eax,(%esp)
  80222a:	e8 55 e8 ff ff       	call   800a84 <memmove>
		*addrlen = ret->ret_addrlen;
  80222f:	a1 10 70 80 00       	mov    0x807010,%eax
  802234:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802236:	89 d8                	mov    %ebx,%eax
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5e                   	pop    %esi
  80223d:	5d                   	pop    %ebp
  80223e:	c3                   	ret    

0080223f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	53                   	push   %ebx
  802243:	83 ec 14             	sub    $0x14,%esp
  802246:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802251:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802255:	8b 45 0c             	mov    0xc(%ebp),%eax
  802258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802263:	e8 1c e8 ff ff       	call   800a84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802268:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80226e:	b8 02 00 00 00       	mov    $0x2,%eax
  802273:	e8 0b ff ff ff       	call   802183 <nsipc>
}
  802278:	83 c4 14             	add    $0x14,%esp
  80227b:	5b                   	pop    %ebx
  80227c:	5d                   	pop    %ebp
  80227d:	c3                   	ret    

0080227e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80228c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802294:	b8 03 00 00 00       	mov    $0x3,%eax
  802299:	e8 e5 fe ff ff       	call   802183 <nsipc>
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8022b3:	e8 cb fe ff ff       	call   802183 <nsipc>
}
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	53                   	push   %ebx
  8022be:	83 ec 14             	sub    $0x14,%esp
  8022c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8022de:	e8 a1 e7 ff ff       	call   800a84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022e3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8022ee:	e8 90 fe ff ff       	call   802183 <nsipc>
}
  8022f3:	83 c4 14             	add    $0x14,%esp
  8022f6:	5b                   	pop    %ebx
  8022f7:	5d                   	pop    %ebp
  8022f8:	c3                   	ret    

008022f9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80230f:	b8 06 00 00 00       	mov    $0x6,%eax
  802314:	e8 6a fe ff ff       	call   802183 <nsipc>
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	56                   	push   %esi
  80231f:	53                   	push   %ebx
  802320:	83 ec 10             	sub    $0x10,%esp
  802323:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80232e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802334:	8b 45 14             	mov    0x14(%ebp),%eax
  802337:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80233c:	b8 07 00 00 00       	mov    $0x7,%eax
  802341:	e8 3d fe ff ff       	call   802183 <nsipc>
  802346:	89 c3                	mov    %eax,%ebx
  802348:	85 c0                	test   %eax,%eax
  80234a:	78 46                	js     802392 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80234c:	39 f0                	cmp    %esi,%eax
  80234e:	7f 07                	jg     802357 <nsipc_recv+0x3c>
  802350:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802355:	7e 24                	jle    80237b <nsipc_recv+0x60>
  802357:	c7 44 24 0c 79 33 80 	movl   $0x803379,0xc(%esp)
  80235e:	00 
  80235f:	c7 44 24 08 28 33 80 	movl   $0x803328,0x8(%esp)
  802366:	00 
  802367:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80236e:	00 
  80236f:	c7 04 24 8e 33 80 00 	movl   $0x80338e,(%esp)
  802376:	e8 f7 dd ff ff       	call   800172 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80237b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80237f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802386:	00 
  802387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238a:	89 04 24             	mov    %eax,(%esp)
  80238d:	e8 f2 e6 ff ff       	call   800a84 <memmove>
	}

	return r;
}
  802392:	89 d8                	mov    %ebx,%eax
  802394:	83 c4 10             	add    $0x10,%esp
  802397:	5b                   	pop    %ebx
  802398:	5e                   	pop    %esi
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    

0080239b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	53                   	push   %ebx
  80239f:	83 ec 14             	sub    $0x14,%esp
  8023a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023b3:	7e 24                	jle    8023d9 <nsipc_send+0x3e>
  8023b5:	c7 44 24 0c 9a 33 80 	movl   $0x80339a,0xc(%esp)
  8023bc:	00 
  8023bd:	c7 44 24 08 28 33 80 	movl   $0x803328,0x8(%esp)
  8023c4:	00 
  8023c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8023cc:	00 
  8023cd:	c7 04 24 8e 33 80 00 	movl   $0x80338e,(%esp)
  8023d4:	e8 99 dd ff ff       	call   800172 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8023eb:	e8 94 e6 ff ff       	call   800a84 <memmove>
	nsipcbuf.send.req_size = size;
  8023f0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023fe:	b8 08 00 00 00       	mov    $0x8,%eax
  802403:	e8 7b fd ff ff       	call   802183 <nsipc>
}
  802408:	83 c4 14             	add    $0x14,%esp
  80240b:	5b                   	pop    %ebx
  80240c:	5d                   	pop    %ebp
  80240d:	c3                   	ret    

0080240e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80241c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802424:	8b 45 10             	mov    0x10(%ebp),%eax
  802427:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80242c:	b8 09 00 00 00       	mov    $0x9,%eax
  802431:	e8 4d fd ff ff       	call   802183 <nsipc>
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	56                   	push   %esi
  80243c:	53                   	push   %ebx
  80243d:	83 ec 10             	sub    $0x10,%esp
  802440:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 d2 f1 ff ff       	call   801620 <fd2data>
  80244e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802450:	c7 44 24 04 a6 33 80 	movl   $0x8033a6,0x4(%esp)
  802457:	00 
  802458:	89 1c 24             	mov    %ebx,(%esp)
  80245b:	e8 87 e4 ff ff       	call   8008e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802460:	8b 46 04             	mov    0x4(%esi),%eax
  802463:	2b 06                	sub    (%esi),%eax
  802465:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80246b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802472:	00 00 00 
	stat->st_dev = &devpipe;
  802475:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80247c:	40 80 00 
	return 0;
}
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
  802484:	83 c4 10             	add    $0x10,%esp
  802487:	5b                   	pop    %ebx
  802488:	5e                   	pop    %esi
  802489:	5d                   	pop    %ebp
  80248a:	c3                   	ret    

0080248b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	53                   	push   %ebx
  80248f:	83 ec 14             	sub    $0x14,%esp
  802492:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802495:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802499:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a0:	e8 57 e9 ff ff       	call   800dfc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024a5:	89 1c 24             	mov    %ebx,(%esp)
  8024a8:	e8 73 f1 ff ff       	call   801620 <fd2data>
  8024ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b8:	e8 3f e9 ff ff       	call   800dfc <sys_page_unmap>
}
  8024bd:	83 c4 14             	add    $0x14,%esp
  8024c0:	5b                   	pop    %ebx
  8024c1:	5d                   	pop    %ebp
  8024c2:	c3                   	ret    

008024c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	57                   	push   %edi
  8024c7:	56                   	push   %esi
  8024c8:	53                   	push   %ebx
  8024c9:	83 ec 2c             	sub    $0x2c,%esp
  8024cc:	89 c6                	mov    %eax,%esi
  8024ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8024d1:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8024d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024d9:	89 34 24             	mov    %esi,(%esp)
  8024dc:	e8 46 06 00 00       	call   802b27 <pageref>
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e6:	89 04 24             	mov    %eax,(%esp)
  8024e9:	e8 39 06 00 00       	call   802b27 <pageref>
  8024ee:	39 c7                	cmp    %eax,%edi
  8024f0:	0f 94 c2             	sete   %dl
  8024f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8024f6:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  8024fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8024ff:	39 fb                	cmp    %edi,%ebx
  802501:	74 21                	je     802524 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802503:	84 d2                	test   %dl,%dl
  802505:	74 ca                	je     8024d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802507:	8b 51 58             	mov    0x58(%ecx),%edx
  80250a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80250e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802512:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802516:	c7 04 24 ad 33 80 00 	movl   $0x8033ad,(%esp)
  80251d:	e8 49 dd ff ff       	call   80026b <cprintf>
  802522:	eb ad                	jmp    8024d1 <_pipeisclosed+0xe>
	}
}
  802524:	83 c4 2c             	add    $0x2c,%esp
  802527:	5b                   	pop    %ebx
  802528:	5e                   	pop    %esi
  802529:	5f                   	pop    %edi
  80252a:	5d                   	pop    %ebp
  80252b:	c3                   	ret    

0080252c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	57                   	push   %edi
  802530:	56                   	push   %esi
  802531:	53                   	push   %ebx
  802532:	83 ec 1c             	sub    $0x1c,%esp
  802535:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802538:	89 34 24             	mov    %esi,(%esp)
  80253b:	e8 e0 f0 ff ff       	call   801620 <fd2data>
  802540:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802542:	bf 00 00 00 00       	mov    $0x0,%edi
  802547:	eb 45                	jmp    80258e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802549:	89 da                	mov    %ebx,%edx
  80254b:	89 f0                	mov    %esi,%eax
  80254d:	e8 71 ff ff ff       	call   8024c3 <_pipeisclosed>
  802552:	85 c0                	test   %eax,%eax
  802554:	75 41                	jne    802597 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802556:	e8 db e7 ff ff       	call   800d36 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80255b:	8b 43 04             	mov    0x4(%ebx),%eax
  80255e:	8b 0b                	mov    (%ebx),%ecx
  802560:	8d 51 20             	lea    0x20(%ecx),%edx
  802563:	39 d0                	cmp    %edx,%eax
  802565:	73 e2                	jae    802549 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802567:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80256a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80256e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802571:	99                   	cltd   
  802572:	c1 ea 1b             	shr    $0x1b,%edx
  802575:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802578:	83 e1 1f             	and    $0x1f,%ecx
  80257b:	29 d1                	sub    %edx,%ecx
  80257d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802581:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802585:	83 c0 01             	add    $0x1,%eax
  802588:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80258b:	83 c7 01             	add    $0x1,%edi
  80258e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802591:	75 c8                	jne    80255b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802593:	89 f8                	mov    %edi,%eax
  802595:	eb 05                	jmp    80259c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80259c:	83 c4 1c             	add    $0x1c,%esp
  80259f:	5b                   	pop    %ebx
  8025a0:	5e                   	pop    %esi
  8025a1:	5f                   	pop    %edi
  8025a2:	5d                   	pop    %ebp
  8025a3:	c3                   	ret    

008025a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
  8025a7:	57                   	push   %edi
  8025a8:	56                   	push   %esi
  8025a9:	53                   	push   %ebx
  8025aa:	83 ec 1c             	sub    $0x1c,%esp
  8025ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8025b0:	89 3c 24             	mov    %edi,(%esp)
  8025b3:	e8 68 f0 ff ff       	call   801620 <fd2data>
  8025b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025ba:	be 00 00 00 00       	mov    $0x0,%esi
  8025bf:	eb 3d                	jmp    8025fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8025c1:	85 f6                	test   %esi,%esi
  8025c3:	74 04                	je     8025c9 <devpipe_read+0x25>
				return i;
  8025c5:	89 f0                	mov    %esi,%eax
  8025c7:	eb 43                	jmp    80260c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025c9:	89 da                	mov    %ebx,%edx
  8025cb:	89 f8                	mov    %edi,%eax
  8025cd:	e8 f1 fe ff ff       	call   8024c3 <_pipeisclosed>
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	75 31                	jne    802607 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8025d6:	e8 5b e7 ff ff       	call   800d36 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8025db:	8b 03                	mov    (%ebx),%eax
  8025dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025e0:	74 df                	je     8025c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025e2:	99                   	cltd   
  8025e3:	c1 ea 1b             	shr    $0x1b,%edx
  8025e6:	01 d0                	add    %edx,%eax
  8025e8:	83 e0 1f             	and    $0x1f,%eax
  8025eb:	29 d0                	sub    %edx,%eax
  8025ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025fb:	83 c6 01             	add    $0x1,%esi
  8025fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802601:	75 d8                	jne    8025db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802603:	89 f0                	mov    %esi,%eax
  802605:	eb 05                	jmp    80260c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80260c:	83 c4 1c             	add    $0x1c,%esp
  80260f:	5b                   	pop    %ebx
  802610:	5e                   	pop    %esi
  802611:	5f                   	pop    %edi
  802612:	5d                   	pop    %ebp
  802613:	c3                   	ret    

00802614 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	56                   	push   %esi
  802618:	53                   	push   %ebx
  802619:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80261c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80261f:	89 04 24             	mov    %eax,(%esp)
  802622:	e8 10 f0 ff ff       	call   801637 <fd_alloc>
  802627:	89 c2                	mov    %eax,%edx
  802629:	85 d2                	test   %edx,%edx
  80262b:	0f 88 4d 01 00 00    	js     80277e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802631:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802638:	00 
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802640:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802647:	e8 09 e7 ff ff       	call   800d55 <sys_page_alloc>
  80264c:	89 c2                	mov    %eax,%edx
  80264e:	85 d2                	test   %edx,%edx
  802650:	0f 88 28 01 00 00    	js     80277e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802656:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802659:	89 04 24             	mov    %eax,(%esp)
  80265c:	e8 d6 ef ff ff       	call   801637 <fd_alloc>
  802661:	89 c3                	mov    %eax,%ebx
  802663:	85 c0                	test   %eax,%eax
  802665:	0f 88 fe 00 00 00    	js     802769 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80266b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802672:	00 
  802673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802676:	89 44 24 04          	mov    %eax,0x4(%esp)
  80267a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802681:	e8 cf e6 ff ff       	call   800d55 <sys_page_alloc>
  802686:	89 c3                	mov    %eax,%ebx
  802688:	85 c0                	test   %eax,%eax
  80268a:	0f 88 d9 00 00 00    	js     802769 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	89 04 24             	mov    %eax,(%esp)
  802696:	e8 85 ef ff ff       	call   801620 <fd2data>
  80269b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026a4:	00 
  8026a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b0:	e8 a0 e6 ff ff       	call   800d55 <sys_page_alloc>
  8026b5:	89 c3                	mov    %eax,%ebx
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	0f 88 97 00 00 00    	js     802756 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c2:	89 04 24             	mov    %eax,(%esp)
  8026c5:	e8 56 ef ff ff       	call   801620 <fd2data>
  8026ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026d1:	00 
  8026d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026dd:	00 
  8026de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e9:	e8 bb e6 ff ff       	call   800da9 <sys_page_map>
  8026ee:	89 c3                	mov    %eax,%ebx
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	78 52                	js     802746 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026f4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802709:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80270f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802712:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802717:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	89 04 24             	mov    %eax,(%esp)
  802724:	e8 e7 ee ff ff       	call   801610 <fd2num>
  802729:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80272c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	89 04 24             	mov    %eax,(%esp)
  802734:	e8 d7 ee ff ff       	call   801610 <fd2num>
  802739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80273c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80273f:	b8 00 00 00 00       	mov    $0x0,%eax
  802744:	eb 38                	jmp    80277e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802746:	89 74 24 04          	mov    %esi,0x4(%esp)
  80274a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802751:	e8 a6 e6 ff ff       	call   800dfc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	89 44 24 04          	mov    %eax,0x4(%esp)
  80275d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802764:	e8 93 e6 ff ff       	call   800dfc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802770:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802777:	e8 80 e6 ff ff       	call   800dfc <sys_page_unmap>
  80277c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80277e:	83 c4 30             	add    $0x30,%esp
  802781:	5b                   	pop    %ebx
  802782:	5e                   	pop    %esi
  802783:	5d                   	pop    %ebp
  802784:	c3                   	ret    

00802785 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80278b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80278e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	89 04 24             	mov    %eax,(%esp)
  802798:	e8 e9 ee ff ff       	call   801686 <fd_lookup>
  80279d:	89 c2                	mov    %eax,%edx
  80279f:	85 d2                	test   %edx,%edx
  8027a1:	78 15                	js     8027b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	89 04 24             	mov    %eax,(%esp)
  8027a9:	e8 72 ee ff ff       	call   801620 <fd2data>
	return _pipeisclosed(fd, p);
  8027ae:	89 c2                	mov    %eax,%edx
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	e8 0b fd ff ff       	call   8024c3 <_pipeisclosed>
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    
  8027ba:	66 90                	xchg   %ax,%ax
  8027bc:	66 90                	xchg   %ax,%ax
  8027be:	66 90                	xchg   %ax,%ax

008027c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c8:	5d                   	pop    %ebp
  8027c9:	c3                   	ret    

008027ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8027d0:	c7 44 24 04 c5 33 80 	movl   $0x8033c5,0x4(%esp)
  8027d7:	00 
  8027d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027db:	89 04 24             	mov    %eax,(%esp)
  8027de:	e8 04 e1 ff ff       	call   8008e7 <strcpy>
	return 0;
}
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	57                   	push   %edi
  8027ee:	56                   	push   %esi
  8027ef:	53                   	push   %ebx
  8027f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802801:	eb 31                	jmp    802834 <devcons_write+0x4a>
		m = n - tot;
  802803:	8b 75 10             	mov    0x10(%ebp),%esi
  802806:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802808:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80280b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802810:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802813:	89 74 24 08          	mov    %esi,0x8(%esp)
  802817:	03 45 0c             	add    0xc(%ebp),%eax
  80281a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281e:	89 3c 24             	mov    %edi,(%esp)
  802821:	e8 5e e2 ff ff       	call   800a84 <memmove>
		sys_cputs(buf, m);
  802826:	89 74 24 04          	mov    %esi,0x4(%esp)
  80282a:	89 3c 24             	mov    %edi,(%esp)
  80282d:	e8 04 e4 ff ff       	call   800c36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802832:	01 f3                	add    %esi,%ebx
  802834:	89 d8                	mov    %ebx,%eax
  802836:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802839:	72 c8                	jb     802803 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80283b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    

00802846 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802851:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802855:	75 07                	jne    80285e <devcons_read+0x18>
  802857:	eb 2a                	jmp    802883 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802859:	e8 d8 e4 ff ff       	call   800d36 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80285e:	66 90                	xchg   %ax,%ax
  802860:	e8 ef e3 ff ff       	call   800c54 <sys_cgetc>
  802865:	85 c0                	test   %eax,%eax
  802867:	74 f0                	je     802859 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802869:	85 c0                	test   %eax,%eax
  80286b:	78 16                	js     802883 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80286d:	83 f8 04             	cmp    $0x4,%eax
  802870:	74 0c                	je     80287e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802872:	8b 55 0c             	mov    0xc(%ebp),%edx
  802875:	88 02                	mov    %al,(%edx)
	return 1;
  802877:	b8 01 00 00 00       	mov    $0x1,%eax
  80287c:	eb 05                	jmp    802883 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80287e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802883:	c9                   	leave  
  802884:	c3                   	ret    

00802885 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
  802888:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802891:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802898:	00 
  802899:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80289c:	89 04 24             	mov    %eax,(%esp)
  80289f:	e8 92 e3 ff ff       	call   800c36 <sys_cputs>
}
  8028a4:	c9                   	leave  
  8028a5:	c3                   	ret    

008028a6 <getchar>:

int
getchar(void)
{
  8028a6:	55                   	push   %ebp
  8028a7:	89 e5                	mov    %esp,%ebp
  8028a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028b3:	00 
  8028b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c2:	e8 53 f0 ff ff       	call   80191a <read>
	if (r < 0)
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	78 0f                	js     8028da <getchar+0x34>
		return r;
	if (r < 1)
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	7e 06                	jle    8028d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8028cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8028d3:	eb 05                	jmp    8028da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8028d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8028da:	c9                   	leave  
  8028db:	c3                   	ret    

008028dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	89 04 24             	mov    %eax,(%esp)
  8028ef:	e8 92 ed ff ff       	call   801686 <fd_lookup>
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	78 11                	js     802909 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802901:	39 10                	cmp    %edx,(%eax)
  802903:	0f 94 c0             	sete   %al
  802906:	0f b6 c0             	movzbl %al,%eax
}
  802909:	c9                   	leave  
  80290a:	c3                   	ret    

0080290b <opencons>:

int
opencons(void)
{
  80290b:	55                   	push   %ebp
  80290c:	89 e5                	mov    %esp,%ebp
  80290e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802911:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802914:	89 04 24             	mov    %eax,(%esp)
  802917:	e8 1b ed ff ff       	call   801637 <fd_alloc>
		return r;
  80291c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80291e:	85 c0                	test   %eax,%eax
  802920:	78 40                	js     802962 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802922:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802929:	00 
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802931:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802938:	e8 18 e4 ff ff       	call   800d55 <sys_page_alloc>
		return r;
  80293d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80293f:	85 c0                	test   %eax,%eax
  802941:	78 1f                	js     802962 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802943:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802958:	89 04 24             	mov    %eax,(%esp)
  80295b:	e8 b0 ec ff ff       	call   801610 <fd2num>
  802960:	89 c2                	mov    %eax,%edx
}
  802962:	89 d0                	mov    %edx,%eax
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80296c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802973:	75 7a                	jne    8029ef <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802975:	e8 9d e3 ff ff       	call   800d17 <sys_getenvid>
  80297a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802981:	00 
  802982:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802989:	ee 
  80298a:	89 04 24             	mov    %eax,(%esp)
  80298d:	e8 c3 e3 ff ff       	call   800d55 <sys_page_alloc>
  802992:	85 c0                	test   %eax,%eax
  802994:	79 20                	jns    8029b6 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802996:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80299a:	c7 44 24 08 e9 31 80 	movl   $0x8031e9,0x8(%esp)
  8029a1:	00 
  8029a2:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8029a9:	00 
  8029aa:	c7 04 24 d1 33 80 00 	movl   $0x8033d1,(%esp)
  8029b1:	e8 bc d7 ff ff       	call   800172 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  8029b6:	e8 5c e3 ff ff       	call   800d17 <sys_getenvid>
  8029bb:	c7 44 24 04 f9 29 80 	movl   $0x8029f9,0x4(%esp)
  8029c2:	00 
  8029c3:	89 04 24             	mov    %eax,(%esp)
  8029c6:	e8 4a e5 ff ff       	call   800f15 <sys_env_set_pgfault_upcall>
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	79 20                	jns    8029ef <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  8029cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029d3:	c7 44 24 08 68 32 80 	movl   $0x803268,0x8(%esp)
  8029da:	00 
  8029db:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8029e2:	00 
  8029e3:	c7 04 24 d1 33 80 00 	movl   $0x8033d1,(%esp)
  8029ea:	e8 83 d7 ff ff       	call   800172 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029f7:	c9                   	leave  
  8029f8:	c3                   	ret    

008029f9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029f9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029fa:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029ff:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a01:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802a04:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802a08:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802a0c:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802a0f:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802a13:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802a15:	83 c4 08             	add    $0x8,%esp
	popal
  802a18:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802a19:	83 c4 04             	add    $0x4,%esp
	popfl
  802a1c:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a1d:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a1e:	c3                   	ret    
  802a1f:	90                   	nop

00802a20 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
  802a23:	56                   	push   %esi
  802a24:	53                   	push   %ebx
  802a25:	83 ec 10             	sub    $0x10,%esp
  802a28:	8b 75 08             	mov    0x8(%ebp),%esi
  802a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802a31:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802a33:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802a38:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a3b:	89 04 24             	mov    %eax,(%esp)
  802a3e:	e8 48 e5 ff ff       	call   800f8b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802a43:	85 c0                	test   %eax,%eax
  802a45:	75 26                	jne    802a6d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802a47:	85 f6                	test   %esi,%esi
  802a49:	74 0a                	je     802a55 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802a4b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802a50:	8b 40 74             	mov    0x74(%eax),%eax
  802a53:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802a55:	85 db                	test   %ebx,%ebx
  802a57:	74 0a                	je     802a63 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802a59:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802a5e:	8b 40 78             	mov    0x78(%eax),%eax
  802a61:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802a63:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802a68:	8b 40 70             	mov    0x70(%eax),%eax
  802a6b:	eb 14                	jmp    802a81 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802a6d:	85 f6                	test   %esi,%esi
  802a6f:	74 06                	je     802a77 <ipc_recv+0x57>
			*from_env_store = 0;
  802a71:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a77:	85 db                	test   %ebx,%ebx
  802a79:	74 06                	je     802a81 <ipc_recv+0x61>
			*perm_store = 0;
  802a7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802a81:	83 c4 10             	add    $0x10,%esp
  802a84:	5b                   	pop    %ebx
  802a85:	5e                   	pop    %esi
  802a86:	5d                   	pop    %ebp
  802a87:	c3                   	ret    

00802a88 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a88:	55                   	push   %ebp
  802a89:	89 e5                	mov    %esp,%ebp
  802a8b:	57                   	push   %edi
  802a8c:	56                   	push   %esi
  802a8d:	53                   	push   %ebx
  802a8e:	83 ec 1c             	sub    $0x1c,%esp
  802a91:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a94:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a97:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802a9a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802a9c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802aa1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  802aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802aab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802aaf:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ab3:	89 3c 24             	mov    %edi,(%esp)
  802ab6:	e8 ad e4 ff ff       	call   800f68 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802abb:	85 c0                	test   %eax,%eax
  802abd:	74 28                	je     802ae7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802abf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ac2:	74 1c                	je     802ae0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802ac4:	c7 44 24 08 e0 33 80 	movl   $0x8033e0,0x8(%esp)
  802acb:	00 
  802acc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802ad3:	00 
  802ad4:	c7 04 24 04 34 80 00 	movl   $0x803404,(%esp)
  802adb:	e8 92 d6 ff ff       	call   800172 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802ae0:	e8 51 e2 ff ff       	call   800d36 <sys_yield>
	}
  802ae5:	eb bd                	jmp    802aa4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802ae7:	83 c4 1c             	add    $0x1c,%esp
  802aea:	5b                   	pop    %ebx
  802aeb:	5e                   	pop    %esi
  802aec:	5f                   	pop    %edi
  802aed:	5d                   	pop    %ebp
  802aee:	c3                   	ret    

00802aef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802aef:	55                   	push   %ebp
  802af0:	89 e5                	mov    %esp,%ebp
  802af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802af5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802afa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802afd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b03:	8b 52 50             	mov    0x50(%edx),%edx
  802b06:	39 ca                	cmp    %ecx,%edx
  802b08:	75 0d                	jne    802b17 <ipc_find_env+0x28>
			return envs[i].env_id;
  802b0a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802b0d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802b12:	8b 40 40             	mov    0x40(%eax),%eax
  802b15:	eb 0e                	jmp    802b25 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b17:	83 c0 01             	add    $0x1,%eax
  802b1a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b1f:	75 d9                	jne    802afa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802b21:	66 b8 00 00          	mov    $0x0,%ax
}
  802b25:	5d                   	pop    %ebp
  802b26:	c3                   	ret    

00802b27 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b27:	55                   	push   %ebp
  802b28:	89 e5                	mov    %esp,%ebp
  802b2a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b2d:	89 d0                	mov    %edx,%eax
  802b2f:	c1 e8 16             	shr    $0x16,%eax
  802b32:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b39:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b3e:	f6 c1 01             	test   $0x1,%cl
  802b41:	74 1d                	je     802b60 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b43:	c1 ea 0c             	shr    $0xc,%edx
  802b46:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b4d:	f6 c2 01             	test   $0x1,%dl
  802b50:	74 0e                	je     802b60 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b52:	c1 ea 0c             	shr    $0xc,%edx
  802b55:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b5c:	ef 
  802b5d:	0f b7 c0             	movzwl %ax,%eax
}
  802b60:	5d                   	pop    %ebp
  802b61:	c3                   	ret    
  802b62:	66 90                	xchg   %ax,%ax
  802b64:	66 90                	xchg   %ax,%ax
  802b66:	66 90                	xchg   %ax,%ax
  802b68:	66 90                	xchg   %ax,%ax
  802b6a:	66 90                	xchg   %ax,%ax
  802b6c:	66 90                	xchg   %ax,%ax
  802b6e:	66 90                	xchg   %ax,%ax

00802b70 <__udivdi3>:
  802b70:	55                   	push   %ebp
  802b71:	57                   	push   %edi
  802b72:	56                   	push   %esi
  802b73:	83 ec 0c             	sub    $0xc,%esp
  802b76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b7a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b7e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b82:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b86:	85 c0                	test   %eax,%eax
  802b88:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b8c:	89 ea                	mov    %ebp,%edx
  802b8e:	89 0c 24             	mov    %ecx,(%esp)
  802b91:	75 2d                	jne    802bc0 <__udivdi3+0x50>
  802b93:	39 e9                	cmp    %ebp,%ecx
  802b95:	77 61                	ja     802bf8 <__udivdi3+0x88>
  802b97:	85 c9                	test   %ecx,%ecx
  802b99:	89 ce                	mov    %ecx,%esi
  802b9b:	75 0b                	jne    802ba8 <__udivdi3+0x38>
  802b9d:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba2:	31 d2                	xor    %edx,%edx
  802ba4:	f7 f1                	div    %ecx
  802ba6:	89 c6                	mov    %eax,%esi
  802ba8:	31 d2                	xor    %edx,%edx
  802baa:	89 e8                	mov    %ebp,%eax
  802bac:	f7 f6                	div    %esi
  802bae:	89 c5                	mov    %eax,%ebp
  802bb0:	89 f8                	mov    %edi,%eax
  802bb2:	f7 f6                	div    %esi
  802bb4:	89 ea                	mov    %ebp,%edx
  802bb6:	83 c4 0c             	add    $0xc,%esp
  802bb9:	5e                   	pop    %esi
  802bba:	5f                   	pop    %edi
  802bbb:	5d                   	pop    %ebp
  802bbc:	c3                   	ret    
  802bbd:	8d 76 00             	lea    0x0(%esi),%esi
  802bc0:	39 e8                	cmp    %ebp,%eax
  802bc2:	77 24                	ja     802be8 <__udivdi3+0x78>
  802bc4:	0f bd e8             	bsr    %eax,%ebp
  802bc7:	83 f5 1f             	xor    $0x1f,%ebp
  802bca:	75 3c                	jne    802c08 <__udivdi3+0x98>
  802bcc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802bd0:	39 34 24             	cmp    %esi,(%esp)
  802bd3:	0f 86 9f 00 00 00    	jbe    802c78 <__udivdi3+0x108>
  802bd9:	39 d0                	cmp    %edx,%eax
  802bdb:	0f 82 97 00 00 00    	jb     802c78 <__udivdi3+0x108>
  802be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802be8:	31 d2                	xor    %edx,%edx
  802bea:	31 c0                	xor    %eax,%eax
  802bec:	83 c4 0c             	add    $0xc,%esp
  802bef:	5e                   	pop    %esi
  802bf0:	5f                   	pop    %edi
  802bf1:	5d                   	pop    %ebp
  802bf2:	c3                   	ret    
  802bf3:	90                   	nop
  802bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bf8:	89 f8                	mov    %edi,%eax
  802bfa:	f7 f1                	div    %ecx
  802bfc:	31 d2                	xor    %edx,%edx
  802bfe:	83 c4 0c             	add    $0xc,%esp
  802c01:	5e                   	pop    %esi
  802c02:	5f                   	pop    %edi
  802c03:	5d                   	pop    %ebp
  802c04:	c3                   	ret    
  802c05:	8d 76 00             	lea    0x0(%esi),%esi
  802c08:	89 e9                	mov    %ebp,%ecx
  802c0a:	8b 3c 24             	mov    (%esp),%edi
  802c0d:	d3 e0                	shl    %cl,%eax
  802c0f:	89 c6                	mov    %eax,%esi
  802c11:	b8 20 00 00 00       	mov    $0x20,%eax
  802c16:	29 e8                	sub    %ebp,%eax
  802c18:	89 c1                	mov    %eax,%ecx
  802c1a:	d3 ef                	shr    %cl,%edi
  802c1c:	89 e9                	mov    %ebp,%ecx
  802c1e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c22:	8b 3c 24             	mov    (%esp),%edi
  802c25:	09 74 24 08          	or     %esi,0x8(%esp)
  802c29:	89 d6                	mov    %edx,%esi
  802c2b:	d3 e7                	shl    %cl,%edi
  802c2d:	89 c1                	mov    %eax,%ecx
  802c2f:	89 3c 24             	mov    %edi,(%esp)
  802c32:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c36:	d3 ee                	shr    %cl,%esi
  802c38:	89 e9                	mov    %ebp,%ecx
  802c3a:	d3 e2                	shl    %cl,%edx
  802c3c:	89 c1                	mov    %eax,%ecx
  802c3e:	d3 ef                	shr    %cl,%edi
  802c40:	09 d7                	or     %edx,%edi
  802c42:	89 f2                	mov    %esi,%edx
  802c44:	89 f8                	mov    %edi,%eax
  802c46:	f7 74 24 08          	divl   0x8(%esp)
  802c4a:	89 d6                	mov    %edx,%esi
  802c4c:	89 c7                	mov    %eax,%edi
  802c4e:	f7 24 24             	mull   (%esp)
  802c51:	39 d6                	cmp    %edx,%esi
  802c53:	89 14 24             	mov    %edx,(%esp)
  802c56:	72 30                	jb     802c88 <__udivdi3+0x118>
  802c58:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c5c:	89 e9                	mov    %ebp,%ecx
  802c5e:	d3 e2                	shl    %cl,%edx
  802c60:	39 c2                	cmp    %eax,%edx
  802c62:	73 05                	jae    802c69 <__udivdi3+0xf9>
  802c64:	3b 34 24             	cmp    (%esp),%esi
  802c67:	74 1f                	je     802c88 <__udivdi3+0x118>
  802c69:	89 f8                	mov    %edi,%eax
  802c6b:	31 d2                	xor    %edx,%edx
  802c6d:	e9 7a ff ff ff       	jmp    802bec <__udivdi3+0x7c>
  802c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c78:	31 d2                	xor    %edx,%edx
  802c7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c7f:	e9 68 ff ff ff       	jmp    802bec <__udivdi3+0x7c>
  802c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c88:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c8b:	31 d2                	xor    %edx,%edx
  802c8d:	83 c4 0c             	add    $0xc,%esp
  802c90:	5e                   	pop    %esi
  802c91:	5f                   	pop    %edi
  802c92:	5d                   	pop    %ebp
  802c93:	c3                   	ret    
  802c94:	66 90                	xchg   %ax,%ax
  802c96:	66 90                	xchg   %ax,%ax
  802c98:	66 90                	xchg   %ax,%ax
  802c9a:	66 90                	xchg   %ax,%ax
  802c9c:	66 90                	xchg   %ax,%ax
  802c9e:	66 90                	xchg   %ax,%ax

00802ca0 <__umoddi3>:
  802ca0:	55                   	push   %ebp
  802ca1:	57                   	push   %edi
  802ca2:	56                   	push   %esi
  802ca3:	83 ec 14             	sub    $0x14,%esp
  802ca6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802caa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802cb2:	89 c7                	mov    %eax,%edi
  802cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cb8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cbc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802cc0:	89 34 24             	mov    %esi,(%esp)
  802cc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	89 c2                	mov    %eax,%edx
  802ccb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ccf:	75 17                	jne    802ce8 <__umoddi3+0x48>
  802cd1:	39 fe                	cmp    %edi,%esi
  802cd3:	76 4b                	jbe    802d20 <__umoddi3+0x80>
  802cd5:	89 c8                	mov    %ecx,%eax
  802cd7:	89 fa                	mov    %edi,%edx
  802cd9:	f7 f6                	div    %esi
  802cdb:	89 d0                	mov    %edx,%eax
  802cdd:	31 d2                	xor    %edx,%edx
  802cdf:	83 c4 14             	add    $0x14,%esp
  802ce2:	5e                   	pop    %esi
  802ce3:	5f                   	pop    %edi
  802ce4:	5d                   	pop    %ebp
  802ce5:	c3                   	ret    
  802ce6:	66 90                	xchg   %ax,%ax
  802ce8:	39 f8                	cmp    %edi,%eax
  802cea:	77 54                	ja     802d40 <__umoddi3+0xa0>
  802cec:	0f bd e8             	bsr    %eax,%ebp
  802cef:	83 f5 1f             	xor    $0x1f,%ebp
  802cf2:	75 5c                	jne    802d50 <__umoddi3+0xb0>
  802cf4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802cf8:	39 3c 24             	cmp    %edi,(%esp)
  802cfb:	0f 87 e7 00 00 00    	ja     802de8 <__umoddi3+0x148>
  802d01:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d05:	29 f1                	sub    %esi,%ecx
  802d07:	19 c7                	sbb    %eax,%edi
  802d09:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d11:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d15:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d19:	83 c4 14             	add    $0x14,%esp
  802d1c:	5e                   	pop    %esi
  802d1d:	5f                   	pop    %edi
  802d1e:	5d                   	pop    %ebp
  802d1f:	c3                   	ret    
  802d20:	85 f6                	test   %esi,%esi
  802d22:	89 f5                	mov    %esi,%ebp
  802d24:	75 0b                	jne    802d31 <__umoddi3+0x91>
  802d26:	b8 01 00 00 00       	mov    $0x1,%eax
  802d2b:	31 d2                	xor    %edx,%edx
  802d2d:	f7 f6                	div    %esi
  802d2f:	89 c5                	mov    %eax,%ebp
  802d31:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d35:	31 d2                	xor    %edx,%edx
  802d37:	f7 f5                	div    %ebp
  802d39:	89 c8                	mov    %ecx,%eax
  802d3b:	f7 f5                	div    %ebp
  802d3d:	eb 9c                	jmp    802cdb <__umoddi3+0x3b>
  802d3f:	90                   	nop
  802d40:	89 c8                	mov    %ecx,%eax
  802d42:	89 fa                	mov    %edi,%edx
  802d44:	83 c4 14             	add    $0x14,%esp
  802d47:	5e                   	pop    %esi
  802d48:	5f                   	pop    %edi
  802d49:	5d                   	pop    %ebp
  802d4a:	c3                   	ret    
  802d4b:	90                   	nop
  802d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d50:	8b 04 24             	mov    (%esp),%eax
  802d53:	be 20 00 00 00       	mov    $0x20,%esi
  802d58:	89 e9                	mov    %ebp,%ecx
  802d5a:	29 ee                	sub    %ebp,%esi
  802d5c:	d3 e2                	shl    %cl,%edx
  802d5e:	89 f1                	mov    %esi,%ecx
  802d60:	d3 e8                	shr    %cl,%eax
  802d62:	89 e9                	mov    %ebp,%ecx
  802d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d68:	8b 04 24             	mov    (%esp),%eax
  802d6b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d6f:	89 fa                	mov    %edi,%edx
  802d71:	d3 e0                	shl    %cl,%eax
  802d73:	89 f1                	mov    %esi,%ecx
  802d75:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d79:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d7d:	d3 ea                	shr    %cl,%edx
  802d7f:	89 e9                	mov    %ebp,%ecx
  802d81:	d3 e7                	shl    %cl,%edi
  802d83:	89 f1                	mov    %esi,%ecx
  802d85:	d3 e8                	shr    %cl,%eax
  802d87:	89 e9                	mov    %ebp,%ecx
  802d89:	09 f8                	or     %edi,%eax
  802d8b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d8f:	f7 74 24 04          	divl   0x4(%esp)
  802d93:	d3 e7                	shl    %cl,%edi
  802d95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d99:	89 d7                	mov    %edx,%edi
  802d9b:	f7 64 24 08          	mull   0x8(%esp)
  802d9f:	39 d7                	cmp    %edx,%edi
  802da1:	89 c1                	mov    %eax,%ecx
  802da3:	89 14 24             	mov    %edx,(%esp)
  802da6:	72 2c                	jb     802dd4 <__umoddi3+0x134>
  802da8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802dac:	72 22                	jb     802dd0 <__umoddi3+0x130>
  802dae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802db2:	29 c8                	sub    %ecx,%eax
  802db4:	19 d7                	sbb    %edx,%edi
  802db6:	89 e9                	mov    %ebp,%ecx
  802db8:	89 fa                	mov    %edi,%edx
  802dba:	d3 e8                	shr    %cl,%eax
  802dbc:	89 f1                	mov    %esi,%ecx
  802dbe:	d3 e2                	shl    %cl,%edx
  802dc0:	89 e9                	mov    %ebp,%ecx
  802dc2:	d3 ef                	shr    %cl,%edi
  802dc4:	09 d0                	or     %edx,%eax
  802dc6:	89 fa                	mov    %edi,%edx
  802dc8:	83 c4 14             	add    $0x14,%esp
  802dcb:	5e                   	pop    %esi
  802dcc:	5f                   	pop    %edi
  802dcd:	5d                   	pop    %ebp
  802dce:	c3                   	ret    
  802dcf:	90                   	nop
  802dd0:	39 d7                	cmp    %edx,%edi
  802dd2:	75 da                	jne    802dae <__umoddi3+0x10e>
  802dd4:	8b 14 24             	mov    (%esp),%edx
  802dd7:	89 c1                	mov    %eax,%ecx
  802dd9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802ddd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802de1:	eb cb                	jmp    802dae <__umoddi3+0x10e>
  802de3:	90                   	nop
  802de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802de8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802dec:	0f 82 0f ff ff ff    	jb     802d01 <__umoddi3+0x61>
  802df2:	e9 1a ff ff ff       	jmp    802d11 <__umoddi3+0x71>
