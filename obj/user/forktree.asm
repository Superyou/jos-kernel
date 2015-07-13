
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 c2 00 00 00       	call   8000f3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 65 0c 00 00       	call   800ca7 <sys_getenvid>
  800042:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 00 2e 80 00 	movl   $0x802e00,(%esp)
  800051:	e8 a1 01 00 00       	call   8001f7 <cprintf>


	forkchild(cur, '0');
  800056:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80005d:	00 
  80005e:	89 1c 24             	mov    %ebx,(%esp)
  800061:	e8 16 00 00 00       	call   80007c <forkchild>
	forkchild(cur, '1');
  800066:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  80006d:	00 
  80006e:	89 1c 24             	mov    %ebx,(%esp)
  800071:	e8 06 00 00 00       	call   80007c <forkchild>
}
  800076:	83 c4 14             	add    $0x14,%esp
  800079:	5b                   	pop    %ebx
  80007a:	5d                   	pop    %ebp
  80007b:	c3                   	ret    

0080007c <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  80007c:	55                   	push   %ebp
  80007d:	89 e5                	mov    %esp,%ebp
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	83 ec 30             	sub    $0x30,%esp
  800084:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800087:	8b 75 0c             	mov    0xc(%ebp),%esi
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  80008a:	89 1c 24             	mov    %ebx,(%esp)
  80008d:	e8 ae 07 00 00       	call   800840 <strlen>
  800092:	83 f8 02             	cmp    $0x2,%eax
  800095:	7f 41                	jg     8000d8 <forkchild+0x5c>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800097:	89 f0                	mov    %esi,%eax
  800099:	0f be f0             	movsbl %al,%esi
  80009c:	89 74 24 10          	mov    %esi,0x10(%esp)
  8000a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000a4:	c7 44 24 08 11 2e 80 	movl   $0x802e11,0x8(%esp)
  8000ab:	00 
  8000ac:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000b3:	00 
  8000b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000b7:	89 04 24             	mov    %eax,(%esp)
  8000ba:	e8 56 07 00 00       	call   800815 <snprintf>
	if (fork() == 0) {
  8000bf:	e8 3b 11 00 00       	call   8011ff <fork>
  8000c4:	85 c0                	test   %eax,%eax
  8000c6:	75 10                	jne    8000d8 <forkchild+0x5c>
		forktree(nxt);
  8000c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 60 ff ff ff       	call   800033 <forktree>
		exit();
  8000d3:	e8 63 00 00 00       	call   80013b <exit>
	}
}
  8000d8:	83 c4 30             	add    $0x30,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <umain>:
	forkchild(cur, '1');
}

void
umain(int argc, char **argv)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	83 ec 18             	sub    $0x18,%esp
	forktree("");
  8000e5:	c7 04 24 10 2e 80 00 	movl   $0x802e10,(%esp)
  8000ec:	e8 42 ff ff ff       	call   800033 <forktree>
}
  8000f1:	c9                   	leave  
  8000f2:	c3                   	ret    

008000f3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 10             	sub    $0x10,%esp
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800101:	e8 a1 0b 00 00       	call   800ca7 <sys_getenvid>
  800106:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800113:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800118:	85 db                	test   %ebx,%ebx
  80011a:	7e 07                	jle    800123 <libmain+0x30>
		binaryname = argv[0];
  80011c:	8b 06                	mov    (%esi),%eax
  80011e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800123:	89 74 24 04          	mov    %esi,0x4(%esp)
  800127:	89 1c 24             	mov    %ebx,(%esp)
  80012a:	e8 b0 ff ff ff       	call   8000df <umain>

	// exit gracefully
	exit();
  80012f:	e8 07 00 00 00       	call   80013b <exit>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	5b                   	pop    %ebx
  800138:	5e                   	pop    %esi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800141:	e8 34 16 00 00       	call   80177a <close_all>
	sys_env_destroy(0);
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 b1 0a 00 00       	call   800c03 <sys_env_destroy>
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	53                   	push   %ebx
  800158:	83 ec 14             	sub    $0x14,%esp
  80015b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015e:	8b 13                	mov    (%ebx),%edx
  800160:	8d 42 01             	lea    0x1(%edx),%eax
  800163:	89 03                	mov    %eax,(%ebx)
  800165:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800168:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800171:	75 19                	jne    80018c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800173:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80017a:	00 
  80017b:	8d 43 08             	lea    0x8(%ebx),%eax
  80017e:	89 04 24             	mov    %eax,(%esp)
  800181:	e8 40 0a 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  800186:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80018c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800190:	83 c4 14             	add    $0x14,%esp
  800193:	5b                   	pop    %ebx
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    

00800196 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80019f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a6:	00 00 00 
	b.cnt = 0;
  8001a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cb:	c7 04 24 54 01 80 00 	movl   $0x800154,(%esp)
  8001d2:	e8 7d 01 00 00       	call   800354 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e7:	89 04 24             	mov    %eax,(%esp)
  8001ea:	e8 d7 09 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  8001ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	8b 45 08             	mov    0x8(%ebp),%eax
  800207:	89 04 24             	mov    %eax,(%esp)
  80020a:	e8 87 ff ff ff       	call   800196 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020f:	c9                   	leave  
  800210:	c3                   	ret    
  800211:	66 90                	xchg   %ax,%ax
  800213:	66 90                	xchg   %ax,%ax
  800215:	66 90                	xchg   %ax,%ax
  800217:	66 90                	xchg   %ax,%ax
  800219:	66 90                	xchg   %ax,%ax
  80021b:	66 90                	xchg   %ax,%ax
  80021d:	66 90                	xchg   %ax,%ax
  80021f:	90                   	nop

00800220 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	57                   	push   %edi
  800224:	56                   	push   %esi
  800225:	53                   	push   %ebx
  800226:	83 ec 3c             	sub    $0x3c,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80022c:	89 d7                	mov    %edx,%edi
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	89 c3                	mov    %eax,%ebx
  800239:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023c:	8b 45 10             	mov    0x10(%ebp),%eax
  80023f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80024d:	39 d9                	cmp    %ebx,%ecx
  80024f:	72 05                	jb     800256 <printnum+0x36>
  800251:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800254:	77 69                	ja     8002bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800256:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800259:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80025d:	83 ee 01             	sub    $0x1,%esi
  800260:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800264:	89 44 24 08          	mov    %eax,0x8(%esp)
  800268:	8b 44 24 08          	mov    0x8(%esp),%eax
  80026c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800270:	89 c3                	mov    %eax,%ebx
  800272:	89 d6                	mov    %edx,%esi
  800274:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800277:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80027a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 cc 28 00 00       	call   802b60 <__udivdi3>
  800294:	89 d9                	mov    %ebx,%ecx
  800296:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80029a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80029e:	89 04 24             	mov    %eax,(%esp)
  8002a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a5:	89 fa                	mov    %edi,%edx
  8002a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002aa:	e8 71 ff ff ff       	call   800220 <printnum>
  8002af:	eb 1b                	jmp    8002cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	ff d3                	call   *%ebx
  8002bd:	eb 03                	jmp    8002c2 <printnum+0xa2>
  8002bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c2:	83 ee 01             	sub    $0x1,%esi
  8002c5:	85 f6                	test   %esi,%esi
  8002c7:	7f e8                	jg     8002b1 <printnum+0x91>
  8002c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	e8 9c 29 00 00       	call   802c90 <__umoddi3>
  8002f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f8:	0f be 80 20 2e 80 00 	movsbl 0x802e20(%eax),%eax
  8002ff:	89 04 24             	mov    %eax,(%esp)
  800302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800305:	ff d0                	call   *%eax
}
  800307:	83 c4 3c             	add    $0x3c,%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800315:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	3b 50 04             	cmp    0x4(%eax),%edx
  80031e:	73 0a                	jae    80032a <sprintputch+0x1b>
		*b->buf++ = ch;
  800320:	8d 4a 01             	lea    0x1(%edx),%ecx
  800323:	89 08                	mov    %ecx,(%eax)
  800325:	8b 45 08             	mov    0x8(%ebp),%eax
  800328:	88 02                	mov    %al,(%edx)
}
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    

0080032c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800332:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800335:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800339:	8b 45 10             	mov    0x10(%ebp),%eax
  80033c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800340:	8b 45 0c             	mov    0xc(%ebp),%eax
  800343:	89 44 24 04          	mov    %eax,0x4(%esp)
  800347:	8b 45 08             	mov    0x8(%ebp),%eax
  80034a:	89 04 24             	mov    %eax,(%esp)
  80034d:	e8 02 00 00 00       	call   800354 <vprintfmt>
	va_end(ap);
}
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
  80035a:	83 ec 3c             	sub    $0x3c,%esp
  80035d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800360:	eb 17                	jmp    800379 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800362:	85 c0                	test   %eax,%eax
  800364:	0f 84 4b 04 00 00    	je     8007b5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80036a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800371:	89 04 24             	mov    %eax,(%esp)
  800374:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800377:	89 fb                	mov    %edi,%ebx
  800379:	8d 7b 01             	lea    0x1(%ebx),%edi
  80037c:	0f b6 03             	movzbl (%ebx),%eax
  80037f:	83 f8 25             	cmp    $0x25,%eax
  800382:	75 de                	jne    800362 <vprintfmt+0xe>
  800384:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800388:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80038f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800394:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80039b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003a0:	eb 18                	jmp    8003ba <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003a4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8003a8:	eb 10                	jmp    8003ba <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003ac:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8003b0:	eb 08                	jmp    8003ba <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8003b5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8d 5f 01             	lea    0x1(%edi),%ebx
  8003bd:	0f b6 17             	movzbl (%edi),%edx
  8003c0:	0f b6 c2             	movzbl %dl,%eax
  8003c3:	83 ea 23             	sub    $0x23,%edx
  8003c6:	80 fa 55             	cmp    $0x55,%dl
  8003c9:	0f 87 c2 03 00 00    	ja     800791 <vprintfmt+0x43d>
  8003cf:	0f b6 d2             	movzbl %dl,%edx
  8003d2:	ff 24 95 60 2f 80 00 	jmp    *0x802f60(,%edx,4)
  8003d9:	89 df                	mov    %ebx,%edi
  8003db:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003e0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8003e3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8003e7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8003ea:	8d 50 d0             	lea    -0x30(%eax),%edx
  8003ed:	83 fa 09             	cmp    $0x9,%edx
  8003f0:	77 33                	ja     800425 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003f2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003f5:	eb e9                	jmp    8003e0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fa:	8b 30                	mov    (%eax),%esi
  8003fc:	8d 40 04             	lea    0x4(%eax),%eax
  8003ff:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800402:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800404:	eb 1f                	jmp    800425 <vprintfmt+0xd1>
  800406:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800409:	85 ff                	test   %edi,%edi
  80040b:	b8 00 00 00 00       	mov    $0x0,%eax
  800410:	0f 49 c7             	cmovns %edi,%eax
  800413:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800416:	89 df                	mov    %ebx,%edi
  800418:	eb a0                	jmp    8003ba <vprintfmt+0x66>
  80041a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80041c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800423:	eb 95                	jmp    8003ba <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800425:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800429:	79 8f                	jns    8003ba <vprintfmt+0x66>
  80042b:	eb 85                	jmp    8003b2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80042d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800430:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800432:	eb 86                	jmp    8003ba <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8d 70 04             	lea    0x4(%eax),%esi
  80043a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800441:	8b 45 14             	mov    0x14(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	89 04 24             	mov    %eax,(%esp)
  800449:	ff 55 08             	call   *0x8(%ebp)
  80044c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80044f:	e9 25 ff ff ff       	jmp    800379 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 70 04             	lea    0x4(%eax),%esi
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	99                   	cltd   
  80045d:	31 d0                	xor    %edx,%eax
  80045f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800461:	83 f8 15             	cmp    $0x15,%eax
  800464:	7f 0b                	jg     800471 <vprintfmt+0x11d>
  800466:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  80046d:	85 d2                	test   %edx,%edx
  80046f:	75 26                	jne    800497 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800471:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800475:	c7 44 24 08 38 2e 80 	movl   $0x802e38,0x8(%esp)
  80047c:	00 
  80047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800480:	89 44 24 04          	mov    %eax,0x4(%esp)
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	89 04 24             	mov    %eax,(%esp)
  80048a:	e8 9d fe ff ff       	call   80032c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80048f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800492:	e9 e2 fe ff ff       	jmp    800379 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800497:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80049b:	c7 44 24 08 da 32 80 	movl   $0x8032da,0x8(%esp)
  8004a2:	00 
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	89 04 24             	mov    %eax,(%esp)
  8004b0:	e8 77 fe ff ff       	call   80032c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004b5:	89 75 14             	mov    %esi,0x14(%ebp)
  8004b8:	e9 bc fe ff ff       	jmp    800379 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004c6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004ca:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004cc:	85 ff                	test   %edi,%edi
  8004ce:	b8 31 2e 80 00       	mov    $0x802e31,%eax
  8004d3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004d6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8004da:	0f 84 94 00 00 00    	je     800574 <vprintfmt+0x220>
  8004e0:	85 c9                	test   %ecx,%ecx
  8004e2:	0f 8e 94 00 00 00    	jle    80057c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ec:	89 3c 24             	mov    %edi,(%esp)
  8004ef:	e8 64 03 00 00       	call   800858 <strnlen>
  8004f4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8004f7:	29 c1                	sub    %eax,%ecx
  8004f9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8004fc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800500:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800503:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800506:	8b 75 08             	mov    0x8(%ebp),%esi
  800509:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80050c:	89 cb                	mov    %ecx,%ebx
  80050e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800510:	eb 0f                	jmp    800521 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800512:	8b 45 0c             	mov    0xc(%ebp),%eax
  800515:	89 44 24 04          	mov    %eax,0x4(%esp)
  800519:	89 3c 24             	mov    %edi,(%esp)
  80051c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80051e:	83 eb 01             	sub    $0x1,%ebx
  800521:	85 db                	test   %ebx,%ebx
  800523:	7f ed                	jg     800512 <vprintfmt+0x1be>
  800525:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800528:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80052b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80052e:	85 c9                	test   %ecx,%ecx
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	0f 49 c1             	cmovns %ecx,%eax
  800538:	29 c1                	sub    %eax,%ecx
  80053a:	89 cb                	mov    %ecx,%ebx
  80053c:	eb 44                	jmp    800582 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80053e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800542:	74 1e                	je     800562 <vprintfmt+0x20e>
  800544:	0f be d2             	movsbl %dl,%edx
  800547:	83 ea 20             	sub    $0x20,%edx
  80054a:	83 fa 5e             	cmp    $0x5e,%edx
  80054d:	76 13                	jbe    800562 <vprintfmt+0x20e>
					putch('?', putdat);
  80054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800552:	89 44 24 04          	mov    %eax,0x4(%esp)
  800556:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80055d:	ff 55 08             	call   *0x8(%ebp)
  800560:	eb 0d                	jmp    80056f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800562:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800565:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800569:	89 04 24             	mov    %eax,(%esp)
  80056c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80056f:	83 eb 01             	sub    $0x1,%ebx
  800572:	eb 0e                	jmp    800582 <vprintfmt+0x22e>
  800574:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800577:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80057a:	eb 06                	jmp    800582 <vprintfmt+0x22e>
  80057c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80057f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800582:	83 c7 01             	add    $0x1,%edi
  800585:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800589:	0f be c2             	movsbl %dl,%eax
  80058c:	85 c0                	test   %eax,%eax
  80058e:	74 27                	je     8005b7 <vprintfmt+0x263>
  800590:	85 f6                	test   %esi,%esi
  800592:	78 aa                	js     80053e <vprintfmt+0x1ea>
  800594:	83 ee 01             	sub    $0x1,%esi
  800597:	79 a5                	jns    80053e <vprintfmt+0x1ea>
  800599:	89 d8                	mov    %ebx,%eax
  80059b:	8b 75 08             	mov    0x8(%ebp),%esi
  80059e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005a1:	89 c3                	mov    %eax,%ebx
  8005a3:	eb 18                	jmp    8005bd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005b0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005b2:	83 eb 01             	sub    $0x1,%ebx
  8005b5:	eb 06                	jmp    8005bd <vprintfmt+0x269>
  8005b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005bd:	85 db                	test   %ebx,%ebx
  8005bf:	7f e4                	jg     8005a5 <vprintfmt+0x251>
  8005c1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005ca:	e9 aa fd ff ff       	jmp    800379 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005cf:	83 f9 01             	cmp    $0x1,%ecx
  8005d2:	7e 10                	jle    8005e4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8b 30                	mov    (%eax),%esi
  8005d9:	8b 78 04             	mov    0x4(%eax),%edi
  8005dc:	8d 40 08             	lea    0x8(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e2:	eb 26                	jmp    80060a <vprintfmt+0x2b6>
	else if (lflag)
  8005e4:	85 c9                	test   %ecx,%ecx
  8005e6:	74 12                	je     8005fa <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 30                	mov    (%eax),%esi
  8005ed:	89 f7                	mov    %esi,%edi
  8005ef:	c1 ff 1f             	sar    $0x1f,%edi
  8005f2:	8d 40 04             	lea    0x4(%eax),%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f8:	eb 10                	jmp    80060a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 30                	mov    (%eax),%esi
  8005ff:	89 f7                	mov    %esi,%edi
  800601:	c1 ff 1f             	sar    $0x1f,%edi
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060a:	89 f0                	mov    %esi,%eax
  80060c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80060e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800613:	85 ff                	test   %edi,%edi
  800615:	0f 89 3a 01 00 00    	jns    800755 <vprintfmt+0x401>
				putch('-', putdat);
  80061b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800622:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800629:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80062c:	89 f0                	mov    %esi,%eax
  80062e:	89 fa                	mov    %edi,%edx
  800630:	f7 d8                	neg    %eax
  800632:	83 d2 00             	adc    $0x0,%edx
  800635:	f7 da                	neg    %edx
			}
			base = 10;
  800637:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80063c:	e9 14 01 00 00       	jmp    800755 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800641:	83 f9 01             	cmp    $0x1,%ecx
  800644:	7e 13                	jle    800659 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 50 04             	mov    0x4(%eax),%edx
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	8b 75 14             	mov    0x14(%ebp),%esi
  800651:	8d 4e 08             	lea    0x8(%esi),%ecx
  800654:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800657:	eb 2c                	jmp    800685 <vprintfmt+0x331>
	else if (lflag)
  800659:	85 c9                	test   %ecx,%ecx
  80065b:	74 15                	je     800672 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
  800667:	8b 75 14             	mov    0x14(%ebp),%esi
  80066a:	8d 76 04             	lea    0x4(%esi),%esi
  80066d:	89 75 14             	mov    %esi,0x14(%ebp)
  800670:	eb 13                	jmp    800685 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	8b 75 14             	mov    0x14(%ebp),%esi
  80067f:	8d 76 04             	lea    0x4(%esi),%esi
  800682:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800685:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80068a:	e9 c6 00 00 00       	jmp    800755 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7e 13                	jle    8006a7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 50 04             	mov    0x4(%eax),%edx
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	8b 75 14             	mov    0x14(%ebp),%esi
  80069f:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006a2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006a5:	eb 24                	jmp    8006cb <vprintfmt+0x377>
	else if (lflag)
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	74 11                	je     8006bc <vprintfmt+0x368>
		return va_arg(*ap, long);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	99                   	cltd   
  8006b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8006b4:	8d 71 04             	lea    0x4(%ecx),%esi
  8006b7:	89 75 14             	mov    %esi,0x14(%ebp)
  8006ba:	eb 0f                	jmp    8006cb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	99                   	cltd   
  8006c2:	8b 75 14             	mov    0x14(%ebp),%esi
  8006c5:	8d 76 04             	lea    0x4(%esi),%esi
  8006c8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8006cb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006d0:	e9 80 00 00 00       	jmp    800755 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006df:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006e6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006f7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006fa:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006fe:	8b 06                	mov    (%esi),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800705:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80070a:	eb 49                	jmp    800755 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80070c:	83 f9 01             	cmp    $0x1,%ecx
  80070f:	7e 13                	jle    800724 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 50 04             	mov    0x4(%eax),%edx
  800717:	8b 00                	mov    (%eax),%eax
  800719:	8b 75 14             	mov    0x14(%ebp),%esi
  80071c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80071f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800722:	eb 2c                	jmp    800750 <vprintfmt+0x3fc>
	else if (lflag)
  800724:	85 c9                	test   %ecx,%ecx
  800726:	74 15                	je     80073d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
  800732:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800735:	8d 71 04             	lea    0x4(%ecx),%esi
  800738:	89 75 14             	mov    %esi,0x14(%ebp)
  80073b:	eb 13                	jmp    800750 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
  800747:	8b 75 14             	mov    0x14(%ebp),%esi
  80074a:	8d 76 04             	lea    0x4(%esi),%esi
  80074d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800750:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800755:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800759:	89 74 24 10          	mov    %esi,0x10(%esp)
  80075d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800760:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800764:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800768:	89 04 24             	mov    %eax,(%esp)
  80076b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80076f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	e8 a6 fa ff ff       	call   800220 <printnum>
			break;
  80077a:	e9 fa fb ff ff       	jmp    800379 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80077f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800782:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800786:	89 04 24             	mov    %eax,(%esp)
  800789:	ff 55 08             	call   *0x8(%ebp)
			break;
  80078c:	e9 e8 fb ff ff       	jmp    800379 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800791:	8b 45 0c             	mov    0xc(%ebp),%eax
  800794:	89 44 24 04          	mov    %eax,0x4(%esp)
  800798:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80079f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007a2:	89 fb                	mov    %edi,%ebx
  8007a4:	eb 03                	jmp    8007a9 <vprintfmt+0x455>
  8007a6:	83 eb 01             	sub    $0x1,%ebx
  8007a9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007ad:	75 f7                	jne    8007a6 <vprintfmt+0x452>
  8007af:	90                   	nop
  8007b0:	e9 c4 fb ff ff       	jmp    800379 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007b5:	83 c4 3c             	add    $0x3c,%esp
  8007b8:	5b                   	pop    %ebx
  8007b9:	5e                   	pop    %esi
  8007ba:	5f                   	pop    %edi
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	83 ec 28             	sub    $0x28,%esp
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007cc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	74 30                	je     80080e <vsnprintf+0x51>
  8007de:	85 d2                	test   %edx,%edx
  8007e0:	7e 2c                	jle    80080e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f7:	c7 04 24 0f 03 80 00 	movl   $0x80030f,(%esp)
  8007fe:	e8 51 fb ff ff       	call   800354 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800806:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80080c:	eb 05                	jmp    800813 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80080e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800813:	c9                   	leave  
  800814:	c3                   	ret    

00800815 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80081b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80081e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800822:	8b 45 10             	mov    0x10(%ebp),%eax
  800825:	89 44 24 08          	mov    %eax,0x8(%esp)
  800829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	89 04 24             	mov    %eax,(%esp)
  800836:	e8 82 ff ff ff       	call   8007bd <vsnprintf>
	va_end(ap);

	return rc;
}
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    
  80083d:	66 90                	xchg   %ax,%ax
  80083f:	90                   	nop

