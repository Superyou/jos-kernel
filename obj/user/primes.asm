
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 17 01 00 00       	call   800148 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800046:	00 
  800047:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004e:	00 
  80004f:	89 34 24             	mov    %esi,(%esp)
  800052:	e8 e9 15 00 00       	call   801640 <ipc_recv>
  800057:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800059:	a1 08 50 80 00       	mov    0x805008,%eax
  80005e:	8b 40 5c             	mov    0x5c(%eax),%eax
  800061:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	c7 04 24 40 2e 80 00 	movl   $0x802e40,(%esp)
  800070:	e8 2d 02 00 00       	call   8002a2 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800075:	e8 25 12 00 00       	call   80129f <fork>
  80007a:	89 c7                	mov    %eax,%edi
  80007c:	85 c0                	test   %eax,%eax
  80007e:	79 20                	jns    8000a0 <primeproc+0x6d>
		panic("fork: %e", id);
  800080:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800084:	c7 44 24 08 4c 2e 80 	movl   $0x802e4c,0x8(%esp)
  80008b:	00 
  80008c:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800093:	00 
  800094:	c7 04 24 55 2e 80 00 	movl   $0x802e55,(%esp)
  80009b:	e8 09 01 00 00       	call   8001a9 <_panic>
	if (id == 0)
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	74 9b                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000a4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ae:	00 
  8000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b6:	00 
  8000b7:	89 34 24             	mov    %esi,(%esp)
  8000ba:	e8 81 15 00 00       	call   801640 <ipc_recv>
  8000bf:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000c1:	99                   	cltd   
  8000c2:	f7 fb                	idiv   %ebx
  8000c4:	85 d2                	test   %edx,%edx
  8000c6:	74 df                	je     8000a7 <primeproc+0x74>
			ipc_send(id, i, 0, 0);
  8000c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000d7:	00 
  8000d8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000dc:	89 3c 24             	mov    %edi,(%esp)
  8000df:	e8 c4 15 00 00       	call   8016a8 <ipc_send>
  8000e4:	eb c1                	jmp    8000a7 <primeproc+0x74>

008000e6 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ee:	e8 ac 11 00 00       	call   80129f <fork>
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	79 20                	jns    800119 <umain+0x33>
		panic("fork: %e", id);
  8000f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fd:	c7 44 24 08 4c 2e 80 	movl   $0x802e4c,0x8(%esp)
  800104:	00 
  800105:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  80010c:	00 
  80010d:	c7 04 24 55 2e 80 00 	movl   $0x802e55,(%esp)
  800114:	e8 90 00 00 00       	call   8001a9 <_panic>
	if (id == 0)
  800119:	bb 02 00 00 00       	mov    $0x2,%ebx
  80011e:	85 c0                	test   %eax,%eax
  800120:	75 05                	jne    800127 <umain+0x41>
		primeproc();
  800122:	e8 0c ff ff ff       	call   800033 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  800127:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80012e:	00 
  80012f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800136:	00 
  800137:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80013b:	89 34 24             	mov    %esi,(%esp)
  80013e:	e8 65 15 00 00       	call   8016a8 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  800143:	83 c3 01             	add    $0x1,%ebx
  800146:	eb df                	jmp    800127 <umain+0x41>

00800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
  80014d:	83 ec 10             	sub    $0x10,%esp
  800150:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800153:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800156:	e8 ec 0b 00 00       	call   800d47 <sys_getenvid>
  80015b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800160:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016d:	85 db                	test   %ebx,%ebx
  80016f:	7e 07                	jle    800178 <libmain+0x30>
		binaryname = argv[0];
  800171:	8b 06                	mov    (%esi),%eax
  800173:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800178:	89 74 24 04          	mov    %esi,0x4(%esp)
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 62 ff ff ff       	call   8000e6 <umain>

	// exit gracefully
	exit();
  800184:	e8 07 00 00 00       	call   800190 <exit>
}
  800189:	83 c4 10             	add    $0x10,%esp
  80018c:	5b                   	pop    %ebx
  80018d:	5e                   	pop    %esi
  80018e:	5d                   	pop    %ebp
  80018f:	c3                   	ret    

00800190 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800196:	e8 8f 17 00 00       	call   80192a <close_all>
	sys_env_destroy(0);
  80019b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a2:	e8 fc 0a 00 00       	call   800ca3 <sys_env_destroy>
}
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    

008001a9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001b1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001b4:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001ba:	e8 88 0b 00 00       	call   800d47 <sys_getenvid>
  8001bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001cd:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d5:	c7 04 24 70 2e 80 00 	movl   $0x802e70,(%esp)
  8001dc:	e8 c1 00 00 00       	call   8002a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001e1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e8:	89 04 24             	mov    %eax,(%esp)
  8001eb:	e8 51 00 00 00       	call   800241 <vcprintf>
	cprintf("\n");
  8001f0:	c7 04 24 bb 33 80 00 	movl   $0x8033bb,(%esp)
  8001f7:	e8 a6 00 00 00       	call   8002a2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001fc:	cc                   	int3   
  8001fd:	eb fd                	jmp    8001fc <_panic+0x53>

008001ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	53                   	push   %ebx
  800203:	83 ec 14             	sub    $0x14,%esp
  800206:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800209:	8b 13                	mov    (%ebx),%edx
  80020b:	8d 42 01             	lea    0x1(%edx),%eax
  80020e:	89 03                	mov    %eax,(%ebx)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	75 19                	jne    800237 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80021e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800225:	00 
  800226:	8d 43 08             	lea    0x8(%ebx),%eax
  800229:	89 04 24             	mov    %eax,(%esp)
  80022c:	e8 35 0a 00 00       	call   800c66 <sys_cputs>
		b->idx = 0;
  800231:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800237:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80023b:	83 c4 14             	add    $0x14,%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5d                   	pop    %ebp
  800240:	c3                   	ret    

00800241 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80024a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800251:	00 00 00 
	b.cnt = 0;
  800254:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800261:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800265:	8b 45 08             	mov    0x8(%ebp),%eax
  800268:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800272:	89 44 24 04          	mov    %eax,0x4(%esp)
  800276:	c7 04 24 ff 01 80 00 	movl   $0x8001ff,(%esp)
  80027d:	e8 72 01 00 00       	call   8003f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800282:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800292:	89 04 24             	mov    %eax,(%esp)
  800295:	e8 cc 09 00 00       	call   800c66 <sys_cputs>

	return b.cnt;
}
  80029a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002af:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b2:	89 04 24             	mov    %eax,(%esp)
  8002b5:	e8 87 ff ff ff       	call   800241 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    
  8002bc:	66 90                	xchg   %ax,%ax
  8002be:	66 90                	xchg   %ax,%ax

008002c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	83 ec 3c             	sub    $0x3c,%esp
  8002c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002cc:	89 d7                	mov    %edx,%edi
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 c3                	mov    %eax,%ebx
  8002d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002ed:	39 d9                	cmp    %ebx,%ecx
  8002ef:	72 05                	jb     8002f6 <printnum+0x36>
  8002f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f4:	77 69                	ja     80035f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002fd:	83 ee 01             	sub    $0x1,%esi
  800300:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800304:	89 44 24 08          	mov    %eax,0x8(%esp)
  800308:	8b 44 24 08          	mov    0x8(%esp),%eax
  80030c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800310:	89 c3                	mov    %eax,%ebx
  800312:	89 d6                	mov    %edx,%esi
  800314:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800317:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80031a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80031e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	e8 6c 28 00 00       	call   802ba0 <__udivdi3>
  800334:	89 d9                	mov    %ebx,%ecx
  800336:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80033a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80033e:	89 04 24             	mov    %eax,(%esp)
  800341:	89 54 24 04          	mov    %edx,0x4(%esp)
  800345:	89 fa                	mov    %edi,%edx
  800347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80034a:	e8 71 ff ff ff       	call   8002c0 <printnum>
  80034f:	eb 1b                	jmp    80036c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800351:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800355:	8b 45 18             	mov    0x18(%ebp),%eax
  800358:	89 04 24             	mov    %eax,(%esp)
  80035b:	ff d3                	call   *%ebx
  80035d:	eb 03                	jmp    800362 <printnum+0xa2>
  80035f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800362:	83 ee 01             	sub    $0x1,%esi
  800365:	85 f6                	test   %esi,%esi
  800367:	7f e8                	jg     800351 <printnum+0x91>
  800369:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80036c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800370:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800374:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800377:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80037a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80037e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038f:	e8 3c 29 00 00       	call   802cd0 <__umoddi3>
  800394:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800398:	0f be 80 93 2e 80 00 	movsbl 0x802e93(%eax),%eax
  80039f:	89 04 24             	mov    %eax,(%esp)
  8003a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a5:	ff d0                	call   *%eax
}
  8003a7:	83 c4 3c             	add    $0x3c,%esp
  8003aa:	5b                   	pop    %ebx
  8003ab:	5e                   	pop    %esi
  8003ac:	5f                   	pop    %edi
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b9:	8b 10                	mov    (%eax),%edx
  8003bb:	3b 50 04             	cmp    0x4(%eax),%edx
  8003be:	73 0a                	jae    8003ca <sprintputch+0x1b>
		*b->buf++ = ch;
  8003c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003c3:	89 08                	mov    %ecx,(%eax)
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	88 02                	mov    %al,(%edx)
}
  8003ca:	5d                   	pop    %ebp
  8003cb:	c3                   	ret    

