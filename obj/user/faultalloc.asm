
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800043:	c7 04 24 40 28 80 00 	movl   $0x802840,(%esp)
  80004a:	e8 ff 01 00 00       	call   80024e <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 c7 0c 00 00       	call   800d35 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 5c 28 80 	movl   $0x80285c,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 4a 28 80 00 	movl   $0x80284a,(%esp)
  800091:	e8 bf 00 00 00       	call   800155 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 88 28 80 	movl   $0x802888,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 b3 07 00 00       	call   800865 <snprintf>
}
  8000b2:	83 c4 24             	add    $0x24,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  8000be:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000c5:	e8 74 0f 00 00       	call   80103e <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000ca:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  8000d1:	de 
  8000d2:	c7 04 24 f9 2c 80 00 	movl   $0x802cf9,(%esp)
  8000d9:	e8 70 01 00 00       	call   80024e <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000de:	c7 44 24 04 fe bf fe 	movl   $0xcafebffe,0x4(%esp)
  8000e5:	ca 
  8000e6:	c7 04 24 f9 2c 80 00 	movl   $0x802cf9,(%esp)
  8000ed:	e8 5c 01 00 00       	call   80024e <cprintf>
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 10             	sub    $0x10,%esp
  8000fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800102:	e8 f0 0b 00 00       	call   800cf7 <sys_getenvid>
  800107:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800114:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	85 db                	test   %ebx,%ebx
  80011b:	7e 07                	jle    800124 <libmain+0x30>
		binaryname = argv[0];
  80011d:	8b 06                	mov    (%esi),%eax
  80011f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800124:	89 74 24 04          	mov    %esi,0x4(%esp)
  800128:	89 1c 24             	mov    %ebx,(%esp)
  80012b:	e8 88 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800130:	e8 07 00 00 00       	call   80013c <exit>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800142:	e8 93 11 00 00       	call   8012da <close_all>
	sys_env_destroy(0);
  800147:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014e:	e8 00 0b 00 00       	call   800c53 <sys_env_destroy>
}
  800153:	c9                   	leave  
  800154:	c3                   	ret    

00800155 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	56                   	push   %esi
  800159:	53                   	push   %ebx
  80015a:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80015d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800160:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800166:	e8 8c 0b 00 00       	call   800cf7 <sys_getenvid>
  80016b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800172:	8b 55 08             	mov    0x8(%ebp),%edx
  800175:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800179:	89 74 24 08          	mov    %esi,0x8(%esp)
  80017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800181:	c7 04 24 b4 28 80 00 	movl   $0x8028b4,(%esp)
  800188:	e8 c1 00 00 00       	call   80024e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80018d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800191:	8b 45 10             	mov    0x10(%ebp),%eax
  800194:	89 04 24             	mov    %eax,(%esp)
  800197:	e8 51 00 00 00       	call   8001ed <vcprintf>
	cprintf("\n");
  80019c:	c7 04 24 47 2d 80 00 	movl   $0x802d47,(%esp)
  8001a3:	e8 a6 00 00 00       	call   80024e <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001a8:	cc                   	int3   
  8001a9:	eb fd                	jmp    8001a8 <_panic+0x53>

008001ab <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	53                   	push   %ebx
  8001af:	83 ec 14             	sub    $0x14,%esp
  8001b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b5:	8b 13                	mov    (%ebx),%edx
  8001b7:	8d 42 01             	lea    0x1(%edx),%eax
  8001ba:	89 03                	mov    %eax,(%ebx)
  8001bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c8:	75 19                	jne    8001e3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ca:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001d1:	00 
  8001d2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 39 0a 00 00       	call   800c16 <sys_cputs>
		b->idx = 0;
  8001dd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001e3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e7:	83 c4 14             	add    $0x14,%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fd:	00 00 00 
	b.cnt = 0;
  800200:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800207:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	89 44 24 08          	mov    %eax,0x8(%esp)
  800218:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800222:	c7 04 24 ab 01 80 00 	movl   $0x8001ab,(%esp)
  800229:	e8 76 01 00 00       	call   8003a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80022e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800234:	89 44 24 04          	mov    %eax,0x4(%esp)
  800238:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023e:	89 04 24             	mov    %eax,(%esp)
  800241:	e8 d0 09 00 00       	call   800c16 <sys_cputs>

	return b.cnt;
}
  800246:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800254:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	e8 87 ff ff ff       	call   8001ed <vcprintf>
	va_end(ap);

	return cnt;
}
  800266:	c9                   	leave  
  800267:	c3                   	ret    
  800268:	66 90                	xchg   %ax,%ax
  80026a:	66 90                	xchg   %ax,%ax
  80026c:	66 90                	xchg   %ax,%ax
  80026e:	66 90                	xchg   %ax,%ax

00800270 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d7                	mov    %edx,%edi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 c3                	mov    %eax,%ebx
  800289:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80028c:	8b 45 10             	mov    0x10(%ebp),%eax
  80028f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800292:	b9 00 00 00 00       	mov    $0x0,%ecx
  800297:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80029d:	39 d9                	cmp    %ebx,%ecx
  80029f:	72 05                	jb     8002a6 <printnum+0x36>
  8002a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a4:	77 69                	ja     80030f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002ad:	83 ee 01             	sub    $0x1,%esi
  8002b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002c0:	89 c3                	mov    %eax,%ebx
  8002c2:	89 d6                	mov    %edx,%esi
  8002c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	e8 cc 22 00 00       	call   8025b0 <__udivdi3>
  8002e4:	89 d9                	mov    %ebx,%ecx
  8002e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002f5:	89 fa                	mov    %edi,%edx
  8002f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fa:	e8 71 ff ff ff       	call   800270 <printnum>
  8002ff:	eb 1b                	jmp    80031c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800301:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800305:	8b 45 18             	mov    0x18(%ebp),%eax
  800308:	89 04 24             	mov    %eax,(%esp)
  80030b:	ff d3                	call   *%ebx
  80030d:	eb 03                	jmp    800312 <printnum+0xa2>
  80030f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800312:	83 ee 01             	sub    $0x1,%esi
  800315:	85 f6                	test   %esi,%esi
  800317:	7f e8                	jg     800301 <printnum+0x91>
  800319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800320:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800324:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800327:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80032a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 9c 23 00 00       	call   8026e0 <__umoddi3>
  800344:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800348:	0f be 80 d7 28 80 00 	movsbl 0x8028d7(%eax),%eax
  80034f:	89 04 24             	mov    %eax,(%esp)
  800352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800355:	ff d0                	call   *%eax
}
  800357:	83 c4 3c             	add    $0x3c,%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800365:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800369:	8b 10                	mov    (%eax),%edx
  80036b:	3b 50 04             	cmp    0x4(%eax),%edx
  80036e:	73 0a                	jae    80037a <sprintputch+0x1b>
		*b->buf++ = ch;
  800370:	8d 4a 01             	lea    0x1(%edx),%ecx
  800373:	89 08                	mov    %ecx,(%eax)
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	88 02                	mov    %al,(%edx)
}
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    