00800840 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	eb 03                	jmp    800850 <strlen+0x10>
		n++;
  80084d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800850:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800854:	75 f7                	jne    80084d <strlen+0xd>
		n++;
	return n;
}
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800861:	b8 00 00 00 00       	mov    $0x0,%eax
  800866:	eb 03                	jmp    80086b <strnlen+0x13>
		n++;
  800868:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086b:	39 d0                	cmp    %edx,%eax
  80086d:	74 06                	je     800875 <strnlen+0x1d>
  80086f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800873:	75 f3                	jne    800868 <strnlen+0x10>
		n++;
	return n;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800881:	89 c2                	mov    %eax,%edx
  800883:	83 c2 01             	add    $0x1,%edx
  800886:	83 c1 01             	add    $0x1,%ecx
  800889:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80088d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800890:	84 db                	test   %bl,%bl
  800892:	75 ef                	jne    800883 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800894:	5b                   	pop    %ebx
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a1:	89 1c 24             	mov    %ebx,(%esp)
  8008a4:	e8 97 ff ff ff       	call   800840 <strlen>
	strcpy(dst + len, src);
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b0:	01 d8                	add    %ebx,%eax
  8008b2:	89 04 24             	mov    %eax,(%esp)
  8008b5:	e8 bd ff ff ff       	call   800877 <strcpy>
	return dst;
}
  8008ba:	89 d8                	mov    %ebx,%eax
  8008bc:	83 c4 08             	add    $0x8,%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	56                   	push   %esi
  8008c6:	53                   	push   %ebx
  8008c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cd:	89 f3                	mov    %esi,%ebx
  8008cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d2:	89 f2                	mov    %esi,%edx
  8008d4:	eb 0f                	jmp    8008e5 <strncpy+0x23>
		*dst++ = *src;
  8008d6:	83 c2 01             	add    $0x1,%edx
  8008d9:	0f b6 01             	movzbl (%ecx),%eax
  8008dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008df:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e5:	39 da                	cmp    %ebx,%edx
  8008e7:	75 ed                	jne    8008d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008e9:	89 f0                	mov    %esi,%eax
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	56                   	push   %esi
  8008f3:	53                   	push   %ebx
  8008f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008fd:	89 f0                	mov    %esi,%eax
  8008ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800903:	85 c9                	test   %ecx,%ecx
  800905:	75 0b                	jne    800912 <strlcpy+0x23>
  800907:	eb 1d                	jmp    800926 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	83 c2 01             	add    $0x1,%edx
  80090f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800912:	39 d8                	cmp    %ebx,%eax
  800914:	74 0b                	je     800921 <strlcpy+0x32>
  800916:	0f b6 0a             	movzbl (%edx),%ecx
  800919:	84 c9                	test   %cl,%cl
  80091b:	75 ec                	jne    800909 <strlcpy+0x1a>
  80091d:	89 c2                	mov    %eax,%edx
  80091f:	eb 02                	jmp    800923 <strlcpy+0x34>
  800921:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800923:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800926:	29 f0                	sub    %esi,%eax
}
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800935:	eb 06                	jmp    80093d <strcmp+0x11>
		p++, q++;
  800937:	83 c1 01             	add    $0x1,%ecx
  80093a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80093d:	0f b6 01             	movzbl (%ecx),%eax
  800940:	84 c0                	test   %al,%al
  800942:	74 04                	je     800948 <strcmp+0x1c>
  800944:	3a 02                	cmp    (%edx),%al
  800946:	74 ef                	je     800937 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800948:	0f b6 c0             	movzbl %al,%eax
  80094b:	0f b6 12             	movzbl (%edx),%edx
  80094e:	29 d0                	sub    %edx,%eax
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	53                   	push   %ebx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 c3                	mov    %eax,%ebx
  80095e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800961:	eb 06                	jmp    800969 <strncmp+0x17>
		n--, p++, q++;
  800963:	83 c0 01             	add    $0x1,%eax
  800966:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800969:	39 d8                	cmp    %ebx,%eax
  80096b:	74 15                	je     800982 <strncmp+0x30>
  80096d:	0f b6 08             	movzbl (%eax),%ecx
  800970:	84 c9                	test   %cl,%cl
  800972:	74 04                	je     800978 <strncmp+0x26>
  800974:	3a 0a                	cmp    (%edx),%cl
  800976:	74 eb                	je     800963 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 00             	movzbl (%eax),%eax
  80097b:	0f b6 12             	movzbl (%edx),%edx
  80097e:	29 d0                	sub    %edx,%eax
  800980:	eb 05                	jmp    800987 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800994:	eb 07                	jmp    80099d <strchr+0x13>
		if (*s == c)
  800996:	38 ca                	cmp    %cl,%dl
  800998:	74 0f                	je     8009a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80099a:	83 c0 01             	add    $0x1,%eax
  80099d:	0f b6 10             	movzbl (%eax),%edx
  8009a0:	84 d2                	test   %dl,%dl
  8009a2:	75 f2                	jne    800996 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b5:	eb 07                	jmp    8009be <strfind+0x13>
		if (*s == c)
  8009b7:	38 ca                	cmp    %cl,%dl
  8009b9:	74 0a                	je     8009c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	0f b6 10             	movzbl (%eax),%edx
  8009c1:	84 d2                	test   %dl,%dl
  8009c3:	75 f2                	jne    8009b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	74 36                	je     800a0d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009dd:	75 28                	jne    800a07 <memset+0x40>
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	75 23                	jne    800a07 <memset+0x40>
		c &= 0xFF;
  8009e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e8:	89 d3                	mov    %edx,%ebx
  8009ea:	c1 e3 08             	shl    $0x8,%ebx
  8009ed:	89 d6                	mov    %edx,%esi
  8009ef:	c1 e6 18             	shl    $0x18,%esi
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	c1 e0 10             	shl    $0x10,%eax
  8009f7:	09 f0                	or     %esi,%eax
  8009f9:	09 c2                	or     %eax,%edx
  8009fb:	89 d0                	mov    %edx,%eax
  8009fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a02:	fc                   	cld    
  800a03:	f3 ab                	rep stos %eax,%es:(%edi)
  800a05:	eb 06                	jmp    800a0d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	fc                   	cld    
  800a0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5f                   	pop    %edi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a22:	39 c6                	cmp    %eax,%esi
  800a24:	73 35                	jae    800a5b <memmove+0x47>
  800a26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a29:	39 d0                	cmp    %edx,%eax
  800a2b:	73 2e                	jae    800a5b <memmove+0x47>
		s += n;
		d += n;
  800a2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a30:	89 d6                	mov    %edx,%esi
  800a32:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3a:	75 13                	jne    800a4f <memmove+0x3b>
  800a3c:	f6 c1 03             	test   $0x3,%cl
  800a3f:	75 0e                	jne    800a4f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a41:	83 ef 04             	sub    $0x4,%edi
  800a44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a4a:	fd                   	std    
  800a4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4d:	eb 09                	jmp    800a58 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4f:	83 ef 01             	sub    $0x1,%edi
  800a52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a55:	fd                   	std    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a58:	fc                   	cld    
  800a59:	eb 1d                	jmp    800a78 <memmove+0x64>
  800a5b:	89 f2                	mov    %esi,%edx
  800a5d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5f:	f6 c2 03             	test   $0x3,%dl
  800a62:	75 0f                	jne    800a73 <memmove+0x5f>
  800a64:	f6 c1 03             	test   $0x3,%cl
  800a67:	75 0a                	jne    800a73 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a69:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a6c:	89 c7                	mov    %eax,%edi
  800a6e:	fc                   	cld    
  800a6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a71:	eb 05                	jmp    800a78 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a73:	89 c7                	mov    %eax,%edi
  800a75:	fc                   	cld    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
  800a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	89 04 24             	mov    %eax,(%esp)
  800a96:	e8 79 ff ff ff       	call   800a14 <memmove>
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa8:	89 d6                	mov    %edx,%esi
  800aaa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aad:	eb 1a                	jmp    800ac9 <memcmp+0x2c>
		if (*s1 != *s2)
  800aaf:	0f b6 02             	movzbl (%edx),%eax
  800ab2:	0f b6 19             	movzbl (%ecx),%ebx
  800ab5:	38 d8                	cmp    %bl,%al
  800ab7:	74 0a                	je     800ac3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ab9:	0f b6 c0             	movzbl %al,%eax
  800abc:	0f b6 db             	movzbl %bl,%ebx
  800abf:	29 d8                	sub    %ebx,%eax
  800ac1:	eb 0f                	jmp    800ad2 <memcmp+0x35>
		s1++, s2++;
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac9:	39 f2                	cmp    %esi,%edx
  800acb:	75 e2                	jne    800aaf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800adf:	89 c2                	mov    %eax,%edx
  800ae1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae4:	eb 07                	jmp    800aed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae6:	38 08                	cmp    %cl,(%eax)
  800ae8:	74 07                	je     800af1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aea:	83 c0 01             	add    $0x1,%eax
  800aed:	39 d0                	cmp    %edx,%eax
  800aef:	72 f5                	jb     800ae6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	57                   	push   %edi
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	8b 55 08             	mov    0x8(%ebp),%edx
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aff:	eb 03                	jmp    800b04 <strtol+0x11>
		s++;
  800b01:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b04:	0f b6 0a             	movzbl (%edx),%ecx
  800b07:	80 f9 09             	cmp    $0x9,%cl
  800b0a:	74 f5                	je     800b01 <strtol+0xe>
  800b0c:	80 f9 20             	cmp    $0x20,%cl
  800b0f:	74 f0                	je     800b01 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b11:	80 f9 2b             	cmp    $0x2b,%cl
  800b14:	75 0a                	jne    800b20 <strtol+0x2d>
		s++;
  800b16:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1e:	eb 11                	jmp    800b31 <strtol+0x3e>
  800b20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b25:	80 f9 2d             	cmp    $0x2d,%cl
  800b28:	75 07                	jne    800b31 <strtol+0x3e>
		s++, neg = 1;
  800b2a:	8d 52 01             	lea    0x1(%edx),%edx
  800b2d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b31:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b36:	75 15                	jne    800b4d <strtol+0x5a>
  800b38:	80 3a 30             	cmpb   $0x30,(%edx)
  800b3b:	75 10                	jne    800b4d <strtol+0x5a>
  800b3d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b41:	75 0a                	jne    800b4d <strtol+0x5a>
		s += 2, base = 16;
  800b43:	83 c2 02             	add    $0x2,%edx
  800b46:	b8 10 00 00 00       	mov    $0x10,%eax
  800b4b:	eb 10                	jmp    800b5d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	75 0c                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b51:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b53:	80 3a 30             	cmpb   $0x30,(%edx)
  800b56:	75 05                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b62:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b65:	0f b6 0a             	movzbl (%edx),%ecx
  800b68:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b6b:	89 f0                	mov    %esi,%eax
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	77 08                	ja     800b79 <strtol+0x86>
			dig = *s - '0';
  800b71:	0f be c9             	movsbl %cl,%ecx
  800b74:	83 e9 30             	sub    $0x30,%ecx
  800b77:	eb 20                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b79:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	3c 19                	cmp    $0x19,%al
  800b80:	77 08                	ja     800b8a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b82:	0f be c9             	movsbl %cl,%ecx
  800b85:	83 e9 57             	sub    $0x57,%ecx
  800b88:	eb 0f                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b8a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	3c 19                	cmp    $0x19,%al
  800b91:	77 16                	ja     800ba9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b93:	0f be c9             	movsbl %cl,%ecx
  800b96:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b99:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b9c:	7d 0f                	jge    800bad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ba5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ba7:	eb bc                	jmp    800b65 <strtol+0x72>
  800ba9:	89 d8                	mov    %ebx,%eax
  800bab:	eb 02                	jmp    800baf <strtol+0xbc>
  800bad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb3:	74 05                	je     800bba <strtol+0xc7>
		*endptr = (char *) s;
  800bb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bba:	f7 d8                	neg    %eax
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	0f 44 c3             	cmove  %ebx,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	89 c3                	mov    %eax,%ebx
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	89 c6                	mov    %eax,%esi
  800bdd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c11:	b8 03 00 00 00       	mov    $0x3,%eax
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	89 cb                	mov    %ecx,%ebx
  800c1b:	89 cf                	mov    %ecx,%edi
  800c1d:	89 ce                	mov    %ecx,%esi
  800c1f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	7e 28                	jle    800c4d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c29:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c30:	00 
  800c31:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800c38:	00 
  800c39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c40:	00 
  800c41:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800c48:	e8 a9 1c 00 00       	call   8028f6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4d:	83 c4 2c             	add    $0x2c,%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c63:	b8 04 00 00 00       	mov    $0x4,%eax
  800c68:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6b:	89 cb                	mov    %ecx,%ebx
  800c6d:	89 cf                	mov    %ecx,%edi
  800c6f:	89 ce                	mov    %ecx,%esi
  800c71:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c73:	85 c0                	test   %eax,%eax
  800c75:	7e 28                	jle    800c9f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c77:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c7b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c82:	00 
  800c83:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800c8a:	00 
  800c8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c92:	00 
  800c93:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800c9a:	e8 57 1c 00 00       	call   8028f6 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800c9f:	83 c4 2c             	add    $0x2c,%esp
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5f                   	pop    %edi
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	57                   	push   %edi
  800cab:	56                   	push   %esi
  800cac:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cad:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb7:	89 d1                	mov    %edx,%ecx
  800cb9:	89 d3                	mov    %edx,%ebx
  800cbb:	89 d7                	mov    %edx,%edi
  800cbd:	89 d6                	mov    %edx,%esi
  800cbf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <sys_yield>:

void
sys_yield(void)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cd6:	89 d1                	mov    %edx,%ecx
  800cd8:	89 d3                	mov    %edx,%ebx
  800cda:	89 d7                	mov    %edx,%edi
  800cdc:	89 d6                	mov    %edx,%esi
  800cde:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cee:	be 00 00 00 00       	mov    $0x0,%esi
  800cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d01:	89 f7                	mov    %esi,%edi
  800d03:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d05:	85 c0                	test   %eax,%eax
  800d07:	7e 28                	jle    800d31 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d09:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d14:	00 
  800d15:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800d1c:	00 
  800d1d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d24:	00 
  800d25:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800d2c:	e8 c5 1b 00 00       	call   8028f6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d31:	83 c4 2c             	add    $0x2c,%esp
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d42:	b8 06 00 00 00       	mov    $0x6,%eax
  800d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d50:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d53:	8b 75 18             	mov    0x18(%ebp),%esi
  800d56:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	7e 28                	jle    800d84 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d60:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d67:	00 
  800d68:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800d6f:	00 
  800d70:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d77:	00 
  800d78:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800d7f:	e8 72 1b 00 00       	call   8028f6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d84:	83 c4 2c             	add    $0x2c,%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9a:	b8 07 00 00 00       	mov    $0x7,%eax
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	89 df                	mov    %ebx,%edi
  800da7:	89 de                	mov    %ebx,%esi
  800da9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	7e 28                	jle    800dd7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800dba:	00 
  800dbb:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800dc2:	00 
  800dc3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dca:	00 
  800dcb:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800dd2:	e8 1f 1b 00 00       	call   8028f6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd7:	83 c4 2c             	add    $0x2c,%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dea:	b8 10 00 00 00       	mov    $0x10,%eax
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	89 cb                	mov    %ecx,%ebx
  800df4:	89 cf                	mov    %ecx,%edi
  800df6:	89 ce                	mov    %ecx,%esi
  800df8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    

00800dff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	57                   	push   %edi
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
  800e05:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	89 df                	mov    %ebx,%edi
  800e1a:	89 de                	mov    %ebx,%esi
  800e1c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	7e 28                	jle    800e4a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e22:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e26:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e2d:	00 
  800e2e:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800e35:	00 
  800e36:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3d:	00 
  800e3e:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800e45:	e8 ac 1a 00 00       	call   8028f6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e4a:	83 c4 2c             	add    $0x2c,%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e60:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6b:	89 df                	mov    %ebx,%edi
  800e6d:	89 de                	mov    %ebx,%esi
  800e6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	7e 28                	jle    800e9d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e79:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e80:	00 
  800e81:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800e88:	00 
  800e89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e90:	00 
  800e91:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800e98:	e8 59 1a 00 00       	call   8028f6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e9d:	83 c4 2c             	add    $0x2c,%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    

00800ea5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	89 df                	mov    %ebx,%edi
  800ec0:	89 de                	mov    %ebx,%esi
  800ec2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7e 28                	jle    800ef0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800ed3:	00 
  800ed4:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800edb:	00 
  800edc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee3:	00 
  800ee4:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800eeb:	e8 06 1a 00 00       	call   8028f6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef0:	83 c4 2c             	add    $0x2c,%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efe:	be 00 00 00 00       	mov    $0x0,%esi
  800f03:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f11:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f14:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
  800f21:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f24:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f29:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	89 cb                	mov    %ecx,%ebx
  800f33:	89 cf                	mov    %ecx,%edi
  800f35:	89 ce                	mov    %ecx,%esi
  800f37:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7e 28                	jle    800f65 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f41:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f48:	00 
  800f49:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800f50:	00 
  800f51:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f58:	00 
  800f59:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800f60:	e8 91 19 00 00       	call   8028f6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f65:	83 c4 2c             	add    $0x2c,%esp
  800f68:	5b                   	pop    %ebx
  800f69:	5e                   	pop    %esi
  800f6a:	5f                   	pop    %edi
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	57                   	push   %edi
  800f71:	56                   	push   %esi
  800f72:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f73:	ba 00 00 00 00       	mov    $0x0,%edx
  800f78:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7d:	89 d1                	mov    %edx,%ecx
  800f7f:	89 d3                	mov    %edx,%ebx
  800f81:	89 d7                	mov    %edx,%edi
  800f83:	89 d6                	mov    %edx,%esi
  800f85:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f87:	5b                   	pop    %ebx
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f97:	b8 11 00 00 00       	mov    $0x11,%eax
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	89 df                	mov    %ebx,%edi
  800fa4:	89 de                	mov    %ebx,%esi
  800fa6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb8:	b8 12 00 00 00       	mov    $0x12,%eax
  800fbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc3:	89 df                	mov    %ebx,%edi
  800fc5:	89 de                	mov    %ebx,%esi
  800fc7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd9:	b8 13 00 00 00       	mov    $0x13,%eax
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	89 cb                	mov    %ecx,%ebx
  800fe3:	89 cf                	mov    %ecx,%edi
  800fe5:	89 ce                	mov    %ecx,%esi
  800fe7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800fe9:	5b                   	pop    %ebx
  800fea:	5e                   	pop    %esi
  800feb:	5f                   	pop    %edi
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    

00800fee <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 2c             	sub    $0x2c,%esp
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ffa:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  800ffc:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  800fff:	89 f8                	mov    %edi,%eax
  801001:	c1 e8 0c             	shr    $0xc,%eax
  801004:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801007:	e8 9b fc ff ff       	call   800ca7 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80100c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801012:	0f 84 de 00 00 00    	je     8010f6 <pgfault+0x108>
  801018:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80101a:	85 c0                	test   %eax,%eax
  80101c:	79 20                	jns    80103e <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80101e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801022:	c7 44 24 08 62 31 80 	movl   $0x803162,0x8(%esp)
  801029:	00 
  80102a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801031:	00 
  801032:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  801039:	e8 b8 18 00 00       	call   8028f6 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  80103e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801041:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801048:	25 05 08 00 00       	and    $0x805,%eax
  80104d:	3d 05 08 00 00       	cmp    $0x805,%eax
  801052:	0f 85 ba 00 00 00    	jne    801112 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801058:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80105f:	00 
  801060:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801067:	00 
  801068:	89 1c 24             	mov    %ebx,(%esp)
  80106b:	e8 75 fc ff ff       	call   800ce5 <sys_page_alloc>
  801070:	85 c0                	test   %eax,%eax
  801072:	79 20                	jns    801094 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801074:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801078:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80107f:	00 
  801080:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801087:	00 
  801088:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80108f:	e8 62 18 00 00       	call   8028f6 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801094:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80109a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010a1:	00 
  8010a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010a6:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010ad:	e8 62 f9 ff ff       	call   800a14 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  8010b2:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010b9:	00 
  8010ba:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010c2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010c9:	00 
  8010ca:	89 1c 24             	mov    %ebx,(%esp)
  8010cd:	e8 67 fc ff ff       	call   800d39 <sys_page_map>
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	79 3c                	jns    801112 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  8010d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010da:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  8010e1:	00 
  8010e2:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8010e9:	00 
  8010ea:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8010f1:	e8 00 18 00 00       	call   8028f6 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  8010f6:	c7 44 24 08 c0 31 80 	movl   $0x8031c0,0x8(%esp)
  8010fd:	00 
  8010fe:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801105:	00 
  801106:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80110d:	e8 e4 17 00 00       	call   8028f6 <_panic>
}
  801112:	83 c4 2c             	add    $0x2c,%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
  80111f:	83 ec 20             	sub    $0x20,%esp
  801122:	8b 75 08             	mov    0x8(%ebp),%esi
  801125:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801128:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80112f:	00 
  801130:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801134:	89 34 24             	mov    %esi,(%esp)
  801137:	e8 a9 fb ff ff       	call   800ce5 <sys_page_alloc>
  80113c:	85 c0                	test   %eax,%eax
  80113e:	79 20                	jns    801160 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801140:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801144:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80115b:	e8 96 17 00 00       	call   8028f6 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801160:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801167:	00 
  801168:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  80116f:	00 
  801170:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801177:	00 
  801178:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80117c:	89 34 24             	mov    %esi,(%esp)
  80117f:	e8 b5 fb ff ff       	call   800d39 <sys_page_map>
  801184:	85 c0                	test   %eax,%eax
  801186:	79 20                	jns    8011a8 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801188:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80118c:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  801193:	00 
  801194:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80119b:	00 
  80119c:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8011a3:	e8 4e 17 00 00       	call   8028f6 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8011a8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011af:	00 
  8011b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011b4:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8011bb:	e8 54 f8 ff ff       	call   800a14 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8011c0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8011c7:	00 
  8011c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011cf:	e8 b8 fb ff ff       	call   800d8c <sys_page_unmap>
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	79 20                	jns    8011f8 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8011d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011dc:	c7 44 24 08 ad 31 80 	movl   $0x8031ad,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8011f3:	e8 fe 16 00 00       	call   8028f6 <_panic>

}
  8011f8:	83 c4 20             	add    $0x20,%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    