008003cc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003d2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	89 04 24             	mov    %eax,(%esp)
  8003ed:	e8 02 00 00 00       	call   8003f4 <vprintfmt>
	va_end(ap);
}
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	57                   	push   %edi
  8003f8:	56                   	push   %esi
  8003f9:	53                   	push   %ebx
  8003fa:	83 ec 3c             	sub    $0x3c,%esp
  8003fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800400:	eb 17                	jmp    800419 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800402:	85 c0                	test   %eax,%eax
  800404:	0f 84 4b 04 00 00    	je     800855 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80040a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80040d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800417:	89 fb                	mov    %edi,%ebx
  800419:	8d 7b 01             	lea    0x1(%ebx),%edi
  80041c:	0f b6 03             	movzbl (%ebx),%eax
  80041f:	83 f8 25             	cmp    $0x25,%eax
  800422:	75 de                	jne    800402 <vprintfmt+0xe>
  800424:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800428:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80042f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800434:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80043b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800440:	eb 18                	jmp    80045a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800442:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800444:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800448:	eb 10                	jmp    80045a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80044c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800450:	eb 08                	jmp    80045a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800452:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800455:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80045d:	0f b6 17             	movzbl (%edi),%edx
  800460:	0f b6 c2             	movzbl %dl,%eax
  800463:	83 ea 23             	sub    $0x23,%edx
  800466:	80 fa 55             	cmp    $0x55,%dl
  800469:	0f 87 c2 03 00 00    	ja     800831 <vprintfmt+0x43d>
  80046f:	0f b6 d2             	movzbl %dl,%edx
  800472:	ff 24 95 e0 2f 80 00 	jmp    *0x802fe0(,%edx,4)
  800479:	89 df                	mov    %ebx,%edi
  80047b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800480:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800483:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800487:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80048a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80048d:	83 fa 09             	cmp    $0x9,%edx
  800490:	77 33                	ja     8004c5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800492:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800495:	eb e9                	jmp    800480 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8b 30                	mov    (%eax),%esi
  80049c:	8d 40 04             	lea    0x4(%eax),%eax
  80049f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004a4:	eb 1f                	jmp    8004c5 <vprintfmt+0xd1>
  8004a6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004a9:	85 ff                	test   %edi,%edi
  8004ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b0:	0f 49 c7             	cmovns %edi,%eax
  8004b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	89 df                	mov    %ebx,%edi
  8004b8:	eb a0                	jmp    80045a <vprintfmt+0x66>
  8004ba:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004bc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8004c3:	eb 95                	jmp    80045a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8004c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c9:	79 8f                	jns    80045a <vprintfmt+0x66>
  8004cb:	eb 85                	jmp    800452 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004cd:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004d2:	eb 86                	jmp    80045a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 70 04             	lea    0x4(%eax),%esi
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 04 24             	mov    %eax,(%esp)
  8004e9:	ff 55 08             	call   *0x8(%ebp)
  8004ec:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8004ef:	e9 25 ff ff ff       	jmp    800419 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8d 70 04             	lea    0x4(%eax),%esi
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	99                   	cltd   
  8004fd:	31 d0                	xor    %edx,%eax
  8004ff:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800501:	83 f8 15             	cmp    $0x15,%eax
  800504:	7f 0b                	jg     800511 <vprintfmt+0x11d>
  800506:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  80050d:	85 d2                	test   %edx,%edx
  80050f:	75 26                	jne    800537 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800511:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800515:	c7 44 24 08 ab 2e 80 	movl   $0x802eab,0x8(%esp)
  80051c:	00 
  80051d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800520:	89 44 24 04          	mov    %eax,0x4(%esp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	89 04 24             	mov    %eax,(%esp)
  80052a:	e8 9d fe ff ff       	call   8003cc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80052f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800532:	e9 e2 fe ff ff       	jmp    800419 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800537:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80053b:	c7 44 24 08 8a 33 80 	movl   $0x80338a,0x8(%esp)
  800542:	00 
  800543:	8b 45 0c             	mov    0xc(%ebp),%eax
  800546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	89 04 24             	mov    %eax,(%esp)
  800550:	e8 77 fe ff ff       	call   8003cc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800555:	89 75 14             	mov    %esi,0x14(%ebp)
  800558:	e9 bc fe ff ff       	jmp    800419 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800563:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800566:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80056a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056c:	85 ff                	test   %edi,%edi
  80056e:	b8 a4 2e 80 00       	mov    $0x802ea4,%eax
  800573:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800576:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80057a:	0f 84 94 00 00 00    	je     800614 <vprintfmt+0x220>
  800580:	85 c9                	test   %ecx,%ecx
  800582:	0f 8e 94 00 00 00    	jle    80061c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800588:	89 74 24 04          	mov    %esi,0x4(%esp)
  80058c:	89 3c 24             	mov    %edi,(%esp)
  80058f:	e8 64 03 00 00       	call   8008f8 <strnlen>
  800594:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800597:	29 c1                	sub    %eax,%ecx
  800599:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80059c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8005a0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8005a3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005ac:	89 cb                	mov    %ecx,%ebx
  8005ae:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	eb 0f                	jmp    8005c1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8005b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b9:	89 3c 24             	mov    %edi,(%esp)
  8005bc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005be:	83 eb 01             	sub    $0x1,%ebx
  8005c1:	85 db                	test   %ebx,%ebx
  8005c3:	7f ed                	jg     8005b2 <vprintfmt+0x1be>
  8005c5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005cb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ce:	85 c9                	test   %ecx,%ecx
  8005d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d5:	0f 49 c1             	cmovns %ecx,%eax
  8005d8:	29 c1                	sub    %eax,%ecx
  8005da:	89 cb                	mov    %ecx,%ebx
  8005dc:	eb 44                	jmp    800622 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e2:	74 1e                	je     800602 <vprintfmt+0x20e>
  8005e4:	0f be d2             	movsbl %dl,%edx
  8005e7:	83 ea 20             	sub    $0x20,%edx
  8005ea:	83 fa 5e             	cmp    $0x5e,%edx
  8005ed:	76 13                	jbe    800602 <vprintfmt+0x20e>
					putch('?', putdat);
  8005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005fd:	ff 55 08             	call   *0x8(%ebp)
  800600:	eb 0d                	jmp    80060f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800602:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800605:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800609:	89 04 24             	mov    %eax,(%esp)
  80060c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060f:	83 eb 01             	sub    $0x1,%ebx
  800612:	eb 0e                	jmp    800622 <vprintfmt+0x22e>
  800614:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800617:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80061a:	eb 06                	jmp    800622 <vprintfmt+0x22e>
  80061c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80061f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800622:	83 c7 01             	add    $0x1,%edi
  800625:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800629:	0f be c2             	movsbl %dl,%eax
  80062c:	85 c0                	test   %eax,%eax
  80062e:	74 27                	je     800657 <vprintfmt+0x263>
  800630:	85 f6                	test   %esi,%esi
  800632:	78 aa                	js     8005de <vprintfmt+0x1ea>
  800634:	83 ee 01             	sub    $0x1,%esi
  800637:	79 a5                	jns    8005de <vprintfmt+0x1ea>
  800639:	89 d8                	mov    %ebx,%eax
  80063b:	8b 75 08             	mov    0x8(%ebp),%esi
  80063e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800641:	89 c3                	mov    %eax,%ebx
  800643:	eb 18                	jmp    80065d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800645:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800649:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800650:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800652:	83 eb 01             	sub    $0x1,%ebx
  800655:	eb 06                	jmp    80065d <vprintfmt+0x269>
  800657:	8b 75 08             	mov    0x8(%ebp),%esi
  80065a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80065d:	85 db                	test   %ebx,%ebx
  80065f:	7f e4                	jg     800645 <vprintfmt+0x251>
  800661:	89 75 08             	mov    %esi,0x8(%ebp)
  800664:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800667:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80066a:	e9 aa fd ff ff       	jmp    800419 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80066f:	83 f9 01             	cmp    $0x1,%ecx
  800672:	7e 10                	jle    800684 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 30                	mov    (%eax),%esi
  800679:	8b 78 04             	mov    0x4(%eax),%edi
  80067c:	8d 40 08             	lea    0x8(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
  800682:	eb 26                	jmp    8006aa <vprintfmt+0x2b6>
	else if (lflag)
  800684:	85 c9                	test   %ecx,%ecx
  800686:	74 12                	je     80069a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 30                	mov    (%eax),%esi
  80068d:	89 f7                	mov    %esi,%edi
  80068f:	c1 ff 1f             	sar    $0x1f,%edi
  800692:	8d 40 04             	lea    0x4(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
  800698:	eb 10                	jmp    8006aa <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 30                	mov    (%eax),%esi
  80069f:	89 f7                	mov    %esi,%edi
  8006a1:	c1 ff 1f             	sar    $0x1f,%edi
  8006a4:	8d 40 04             	lea    0x4(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006aa:	89 f0                	mov    %esi,%eax
  8006ac:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006b3:	85 ff                	test   %edi,%edi
  8006b5:	0f 89 3a 01 00 00    	jns    8007f5 <vprintfmt+0x401>
				putch('-', putdat);
  8006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006c9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006cc:	89 f0                	mov    %esi,%eax
  8006ce:	89 fa                	mov    %edi,%edx
  8006d0:	f7 d8                	neg    %eax
  8006d2:	83 d2 00             	adc    $0x0,%edx
  8006d5:	f7 da                	neg    %edx
			}
			base = 10;
  8006d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006dc:	e9 14 01 00 00       	jmp    8007f5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006e1:	83 f9 01             	cmp    $0x1,%ecx
  8006e4:	7e 13                	jle    8006f9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8b 50 04             	mov    0x4(%eax),%edx
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	8b 75 14             	mov    0x14(%ebp),%esi
  8006f1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006f4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006f7:	eb 2c                	jmp    800725 <vprintfmt+0x331>
	else if (lflag)
  8006f9:	85 c9                	test   %ecx,%ecx
  8006fb:	74 15                	je     800712 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	ba 00 00 00 00       	mov    $0x0,%edx
  800707:	8b 75 14             	mov    0x14(%ebp),%esi
  80070a:	8d 76 04             	lea    0x4(%esi),%esi
  80070d:	89 75 14             	mov    %esi,0x14(%ebp)
  800710:	eb 13                	jmp    800725 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	ba 00 00 00 00       	mov    $0x0,%edx
  80071c:	8b 75 14             	mov    0x14(%ebp),%esi
  80071f:	8d 76 04             	lea    0x4(%esi),%esi
  800722:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800725:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80072a:	e9 c6 00 00 00       	jmp    8007f5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80072f:	83 f9 01             	cmp    $0x1,%ecx
  800732:	7e 13                	jle    800747 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 50 04             	mov    0x4(%eax),%edx
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8b 75 14             	mov    0x14(%ebp),%esi
  80073f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800742:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800745:	eb 24                	jmp    80076b <vprintfmt+0x377>
	else if (lflag)
  800747:	85 c9                	test   %ecx,%ecx
  800749:	74 11                	je     80075c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	99                   	cltd   
  800751:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800754:	8d 71 04             	lea    0x4(%ecx),%esi
  800757:	89 75 14             	mov    %esi,0x14(%ebp)
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	99                   	cltd   
  800762:	8b 75 14             	mov    0x14(%ebp),%esi
  800765:	8d 76 04             	lea    0x4(%esi),%esi
  800768:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80076b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800770:	e9 80 00 00 00       	jmp    8007f5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800775:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800786:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800790:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800797:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80079a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80079e:	8b 06                	mov    (%esi),%eax
  8007a0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007a5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007aa:	eb 49                	jmp    8007f5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007ac:	83 f9 01             	cmp    $0x1,%ecx
  8007af:	7e 13                	jle    8007c4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 50 04             	mov    0x4(%eax),%edx
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	8b 75 14             	mov    0x14(%ebp),%esi
  8007bc:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007bf:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007c2:	eb 2c                	jmp    8007f0 <vprintfmt+0x3fc>
	else if (lflag)
  8007c4:	85 c9                	test   %ecx,%ecx
  8007c6:	74 15                	je     8007dd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007d5:	8d 71 04             	lea    0x4(%ecx),%esi
  8007d8:	89 75 14             	mov    %esi,0x14(%ebp)
  8007db:	eb 13                	jmp    8007f0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	8b 75 14             	mov    0x14(%ebp),%esi
  8007ea:	8d 76 04             	lea    0x4(%esi),%esi
  8007ed:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8007f0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8007f9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007fd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800800:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800804:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800808:	89 04 24             	mov    %eax,(%esp)
  80080b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80080f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	e8 a6 fa ff ff       	call   8002c0 <printnum>
			break;
  80081a:	e9 fa fb ff ff       	jmp    800419 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80081f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800822:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800826:	89 04 24             	mov    %eax,(%esp)
  800829:	ff 55 08             	call   *0x8(%ebp)
			break;
  80082c:	e9 e8 fb ff ff       	jmp    800419 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800831:	8b 45 0c             	mov    0xc(%ebp),%eax
  800834:	89 44 24 04          	mov    %eax,0x4(%esp)
  800838:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80083f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800842:	89 fb                	mov    %edi,%ebx
  800844:	eb 03                	jmp    800849 <vprintfmt+0x455>
  800846:	83 eb 01             	sub    $0x1,%ebx
  800849:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80084d:	75 f7                	jne    800846 <vprintfmt+0x452>
  80084f:	90                   	nop
  800850:	e9 c4 fb ff ff       	jmp    800419 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800855:	83 c4 3c             	add    $0x3c,%esp
  800858:	5b                   	pop    %ebx
  800859:	5e                   	pop    %esi
  80085a:	5f                   	pop    %edi
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	83 ec 28             	sub    $0x28,%esp
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800869:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800870:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800873:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80087a:	85 c0                	test   %eax,%eax
  80087c:	74 30                	je     8008ae <vsnprintf+0x51>
  80087e:	85 d2                	test   %edx,%edx
  800880:	7e 2c                	jle    8008ae <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800889:	8b 45 10             	mov    0x10(%ebp),%eax
  80088c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800890:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800893:	89 44 24 04          	mov    %eax,0x4(%esp)
  800897:	c7 04 24 af 03 80 00 	movl   $0x8003af,(%esp)
  80089e:	e8 51 fb ff ff       	call   8003f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ac:	eb 05                	jmp    8008b3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008bb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	89 04 24             	mov    %eax,(%esp)
  8008d6:	e8 82 ff ff ff       	call   80085d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    
  8008dd:	66 90                	xchg   %ax,%ax
  8008df:	90                   	nop

008008e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb 03                	jmp    8008f0 <strlen+0x10>
		n++;
  8008ed:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f4:	75 f7                	jne    8008ed <strlen+0xd>
		n++;
	return n;
}
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	eb 03                	jmp    80090b <strnlen+0x13>
		n++;
  800908:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090b:	39 d0                	cmp    %edx,%eax
  80090d:	74 06                	je     800915 <strnlen+0x1d>
  80090f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800913:	75 f3                	jne    800908 <strnlen+0x10>
		n++;
	return n;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800921:	89 c2                	mov    %eax,%edx
  800923:	83 c2 01             	add    $0x1,%edx
  800926:	83 c1 01             	add    $0x1,%ecx
  800929:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80092d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800930:	84 db                	test   %bl,%bl
  800932:	75 ef                	jne    800923 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800934:	5b                   	pop    %ebx
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	53                   	push   %ebx
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800941:	89 1c 24             	mov    %ebx,(%esp)
  800944:	e8 97 ff ff ff       	call   8008e0 <strlen>
	strcpy(dst + len, src);
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800950:	01 d8                	add    %ebx,%eax
  800952:	89 04 24             	mov    %eax,(%esp)
  800955:	e8 bd ff ff ff       	call   800917 <strcpy>
	return dst;
}
  80095a:	89 d8                	mov    %ebx,%eax
  80095c:	83 c4 08             	add    $0x8,%esp
  80095f:	5b                   	pop    %ebx
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	56                   	push   %esi
  800966:	53                   	push   %ebx
  800967:	8b 75 08             	mov    0x8(%ebp),%esi
  80096a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096d:	89 f3                	mov    %esi,%ebx
  80096f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800972:	89 f2                	mov    %esi,%edx
  800974:	eb 0f                	jmp    800985 <strncpy+0x23>
		*dst++ = *src;
  800976:	83 c2 01             	add    $0x1,%edx
  800979:	0f b6 01             	movzbl (%ecx),%eax
  80097c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80097f:	80 39 01             	cmpb   $0x1,(%ecx)
  800982:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800985:	39 da                	cmp    %ebx,%edx
  800987:	75 ed                	jne    800976 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800989:	89 f0                	mov    %esi,%eax
  80098b:	5b                   	pop    %ebx
  80098c:	5e                   	pop    %esi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	56                   	push   %esi
  800993:	53                   	push   %ebx
  800994:	8b 75 08             	mov    0x8(%ebp),%esi
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80099d:	89 f0                	mov    %esi,%eax
  80099f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a3:	85 c9                	test   %ecx,%ecx
  8009a5:	75 0b                	jne    8009b2 <strlcpy+0x23>
  8009a7:	eb 1d                	jmp    8009c6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009a9:	83 c0 01             	add    $0x1,%eax
  8009ac:	83 c2 01             	add    $0x1,%edx
  8009af:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009b2:	39 d8                	cmp    %ebx,%eax
  8009b4:	74 0b                	je     8009c1 <strlcpy+0x32>
  8009b6:	0f b6 0a             	movzbl (%edx),%ecx
  8009b9:	84 c9                	test   %cl,%cl
  8009bb:	75 ec                	jne    8009a9 <strlcpy+0x1a>
  8009bd:	89 c2                	mov    %eax,%edx
  8009bf:	eb 02                	jmp    8009c3 <strlcpy+0x34>
  8009c1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009c3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009c6:	29 f0                	sub    %esi,%eax
}
  8009c8:	5b                   	pop    %ebx
  8009c9:	5e                   	pop    %esi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009d5:	eb 06                	jmp    8009dd <strcmp+0x11>
		p++, q++;
  8009d7:	83 c1 01             	add    $0x1,%ecx
  8009da:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009dd:	0f b6 01             	movzbl (%ecx),%eax
  8009e0:	84 c0                	test   %al,%al
  8009e2:	74 04                	je     8009e8 <strcmp+0x1c>
  8009e4:	3a 02                	cmp    (%edx),%al
  8009e6:	74 ef                	je     8009d7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 c0             	movzbl %al,%eax
  8009eb:	0f b6 12             	movzbl (%edx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
}
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fc:	89 c3                	mov    %eax,%ebx
  8009fe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a01:	eb 06                	jmp    800a09 <strncmp+0x17>
		n--, p++, q++;
  800a03:	83 c0 01             	add    $0x1,%eax
  800a06:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a09:	39 d8                	cmp    %ebx,%eax
  800a0b:	74 15                	je     800a22 <strncmp+0x30>
  800a0d:	0f b6 08             	movzbl (%eax),%ecx
  800a10:	84 c9                	test   %cl,%cl
  800a12:	74 04                	je     800a18 <strncmp+0x26>
  800a14:	3a 0a                	cmp    (%edx),%cl
  800a16:	74 eb                	je     800a03 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a18:	0f b6 00             	movzbl (%eax),%eax
  800a1b:	0f b6 12             	movzbl (%edx),%edx
  800a1e:	29 d0                	sub    %edx,%eax
  800a20:	eb 05                	jmp    800a27 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a22:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a27:	5b                   	pop    %ebx
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a34:	eb 07                	jmp    800a3d <strchr+0x13>
		if (*s == c)
  800a36:	38 ca                	cmp    %cl,%dl
  800a38:	74 0f                	je     800a49 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	0f b6 10             	movzbl (%eax),%edx
  800a40:	84 d2                	test   %dl,%dl
  800a42:	75 f2                	jne    800a36 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a55:	eb 07                	jmp    800a5e <strfind+0x13>
		if (*s == c)
  800a57:	38 ca                	cmp    %cl,%dl
  800a59:	74 0a                	je     800a65 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a5b:	83 c0 01             	add    $0x1,%eax
  800a5e:	0f b6 10             	movzbl (%eax),%edx
  800a61:	84 d2                	test   %dl,%dl
  800a63:	75 f2                	jne    800a57 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	57                   	push   %edi
  800a6b:	56                   	push   %esi
  800a6c:	53                   	push   %ebx
  800a6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a73:	85 c9                	test   %ecx,%ecx
  800a75:	74 36                	je     800aad <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a77:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7d:	75 28                	jne    800aa7 <memset+0x40>
  800a7f:	f6 c1 03             	test   $0x3,%cl
  800a82:	75 23                	jne    800aa7 <memset+0x40>
		c &= 0xFF;
  800a84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a88:	89 d3                	mov    %edx,%ebx
  800a8a:	c1 e3 08             	shl    $0x8,%ebx
  800a8d:	89 d6                	mov    %edx,%esi
  800a8f:	c1 e6 18             	shl    $0x18,%esi
  800a92:	89 d0                	mov    %edx,%eax
  800a94:	c1 e0 10             	shl    $0x10,%eax
  800a97:	09 f0                	or     %esi,%eax
  800a99:	09 c2                	or     %eax,%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a9f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800aa2:	fc                   	cld    
  800aa3:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa5:	eb 06                	jmp    800aad <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	fc                   	cld    
  800aab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aad:	89 f8                	mov    %edi,%eax
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5f                   	pop    %edi
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	57                   	push   %edi
  800ab8:	56                   	push   %esi
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac2:	39 c6                	cmp    %eax,%esi
  800ac4:	73 35                	jae    800afb <memmove+0x47>
  800ac6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac9:	39 d0                	cmp    %edx,%eax
  800acb:	73 2e                	jae    800afb <memmove+0x47>
		s += n;
		d += n;
  800acd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ad0:	89 d6                	mov    %edx,%esi
  800ad2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ada:	75 13                	jne    800aef <memmove+0x3b>
  800adc:	f6 c1 03             	test   $0x3,%cl
  800adf:	75 0e                	jne    800aef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae1:	83 ef 04             	sub    $0x4,%edi
  800ae4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aea:	fd                   	std    
  800aeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aed:	eb 09                	jmp    800af8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aef:	83 ef 01             	sub    $0x1,%edi
  800af2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800af5:	fd                   	std    
  800af6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af8:	fc                   	cld    
  800af9:	eb 1d                	jmp    800b18 <memmove+0x64>
  800afb:	89 f2                	mov    %esi,%edx
  800afd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aff:	f6 c2 03             	test   $0x3,%dl
  800b02:	75 0f                	jne    800b13 <memmove+0x5f>
  800b04:	f6 c1 03             	test   $0x3,%cl
  800b07:	75 0a                	jne    800b13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b09:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b0c:	89 c7                	mov    %eax,%edi
  800b0e:	fc                   	cld    
  800b0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b11:	eb 05                	jmp    800b18 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b13:	89 c7                	mov    %eax,%edi
  800b15:	fc                   	cld    
  800b16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b18:	5e                   	pop    %esi
  800b19:	5f                   	pop    %edi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b22:	8b 45 10             	mov    0x10(%ebp),%eax
  800b25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	89 04 24             	mov    %eax,(%esp)
  800b36:	e8 79 ff ff ff       	call   800ab4 <memmove>
}
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
  800b42:	8b 55 08             	mov    0x8(%ebp),%edx
  800b45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b48:	89 d6                	mov    %edx,%esi
  800b4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4d:	eb 1a                	jmp    800b69 <memcmp+0x2c>
		if (*s1 != *s2)
  800b4f:	0f b6 02             	movzbl (%edx),%eax
  800b52:	0f b6 19             	movzbl (%ecx),%ebx
  800b55:	38 d8                	cmp    %bl,%al
  800b57:	74 0a                	je     800b63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b59:	0f b6 c0             	movzbl %al,%eax
  800b5c:	0f b6 db             	movzbl %bl,%ebx
  800b5f:	29 d8                	sub    %ebx,%eax
  800b61:	eb 0f                	jmp    800b72 <memcmp+0x35>
		s1++, s2++;
  800b63:	83 c2 01             	add    $0x1,%edx
  800b66:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b69:	39 f2                	cmp    %esi,%edx
  800b6b:	75 e2                	jne    800b4f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b72:	5b                   	pop    %ebx
  800b73:	5e                   	pop    %esi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7f:	89 c2                	mov    %eax,%edx
  800b81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b84:	eb 07                	jmp    800b8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b86:	38 08                	cmp    %cl,(%eax)
  800b88:	74 07                	je     800b91 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b8a:	83 c0 01             	add    $0x1,%eax
  800b8d:	39 d0                	cmp    %edx,%eax
  800b8f:	72 f5                	jb     800b86 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9f:	eb 03                	jmp    800ba4 <strtol+0x11>
		s++;
  800ba1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba4:	0f b6 0a             	movzbl (%edx),%ecx
  800ba7:	80 f9 09             	cmp    $0x9,%cl
  800baa:	74 f5                	je     800ba1 <strtol+0xe>
  800bac:	80 f9 20             	cmp    $0x20,%cl
  800baf:	74 f0                	je     800ba1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bb1:	80 f9 2b             	cmp    $0x2b,%cl
  800bb4:	75 0a                	jne    800bc0 <strtol+0x2d>
		s++;
  800bb6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbe:	eb 11                	jmp    800bd1 <strtol+0x3e>
  800bc0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bc5:	80 f9 2d             	cmp    $0x2d,%cl
  800bc8:	75 07                	jne    800bd1 <strtol+0x3e>
		s++, neg = 1;
  800bca:	8d 52 01             	lea    0x1(%edx),%edx
  800bcd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bd6:	75 15                	jne    800bed <strtol+0x5a>
  800bd8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bdb:	75 10                	jne    800bed <strtol+0x5a>
  800bdd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800be1:	75 0a                	jne    800bed <strtol+0x5a>
		s += 2, base = 16;
  800be3:	83 c2 02             	add    $0x2,%edx
  800be6:	b8 10 00 00 00       	mov    $0x10,%eax
  800beb:	eb 10                	jmp    800bfd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bed:	85 c0                	test   %eax,%eax
  800bef:	75 0c                	jne    800bfd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bf6:	75 05                	jne    800bfd <strtol+0x6a>
		s++, base = 8;
  800bf8:	83 c2 01             	add    $0x1,%edx
  800bfb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c02:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c05:	0f b6 0a             	movzbl (%edx),%ecx
  800c08:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c0b:	89 f0                	mov    %esi,%eax
  800c0d:	3c 09                	cmp    $0x9,%al
  800c0f:	77 08                	ja     800c19 <strtol+0x86>
			dig = *s - '0';
  800c11:	0f be c9             	movsbl %cl,%ecx
  800c14:	83 e9 30             	sub    $0x30,%ecx
  800c17:	eb 20                	jmp    800c39 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c19:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c1c:	89 f0                	mov    %esi,%eax
  800c1e:	3c 19                	cmp    $0x19,%al
  800c20:	77 08                	ja     800c2a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c22:	0f be c9             	movsbl %cl,%ecx
  800c25:	83 e9 57             	sub    $0x57,%ecx
  800c28:	eb 0f                	jmp    800c39 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c2a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c2d:	89 f0                	mov    %esi,%eax
  800c2f:	3c 19                	cmp    $0x19,%al
  800c31:	77 16                	ja     800c49 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c33:	0f be c9             	movsbl %cl,%ecx
  800c36:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c39:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c3c:	7d 0f                	jge    800c4d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c3e:	83 c2 01             	add    $0x1,%edx
  800c41:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c45:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c47:	eb bc                	jmp    800c05 <strtol+0x72>
  800c49:	89 d8                	mov    %ebx,%eax
  800c4b:	eb 02                	jmp    800c4f <strtol+0xbc>
  800c4d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c53:	74 05                	je     800c5a <strtol+0xc7>
		*endptr = (char *) s;
  800c55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c58:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c5a:	f7 d8                	neg    %eax
  800c5c:	85 ff                	test   %edi,%edi
  800c5e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	57                   	push   %edi
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	89 c3                	mov    %eax,%ebx
  800c79:	89 c7                	mov    %eax,%edi
  800c7b:	89 c6                	mov    %eax,%esi
  800c7d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	57                   	push   %edi
  800c88:	56                   	push   %esi
  800c89:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c94:	89 d1                	mov    %edx,%ecx
  800c96:	89 d3                	mov    %edx,%ebx
  800c98:	89 d7                	mov    %edx,%edi
  800c9a:	89 d6                	mov    %edx,%esi
  800c9c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	89 cb                	mov    %ecx,%ebx
  800cbb:	89 cf                	mov    %ecx,%edi
  800cbd:	89 ce                	mov    %ecx,%esi
  800cbf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7e 28                	jle    800ced <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cd0:	00 
  800cd1:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800cd8:	00 
  800cd9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce0:	00 
  800ce1:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800ce8:	e8 bc f4 ff ff       	call   8001a9 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ced:	83 c4 2c             	add    $0x2c,%esp
  800cf0:	5b                   	pop    %ebx
  800cf1:	5e                   	pop    %esi
  800cf2:	5f                   	pop    %edi
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
  800cfb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d03:	b8 04 00 00 00       	mov    $0x4,%eax
  800d08:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0b:	89 cb                	mov    %ecx,%ebx
  800d0d:	89 cf                	mov    %ecx,%edi
  800d0f:	89 ce                	mov    %ecx,%esi
  800d11:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7e 28                	jle    800d3f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d22:	00 
  800d23:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800d2a:	00 
  800d2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d32:	00 
  800d33:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800d3a:	e8 6a f4 ff ff       	call   8001a9 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800d3f:	83 c4 2c             	add    $0x2c,%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d52:	b8 02 00 00 00       	mov    $0x2,%eax
  800d57:	89 d1                	mov    %edx,%ecx
  800d59:	89 d3                	mov    %edx,%ebx
  800d5b:	89 d7                	mov    %edx,%edi
  800d5d:	89 d6                	mov    %edx,%esi
  800d5f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <sys_yield>:

void
sys_yield(void)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d71:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d76:	89 d1                	mov    %edx,%ecx
  800d78:	89 d3                	mov    %edx,%ebx
  800d7a:	89 d7                	mov    %edx,%edi
  800d7c:	89 d6                	mov    %edx,%esi
  800d7e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8e:	be 00 00 00 00       	mov    $0x0,%esi
  800d93:	b8 05 00 00 00       	mov    $0x5,%eax
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da1:	89 f7                	mov    %esi,%edi
  800da3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7e 28                	jle    800dd1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dad:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800db4:	00 
  800db5:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800dbc:	00 
  800dbd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc4:	00 
  800dc5:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800dcc:	e8 d8 f3 ff ff       	call   8001a9 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd1:	83 c4 2c             	add    $0x2c,%esp
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de2:	b8 06 00 00 00       	mov    $0x6,%eax
  800de7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df3:	8b 75 18             	mov    0x18(%ebp),%esi
  800df6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7e 28                	jle    800e24 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e00:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e07:	00 
  800e08:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800e0f:	00 
  800e10:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e17:	00 
  800e18:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800e1f:	e8 85 f3 ff ff       	call   8001a9 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e24:	83 c4 2c             	add    $0x2c,%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	57                   	push   %edi
  800e30:	56                   	push   %esi
  800e31:	53                   	push   %ebx
  800e32:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3a:	b8 07 00 00 00       	mov    $0x7,%eax
  800e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e42:	8b 55 08             	mov    0x8(%ebp),%edx
  800e45:	89 df                	mov    %ebx,%edi
  800e47:	89 de                	mov    %ebx,%esi
  800e49:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	7e 28                	jle    800e77 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e53:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e5a:	00 
  800e5b:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800e62:	00 
  800e63:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e6a:	00 
  800e6b:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800e72:	e8 32 f3 ff ff       	call   8001a9 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e77:	83 c4 2c             	add    $0x2c,%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	89 cb                	mov    %ecx,%ebx
  800e94:	89 cf                	mov    %ecx,%edi
  800e96:	89 ce                	mov    %ecx,%esi
  800e98:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ead:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7e 28                	jle    800eea <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ecd:	00 
  800ece:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800ed5:	00 
  800ed6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edd:	00 
  800ede:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800ee5:	e8 bf f2 ff ff       	call   8001a9 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eea:	83 c4 2c             	add    $0x2c,%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	89 df                	mov    %ebx,%edi
  800f0d:	89 de                	mov    %ebx,%esi
  800f0f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	7e 28                	jle    800f3d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f19:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f20:	00 
  800f21:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800f28:	00 
  800f29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f30:	00 
  800f31:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800f38:	e8 6c f2 ff ff       	call   8001a9 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f3d:	83 c4 2c             	add    $0x2c,%esp
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
  800f4b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f53:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5e:	89 df                	mov    %ebx,%edi
  800f60:	89 de                	mov    %ebx,%esi
  800f62:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7e 28                	jle    800f90 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f68:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f73:	00 
  800f74:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800f7b:	00 
  800f7c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f83:	00 
  800f84:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800f8b:	e8 19 f2 ff ff       	call   8001a9 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f90:	83 c4 2c             	add    $0x2c,%esp
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9e:	be 00 00 00 00       	mov    $0x0,%esi
  800fa3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fab:	8b 55 08             	mov    0x8(%ebp),%edx
  800fae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fb4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
  800fc1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	89 cb                	mov    %ecx,%ebx
  800fd3:	89 cf                	mov    %ecx,%edi
  800fd5:	89 ce                	mov    %ecx,%esi
  800fd7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	7e 28                	jle    801005 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800fe8:	00 
  800fe9:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800ff0:	00 
  800ff1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff8:	00 
  800ff9:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  801000:	e8 a4 f1 ff ff       	call   8001a9 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801005:	83 c4 2c             	add    $0x2c,%esp
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5f                   	pop    %edi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	57                   	push   %edi
  801011:	56                   	push   %esi
  801012:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801013:	ba 00 00 00 00       	mov    $0x0,%edx
  801018:	b8 0f 00 00 00       	mov    $0xf,%eax
  80101d:	89 d1                	mov    %edx,%ecx
  80101f:	89 d3                	mov    %edx,%ebx
  801021:	89 d7                	mov    %edx,%edi
  801023:	89 d6                	mov    %edx,%esi
  801025:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5f                   	pop    %edi
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    

0080102c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801032:	bb 00 00 00 00       	mov    $0x0,%ebx
  801037:	b8 11 00 00 00       	mov    $0x11,%eax
  80103c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	89 df                	mov    %ebx,%edi
  801044:	89 de                	mov    %ebx,%esi
  801046:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801053:	bb 00 00 00 00       	mov    $0x0,%ebx
  801058:	b8 12 00 00 00       	mov    $0x12,%eax
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	89 df                	mov    %ebx,%edi
  801065:	89 de                	mov    %ebx,%esi
  801067:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    

0080106e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801074:	b9 00 00 00 00       	mov    $0x0,%ecx
  801079:	b8 13 00 00 00       	mov    $0x13,%eax
  80107e:	8b 55 08             	mov    0x8(%ebp),%edx
  801081:	89 cb                	mov    %ecx,%ebx
  801083:	89 cf                	mov    %ecx,%edi
  801085:	89 ce                	mov    %ecx,%esi
  801087:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801089:	5b                   	pop    %ebx
  80108a:	5e                   	pop    %esi
  80108b:	5f                   	pop    %edi
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    

0080108e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	57                   	push   %edi
  801092:	56                   	push   %esi
  801093:	53                   	push   %ebx
  801094:	83 ec 2c             	sub    $0x2c,%esp
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80109a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80109c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80109f:	89 f8                	mov    %edi,%eax
  8010a1:	c1 e8 0c             	shr    $0xc,%eax
  8010a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  8010a7:	e8 9b fc ff ff       	call   800d47 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  8010ac:	f7 c6 02 00 00 00    	test   $0x2,%esi
  8010b2:	0f 84 de 00 00 00    	je     801196 <pgfault+0x108>
  8010b8:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	79 20                	jns    8010de <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  8010be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010c2:	c7 44 24 08 e2 31 80 	movl   $0x8031e2,0x8(%esp)
  8010c9:	00 
  8010ca:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8010d1:	00 
  8010d2:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8010d9:	e8 cb f0 ff ff       	call   8001a9 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  8010de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  8010e8:	25 05 08 00 00       	and    $0x805,%eax
  8010ed:	3d 05 08 00 00       	cmp    $0x805,%eax
  8010f2:	0f 85 ba 00 00 00    	jne    8011b2 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8010f8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010ff:	00 
  801100:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801107:	00 
  801108:	89 1c 24             	mov    %ebx,(%esp)
  80110b:	e8 75 fc ff ff       	call   800d85 <sys_page_alloc>
  801110:	85 c0                	test   %eax,%eax
  801112:	79 20                	jns    801134 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801114:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801118:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  80111f:	00 
  801120:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801127:	00 
  801128:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80112f:	e8 75 f0 ff ff       	call   8001a9 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801134:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80113a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801141:	00 
  801142:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801146:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80114d:	e8 62 f9 ff ff       	call   800ab4 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801152:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801159:	00 
  80115a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80115e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801162:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801169:	00 
  80116a:	89 1c 24             	mov    %ebx,(%esp)
  80116d:	e8 67 fc ff ff       	call   800dd9 <sys_page_map>
  801172:	85 c0                	test   %eax,%eax
  801174:	79 3c                	jns    8011b2 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801176:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80117a:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  801181:	00 
  801182:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801189:	00 
  80118a:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  801191:	e8 13 f0 ff ff       	call   8001a9 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801196:	c7 44 24 08 40 32 80 	movl   $0x803240,0x8(%esp)
  80119d:	00 
  80119e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8011a5:	00 
  8011a6:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8011ad:	e8 f7 ef ff ff       	call   8001a9 <_panic>
}
  8011b2:	83 c4 2c             	add    $0x2c,%esp
  8011b5:	5b                   	pop    %ebx
  8011b6:	5e                   	pop    %esi
  8011b7:	5f                   	pop    %edi
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	56                   	push   %esi
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 20             	sub    $0x20,%esp
  8011c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8011c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8011c8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011cf:	00 
  8011d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011d4:	89 34 24             	mov    %esi,(%esp)
  8011d7:	e8 a9 fb ff ff       	call   800d85 <sys_page_alloc>
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	79 20                	jns    801200 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  8011e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e4:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8011f3:	00 
  8011f4:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8011fb:	e8 a9 ef ff ff       	call   8001a9 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801200:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801207:	00 
  801208:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  80120f:	00 
  801210:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801217:	00 
  801218:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80121c:	89 34 24             	mov    %esi,(%esp)
  80121f:	e8 b5 fb ff ff       	call   800dd9 <sys_page_map>
  801224:	85 c0                	test   %eax,%eax
  801226:	79 20                	jns    801248 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801228:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122c:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  801233:	00 
  801234:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80123b:	00 
  80123c:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  801243:	e8 61 ef ff ff       	call   8001a9 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801248:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80124f:	00 
  801250:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801254:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80125b:	e8 54 f8 ff ff       	call   800ab4 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801260:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801267:	00 
  801268:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80126f:	e8 b8 fb ff ff       	call   800e2c <sys_page_unmap>
  801274:	85 c0                	test   %eax,%eax
  801276:	79 20                	jns    801298 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801278:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80127c:	c7 44 24 08 2d 32 80 	movl   $0x80322d,0x8(%esp)
  801283:	00 
  801284:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80128b:	00 
  80128c:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  801293:	e8 11 ef ff ff       	call   8001a9 <_panic>

}
  801298:	83 c4 20             	add    $0x20,%esp
  80129b:	5b                   	pop    %ebx
  80129c:	5e                   	pop    %esi
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    

