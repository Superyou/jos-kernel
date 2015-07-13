
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 01 01 00 00       	call   800132 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	c7 04 24 40 2a 80 00 	movl   $0x802a40,(%esp)
  800040:	e8 f1 01 00 00       	call   800236 <cprintf>
	exit();
  800045:	e8 30 01 00 00       	call   80017a <exit>
}
  80004a:	c9                   	leave  
  80004b:	c3                   	ret    

0080004c <umain>:

void
umain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	57                   	push   %edi
  800050:	56                   	push   %esi
  800051:	53                   	push   %ebx
  800052:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800058:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800062:	8b 45 0c             	mov    0xc(%ebp),%eax
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	8d 45 08             	lea    0x8(%ebp),%eax
  80006c:	89 04 24             	mov    %eax,(%esp)
  80006f:	e8 aa 0f 00 00       	call   80101e <argstart>
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
  800074:	be 00 00 00 00       	mov    $0x0,%esi
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800079:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
  80007f:	eb 11                	jmp    800092 <umain+0x46>
		if (i == '1')
  800081:	83 f8 31             	cmp    $0x31,%eax
  800084:	75 07                	jne    80008d <umain+0x41>
			usefprint = 1;
  800086:	be 01 00 00 00       	mov    $0x1,%esi
  80008b:	eb 05                	jmp    800092 <umain+0x46>
		else
			usage();
  80008d:	e8 a1 ff ff ff       	call   800033 <usage>
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800092:	89 1c 24             	mov    %ebx,(%esp)
  800095:	e8 bc 0f 00 00       	call   801056 <argnext>
  80009a:	85 c0                	test   %eax,%eax
  80009c:	79 e3                	jns    800081 <umain+0x35>
  80009e:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000a3:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000ad:	89 1c 24             	mov    %ebx,(%esp)
  8000b0:	e8 f1 15 00 00       	call   8016a6 <fstat>
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	78 66                	js     80011f <umain+0xd3>
			if (usefprint)
  8000b9:	85 f6                	test   %esi,%esi
  8000bb:	74 36                	je     8000f3 <umain+0xa7>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c0:	8b 40 04             	mov    0x4(%eax),%eax
  8000c3:	89 44 24 18          	mov    %eax,0x18(%esp)
  8000c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000ca:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000dd:	c7 44 24 04 54 2a 80 	movl   $0x802a54,0x4(%esp)
  8000e4:	00 
  8000e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ec:	e8 95 1a 00 00       	call   801b86 <fprintf>
  8000f1:	eb 2c                	jmp    80011f <umain+0xd3>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f6:	8b 40 04             	mov    0x4(%eax),%eax
  8000f9:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800100:	89 44 24 10          	mov    %eax,0x10(%esp)
  800104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800107:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80010b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80010f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800113:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  80011a:	e8 17 01 00 00       	call   800236 <cprintf>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  80011f:	83 c3 01             	add    $0x1,%ebx
  800122:	83 fb 20             	cmp    $0x20,%ebx
  800125:	75 82                	jne    8000a9 <umain+0x5d>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800127:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	56                   	push   %esi
  800136:	53                   	push   %ebx
  800137:	83 ec 10             	sub    $0x10,%esp
  80013a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800140:	e8 92 0b 00 00       	call   800cd7 <sys_getenvid>
  800145:	25 ff 03 00 00       	and    $0x3ff,%eax
  80014a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80014d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800152:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800157:	85 db                	test   %ebx,%ebx
  800159:	7e 07                	jle    800162 <libmain+0x30>
		binaryname = argv[0];
  80015b:	8b 06                	mov    (%esi),%eax
  80015d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800162:	89 74 24 04          	mov    %esi,0x4(%esp)
  800166:	89 1c 24             	mov    %ebx,(%esp)
  800169:	e8 de fe ff ff       	call   80004c <umain>

	// exit gracefully
	exit();
  80016e:	e8 07 00 00 00       	call   80017a <exit>
}
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800180:	e8 d5 11 00 00       	call   80135a <close_all>
	sys_env_destroy(0);
  800185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80018c:	e8 a2 0a 00 00       	call   800c33 <sys_env_destroy>
}
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	53                   	push   %ebx
  800197:	83 ec 14             	sub    $0x14,%esp
  80019a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80019d:	8b 13                	mov    (%ebx),%edx
  80019f:	8d 42 01             	lea    0x1(%edx),%eax
  8001a2:	89 03                	mov    %eax,(%ebx)
  8001a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b0:	75 19                	jne    8001cb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001b2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001b9:	00 
  8001ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 31 0a 00 00       	call   800bf6 <sys_cputs>
		b->idx = 0;
  8001c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001cb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cf:	83 c4 14             	add    $0x14,%esp
  8001d2:	5b                   	pop    %ebx
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001de:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e5:	00 00 00 
	b.cnt = 0;
  8001e8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ef:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800200:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020a:	c7 04 24 93 01 80 00 	movl   $0x800193,(%esp)
  800211:	e8 6e 01 00 00       	call   800384 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800216:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80021c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800220:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 c8 09 00 00       	call   800bf6 <sys_cputs>

	return b.cnt;
}
  80022e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80023c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800243:	8b 45 08             	mov    0x8(%ebp),%eax
  800246:	89 04 24             	mov    %eax,(%esp)
  800249:	e8 87 ff ff ff       	call   8001d5 <vcprintf>
	va_end(ap);

	return cnt;
}
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 3c             	sub    $0x3c,%esp
  800259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800264:	8b 45 0c             	mov    0xc(%ebp),%eax
  800267:	89 c3                	mov    %eax,%ebx
  800269:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80026c:	8b 45 10             	mov    0x10(%ebp),%eax
  80026f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800272:	b9 00 00 00 00       	mov    $0x0,%ecx
  800277:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80027d:	39 d9                	cmp    %ebx,%ecx
  80027f:	72 05                	jb     800286 <printnum+0x36>
  800281:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800284:	77 69                	ja     8002ef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800286:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800289:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80028d:	83 ee 01             	sub    $0x1,%esi
  800290:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800294:	89 44 24 08          	mov    %eax,0x8(%esp)
  800298:	8b 44 24 08          	mov    0x8(%esp),%eax
  80029c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	89 d6                	mov    %edx,%esi
  8002a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b5:	89 04 24             	mov    %eax,(%esp)
  8002b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bf:	e8 ec 24 00 00       	call   8027b0 <__udivdi3>
  8002c4:	89 d9                	mov    %ebx,%ecx
  8002c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002ce:	89 04 24             	mov    %eax,(%esp)
  8002d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002d5:	89 fa                	mov    %edi,%edx
  8002d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002da:	e8 71 ff ff ff       	call   800250 <printnum>
  8002df:	eb 1b                	jmp    8002fc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e8:	89 04 24             	mov    %eax,(%esp)
  8002eb:	ff d3                	call   *%ebx
  8002ed:	eb 03                	jmp    8002f2 <printnum+0xa2>
  8002ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002f2:	83 ee 01             	sub    $0x1,%esi
  8002f5:	85 f6                	test   %esi,%esi
  8002f7:	7f e8                	jg     8002e1 <printnum+0x91>
  8002f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800300:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800304:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800307:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80030a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80030e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800312:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800315:	89 04 24             	mov    %eax,(%esp)
  800318:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80031b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031f:	e8 bc 25 00 00       	call   8028e0 <__umoddi3>
  800324:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800328:	0f be 80 86 2a 80 00 	movsbl 0x802a86(%eax),%eax
  80032f:	89 04 24             	mov    %eax,(%esp)
  800332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800335:	ff d0                	call   *%eax
}
  800337:	83 c4 3c             	add    $0x3c,%esp
  80033a:	5b                   	pop    %ebx
  80033b:	5e                   	pop    %esi
  80033c:	5f                   	pop    %edi
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    

0080033f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800345:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800349:	8b 10                	mov    (%eax),%edx
  80034b:	3b 50 04             	cmp    0x4(%eax),%edx
  80034e:	73 0a                	jae    80035a <sprintputch+0x1b>
		*b->buf++ = ch;
  800350:	8d 4a 01             	lea    0x1(%edx),%ecx
  800353:	89 08                	mov    %ecx,(%eax)
  800355:	8b 45 08             	mov    0x8(%ebp),%eax
  800358:	88 02                	mov    %al,(%edx)
}
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800362:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800365:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800369:	8b 45 10             	mov    0x10(%ebp),%eax
  80036c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
  800373:	89 44 24 04          	mov    %eax,0x4(%esp)
  800377:	8b 45 08             	mov    0x8(%ebp),%eax
  80037a:	89 04 24             	mov    %eax,(%esp)
  80037d:	e8 02 00 00 00       	call   800384 <vprintfmt>
	va_end(ap);
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	83 ec 3c             	sub    $0x3c,%esp
  80038d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800390:	eb 17                	jmp    8003a9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800392:	85 c0                	test   %eax,%eax
  800394:	0f 84 4b 04 00 00    	je     8007e5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80039a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80039d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003a1:	89 04 24             	mov    %eax,(%esp)
  8003a4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8003a7:	89 fb                	mov    %edi,%ebx
  8003a9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8003ac:	0f b6 03             	movzbl (%ebx),%eax
  8003af:	83 f8 25             	cmp    $0x25,%eax
  8003b2:	75 de                	jne    800392 <vprintfmt+0xe>
  8003b4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8003b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8003c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d0:	eb 18                	jmp    8003ea <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003d4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8003d8:	eb 10                	jmp    8003ea <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003dc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8003e0:	eb 08                	jmp    8003ea <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8003e5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	8d 5f 01             	lea    0x1(%edi),%ebx
  8003ed:	0f b6 17             	movzbl (%edi),%edx
  8003f0:	0f b6 c2             	movzbl %dl,%eax
  8003f3:	83 ea 23             	sub    $0x23,%edx
  8003f6:	80 fa 55             	cmp    $0x55,%dl
  8003f9:	0f 87 c2 03 00 00    	ja     8007c1 <vprintfmt+0x43d>
  8003ff:	0f b6 d2             	movzbl %dl,%edx
  800402:	ff 24 95 c0 2b 80 00 	jmp    *0x802bc0(,%edx,4)
  800409:	89 df                	mov    %ebx,%edi
  80040b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800410:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800413:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800417:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80041a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80041d:	83 fa 09             	cmp    $0x9,%edx
  800420:	77 33                	ja     800455 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800422:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800425:	eb e9                	jmp    800410 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8b 30                	mov    (%eax),%esi
  80042c:	8d 40 04             	lea    0x4(%eax),%eax
  80042f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800432:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800434:	eb 1f                	jmp    800455 <vprintfmt+0xd1>
  800436:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800439:	85 ff                	test   %edi,%edi
  80043b:	b8 00 00 00 00       	mov    $0x0,%eax
  800440:	0f 49 c7             	cmovns %edi,%eax
  800443:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	89 df                	mov    %ebx,%edi
  800448:	eb a0                	jmp    8003ea <vprintfmt+0x66>
  80044a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80044c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800453:	eb 95                	jmp    8003ea <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800455:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800459:	79 8f                	jns    8003ea <vprintfmt+0x66>
  80045b:	eb 85                	jmp    8003e2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80045d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800460:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800462:	eb 86                	jmp    8003ea <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8d 70 04             	lea    0x4(%eax),%esi
  80046a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800471:	8b 45 14             	mov    0x14(%ebp),%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 04 24             	mov    %eax,(%esp)
  800479:	ff 55 08             	call   *0x8(%ebp)
  80047c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80047f:	e9 25 ff ff ff       	jmp    8003a9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8d 70 04             	lea    0x4(%eax),%esi
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	99                   	cltd   
  80048d:	31 d0                	xor    %edx,%eax
  80048f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800491:	83 f8 15             	cmp    $0x15,%eax
  800494:	7f 0b                	jg     8004a1 <vprintfmt+0x11d>
  800496:	8b 14 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%edx
  80049d:	85 d2                	test   %edx,%edx
  80049f:	75 26                	jne    8004c7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8004a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004a5:	c7 44 24 08 9e 2a 80 	movl   $0x802a9e,0x8(%esp)
  8004ac:	00 
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	89 04 24             	mov    %eax,(%esp)
  8004ba:	e8 9d fe ff ff       	call   80035c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004bf:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004c2:	e9 e2 fe ff ff       	jmp    8003a9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004c7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004cb:	c7 44 24 08 72 2e 80 	movl   $0x802e72,0x8(%esp)
  8004d2:	00 
  8004d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	89 04 24             	mov    %eax,(%esp)
  8004e0:	e8 77 fe ff ff       	call   80035c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004e5:	89 75 14             	mov    %esi,0x14(%ebp)
  8004e8:	e9 bc fe ff ff       	jmp    8003a9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004f6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004fa:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004fc:	85 ff                	test   %edi,%edi
  8004fe:	b8 97 2a 80 00       	mov    $0x802a97,%eax
  800503:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800506:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80050a:	0f 84 94 00 00 00    	je     8005a4 <vprintfmt+0x220>
  800510:	85 c9                	test   %ecx,%ecx
  800512:	0f 8e 94 00 00 00    	jle    8005ac <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	89 74 24 04          	mov    %esi,0x4(%esp)
  80051c:	89 3c 24             	mov    %edi,(%esp)
  80051f:	e8 64 03 00 00       	call   800888 <strnlen>
  800524:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800527:	29 c1                	sub    %eax,%ecx
  800529:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80052c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800530:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800533:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800536:	8b 75 08             	mov    0x8(%ebp),%esi
  800539:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80053c:	89 cb                	mov    %ecx,%ebx
  80053e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800540:	eb 0f                	jmp    800551 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800542:	8b 45 0c             	mov    0xc(%ebp),%eax
  800545:	89 44 24 04          	mov    %eax,0x4(%esp)
  800549:	89 3c 24             	mov    %edi,(%esp)
  80054c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80054e:	83 eb 01             	sub    $0x1,%ebx
  800551:	85 db                	test   %ebx,%ebx
  800553:	7f ed                	jg     800542 <vprintfmt+0x1be>
  800555:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800558:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80055b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80055e:	85 c9                	test   %ecx,%ecx
  800560:	b8 00 00 00 00       	mov    $0x0,%eax
  800565:	0f 49 c1             	cmovns %ecx,%eax
  800568:	29 c1                	sub    %eax,%ecx
  80056a:	89 cb                	mov    %ecx,%ebx
  80056c:	eb 44                	jmp    8005b2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80056e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800572:	74 1e                	je     800592 <vprintfmt+0x20e>
  800574:	0f be d2             	movsbl %dl,%edx
  800577:	83 ea 20             	sub    $0x20,%edx
  80057a:	83 fa 5e             	cmp    $0x5e,%edx
  80057d:	76 13                	jbe    800592 <vprintfmt+0x20e>
					putch('?', putdat);
  80057f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800582:	89 44 24 04          	mov    %eax,0x4(%esp)
  800586:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80058d:	ff 55 08             	call   *0x8(%ebp)
  800590:	eb 0d                	jmp    80059f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800592:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800595:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800599:	89 04 24             	mov    %eax,(%esp)
  80059c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80059f:	83 eb 01             	sub    $0x1,%ebx
  8005a2:	eb 0e                	jmp    8005b2 <vprintfmt+0x22e>
  8005a4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005aa:	eb 06                	jmp    8005b2 <vprintfmt+0x22e>
  8005ac:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005b2:	83 c7 01             	add    $0x1,%edi
  8005b5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005b9:	0f be c2             	movsbl %dl,%eax
  8005bc:	85 c0                	test   %eax,%eax
  8005be:	74 27                	je     8005e7 <vprintfmt+0x263>
  8005c0:	85 f6                	test   %esi,%esi
  8005c2:	78 aa                	js     80056e <vprintfmt+0x1ea>
  8005c4:	83 ee 01             	sub    $0x1,%esi
  8005c7:	79 a5                	jns    80056e <vprintfmt+0x1ea>
  8005c9:	89 d8                	mov    %ebx,%eax
  8005cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005d1:	89 c3                	mov    %eax,%ebx
  8005d3:	eb 18                	jmp    8005ed <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005d9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005e0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005e2:	83 eb 01             	sub    $0x1,%ebx
  8005e5:	eb 06                	jmp    8005ed <vprintfmt+0x269>
  8005e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ea:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005ed:	85 db                	test   %ebx,%ebx
  8005ef:	7f e4                	jg     8005d5 <vprintfmt+0x251>
  8005f1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005f4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005fa:	e9 aa fd ff ff       	jmp    8003a9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005ff:	83 f9 01             	cmp    $0x1,%ecx
  800602:	7e 10                	jle    800614 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 30                	mov    (%eax),%esi
  800609:	8b 78 04             	mov    0x4(%eax),%edi
  80060c:	8d 40 08             	lea    0x8(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
  800612:	eb 26                	jmp    80063a <vprintfmt+0x2b6>
	else if (lflag)
  800614:	85 c9                	test   %ecx,%ecx
  800616:	74 12                	je     80062a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 30                	mov    (%eax),%esi
  80061d:	89 f7                	mov    %esi,%edi
  80061f:	c1 ff 1f             	sar    $0x1f,%edi
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	eb 10                	jmp    80063a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 30                	mov    (%eax),%esi
  80062f:	89 f7                	mov    %esi,%edi
  800631:	c1 ff 1f             	sar    $0x1f,%edi
  800634:	8d 40 04             	lea    0x4(%eax),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80063a:	89 f0                	mov    %esi,%eax
  80063c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80063e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800643:	85 ff                	test   %edi,%edi
  800645:	0f 89 3a 01 00 00    	jns    800785 <vprintfmt+0x401>
				putch('-', putdat);
  80064b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800652:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800659:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80065c:	89 f0                	mov    %esi,%eax
  80065e:	89 fa                	mov    %edi,%edx
  800660:	f7 d8                	neg    %eax
  800662:	83 d2 00             	adc    $0x0,%edx
  800665:	f7 da                	neg    %edx
			}
			base = 10;
  800667:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80066c:	e9 14 01 00 00       	jmp    800785 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800671:	83 f9 01             	cmp    $0x1,%ecx
  800674:	7e 13                	jle    800689 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 50 04             	mov    0x4(%eax),%edx
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	8b 75 14             	mov    0x14(%ebp),%esi
  800681:	8d 4e 08             	lea    0x8(%esi),%ecx
  800684:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800687:	eb 2c                	jmp    8006b5 <vprintfmt+0x331>
	else if (lflag)
  800689:	85 c9                	test   %ecx,%ecx
  80068b:	74 15                	je     8006a2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
  800697:	8b 75 14             	mov    0x14(%ebp),%esi
  80069a:	8d 76 04             	lea    0x4(%esi),%esi
  80069d:	89 75 14             	mov    %esi,0x14(%ebp)
  8006a0:	eb 13                	jmp    8006b5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ac:	8b 75 14             	mov    0x14(%ebp),%esi
  8006af:	8d 76 04             	lea    0x4(%esi),%esi
  8006b2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8006b5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006ba:	e9 c6 00 00 00       	jmp    800785 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006bf:	83 f9 01             	cmp    $0x1,%ecx
  8006c2:	7e 13                	jle    8006d7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8b 75 14             	mov    0x14(%ebp),%esi
  8006cf:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006d2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006d5:	eb 24                	jmp    8006fb <vprintfmt+0x377>
	else if (lflag)
  8006d7:	85 c9                	test   %ecx,%ecx
  8006d9:	74 11                	je     8006ec <vprintfmt+0x368>
		return va_arg(*ap, long);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	99                   	cltd   
  8006e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8006e4:	8d 71 04             	lea    0x4(%ecx),%esi
  8006e7:	89 75 14             	mov    %esi,0x14(%ebp)
  8006ea:	eb 0f                	jmp    8006fb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	99                   	cltd   
  8006f2:	8b 75 14             	mov    0x14(%ebp),%esi
  8006f5:	8d 76 04             	lea    0x4(%esi),%esi
  8006f8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8006fb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800700:	e9 80 00 00 00       	jmp    800785 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800705:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800716:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800720:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800727:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80072a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80072e:	8b 06                	mov    (%esi),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800735:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80073a:	eb 49                	jmp    800785 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80073c:	83 f9 01             	cmp    $0x1,%ecx
  80073f:	7e 13                	jle    800754 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 50 04             	mov    0x4(%eax),%edx
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8b 75 14             	mov    0x14(%ebp),%esi
  80074c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80074f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800752:	eb 2c                	jmp    800780 <vprintfmt+0x3fc>
	else if (lflag)
  800754:	85 c9                	test   %ecx,%ecx
  800756:	74 15                	je     80076d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
  800762:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800765:	8d 71 04             	lea    0x4(%ecx),%esi
  800768:	89 75 14             	mov    %esi,0x14(%ebp)
  80076b:	eb 13                	jmp    800780 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	8b 75 14             	mov    0x14(%ebp),%esi
  80077a:	8d 76 04             	lea    0x4(%esi),%esi
  80077d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800780:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800785:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800789:	89 74 24 10          	mov    %esi,0x10(%esp)
  80078d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800790:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800794:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800798:	89 04 24             	mov    %eax,(%esp)
  80079b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80079f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	e8 a6 fa ff ff       	call   800250 <printnum>
			break;
  8007aa:	e9 fa fb ff ff       	jmp    8003a9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007b6:	89 04 24             	mov    %eax,(%esp)
  8007b9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007bc:	e9 e8 fb ff ff       	jmp    8003a9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007cf:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d2:	89 fb                	mov    %edi,%ebx
  8007d4:	eb 03                	jmp    8007d9 <vprintfmt+0x455>
  8007d6:	83 eb 01             	sub    $0x1,%ebx
  8007d9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007dd:	75 f7                	jne    8007d6 <vprintfmt+0x452>
  8007df:	90                   	nop
  8007e0:	e9 c4 fb ff ff       	jmp    8003a9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007e5:	83 c4 3c             	add    $0x3c,%esp
  8007e8:	5b                   	pop    %ebx
  8007e9:	5e                   	pop    %esi
  8007ea:	5f                   	pop    %edi
  8007eb:	5d                   	pop    %ebp
  8007ec:	c3                   	ret    