008011ff <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
  801205:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801208:	c7 04 24 ee 0f 80 00 	movl   $0x800fee,(%esp)
  80120f:	e8 38 17 00 00       	call   80294c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801214:	b8 08 00 00 00       	mov    $0x8,%eax
  801219:	cd 30                	int    $0x30
  80121b:	89 c6                	mov    %eax,%esi
  80121d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801220:	85 c0                	test   %eax,%eax
  801222:	79 20                	jns    801244 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801224:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801228:	c7 44 24 08 e4 31 80 	movl   $0x8031e4,0x8(%esp)
  80122f:	00 
  801230:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801237:	00 
  801238:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80123f:	e8 b2 16 00 00       	call   8028f6 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801244:	bb 00 00 00 00       	mov    $0x0,%ebx
  801249:	85 c0                	test   %eax,%eax
  80124b:	75 21                	jne    80126e <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80124d:	e8 55 fa ff ff       	call   800ca7 <sys_getenvid>
  801252:	25 ff 03 00 00       	and    $0x3ff,%eax
  801257:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80125a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80125f:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
  801269:	e9 88 01 00 00       	jmp    8013f6 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  80126e:	89 d8                	mov    %ebx,%eax
  801270:	c1 e8 16             	shr    $0x16,%eax
  801273:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80127a:	a8 01                	test   $0x1,%al
  80127c:	0f 84 e0 00 00 00    	je     801362 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801282:	89 df                	mov    %ebx,%edi
  801284:	c1 ef 0c             	shr    $0xc,%edi
  801287:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80128e:	a8 01                	test   $0x1,%al
  801290:	0f 84 c4 00 00 00    	je     80135a <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801296:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80129d:	f6 c4 04             	test   $0x4,%ah
  8012a0:	74 0d                	je     8012af <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  8012a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a7:	83 c8 05             	or     $0x5,%eax
  8012aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012ad:	eb 1b                	jmp    8012ca <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  8012af:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  8012b4:	83 f8 01             	cmp    $0x1,%eax
  8012b7:	19 c0                	sbb    %eax,%eax
  8012b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012bc:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  8012c3:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8012ca:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8012cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012df:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ea:	e8 4a fa ff ff       	call   800d39 <sys_page_map>
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	79 20                	jns    801313 <fork+0x114>
		panic("sys_page_map: %e", r);
  8012f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f7:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801306:	00 
  801307:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80130e:	e8 e3 15 00 00       	call   8028f6 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801316:	89 44 24 10          	mov    %eax,0x10(%esp)
  80131a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80131e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801325:	00 
  801326:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80132a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801331:	e8 03 fa ff ff       	call   800d39 <sys_page_map>
  801336:	85 c0                	test   %eax,%eax
  801338:	79 20                	jns    80135a <fork+0x15b>
		panic("sys_page_map: %e", r);
  80133a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133e:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  801345:	00 
  801346:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  80134d:	00 
  80134e:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  801355:	e8 9c 15 00 00       	call   8028f6 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  80135a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801360:	eb 06                	jmp    801368 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801362:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801368:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  80136e:	0f 86 fa fe ff ff    	jbe    80126e <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801374:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80137b:	00 
  80137c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801383:	ee 
  801384:	89 34 24             	mov    %esi,(%esp)
  801387:	e8 59 f9 ff ff       	call   800ce5 <sys_page_alloc>
  80138c:	85 c0                	test   %eax,%eax
  80138e:	79 20                	jns    8013b0 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801390:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801394:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80139b:	00 
  80139c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  8013a3:	00 
  8013a4:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8013ab:	e8 46 15 00 00       	call   8028f6 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8013b0:	c7 44 24 04 df 29 80 	movl   $0x8029df,0x4(%esp)
  8013b7:	00 
  8013b8:	89 34 24             	mov    %esi,(%esp)
  8013bb:	e8 e5 fa ff ff       	call   800ea5 <sys_env_set_pgfault_upcall>
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	79 20                	jns    8013e4 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  8013c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013c8:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  8013cf:	00 
  8013d0:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  8013d7:	00 
  8013d8:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8013df:	e8 12 15 00 00       	call   8028f6 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8013e4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013eb:	00 
  8013ec:	89 34 24             	mov    %esi,(%esp)
  8013ef:	e8 0b fa ff ff       	call   800dff <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  8013f4:	89 f0                	mov    %esi,%eax

}
  8013f6:	83 c4 2c             	add    $0x2c,%esp
  8013f9:	5b                   	pop    %ebx
  8013fa:	5e                   	pop    %esi
  8013fb:	5f                   	pop    %edi
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <sfork>:

// Challenge!
int
sfork(void)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	57                   	push   %edi
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
  801404:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801407:	c7 04 24 ee 0f 80 00 	movl   $0x800fee,(%esp)
  80140e:	e8 39 15 00 00       	call   80294c <set_pgfault_handler>
  801413:	b8 08 00 00 00       	mov    $0x8,%eax
  801418:	cd 30                	int    $0x30
  80141a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80141c:	85 c0                	test   %eax,%eax
  80141e:	79 20                	jns    801440 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801420:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801424:	c7 44 24 08 e4 31 80 	movl   $0x8031e4,0x8(%esp)
  80142b:	00 
  80142c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801433:	00 
  801434:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80143b:	e8 b6 14 00 00       	call   8028f6 <_panic>
  801440:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801442:	bb 00 00 00 00       	mov    $0x0,%ebx
  801447:	85 c0                	test   %eax,%eax
  801449:	75 2d                	jne    801478 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80144b:	e8 57 f8 ff ff       	call   800ca7 <sys_getenvid>
  801450:	25 ff 03 00 00       	and    $0x3ff,%eax
  801455:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801458:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80145d:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  801462:	c7 04 24 ee 0f 80 00 	movl   $0x800fee,(%esp)
  801469:	e8 de 14 00 00       	call   80294c <set_pgfault_handler>
		return 0;
  80146e:	b8 00 00 00 00       	mov    $0x0,%eax
  801473:	e9 1d 01 00 00       	jmp    801595 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801478:	89 d8                	mov    %ebx,%eax
  80147a:	c1 e8 16             	shr    $0x16,%eax
  80147d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801484:	a8 01                	test   $0x1,%al
  801486:	74 69                	je     8014f1 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801488:	89 d8                	mov    %ebx,%eax
  80148a:	c1 e8 0c             	shr    $0xc,%eax
  80148d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801494:	f6 c2 01             	test   $0x1,%dl
  801497:	74 50                	je     8014e9 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801499:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8014a0:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  8014a3:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8014a9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014b1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c0:	e8 74 f8 ff ff       	call   800d39 <sys_page_map>
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	79 20                	jns    8014e9 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  8014c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014cd:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  8014d4:	00 
  8014d5:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8014dc:	00 
  8014dd:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8014e4:	e8 0d 14 00 00       	call   8028f6 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8014e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014ef:	eb 06                	jmp    8014f7 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  8014f1:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  8014f7:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  8014fd:	0f 86 75 ff ff ff    	jbe    801478 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801503:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80150a:	ee 
  80150b:	89 34 24             	mov    %esi,(%esp)
  80150e:	e8 07 fc ff ff       	call   80111a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801513:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80151a:	00 
  80151b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801522:	ee 
  801523:	89 34 24             	mov    %esi,(%esp)
  801526:	e8 ba f7 ff ff       	call   800ce5 <sys_page_alloc>
  80152b:	85 c0                	test   %eax,%eax
  80152d:	79 20                	jns    80154f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80152f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801533:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80153a:	00 
  80153b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801542:	00 
  801543:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80154a:	e8 a7 13 00 00       	call   8028f6 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80154f:	c7 44 24 04 df 29 80 	movl   $0x8029df,0x4(%esp)
  801556:	00 
  801557:	89 34 24             	mov    %esi,(%esp)
  80155a:	e8 46 f9 ff ff       	call   800ea5 <sys_env_set_pgfault_upcall>
  80155f:	85 c0                	test   %eax,%eax
  801561:	79 20                	jns    801583 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801563:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801567:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  80156e:	00 
  80156f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801576:	00 
  801577:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80157e:	e8 73 13 00 00       	call   8028f6 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801583:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80158a:	00 
  80158b:	89 34 24             	mov    %esi,(%esp)
  80158e:	e8 6c f8 ff ff       	call   800dff <sys_env_set_status>
	return envid;
  801593:	89 f0                	mov    %esi,%eax

}
  801595:	83 c4 2c             	add    $0x2c,%esp
  801598:	5b                   	pop    %ebx
  801599:	5e                   	pop    %esi
  80159a:	5f                   	pop    %edi
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    
  80159d:	66 90                	xchg   %ax,%ax
  80159f:	90                   	nop

008015a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    

008015b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8015bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    

008015c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	c1 ea 16             	shr    $0x16,%edx
  8015d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015de:	f6 c2 01             	test   $0x1,%dl
  8015e1:	74 11                	je     8015f4 <fd_alloc+0x2d>
  8015e3:	89 c2                	mov    %eax,%edx
  8015e5:	c1 ea 0c             	shr    $0xc,%edx
  8015e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ef:	f6 c2 01             	test   $0x1,%dl
  8015f2:	75 09                	jne    8015fd <fd_alloc+0x36>
			*fd_store = fd;
  8015f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fb:	eb 17                	jmp    801614 <fd_alloc+0x4d>
  8015fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801602:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801607:	75 c9                	jne    8015d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801609:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80160f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80161c:	83 f8 1f             	cmp    $0x1f,%eax
  80161f:	77 36                	ja     801657 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801621:	c1 e0 0c             	shl    $0xc,%eax
  801624:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801629:	89 c2                	mov    %eax,%edx
  80162b:	c1 ea 16             	shr    $0x16,%edx
  80162e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801635:	f6 c2 01             	test   $0x1,%dl
  801638:	74 24                	je     80165e <fd_lookup+0x48>
  80163a:	89 c2                	mov    %eax,%edx
  80163c:	c1 ea 0c             	shr    $0xc,%edx
  80163f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801646:	f6 c2 01             	test   $0x1,%dl
  801649:	74 1a                	je     801665 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80164b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164e:	89 02                	mov    %eax,(%edx)
	return 0;
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
  801655:	eb 13                	jmp    80166a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165c:	eb 0c                	jmp    80166a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80165e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801663:	eb 05                	jmp    80166a <fd_lookup+0x54>
  801665:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 18             	sub    $0x18,%esp
  801672:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801675:	ba 00 00 00 00       	mov    $0x0,%edx
  80167a:	eb 13                	jmp    80168f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80167c:	39 08                	cmp    %ecx,(%eax)
  80167e:	75 0c                	jne    80168c <dev_lookup+0x20>
			*dev = devtab[i];
  801680:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801683:	89 01                	mov    %eax,(%ecx)
			return 0;
  801685:	b8 00 00 00 00       	mov    $0x0,%eax
  80168a:	eb 38                	jmp    8016c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80168c:	83 c2 01             	add    $0x1,%edx
  80168f:	8b 04 95 a8 32 80 00 	mov    0x8032a8(,%edx,4),%eax
  801696:	85 c0                	test   %eax,%eax
  801698:	75 e2                	jne    80167c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80169a:	a1 08 50 80 00       	mov    0x805008,%eax
  80169f:	8b 40 48             	mov    0x48(%eax),%eax
  8016a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016aa:	c7 04 24 2c 32 80 00 	movl   $0x80322c,(%esp)
  8016b1:	e8 41 eb ff ff       	call   8001f7 <cprintf>
	*dev = 0;
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 20             	sub    $0x20,%esp
  8016ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8016d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e4:	89 04 24             	mov    %eax,(%esp)
  8016e7:	e8 2a ff ff ff       	call   801616 <fd_lookup>
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 05                	js     8016f5 <fd_close+0x2f>
	    || fd != fd2)
  8016f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016f3:	74 0c                	je     801701 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016f5:	84 db                	test   %bl,%bl
  8016f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fc:	0f 44 c2             	cmove  %edx,%eax
  8016ff:	eb 3f                	jmp    801740 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801701:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801704:	89 44 24 04          	mov    %eax,0x4(%esp)
  801708:	8b 06                	mov    (%esi),%eax
  80170a:	89 04 24             	mov    %eax,(%esp)
  80170d:	e8 5a ff ff ff       	call   80166c <dev_lookup>
  801712:	89 c3                	mov    %eax,%ebx
  801714:	85 c0                	test   %eax,%eax
  801716:	78 16                	js     80172e <fd_close+0x68>
		if (dev->dev_close)
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80171e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801723:	85 c0                	test   %eax,%eax
  801725:	74 07                	je     80172e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801727:	89 34 24             	mov    %esi,(%esp)
  80172a:	ff d0                	call   *%eax
  80172c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80172e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801732:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801739:	e8 4e f6 ff ff       	call   800d8c <sys_page_unmap>
	return r;
  80173e:	89 d8                	mov    %ebx,%eax
}
  801740:	83 c4 20             	add    $0x20,%esp
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    

00801747 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801750:	89 44 24 04          	mov    %eax,0x4(%esp)
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	89 04 24             	mov    %eax,(%esp)
  80175a:	e8 b7 fe ff ff       	call   801616 <fd_lookup>
  80175f:	89 c2                	mov    %eax,%edx
  801761:	85 d2                	test   %edx,%edx
  801763:	78 13                	js     801778 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801765:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80176c:	00 
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	89 04 24             	mov    %eax,(%esp)
  801773:	e8 4e ff ff ff       	call   8016c6 <fd_close>
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <close_all>:

void
close_all(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	53                   	push   %ebx
  80177e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801781:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801786:	89 1c 24             	mov    %ebx,(%esp)
  801789:	e8 b9 ff ff ff       	call   801747 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80178e:	83 c3 01             	add    $0x1,%ebx
  801791:	83 fb 20             	cmp    $0x20,%ebx
  801794:	75 f0                	jne    801786 <close_all+0xc>
		close(i);
}
  801796:	83 c4 14             	add    $0x14,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5d                   	pop    %ebp
  80179b:	c3                   	ret    

0080179c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	57                   	push   %edi
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 04 24             	mov    %eax,(%esp)
  8017b2:	e8 5f fe ff ff       	call   801616 <fd_lookup>
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	85 d2                	test   %edx,%edx
  8017bb:	0f 88 e1 00 00 00    	js     8018a2 <dup+0x106>
		return r;
	close(newfdnum);
  8017c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c4:	89 04 24             	mov    %eax,(%esp)
  8017c7:	e8 7b ff ff ff       	call   801747 <close>

	newfd = INDEX2FD(newfdnum);
  8017cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017cf:	c1 e3 0c             	shl    $0xc,%ebx
  8017d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017db:	89 04 24             	mov    %eax,(%esp)
  8017de:	e8 cd fd ff ff       	call   8015b0 <fd2data>
  8017e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017e5:	89 1c 24             	mov    %ebx,(%esp)
  8017e8:	e8 c3 fd ff ff       	call   8015b0 <fd2data>
  8017ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017ef:	89 f0                	mov    %esi,%eax
  8017f1:	c1 e8 16             	shr    $0x16,%eax
  8017f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017fb:	a8 01                	test   $0x1,%al
  8017fd:	74 43                	je     801842 <dup+0xa6>
  8017ff:	89 f0                	mov    %esi,%eax
  801801:	c1 e8 0c             	shr    $0xc,%eax
  801804:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80180b:	f6 c2 01             	test   $0x1,%dl
  80180e:	74 32                	je     801842 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801810:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801817:	25 07 0e 00 00       	and    $0xe07,%eax
  80181c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801820:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801824:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80182b:	00 
  80182c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801830:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801837:	e8 fd f4 ff ff       	call   800d39 <sys_page_map>
  80183c:	89 c6                	mov    %eax,%esi
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 3e                	js     801880 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801845:	89 c2                	mov    %eax,%edx
  801847:	c1 ea 0c             	shr    $0xc,%edx
  80184a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801851:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801857:	89 54 24 10          	mov    %edx,0x10(%esp)
  80185b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80185f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801866:	00 
  801867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801872:	e8 c2 f4 ff ff       	call   800d39 <sys_page_map>
  801877:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80187c:	85 f6                	test   %esi,%esi
  80187e:	79 22                	jns    8018a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801880:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801884:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80188b:	e8 fc f4 ff ff       	call   800d8c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801890:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80189b:	e8 ec f4 ff ff       	call   800d8c <sys_page_unmap>
	return r;
  8018a0:	89 f0                	mov    %esi,%eax
}
  8018a2:	83 c4 3c             	add    $0x3c,%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 24             	sub    $0x24,%esp
  8018b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bb:	89 1c 24             	mov    %ebx,(%esp)
  8018be:	e8 53 fd ff ff       	call   801616 <fd_lookup>
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	85 d2                	test   %edx,%edx
  8018c7:	78 6d                	js     801936 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d3:	8b 00                	mov    (%eax),%eax
  8018d5:	89 04 24             	mov    %eax,(%esp)
  8018d8:	e8 8f fd ff ff       	call   80166c <dev_lookup>
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 55                	js     801936 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e4:	8b 50 08             	mov    0x8(%eax),%edx
  8018e7:	83 e2 03             	and    $0x3,%edx
  8018ea:	83 fa 01             	cmp    $0x1,%edx
  8018ed:	75 23                	jne    801912 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8018f4:	8b 40 48             	mov    0x48(%eax),%eax
  8018f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	c7 04 24 6d 32 80 00 	movl   $0x80326d,(%esp)
  801906:	e8 ec e8 ff ff       	call   8001f7 <cprintf>
		return -E_INVAL;
  80190b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801910:	eb 24                	jmp    801936 <read+0x8c>
	}
	if (!dev->dev_read)
  801912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801915:	8b 52 08             	mov    0x8(%edx),%edx
  801918:	85 d2                	test   %edx,%edx
  80191a:	74 15                	je     801931 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80191c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801926:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80192a:	89 04 24             	mov    %eax,(%esp)
  80192d:	ff d2                	call   *%edx
  80192f:	eb 05                	jmp    801936 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801931:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801936:	83 c4 24             	add    $0x24,%esp
  801939:	5b                   	pop    %ebx
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	57                   	push   %edi
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	83 ec 1c             	sub    $0x1c,%esp
  801945:	8b 7d 08             	mov    0x8(%ebp),%edi
  801948:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80194b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801950:	eb 23                	jmp    801975 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801952:	89 f0                	mov    %esi,%eax
  801954:	29 d8                	sub    %ebx,%eax
  801956:	89 44 24 08          	mov    %eax,0x8(%esp)
  80195a:	89 d8                	mov    %ebx,%eax
  80195c:	03 45 0c             	add    0xc(%ebp),%eax
  80195f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801963:	89 3c 24             	mov    %edi,(%esp)
  801966:	e8 3f ff ff ff       	call   8018aa <read>
		if (m < 0)
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 10                	js     80197f <readn+0x43>
			return m;
		if (m == 0)
  80196f:	85 c0                	test   %eax,%eax
  801971:	74 0a                	je     80197d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801973:	01 c3                	add    %eax,%ebx
  801975:	39 f3                	cmp    %esi,%ebx
  801977:	72 d9                	jb     801952 <readn+0x16>
  801979:	89 d8                	mov    %ebx,%eax
  80197b:	eb 02                	jmp    80197f <readn+0x43>
  80197d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80197f:	83 c4 1c             	add    $0x1c,%esp
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5f                   	pop    %edi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	53                   	push   %ebx
  80198b:	83 ec 24             	sub    $0x24,%esp
  80198e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801991:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	89 1c 24             	mov    %ebx,(%esp)
  80199b:	e8 76 fc ff ff       	call   801616 <fd_lookup>
  8019a0:	89 c2                	mov    %eax,%edx
  8019a2:	85 d2                	test   %edx,%edx
  8019a4:	78 68                	js     801a0e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	89 04 24             	mov    %eax,(%esp)
  8019b5:	e8 b2 fc ff ff       	call   80166c <dev_lookup>
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 50                	js     801a0e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019c5:	75 23                	jne    8019ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8019cc:	8b 40 48             	mov    0x48(%eax),%eax
  8019cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	c7 04 24 89 32 80 00 	movl   $0x803289,(%esp)
  8019de:	e8 14 e8 ff ff       	call   8001f7 <cprintf>
		return -E_INVAL;
  8019e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e8:	eb 24                	jmp    801a0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8019f0:	85 d2                	test   %edx,%edx
  8019f2:	74 15                	je     801a09 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a02:	89 04 24             	mov    %eax,(%esp)
  801a05:	ff d2                	call   *%edx
  801a07:	eb 05                	jmp    801a0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a0e:	83 c4 24             	add    $0x24,%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    