0080129f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	57                   	push   %edi
  8012a3:	56                   	push   %esi
  8012a4:	53                   	push   %ebx
  8012a5:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  8012a8:	c7 04 24 8e 10 80 00 	movl   $0x80108e,(%esp)
  8012af:	e8 f2 17 00 00       	call   802aa6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8012b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8012b9:	cd 30                	int    $0x30
  8012bb:	89 c6                	mov    %eax,%esi
  8012bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	79 20                	jns    8012e4 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  8012c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012c8:	c7 44 24 08 64 32 80 	movl   $0x803264,0x8(%esp)
  8012cf:	00 
  8012d0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  8012d7:	00 
  8012d8:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8012df:	e8 c5 ee ff ff       	call   8001a9 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8012e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	75 21                	jne    80130e <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8012ed:	e8 55 fa ff ff       	call   800d47 <sys_getenvid>
  8012f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012ff:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	e9 88 01 00 00       	jmp    801496 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  80130e:	89 d8                	mov    %ebx,%eax
  801310:	c1 e8 16             	shr    $0x16,%eax
  801313:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80131a:	a8 01                	test   $0x1,%al
  80131c:	0f 84 e0 00 00 00    	je     801402 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801322:	89 df                	mov    %ebx,%edi
  801324:	c1 ef 0c             	shr    $0xc,%edi
  801327:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80132e:	a8 01                	test   $0x1,%al
  801330:	0f 84 c4 00 00 00    	je     8013fa <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801336:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80133d:	f6 c4 04             	test   $0x4,%ah
  801340:	74 0d                	je     80134f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801342:	25 07 0e 00 00       	and    $0xe07,%eax
  801347:	83 c8 05             	or     $0x5,%eax
  80134a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80134d:	eb 1b                	jmp    80136a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80134f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801354:	83 f8 01             	cmp    $0x1,%eax
  801357:	19 c0                	sbb    %eax,%eax
  801359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80135c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801363:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80136a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80136d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801370:	89 44 24 10          	mov    %eax,0x10(%esp)
  801374:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801378:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80137b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80137f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801383:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80138a:	e8 4a fa ff ff       	call   800dd9 <sys_page_map>
  80138f:	85 c0                	test   %eax,%eax
  801391:	79 20                	jns    8013b3 <fork+0x114>
		panic("sys_page_map: %e", r);
  801393:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801397:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  80139e:	00 
  80139f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  8013a6:	00 
  8013a7:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8013ae:	e8 f6 ed ff ff       	call   8001a9 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  8013b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013ba:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013be:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013c5:	00 
  8013c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d1:	e8 03 fa ff ff       	call   800dd9 <sys_page_map>
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	79 20                	jns    8013fa <fork+0x15b>
		panic("sys_page_map: %e", r);
  8013da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013de:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  8013e5:	00 
  8013e6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  8013ed:	00 
  8013ee:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8013f5:	e8 af ed ff ff       	call   8001a9 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8013fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801400:	eb 06                	jmp    801408 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801402:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801408:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  80140e:	0f 86 fa fe ff ff    	jbe    80130e <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801414:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80141b:	00 
  80141c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801423:	ee 
  801424:	89 34 24             	mov    %esi,(%esp)
  801427:	e8 59 f9 ff ff       	call   800d85 <sys_page_alloc>
  80142c:	85 c0                	test   %eax,%eax
  80142e:	79 20                	jns    801450 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801430:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801434:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  80143b:	00 
  80143c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801443:	00 
  801444:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80144b:	e8 59 ed ff ff       	call   8001a9 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801450:	c7 44 24 04 39 2b 80 	movl   $0x802b39,0x4(%esp)
  801457:	00 
  801458:	89 34 24             	mov    %esi,(%esp)
  80145b:	e8 e5 fa ff ff       	call   800f45 <sys_env_set_pgfault_upcall>
  801460:	85 c0                	test   %eax,%eax
  801462:	79 20                	jns    801484 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801464:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801468:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  80146f:	00 
  801470:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801477:	00 
  801478:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80147f:	e8 25 ed ff ff       	call   8001a9 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801484:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80148b:	00 
  80148c:	89 34 24             	mov    %esi,(%esp)
  80148f:	e8 0b fa ff ff       	call   800e9f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801494:	89 f0                	mov    %esi,%eax

}
  801496:	83 c4 2c             	add    $0x2c,%esp
  801499:	5b                   	pop    %ebx
  80149a:	5e                   	pop    %esi
  80149b:	5f                   	pop    %edi
  80149c:	5d                   	pop    %ebp
  80149d:	c3                   	ret    

0080149e <sfork>:

// Challenge!
int
sfork(void)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	57                   	push   %edi
  8014a2:	56                   	push   %esi
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  8014a7:	c7 04 24 8e 10 80 00 	movl   $0x80108e,(%esp)
  8014ae:	e8 f3 15 00 00       	call   802aa6 <set_pgfault_handler>
  8014b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8014b8:	cd 30                	int    $0x30
  8014ba:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	79 20                	jns    8014e0 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  8014c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014c4:	c7 44 24 08 64 32 80 	movl   $0x803264,0x8(%esp)
  8014cb:	00 
  8014cc:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  8014d3:	00 
  8014d4:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8014db:	e8 c9 ec ff ff       	call   8001a9 <_panic>
  8014e0:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8014e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	75 2d                	jne    801518 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8014eb:	e8 57 f8 ff ff       	call   800d47 <sys_getenvid>
  8014f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014f5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014fd:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  801502:	c7 04 24 8e 10 80 00 	movl   $0x80108e,(%esp)
  801509:	e8 98 15 00 00       	call   802aa6 <set_pgfault_handler>
		return 0;
  80150e:	b8 00 00 00 00       	mov    $0x0,%eax
  801513:	e9 1d 01 00 00       	jmp    801635 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801518:	89 d8                	mov    %ebx,%eax
  80151a:	c1 e8 16             	shr    $0x16,%eax
  80151d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801524:	a8 01                	test   $0x1,%al
  801526:	74 69                	je     801591 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801528:	89 d8                	mov    %ebx,%eax
  80152a:	c1 e8 0c             	shr    $0xc,%eax
  80152d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801534:	f6 c2 01             	test   $0x1,%dl
  801537:	74 50                	je     801589 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801539:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801540:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801543:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801549:	89 54 24 10          	mov    %edx,0x10(%esp)
  80154d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801551:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801555:	89 44 24 04          	mov    %eax,0x4(%esp)
  801559:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801560:	e8 74 f8 ff ff       	call   800dd9 <sys_page_map>
  801565:	85 c0                	test   %eax,%eax
  801567:	79 20                	jns    801589 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801569:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80156d:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  801574:	00 
  801575:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80157c:	00 
  80157d:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  801584:	e8 20 ec ff ff       	call   8001a9 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801589:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80158f:	eb 06                	jmp    801597 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801591:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801597:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80159d:	0f 86 75 ff ff ff    	jbe    801518 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  8015a3:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  8015aa:	ee 
  8015ab:	89 34 24             	mov    %esi,(%esp)
  8015ae:	e8 07 fc ff ff       	call   8011ba <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8015b3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015ba:	00 
  8015bb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015c2:	ee 
  8015c3:	89 34 24             	mov    %esi,(%esp)
  8015c6:	e8 ba f7 ff ff       	call   800d85 <sys_page_alloc>
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	79 20                	jns    8015ef <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  8015cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d3:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  8015da:	00 
  8015db:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  8015e2:	00 
  8015e3:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8015ea:	e8 ba eb ff ff       	call   8001a9 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8015ef:	c7 44 24 04 39 2b 80 	movl   $0x802b39,0x4(%esp)
  8015f6:	00 
  8015f7:	89 34 24             	mov    %esi,(%esp)
  8015fa:	e8 46 f9 ff ff       	call   800f45 <sys_env_set_pgfault_upcall>
  8015ff:	85 c0                	test   %eax,%eax
  801601:	79 20                	jns    801623 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801603:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801607:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  80160e:	00 
  80160f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801616:	00 
  801617:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80161e:	e8 86 eb ff ff       	call   8001a9 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801623:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80162a:	00 
  80162b:	89 34 24             	mov    %esi,(%esp)
  80162e:	e8 6c f8 ff ff       	call   800e9f <sys_env_set_status>
	return envid;
  801633:	89 f0                	mov    %esi,%eax

}
  801635:	83 c4 2c             	add    $0x2c,%esp
  801638:	5b                   	pop    %ebx
  801639:	5e                   	pop    %esi
  80163a:	5f                   	pop    %edi
  80163b:	5d                   	pop    %ebp
  80163c:	c3                   	ret    
  80163d:	66 90                	xchg   %ax,%ax
  80163f:	90                   	nop

00801640 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
  801645:	83 ec 10             	sub    $0x10,%esp
  801648:	8b 75 08             	mov    0x8(%ebp),%esi
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  801651:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  801653:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801658:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80165b:	89 04 24             	mov    %eax,(%esp)
  80165e:	e8 58 f9 ff ff       	call   800fbb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  801663:	85 c0                	test   %eax,%eax
  801665:	75 26                	jne    80168d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  801667:	85 f6                	test   %esi,%esi
  801669:	74 0a                	je     801675 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80166b:	a1 08 50 80 00       	mov    0x805008,%eax
  801670:	8b 40 74             	mov    0x74(%eax),%eax
  801673:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  801675:	85 db                	test   %ebx,%ebx
  801677:	74 0a                	je     801683 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  801679:	a1 08 50 80 00       	mov    0x805008,%eax
  80167e:	8b 40 78             	mov    0x78(%eax),%eax
  801681:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801683:	a1 08 50 80 00       	mov    0x805008,%eax
  801688:	8b 40 70             	mov    0x70(%eax),%eax
  80168b:	eb 14                	jmp    8016a1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80168d:	85 f6                	test   %esi,%esi
  80168f:	74 06                	je     801697 <ipc_recv+0x57>
			*from_env_store = 0;
  801691:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801697:	85 db                	test   %ebx,%ebx
  801699:	74 06                	je     8016a1 <ipc_recv+0x61>
			*perm_store = 0;
  80169b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	5b                   	pop    %ebx
  8016a5:	5e                   	pop    %esi
  8016a6:	5d                   	pop    %ebp
  8016a7:	c3                   	ret    

008016a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	57                   	push   %edi
  8016ac:	56                   	push   %esi
  8016ad:	53                   	push   %ebx
  8016ae:	83 ec 1c             	sub    $0x1c,%esp
  8016b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016b7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  8016ba:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  8016bc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8016c1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8016c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016d3:	89 3c 24             	mov    %edi,(%esp)
  8016d6:	e8 bd f8 ff ff       	call   800f98 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	74 28                	je     801707 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8016df:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8016e2:	74 1c                	je     801700 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8016e4:	c7 44 24 08 ac 32 80 	movl   $0x8032ac,0x8(%esp)
  8016eb:	00 
  8016ec:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8016f3:	00 
  8016f4:	c7 04 24 cd 32 80 00 	movl   $0x8032cd,(%esp)
  8016fb:	e8 a9 ea ff ff       	call   8001a9 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  801700:	e8 61 f6 ff ff       	call   800d66 <sys_yield>
	}
  801705:	eb bd                	jmp    8016c4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  801707:	83 c4 1c             	add    $0x1c,%esp
  80170a:	5b                   	pop    %ebx
  80170b:	5e                   	pop    %esi
  80170c:	5f                   	pop    %edi
  80170d:	5d                   	pop    %ebp
  80170e:	c3                   	ret    

0080170f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80171a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80171d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801723:	8b 52 50             	mov    0x50(%edx),%edx
  801726:	39 ca                	cmp    %ecx,%edx
  801728:	75 0d                	jne    801737 <ipc_find_env+0x28>
			return envs[i].env_id;
  80172a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80172d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801732:	8b 40 40             	mov    0x40(%eax),%eax
  801735:	eb 0e                	jmp    801745 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801737:	83 c0 01             	add    $0x1,%eax
  80173a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80173f:	75 d9                	jne    80171a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801741:	66 b8 00 00          	mov    $0x0,%ax
}
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    
  801747:	66 90                	xchg   %ax,%ax
  801749:	66 90                	xchg   %ax,%ax
  80174b:	66 90                	xchg   %ax,%ax
  80174d:	66 90                	xchg   %ax,%ax
  80174f:	90                   	nop

00801750 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	05 00 00 00 30       	add    $0x30000000,%eax
  80175b:	c1 e8 0c             	shr    $0xc,%eax
}
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    

00801760 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80176b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801770:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80177d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801782:	89 c2                	mov    %eax,%edx
  801784:	c1 ea 16             	shr    $0x16,%edx
  801787:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80178e:	f6 c2 01             	test   $0x1,%dl
  801791:	74 11                	je     8017a4 <fd_alloc+0x2d>
  801793:	89 c2                	mov    %eax,%edx
  801795:	c1 ea 0c             	shr    $0xc,%edx
  801798:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80179f:	f6 c2 01             	test   $0x1,%dl
  8017a2:	75 09                	jne    8017ad <fd_alloc+0x36>
			*fd_store = fd;
  8017a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ab:	eb 17                	jmp    8017c4 <fd_alloc+0x4d>
  8017ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017b7:	75 c9                	jne    801782 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8017bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017cc:	83 f8 1f             	cmp    $0x1f,%eax
  8017cf:	77 36                	ja     801807 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017d1:	c1 e0 0c             	shl    $0xc,%eax
  8017d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017d9:	89 c2                	mov    %eax,%edx
  8017db:	c1 ea 16             	shr    $0x16,%edx
  8017de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017e5:	f6 c2 01             	test   $0x1,%dl
  8017e8:	74 24                	je     80180e <fd_lookup+0x48>
  8017ea:	89 c2                	mov    %eax,%edx
  8017ec:	c1 ea 0c             	shr    $0xc,%edx
  8017ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017f6:	f6 c2 01             	test   $0x1,%dl
  8017f9:	74 1a                	je     801815 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	eb 13                	jmp    80181a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180c:	eb 0c                	jmp    80181a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80180e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801813:	eb 05                	jmp    80181a <fd_lookup+0x54>
  801815:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
  801822:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801825:	ba 00 00 00 00       	mov    $0x0,%edx
  80182a:	eb 13                	jmp    80183f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80182c:	39 08                	cmp    %ecx,(%eax)
  80182e:	75 0c                	jne    80183c <dev_lookup+0x20>
			*dev = devtab[i];
  801830:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801833:	89 01                	mov    %eax,(%ecx)
			return 0;
  801835:	b8 00 00 00 00       	mov    $0x0,%eax
  80183a:	eb 38                	jmp    801874 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80183c:	83 c2 01             	add    $0x1,%edx
  80183f:	8b 04 95 58 33 80 00 	mov    0x803358(,%edx,4),%eax
  801846:	85 c0                	test   %eax,%eax
  801848:	75 e2                	jne    80182c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80184a:	a1 08 50 80 00       	mov    0x805008,%eax
  80184f:	8b 40 48             	mov    0x48(%eax),%eax
  801852:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801856:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185a:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  801861:	e8 3c ea ff ff       	call   8002a2 <cprintf>
	*dev = 0;
  801866:	8b 45 0c             	mov    0xc(%ebp),%eax
  801869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80186f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
  80187b:	83 ec 20             	sub    $0x20,%esp
  80187e:	8b 75 08             	mov    0x8(%ebp),%esi
  801881:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801884:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801887:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80188b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801891:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801894:	89 04 24             	mov    %eax,(%esp)
  801897:	e8 2a ff ff ff       	call   8017c6 <fd_lookup>
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 05                	js     8018a5 <fd_close+0x2f>
	    || fd != fd2)
  8018a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018a3:	74 0c                	je     8018b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8018a5:	84 db                	test   %bl,%bl
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	0f 44 c2             	cmove  %edx,%eax
  8018af:	eb 3f                	jmp    8018f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b8:	8b 06                	mov    (%esi),%eax
  8018ba:	89 04 24             	mov    %eax,(%esp)
  8018bd:	e8 5a ff ff ff       	call   80181c <dev_lookup>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 16                	js     8018de <fd_close+0x68>
		if (dev->dev_close)
  8018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8018ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	74 07                	je     8018de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8018d7:	89 34 24             	mov    %esi,(%esp)
  8018da:	ff d0                	call   *%eax
  8018dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e9:	e8 3e f5 ff ff       	call   800e2c <sys_page_unmap>
	return r;
  8018ee:	89 d8                	mov    %ebx,%eax
}
  8018f0:	83 c4 20             	add    $0x20,%esp
  8018f3:	5b                   	pop    %ebx
  8018f4:	5e                   	pop    %esi
  8018f5:	5d                   	pop    %ebp
  8018f6:	c3                   	ret    