0080037c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800382:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800385:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800389:	8b 45 10             	mov    0x10(%ebp),%eax
  80038c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800390:	8b 45 0c             	mov    0xc(%ebp),%eax
  800393:	89 44 24 04          	mov    %eax,0x4(%esp)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	89 04 24             	mov    %eax,(%esp)
  80039d:	e8 02 00 00 00       	call   8003a4 <vprintfmt>
	va_end(ap);
}
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	57                   	push   %edi
  8003a8:	56                   	push   %esi
  8003a9:	53                   	push   %ebx
  8003aa:	83 ec 3c             	sub    $0x3c,%esp
  8003ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003b0:	eb 17                	jmp    8003c9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	0f 84 4b 04 00 00    	je     800805 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8003ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003c1:	89 04 24             	mov    %eax,(%esp)
  8003c4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8003c7:	89 fb                	mov    %edi,%ebx
  8003c9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8003cc:	0f b6 03             	movzbl (%ebx),%eax
  8003cf:	83 f8 25             	cmp    $0x25,%eax
  8003d2:	75 de                	jne    8003b2 <vprintfmt+0xe>
  8003d4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8003d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003df:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8003e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f0:	eb 18                	jmp    80040a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003f4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8003f8:	eb 10                	jmp    80040a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003fc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800400:	eb 08                	jmp    80040a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800402:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800405:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80040d:	0f b6 17             	movzbl (%edi),%edx
  800410:	0f b6 c2             	movzbl %dl,%eax
  800413:	83 ea 23             	sub    $0x23,%edx
  800416:	80 fa 55             	cmp    $0x55,%dl
  800419:	0f 87 c2 03 00 00    	ja     8007e1 <vprintfmt+0x43d>
  80041f:	0f b6 d2             	movzbl %dl,%edx
  800422:	ff 24 95 20 2a 80 00 	jmp    *0x802a20(,%edx,4)
  800429:	89 df                	mov    %ebx,%edi
  80042b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800430:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800433:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800437:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80043a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80043d:	83 fa 09             	cmp    $0x9,%edx
  800440:	77 33                	ja     800475 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800442:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800445:	eb e9                	jmp    800430 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8b 30                	mov    (%eax),%esi
  80044c:	8d 40 04             	lea    0x4(%eax),%eax
  80044f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800452:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800454:	eb 1f                	jmp    800475 <vprintfmt+0xd1>
  800456:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800459:	85 ff                	test   %edi,%edi
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	0f 49 c7             	cmovns %edi,%eax
  800463:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800466:	89 df                	mov    %ebx,%edi
  800468:	eb a0                	jmp    80040a <vprintfmt+0x66>
  80046a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80046c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800473:	eb 95                	jmp    80040a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800475:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800479:	79 8f                	jns    80040a <vprintfmt+0x66>
  80047b:	eb 85                	jmp    800402 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80047d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800480:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800482:	eb 86                	jmp    80040a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8d 70 04             	lea    0x4(%eax),%esi
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	89 04 24             	mov    %eax,(%esp)
  800499:	ff 55 08             	call   *0x8(%ebp)
  80049c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80049f:	e9 25 ff ff ff       	jmp    8003c9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 70 04             	lea    0x4(%eax),%esi
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	99                   	cltd   
  8004ad:	31 d0                	xor    %edx,%eax
  8004af:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b1:	83 f8 15             	cmp    $0x15,%eax
  8004b4:	7f 0b                	jg     8004c1 <vprintfmt+0x11d>
  8004b6:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  8004bd:	85 d2                	test   %edx,%edx
  8004bf:	75 26                	jne    8004e7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8004c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004c5:	c7 44 24 08 ef 28 80 	movl   $0x8028ef,0x8(%esp)
  8004cc:	00 
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 04 24             	mov    %eax,(%esp)
  8004da:	e8 9d fe ff ff       	call   80037c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004df:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004e2:	e9 e2 fe ff ff       	jmp    8003c9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004e7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004eb:	c7 44 24 08 16 2d 80 	movl   $0x802d16,0x8(%esp)
  8004f2:	00 
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	e8 77 fe ff ff       	call   80037c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800505:	89 75 14             	mov    %esi,0x14(%ebp)
  800508:	e9 bc fe ff ff       	jmp    8003c9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800513:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800516:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80051a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80051c:	85 ff                	test   %edi,%edi
  80051e:	b8 e8 28 80 00       	mov    $0x8028e8,%eax
  800523:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800526:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80052a:	0f 84 94 00 00 00    	je     8005c4 <vprintfmt+0x220>
  800530:	85 c9                	test   %ecx,%ecx
  800532:	0f 8e 94 00 00 00    	jle    8005cc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800538:	89 74 24 04          	mov    %esi,0x4(%esp)
  80053c:	89 3c 24             	mov    %edi,(%esp)
  80053f:	e8 64 03 00 00       	call   8008a8 <strnlen>
  800544:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800547:	29 c1                	sub    %eax,%ecx
  800549:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80054c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800550:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800553:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800556:	8b 75 08             	mov    0x8(%ebp),%esi
  800559:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80055c:	89 cb                	mov    %ecx,%ebx
  80055e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800560:	eb 0f                	jmp    800571 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800562:	8b 45 0c             	mov    0xc(%ebp),%eax
  800565:	89 44 24 04          	mov    %eax,0x4(%esp)
  800569:	89 3c 24             	mov    %edi,(%esp)
  80056c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80056e:	83 eb 01             	sub    $0x1,%ebx
  800571:	85 db                	test   %ebx,%ebx
  800573:	7f ed                	jg     800562 <vprintfmt+0x1be>
  800575:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800578:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80057b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80057e:	85 c9                	test   %ecx,%ecx
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	0f 49 c1             	cmovns %ecx,%eax
  800588:	29 c1                	sub    %eax,%ecx
  80058a:	89 cb                	mov    %ecx,%ebx
  80058c:	eb 44                	jmp    8005d2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80058e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800592:	74 1e                	je     8005b2 <vprintfmt+0x20e>
  800594:	0f be d2             	movsbl %dl,%edx
  800597:	83 ea 20             	sub    $0x20,%edx
  80059a:	83 fa 5e             	cmp    $0x5e,%edx
  80059d:	76 13                	jbe    8005b2 <vprintfmt+0x20e>
					putch('?', putdat);
  80059f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005ad:	ff 55 08             	call   *0x8(%ebp)
  8005b0:	eb 0d                	jmp    8005bf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8005b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005b9:	89 04 24             	mov    %eax,(%esp)
  8005bc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005bf:	83 eb 01             	sub    $0x1,%ebx
  8005c2:	eb 0e                	jmp    8005d2 <vprintfmt+0x22e>
  8005c4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ca:	eb 06                	jmp    8005d2 <vprintfmt+0x22e>
  8005cc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005cf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005d2:	83 c7 01             	add    $0x1,%edi
  8005d5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005d9:	0f be c2             	movsbl %dl,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	74 27                	je     800607 <vprintfmt+0x263>
  8005e0:	85 f6                	test   %esi,%esi
  8005e2:	78 aa                	js     80058e <vprintfmt+0x1ea>
  8005e4:	83 ee 01             	sub    $0x1,%esi
  8005e7:	79 a5                	jns    80058e <vprintfmt+0x1ea>
  8005e9:	89 d8                	mov    %ebx,%eax
  8005eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005f1:	89 c3                	mov    %eax,%ebx
  8005f3:	eb 18                	jmp    80060d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800600:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800602:	83 eb 01             	sub    $0x1,%ebx
  800605:	eb 06                	jmp    80060d <vprintfmt+0x269>
  800607:	8b 75 08             	mov    0x8(%ebp),%esi
  80060a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80060d:	85 db                	test   %ebx,%ebx
  80060f:	7f e4                	jg     8005f5 <vprintfmt+0x251>
  800611:	89 75 08             	mov    %esi,0x8(%ebp)
  800614:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800617:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061a:	e9 aa fd ff ff       	jmp    8003c9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80061f:	83 f9 01             	cmp    $0x1,%ecx
  800622:	7e 10                	jle    800634 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8b 30                	mov    (%eax),%esi
  800629:	8b 78 04             	mov    0x4(%eax),%edi
  80062c:	8d 40 08             	lea    0x8(%eax),%eax
  80062f:	89 45 14             	mov    %eax,0x14(%ebp)
  800632:	eb 26                	jmp    80065a <vprintfmt+0x2b6>
	else if (lflag)
  800634:	85 c9                	test   %ecx,%ecx
  800636:	74 12                	je     80064a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 30                	mov    (%eax),%esi
  80063d:	89 f7                	mov    %esi,%edi
  80063f:	c1 ff 1f             	sar    $0x1f,%edi
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
  800648:	eb 10                	jmp    80065a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 30                	mov    (%eax),%esi
  80064f:	89 f7                	mov    %esi,%edi
  800651:	c1 ff 1f             	sar    $0x1f,%edi
  800654:	8d 40 04             	lea    0x4(%eax),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80065a:	89 f0                	mov    %esi,%eax
  80065c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80065e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800663:	85 ff                	test   %edi,%edi
  800665:	0f 89 3a 01 00 00    	jns    8007a5 <vprintfmt+0x401>
				putch('-', putdat);
  80066b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800672:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800679:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80067c:	89 f0                	mov    %esi,%eax
  80067e:	89 fa                	mov    %edi,%edx
  800680:	f7 d8                	neg    %eax
  800682:	83 d2 00             	adc    $0x0,%edx
  800685:	f7 da                	neg    %edx
			}
			base = 10;
  800687:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80068c:	e9 14 01 00 00       	jmp    8007a5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800691:	83 f9 01             	cmp    $0x1,%ecx
  800694:	7e 13                	jle    8006a9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 50 04             	mov    0x4(%eax),%edx
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	8b 75 14             	mov    0x14(%ebp),%esi
  8006a1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006a4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006a7:	eb 2c                	jmp    8006d5 <vprintfmt+0x331>
	else if (lflag)
  8006a9:	85 c9                	test   %ecx,%ecx
  8006ab:	74 15                	je     8006c2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ba:	8d 76 04             	lea    0x4(%esi),%esi
  8006bd:	89 75 14             	mov    %esi,0x14(%ebp)
  8006c0:	eb 13                	jmp    8006d5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	8b 75 14             	mov    0x14(%ebp),%esi
  8006cf:	8d 76 04             	lea    0x4(%esi),%esi
  8006d2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8006d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006da:	e9 c6 00 00 00       	jmp    8007a5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006df:	83 f9 01             	cmp    $0x1,%ecx
  8006e2:	7e 13                	jle    8006f7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ef:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006f2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006f5:	eb 24                	jmp    80071b <vprintfmt+0x377>
	else if (lflag)
  8006f7:	85 c9                	test   %ecx,%ecx
  8006f9:	74 11                	je     80070c <vprintfmt+0x368>
		return va_arg(*ap, long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	99                   	cltd   
  800701:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800704:	8d 71 04             	lea    0x4(%ecx),%esi
  800707:	89 75 14             	mov    %esi,0x14(%ebp)
  80070a:	eb 0f                	jmp    80071b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	99                   	cltd   
  800712:	8b 75 14             	mov    0x14(%ebp),%esi
  800715:	8d 76 04             	lea    0x4(%esi),%esi
  800718:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80071b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800720:	e9 80 00 00 00       	jmp    8007a5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800725:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800736:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800740:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800747:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80074a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80074e:	8b 06                	mov    (%esi),%eax
  800750:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800755:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80075a:	eb 49                	jmp    8007a5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80075c:	83 f9 01             	cmp    $0x1,%ecx
  80075f:	7e 13                	jle    800774 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	8b 75 14             	mov    0x14(%ebp),%esi
  80076c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80076f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800772:	eb 2c                	jmp    8007a0 <vprintfmt+0x3fc>
	else if (lflag)
  800774:	85 c9                	test   %ecx,%ecx
  800776:	74 15                	je     80078d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	ba 00 00 00 00       	mov    $0x0,%edx
  800782:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800785:	8d 71 04             	lea    0x4(%ecx),%esi
  800788:	89 75 14             	mov    %esi,0x14(%ebp)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
  800797:	8b 75 14             	mov    0x14(%ebp),%esi
  80079a:	8d 76 04             	lea    0x4(%esi),%esi
  80079d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8007a0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8007a9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ad:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007b4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007b8:	89 04 24             	mov    %eax,(%esp)
  8007bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	e8 a6 fa ff ff       	call   800270 <printnum>
			break;
  8007ca:	e9 fa fb ff ff       	jmp    8003c9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007d6:	89 04 24             	mov    %eax,(%esp)
  8007d9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007dc:	e9 e8 fb ff ff       	jmp    8003c9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007ef:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f2:	89 fb                	mov    %edi,%ebx
  8007f4:	eb 03                	jmp    8007f9 <vprintfmt+0x455>
  8007f6:	83 eb 01             	sub    $0x1,%ebx
  8007f9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007fd:	75 f7                	jne    8007f6 <vprintfmt+0x452>
  8007ff:	90                   	nop
  800800:	e9 c4 fb ff ff       	jmp    8003c9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800805:	83 c4 3c             	add    $0x3c,%esp
  800808:	5b                   	pop    %ebx
  800809:	5e                   	pop    %esi
  80080a:	5f                   	pop    %edi
  80080b:	5d                   	pop    %ebp
  80080c:	c3                   	ret    

0080080d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800819:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80081c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800820:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800823:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082a:	85 c0                	test   %eax,%eax
  80082c:	74 30                	je     80085e <vsnprintf+0x51>
  80082e:	85 d2                	test   %edx,%edx
  800830:	7e 2c                	jle    80085e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800839:	8b 45 10             	mov    0x10(%ebp),%eax
  80083c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800840:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800843:	89 44 24 04          	mov    %eax,0x4(%esp)
  800847:	c7 04 24 5f 03 80 00 	movl   $0x80035f,(%esp)
  80084e:	e8 51 fb ff ff       	call   8003a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800856:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085c:	eb 05                	jmp    800863 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80085e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800863:	c9                   	leave  
  800864:	c3                   	ret    

00800865 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80086e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	89 44 24 08          	mov    %eax,0x8(%esp)
  800879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 04 24             	mov    %eax,(%esp)
  800886:	e8 82 ff ff ff       	call   80080d <vsnprintf>
	va_end(ap);

	return rc;
}
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    
  80088d:	66 90                	xchg   %ax,%ax
  80088f:	90                   	nop