008007ed <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	83 ec 28             	sub    $0x28,%esp
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007fc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800800:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80080a:	85 c0                	test   %eax,%eax
  80080c:	74 30                	je     80083e <vsnprintf+0x51>
  80080e:	85 d2                	test   %edx,%edx
  800810:	7e 2c                	jle    80083e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800820:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800823:	89 44 24 04          	mov    %eax,0x4(%esp)
  800827:	c7 04 24 3f 03 80 00 	movl   $0x80033f,(%esp)
  80082e:	e8 51 fb ff ff       	call   800384 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800836:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80083c:	eb 05                	jmp    800843 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80083e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800843:	c9                   	leave  
  800844:	c3                   	ret    

00800845 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80084b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80084e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	89 44 24 08          	mov    %eax,0x8(%esp)
  800859:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	89 04 24             	mov    %eax,(%esp)
  800866:	e8 82 ff ff ff       	call   8007ed <vsnprintf>
	va_end(ap);

	return rc;
}
  80086b:	c9                   	leave  
  80086c:	c3                   	ret    
  80086d:	66 90                	xchg   %ax,%ax
  80086f:	90                   	nop

00800870 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	eb 03                	jmp    800880 <strlen+0x10>
		n++;
  80087d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800880:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800884:	75 f7                	jne    80087d <strlen+0xd>
		n++;
	return n;
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	eb 03                	jmp    80089b <strnlen+0x13>
		n++;
  800898:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089b:	39 d0                	cmp    %edx,%eax
  80089d:	74 06                	je     8008a5 <strnlen+0x1d>
  80089f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008a3:	75 f3                	jne    800898 <strnlen+0x10>
		n++;
	return n;
}
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	53                   	push   %ebx
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b1:	89 c2                	mov    %eax,%edx
  8008b3:	83 c2 01             	add    $0x1,%edx
  8008b6:	83 c1 01             	add    $0x1,%ecx
  8008b9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008bd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c0:	84 db                	test   %bl,%bl
  8008c2:	75 ef                	jne    8008b3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008c4:	5b                   	pop    %ebx
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d1:	89 1c 24             	mov    %ebx,(%esp)
  8008d4:	e8 97 ff ff ff       	call   800870 <strlen>
	strcpy(dst + len, src);
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008e0:	01 d8                	add    %ebx,%eax
  8008e2:	89 04 24             	mov    %eax,(%esp)
  8008e5:	e8 bd ff ff ff       	call   8008a7 <strcpy>
	return dst;
}
  8008ea:	89 d8                	mov    %ebx,%eax
  8008ec:	83 c4 08             	add    $0x8,%esp
  8008ef:	5b                   	pop    %ebx
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	56                   	push   %esi
  8008f6:	53                   	push   %ebx
  8008f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008fd:	89 f3                	mov    %esi,%ebx
  8008ff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800902:	89 f2                	mov    %esi,%edx
  800904:	eb 0f                	jmp    800915 <strncpy+0x23>
		*dst++ = *src;
  800906:	83 c2 01             	add    $0x1,%edx
  800909:	0f b6 01             	movzbl (%ecx),%eax
  80090c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80090f:	80 39 01             	cmpb   $0x1,(%ecx)
  800912:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800915:	39 da                	cmp    %ebx,%edx
  800917:	75 ed                	jne    800906 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800919:	89 f0                	mov    %esi,%eax
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	56                   	push   %esi
  800923:	53                   	push   %ebx
  800924:	8b 75 08             	mov    0x8(%ebp),%esi
  800927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80092d:	89 f0                	mov    %esi,%eax
  80092f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800933:	85 c9                	test   %ecx,%ecx
  800935:	75 0b                	jne    800942 <strlcpy+0x23>
  800937:	eb 1d                	jmp    800956 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800939:	83 c0 01             	add    $0x1,%eax
  80093c:	83 c2 01             	add    $0x1,%edx
  80093f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800942:	39 d8                	cmp    %ebx,%eax
  800944:	74 0b                	je     800951 <strlcpy+0x32>
  800946:	0f b6 0a             	movzbl (%edx),%ecx
  800949:	84 c9                	test   %cl,%cl
  80094b:	75 ec                	jne    800939 <strlcpy+0x1a>
  80094d:	89 c2                	mov    %eax,%edx
  80094f:	eb 02                	jmp    800953 <strlcpy+0x34>
  800951:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800953:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800956:	29 f0                	sub    %esi,%eax
}
  800958:	5b                   	pop    %ebx
  800959:	5e                   	pop    %esi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800962:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800965:	eb 06                	jmp    80096d <strcmp+0x11>
		p++, q++;
  800967:	83 c1 01             	add    $0x1,%ecx
  80096a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80096d:	0f b6 01             	movzbl (%ecx),%eax
  800970:	84 c0                	test   %al,%al
  800972:	74 04                	je     800978 <strcmp+0x1c>
  800974:	3a 02                	cmp    (%edx),%al
  800976:	74 ef                	je     800967 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 c0             	movzbl %al,%eax
  80097b:	0f b6 12             	movzbl (%edx),%edx
  80097e:	29 d0                	sub    %edx,%eax
}
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	53                   	push   %ebx
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 c3                	mov    %eax,%ebx
  80098e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800991:	eb 06                	jmp    800999 <strncmp+0x17>
		n--, p++, q++;
  800993:	83 c0 01             	add    $0x1,%eax
  800996:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800999:	39 d8                	cmp    %ebx,%eax
  80099b:	74 15                	je     8009b2 <strncmp+0x30>
  80099d:	0f b6 08             	movzbl (%eax),%ecx
  8009a0:	84 c9                	test   %cl,%cl
  8009a2:	74 04                	je     8009a8 <strncmp+0x26>
  8009a4:	3a 0a                	cmp    (%edx),%cl
  8009a6:	74 eb                	je     800993 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 00             	movzbl (%eax),%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
  8009b0:	eb 05                	jmp    8009b7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c4:	eb 07                	jmp    8009cd <strchr+0x13>
		if (*s == c)
  8009c6:	38 ca                	cmp    %cl,%dl
  8009c8:	74 0f                	je     8009d9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ca:	83 c0 01             	add    $0x1,%eax
  8009cd:	0f b6 10             	movzbl (%eax),%edx
  8009d0:	84 d2                	test   %dl,%dl
  8009d2:	75 f2                	jne    8009c6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e5:	eb 07                	jmp    8009ee <strfind+0x13>
		if (*s == c)
  8009e7:	38 ca                	cmp    %cl,%dl
  8009e9:	74 0a                	je     8009f5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009eb:	83 c0 01             	add    $0x1,%eax
  8009ee:	0f b6 10             	movzbl (%eax),%edx
  8009f1:	84 d2                	test   %dl,%dl
  8009f3:	75 f2                	jne    8009e7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	57                   	push   %edi
  8009fb:	56                   	push   %esi
  8009fc:	53                   	push   %ebx
  8009fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a03:	85 c9                	test   %ecx,%ecx
  800a05:	74 36                	je     800a3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0d:	75 28                	jne    800a37 <memset+0x40>
  800a0f:	f6 c1 03             	test   $0x3,%cl
  800a12:	75 23                	jne    800a37 <memset+0x40>
		c &= 0xFF;
  800a14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a18:	89 d3                	mov    %edx,%ebx
  800a1a:	c1 e3 08             	shl    $0x8,%ebx
  800a1d:	89 d6                	mov    %edx,%esi
  800a1f:	c1 e6 18             	shl    $0x18,%esi
  800a22:	89 d0                	mov    %edx,%eax
  800a24:	c1 e0 10             	shl    $0x10,%eax
  800a27:	09 f0                	or     %esi,%eax
  800a29:	09 c2                	or     %eax,%edx
  800a2b:	89 d0                	mov    %edx,%eax
  800a2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a32:	fc                   	cld    
  800a33:	f3 ab                	rep stos %eax,%es:(%edi)
  800a35:	eb 06                	jmp    800a3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3a:	fc                   	cld    
  800a3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3d:	89 f8                	mov    %edi,%eax
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	57                   	push   %edi
  800a48:	56                   	push   %esi
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a52:	39 c6                	cmp    %eax,%esi
  800a54:	73 35                	jae    800a8b <memmove+0x47>
  800a56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a59:	39 d0                	cmp    %edx,%eax
  800a5b:	73 2e                	jae    800a8b <memmove+0x47>
		s += n;
		d += n;
  800a5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a60:	89 d6                	mov    %edx,%esi
  800a62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6a:	75 13                	jne    800a7f <memmove+0x3b>
  800a6c:	f6 c1 03             	test   $0x3,%cl
  800a6f:	75 0e                	jne    800a7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a71:	83 ef 04             	sub    $0x4,%edi
  800a74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a7a:	fd                   	std    
  800a7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7d:	eb 09                	jmp    800a88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a7f:	83 ef 01             	sub    $0x1,%edi
  800a82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a85:	fd                   	std    
  800a86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a88:	fc                   	cld    
  800a89:	eb 1d                	jmp    800aa8 <memmove+0x64>
  800a8b:	89 f2                	mov    %esi,%edx
  800a8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	f6 c2 03             	test   $0x3,%dl
  800a92:	75 0f                	jne    800aa3 <memmove+0x5f>
  800a94:	f6 c1 03             	test   $0x3,%cl
  800a97:	75 0a                	jne    800aa3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a9c:	89 c7                	mov    %eax,%edi
  800a9e:	fc                   	cld    
  800a9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa1:	eb 05                	jmp    800aa8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aa3:	89 c7                	mov    %eax,%edi
  800aa5:	fc                   	cld    
  800aa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa8:	5e                   	pop    %esi
  800aa9:	5f                   	pop    %edi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	89 04 24             	mov    %eax,(%esp)
  800ac6:	e8 79 ff ff ff       	call   800a44 <memmove>
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad8:	89 d6                	mov    %edx,%esi
  800ada:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800add:	eb 1a                	jmp    800af9 <memcmp+0x2c>
		if (*s1 != *s2)
  800adf:	0f b6 02             	movzbl (%edx),%eax
  800ae2:	0f b6 19             	movzbl (%ecx),%ebx
  800ae5:	38 d8                	cmp    %bl,%al
  800ae7:	74 0a                	je     800af3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ae9:	0f b6 c0             	movzbl %al,%eax
  800aec:	0f b6 db             	movzbl %bl,%ebx
  800aef:	29 d8                	sub    %ebx,%eax
  800af1:	eb 0f                	jmp    800b02 <memcmp+0x35>
		s1++, s2++;
  800af3:	83 c2 01             	add    $0x1,%edx
  800af6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af9:	39 f2                	cmp    %esi,%edx
  800afb:	75 e2                	jne    800adf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b0f:	89 c2                	mov    %eax,%edx
  800b11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b14:	eb 07                	jmp    800b1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b16:	38 08                	cmp    %cl,(%eax)
  800b18:	74 07                	je     800b21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	39 d0                	cmp    %edx,%eax
  800b1f:	72 f5                	jb     800b16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b2f:	eb 03                	jmp    800b34 <strtol+0x11>
		s++;
  800b31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b34:	0f b6 0a             	movzbl (%edx),%ecx
  800b37:	80 f9 09             	cmp    $0x9,%cl
  800b3a:	74 f5                	je     800b31 <strtol+0xe>
  800b3c:	80 f9 20             	cmp    $0x20,%cl
  800b3f:	74 f0                	je     800b31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b41:	80 f9 2b             	cmp    $0x2b,%cl
  800b44:	75 0a                	jne    800b50 <strtol+0x2d>
		s++;
  800b46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b49:	bf 00 00 00 00       	mov    $0x0,%edi
  800b4e:	eb 11                	jmp    800b61 <strtol+0x3e>
  800b50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b55:	80 f9 2d             	cmp    $0x2d,%cl
  800b58:	75 07                	jne    800b61 <strtol+0x3e>
		s++, neg = 1;
  800b5a:	8d 52 01             	lea    0x1(%edx),%edx
  800b5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b66:	75 15                	jne    800b7d <strtol+0x5a>
  800b68:	80 3a 30             	cmpb   $0x30,(%edx)
  800b6b:	75 10                	jne    800b7d <strtol+0x5a>
  800b6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b71:	75 0a                	jne    800b7d <strtol+0x5a>
		s += 2, base = 16;
  800b73:	83 c2 02             	add    $0x2,%edx
  800b76:	b8 10 00 00 00       	mov    $0x10,%eax
  800b7b:	eb 10                	jmp    800b8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b7d:	85 c0                	test   %eax,%eax
  800b7f:	75 0c                	jne    800b8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b83:	80 3a 30             	cmpb   $0x30,(%edx)
  800b86:	75 05                	jne    800b8d <strtol+0x6a>
		s++, base = 8;
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b95:	0f b6 0a             	movzbl (%edx),%ecx
  800b98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b9b:	89 f0                	mov    %esi,%eax
  800b9d:	3c 09                	cmp    $0x9,%al
  800b9f:	77 08                	ja     800ba9 <strtol+0x86>
			dig = *s - '0';
  800ba1:	0f be c9             	movsbl %cl,%ecx
  800ba4:	83 e9 30             	sub    $0x30,%ecx
  800ba7:	eb 20                	jmp    800bc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ba9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bac:	89 f0                	mov    %esi,%eax
  800bae:	3c 19                	cmp    $0x19,%al
  800bb0:	77 08                	ja     800bba <strtol+0x97>
			dig = *s - 'a' + 10;
  800bb2:	0f be c9             	movsbl %cl,%ecx
  800bb5:	83 e9 57             	sub    $0x57,%ecx
  800bb8:	eb 0f                	jmp    800bc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bbd:	89 f0                	mov    %esi,%eax
  800bbf:	3c 19                	cmp    $0x19,%al
  800bc1:	77 16                	ja     800bd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bc3:	0f be c9             	movsbl %cl,%ecx
  800bc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bcc:	7d 0f                	jge    800bdd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bce:	83 c2 01             	add    $0x1,%edx
  800bd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bd7:	eb bc                	jmp    800b95 <strtol+0x72>
  800bd9:	89 d8                	mov    %ebx,%eax
  800bdb:	eb 02                	jmp    800bdf <strtol+0xbc>
  800bdd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be3:	74 05                	je     800bea <strtol+0xc7>
		*endptr = (char *) s;
  800be5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bea:	f7 d8                	neg    %eax
  800bec:	85 ff                	test   %edi,%edi
  800bee:	0f 44 c3             	cmove  %ebx,%eax
}
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800c01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c04:	8b 55 08             	mov    0x8(%ebp),%edx
  800c07:	89 c3                	mov    %eax,%ebx
  800c09:	89 c7                	mov    %eax,%edi
  800c0b:	89 c6                	mov    %eax,%esi
  800c0d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c24:	89 d1                	mov    %edx,%ecx
  800c26:	89 d3                	mov    %edx,%ebx
  800c28:	89 d7                	mov    %edx,%edi
  800c2a:	89 d6                	mov    %edx,%esi
  800c2c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c41:	b8 03 00 00 00       	mov    $0x3,%eax
  800c46:	8b 55 08             	mov    0x8(%ebp),%edx
  800c49:	89 cb                	mov    %ecx,%ebx
  800c4b:	89 cf                	mov    %ecx,%edi
  800c4d:	89 ce                	mov    %ecx,%esi
  800c4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c51:	85 c0                	test   %eax,%eax
  800c53:	7e 28                	jle    800c7d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c59:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c60:	00 
  800c61:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800c68:	00 
  800c69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c70:	00 
  800c71:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800c78:	e8 89 19 00 00       	call   802606 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7d:	83 c4 2c             	add    $0x2c,%esp
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c93:	b8 04 00 00 00       	mov    $0x4,%eax
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	89 cb                	mov    %ecx,%ebx
  800c9d:	89 cf                	mov    %ecx,%edi
  800c9f:	89 ce                	mov    %ecx,%esi
  800ca1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	7e 28                	jle    800ccf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cb2:	00 
  800cb3:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800cba:	00 
  800cbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc2:	00 
  800cc3:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800cca:	e8 37 19 00 00       	call   802606 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800ccf:	83 c4 2c             	add    $0x2c,%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce7:	89 d1                	mov    %edx,%ecx
  800ce9:	89 d3                	mov    %edx,%ebx
  800ceb:	89 d7                	mov    %edx,%edi
  800ced:	89 d6                	mov    %edx,%esi
  800cef:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_yield>:

void
sys_yield(void)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800d01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d06:	89 d1                	mov    %edx,%ecx
  800d08:	89 d3                	mov    %edx,%ebx
  800d0a:	89 d7                	mov    %edx,%edi
  800d0c:	89 d6                	mov    %edx,%esi
  800d0e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1e:	be 00 00 00 00       	mov    $0x0,%esi
  800d23:	b8 05 00 00 00       	mov    $0x5,%eax
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d31:	89 f7                	mov    %esi,%edi
  800d33:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7e 28                	jle    800d61 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d39:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d3d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d44:	00 
  800d45:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800d4c:	00 
  800d4d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d54:	00 
  800d55:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800d5c:	e8 a5 18 00 00       	call   802606 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d61:	83 c4 2c             	add    $0x2c,%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d72:	b8 06 00 00 00       	mov    $0x6,%eax
  800d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d80:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d83:	8b 75 18             	mov    0x18(%ebp),%esi
  800d86:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	7e 28                	jle    800db4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d90:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d97:	00 
  800d98:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800d9f:	00 
  800da0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da7:	00 
  800da8:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800daf:	e8 52 18 00 00       	call   802606 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800db4:	83 c4 2c             	add    $0x2c,%esp
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	57                   	push   %edi
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
  800dc2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dca:	b8 07 00 00 00       	mov    $0x7,%eax
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	89 df                	mov    %ebx,%edi
  800dd7:	89 de                	mov    %ebx,%esi
  800dd9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	7e 28                	jle    800e07 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800dea:	00 
  800deb:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800df2:	00 
  800df3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfa:	00 
  800dfb:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800e02:	e8 ff 17 00 00       	call   802606 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e07:	83 c4 2c             	add    $0x2c,%esp
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    

00800e0f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e15:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e22:	89 cb                	mov    %ecx,%ebx
  800e24:	89 cf                	mov    %ecx,%edi
  800e26:	89 ce                	mov    %ecx,%esi
  800e28:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	89 df                	mov    %ebx,%edi
  800e4a:	89 de                	mov    %ebx,%esi
  800e4c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	7e 28                	jle    800e7a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e56:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e5d:	00 
  800e5e:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800e65:	00 
  800e66:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e6d:	00 
  800e6e:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800e75:	e8 8c 17 00 00       	call   802606 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e7a:	83 c4 2c             	add    $0x2c,%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
  800e88:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e90:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	89 df                	mov    %ebx,%edi
  800e9d:	89 de                	mov    %ebx,%esi
  800e9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	7e 28                	jle    800ecd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800eb8:	00 
  800eb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec0:	00 
  800ec1:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800ec8:	e8 39 17 00 00       	call   802606 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ecd:	83 c4 2c             	add    $0x2c,%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800ede:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  800eee:	89 df                	mov    %ebx,%edi
  800ef0:	89 de                	mov    %ebx,%esi
  800ef2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	7e 28                	jle    800f20 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f03:	00 
  800f04:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800f0b:	00 
  800f0c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f13:	00 
  800f14:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800f1b:	e8 e6 16 00 00       	call   802606 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f20:	83 c4 2c             	add    $0x2c,%esp
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	57                   	push   %edi
  800f2c:	56                   	push   %esi
  800f2d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2e:	be 00 00 00 00       	mov    $0x0,%esi
  800f33:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f41:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f44:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5f                   	pop    %edi
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    

00800f4b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
  800f51:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f59:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f61:	89 cb                	mov    %ecx,%ebx
  800f63:	89 cf                	mov    %ecx,%edi
  800f65:	89 ce                	mov    %ecx,%esi
  800f67:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	7e 28                	jle    800f95 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f71:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f78:	00 
  800f79:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  800f80:	00 
  800f81:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f88:	00 
  800f89:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800f90:	e8 71 16 00 00       	call   802606 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f95:	83 c4 2c             	add    $0x2c,%esp
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	57                   	push   %edi
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fad:	89 d1                	mov    %edx,%ecx
  800faf:	89 d3                	mov    %edx,%ebx
  800fb1:	89 d7                	mov    %edx,%edi
  800fb3:	89 d6                	mov    %edx,%esi
  800fb5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd2:	89 df                	mov    %ebx,%edi
  800fd4:	89 de                	mov    %ebx,%esi
  800fd6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
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
  800fe3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe8:	b8 12 00 00 00       	mov    $0x12,%eax
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	89 df                	mov    %ebx,%edi
  800ff5:	89 de                	mov    %ebx,%esi
  800ff7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800ff9:	5b                   	pop    %ebx
  800ffa:	5e                   	pop    %esi
  800ffb:	5f                   	pop    %edi
  800ffc:	5d                   	pop    %ebp
  800ffd:	c3                   	ret    

00800ffe <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801004:	b9 00 00 00 00       	mov    $0x0,%ecx
  801009:	b8 13 00 00 00       	mov    $0x13,%eax
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	89 cb                	mov    %ecx,%ebx
  801013:	89 cf                	mov    %ecx,%edi
  801015:	89 ce                	mov    %ecx,%esi
  801017:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	53                   	push   %ebx
  801022:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801025:	8b 55 0c             	mov    0xc(%ebp),%edx
  801028:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80102b:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  80102d:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801030:	bb 00 00 00 00       	mov    $0x0,%ebx
  801035:	83 39 01             	cmpl   $0x1,(%ecx)
  801038:	7e 0f                	jle    801049 <argstart+0x2b>
  80103a:	85 d2                	test   %edx,%edx
  80103c:	ba 00 00 00 00       	mov    $0x0,%edx
  801041:	bb 51 2a 80 00       	mov    $0x802a51,%ebx
  801046:	0f 44 da             	cmove  %edx,%ebx
  801049:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  80104c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801053:	5b                   	pop    %ebx
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <argnext>:

int
argnext(struct Argstate *args)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	53                   	push   %ebx
  80105a:	83 ec 14             	sub    $0x14,%esp
  80105d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801060:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801067:	8b 43 08             	mov    0x8(%ebx),%eax
  80106a:	85 c0                	test   %eax,%eax
  80106c:	74 71                	je     8010df <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  80106e:	80 38 00             	cmpb   $0x0,(%eax)
  801071:	75 50                	jne    8010c3 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801073:	8b 0b                	mov    (%ebx),%ecx
  801075:	83 39 01             	cmpl   $0x1,(%ecx)
  801078:	74 57                	je     8010d1 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  80107a:	8b 53 04             	mov    0x4(%ebx),%edx
  80107d:	8b 42 04             	mov    0x4(%edx),%eax
  801080:	80 38 2d             	cmpb   $0x2d,(%eax)
  801083:	75 4c                	jne    8010d1 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801085:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801089:	74 46                	je     8010d1 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80108b:	83 c0 01             	add    $0x1,%eax
  80108e:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801091:	8b 01                	mov    (%ecx),%eax
  801093:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80109a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80109e:	8d 42 08             	lea    0x8(%edx),%eax
  8010a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010a5:	83 c2 04             	add    $0x4,%edx
  8010a8:	89 14 24             	mov    %edx,(%esp)
  8010ab:	e8 94 f9 ff ff       	call   800a44 <memmove>
		(*args->argc)--;
  8010b0:	8b 03                	mov    (%ebx),%eax
  8010b2:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8010b5:	8b 43 08             	mov    0x8(%ebx),%eax
  8010b8:	80 38 2d             	cmpb   $0x2d,(%eax)
  8010bb:	75 06                	jne    8010c3 <argnext+0x6d>
  8010bd:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8010c1:	74 0e                	je     8010d1 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8010c3:	8b 53 08             	mov    0x8(%ebx),%edx
  8010c6:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8010c9:	83 c2 01             	add    $0x1,%edx
  8010cc:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  8010cf:	eb 13                	jmp    8010e4 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  8010d1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8010d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010dd:	eb 05                	jmp    8010e4 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  8010df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8010e4:	83 c4 14             	add    $0x14,%esp
  8010e7:	5b                   	pop    %ebx
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	53                   	push   %ebx
  8010ee:	83 ec 14             	sub    $0x14,%esp
  8010f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8010f4:	8b 43 08             	mov    0x8(%ebx),%eax
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	74 5a                	je     801155 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  8010fb:	80 38 00             	cmpb   $0x0,(%eax)
  8010fe:	74 0c                	je     80110c <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801100:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801103:	c7 43 08 51 2a 80 00 	movl   $0x802a51,0x8(%ebx)
  80110a:	eb 44                	jmp    801150 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  80110c:	8b 03                	mov    (%ebx),%eax
  80110e:	83 38 01             	cmpl   $0x1,(%eax)
  801111:	7e 2f                	jle    801142 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801113:	8b 53 04             	mov    0x4(%ebx),%edx
  801116:	8b 4a 04             	mov    0x4(%edx),%ecx
  801119:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80111c:	8b 00                	mov    (%eax),%eax
  80111e:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801125:	89 44 24 08          	mov    %eax,0x8(%esp)
  801129:	8d 42 08             	lea    0x8(%edx),%eax
  80112c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801130:	83 c2 04             	add    $0x4,%edx
  801133:	89 14 24             	mov    %edx,(%esp)
  801136:	e8 09 f9 ff ff       	call   800a44 <memmove>
		(*args->argc)--;
  80113b:	8b 03                	mov    (%ebx),%eax
  80113d:	83 28 01             	subl   $0x1,(%eax)
  801140:	eb 0e                	jmp    801150 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801142:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801149:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801150:	8b 43 0c             	mov    0xc(%ebx),%eax
  801153:	eb 05                	jmp    80115a <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801155:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  80115a:	83 c4 14             	add    $0x14,%esp
  80115d:	5b                   	pop    %ebx
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    

00801160 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 18             	sub    $0x18,%esp
  801166:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801169:	8b 51 0c             	mov    0xc(%ecx),%edx
  80116c:	89 d0                	mov    %edx,%eax
  80116e:	85 d2                	test   %edx,%edx
  801170:	75 08                	jne    80117a <argvalue+0x1a>
  801172:	89 0c 24             	mov    %ecx,(%esp)
  801175:	e8 70 ff ff ff       	call   8010ea <argnextvalue>
}
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    
  80117c:	66 90                	xchg   %ax,%ax
  80117e:	66 90                	xchg   %ax,%ax

00801180 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	05 00 00 00 30       	add    $0x30000000,%eax
  80118b:	c1 e8 0c             	shr    $0xc,%eax
}
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80119b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ad:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011b2:	89 c2                	mov    %eax,%edx
  8011b4:	c1 ea 16             	shr    $0x16,%edx
  8011b7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011be:	f6 c2 01             	test   $0x1,%dl
  8011c1:	74 11                	je     8011d4 <fd_alloc+0x2d>
  8011c3:	89 c2                	mov    %eax,%edx
  8011c5:	c1 ea 0c             	shr    $0xc,%edx
  8011c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011cf:	f6 c2 01             	test   $0x1,%dl
  8011d2:	75 09                	jne    8011dd <fd_alloc+0x36>
			*fd_store = fd;
  8011d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011db:	eb 17                	jmp    8011f4 <fd_alloc+0x4d>
  8011dd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011e7:	75 c9                	jne    8011b2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011e9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011ef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011fc:	83 f8 1f             	cmp    $0x1f,%eax
  8011ff:	77 36                	ja     801237 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801201:	c1 e0 0c             	shl    $0xc,%eax
  801204:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801209:	89 c2                	mov    %eax,%edx
  80120b:	c1 ea 16             	shr    $0x16,%edx
  80120e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801215:	f6 c2 01             	test   $0x1,%dl
  801218:	74 24                	je     80123e <fd_lookup+0x48>
  80121a:	89 c2                	mov    %eax,%edx
  80121c:	c1 ea 0c             	shr    $0xc,%edx
  80121f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801226:	f6 c2 01             	test   $0x1,%dl
  801229:	74 1a                	je     801245 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80122b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122e:	89 02                	mov    %eax,(%edx)
	return 0;
  801230:	b8 00 00 00 00       	mov    $0x0,%eax
  801235:	eb 13                	jmp    80124a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801237:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123c:	eb 0c                	jmp    80124a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80123e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801243:	eb 05                	jmp    80124a <fd_lookup+0x54>
  801245:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 18             	sub    $0x18,%esp
  801252:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801255:	ba 00 00 00 00       	mov    $0x0,%edx
  80125a:	eb 13                	jmp    80126f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80125c:	39 08                	cmp    %ecx,(%eax)
  80125e:	75 0c                	jne    80126c <dev_lookup+0x20>
			*dev = devtab[i];
  801260:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801263:	89 01                	mov    %eax,(%ecx)
			return 0;
  801265:	b8 00 00 00 00       	mov    $0x0,%eax
  80126a:	eb 38                	jmp    8012a4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80126c:	83 c2 01             	add    $0x1,%edx
  80126f:	8b 04 95 40 2e 80 00 	mov    0x802e40(,%edx,4),%eax
  801276:	85 c0                	test   %eax,%eax
  801278:	75 e2                	jne    80125c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80127a:	a1 08 40 80 00       	mov    0x804008,%eax
  80127f:	8b 40 48             	mov    0x48(%eax),%eax
  801282:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801286:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128a:	c7 04 24 c4 2d 80 00 	movl   $0x802dc4,(%esp)
  801291:	e8 a0 ef ff ff       	call   800236 <cprintf>
	*dev = 0;
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80129f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	56                   	push   %esi
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 20             	sub    $0x20,%esp
  8012ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012c1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c4:	89 04 24             	mov    %eax,(%esp)
  8012c7:	e8 2a ff ff ff       	call   8011f6 <fd_lookup>
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	78 05                	js     8012d5 <fd_close+0x2f>
	    || fd != fd2)
  8012d0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8012d3:	74 0c                	je     8012e1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8012d5:	84 db                	test   %bl,%bl
  8012d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012dc:	0f 44 c2             	cmove  %edx,%eax
  8012df:	eb 3f                	jmp    801320 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e8:	8b 06                	mov    (%esi),%eax
  8012ea:	89 04 24             	mov    %eax,(%esp)
  8012ed:	e8 5a ff ff ff       	call   80124c <dev_lookup>
  8012f2:	89 c3                	mov    %eax,%ebx
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	78 16                	js     80130e <fd_close+0x68>
		if (dev->dev_close)
  8012f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012fe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801303:	85 c0                	test   %eax,%eax
  801305:	74 07                	je     80130e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801307:	89 34 24             	mov    %esi,(%esp)
  80130a:	ff d0                	call   *%eax
  80130c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80130e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801319:	e8 9e fa ff ff       	call   800dbc <sys_page_unmap>
	return r;
  80131e:	89 d8                	mov    %ebx,%eax
}
  801320:	83 c4 20             	add    $0x20,%esp
  801323:	5b                   	pop    %ebx
  801324:	5e                   	pop    %esi
  801325:	5d                   	pop    %ebp
  801326:	c3                   	ret    

00801327 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80132d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801330:	89 44 24 04          	mov    %eax,0x4(%esp)
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	89 04 24             	mov    %eax,(%esp)
  80133a:	e8 b7 fe ff ff       	call   8011f6 <fd_lookup>
  80133f:	89 c2                	mov    %eax,%edx
  801341:	85 d2                	test   %edx,%edx
  801343:	78 13                	js     801358 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801345:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80134c:	00 
  80134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801350:	89 04 24             	mov    %eax,(%esp)
  801353:	e8 4e ff ff ff       	call   8012a6 <fd_close>
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <close_all>:

void
close_all(void)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	53                   	push   %ebx
  80135e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801361:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801366:	89 1c 24             	mov    %ebx,(%esp)
  801369:	e8 b9 ff ff ff       	call   801327 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80136e:	83 c3 01             	add    $0x1,%ebx
  801371:	83 fb 20             	cmp    $0x20,%ebx
  801374:	75 f0                	jne    801366 <close_all+0xc>
		close(i);
}
  801376:	83 c4 14             	add    $0x14,%esp
  801379:	5b                   	pop    %ebx
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	57                   	push   %edi
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801385:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 04 24             	mov    %eax,(%esp)
  801392:	e8 5f fe ff ff       	call   8011f6 <fd_lookup>
  801397:	89 c2                	mov    %eax,%edx
  801399:	85 d2                	test   %edx,%edx
  80139b:	0f 88 e1 00 00 00    	js     801482 <dup+0x106>
		return r;
	close(newfdnum);
  8013a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a4:	89 04 24             	mov    %eax,(%esp)
  8013a7:	e8 7b ff ff ff       	call   801327 <close>

	newfd = INDEX2FD(newfdnum);
  8013ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8013af:	c1 e3 0c             	shl    $0xc,%ebx
  8013b2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8013b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bb:	89 04 24             	mov    %eax,(%esp)
  8013be:	e8 cd fd ff ff       	call   801190 <fd2data>
  8013c3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8013c5:	89 1c 24             	mov    %ebx,(%esp)
  8013c8:	e8 c3 fd ff ff       	call   801190 <fd2data>
  8013cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	c1 e8 16             	shr    $0x16,%eax
  8013d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013db:	a8 01                	test   $0x1,%al
  8013dd:	74 43                	je     801422 <dup+0xa6>
  8013df:	89 f0                	mov    %esi,%eax
  8013e1:	c1 e8 0c             	shr    $0xc,%eax
  8013e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013eb:	f6 c2 01             	test   $0x1,%dl
  8013ee:	74 32                	je     801422 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801400:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801404:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80140b:	00 
  80140c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801410:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801417:	e8 4d f9 ff ff       	call   800d69 <sys_page_map>
  80141c:	89 c6                	mov    %eax,%esi
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 3e                	js     801460 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801425:	89 c2                	mov    %eax,%edx
  801427:	c1 ea 0c             	shr    $0xc,%edx
  80142a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801431:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801437:	89 54 24 10          	mov    %edx,0x10(%esp)
  80143b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80143f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801446:	00 
  801447:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801452:	e8 12 f9 ff ff       	call   800d69 <sys_page_map>
  801457:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801459:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80145c:	85 f6                	test   %esi,%esi
  80145e:	79 22                	jns    801482 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801460:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801464:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80146b:	e8 4c f9 ff ff       	call   800dbc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801470:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80147b:	e8 3c f9 ff ff       	call   800dbc <sys_page_unmap>
	return r;
  801480:	89 f0                	mov    %esi,%eax
}
  801482:	83 c4 3c             	add    $0x3c,%esp
  801485:	5b                   	pop    %ebx
  801486:	5e                   	pop    %esi
  801487:	5f                   	pop    %edi
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    

0080148a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	53                   	push   %ebx
  80148e:	83 ec 24             	sub    $0x24,%esp
  801491:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801494:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149b:	89 1c 24             	mov    %ebx,(%esp)
  80149e:	e8 53 fd ff ff       	call   8011f6 <fd_lookup>
  8014a3:	89 c2                	mov    %eax,%edx
  8014a5:	85 d2                	test   %edx,%edx
  8014a7:	78 6d                	js     801516 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b3:	8b 00                	mov    (%eax),%eax
  8014b5:	89 04 24             	mov    %eax,(%esp)
  8014b8:	e8 8f fd ff ff       	call   80124c <dev_lookup>
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	78 55                	js     801516 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c4:	8b 50 08             	mov    0x8(%eax),%edx
  8014c7:	83 e2 03             	and    $0x3,%edx
  8014ca:	83 fa 01             	cmp    $0x1,%edx
  8014cd:	75 23                	jne    8014f2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014cf:	a1 08 40 80 00       	mov    0x804008,%eax
  8014d4:	8b 40 48             	mov    0x48(%eax),%eax
  8014d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014df:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8014e6:	e8 4b ed ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  8014eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f0:	eb 24                	jmp    801516 <read+0x8c>
	}
	if (!dev->dev_read)
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	8b 52 08             	mov    0x8(%edx),%edx
  8014f8:	85 d2                	test   %edx,%edx
  8014fa:	74 15                	je     801511 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801506:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80150a:	89 04 24             	mov    %eax,(%esp)
  80150d:	ff d2                	call   *%edx
  80150f:	eb 05                	jmp    801516 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801511:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801516:	83 c4 24             	add    $0x24,%esp
  801519:	5b                   	pop    %ebx
  80151a:	5d                   	pop    %ebp
  80151b:	c3                   	ret    

0080151c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	57                   	push   %edi
  801520:	56                   	push   %esi
  801521:	53                   	push   %ebx
  801522:	83 ec 1c             	sub    $0x1c,%esp
  801525:	8b 7d 08             	mov    0x8(%ebp),%edi
  801528:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80152b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801530:	eb 23                	jmp    801555 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801532:	89 f0                	mov    %esi,%eax
  801534:	29 d8                	sub    %ebx,%eax
  801536:	89 44 24 08          	mov    %eax,0x8(%esp)
  80153a:	89 d8                	mov    %ebx,%eax
  80153c:	03 45 0c             	add    0xc(%ebp),%eax
  80153f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801543:	89 3c 24             	mov    %edi,(%esp)
  801546:	e8 3f ff ff ff       	call   80148a <read>
		if (m < 0)
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 10                	js     80155f <readn+0x43>
			return m;
		if (m == 0)
  80154f:	85 c0                	test   %eax,%eax
  801551:	74 0a                	je     80155d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801553:	01 c3                	add    %eax,%ebx
  801555:	39 f3                	cmp    %esi,%ebx
  801557:	72 d9                	jb     801532 <readn+0x16>
  801559:	89 d8                	mov    %ebx,%eax
  80155b:	eb 02                	jmp    80155f <readn+0x43>
  80155d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80155f:	83 c4 1c             	add    $0x1c,%esp
  801562:	5b                   	pop    %ebx
  801563:	5e                   	pop    %esi
  801564:	5f                   	pop    %edi
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	53                   	push   %ebx
  80156b:	83 ec 24             	sub    $0x24,%esp
  80156e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801571:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801574:	89 44 24 04          	mov    %eax,0x4(%esp)
  801578:	89 1c 24             	mov    %ebx,(%esp)
  80157b:	e8 76 fc ff ff       	call   8011f6 <fd_lookup>
  801580:	89 c2                	mov    %eax,%edx
  801582:	85 d2                	test   %edx,%edx
  801584:	78 68                	js     8015ee <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801586:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801589:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801590:	8b 00                	mov    (%eax),%eax
  801592:	89 04 24             	mov    %eax,(%esp)
  801595:	e8 b2 fc ff ff       	call   80124c <dev_lookup>
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 50                	js     8015ee <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a5:	75 23                	jne    8015ca <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a7:	a1 08 40 80 00       	mov    0x804008,%eax
  8015ac:	8b 40 48             	mov    0x48(%eax),%eax
  8015af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b7:	c7 04 24 21 2e 80 00 	movl   $0x802e21,(%esp)
  8015be:	e8 73 ec ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  8015c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c8:	eb 24                	jmp    8015ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8015d0:	85 d2                	test   %edx,%edx
  8015d2:	74 15                	je     8015e9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015e2:	89 04 24             	mov    %eax,(%esp)
  8015e5:	ff d2                	call   *%edx
  8015e7:	eb 05                	jmp    8015ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015ee:	83 c4 24             	add    $0x24,%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    

