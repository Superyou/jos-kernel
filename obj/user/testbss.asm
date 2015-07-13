
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 cd 00 00 00       	call   8000fe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	c7 04 24 a0 27 80 00 	movl   $0x8027a0,(%esp)
  800040:	e8 13 02 00 00       	call   800258 <cprintf>
	for (i = 0; i < ARRAYSIZE; i++)
  800045:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004a:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800051:	00 
  800052:	74 20                	je     800074 <umain+0x41>
			panic("bigarray[%d] isn't cleared!\n", i);
  800054:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800058:	c7 44 24 08 1b 28 80 	movl   $0x80281b,0x8(%esp)
  80005f:	00 
  800060:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800067:	00 
  800068:	c7 04 24 38 28 80 00 	movl   $0x802838,(%esp)
  80006f:	e8 eb 00 00 00       	call   80015f <_panic>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  800074:	83 c0 01             	add    $0x1,%eax
  800077:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80007c:	75 cc                	jne    80004a <umain+0x17>
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
  800083:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80008a:	83 c0 01             	add    $0x1,%eax
  80008d:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800092:	75 ef                	jne    800083 <umain+0x50>
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != i)
  800099:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  8000a0:	74 20                	je     8000c2 <umain+0x8f>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a6:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 38 28 80 00 	movl   $0x802838,(%esp)
  8000bd:	e8 9d 00 00 00       	call   80015f <_panic>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000c2:	83 c0 01             	add    $0x1,%eax
  8000c5:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000ca:	75 cd                	jne    800099 <umain+0x66>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000cc:	c7 04 24 e8 27 80 00 	movl   $0x8027e8,(%esp)
  8000d3:	e8 80 01 00 00       	call   800258 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000d8:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000df:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000e2:	c7 44 24 08 47 28 80 	movl   $0x802847,0x8(%esp)
  8000e9:	00 
  8000ea:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8000f1:	00 
  8000f2:	c7 04 24 38 28 80 00 	movl   $0x802838,(%esp)
  8000f9:	e8 61 00 00 00       	call   80015f <_panic>

008000fe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	83 ec 10             	sub    $0x10,%esp
  800106:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800109:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80010c:	e8 f6 0b 00 00       	call   800d07 <sys_getenvid>
  800111:	25 ff 03 00 00       	and    $0x3ff,%eax
  800116:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800119:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011e:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800123:	85 db                	test   %ebx,%ebx
  800125:	7e 07                	jle    80012e <libmain+0x30>
		binaryname = argv[0];
  800127:	8b 06                	mov    (%esi),%eax
  800129:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800132:	89 1c 24             	mov    %ebx,(%esp)
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 07 00 00 00       	call   800146 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5d                   	pop    %ebp
  800145:	c3                   	ret    

00800146 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80014c:	e8 d9 10 00 00       	call   80122a <close_all>
	sys_env_destroy(0);
  800151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800158:	e8 06 0b 00 00       	call   800c63 <sys_env_destroy>
}
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800167:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80016a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800170:	e8 92 0b 00 00       	call   800d07 <sys_getenvid>
  800175:	8b 55 0c             	mov    0xc(%ebp),%edx
  800178:	89 54 24 10          	mov    %edx,0x10(%esp)
  80017c:	8b 55 08             	mov    0x8(%ebp),%edx
  80017f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800183:	89 74 24 08          	mov    %esi,0x8(%esp)
  800187:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018b:	c7 04 24 68 28 80 00 	movl   $0x802868,(%esp)
  800192:	e8 c1 00 00 00       	call   800258 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800197:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80019b:	8b 45 10             	mov    0x10(%ebp),%eax
  80019e:	89 04 24             	mov    %eax,(%esp)
  8001a1:	e8 51 00 00 00       	call   8001f7 <vcprintf>
	cprintf("\n");
  8001a6:	c7 04 24 36 28 80 00 	movl   $0x802836,(%esp)
  8001ad:	e8 a6 00 00 00       	call   800258 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b2:	cc                   	int3   
  8001b3:	eb fd                	jmp    8001b2 <_panic+0x53>

008001b5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 14             	sub    $0x14,%esp
  8001bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001bf:	8b 13                	mov    (%ebx),%edx
  8001c1:	8d 42 01             	lea    0x1(%edx),%eax
  8001c4:	89 03                	mov    %eax,(%ebx)
  8001c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d2:	75 19                	jne    8001ed <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001d4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001db:	00 
  8001dc:	8d 43 08             	lea    0x8(%ebx),%eax
  8001df:	89 04 24             	mov    %eax,(%esp)
  8001e2:	e8 3f 0a 00 00       	call   800c26 <sys_cputs>
		b->idx = 0;
  8001e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001ed:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f1:	83 c4 14             	add    $0x14,%esp
  8001f4:	5b                   	pop    %ebx
  8001f5:	5d                   	pop    %ebp
  8001f6:	c3                   	ret    

008001f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800200:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800207:	00 00 00 
	b.cnt = 0;
  80020a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800211:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800214:	8b 45 0c             	mov    0xc(%ebp),%eax
  800217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021b:	8b 45 08             	mov    0x8(%ebp),%eax
  80021e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800222:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800228:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022c:	c7 04 24 b5 01 80 00 	movl   $0x8001b5,(%esp)
  800233:	e8 7c 01 00 00       	call   8003b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800238:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80023e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800242:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	e8 d6 09 00 00       	call   800c26 <sys_cputs>

	return b.cnt;
}
  800250:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800256:	c9                   	leave  
  800257:	c3                   	ret    

00800258 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80025e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800261:	89 44 24 04          	mov    %eax,0x4(%esp)
  800265:	8b 45 08             	mov    0x8(%ebp),%eax
  800268:	89 04 24             	mov    %eax,(%esp)
  80026b:	e8 87 ff ff ff       	call   8001f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800270:	c9                   	leave  
  800271:	c3                   	ret    
  800272:	66 90                	xchg   %ax,%ax
  800274:	66 90                	xchg   %ax,%ax
  800276:	66 90                	xchg   %ax,%ax
  800278:	66 90                	xchg   %ax,%ax
  80027a:	66 90                	xchg   %ax,%ax
  80027c:	66 90                	xchg   %ax,%ax
  80027e:	66 90                	xchg   %ax,%ax

00800280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 3c             	sub    $0x3c,%esp
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028c:	89 d7                	mov    %edx,%edi
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	89 c3                	mov    %eax,%ebx
  800299:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80029c:	8b 45 10             	mov    0x10(%ebp),%eax
  80029f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002ad:	39 d9                	cmp    %ebx,%ecx
  8002af:	72 05                	jb     8002b6 <printnum+0x36>
  8002b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002b4:	77 69                	ja     80031f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002bd:	83 ee 01             	sub    $0x1,%esi
  8002c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002d0:	89 c3                	mov    %eax,%ebx
  8002d2:	89 d6                	mov    %edx,%esi
  8002d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	e8 0c 22 00 00       	call   802500 <__udivdi3>
  8002f4:	89 d9                	mov    %ebx,%ecx
  8002f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002fe:	89 04 24             	mov    %eax,(%esp)
  800301:	89 54 24 04          	mov    %edx,0x4(%esp)
  800305:	89 fa                	mov    %edi,%edx
  800307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80030a:	e8 71 ff ff ff       	call   800280 <printnum>
  80030f:	eb 1b                	jmp    80032c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800311:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800315:	8b 45 18             	mov    0x18(%ebp),%eax
  800318:	89 04 24             	mov    %eax,(%esp)
  80031b:	ff d3                	call   *%ebx
  80031d:	eb 03                	jmp    800322 <printnum+0xa2>
  80031f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800322:	83 ee 01             	sub    $0x1,%esi
  800325:	85 f6                	test   %esi,%esi
  800327:	7f e8                	jg     800311 <printnum+0x91>
  800329:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800330:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800334:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800337:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80033a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	e8 dc 22 00 00       	call   802630 <__umoddi3>
  800354:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800358:	0f be 80 8b 28 80 00 	movsbl 0x80288b(%eax),%eax
  80035f:	89 04 24             	mov    %eax,(%esp)
  800362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800365:	ff d0                	call   *%eax
}
  800367:	83 c4 3c             	add    $0x3c,%esp
  80036a:	5b                   	pop    %ebx
  80036b:	5e                   	pop    %esi
  80036c:	5f                   	pop    %edi
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800375:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	3b 50 04             	cmp    0x4(%eax),%edx
  80037e:	73 0a                	jae    80038a <sprintputch+0x1b>
		*b->buf++ = ch;
  800380:	8d 4a 01             	lea    0x1(%edx),%ecx
  800383:	89 08                	mov    %ecx,(%eax)
  800385:	8b 45 08             	mov    0x8(%ebp),%eax
  800388:	88 02                	mov    %al,(%edx)
}
  80038a:	5d                   	pop    %ebp
  80038b:	c3                   	ret    

0080038c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800392:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800395:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800399:	8b 45 10             	mov    0x10(%ebp),%eax
  80039c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	89 04 24             	mov    %eax,(%esp)
  8003ad:	e8 02 00 00 00       	call   8003b4 <vprintfmt>
	va_end(ap);
}
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    