00800890 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	eb 03                	jmp    8008a0 <strlen+0x10>
		n++;
  80089d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a4:	75 f7                	jne    80089d <strlen+0xd>
		n++;
	return n;
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b6:	eb 03                	jmp    8008bb <strnlen+0x13>
		n++;
  8008b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008bb:	39 d0                	cmp    %edx,%eax
  8008bd:	74 06                	je     8008c5 <strnlen+0x1d>
  8008bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008c3:	75 f3                	jne    8008b8 <strnlen+0x10>
		n++;
	return n;
}
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008d1:	89 c2                	mov    %eax,%edx
  8008d3:	83 c2 01             	add    $0x1,%edx
  8008d6:	83 c1 01             	add    $0x1,%ecx
  8008d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e0:	84 db                	test   %bl,%bl
  8008e2:	75 ef                	jne    8008d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008e4:	5b                   	pop    %ebx
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f1:	89 1c 24             	mov    %ebx,(%esp)
  8008f4:	e8 97 ff ff ff       	call   800890 <strlen>
	strcpy(dst + len, src);
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800900:	01 d8                	add    %ebx,%eax
  800902:	89 04 24             	mov    %eax,(%esp)
  800905:	e8 bd ff ff ff       	call   8008c7 <strcpy>
	return dst;
}
  80090a:	89 d8                	mov    %ebx,%eax
  80090c:	83 c4 08             	add    $0x8,%esp
  80090f:	5b                   	pop    %ebx
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091d:	89 f3                	mov    %esi,%ebx
  80091f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800922:	89 f2                	mov    %esi,%edx
  800924:	eb 0f                	jmp    800935 <strncpy+0x23>
		*dst++ = *src;
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	0f b6 01             	movzbl (%ecx),%eax
  80092c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80092f:	80 39 01             	cmpb   $0x1,(%ecx)
  800932:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800935:	39 da                	cmp    %ebx,%edx
  800937:	75 ed                	jne    800926 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800939:	89 f0                	mov    %esi,%eax
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
  800944:	8b 75 08             	mov    0x8(%ebp),%esi
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80094d:	89 f0                	mov    %esi,%eax
  80094f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800953:	85 c9                	test   %ecx,%ecx
  800955:	75 0b                	jne    800962 <strlcpy+0x23>
  800957:	eb 1d                	jmp    800976 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800959:	83 c0 01             	add    $0x1,%eax
  80095c:	83 c2 01             	add    $0x1,%edx
  80095f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800962:	39 d8                	cmp    %ebx,%eax
  800964:	74 0b                	je     800971 <strlcpy+0x32>
  800966:	0f b6 0a             	movzbl (%edx),%ecx
  800969:	84 c9                	test   %cl,%cl
  80096b:	75 ec                	jne    800959 <strlcpy+0x1a>
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	eb 02                	jmp    800973 <strlcpy+0x34>
  800971:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800973:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800976:	29 f0                	sub    %esi,%eax
}
  800978:	5b                   	pop    %ebx
  800979:	5e                   	pop    %esi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800985:	eb 06                	jmp    80098d <strcmp+0x11>
		p++, q++;
  800987:	83 c1 01             	add    $0x1,%ecx
  80098a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80098d:	0f b6 01             	movzbl (%ecx),%eax
  800990:	84 c0                	test   %al,%al
  800992:	74 04                	je     800998 <strcmp+0x1c>
  800994:	3a 02                	cmp    (%edx),%al
  800996:	74 ef                	je     800987 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 c0             	movzbl %al,%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	89 c3                	mov    %eax,%ebx
  8009ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b1:	eb 06                	jmp    8009b9 <strncmp+0x17>
		n--, p++, q++;
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009b9:	39 d8                	cmp    %ebx,%eax
  8009bb:	74 15                	je     8009d2 <strncmp+0x30>
  8009bd:	0f b6 08             	movzbl (%eax),%ecx
  8009c0:	84 c9                	test   %cl,%cl
  8009c2:	74 04                	je     8009c8 <strncmp+0x26>
  8009c4:	3a 0a                	cmp    (%edx),%cl
  8009c6:	74 eb                	je     8009b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c8:	0f b6 00             	movzbl (%eax),%eax
  8009cb:	0f b6 12             	movzbl (%edx),%edx
  8009ce:	29 d0                	sub    %edx,%eax
  8009d0:	eb 05                	jmp    8009d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	eb 07                	jmp    8009ed <strchr+0x13>
		if (*s == c)
  8009e6:	38 ca                	cmp    %cl,%dl
  8009e8:	74 0f                	je     8009f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ea:	83 c0 01             	add    $0x1,%eax
  8009ed:	0f b6 10             	movzbl (%eax),%edx
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	75 f2                	jne    8009e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a05:	eb 07                	jmp    800a0e <strfind+0x13>
		if (*s == c)
  800a07:	38 ca                	cmp    %cl,%dl
  800a09:	74 0a                	je     800a15 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a0b:	83 c0 01             	add    $0x1,%eax
  800a0e:	0f b6 10             	movzbl (%eax),%edx
  800a11:	84 d2                	test   %dl,%dl
  800a13:	75 f2                	jne    800a07 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	57                   	push   %edi
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a23:	85 c9                	test   %ecx,%ecx
  800a25:	74 36                	je     800a5d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a27:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a2d:	75 28                	jne    800a57 <memset+0x40>
  800a2f:	f6 c1 03             	test   $0x3,%cl
  800a32:	75 23                	jne    800a57 <memset+0x40>
		c &= 0xFF;
  800a34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a38:	89 d3                	mov    %edx,%ebx
  800a3a:	c1 e3 08             	shl    $0x8,%ebx
  800a3d:	89 d6                	mov    %edx,%esi
  800a3f:	c1 e6 18             	shl    $0x18,%esi
  800a42:	89 d0                	mov    %edx,%eax
  800a44:	c1 e0 10             	shl    $0x10,%eax
  800a47:	09 f0                	or     %esi,%eax
  800a49:	09 c2                	or     %eax,%edx
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a4f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a52:	fc                   	cld    
  800a53:	f3 ab                	rep stos %eax,%es:(%edi)
  800a55:	eb 06                	jmp    800a5d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	5b                   	pop    %ebx
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a72:	39 c6                	cmp    %eax,%esi
  800a74:	73 35                	jae    800aab <memmove+0x47>
  800a76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a79:	39 d0                	cmp    %edx,%eax
  800a7b:	73 2e                	jae    800aab <memmove+0x47>
		s += n;
		d += n;
  800a7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a80:	89 d6                	mov    %edx,%esi
  800a82:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8a:	75 13                	jne    800a9f <memmove+0x3b>
  800a8c:	f6 c1 03             	test   $0x3,%cl
  800a8f:	75 0e                	jne    800a9f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a91:	83 ef 04             	sub    $0x4,%edi
  800a94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a9a:	fd                   	std    
  800a9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9d:	eb 09                	jmp    800aa8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9f:	83 ef 01             	sub    $0x1,%edi
  800aa2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800aa5:	fd                   	std    
  800aa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa8:	fc                   	cld    
  800aa9:	eb 1d                	jmp    800ac8 <memmove+0x64>
  800aab:	89 f2                	mov    %esi,%edx
  800aad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaf:	f6 c2 03             	test   $0x3,%dl
  800ab2:	75 0f                	jne    800ac3 <memmove+0x5f>
  800ab4:	f6 c1 03             	test   $0x3,%cl
  800ab7:	75 0a                	jne    800ac3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800abc:	89 c7                	mov    %eax,%edi
  800abe:	fc                   	cld    
  800abf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac1:	eb 05                	jmp    800ac8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac8:	5e                   	pop    %esi
  800ac9:	5f                   	pop    %edi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	89 04 24             	mov    %eax,(%esp)
  800ae6:	e8 79 ff ff ff       	call   800a64 <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af8:	89 d6                	mov    %edx,%esi
  800afa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afd:	eb 1a                	jmp    800b19 <memcmp+0x2c>
		if (*s1 != *s2)
  800aff:	0f b6 02             	movzbl (%edx),%eax
  800b02:	0f b6 19             	movzbl (%ecx),%ebx
  800b05:	38 d8                	cmp    %bl,%al
  800b07:	74 0a                	je     800b13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b09:	0f b6 c0             	movzbl %al,%eax
  800b0c:	0f b6 db             	movzbl %bl,%ebx
  800b0f:	29 d8                	sub    %ebx,%eax
  800b11:	eb 0f                	jmp    800b22 <memcmp+0x35>
		s1++, s2++;
  800b13:	83 c2 01             	add    $0x1,%edx
  800b16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b19:	39 f2                	cmp    %esi,%edx
  800b1b:	75 e2                	jne    800aff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	eb 07                	jmp    800b3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b36:	38 08                	cmp    %cl,(%eax)
  800b38:	74 07                	je     800b41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	39 d0                	cmp    %edx,%eax
  800b3f:	72 f5                	jb     800b36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4f:	eb 03                	jmp    800b54 <strtol+0x11>
		s++;
  800b51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b54:	0f b6 0a             	movzbl (%edx),%ecx
  800b57:	80 f9 09             	cmp    $0x9,%cl
  800b5a:	74 f5                	je     800b51 <strtol+0xe>
  800b5c:	80 f9 20             	cmp    $0x20,%cl
  800b5f:	74 f0                	je     800b51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b61:	80 f9 2b             	cmp    $0x2b,%cl
  800b64:	75 0a                	jne    800b70 <strtol+0x2d>
		s++;
  800b66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b69:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6e:	eb 11                	jmp    800b81 <strtol+0x3e>
  800b70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b75:	80 f9 2d             	cmp    $0x2d,%cl
  800b78:	75 07                	jne    800b81 <strtol+0x3e>
		s++, neg = 1;
  800b7a:	8d 52 01             	lea    0x1(%edx),%edx
  800b7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b86:	75 15                	jne    800b9d <strtol+0x5a>
  800b88:	80 3a 30             	cmpb   $0x30,(%edx)
  800b8b:	75 10                	jne    800b9d <strtol+0x5a>
  800b8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b91:	75 0a                	jne    800b9d <strtol+0x5a>
		s += 2, base = 16;
  800b93:	83 c2 02             	add    $0x2,%edx
  800b96:	b8 10 00 00 00       	mov    $0x10,%eax
  800b9b:	eb 10                	jmp    800bad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b9d:	85 c0                	test   %eax,%eax
  800b9f:	75 0c                	jne    800bad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ba3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ba6:	75 05                	jne    800bad <strtol+0x6a>
		s++, base = 8;
  800ba8:	83 c2 01             	add    $0x1,%edx
  800bab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bb5:	0f b6 0a             	movzbl (%edx),%ecx
  800bb8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bbb:	89 f0                	mov    %esi,%eax
  800bbd:	3c 09                	cmp    $0x9,%al
  800bbf:	77 08                	ja     800bc9 <strtol+0x86>
			dig = *s - '0';
  800bc1:	0f be c9             	movsbl %cl,%ecx
  800bc4:	83 e9 30             	sub    $0x30,%ecx
  800bc7:	eb 20                	jmp    800be9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bc9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bcc:	89 f0                	mov    %esi,%eax
  800bce:	3c 19                	cmp    $0x19,%al
  800bd0:	77 08                	ja     800bda <strtol+0x97>
			dig = *s - 'a' + 10;
  800bd2:	0f be c9             	movsbl %cl,%ecx
  800bd5:	83 e9 57             	sub    $0x57,%ecx
  800bd8:	eb 0f                	jmp    800be9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bda:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bdd:	89 f0                	mov    %esi,%eax
  800bdf:	3c 19                	cmp    $0x19,%al
  800be1:	77 16                	ja     800bf9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800be3:	0f be c9             	movsbl %cl,%ecx
  800be6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800be9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bec:	7d 0f                	jge    800bfd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bf5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bf7:	eb bc                	jmp    800bb5 <strtol+0x72>
  800bf9:	89 d8                	mov    %ebx,%eax
  800bfb:	eb 02                	jmp    800bff <strtol+0xbc>
  800bfd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c03:	74 05                	je     800c0a <strtol+0xc7>
		*endptr = (char *) s;
  800c05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c0a:	f7 d8                	neg    %eax
  800c0c:	85 ff                	test   %edi,%edi
  800c0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	89 c3                	mov    %eax,%ebx
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	89 c6                	mov    %eax,%esi
  800c2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c44:	89 d1                	mov    %edx,%ecx
  800c46:	89 d3                	mov    %edx,%ebx
  800c48:	89 d7                	mov    %edx,%edi
  800c4a:	89 d6                	mov    %edx,%esi
  800c4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c61:	b8 03 00 00 00       	mov    $0x3,%eax
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	89 cb                	mov    %ecx,%ebx
  800c6b:	89 cf                	mov    %ecx,%edi
  800c6d:	89 ce                	mov    %ecx,%esi
  800c6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c71:	85 c0                	test   %eax,%eax
  800c73:	7e 28                	jle    800c9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c80:	00 
  800c81:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800c88:	00 
  800c89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c90:	00 
  800c91:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800c98:	e8 b8 f4 ff ff       	call   800155 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c9d:	83 c4 2c             	add    $0x2c,%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cae:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb3:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	89 cb                	mov    %ecx,%ebx
  800cbd:	89 cf                	mov    %ecx,%edi
  800cbf:	89 ce                	mov    %ecx,%esi
  800cc1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	7e 28                	jle    800cef <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cd2:	00 
  800cd3:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800cda:	00 
  800cdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce2:	00 
  800ce3:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800cea:	e8 66 f4 ff ff       	call   800155 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800cef:	83 c4 2c             	add    $0x2c,%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	b8 02 00 00 00       	mov    $0x2,%eax
  800d07:	89 d1                	mov    %edx,%ecx
  800d09:	89 d3                	mov    %edx,%ebx
  800d0b:	89 d7                	mov    %edx,%edi
  800d0d:	89 d6                	mov    %edx,%esi
  800d0f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <sys_yield>:

void
sys_yield(void)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d26:	89 d1                	mov    %edx,%ecx
  800d28:	89 d3                	mov    %edx,%ebx
  800d2a:	89 d7                	mov    %edx,%edi
  800d2c:	89 d6                	mov    %edx,%esi
  800d2e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3e:	be 00 00 00 00       	mov    $0x0,%esi
  800d43:	b8 05 00 00 00       	mov    $0x5,%eax
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d51:	89 f7                	mov    %esi,%edi
  800d53:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7e 28                	jle    800d81 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d64:	00 
  800d65:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800d6c:	00 
  800d6d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d74:	00 
  800d75:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800d7c:	e8 d4 f3 ff ff       	call   800155 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d81:	83 c4 2c             	add    $0x2c,%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d92:	b8 06 00 00 00       	mov    $0x6,%eax
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da3:	8b 75 18             	mov    0x18(%ebp),%esi
  800da6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da8:	85 c0                	test   %eax,%eax
  800daa:	7e 28                	jle    800dd4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dac:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800db7:	00 
  800db8:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800dbf:	00 
  800dc0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc7:	00 
  800dc8:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800dcf:	e8 81 f3 ff ff       	call   800155 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd4:	83 c4 2c             	add    $0x2c,%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dea:	b8 07 00 00 00       	mov    $0x7,%eax
  800def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	89 df                	mov    %ebx,%edi
  800df7:	89 de                	mov    %ebx,%esi
  800df9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	7e 28                	jle    800e27 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dff:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e03:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e0a:	00 
  800e0b:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800e12:	00 
  800e13:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1a:	00 
  800e1b:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800e22:	e8 2e f3 ff ff       	call   800155 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e27:	83 c4 2c             	add    $0x2c,%esp
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	89 cb                	mov    %ecx,%ebx
  800e44:	89 cf                	mov    %ecx,%edi
  800e46:	89 ce                	mov    %ecx,%esi
  800e48:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	89 de                	mov    %ebx,%esi
  800e6c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7e 28                	jle    800e9a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e76:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e7d:	00 
  800e7e:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800e85:	00 
  800e86:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8d:	00 
  800e8e:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800e95:	e8 bb f2 ff ff       	call   800155 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e9a:	83 c4 2c             	add    $0x2c,%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebb:	89 df                	mov    %ebx,%edi
  800ebd:	89 de                	mov    %ebx,%esi
  800ebf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	7e 28                	jle    800eed <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ed0:	00 
  800ed1:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800ed8:	00 
  800ed9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee0:	00 
  800ee1:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800ee8:	e8 68 f2 ff ff       	call   800155 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eed:	83 c4 2c             	add    $0x2c,%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	57                   	push   %edi
  800ef9:	56                   	push   %esi
  800efa:	53                   	push   %ebx
  800efb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f03:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	89 df                	mov    %ebx,%edi
  800f10:	89 de                	mov    %ebx,%esi
  800f12:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f14:	85 c0                	test   %eax,%eax
  800f16:	7e 28                	jle    800f40 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f18:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f23:	00 
  800f24:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800f2b:	00 
  800f2c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f33:	00 
  800f34:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800f3b:	e8 15 f2 ff ff       	call   800155 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f40:	83 c4 2c             	add    $0x2c,%esp
  800f43:	5b                   	pop    %ebx
  800f44:	5e                   	pop    %esi
  800f45:	5f                   	pop    %edi
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    

00800f48 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	57                   	push   %edi
  800f4c:	56                   	push   %esi
  800f4d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4e:	be 00 00 00 00       	mov    $0x0,%esi
  800f53:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f61:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f64:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f79:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	89 cb                	mov    %ecx,%ebx
  800f83:	89 cf                	mov    %ecx,%edi
  800f85:	89 ce                	mov    %ecx,%esi
  800f87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	7e 28                	jle    800fb5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f91:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f98:	00 
  800f99:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800fa0:	00 
  800fa1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa8:	00 
  800fa9:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800fb0:	e8 a0 f1 ff ff       	call   800155 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb5:	83 c4 2c             	add    $0x2c,%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fcd:	89 d1                	mov    %edx,%ecx
  800fcf:	89 d3                	mov    %edx,%ebx
  800fd1:	89 d7                	mov    %edx,%edi
  800fd3:	89 d6                	mov    %edx,%esi
  800fd5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff2:	89 df                	mov    %ebx,%edi
  800ff4:	89 de                	mov    %ebx,%esi
  800ff6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801003:	bb 00 00 00 00       	mov    $0x0,%ebx
  801008:	b8 12 00 00 00       	mov    $0x12,%eax
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	8b 55 08             	mov    0x8(%ebp),%edx
  801013:	89 df                	mov    %ebx,%edi
  801015:	89 de                	mov    %ebx,%esi
  801017:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801024:	b9 00 00 00 00       	mov    $0x0,%ecx
  801029:	b8 13 00 00 00       	mov    $0x13,%eax
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	89 cb                	mov    %ecx,%ebx
  801033:	89 cf                	mov    %ecx,%edi
  801035:	89 ce                	mov    %ecx,%esi
  801037:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  801044:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  80104b:	75 7a                	jne    8010c7 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80104d:	e8 a5 fc ff ff       	call   800cf7 <sys_getenvid>
  801052:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801059:	00 
  80105a:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801061:	ee 
  801062:	89 04 24             	mov    %eax,(%esp)
  801065:	e8 cb fc ff ff       	call   800d35 <sys_page_alloc>
  80106a:	85 c0                	test   %eax,%eax
  80106c:	79 20                	jns    80108e <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  80106e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801072:	c7 44 24 08 22 2c 80 	movl   $0x802c22,0x8(%esp)
  801079:	00 
  80107a:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  801081:	00 
  801082:	c7 04 24 35 2c 80 00 	movl   $0x802c35,(%esp)
  801089:	e8 c7 f0 ff ff       	call   800155 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  80108e:	e8 64 fc ff ff       	call   800cf7 <sys_getenvid>
  801093:	c7 44 24 04 d1 10 80 	movl   $0x8010d1,0x4(%esp)
  80109a:	00 
  80109b:	89 04 24             	mov    %eax,(%esp)
  80109e:	e8 52 fe ff ff       	call   800ef5 <sys_env_set_pgfault_upcall>
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	79 20                	jns    8010c7 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  8010a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010ab:	c7 44 24 08 44 2c 80 	movl   $0x802c44,0x8(%esp)
  8010b2:	00 
  8010b3:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8010ba:	00 
  8010bb:	c7 04 24 35 2c 80 00 	movl   $0x802c35,(%esp)
  8010c2:	e8 8e f0 ff ff       	call   800155 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010d1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010d2:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8010d7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010d9:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  8010dc:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  8010e0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8010e4:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  8010e7:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  8010eb:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  8010ed:	83 c4 08             	add    $0x8,%esp
	popal
  8010f0:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  8010f1:	83 c4 04             	add    $0x4,%esp
	popfl
  8010f4:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8010f5:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8010f6:	c3                   	ret    
  8010f7:	66 90                	xchg   %ax,%ax
  8010f9:	66 90                	xchg   %ax,%ax
  8010fb:	66 90                	xchg   %ax,%ax
  8010fd:	66 90                	xchg   %ax,%ax
  8010ff:	90                   	nop