00801a14 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a1a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	e8 ea fb ff ff       	call   801616 <fd_lookup>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 0e                	js     801a3e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 24             	sub    $0x24,%esp
  801a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a51:	89 1c 24             	mov    %ebx,(%esp)
  801a54:	e8 bd fb ff ff       	call   801616 <fd_lookup>
  801a59:	89 c2                	mov    %eax,%edx
  801a5b:	85 d2                	test   %edx,%edx
  801a5d:	78 61                	js     801ac0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a69:	8b 00                	mov    (%eax),%eax
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	e8 f9 fb ff ff       	call   80166c <dev_lookup>
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 49                	js     801ac0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7e:	75 23                	jne    801aa3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a80:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a85:	8b 40 48             	mov    0x48(%eax),%eax
  801a88:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a90:	c7 04 24 4c 32 80 00 	movl   $0x80324c,(%esp)
  801a97:	e8 5b e7 ff ff       	call   8001f7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aa1:	eb 1d                	jmp    801ac0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa6:	8b 52 18             	mov    0x18(%edx),%edx
  801aa9:	85 d2                	test   %edx,%edx
  801aab:	74 0e                	je     801abb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801aad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab4:	89 04 24             	mov    %eax,(%esp)
  801ab7:	ff d2                	call   *%edx
  801ab9:	eb 05                	jmp    801ac0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801abb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801ac0:	83 c4 24             	add    $0x24,%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5d                   	pop    %ebp
  801ac5:	c3                   	ret    

00801ac6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	53                   	push   %ebx
  801aca:	83 ec 24             	sub    $0x24,%esp
  801acd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	89 04 24             	mov    %eax,(%esp)
  801add:	e8 34 fb ff ff       	call   801616 <fd_lookup>
  801ae2:	89 c2                	mov    %eax,%edx
  801ae4:	85 d2                	test   %edx,%edx
  801ae6:	78 52                	js     801b3a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af2:	8b 00                	mov    (%eax),%eax
  801af4:	89 04 24             	mov    %eax,(%esp)
  801af7:	e8 70 fb ff ff       	call   80166c <dev_lookup>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 3a                	js     801b3a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b03:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b07:	74 2c                	je     801b35 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b09:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b0c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b13:	00 00 00 
	stat->st_isdir = 0;
  801b16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b1d:	00 00 00 
	stat->st_dev = dev;
  801b20:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b2d:	89 14 24             	mov    %edx,(%esp)
  801b30:	ff 50 14             	call   *0x14(%eax)
  801b33:	eb 05                	jmp    801b3a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b3a:	83 c4 24             	add    $0x24,%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	56                   	push   %esi
  801b44:	53                   	push   %ebx
  801b45:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b4f:	00 
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	89 04 24             	mov    %eax,(%esp)
  801b56:	e8 99 02 00 00       	call   801df4 <open>
  801b5b:	89 c3                	mov    %eax,%ebx
  801b5d:	85 db                	test   %ebx,%ebx
  801b5f:	78 1b                	js     801b7c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b68:	89 1c 24             	mov    %ebx,(%esp)
  801b6b:	e8 56 ff ff ff       	call   801ac6 <fstat>
  801b70:	89 c6                	mov    %eax,%esi
	close(fd);
  801b72:	89 1c 24             	mov    %ebx,(%esp)
  801b75:	e8 cd fb ff ff       	call   801747 <close>
	return r;
  801b7a:	89 f0                	mov    %esi,%eax
}
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    

00801b83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
  801b88:	83 ec 10             	sub    $0x10,%esp
  801b8b:	89 c6                	mov    %eax,%esi
  801b8d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b8f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b96:	75 11                	jne    801ba9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b9f:	e8 3b 0f 00 00       	call   802adf <ipc_find_env>
  801ba4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ba9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bb0:	00 
  801bb1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801bb8:	00 
  801bb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bbd:	a1 00 50 80 00       	mov    0x805000,%eax
  801bc2:	89 04 24             	mov    %eax,(%esp)
  801bc5:	e8 ae 0e 00 00       	call   802a78 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bd1:	00 
  801bd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdd:	e8 2e 0e 00 00       	call   802a10 <ipc_recv>
}
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    

00801be9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c02:	ba 00 00 00 00       	mov    $0x0,%edx
  801c07:	b8 02 00 00 00       	mov    $0x2,%eax
  801c0c:	e8 72 ff ff ff       	call   801b83 <fsipc>
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
  801c29:	b8 06 00 00 00       	mov    $0x6,%eax
  801c2e:	e8 50 ff ff ff       	call   801b83 <fsipc>
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	53                   	push   %ebx
  801c39:	83 ec 14             	sub    $0x14,%esp
  801c3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	8b 40 0c             	mov    0xc(%eax),%eax
  801c45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c54:	e8 2a ff ff ff       	call   801b83 <fsipc>
  801c59:	89 c2                	mov    %eax,%edx
  801c5b:	85 d2                	test   %edx,%edx
  801c5d:	78 2b                	js     801c8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c66:	00 
  801c67:	89 1c 24             	mov    %ebx,(%esp)
  801c6a:	e8 08 ec ff ff       	call   800877 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8a:	83 c4 14             	add    $0x14,%esp
  801c8d:	5b                   	pop    %ebx
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
  801c94:	83 ec 14             	sub    $0x14,%esp
  801c97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801c9a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801ca0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ca5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  801cab:	8b 52 0c             	mov    0xc(%edx),%edx
  801cae:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801cb4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801cb9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc4:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ccb:	e8 44 ed ff ff       	call   800a14 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801cd0:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801cd7:	00 
  801cd8:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  801cdf:	e8 13 e5 ff ff       	call   8001f7 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce9:	b8 04 00 00 00       	mov    $0x4,%eax
  801cee:	e8 90 fe ff ff       	call   801b83 <fsipc>
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	78 53                	js     801d4a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801cf7:	39 c3                	cmp    %eax,%ebx
  801cf9:	73 24                	jae    801d1f <devfile_write+0x8f>
  801cfb:	c7 44 24 0c c1 32 80 	movl   $0x8032c1,0xc(%esp)
  801d02:	00 
  801d03:	c7 44 24 08 c8 32 80 	movl   $0x8032c8,0x8(%esp)
  801d0a:	00 
  801d0b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801d12:	00 
  801d13:	c7 04 24 dd 32 80 00 	movl   $0x8032dd,(%esp)
  801d1a:	e8 d7 0b 00 00       	call   8028f6 <_panic>
	assert(r <= PGSIZE);
  801d1f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d24:	7e 24                	jle    801d4a <devfile_write+0xba>
  801d26:	c7 44 24 0c e8 32 80 	movl   $0x8032e8,0xc(%esp)
  801d2d:	00 
  801d2e:	c7 44 24 08 c8 32 80 	movl   $0x8032c8,0x8(%esp)
  801d35:	00 
  801d36:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801d3d:	00 
  801d3e:	c7 04 24 dd 32 80 00 	movl   $0x8032dd,(%esp)
  801d45:	e8 ac 0b 00 00       	call   8028f6 <_panic>
	return r;
}
  801d4a:	83 c4 14             	add    $0x14,%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    

00801d50 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
  801d55:	83 ec 10             	sub    $0x10,%esp
  801d58:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d61:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d66:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d71:	b8 03 00 00 00       	mov    $0x3,%eax
  801d76:	e8 08 fe ff ff       	call   801b83 <fsipc>
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	78 6a                	js     801deb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d81:	39 c6                	cmp    %eax,%esi
  801d83:	73 24                	jae    801da9 <devfile_read+0x59>
  801d85:	c7 44 24 0c c1 32 80 	movl   $0x8032c1,0xc(%esp)
  801d8c:	00 
  801d8d:	c7 44 24 08 c8 32 80 	movl   $0x8032c8,0x8(%esp)
  801d94:	00 
  801d95:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d9c:	00 
  801d9d:	c7 04 24 dd 32 80 00 	movl   $0x8032dd,(%esp)
  801da4:	e8 4d 0b 00 00       	call   8028f6 <_panic>
	assert(r <= PGSIZE);
  801da9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dae:	7e 24                	jle    801dd4 <devfile_read+0x84>
  801db0:	c7 44 24 0c e8 32 80 	movl   $0x8032e8,0xc(%esp)
  801db7:	00 
  801db8:	c7 44 24 08 c8 32 80 	movl   $0x8032c8,0x8(%esp)
  801dbf:	00 
  801dc0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801dc7:	00 
  801dc8:	c7 04 24 dd 32 80 00 	movl   $0x8032dd,(%esp)
  801dcf:	e8 22 0b 00 00       	call   8028f6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dd4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd8:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ddf:	00 
  801de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de3:	89 04 24             	mov    %eax,(%esp)
  801de6:	e8 29 ec ff ff       	call   800a14 <memmove>
	return r;
}
  801deb:	89 d8                	mov    %ebx,%eax
  801ded:	83 c4 10             	add    $0x10,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    

00801df4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	53                   	push   %ebx
  801df8:	83 ec 24             	sub    $0x24,%esp
  801dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801dfe:	89 1c 24             	mov    %ebx,(%esp)
  801e01:	e8 3a ea ff ff       	call   800840 <strlen>
  801e06:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e0b:	7f 60                	jg     801e6d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e10:	89 04 24             	mov    %eax,(%esp)
  801e13:	e8 af f7 ff ff       	call   8015c7 <fd_alloc>
  801e18:	89 c2                	mov    %eax,%edx
  801e1a:	85 d2                	test   %edx,%edx
  801e1c:	78 54                	js     801e72 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e22:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e29:	e8 49 ea ff ff       	call   800877 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e39:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3e:	e8 40 fd ff ff       	call   801b83 <fsipc>
  801e43:	89 c3                	mov    %eax,%ebx
  801e45:	85 c0                	test   %eax,%eax
  801e47:	79 17                	jns    801e60 <open+0x6c>
		fd_close(fd, 0);
  801e49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e50:	00 
  801e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e54:	89 04 24             	mov    %eax,(%esp)
  801e57:	e8 6a f8 ff ff       	call   8016c6 <fd_close>
		return r;
  801e5c:	89 d8                	mov    %ebx,%eax
  801e5e:	eb 12                	jmp    801e72 <open+0x7e>
	}

	return fd2num(fd);
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	89 04 24             	mov    %eax,(%esp)
  801e66:	e8 35 f7 ff ff       	call   8015a0 <fd2num>
  801e6b:	eb 05                	jmp    801e72 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e6d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e72:	83 c4 24             	add    $0x24,%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    

00801e78 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e83:	b8 08 00 00 00       	mov    $0x8,%eax
  801e88:	e8 f6 fc ff ff       	call   801b83 <fsipc>
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <evict>:

int evict(void)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801e95:	c7 04 24 f4 32 80 00 	movl   $0x8032f4,(%esp)
  801e9c:	e8 56 e3 ff ff       	call   8001f7 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea6:	b8 09 00 00 00       	mov    $0x9,%eax
  801eab:	e8 d3 fc ff ff       	call   801b83 <fsipc>
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    
  801eb2:	66 90                	xchg   %ax,%ax
  801eb4:	66 90                	xchg   %ax,%ax
  801eb6:	66 90                	xchg   %ax,%ax
  801eb8:	66 90                	xchg   %ax,%ax
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	66 90                	xchg   %ax,%ax
  801ebe:	66 90                	xchg   %ax,%ax

00801ec0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ec6:	c7 44 24 04 0d 33 80 	movl   $0x80330d,0x4(%esp)
  801ecd:	00 
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	89 04 24             	mov    %eax,(%esp)
  801ed4:	e8 9e e9 ff ff       	call   800877 <strcpy>
	return 0;
}
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 14             	sub    $0x14,%esp
  801ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eea:	89 1c 24             	mov    %ebx,(%esp)
  801eed:	e8 25 0c 00 00       	call   802b17 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801ef7:	83 f8 01             	cmp    $0x1,%eax
  801efa:	75 0d                	jne    801f09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801efc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801eff:	89 04 24             	mov    %eax,(%esp)
  801f02:	e8 29 03 00 00       	call   802230 <nsipc_close>
  801f07:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f09:	89 d0                	mov    %edx,%eax
  801f0b:	83 c4 14             	add    $0x14,%esp
  801f0e:	5b                   	pop    %ebx
  801f0f:	5d                   	pop    %ebp
  801f10:	c3                   	ret    