008003b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	57                   	push   %edi
  8003b8:	56                   	push   %esi
  8003b9:	53                   	push   %ebx
  8003ba:	83 ec 3c             	sub    $0x3c,%esp
  8003bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003c0:	eb 17                	jmp    8003d9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8003c2:	85 c0                	test   %eax,%eax
  8003c4:	0f 84 4b 04 00 00    	je     800815 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8003ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003d1:	89 04 24             	mov    %eax,(%esp)
  8003d4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8003d7:	89 fb                	mov    %edi,%ebx
  8003d9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8003dc:	0f b6 03             	movzbl (%ebx),%eax
  8003df:	83 f8 25             	cmp    $0x25,%eax
  8003e2:	75 de                	jne    8003c2 <vprintfmt+0xe>
  8003e4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8003e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8003f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800400:	eb 18                	jmp    80041a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800402:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800404:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800408:	eb 10                	jmp    80041a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80040c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800410:	eb 08                	jmp    80041a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800412:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800415:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80041d:	0f b6 17             	movzbl (%edi),%edx
  800420:	0f b6 c2             	movzbl %dl,%eax
  800423:	83 ea 23             	sub    $0x23,%edx
  800426:	80 fa 55             	cmp    $0x55,%dl
  800429:	0f 87 c2 03 00 00    	ja     8007f1 <vprintfmt+0x43d>
  80042f:	0f b6 d2             	movzbl %dl,%edx
  800432:	ff 24 95 c0 29 80 00 	jmp    *0x8029c0(,%edx,4)
  800439:	89 df                	mov    %ebx,%edi
  80043b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800440:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800443:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800447:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80044a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80044d:	83 fa 09             	cmp    $0x9,%edx
  800450:	77 33                	ja     800485 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800452:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800455:	eb e9                	jmp    800440 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800457:	8b 45 14             	mov    0x14(%ebp),%eax
  80045a:	8b 30                	mov    (%eax),%esi
  80045c:	8d 40 04             	lea    0x4(%eax),%eax
  80045f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800462:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800464:	eb 1f                	jmp    800485 <vprintfmt+0xd1>
  800466:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800469:	85 ff                	test   %edi,%edi
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
  800470:	0f 49 c7             	cmovns %edi,%eax
  800473:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800476:	89 df                	mov    %ebx,%edi
  800478:	eb a0                	jmp    80041a <vprintfmt+0x66>
  80047a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80047c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800483:	eb 95                	jmp    80041a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800485:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800489:	79 8f                	jns    80041a <vprintfmt+0x66>
  80048b:	eb 85                	jmp    800412 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80048d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800490:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800492:	eb 86                	jmp    80041a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8d 70 04             	lea    0x4(%eax),%esi
  80049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 04 24             	mov    %eax,(%esp)
  8004a9:	ff 55 08             	call   *0x8(%ebp)
  8004ac:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8004af:	e9 25 ff ff ff       	jmp    8003d9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	8d 70 04             	lea    0x4(%eax),%esi
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	99                   	cltd   
  8004bd:	31 d0                	xor    %edx,%eax
  8004bf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c1:	83 f8 15             	cmp    $0x15,%eax
  8004c4:	7f 0b                	jg     8004d1 <vprintfmt+0x11d>
  8004c6:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  8004cd:	85 d2                	test   %edx,%edx
  8004cf:	75 26                	jne    8004f7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8004d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004d5:	c7 44 24 08 a3 28 80 	movl   $0x8028a3,0x8(%esp)
  8004dc:	00 
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	89 04 24             	mov    %eax,(%esp)
  8004ea:	e8 9d fe ff ff       	call   80038c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ef:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004f2:	e9 e2 fe ff ff       	jmp    8003d9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004fb:	c7 44 24 08 72 2c 80 	movl   $0x802c72,0x8(%esp)
  800502:	00 
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	89 04 24             	mov    %eax,(%esp)
  800510:	e8 77 fe ff ff       	call   80038c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800515:	89 75 14             	mov    %esi,0x14(%ebp)
  800518:	e9 bc fe ff ff       	jmp    8003d9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800523:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800526:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80052a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80052c:	85 ff                	test   %edi,%edi
  80052e:	b8 9c 28 80 00       	mov    $0x80289c,%eax
  800533:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800536:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80053a:	0f 84 94 00 00 00    	je     8005d4 <vprintfmt+0x220>
  800540:	85 c9                	test   %ecx,%ecx
  800542:	0f 8e 94 00 00 00    	jle    8005dc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800548:	89 74 24 04          	mov    %esi,0x4(%esp)
  80054c:	89 3c 24             	mov    %edi,(%esp)
  80054f:	e8 64 03 00 00       	call   8008b8 <strnlen>
  800554:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800557:	29 c1                	sub    %eax,%ecx
  800559:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80055c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800560:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800563:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800566:	8b 75 08             	mov    0x8(%ebp),%esi
  800569:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80056c:	89 cb                	mov    %ecx,%ebx
  80056e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800570:	eb 0f                	jmp    800581 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	89 44 24 04          	mov    %eax,0x4(%esp)
  800579:	89 3c 24             	mov    %edi,(%esp)
  80057c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80057e:	83 eb 01             	sub    $0x1,%ebx
  800581:	85 db                	test   %ebx,%ebx
  800583:	7f ed                	jg     800572 <vprintfmt+0x1be>
  800585:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800588:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80058b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80058e:	85 c9                	test   %ecx,%ecx
  800590:	b8 00 00 00 00       	mov    $0x0,%eax
  800595:	0f 49 c1             	cmovns %ecx,%eax
  800598:	29 c1                	sub    %eax,%ecx
  80059a:	89 cb                	mov    %ecx,%ebx
  80059c:	eb 44                	jmp    8005e2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80059e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a2:	74 1e                	je     8005c2 <vprintfmt+0x20e>
  8005a4:	0f be d2             	movsbl %dl,%edx
  8005a7:	83 ea 20             	sub    $0x20,%edx
  8005aa:	83 fa 5e             	cmp    $0x5e,%edx
  8005ad:	76 13                	jbe    8005c2 <vprintfmt+0x20e>
					putch('?', putdat);
  8005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005bd:	ff 55 08             	call   *0x8(%ebp)
  8005c0:	eb 0d                	jmp    8005cf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8005c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005c9:	89 04 24             	mov    %eax,(%esp)
  8005cc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005cf:	83 eb 01             	sub    $0x1,%ebx
  8005d2:	eb 0e                	jmp    8005e2 <vprintfmt+0x22e>
  8005d4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005d7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005da:	eb 06                	jmp    8005e2 <vprintfmt+0x22e>
  8005dc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005df:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005e2:	83 c7 01             	add    $0x1,%edi
  8005e5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005e9:	0f be c2             	movsbl %dl,%eax
  8005ec:	85 c0                	test   %eax,%eax
  8005ee:	74 27                	je     800617 <vprintfmt+0x263>
  8005f0:	85 f6                	test   %esi,%esi
  8005f2:	78 aa                	js     80059e <vprintfmt+0x1ea>
  8005f4:	83 ee 01             	sub    $0x1,%esi
  8005f7:	79 a5                	jns    80059e <vprintfmt+0x1ea>
  8005f9:	89 d8                	mov    %ebx,%eax
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800601:	89 c3                	mov    %eax,%ebx
  800603:	eb 18                	jmp    80061d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800605:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800609:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800610:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800612:	83 eb 01             	sub    $0x1,%ebx
  800615:	eb 06                	jmp    80061d <vprintfmt+0x269>
  800617:	8b 75 08             	mov    0x8(%ebp),%esi
  80061a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80061d:	85 db                	test   %ebx,%ebx
  80061f:	7f e4                	jg     800605 <vprintfmt+0x251>
  800621:	89 75 08             	mov    %esi,0x8(%ebp)
  800624:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800627:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80062a:	e9 aa fd ff ff       	jmp    8003d9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80062f:	83 f9 01             	cmp    $0x1,%ecx
  800632:	7e 10                	jle    800644 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 30                	mov    (%eax),%esi
  800639:	8b 78 04             	mov    0x4(%eax),%edi
  80063c:	8d 40 08             	lea    0x8(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	eb 26                	jmp    80066a <vprintfmt+0x2b6>
	else if (lflag)
  800644:	85 c9                	test   %ecx,%ecx
  800646:	74 12                	je     80065a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8b 30                	mov    (%eax),%esi
  80064d:	89 f7                	mov    %esi,%edi
  80064f:	c1 ff 1f             	sar    $0x1f,%edi
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
  800658:	eb 10                	jmp    80066a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 30                	mov    (%eax),%esi
  80065f:	89 f7                	mov    %esi,%edi
  800661:	c1 ff 1f             	sar    $0x1f,%edi
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80066a:	89 f0                	mov    %esi,%eax
  80066c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80066e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800673:	85 ff                	test   %edi,%edi
  800675:	0f 89 3a 01 00 00    	jns    8007b5 <vprintfmt+0x401>
				putch('-', putdat);
  80067b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800682:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800689:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80068c:	89 f0                	mov    %esi,%eax
  80068e:	89 fa                	mov    %edi,%edx
  800690:	f7 d8                	neg    %eax
  800692:	83 d2 00             	adc    $0x0,%edx
  800695:	f7 da                	neg    %edx
			}
			base = 10;
  800697:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80069c:	e9 14 01 00 00       	jmp    8007b5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006a1:	83 f9 01             	cmp    $0x1,%ecx
  8006a4:	7e 13                	jle    8006b9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 50 04             	mov    0x4(%eax),%edx
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8b 75 14             	mov    0x14(%ebp),%esi
  8006b1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006b4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006b7:	eb 2c                	jmp    8006e5 <vprintfmt+0x331>
	else if (lflag)
  8006b9:	85 c9                	test   %ecx,%ecx
  8006bb:	74 15                	je     8006d2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ca:	8d 76 04             	lea    0x4(%esi),%esi
  8006cd:	89 75 14             	mov    %esi,0x14(%ebp)
  8006d0:	eb 13                	jmp    8006e5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dc:	8b 75 14             	mov    0x14(%ebp),%esi
  8006df:	8d 76 04             	lea    0x4(%esi),%esi
  8006e2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8006e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006ea:	e9 c6 00 00 00       	jmp    8007b5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006ef:	83 f9 01             	cmp    $0x1,%ecx
  8006f2:	7e 13                	jle    800707 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 50 04             	mov    0x4(%eax),%edx
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ff:	8d 4e 08             	lea    0x8(%esi),%ecx
  800702:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800705:	eb 24                	jmp    80072b <vprintfmt+0x377>
	else if (lflag)
  800707:	85 c9                	test   %ecx,%ecx
  800709:	74 11                	je     80071c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	99                   	cltd   
  800711:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800714:	8d 71 04             	lea    0x4(%ecx),%esi
  800717:	89 75 14             	mov    %esi,0x14(%ebp)
  80071a:	eb 0f                	jmp    80072b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	99                   	cltd   
  800722:	8b 75 14             	mov    0x14(%ebp),%esi
  800725:	8d 76 04             	lea    0x4(%esi),%esi
  800728:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80072b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800730:	e9 80 00 00 00       	jmp    8007b5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800735:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80073f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800746:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800750:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800757:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80075a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80075e:	8b 06                	mov    (%esi),%eax
  800760:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800765:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80076a:	eb 49                	jmp    8007b5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80076c:	83 f9 01             	cmp    $0x1,%ecx
  80076f:	7e 13                	jle    800784 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 50 04             	mov    0x4(%eax),%edx
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8b 75 14             	mov    0x14(%ebp),%esi
  80077c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80077f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800782:	eb 2c                	jmp    8007b0 <vprintfmt+0x3fc>
	else if (lflag)
  800784:	85 c9                	test   %ecx,%ecx
  800786:	74 15                	je     80079d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	ba 00 00 00 00       	mov    $0x0,%edx
  800792:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800795:	8d 71 04             	lea    0x4(%ecx),%esi
  800798:	89 75 14             	mov    %esi,0x14(%ebp)
  80079b:	eb 13                	jmp    8007b0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a7:	8b 75 14             	mov    0x14(%ebp),%esi
  8007aa:	8d 76 04             	lea    0x4(%esi),%esi
  8007ad:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8007b0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8007b9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007bd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007c4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007c8:	89 04 24             	mov    %eax,(%esp)
  8007cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	e8 a6 fa ff ff       	call   800280 <printnum>
			break;
  8007da:	e9 fa fb ff ff       	jmp    8003d9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007e6:	89 04 24             	mov    %eax,(%esp)
  8007e9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007ec:	e9 e8 fb ff ff       	jmp    8003d9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007ff:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800802:	89 fb                	mov    %edi,%ebx
  800804:	eb 03                	jmp    800809 <vprintfmt+0x455>
  800806:	83 eb 01             	sub    $0x1,%ebx
  800809:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80080d:	75 f7                	jne    800806 <vprintfmt+0x452>
  80080f:	90                   	nop
  800810:	e9 c4 fb ff ff       	jmp    8003d9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800815:	83 c4 3c             	add    $0x3c,%esp
  800818:	5b                   	pop    %ebx
  800819:	5e                   	pop    %esi
  80081a:	5f                   	pop    %edi
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	83 ec 28             	sub    $0x28,%esp
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800829:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80082c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800830:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800833:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083a:	85 c0                	test   %eax,%eax
  80083c:	74 30                	je     80086e <vsnprintf+0x51>
  80083e:	85 d2                	test   %edx,%edx
  800840:	7e 2c                	jle    80086e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800849:	8b 45 10             	mov    0x10(%ebp),%eax
  80084c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800850:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800853:	89 44 24 04          	mov    %eax,0x4(%esp)
  800857:	c7 04 24 6f 03 80 00 	movl   $0x80036f,(%esp)
  80085e:	e8 51 fb ff ff       	call   8003b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	eb 05                	jmp    800873 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80086e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800873:	c9                   	leave  
  800874:	c3                   	ret    