008018f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801900:	89 44 24 04          	mov    %eax,0x4(%esp)
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	89 04 24             	mov    %eax,(%esp)
  80190a:	e8 b7 fe ff ff       	call   8017c6 <fd_lookup>
  80190f:	89 c2                	mov    %eax,%edx
  801911:	85 d2                	test   %edx,%edx
  801913:	78 13                	js     801928 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801915:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80191c:	00 
  80191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801920:	89 04 24             	mov    %eax,(%esp)
  801923:	e8 4e ff ff ff       	call   801876 <fd_close>
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <close_all>:

void
close_all(void)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	53                   	push   %ebx
  80192e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801931:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801936:	89 1c 24             	mov    %ebx,(%esp)
  801939:	e8 b9 ff ff ff       	call   8018f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80193e:	83 c3 01             	add    $0x1,%ebx
  801941:	83 fb 20             	cmp    $0x20,%ebx
  801944:	75 f0                	jne    801936 <close_all+0xc>
		close(i);
}
  801946:	83 c4 14             	add    $0x14,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    

0080194c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	57                   	push   %edi
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801955:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	89 04 24             	mov    %eax,(%esp)
  801962:	e8 5f fe ff ff       	call   8017c6 <fd_lookup>
  801967:	89 c2                	mov    %eax,%edx
  801969:	85 d2                	test   %edx,%edx
  80196b:	0f 88 e1 00 00 00    	js     801a52 <dup+0x106>
		return r;
	close(newfdnum);
  801971:	8b 45 0c             	mov    0xc(%ebp),%eax
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	e8 7b ff ff ff       	call   8018f7 <close>

	newfd = INDEX2FD(newfdnum);
  80197c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80197f:	c1 e3 0c             	shl    $0xc,%ebx
  801982:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80198b:	89 04 24             	mov    %eax,(%esp)
  80198e:	e8 cd fd ff ff       	call   801760 <fd2data>
  801993:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801995:	89 1c 24             	mov    %ebx,(%esp)
  801998:	e8 c3 fd ff ff       	call   801760 <fd2data>
  80199d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80199f:	89 f0                	mov    %esi,%eax
  8019a1:	c1 e8 16             	shr    $0x16,%eax
  8019a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019ab:	a8 01                	test   $0x1,%al
  8019ad:	74 43                	je     8019f2 <dup+0xa6>
  8019af:	89 f0                	mov    %esi,%eax
  8019b1:	c1 e8 0c             	shr    $0xc,%eax
  8019b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019bb:	f6 c2 01             	test   $0x1,%dl
  8019be:	74 32                	je     8019f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8019cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019db:	00 
  8019dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019e7:	e8 ed f3 ff ff       	call   800dd9 <sys_page_map>
  8019ec:	89 c6                	mov    %eax,%esi
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 3e                	js     801a30 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f5:	89 c2                	mov    %eax,%edx
  8019f7:	c1 ea 0c             	shr    $0xc,%edx
  8019fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a01:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a07:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a16:	00 
  801a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a22:	e8 b2 f3 ff ff       	call   800dd9 <sys_page_map>
  801a27:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a29:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a2c:	85 f6                	test   %esi,%esi
  801a2e:	79 22                	jns    801a52 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a30:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3b:	e8 ec f3 ff ff       	call   800e2c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a4b:	e8 dc f3 ff ff       	call   800e2c <sys_page_unmap>
	return r;
  801a50:	89 f0                	mov    %esi,%eax
}
  801a52:	83 c4 3c             	add    $0x3c,%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5f                   	pop    %edi
  801a58:	5d                   	pop    %ebp
  801a59:	c3                   	ret    

00801a5a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	53                   	push   %ebx
  801a5e:	83 ec 24             	sub    $0x24,%esp
  801a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6b:	89 1c 24             	mov    %ebx,(%esp)
  801a6e:	e8 53 fd ff ff       	call   8017c6 <fd_lookup>
  801a73:	89 c2                	mov    %eax,%edx
  801a75:	85 d2                	test   %edx,%edx
  801a77:	78 6d                	js     801ae6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a83:	8b 00                	mov    (%eax),%eax
  801a85:	89 04 24             	mov    %eax,(%esp)
  801a88:	e8 8f fd ff ff       	call   80181c <dev_lookup>
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	78 55                	js     801ae6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a94:	8b 50 08             	mov    0x8(%eax),%edx
  801a97:	83 e2 03             	and    $0x3,%edx
  801a9a:	83 fa 01             	cmp    $0x1,%edx
  801a9d:	75 23                	jne    801ac2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a9f:	a1 08 50 80 00       	mov    0x805008,%eax
  801aa4:	8b 40 48             	mov    0x48(%eax),%eax
  801aa7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aaf:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  801ab6:	e8 e7 e7 ff ff       	call   8002a2 <cprintf>
		return -E_INVAL;
  801abb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ac0:	eb 24                	jmp    801ae6 <read+0x8c>
	}
	if (!dev->dev_read)
  801ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac5:	8b 52 08             	mov    0x8(%edx),%edx
  801ac8:	85 d2                	test   %edx,%edx
  801aca:	74 15                	je     801ae1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801acc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801acf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ad3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ada:	89 04 24             	mov    %eax,(%esp)
  801add:	ff d2                	call   *%edx
  801adf:	eb 05                	jmp    801ae6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801ae1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801ae6:	83 c4 24             	add    $0x24,%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	57                   	push   %edi
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	83 ec 1c             	sub    $0x1c,%esp
  801af5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801af8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801afb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b00:	eb 23                	jmp    801b25 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b02:	89 f0                	mov    %esi,%eax
  801b04:	29 d8                	sub    %ebx,%eax
  801b06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b0a:	89 d8                	mov    %ebx,%eax
  801b0c:	03 45 0c             	add    0xc(%ebp),%eax
  801b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b13:	89 3c 24             	mov    %edi,(%esp)
  801b16:	e8 3f ff ff ff       	call   801a5a <read>
		if (m < 0)
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 10                	js     801b2f <readn+0x43>
			return m;
		if (m == 0)
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	74 0a                	je     801b2d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b23:	01 c3                	add    %eax,%ebx
  801b25:	39 f3                	cmp    %esi,%ebx
  801b27:	72 d9                	jb     801b02 <readn+0x16>
  801b29:	89 d8                	mov    %ebx,%eax
  801b2b:	eb 02                	jmp    801b2f <readn+0x43>
  801b2d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b2f:	83 c4 1c             	add    $0x1c,%esp
  801b32:	5b                   	pop    %ebx
  801b33:	5e                   	pop    %esi
  801b34:	5f                   	pop    %edi
  801b35:	5d                   	pop    %ebp
  801b36:	c3                   	ret    

00801b37 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	53                   	push   %ebx
  801b3b:	83 ec 24             	sub    $0x24,%esp
  801b3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b41:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b48:	89 1c 24             	mov    %ebx,(%esp)
  801b4b:	e8 76 fc ff ff       	call   8017c6 <fd_lookup>
  801b50:	89 c2                	mov    %eax,%edx
  801b52:	85 d2                	test   %edx,%edx
  801b54:	78 68                	js     801bbe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b60:	8b 00                	mov    (%eax),%eax
  801b62:	89 04 24             	mov    %eax,(%esp)
  801b65:	e8 b2 fc ff ff       	call   80181c <dev_lookup>
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 50                	js     801bbe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b71:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b75:	75 23                	jne    801b9a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b77:	a1 08 50 80 00       	mov    0x805008,%eax
  801b7c:	8b 40 48             	mov    0x48(%eax),%eax
  801b7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b87:	c7 04 24 38 33 80 00 	movl   $0x803338,(%esp)
  801b8e:	e8 0f e7 ff ff       	call   8002a2 <cprintf>
		return -E_INVAL;
  801b93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b98:	eb 24                	jmp    801bbe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9d:	8b 52 0c             	mov    0xc(%edx),%edx
  801ba0:	85 d2                	test   %edx,%edx
  801ba2:	74 15                	je     801bb9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ba4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb2:	89 04 24             	mov    %eax,(%esp)
  801bb5:	ff d2                	call   *%edx
  801bb7:	eb 05                	jmp    801bbe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801bb9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801bbe:	83 c4 24             	add    $0x24,%esp
  801bc1:	5b                   	pop    %ebx
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    

00801bc4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	89 04 24             	mov    %eax,(%esp)
  801bd7:	e8 ea fb ff ff       	call   8017c6 <fd_lookup>
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 0e                	js     801bee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 24             	sub    $0x24,%esp
  801bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c01:	89 1c 24             	mov    %ebx,(%esp)
  801c04:	e8 bd fb ff ff       	call   8017c6 <fd_lookup>
  801c09:	89 c2                	mov    %eax,%edx
  801c0b:	85 d2                	test   %edx,%edx
  801c0d:	78 61                	js     801c70 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c19:	8b 00                	mov    (%eax),%eax
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 f9 fb ff ff       	call   80181c <dev_lookup>
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 49                	js     801c70 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c2e:	75 23                	jne    801c53 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801c30:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c35:	8b 40 48             	mov    0x48(%eax),%eax
  801c38:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c40:	c7 04 24 f8 32 80 00 	movl   $0x8032f8,(%esp)
  801c47:	e8 56 e6 ff ff       	call   8002a2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c51:	eb 1d                	jmp    801c70 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c56:	8b 52 18             	mov    0x18(%edx),%edx
  801c59:	85 d2                	test   %edx,%edx
  801c5b:	74 0e                	je     801c6b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	ff d2                	call   *%edx
  801c69:	eb 05                	jmp    801c70 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801c6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801c70:	83 c4 24             	add    $0x24,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	53                   	push   %ebx
  801c7a:	83 ec 24             	sub    $0x24,%esp
  801c7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	89 04 24             	mov    %eax,(%esp)
  801c8d:	e8 34 fb ff ff       	call   8017c6 <fd_lookup>
  801c92:	89 c2                	mov    %eax,%edx
  801c94:	85 d2                	test   %edx,%edx
  801c96:	78 52                	js     801cea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca2:	8b 00                	mov    (%eax),%eax
  801ca4:	89 04 24             	mov    %eax,(%esp)
  801ca7:	e8 70 fb ff ff       	call   80181c <dev_lookup>
  801cac:	85 c0                	test   %eax,%eax
  801cae:	78 3a                	js     801cea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cb7:	74 2c                	je     801ce5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cb9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cbc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cc3:	00 00 00 
	stat->st_isdir = 0;
  801cc6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ccd:	00 00 00 
	stat->st_dev = dev;
  801cd0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cdd:	89 14 24             	mov    %edx,(%esp)
  801ce0:	ff 50 14             	call   *0x14(%eax)
  801ce3:	eb 05                	jmp    801cea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ce5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801cea:	83 c4 24             	add    $0x24,%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cf8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cff:	00 
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	89 04 24             	mov    %eax,(%esp)
  801d06:	e8 99 02 00 00       	call   801fa4 <open>
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	85 db                	test   %ebx,%ebx
  801d0f:	78 1b                	js     801d2c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d18:	89 1c 24             	mov    %ebx,(%esp)
  801d1b:	e8 56 ff ff ff       	call   801c76 <fstat>
  801d20:	89 c6                	mov    %eax,%esi
	close(fd);
  801d22:	89 1c 24             	mov    %ebx,(%esp)
  801d25:	e8 cd fb ff ff       	call   8018f7 <close>
	return r;
  801d2a:	89 f0                	mov    %esi,%eax
}
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 10             	sub    $0x10,%esp
  801d3b:	89 c6                	mov    %eax,%esi
  801d3d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d3f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d46:	75 11                	jne    801d59 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d4f:	e8 bb f9 ff ff       	call   80170f <ipc_find_env>
  801d54:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d59:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d60:	00 
  801d61:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d68:	00 
  801d69:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d6d:	a1 00 50 80 00       	mov    0x805000,%eax
  801d72:	89 04 24             	mov    %eax,(%esp)
  801d75:	e8 2e f9 ff ff       	call   8016a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d81:	00 
  801d82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d8d:	e8 ae f8 ff ff       	call   801640 <ipc_recv>
}
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	5b                   	pop    %ebx
  801d96:	5e                   	pop    %esi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    

00801d99 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	8b 40 0c             	mov    0xc(%eax),%eax
  801da5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dad:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801db2:	ba 00 00 00 00       	mov    $0x0,%edx
  801db7:	b8 02 00 00 00       	mov    $0x2,%eax
  801dbc:	e8 72 ff ff ff       	call   801d33 <fsipc>
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801dd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd9:	b8 06 00 00 00       	mov    $0x6,%eax
  801dde:	e8 50 ff ff ff       	call   801d33 <fsipc>
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	53                   	push   %ebx
  801de9:	83 ec 14             	sub    $0x14,%esp
  801dec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	8b 40 0c             	mov    0xc(%eax),%eax
  801df5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801dff:	b8 05 00 00 00       	mov    $0x5,%eax
  801e04:	e8 2a ff ff ff       	call   801d33 <fsipc>
  801e09:	89 c2                	mov    %eax,%edx
  801e0b:	85 d2                	test   %edx,%edx
  801e0d:	78 2b                	js     801e3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e16:	00 
  801e17:	89 1c 24             	mov    %ebx,(%esp)
  801e1a:	e8 f8 ea ff ff       	call   800917 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e1f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e2a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3a:	83 c4 14             	add    $0x14,%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    

00801e40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	53                   	push   %ebx
  801e44:	83 ec 14             	sub    $0x14,%esp
  801e47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801e4a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801e50:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801e55:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e58:	8b 55 08             	mov    0x8(%ebp),%edx
  801e5b:	8b 52 0c             	mov    0xc(%edx),%edx
  801e5e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801e64:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801e69:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e74:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e7b:	e8 34 ec ff ff       	call   800ab4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801e80:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801e87:	00 
  801e88:	c7 04 24 6c 33 80 00 	movl   $0x80336c,(%esp)
  801e8f:	e8 0e e4 ff ff       	call   8002a2 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e94:	ba 00 00 00 00       	mov    $0x0,%edx
  801e99:	b8 04 00 00 00       	mov    $0x4,%eax
  801e9e:	e8 90 fe ff ff       	call   801d33 <fsipc>
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	78 53                	js     801efa <devfile_write+0xba>
		return r;
	assert(r <= n);
  801ea7:	39 c3                	cmp    %eax,%ebx
  801ea9:	73 24                	jae    801ecf <devfile_write+0x8f>
  801eab:	c7 44 24 0c 71 33 80 	movl   $0x803371,0xc(%esp)
  801eb2:	00 
  801eb3:	c7 44 24 08 78 33 80 	movl   $0x803378,0x8(%esp)
  801eba:	00 
  801ebb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801ec2:	00 
  801ec3:	c7 04 24 8d 33 80 00 	movl   $0x80338d,(%esp)
  801eca:	e8 da e2 ff ff       	call   8001a9 <_panic>
	assert(r <= PGSIZE);
  801ecf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ed4:	7e 24                	jle    801efa <devfile_write+0xba>
  801ed6:	c7 44 24 0c 98 33 80 	movl   $0x803398,0xc(%esp)
  801edd:	00 
  801ede:	c7 44 24 08 78 33 80 	movl   $0x803378,0x8(%esp)
  801ee5:	00 
  801ee6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801eed:	00 
  801eee:	c7 04 24 8d 33 80 00 	movl   $0x80338d,(%esp)
  801ef5:	e8 af e2 ff ff       	call   8001a9 <_panic>
	return r;
}
  801efa:	83 c4 14             	add    $0x14,%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    