008015f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	89 04 24             	mov    %eax,(%esp)
  801607:	e8 ea fb ff ff       	call   8011f6 <fd_lookup>
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 0e                	js     80161e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801610:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801613:	8b 55 0c             	mov    0xc(%ebp),%edx
  801616:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	53                   	push   %ebx
  801624:	83 ec 24             	sub    $0x24,%esp
  801627:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801631:	89 1c 24             	mov    %ebx,(%esp)
  801634:	e8 bd fb ff ff       	call   8011f6 <fd_lookup>
  801639:	89 c2                	mov    %eax,%edx
  80163b:	85 d2                	test   %edx,%edx
  80163d:	78 61                	js     8016a0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801642:	89 44 24 04          	mov    %eax,0x4(%esp)
  801646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801649:	8b 00                	mov    (%eax),%eax
  80164b:	89 04 24             	mov    %eax,(%esp)
  80164e:	e8 f9 fb ff ff       	call   80124c <dev_lookup>
  801653:	85 c0                	test   %eax,%eax
  801655:	78 49                	js     8016a0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165e:	75 23                	jne    801683 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801660:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801665:	8b 40 48             	mov    0x48(%eax),%eax
  801668:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80166c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801670:	c7 04 24 e4 2d 80 00 	movl   $0x802de4,(%esp)
  801677:	e8 ba eb ff ff       	call   800236 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80167c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801681:	eb 1d                	jmp    8016a0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801686:	8b 52 18             	mov    0x18(%edx),%edx
  801689:	85 d2                	test   %edx,%edx
  80168b:	74 0e                	je     80169b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80168d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801690:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801694:	89 04 24             	mov    %eax,(%esp)
  801697:	ff d2                	call   *%edx
  801699:	eb 05                	jmp    8016a0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80169b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8016a0:	83 c4 24             	add    $0x24,%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    

008016a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	53                   	push   %ebx
  8016aa:	83 ec 24             	sub    $0x24,%esp
  8016ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	89 04 24             	mov    %eax,(%esp)
  8016bd:	e8 34 fb ff ff       	call   8011f6 <fd_lookup>
  8016c2:	89 c2                	mov    %eax,%edx
  8016c4:	85 d2                	test   %edx,%edx
  8016c6:	78 52                	js     80171a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d2:	8b 00                	mov    (%eax),%eax
  8016d4:	89 04 24             	mov    %eax,(%esp)
  8016d7:	e8 70 fb ff ff       	call   80124c <dev_lookup>
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 3a                	js     80171a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e7:	74 2c                	je     801715 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f3:	00 00 00 
	stat->st_isdir = 0;
  8016f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016fd:	00 00 00 
	stat->st_dev = dev;
  801700:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801706:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80170a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80170d:	89 14 24             	mov    %edx,(%esp)
  801710:	ff 50 14             	call   *0x14(%eax)
  801713:	eb 05                	jmp    80171a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801715:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80171a:	83 c4 24             	add    $0x24,%esp
  80171d:	5b                   	pop    %ebx
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801728:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80172f:	00 
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	89 04 24             	mov    %eax,(%esp)
  801736:	e8 99 02 00 00       	call   8019d4 <open>
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	85 db                	test   %ebx,%ebx
  80173f:	78 1b                	js     80175c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	89 44 24 04          	mov    %eax,0x4(%esp)
  801748:	89 1c 24             	mov    %ebx,(%esp)
  80174b:	e8 56 ff ff ff       	call   8016a6 <fstat>
  801750:	89 c6                	mov    %eax,%esi
	close(fd);
  801752:	89 1c 24             	mov    %ebx,(%esp)
  801755:	e8 cd fb ff ff       	call   801327 <close>
	return r;
  80175a:	89 f0                	mov    %esi,%eax
}
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	5b                   	pop    %ebx
  801760:	5e                   	pop    %esi
  801761:	5d                   	pop    %ebp
  801762:	c3                   	ret    

00801763 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
  801768:	83 ec 10             	sub    $0x10,%esp
  80176b:	89 c6                	mov    %eax,%esi
  80176d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80176f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801776:	75 11                	jne    801789 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801778:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80177f:	e8 ab 0f 00 00       	call   80272f <ipc_find_env>
  801784:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801789:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801790:	00 
  801791:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801798:	00 
  801799:	89 74 24 04          	mov    %esi,0x4(%esp)
  80179d:	a1 00 40 80 00       	mov    0x804000,%eax
  8017a2:	89 04 24             	mov    %eax,(%esp)
  8017a5:	e8 1e 0f 00 00       	call   8026c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b1:	00 
  8017b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017bd:	e8 9e 0e 00 00       	call   802660 <ipc_recv>
}
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	5b                   	pop    %ebx
  8017c6:	5e                   	pop    %esi
  8017c7:	5d                   	pop    %ebp
  8017c8:	c3                   	ret    

008017c9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ec:	e8 72 ff ff ff       	call   801763 <fsipc>
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ff:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801804:	ba 00 00 00 00       	mov    $0x0,%edx
  801809:	b8 06 00 00 00       	mov    $0x6,%eax
  80180e:	e8 50 ff ff ff       	call   801763 <fsipc>
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	53                   	push   %ebx
  801819:	83 ec 14             	sub    $0x14,%esp
  80181c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8b 40 0c             	mov    0xc(%eax),%eax
  801825:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80182a:	ba 00 00 00 00       	mov    $0x0,%edx
  80182f:	b8 05 00 00 00       	mov    $0x5,%eax
  801834:	e8 2a ff ff ff       	call   801763 <fsipc>
  801839:	89 c2                	mov    %eax,%edx
  80183b:	85 d2                	test   %edx,%edx
  80183d:	78 2b                	js     80186a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80183f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801846:	00 
  801847:	89 1c 24             	mov    %ebx,(%esp)
  80184a:	e8 58 f0 ff ff       	call   8008a7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80184f:	a1 80 50 80 00       	mov    0x805080,%eax
  801854:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80185a:	a1 84 50 80 00       	mov    0x805084,%eax
  80185f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186a:	83 c4 14             	add    $0x14,%esp
  80186d:	5b                   	pop    %ebx
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    

00801870 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	53                   	push   %ebx
  801874:	83 ec 14             	sub    $0x14,%esp
  801877:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80187a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801880:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801885:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801888:	8b 55 08             	mov    0x8(%ebp),%edx
  80188b:	8b 52 0c             	mov    0xc(%edx),%edx
  80188e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801894:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801899:	89 44 24 08          	mov    %eax,0x8(%esp)
  80189d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a4:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8018ab:	e8 94 f1 ff ff       	call   800a44 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  8018b0:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  8018b7:	00 
  8018b8:	c7 04 24 54 2e 80 00 	movl   $0x802e54,(%esp)
  8018bf:	e8 72 e9 ff ff       	call   800236 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c9:	b8 04 00 00 00       	mov    $0x4,%eax
  8018ce:	e8 90 fe ff ff       	call   801763 <fsipc>
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 53                	js     80192a <devfile_write+0xba>
		return r;
	assert(r <= n);
  8018d7:	39 c3                	cmp    %eax,%ebx
  8018d9:	73 24                	jae    8018ff <devfile_write+0x8f>
  8018db:	c7 44 24 0c 59 2e 80 	movl   $0x802e59,0xc(%esp)
  8018e2:	00 
  8018e3:	c7 44 24 08 60 2e 80 	movl   $0x802e60,0x8(%esp)
  8018ea:	00 
  8018eb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8018f2:	00 
  8018f3:	c7 04 24 75 2e 80 00 	movl   $0x802e75,(%esp)
  8018fa:	e8 07 0d 00 00       	call   802606 <_panic>
	assert(r <= PGSIZE);
  8018ff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801904:	7e 24                	jle    80192a <devfile_write+0xba>
  801906:	c7 44 24 0c 80 2e 80 	movl   $0x802e80,0xc(%esp)
  80190d:	00 
  80190e:	c7 44 24 08 60 2e 80 	movl   $0x802e60,0x8(%esp)
  801915:	00 
  801916:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80191d:	00 
  80191e:	c7 04 24 75 2e 80 00 	movl   $0x802e75,(%esp)
  801925:	e8 dc 0c 00 00       	call   802606 <_panic>
	return r;
}
  80192a:	83 c4 14             	add    $0x14,%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    

00801930 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
  801935:	83 ec 10             	sub    $0x10,%esp
  801938:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8b 40 0c             	mov    0xc(%eax),%eax
  801941:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801946:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80194c:	ba 00 00 00 00       	mov    $0x0,%edx
  801951:	b8 03 00 00 00       	mov    $0x3,%eax
  801956:	e8 08 fe ff ff       	call   801763 <fsipc>
  80195b:	89 c3                	mov    %eax,%ebx
  80195d:	85 c0                	test   %eax,%eax
  80195f:	78 6a                	js     8019cb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801961:	39 c6                	cmp    %eax,%esi
  801963:	73 24                	jae    801989 <devfile_read+0x59>
  801965:	c7 44 24 0c 59 2e 80 	movl   $0x802e59,0xc(%esp)
  80196c:	00 
  80196d:	c7 44 24 08 60 2e 80 	movl   $0x802e60,0x8(%esp)
  801974:	00 
  801975:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80197c:	00 
  80197d:	c7 04 24 75 2e 80 00 	movl   $0x802e75,(%esp)
  801984:	e8 7d 0c 00 00       	call   802606 <_panic>
	assert(r <= PGSIZE);
  801989:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80198e:	7e 24                	jle    8019b4 <devfile_read+0x84>
  801990:	c7 44 24 0c 80 2e 80 	movl   $0x802e80,0xc(%esp)
  801997:	00 
  801998:	c7 44 24 08 60 2e 80 	movl   $0x802e60,0x8(%esp)
  80199f:	00 
  8019a0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8019a7:	00 
  8019a8:	c7 04 24 75 2e 80 00 	movl   $0x802e75,(%esp)
  8019af:	e8 52 0c 00 00       	call   802606 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b8:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8019bf:	00 
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	89 04 24             	mov    %eax,(%esp)
  8019c6:	e8 79 f0 ff ff       	call   800a44 <memmove>
	return r;
}
  8019cb:	89 d8                	mov    %ebx,%eax
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5e                   	pop    %esi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 24             	sub    $0x24,%esp
  8019db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8019de:	89 1c 24             	mov    %ebx,(%esp)
  8019e1:	e8 8a ee ff ff       	call   800870 <strlen>
  8019e6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019eb:	7f 60                	jg     801a4d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8019ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f0:	89 04 24             	mov    %eax,(%esp)
  8019f3:	e8 af f7 ff ff       	call   8011a7 <fd_alloc>
  8019f8:	89 c2                	mov    %eax,%edx
  8019fa:	85 d2                	test   %edx,%edx
  8019fc:	78 54                	js     801a52 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8019fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a02:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801a09:	e8 99 ee ff ff       	call   8008a7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a19:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1e:	e8 40 fd ff ff       	call   801763 <fsipc>
  801a23:	89 c3                	mov    %eax,%ebx
  801a25:	85 c0                	test   %eax,%eax
  801a27:	79 17                	jns    801a40 <open+0x6c>
		fd_close(fd, 0);
  801a29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a30:	00 
  801a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a34:	89 04 24             	mov    %eax,(%esp)
  801a37:	e8 6a f8 ff ff       	call   8012a6 <fd_close>
		return r;
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	eb 12                	jmp    801a52 <open+0x7e>
	}

	return fd2num(fd);
  801a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a43:	89 04 24             	mov    %eax,(%esp)
  801a46:	e8 35 f7 ff ff       	call   801180 <fd2num>
  801a4b:	eb 05                	jmp    801a52 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801a4d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801a52:	83 c4 24             	add    $0x24,%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a63:	b8 08 00 00 00       	mov    $0x8,%eax
  801a68:	e8 f6 fc ff ff       	call   801763 <fsipc>
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <evict>:

int evict(void)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801a75:	c7 04 24 8c 2e 80 00 	movl   $0x802e8c,(%esp)
  801a7c:	e8 b5 e7 ff ff       	call   800236 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801a81:	ba 00 00 00 00       	mov    $0x0,%edx
  801a86:	b8 09 00 00 00       	mov    $0x9,%eax
  801a8b:	e8 d3 fc ff ff       	call   801763 <fsipc>
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	53                   	push   %ebx
  801a96:	83 ec 14             	sub    $0x14,%esp
  801a99:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801a9b:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a9f:	7e 31                	jle    801ad2 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801aa1:	8b 40 04             	mov    0x4(%eax),%eax
  801aa4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa8:	8d 43 10             	lea    0x10(%ebx),%eax
  801aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aaf:	8b 03                	mov    (%ebx),%eax
  801ab1:	89 04 24             	mov    %eax,(%esp)
  801ab4:	e8 ae fa ff ff       	call   801567 <write>
		if (result > 0)
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	7e 03                	jle    801ac0 <writebuf+0x2e>
			b->result += result;
  801abd:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801ac0:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ac3:	74 0d                	je     801ad2 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	ba 00 00 00 00       	mov    $0x0,%edx
  801acc:	0f 4f c2             	cmovg  %edx,%eax
  801acf:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801ad2:	83 c4 14             	add    $0x14,%esp
  801ad5:	5b                   	pop    %ebx
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    

00801ad8 <putch>:

static void
putch(int ch, void *thunk)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	53                   	push   %ebx
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801ae2:	8b 53 04             	mov    0x4(%ebx),%edx
  801ae5:	8d 42 01             	lea    0x1(%edx),%eax
  801ae8:	89 43 04             	mov    %eax,0x4(%ebx)
  801aeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aee:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801af2:	3d 00 01 00 00       	cmp    $0x100,%eax
  801af7:	75 0e                	jne    801b07 <putch+0x2f>
		writebuf(b);
  801af9:	89 d8                	mov    %ebx,%eax
  801afb:	e8 92 ff ff ff       	call   801a92 <writebuf>
		b->idx = 0;
  801b00:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801b07:	83 c4 04             	add    $0x4,%esp
  801b0a:	5b                   	pop    %ebx
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    