00800875 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80087b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80087e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800882:	8b 45 10             	mov    0x10(%ebp),%eax
  800885:	89 44 24 08          	mov    %eax,0x8(%esp)
  800889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	89 04 24             	mov    %eax,(%esp)
  800896:	e8 82 ff ff ff       	call   80081d <vsnprintf>
	va_end(ap);

	return rc;
}
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    
  80089d:	66 90                	xchg   %ax,%ax
  80089f:	90                   	nop

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	eb 03                	jmp    8008b0 <strlen+0x10>
		n++;
  8008ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b4:	75 f7                	jne    8008ad <strlen+0xd>
		n++;
	return n;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	eb 03                	jmp    8008cb <strnlen+0x13>
		n++;
  8008c8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cb:	39 d0                	cmp    %edx,%eax
  8008cd:	74 06                	je     8008d5 <strnlen+0x1d>
  8008cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d3:	75 f3                	jne    8008c8 <strnlen+0x10>
		n++;
	return n;
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e1:	89 c2                	mov    %eax,%edx
  8008e3:	83 c2 01             	add    $0x1,%edx
  8008e6:	83 c1 01             	add    $0x1,%ecx
  8008e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ed:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f0:	84 db                	test   %bl,%bl
  8008f2:	75 ef                	jne    8008e3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800901:	89 1c 24             	mov    %ebx,(%esp)
  800904:	e8 97 ff ff ff       	call   8008a0 <strlen>
	strcpy(dst + len, src);
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800910:	01 d8                	add    %ebx,%eax
  800912:	89 04 24             	mov    %eax,(%esp)
  800915:	e8 bd ff ff ff       	call   8008d7 <strcpy>
	return dst;
}
  80091a:	89 d8                	mov    %ebx,%eax
  80091c:	83 c4 08             	add    $0x8,%esp
  80091f:	5b                   	pop    %ebx
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	56                   	push   %esi
  800926:	53                   	push   %ebx
  800927:	8b 75 08             	mov    0x8(%ebp),%esi
  80092a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092d:	89 f3                	mov    %esi,%ebx
  80092f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800932:	89 f2                	mov    %esi,%edx
  800934:	eb 0f                	jmp    800945 <strncpy+0x23>
		*dst++ = *src;
  800936:	83 c2 01             	add    $0x1,%edx
  800939:	0f b6 01             	movzbl (%ecx),%eax
  80093c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093f:	80 39 01             	cmpb   $0x1,(%ecx)
  800942:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800945:	39 da                	cmp    %ebx,%edx
  800947:	75 ed                	jne    800936 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800949:	89 f0                	mov    %esi,%eax
  80094b:	5b                   	pop    %ebx
  80094c:	5e                   	pop    %esi
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	8b 75 08             	mov    0x8(%ebp),%esi
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800963:	85 c9                	test   %ecx,%ecx
  800965:	75 0b                	jne    800972 <strlcpy+0x23>
  800967:	eb 1d                	jmp    800986 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	83 c2 01             	add    $0x1,%edx
  80096f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800972:	39 d8                	cmp    %ebx,%eax
  800974:	74 0b                	je     800981 <strlcpy+0x32>
  800976:	0f b6 0a             	movzbl (%edx),%ecx
  800979:	84 c9                	test   %cl,%cl
  80097b:	75 ec                	jne    800969 <strlcpy+0x1a>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	eb 02                	jmp    800983 <strlcpy+0x34>
  800981:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800983:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800986:	29 f0                	sub    %esi,%eax
}
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800995:	eb 06                	jmp    80099d <strcmp+0x11>
		p++, q++;
  800997:	83 c1 01             	add    $0x1,%ecx
  80099a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80099d:	0f b6 01             	movzbl (%ecx),%eax
  8009a0:	84 c0                	test   %al,%al
  8009a2:	74 04                	je     8009a8 <strcmp+0x1c>
  8009a4:	3a 02                	cmp    (%edx),%al
  8009a6:	74 ef                	je     800997 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 c0             	movzbl %al,%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 c3                	mov    %eax,%ebx
  8009be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c1:	eb 06                	jmp    8009c9 <strncmp+0x17>
		n--, p++, q++;
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009c9:	39 d8                	cmp    %ebx,%eax
  8009cb:	74 15                	je     8009e2 <strncmp+0x30>
  8009cd:	0f b6 08             	movzbl (%eax),%ecx
  8009d0:	84 c9                	test   %cl,%cl
  8009d2:	74 04                	je     8009d8 <strncmp+0x26>
  8009d4:	3a 0a                	cmp    (%edx),%cl
  8009d6:	74 eb                	je     8009c3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
  8009e0:	eb 05                	jmp    8009e7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009e7:	5b                   	pop    %ebx
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f4:	eb 07                	jmp    8009fd <strchr+0x13>
		if (*s == c)
  8009f6:	38 ca                	cmp    %cl,%dl
  8009f8:	74 0f                	je     800a09 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	0f b6 10             	movzbl (%eax),%edx
  800a00:	84 d2                	test   %dl,%dl
  800a02:	75 f2                	jne    8009f6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	eb 07                	jmp    800a1e <strfind+0x13>
		if (*s == c)
  800a17:	38 ca                	cmp    %cl,%dl
  800a19:	74 0a                	je     800a25 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	0f b6 10             	movzbl (%eax),%edx
  800a21:	84 d2                	test   %dl,%dl
  800a23:	75 f2                	jne    800a17 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	74 36                	je     800a6d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a37:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3d:	75 28                	jne    800a67 <memset+0x40>
  800a3f:	f6 c1 03             	test   $0x3,%cl
  800a42:	75 23                	jne    800a67 <memset+0x40>
		c &= 0xFF;
  800a44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a48:	89 d3                	mov    %edx,%ebx
  800a4a:	c1 e3 08             	shl    $0x8,%ebx
  800a4d:	89 d6                	mov    %edx,%esi
  800a4f:	c1 e6 18             	shl    $0x18,%esi
  800a52:	89 d0                	mov    %edx,%eax
  800a54:	c1 e0 10             	shl    $0x10,%eax
  800a57:	09 f0                	or     %esi,%eax
  800a59:	09 c2                	or     %eax,%edx
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a5f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a62:	fc                   	cld    
  800a63:	f3 ab                	rep stos %eax,%es:(%edi)
  800a65:	eb 06                	jmp    800a6d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	fc                   	cld    
  800a6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6d:	89 f8                	mov    %edi,%eax
  800a6f:	5b                   	pop    %ebx
  800a70:	5e                   	pop    %esi
  800a71:	5f                   	pop    %edi
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	57                   	push   %edi
  800a78:	56                   	push   %esi
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a82:	39 c6                	cmp    %eax,%esi
  800a84:	73 35                	jae    800abb <memmove+0x47>
  800a86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a89:	39 d0                	cmp    %edx,%eax
  800a8b:	73 2e                	jae    800abb <memmove+0x47>
		s += n;
		d += n;
  800a8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a90:	89 d6                	mov    %edx,%esi
  800a92:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a94:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9a:	75 13                	jne    800aaf <memmove+0x3b>
  800a9c:	f6 c1 03             	test   $0x3,%cl
  800a9f:	75 0e                	jne    800aaf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb 09                	jmp    800ab8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 1d                	jmp    800ad8 <memmove+0x64>
  800abb:	89 f2                	mov    %esi,%edx
  800abd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	f6 c2 03             	test   $0x3,%dl
  800ac2:	75 0f                	jne    800ad3 <memmove+0x5f>
  800ac4:	f6 c1 03             	test   $0x3,%cl
  800ac7:	75 0a                	jne    800ad3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800acc:	89 c7                	mov    %eax,%edi
  800ace:	fc                   	cld    
  800acf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad1:	eb 05                	jmp    800ad8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad3:	89 c7                	mov    %eax,%edi
  800ad5:	fc                   	cld    
  800ad6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	89 04 24             	mov    %eax,(%esp)
  800af6:	e8 79 ff ff ff       	call   800a74 <memmove>
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	56                   	push   %esi
  800b01:	53                   	push   %ebx
  800b02:	8b 55 08             	mov    0x8(%ebp),%edx
  800b05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0d:	eb 1a                	jmp    800b29 <memcmp+0x2c>
		if (*s1 != *s2)
  800b0f:	0f b6 02             	movzbl (%edx),%eax
  800b12:	0f b6 19             	movzbl (%ecx),%ebx
  800b15:	38 d8                	cmp    %bl,%al
  800b17:	74 0a                	je     800b23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b19:	0f b6 c0             	movzbl %al,%eax
  800b1c:	0f b6 db             	movzbl %bl,%ebx
  800b1f:	29 d8                	sub    %ebx,%eax
  800b21:	eb 0f                	jmp    800b32 <memcmp+0x35>
		s1++, s2++;
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b29:	39 f2                	cmp    %esi,%edx
  800b2b:	75 e2                	jne    800b0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3f:	89 c2                	mov    %eax,%edx
  800b41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b44:	eb 07                	jmp    800b4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b46:	38 08                	cmp    %cl,(%eax)
  800b48:	74 07                	je     800b51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	39 d0                	cmp    %edx,%eax
  800b4f:	72 f5                	jb     800b46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5f:	eb 03                	jmp    800b64 <strtol+0x11>
		s++;
  800b61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b64:	0f b6 0a             	movzbl (%edx),%ecx
  800b67:	80 f9 09             	cmp    $0x9,%cl
  800b6a:	74 f5                	je     800b61 <strtol+0xe>
  800b6c:	80 f9 20             	cmp    $0x20,%cl
  800b6f:	74 f0                	je     800b61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b71:	80 f9 2b             	cmp    $0x2b,%cl
  800b74:	75 0a                	jne    800b80 <strtol+0x2d>
		s++;
  800b76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b79:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7e:	eb 11                	jmp    800b91 <strtol+0x3e>
  800b80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b85:	80 f9 2d             	cmp    $0x2d,%cl
  800b88:	75 07                	jne    800b91 <strtol+0x3e>
		s++, neg = 1;
  800b8a:	8d 52 01             	lea    0x1(%edx),%edx
  800b8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b96:	75 15                	jne    800bad <strtol+0x5a>
  800b98:	80 3a 30             	cmpb   $0x30,(%edx)
  800b9b:	75 10                	jne    800bad <strtol+0x5a>
  800b9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba1:	75 0a                	jne    800bad <strtol+0x5a>
		s += 2, base = 16;
  800ba3:	83 c2 02             	add    $0x2,%edx
  800ba6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bab:	eb 10                	jmp    800bbd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bad:	85 c0                	test   %eax,%eax
  800baf:	75 0c                	jne    800bbd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bb6:	75 05                	jne    800bbd <strtol+0x6a>
		s++, base = 8;
  800bb8:	83 c2 01             	add    $0x1,%edx
  800bbb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bc5:	0f b6 0a             	movzbl (%edx),%ecx
  800bc8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bcb:	89 f0                	mov    %esi,%eax
  800bcd:	3c 09                	cmp    $0x9,%al
  800bcf:	77 08                	ja     800bd9 <strtol+0x86>
			dig = *s - '0';
  800bd1:	0f be c9             	movsbl %cl,%ecx
  800bd4:	83 e9 30             	sub    $0x30,%ecx
  800bd7:	eb 20                	jmp    800bf9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bd9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bdc:	89 f0                	mov    %esi,%eax
  800bde:	3c 19                	cmp    $0x19,%al
  800be0:	77 08                	ja     800bea <strtol+0x97>
			dig = *s - 'a' + 10;
  800be2:	0f be c9             	movsbl %cl,%ecx
  800be5:	83 e9 57             	sub    $0x57,%ecx
  800be8:	eb 0f                	jmp    800bf9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bed:	89 f0                	mov    %esi,%eax
  800bef:	3c 19                	cmp    $0x19,%al
  800bf1:	77 16                	ja     800c09 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bf3:	0f be c9             	movsbl %cl,%ecx
  800bf6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bf9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bfc:	7d 0f                	jge    800c0d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bfe:	83 c2 01             	add    $0x1,%edx
  800c01:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c05:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c07:	eb bc                	jmp    800bc5 <strtol+0x72>
  800c09:	89 d8                	mov    %ebx,%eax
  800c0b:	eb 02                	jmp    800c0f <strtol+0xbc>
  800c0d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c13:	74 05                	je     800c1a <strtol+0xc7>
		*endptr = (char *) s;
  800c15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c18:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c1a:	f7 d8                	neg    %eax
  800c1c:	85 ff                	test   %edi,%edi
  800c1e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	89 c3                	mov    %eax,%ebx
  800c39:	89 c7                	mov    %eax,%edi
  800c3b:	89 c6                	mov    %eax,%esi
  800c3d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c54:	89 d1                	mov    %edx,%ecx
  800c56:	89 d3                	mov    %edx,%ebx
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	89 d6                	mov    %edx,%esi
  800c5c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	89 cb                	mov    %ecx,%ebx
  800c7b:	89 cf                	mov    %ecx,%edi
  800c7d:	89 ce                	mov    %ecx,%esi
  800c7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c81:	85 c0                	test   %eax,%eax
  800c83:	7e 28                	jle    800cad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c89:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c90:	00 
  800c91:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800c98:	00 
  800c99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca0:	00 
  800ca1:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800ca8:	e8 b2 f4 ff ff       	call   80015f <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cad:	83 c4 2c             	add    $0x2c,%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc3:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccb:	89 cb                	mov    %ecx,%ebx
  800ccd:	89 cf                	mov    %ecx,%edi
  800ccf:	89 ce                	mov    %ecx,%esi
  800cd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7e 28                	jle    800cff <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ce2:	00 
  800ce3:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800cea:	00 
  800ceb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf2:	00 
  800cf3:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800cfa:	e8 60 f4 ff ff       	call   80015f <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800cff:	83 c4 2c             	add    $0x2c,%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d12:	b8 02 00 00 00       	mov    $0x2,%eax
  800d17:	89 d1                	mov    %edx,%ecx
  800d19:	89 d3                	mov    %edx,%ebx
  800d1b:	89 d7                	mov    %edx,%edi
  800d1d:	89 d6                	mov    %edx,%esi
  800d1f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_yield>:

void
sys_yield(void)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d31:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d36:	89 d1                	mov    %edx,%ecx
  800d38:	89 d3                	mov    %edx,%ebx
  800d3a:	89 d7                	mov    %edx,%edi
  800d3c:	89 d6                	mov    %edx,%esi
  800d3e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d40:	5b                   	pop    %ebx
  800d41:	5e                   	pop    %esi
  800d42:	5f                   	pop    %edi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4e:	be 00 00 00 00       	mov    $0x0,%esi
  800d53:	b8 05 00 00 00       	mov    $0x5,%eax
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d61:	89 f7                	mov    %esi,%edi
  800d63:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d65:	85 c0                	test   %eax,%eax
  800d67:	7e 28                	jle    800d91 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d69:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d74:	00 
  800d75:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800d7c:	00 
  800d7d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d84:	00 
  800d85:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800d8c:	e8 ce f3 ff ff       	call   80015f <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d91:	83 c4 2c             	add    $0x2c,%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da2:	b8 06 00 00 00       	mov    $0x6,%eax
  800da7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db3:	8b 75 18             	mov    0x18(%ebp),%esi
  800db6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db8:	85 c0                	test   %eax,%eax
  800dba:	7e 28                	jle    800de4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dc7:	00 
  800dc8:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800dcf:	00 
  800dd0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd7:	00 
  800dd8:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800ddf:	e8 7b f3 ff ff       	call   80015f <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de4:	83 c4 2c             	add    $0x2c,%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfa:	b8 07 00 00 00       	mov    $0x7,%eax
  800dff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	89 de                	mov    %ebx,%esi
  800e09:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7e 28                	jle    800e37 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e13:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e1a:	00 
  800e1b:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800e22:	00 
  800e23:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2a:	00 
  800e2b:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800e32:	e8 28 f3 ff ff       	call   80015f <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e37:	83 c4 2c             	add    $0x2c,%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e45:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	89 cb                	mov    %ecx,%ebx
  800e54:	89 cf                	mov    %ecx,%edi
  800e56:	89 ce                	mov    %ecx,%esi
  800e58:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	57                   	push   %edi
  800e63:	56                   	push   %esi
  800e64:	53                   	push   %ebx
  800e65:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	89 df                	mov    %ebx,%edi
  800e7a:	89 de                	mov    %ebx,%esi
  800e7c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	7e 28                	jle    800eaa <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e82:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e86:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e8d:	00 
  800e8e:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800e95:	00 
  800e96:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9d:	00 
  800e9e:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800ea5:	e8 b5 f2 ff ff       	call   80015f <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eaa:	83 c4 2c             	add    $0x2c,%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
  800eb8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	89 df                	mov    %ebx,%edi
  800ecd:	89 de                	mov    %ebx,%esi
  800ecf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	7e 28                	jle    800efd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ee0:	00 
  800ee1:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800ee8:	00 
  800ee9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef0:	00 
  800ef1:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800ef8:	e8 62 f2 ff ff       	call   80015f <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800efd:	83 c4 2c             	add    $0x2c,%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	57                   	push   %edi
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
  800f0b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f13:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	89 df                	mov    %ebx,%edi
  800f20:	89 de                	mov    %ebx,%esi
  800f22:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	7e 28                	jle    800f50 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f28:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f33:	00 
  800f34:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800f3b:	00 
  800f3c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f43:	00 
  800f44:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800f4b:	e8 0f f2 ff ff       	call   80015f <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f50:	83 c4 2c             	add    $0x2c,%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5e:	be 00 00 00 00       	mov    $0x0,%esi
  800f63:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f71:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f74:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f76:	5b                   	pop    %ebx
  800f77:	5e                   	pop    %esi
  800f78:	5f                   	pop    %edi
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	57                   	push   %edi
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
  800f81:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f89:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f91:	89 cb                	mov    %ecx,%ebx
  800f93:	89 cf                	mov    %ecx,%edi
  800f95:	89 ce                	mov    %ecx,%esi
  800f97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	7e 28                	jle    800fc5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800fa8:	00 
  800fa9:	c7 44 24 08 97 2b 80 	movl   $0x802b97,0x8(%esp)
  800fb0:	00 
  800fb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb8:	00 
  800fb9:	c7 04 24 b4 2b 80 00 	movl   $0x802bb4,(%esp)
  800fc0:	e8 9a f1 ff ff       	call   80015f <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc5:	83 c4 2c             	add    $0x2c,%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fdd:	89 d1                	mov    %edx,%ecx
  800fdf:	89 d3                	mov    %edx,%ebx
  800fe1:	89 d7                	mov    %edx,%edi
  800fe3:	89 d6                	mov    %edx,%esi
  800fe5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff7:	b8 11 00 00 00       	mov    $0x11,%eax
  800ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	89 df                	mov    %ebx,%edi
  801004:	89 de                	mov    %ebx,%esi
  801006:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5f                   	pop    %edi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
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
  801013:	bb 00 00 00 00       	mov    $0x0,%ebx
  801018:	b8 12 00 00 00       	mov    $0x12,%eax
  80101d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 df                	mov    %ebx,%edi
  801025:	89 de                	mov    %ebx,%esi
  801027:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	57                   	push   %edi
  801032:	56                   	push   %esi
  801033:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801034:	b9 00 00 00 00       	mov    $0x0,%ecx
  801039:	b8 13 00 00 00       	mov    $0x13,%eax
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	89 cb                	mov    %ecx,%ebx
  801043:	89 cf                	mov    %ecx,%edi
  801045:	89 ce                	mov    %ecx,%esi
  801047:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5f                   	pop    %edi
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    
  80104e:	66 90                	xchg   %ax,%ax