00801f00 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	56                   	push   %esi
  801f04:	53                   	push   %ebx
  801f05:	83 ec 10             	sub    $0x10,%esp
  801f08:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f11:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f16:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f21:	b8 03 00 00 00       	mov    $0x3,%eax
  801f26:	e8 08 fe ff ff       	call   801d33 <fsipc>
  801f2b:	89 c3                	mov    %eax,%ebx
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	78 6a                	js     801f9b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801f31:	39 c6                	cmp    %eax,%esi
  801f33:	73 24                	jae    801f59 <devfile_read+0x59>
  801f35:	c7 44 24 0c 71 33 80 	movl   $0x803371,0xc(%esp)
  801f3c:	00 
  801f3d:	c7 44 24 08 78 33 80 	movl   $0x803378,0x8(%esp)
  801f44:	00 
  801f45:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f4c:	00 
  801f4d:	c7 04 24 8d 33 80 00 	movl   $0x80338d,(%esp)
  801f54:	e8 50 e2 ff ff       	call   8001a9 <_panic>
	assert(r <= PGSIZE);
  801f59:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f5e:	7e 24                	jle    801f84 <devfile_read+0x84>
  801f60:	c7 44 24 0c 98 33 80 	movl   $0x803398,0xc(%esp)
  801f67:	00 
  801f68:	c7 44 24 08 78 33 80 	movl   $0x803378,0x8(%esp)
  801f6f:	00 
  801f70:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f77:	00 
  801f78:	c7 04 24 8d 33 80 00 	movl   $0x80338d,(%esp)
  801f7f:	e8 25 e2 ff ff       	call   8001a9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f84:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f88:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f8f:	00 
  801f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f93:	89 04 24             	mov    %eax,(%esp)
  801f96:	e8 19 eb ff ff       	call   800ab4 <memmove>
	return r;
}
  801f9b:	89 d8                	mov    %ebx,%eax
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	5b                   	pop    %ebx
  801fa1:	5e                   	pop    %esi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    

00801fa4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 24             	sub    $0x24,%esp
  801fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fae:	89 1c 24             	mov    %ebx,(%esp)
  801fb1:	e8 2a e9 ff ff       	call   8008e0 <strlen>
  801fb6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fbb:	7f 60                	jg     80201d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801fbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc0:	89 04 24             	mov    %eax,(%esp)
  801fc3:	e8 af f7 ff ff       	call   801777 <fd_alloc>
  801fc8:	89 c2                	mov    %eax,%edx
  801fca:	85 d2                	test   %edx,%edx
  801fcc:	78 54                	js     802022 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801fce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fd2:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801fd9:	e8 39 e9 ff ff       	call   800917 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fee:	e8 40 fd ff ff       	call   801d33 <fsipc>
  801ff3:	89 c3                	mov    %eax,%ebx
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	79 17                	jns    802010 <open+0x6c>
		fd_close(fd, 0);
  801ff9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802000:	00 
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	89 04 24             	mov    %eax,(%esp)
  802007:	e8 6a f8 ff ff       	call   801876 <fd_close>
		return r;
  80200c:	89 d8                	mov    %ebx,%eax
  80200e:	eb 12                	jmp    802022 <open+0x7e>
	}

	return fd2num(fd);
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	89 04 24             	mov    %eax,(%esp)
  802016:	e8 35 f7 ff ff       	call   801750 <fd2num>
  80201b:	eb 05                	jmp    802022 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80201d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802022:	83 c4 24             	add    $0x24,%esp
  802025:	5b                   	pop    %ebx
  802026:	5d                   	pop    %ebp
  802027:	c3                   	ret    

00802028 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80202e:	ba 00 00 00 00       	mov    $0x0,%edx
  802033:	b8 08 00 00 00       	mov    $0x8,%eax
  802038:	e8 f6 fc ff ff       	call   801d33 <fsipc>
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <evict>:

int evict(void)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802045:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  80204c:	e8 51 e2 ff ff       	call   8002a2 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802051:	ba 00 00 00 00       	mov    $0x0,%edx
  802056:	b8 09 00 00 00       	mov    $0x9,%eax
  80205b:	e8 d3 fc ff ff       	call   801d33 <fsipc>
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    
  802062:	66 90                	xchg   %ax,%ax
  802064:	66 90                	xchg   %ax,%ax
  802066:	66 90                	xchg   %ax,%ax
  802068:	66 90                	xchg   %ax,%ax
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	66 90                	xchg   %ax,%ax
  80206e:	66 90                	xchg   %ax,%ax

00802070 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802076:	c7 44 24 04 bd 33 80 	movl   $0x8033bd,0x4(%esp)
  80207d:	00 
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 8e e8 ff ff       	call   800917 <strcpy>
	return 0;
}
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	53                   	push   %ebx
  802094:	83 ec 14             	sub    $0x14,%esp
  802097:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80209a:	89 1c 24             	mov    %ebx,(%esp)
  80209d:	e8 bd 0a 00 00       	call   802b5f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8020a2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8020a7:	83 f8 01             	cmp    $0x1,%eax
  8020aa:	75 0d                	jne    8020b9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8020ac:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020af:	89 04 24             	mov    %eax,(%esp)
  8020b2:	e8 29 03 00 00       	call   8023e0 <nsipc_close>
  8020b7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8020b9:	89 d0                	mov    %edx,%eax
  8020bb:	83 c4 14             	add    $0x14,%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5d                   	pop    %ebp
  8020c0:	c3                   	ret    

008020c1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020ce:	00 
  8020cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e3:	89 04 24             	mov    %eax,(%esp)
  8020e6:	e8 f0 03 00 00       	call   8024db <nsipc_send>
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020fa:	00 
  8020fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  802102:	8b 45 0c             	mov    0xc(%ebp),%eax
  802105:	89 44 24 04          	mov    %eax,0x4(%esp)
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 40 0c             	mov    0xc(%eax),%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 44 03 00 00       	call   80245b <nsipc_recv>
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80211f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802122:	89 54 24 04          	mov    %edx,0x4(%esp)
  802126:	89 04 24             	mov    %eax,(%esp)
  802129:	e8 98 f6 ff ff       	call   8017c6 <fd_lookup>
  80212e:	85 c0                	test   %eax,%eax
  802130:	78 17                	js     802149 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80213b:	39 08                	cmp    %ecx,(%eax)
  80213d:	75 05                	jne    802144 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80213f:	8b 40 0c             	mov    0xc(%eax),%eax
  802142:	eb 05                	jmp    802149 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802144:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	83 ec 20             	sub    $0x20,%esp
  802153:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802155:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802158:	89 04 24             	mov    %eax,(%esp)
  80215b:	e8 17 f6 ff ff       	call   801777 <fd_alloc>
  802160:	89 c3                	mov    %eax,%ebx
  802162:	85 c0                	test   %eax,%eax
  802164:	78 21                	js     802187 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802166:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80216d:	00 
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	89 44 24 04          	mov    %eax,0x4(%esp)
  802175:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80217c:	e8 04 ec ff ff       	call   800d85 <sys_page_alloc>
  802181:	89 c3                	mov    %eax,%ebx
  802183:	85 c0                	test   %eax,%eax
  802185:	79 0c                	jns    802193 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802187:	89 34 24             	mov    %esi,(%esp)
  80218a:	e8 51 02 00 00       	call   8023e0 <nsipc_close>
		return r;
  80218f:	89 d8                	mov    %ebx,%eax
  802191:	eb 20                	jmp    8021b3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802193:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8021a8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8021ab:	89 14 24             	mov    %edx,(%esp)
  8021ae:	e8 9d f5 ff ff       	call   801750 <fd2num>
}
  8021b3:	83 c4 20             	add    $0x20,%esp
  8021b6:	5b                   	pop    %ebx
  8021b7:	5e                   	pop    %esi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	e8 51 ff ff ff       	call   802119 <fd2sockid>
		return r;
  8021c8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 23                	js     8021f1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021ce:	8b 55 10             	mov    0x10(%ebp),%edx
  8021d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021dc:	89 04 24             	mov    %eax,(%esp)
  8021df:	e8 45 01 00 00       	call   802329 <nsipc_accept>
		return r;
  8021e4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 07                	js     8021f1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8021ea:	e8 5c ff ff ff       	call   80214b <alloc_sockfd>
  8021ef:	89 c1                	mov    %eax,%ecx
}
  8021f1:	89 c8                	mov    %ecx,%eax
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	e8 16 ff ff ff       	call   802119 <fd2sockid>
  802203:	89 c2                	mov    %eax,%edx
  802205:	85 d2                	test   %edx,%edx
  802207:	78 16                	js     80221f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	89 14 24             	mov    %edx,(%esp)
  80221a:	e8 60 01 00 00       	call   80237f <nsipc_bind>
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <shutdown>:

int
shutdown(int s, int how)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	e8 ea fe ff ff       	call   802119 <fd2sockid>
  80222f:	89 c2                	mov    %eax,%edx
  802231:	85 d2                	test   %edx,%edx
  802233:	78 0f                	js     802244 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802235:	8b 45 0c             	mov    0xc(%ebp),%eax
  802238:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223c:	89 14 24             	mov    %edx,(%esp)
  80223f:	e8 7a 01 00 00       	call   8023be <nsipc_shutdown>
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	e8 c5 fe ff ff       	call   802119 <fd2sockid>
  802254:	89 c2                	mov    %eax,%edx
  802256:	85 d2                	test   %edx,%edx
  802258:	78 16                	js     802270 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80225a:	8b 45 10             	mov    0x10(%ebp),%eax
  80225d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802261:	8b 45 0c             	mov    0xc(%ebp),%eax
  802264:	89 44 24 04          	mov    %eax,0x4(%esp)
  802268:	89 14 24             	mov    %edx,(%esp)
  80226b:	e8 8a 01 00 00       	call   8023fa <nsipc_connect>
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <listen>:

int
listen(int s, int backlog)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	e8 99 fe ff ff       	call   802119 <fd2sockid>
  802280:	89 c2                	mov    %eax,%edx
  802282:	85 d2                	test   %edx,%edx
  802284:	78 0f                	js     802295 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802286:	8b 45 0c             	mov    0xc(%ebp),%eax
  802289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228d:	89 14 24             	mov    %edx,(%esp)
  802290:	e8 a4 01 00 00       	call   802439 <nsipc_listen>
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80229d:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	89 04 24             	mov    %eax,(%esp)
  8022b1:	e8 98 02 00 00       	call   80254e <nsipc_socket>
  8022b6:	89 c2                	mov    %eax,%edx
  8022b8:	85 d2                	test   %edx,%edx
  8022ba:	78 05                	js     8022c1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8022bc:	e8 8a fe ff ff       	call   80214b <alloc_sockfd>
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	53                   	push   %ebx
  8022c7:	83 ec 14             	sub    $0x14,%esp
  8022ca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022cc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8022d3:	75 11                	jne    8022e6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022dc:	e8 2e f4 ff ff       	call   80170f <ipc_find_env>
  8022e1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022e6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022ed:	00 
  8022ee:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8022f5:	00 
  8022f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022fa:	a1 04 50 80 00       	mov    0x805004,%eax
  8022ff:	89 04 24             	mov    %eax,(%esp)
  802302:	e8 a1 f3 ff ff       	call   8016a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802307:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80230e:	00 
  80230f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802316:	00 
  802317:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80231e:	e8 1d f3 ff ff       	call   801640 <ipc_recv>
}
  802323:	83 c4 14             	add    $0x14,%esp
  802326:	5b                   	pop    %ebx
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    

00802329 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	83 ec 10             	sub    $0x10,%esp
  802331:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80233c:	8b 06                	mov    (%esi),%eax
  80233e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802343:	b8 01 00 00 00       	mov    $0x1,%eax
  802348:	e8 76 ff ff ff       	call   8022c3 <nsipc>
  80234d:	89 c3                	mov    %eax,%ebx
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 23                	js     802376 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802353:	a1 10 70 80 00       	mov    0x807010,%eax
  802358:	89 44 24 08          	mov    %eax,0x8(%esp)
  80235c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802363:	00 
  802364:	8b 45 0c             	mov    0xc(%ebp),%eax
  802367:	89 04 24             	mov    %eax,(%esp)
  80236a:	e8 45 e7 ff ff       	call   800ab4 <memmove>
		*addrlen = ret->ret_addrlen;
  80236f:	a1 10 70 80 00       	mov    0x807010,%eax
  802374:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802376:	89 d8                	mov    %ebx,%eax
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	5b                   	pop    %ebx
  80237c:	5e                   	pop    %esi
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    

0080237f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	53                   	push   %ebx
  802383:	83 ec 14             	sub    $0x14,%esp
  802386:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802391:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802395:	8b 45 0c             	mov    0xc(%ebp),%eax
  802398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023a3:	e8 0c e7 ff ff       	call   800ab4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023a8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8023b3:	e8 0b ff ff ff       	call   8022c3 <nsipc>
}
  8023b8:	83 c4 14             	add    $0x14,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8023cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8023d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8023d9:	e8 e5 fe ff ff       	call   8022c3 <nsipc>
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <nsipc_close>:

int
nsipc_close(int s)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8023f3:	e8 cb fe ff ff       	call   8022c3 <nsipc>
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 14             	sub    $0x14,%esp
  802401:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80240c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802410:	8b 45 0c             	mov    0xc(%ebp),%eax
  802413:	89 44 24 04          	mov    %eax,0x4(%esp)
  802417:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80241e:	e8 91 e6 ff ff       	call   800ab4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802423:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802429:	b8 05 00 00 00       	mov    $0x5,%eax
  80242e:	e8 90 fe ff ff       	call   8022c3 <nsipc>
}
  802433:	83 c4 14             	add    $0x14,%esp
  802436:	5b                   	pop    %ebx
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80244f:	b8 06 00 00 00       	mov    $0x6,%eax
  802454:	e8 6a fe ff ff       	call   8022c3 <nsipc>
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	56                   	push   %esi
  80245f:	53                   	push   %ebx
  802460:	83 ec 10             	sub    $0x10,%esp
  802463:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80246e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802474:	8b 45 14             	mov    0x14(%ebp),%eax
  802477:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80247c:	b8 07 00 00 00       	mov    $0x7,%eax
  802481:	e8 3d fe ff ff       	call   8022c3 <nsipc>
  802486:	89 c3                	mov    %eax,%ebx
  802488:	85 c0                	test   %eax,%eax
  80248a:	78 46                	js     8024d2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80248c:	39 f0                	cmp    %esi,%eax
  80248e:	7f 07                	jg     802497 <nsipc_recv+0x3c>
  802490:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802495:	7e 24                	jle    8024bb <nsipc_recv+0x60>
  802497:	c7 44 24 0c c9 33 80 	movl   $0x8033c9,0xc(%esp)
  80249e:	00 
  80249f:	c7 44 24 08 78 33 80 	movl   $0x803378,0x8(%esp)
  8024a6:	00 
  8024a7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8024ae:	00 
  8024af:	c7 04 24 de 33 80 00 	movl   $0x8033de,(%esp)
  8024b6:	e8 ee dc ff ff       	call   8001a9 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024bf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8024c6:	00 
  8024c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ca:	89 04 24             	mov    %eax,(%esp)
  8024cd:	e8 e2 e5 ff ff       	call   800ab4 <memmove>
	}

	return r;
}
  8024d2:	89 d8                	mov    %ebx,%eax
  8024d4:	83 c4 10             	add    $0x10,%esp
  8024d7:	5b                   	pop    %ebx
  8024d8:	5e                   	pop    %esi
  8024d9:	5d                   	pop    %ebp
  8024da:	c3                   	ret    