00801b0d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b1f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b26:	00 00 00 
	b.result = 0;
  801b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b30:	00 00 00 
	b.error = 1;
  801b33:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b3a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b40:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b55:	c7 04 24 d8 1a 80 00 	movl   $0x801ad8,(%esp)
  801b5c:	e8 23 e8 ff ff       	call   800384 <vprintfmt>
	if (b.idx > 0)
  801b61:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b68:	7e 0b                	jle    801b75 <vfprintf+0x68>
		writebuf(&b);
  801b6a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b70:	e8 1d ff ff ff       	call   801a92 <writebuf>

	return (b.result ? b.result : b.error);
  801b75:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b8c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b8f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	89 04 24             	mov    %eax,(%esp)
  801ba0:	e8 68 ff ff ff       	call   801b0d <vfprintf>
	va_end(ap);

	return cnt;
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <printf>:

int
printf(const char *fmt, ...)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bad:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801bb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bc2:	e8 46 ff ff ff       	call   801b0d <vfprintf>
	va_end(ap);

	return cnt;
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    
  801bc9:	66 90                	xchg   %ax,%ax
  801bcb:	66 90                	xchg   %ax,%ax
  801bcd:	66 90                	xchg   %ax,%ax
  801bcf:	90                   	nop

00801bd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801bd6:	c7 44 24 04 a5 2e 80 	movl   $0x802ea5,0x4(%esp)
  801bdd:	00 
  801bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be1:	89 04 24             	mov    %eax,(%esp)
  801be4:	e8 be ec ff ff       	call   8008a7 <strcpy>
	return 0;
}
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 14             	sub    $0x14,%esp
  801bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bfa:	89 1c 24             	mov    %ebx,(%esp)
  801bfd:	e8 65 0b 00 00       	call   802767 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801c02:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801c07:	83 f8 01             	cmp    $0x1,%eax
  801c0a:	75 0d                	jne    801c19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801c0c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c0f:	89 04 24             	mov    %eax,(%esp)
  801c12:	e8 29 03 00 00       	call   801f40 <nsipc_close>
  801c17:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801c19:	89 d0                	mov    %edx,%eax
  801c1b:	83 c4 14             	add    $0x14,%esp
  801c1e:	5b                   	pop    %ebx
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    

00801c21 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c2e:	00 
  801c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8b 40 0c             	mov    0xc(%eax),%eax
  801c43:	89 04 24             	mov    %eax,(%esp)
  801c46:	e8 f0 03 00 00       	call   80203b <nsipc_send>
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c5a:	00 
  801c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6f:	89 04 24             	mov    %eax,(%esp)
  801c72:	e8 44 03 00 00       	call   801fbb <nsipc_recv>
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c7f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c82:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c86:	89 04 24             	mov    %eax,(%esp)
  801c89:	e8 68 f5 ff ff       	call   8011f6 <fd_lookup>
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	78 17                	js     801ca9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c95:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c9b:	39 08                	cmp    %ecx,(%eax)
  801c9d:	75 05                	jne    801ca4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca2:	eb 05                	jmp    801ca9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ca4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 20             	sub    $0x20,%esp
  801cb3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801cb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb8:	89 04 24             	mov    %eax,(%esp)
  801cbb:	e8 e7 f4 ff ff       	call   8011a7 <fd_alloc>
  801cc0:	89 c3                	mov    %eax,%ebx
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	78 21                	js     801ce7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801cc6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ccd:	00 
  801cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cdc:	e8 34 f0 ff ff       	call   800d15 <sys_page_alloc>
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	79 0c                	jns    801cf3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ce7:	89 34 24             	mov    %esi,(%esp)
  801cea:	e8 51 02 00 00       	call   801f40 <nsipc_close>
		return r;
  801cef:	89 d8                	mov    %ebx,%eax
  801cf1:	eb 20                	jmp    801d13 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801cf3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d01:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801d08:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801d0b:	89 14 24             	mov    %edx,(%esp)
  801d0e:	e8 6d f4 ff ff       	call   801180 <fd2num>
}
  801d13:	83 c4 20             	add    $0x20,%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    

00801d1a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	e8 51 ff ff ff       	call   801c79 <fd2sockid>
		return r;
  801d28:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	78 23                	js     801d51 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d2e:	8b 55 10             	mov    0x10(%ebp),%edx
  801d31:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d38:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d3c:	89 04 24             	mov    %eax,(%esp)
  801d3f:	e8 45 01 00 00       	call   801e89 <nsipc_accept>
		return r;
  801d44:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d46:	85 c0                	test   %eax,%eax
  801d48:	78 07                	js     801d51 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801d4a:	e8 5c ff ff ff       	call   801cab <alloc_sockfd>
  801d4f:	89 c1                	mov    %eax,%ecx
}
  801d51:	89 c8                	mov    %ecx,%eax
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	e8 16 ff ff ff       	call   801c79 <fd2sockid>
  801d63:	89 c2                	mov    %eax,%edx
  801d65:	85 d2                	test   %edx,%edx
  801d67:	78 16                	js     801d7f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801d69:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d77:	89 14 24             	mov    %edx,(%esp)
  801d7a:	e8 60 01 00 00       	call   801edf <nsipc_bind>
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <shutdown>:

int
shutdown(int s, int how)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	e8 ea fe ff ff       	call   801c79 <fd2sockid>
  801d8f:	89 c2                	mov    %eax,%edx
  801d91:	85 d2                	test   %edx,%edx
  801d93:	78 0f                	js     801da4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9c:	89 14 24             	mov    %edx,(%esp)
  801d9f:	e8 7a 01 00 00       	call   801f1e <nsipc_shutdown>
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	e8 c5 fe ff ff       	call   801c79 <fd2sockid>
  801db4:	89 c2                	mov    %eax,%edx
  801db6:	85 d2                	test   %edx,%edx
  801db8:	78 16                	js     801dd0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801dba:	8b 45 10             	mov    0x10(%ebp),%eax
  801dbd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc8:	89 14 24             	mov    %edx,(%esp)
  801dcb:	e8 8a 01 00 00       	call   801f5a <nsipc_connect>
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <listen>:

int
listen(int s, int backlog)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	e8 99 fe ff ff       	call   801c79 <fd2sockid>
  801de0:	89 c2                	mov    %eax,%edx
  801de2:	85 d2                	test   %edx,%edx
  801de4:	78 0f                	js     801df5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ded:	89 14 24             	mov    %edx,(%esp)
  801df0:	e8 a4 01 00 00       	call   801f99 <nsipc_listen>
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801e00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	89 04 24             	mov    %eax,(%esp)
  801e11:	e8 98 02 00 00       	call   8020ae <nsipc_socket>
  801e16:	89 c2                	mov    %eax,%edx
  801e18:	85 d2                	test   %edx,%edx
  801e1a:	78 05                	js     801e21 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801e1c:	e8 8a fe ff ff       	call   801cab <alloc_sockfd>
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	53                   	push   %ebx
  801e27:	83 ec 14             	sub    $0x14,%esp
  801e2a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e2c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801e33:	75 11                	jne    801e46 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801e3c:	e8 ee 08 00 00       	call   80272f <ipc_find_env>
  801e41:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e46:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e4d:	00 
  801e4e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e55:	00 
  801e56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e5a:	a1 04 40 80 00       	mov    0x804004,%eax
  801e5f:	89 04 24             	mov    %eax,(%esp)
  801e62:	e8 61 08 00 00       	call   8026c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e6e:	00 
  801e6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e76:	00 
  801e77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e7e:	e8 dd 07 00 00       	call   802660 <ipc_recv>
}
  801e83:	83 c4 14             	add    $0x14,%esp
  801e86:	5b                   	pop    %ebx
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    

00801e89 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	56                   	push   %esi
  801e8d:	53                   	push   %ebx
  801e8e:	83 ec 10             	sub    $0x10,%esp
  801e91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e9c:	8b 06                	mov    (%esi),%eax
  801e9e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ea3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea8:	e8 76 ff ff ff       	call   801e23 <nsipc>
  801ead:	89 c3                	mov    %eax,%ebx
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 23                	js     801ed6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801eb3:	a1 10 60 80 00       	mov    0x806010,%eax
  801eb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ebc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ec3:	00 
  801ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec7:	89 04 24             	mov    %eax,(%esp)
  801eca:	e8 75 eb ff ff       	call   800a44 <memmove>
		*addrlen = ret->ret_addrlen;
  801ecf:	a1 10 60 80 00       	mov    0x806010,%eax
  801ed4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ed6:	89 d8                	mov    %ebx,%eax
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5e                   	pop    %esi
  801edd:	5d                   	pop    %ebp
  801ede:	c3                   	ret    

00801edf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	53                   	push   %ebx
  801ee3:	83 ec 14             	sub    $0x14,%esp
  801ee6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ef1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801f03:	e8 3c eb ff ff       	call   800a44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f08:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801f13:	e8 0b ff ff ff       	call   801e23 <nsipc>
}
  801f18:	83 c4 14             	add    $0x14,%esp
  801f1b:	5b                   	pop    %ebx
  801f1c:	5d                   	pop    %ebp
  801f1d:	c3                   	ret    

00801f1e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f34:	b8 03 00 00 00       	mov    $0x3,%eax
  801f39:	e8 e5 fe ff ff       	call   801e23 <nsipc>
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <nsipc_close>:

int
nsipc_close(int s)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f4e:	b8 04 00 00 00       	mov    $0x4,%eax
  801f53:	e8 cb fe ff ff       	call   801e23 <nsipc>
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	53                   	push   %ebx
  801f5e:	83 ec 14             	sub    $0x14,%esp
  801f61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f77:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801f7e:	e8 c1 ea ff ff       	call   800a44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f89:	b8 05 00 00 00       	mov    $0x5,%eax
  801f8e:	e8 90 fe ff ff       	call   801e23 <nsipc>
}
  801f93:	83 c4 14             	add    $0x14,%esp
  801f96:	5b                   	pop    %ebx
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    

00801f99 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801faa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801faf:	b8 06 00 00 00       	mov    $0x6,%eax
  801fb4:	e8 6a fe ff ff       	call   801e23 <nsipc>
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	56                   	push   %esi
  801fbf:	53                   	push   %ebx
  801fc0:	83 ec 10             	sub    $0x10,%esp
  801fc3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801fce:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fdc:	b8 07 00 00 00       	mov    $0x7,%eax
  801fe1:	e8 3d fe ff ff       	call   801e23 <nsipc>
  801fe6:	89 c3                	mov    %eax,%ebx
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 46                	js     802032 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801fec:	39 f0                	cmp    %esi,%eax
  801fee:	7f 07                	jg     801ff7 <nsipc_recv+0x3c>
  801ff0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ff5:	7e 24                	jle    80201b <nsipc_recv+0x60>
  801ff7:	c7 44 24 0c b1 2e 80 	movl   $0x802eb1,0xc(%esp)
  801ffe:	00 
  801fff:	c7 44 24 08 60 2e 80 	movl   $0x802e60,0x8(%esp)
  802006:	00 
  802007:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80200e:	00 
  80200f:	c7 04 24 c6 2e 80 00 	movl   $0x802ec6,(%esp)
  802016:	e8 eb 05 00 00       	call   802606 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80201b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80201f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802026:	00 
  802027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202a:	89 04 24             	mov    %eax,(%esp)
  80202d:	e8 12 ea ff ff       	call   800a44 <memmove>
	}

	return r;
}
  802032:	89 d8                	mov    %ebx,%eax
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	5b                   	pop    %ebx
  802038:	5e                   	pop    %esi
  802039:	5d                   	pop    %ebp
  80203a:	c3                   	ret    

0080203b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	53                   	push   %ebx
  80203f:	83 ec 14             	sub    $0x14,%esp
  802042:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80204d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802053:	7e 24                	jle    802079 <nsipc_send+0x3e>
  802055:	c7 44 24 0c d2 2e 80 	movl   $0x802ed2,0xc(%esp)
  80205c:	00 
  80205d:	c7 44 24 08 60 2e 80 	movl   $0x802e60,0x8(%esp)
  802064:	00 
  802065:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80206c:	00 
  80206d:	c7 04 24 c6 2e 80 00 	movl   $0x802ec6,(%esp)
  802074:	e8 8d 05 00 00       	call   802606 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802079:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80207d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802080:	89 44 24 04          	mov    %eax,0x4(%esp)
  802084:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80208b:	e8 b4 e9 ff ff       	call   800a44 <memmove>
	nsipcbuf.send.req_size = size;
  802090:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802096:	8b 45 14             	mov    0x14(%ebp),%eax
  802099:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80209e:	b8 08 00 00 00       	mov    $0x8,%eax
  8020a3:	e8 7b fd ff ff       	call   801e23 <nsipc>
}
  8020a8:	83 c4 14             	add    $0x14,%esp
  8020ab:	5b                   	pop    %ebx
  8020ac:	5d                   	pop    %ebp
  8020ad:	c3                   	ret    

008020ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020bf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8020c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8020cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8020d1:	e8 4d fd ff ff       	call   801e23 <nsipc>
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	56                   	push   %esi
  8020dc:	53                   	push   %ebx
  8020dd:	83 ec 10             	sub    $0x10,%esp
  8020e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	89 04 24             	mov    %eax,(%esp)
  8020e9:	e8 a2 f0 ff ff       	call   801190 <fd2data>
  8020ee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020f0:	c7 44 24 04 de 2e 80 	movl   $0x802ede,0x4(%esp)
  8020f7:	00 
  8020f8:	89 1c 24             	mov    %ebx,(%esp)
  8020fb:	e8 a7 e7 ff ff       	call   8008a7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802100:	8b 46 04             	mov    0x4(%esi),%eax
  802103:	2b 06                	sub    (%esi),%eax
  802105:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80210b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802112:	00 00 00 
	stat->st_dev = &devpipe;
  802115:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80211c:	30 80 00 
	return 0;
}
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    

0080212b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	53                   	push   %ebx
  80212f:	83 ec 14             	sub    $0x14,%esp
  802132:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802135:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802139:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802140:	e8 77 ec ff ff       	call   800dbc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802145:	89 1c 24             	mov    %ebx,(%esp)
  802148:	e8 43 f0 ff ff       	call   801190 <fd2data>
  80214d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802158:	e8 5f ec ff ff       	call   800dbc <sys_page_unmap>
}
  80215d:	83 c4 14             	add    $0x14,%esp
  802160:	5b                   	pop    %ebx
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    

00802163 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	57                   	push   %edi
  802167:	56                   	push   %esi
  802168:	53                   	push   %ebx
  802169:	83 ec 2c             	sub    $0x2c,%esp
  80216c:	89 c6                	mov    %eax,%esi
  80216e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802171:	a1 08 40 80 00       	mov    0x804008,%eax
  802176:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802179:	89 34 24             	mov    %esi,(%esp)
  80217c:	e8 e6 05 00 00       	call   802767 <pageref>
  802181:	89 c7                	mov    %eax,%edi
  802183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802186:	89 04 24             	mov    %eax,(%esp)
  802189:	e8 d9 05 00 00       	call   802767 <pageref>
  80218e:	39 c7                	cmp    %eax,%edi
  802190:	0f 94 c2             	sete   %dl
  802193:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802196:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80219c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80219f:	39 fb                	cmp    %edi,%ebx
  8021a1:	74 21                	je     8021c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8021a3:	84 d2                	test   %dl,%dl
  8021a5:	74 ca                	je     802171 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8021aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021b6:	c7 04 24 e5 2e 80 00 	movl   $0x802ee5,(%esp)
  8021bd:	e8 74 e0 ff ff       	call   800236 <cprintf>
  8021c2:	eb ad                	jmp    802171 <_pipeisclosed+0xe>
	}
}
  8021c4:	83 c4 2c             	add    $0x2c,%esp
  8021c7:	5b                   	pop    %ebx
  8021c8:	5e                   	pop    %esi
  8021c9:	5f                   	pop    %edi
  8021ca:	5d                   	pop    %ebp
  8021cb:	c3                   	ret    