00801100 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	05 00 00 00 30       	add    $0x30000000,%eax
  80110b:	c1 e8 0c             	shr    $0xc,%eax
}
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80111b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801120:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80112d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801132:	89 c2                	mov    %eax,%edx
  801134:	c1 ea 16             	shr    $0x16,%edx
  801137:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80113e:	f6 c2 01             	test   $0x1,%dl
  801141:	74 11                	je     801154 <fd_alloc+0x2d>
  801143:	89 c2                	mov    %eax,%edx
  801145:	c1 ea 0c             	shr    $0xc,%edx
  801148:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80114f:	f6 c2 01             	test   $0x1,%dl
  801152:	75 09                	jne    80115d <fd_alloc+0x36>
			*fd_store = fd;
  801154:	89 01                	mov    %eax,(%ecx)
			return 0;
  801156:	b8 00 00 00 00       	mov    $0x0,%eax
  80115b:	eb 17                	jmp    801174 <fd_alloc+0x4d>
  80115d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801162:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801167:	75 c9                	jne    801132 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801169:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80116f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80117c:	83 f8 1f             	cmp    $0x1f,%eax
  80117f:	77 36                	ja     8011b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801181:	c1 e0 0c             	shl    $0xc,%eax
  801184:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801189:	89 c2                	mov    %eax,%edx
  80118b:	c1 ea 16             	shr    $0x16,%edx
  80118e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801195:	f6 c2 01             	test   $0x1,%dl
  801198:	74 24                	je     8011be <fd_lookup+0x48>
  80119a:	89 c2                	mov    %eax,%edx
  80119c:	c1 ea 0c             	shr    $0xc,%edx
  80119f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a6:	f6 c2 01             	test   $0x1,%dl
  8011a9:	74 1a                	je     8011c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8011b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b5:	eb 13                	jmp    8011ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011bc:	eb 0c                	jmp    8011ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c3:	eb 05                	jmp    8011ca <fd_lookup+0x54>
  8011c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	83 ec 18             	sub    $0x18,%esp
  8011d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011da:	eb 13                	jmp    8011ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8011dc:	39 08                	cmp    %ecx,(%eax)
  8011de:	75 0c                	jne    8011ec <dev_lookup+0x20>
			*dev = devtab[i];
  8011e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ea:	eb 38                	jmp    801224 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011ec:	83 c2 01             	add    $0x1,%edx
  8011ef:	8b 04 95 e4 2c 80 00 	mov    0x802ce4(,%edx,4),%eax
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	75 e2                	jne    8011dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8011ff:	8b 40 48             	mov    0x48(%eax),%eax
  801202:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80120a:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  801211:	e8 38 f0 ff ff       	call   80024e <cprintf>
	*dev = 0;
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80121f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801224:	c9                   	leave  
  801225:	c3                   	ret    

00801226 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	56                   	push   %esi
  80122a:	53                   	push   %ebx
  80122b:	83 ec 20             	sub    $0x20,%esp
  80122e:	8b 75 08             	mov    0x8(%ebp),%esi
  801231:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801237:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80123b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801241:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801244:	89 04 24             	mov    %eax,(%esp)
  801247:	e8 2a ff ff ff       	call   801176 <fd_lookup>
  80124c:	85 c0                	test   %eax,%eax
  80124e:	78 05                	js     801255 <fd_close+0x2f>
	    || fd != fd2)
  801250:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801253:	74 0c                	je     801261 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801255:	84 db                	test   %bl,%bl
  801257:	ba 00 00 00 00       	mov    $0x0,%edx
  80125c:	0f 44 c2             	cmove  %edx,%eax
  80125f:	eb 3f                	jmp    8012a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801261:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801264:	89 44 24 04          	mov    %eax,0x4(%esp)
  801268:	8b 06                	mov    (%esi),%eax
  80126a:	89 04 24             	mov    %eax,(%esp)
  80126d:	e8 5a ff ff ff       	call   8011cc <dev_lookup>
  801272:	89 c3                	mov    %eax,%ebx
  801274:	85 c0                	test   %eax,%eax
  801276:	78 16                	js     80128e <fd_close+0x68>
		if (dev->dev_close)
  801278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80127e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801283:	85 c0                	test   %eax,%eax
  801285:	74 07                	je     80128e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801287:	89 34 24             	mov    %esi,(%esp)
  80128a:	ff d0                	call   *%eax
  80128c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80128e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801292:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801299:	e8 3e fb ff ff       	call   800ddc <sys_page_unmap>
	return r;
  80129e:	89 d8                	mov    %ebx,%eax
}
  8012a0:	83 c4 20             	add    $0x20,%esp
  8012a3:	5b                   	pop    %ebx
  8012a4:	5e                   	pop    %esi
  8012a5:	5d                   	pop    %ebp
  8012a6:	c3                   	ret    

008012a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	89 04 24             	mov    %eax,(%esp)
  8012ba:	e8 b7 fe ff ff       	call   801176 <fd_lookup>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	85 d2                	test   %edx,%edx
  8012c3:	78 13                	js     8012d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012cc:	00 
  8012cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d0:	89 04 24             	mov    %eax,(%esp)
  8012d3:	e8 4e ff ff ff       	call   801226 <fd_close>
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <close_all>:

void
close_all(void)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012e6:	89 1c 24             	mov    %ebx,(%esp)
  8012e9:	e8 b9 ff ff ff       	call   8012a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ee:	83 c3 01             	add    $0x1,%ebx
  8012f1:	83 fb 20             	cmp    $0x20,%ebx
  8012f4:	75 f0                	jne    8012e6 <close_all+0xc>
		close(i);
}
  8012f6:	83 c4 14             	add    $0x14,%esp
  8012f9:	5b                   	pop    %ebx
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    

008012fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	57                   	push   %edi
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801305:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801308:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	89 04 24             	mov    %eax,(%esp)
  801312:	e8 5f fe ff ff       	call   801176 <fd_lookup>
  801317:	89 c2                	mov    %eax,%edx
  801319:	85 d2                	test   %edx,%edx
  80131b:	0f 88 e1 00 00 00    	js     801402 <dup+0x106>
		return r;
	close(newfdnum);
  801321:	8b 45 0c             	mov    0xc(%ebp),%eax
  801324:	89 04 24             	mov    %eax,(%esp)
  801327:	e8 7b ff ff ff       	call   8012a7 <close>

	newfd = INDEX2FD(newfdnum);
  80132c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80132f:	c1 e3 0c             	shl    $0xc,%ebx
  801332:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80133b:	89 04 24             	mov    %eax,(%esp)
  80133e:	e8 cd fd ff ff       	call   801110 <fd2data>
  801343:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801345:	89 1c 24             	mov    %ebx,(%esp)
  801348:	e8 c3 fd ff ff       	call   801110 <fd2data>
  80134d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80134f:	89 f0                	mov    %esi,%eax
  801351:	c1 e8 16             	shr    $0x16,%eax
  801354:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80135b:	a8 01                	test   $0x1,%al
  80135d:	74 43                	je     8013a2 <dup+0xa6>
  80135f:	89 f0                	mov    %esi,%eax
  801361:	c1 e8 0c             	shr    $0xc,%eax
  801364:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80136b:	f6 c2 01             	test   $0x1,%dl
  80136e:	74 32                	je     8013a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801370:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801377:	25 07 0e 00 00       	and    $0xe07,%eax
  80137c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801380:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801384:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80138b:	00 
  80138c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801390:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801397:	e8 ed f9 ff ff       	call   800d89 <sys_page_map>
  80139c:	89 c6                	mov    %eax,%esi
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 3e                	js     8013e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a5:	89 c2                	mov    %eax,%edx
  8013a7:	c1 ea 0c             	shr    $0xc,%edx
  8013aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013c6:	00 
  8013c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d2:	e8 b2 f9 ff ff       	call   800d89 <sys_page_map>
  8013d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013dc:	85 f6                	test   %esi,%esi
  8013de:	79 22                	jns    801402 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013eb:	e8 ec f9 ff ff       	call   800ddc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fb:	e8 dc f9 ff ff       	call   800ddc <sys_page_unmap>
	return r;
  801400:	89 f0                	mov    %esi,%eax
}
  801402:	83 c4 3c             	add    $0x3c,%esp
  801405:	5b                   	pop    %ebx
  801406:	5e                   	pop    %esi
  801407:	5f                   	pop    %edi
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    

0080140a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	53                   	push   %ebx
  80140e:	83 ec 24             	sub    $0x24,%esp
  801411:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801414:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801417:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141b:	89 1c 24             	mov    %ebx,(%esp)
  80141e:	e8 53 fd ff ff       	call   801176 <fd_lookup>
  801423:	89 c2                	mov    %eax,%edx
  801425:	85 d2                	test   %edx,%edx
  801427:	78 6d                	js     801496 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801429:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801433:	8b 00                	mov    (%eax),%eax
  801435:	89 04 24             	mov    %eax,(%esp)
  801438:	e8 8f fd ff ff       	call   8011cc <dev_lookup>
  80143d:	85 c0                	test   %eax,%eax
  80143f:	78 55                	js     801496 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801444:	8b 50 08             	mov    0x8(%eax),%edx
  801447:	83 e2 03             	and    $0x3,%edx
  80144a:	83 fa 01             	cmp    $0x1,%edx
  80144d:	75 23                	jne    801472 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80144f:	a1 08 40 80 00       	mov    0x804008,%eax
  801454:	8b 40 48             	mov    0x48(%eax),%eax
  801457:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80145b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145f:	c7 04 24 a9 2c 80 00 	movl   $0x802ca9,(%esp)
  801466:	e8 e3 ed ff ff       	call   80024e <cprintf>
		return -E_INVAL;
  80146b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801470:	eb 24                	jmp    801496 <read+0x8c>
	}
	if (!dev->dev_read)
  801472:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801475:	8b 52 08             	mov    0x8(%edx),%edx
  801478:	85 d2                	test   %edx,%edx
  80147a:	74 15                	je     801491 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80147c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80147f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801483:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801486:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80148a:	89 04 24             	mov    %eax,(%esp)
  80148d:	ff d2                	call   *%edx
  80148f:	eb 05                	jmp    801496 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801491:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801496:	83 c4 24             	add    $0x24,%esp
  801499:	5b                   	pop    %ebx
  80149a:	5d                   	pop    %ebp
  80149b:	c3                   	ret    

0080149c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	57                   	push   %edi
  8014a0:	56                   	push   %esi
  8014a1:	53                   	push   %ebx
  8014a2:	83 ec 1c             	sub    $0x1c,%esp
  8014a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b0:	eb 23                	jmp    8014d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014b2:	89 f0                	mov    %esi,%eax
  8014b4:	29 d8                	sub    %ebx,%eax
  8014b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ba:	89 d8                	mov    %ebx,%eax
  8014bc:	03 45 0c             	add    0xc(%ebp),%eax
  8014bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c3:	89 3c 24             	mov    %edi,(%esp)
  8014c6:	e8 3f ff ff ff       	call   80140a <read>
		if (m < 0)
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	78 10                	js     8014df <readn+0x43>
			return m;
		if (m == 0)
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	74 0a                	je     8014dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d3:	01 c3                	add    %eax,%ebx
  8014d5:	39 f3                	cmp    %esi,%ebx
  8014d7:	72 d9                	jb     8014b2 <readn+0x16>
  8014d9:	89 d8                	mov    %ebx,%eax
  8014db:	eb 02                	jmp    8014df <readn+0x43>
  8014dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014df:	83 c4 1c             	add    $0x1c,%esp
  8014e2:	5b                   	pop    %ebx
  8014e3:	5e                   	pop    %esi
  8014e4:	5f                   	pop    %edi
  8014e5:	5d                   	pop    %ebp
  8014e6:	c3                   	ret    

008014e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 24             	sub    $0x24,%esp
  8014ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f8:	89 1c 24             	mov    %ebx,(%esp)
  8014fb:	e8 76 fc ff ff       	call   801176 <fd_lookup>
  801500:	89 c2                	mov    %eax,%edx
  801502:	85 d2                	test   %edx,%edx
  801504:	78 68                	js     80156e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801506:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801509:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801510:	8b 00                	mov    (%eax),%eax
  801512:	89 04 24             	mov    %eax,(%esp)
  801515:	e8 b2 fc ff ff       	call   8011cc <dev_lookup>
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 50                	js     80156e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80151e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801521:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801525:	75 23                	jne    80154a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801527:	a1 08 40 80 00       	mov    0x804008,%eax
  80152c:	8b 40 48             	mov    0x48(%eax),%eax
  80152f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801533:	89 44 24 04          	mov    %eax,0x4(%esp)
  801537:	c7 04 24 c5 2c 80 00 	movl   $0x802cc5,(%esp)
  80153e:	e8 0b ed ff ff       	call   80024e <cprintf>
		return -E_INVAL;
  801543:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801548:	eb 24                	jmp    80156e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 52 0c             	mov    0xc(%edx),%edx
  801550:	85 d2                	test   %edx,%edx
  801552:	74 15                	je     801569 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801554:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801557:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80155b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80155e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801562:	89 04 24             	mov    %eax,(%esp)
  801565:	ff d2                	call   *%edx
  801567:	eb 05                	jmp    80156e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801569:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80156e:	83 c4 24             	add    $0x24,%esp
  801571:	5b                   	pop    %ebx
  801572:	5d                   	pop    %ebp
  801573:	c3                   	ret    