00801f11 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f1e:	00 
  801f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	8b 40 0c             	mov    0xc(%eax),%eax
  801f33:	89 04 24             	mov    %eax,(%esp)
  801f36:	e8 f0 03 00 00       	call   80232b <nsipc_send>
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f4a:	00 
  801f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5f:	89 04 24             	mov    %eax,(%esp)
  801f62:	e8 44 03 00 00       	call   8022ab <nsipc_recv>
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f72:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f76:	89 04 24             	mov    %eax,(%esp)
  801f79:	e8 98 f6 ff ff       	call   801616 <fd_lookup>
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 17                	js     801f99 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f85:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f8b:	39 08                	cmp    %ecx,(%eax)
  801f8d:	75 05                	jne    801f94 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f92:	eb 05                	jmp    801f99 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	83 ec 20             	sub    $0x20,%esp
  801fa3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa8:	89 04 24             	mov    %eax,(%esp)
  801fab:	e8 17 f6 ff ff       	call   8015c7 <fd_alloc>
  801fb0:	89 c3                	mov    %eax,%ebx
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 21                	js     801fd7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fb6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fbd:	00 
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fcc:	e8 14 ed ff ff       	call   800ce5 <sys_page_alloc>
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	79 0c                	jns    801fe3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801fd7:	89 34 24             	mov    %esi,(%esp)
  801fda:	e8 51 02 00 00       	call   802230 <nsipc_close>
		return r;
  801fdf:	89 d8                	mov    %ebx,%eax
  801fe1:	eb 20                	jmp    802003 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fe3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801ff8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801ffb:	89 14 24             	mov    %edx,(%esp)
  801ffe:	e8 9d f5 ff ff       	call   8015a0 <fd2num>
}
  802003:	83 c4 20             	add    $0x20,%esp
  802006:	5b                   	pop    %ebx
  802007:	5e                   	pop    %esi
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    

0080200a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	e8 51 ff ff ff       	call   801f69 <fd2sockid>
		return r;
  802018:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201a:	85 c0                	test   %eax,%eax
  80201c:	78 23                	js     802041 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80201e:	8b 55 10             	mov    0x10(%ebp),%edx
  802021:	89 54 24 08          	mov    %edx,0x8(%esp)
  802025:	8b 55 0c             	mov    0xc(%ebp),%edx
  802028:	89 54 24 04          	mov    %edx,0x4(%esp)
  80202c:	89 04 24             	mov    %eax,(%esp)
  80202f:	e8 45 01 00 00       	call   802179 <nsipc_accept>
		return r;
  802034:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802036:	85 c0                	test   %eax,%eax
  802038:	78 07                	js     802041 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80203a:	e8 5c ff ff ff       	call   801f9b <alloc_sockfd>
  80203f:	89 c1                	mov    %eax,%ecx
}
  802041:	89 c8                	mov    %ecx,%eax
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	e8 16 ff ff ff       	call   801f69 <fd2sockid>
  802053:	89 c2                	mov    %eax,%edx
  802055:	85 d2                	test   %edx,%edx
  802057:	78 16                	js     80206f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802059:	8b 45 10             	mov    0x10(%ebp),%eax
  80205c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802060:	8b 45 0c             	mov    0xc(%ebp),%eax
  802063:	89 44 24 04          	mov    %eax,0x4(%esp)
  802067:	89 14 24             	mov    %edx,(%esp)
  80206a:	e8 60 01 00 00       	call   8021cf <nsipc_bind>
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <shutdown>:

int
shutdown(int s, int how)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	e8 ea fe ff ff       	call   801f69 <fd2sockid>
  80207f:	89 c2                	mov    %eax,%edx
  802081:	85 d2                	test   %edx,%edx
  802083:	78 0f                	js     802094 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802085:	8b 45 0c             	mov    0xc(%ebp),%eax
  802088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208c:	89 14 24             	mov    %edx,(%esp)
  80208f:	e8 7a 01 00 00       	call   80220e <nsipc_shutdown>
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	e8 c5 fe ff ff       	call   801f69 <fd2sockid>
  8020a4:	89 c2                	mov    %eax,%edx
  8020a6:	85 d2                	test   %edx,%edx
  8020a8:	78 16                	js     8020c0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8020aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b8:	89 14 24             	mov    %edx,(%esp)
  8020bb:	e8 8a 01 00 00       	call   80224a <nsipc_connect>
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <listen>:

int
listen(int s, int backlog)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	e8 99 fe ff ff       	call   801f69 <fd2sockid>
  8020d0:	89 c2                	mov    %eax,%edx
  8020d2:	85 d2                	test   %edx,%edx
  8020d4:	78 0f                	js     8020e5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dd:	89 14 24             	mov    %edx,(%esp)
  8020e0:	e8 a4 01 00 00       	call   802289 <nsipc_listen>
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	89 04 24             	mov    %eax,(%esp)
  802101:	e8 98 02 00 00       	call   80239e <nsipc_socket>
  802106:	89 c2                	mov    %eax,%edx
  802108:	85 d2                	test   %edx,%edx
  80210a:	78 05                	js     802111 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80210c:	e8 8a fe ff ff       	call   801f9b <alloc_sockfd>
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	53                   	push   %ebx
  802117:	83 ec 14             	sub    $0x14,%esp
  80211a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80211c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802123:	75 11                	jne    802136 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802125:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80212c:	e8 ae 09 00 00       	call   802adf <ipc_find_env>
  802131:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802136:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80213d:	00 
  80213e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802145:	00 
  802146:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80214a:	a1 04 50 80 00       	mov    0x805004,%eax
  80214f:	89 04 24             	mov    %eax,(%esp)
  802152:	e8 21 09 00 00       	call   802a78 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802157:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80215e:	00 
  80215f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802166:	00 
  802167:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80216e:	e8 9d 08 00 00       	call   802a10 <ipc_recv>
}
  802173:	83 c4 14             	add    $0x14,%esp
  802176:	5b                   	pop    %ebx
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    

00802179 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	56                   	push   %esi
  80217d:	53                   	push   %ebx
  80217e:	83 ec 10             	sub    $0x10,%esp
  802181:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80218c:	8b 06                	mov    (%esi),%eax
  80218e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802193:	b8 01 00 00 00       	mov    $0x1,%eax
  802198:	e8 76 ff ff ff       	call   802113 <nsipc>
  80219d:	89 c3                	mov    %eax,%ebx
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	78 23                	js     8021c6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021a3:	a1 10 70 80 00       	mov    0x807010,%eax
  8021a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021ac:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021b3:	00 
  8021b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b7:	89 04 24             	mov    %eax,(%esp)
  8021ba:	e8 55 e8 ff ff       	call   800a14 <memmove>
		*addrlen = ret->ret_addrlen;
  8021bf:	a1 10 70 80 00       	mov    0x807010,%eax
  8021c4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8021c6:	89 d8                	mov    %ebx,%eax
  8021c8:	83 c4 10             	add    $0x10,%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5e                   	pop    %esi
  8021cd:	5d                   	pop    %ebp
  8021ce:	c3                   	ret    

008021cf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	53                   	push   %ebx
  8021d3:	83 ec 14             	sub    $0x14,%esp
  8021d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021e1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ec:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021f3:	e8 1c e8 ff ff       	call   800a14 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021f8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021fe:	b8 02 00 00 00       	mov    $0x2,%eax
  802203:	e8 0b ff ff ff       	call   802113 <nsipc>
}
  802208:	83 c4 14             	add    $0x14,%esp
  80220b:	5b                   	pop    %ebx
  80220c:	5d                   	pop    %ebp
  80220d:	c3                   	ret    

0080220e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80221c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802224:	b8 03 00 00 00       	mov    $0x3,%eax
  802229:	e8 e5 fe ff ff       	call   802113 <nsipc>
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <nsipc_close>:

int
nsipc_close(int s)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80223e:	b8 04 00 00 00       	mov    $0x4,%eax
  802243:	e8 cb fe ff ff       	call   802113 <nsipc>
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	53                   	push   %ebx
  80224e:	83 ec 14             	sub    $0x14,%esp
  802251:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80225c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802260:	8b 45 0c             	mov    0xc(%ebp),%eax
  802263:	89 44 24 04          	mov    %eax,0x4(%esp)
  802267:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80226e:	e8 a1 e7 ff ff       	call   800a14 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802273:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802279:	b8 05 00 00 00       	mov    $0x5,%eax
  80227e:	e8 90 fe ff ff       	call   802113 <nsipc>
}
  802283:	83 c4 14             	add    $0x14,%esp
  802286:	5b                   	pop    %ebx
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80229f:	b8 06 00 00 00       	mov    $0x6,%eax
  8022a4:	e8 6a fe ff ff       	call   802113 <nsipc>
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	56                   	push   %esi
  8022af:	53                   	push   %ebx
  8022b0:	83 ec 10             	sub    $0x10,%esp
  8022b3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022be:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022cc:	b8 07 00 00 00       	mov    $0x7,%eax
  8022d1:	e8 3d fe ff ff       	call   802113 <nsipc>
  8022d6:	89 c3                	mov    %eax,%ebx
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	78 46                	js     802322 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022dc:	39 f0                	cmp    %esi,%eax
  8022de:	7f 07                	jg     8022e7 <nsipc_recv+0x3c>
  8022e0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022e5:	7e 24                	jle    80230b <nsipc_recv+0x60>
  8022e7:	c7 44 24 0c 19 33 80 	movl   $0x803319,0xc(%esp)
  8022ee:	00 
  8022ef:	c7 44 24 08 c8 32 80 	movl   $0x8032c8,0x8(%esp)
  8022f6:	00 
  8022f7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022fe:	00 
  8022ff:	c7 04 24 2e 33 80 00 	movl   $0x80332e,(%esp)
  802306:	e8 eb 05 00 00       	call   8028f6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80230b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80230f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802316:	00 
  802317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231a:	89 04 24             	mov    %eax,(%esp)
  80231d:	e8 f2 e6 ff ff       	call   800a14 <memmove>
	}

	return r;
}
  802322:	89 d8                	mov    %ebx,%eax
  802324:	83 c4 10             	add    $0x10,%esp
  802327:	5b                   	pop    %ebx
  802328:	5e                   	pop    %esi
  802329:	5d                   	pop    %ebp
  80232a:	c3                   	ret    

0080232b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	53                   	push   %ebx
  80232f:	83 ec 14             	sub    $0x14,%esp
  802332:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80233d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802343:	7e 24                	jle    802369 <nsipc_send+0x3e>
  802345:	c7 44 24 0c 3a 33 80 	movl   $0x80333a,0xc(%esp)
  80234c:	00 
  80234d:	c7 44 24 08 c8 32 80 	movl   $0x8032c8,0x8(%esp)
  802354:	00 
  802355:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80235c:	00 
  80235d:	c7 04 24 2e 33 80 00 	movl   $0x80332e,(%esp)
  802364:	e8 8d 05 00 00       	call   8028f6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802369:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80236d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802370:	89 44 24 04          	mov    %eax,0x4(%esp)
  802374:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80237b:	e8 94 e6 ff ff       	call   800a14 <memmove>
	nsipcbuf.send.req_size = size;
  802380:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802386:	8b 45 14             	mov    0x14(%ebp),%eax
  802389:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80238e:	b8 08 00 00 00       	mov    $0x8,%eax
  802393:	e8 7b fd ff ff       	call   802113 <nsipc>
}
  802398:	83 c4 14             	add    $0x14,%esp
  80239b:	5b                   	pop    %ebx
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    

0080239e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023af:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8023c1:	e8 4d fd ff ff       	call   802113 <nsipc>
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	56                   	push   %esi
  8023cc:	53                   	push   %ebx
  8023cd:	83 ec 10             	sub    $0x10,%esp
  8023d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	89 04 24             	mov    %eax,(%esp)
  8023d9:	e8 d2 f1 ff ff       	call   8015b0 <fd2data>
  8023de:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023e0:	c7 44 24 04 46 33 80 	movl   $0x803346,0x4(%esp)
  8023e7:	00 
  8023e8:	89 1c 24             	mov    %ebx,(%esp)
  8023eb:	e8 87 e4 ff ff       	call   800877 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023f0:	8b 46 04             	mov    0x4(%esi),%eax
  8023f3:	2b 06                	sub    (%esi),%eax
  8023f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802402:	00 00 00 
	stat->st_dev = &devpipe;
  802405:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80240c:	40 80 00 
	return 0;
}
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    

0080241b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	53                   	push   %ebx
  80241f:	83 ec 14             	sub    $0x14,%esp
  802422:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802425:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802429:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802430:	e8 57 e9 ff ff       	call   800d8c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802435:	89 1c 24             	mov    %ebx,(%esp)
  802438:	e8 73 f1 ff ff       	call   8015b0 <fd2data>
  80243d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802441:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802448:	e8 3f e9 ff ff       	call   800d8c <sys_page_unmap>
}
  80244d:	83 c4 14             	add    $0x14,%esp
  802450:	5b                   	pop    %ebx
  802451:	5d                   	pop    %ebp
  802452:	c3                   	ret    

00802453 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	57                   	push   %edi
  802457:	56                   	push   %esi
  802458:	53                   	push   %ebx
  802459:	83 ec 2c             	sub    $0x2c,%esp
  80245c:	89 c6                	mov    %eax,%esi
  80245e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802461:	a1 08 50 80 00       	mov    0x805008,%eax
  802466:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802469:	89 34 24             	mov    %esi,(%esp)
  80246c:	e8 a6 06 00 00       	call   802b17 <pageref>
  802471:	89 c7                	mov    %eax,%edi
  802473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802476:	89 04 24             	mov    %eax,(%esp)
  802479:	e8 99 06 00 00       	call   802b17 <pageref>
  80247e:	39 c7                	cmp    %eax,%edi
  802480:	0f 94 c2             	sete   %dl
  802483:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802486:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80248c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80248f:	39 fb                	cmp    %edi,%ebx
  802491:	74 21                	je     8024b4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802493:	84 d2                	test   %dl,%dl
  802495:	74 ca                	je     802461 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802497:	8b 51 58             	mov    0x58(%ecx),%edx
  80249a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80249e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a6:	c7 04 24 4d 33 80 00 	movl   $0x80334d,(%esp)
  8024ad:	e8 45 dd ff ff       	call   8001f7 <cprintf>
  8024b2:	eb ad                	jmp    802461 <_pipeisclosed+0xe>
	}
}
  8024b4:	83 c4 2c             	add    $0x2c,%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5f                   	pop    %edi
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    

008024bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	57                   	push   %edi
  8024c0:	56                   	push   %esi
  8024c1:	53                   	push   %ebx
  8024c2:	83 ec 1c             	sub    $0x1c,%esp
  8024c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024c8:	89 34 24             	mov    %esi,(%esp)
  8024cb:	e8 e0 f0 ff ff       	call   8015b0 <fd2data>
  8024d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d7:	eb 45                	jmp    80251e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024d9:	89 da                	mov    %ebx,%edx
  8024db:	89 f0                	mov    %esi,%eax
  8024dd:	e8 71 ff ff ff       	call   802453 <_pipeisclosed>
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	75 41                	jne    802527 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024e6:	e8 db e7 ff ff       	call   800cc6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8024ee:	8b 0b                	mov    (%ebx),%ecx
  8024f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024f3:	39 d0                	cmp    %edx,%eax
  8024f5:	73 e2                	jae    8024d9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802501:	99                   	cltd   
  802502:	c1 ea 1b             	shr    $0x1b,%edx
  802505:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802508:	83 e1 1f             	and    $0x1f,%ecx
  80250b:	29 d1                	sub    %edx,%ecx
  80250d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802511:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802515:	83 c0 01             	add    $0x1,%eax
  802518:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80251b:	83 c7 01             	add    $0x1,%edi
  80251e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802521:	75 c8                	jne    8024eb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802523:	89 f8                	mov    %edi,%eax
  802525:	eb 05                	jmp    80252c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802527:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80252c:	83 c4 1c             	add    $0x1c,%esp
  80252f:	5b                   	pop    %ebx
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    