008021cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	57                   	push   %edi
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 1c             	sub    $0x1c,%esp
  8021d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8021d8:	89 34 24             	mov    %esi,(%esp)
  8021db:	e8 b0 ef ff ff       	call   801190 <fd2data>
  8021e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e7:	eb 45                	jmp    80222e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8021e9:	89 da                	mov    %ebx,%edx
  8021eb:	89 f0                	mov    %esi,%eax
  8021ed:	e8 71 ff ff ff       	call   802163 <_pipeisclosed>
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	75 41                	jne    802237 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8021f6:	e8 fb ea ff ff       	call   800cf6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8021fe:	8b 0b                	mov    (%ebx),%ecx
  802200:	8d 51 20             	lea    0x20(%ecx),%edx
  802203:	39 d0                	cmp    %edx,%eax
  802205:	73 e2                	jae    8021e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80220a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80220e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802211:	99                   	cltd   
  802212:	c1 ea 1b             	shr    $0x1b,%edx
  802215:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802218:	83 e1 1f             	and    $0x1f,%ecx
  80221b:	29 d1                	sub    %edx,%ecx
  80221d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802221:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802225:	83 c0 01             	add    $0x1,%eax
  802228:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80222b:	83 c7 01             	add    $0x1,%edi
  80222e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802231:	75 c8                	jne    8021fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802233:	89 f8                	mov    %edi,%eax
  802235:	eb 05                	jmp    80223c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802237:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80223c:	83 c4 1c             	add    $0x1c,%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5f                   	pop    %edi
  802242:	5d                   	pop    %ebp
  802243:	c3                   	ret    

00802244 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	57                   	push   %edi
  802248:	56                   	push   %esi
  802249:	53                   	push   %ebx
  80224a:	83 ec 1c             	sub    $0x1c,%esp
  80224d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802250:	89 3c 24             	mov    %edi,(%esp)
  802253:	e8 38 ef ff ff       	call   801190 <fd2data>
  802258:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80225a:	be 00 00 00 00       	mov    $0x0,%esi
  80225f:	eb 3d                	jmp    80229e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802261:	85 f6                	test   %esi,%esi
  802263:	74 04                	je     802269 <devpipe_read+0x25>
				return i;
  802265:	89 f0                	mov    %esi,%eax
  802267:	eb 43                	jmp    8022ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802269:	89 da                	mov    %ebx,%edx
  80226b:	89 f8                	mov    %edi,%eax
  80226d:	e8 f1 fe ff ff       	call   802163 <_pipeisclosed>
  802272:	85 c0                	test   %eax,%eax
  802274:	75 31                	jne    8022a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802276:	e8 7b ea ff ff       	call   800cf6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80227b:	8b 03                	mov    (%ebx),%eax
  80227d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802280:	74 df                	je     802261 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802282:	99                   	cltd   
  802283:	c1 ea 1b             	shr    $0x1b,%edx
  802286:	01 d0                	add    %edx,%eax
  802288:	83 e0 1f             	and    $0x1f,%eax
  80228b:	29 d0                	sub    %edx,%eax
  80228d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802295:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802298:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80229b:	83 c6 01             	add    $0x1,%esi
  80229e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022a1:	75 d8                	jne    80227b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	eb 05                	jmp    8022ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8022ac:	83 c4 1c             	add    $0x1c,%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    

008022b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	56                   	push   %esi
  8022b8:	53                   	push   %ebx
  8022b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8022bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022bf:	89 04 24             	mov    %eax,(%esp)
  8022c2:	e8 e0 ee ff ff       	call   8011a7 <fd_alloc>
  8022c7:	89 c2                	mov    %eax,%edx
  8022c9:	85 d2                	test   %edx,%edx
  8022cb:	0f 88 4d 01 00 00    	js     80241e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022d8:	00 
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e7:	e8 29 ea ff ff       	call   800d15 <sys_page_alloc>
  8022ec:	89 c2                	mov    %eax,%edx
  8022ee:	85 d2                	test   %edx,%edx
  8022f0:	0f 88 28 01 00 00    	js     80241e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8022f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022f9:	89 04 24             	mov    %eax,(%esp)
  8022fc:	e8 a6 ee ff ff       	call   8011a7 <fd_alloc>
  802301:	89 c3                	mov    %eax,%ebx
  802303:	85 c0                	test   %eax,%eax
  802305:	0f 88 fe 00 00 00    	js     802409 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80230b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802312:	00 
  802313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802316:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802321:	e8 ef e9 ff ff       	call   800d15 <sys_page_alloc>
  802326:	89 c3                	mov    %eax,%ebx
  802328:	85 c0                	test   %eax,%eax
  80232a:	0f 88 d9 00 00 00    	js     802409 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	89 04 24             	mov    %eax,(%esp)
  802336:	e8 55 ee ff ff       	call   801190 <fd2data>
  80233b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80233d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802344:	00 
  802345:	89 44 24 04          	mov    %eax,0x4(%esp)
  802349:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802350:	e8 c0 e9 ff ff       	call   800d15 <sys_page_alloc>
  802355:	89 c3                	mov    %eax,%ebx
  802357:	85 c0                	test   %eax,%eax
  802359:	0f 88 97 00 00 00    	js     8023f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	89 04 24             	mov    %eax,(%esp)
  802365:	e8 26 ee ff ff       	call   801190 <fd2data>
  80236a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802371:	00 
  802372:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802376:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80237d:	00 
  80237e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802382:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802389:	e8 db e9 ff ff       	call   800d69 <sys_page_map>
  80238e:	89 c3                	mov    %eax,%ebx
  802390:	85 c0                	test   %eax,%eax
  802392:	78 52                	js     8023e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802394:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8023a9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8023af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8023b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	89 04 24             	mov    %eax,(%esp)
  8023c4:	e8 b7 ed ff ff       	call   801180 <fd2num>
  8023c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	89 04 24             	mov    %eax,(%esp)
  8023d4:	e8 a7 ed ff ff       	call   801180 <fd2num>
  8023d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	eb 38                	jmp    80241e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8023e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f1:	e8 c6 e9 ff ff       	call   800dbc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802404:	e8 b3 e9 ff ff       	call   800dbc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802410:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802417:	e8 a0 e9 ff ff       	call   800dbc <sys_page_unmap>
  80241c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80241e:	83 c4 30             	add    $0x30,%esp
  802421:	5b                   	pop    %ebx
  802422:	5e                   	pop    %esi
  802423:	5d                   	pop    %ebp
  802424:	c3                   	ret    

00802425 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80242b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80242e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	89 04 24             	mov    %eax,(%esp)
  802438:	e8 b9 ed ff ff       	call   8011f6 <fd_lookup>
  80243d:	89 c2                	mov    %eax,%edx
  80243f:	85 d2                	test   %edx,%edx
  802441:	78 15                	js     802458 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 42 ed ff ff       	call   801190 <fd2data>
	return _pipeisclosed(fd, p);
  80244e:	89 c2                	mov    %eax,%edx
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	e8 0b fd ff ff       	call   802163 <_pipeisclosed>
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    

0080246a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802470:	c7 44 24 04 fd 2e 80 	movl   $0x802efd,0x4(%esp)
  802477:	00 
  802478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247b:	89 04 24             	mov    %eax,(%esp)
  80247e:	e8 24 e4 ff ff       	call   8008a7 <strcpy>
	return 0;
}
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	57                   	push   %edi
  80248e:	56                   	push   %esi
  80248f:	53                   	push   %ebx
  802490:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802496:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80249b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024a1:	eb 31                	jmp    8024d4 <devcons_write+0x4a>
		m = n - tot;
  8024a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8024a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8024a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8024ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8024b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8024b7:	03 45 0c             	add    0xc(%ebp),%eax
  8024ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024be:	89 3c 24             	mov    %edi,(%esp)
  8024c1:	e8 7e e5 ff ff       	call   800a44 <memmove>
		sys_cputs(buf, m);
  8024c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024ca:	89 3c 24             	mov    %edi,(%esp)
  8024cd:	e8 24 e7 ff ff       	call   800bf6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024d2:	01 f3                	add    %esi,%ebx
  8024d4:	89 d8                	mov    %ebx,%eax
  8024d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8024d9:	72 c8                	jb     8024a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8024db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    

008024e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8024ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8024f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024f5:	75 07                	jne    8024fe <devcons_read+0x18>
  8024f7:	eb 2a                	jmp    802523 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8024f9:	e8 f8 e7 ff ff       	call   800cf6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8024fe:	66 90                	xchg   %ax,%ax
  802500:	e8 0f e7 ff ff       	call   800c14 <sys_cgetc>
  802505:	85 c0                	test   %eax,%eax
  802507:	74 f0                	je     8024f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802509:	85 c0                	test   %eax,%eax
  80250b:	78 16                	js     802523 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80250d:	83 f8 04             	cmp    $0x4,%eax
  802510:	74 0c                	je     80251e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802512:	8b 55 0c             	mov    0xc(%ebp),%edx
  802515:	88 02                	mov    %al,(%edx)
	return 1;
  802517:	b8 01 00 00 00       	mov    $0x1,%eax
  80251c:	eb 05                	jmp    802523 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
  802528:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802531:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802538:	00 
  802539:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80253c:	89 04 24             	mov    %eax,(%esp)
  80253f:	e8 b2 e6 ff ff       	call   800bf6 <sys_cputs>
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <getchar>:

int
getchar(void)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80254c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802553:	00 
  802554:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802557:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802562:	e8 23 ef ff ff       	call   80148a <read>
	if (r < 0)
  802567:	85 c0                	test   %eax,%eax
  802569:	78 0f                	js     80257a <getchar+0x34>
		return r;
	if (r < 1)
  80256b:	85 c0                	test   %eax,%eax
  80256d:	7e 06                	jle    802575 <getchar+0x2f>
		return -E_EOF;
	return c;
  80256f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802573:	eb 05                	jmp    80257a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802575:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80257a:	c9                   	leave  
  80257b:	c3                   	ret    

0080257c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802582:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802585:	89 44 24 04          	mov    %eax,0x4(%esp)
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	89 04 24             	mov    %eax,(%esp)
  80258f:	e8 62 ec ff ff       	call   8011f6 <fd_lookup>
  802594:	85 c0                	test   %eax,%eax
  802596:	78 11                	js     8025a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8025a1:	39 10                	cmp    %edx,(%eax)
  8025a3:	0f 94 c0             	sete   %al
  8025a6:	0f b6 c0             	movzbl %al,%eax
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <opencons>:

int
opencons(void)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025b4:	89 04 24             	mov    %eax,(%esp)
  8025b7:	e8 eb eb ff ff       	call   8011a7 <fd_alloc>
		return r;
  8025bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	78 40                	js     802602 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025c9:	00 
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d8:	e8 38 e7 ff ff       	call   800d15 <sys_page_alloc>
		return r;
  8025dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	78 1f                	js     802602 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8025e3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025f8:	89 04 24             	mov    %eax,(%esp)
  8025fb:	e8 80 eb ff ff       	call   801180 <fd2num>
  802600:	89 c2                	mov    %eax,%edx
}
  802602:	89 d0                	mov    %edx,%eax
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	56                   	push   %esi
  80260a:	53                   	push   %ebx
  80260b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80260e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802611:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802617:	e8 bb e6 ff ff       	call   800cd7 <sys_getenvid>
  80261c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802623:	8b 55 08             	mov    0x8(%ebp),%edx
  802626:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80262a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80262e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802632:	c7 04 24 0c 2f 80 00 	movl   $0x802f0c,(%esp)
  802639:	e8 f8 db ff ff       	call   800236 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80263e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802642:	8b 45 10             	mov    0x10(%ebp),%eax
  802645:	89 04 24             	mov    %eax,(%esp)
  802648:	e8 88 db ff ff       	call   8001d5 <vcprintf>
	cprintf("\n");
  80264d:	c7 04 24 50 2a 80 00 	movl   $0x802a50,(%esp)
  802654:	e8 dd db ff ff       	call   800236 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802659:	cc                   	int3   
  80265a:	eb fd                	jmp    802659 <_panic+0x53>
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	56                   	push   %esi
  802664:	53                   	push   %ebx
  802665:	83 ec 10             	sub    $0x10,%esp
  802668:	8b 75 08             	mov    0x8(%ebp),%esi
  80266b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802671:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802673:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802678:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80267b:	89 04 24             	mov    %eax,(%esp)
  80267e:	e8 c8 e8 ff ff       	call   800f4b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802683:	85 c0                	test   %eax,%eax
  802685:	75 26                	jne    8026ad <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802687:	85 f6                	test   %esi,%esi
  802689:	74 0a                	je     802695 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80268b:	a1 08 40 80 00       	mov    0x804008,%eax
  802690:	8b 40 74             	mov    0x74(%eax),%eax
  802693:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802695:	85 db                	test   %ebx,%ebx
  802697:	74 0a                	je     8026a3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802699:	a1 08 40 80 00       	mov    0x804008,%eax
  80269e:	8b 40 78             	mov    0x78(%eax),%eax
  8026a1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8026a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8026a8:	8b 40 70             	mov    0x70(%eax),%eax
  8026ab:	eb 14                	jmp    8026c1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8026ad:	85 f6                	test   %esi,%esi
  8026af:	74 06                	je     8026b7 <ipc_recv+0x57>
			*from_env_store = 0;
  8026b1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8026b7:	85 db                	test   %ebx,%ebx
  8026b9:	74 06                	je     8026c1 <ipc_recv+0x61>
			*perm_store = 0;
  8026bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	5b                   	pop    %ebx
  8026c5:	5e                   	pop    %esi
  8026c6:	5d                   	pop    %ebp
  8026c7:	c3                   	ret    

008026c8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	57                   	push   %edi
  8026cc:	56                   	push   %esi
  8026cd:	53                   	push   %ebx
  8026ce:	83 ec 1c             	sub    $0x1c,%esp
  8026d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026d7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  8026da:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  8026dc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8026e1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8026e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8026e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026f3:	89 3c 24             	mov    %edi,(%esp)
  8026f6:	e8 2d e8 ff ff       	call   800f28 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 28                	je     802727 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8026ff:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802702:	74 1c                	je     802720 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802704:	c7 44 24 08 30 2f 80 	movl   $0x802f30,0x8(%esp)
  80270b:	00 
  80270c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802713:	00 
  802714:	c7 04 24 54 2f 80 00 	movl   $0x802f54,(%esp)
  80271b:	e8 e6 fe ff ff       	call   802606 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802720:	e8 d1 e5 ff ff       	call   800cf6 <sys_yield>
	}
  802725:	eb bd                	jmp    8026e4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802727:	83 c4 1c             	add    $0x1c,%esp
  80272a:	5b                   	pop    %ebx
  80272b:	5e                   	pop    %esi
  80272c:	5f                   	pop    %edi
  80272d:	5d                   	pop    %ebp
  80272e:	c3                   	ret    