00801574 <seek>:

int
seek(int fdnum, off_t offset)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80157d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	e8 ea fb ff ff       	call   801176 <fd_lookup>
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 0e                	js     80159e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801590:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801593:	8b 55 0c             	mov    0xc(%ebp),%edx
  801596:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	53                   	push   %ebx
  8015a4:	83 ec 24             	sub    $0x24,%esp
  8015a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b1:	89 1c 24             	mov    %ebx,(%esp)
  8015b4:	e8 bd fb ff ff       	call   801176 <fd_lookup>
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	85 d2                	test   %edx,%edx
  8015bd:	78 61                	js     801620 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	8b 00                	mov    (%eax),%eax
  8015cb:	89 04 24             	mov    %eax,(%esp)
  8015ce:	e8 f9 fb ff ff       	call   8011cc <dev_lookup>
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	78 49                	js     801620 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015de:	75 23                	jne    801603 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015e0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e5:	8b 40 48             	mov    0x48(%eax),%eax
  8015e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f0:	c7 04 24 88 2c 80 00 	movl   $0x802c88,(%esp)
  8015f7:	e8 52 ec ff ff       	call   80024e <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801601:	eb 1d                	jmp    801620 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801606:	8b 52 18             	mov    0x18(%edx),%edx
  801609:	85 d2                	test   %edx,%edx
  80160b:	74 0e                	je     80161b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80160d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801610:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801614:	89 04 24             	mov    %eax,(%esp)
  801617:	ff d2                	call   *%edx
  801619:	eb 05                	jmp    801620 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80161b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801620:	83 c4 24             	add    $0x24,%esp
  801623:	5b                   	pop    %ebx
  801624:	5d                   	pop    %ebp
  801625:	c3                   	ret    

00801626 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	53                   	push   %ebx
  80162a:	83 ec 24             	sub    $0x24,%esp
  80162d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801630:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801633:	89 44 24 04          	mov    %eax,0x4(%esp)
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	89 04 24             	mov    %eax,(%esp)
  80163d:	e8 34 fb ff ff       	call   801176 <fd_lookup>
  801642:	89 c2                	mov    %eax,%edx
  801644:	85 d2                	test   %edx,%edx
  801646:	78 52                	js     80169a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801648:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801652:	8b 00                	mov    (%eax),%eax
  801654:	89 04 24             	mov    %eax,(%esp)
  801657:	e8 70 fb ff ff       	call   8011cc <dev_lookup>
  80165c:	85 c0                	test   %eax,%eax
  80165e:	78 3a                	js     80169a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801663:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801667:	74 2c                	je     801695 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801669:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80166c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801673:	00 00 00 
	stat->st_isdir = 0;
  801676:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80167d:	00 00 00 
	stat->st_dev = dev;
  801680:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801686:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80168a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168d:	89 14 24             	mov    %edx,(%esp)
  801690:	ff 50 14             	call   *0x14(%eax)
  801693:	eb 05                	jmp    80169a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801695:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80169a:	83 c4 24             	add    $0x24,%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    

008016a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	56                   	push   %esi
  8016a4:	53                   	push   %ebx
  8016a5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016af:	00 
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	89 04 24             	mov    %eax,(%esp)
  8016b6:	e8 99 02 00 00       	call   801954 <open>
  8016bb:	89 c3                	mov    %eax,%ebx
  8016bd:	85 db                	test   %ebx,%ebx
  8016bf:	78 1b                	js     8016dc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c8:	89 1c 24             	mov    %ebx,(%esp)
  8016cb:	e8 56 ff ff ff       	call   801626 <fstat>
  8016d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d2:	89 1c 24             	mov    %ebx,(%esp)
  8016d5:	e8 cd fb ff ff       	call   8012a7 <close>
	return r;
  8016da:	89 f0                	mov    %esi,%eax
}
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 10             	sub    $0x10,%esp
  8016eb:	89 c6                	mov    %eax,%esi
  8016ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ef:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016f6:	75 11                	jne    801709 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016ff:	e8 2b 0e 00 00       	call   80252f <ipc_find_env>
  801704:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801709:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801710:	00 
  801711:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801718:	00 
  801719:	89 74 24 04          	mov    %esi,0x4(%esp)
  80171d:	a1 00 40 80 00       	mov    0x804000,%eax
  801722:	89 04 24             	mov    %eax,(%esp)
  801725:	e8 9e 0d 00 00       	call   8024c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80172a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801731:	00 
  801732:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801736:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80173d:	e8 1e 0d 00 00       	call   802460 <ipc_recv>
}
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    

00801749 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8b 40 0c             	mov    0xc(%eax),%eax
  801755:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80175a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	b8 02 00 00 00       	mov    $0x2,%eax
  80176c:	e8 72 ff ff ff       	call   8016e3 <fsipc>
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	8b 40 0c             	mov    0xc(%eax),%eax
  80177f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801784:	ba 00 00 00 00       	mov    $0x0,%edx
  801789:	b8 06 00 00 00       	mov    $0x6,%eax
  80178e:	e8 50 ff ff ff       	call   8016e3 <fsipc>
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	53                   	push   %ebx
  801799:	83 ec 14             	sub    $0x14,%esp
  80179c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017af:	b8 05 00 00 00       	mov    $0x5,%eax
  8017b4:	e8 2a ff ff ff       	call   8016e3 <fsipc>
  8017b9:	89 c2                	mov    %eax,%edx
  8017bb:	85 d2                	test   %edx,%edx
  8017bd:	78 2b                	js     8017ea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017bf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017c6:	00 
  8017c7:	89 1c 24             	mov    %ebx,(%esp)
  8017ca:	e8 f8 f0 ff ff       	call   8008c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017cf:	a1 80 50 80 00       	mov    0x805080,%eax
  8017d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017da:	a1 84 50 80 00       	mov    0x805084,%eax
  8017df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ea:	83 c4 14             	add    $0x14,%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 14             	sub    $0x14,%esp
  8017f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  8017fa:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801800:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801805:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801808:	8b 55 08             	mov    0x8(%ebp),%edx
  80180b:	8b 52 0c             	mov    0xc(%edx),%edx
  80180e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801814:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801819:	89 44 24 08          	mov    %eax,0x8(%esp)
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 44 24 04          	mov    %eax,0x4(%esp)
  801824:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80182b:	e8 34 f2 ff ff       	call   800a64 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801830:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801837:	00 
  801838:	c7 04 24 f8 2c 80 00 	movl   $0x802cf8,(%esp)
  80183f:	e8 0a ea ff ff       	call   80024e <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801844:	ba 00 00 00 00       	mov    $0x0,%edx
  801849:	b8 04 00 00 00       	mov    $0x4,%eax
  80184e:	e8 90 fe ff ff       	call   8016e3 <fsipc>
  801853:	85 c0                	test   %eax,%eax
  801855:	78 53                	js     8018aa <devfile_write+0xba>
		return r;
	assert(r <= n);
  801857:	39 c3                	cmp    %eax,%ebx
  801859:	73 24                	jae    80187f <devfile_write+0x8f>
  80185b:	c7 44 24 0c fd 2c 80 	movl   $0x802cfd,0xc(%esp)
  801862:	00 
  801863:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  80186a:	00 
  80186b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801872:	00 
  801873:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  80187a:	e8 d6 e8 ff ff       	call   800155 <_panic>
	assert(r <= PGSIZE);
  80187f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801884:	7e 24                	jle    8018aa <devfile_write+0xba>
  801886:	c7 44 24 0c 24 2d 80 	movl   $0x802d24,0xc(%esp)
  80188d:	00 
  80188e:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  801895:	00 
  801896:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80189d:	00 
  80189e:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  8018a5:	e8 ab e8 ff ff       	call   800155 <_panic>
	return r;
}
  8018aa:	83 c4 14             	add    $0x14,%esp
  8018ad:	5b                   	pop    %ebx
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    

008018b0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	56                   	push   %esi
  8018b4:	53                   	push   %ebx
  8018b5:	83 ec 10             	sub    $0x10,%esp
  8018b8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018c6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d1:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d6:	e8 08 fe ff ff       	call   8016e3 <fsipc>
  8018db:	89 c3                	mov    %eax,%ebx
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 6a                	js     80194b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018e1:	39 c6                	cmp    %eax,%esi
  8018e3:	73 24                	jae    801909 <devfile_read+0x59>
  8018e5:	c7 44 24 0c fd 2c 80 	movl   $0x802cfd,0xc(%esp)
  8018ec:	00 
  8018ed:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  8018f4:	00 
  8018f5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018fc:	00 
  8018fd:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  801904:	e8 4c e8 ff ff       	call   800155 <_panic>
	assert(r <= PGSIZE);
  801909:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80190e:	7e 24                	jle    801934 <devfile_read+0x84>
  801910:	c7 44 24 0c 24 2d 80 	movl   $0x802d24,0xc(%esp)
  801917:	00 
  801918:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  80191f:	00 
  801920:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801927:	00 
  801928:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  80192f:	e8 21 e8 ff ff       	call   800155 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801934:	89 44 24 08          	mov    %eax,0x8(%esp)
  801938:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80193f:	00 
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 04 24             	mov    %eax,(%esp)
  801946:	e8 19 f1 ff ff       	call   800a64 <memmove>
	return r;
}
  80194b:	89 d8                	mov    %ebx,%eax
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	5b                   	pop    %ebx
  801951:	5e                   	pop    %esi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    

00801954 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	53                   	push   %ebx
  801958:	83 ec 24             	sub    $0x24,%esp
  80195b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80195e:	89 1c 24             	mov    %ebx,(%esp)
  801961:	e8 2a ef ff ff       	call   800890 <strlen>
  801966:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80196b:	7f 60                	jg     8019cd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80196d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801970:	89 04 24             	mov    %eax,(%esp)
  801973:	e8 af f7 ff ff       	call   801127 <fd_alloc>
  801978:	89 c2                	mov    %eax,%edx
  80197a:	85 d2                	test   %edx,%edx
  80197c:	78 54                	js     8019d2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80197e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801982:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801989:	e8 39 ef ff ff       	call   8008c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80198e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801991:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801999:	b8 01 00 00 00       	mov    $0x1,%eax
  80199e:	e8 40 fd ff ff       	call   8016e3 <fsipc>
  8019a3:	89 c3                	mov    %eax,%ebx
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	79 17                	jns    8019c0 <open+0x6c>
		fd_close(fd, 0);
  8019a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019b0:	00 
  8019b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b4:	89 04 24             	mov    %eax,(%esp)
  8019b7:	e8 6a f8 ff ff       	call   801226 <fd_close>
		return r;
  8019bc:	89 d8                	mov    %ebx,%eax
  8019be:	eb 12                	jmp    8019d2 <open+0x7e>
	}

	return fd2num(fd);
  8019c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c3:	89 04 24             	mov    %eax,(%esp)
  8019c6:	e8 35 f7 ff ff       	call   801100 <fd2num>
  8019cb:	eb 05                	jmp    8019d2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019cd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019d2:	83 c4 24             	add    $0x24,%esp
  8019d5:	5b                   	pop    %ebx
  8019d6:	5d                   	pop    %ebp
  8019d7:	c3                   	ret    

008019d8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e8:	e8 f6 fc ff ff       	call   8016e3 <fsipc>
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <evict>:

int evict(void)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  8019f5:	c7 04 24 30 2d 80 00 	movl   $0x802d30,(%esp)
  8019fc:	e8 4d e8 ff ff       	call   80024e <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
  801a06:	b8 09 00 00 00       	mov    $0x9,%eax
  801a0b:	e8 d3 fc ff ff       	call   8016e3 <fsipc>
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    
  801a12:	66 90                	xchg   %ax,%ax
  801a14:	66 90                	xchg   %ax,%ax
  801a16:	66 90                	xchg   %ax,%ax
  801a18:	66 90                	xchg   %ax,%ax
  801a1a:	66 90                	xchg   %ax,%ax
  801a1c:	66 90                	xchg   %ax,%ax
  801a1e:	66 90                	xchg   %ax,%ax

00801a20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801a26:	c7 44 24 04 49 2d 80 	movl   $0x802d49,0x4(%esp)
  801a2d:	00 
  801a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a31:	89 04 24             	mov    %eax,(%esp)
  801a34:	e8 8e ee ff ff       	call   8008c7 <strcpy>
	return 0;
}
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 14             	sub    $0x14,%esp
  801a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a4a:	89 1c 24             	mov    %ebx,(%esp)
  801a4d:	e8 15 0b 00 00       	call   802567 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801a52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801a57:	83 f8 01             	cmp    $0x1,%eax
  801a5a:	75 0d                	jne    801a69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801a5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	e8 29 03 00 00       	call   801d90 <nsipc_close>
  801a67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801a69:	89 d0                	mov    %edx,%eax
  801a6b:	83 c4 14             	add    $0x14,%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5d                   	pop    %ebp
  801a70:	c3                   	ret    