00801050 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	05 00 00 00 30       	add    $0x30000000,%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
}
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80106b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801070:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801082:	89 c2                	mov    %eax,%edx
  801084:	c1 ea 16             	shr    $0x16,%edx
  801087:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80108e:	f6 c2 01             	test   $0x1,%dl
  801091:	74 11                	je     8010a4 <fd_alloc+0x2d>
  801093:	89 c2                	mov    %eax,%edx
  801095:	c1 ea 0c             	shr    $0xc,%edx
  801098:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80109f:	f6 c2 01             	test   $0x1,%dl
  8010a2:	75 09                	jne    8010ad <fd_alloc+0x36>
			*fd_store = fd;
  8010a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ab:	eb 17                	jmp    8010c4 <fd_alloc+0x4d>
  8010ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010b7:	75 c9                	jne    801082 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010cc:	83 f8 1f             	cmp    $0x1f,%eax
  8010cf:	77 36                	ja     801107 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010d1:	c1 e0 0c             	shl    $0xc,%eax
  8010d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d9:	89 c2                	mov    %eax,%edx
  8010db:	c1 ea 16             	shr    $0x16,%edx
  8010de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010e5:	f6 c2 01             	test   $0x1,%dl
  8010e8:	74 24                	je     80110e <fd_lookup+0x48>
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	c1 ea 0c             	shr    $0xc,%edx
  8010ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f6:	f6 c2 01             	test   $0x1,%dl
  8010f9:	74 1a                	je     801115 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	eb 13                	jmp    80111a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801107:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110c:	eb 0c                	jmp    80111a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80110e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801113:	eb 05                	jmp    80111a <fd_lookup+0x54>
  801115:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 18             	sub    $0x18,%esp
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801125:	ba 00 00 00 00       	mov    $0x0,%edx
  80112a:	eb 13                	jmp    80113f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80112c:	39 08                	cmp    %ecx,(%eax)
  80112e:	75 0c                	jne    80113c <dev_lookup+0x20>
			*dev = devtab[i];
  801130:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801133:	89 01                	mov    %eax,(%ecx)
			return 0;
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
  80113a:	eb 38                	jmp    801174 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80113c:	83 c2 01             	add    $0x1,%edx
  80113f:	8b 04 95 40 2c 80 00 	mov    0x802c40(,%edx,4),%eax
  801146:	85 c0                	test   %eax,%eax
  801148:	75 e2                	jne    80112c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80114a:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80114f:	8b 40 48             	mov    0x48(%eax),%eax
  801152:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801156:	89 44 24 04          	mov    %eax,0x4(%esp)
  80115a:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  801161:	e8 f2 f0 ff ff       	call   800258 <cprintf>
	*dev = 0;
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80116f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	56                   	push   %esi
  80117a:	53                   	push   %ebx
  80117b:	83 ec 20             	sub    $0x20,%esp
  80117e:	8b 75 08             	mov    0x8(%ebp),%esi
  801181:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801184:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801187:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801191:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801194:	89 04 24             	mov    %eax,(%esp)
  801197:	e8 2a ff ff ff       	call   8010c6 <fd_lookup>
  80119c:	85 c0                	test   %eax,%eax
  80119e:	78 05                	js     8011a5 <fd_close+0x2f>
	    || fd != fd2)
  8011a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011a3:	74 0c                	je     8011b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011a5:	84 db                	test   %bl,%bl
  8011a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ac:	0f 44 c2             	cmove  %edx,%eax
  8011af:	eb 3f                	jmp    8011f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011b8:	8b 06                	mov    (%esi),%eax
  8011ba:	89 04 24             	mov    %eax,(%esp)
  8011bd:	e8 5a ff ff ff       	call   80111c <dev_lookup>
  8011c2:	89 c3                	mov    %eax,%ebx
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	78 16                	js     8011de <fd_close+0x68>
		if (dev->dev_close)
  8011c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	74 07                	je     8011de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011d7:	89 34 24             	mov    %esi,(%esp)
  8011da:	ff d0                	call   *%eax
  8011dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e9:	e8 fe fb ff ff       	call   800dec <sys_page_unmap>
	return r;
  8011ee:	89 d8                	mov    %ebx,%eax
}
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	5b                   	pop    %ebx
  8011f4:	5e                   	pop    %esi
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    

008011f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801200:	89 44 24 04          	mov    %eax,0x4(%esp)
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	89 04 24             	mov    %eax,(%esp)
  80120a:	e8 b7 fe ff ff       	call   8010c6 <fd_lookup>
  80120f:	89 c2                	mov    %eax,%edx
  801211:	85 d2                	test   %edx,%edx
  801213:	78 13                	js     801228 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801215:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80121c:	00 
  80121d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801220:	89 04 24             	mov    %eax,(%esp)
  801223:	e8 4e ff ff ff       	call   801176 <fd_close>
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <close_all>:

void
close_all(void)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	53                   	push   %ebx
  80122e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801231:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801236:	89 1c 24             	mov    %ebx,(%esp)
  801239:	e8 b9 ff ff ff       	call   8011f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80123e:	83 c3 01             	add    $0x1,%ebx
  801241:	83 fb 20             	cmp    $0x20,%ebx
  801244:	75 f0                	jne    801236 <close_all+0xc>
		close(i);
}
  801246:	83 c4 14             	add    $0x14,%esp
  801249:	5b                   	pop    %ebx
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	57                   	push   %edi
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
  801252:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801255:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 04 24             	mov    %eax,(%esp)
  801262:	e8 5f fe ff ff       	call   8010c6 <fd_lookup>
  801267:	89 c2                	mov    %eax,%edx
  801269:	85 d2                	test   %edx,%edx
  80126b:	0f 88 e1 00 00 00    	js     801352 <dup+0x106>
		return r;
	close(newfdnum);
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	89 04 24             	mov    %eax,(%esp)
  801277:	e8 7b ff ff ff       	call   8011f7 <close>

	newfd = INDEX2FD(newfdnum);
  80127c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80127f:	c1 e3 0c             	shl    $0xc,%ebx
  801282:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128b:	89 04 24             	mov    %eax,(%esp)
  80128e:	e8 cd fd ff ff       	call   801060 <fd2data>
  801293:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801295:	89 1c 24             	mov    %ebx,(%esp)
  801298:	e8 c3 fd ff ff       	call   801060 <fd2data>
  80129d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80129f:	89 f0                	mov    %esi,%eax
  8012a1:	c1 e8 16             	shr    $0x16,%eax
  8012a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ab:	a8 01                	test   $0x1,%al
  8012ad:	74 43                	je     8012f2 <dup+0xa6>
  8012af:	89 f0                	mov    %esi,%eax
  8012b1:	c1 e8 0c             	shr    $0xc,%eax
  8012b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012bb:	f6 c2 01             	test   $0x1,%dl
  8012be:	74 32                	je     8012f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012db:	00 
  8012dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e7:	e8 ad fa ff ff       	call   800d99 <sys_page_map>
  8012ec:	89 c6                	mov    %eax,%esi
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 3e                	js     801330 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f5:	89 c2                	mov    %eax,%edx
  8012f7:	c1 ea 0c             	shr    $0xc,%edx
  8012fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801301:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801307:	89 54 24 10          	mov    %edx,0x10(%esp)
  80130b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80130f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801316:	00 
  801317:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801322:	e8 72 fa ff ff       	call   800d99 <sys_page_map>
  801327:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801329:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80132c:	85 f6                	test   %esi,%esi
  80132e:	79 22                	jns    801352 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801330:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133b:	e8 ac fa ff ff       	call   800dec <sys_page_unmap>
	sys_page_unmap(0, nva);
  801340:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134b:	e8 9c fa ff ff       	call   800dec <sys_page_unmap>
	return r;
  801350:	89 f0                	mov    %esi,%eax
}
  801352:	83 c4 3c             	add    $0x3c,%esp
  801355:	5b                   	pop    %ebx
  801356:	5e                   	pop    %esi
  801357:	5f                   	pop    %edi
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	53                   	push   %ebx
  80135e:	83 ec 24             	sub    $0x24,%esp
  801361:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801364:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136b:	89 1c 24             	mov    %ebx,(%esp)
  80136e:	e8 53 fd ff ff       	call   8010c6 <fd_lookup>
  801373:	89 c2                	mov    %eax,%edx
  801375:	85 d2                	test   %edx,%edx
  801377:	78 6d                	js     8013e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801379:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	89 04 24             	mov    %eax,(%esp)
  801388:	e8 8f fd ff ff       	call   80111c <dev_lookup>
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 55                	js     8013e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801394:	8b 50 08             	mov    0x8(%eax),%edx
  801397:	83 e2 03             	and    $0x3,%edx
  80139a:	83 fa 01             	cmp    $0x1,%edx
  80139d:	75 23                	jne    8013c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80139f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8013a4:	8b 40 48             	mov    0x48(%eax),%eax
  8013a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013af:	c7 04 24 05 2c 80 00 	movl   $0x802c05,(%esp)
  8013b6:	e8 9d ee ff ff       	call   800258 <cprintf>
		return -E_INVAL;
  8013bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c0:	eb 24                	jmp    8013e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c5:	8b 52 08             	mov    0x8(%edx),%edx
  8013c8:	85 d2                	test   %edx,%edx
  8013ca:	74 15                	je     8013e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013da:	89 04 24             	mov    %eax,(%esp)
  8013dd:	ff d2                	call   *%edx
  8013df:	eb 05                	jmp    8013e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013e6:	83 c4 24             	add    $0x24,%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    

008013ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	57                   	push   %edi
  8013f0:	56                   	push   %esi
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 1c             	sub    $0x1c,%esp
  8013f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801400:	eb 23                	jmp    801425 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801402:	89 f0                	mov    %esi,%eax
  801404:	29 d8                	sub    %ebx,%eax
  801406:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140a:	89 d8                	mov    %ebx,%eax
  80140c:	03 45 0c             	add    0xc(%ebp),%eax
  80140f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801413:	89 3c 24             	mov    %edi,(%esp)
  801416:	e8 3f ff ff ff       	call   80135a <read>
		if (m < 0)
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 10                	js     80142f <readn+0x43>
			return m;
		if (m == 0)
  80141f:	85 c0                	test   %eax,%eax
  801421:	74 0a                	je     80142d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801423:	01 c3                	add    %eax,%ebx
  801425:	39 f3                	cmp    %esi,%ebx
  801427:	72 d9                	jb     801402 <readn+0x16>
  801429:	89 d8                	mov    %ebx,%eax
  80142b:	eb 02                	jmp    80142f <readn+0x43>
  80142d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80142f:	83 c4 1c             	add    $0x1c,%esp
  801432:	5b                   	pop    %ebx
  801433:	5e                   	pop    %esi
  801434:	5f                   	pop    %edi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	53                   	push   %ebx
  80143b:	83 ec 24             	sub    $0x24,%esp
  80143e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801441:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801444:	89 44 24 04          	mov    %eax,0x4(%esp)
  801448:	89 1c 24             	mov    %ebx,(%esp)
  80144b:	e8 76 fc ff ff       	call   8010c6 <fd_lookup>
  801450:	89 c2                	mov    %eax,%edx
  801452:	85 d2                	test   %edx,%edx
  801454:	78 68                	js     8014be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801456:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801460:	8b 00                	mov    (%eax),%eax
  801462:	89 04 24             	mov    %eax,(%esp)
  801465:	e8 b2 fc ff ff       	call   80111c <dev_lookup>
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 50                	js     8014be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801471:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801475:	75 23                	jne    80149a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801477:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80147c:	8b 40 48             	mov    0x48(%eax),%eax
  80147f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801483:	89 44 24 04          	mov    %eax,0x4(%esp)
  801487:	c7 04 24 21 2c 80 00 	movl   $0x802c21,(%esp)
  80148e:	e8 c5 ed ff ff       	call   800258 <cprintf>
		return -E_INVAL;
  801493:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801498:	eb 24                	jmp    8014be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80149a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149d:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a0:	85 d2                	test   %edx,%edx
  8014a2:	74 15                	je     8014b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014b2:	89 04 24             	mov    %eax,(%esp)
  8014b5:	ff d2                	call   *%edx
  8014b7:	eb 05                	jmp    8014be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014be:	83 c4 24             	add    $0x24,%esp
  8014c1:	5b                   	pop    %ebx
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	89 04 24             	mov    %eax,(%esp)
  8014d7:	e8 ea fb ff ff       	call   8010c6 <fd_lookup>
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 0e                	js     8014ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 24             	sub    $0x24,%esp
  8014f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801501:	89 1c 24             	mov    %ebx,(%esp)
  801504:	e8 bd fb ff ff       	call   8010c6 <fd_lookup>
  801509:	89 c2                	mov    %eax,%edx
  80150b:	85 d2                	test   %edx,%edx
  80150d:	78 61                	js     801570 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801512:	89 44 24 04          	mov    %eax,0x4(%esp)
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	89 04 24             	mov    %eax,(%esp)
  80151e:	e8 f9 fb ff ff       	call   80111c <dev_lookup>
  801523:	85 c0                	test   %eax,%eax
  801525:	78 49                	js     801570 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152e:	75 23                	jne    801553 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801530:	a1 20 40 c0 00       	mov    0xc04020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801535:	8b 40 48             	mov    0x48(%eax),%eax
  801538:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80153c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801540:	c7 04 24 e4 2b 80 00 	movl   $0x802be4,(%esp)
  801547:	e8 0c ed ff ff       	call   800258 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80154c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801551:	eb 1d                	jmp    801570 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801556:	8b 52 18             	mov    0x18(%edx),%edx
  801559:	85 d2                	test   %edx,%edx
  80155b:	74 0e                	je     80156b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80155d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801560:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	ff d2                	call   *%edx
  801569:	eb 05                	jmp    801570 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80156b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801570:	83 c4 24             	add    $0x24,%esp
  801573:	5b                   	pop    %ebx
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    