008024db <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	53                   	push   %ebx
  8024df:	83 ec 14             	sub    $0x14,%esp
  8024e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024ed:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024f3:	7e 24                	jle    802519 <nsipc_send+0x3e>
  8024f5:	c7 44 24 0c ea 33 80 	movl   $0x8033ea,0xc(%esp)
  8024fc:	00 
  8024fd:	c7 44 24 08 78 33 80 	movl   $0x803378,0x8(%esp)
  802504:	00 
  802505:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80250c:	00 
  80250d:	c7 04 24 de 33 80 00 	movl   $0x8033de,(%esp)
  802514:	e8 90 dc ff ff       	call   8001a9 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802519:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80251d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802520:	89 44 24 04          	mov    %eax,0x4(%esp)
  802524:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80252b:	e8 84 e5 ff ff       	call   800ab4 <memmove>
	nsipcbuf.send.req_size = size;
  802530:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802536:	8b 45 14             	mov    0x14(%ebp),%eax
  802539:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80253e:	b8 08 00 00 00       	mov    $0x8,%eax
  802543:	e8 7b fd ff ff       	call   8022c3 <nsipc>
}
  802548:	83 c4 14             	add    $0x14,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5d                   	pop    %ebp
  80254d:	c3                   	ret    

0080254e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80255c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802564:	8b 45 10             	mov    0x10(%ebp),%eax
  802567:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80256c:	b8 09 00 00 00       	mov    $0x9,%eax
  802571:	e8 4d fd ff ff       	call   8022c3 <nsipc>
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	56                   	push   %esi
  80257c:	53                   	push   %ebx
  80257d:	83 ec 10             	sub    $0x10,%esp
  802580:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	89 04 24             	mov    %eax,(%esp)
  802589:	e8 d2 f1 ff ff       	call   801760 <fd2data>
  80258e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802590:	c7 44 24 04 f6 33 80 	movl   $0x8033f6,0x4(%esp)
  802597:	00 
  802598:	89 1c 24             	mov    %ebx,(%esp)
  80259b:	e8 77 e3 ff ff       	call   800917 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025a0:	8b 46 04             	mov    0x4(%esi),%eax
  8025a3:	2b 06                	sub    (%esi),%eax
  8025a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8025ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8025b2:	00 00 00 
	stat->st_dev = &devpipe;
  8025b5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8025bc:	40 80 00 
	return 0;
}
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c4:	83 c4 10             	add    $0x10,%esp
  8025c7:	5b                   	pop    %ebx
  8025c8:	5e                   	pop    %esi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    

008025cb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	53                   	push   %ebx
  8025cf:	83 ec 14             	sub    $0x14,%esp
  8025d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e0:	e8 47 e8 ff ff       	call   800e2c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025e5:	89 1c 24             	mov    %ebx,(%esp)
  8025e8:	e8 73 f1 ff ff       	call   801760 <fd2data>
  8025ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f8:	e8 2f e8 ff ff       	call   800e2c <sys_page_unmap>
}
  8025fd:	83 c4 14             	add    $0x14,%esp
  802600:	5b                   	pop    %ebx
  802601:	5d                   	pop    %ebp
  802602:	c3                   	ret    

00802603 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	57                   	push   %edi
  802607:	56                   	push   %esi
  802608:	53                   	push   %ebx
  802609:	83 ec 2c             	sub    $0x2c,%esp
  80260c:	89 c6                	mov    %eax,%esi
  80260e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802611:	a1 08 50 80 00       	mov    0x805008,%eax
  802616:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802619:	89 34 24             	mov    %esi,(%esp)
  80261c:	e8 3e 05 00 00       	call   802b5f <pageref>
  802621:	89 c7                	mov    %eax,%edi
  802623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802626:	89 04 24             	mov    %eax,(%esp)
  802629:	e8 31 05 00 00       	call   802b5f <pageref>
  80262e:	39 c7                	cmp    %eax,%edi
  802630:	0f 94 c2             	sete   %dl
  802633:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802636:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80263c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80263f:	39 fb                	cmp    %edi,%ebx
  802641:	74 21                	je     802664 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802643:	84 d2                	test   %dl,%dl
  802645:	74 ca                	je     802611 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802647:	8b 51 58             	mov    0x58(%ecx),%edx
  80264a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80264e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802652:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802656:	c7 04 24 fd 33 80 00 	movl   $0x8033fd,(%esp)
  80265d:	e8 40 dc ff ff       	call   8002a2 <cprintf>
  802662:	eb ad                	jmp    802611 <_pipeisclosed+0xe>
	}
}
  802664:	83 c4 2c             	add    $0x2c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    

0080266c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	57                   	push   %edi
  802670:	56                   	push   %esi
  802671:	53                   	push   %ebx
  802672:	83 ec 1c             	sub    $0x1c,%esp
  802675:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802678:	89 34 24             	mov    %esi,(%esp)
  80267b:	e8 e0 f0 ff ff       	call   801760 <fd2data>
  802680:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802682:	bf 00 00 00 00       	mov    $0x0,%edi
  802687:	eb 45                	jmp    8026ce <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802689:	89 da                	mov    %ebx,%edx
  80268b:	89 f0                	mov    %esi,%eax
  80268d:	e8 71 ff ff ff       	call   802603 <_pipeisclosed>
  802692:	85 c0                	test   %eax,%eax
  802694:	75 41                	jne    8026d7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802696:	e8 cb e6 ff ff       	call   800d66 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80269b:	8b 43 04             	mov    0x4(%ebx),%eax
  80269e:	8b 0b                	mov    (%ebx),%ecx
  8026a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8026a3:	39 d0                	cmp    %edx,%eax
  8026a5:	73 e2                	jae    802689 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8026ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8026b1:	99                   	cltd   
  8026b2:	c1 ea 1b             	shr    $0x1b,%edx
  8026b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8026b8:	83 e1 1f             	and    $0x1f,%ecx
  8026bb:	29 d1                	sub    %edx,%ecx
  8026bd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8026c1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8026c5:	83 c0 01             	add    $0x1,%eax
  8026c8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026cb:	83 c7 01             	add    $0x1,%edi
  8026ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026d1:	75 c8                	jne    80269b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8026d3:	89 f8                	mov    %edi,%eax
  8026d5:	eb 05                	jmp    8026dc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8026dc:	83 c4 1c             	add    $0x1c,%esp
  8026df:	5b                   	pop    %ebx
  8026e0:	5e                   	pop    %esi
  8026e1:	5f                   	pop    %edi
  8026e2:	5d                   	pop    %ebp
  8026e3:	c3                   	ret    

008026e4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	57                   	push   %edi
  8026e8:	56                   	push   %esi
  8026e9:	53                   	push   %ebx
  8026ea:	83 ec 1c             	sub    $0x1c,%esp
  8026ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026f0:	89 3c 24             	mov    %edi,(%esp)
  8026f3:	e8 68 f0 ff ff       	call   801760 <fd2data>
  8026f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026fa:	be 00 00 00 00       	mov    $0x0,%esi
  8026ff:	eb 3d                	jmp    80273e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802701:	85 f6                	test   %esi,%esi
  802703:	74 04                	je     802709 <devpipe_read+0x25>
				return i;
  802705:	89 f0                	mov    %esi,%eax
  802707:	eb 43                	jmp    80274c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802709:	89 da                	mov    %ebx,%edx
  80270b:	89 f8                	mov    %edi,%eax
  80270d:	e8 f1 fe ff ff       	call   802603 <_pipeisclosed>
  802712:	85 c0                	test   %eax,%eax
  802714:	75 31                	jne    802747 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802716:	e8 4b e6 ff ff       	call   800d66 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80271b:	8b 03                	mov    (%ebx),%eax
  80271d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802720:	74 df                	je     802701 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802722:	99                   	cltd   
  802723:	c1 ea 1b             	shr    $0x1b,%edx
  802726:	01 d0                	add    %edx,%eax
  802728:	83 e0 1f             	and    $0x1f,%eax
  80272b:	29 d0                	sub    %edx,%eax
  80272d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802732:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802735:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802738:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80273b:	83 c6 01             	add    $0x1,%esi
  80273e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802741:	75 d8                	jne    80271b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802743:	89 f0                	mov    %esi,%eax
  802745:	eb 05                	jmp    80274c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802747:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80274c:	83 c4 1c             	add    $0x1c,%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    

00802754 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	56                   	push   %esi
  802758:	53                   	push   %ebx
  802759:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80275c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80275f:	89 04 24             	mov    %eax,(%esp)
  802762:	e8 10 f0 ff ff       	call   801777 <fd_alloc>
  802767:	89 c2                	mov    %eax,%edx
  802769:	85 d2                	test   %edx,%edx
  80276b:	0f 88 4d 01 00 00    	js     8028be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802771:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802778:	00 
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802780:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802787:	e8 f9 e5 ff ff       	call   800d85 <sys_page_alloc>
  80278c:	89 c2                	mov    %eax,%edx
  80278e:	85 d2                	test   %edx,%edx
  802790:	0f 88 28 01 00 00    	js     8028be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802796:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802799:	89 04 24             	mov    %eax,(%esp)
  80279c:	e8 d6 ef ff ff       	call   801777 <fd_alloc>
  8027a1:	89 c3                	mov    %eax,%ebx
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	0f 88 fe 00 00 00    	js     8028a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027b2:	00 
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027c1:	e8 bf e5 ff ff       	call   800d85 <sys_page_alloc>
  8027c6:	89 c3                	mov    %eax,%ebx
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	0f 88 d9 00 00 00    	js     8028a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	89 04 24             	mov    %eax,(%esp)
  8027d6:	e8 85 ef ff ff       	call   801760 <fd2data>
  8027db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027dd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027e4:	00 
  8027e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f0:	e8 90 e5 ff ff       	call   800d85 <sys_page_alloc>
  8027f5:	89 c3                	mov    %eax,%ebx
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	0f 88 97 00 00 00    	js     802896 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802802:	89 04 24             	mov    %eax,(%esp)
  802805:	e8 56 ef ff ff       	call   801760 <fd2data>
  80280a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802811:	00 
  802812:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802816:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80281d:	00 
  80281e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802822:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802829:	e8 ab e5 ff ff       	call   800dd9 <sys_page_map>
  80282e:	89 c3                	mov    %eax,%ebx
  802830:	85 c0                	test   %eax,%eax
  802832:	78 52                	js     802886 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802834:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802849:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	89 04 24             	mov    %eax,(%esp)
  802864:	e8 e7 ee ff ff       	call   801750 <fd2num>
  802869:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80286c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	89 04 24             	mov    %eax,(%esp)
  802874:	e8 d7 ee ff ff       	call   801750 <fd2num>
  802879:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80287c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80287f:	b8 00 00 00 00       	mov    $0x0,%eax
  802884:	eb 38                	jmp    8028be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802886:	89 74 24 04          	mov    %esi,0x4(%esp)
  80288a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802891:	e8 96 e5 ff ff       	call   800e2c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	89 44 24 04          	mov    %eax,0x4(%esp)
  80289d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a4:	e8 83 e5 ff ff       	call   800e2c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b7:	e8 70 e5 ff ff       	call   800e2c <sys_page_unmap>
  8028bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8028be:	83 c4 30             	add    $0x30,%esp
  8028c1:	5b                   	pop    %ebx
  8028c2:	5e                   	pop    %esi
  8028c3:	5d                   	pop    %ebp
  8028c4:	c3                   	ret    

008028c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	89 04 24             	mov    %eax,(%esp)
  8028d8:	e8 e9 ee ff ff       	call   8017c6 <fd_lookup>
  8028dd:	89 c2                	mov    %eax,%edx
  8028df:	85 d2                	test   %edx,%edx
  8028e1:	78 15                	js     8028f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	89 04 24             	mov    %eax,(%esp)
  8028e9:	e8 72 ee ff ff       	call   801760 <fd2data>
	return _pipeisclosed(fd, p);
  8028ee:	89 c2                	mov    %eax,%edx
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	e8 0b fd ff ff       	call   802603 <_pipeisclosed>
}
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    
  8028fa:	66 90                	xchg   %ax,%ax
  8028fc:	66 90                	xchg   %ax,%ax
  8028fe:	66 90                	xchg   %ax,%ax

00802900 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	5d                   	pop    %ebp
  802909:	c3                   	ret    

0080290a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802910:	c7 44 24 04 15 34 80 	movl   $0x803415,0x4(%esp)
  802917:	00 
  802918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291b:	89 04 24             	mov    %eax,(%esp)
  80291e:	e8 f4 df ff ff       	call   800917 <strcpy>
	return 0;
}
  802923:	b8 00 00 00 00       	mov    $0x0,%eax
  802928:	c9                   	leave  
  802929:	c3                   	ret    

0080292a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	57                   	push   %edi
  80292e:	56                   	push   %esi
  80292f:	53                   	push   %ebx
  802930:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802936:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80293b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802941:	eb 31                	jmp    802974 <devcons_write+0x4a>
		m = n - tot;
  802943:	8b 75 10             	mov    0x10(%ebp),%esi
  802946:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802948:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80294b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802950:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802953:	89 74 24 08          	mov    %esi,0x8(%esp)
  802957:	03 45 0c             	add    0xc(%ebp),%eax
  80295a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80295e:	89 3c 24             	mov    %edi,(%esp)
  802961:	e8 4e e1 ff ff       	call   800ab4 <memmove>
		sys_cputs(buf, m);
  802966:	89 74 24 04          	mov    %esi,0x4(%esp)
  80296a:	89 3c 24             	mov    %edi,(%esp)
  80296d:	e8 f4 e2 ff ff       	call   800c66 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802972:	01 f3                	add    %esi,%ebx
  802974:	89 d8                	mov    %ebx,%eax
  802976:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802979:	72 c8                	jb     802943 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80297b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    

00802986 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802991:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802995:	75 07                	jne    80299e <devcons_read+0x18>
  802997:	eb 2a                	jmp    8029c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802999:	e8 c8 e3 ff ff       	call   800d66 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80299e:	66 90                	xchg   %ax,%ax
  8029a0:	e8 df e2 ff ff       	call   800c84 <sys_cgetc>
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 f0                	je     802999 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	78 16                	js     8029c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029ad:	83 f8 04             	cmp    $0x4,%eax
  8029b0:	74 0c                	je     8029be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8029b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b5:	88 02                	mov    %al,(%edx)
	return 1;
  8029b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bc:	eb 05                	jmp    8029c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8029c3:	c9                   	leave  
  8029c4:	c3                   	ret    

008029c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
  8029c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029d8:	00 
  8029d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029dc:	89 04 24             	mov    %eax,(%esp)
  8029df:	e8 82 e2 ff ff       	call   800c66 <sys_cputs>
}
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <getchar>:

int
getchar(void)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
  8029e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029f3:	00 
  8029f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a02:	e8 53 f0 ff ff       	call   801a5a <read>
	if (r < 0)
  802a07:	85 c0                	test   %eax,%eax
  802a09:	78 0f                	js     802a1a <getchar+0x34>
		return r;
	if (r < 1)
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	7e 06                	jle    802a15 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a0f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a13:	eb 05                	jmp    802a1a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a15:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    

00802a1c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	89 04 24             	mov    %eax,(%esp)
  802a2f:	e8 92 ed ff ff       	call   8017c6 <fd_lookup>
  802a34:	85 c0                	test   %eax,%eax
  802a36:	78 11                	js     802a49 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a41:	39 10                	cmp    %edx,(%eax)
  802a43:	0f 94 c0             	sete   %al
  802a46:	0f b6 c0             	movzbl %al,%eax
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <opencons>:

int
opencons(void)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a54:	89 04 24             	mov    %eax,(%esp)
  802a57:	e8 1b ed ff ff       	call   801777 <fd_alloc>
		return r;
  802a5c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a5e:	85 c0                	test   %eax,%eax
  802a60:	78 40                	js     802aa2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a62:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a69:	00 
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a78:	e8 08 e3 ff ff       	call   800d85 <sys_page_alloc>
		return r;
  802a7d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	78 1f                	js     802aa2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a83:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a98:	89 04 24             	mov    %eax,(%esp)
  802a9b:	e8 b0 ec ff ff       	call   801750 <fd2num>
  802aa0:	89 c2                	mov    %eax,%edx
}
  802aa2:	89 d0                	mov    %edx,%eax
  802aa4:	c9                   	leave  
  802aa5:	c3                   	ret    