00801a71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a7e:	00 
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	8b 40 0c             	mov    0xc(%eax),%eax
  801a93:	89 04 24             	mov    %eax,(%esp)
  801a96:	e8 f0 03 00 00       	call   801e8b <nsipc_send>
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801aa3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801aaa:	00 
  801aab:	8b 45 10             	mov    0x10(%ebp),%eax
  801aae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8b 40 0c             	mov    0xc(%eax),%eax
  801abf:	89 04 24             	mov    %eax,(%esp)
  801ac2:	e8 44 03 00 00       	call   801e0b <nsipc_recv>
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801acf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ad2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ad6:	89 04 24             	mov    %eax,(%esp)
  801ad9:	e8 98 f6 ff ff       	call   801176 <fd_lookup>
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 17                	js     801af9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801aeb:	39 08                	cmp    %ecx,(%eax)
  801aed:	75 05                	jne    801af4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801aef:	8b 40 0c             	mov    0xc(%eax),%eax
  801af2:	eb 05                	jmp    801af9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801af4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	83 ec 20             	sub    $0x20,%esp
  801b03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801b05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b08:	89 04 24             	mov    %eax,(%esp)
  801b0b:	e8 17 f6 ff ff       	call   801127 <fd_alloc>
  801b10:	89 c3                	mov    %eax,%ebx
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 21                	js     801b37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b1d:	00 
  801b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2c:	e8 04 f2 ff ff       	call   800d35 <sys_page_alloc>
  801b31:	89 c3                	mov    %eax,%ebx
  801b33:	85 c0                	test   %eax,%eax
  801b35:	79 0c                	jns    801b43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801b37:	89 34 24             	mov    %esi,(%esp)
  801b3a:	e8 51 02 00 00       	call   801d90 <nsipc_close>
		return r;
  801b3f:	89 d8                	mov    %ebx,%eax
  801b41:	eb 20                	jmp    801b63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b43:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801b58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801b5b:	89 14 24             	mov    %edx,(%esp)
  801b5e:	e8 9d f5 ff ff       	call   801100 <fd2num>
}
  801b63:	83 c4 20             	add    $0x20,%esp
  801b66:	5b                   	pop    %ebx
  801b67:	5e                   	pop    %esi
  801b68:	5d                   	pop    %ebp
  801b69:	c3                   	ret    

00801b6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	e8 51 ff ff ff       	call   801ac9 <fd2sockid>
		return r;
  801b78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 23                	js     801ba1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b7e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b81:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b8c:	89 04 24             	mov    %eax,(%esp)
  801b8f:	e8 45 01 00 00       	call   801cd9 <nsipc_accept>
		return r;
  801b94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b96:	85 c0                	test   %eax,%eax
  801b98:	78 07                	js     801ba1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b9a:	e8 5c ff ff ff       	call   801afb <alloc_sockfd>
  801b9f:	89 c1                	mov    %eax,%ecx
}
  801ba1:	89 c8                	mov    %ecx,%eax
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	e8 16 ff ff ff       	call   801ac9 <fd2sockid>
  801bb3:	89 c2                	mov    %eax,%edx
  801bb5:	85 d2                	test   %edx,%edx
  801bb7:	78 16                	js     801bcf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc7:	89 14 24             	mov    %edx,(%esp)
  801bca:	e8 60 01 00 00       	call   801d2f <nsipc_bind>
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <shutdown>:

int
shutdown(int s, int how)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	e8 ea fe ff ff       	call   801ac9 <fd2sockid>
  801bdf:	89 c2                	mov    %eax,%edx
  801be1:	85 d2                	test   %edx,%edx
  801be3:	78 0f                	js     801bf4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bec:	89 14 24             	mov    %edx,(%esp)
  801bef:	e8 7a 01 00 00       	call   801d6e <nsipc_shutdown>
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	e8 c5 fe ff ff       	call   801ac9 <fd2sockid>
  801c04:	89 c2                	mov    %eax,%edx
  801c06:	85 d2                	test   %edx,%edx
  801c08:	78 16                	js     801c20 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801c0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c18:	89 14 24             	mov    %edx,(%esp)
  801c1b:	e8 8a 01 00 00       	call   801daa <nsipc_connect>
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <listen>:

int
listen(int s, int backlog)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	e8 99 fe ff ff       	call   801ac9 <fd2sockid>
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	85 d2                	test   %edx,%edx
  801c34:	78 0f                	js     801c45 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3d:	89 14 24             	mov    %edx,(%esp)
  801c40:	e8 a4 01 00 00       	call   801de9 <nsipc_listen>
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 98 02 00 00       	call   801efe <nsipc_socket>
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	85 d2                	test   %edx,%edx
  801c6a:	78 05                	js     801c71 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801c6c:	e8 8a fe ff ff       	call   801afb <alloc_sockfd>
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	53                   	push   %ebx
  801c77:	83 ec 14             	sub    $0x14,%esp
  801c7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c7c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c83:	75 11                	jne    801c96 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c85:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c8c:	e8 9e 08 00 00       	call   80252f <ipc_find_env>
  801c91:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c96:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c9d:	00 
  801c9e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ca5:	00 
  801ca6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801caa:	a1 04 40 80 00       	mov    0x804004,%eax
  801caf:	89 04 24             	mov    %eax,(%esp)
  801cb2:	e8 11 08 00 00       	call   8024c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cb7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cbe:	00 
  801cbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cc6:	00 
  801cc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cce:	e8 8d 07 00 00       	call   802460 <ipc_recv>
}
  801cd3:	83 c4 14             	add    $0x14,%esp
  801cd6:	5b                   	pop    %ebx
  801cd7:	5d                   	pop    %ebp
  801cd8:	c3                   	ret    

00801cd9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	56                   	push   %esi
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 10             	sub    $0x10,%esp
  801ce1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cec:	8b 06                	mov    (%esi),%eax
  801cee:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cf3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf8:	e8 76 ff ff ff       	call   801c73 <nsipc>
  801cfd:	89 c3                	mov    %eax,%ebx
  801cff:	85 c0                	test   %eax,%eax
  801d01:	78 23                	js     801d26 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d03:	a1 10 60 80 00       	mov    0x806010,%eax
  801d08:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d0c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d13:	00 
  801d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d17:	89 04 24             	mov    %eax,(%esp)
  801d1a:	e8 45 ed ff ff       	call   800a64 <memmove>
		*addrlen = ret->ret_addrlen;
  801d1f:	a1 10 60 80 00       	mov    0x806010,%eax
  801d24:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801d26:	89 d8                	mov    %ebx,%eax
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5e                   	pop    %esi
  801d2d:	5d                   	pop    %ebp
  801d2e:	c3                   	ret    

00801d2f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	53                   	push   %ebx
  801d33:	83 ec 14             	sub    $0x14,%esp
  801d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d41:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d53:	e8 0c ed ff ff       	call   800a64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d58:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d5e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d63:	e8 0b ff ff ff       	call   801c73 <nsipc>
}
  801d68:	83 c4 14             	add    $0x14,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5d                   	pop    %ebp
  801d6d:	c3                   	ret    

00801d6e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d84:	b8 03 00 00 00       	mov    $0x3,%eax
  801d89:	e8 e5 fe ff ff       	call   801c73 <nsipc>
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <nsipc_close>:

int
nsipc_close(int s)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d9e:	b8 04 00 00 00       	mov    $0x4,%eax
  801da3:	e8 cb fe ff ff       	call   801c73 <nsipc>
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	53                   	push   %ebx
  801dae:	83 ec 14             	sub    $0x14,%esp
  801db1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dbc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801dce:	e8 91 ec ff ff       	call   800a64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dd3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801dd9:	b8 05 00 00 00       	mov    $0x5,%eax
  801dde:	e8 90 fe ff ff       	call   801c73 <nsipc>
}
  801de3:	83 c4 14             	add    $0x14,%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801dff:	b8 06 00 00 00       	mov    $0x6,%eax
  801e04:	e8 6a fe ff ff       	call   801c73 <nsipc>
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	56                   	push   %esi
  801e0f:	53                   	push   %ebx
  801e10:	83 ec 10             	sub    $0x10,%esp
  801e13:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e1e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e24:	8b 45 14             	mov    0x14(%ebp),%eax
  801e27:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e2c:	b8 07 00 00 00       	mov    $0x7,%eax
  801e31:	e8 3d fe ff ff       	call   801c73 <nsipc>
  801e36:	89 c3                	mov    %eax,%ebx
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 46                	js     801e82 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801e3c:	39 f0                	cmp    %esi,%eax
  801e3e:	7f 07                	jg     801e47 <nsipc_recv+0x3c>
  801e40:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e45:	7e 24                	jle    801e6b <nsipc_recv+0x60>
  801e47:	c7 44 24 0c 55 2d 80 	movl   $0x802d55,0xc(%esp)
  801e4e:	00 
  801e4f:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  801e56:	00 
  801e57:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801e5e:	00 
  801e5f:	c7 04 24 6a 2d 80 00 	movl   $0x802d6a,(%esp)
  801e66:	e8 ea e2 ff ff       	call   800155 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e76:	00 
  801e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7a:	89 04 24             	mov    %eax,(%esp)
  801e7d:	e8 e2 eb ff ff       	call   800a64 <memmove>
	}

	return r;
}
  801e82:	89 d8                	mov    %ebx,%eax
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    

00801e8b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	53                   	push   %ebx
  801e8f:	83 ec 14             	sub    $0x14,%esp
  801e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e9d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ea3:	7e 24                	jle    801ec9 <nsipc_send+0x3e>
  801ea5:	c7 44 24 0c 76 2d 80 	movl   $0x802d76,0xc(%esp)
  801eac:	00 
  801ead:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  801eb4:	00 
  801eb5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801ebc:	00 
  801ebd:	c7 04 24 6a 2d 80 00 	movl   $0x802d6a,(%esp)
  801ec4:	e8 8c e2 ff ff       	call   800155 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ec9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801edb:	e8 84 eb ff ff       	call   800a64 <memmove>
	nsipcbuf.send.req_size = size;
  801ee0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ee6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801eee:	b8 08 00 00 00       	mov    $0x8,%eax
  801ef3:	e8 7b fd ff ff       	call   801c73 <nsipc>
}
  801ef8:	83 c4 14             	add    $0x14,%esp
  801efb:	5b                   	pop    %ebx
  801efc:	5d                   	pop    %ebp
  801efd:	c3                   	ret    

00801efe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f14:	8b 45 10             	mov    0x10(%ebp),%eax
  801f17:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f1c:	b8 09 00 00 00       	mov    $0x9,%eax
  801f21:	e8 4d fd ff ff       	call   801c73 <nsipc>
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	83 ec 10             	sub    $0x10,%esp
  801f30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	89 04 24             	mov    %eax,(%esp)
  801f39:	e8 d2 f1 ff ff       	call   801110 <fd2data>
  801f3e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f40:	c7 44 24 04 82 2d 80 	movl   $0x802d82,0x4(%esp)
  801f47:	00 
  801f48:	89 1c 24             	mov    %ebx,(%esp)
  801f4b:	e8 77 e9 ff ff       	call   8008c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f50:	8b 46 04             	mov    0x4(%esi),%eax
  801f53:	2b 06                	sub    (%esi),%eax
  801f55:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f5b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f62:	00 00 00 
	stat->st_dev = &devpipe;
  801f65:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f6c:	30 80 00 
	return 0;
}
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	83 c4 10             	add    $0x10,%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5d                   	pop    %ebp
  801f7a:	c3                   	ret    

00801f7b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	53                   	push   %ebx
  801f7f:	83 ec 14             	sub    $0x14,%esp
  801f82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f85:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f90:	e8 47 ee ff ff       	call   800ddc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f95:	89 1c 24             	mov    %ebx,(%esp)
  801f98:	e8 73 f1 ff ff       	call   801110 <fd2data>
  801f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa8:	e8 2f ee ff ff       	call   800ddc <sys_page_unmap>
}
  801fad:	83 c4 14             	add    $0x14,%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5d                   	pop    %ebp
  801fb2:	c3                   	ret    

00801fb3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	57                   	push   %edi
  801fb7:	56                   	push   %esi
  801fb8:	53                   	push   %ebx
  801fb9:	83 ec 2c             	sub    $0x2c,%esp
  801fbc:	89 c6                	mov    %eax,%esi
  801fbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801fc1:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fc9:	89 34 24             	mov    %esi,(%esp)
  801fcc:	e8 96 05 00 00       	call   802567 <pageref>
  801fd1:	89 c7                	mov    %eax,%edi
  801fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd6:	89 04 24             	mov    %eax,(%esp)
  801fd9:	e8 89 05 00 00       	call   802567 <pageref>
  801fde:	39 c7                	cmp    %eax,%edi
  801fe0:	0f 94 c2             	sete   %dl
  801fe3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801fe6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801fec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801fef:	39 fb                	cmp    %edi,%ebx
  801ff1:	74 21                	je     802014 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801ff3:	84 d2                	test   %dl,%dl
  801ff5:	74 ca                	je     801fc1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ff7:	8b 51 58             	mov    0x58(%ecx),%edx
  801ffa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ffe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802002:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802006:	c7 04 24 89 2d 80 00 	movl   $0x802d89,(%esp)
  80200d:	e8 3c e2 ff ff       	call   80024e <cprintf>
  802012:	eb ad                	jmp    801fc1 <_pipeisclosed+0xe>
	}
}
  802014:	83 c4 2c             	add    $0x2c,%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5f                   	pop    %edi
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    