00801576 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	53                   	push   %ebx
  80157a:	83 ec 24             	sub    $0x24,%esp
  80157d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801580:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801583:	89 44 24 04          	mov    %eax,0x4(%esp)
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 04 24             	mov    %eax,(%esp)
  80158d:	e8 34 fb ff ff       	call   8010c6 <fd_lookup>
  801592:	89 c2                	mov    %eax,%edx
  801594:	85 d2                	test   %edx,%edx
  801596:	78 52                	js     8015ea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801598:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	8b 00                	mov    (%eax),%eax
  8015a4:	89 04 24             	mov    %eax,(%esp)
  8015a7:	e8 70 fb ff ff       	call   80111c <dev_lookup>
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 3a                	js     8015ea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015b7:	74 2c                	je     8015e5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015c3:	00 00 00 
	stat->st_isdir = 0;
  8015c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015cd:	00 00 00 
	stat->st_dev = dev;
  8015d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015dd:	89 14 24             	mov    %edx,(%esp)
  8015e0:	ff 50 14             	call   *0x14(%eax)
  8015e3:	eb 05                	jmp    8015ea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015ea:	83 c4 24             	add    $0x24,%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	56                   	push   %esi
  8015f4:	53                   	push   %ebx
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015ff:	00 
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	89 04 24             	mov    %eax,(%esp)
  801606:	e8 99 02 00 00       	call   8018a4 <open>
  80160b:	89 c3                	mov    %eax,%ebx
  80160d:	85 db                	test   %ebx,%ebx
  80160f:	78 1b                	js     80162c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	89 44 24 04          	mov    %eax,0x4(%esp)
  801618:	89 1c 24             	mov    %ebx,(%esp)
  80161b:	e8 56 ff ff ff       	call   801576 <fstat>
  801620:	89 c6                	mov    %eax,%esi
	close(fd);
  801622:	89 1c 24             	mov    %ebx,(%esp)
  801625:	e8 cd fb ff ff       	call   8011f7 <close>
	return r;
  80162a:	89 f0                	mov    %esi,%eax
}
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	5b                   	pop    %ebx
  801630:	5e                   	pop    %esi
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    

00801633 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	56                   	push   %esi
  801637:	53                   	push   %ebx
  801638:	83 ec 10             	sub    $0x10,%esp
  80163b:	89 c6                	mov    %eax,%esi
  80163d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80163f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801646:	75 11                	jne    801659 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801648:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80164f:	e8 2b 0e 00 00       	call   80247f <ipc_find_env>
  801654:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801659:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801660:	00 
  801661:	c7 44 24 08 00 50 c0 	movl   $0xc05000,0x8(%esp)
  801668:	00 
  801669:	89 74 24 04          	mov    %esi,0x4(%esp)
  80166d:	a1 00 40 80 00       	mov    0x804000,%eax
  801672:	89 04 24             	mov    %eax,(%esp)
  801675:	e8 9e 0d 00 00       	call   802418 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80167a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801681:	00 
  801682:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801686:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168d:	e8 1e 0d 00 00       	call   8023b0 <ipc_recv>
}
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    

00801699 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a5:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016bc:	e8 72 ff ff ff       	call   801633 <fsipc>
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016cf:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016de:	e8 50 ff ff ff       	call   801633 <fsipc>
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 14             	sub    $0x14,%esp
  8016ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f5:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801704:	e8 2a ff ff ff       	call   801633 <fsipc>
  801709:	89 c2                	mov    %eax,%edx
  80170b:	85 d2                	test   %edx,%edx
  80170d:	78 2b                	js     80173a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80170f:	c7 44 24 04 00 50 c0 	movl   $0xc05000,0x4(%esp)
  801716:	00 
  801717:	89 1c 24             	mov    %ebx,(%esp)
  80171a:	e8 b8 f1 ff ff       	call   8008d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80171f:	a1 80 50 c0 00       	mov    0xc05080,%eax
  801724:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80172a:	a1 84 50 c0 00       	mov    0xc05084,%eax
  80172f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	83 c4 14             	add    $0x14,%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    

00801740 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	53                   	push   %ebx
  801744:	83 ec 14             	sub    $0x14,%esp
  801747:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80174a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801750:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801755:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801758:	8b 55 08             	mov    0x8(%ebp),%edx
  80175b:	8b 52 0c             	mov    0xc(%edx),%edx
  80175e:	89 15 00 50 c0 00    	mov    %edx,0xc05000
	fsipcbuf.write.req_n = count;
  801764:	a3 04 50 c0 00       	mov    %eax,0xc05004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801769:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	89 44 24 04          	mov    %eax,0x4(%esp)
  801774:	c7 04 24 08 50 c0 00 	movl   $0xc05008,(%esp)
  80177b:	e8 f4 f2 ff ff       	call   800a74 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801780:	c7 44 24 04 08 50 c0 	movl   $0xc05008,0x4(%esp)
  801787:	00 
  801788:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  80178f:	e8 c4 ea ff ff       	call   800258 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801794:	ba 00 00 00 00       	mov    $0x0,%edx
  801799:	b8 04 00 00 00       	mov    $0x4,%eax
  80179e:	e8 90 fe ff ff       	call   801633 <fsipc>
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 53                	js     8017fa <devfile_write+0xba>
		return r;
	assert(r <= n);
  8017a7:	39 c3                	cmp    %eax,%ebx
  8017a9:	73 24                	jae    8017cf <devfile_write+0x8f>
  8017ab:	c7 44 24 0c 59 2c 80 	movl   $0x802c59,0xc(%esp)
  8017b2:	00 
  8017b3:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  8017ba:	00 
  8017bb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8017c2:	00 
  8017c3:	c7 04 24 75 2c 80 00 	movl   $0x802c75,(%esp)
  8017ca:	e8 90 e9 ff ff       	call   80015f <_panic>
	assert(r <= PGSIZE);
  8017cf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017d4:	7e 24                	jle    8017fa <devfile_write+0xba>
  8017d6:	c7 44 24 0c 80 2c 80 	movl   $0x802c80,0xc(%esp)
  8017dd:	00 
  8017de:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  8017e5:	00 
  8017e6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8017ed:	00 
  8017ee:	c7 04 24 75 2c 80 00 	movl   $0x802c75,(%esp)
  8017f5:	e8 65 e9 ff ff       	call   80015f <_panic>
	return r;
}
  8017fa:	83 c4 14             	add    $0x14,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	56                   	push   %esi
  801804:	53                   	push   %ebx
  801805:	83 ec 10             	sub    $0x10,%esp
  801808:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	8b 40 0c             	mov    0xc(%eax),%eax
  801811:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  801816:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80181c:	ba 00 00 00 00       	mov    $0x0,%edx
  801821:	b8 03 00 00 00       	mov    $0x3,%eax
  801826:	e8 08 fe ff ff       	call   801633 <fsipc>
  80182b:	89 c3                	mov    %eax,%ebx
  80182d:	85 c0                	test   %eax,%eax
  80182f:	78 6a                	js     80189b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801831:	39 c6                	cmp    %eax,%esi
  801833:	73 24                	jae    801859 <devfile_read+0x59>
  801835:	c7 44 24 0c 59 2c 80 	movl   $0x802c59,0xc(%esp)
  80183c:	00 
  80183d:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  801844:	00 
  801845:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80184c:	00 
  80184d:	c7 04 24 75 2c 80 00 	movl   $0x802c75,(%esp)
  801854:	e8 06 e9 ff ff       	call   80015f <_panic>
	assert(r <= PGSIZE);
  801859:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80185e:	7e 24                	jle    801884 <devfile_read+0x84>
  801860:	c7 44 24 0c 80 2c 80 	movl   $0x802c80,0xc(%esp)
  801867:	00 
  801868:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  80186f:	00 
  801870:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801877:	00 
  801878:	c7 04 24 75 2c 80 00 	movl   $0x802c75,(%esp)
  80187f:	e8 db e8 ff ff       	call   80015f <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801884:	89 44 24 08          	mov    %eax,0x8(%esp)
  801888:	c7 44 24 04 00 50 c0 	movl   $0xc05000,0x4(%esp)
  80188f:	00 
  801890:	8b 45 0c             	mov    0xc(%ebp),%eax
  801893:	89 04 24             	mov    %eax,(%esp)
  801896:	e8 d9 f1 ff ff       	call   800a74 <memmove>
	return r;
}
  80189b:	89 d8                	mov    %ebx,%eax
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	5b                   	pop    %ebx
  8018a1:	5e                   	pop    %esi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    

008018a4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 24             	sub    $0x24,%esp
  8018ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018ae:	89 1c 24             	mov    %ebx,(%esp)
  8018b1:	e8 ea ef ff ff       	call   8008a0 <strlen>
  8018b6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018bb:	7f 60                	jg     80191d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c0:	89 04 24             	mov    %eax,(%esp)
  8018c3:	e8 af f7 ff ff       	call   801077 <fd_alloc>
  8018c8:	89 c2                	mov    %eax,%edx
  8018ca:	85 d2                	test   %edx,%edx
  8018cc:	78 54                	js     801922 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d2:	c7 04 24 00 50 c0 00 	movl   $0xc05000,(%esp)
  8018d9:	e8 f9 ef ff ff       	call   8008d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e1:	a3 00 54 c0 00       	mov    %eax,0xc05400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ee:	e8 40 fd ff ff       	call   801633 <fsipc>
  8018f3:	89 c3                	mov    %eax,%ebx
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	79 17                	jns    801910 <open+0x6c>
		fd_close(fd, 0);
  8018f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801900:	00 
  801901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	e8 6a f8 ff ff       	call   801176 <fd_close>
		return r;
  80190c:	89 d8                	mov    %ebx,%eax
  80190e:	eb 12                	jmp    801922 <open+0x7e>
	}

	return fd2num(fd);
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	89 04 24             	mov    %eax,(%esp)
  801916:	e8 35 f7 ff ff       	call   801050 <fd2num>
  80191b:	eb 05                	jmp    801922 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80191d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801922:	83 c4 24             	add    $0x24,%esp
  801925:	5b                   	pop    %ebx
  801926:	5d                   	pop    %ebp
  801927:	c3                   	ret    

00801928 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80192e:	ba 00 00 00 00       	mov    $0x0,%edx
  801933:	b8 08 00 00 00       	mov    $0x8,%eax
  801938:	e8 f6 fc ff ff       	call   801633 <fsipc>
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <evict>:

int evict(void)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801945:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  80194c:	e8 07 e9 ff ff       	call   800258 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801951:	ba 00 00 00 00       	mov    $0x0,%edx
  801956:	b8 09 00 00 00       	mov    $0x9,%eax
  80195b:	e8 d3 fc ff ff       	call   801633 <fsipc>
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    
  801962:	66 90                	xchg   %ax,%ax
  801964:	66 90                	xchg   %ax,%ax
  801966:	66 90                	xchg   %ax,%ax
  801968:	66 90                	xchg   %ax,%ax
  80196a:	66 90                	xchg   %ax,%ax
  80196c:	66 90                	xchg   %ax,%ax
  80196e:	66 90                	xchg   %ax,%ax

00801970 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801976:	c7 44 24 04 a5 2c 80 	movl   $0x802ca5,0x4(%esp)
  80197d:	00 
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	89 04 24             	mov    %eax,(%esp)
  801984:	e8 4e ef ff ff       	call   8008d7 <strcpy>
	return 0;
}
  801989:	b8 00 00 00 00       	mov    $0x0,%eax
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	53                   	push   %ebx
  801994:	83 ec 14             	sub    $0x14,%esp
  801997:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80199a:	89 1c 24             	mov    %ebx,(%esp)
  80199d:	e8 15 0b 00 00       	call   8024b7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8019a2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8019a7:	83 f8 01             	cmp    $0x1,%eax
  8019aa:	75 0d                	jne    8019b9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8019ac:	8b 43 0c             	mov    0xc(%ebx),%eax
  8019af:	89 04 24             	mov    %eax,(%esp)
  8019b2:	e8 29 03 00 00       	call   801ce0 <nsipc_close>
  8019b7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8019b9:	89 d0                	mov    %edx,%eax
  8019bb:	83 c4 14             	add    $0x14,%esp
  8019be:	5b                   	pop    %ebx
  8019bf:	5d                   	pop    %ebp
  8019c0:	c3                   	ret    