00802aa6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
  802aa9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802aac:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802ab3:	75 7a                	jne    802b2f <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802ab5:	e8 8d e2 ff ff       	call   800d47 <sys_getenvid>
  802aba:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ac1:	00 
  802ac2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802ac9:	ee 
  802aca:	89 04 24             	mov    %eax,(%esp)
  802acd:	e8 b3 e2 ff ff       	call   800d85 <sys_page_alloc>
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	79 20                	jns    802af6 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802ad6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ada:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  802ae1:	00 
  802ae2:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802ae9:	00 
  802aea:	c7 04 24 21 34 80 00 	movl   $0x803421,(%esp)
  802af1:	e8 b3 d6 ff ff       	call   8001a9 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802af6:	e8 4c e2 ff ff       	call   800d47 <sys_getenvid>
  802afb:	c7 44 24 04 39 2b 80 	movl   $0x802b39,0x4(%esp)
  802b02:	00 
  802b03:	89 04 24             	mov    %eax,(%esp)
  802b06:	e8 3a e4 ff ff       	call   800f45 <sys_env_set_pgfault_upcall>
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	79 20                	jns    802b2f <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802b0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b13:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  802b1a:	00 
  802b1b:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802b22:	00 
  802b23:	c7 04 24 21 34 80 00 	movl   $0x803421,(%esp)
  802b2a:	e8 7a d6 ff ff       	call   8001a9 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b37:	c9                   	leave  
  802b38:	c3                   	ret    

00802b39 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b39:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b3a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802b3f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b41:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802b44:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802b48:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802b4c:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802b4f:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802b53:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802b55:	83 c4 08             	add    $0x8,%esp
	popal
  802b58:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802b59:	83 c4 04             	add    $0x4,%esp
	popfl
  802b5c:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b5d:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802b5e:	c3                   	ret    

00802b5f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b5f:	55                   	push   %ebp
  802b60:	89 e5                	mov    %esp,%ebp
  802b62:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b65:	89 d0                	mov    %edx,%eax
  802b67:	c1 e8 16             	shr    $0x16,%eax
  802b6a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b71:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b76:	f6 c1 01             	test   $0x1,%cl
  802b79:	74 1d                	je     802b98 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b7b:	c1 ea 0c             	shr    $0xc,%edx
  802b7e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b85:	f6 c2 01             	test   $0x1,%dl
  802b88:	74 0e                	je     802b98 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b8a:	c1 ea 0c             	shr    $0xc,%edx
  802b8d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b94:	ef 
  802b95:	0f b7 c0             	movzwl %ax,%eax
}
  802b98:	5d                   	pop    %ebp
  802b99:	c3                   	ret    
  802b9a:	66 90                	xchg   %ax,%ax
  802b9c:	66 90                	xchg   %ax,%ax
  802b9e:	66 90                	xchg   %ax,%ax

00802ba0 <__udivdi3>:
  802ba0:	55                   	push   %ebp
  802ba1:	57                   	push   %edi
  802ba2:	56                   	push   %esi
  802ba3:	83 ec 0c             	sub    $0xc,%esp
  802ba6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802baa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802bae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802bb2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bbc:	89 ea                	mov    %ebp,%edx
  802bbe:	89 0c 24             	mov    %ecx,(%esp)
  802bc1:	75 2d                	jne    802bf0 <__udivdi3+0x50>
  802bc3:	39 e9                	cmp    %ebp,%ecx
  802bc5:	77 61                	ja     802c28 <__udivdi3+0x88>
  802bc7:	85 c9                	test   %ecx,%ecx
  802bc9:	89 ce                	mov    %ecx,%esi
  802bcb:	75 0b                	jne    802bd8 <__udivdi3+0x38>
  802bcd:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd2:	31 d2                	xor    %edx,%edx
  802bd4:	f7 f1                	div    %ecx
  802bd6:	89 c6                	mov    %eax,%esi
  802bd8:	31 d2                	xor    %edx,%edx
  802bda:	89 e8                	mov    %ebp,%eax
  802bdc:	f7 f6                	div    %esi
  802bde:	89 c5                	mov    %eax,%ebp
  802be0:	89 f8                	mov    %edi,%eax
  802be2:	f7 f6                	div    %esi
  802be4:	89 ea                	mov    %ebp,%edx
  802be6:	83 c4 0c             	add    $0xc,%esp
  802be9:	5e                   	pop    %esi
  802bea:	5f                   	pop    %edi
  802beb:	5d                   	pop    %ebp
  802bec:	c3                   	ret    
  802bed:	8d 76 00             	lea    0x0(%esi),%esi
  802bf0:	39 e8                	cmp    %ebp,%eax
  802bf2:	77 24                	ja     802c18 <__udivdi3+0x78>
  802bf4:	0f bd e8             	bsr    %eax,%ebp
  802bf7:	83 f5 1f             	xor    $0x1f,%ebp
  802bfa:	75 3c                	jne    802c38 <__udivdi3+0x98>
  802bfc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c00:	39 34 24             	cmp    %esi,(%esp)
  802c03:	0f 86 9f 00 00 00    	jbe    802ca8 <__udivdi3+0x108>
  802c09:	39 d0                	cmp    %edx,%eax
  802c0b:	0f 82 97 00 00 00    	jb     802ca8 <__udivdi3+0x108>
  802c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c18:	31 d2                	xor    %edx,%edx
  802c1a:	31 c0                	xor    %eax,%eax
  802c1c:	83 c4 0c             	add    $0xc,%esp
  802c1f:	5e                   	pop    %esi
  802c20:	5f                   	pop    %edi
  802c21:	5d                   	pop    %ebp
  802c22:	c3                   	ret    
  802c23:	90                   	nop
  802c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c28:	89 f8                	mov    %edi,%eax
  802c2a:	f7 f1                	div    %ecx
  802c2c:	31 d2                	xor    %edx,%edx
  802c2e:	83 c4 0c             	add    $0xc,%esp
  802c31:	5e                   	pop    %esi
  802c32:	5f                   	pop    %edi
  802c33:	5d                   	pop    %ebp
  802c34:	c3                   	ret    
  802c35:	8d 76 00             	lea    0x0(%esi),%esi
  802c38:	89 e9                	mov    %ebp,%ecx
  802c3a:	8b 3c 24             	mov    (%esp),%edi
  802c3d:	d3 e0                	shl    %cl,%eax
  802c3f:	89 c6                	mov    %eax,%esi
  802c41:	b8 20 00 00 00       	mov    $0x20,%eax
  802c46:	29 e8                	sub    %ebp,%eax
  802c48:	89 c1                	mov    %eax,%ecx
  802c4a:	d3 ef                	shr    %cl,%edi
  802c4c:	89 e9                	mov    %ebp,%ecx
  802c4e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c52:	8b 3c 24             	mov    (%esp),%edi
  802c55:	09 74 24 08          	or     %esi,0x8(%esp)
  802c59:	89 d6                	mov    %edx,%esi
  802c5b:	d3 e7                	shl    %cl,%edi
  802c5d:	89 c1                	mov    %eax,%ecx
  802c5f:	89 3c 24             	mov    %edi,(%esp)
  802c62:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c66:	d3 ee                	shr    %cl,%esi
  802c68:	89 e9                	mov    %ebp,%ecx
  802c6a:	d3 e2                	shl    %cl,%edx
  802c6c:	89 c1                	mov    %eax,%ecx
  802c6e:	d3 ef                	shr    %cl,%edi
  802c70:	09 d7                	or     %edx,%edi
  802c72:	89 f2                	mov    %esi,%edx
  802c74:	89 f8                	mov    %edi,%eax
  802c76:	f7 74 24 08          	divl   0x8(%esp)
  802c7a:	89 d6                	mov    %edx,%esi
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	f7 24 24             	mull   (%esp)
  802c81:	39 d6                	cmp    %edx,%esi
  802c83:	89 14 24             	mov    %edx,(%esp)
  802c86:	72 30                	jb     802cb8 <__udivdi3+0x118>
  802c88:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c8c:	89 e9                	mov    %ebp,%ecx
  802c8e:	d3 e2                	shl    %cl,%edx
  802c90:	39 c2                	cmp    %eax,%edx
  802c92:	73 05                	jae    802c99 <__udivdi3+0xf9>
  802c94:	3b 34 24             	cmp    (%esp),%esi
  802c97:	74 1f                	je     802cb8 <__udivdi3+0x118>
  802c99:	89 f8                	mov    %edi,%eax
  802c9b:	31 d2                	xor    %edx,%edx
  802c9d:	e9 7a ff ff ff       	jmp    802c1c <__udivdi3+0x7c>
  802ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ca8:	31 d2                	xor    %edx,%edx
  802caa:	b8 01 00 00 00       	mov    $0x1,%eax
  802caf:	e9 68 ff ff ff       	jmp    802c1c <__udivdi3+0x7c>
  802cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cb8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802cbb:	31 d2                	xor    %edx,%edx
  802cbd:	83 c4 0c             	add    $0xc,%esp
  802cc0:	5e                   	pop    %esi
  802cc1:	5f                   	pop    %edi
  802cc2:	5d                   	pop    %ebp
  802cc3:	c3                   	ret    
  802cc4:	66 90                	xchg   %ax,%ax
  802cc6:	66 90                	xchg   %ax,%ax
  802cc8:	66 90                	xchg   %ax,%ax
  802cca:	66 90                	xchg   %ax,%ax
  802ccc:	66 90                	xchg   %ax,%ax
  802cce:	66 90                	xchg   %ax,%ax

00802cd0 <__umoddi3>:
  802cd0:	55                   	push   %ebp
  802cd1:	57                   	push   %edi
  802cd2:	56                   	push   %esi
  802cd3:	83 ec 14             	sub    $0x14,%esp
  802cd6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cda:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cde:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ce2:	89 c7                	mov    %eax,%edi
  802ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ce8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802cf0:	89 34 24             	mov    %esi,(%esp)
  802cf3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cf7:	85 c0                	test   %eax,%eax
  802cf9:	89 c2                	mov    %eax,%edx
  802cfb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cff:	75 17                	jne    802d18 <__umoddi3+0x48>
  802d01:	39 fe                	cmp    %edi,%esi
  802d03:	76 4b                	jbe    802d50 <__umoddi3+0x80>
  802d05:	89 c8                	mov    %ecx,%eax
  802d07:	89 fa                	mov    %edi,%edx
  802d09:	f7 f6                	div    %esi
  802d0b:	89 d0                	mov    %edx,%eax
  802d0d:	31 d2                	xor    %edx,%edx
  802d0f:	83 c4 14             	add    $0x14,%esp
  802d12:	5e                   	pop    %esi
  802d13:	5f                   	pop    %edi
  802d14:	5d                   	pop    %ebp
  802d15:	c3                   	ret    
  802d16:	66 90                	xchg   %ax,%ax
  802d18:	39 f8                	cmp    %edi,%eax
  802d1a:	77 54                	ja     802d70 <__umoddi3+0xa0>
  802d1c:	0f bd e8             	bsr    %eax,%ebp
  802d1f:	83 f5 1f             	xor    $0x1f,%ebp
  802d22:	75 5c                	jne    802d80 <__umoddi3+0xb0>
  802d24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d28:	39 3c 24             	cmp    %edi,(%esp)
  802d2b:	0f 87 e7 00 00 00    	ja     802e18 <__umoddi3+0x148>
  802d31:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d35:	29 f1                	sub    %esi,%ecx
  802d37:	19 c7                	sbb    %eax,%edi
  802d39:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d41:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d45:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d49:	83 c4 14             	add    $0x14,%esp
  802d4c:	5e                   	pop    %esi
  802d4d:	5f                   	pop    %edi
  802d4e:	5d                   	pop    %ebp
  802d4f:	c3                   	ret    
  802d50:	85 f6                	test   %esi,%esi
  802d52:	89 f5                	mov    %esi,%ebp
  802d54:	75 0b                	jne    802d61 <__umoddi3+0x91>
  802d56:	b8 01 00 00 00       	mov    $0x1,%eax
  802d5b:	31 d2                	xor    %edx,%edx
  802d5d:	f7 f6                	div    %esi
  802d5f:	89 c5                	mov    %eax,%ebp
  802d61:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d65:	31 d2                	xor    %edx,%edx
  802d67:	f7 f5                	div    %ebp
  802d69:	89 c8                	mov    %ecx,%eax
  802d6b:	f7 f5                	div    %ebp
  802d6d:	eb 9c                	jmp    802d0b <__umoddi3+0x3b>
  802d6f:	90                   	nop
  802d70:	89 c8                	mov    %ecx,%eax
  802d72:	89 fa                	mov    %edi,%edx
  802d74:	83 c4 14             	add    $0x14,%esp
  802d77:	5e                   	pop    %esi
  802d78:	5f                   	pop    %edi
  802d79:	5d                   	pop    %ebp
  802d7a:	c3                   	ret    
  802d7b:	90                   	nop
  802d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d80:	8b 04 24             	mov    (%esp),%eax
  802d83:	be 20 00 00 00       	mov    $0x20,%esi
  802d88:	89 e9                	mov    %ebp,%ecx
  802d8a:	29 ee                	sub    %ebp,%esi
  802d8c:	d3 e2                	shl    %cl,%edx
  802d8e:	89 f1                	mov    %esi,%ecx
  802d90:	d3 e8                	shr    %cl,%eax
  802d92:	89 e9                	mov    %ebp,%ecx
  802d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d98:	8b 04 24             	mov    (%esp),%eax
  802d9b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d9f:	89 fa                	mov    %edi,%edx
  802da1:	d3 e0                	shl    %cl,%eax
  802da3:	89 f1                	mov    %esi,%ecx
  802da5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802da9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802dad:	d3 ea                	shr    %cl,%edx
  802daf:	89 e9                	mov    %ebp,%ecx
  802db1:	d3 e7                	shl    %cl,%edi
  802db3:	89 f1                	mov    %esi,%ecx
  802db5:	d3 e8                	shr    %cl,%eax
  802db7:	89 e9                	mov    %ebp,%ecx
  802db9:	09 f8                	or     %edi,%eax
  802dbb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802dbf:	f7 74 24 04          	divl   0x4(%esp)
  802dc3:	d3 e7                	shl    %cl,%edi
  802dc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dc9:	89 d7                	mov    %edx,%edi
  802dcb:	f7 64 24 08          	mull   0x8(%esp)
  802dcf:	39 d7                	cmp    %edx,%edi
  802dd1:	89 c1                	mov    %eax,%ecx
  802dd3:	89 14 24             	mov    %edx,(%esp)
  802dd6:	72 2c                	jb     802e04 <__umoddi3+0x134>
  802dd8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802ddc:	72 22                	jb     802e00 <__umoddi3+0x130>
  802dde:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802de2:	29 c8                	sub    %ecx,%eax
  802de4:	19 d7                	sbb    %edx,%edi
  802de6:	89 e9                	mov    %ebp,%ecx
  802de8:	89 fa                	mov    %edi,%edx
  802dea:	d3 e8                	shr    %cl,%eax
  802dec:	89 f1                	mov    %esi,%ecx
  802dee:	d3 e2                	shl    %cl,%edx
  802df0:	89 e9                	mov    %ebp,%ecx
  802df2:	d3 ef                	shr    %cl,%edi
  802df4:	09 d0                	or     %edx,%eax
  802df6:	89 fa                	mov    %edi,%edx
  802df8:	83 c4 14             	add    $0x14,%esp
  802dfb:	5e                   	pop    %esi
  802dfc:	5f                   	pop    %edi
  802dfd:	5d                   	pop    %ebp
  802dfe:	c3                   	ret    
  802dff:	90                   	nop
  802e00:	39 d7                	cmp    %edx,%edi
  802e02:	75 da                	jne    802dde <__umoddi3+0x10e>
  802e04:	8b 14 24             	mov    (%esp),%edx
  802e07:	89 c1                	mov    %eax,%ecx
  802e09:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e0d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e11:	eb cb                	jmp    802dde <__umoddi3+0x10e>
  802e13:	90                   	nop
  802e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e18:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e1c:	0f 82 0f ff ff ff    	jb     802d31 <__umoddi3+0x61>
  802e22:	e9 1a ff ff ff       	jmp    802d41 <__umoddi3+0x71>