0080201c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	57                   	push   %edi
  802020:	56                   	push   %esi
  802021:	53                   	push   %ebx
  802022:	83 ec 1c             	sub    $0x1c,%esp
  802025:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802028:	89 34 24             	mov    %esi,(%esp)
  80202b:	e8 e0 f0 ff ff       	call   801110 <fd2data>
  802030:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802032:	bf 00 00 00 00       	mov    $0x0,%edi
  802037:	eb 45                	jmp    80207e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802039:	89 da                	mov    %ebx,%edx
  80203b:	89 f0                	mov    %esi,%eax
  80203d:	e8 71 ff ff ff       	call   801fb3 <_pipeisclosed>
  802042:	85 c0                	test   %eax,%eax
  802044:	75 41                	jne    802087 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802046:	e8 cb ec ff ff       	call   800d16 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80204b:	8b 43 04             	mov    0x4(%ebx),%eax
  80204e:	8b 0b                	mov    (%ebx),%ecx
  802050:	8d 51 20             	lea    0x20(%ecx),%edx
  802053:	39 d0                	cmp    %edx,%eax
  802055:	73 e2                	jae    802039 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80205a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80205e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802061:	99                   	cltd   
  802062:	c1 ea 1b             	shr    $0x1b,%edx
  802065:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802068:	83 e1 1f             	and    $0x1f,%ecx
  80206b:	29 d1                	sub    %edx,%ecx
  80206d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802071:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802075:	83 c0 01             	add    $0x1,%eax
  802078:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80207b:	83 c7 01             	add    $0x1,%edi
  80207e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802081:	75 c8                	jne    80204b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802083:	89 f8                	mov    %edi,%eax
  802085:	eb 05                	jmp    80208c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80208c:	83 c4 1c             	add    $0x1c,%esp
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5f                   	pop    %edi
  802092:	5d                   	pop    %ebp
  802093:	c3                   	ret    

00802094 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	57                   	push   %edi
  802098:	56                   	push   %esi
  802099:	53                   	push   %ebx
  80209a:	83 ec 1c             	sub    $0x1c,%esp
  80209d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8020a0:	89 3c 24             	mov    %edi,(%esp)
  8020a3:	e8 68 f0 ff ff       	call   801110 <fd2data>
  8020a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020aa:	be 00 00 00 00       	mov    $0x0,%esi
  8020af:	eb 3d                	jmp    8020ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020b1:	85 f6                	test   %esi,%esi
  8020b3:	74 04                	je     8020b9 <devpipe_read+0x25>
				return i;
  8020b5:	89 f0                	mov    %esi,%eax
  8020b7:	eb 43                	jmp    8020fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8020b9:	89 da                	mov    %ebx,%edx
  8020bb:	89 f8                	mov    %edi,%eax
  8020bd:	e8 f1 fe ff ff       	call   801fb3 <_pipeisclosed>
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	75 31                	jne    8020f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8020c6:	e8 4b ec ff ff       	call   800d16 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8020cb:	8b 03                	mov    (%ebx),%eax
  8020cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020d0:	74 df                	je     8020b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020d2:	99                   	cltd   
  8020d3:	c1 ea 1b             	shr    $0x1b,%edx
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	83 e0 1f             	and    $0x1f,%eax
  8020db:	29 d0                	sub    %edx,%eax
  8020dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020eb:	83 c6 01             	add    $0x1,%esi
  8020ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f1:	75 d8                	jne    8020cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020f3:	89 f0                	mov    %esi,%eax
  8020f5:	eb 05                	jmp    8020fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020fc:	83 c4 1c             	add    $0x1c,%esp
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5f                   	pop    %edi
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	56                   	push   %esi
  802108:	53                   	push   %ebx
  802109:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80210c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 10 f0 ff ff       	call   801127 <fd_alloc>
  802117:	89 c2                	mov    %eax,%edx
  802119:	85 d2                	test   %edx,%edx
  80211b:	0f 88 4d 01 00 00    	js     80226e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802121:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802128:	00 
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802137:	e8 f9 eb ff ff       	call   800d35 <sys_page_alloc>
  80213c:	89 c2                	mov    %eax,%edx
  80213e:	85 d2                	test   %edx,%edx
  802140:	0f 88 28 01 00 00    	js     80226e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802146:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802149:	89 04 24             	mov    %eax,(%esp)
  80214c:	e8 d6 ef ff ff       	call   801127 <fd_alloc>
  802151:	89 c3                	mov    %eax,%ebx
  802153:	85 c0                	test   %eax,%eax
  802155:	0f 88 fe 00 00 00    	js     802259 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80215b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802162:	00 
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802171:	e8 bf eb ff ff       	call   800d35 <sys_page_alloc>
  802176:	89 c3                	mov    %eax,%ebx
  802178:	85 c0                	test   %eax,%eax
  80217a:	0f 88 d9 00 00 00    	js     802259 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	89 04 24             	mov    %eax,(%esp)
  802186:	e8 85 ef ff ff       	call   801110 <fd2data>
  80218b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80218d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802194:	00 
  802195:	89 44 24 04          	mov    %eax,0x4(%esp)
  802199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a0:	e8 90 eb ff ff       	call   800d35 <sys_page_alloc>
  8021a5:	89 c3                	mov    %eax,%ebx
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	0f 88 97 00 00 00    	js     802246 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b2:	89 04 24             	mov    %eax,(%esp)
  8021b5:	e8 56 ef ff ff       	call   801110 <fd2data>
  8021ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021c1:	00 
  8021c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021cd:	00 
  8021ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d9:	e8 ab eb ff ff       	call   800d89 <sys_page_map>
  8021de:	89 c3                	mov    %eax,%ebx
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	78 52                	js     802236 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021e4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021f9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802202:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802207:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	89 04 24             	mov    %eax,(%esp)
  802214:	e8 e7 ee ff ff       	call   801100 <fd2num>
  802219:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80221c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	89 04 24             	mov    %eax,(%esp)
  802224:	e8 d7 ee ff ff       	call   801100 <fd2num>
  802229:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80222c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	eb 38                	jmp    80226e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802236:	89 74 24 04          	mov    %esi,0x4(%esp)
  80223a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802241:	e8 96 eb ff ff       	call   800ddc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802254:	e8 83 eb ff ff       	call   800ddc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802267:	e8 70 eb ff ff       	call   800ddc <sys_page_unmap>
  80226c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80226e:	83 c4 30             	add    $0x30,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    

00802275 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80227b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80227e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	89 04 24             	mov    %eax,(%esp)
  802288:	e8 e9 ee ff ff       	call   801176 <fd_lookup>
  80228d:	89 c2                	mov    %eax,%edx
  80228f:	85 d2                	test   %edx,%edx
  802291:	78 15                	js     8022a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	89 04 24             	mov    %eax,(%esp)
  802299:	e8 72 ee ff ff       	call   801110 <fd2data>
	return _pipeisclosed(fd, p);
  80229e:	89 c2                	mov    %eax,%edx
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	e8 0b fd ff ff       	call   801fb3 <_pipeisclosed>
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022c0:	c7 44 24 04 a1 2d 80 	movl   $0x802da1,0x4(%esp)
  8022c7:	00 
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	89 04 24             	mov    %eax,(%esp)
  8022ce:	e8 f4 e5 ff ff       	call   8008c7 <strcpy>
	return 0;
}
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	57                   	push   %edi
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
  8022e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022f1:	eb 31                	jmp    802324 <devcons_write+0x4a>
		m = n - tot;
  8022f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8022f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8022f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802300:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802303:	89 74 24 08          	mov    %esi,0x8(%esp)
  802307:	03 45 0c             	add    0xc(%ebp),%eax
  80230a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230e:	89 3c 24             	mov    %edi,(%esp)
  802311:	e8 4e e7 ff ff       	call   800a64 <memmove>
		sys_cputs(buf, m);
  802316:	89 74 24 04          	mov    %esi,0x4(%esp)
  80231a:	89 3c 24             	mov    %edi,(%esp)
  80231d:	e8 f4 e8 ff ff       	call   800c16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802322:	01 f3                	add    %esi,%ebx
  802324:	89 d8                	mov    %ebx,%eax
  802326:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802329:	72 c8                	jb     8022f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80232b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802341:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802345:	75 07                	jne    80234e <devcons_read+0x18>
  802347:	eb 2a                	jmp    802373 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802349:	e8 c8 e9 ff ff       	call   800d16 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80234e:	66 90                	xchg   %ax,%ax
  802350:	e8 df e8 ff ff       	call   800c34 <sys_cgetc>
  802355:	85 c0                	test   %eax,%eax
  802357:	74 f0                	je     802349 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802359:	85 c0                	test   %eax,%eax
  80235b:	78 16                	js     802373 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80235d:	83 f8 04             	cmp    $0x4,%eax
  802360:	74 0c                	je     80236e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802362:	8b 55 0c             	mov    0xc(%ebp),%edx
  802365:	88 02                	mov    %al,(%edx)
	return 1;
  802367:	b8 01 00 00 00       	mov    $0x1,%eax
  80236c:	eb 05                	jmp    802373 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802381:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802388:	00 
  802389:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80238c:	89 04 24             	mov    %eax,(%esp)
  80238f:	e8 82 e8 ff ff       	call   800c16 <sys_cputs>
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <getchar>:

int
getchar(void)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80239c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023a3:	00 
  8023a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b2:	e8 53 f0 ff ff       	call   80140a <read>
	if (r < 0)
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	78 0f                	js     8023ca <getchar+0x34>
		return r;
	if (r < 1)
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	7e 06                	jle    8023c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8023bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8023c3:	eb 05                	jmp    8023ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8023c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	89 04 24             	mov    %eax,(%esp)
  8023df:	e8 92 ed ff ff       	call   801176 <fd_lookup>
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	78 11                	js     8023f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023f1:	39 10                	cmp    %edx,(%eax)
  8023f3:	0f 94 c0             	sete   %al
  8023f6:	0f b6 c0             	movzbl %al,%eax
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <opencons>:

int
opencons(void)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802401:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802404:	89 04 24             	mov    %eax,(%esp)
  802407:	e8 1b ed ff ff       	call   801127 <fd_alloc>
		return r;
  80240c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80240e:	85 c0                	test   %eax,%eax
  802410:	78 40                	js     802452 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802412:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802419:	00 
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802421:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802428:	e8 08 e9 ff ff       	call   800d35 <sys_page_alloc>
		return r;
  80242d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80242f:	85 c0                	test   %eax,%eax
  802431:	78 1f                	js     802452 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802433:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802448:	89 04 24             	mov    %eax,(%esp)
  80244b:	e8 b0 ec ff ff       	call   801100 <fd2num>
  802450:	89 c2                	mov    %eax,%edx
}
  802452:	89 d0                	mov    %edx,%eax
  802454:	c9                   	leave  
  802455:	c3                   	ret    
  802456:	66 90                	xchg   %ax,%ax
  802458:	66 90                	xchg   %ax,%ax
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	56                   	push   %esi
  802464:	53                   	push   %ebx
  802465:	83 ec 10             	sub    $0x10,%esp
  802468:	8b 75 08             	mov    0x8(%ebp),%esi
  80246b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802471:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802473:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802478:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80247b:	89 04 24             	mov    %eax,(%esp)
  80247e:	e8 e8 ea ff ff       	call   800f6b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802483:	85 c0                	test   %eax,%eax
  802485:	75 26                	jne    8024ad <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802487:	85 f6                	test   %esi,%esi
  802489:	74 0a                	je     802495 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80248b:	a1 08 40 80 00       	mov    0x804008,%eax
  802490:	8b 40 74             	mov    0x74(%eax),%eax
  802493:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802495:	85 db                	test   %ebx,%ebx
  802497:	74 0a                	je     8024a3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802499:	a1 08 40 80 00       	mov    0x804008,%eax
  80249e:	8b 40 78             	mov    0x78(%eax),%eax
  8024a1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8024a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8024a8:	8b 40 70             	mov    0x70(%eax),%eax
  8024ab:	eb 14                	jmp    8024c1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8024ad:	85 f6                	test   %esi,%esi
  8024af:	74 06                	je     8024b7 <ipc_recv+0x57>
			*from_env_store = 0;
  8024b1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8024b7:	85 db                	test   %ebx,%ebx
  8024b9:	74 06                	je     8024c1 <ipc_recv+0x61>
			*perm_store = 0;
  8024bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  8024c1:	83 c4 10             	add    $0x10,%esp
  8024c4:	5b                   	pop    %ebx
  8024c5:	5e                   	pop    %esi
  8024c6:	5d                   	pop    %ebp
  8024c7:	c3                   	ret    

008024c8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	57                   	push   %edi
  8024cc:	56                   	push   %esi
  8024cd:	53                   	push   %ebx
  8024ce:	83 ec 1c             	sub    $0x1c,%esp
  8024d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024d7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  8024da:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  8024dc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8024e1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8024e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024f3:	89 3c 24             	mov    %edi,(%esp)
  8024f6:	e8 4d ea ff ff       	call   800f48 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	74 28                	je     802527 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8024ff:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802502:	74 1c                	je     802520 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802504:	c7 44 24 08 b0 2d 80 	movl   $0x802db0,0x8(%esp)
  80250b:	00 
  80250c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802513:	00 
  802514:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  80251b:	e8 35 dc ff ff       	call   800155 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802520:	e8 f1 e7 ff ff       	call   800d16 <sys_yield>
	}
  802525:	eb bd                	jmp    8024e4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802527:	83 c4 1c             	add    $0x1c,%esp
  80252a:	5b                   	pop    %ebx
  80252b:	5e                   	pop    %esi
  80252c:	5f                   	pop    %edi
  80252d:	5d                   	pop    %ebp
  80252e:	c3                   	ret    

0080252f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802535:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80253a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80253d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802543:	8b 52 50             	mov    0x50(%edx),%edx
  802546:	39 ca                	cmp    %ecx,%edx
  802548:	75 0d                	jne    802557 <ipc_find_env+0x28>
			return envs[i].env_id;
  80254a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80254d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802552:	8b 40 40             	mov    0x40(%eax),%eax
  802555:	eb 0e                	jmp    802565 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802557:	83 c0 01             	add    $0x1,%eax
  80255a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80255f:	75 d9                	jne    80253a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802561:	66 b8 00 00          	mov    $0x0,%ax
}
  802565:	5d                   	pop    %ebp
  802566:	c3                   	ret    