008019c1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ce:	00 
  8019cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e3:	89 04 24             	mov    %eax,(%esp)
  8019e6:	e8 f0 03 00 00       	call   801ddb <nsipc_send>
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019fa:	00 
  8019fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0f:	89 04 24             	mov    %eax,(%esp)
  801a12:	e8 44 03 00 00       	call   801d5b <nsipc_recv>
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a1f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a22:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a26:	89 04 24             	mov    %eax,(%esp)
  801a29:	e8 98 f6 ff ff       	call   8010c6 <fd_lookup>
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 17                	js     801a49 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a35:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a3b:	39 08                	cmp    %ecx,(%eax)
  801a3d:	75 05                	jne    801a44 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a42:	eb 05                	jmp    801a49 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	56                   	push   %esi
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 20             	sub    $0x20,%esp
  801a53:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a58:	89 04 24             	mov    %eax,(%esp)
  801a5b:	e8 17 f6 ff ff       	call   801077 <fd_alloc>
  801a60:	89 c3                	mov    %eax,%ebx
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 21                	js     801a87 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a6d:	00 
  801a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7c:	e8 c4 f2 ff ff       	call   800d45 <sys_page_alloc>
  801a81:	89 c3                	mov    %eax,%ebx
  801a83:	85 c0                	test   %eax,%eax
  801a85:	79 0c                	jns    801a93 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a87:	89 34 24             	mov    %esi,(%esp)
  801a8a:	e8 51 02 00 00       	call   801ce0 <nsipc_close>
		return r;
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	eb 20                	jmp    801ab3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a93:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801aa8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801aab:	89 14 24             	mov    %edx,(%esp)
  801aae:	e8 9d f5 ff ff       	call   801050 <fd2num>
}
  801ab3:	83 c4 20             	add    $0x20,%esp
  801ab6:	5b                   	pop    %ebx
  801ab7:	5e                   	pop    %esi
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    

00801aba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	e8 51 ff ff ff       	call   801a19 <fd2sockid>
		return r;
  801ac8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 23                	js     801af1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ace:	8b 55 10             	mov    0x10(%ebp),%edx
  801ad1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801adc:	89 04 24             	mov    %eax,(%esp)
  801adf:	e8 45 01 00 00       	call   801c29 <nsipc_accept>
		return r;
  801ae4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 07                	js     801af1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801aea:	e8 5c ff ff ff       	call   801a4b <alloc_sockfd>
  801aef:	89 c1                	mov    %eax,%ecx
}
  801af1:	89 c8                	mov    %ecx,%eax
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	e8 16 ff ff ff       	call   801a19 <fd2sockid>
  801b03:	89 c2                	mov    %eax,%edx
  801b05:	85 d2                	test   %edx,%edx
  801b07:	78 16                	js     801b1f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b17:	89 14 24             	mov    %edx,(%esp)
  801b1a:	e8 60 01 00 00       	call   801c7f <nsipc_bind>
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <shutdown>:

int
shutdown(int s, int how)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	e8 ea fe ff ff       	call   801a19 <fd2sockid>
  801b2f:	89 c2                	mov    %eax,%edx
  801b31:	85 d2                	test   %edx,%edx
  801b33:	78 0f                	js     801b44 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3c:	89 14 24             	mov    %edx,(%esp)
  801b3f:	e8 7a 01 00 00       	call   801cbe <nsipc_shutdown>
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	e8 c5 fe ff ff       	call   801a19 <fd2sockid>
  801b54:	89 c2                	mov    %eax,%edx
  801b56:	85 d2                	test   %edx,%edx
  801b58:	78 16                	js     801b70 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b68:	89 14 24             	mov    %edx,(%esp)
  801b6b:	e8 8a 01 00 00       	call   801cfa <nsipc_connect>
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <listen>:

int
listen(int s, int backlog)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	e8 99 fe ff ff       	call   801a19 <fd2sockid>
  801b80:	89 c2                	mov    %eax,%edx
  801b82:	85 d2                	test   %edx,%edx
  801b84:	78 0f                	js     801b95 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8d:	89 14 24             	mov    %edx,(%esp)
  801b90:	e8 a4 01 00 00       	call   801d39 <nsipc_listen>
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	89 04 24             	mov    %eax,(%esp)
  801bb1:	e8 98 02 00 00       	call   801e4e <nsipc_socket>
  801bb6:	89 c2                	mov    %eax,%edx
  801bb8:	85 d2                	test   %edx,%edx
  801bba:	78 05                	js     801bc1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801bbc:	e8 8a fe ff ff       	call   801a4b <alloc_sockfd>
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 14             	sub    $0x14,%esp
  801bca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bcc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bd3:	75 11                	jne    801be6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bd5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801bdc:	e8 9e 08 00 00       	call   80247f <ipc_find_env>
  801be1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801be6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bed:	00 
  801bee:	c7 44 24 08 00 60 c0 	movl   $0xc06000,0x8(%esp)
  801bf5:	00 
  801bf6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bfa:	a1 04 40 80 00       	mov    0x804004,%eax
  801bff:	89 04 24             	mov    %eax,(%esp)
  801c02:	e8 11 08 00 00       	call   802418 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c0e:	00 
  801c0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c16:	00 
  801c17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c1e:	e8 8d 07 00 00       	call   8023b0 <ipc_recv>
}
  801c23:	83 c4 14             	add    $0x14,%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    

00801c29 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	56                   	push   %esi
  801c2d:	53                   	push   %ebx
  801c2e:	83 ec 10             	sub    $0x10,%esp
  801c31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c3c:	8b 06                	mov    (%esi),%eax
  801c3e:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c43:	b8 01 00 00 00       	mov    $0x1,%eax
  801c48:	e8 76 ff ff ff       	call   801bc3 <nsipc>
  801c4d:	89 c3                	mov    %eax,%ebx
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	78 23                	js     801c76 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c53:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801c58:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c5c:	c7 44 24 04 00 60 c0 	movl   $0xc06000,0x4(%esp)
  801c63:	00 
  801c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c67:	89 04 24             	mov    %eax,(%esp)
  801c6a:	e8 05 ee ff ff       	call   800a74 <memmove>
		*addrlen = ret->ret_addrlen;
  801c6f:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801c74:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801c76:	89 d8                	mov    %ebx,%eax
  801c78:	83 c4 10             	add    $0x10,%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5d                   	pop    %ebp
  801c7e:	c3                   	ret    

00801c7f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	53                   	push   %ebx
  801c83:	83 ec 14             	sub    $0x14,%esp
  801c86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9c:	c7 04 24 04 60 c0 00 	movl   $0xc06004,(%esp)
  801ca3:	e8 cc ed ff ff       	call   800a74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ca8:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801cae:	b8 02 00 00 00       	mov    $0x2,%eax
  801cb3:	e8 0b ff ff ff       	call   801bc3 <nsipc>
}
  801cb8:	83 c4 14             	add    $0x14,%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    

00801cbe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801cd4:	b8 03 00 00 00       	mov    $0x3,%eax
  801cd9:	e8 e5 fe ff ff       	call   801bc3 <nsipc>
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <nsipc_close>:

int
nsipc_close(int s)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801cee:	b8 04 00 00 00       	mov    $0x4,%eax
  801cf3:	e8 cb fe ff ff       	call   801bc3 <nsipc>
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	53                   	push   %ebx
  801cfe:	83 ec 14             	sub    $0x14,%esp
  801d01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d0c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d17:	c7 04 24 04 60 c0 00 	movl   $0xc06004,(%esp)
  801d1e:	e8 51 ed ff ff       	call   800a74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d23:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801d29:	b8 05 00 00 00       	mov    $0x5,%eax
  801d2e:	e8 90 fe ff ff       	call   801bc3 <nsipc>
}
  801d33:	83 c4 14             	add    $0x14,%esp
  801d36:	5b                   	pop    %ebx
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4a:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801d4f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d54:	e8 6a fe ff ff       	call   801bc3 <nsipc>
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 10             	sub    $0x10,%esp
  801d63:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801d6e:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801d74:	8b 45 14             	mov    0x14(%ebp),%eax
  801d77:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d7c:	b8 07 00 00 00       	mov    $0x7,%eax
  801d81:	e8 3d fe ff ff       	call   801bc3 <nsipc>
  801d86:	89 c3                	mov    %eax,%ebx
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	78 46                	js     801dd2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d8c:	39 f0                	cmp    %esi,%eax
  801d8e:	7f 07                	jg     801d97 <nsipc_recv+0x3c>
  801d90:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d95:	7e 24                	jle    801dbb <nsipc_recv+0x60>
  801d97:	c7 44 24 0c b1 2c 80 	movl   $0x802cb1,0xc(%esp)
  801d9e:	00 
  801d9f:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  801da6:	00 
  801da7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801dae:	00 
  801daf:	c7 04 24 c6 2c 80 00 	movl   $0x802cc6,(%esp)
  801db6:	e8 a4 e3 ff ff       	call   80015f <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dbb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dbf:	c7 44 24 04 00 60 c0 	movl   $0xc06000,0x4(%esp)
  801dc6:	00 
  801dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dca:	89 04 24             	mov    %eax,(%esp)
  801dcd:	e8 a2 ec ff ff       	call   800a74 <memmove>
	}

	return r;
}
  801dd2:	89 d8                	mov    %ebx,%eax
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5d                   	pop    %ebp
  801dda:	c3                   	ret    

00801ddb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 14             	sub    $0x14,%esp
  801de2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801ded:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801df3:	7e 24                	jle    801e19 <nsipc_send+0x3e>
  801df5:	c7 44 24 0c d2 2c 80 	movl   $0x802cd2,0xc(%esp)
  801dfc:	00 
  801dfd:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  801e04:	00 
  801e05:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801e0c:	00 
  801e0d:	c7 04 24 c6 2c 80 00 	movl   $0x802cc6,(%esp)
  801e14:	e8 46 e3 ff ff       	call   80015f <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e24:	c7 04 24 0c 60 c0 00 	movl   $0xc0600c,(%esp)
  801e2b:	e8 44 ec ff ff       	call   800a74 <memmove>
	nsipcbuf.send.req_size = size;
  801e30:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801e36:	8b 45 14             	mov    0x14(%ebp),%eax
  801e39:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801e3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e43:	e8 7b fd ff ff       	call   801bc3 <nsipc>
}
  801e48:	83 c4 14             	add    $0x14,%esp
  801e4b:	5b                   	pop    %ebx
  801e4c:	5d                   	pop    %ebp
  801e4d:	c3                   	ret    

00801e4e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5f:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801e64:	8b 45 10             	mov    0x10(%ebp),%eax
  801e67:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801e6c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e71:	e8 4d fd ff ff       	call   801bc3 <nsipc>
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	56                   	push   %esi
  801e7c:	53                   	push   %ebx
  801e7d:	83 ec 10             	sub    $0x10,%esp
  801e80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	89 04 24             	mov    %eax,(%esp)
  801e89:	e8 d2 f1 ff ff       	call   801060 <fd2data>
  801e8e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e90:	c7 44 24 04 de 2c 80 	movl   $0x802cde,0x4(%esp)
  801e97:	00 
  801e98:	89 1c 24             	mov    %ebx,(%esp)
  801e9b:	e8 37 ea ff ff       	call   8008d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ea0:	8b 46 04             	mov    0x4(%esi),%eax
  801ea3:	2b 06                	sub    (%esi),%eax
  801ea5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801eab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801eb2:	00 00 00 
	stat->st_dev = &devpipe;
  801eb5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ebc:	30 80 00 
	return 0;
}
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	5b                   	pop    %ebx
  801ec8:	5e                   	pop    %esi
  801ec9:	5d                   	pop    %ebp
  801eca:	c3                   	ret    

00801ecb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	53                   	push   %ebx
  801ecf:	83 ec 14             	sub    $0x14,%esp
  801ed2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ed5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ed9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee0:	e8 07 ef ff ff       	call   800dec <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ee5:	89 1c 24             	mov    %ebx,(%esp)
  801ee8:	e8 73 f1 ff ff       	call   801060 <fd2data>
  801eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef8:	e8 ef ee ff ff       	call   800dec <sys_page_unmap>
}
  801efd:	83 c4 14             	add    $0x14,%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5d                   	pop    %ebp
  801f02:	c3                   	ret    

00801f03 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	57                   	push   %edi
  801f07:	56                   	push   %esi
  801f08:	53                   	push   %ebx
  801f09:	83 ec 2c             	sub    $0x2c,%esp
  801f0c:	89 c6                	mov    %eax,%esi
  801f0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f11:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801f16:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f19:	89 34 24             	mov    %esi,(%esp)
  801f1c:	e8 96 05 00 00       	call   8024b7 <pageref>
  801f21:	89 c7                	mov    %eax,%edi
  801f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f26:	89 04 24             	mov    %eax,(%esp)
  801f29:	e8 89 05 00 00       	call   8024b7 <pageref>
  801f2e:	39 c7                	cmp    %eax,%edi
  801f30:	0f 94 c2             	sete   %dl
  801f33:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f36:	8b 0d 20 40 c0 00    	mov    0xc04020,%ecx
  801f3c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f3f:	39 fb                	cmp    %edi,%ebx
  801f41:	74 21                	je     801f64 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f43:	84 d2                	test   %dl,%dl
  801f45:	74 ca                	je     801f11 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f47:	8b 51 58             	mov    0x58(%ecx),%edx
  801f4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f4e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f56:	c7 04 24 e5 2c 80 00 	movl   $0x802ce5,(%esp)
  801f5d:	e8 f6 e2 ff ff       	call   800258 <cprintf>
  801f62:	eb ad                	jmp    801f11 <_pipeisclosed+0xe>
	}
}
  801f64:	83 c4 2c             	add    $0x2c,%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5f                   	pop    %edi
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    