0080272f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
  802732:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80273a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80273d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802743:	8b 52 50             	mov    0x50(%edx),%edx
  802746:	39 ca                	cmp    %ecx,%edx
  802748:	75 0d                	jne    802757 <ipc_find_env+0x28>
			return envs[i].env_id;
  80274a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80274d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802752:	8b 40 40             	mov    0x40(%eax),%eax
  802755:	eb 0e                	jmp    802765 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802757:	83 c0 01             	add    $0x1,%eax
  80275a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80275f:	75 d9                	jne    80273a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802761:	66 b8 00 00          	mov    $0x0,%ax
}
  802765:	5d                   	pop    %ebp
  802766:	c3                   	ret    

00802767 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	c1 e8 16             	shr    $0x16,%eax
  802772:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802779:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80277e:	f6 c1 01             	test   $0x1,%cl
  802781:	74 1d                	je     8027a0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802783:	c1 ea 0c             	shr    $0xc,%edx
  802786:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80278d:	f6 c2 01             	test   $0x1,%dl
  802790:	74 0e                	je     8027a0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802792:	c1 ea 0c             	shr    $0xc,%edx
  802795:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80279c:	ef 
  80279d:	0f b7 c0             	movzwl %ax,%eax
}
  8027a0:	5d                   	pop    %ebp
  8027a1:	c3                   	ret    
  8027a2:	66 90                	xchg   %ax,%ax
  8027a4:	66 90                	xchg   %ax,%ax
  8027a6:	66 90                	xchg   %ax,%ax
  8027a8:	66 90                	xchg   %ax,%ax
  8027aa:	66 90                	xchg   %ax,%ax
  8027ac:	66 90                	xchg   %ax,%ax
  8027ae:	66 90                	xchg   %ax,%ax

008027b0 <__udivdi3>:
  8027b0:	55                   	push   %ebp
  8027b1:	57                   	push   %edi
  8027b2:	56                   	push   %esi
  8027b3:	83 ec 0c             	sub    $0xc,%esp
  8027b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8027be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8027c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8027cc:	89 ea                	mov    %ebp,%edx
  8027ce:	89 0c 24             	mov    %ecx,(%esp)
  8027d1:	75 2d                	jne    802800 <__udivdi3+0x50>
  8027d3:	39 e9                	cmp    %ebp,%ecx
  8027d5:	77 61                	ja     802838 <__udivdi3+0x88>
  8027d7:	85 c9                	test   %ecx,%ecx
  8027d9:	89 ce                	mov    %ecx,%esi
  8027db:	75 0b                	jne    8027e8 <__udivdi3+0x38>
  8027dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e2:	31 d2                	xor    %edx,%edx
  8027e4:	f7 f1                	div    %ecx
  8027e6:	89 c6                	mov    %eax,%esi
  8027e8:	31 d2                	xor    %edx,%edx
  8027ea:	89 e8                	mov    %ebp,%eax
  8027ec:	f7 f6                	div    %esi
  8027ee:	89 c5                	mov    %eax,%ebp
  8027f0:	89 f8                	mov    %edi,%eax
  8027f2:	f7 f6                	div    %esi
  8027f4:	89 ea                	mov    %ebp,%edx
  8027f6:	83 c4 0c             	add    $0xc,%esp
  8027f9:	5e                   	pop    %esi
  8027fa:	5f                   	pop    %edi
  8027fb:	5d                   	pop    %ebp
  8027fc:	c3                   	ret    
  8027fd:	8d 76 00             	lea    0x0(%esi),%esi
  802800:	39 e8                	cmp    %ebp,%eax
  802802:	77 24                	ja     802828 <__udivdi3+0x78>
  802804:	0f bd e8             	bsr    %eax,%ebp
  802807:	83 f5 1f             	xor    $0x1f,%ebp
  80280a:	75 3c                	jne    802848 <__udivdi3+0x98>
  80280c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802810:	39 34 24             	cmp    %esi,(%esp)
  802813:	0f 86 9f 00 00 00    	jbe    8028b8 <__udivdi3+0x108>
  802819:	39 d0                	cmp    %edx,%eax
  80281b:	0f 82 97 00 00 00    	jb     8028b8 <__udivdi3+0x108>
  802821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802828:	31 d2                	xor    %edx,%edx
  80282a:	31 c0                	xor    %eax,%eax
  80282c:	83 c4 0c             	add    $0xc,%esp
  80282f:	5e                   	pop    %esi
  802830:	5f                   	pop    %edi
  802831:	5d                   	pop    %ebp
  802832:	c3                   	ret    
  802833:	90                   	nop
  802834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802838:	89 f8                	mov    %edi,%eax
  80283a:	f7 f1                	div    %ecx
  80283c:	31 d2                	xor    %edx,%edx
  80283e:	83 c4 0c             	add    $0xc,%esp
  802841:	5e                   	pop    %esi
  802842:	5f                   	pop    %edi
  802843:	5d                   	pop    %ebp
  802844:	c3                   	ret    
  802845:	8d 76 00             	lea    0x0(%esi),%esi
  802848:	89 e9                	mov    %ebp,%ecx
  80284a:	8b 3c 24             	mov    (%esp),%edi
  80284d:	d3 e0                	shl    %cl,%eax
  80284f:	89 c6                	mov    %eax,%esi
  802851:	b8 20 00 00 00       	mov    $0x20,%eax
  802856:	29 e8                	sub    %ebp,%eax
  802858:	89 c1                	mov    %eax,%ecx
  80285a:	d3 ef                	shr    %cl,%edi
  80285c:	89 e9                	mov    %ebp,%ecx
  80285e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802862:	8b 3c 24             	mov    (%esp),%edi
  802865:	09 74 24 08          	or     %esi,0x8(%esp)
  802869:	89 d6                	mov    %edx,%esi
  80286b:	d3 e7                	shl    %cl,%edi
  80286d:	89 c1                	mov    %eax,%ecx
  80286f:	89 3c 24             	mov    %edi,(%esp)
  802872:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802876:	d3 ee                	shr    %cl,%esi
  802878:	89 e9                	mov    %ebp,%ecx
  80287a:	d3 e2                	shl    %cl,%edx
  80287c:	89 c1                	mov    %eax,%ecx
  80287e:	d3 ef                	shr    %cl,%edi
  802880:	09 d7                	or     %edx,%edi
  802882:	89 f2                	mov    %esi,%edx
  802884:	89 f8                	mov    %edi,%eax
  802886:	f7 74 24 08          	divl   0x8(%esp)
  80288a:	89 d6                	mov    %edx,%esi
  80288c:	89 c7                	mov    %eax,%edi
  80288e:	f7 24 24             	mull   (%esp)
  802891:	39 d6                	cmp    %edx,%esi
  802893:	89 14 24             	mov    %edx,(%esp)
  802896:	72 30                	jb     8028c8 <__udivdi3+0x118>
  802898:	8b 54 24 04          	mov    0x4(%esp),%edx
  80289c:	89 e9                	mov    %ebp,%ecx
  80289e:	d3 e2                	shl    %cl,%edx
  8028a0:	39 c2                	cmp    %eax,%edx
  8028a2:	73 05                	jae    8028a9 <__udivdi3+0xf9>
  8028a4:	3b 34 24             	cmp    (%esp),%esi
  8028a7:	74 1f                	je     8028c8 <__udivdi3+0x118>
  8028a9:	89 f8                	mov    %edi,%eax
  8028ab:	31 d2                	xor    %edx,%edx
  8028ad:	e9 7a ff ff ff       	jmp    80282c <__udivdi3+0x7c>
  8028b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028b8:	31 d2                	xor    %edx,%edx
  8028ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bf:	e9 68 ff ff ff       	jmp    80282c <__udivdi3+0x7c>
  8028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	83 c4 0c             	add    $0xc,%esp
  8028d0:	5e                   	pop    %esi
  8028d1:	5f                   	pop    %edi
  8028d2:	5d                   	pop    %ebp
  8028d3:	c3                   	ret    
  8028d4:	66 90                	xchg   %ax,%ax
  8028d6:	66 90                	xchg   %ax,%ax
  8028d8:	66 90                	xchg   %ax,%ax
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	66 90                	xchg   %ax,%ax
  8028de:	66 90                	xchg   %ax,%ax

008028e0 <__umoddi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	83 ec 14             	sub    $0x14,%esp
  8028e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8028f2:	89 c7                	mov    %eax,%edi
  8028f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8028fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802900:	89 34 24             	mov    %esi,(%esp)
  802903:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802907:	85 c0                	test   %eax,%eax
  802909:	89 c2                	mov    %eax,%edx
  80290b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80290f:	75 17                	jne    802928 <__umoddi3+0x48>
  802911:	39 fe                	cmp    %edi,%esi
  802913:	76 4b                	jbe    802960 <__umoddi3+0x80>
  802915:	89 c8                	mov    %ecx,%eax
  802917:	89 fa                	mov    %edi,%edx
  802919:	f7 f6                	div    %esi
  80291b:	89 d0                	mov    %edx,%eax
  80291d:	31 d2                	xor    %edx,%edx
  80291f:	83 c4 14             	add    $0x14,%esp
  802922:	5e                   	pop    %esi
  802923:	5f                   	pop    %edi
  802924:	5d                   	pop    %ebp
  802925:	c3                   	ret    
  802926:	66 90                	xchg   %ax,%ax
  802928:	39 f8                	cmp    %edi,%eax
  80292a:	77 54                	ja     802980 <__umoddi3+0xa0>
  80292c:	0f bd e8             	bsr    %eax,%ebp
  80292f:	83 f5 1f             	xor    $0x1f,%ebp
  802932:	75 5c                	jne    802990 <__umoddi3+0xb0>
  802934:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802938:	39 3c 24             	cmp    %edi,(%esp)
  80293b:	0f 87 e7 00 00 00    	ja     802a28 <__umoddi3+0x148>
  802941:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802945:	29 f1                	sub    %esi,%ecx
  802947:	19 c7                	sbb    %eax,%edi
  802949:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80294d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802951:	8b 44 24 08          	mov    0x8(%esp),%eax
  802955:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802959:	83 c4 14             	add    $0x14,%esp
  80295c:	5e                   	pop    %esi
  80295d:	5f                   	pop    %edi
  80295e:	5d                   	pop    %ebp
  80295f:	c3                   	ret    
  802960:	85 f6                	test   %esi,%esi
  802962:	89 f5                	mov    %esi,%ebp
  802964:	75 0b                	jne    802971 <__umoddi3+0x91>
  802966:	b8 01 00 00 00       	mov    $0x1,%eax
  80296b:	31 d2                	xor    %edx,%edx
  80296d:	f7 f6                	div    %esi
  80296f:	89 c5                	mov    %eax,%ebp
  802971:	8b 44 24 04          	mov    0x4(%esp),%eax
  802975:	31 d2                	xor    %edx,%edx
  802977:	f7 f5                	div    %ebp
  802979:	89 c8                	mov    %ecx,%eax
  80297b:	f7 f5                	div    %ebp
  80297d:	eb 9c                	jmp    80291b <__umoddi3+0x3b>
  80297f:	90                   	nop
  802980:	89 c8                	mov    %ecx,%eax
  802982:	89 fa                	mov    %edi,%edx
  802984:	83 c4 14             	add    $0x14,%esp
  802987:	5e                   	pop    %esi
  802988:	5f                   	pop    %edi
  802989:	5d                   	pop    %ebp
  80298a:	c3                   	ret    
  80298b:	90                   	nop
  80298c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802990:	8b 04 24             	mov    (%esp),%eax
  802993:	be 20 00 00 00       	mov    $0x20,%esi
  802998:	89 e9                	mov    %ebp,%ecx
  80299a:	29 ee                	sub    %ebp,%esi
  80299c:	d3 e2                	shl    %cl,%edx
  80299e:	89 f1                	mov    %esi,%ecx
  8029a0:	d3 e8                	shr    %cl,%eax
  8029a2:	89 e9                	mov    %ebp,%ecx
  8029a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a8:	8b 04 24             	mov    (%esp),%eax
  8029ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8029af:	89 fa                	mov    %edi,%edx
  8029b1:	d3 e0                	shl    %cl,%eax
  8029b3:	89 f1                	mov    %esi,%ecx
  8029b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8029bd:	d3 ea                	shr    %cl,%edx
  8029bf:	89 e9                	mov    %ebp,%ecx
  8029c1:	d3 e7                	shl    %cl,%edi
  8029c3:	89 f1                	mov    %esi,%ecx
  8029c5:	d3 e8                	shr    %cl,%eax
  8029c7:	89 e9                	mov    %ebp,%ecx
  8029c9:	09 f8                	or     %edi,%eax
  8029cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8029cf:	f7 74 24 04          	divl   0x4(%esp)
  8029d3:	d3 e7                	shl    %cl,%edi
  8029d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029d9:	89 d7                	mov    %edx,%edi
  8029db:	f7 64 24 08          	mull   0x8(%esp)
  8029df:	39 d7                	cmp    %edx,%edi
  8029e1:	89 c1                	mov    %eax,%ecx
  8029e3:	89 14 24             	mov    %edx,(%esp)
  8029e6:	72 2c                	jb     802a14 <__umoddi3+0x134>
  8029e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8029ec:	72 22                	jb     802a10 <__umoddi3+0x130>
  8029ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8029f2:	29 c8                	sub    %ecx,%eax
  8029f4:	19 d7                	sbb    %edx,%edi
  8029f6:	89 e9                	mov    %ebp,%ecx
  8029f8:	89 fa                	mov    %edi,%edx
  8029fa:	d3 e8                	shr    %cl,%eax
  8029fc:	89 f1                	mov    %esi,%ecx
  8029fe:	d3 e2                	shl    %cl,%edx
  802a00:	89 e9                	mov    %ebp,%ecx
  802a02:	d3 ef                	shr    %cl,%edi
  802a04:	09 d0                	or     %edx,%eax
  802a06:	89 fa                	mov    %edi,%edx
  802a08:	83 c4 14             	add    $0x14,%esp
  802a0b:	5e                   	pop    %esi
  802a0c:	5f                   	pop    %edi
  802a0d:	5d                   	pop    %ebp
  802a0e:	c3                   	ret    
  802a0f:	90                   	nop
  802a10:	39 d7                	cmp    %edx,%edi
  802a12:	75 da                	jne    8029ee <__umoddi3+0x10e>
  802a14:	8b 14 24             	mov    (%esp),%edx
  802a17:	89 c1                	mov    %eax,%ecx
  802a19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802a1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802a21:	eb cb                	jmp    8029ee <__umoddi3+0x10e>
  802a23:	90                   	nop
  802a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802a2c:	0f 82 0f ff ff ff    	jb     802941 <__umoddi3+0x61>
  802a32:	e9 1a ff ff ff       	jmp    802951 <__umoddi3+0x71>