00802534 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	57                   	push   %edi
  802538:	56                   	push   %esi
  802539:	53                   	push   %ebx
  80253a:	83 ec 1c             	sub    $0x1c,%esp
  80253d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802540:	89 3c 24             	mov    %edi,(%esp)
  802543:	e8 68 f0 ff ff       	call   8015b0 <fd2data>
  802548:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80254a:	be 00 00 00 00       	mov    $0x0,%esi
  80254f:	eb 3d                	jmp    80258e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802551:	85 f6                	test   %esi,%esi
  802553:	74 04                	je     802559 <devpipe_read+0x25>
				return i;
  802555:	89 f0                	mov    %esi,%eax
  802557:	eb 43                	jmp    80259c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802559:	89 da                	mov    %ebx,%edx
  80255b:	89 f8                	mov    %edi,%eax
  80255d:	e8 f1 fe ff ff       	call   802453 <_pipeisclosed>
  802562:	85 c0                	test   %eax,%eax
  802564:	75 31                	jne    802597 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802566:	e8 5b e7 ff ff       	call   800cc6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80256b:	8b 03                	mov    (%ebx),%eax
  80256d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802570:	74 df                	je     802551 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802572:	99                   	cltd   
  802573:	c1 ea 1b             	shr    $0x1b,%edx
  802576:	01 d0                	add    %edx,%eax
  802578:	83 e0 1f             	and    $0x1f,%eax
  80257b:	29 d0                	sub    %edx,%eax
  80257d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802585:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802588:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80258b:	83 c6 01             	add    $0x1,%esi
  80258e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802591:	75 d8                	jne    80256b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802593:	89 f0                	mov    %esi,%eax
  802595:	eb 05                	jmp    80259c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80259c:	83 c4 1c             	add    $0x1c,%esp
  80259f:	5b                   	pop    %ebx
  8025a0:	5e                   	pop    %esi
  8025a1:	5f                   	pop    %edi
  8025a2:	5d                   	pop    %ebp
  8025a3:	c3                   	ret    

008025a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
  8025a7:	56                   	push   %esi
  8025a8:	53                   	push   %ebx
  8025a9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025af:	89 04 24             	mov    %eax,(%esp)
  8025b2:	e8 10 f0 ff ff       	call   8015c7 <fd_alloc>
  8025b7:	89 c2                	mov    %eax,%edx
  8025b9:	85 d2                	test   %edx,%edx
  8025bb:	0f 88 4d 01 00 00    	js     80270e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025c8:	00 
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d7:	e8 09 e7 ff ff       	call   800ce5 <sys_page_alloc>
  8025dc:	89 c2                	mov    %eax,%edx
  8025de:	85 d2                	test   %edx,%edx
  8025e0:	0f 88 28 01 00 00    	js     80270e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025e9:	89 04 24             	mov    %eax,(%esp)
  8025ec:	e8 d6 ef ff ff       	call   8015c7 <fd_alloc>
  8025f1:	89 c3                	mov    %eax,%ebx
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 88 fe 00 00 00    	js     8026f9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802602:	00 
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802611:	e8 cf e6 ff ff       	call   800ce5 <sys_page_alloc>
  802616:	89 c3                	mov    %eax,%ebx
  802618:	85 c0                	test   %eax,%eax
  80261a:	0f 88 d9 00 00 00    	js     8026f9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	89 04 24             	mov    %eax,(%esp)
  802626:	e8 85 ef ff ff       	call   8015b0 <fd2data>
  80262b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802634:	00 
  802635:	89 44 24 04          	mov    %eax,0x4(%esp)
  802639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802640:	e8 a0 e6 ff ff       	call   800ce5 <sys_page_alloc>
  802645:	89 c3                	mov    %eax,%ebx
  802647:	85 c0                	test   %eax,%eax
  802649:	0f 88 97 00 00 00    	js     8026e6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80264f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802652:	89 04 24             	mov    %eax,(%esp)
  802655:	e8 56 ef ff ff       	call   8015b0 <fd2data>
  80265a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802661:	00 
  802662:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802666:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80266d:	00 
  80266e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802672:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802679:	e8 bb e6 ff ff       	call   800d39 <sys_page_map>
  80267e:	89 c3                	mov    %eax,%ebx
  802680:	85 c0                	test   %eax,%eax
  802682:	78 52                	js     8026d6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802684:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802699:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80269f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	89 04 24             	mov    %eax,(%esp)
  8026b4:	e8 e7 ee ff ff       	call   8015a0 <fd2num>
  8026b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c1:	89 04 24             	mov    %eax,(%esp)
  8026c4:	e8 d7 ee ff ff       	call   8015a0 <fd2num>
  8026c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d4:	eb 38                	jmp    80270e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e1:	e8 a6 e6 ff ff       	call   800d8c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f4:	e8 93 e6 ff ff       	call   800d8c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802700:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802707:	e8 80 e6 ff ff       	call   800d8c <sys_page_unmap>
  80270c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80270e:	83 c4 30             	add    $0x30,%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5d                   	pop    %ebp
  802714:	c3                   	ret    

00802715 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80271b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80271e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	89 04 24             	mov    %eax,(%esp)
  802728:	e8 e9 ee ff ff       	call   801616 <fd_lookup>
  80272d:	89 c2                	mov    %eax,%edx
  80272f:	85 d2                	test   %edx,%edx
  802731:	78 15                	js     802748 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	89 04 24             	mov    %eax,(%esp)
  802739:	e8 72 ee ff ff       	call   8015b0 <fd2data>
	return _pipeisclosed(fd, p);
  80273e:	89 c2                	mov    %eax,%edx
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	e8 0b fd ff ff       	call   802453 <_pipeisclosed>
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    
  80274a:	66 90                	xchg   %ax,%ax
  80274c:	66 90                	xchg   %ax,%ax
  80274e:	66 90                	xchg   %ax,%ax

00802750 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802753:	b8 00 00 00 00       	mov    $0x0,%eax
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    

0080275a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802760:	c7 44 24 04 65 33 80 	movl   $0x803365,0x4(%esp)
  802767:	00 
  802768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276b:	89 04 24             	mov    %eax,(%esp)
  80276e:	e8 04 e1 ff ff       	call   800877 <strcpy>
	return 0;
}
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	57                   	push   %edi
  80277e:	56                   	push   %esi
  80277f:	53                   	push   %ebx
  802780:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802786:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80278b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802791:	eb 31                	jmp    8027c4 <devcons_write+0x4a>
		m = n - tot;
  802793:	8b 75 10             	mov    0x10(%ebp),%esi
  802796:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802798:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80279b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027a7:	03 45 0c             	add    0xc(%ebp),%eax
  8027aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ae:	89 3c 24             	mov    %edi,(%esp)
  8027b1:	e8 5e e2 ff ff       	call   800a14 <memmove>
		sys_cputs(buf, m);
  8027b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027ba:	89 3c 24             	mov    %edi,(%esp)
  8027bd:	e8 04 e4 ff ff       	call   800bc6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027c2:	01 f3                	add    %esi,%ebx
  8027c4:	89 d8                	mov    %ebx,%eax
  8027c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8027c9:	72 c8                	jb     802793 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027d1:	5b                   	pop    %ebx
  8027d2:	5e                   	pop    %esi
  8027d3:	5f                   	pop    %edi
  8027d4:	5d                   	pop    %ebp
  8027d5:	c3                   	ret    

008027d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027e5:	75 07                	jne    8027ee <devcons_read+0x18>
  8027e7:	eb 2a                	jmp    802813 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027e9:	e8 d8 e4 ff ff       	call   800cc6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027ee:	66 90                	xchg   %ax,%ax
  8027f0:	e8 ef e3 ff ff       	call   800be4 <sys_cgetc>
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 f0                	je     8027e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	78 16                	js     802813 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8027fd:	83 f8 04             	cmp    $0x4,%eax
  802800:	74 0c                	je     80280e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802802:	8b 55 0c             	mov    0xc(%ebp),%edx
  802805:	88 02                	mov    %al,(%edx)
	return 1;
  802807:	b8 01 00 00 00       	mov    $0x1,%eax
  80280c:	eb 05                	jmp    802813 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802821:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802828:	00 
  802829:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80282c:	89 04 24             	mov    %eax,(%esp)
  80282f:	e8 92 e3 ff ff       	call   800bc6 <sys_cputs>
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <getchar>:

int
getchar(void)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80283c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802843:	00 
  802844:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802852:	e8 53 f0 ff ff       	call   8018aa <read>
	if (r < 0)
  802857:	85 c0                	test   %eax,%eax
  802859:	78 0f                	js     80286a <getchar+0x34>
		return r;
	if (r < 1)
  80285b:	85 c0                	test   %eax,%eax
  80285d:	7e 06                	jle    802865 <getchar+0x2f>
		return -E_EOF;
	return c;
  80285f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802863:	eb 05                	jmp    80286a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802865:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802875:	89 44 24 04          	mov    %eax,0x4(%esp)
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	89 04 24             	mov    %eax,(%esp)
  80287f:	e8 92 ed ff ff       	call   801616 <fd_lookup>
  802884:	85 c0                	test   %eax,%eax
  802886:	78 11                	js     802899 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802891:	39 10                	cmp    %edx,(%eax)
  802893:	0f 94 c0             	sete   %al
  802896:	0f b6 c0             	movzbl %al,%eax
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <opencons>:

int
opencons(void)
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
  80289e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a4:	89 04 24             	mov    %eax,(%esp)
  8028a7:	e8 1b ed ff ff       	call   8015c7 <fd_alloc>
		return r;
  8028ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	78 40                	js     8028f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028b9:	00 
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c8:	e8 18 e4 ff ff       	call   800ce5 <sys_page_alloc>
		return r;
  8028cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	78 1f                	js     8028f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028d3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028e8:	89 04 24             	mov    %eax,(%esp)
  8028eb:	e8 b0 ec ff ff       	call   8015a0 <fd2num>
  8028f0:	89 c2                	mov    %eax,%edx
}
  8028f2:	89 d0                	mov    %edx,%eax
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

008028f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8028f6:	55                   	push   %ebp
  8028f7:	89 e5                	mov    %esp,%ebp
  8028f9:	56                   	push   %esi
  8028fa:	53                   	push   %ebx
  8028fb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8028fe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802901:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802907:	e8 9b e3 ff ff       	call   800ca7 <sys_getenvid>
  80290c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80290f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802913:	8b 55 08             	mov    0x8(%ebp),%edx
  802916:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80291a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80291e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802922:	c7 04 24 74 33 80 00 	movl   $0x803374,(%esp)
  802929:	e8 c9 d8 ff ff       	call   8001f7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80292e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802932:	8b 45 10             	mov    0x10(%ebp),%eax
  802935:	89 04 24             	mov    %eax,(%esp)
  802938:	e8 59 d8 ff ff       	call   800196 <vcprintf>
	cprintf("\n");
  80293d:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  802944:	e8 ae d8 ff ff       	call   8001f7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802949:	cc                   	int3   
  80294a:	eb fd                	jmp    802949 <_panic+0x53>

0080294c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802952:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802959:	75 7a                	jne    8029d5 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80295b:	e8 47 e3 ff ff       	call   800ca7 <sys_getenvid>
  802960:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802967:	00 
  802968:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80296f:	ee 
  802970:	89 04 24             	mov    %eax,(%esp)
  802973:	e8 6d e3 ff ff       	call   800ce5 <sys_page_alloc>
  802978:	85 c0                	test   %eax,%eax
  80297a:	79 20                	jns    80299c <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  80297c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802980:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  802987:	00 
  802988:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  80298f:	00 
  802990:	c7 04 24 97 33 80 00 	movl   $0x803397,(%esp)
  802997:	e8 5a ff ff ff       	call   8028f6 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  80299c:	e8 06 e3 ff ff       	call   800ca7 <sys_getenvid>
  8029a1:	c7 44 24 04 df 29 80 	movl   $0x8029df,0x4(%esp)
  8029a8:	00 
  8029a9:	89 04 24             	mov    %eax,(%esp)
  8029ac:	e8 f4 e4 ff ff       	call   800ea5 <sys_env_set_pgfault_upcall>
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	79 20                	jns    8029d5 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  8029b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029b9:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  8029c0:	00 
  8029c1:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8029c8:	00 
  8029c9:	c7 04 24 97 33 80 00 	movl   $0x803397,(%esp)
  8029d0:	e8 21 ff ff ff       	call   8028f6 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029dd:	c9                   	leave  
  8029de:	c3                   	ret    

008029df <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029df:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029e0:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029e5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029e7:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  8029ea:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  8029ee:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8029f2:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  8029f5:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  8029f9:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  8029fb:	83 c4 08             	add    $0x8,%esp
	popal
  8029fe:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  8029ff:	83 c4 04             	add    $0x4,%esp
	popfl
  802a02:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a03:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a04:	c3                   	ret    
  802a05:	66 90                	xchg   %ax,%ax
  802a07:	66 90                	xchg   %ax,%ax
  802a09:	66 90                	xchg   %ax,%ax
  802a0b:	66 90                	xchg   %ax,%ax
  802a0d:	66 90                	xchg   %ax,%ax
  802a0f:	90                   	nop

00802a10 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	56                   	push   %esi
  802a14:	53                   	push   %ebx
  802a15:	83 ec 10             	sub    $0x10,%esp
  802a18:	8b 75 08             	mov    0x8(%ebp),%esi
  802a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802a21:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802a23:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802a28:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a2b:	89 04 24             	mov    %eax,(%esp)
  802a2e:	e8 e8 e4 ff ff       	call   800f1b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802a33:	85 c0                	test   %eax,%eax
  802a35:	75 26                	jne    802a5d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802a37:	85 f6                	test   %esi,%esi
  802a39:	74 0a                	je     802a45 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802a3b:	a1 08 50 80 00       	mov    0x805008,%eax
  802a40:	8b 40 74             	mov    0x74(%eax),%eax
  802a43:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802a45:	85 db                	test   %ebx,%ebx
  802a47:	74 0a                	je     802a53 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802a49:	a1 08 50 80 00       	mov    0x805008,%eax
  802a4e:	8b 40 78             	mov    0x78(%eax),%eax
  802a51:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802a53:	a1 08 50 80 00       	mov    0x805008,%eax
  802a58:	8b 40 70             	mov    0x70(%eax),%eax
  802a5b:	eb 14                	jmp    802a71 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802a5d:	85 f6                	test   %esi,%esi
  802a5f:	74 06                	je     802a67 <ipc_recv+0x57>
			*from_env_store = 0;
  802a61:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a67:	85 db                	test   %ebx,%ebx
  802a69:	74 06                	je     802a71 <ipc_recv+0x61>
			*perm_store = 0;
  802a6b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802a71:	83 c4 10             	add    $0x10,%esp
  802a74:	5b                   	pop    %ebx
  802a75:	5e                   	pop    %esi
  802a76:	5d                   	pop    %ebp
  802a77:	c3                   	ret    

00802a78 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a78:	55                   	push   %ebp
  802a79:	89 e5                	mov    %esp,%ebp
  802a7b:	57                   	push   %edi
  802a7c:	56                   	push   %esi
  802a7d:	53                   	push   %ebx
  802a7e:	83 ec 1c             	sub    $0x1c,%esp
  802a81:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a84:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a87:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802a8a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802a8c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802a91:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802a94:	8b 45 14             	mov    0x14(%ebp),%eax
  802a97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a9f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802aa3:	89 3c 24             	mov    %edi,(%esp)
  802aa6:	e8 4d e4 ff ff       	call   800ef8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802aab:	85 c0                	test   %eax,%eax
  802aad:	74 28                	je     802ad7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802aaf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ab2:	74 1c                	je     802ad0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802ab4:	c7 44 24 08 a8 33 80 	movl   $0x8033a8,0x8(%esp)
  802abb:	00 
  802abc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802ac3:	00 
  802ac4:	c7 04 24 cc 33 80 00 	movl   $0x8033cc,(%esp)
  802acb:	e8 26 fe ff ff       	call   8028f6 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802ad0:	e8 f1 e1 ff ff       	call   800cc6 <sys_yield>
	}
  802ad5:	eb bd                	jmp    802a94 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802ad7:	83 c4 1c             	add    $0x1c,%esp
  802ada:	5b                   	pop    %ebx
  802adb:	5e                   	pop    %esi
  802adc:	5f                   	pop    %edi
  802add:	5d                   	pop    %ebp
  802ade:	c3                   	ret    