00801f6c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	57                   	push   %edi
  801f70:	56                   	push   %esi
  801f71:	53                   	push   %ebx
  801f72:	83 ec 1c             	sub    $0x1c,%esp
  801f75:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f78:	89 34 24             	mov    %esi,(%esp)
  801f7b:	e8 e0 f0 ff ff       	call   801060 <fd2data>
  801f80:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f82:	bf 00 00 00 00       	mov    $0x0,%edi
  801f87:	eb 45                	jmp    801fce <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f89:	89 da                	mov    %ebx,%edx
  801f8b:	89 f0                	mov    %esi,%eax
  801f8d:	e8 71 ff ff ff       	call   801f03 <_pipeisclosed>
  801f92:	85 c0                	test   %eax,%eax
  801f94:	75 41                	jne    801fd7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f96:	e8 8b ed ff ff       	call   800d26 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f9b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f9e:	8b 0b                	mov    (%ebx),%ecx
  801fa0:	8d 51 20             	lea    0x20(%ecx),%edx
  801fa3:	39 d0                	cmp    %edx,%eax
  801fa5:	73 e2                	jae    801f89 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801faa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fb1:	99                   	cltd   
  801fb2:	c1 ea 1b             	shr    $0x1b,%edx
  801fb5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801fb8:	83 e1 1f             	and    $0x1f,%ecx
  801fbb:	29 d1                	sub    %edx,%ecx
  801fbd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801fc1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fc5:	83 c0 01             	add    $0x1,%eax
  801fc8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fcb:	83 c7 01             	add    $0x1,%edi
  801fce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fd1:	75 c8                	jne    801f9b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fd3:	89 f8                	mov    %edi,%eax
  801fd5:	eb 05                	jmp    801fdc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fdc:	83 c4 1c             	add    $0x1c,%esp
  801fdf:	5b                   	pop    %ebx
  801fe0:	5e                   	pop    %esi
  801fe1:	5f                   	pop    %edi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    

00801fe4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	57                   	push   %edi
  801fe8:	56                   	push   %esi
  801fe9:	53                   	push   %ebx
  801fea:	83 ec 1c             	sub    $0x1c,%esp
  801fed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ff0:	89 3c 24             	mov    %edi,(%esp)
  801ff3:	e8 68 f0 ff ff       	call   801060 <fd2data>
  801ff8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ffa:	be 00 00 00 00       	mov    $0x0,%esi
  801fff:	eb 3d                	jmp    80203e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802001:	85 f6                	test   %esi,%esi
  802003:	74 04                	je     802009 <devpipe_read+0x25>
				return i;
  802005:	89 f0                	mov    %esi,%eax
  802007:	eb 43                	jmp    80204c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802009:	89 da                	mov    %ebx,%edx
  80200b:	89 f8                	mov    %edi,%eax
  80200d:	e8 f1 fe ff ff       	call   801f03 <_pipeisclosed>
  802012:	85 c0                	test   %eax,%eax
  802014:	75 31                	jne    802047 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802016:	e8 0b ed ff ff       	call   800d26 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80201b:	8b 03                	mov    (%ebx),%eax
  80201d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802020:	74 df                	je     802001 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802022:	99                   	cltd   
  802023:	c1 ea 1b             	shr    $0x1b,%edx
  802026:	01 d0                	add    %edx,%eax
  802028:	83 e0 1f             	and    $0x1f,%eax
  80202b:	29 d0                	sub    %edx,%eax
  80202d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802035:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802038:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80203b:	83 c6 01             	add    $0x1,%esi
  80203e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802041:	75 d8                	jne    80201b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802043:	89 f0                	mov    %esi,%eax
  802045:	eb 05                	jmp    80204c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80204c:	83 c4 1c             	add    $0x1c,%esp
  80204f:	5b                   	pop    %ebx
  802050:	5e                   	pop    %esi
  802051:	5f                   	pop    %edi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    

00802054 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	56                   	push   %esi
  802058:	53                   	push   %ebx
  802059:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80205c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205f:	89 04 24             	mov    %eax,(%esp)
  802062:	e8 10 f0 ff ff       	call   801077 <fd_alloc>
  802067:	89 c2                	mov    %eax,%edx
  802069:	85 d2                	test   %edx,%edx
  80206b:	0f 88 4d 01 00 00    	js     8021be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802071:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802078:	00 
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802080:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802087:	e8 b9 ec ff ff       	call   800d45 <sys_page_alloc>
  80208c:	89 c2                	mov    %eax,%edx
  80208e:	85 d2                	test   %edx,%edx
  802090:	0f 88 28 01 00 00    	js     8021be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802096:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802099:	89 04 24             	mov    %eax,(%esp)
  80209c:	e8 d6 ef ff ff       	call   801077 <fd_alloc>
  8020a1:	89 c3                	mov    %eax,%ebx
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	0f 88 fe 00 00 00    	js     8021a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020b2:	00 
  8020b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c1:	e8 7f ec ff ff       	call   800d45 <sys_page_alloc>
  8020c6:	89 c3                	mov    %eax,%ebx
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	0f 88 d9 00 00 00    	js     8021a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	89 04 24             	mov    %eax,(%esp)
  8020d6:	e8 85 ef ff ff       	call   801060 <fd2data>
  8020db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020dd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020e4:	00 
  8020e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f0:	e8 50 ec ff ff       	call   800d45 <sys_page_alloc>
  8020f5:	89 c3                	mov    %eax,%ebx
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	0f 88 97 00 00 00    	js     802196 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802102:	89 04 24             	mov    %eax,(%esp)
  802105:	e8 56 ef ff ff       	call   801060 <fd2data>
  80210a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802111:	00 
  802112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802116:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80211d:	00 
  80211e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802122:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802129:	e8 6b ec ff ff       	call   800d99 <sys_page_map>
  80212e:	89 c3                	mov    %eax,%ebx
  802130:	85 c0                	test   %eax,%eax
  802132:	78 52                	js     802186 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802134:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802149:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80214f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802152:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802157:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	89 04 24             	mov    %eax,(%esp)
  802164:	e8 e7 ee ff ff       	call   801050 <fd2num>
  802169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80216c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80216e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802171:	89 04 24             	mov    %eax,(%esp)
  802174:	e8 d7 ee ff ff       	call   801050 <fd2num>
  802179:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80217c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	eb 38                	jmp    8021be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802186:	89 74 24 04          	mov    %esi,0x4(%esp)
  80218a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802191:	e8 56 ec ff ff       	call   800dec <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802199:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a4:	e8 43 ec ff ff       	call   800dec <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b7:	e8 30 ec ff ff       	call   800dec <sys_page_unmap>
  8021bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8021be:	83 c4 30             	add    $0x30,%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    

008021c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	89 04 24             	mov    %eax,(%esp)
  8021d8:	e8 e9 ee ff ff       	call   8010c6 <fd_lookup>
  8021dd:	89 c2                	mov    %eax,%edx
  8021df:	85 d2                	test   %edx,%edx
  8021e1:	78 15                	js     8021f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	89 04 24             	mov    %eax,(%esp)
  8021e9:	e8 72 ee ff ff       	call   801060 <fd2data>
	return _pipeisclosed(fd, p);
  8021ee:	89 c2                	mov    %eax,%edx
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	e8 0b fd ff ff       	call   801f03 <_pipeisclosed>
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    

0080220a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802210:	c7 44 24 04 fd 2c 80 	movl   $0x802cfd,0x4(%esp)
  802217:	00 
  802218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221b:	89 04 24             	mov    %eax,(%esp)
  80221e:	e8 b4 e6 ff ff       	call   8008d7 <strcpy>
	return 0;
}
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	57                   	push   %edi
  80222e:	56                   	push   %esi
  80222f:	53                   	push   %ebx
  802230:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802236:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80223b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802241:	eb 31                	jmp    802274 <devcons_write+0x4a>
		m = n - tot;
  802243:	8b 75 10             	mov    0x10(%ebp),%esi
  802246:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802248:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80224b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802250:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802253:	89 74 24 08          	mov    %esi,0x8(%esp)
  802257:	03 45 0c             	add    0xc(%ebp),%eax
  80225a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225e:	89 3c 24             	mov    %edi,(%esp)
  802261:	e8 0e e8 ff ff       	call   800a74 <memmove>
		sys_cputs(buf, m);
  802266:	89 74 24 04          	mov    %esi,0x4(%esp)
  80226a:	89 3c 24             	mov    %edi,(%esp)
  80226d:	e8 b4 e9 ff ff       	call   800c26 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802272:	01 f3                	add    %esi,%ebx
  802274:	89 d8                	mov    %ebx,%eax
  802276:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802279:	72 c8                	jb     802243 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80227b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5f                   	pop    %edi
  802284:	5d                   	pop    %ebp
  802285:	c3                   	ret    

00802286 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
  802289:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80228c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802295:	75 07                	jne    80229e <devcons_read+0x18>
  802297:	eb 2a                	jmp    8022c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802299:	e8 88 ea ff ff       	call   800d26 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80229e:	66 90                	xchg   %ax,%ax
  8022a0:	e8 9f e9 ff ff       	call   800c44 <sys_cgetc>
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	74 f0                	je     802299 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	78 16                	js     8022c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8022ad:	83 f8 04             	cmp    $0x4,%eax
  8022b0:	74 0c                	je     8022be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8022b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b5:	88 02                	mov    %al,(%edx)
	return 1;
  8022b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bc:	eb 05                	jmp    8022c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022d8:	00 
  8022d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022dc:	89 04 24             	mov    %eax,(%esp)
  8022df:	e8 42 e9 ff ff       	call   800c26 <sys_cputs>
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <getchar>:

int
getchar(void)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022f3:	00 
  8022f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802302:	e8 53 f0 ff ff       	call   80135a <read>
	if (r < 0)
  802307:	85 c0                	test   %eax,%eax
  802309:	78 0f                	js     80231a <getchar+0x34>
		return r;
	if (r < 1)
  80230b:	85 c0                	test   %eax,%eax
  80230d:	7e 06                	jle    802315 <getchar+0x2f>
		return -E_EOF;
	return c;
  80230f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802313:	eb 05                	jmp    80231a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802315:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802325:	89 44 24 04          	mov    %eax,0x4(%esp)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	89 04 24             	mov    %eax,(%esp)
  80232f:	e8 92 ed ff ff       	call   8010c6 <fd_lookup>
  802334:	85 c0                	test   %eax,%eax
  802336:	78 11                	js     802349 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802341:	39 10                	cmp    %edx,(%eax)
  802343:	0f 94 c0             	sete   %al
  802346:	0f b6 c0             	movzbl %al,%eax
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <opencons>:

int
opencons(void)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802351:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802354:	89 04 24             	mov    %eax,(%esp)
  802357:	e8 1b ed ff ff       	call   801077 <fd_alloc>
		return r;
  80235c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80235e:	85 c0                	test   %eax,%eax
  802360:	78 40                	js     8023a2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802362:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802369:	00 
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802371:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802378:	e8 c8 e9 ff ff       	call   800d45 <sys_page_alloc>
		return r;
  80237d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80237f:	85 c0                	test   %eax,%eax
  802381:	78 1f                	js     8023a2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802383:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802398:	89 04 24             	mov    %eax,(%esp)
  80239b:	e8 b0 ec ff ff       	call   801050 <fd2num>
  8023a0:	89 c2                	mov    %eax,%edx
}
  8023a2:	89 d0                	mov    %edx,%eax
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    
  8023a6:	66 90                	xchg   %ax,%ax
  8023a8:	66 90                	xchg   %ax,%ax
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	56                   	push   %esi
  8023b4:	53                   	push   %ebx
  8023b5:	83 ec 10             	sub    $0x10,%esp
  8023b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8023c1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8023c3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8023c8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023cb:	89 04 24             	mov    %eax,(%esp)
  8023ce:	e8 a8 eb ff ff       	call   800f7b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	75 26                	jne    8023fd <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8023d7:	85 f6                	test   %esi,%esi
  8023d9:	74 0a                	je     8023e5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8023db:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8023e0:	8b 40 74             	mov    0x74(%eax),%eax
  8023e3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8023e5:	85 db                	test   %ebx,%ebx
  8023e7:	74 0a                	je     8023f3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8023e9:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8023ee:	8b 40 78             	mov    0x78(%eax),%eax
  8023f1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8023f3:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8023f8:	8b 40 70             	mov    0x70(%eax),%eax
  8023fb:	eb 14                	jmp    802411 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8023fd:	85 f6                	test   %esi,%esi
  8023ff:	74 06                	je     802407 <ipc_recv+0x57>
			*from_env_store = 0;
  802401:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802407:	85 db                	test   %ebx,%ebx
  802409:	74 06                	je     802411 <ipc_recv+0x61>
			*perm_store = 0;
  80240b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802411:	83 c4 10             	add    $0x10,%esp
  802414:	5b                   	pop    %ebx
  802415:	5e                   	pop    %esi
  802416:	5d                   	pop    %ebp
  802417:	c3                   	ret    

00802418 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	57                   	push   %edi
  80241c:	56                   	push   %esi
  80241d:	53                   	push   %ebx
  80241e:	83 ec 1c             	sub    $0x1c,%esp
  802421:	8b 7d 08             	mov    0x8(%ebp),%edi
  802424:	8b 75 0c             	mov    0xc(%ebp),%esi
  802427:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80242a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80242c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802431:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802434:	8b 45 14             	mov    0x14(%ebp),%eax
  802437:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80243b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80243f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802443:	89 3c 24             	mov    %edi,(%esp)
  802446:	e8 0d eb ff ff       	call   800f58 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80244b:	85 c0                	test   %eax,%eax
  80244d:	74 28                	je     802477 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80244f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802452:	74 1c                	je     802470 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802454:	c7 44 24 08 0c 2d 80 	movl   $0x802d0c,0x8(%esp)
  80245b:	00 
  80245c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802463:	00 
  802464:	c7 04 24 30 2d 80 00 	movl   $0x802d30,(%esp)
  80246b:	e8 ef dc ff ff       	call   80015f <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802470:	e8 b1 e8 ff ff       	call   800d26 <sys_yield>
	}
  802475:	eb bd                	jmp    802434 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802477:	83 c4 1c             	add    $0x1c,%esp
  80247a:	5b                   	pop    %ebx
  80247b:	5e                   	pop    %esi
  80247c:	5f                   	pop    %edi
  80247d:	5d                   	pop    %ebp
  80247e:	c3                   	ret    