00802567 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80256d:	89 d0                	mov    %edx,%eax
  80256f:	c1 e8 16             	shr    $0x16,%eax
  802572:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802579:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80257e:	f6 c1 01             	test   $0x1,%cl
  802581:	74 1d                	je     8025a0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802583:	c1 ea 0c             	shr    $0xc,%edx
  802586:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80258d:	f6 c2 01             	test   $0x1,%dl
  802590:	74 0e                	je     8025a0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802592:	c1 ea 0c             	shr    $0xc,%edx
  802595:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80259c:	ef 
  80259d:	0f b7 c0             	movzwl %ax,%eax
}
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    
  8025a2:	66 90                	xchg   %ax,%ax
  8025a4:	66 90                	xchg   %ax,%ax
  8025a6:	66 90                	xchg   %ax,%ax
  8025a8:	66 90                	xchg   %ax,%ax
  8025aa:	66 90                	xchg   %ax,%ax
  8025ac:	66 90                	xchg   %ax,%ax
  8025ae:	66 90                	xchg   %ax,%ax

008025b0 <__udivdi3>:
  8025b0:	55                   	push   %ebp
  8025b1:	57                   	push   %edi
  8025b2:	56                   	push   %esi
  8025b3:	83 ec 0c             	sub    $0xc,%esp
  8025b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8025be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8025c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025cc:	89 ea                	mov    %ebp,%edx
  8025ce:	89 0c 24             	mov    %ecx,(%esp)
  8025d1:	75 2d                	jne    802600 <__udivdi3+0x50>
  8025d3:	39 e9                	cmp    %ebp,%ecx
  8025d5:	77 61                	ja     802638 <__udivdi3+0x88>
  8025d7:	85 c9                	test   %ecx,%ecx
  8025d9:	89 ce                	mov    %ecx,%esi
  8025db:	75 0b                	jne    8025e8 <__udivdi3+0x38>
  8025dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e2:	31 d2                	xor    %edx,%edx
  8025e4:	f7 f1                	div    %ecx
  8025e6:	89 c6                	mov    %eax,%esi
  8025e8:	31 d2                	xor    %edx,%edx
  8025ea:	89 e8                	mov    %ebp,%eax
  8025ec:	f7 f6                	div    %esi
  8025ee:	89 c5                	mov    %eax,%ebp
  8025f0:	89 f8                	mov    %edi,%eax
  8025f2:	f7 f6                	div    %esi
  8025f4:	89 ea                	mov    %ebp,%edx
  8025f6:	83 c4 0c             	add    $0xc,%esp
  8025f9:	5e                   	pop    %esi
  8025fa:	5f                   	pop    %edi
  8025fb:	5d                   	pop    %ebp
  8025fc:	c3                   	ret    
  8025fd:	8d 76 00             	lea    0x0(%esi),%esi
  802600:	39 e8                	cmp    %ebp,%eax
  802602:	77 24                	ja     802628 <__udivdi3+0x78>
  802604:	0f bd e8             	bsr    %eax,%ebp
  802607:	83 f5 1f             	xor    $0x1f,%ebp
  80260a:	75 3c                	jne    802648 <__udivdi3+0x98>
  80260c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802610:	39 34 24             	cmp    %esi,(%esp)
  802613:	0f 86 9f 00 00 00    	jbe    8026b8 <__udivdi3+0x108>
  802619:	39 d0                	cmp    %edx,%eax
  80261b:	0f 82 97 00 00 00    	jb     8026b8 <__udivdi3+0x108>
  802621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802628:	31 d2                	xor    %edx,%edx
  80262a:	31 c0                	xor    %eax,%eax
  80262c:	83 c4 0c             	add    $0xc,%esp
  80262f:	5e                   	pop    %esi
  802630:	5f                   	pop    %edi
  802631:	5d                   	pop    %ebp
  802632:	c3                   	ret    
  802633:	90                   	nop
  802634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802638:	89 f8                	mov    %edi,%eax
  80263a:	f7 f1                	div    %ecx
  80263c:	31 d2                	xor    %edx,%edx
  80263e:	83 c4 0c             	add    $0xc,%esp
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	89 e9                	mov    %ebp,%ecx
  80264a:	8b 3c 24             	mov    (%esp),%edi
  80264d:	d3 e0                	shl    %cl,%eax
  80264f:	89 c6                	mov    %eax,%esi
  802651:	b8 20 00 00 00       	mov    $0x20,%eax
  802656:	29 e8                	sub    %ebp,%eax
  802658:	89 c1                	mov    %eax,%ecx
  80265a:	d3 ef                	shr    %cl,%edi
  80265c:	89 e9                	mov    %ebp,%ecx
  80265e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802662:	8b 3c 24             	mov    (%esp),%edi
  802665:	09 74 24 08          	or     %esi,0x8(%esp)
  802669:	89 d6                	mov    %edx,%esi
  80266b:	d3 e7                	shl    %cl,%edi
  80266d:	89 c1                	mov    %eax,%ecx
  80266f:	89 3c 24             	mov    %edi,(%esp)
  802672:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802676:	d3 ee                	shr    %cl,%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	d3 e2                	shl    %cl,%edx
  80267c:	89 c1                	mov    %eax,%ecx
  80267e:	d3 ef                	shr    %cl,%edi
  802680:	09 d7                	or     %edx,%edi
  802682:	89 f2                	mov    %esi,%edx
  802684:	89 f8                	mov    %edi,%eax
  802686:	f7 74 24 08          	divl   0x8(%esp)
  80268a:	89 d6                	mov    %edx,%esi
  80268c:	89 c7                	mov    %eax,%edi
  80268e:	f7 24 24             	mull   (%esp)
  802691:	39 d6                	cmp    %edx,%esi
  802693:	89 14 24             	mov    %edx,(%esp)
  802696:	72 30                	jb     8026c8 <__udivdi3+0x118>
  802698:	8b 54 24 04          	mov    0x4(%esp),%edx
  80269c:	89 e9                	mov    %ebp,%ecx
  80269e:	d3 e2                	shl    %cl,%edx
  8026a0:	39 c2                	cmp    %eax,%edx
  8026a2:	73 05                	jae    8026a9 <__udivdi3+0xf9>
  8026a4:	3b 34 24             	cmp    (%esp),%esi
  8026a7:	74 1f                	je     8026c8 <__udivdi3+0x118>
  8026a9:	89 f8                	mov    %edi,%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	e9 7a ff ff ff       	jmp    80262c <__udivdi3+0x7c>
  8026b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026b8:	31 d2                	xor    %edx,%edx
  8026ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bf:	e9 68 ff ff ff       	jmp    80262c <__udivdi3+0x7c>
  8026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	83 c4 0c             	add    $0xc,%esp
  8026d0:	5e                   	pop    %esi
  8026d1:	5f                   	pop    %edi
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    
  8026d4:	66 90                	xchg   %ax,%ax
  8026d6:	66 90                	xchg   %ax,%ax
  8026d8:	66 90                	xchg   %ax,%ax
  8026da:	66 90                	xchg   %ax,%ax
  8026dc:	66 90                	xchg   %ax,%ax
  8026de:	66 90                	xchg   %ax,%ax

008026e0 <__umoddi3>:
  8026e0:	55                   	push   %ebp
  8026e1:	57                   	push   %edi
  8026e2:	56                   	push   %esi
  8026e3:	83 ec 14             	sub    $0x14,%esp
  8026e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8026f2:	89 c7                	mov    %eax,%edi
  8026f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8026fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802700:	89 34 24             	mov    %esi,(%esp)
  802703:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802707:	85 c0                	test   %eax,%eax
  802709:	89 c2                	mov    %eax,%edx
  80270b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80270f:	75 17                	jne    802728 <__umoddi3+0x48>
  802711:	39 fe                	cmp    %edi,%esi
  802713:	76 4b                	jbe    802760 <__umoddi3+0x80>
  802715:	89 c8                	mov    %ecx,%eax
  802717:	89 fa                	mov    %edi,%edx
  802719:	f7 f6                	div    %esi
  80271b:	89 d0                	mov    %edx,%eax
  80271d:	31 d2                	xor    %edx,%edx
  80271f:	83 c4 14             	add    $0x14,%esp
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    
  802726:	66 90                	xchg   %ax,%ax
  802728:	39 f8                	cmp    %edi,%eax
  80272a:	77 54                	ja     802780 <__umoddi3+0xa0>
  80272c:	0f bd e8             	bsr    %eax,%ebp
  80272f:	83 f5 1f             	xor    $0x1f,%ebp
  802732:	75 5c                	jne    802790 <__umoddi3+0xb0>
  802734:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802738:	39 3c 24             	cmp    %edi,(%esp)
  80273b:	0f 87 e7 00 00 00    	ja     802828 <__umoddi3+0x148>
  802741:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802745:	29 f1                	sub    %esi,%ecx
  802747:	19 c7                	sbb    %eax,%edi
  802749:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80274d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802751:	8b 44 24 08          	mov    0x8(%esp),%eax
  802755:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802759:	83 c4 14             	add    $0x14,%esp
  80275c:	5e                   	pop    %esi
  80275d:	5f                   	pop    %edi
  80275e:	5d                   	pop    %ebp
  80275f:	c3                   	ret    
  802760:	85 f6                	test   %esi,%esi
  802762:	89 f5                	mov    %esi,%ebp
  802764:	75 0b                	jne    802771 <__umoddi3+0x91>
  802766:	b8 01 00 00 00       	mov    $0x1,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	f7 f6                	div    %esi
  80276f:	89 c5                	mov    %eax,%ebp
  802771:	8b 44 24 04          	mov    0x4(%esp),%eax
  802775:	31 d2                	xor    %edx,%edx
  802777:	f7 f5                	div    %ebp
  802779:	89 c8                	mov    %ecx,%eax
  80277b:	f7 f5                	div    %ebp
  80277d:	eb 9c                	jmp    80271b <__umoddi3+0x3b>
  80277f:	90                   	nop
  802780:	89 c8                	mov    %ecx,%eax
  802782:	89 fa                	mov    %edi,%edx
  802784:	83 c4 14             	add    $0x14,%esp
  802787:	5e                   	pop    %esi
  802788:	5f                   	pop    %edi
  802789:	5d                   	pop    %ebp
  80278a:	c3                   	ret    
  80278b:	90                   	nop
  80278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802790:	8b 04 24             	mov    (%esp),%eax
  802793:	be 20 00 00 00       	mov    $0x20,%esi
  802798:	89 e9                	mov    %ebp,%ecx
  80279a:	29 ee                	sub    %ebp,%esi
  80279c:	d3 e2                	shl    %cl,%edx
  80279e:	89 f1                	mov    %esi,%ecx
  8027a0:	d3 e8                	shr    %cl,%eax
  8027a2:	89 e9                	mov    %ebp,%ecx
  8027a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a8:	8b 04 24             	mov    (%esp),%eax
  8027ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8027af:	89 fa                	mov    %edi,%edx
  8027b1:	d3 e0                	shl    %cl,%eax
  8027b3:	89 f1                	mov    %esi,%ecx
  8027b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8027bd:	d3 ea                	shr    %cl,%edx
  8027bf:	89 e9                	mov    %ebp,%ecx
  8027c1:	d3 e7                	shl    %cl,%edi
  8027c3:	89 f1                	mov    %esi,%ecx
  8027c5:	d3 e8                	shr    %cl,%eax
  8027c7:	89 e9                	mov    %ebp,%ecx
  8027c9:	09 f8                	or     %edi,%eax
  8027cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8027cf:	f7 74 24 04          	divl   0x4(%esp)
  8027d3:	d3 e7                	shl    %cl,%edi
  8027d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027d9:	89 d7                	mov    %edx,%edi
  8027db:	f7 64 24 08          	mull   0x8(%esp)
  8027df:	39 d7                	cmp    %edx,%edi
  8027e1:	89 c1                	mov    %eax,%ecx
  8027e3:	89 14 24             	mov    %edx,(%esp)
  8027e6:	72 2c                	jb     802814 <__umoddi3+0x134>
  8027e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8027ec:	72 22                	jb     802810 <__umoddi3+0x130>
  8027ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8027f2:	29 c8                	sub    %ecx,%eax
  8027f4:	19 d7                	sbb    %edx,%edi
  8027f6:	89 e9                	mov    %ebp,%ecx
  8027f8:	89 fa                	mov    %edi,%edx
  8027fa:	d3 e8                	shr    %cl,%eax
  8027fc:	89 f1                	mov    %esi,%ecx
  8027fe:	d3 e2                	shl    %cl,%edx
  802800:	89 e9                	mov    %ebp,%ecx
  802802:	d3 ef                	shr    %cl,%edi
  802804:	09 d0                	or     %edx,%eax
  802806:	89 fa                	mov    %edi,%edx
  802808:	83 c4 14             	add    $0x14,%esp
  80280b:	5e                   	pop    %esi
  80280c:	5f                   	pop    %edi
  80280d:	5d                   	pop    %ebp
  80280e:	c3                   	ret    
  80280f:	90                   	nop
  802810:	39 d7                	cmp    %edx,%edi
  802812:	75 da                	jne    8027ee <__umoddi3+0x10e>
  802814:	8b 14 24             	mov    (%esp),%edx
  802817:	89 c1                	mov    %eax,%ecx
  802819:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80281d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802821:	eb cb                	jmp    8027ee <__umoddi3+0x10e>
  802823:	90                   	nop
  802824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802828:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80282c:	0f 82 0f ff ff ff    	jb     802741 <__umoddi3+0x61>
  802832:	e9 1a ff ff ff       	jmp    802751 <__umoddi3+0x71>