00802adf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802adf:	55                   	push   %ebp
  802ae0:	89 e5                	mov    %esp,%ebp
  802ae2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ae5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802aea:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802aed:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802af3:	8b 52 50             	mov    0x50(%edx),%edx
  802af6:	39 ca                	cmp    %ecx,%edx
  802af8:	75 0d                	jne    802b07 <ipc_find_env+0x28>
			return envs[i].env_id;
  802afa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802afd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802b02:	8b 40 40             	mov    0x40(%eax),%eax
  802b05:	eb 0e                	jmp    802b15 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b07:	83 c0 01             	add    $0x1,%eax
  802b0a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b0f:	75 d9                	jne    802aea <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802b11:	66 b8 00 00          	mov    $0x0,%ax
}
  802b15:	5d                   	pop    %ebp
  802b16:	c3                   	ret    

00802b17 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b17:	55                   	push   %ebp
  802b18:	89 e5                	mov    %esp,%ebp
  802b1a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b1d:	89 d0                	mov    %edx,%eax
  802b1f:	c1 e8 16             	shr    $0x16,%eax
  802b22:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b2e:	f6 c1 01             	test   $0x1,%cl
  802b31:	74 1d                	je     802b50 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b33:	c1 ea 0c             	shr    $0xc,%edx
  802b36:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b3d:	f6 c2 01             	test   $0x1,%dl
  802b40:	74 0e                	je     802b50 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b42:	c1 ea 0c             	shr    $0xc,%edx
  802b45:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b4c:	ef 
  802b4d:	0f b7 c0             	movzwl %ax,%eax
}
  802b50:	5d                   	pop    %ebp
  802b51:	c3                   	ret    
  802b52:	66 90                	xchg   %ax,%ax
  802b54:	66 90                	xchg   %ax,%ax
  802b56:	66 90                	xchg   %ax,%ax
  802b58:	66 90                	xchg   %ax,%ax
  802b5a:	66 90                	xchg   %ax,%ax
  802b5c:	66 90                	xchg   %ax,%ax
  802b5e:	66 90                	xchg   %ax,%ax

00802b60 <__udivdi3>:
  802b60:	55                   	push   %ebp
  802b61:	57                   	push   %edi
  802b62:	56                   	push   %esi
  802b63:	83 ec 0c             	sub    $0xc,%esp
  802b66:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b6a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b6e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b72:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b76:	85 c0                	test   %eax,%eax
  802b78:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b7c:	89 ea                	mov    %ebp,%edx
  802b7e:	89 0c 24             	mov    %ecx,(%esp)
  802b81:	75 2d                	jne    802bb0 <__udivdi3+0x50>
  802b83:	39 e9                	cmp    %ebp,%ecx
  802b85:	77 61                	ja     802be8 <__udivdi3+0x88>
  802b87:	85 c9                	test   %ecx,%ecx
  802b89:	89 ce                	mov    %ecx,%esi
  802b8b:	75 0b                	jne    802b98 <__udivdi3+0x38>
  802b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b92:	31 d2                	xor    %edx,%edx
  802b94:	f7 f1                	div    %ecx
  802b96:	89 c6                	mov    %eax,%esi
  802b98:	31 d2                	xor    %edx,%edx
  802b9a:	89 e8                	mov    %ebp,%eax
  802b9c:	f7 f6                	div    %esi
  802b9e:	89 c5                	mov    %eax,%ebp
  802ba0:	89 f8                	mov    %edi,%eax
  802ba2:	f7 f6                	div    %esi
  802ba4:	89 ea                	mov    %ebp,%edx
  802ba6:	83 c4 0c             	add    $0xc,%esp
  802ba9:	5e                   	pop    %esi
  802baa:	5f                   	pop    %edi
  802bab:	5d                   	pop    %ebp
  802bac:	c3                   	ret    
  802bad:	8d 76 00             	lea    0x0(%esi),%esi
  802bb0:	39 e8                	cmp    %ebp,%eax
  802bb2:	77 24                	ja     802bd8 <__udivdi3+0x78>
  802bb4:	0f bd e8             	bsr    %eax,%ebp
  802bb7:	83 f5 1f             	xor    $0x1f,%ebp
  802bba:	75 3c                	jne    802bf8 <__udivdi3+0x98>
  802bbc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802bc0:	39 34 24             	cmp    %esi,(%esp)
  802bc3:	0f 86 9f 00 00 00    	jbe    802c68 <__udivdi3+0x108>
  802bc9:	39 d0                	cmp    %edx,%eax
  802bcb:	0f 82 97 00 00 00    	jb     802c68 <__udivdi3+0x108>
  802bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	31 d2                	xor    %edx,%edx
  802bda:	31 c0                	xor    %eax,%eax
  802bdc:	83 c4 0c             	add    $0xc,%esp
  802bdf:	5e                   	pop    %esi
  802be0:	5f                   	pop    %edi
  802be1:	5d                   	pop    %ebp
  802be2:	c3                   	ret    
  802be3:	90                   	nop
  802be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802be8:	89 f8                	mov    %edi,%eax
  802bea:	f7 f1                	div    %ecx
  802bec:	31 d2                	xor    %edx,%edx
  802bee:	83 c4 0c             	add    $0xc,%esp
  802bf1:	5e                   	pop    %esi
  802bf2:	5f                   	pop    %edi
  802bf3:	5d                   	pop    %ebp
  802bf4:	c3                   	ret    
  802bf5:	8d 76 00             	lea    0x0(%esi),%esi
  802bf8:	89 e9                	mov    %ebp,%ecx
  802bfa:	8b 3c 24             	mov    (%esp),%edi
  802bfd:	d3 e0                	shl    %cl,%eax
  802bff:	89 c6                	mov    %eax,%esi
  802c01:	b8 20 00 00 00       	mov    $0x20,%eax
  802c06:	29 e8                	sub    %ebp,%eax
  802c08:	89 c1                	mov    %eax,%ecx
  802c0a:	d3 ef                	shr    %cl,%edi
  802c0c:	89 e9                	mov    %ebp,%ecx
  802c0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c12:	8b 3c 24             	mov    (%esp),%edi
  802c15:	09 74 24 08          	or     %esi,0x8(%esp)
  802c19:	89 d6                	mov    %edx,%esi
  802c1b:	d3 e7                	shl    %cl,%edi
  802c1d:	89 c1                	mov    %eax,%ecx
  802c1f:	89 3c 24             	mov    %edi,(%esp)
  802c22:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c26:	d3 ee                	shr    %cl,%esi
  802c28:	89 e9                	mov    %ebp,%ecx
  802c2a:	d3 e2                	shl    %cl,%edx
  802c2c:	89 c1                	mov    %eax,%ecx
  802c2e:	d3 ef                	shr    %cl,%edi
  802c30:	09 d7                	or     %edx,%edi
  802c32:	89 f2                	mov    %esi,%edx
  802c34:	89 f8                	mov    %edi,%eax
  802c36:	f7 74 24 08          	divl   0x8(%esp)
  802c3a:	89 d6                	mov    %edx,%esi
  802c3c:	89 c7                	mov    %eax,%edi
  802c3e:	f7 24 24             	mull   (%esp)
  802c41:	39 d6                	cmp    %edx,%esi
  802c43:	89 14 24             	mov    %edx,(%esp)
  802c46:	72 30                	jb     802c78 <__udivdi3+0x118>
  802c48:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c4c:	89 e9                	mov    %ebp,%ecx
  802c4e:	d3 e2                	shl    %cl,%edx
  802c50:	39 c2                	cmp    %eax,%edx
  802c52:	73 05                	jae    802c59 <__udivdi3+0xf9>
  802c54:	3b 34 24             	cmp    (%esp),%esi
  802c57:	74 1f                	je     802c78 <__udivdi3+0x118>
  802c59:	89 f8                	mov    %edi,%eax
  802c5b:	31 d2                	xor    %edx,%edx
  802c5d:	e9 7a ff ff ff       	jmp    802bdc <__udivdi3+0x7c>
  802c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c68:	31 d2                	xor    %edx,%edx
  802c6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c6f:	e9 68 ff ff ff       	jmp    802bdc <__udivdi3+0x7c>
  802c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c78:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c7b:	31 d2                	xor    %edx,%edx
  802c7d:	83 c4 0c             	add    $0xc,%esp
  802c80:	5e                   	pop    %esi
  802c81:	5f                   	pop    %edi
  802c82:	5d                   	pop    %ebp
  802c83:	c3                   	ret    
  802c84:	66 90                	xchg   %ax,%ax
  802c86:	66 90                	xchg   %ax,%ax
  802c88:	66 90                	xchg   %ax,%ax
  802c8a:	66 90                	xchg   %ax,%ax
  802c8c:	66 90                	xchg   %ax,%ax
  802c8e:	66 90                	xchg   %ax,%ax

00802c90 <__umoddi3>:
  802c90:	55                   	push   %ebp
  802c91:	57                   	push   %edi
  802c92:	56                   	push   %esi
  802c93:	83 ec 14             	sub    $0x14,%esp
  802c96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c9a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c9e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ca2:	89 c7                	mov    %eax,%edi
  802ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ca8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802cb0:	89 34 24             	mov    %esi,(%esp)
  802cb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	89 c2                	mov    %eax,%edx
  802cbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cbf:	75 17                	jne    802cd8 <__umoddi3+0x48>
  802cc1:	39 fe                	cmp    %edi,%esi
  802cc3:	76 4b                	jbe    802d10 <__umoddi3+0x80>
  802cc5:	89 c8                	mov    %ecx,%eax
  802cc7:	89 fa                	mov    %edi,%edx
  802cc9:	f7 f6                	div    %esi
  802ccb:	89 d0                	mov    %edx,%eax
  802ccd:	31 d2                	xor    %edx,%edx
  802ccf:	83 c4 14             	add    $0x14,%esp
  802cd2:	5e                   	pop    %esi
  802cd3:	5f                   	pop    %edi
  802cd4:	5d                   	pop    %ebp
  802cd5:	c3                   	ret    
  802cd6:	66 90                	xchg   %ax,%ax
  802cd8:	39 f8                	cmp    %edi,%eax
  802cda:	77 54                	ja     802d30 <__umoddi3+0xa0>
  802cdc:	0f bd e8             	bsr    %eax,%ebp
  802cdf:	83 f5 1f             	xor    $0x1f,%ebp
  802ce2:	75 5c                	jne    802d40 <__umoddi3+0xb0>
  802ce4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ce8:	39 3c 24             	cmp    %edi,(%esp)
  802ceb:	0f 87 e7 00 00 00    	ja     802dd8 <__umoddi3+0x148>
  802cf1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802cf5:	29 f1                	sub    %esi,%ecx
  802cf7:	19 c7                	sbb    %eax,%edi
  802cf9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d01:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d05:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d09:	83 c4 14             	add    $0x14,%esp
  802d0c:	5e                   	pop    %esi
  802d0d:	5f                   	pop    %edi
  802d0e:	5d                   	pop    %ebp
  802d0f:	c3                   	ret    
  802d10:	85 f6                	test   %esi,%esi
  802d12:	89 f5                	mov    %esi,%ebp
  802d14:	75 0b                	jne    802d21 <__umoddi3+0x91>
  802d16:	b8 01 00 00 00       	mov    $0x1,%eax
  802d1b:	31 d2                	xor    %edx,%edx
  802d1d:	f7 f6                	div    %esi
  802d1f:	89 c5                	mov    %eax,%ebp
  802d21:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d25:	31 d2                	xor    %edx,%edx
  802d27:	f7 f5                	div    %ebp
  802d29:	89 c8                	mov    %ecx,%eax
  802d2b:	f7 f5                	div    %ebp
  802d2d:	eb 9c                	jmp    802ccb <__umoddi3+0x3b>
  802d2f:	90                   	nop
  802d30:	89 c8                	mov    %ecx,%eax
  802d32:	89 fa                	mov    %edi,%edx
  802d34:	83 c4 14             	add    $0x14,%esp
  802d37:	5e                   	pop    %esi
  802d38:	5f                   	pop    %edi
  802d39:	5d                   	pop    %ebp
  802d3a:	c3                   	ret    
  802d3b:	90                   	nop
  802d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d40:	8b 04 24             	mov    (%esp),%eax
  802d43:	be 20 00 00 00       	mov    $0x20,%esi
  802d48:	89 e9                	mov    %ebp,%ecx
  802d4a:	29 ee                	sub    %ebp,%esi
  802d4c:	d3 e2                	shl    %cl,%edx
  802d4e:	89 f1                	mov    %esi,%ecx
  802d50:	d3 e8                	shr    %cl,%eax
  802d52:	89 e9                	mov    %ebp,%ecx
  802d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d58:	8b 04 24             	mov    (%esp),%eax
  802d5b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d5f:	89 fa                	mov    %edi,%edx
  802d61:	d3 e0                	shl    %cl,%eax
  802d63:	89 f1                	mov    %esi,%ecx
  802d65:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d69:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d6d:	d3 ea                	shr    %cl,%edx
  802d6f:	89 e9                	mov    %ebp,%ecx
  802d71:	d3 e7                	shl    %cl,%edi
  802d73:	89 f1                	mov    %esi,%ecx
  802d75:	d3 e8                	shr    %cl,%eax
  802d77:	89 e9                	mov    %ebp,%ecx
  802d79:	09 f8                	or     %edi,%eax
  802d7b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d7f:	f7 74 24 04          	divl   0x4(%esp)
  802d83:	d3 e7                	shl    %cl,%edi
  802d85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d89:	89 d7                	mov    %edx,%edi
  802d8b:	f7 64 24 08          	mull   0x8(%esp)
  802d8f:	39 d7                	cmp    %edx,%edi
  802d91:	89 c1                	mov    %eax,%ecx
  802d93:	89 14 24             	mov    %edx,(%esp)
  802d96:	72 2c                	jb     802dc4 <__umoddi3+0x134>
  802d98:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d9c:	72 22                	jb     802dc0 <__umoddi3+0x130>
  802d9e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802da2:	29 c8                	sub    %ecx,%eax
  802da4:	19 d7                	sbb    %edx,%edi
  802da6:	89 e9                	mov    %ebp,%ecx
  802da8:	89 fa                	mov    %edi,%edx
  802daa:	d3 e8                	shr    %cl,%eax
  802dac:	89 f1                	mov    %esi,%ecx
  802dae:	d3 e2                	shl    %cl,%edx
  802db0:	89 e9                	mov    %ebp,%ecx
  802db2:	d3 ef                	shr    %cl,%edi
  802db4:	09 d0                	or     %edx,%eax
  802db6:	89 fa                	mov    %edi,%edx
  802db8:	83 c4 14             	add    $0x14,%esp
  802dbb:	5e                   	pop    %esi
  802dbc:	5f                   	pop    %edi
  802dbd:	5d                   	pop    %ebp
  802dbe:	c3                   	ret    
  802dbf:	90                   	nop
  802dc0:	39 d7                	cmp    %edx,%edi
  802dc2:	75 da                	jne    802d9e <__umoddi3+0x10e>
  802dc4:	8b 14 24             	mov    (%esp),%edx
  802dc7:	89 c1                	mov    %eax,%ecx
  802dc9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802dcd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802dd1:	eb cb                	jmp    802d9e <__umoddi3+0x10e>
  802dd3:	90                   	nop
  802dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dd8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802ddc:	0f 82 0f ff ff ff    	jb     802cf1 <__umoddi3+0x61>
  802de2:	e9 1a ff ff ff       	jmp    802d01 <__umoddi3+0x71>