0080247f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
  802482:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802485:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80248a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80248d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802493:	8b 52 50             	mov    0x50(%edx),%edx
  802496:	39 ca                	cmp    %ecx,%edx
  802498:	75 0d                	jne    8024a7 <ipc_find_env+0x28>
			return envs[i].env_id;
  80249a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80249d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8024a2:	8b 40 40             	mov    0x40(%eax),%eax
  8024a5:	eb 0e                	jmp    8024b5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024a7:	83 c0 01             	add    $0x1,%eax
  8024aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024af:	75 d9                	jne    80248a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024b1:	66 b8 00 00          	mov    $0x0,%ax
}
  8024b5:	5d                   	pop    %ebp
  8024b6:	c3                   	ret    

008024b7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
  8024ba:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024bd:	89 d0                	mov    %edx,%eax
  8024bf:	c1 e8 16             	shr    $0x16,%eax
  8024c2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024ce:	f6 c1 01             	test   $0x1,%cl
  8024d1:	74 1d                	je     8024f0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024d3:	c1 ea 0c             	shr    $0xc,%edx
  8024d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024dd:	f6 c2 01             	test   $0x1,%dl
  8024e0:	74 0e                	je     8024f0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024e2:	c1 ea 0c             	shr    $0xc,%edx
  8024e5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024ec:	ef 
  8024ed:	0f b7 c0             	movzwl %ax,%eax
}
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    
  8024f2:	66 90                	xchg   %ax,%ax
  8024f4:	66 90                	xchg   %ax,%ax
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__udivdi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	83 ec 0c             	sub    $0xc,%esp
  802506:	8b 44 24 28          	mov    0x28(%esp),%eax
  80250a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80250e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802512:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802516:	85 c0                	test   %eax,%eax
  802518:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80251c:	89 ea                	mov    %ebp,%edx
  80251e:	89 0c 24             	mov    %ecx,(%esp)
  802521:	75 2d                	jne    802550 <__udivdi3+0x50>
  802523:	39 e9                	cmp    %ebp,%ecx
  802525:	77 61                	ja     802588 <__udivdi3+0x88>
  802527:	85 c9                	test   %ecx,%ecx
  802529:	89 ce                	mov    %ecx,%esi
  80252b:	75 0b                	jne    802538 <__udivdi3+0x38>
  80252d:	b8 01 00 00 00       	mov    $0x1,%eax
  802532:	31 d2                	xor    %edx,%edx
  802534:	f7 f1                	div    %ecx
  802536:	89 c6                	mov    %eax,%esi
  802538:	31 d2                	xor    %edx,%edx
  80253a:	89 e8                	mov    %ebp,%eax
  80253c:	f7 f6                	div    %esi
  80253e:	89 c5                	mov    %eax,%ebp
  802540:	89 f8                	mov    %edi,%eax
  802542:	f7 f6                	div    %esi
  802544:	89 ea                	mov    %ebp,%edx
  802546:	83 c4 0c             	add    $0xc,%esp
  802549:	5e                   	pop    %esi
  80254a:	5f                   	pop    %edi
  80254b:	5d                   	pop    %ebp
  80254c:	c3                   	ret    
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	39 e8                	cmp    %ebp,%eax
  802552:	77 24                	ja     802578 <__udivdi3+0x78>
  802554:	0f bd e8             	bsr    %eax,%ebp
  802557:	83 f5 1f             	xor    $0x1f,%ebp
  80255a:	75 3c                	jne    802598 <__udivdi3+0x98>
  80255c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802560:	39 34 24             	cmp    %esi,(%esp)
  802563:	0f 86 9f 00 00 00    	jbe    802608 <__udivdi3+0x108>
  802569:	39 d0                	cmp    %edx,%eax
  80256b:	0f 82 97 00 00 00    	jb     802608 <__udivdi3+0x108>
  802571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802578:	31 d2                	xor    %edx,%edx
  80257a:	31 c0                	xor    %eax,%eax
  80257c:	83 c4 0c             	add    $0xc,%esp
  80257f:	5e                   	pop    %esi
  802580:	5f                   	pop    %edi
  802581:	5d                   	pop    %ebp
  802582:	c3                   	ret    
  802583:	90                   	nop
  802584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802588:	89 f8                	mov    %edi,%eax
  80258a:	f7 f1                	div    %ecx
  80258c:	31 d2                	xor    %edx,%edx
  80258e:	83 c4 0c             	add    $0xc,%esp
  802591:	5e                   	pop    %esi
  802592:	5f                   	pop    %edi
  802593:	5d                   	pop    %ebp
  802594:	c3                   	ret    
  802595:	8d 76 00             	lea    0x0(%esi),%esi
  802598:	89 e9                	mov    %ebp,%ecx
  80259a:	8b 3c 24             	mov    (%esp),%edi
  80259d:	d3 e0                	shl    %cl,%eax
  80259f:	89 c6                	mov    %eax,%esi
  8025a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a6:	29 e8                	sub    %ebp,%eax
  8025a8:	89 c1                	mov    %eax,%ecx
  8025aa:	d3 ef                	shr    %cl,%edi
  8025ac:	89 e9                	mov    %ebp,%ecx
  8025ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025b2:	8b 3c 24             	mov    (%esp),%edi
  8025b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025b9:	89 d6                	mov    %edx,%esi
  8025bb:	d3 e7                	shl    %cl,%edi
  8025bd:	89 c1                	mov    %eax,%ecx
  8025bf:	89 3c 24             	mov    %edi,(%esp)
  8025c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025c6:	d3 ee                	shr    %cl,%esi
  8025c8:	89 e9                	mov    %ebp,%ecx
  8025ca:	d3 e2                	shl    %cl,%edx
  8025cc:	89 c1                	mov    %eax,%ecx
  8025ce:	d3 ef                	shr    %cl,%edi
  8025d0:	09 d7                	or     %edx,%edi
  8025d2:	89 f2                	mov    %esi,%edx
  8025d4:	89 f8                	mov    %edi,%eax
  8025d6:	f7 74 24 08          	divl   0x8(%esp)
  8025da:	89 d6                	mov    %edx,%esi
  8025dc:	89 c7                	mov    %eax,%edi
  8025de:	f7 24 24             	mull   (%esp)
  8025e1:	39 d6                	cmp    %edx,%esi
  8025e3:	89 14 24             	mov    %edx,(%esp)
  8025e6:	72 30                	jb     802618 <__udivdi3+0x118>
  8025e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025ec:	89 e9                	mov    %ebp,%ecx
  8025ee:	d3 e2                	shl    %cl,%edx
  8025f0:	39 c2                	cmp    %eax,%edx
  8025f2:	73 05                	jae    8025f9 <__udivdi3+0xf9>
  8025f4:	3b 34 24             	cmp    (%esp),%esi
  8025f7:	74 1f                	je     802618 <__udivdi3+0x118>
  8025f9:	89 f8                	mov    %edi,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	e9 7a ff ff ff       	jmp    80257c <__udivdi3+0x7c>
  802602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802608:	31 d2                	xor    %edx,%edx
  80260a:	b8 01 00 00 00       	mov    $0x1,%eax
  80260f:	e9 68 ff ff ff       	jmp    80257c <__udivdi3+0x7c>
  802614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802618:	8d 47 ff             	lea    -0x1(%edi),%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	83 c4 0c             	add    $0xc,%esp
  802620:	5e                   	pop    %esi
  802621:	5f                   	pop    %edi
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    
  802624:	66 90                	xchg   %ax,%ax
  802626:	66 90                	xchg   %ax,%ax
  802628:	66 90                	xchg   %ax,%ax
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__umoddi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	83 ec 14             	sub    $0x14,%esp
  802636:	8b 44 24 28          	mov    0x28(%esp),%eax
  80263a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80263e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802642:	89 c7                	mov    %eax,%edi
  802644:	89 44 24 04          	mov    %eax,0x4(%esp)
  802648:	8b 44 24 30          	mov    0x30(%esp),%eax
  80264c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802650:	89 34 24             	mov    %esi,(%esp)
  802653:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802657:	85 c0                	test   %eax,%eax
  802659:	89 c2                	mov    %eax,%edx
  80265b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80265f:	75 17                	jne    802678 <__umoddi3+0x48>
  802661:	39 fe                	cmp    %edi,%esi
  802663:	76 4b                	jbe    8026b0 <__umoddi3+0x80>
  802665:	89 c8                	mov    %ecx,%eax
  802667:	89 fa                	mov    %edi,%edx
  802669:	f7 f6                	div    %esi
  80266b:	89 d0                	mov    %edx,%eax
  80266d:	31 d2                	xor    %edx,%edx
  80266f:	83 c4 14             	add    $0x14,%esp
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
  802676:	66 90                	xchg   %ax,%ax
  802678:	39 f8                	cmp    %edi,%eax
  80267a:	77 54                	ja     8026d0 <__umoddi3+0xa0>
  80267c:	0f bd e8             	bsr    %eax,%ebp
  80267f:	83 f5 1f             	xor    $0x1f,%ebp
  802682:	75 5c                	jne    8026e0 <__umoddi3+0xb0>
  802684:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802688:	39 3c 24             	cmp    %edi,(%esp)
  80268b:	0f 87 e7 00 00 00    	ja     802778 <__umoddi3+0x148>
  802691:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802695:	29 f1                	sub    %esi,%ecx
  802697:	19 c7                	sbb    %eax,%edi
  802699:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80269d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026a9:	83 c4 14             	add    $0x14,%esp
  8026ac:	5e                   	pop    %esi
  8026ad:	5f                   	pop    %edi
  8026ae:	5d                   	pop    %ebp
  8026af:	c3                   	ret    
  8026b0:	85 f6                	test   %esi,%esi
  8026b2:	89 f5                	mov    %esi,%ebp
  8026b4:	75 0b                	jne    8026c1 <__umoddi3+0x91>
  8026b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bb:	31 d2                	xor    %edx,%edx
  8026bd:	f7 f6                	div    %esi
  8026bf:	89 c5                	mov    %eax,%ebp
  8026c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026c5:	31 d2                	xor    %edx,%edx
  8026c7:	f7 f5                	div    %ebp
  8026c9:	89 c8                	mov    %ecx,%eax
  8026cb:	f7 f5                	div    %ebp
  8026cd:	eb 9c                	jmp    80266b <__umoddi3+0x3b>
  8026cf:	90                   	nop
  8026d0:	89 c8                	mov    %ecx,%eax
  8026d2:	89 fa                	mov    %edi,%edx
  8026d4:	83 c4 14             	add    $0x14,%esp
  8026d7:	5e                   	pop    %esi
  8026d8:	5f                   	pop    %edi
  8026d9:	5d                   	pop    %ebp
  8026da:	c3                   	ret    
  8026db:	90                   	nop
  8026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e0:	8b 04 24             	mov    (%esp),%eax
  8026e3:	be 20 00 00 00       	mov    $0x20,%esi
  8026e8:	89 e9                	mov    %ebp,%ecx
  8026ea:	29 ee                	sub    %ebp,%esi
  8026ec:	d3 e2                	shl    %cl,%edx
  8026ee:	89 f1                	mov    %esi,%ecx
  8026f0:	d3 e8                	shr    %cl,%eax
  8026f2:	89 e9                	mov    %ebp,%ecx
  8026f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f8:	8b 04 24             	mov    (%esp),%eax
  8026fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8026ff:	89 fa                	mov    %edi,%edx
  802701:	d3 e0                	shl    %cl,%eax
  802703:	89 f1                	mov    %esi,%ecx
  802705:	89 44 24 08          	mov    %eax,0x8(%esp)
  802709:	8b 44 24 10          	mov    0x10(%esp),%eax
  80270d:	d3 ea                	shr    %cl,%edx
  80270f:	89 e9                	mov    %ebp,%ecx
  802711:	d3 e7                	shl    %cl,%edi
  802713:	89 f1                	mov    %esi,%ecx
  802715:	d3 e8                	shr    %cl,%eax
  802717:	89 e9                	mov    %ebp,%ecx
  802719:	09 f8                	or     %edi,%eax
  80271b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80271f:	f7 74 24 04          	divl   0x4(%esp)
  802723:	d3 e7                	shl    %cl,%edi
  802725:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802729:	89 d7                	mov    %edx,%edi
  80272b:	f7 64 24 08          	mull   0x8(%esp)
  80272f:	39 d7                	cmp    %edx,%edi
  802731:	89 c1                	mov    %eax,%ecx
  802733:	89 14 24             	mov    %edx,(%esp)
  802736:	72 2c                	jb     802764 <__umoddi3+0x134>
  802738:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80273c:	72 22                	jb     802760 <__umoddi3+0x130>
  80273e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802742:	29 c8                	sub    %ecx,%eax
  802744:	19 d7                	sbb    %edx,%edi
  802746:	89 e9                	mov    %ebp,%ecx
  802748:	89 fa                	mov    %edi,%edx
  80274a:	d3 e8                	shr    %cl,%eax
  80274c:	89 f1                	mov    %esi,%ecx
  80274e:	d3 e2                	shl    %cl,%edx
  802750:	89 e9                	mov    %ebp,%ecx
  802752:	d3 ef                	shr    %cl,%edi
  802754:	09 d0                	or     %edx,%eax
  802756:	89 fa                	mov    %edi,%edx
  802758:	83 c4 14             	add    $0x14,%esp
  80275b:	5e                   	pop    %esi
  80275c:	5f                   	pop    %edi
  80275d:	5d                   	pop    %ebp
  80275e:	c3                   	ret    
  80275f:	90                   	nop
  802760:	39 d7                	cmp    %edx,%edi
  802762:	75 da                	jne    80273e <__umoddi3+0x10e>
  802764:	8b 14 24             	mov    (%esp),%edx
  802767:	89 c1                	mov    %eax,%ecx
  802769:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80276d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802771:	eb cb                	jmp    80273e <__umoddi3+0x10e>
  802773:	90                   	nop
  802774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802778:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80277c:	0f 82 0f ff ff ff    	jb     802691 <__umoddi3+0x61>
  802782:	e9 1a ff ff ff       	jmp    8026a1 <__umoddi3+0x71>
