
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 d5 09 00 00       	call   800a06 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 1c             	sub    $0x1c,%esp
  800049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int t;

	if (s == 0) {
  80004f:	85 db                	test   %ebx,%ebx
  800051:	75 28                	jne    80007b <_gettoken+0x3b>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
  800053:	b8 00 00 00 00       	mov    $0x0,%eax
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
  800058:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80005f:	0f 8e 33 01 00 00    	jle    800198 <_gettoken+0x158>
			cprintf("GETTOKEN NULL\n");
  800065:	c7 04 24 c0 3f 80 00 	movl   $0x803fc0,(%esp)
  80006c:	e8 ef 0a 00 00       	call   800b60 <cprintf>
		return 0;
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	e9 1d 01 00 00       	jmp    800198 <_gettoken+0x158>
	}

	if (debug > 1)
  80007b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800082:	7e 10                	jle    800094 <_gettoken+0x54>
		cprintf("GETTOKEN: %s\n", s);
  800084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800088:	c7 04 24 cf 3f 80 00 	movl   $0x803fcf,(%esp)
  80008f:	e8 cc 0a 00 00       	call   800b60 <cprintf>

	*p1 = 0;
  800094:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	*p2 = 0;
  80009a:	8b 45 10             	mov    0x10(%ebp),%eax
  80009d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  8000a3:	eb 07                	jmp    8000ac <_gettoken+0x6c>
		*s++ = 0;
  8000a5:	83 c3 01             	add    $0x1,%ebx
  8000a8:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000ac:	0f be 03             	movsbl (%ebx),%eax
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	c7 04 24 dd 3f 80 00 	movl   $0x803fdd,(%esp)
  8000ba:	e8 1b 13 00 00       	call   8013da <strchr>
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	75 e2                	jne    8000a5 <_gettoken+0x65>
  8000c3:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000c5:	0f b6 03             	movzbl (%ebx),%eax
  8000c8:	84 c0                	test   %al,%al
  8000ca:	75 28                	jne    8000f4 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000cc:	b8 00 00 00 00       	mov    $0x0,%eax
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
  8000d1:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000d8:	0f 8e ba 00 00 00    	jle    800198 <_gettoken+0x158>
			cprintf("EOL\n");
  8000de:	c7 04 24 e2 3f 80 00 	movl   $0x803fe2,(%esp)
  8000e5:	e8 76 0a 00 00       	call   800b60 <cprintf>
		return 0;
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	e9 a4 00 00 00       	jmp    800198 <_gettoken+0x158>
	}
	if (strchr(SYMBOLS, *s)) {
  8000f4:	0f be c0             	movsbl %al,%eax
  8000f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fb:	c7 04 24 f3 3f 80 00 	movl   $0x803ff3,(%esp)
  800102:	e8 d3 12 00 00       	call   8013da <strchr>
  800107:	85 c0                	test   %eax,%eax
  800109:	74 2f                	je     80013a <_gettoken+0xfa>
		t = *s;
  80010b:	0f be 1b             	movsbl (%ebx),%ebx
		*p1 = s;
  80010e:	89 3e                	mov    %edi,(%esi)
		*s++ = 0;
  800110:	c6 07 00             	movb   $0x0,(%edi)
  800113:	83 c7 01             	add    $0x1,%edi
  800116:	8b 45 10             	mov    0x10(%ebp),%eax
  800119:	89 38                	mov    %edi,(%eax)
		*p2 = s;
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
  80011b:	89 d8                	mov    %ebx,%eax
	if (strchr(SYMBOLS, *s)) {
		t = *s;
		*p1 = s;
		*s++ = 0;
		*p2 = s;
		if (debug > 1)
  80011d:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800124:	7e 72                	jle    800198 <_gettoken+0x158>
			cprintf("TOK %c\n", t);
  800126:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80012a:	c7 04 24 e7 3f 80 00 	movl   $0x803fe7,(%esp)
  800131:	e8 2a 0a 00 00       	call   800b60 <cprintf>
		return t;
  800136:	89 d8                	mov    %ebx,%eax
  800138:	eb 5e                	jmp    800198 <_gettoken+0x158>
	}
	*p1 = s;
  80013a:	89 1e                	mov    %ebx,(%esi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80013c:	eb 03                	jmp    800141 <_gettoken+0x101>
		s++;
  80013e:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800141:	0f b6 03             	movzbl (%ebx),%eax
  800144:	84 c0                	test   %al,%al
  800146:	74 17                	je     80015f <_gettoken+0x11f>
  800148:	0f be c0             	movsbl %al,%eax
  80014b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014f:	c7 04 24 ef 3f 80 00 	movl   $0x803fef,(%esp)
  800156:	e8 7f 12 00 00       	call   8013da <strchr>
  80015b:	85 c0                	test   %eax,%eax
  80015d:	74 df                	je     80013e <_gettoken+0xfe>
		s++;
	*p2 = s;
  80015f:	8b 45 10             	mov    0x10(%ebp),%eax
  800162:	89 18                	mov    %ebx,(%eax)
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
  800164:	b8 77 00 00 00       	mov    $0x77,%eax
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
  800169:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800170:	7e 26                	jle    800198 <_gettoken+0x158>
		t = **p2;
  800172:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
  800175:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800178:	8b 06                	mov    (%esi),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	c7 04 24 fb 3f 80 00 	movl   $0x803ffb,(%esp)
  800185:	e8 d6 09 00 00       	call   800b60 <cprintf>
		**p2 = t;
  80018a:	8b 45 10             	mov    0x10(%ebp),%eax
  80018d:	8b 00                	mov    (%eax),%eax
  80018f:	89 fa                	mov    %edi,%edx
  800191:	88 10                	mov    %dl,(%eax)
	}
	return 'w';
  800193:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800198:	83 c4 1c             	add    $0x1c,%esp
  80019b:	5b                   	pop    %ebx
  80019c:	5e                   	pop    %esi
  80019d:	5f                   	pop    %edi
  80019e:	5d                   	pop    %ebp
  80019f:	c3                   	ret    

008001a0 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
  8001a6:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	74 24                	je     8001d1 <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001ad:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001b4:	00 
  8001b5:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001bc:	00 
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 7b fe ff ff       	call   800040 <_gettoken>
  8001c5:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cf:	eb 3c                	jmp    80020d <gettoken+0x6d>
	}
	c = nc;
  8001d1:	a1 08 60 80 00       	mov    0x806008,%eax
  8001d6:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001de:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001e4:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001e6:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001ed:	00 
  8001ee:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001f5:	00 
  8001f6:	a1 0c 60 80 00       	mov    0x80600c,%eax
  8001fb:	89 04 24             	mov    %eax,(%esp)
  8001fe:	e8 3d fe ff ff       	call   800040 <_gettoken>
  800203:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  800208:	a1 04 60 80 00       	mov    0x806004,%eax
}
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	57                   	push   %edi
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
  800215:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  80021b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800222:	00 
  800223:	8b 45 08             	mov    0x8(%ebp),%eax
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 72 ff ff ff       	call   8001a0 <gettoken>

again:
	argc = 0;
  80022e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800233:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  800236:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80023a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800241:	e8 5a ff ff ff       	call   8001a0 <gettoken>
  800246:	83 f8 3e             	cmp    $0x3e,%eax
  800249:	0f 84 d4 00 00 00    	je     800323 <runcmd+0x114>
  80024f:	83 f8 3e             	cmp    $0x3e,%eax
  800252:	7f 13                	jg     800267 <runcmd+0x58>
  800254:	85 c0                	test   %eax,%eax
  800256:	0f 84 55 02 00 00    	je     8004b1 <runcmd+0x2a2>
  80025c:	83 f8 3c             	cmp    $0x3c,%eax
  80025f:	90                   	nop
  800260:	74 3d                	je     80029f <runcmd+0x90>
  800262:	e9 2a 02 00 00       	jmp    800491 <runcmd+0x282>
  800267:	83 f8 77             	cmp    $0x77,%eax
  80026a:	74 0f                	je     80027b <runcmd+0x6c>
  80026c:	83 f8 7c             	cmp    $0x7c,%eax
  80026f:	90                   	nop
  800270:	0f 84 2e 01 00 00    	je     8003a4 <runcmd+0x195>
  800276:	e9 16 02 00 00       	jmp    800491 <runcmd+0x282>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  80027b:	83 fe 10             	cmp    $0x10,%esi
  80027e:	66 90                	xchg   %ax,%ax
  800280:	75 11                	jne    800293 <runcmd+0x84>
				cprintf("too many arguments\n");
  800282:	c7 04 24 05 40 80 00 	movl   $0x804005,(%esp)
  800289:	e8 d2 08 00 00       	call   800b60 <cprintf>
				exit();
  80028e:	e8 bb 07 00 00       	call   800a4e <exit>
			}
			argv[argc++] = t;
  800293:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800296:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  80029a:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  80029d:	eb 97                	jmp    800236 <runcmd+0x27>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80029f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002aa:	e8 f1 fe ff ff       	call   8001a0 <gettoken>
  8002af:	83 f8 77             	cmp    $0x77,%eax
  8002b2:	74 11                	je     8002c5 <runcmd+0xb6>
				cprintf("syntax error: < not followed by word\n");
  8002b4:	c7 04 24 44 41 80 00 	movl   $0x804144,(%esp)
  8002bb:	e8 a0 08 00 00       	call   800b60 <cprintf>
				exit();
  8002c0:	e8 89 07 00 00       	call   800a4e <exit>
			// then close the original 'fd'.

			// LAB 5: Your code here.

			//panic("< redirection not implemented");
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002cc:	00 
  8002cd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002d0:	89 04 24             	mov    %eax,(%esp)
  8002d3:	e8 cc 26 00 00       	call   8029a4 <open>
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	79 1e                	jns    8002fc <runcmd+0xed>
				cprintf("open %s for write: %e", t, fd);
  8002de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e9:	c7 04 24 19 40 80 00 	movl   $0x804019,(%esp)
  8002f0:	e8 6b 08 00 00       	call   800b60 <cprintf>
				exit();
  8002f5:	e8 54 07 00 00       	call   800a4e <exit>
  8002fa:	eb 0a                	jmp    800306 <runcmd+0xf7>
			}
			if (fd != 0) {
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	66 90                	xchg   %ax,%ax
  800300:	0f 84 30 ff ff ff    	je     800236 <runcmd+0x27>
				dup(fd, 0);
  800306:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80030d:	00 
  80030e:	89 3c 24             	mov    %edi,(%esp)
  800311:	e8 36 20 00 00       	call   80234c <dup>
				close(fd);
  800316:	89 3c 24             	mov    %edi,(%esp)
  800319:	e8 d9 1f 00 00       	call   8022f7 <close>
  80031e:	e9 13 ff ff ff       	jmp    800236 <runcmd+0x27>
			}
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800323:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80032e:	e8 6d fe ff ff       	call   8001a0 <gettoken>
  800333:	83 f8 77             	cmp    $0x77,%eax
  800336:	74 11                	je     800349 <runcmd+0x13a>
				cprintf("syntax error: > not followed by word\n");
  800338:	c7 04 24 6c 41 80 00 	movl   $0x80416c,(%esp)
  80033f:	e8 1c 08 00 00       	call   800b60 <cprintf>
				exit();
  800344:	e8 05 07 00 00       	call   800a4e <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800349:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  800350:	00 
  800351:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800354:	89 04 24             	mov    %eax,(%esp)
  800357:	e8 48 26 00 00       	call   8029a4 <open>
  80035c:	89 c7                	mov    %eax,%edi
  80035e:	85 c0                	test   %eax,%eax
  800360:	79 1c                	jns    80037e <runcmd+0x16f>
				cprintf("open %s for write: %e", t, fd);
  800362:	89 44 24 08          	mov    %eax,0x8(%esp)
  800366:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036d:	c7 04 24 19 40 80 00 	movl   $0x804019,(%esp)
  800374:	e8 e7 07 00 00       	call   800b60 <cprintf>
				exit();
  800379:	e8 d0 06 00 00       	call   800a4e <exit>
			}
			if (fd != 1) {
  80037e:	83 ff 01             	cmp    $0x1,%edi
  800381:	0f 84 af fe ff ff    	je     800236 <runcmd+0x27>
				dup(fd, 1);
  800387:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80038e:	00 
  80038f:	89 3c 24             	mov    %edi,(%esp)
  800392:	e8 b5 1f 00 00       	call   80234c <dup>
				close(fd);
  800397:	89 3c 24             	mov    %edi,(%esp)
  80039a:	e8 58 1f 00 00       	call   8022f7 <close>
  80039f:	e9 92 fe ff ff       	jmp    800236 <runcmd+0x27>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003a4:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003aa:	89 04 24             	mov    %eax,(%esp)
  8003ad:	e8 62 35 00 00       	call   803914 <pipe>
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	79 15                	jns    8003cb <runcmd+0x1bc>
				cprintf("pipe: %e", r);
  8003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ba:	c7 04 24 2f 40 80 00 	movl   $0x80402f,(%esp)
  8003c1:	e8 9a 07 00 00       	call   800b60 <cprintf>
				exit();
  8003c6:	e8 83 06 00 00       	call   800a4e <exit>
			}
			if (debug)
  8003cb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8003d2:	74 20                	je     8003f4 <runcmd+0x1e5>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003d4:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8003da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003de:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8003e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e8:	c7 04 24 38 40 80 00 	movl   $0x804038,(%esp)
  8003ef:	e8 6c 07 00 00       	call   800b60 <cprintf>
			if ((r = fork()) < 0) {
  8003f4:	e8 56 18 00 00       	call   801c4f <fork>
  8003f9:	89 c7                	mov    %eax,%edi
  8003fb:	85 c0                	test   %eax,%eax
  8003fd:	79 15                	jns    800414 <runcmd+0x205>
				cprintf("fork: %e", r);
  8003ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800403:	c7 04 24 45 40 80 00 	movl   $0x804045,(%esp)
  80040a:	e8 51 07 00 00       	call   800b60 <cprintf>
				exit();
  80040f:	e8 3a 06 00 00       	call   800a4e <exit>
			}
			if (r == 0) {
  800414:	85 ff                	test   %edi,%edi
  800416:	75 40                	jne    800458 <runcmd+0x249>
				if (p[0] != 0) {
  800418:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80041e:	85 c0                	test   %eax,%eax
  800420:	74 1e                	je     800440 <runcmd+0x231>
					dup(p[0], 0);
  800422:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800429:	00 
  80042a:	89 04 24             	mov    %eax,(%esp)
  80042d:	e8 1a 1f 00 00       	call   80234c <dup>
					close(p[0]);
  800432:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	e8 b7 1e 00 00       	call   8022f7 <close>
				}
				close(p[1]);
  800440:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800446:	89 04 24             	mov    %eax,(%esp)
  800449:	e8 a9 1e 00 00       	call   8022f7 <close>

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
  80044e:	be 00 00 00 00       	mov    $0x0,%esi
				if (p[0] != 0) {
					dup(p[0], 0);
					close(p[0]);
				}
				close(p[1]);
				goto again;
  800453:	e9 de fd ff ff       	jmp    800236 <runcmd+0x27>
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  800458:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80045e:	83 f8 01             	cmp    $0x1,%eax
  800461:	74 1e                	je     800481 <runcmd+0x272>
					dup(p[1], 1);
  800463:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80046a:	00 
  80046b:	89 04 24             	mov    %eax,(%esp)
  80046e:	e8 d9 1e 00 00       	call   80234c <dup>
					close(p[1]);
  800473:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800479:	89 04 24             	mov    %eax,(%esp)
  80047c:	e8 76 1e 00 00       	call   8022f7 <close>
				}
				close(p[0]);
  800481:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800487:	89 04 24             	mov    %eax,(%esp)
  80048a:	e8 68 1e 00 00       	call   8022f7 <close>
				goto runit;
  80048f:	eb 25                	jmp    8004b6 <runcmd+0x2a7>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800491:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800495:	c7 44 24 08 4e 40 80 	movl   $0x80404e,0x8(%esp)
  80049c:	00 
  80049d:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  8004a4:	00 
  8004a5:	c7 04 24 6a 40 80 00 	movl   $0x80406a,(%esp)
  8004ac:	e8 b6 05 00 00       	call   800a67 <_panic>
runcmd(char* s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  8004b1:	bf 00 00 00 00       	mov    $0x0,%edi
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8004b6:	85 f6                	test   %esi,%esi
  8004b8:	75 1e                	jne    8004d8 <runcmd+0x2c9>
		if (debug)
  8004ba:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004c1:	0f 84 85 01 00 00    	je     80064c <runcmd+0x43d>
			cprintf("EMPTY COMMAND\n");
  8004c7:	c7 04 24 74 40 80 00 	movl   $0x804074,(%esp)
  8004ce:	e8 8d 06 00 00       	call   800b60 <cprintf>
  8004d3:	e9 74 01 00 00       	jmp    80064c <runcmd+0x43d>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  8004d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004db:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004de:	74 22                	je     800502 <runcmd+0x2f3>
		argv0buf[0] = '/';
  8004e0:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  8004e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004eb:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  8004f1:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  8004f7:	89 04 24             	mov    %eax,(%esp)
  8004fa:	e8 c8 0d 00 00       	call   8012c7 <strcpy>
		argv[0] = argv0buf;
  8004ff:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  800502:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  800509:	00 

	// Print the command.
	if (debug) {
  80050a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800511:	74 43                	je     800556 <runcmd+0x347>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800513:	a1 28 64 80 00       	mov    0x806428,%eax
  800518:	8b 40 48             	mov    0x48(%eax),%eax
  80051b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051f:	c7 04 24 83 40 80 00 	movl   $0x804083,(%esp)
  800526:	e8 35 06 00 00       	call   800b60 <cprintf>
  80052b:	8d 5d a8             	lea    -0x58(%ebp),%ebx
		for (i = 0; argv[i]; i++)
  80052e:	eb 10                	jmp    800540 <runcmd+0x331>
			cprintf(" %s", argv[i]);
  800530:	89 44 24 04          	mov    %eax,0x4(%esp)
  800534:	c7 04 24 0e 41 80 00 	movl   $0x80410e,(%esp)
  80053b:	e8 20 06 00 00       	call   800b60 <cprintf>
  800540:	83 c3 04             	add    $0x4,%ebx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800543:	8b 43 fc             	mov    -0x4(%ebx),%eax
  800546:	85 c0                	test   %eax,%eax
  800548:	75 e6                	jne    800530 <runcmd+0x321>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80054a:	c7 04 24 e0 3f 80 00 	movl   $0x803fe0,(%esp)
  800551:	e8 0a 06 00 00       	call   800b60 <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800556:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800559:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800560:	89 04 24             	mov    %eax,(%esp)
  800563:	e8 38 26 00 00       	call   802ba0 <spawn>
  800568:	89 c3                	mov    %eax,%ebx
  80056a:	85 c0                	test   %eax,%eax
  80056c:	0f 89 c3 00 00 00    	jns    800635 <runcmd+0x426>
		cprintf("spawn %s: %e\n", argv[0], r);
  800572:	89 44 24 08          	mov    %eax,0x8(%esp)
  800576:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057d:	c7 04 24 91 40 80 00 	movl   $0x804091,(%esp)
  800584:	e8 d7 05 00 00       	call   800b60 <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800589:	e8 9c 1d 00 00       	call   80232a <close_all>
  80058e:	eb 4c                	jmp    8005dc <runcmd+0x3cd>
	if (r >= 0) {
		if (debug)
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800590:	a1 28 64 80 00       	mov    0x806428,%eax
  800595:	8b 40 48             	mov    0x48(%eax),%eax
  800598:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80059c:	8b 55 a8             	mov    -0x58(%ebp),%edx
  80059f:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a7:	c7 04 24 9f 40 80 00 	movl   $0x80409f,(%esp)
  8005ae:	e8 ad 05 00 00       	call   800b60 <cprintf>
		wait(r);
  8005b3:	89 1c 24             	mov    %ebx,(%esp)
  8005b6:	e8 ff 34 00 00       	call   803aba <wait>
		if (debug)
  8005bb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005c2:	74 18                	je     8005dc <runcmd+0x3cd>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005c4:	a1 28 64 80 00       	mov    0x806428,%eax
  8005c9:	8b 40 48             	mov    0x48(%eax),%eax
  8005cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d0:	c7 04 24 b4 40 80 00 	movl   $0x8040b4,(%esp)
  8005d7:	e8 84 05 00 00       	call   800b60 <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  8005dc:	85 ff                	test   %edi,%edi
  8005de:	74 4e                	je     80062e <runcmd+0x41f>
		if (debug)
  8005e0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005e7:	74 1c                	je     800605 <runcmd+0x3f6>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005e9:	a1 28 64 80 00       	mov    0x806428,%eax
  8005ee:	8b 40 48             	mov    0x48(%eax),%eax
  8005f1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8005f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f9:	c7 04 24 ca 40 80 00 	movl   $0x8040ca,(%esp)
  800600:	e8 5b 05 00 00       	call   800b60 <cprintf>
		wait(pipe_child);
  800605:	89 3c 24             	mov    %edi,(%esp)
  800608:	e8 ad 34 00 00       	call   803aba <wait>
		if (debug)
  80060d:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800614:	74 18                	je     80062e <runcmd+0x41f>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800616:	a1 28 64 80 00       	mov    0x806428,%eax
  80061b:	8b 40 48             	mov    0x48(%eax),%eax
  80061e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800622:	c7 04 24 b4 40 80 00 	movl   $0x8040b4,(%esp)
  800629:	e8 32 05 00 00       	call   800b60 <cprintf>
	}

	// Done!
	exit();
  80062e:	e8 1b 04 00 00       	call   800a4e <exit>
  800633:	eb 17                	jmp    80064c <runcmd+0x43d>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
		cprintf("spawn %s: %e\n", argv[0], r);

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800635:	e8 f0 1c 00 00       	call   80232a <close_all>
	if (r >= 0) {
		if (debug)
  80063a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800641:	0f 84 6c ff ff ff    	je     8005b3 <runcmd+0x3a4>
  800647:	e9 44 ff ff ff       	jmp    800590 <runcmd+0x381>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  80064c:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  800652:	5b                   	pop    %ebx
  800653:	5e                   	pop    %esi
  800654:	5f                   	pop    %edi
  800655:	5d                   	pop    %ebp
  800656:	c3                   	ret    

00800657 <usage>:
}


void
usage(void)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  80065d:	c7 04 24 94 41 80 00 	movl   $0x804194,(%esp)
  800664:	e8 f7 04 00 00       	call   800b60 <cprintf>
	exit();
  800669:	e8 e0 03 00 00       	call   800a4e <exit>
}
  80066e:	c9                   	leave  
  80066f:	c3                   	ret    

00800670 <umain>:

void
umain(int argc, char **argv)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	57                   	push   %edi
  800674:	56                   	push   %esi
  800675:	53                   	push   %ebx
  800676:	83 ec 3c             	sub    $0x3c,%esp
  800679:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  80067c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80067f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800683:	89 74 24 04          	mov    %esi,0x4(%esp)
  800687:	8d 45 08             	lea    0x8(%ebp),%eax
  80068a:	89 04 24             	mov    %eax,(%esp)
  80068d:	e8 5b 19 00 00       	call   801fed <argstart>
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
  800692:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
umain(int argc, char **argv)
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  800699:	bf 3f 00 00 00       	mov    $0x3f,%edi
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  80069e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8006a1:	eb 2f                	jmp    8006d2 <umain+0x62>
		switch (r) {
  8006a3:	83 f8 69             	cmp    $0x69,%eax
  8006a6:	74 0c                	je     8006b4 <umain+0x44>
  8006a8:	83 f8 78             	cmp    $0x78,%eax
  8006ab:	74 1e                	je     8006cb <umain+0x5b>
  8006ad:	83 f8 64             	cmp    $0x64,%eax
  8006b0:	75 12                	jne    8006c4 <umain+0x54>
  8006b2:	eb 07                	jmp    8006bb <umain+0x4b>
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006b4:	bf 01 00 00 00       	mov    $0x1,%edi
  8006b9:	eb 17                	jmp    8006d2 <umain+0x62>
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
  8006bb:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006c2:	eb 0e                	jmp    8006d2 <umain+0x62>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006c4:	e8 8e ff ff ff       	call   800657 <usage>
  8006c9:	eb 07                	jmp    8006d2 <umain+0x62>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
  8006cb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  8006d2:	89 1c 24             	mov    %ebx,(%esp)
  8006d5:	e8 4b 19 00 00       	call   802025 <argnext>
  8006da:	85 c0                	test   %eax,%eax
  8006dc:	79 c5                	jns    8006a3 <umain+0x33>
  8006de:	89 fb                	mov    %edi,%ebx
			break;
		default:
			usage();
		}

	if (argc > 2)
  8006e0:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006e4:	7e 05                	jle    8006eb <umain+0x7b>
		usage();
  8006e6:	e8 6c ff ff ff       	call   800657 <usage>
	if (argc == 2) {
  8006eb:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006ef:	75 72                	jne    800763 <umain+0xf3>
		close(0);
  8006f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006f8:	e8 fa 1b 00 00       	call   8022f7 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800704:	00 
  800705:	8b 46 04             	mov    0x4(%esi),%eax
  800708:	89 04 24             	mov    %eax,(%esp)
  80070b:	e8 94 22 00 00       	call   8029a4 <open>
  800710:	85 c0                	test   %eax,%eax
  800712:	79 27                	jns    80073b <umain+0xcb>
			panic("open %s: %e", argv[1], r);
  800714:	89 44 24 10          	mov    %eax,0x10(%esp)
  800718:	8b 46 04             	mov    0x4(%esi),%eax
  80071b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80071f:	c7 44 24 08 ea 40 80 	movl   $0x8040ea,0x8(%esp)
  800726:	00 
  800727:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  80072e:	00 
  80072f:	c7 04 24 6a 40 80 00 	movl   $0x80406a,(%esp)
  800736:	e8 2c 03 00 00       	call   800a67 <_panic>
		assert(r == 0);
  80073b:	85 c0                	test   %eax,%eax
  80073d:	74 24                	je     800763 <umain+0xf3>
  80073f:	c7 44 24 0c f6 40 80 	movl   $0x8040f6,0xc(%esp)
  800746:	00 
  800747:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  80074e:	00 
  80074f:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  800756:	00 
  800757:	c7 04 24 6a 40 80 00 	movl   $0x80406a,(%esp)
  80075e:	e8 04 03 00 00       	call   800a67 <_panic>
	}
	if (interactive == '?')
  800763:	83 fb 3f             	cmp    $0x3f,%ebx
  800766:	75 0e                	jne    800776 <umain+0x106>
		interactive = iscons(0);
  800768:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80076f:	e8 08 02 00 00       	call   80097c <iscons>
  800774:	89 c7                	mov    %eax,%edi

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800776:	85 ff                	test   %edi,%edi
  800778:	b8 00 00 00 00       	mov    $0x0,%eax
  80077d:	ba e7 40 80 00       	mov    $0x8040e7,%edx
  800782:	0f 45 c2             	cmovne %edx,%eax
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	e8 13 0a 00 00       	call   8011a0 <readline>
  80078d:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80078f:	85 c0                	test   %eax,%eax
  800791:	75 1a                	jne    8007ad <umain+0x13d>
			if (debug)
  800793:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80079a:	74 0c                	je     8007a8 <umain+0x138>
				cprintf("EXITING\n");
  80079c:	c7 04 24 12 41 80 00 	movl   $0x804112,(%esp)
  8007a3:	e8 b8 03 00 00       	call   800b60 <cprintf>
			exit();	// end of file
  8007a8:	e8 a1 02 00 00       	call   800a4e <exit>
		}
		if (debug)
  8007ad:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007b4:	74 10                	je     8007c6 <umain+0x156>
			cprintf("LINE: %s\n", buf);
  8007b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007ba:	c7 04 24 1b 41 80 00 	movl   $0x80411b,(%esp)
  8007c1:	e8 9a 03 00 00       	call   800b60 <cprintf>
		if (buf[0] == '#')
  8007c6:	80 3b 23             	cmpb   $0x23,(%ebx)
  8007c9:	74 ab                	je     800776 <umain+0x106>
			continue;
		if (echocmds)
  8007cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007cf:	74 10                	je     8007e1 <umain+0x171>
			printf("# %s\n", buf);
  8007d1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d5:	c7 04 24 25 41 80 00 	movl   $0x804125,(%esp)
  8007dc:	e8 96 23 00 00       	call   802b77 <printf>
		if (debug)
  8007e1:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007e8:	74 0c                	je     8007f6 <umain+0x186>
			cprintf("BEFORE FORK\n");
  8007ea:	c7 04 24 2b 41 80 00 	movl   $0x80412b,(%esp)
  8007f1:	e8 6a 03 00 00       	call   800b60 <cprintf>
		if ((r = fork()) < 0)
  8007f6:	e8 54 14 00 00       	call   801c4f <fork>
  8007fb:	89 c6                	mov    %eax,%esi
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	79 20                	jns    800821 <umain+0x1b1>
			panic("fork: %e", r);
  800801:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800805:	c7 44 24 08 45 40 80 	movl   $0x804045,0x8(%esp)
  80080c:	00 
  80080d:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  800814:	00 
  800815:	c7 04 24 6a 40 80 00 	movl   $0x80406a,(%esp)
  80081c:	e8 46 02 00 00       	call   800a67 <_panic>
		if (debug)
  800821:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800828:	74 10                	je     80083a <umain+0x1ca>
			cprintf("FORK: %d\n", r);
  80082a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082e:	c7 04 24 38 41 80 00 	movl   $0x804138,(%esp)
  800835:	e8 26 03 00 00       	call   800b60 <cprintf>
		if (r == 0) {
  80083a:	85 f6                	test   %esi,%esi
  80083c:	75 12                	jne    800850 <umain+0x1e0>
			runcmd(buf);
  80083e:	89 1c 24             	mov    %ebx,(%esp)
  800841:	e8 c9 f9 ff ff       	call   80020f <runcmd>
			exit();
  800846:	e8 03 02 00 00       	call   800a4e <exit>
  80084b:	e9 26 ff ff ff       	jmp    800776 <umain+0x106>
		} else
			wait(r);
  800850:	89 34 24             	mov    %esi,(%esp)
  800853:	e8 62 32 00 00       	call   803aba <wait>
  800858:	e9 19 ff ff ff       	jmp    800776 <umain+0x106>
  80085d:	66 90                	xchg   %ax,%ax
  80085f:	90                   	nop

00800860 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800870:	c7 44 24 04 b5 41 80 	movl   $0x8041b5,0x4(%esp)
  800877:	00 
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087b:	89 04 24             	mov    %eax,(%esp)
  80087e:	e8 44 0a 00 00       	call   8012c7 <strcpy>
	return 0;
}
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
  800888:	c9                   	leave  
  800889:	c3                   	ret    

0080088a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	57                   	push   %edi
  80088e:	56                   	push   %esi
  80088f:	53                   	push   %ebx
  800890:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800896:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80089b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008a1:	eb 31                	jmp    8008d4 <devcons_write+0x4a>
		m = n - tot;
  8008a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8008a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8008a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8008ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8008b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8008b7:	03 45 0c             	add    0xc(%ebp),%eax
  8008ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008be:	89 3c 24             	mov    %edi,(%esp)
  8008c1:	e8 9e 0b 00 00       	call   801464 <memmove>
		sys_cputs(buf, m);
  8008c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008ca:	89 3c 24             	mov    %edi,(%esp)
  8008cd:	e8 44 0d 00 00       	call   801616 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008d2:	01 f3                	add    %esi,%ebx
  8008d4:	89 d8                	mov    %ebx,%eax
  8008d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8008d9:	72 c8                	jb     8008a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8008db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8008e1:	5b                   	pop    %ebx
  8008e2:	5e                   	pop    %esi
  8008e3:	5f                   	pop    %edi
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8008f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8008f5:	75 07                	jne    8008fe <devcons_read+0x18>
  8008f7:	eb 2a                	jmp    800923 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8008f9:	e8 18 0e 00 00       	call   801716 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8008fe:	66 90                	xchg   %ax,%ax
  800900:	e8 2f 0d 00 00       	call   801634 <sys_cgetc>
  800905:	85 c0                	test   %eax,%eax
  800907:	74 f0                	je     8008f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800909:	85 c0                	test   %eax,%eax
  80090b:	78 16                	js     800923 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80090d:	83 f8 04             	cmp    $0x4,%eax
  800910:	74 0c                	je     80091e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800912:	8b 55 0c             	mov    0xc(%ebp),%edx
  800915:	88 02                	mov    %al,(%edx)
	return 1;
  800917:	b8 01 00 00 00       	mov    $0x1,%eax
  80091c:	eb 05                	jmp    800923 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800923:	c9                   	leave  
  800924:	c3                   	ret    

00800925 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800931:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800938:	00 
  800939:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80093c:	89 04 24             	mov    %eax,(%esp)
  80093f:	e8 d2 0c 00 00       	call   801616 <sys_cputs>
}
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <getchar>:

int
getchar(void)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80094c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800953:	00 
  800954:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800957:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800962:	e8 f3 1a 00 00       	call   80245a <read>
	if (r < 0)
  800967:	85 c0                	test   %eax,%eax
  800969:	78 0f                	js     80097a <getchar+0x34>
		return r;
	if (r < 1)
  80096b:	85 c0                	test   %eax,%eax
  80096d:	7e 06                	jle    800975 <getchar+0x2f>
		return -E_EOF;
	return c;
  80096f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800973:	eb 05                	jmp    80097a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800975:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800982:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800985:	89 44 24 04          	mov    %eax,0x4(%esp)
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	89 04 24             	mov    %eax,(%esp)
  80098f:	e8 32 18 00 00       	call   8021c6 <fd_lookup>
  800994:	85 c0                	test   %eax,%eax
  800996:	78 11                	js     8009a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099b:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009a1:	39 10                	cmp    %edx,(%eax)
  8009a3:	0f 94 c0             	sete   %al
  8009a6:	0f b6 c0             	movzbl %al,%eax
}
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <opencons>:

int
opencons(void)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b4:	89 04 24             	mov    %eax,(%esp)
  8009b7:	e8 bb 17 00 00       	call   802177 <fd_alloc>
		return r;
  8009bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009be:	85 c0                	test   %eax,%eax
  8009c0:	78 40                	js     800a02 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8009c9:	00 
  8009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009d8:	e8 58 0d 00 00       	call   801735 <sys_page_alloc>
		return r;
  8009dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009df:	85 c0                	test   %eax,%eax
  8009e1:	78 1f                	js     800a02 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8009e3:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009f8:	89 04 24             	mov    %eax,(%esp)
  8009fb:	e8 50 17 00 00       	call   802150 <fd2num>
  800a00:	89 c2                	mov    %eax,%edx
}
  800a02:	89 d0                	mov    %edx,%eax
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	83 ec 10             	sub    $0x10,%esp
  800a0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a11:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800a14:	e8 de 0c 00 00       	call   8016f7 <sys_getenvid>
  800a19:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a1e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a21:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a26:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	7e 07                	jle    800a36 <libmain+0x30>
		binaryname = argv[0];
  800a2f:	8b 06                	mov    (%esi),%eax
  800a31:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a36:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a3a:	89 1c 24             	mov    %ebx,(%esp)
  800a3d:	e8 2e fc ff ff       	call   800670 <umain>

	// exit gracefully
	exit();
  800a42:	e8 07 00 00 00       	call   800a4e <exit>
}
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	5b                   	pop    %ebx
  800a4b:	5e                   	pop    %esi
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800a54:	e8 d1 18 00 00       	call   80232a <close_all>
	sys_env_destroy(0);
  800a59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a60:	e8 ee 0b 00 00       	call   801653 <sys_env_destroy>
}
  800a65:	c9                   	leave  
  800a66:	c3                   	ret    

00800a67 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	56                   	push   %esi
  800a6b:	53                   	push   %ebx
  800a6c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800a6f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a72:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800a78:	e8 7a 0c 00 00       	call   8016f7 <sys_getenvid>
  800a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a80:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a84:	8b 55 08             	mov    0x8(%ebp),%edx
  800a87:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a8b:	89 74 24 08          	mov    %esi,0x8(%esp)
  800a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a93:	c7 04 24 cc 41 80 00 	movl   $0x8041cc,(%esp)
  800a9a:	e8 c1 00 00 00       	call   800b60 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa6:	89 04 24             	mov    %eax,(%esp)
  800aa9:	e8 51 00 00 00       	call   800aff <vcprintf>
	cprintf("\n");
  800aae:	c7 04 24 e0 3f 80 00 	movl   $0x803fe0,(%esp)
  800ab5:	e8 a6 00 00 00       	call   800b60 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aba:	cc                   	int3   
  800abb:	eb fd                	jmp    800aba <_panic+0x53>

00800abd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	53                   	push   %ebx
  800ac1:	83 ec 14             	sub    $0x14,%esp
  800ac4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ac7:	8b 13                	mov    (%ebx),%edx
  800ac9:	8d 42 01             	lea    0x1(%edx),%eax
  800acc:	89 03                	mov    %eax,(%ebx)
  800ace:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ad5:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ada:	75 19                	jne    800af5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800adc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800ae3:	00 
  800ae4:	8d 43 08             	lea    0x8(%ebx),%eax
  800ae7:	89 04 24             	mov    %eax,(%esp)
  800aea:	e8 27 0b 00 00       	call   801616 <sys_cputs>
		b->idx = 0;
  800aef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800af5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800af9:	83 c4 14             	add    $0x14,%esp
  800afc:	5b                   	pop    %ebx
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800b08:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b0f:	00 00 00 
	b.cnt = 0;
  800b12:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b19:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b34:	c7 04 24 bd 0a 80 00 	movl   $0x800abd,(%esp)
  800b3b:	e8 74 01 00 00       	call   800cb4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b40:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800b46:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b4a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b50:	89 04 24             	mov    %eax,(%esp)
  800b53:	e8 be 0a 00 00       	call   801616 <sys_cputs>

	return b.cnt;
}
  800b58:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b5e:	c9                   	leave  
  800b5f:	c3                   	ret    

00800b60 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b66:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	89 04 24             	mov    %eax,(%esp)
  800b73:	e8 87 ff ff ff       	call   800aff <vcprintf>
	va_end(ap);

	return cnt;
}
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    
  800b7a:	66 90                	xchg   %ax,%ax
  800b7c:	66 90                	xchg   %ax,%ax
  800b7e:	66 90                	xchg   %ax,%ax

00800b80 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	57                   	push   %edi
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
  800b86:	83 ec 3c             	sub    $0x3c,%esp
  800b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b8c:	89 d7                	mov    %edx,%edi
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	89 c3                	mov    %eax,%ebx
  800b99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800b9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ba2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800baa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bad:	39 d9                	cmp    %ebx,%ecx
  800baf:	72 05                	jb     800bb6 <printnum+0x36>
  800bb1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800bb4:	77 69                	ja     800c1f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bb6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bb9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800bbd:	83 ee 01             	sub    $0x1,%esi
  800bc0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc8:	8b 44 24 08          	mov    0x8(%esp),%eax
  800bcc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800bd0:	89 c3                	mov    %eax,%ebx
  800bd2:	89 d6                	mov    %edx,%esi
  800bd4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800bd7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800bda:	89 54 24 08          	mov    %edx,0x8(%esp)
  800bde:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be5:	89 04 24             	mov    %eax,(%esp)
  800be8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bef:	e8 3c 31 00 00       	call   803d30 <__udivdi3>
  800bf4:	89 d9                	mov    %ebx,%ecx
  800bf6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bfa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bfe:	89 04 24             	mov    %eax,(%esp)
  800c01:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c05:	89 fa                	mov    %edi,%edx
  800c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c0a:	e8 71 ff ff ff       	call   800b80 <printnum>
  800c0f:	eb 1b                	jmp    800c2c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c11:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c15:	8b 45 18             	mov    0x18(%ebp),%eax
  800c18:	89 04 24             	mov    %eax,(%esp)
  800c1b:	ff d3                	call   *%ebx
  800c1d:	eb 03                	jmp    800c22 <printnum+0xa2>
  800c1f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c22:	83 ee 01             	sub    $0x1,%esi
  800c25:	85 f6                	test   %esi,%esi
  800c27:	7f e8                	jg     800c11 <printnum+0x91>
  800c29:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c30:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c45:	89 04 24             	mov    %eax,(%esp)
  800c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c4f:	e8 0c 32 00 00       	call   803e60 <__umoddi3>
  800c54:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c58:	0f be 80 ef 41 80 00 	movsbl 0x8041ef(%eax),%eax
  800c5f:	89 04 24             	mov    %eax,(%esp)
  800c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c65:	ff d0                	call   *%eax
}
  800c67:	83 c4 3c             	add    $0x3c,%esp
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c75:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c79:	8b 10                	mov    (%eax),%edx
  800c7b:	3b 50 04             	cmp    0x4(%eax),%edx
  800c7e:	73 0a                	jae    800c8a <sprintputch+0x1b>
		*b->buf++ = ch;
  800c80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c83:	89 08                	mov    %ecx,(%eax)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	88 02                	mov    %al,(%edx)
}
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c92:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c99:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	89 04 24             	mov    %eax,(%esp)
  800cad:	e8 02 00 00 00       	call   800cb4 <vprintfmt>
	va_end(ap);
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
  800cba:	83 ec 3c             	sub    $0x3c,%esp
  800cbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc0:	eb 17                	jmp    800cd9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	0f 84 4b 04 00 00    	je     801115 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  800cca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cd1:	89 04 24             	mov    %eax,(%esp)
  800cd4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800cd7:	89 fb                	mov    %edi,%ebx
  800cd9:	8d 7b 01             	lea    0x1(%ebx),%edi
  800cdc:	0f b6 03             	movzbl (%ebx),%eax
  800cdf:	83 f8 25             	cmp    $0x25,%eax
  800ce2:	75 de                	jne    800cc2 <vprintfmt+0xe>
  800ce4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800ce8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800cef:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800cf4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800cfb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d00:	eb 18                	jmp    800d1a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d02:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800d04:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800d08:	eb 10                	jmp    800d1a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d0a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d0c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800d10:	eb 08                	jmp    800d1a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800d12:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800d15:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d1a:	8d 5f 01             	lea    0x1(%edi),%ebx
  800d1d:	0f b6 17             	movzbl (%edi),%edx
  800d20:	0f b6 c2             	movzbl %dl,%eax
  800d23:	83 ea 23             	sub    $0x23,%edx
  800d26:	80 fa 55             	cmp    $0x55,%dl
  800d29:	0f 87 c2 03 00 00    	ja     8010f1 <vprintfmt+0x43d>
  800d2f:	0f b6 d2             	movzbl %dl,%edx
  800d32:	ff 24 95 40 43 80 00 	jmp    *0x804340(,%edx,4)
  800d39:	89 df                	mov    %ebx,%edi
  800d3b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800d40:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800d43:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800d47:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  800d4a:	8d 50 d0             	lea    -0x30(%eax),%edx
  800d4d:	83 fa 09             	cmp    $0x9,%edx
  800d50:	77 33                	ja     800d85 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d52:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d55:	eb e9                	jmp    800d40 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d57:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5a:	8b 30                	mov    (%eax),%esi
  800d5c:	8d 40 04             	lea    0x4(%eax),%eax
  800d5f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d62:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800d64:	eb 1f                	jmp    800d85 <vprintfmt+0xd1>
  800d66:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800d69:	85 ff                	test   %edi,%edi
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	0f 49 c7             	cmovns %edi,%eax
  800d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d76:	89 df                	mov    %ebx,%edi
  800d78:	eb a0                	jmp    800d1a <vprintfmt+0x66>
  800d7a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800d7c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800d83:	eb 95                	jmp    800d1a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800d85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d89:	79 8f                	jns    800d1a <vprintfmt+0x66>
  800d8b:	eb 85                	jmp    800d12 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d8d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d90:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800d92:	eb 86                	jmp    800d1a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d94:	8b 45 14             	mov    0x14(%ebp),%eax
  800d97:	8d 70 04             	lea    0x4(%eax),%esi
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da1:	8b 45 14             	mov    0x14(%ebp),%eax
  800da4:	8b 00                	mov    (%eax),%eax
  800da6:	89 04 24             	mov    %eax,(%esp)
  800da9:	ff 55 08             	call   *0x8(%ebp)
  800dac:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  800daf:	e9 25 ff ff ff       	jmp    800cd9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	8d 70 04             	lea    0x4(%eax),%esi
  800dba:	8b 00                	mov    (%eax),%eax
  800dbc:	99                   	cltd   
  800dbd:	31 d0                	xor    %edx,%eax
  800dbf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dc1:	83 f8 15             	cmp    $0x15,%eax
  800dc4:	7f 0b                	jg     800dd1 <vprintfmt+0x11d>
  800dc6:	8b 14 85 a0 44 80 00 	mov    0x8044a0(,%eax,4),%edx
  800dcd:	85 d2                	test   %edx,%edx
  800dcf:	75 26                	jne    800df7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800dd1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800dd5:	c7 44 24 08 07 42 80 	movl   $0x804207,0x8(%esp)
  800ddc:	00 
  800ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	89 04 24             	mov    %eax,(%esp)
  800dea:	e8 9d fe ff ff       	call   800c8c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800def:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800df2:	e9 e2 fe ff ff       	jmp    800cd9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800df7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dfb:	c7 44 24 08 0f 41 80 	movl   $0x80410f,0x8(%esp)
  800e02:	00 
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	89 04 24             	mov    %eax,(%esp)
  800e10:	e8 77 fe ff ff       	call   800c8c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e15:	89 75 14             	mov    %esi,0x14(%ebp)
  800e18:	e9 bc fe ff ff       	jmp    800cd9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e20:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e23:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e26:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800e2a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800e2c:	85 ff                	test   %edi,%edi
  800e2e:	b8 00 42 80 00       	mov    $0x804200,%eax
  800e33:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800e36:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  800e3a:	0f 84 94 00 00 00    	je     800ed4 <vprintfmt+0x220>
  800e40:	85 c9                	test   %ecx,%ecx
  800e42:	0f 8e 94 00 00 00    	jle    800edc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e48:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e4c:	89 3c 24             	mov    %edi,(%esp)
  800e4f:	e8 54 04 00 00       	call   8012a8 <strnlen>
  800e54:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800e57:	29 c1                	sub    %eax,%ecx
  800e59:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  800e5c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800e60:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800e63:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800e66:	8b 75 08             	mov    0x8(%ebp),%esi
  800e69:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e6c:	89 cb                	mov    %ecx,%ebx
  800e6e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e70:	eb 0f                	jmp    800e81 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e79:	89 3c 24             	mov    %edi,(%esp)
  800e7c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7e:	83 eb 01             	sub    $0x1,%ebx
  800e81:	85 db                	test   %ebx,%ebx
  800e83:	7f ed                	jg     800e72 <vprintfmt+0x1be>
  800e85:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800e88:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800e8b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e8e:	85 c9                	test   %ecx,%ecx
  800e90:	b8 00 00 00 00       	mov    $0x0,%eax
  800e95:	0f 49 c1             	cmovns %ecx,%eax
  800e98:	29 c1                	sub    %eax,%ecx
  800e9a:	89 cb                	mov    %ecx,%ebx
  800e9c:	eb 44                	jmp    800ee2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800e9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ea2:	74 1e                	je     800ec2 <vprintfmt+0x20e>
  800ea4:	0f be d2             	movsbl %dl,%edx
  800ea7:	83 ea 20             	sub    $0x20,%edx
  800eaa:	83 fa 5e             	cmp    $0x5e,%edx
  800ead:	76 13                	jbe    800ec2 <vprintfmt+0x20e>
					putch('?', putdat);
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eb6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800ebd:	ff 55 08             	call   *0x8(%ebp)
  800ec0:	eb 0d                	jmp    800ecf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ec9:	89 04 24             	mov    %eax,(%esp)
  800ecc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ecf:	83 eb 01             	sub    $0x1,%ebx
  800ed2:	eb 0e                	jmp    800ee2 <vprintfmt+0x22e>
  800ed4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ed7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800eda:	eb 06                	jmp    800ee2 <vprintfmt+0x22e>
  800edc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800edf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800ee2:	83 c7 01             	add    $0x1,%edi
  800ee5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800ee9:	0f be c2             	movsbl %dl,%eax
  800eec:	85 c0                	test   %eax,%eax
  800eee:	74 27                	je     800f17 <vprintfmt+0x263>
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	78 aa                	js     800e9e <vprintfmt+0x1ea>
  800ef4:	83 ee 01             	sub    $0x1,%esi
  800ef7:	79 a5                	jns    800e9e <vprintfmt+0x1ea>
  800ef9:	89 d8                	mov    %ebx,%eax
  800efb:	8b 75 08             	mov    0x8(%ebp),%esi
  800efe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f01:	89 c3                	mov    %eax,%ebx
  800f03:	eb 18                	jmp    800f1d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800f05:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f09:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800f10:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f12:	83 eb 01             	sub    $0x1,%ebx
  800f15:	eb 06                	jmp    800f1d <vprintfmt+0x269>
  800f17:	8b 75 08             	mov    0x8(%ebp),%esi
  800f1a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f1d:	85 db                	test   %ebx,%ebx
  800f1f:	7f e4                	jg     800f05 <vprintfmt+0x251>
  800f21:	89 75 08             	mov    %esi,0x8(%ebp)
  800f24:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800f27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2a:	e9 aa fd ff ff       	jmp    800cd9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f2f:	83 f9 01             	cmp    $0x1,%ecx
  800f32:	7e 10                	jle    800f44 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800f34:	8b 45 14             	mov    0x14(%ebp),%eax
  800f37:	8b 30                	mov    (%eax),%esi
  800f39:	8b 78 04             	mov    0x4(%eax),%edi
  800f3c:	8d 40 08             	lea    0x8(%eax),%eax
  800f3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f42:	eb 26                	jmp    800f6a <vprintfmt+0x2b6>
	else if (lflag)
  800f44:	85 c9                	test   %ecx,%ecx
  800f46:	74 12                	je     800f5a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	8b 30                	mov    (%eax),%esi
  800f4d:	89 f7                	mov    %esi,%edi
  800f4f:	c1 ff 1f             	sar    $0x1f,%edi
  800f52:	8d 40 04             	lea    0x4(%eax),%eax
  800f55:	89 45 14             	mov    %eax,0x14(%ebp)
  800f58:	eb 10                	jmp    800f6a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  800f5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5d:	8b 30                	mov    (%eax),%esi
  800f5f:	89 f7                	mov    %esi,%edi
  800f61:	c1 ff 1f             	sar    $0x1f,%edi
  800f64:	8d 40 04             	lea    0x4(%eax),%eax
  800f67:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f6a:	89 f0                	mov    %esi,%eax
  800f6c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800f6e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800f73:	85 ff                	test   %edi,%edi
  800f75:	0f 89 3a 01 00 00    	jns    8010b5 <vprintfmt+0x401>
				putch('-', putdat);
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f82:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800f89:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800f8c:	89 f0                	mov    %esi,%eax
  800f8e:	89 fa                	mov    %edi,%edx
  800f90:	f7 d8                	neg    %eax
  800f92:	83 d2 00             	adc    $0x0,%edx
  800f95:	f7 da                	neg    %edx
			}
			base = 10;
  800f97:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f9c:	e9 14 01 00 00       	jmp    8010b5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800fa1:	83 f9 01             	cmp    $0x1,%ecx
  800fa4:	7e 13                	jle    800fb9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800fa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa9:	8b 50 04             	mov    0x4(%eax),%edx
  800fac:	8b 00                	mov    (%eax),%eax
  800fae:	8b 75 14             	mov    0x14(%ebp),%esi
  800fb1:	8d 4e 08             	lea    0x8(%esi),%ecx
  800fb4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800fb7:	eb 2c                	jmp    800fe5 <vprintfmt+0x331>
	else if (lflag)
  800fb9:	85 c9                	test   %ecx,%ecx
  800fbb:	74 15                	je     800fd2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  800fbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc7:	8b 75 14             	mov    0x14(%ebp),%esi
  800fca:	8d 76 04             	lea    0x4(%esi),%esi
  800fcd:	89 75 14             	mov    %esi,0x14(%ebp)
  800fd0:	eb 13                	jmp    800fe5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd5:	8b 00                	mov    (%eax),%eax
  800fd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdc:	8b 75 14             	mov    0x14(%ebp),%esi
  800fdf:	8d 76 04             	lea    0x4(%esi),%esi
  800fe2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800fe5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800fea:	e9 c6 00 00 00       	jmp    8010b5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800fef:	83 f9 01             	cmp    $0x1,%ecx
  800ff2:	7e 13                	jle    801007 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800ff4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff7:	8b 50 04             	mov    0x4(%eax),%edx
  800ffa:	8b 00                	mov    (%eax),%eax
  800ffc:	8b 75 14             	mov    0x14(%ebp),%esi
  800fff:	8d 4e 08             	lea    0x8(%esi),%ecx
  801002:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801005:	eb 24                	jmp    80102b <vprintfmt+0x377>
	else if (lflag)
  801007:	85 c9                	test   %ecx,%ecx
  801009:	74 11                	je     80101c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80100b:	8b 45 14             	mov    0x14(%ebp),%eax
  80100e:	8b 00                	mov    (%eax),%eax
  801010:	99                   	cltd   
  801011:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801014:	8d 71 04             	lea    0x4(%ecx),%esi
  801017:	89 75 14             	mov    %esi,0x14(%ebp)
  80101a:	eb 0f                	jmp    80102b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80101c:	8b 45 14             	mov    0x14(%ebp),%eax
  80101f:	8b 00                	mov    (%eax),%eax
  801021:	99                   	cltd   
  801022:	8b 75 14             	mov    0x14(%ebp),%esi
  801025:	8d 76 04             	lea    0x4(%esi),%esi
  801028:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80102b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801030:	e9 80 00 00 00       	jmp    8010b5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801035:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80103f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801046:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801050:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801057:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80105a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105e:	8b 06                	mov    (%esi),%eax
  801060:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801065:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80106a:	eb 49                	jmp    8010b5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80106c:	83 f9 01             	cmp    $0x1,%ecx
  80106f:	7e 13                	jle    801084 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  801071:	8b 45 14             	mov    0x14(%ebp),%eax
  801074:	8b 50 04             	mov    0x4(%eax),%edx
  801077:	8b 00                	mov    (%eax),%eax
  801079:	8b 75 14             	mov    0x14(%ebp),%esi
  80107c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80107f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801082:	eb 2c                	jmp    8010b0 <vprintfmt+0x3fc>
	else if (lflag)
  801084:	85 c9                	test   %ecx,%ecx
  801086:	74 15                	je     80109d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  801088:	8b 45 14             	mov    0x14(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	ba 00 00 00 00       	mov    $0x0,%edx
  801092:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801095:	8d 71 04             	lea    0x4(%ecx),%esi
  801098:	89 75 14             	mov    %esi,0x14(%ebp)
  80109b:	eb 13                	jmp    8010b0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a7:	8b 75 14             	mov    0x14(%ebp),%esi
  8010aa:	8d 76 04             	lea    0x4(%esi),%esi
  8010ad:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8010b0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010b5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8010b9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8010bd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8010c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8010c4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010c8:	89 04 24             	mov    %eax,(%esp)
  8010cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	e8 a6 fa ff ff       	call   800b80 <printnum>
			break;
  8010da:	e9 fa fb ff ff       	jmp    800cd9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8010e6:	89 04 24             	mov    %eax,(%esp)
  8010e9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8010ec:	e9 e8 fb ff ff       	jmp    800cd9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8010ff:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801102:	89 fb                	mov    %edi,%ebx
  801104:	eb 03                	jmp    801109 <vprintfmt+0x455>
  801106:	83 eb 01             	sub    $0x1,%ebx
  801109:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80110d:	75 f7                	jne    801106 <vprintfmt+0x452>
  80110f:	90                   	nop
  801110:	e9 c4 fb ff ff       	jmp    800cd9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801115:	83 c4 3c             	add    $0x3c,%esp
  801118:	5b                   	pop    %ebx
  801119:	5e                   	pop    %esi
  80111a:	5f                   	pop    %edi
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	83 ec 28             	sub    $0x28,%esp
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801129:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80112c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801130:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801133:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80113a:	85 c0                	test   %eax,%eax
  80113c:	74 30                	je     80116e <vsnprintf+0x51>
  80113e:	85 d2                	test   %edx,%edx
  801140:	7e 2c                	jle    80116e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801142:	8b 45 14             	mov    0x14(%ebp),%eax
  801145:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801150:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801153:	89 44 24 04          	mov    %eax,0x4(%esp)
  801157:	c7 04 24 6f 0c 80 00 	movl   $0x800c6f,(%esp)
  80115e:	e8 51 fb ff ff       	call   800cb4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801163:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801166:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	eb 05                	jmp    801173 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80116e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80117b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80117e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	89 44 24 08          	mov    %eax,0x8(%esp)
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	89 04 24             	mov    %eax,(%esp)
  801196:	e8 82 ff ff ff       	call   80111d <vsnprintf>
	va_end(ap);

	return rc;
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    
  80119d:	66 90                	xchg   %ax,%ax
  80119f:	90                   	nop

008011a0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	57                   	push   %edi
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 1c             	sub    $0x1c,%esp
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	74 18                	je     8011c8 <readline+0x28>
		fprintf(1, "%s", prompt);
  8011b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011b4:	c7 44 24 04 0f 41 80 	movl   $0x80410f,0x4(%esp)
  8011bb:	00 
  8011bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8011c3:	e8 8e 19 00 00       	call   802b56 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  8011c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011cf:	e8 a8 f7 ff ff       	call   80097c <iscons>
  8011d4:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  8011d6:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  8011db:	e8 66 f7 ff ff       	call   800946 <getchar>
  8011e0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	79 25                	jns    80120b <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8011e6:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  8011eb:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8011ee:	0f 84 88 00 00 00    	je     80127c <readline+0xdc>
				cprintf("read error: %e\n", c);
  8011f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011f8:	c7 04 24 17 45 80 00 	movl   $0x804517,(%esp)
  8011ff:	e8 5c f9 ff ff       	call   800b60 <cprintf>
			return NULL;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 71                	jmp    80127c <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80120b:	83 f8 7f             	cmp    $0x7f,%eax
  80120e:	74 05                	je     801215 <readline+0x75>
  801210:	83 f8 08             	cmp    $0x8,%eax
  801213:	75 19                	jne    80122e <readline+0x8e>
  801215:	85 f6                	test   %esi,%esi
  801217:	7e 15                	jle    80122e <readline+0x8e>
			if (echoing)
  801219:	85 ff                	test   %edi,%edi
  80121b:	74 0c                	je     801229 <readline+0x89>
				cputchar('\b');
  80121d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  801224:	e8 fc f6 ff ff       	call   800925 <cputchar>
			i--;
  801229:	83 ee 01             	sub    $0x1,%esi
  80122c:	eb ad                	jmp    8011db <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80122e:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801234:	7f 1c                	jg     801252 <readline+0xb2>
  801236:	83 fb 1f             	cmp    $0x1f,%ebx
  801239:	7e 17                	jle    801252 <readline+0xb2>
			if (echoing)
  80123b:	85 ff                	test   %edi,%edi
  80123d:	74 08                	je     801247 <readline+0xa7>
				cputchar(c);
  80123f:	89 1c 24             	mov    %ebx,(%esp)
  801242:	e8 de f6 ff ff       	call   800925 <cputchar>
			buf[i++] = c;
  801247:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  80124d:	8d 76 01             	lea    0x1(%esi),%esi
  801250:	eb 89                	jmp    8011db <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  801252:	83 fb 0d             	cmp    $0xd,%ebx
  801255:	74 09                	je     801260 <readline+0xc0>
  801257:	83 fb 0a             	cmp    $0xa,%ebx
  80125a:	0f 85 7b ff ff ff    	jne    8011db <readline+0x3b>
			if (echoing)
  801260:	85 ff                	test   %edi,%edi
  801262:	74 0c                	je     801270 <readline+0xd0>
				cputchar('\n');
  801264:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80126b:	e8 b5 f6 ff ff       	call   800925 <cputchar>
			buf[i] = 0;
  801270:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  801277:	b8 20 60 80 00       	mov    $0x806020,%eax
		}
	}
}
  80127c:	83 c4 1c             	add    $0x1c,%esp
  80127f:	5b                   	pop    %ebx
  801280:	5e                   	pop    %esi
  801281:	5f                   	pop    %edi
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    
  801284:	66 90                	xchg   %ax,%ax
  801286:	66 90                	xchg   %ax,%ax
  801288:	66 90                	xchg   %ax,%ax
  80128a:	66 90                	xchg   %ax,%ax
  80128c:	66 90                	xchg   %ax,%ax
  80128e:	66 90                	xchg   %ax,%ax

00801290 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801296:	b8 00 00 00 00       	mov    $0x0,%eax
  80129b:	eb 03                	jmp    8012a0 <strlen+0x10>
		n++;
  80129d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8012a4:	75 f7                	jne    80129d <strlen+0xd>
		n++;
	return n;
}
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b6:	eb 03                	jmp    8012bb <strnlen+0x13>
		n++;
  8012b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012bb:	39 d0                	cmp    %edx,%eax
  8012bd:	74 06                	je     8012c5 <strnlen+0x1d>
  8012bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8012c3:	75 f3                	jne    8012b8 <strnlen+0x10>
		n++;
	return n;
}
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    

008012c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	53                   	push   %ebx
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8012d1:	89 c2                	mov    %eax,%edx
  8012d3:	83 c2 01             	add    $0x1,%edx
  8012d6:	83 c1 01             	add    $0x1,%ecx
  8012d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8012dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8012e0:	84 db                	test   %bl,%bl
  8012e2:	75 ef                	jne    8012d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8012e4:	5b                   	pop    %ebx
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012f1:	89 1c 24             	mov    %ebx,(%esp)
  8012f4:	e8 97 ff ff ff       	call   801290 <strlen>
	strcpy(dst + len, src);
  8012f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801300:	01 d8                	add    %ebx,%eax
  801302:	89 04 24             	mov    %eax,(%esp)
  801305:	e8 bd ff ff ff       	call   8012c7 <strcpy>
	return dst;
}
  80130a:	89 d8                	mov    %ebx,%eax
  80130c:	83 c4 08             	add    $0x8,%esp
  80130f:	5b                   	pop    %ebx
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    

00801312 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	56                   	push   %esi
  801316:	53                   	push   %ebx
  801317:	8b 75 08             	mov    0x8(%ebp),%esi
  80131a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131d:	89 f3                	mov    %esi,%ebx
  80131f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801322:	89 f2                	mov    %esi,%edx
  801324:	eb 0f                	jmp    801335 <strncpy+0x23>
		*dst++ = *src;
  801326:	83 c2 01             	add    $0x1,%edx
  801329:	0f b6 01             	movzbl (%ecx),%eax
  80132c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80132f:	80 39 01             	cmpb   $0x1,(%ecx)
  801332:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801335:	39 da                	cmp    %ebx,%edx
  801337:	75 ed                	jne    801326 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801339:	89 f0                	mov    %esi,%eax
  80133b:	5b                   	pop    %ebx
  80133c:	5e                   	pop    %esi
  80133d:	5d                   	pop    %ebp
  80133e:	c3                   	ret    

0080133f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	56                   	push   %esi
  801343:	53                   	push   %ebx
  801344:	8b 75 08             	mov    0x8(%ebp),%esi
  801347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80134d:	89 f0                	mov    %esi,%eax
  80134f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801353:	85 c9                	test   %ecx,%ecx
  801355:	75 0b                	jne    801362 <strlcpy+0x23>
  801357:	eb 1d                	jmp    801376 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801359:	83 c0 01             	add    $0x1,%eax
  80135c:	83 c2 01             	add    $0x1,%edx
  80135f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801362:	39 d8                	cmp    %ebx,%eax
  801364:	74 0b                	je     801371 <strlcpy+0x32>
  801366:	0f b6 0a             	movzbl (%edx),%ecx
  801369:	84 c9                	test   %cl,%cl
  80136b:	75 ec                	jne    801359 <strlcpy+0x1a>
  80136d:	89 c2                	mov    %eax,%edx
  80136f:	eb 02                	jmp    801373 <strlcpy+0x34>
  801371:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801373:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801376:	29 f0                	sub    %esi,%eax
}
  801378:	5b                   	pop    %ebx
  801379:	5e                   	pop    %esi
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801382:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801385:	eb 06                	jmp    80138d <strcmp+0x11>
		p++, q++;
  801387:	83 c1 01             	add    $0x1,%ecx
  80138a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80138d:	0f b6 01             	movzbl (%ecx),%eax
  801390:	84 c0                	test   %al,%al
  801392:	74 04                	je     801398 <strcmp+0x1c>
  801394:	3a 02                	cmp    (%edx),%al
  801396:	74 ef                	je     801387 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801398:	0f b6 c0             	movzbl %al,%eax
  80139b:	0f b6 12             	movzbl (%edx),%edx
  80139e:	29 d0                	sub    %edx,%eax
}
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    

008013a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	53                   	push   %ebx
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ac:	89 c3                	mov    %eax,%ebx
  8013ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8013b1:	eb 06                	jmp    8013b9 <strncmp+0x17>
		n--, p++, q++;
  8013b3:	83 c0 01             	add    $0x1,%eax
  8013b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013b9:	39 d8                	cmp    %ebx,%eax
  8013bb:	74 15                	je     8013d2 <strncmp+0x30>
  8013bd:	0f b6 08             	movzbl (%eax),%ecx
  8013c0:	84 c9                	test   %cl,%cl
  8013c2:	74 04                	je     8013c8 <strncmp+0x26>
  8013c4:	3a 0a                	cmp    (%edx),%cl
  8013c6:	74 eb                	je     8013b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c8:	0f b6 00             	movzbl (%eax),%eax
  8013cb:	0f b6 12             	movzbl (%edx),%edx
  8013ce:	29 d0                	sub    %edx,%eax
  8013d0:	eb 05                	jmp    8013d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8013d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8013d7:	5b                   	pop    %ebx
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013e4:	eb 07                	jmp    8013ed <strchr+0x13>
		if (*s == c)
  8013e6:	38 ca                	cmp    %cl,%dl
  8013e8:	74 0f                	je     8013f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013ea:	83 c0 01             	add    $0x1,%eax
  8013ed:	0f b6 10             	movzbl (%eax),%edx
  8013f0:	84 d2                	test   %dl,%dl
  8013f2:	75 f2                	jne    8013e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8013f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    

008013fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801405:	eb 07                	jmp    80140e <strfind+0x13>
		if (*s == c)
  801407:	38 ca                	cmp    %cl,%dl
  801409:	74 0a                	je     801415 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80140b:	83 c0 01             	add    $0x1,%eax
  80140e:	0f b6 10             	movzbl (%eax),%edx
  801411:	84 d2                	test   %dl,%dl
  801413:	75 f2                	jne    801407 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	57                   	push   %edi
  80141b:	56                   	push   %esi
  80141c:	53                   	push   %ebx
  80141d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801420:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801423:	85 c9                	test   %ecx,%ecx
  801425:	74 36                	je     80145d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801427:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80142d:	75 28                	jne    801457 <memset+0x40>
  80142f:	f6 c1 03             	test   $0x3,%cl
  801432:	75 23                	jne    801457 <memset+0x40>
		c &= 0xFF;
  801434:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801438:	89 d3                	mov    %edx,%ebx
  80143a:	c1 e3 08             	shl    $0x8,%ebx
  80143d:	89 d6                	mov    %edx,%esi
  80143f:	c1 e6 18             	shl    $0x18,%esi
  801442:	89 d0                	mov    %edx,%eax
  801444:	c1 e0 10             	shl    $0x10,%eax
  801447:	09 f0                	or     %esi,%eax
  801449:	09 c2                	or     %eax,%edx
  80144b:	89 d0                	mov    %edx,%eax
  80144d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80144f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801452:	fc                   	cld    
  801453:	f3 ab                	rep stos %eax,%es:(%edi)
  801455:	eb 06                	jmp    80145d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	fc                   	cld    
  80145b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80145d:	89 f8                	mov    %edi,%eax
  80145f:	5b                   	pop    %ebx
  801460:	5e                   	pop    %esi
  801461:	5f                   	pop    %edi
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    

00801464 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80146f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801472:	39 c6                	cmp    %eax,%esi
  801474:	73 35                	jae    8014ab <memmove+0x47>
  801476:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801479:	39 d0                	cmp    %edx,%eax
  80147b:	73 2e                	jae    8014ab <memmove+0x47>
		s += n;
		d += n;
  80147d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801480:	89 d6                	mov    %edx,%esi
  801482:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801484:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80148a:	75 13                	jne    80149f <memmove+0x3b>
  80148c:	f6 c1 03             	test   $0x3,%cl
  80148f:	75 0e                	jne    80149f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801491:	83 ef 04             	sub    $0x4,%edi
  801494:	8d 72 fc             	lea    -0x4(%edx),%esi
  801497:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80149a:	fd                   	std    
  80149b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80149d:	eb 09                	jmp    8014a8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80149f:	83 ef 01             	sub    $0x1,%edi
  8014a2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014a5:	fd                   	std    
  8014a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014a8:	fc                   	cld    
  8014a9:	eb 1d                	jmp    8014c8 <memmove+0x64>
  8014ab:	89 f2                	mov    %esi,%edx
  8014ad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014af:	f6 c2 03             	test   $0x3,%dl
  8014b2:	75 0f                	jne    8014c3 <memmove+0x5f>
  8014b4:	f6 c1 03             	test   $0x3,%cl
  8014b7:	75 0a                	jne    8014c3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014b9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014bc:	89 c7                	mov    %eax,%edi
  8014be:	fc                   	cld    
  8014bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014c1:	eb 05                	jmp    8014c8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014c3:	89 c7                	mov    %eax,%edi
  8014c5:	fc                   	cld    
  8014c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8014c8:	5e                   	pop    %esi
  8014c9:	5f                   	pop    %edi
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8014d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	89 04 24             	mov    %eax,(%esp)
  8014e6:	e8 79 ff ff ff       	call   801464 <memmove>
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
  8014f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f8:	89 d6                	mov    %edx,%esi
  8014fa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014fd:	eb 1a                	jmp    801519 <memcmp+0x2c>
		if (*s1 != *s2)
  8014ff:	0f b6 02             	movzbl (%edx),%eax
  801502:	0f b6 19             	movzbl (%ecx),%ebx
  801505:	38 d8                	cmp    %bl,%al
  801507:	74 0a                	je     801513 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801509:	0f b6 c0             	movzbl %al,%eax
  80150c:	0f b6 db             	movzbl %bl,%ebx
  80150f:	29 d8                	sub    %ebx,%eax
  801511:	eb 0f                	jmp    801522 <memcmp+0x35>
		s1++, s2++;
  801513:	83 c2 01             	add    $0x1,%edx
  801516:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801519:	39 f2                	cmp    %esi,%edx
  80151b:	75 e2                	jne    8014ff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    

00801526 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80152f:	89 c2                	mov    %eax,%edx
  801531:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801534:	eb 07                	jmp    80153d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801536:	38 08                	cmp    %cl,(%eax)
  801538:	74 07                	je     801541 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80153a:	83 c0 01             	add    $0x1,%eax
  80153d:	39 d0                	cmp    %edx,%eax
  80153f:	72 f5                	jb     801536 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801541:	5d                   	pop    %ebp
  801542:	c3                   	ret    

00801543 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	57                   	push   %edi
  801547:	56                   	push   %esi
  801548:	53                   	push   %ebx
  801549:	8b 55 08             	mov    0x8(%ebp),%edx
  80154c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80154f:	eb 03                	jmp    801554 <strtol+0x11>
		s++;
  801551:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801554:	0f b6 0a             	movzbl (%edx),%ecx
  801557:	80 f9 09             	cmp    $0x9,%cl
  80155a:	74 f5                	je     801551 <strtol+0xe>
  80155c:	80 f9 20             	cmp    $0x20,%cl
  80155f:	74 f0                	je     801551 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801561:	80 f9 2b             	cmp    $0x2b,%cl
  801564:	75 0a                	jne    801570 <strtol+0x2d>
		s++;
  801566:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801569:	bf 00 00 00 00       	mov    $0x0,%edi
  80156e:	eb 11                	jmp    801581 <strtol+0x3e>
  801570:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801575:	80 f9 2d             	cmp    $0x2d,%cl
  801578:	75 07                	jne    801581 <strtol+0x3e>
		s++, neg = 1;
  80157a:	8d 52 01             	lea    0x1(%edx),%edx
  80157d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801581:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801586:	75 15                	jne    80159d <strtol+0x5a>
  801588:	80 3a 30             	cmpb   $0x30,(%edx)
  80158b:	75 10                	jne    80159d <strtol+0x5a>
  80158d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801591:	75 0a                	jne    80159d <strtol+0x5a>
		s += 2, base = 16;
  801593:	83 c2 02             	add    $0x2,%edx
  801596:	b8 10 00 00 00       	mov    $0x10,%eax
  80159b:	eb 10                	jmp    8015ad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80159d:	85 c0                	test   %eax,%eax
  80159f:	75 0c                	jne    8015ad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8015a1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8015a3:	80 3a 30             	cmpb   $0x30,(%edx)
  8015a6:	75 05                	jne    8015ad <strtol+0x6a>
		s++, base = 8;
  8015a8:	83 c2 01             	add    $0x1,%edx
  8015ab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8015ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015b5:	0f b6 0a             	movzbl (%edx),%ecx
  8015b8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8015bb:	89 f0                	mov    %esi,%eax
  8015bd:	3c 09                	cmp    $0x9,%al
  8015bf:	77 08                	ja     8015c9 <strtol+0x86>
			dig = *s - '0';
  8015c1:	0f be c9             	movsbl %cl,%ecx
  8015c4:	83 e9 30             	sub    $0x30,%ecx
  8015c7:	eb 20                	jmp    8015e9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8015c9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8015cc:	89 f0                	mov    %esi,%eax
  8015ce:	3c 19                	cmp    $0x19,%al
  8015d0:	77 08                	ja     8015da <strtol+0x97>
			dig = *s - 'a' + 10;
  8015d2:	0f be c9             	movsbl %cl,%ecx
  8015d5:	83 e9 57             	sub    $0x57,%ecx
  8015d8:	eb 0f                	jmp    8015e9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8015da:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8015dd:	89 f0                	mov    %esi,%eax
  8015df:	3c 19                	cmp    $0x19,%al
  8015e1:	77 16                	ja     8015f9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8015e3:	0f be c9             	movsbl %cl,%ecx
  8015e6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8015e9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8015ec:	7d 0f                	jge    8015fd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8015ee:	83 c2 01             	add    $0x1,%edx
  8015f1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8015f5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8015f7:	eb bc                	jmp    8015b5 <strtol+0x72>
  8015f9:	89 d8                	mov    %ebx,%eax
  8015fb:	eb 02                	jmp    8015ff <strtol+0xbc>
  8015fd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8015ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801603:	74 05                	je     80160a <strtol+0xc7>
		*endptr = (char *) s;
  801605:	8b 75 0c             	mov    0xc(%ebp),%esi
  801608:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80160a:	f7 d8                	neg    %eax
  80160c:	85 ff                	test   %edi,%edi
  80160e:	0f 44 c3             	cmove  %ebx,%eax
}
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5f                   	pop    %edi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	57                   	push   %edi
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801624:	8b 55 08             	mov    0x8(%ebp),%edx
  801627:	89 c3                	mov    %eax,%ebx
  801629:	89 c7                	mov    %eax,%edi
  80162b:	89 c6                	mov    %eax,%esi
  80162d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80162f:	5b                   	pop    %ebx
  801630:	5e                   	pop    %esi
  801631:	5f                   	pop    %edi
  801632:	5d                   	pop    %ebp
  801633:	c3                   	ret    

00801634 <sys_cgetc>:

int
sys_cgetc(void)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	57                   	push   %edi
  801638:	56                   	push   %esi
  801639:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	b8 01 00 00 00       	mov    $0x1,%eax
  801644:	89 d1                	mov    %edx,%ecx
  801646:	89 d3                	mov    %edx,%ebx
  801648:	89 d7                	mov    %edx,%edi
  80164a:	89 d6                	mov    %edx,%esi
  80164c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80164e:	5b                   	pop    %ebx
  80164f:	5e                   	pop    %esi
  801650:	5f                   	pop    %edi
  801651:	5d                   	pop    %ebp
  801652:	c3                   	ret    

00801653 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	57                   	push   %edi
  801657:	56                   	push   %esi
  801658:	53                   	push   %ebx
  801659:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80165c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801661:	b8 03 00 00 00       	mov    $0x3,%eax
  801666:	8b 55 08             	mov    0x8(%ebp),%edx
  801669:	89 cb                	mov    %ecx,%ebx
  80166b:	89 cf                	mov    %ecx,%edi
  80166d:	89 ce                	mov    %ecx,%esi
  80166f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801671:	85 c0                	test   %eax,%eax
  801673:	7e 28                	jle    80169d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801675:	89 44 24 10          	mov    %eax,0x10(%esp)
  801679:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801680:	00 
  801681:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  801688:	00 
  801689:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801690:	00 
  801691:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  801698:	e8 ca f3 ff ff       	call   800a67 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80169d:	83 c4 2c             	add    $0x2c,%esp
  8016a0:	5b                   	pop    %ebx
  8016a1:	5e                   	pop    %esi
  8016a2:	5f                   	pop    %edi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	57                   	push   %edi
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 cb                	mov    %ecx,%ebx
  8016bd:	89 cf                	mov    %ecx,%edi
  8016bf:	89 ce                	mov    %ecx,%esi
  8016c1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	7e 28                	jle    8016ef <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016cb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8016d2:	00 
  8016d3:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  8016da:	00 
  8016db:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016e2:	00 
  8016e3:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  8016ea:	e8 78 f3 ff ff       	call   800a67 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  8016ef:	83 c4 2c             	add    $0x2c,%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	57                   	push   %edi
  8016fb:	56                   	push   %esi
  8016fc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801702:	b8 02 00 00 00       	mov    $0x2,%eax
  801707:	89 d1                	mov    %edx,%ecx
  801709:	89 d3                	mov    %edx,%ebx
  80170b:	89 d7                	mov    %edx,%edi
  80170d:	89 d6                	mov    %edx,%esi
  80170f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801711:	5b                   	pop    %ebx
  801712:	5e                   	pop    %esi
  801713:	5f                   	pop    %edi
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    

00801716 <sys_yield>:

void
sys_yield(void)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	57                   	push   %edi
  80171a:	56                   	push   %esi
  80171b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80171c:	ba 00 00 00 00       	mov    $0x0,%edx
  801721:	b8 0c 00 00 00       	mov    $0xc,%eax
  801726:	89 d1                	mov    %edx,%ecx
  801728:	89 d3                	mov    %edx,%ebx
  80172a:	89 d7                	mov    %edx,%edi
  80172c:	89 d6                	mov    %edx,%esi
  80172e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5f                   	pop    %edi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  80173e:	be 00 00 00 00       	mov    $0x0,%esi
  801743:	b8 05 00 00 00       	mov    $0x5,%eax
  801748:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801751:	89 f7                	mov    %esi,%edi
  801753:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801755:	85 c0                	test   %eax,%eax
  801757:	7e 28                	jle    801781 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801759:	89 44 24 10          	mov    %eax,0x10(%esp)
  80175d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801764:	00 
  801765:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  80176c:	00 
  80176d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801774:	00 
  801775:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  80177c:	e8 e6 f2 ff ff       	call   800a67 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801781:	83 c4 2c             	add    $0x2c,%esp
  801784:	5b                   	pop    %ebx
  801785:	5e                   	pop    %esi
  801786:	5f                   	pop    %edi
  801787:	5d                   	pop    %ebp
  801788:	c3                   	ret    

00801789 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	57                   	push   %edi
  80178d:	56                   	push   %esi
  80178e:	53                   	push   %ebx
  80178f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801792:	b8 06 00 00 00       	mov    $0x6,%eax
  801797:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179a:	8b 55 08             	mov    0x8(%ebp),%edx
  80179d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017a0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8017a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8017a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	7e 28                	jle    8017d4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017b0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8017b7:	00 
  8017b8:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  8017bf:	00 
  8017c0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017c7:	00 
  8017c8:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  8017cf:	e8 93 f2 ff ff       	call   800a67 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8017d4:	83 c4 2c             	add    $0x2c,%esp
  8017d7:	5b                   	pop    %ebx
  8017d8:	5e                   	pop    %esi
  8017d9:	5f                   	pop    %edi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	57                   	push   %edi
  8017e0:	56                   	push   %esi
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ea:	b8 07 00 00 00       	mov    $0x7,%eax
  8017ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f5:	89 df                	mov    %ebx,%edi
  8017f7:	89 de                	mov    %ebx,%esi
  8017f9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	7e 28                	jle    801827 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  801803:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80180a:	00 
  80180b:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  801812:	00 
  801813:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80181a:	00 
  80181b:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  801822:	e8 40 f2 ff ff       	call   800a67 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801827:	83 c4 2c             	add    $0x2c,%esp
  80182a:	5b                   	pop    %ebx
  80182b:	5e                   	pop    %esi
  80182c:	5f                   	pop    %edi
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    

0080182f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	57                   	push   %edi
  801833:	56                   	push   %esi
  801834:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801835:	b9 00 00 00 00       	mov    $0x0,%ecx
  80183a:	b8 10 00 00 00       	mov    $0x10,%eax
  80183f:	8b 55 08             	mov    0x8(%ebp),%edx
  801842:	89 cb                	mov    %ecx,%ebx
  801844:	89 cf                	mov    %ecx,%edi
  801846:	89 ce                	mov    %ecx,%esi
  801848:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80184a:	5b                   	pop    %ebx
  80184b:	5e                   	pop    %esi
  80184c:	5f                   	pop    %edi
  80184d:	5d                   	pop    %ebp
  80184e:	c3                   	ret    

0080184f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	57                   	push   %edi
  801853:	56                   	push   %esi
  801854:	53                   	push   %ebx
  801855:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801858:	bb 00 00 00 00       	mov    $0x0,%ebx
  80185d:	b8 09 00 00 00       	mov    $0x9,%eax
  801862:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801865:	8b 55 08             	mov    0x8(%ebp),%edx
  801868:	89 df                	mov    %ebx,%edi
  80186a:	89 de                	mov    %ebx,%esi
  80186c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80186e:	85 c0                	test   %eax,%eax
  801870:	7e 28                	jle    80189a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801872:	89 44 24 10          	mov    %eax,0x10(%esp)
  801876:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80187d:	00 
  80187e:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  801885:	00 
  801886:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80188d:	00 
  80188e:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  801895:	e8 cd f1 ff ff       	call   800a67 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80189a:	83 c4 2c             	add    $0x2c,%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5f                   	pop    %edi
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    

008018a2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	57                   	push   %edi
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8018b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018bb:	89 df                	mov    %ebx,%edi
  8018bd:	89 de                	mov    %ebx,%esi
  8018bf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	7e 28                	jle    8018ed <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018c9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8018d0:	00 
  8018d1:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  8018d8:	00 
  8018d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018e0:	00 
  8018e1:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  8018e8:	e8 7a f1 ff ff       	call   800a67 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8018ed:	83 c4 2c             	add    $0x2c,%esp
  8018f0:	5b                   	pop    %ebx
  8018f1:	5e                   	pop    %esi
  8018f2:	5f                   	pop    %edi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    

008018f5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	57                   	push   %edi
  8018f9:	56                   	push   %esi
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801903:	b8 0b 00 00 00       	mov    $0xb,%eax
  801908:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80190b:	8b 55 08             	mov    0x8(%ebp),%edx
  80190e:	89 df                	mov    %ebx,%edi
  801910:	89 de                	mov    %ebx,%esi
  801912:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801914:	85 c0                	test   %eax,%eax
  801916:	7e 28                	jle    801940 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801918:	89 44 24 10          	mov    %eax,0x10(%esp)
  80191c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801923:	00 
  801924:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  80192b:	00 
  80192c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801933:	00 
  801934:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  80193b:	e8 27 f1 ff ff       	call   800a67 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801940:	83 c4 2c             	add    $0x2c,%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5f                   	pop    %edi
  801946:	5d                   	pop    %ebp
  801947:	c3                   	ret    

00801948 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	57                   	push   %edi
  80194c:	56                   	push   %esi
  80194d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80194e:	be 00 00 00 00       	mov    $0x0,%esi
  801953:	b8 0d 00 00 00       	mov    $0xd,%eax
  801958:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80195b:	8b 55 08             	mov    0x8(%ebp),%edx
  80195e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801961:	8b 7d 14             	mov    0x14(%ebp),%edi
  801964:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801966:	5b                   	pop    %ebx
  801967:	5e                   	pop    %esi
  801968:	5f                   	pop    %edi
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    

0080196b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	57                   	push   %edi
  80196f:	56                   	push   %esi
  801970:	53                   	push   %ebx
  801971:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801974:	b9 00 00 00 00       	mov    $0x0,%ecx
  801979:	b8 0e 00 00 00       	mov    $0xe,%eax
  80197e:	8b 55 08             	mov    0x8(%ebp),%edx
  801981:	89 cb                	mov    %ecx,%ebx
  801983:	89 cf                	mov    %ecx,%edi
  801985:	89 ce                	mov    %ecx,%esi
  801987:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801989:	85 c0                	test   %eax,%eax
  80198b:	7e 28                	jle    8019b5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80198d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801991:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801998:	00 
  801999:	c7 44 24 08 27 45 80 	movl   $0x804527,0x8(%esp)
  8019a0:	00 
  8019a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019a8:	00 
  8019a9:	c7 04 24 44 45 80 00 	movl   $0x804544,(%esp)
  8019b0:	e8 b2 f0 ff ff       	call   800a67 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8019b5:	83 c4 2c             	add    $0x2c,%esp
  8019b8:	5b                   	pop    %ebx
  8019b9:	5e                   	pop    %esi
  8019ba:	5f                   	pop    %edi
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    

008019bd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	57                   	push   %edi
  8019c1:	56                   	push   %esi
  8019c2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8019cd:	89 d1                	mov    %edx,%ecx
  8019cf:	89 d3                	mov    %edx,%ebx
  8019d1:	89 d7                	mov    %edx,%edi
  8019d3:	89 d6                	mov    %edx,%esi
  8019d5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5f                   	pop    %edi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    

008019dc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	57                   	push   %edi
  8019e0:	56                   	push   %esi
  8019e1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019e7:	b8 11 00 00 00       	mov    $0x11,%eax
  8019ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f2:	89 df                	mov    %ebx,%edi
  8019f4:	89 de                	mov    %ebx,%esi
  8019f6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5f                   	pop    %edi
  8019fb:	5d                   	pop    %ebp
  8019fc:	c3                   	ret    

008019fd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	57                   	push   %edi
  801a01:	56                   	push   %esi
  801a02:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a03:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a08:	b8 12 00 00 00       	mov    $0x12,%eax
  801a0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a10:	8b 55 08             	mov    0x8(%ebp),%edx
  801a13:	89 df                	mov    %ebx,%edi
  801a15:	89 de                	mov    %ebx,%esi
  801a17:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801a19:	5b                   	pop    %ebx
  801a1a:	5e                   	pop    %esi
  801a1b:	5f                   	pop    %edi
  801a1c:	5d                   	pop    %ebp
  801a1d:	c3                   	ret    

00801a1e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	57                   	push   %edi
  801a22:	56                   	push   %esi
  801a23:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a29:	b8 13 00 00 00       	mov    $0x13,%eax
  801a2e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a31:	89 cb                	mov    %ecx,%ebx
  801a33:	89 cf                	mov    %ecx,%edi
  801a35:	89 ce                	mov    %ecx,%esi
  801a37:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801a39:	5b                   	pop    %ebx
  801a3a:	5e                   	pop    %esi
  801a3b:	5f                   	pop    %edi
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    

00801a3e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	57                   	push   %edi
  801a42:	56                   	push   %esi
  801a43:	53                   	push   %ebx
  801a44:	83 ec 2c             	sub    $0x2c,%esp
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801a4a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  801a4c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  801a4f:	89 f8                	mov    %edi,%eax
  801a51:	c1 e8 0c             	shr    $0xc,%eax
  801a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801a57:	e8 9b fc ff ff       	call   8016f7 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  801a5c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801a62:	0f 84 de 00 00 00    	je     801b46 <pgfault+0x108>
  801a68:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	79 20                	jns    801a8e <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  801a6e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a72:	c7 44 24 08 52 45 80 	movl   $0x804552,0x8(%esp)
  801a79:	00 
  801a7a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801a81:	00 
  801a82:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801a89:	e8 d9 ef ff ff       	call   800a67 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  801a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a91:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801a98:	25 05 08 00 00       	and    $0x805,%eax
  801a9d:	3d 05 08 00 00       	cmp    $0x805,%eax
  801aa2:	0f 85 ba 00 00 00    	jne    801b62 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801aa8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801aaf:	00 
  801ab0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801ab7:	00 
  801ab8:	89 1c 24             	mov    %ebx,(%esp)
  801abb:	e8 75 fc ff ff       	call   801735 <sys_page_alloc>
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	79 20                	jns    801ae4 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801ac4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac8:	c7 44 24 08 79 45 80 	movl   $0x804579,0x8(%esp)
  801acf:	00 
  801ad0:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801ad7:	00 
  801ad8:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801adf:	e8 83 ef ff ff       	call   800a67 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801ae4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801aea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801af1:	00 
  801af2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801af6:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801afd:	e8 62 f9 ff ff       	call   801464 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801b02:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801b09:	00 
  801b0a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b0e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b12:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801b19:	00 
  801b1a:	89 1c 24             	mov    %ebx,(%esp)
  801b1d:	e8 67 fc ff ff       	call   801789 <sys_page_map>
  801b22:	85 c0                	test   %eax,%eax
  801b24:	79 3c                	jns    801b62 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801b26:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2a:	c7 44 24 08 8c 45 80 	movl   $0x80458c,0x8(%esp)
  801b31:	00 
  801b32:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801b39:	00 
  801b3a:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801b41:	e8 21 ef ff ff       	call   800a67 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801b46:	c7 44 24 08 b0 45 80 	movl   $0x8045b0,0x8(%esp)
  801b4d:	00 
  801b4e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801b55:	00 
  801b56:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801b5d:	e8 05 ef ff ff       	call   800a67 <_panic>
}
  801b62:	83 c4 2c             	add    $0x2c,%esp
  801b65:	5b                   	pop    %ebx
  801b66:	5e                   	pop    %esi
  801b67:	5f                   	pop    %edi
  801b68:	5d                   	pop    %ebp
  801b69:	c3                   	ret    

00801b6a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	56                   	push   %esi
  801b6e:	53                   	push   %ebx
  801b6f:	83 ec 20             	sub    $0x20,%esp
  801b72:	8b 75 08             	mov    0x8(%ebp),%esi
  801b75:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801b78:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801b7f:	00 
  801b80:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b84:	89 34 24             	mov    %esi,(%esp)
  801b87:	e8 a9 fb ff ff       	call   801735 <sys_page_alloc>
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	79 20                	jns    801bb0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801b90:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b94:	c7 44 24 08 79 45 80 	movl   $0x804579,0x8(%esp)
  801b9b:	00 
  801b9c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801ba3:	00 
  801ba4:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801bab:	e8 b7 ee ff ff       	call   800a67 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bb0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801bb7:	00 
  801bb8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801bbf:	00 
  801bc0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bc7:	00 
  801bc8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bcc:	89 34 24             	mov    %esi,(%esp)
  801bcf:	e8 b5 fb ff ff       	call   801789 <sys_page_map>
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	79 20                	jns    801bf8 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801bd8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bdc:	c7 44 24 08 8c 45 80 	movl   $0x80458c,0x8(%esp)
  801be3:	00 
  801be4:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  801beb:	00 
  801bec:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801bf3:	e8 6f ee ff ff       	call   800a67 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801bf8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801bff:	00 
  801c00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c04:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801c0b:	e8 54 f8 ff ff       	call   801464 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c10:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c17:	00 
  801c18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c1f:	e8 b8 fb ff ff       	call   8017dc <sys_page_unmap>
  801c24:	85 c0                	test   %eax,%eax
  801c26:	79 20                	jns    801c48 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801c28:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2c:	c7 44 24 08 9d 45 80 	movl   $0x80459d,0x8(%esp)
  801c33:	00 
  801c34:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c3b:	00 
  801c3c:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801c43:	e8 1f ee ff ff       	call   800a67 <_panic>

}
  801c48:	83 c4 20             	add    $0x20,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    

00801c4f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	57                   	push   %edi
  801c53:	56                   	push   %esi
  801c54:	53                   	push   %ebx
  801c55:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801c58:	c7 04 24 3e 1a 80 00 	movl   $0x801a3e,(%esp)
  801c5f:	e8 b6 1e 00 00       	call   803b1a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801c64:	b8 08 00 00 00       	mov    $0x8,%eax
  801c69:	cd 30                	int    $0x30
  801c6b:	89 c6                	mov    %eax,%esi
  801c6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801c70:	85 c0                	test   %eax,%eax
  801c72:	79 20                	jns    801c94 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801c74:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c78:	c7 44 24 08 d4 45 80 	movl   $0x8045d4,0x8(%esp)
  801c7f:	00 
  801c80:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801c87:	00 
  801c88:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801c8f:	e8 d3 ed ff ff       	call   800a67 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801c94:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	75 21                	jne    801cbe <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  801c9d:	e8 55 fa ff ff       	call   8016f7 <sys_getenvid>
  801ca2:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ca7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801caa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801caf:	a3 28 64 80 00       	mov    %eax,0x806428
		//set_pgfault_handler(pgfault);
		return 0;
  801cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb9:	e9 88 01 00 00       	jmp    801e46 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801cbe:	89 d8                	mov    %ebx,%eax
  801cc0:	c1 e8 16             	shr    $0x16,%eax
  801cc3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801cca:	a8 01                	test   $0x1,%al
  801ccc:	0f 84 e0 00 00 00    	je     801db2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801cd2:	89 df                	mov    %ebx,%edi
  801cd4:	c1 ef 0c             	shr    $0xc,%edi
  801cd7:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  801cde:	a8 01                	test   $0x1,%al
  801ce0:	0f 84 c4 00 00 00    	je     801daa <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801ce6:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  801ced:	f6 c4 04             	test   $0x4,%ah
  801cf0:	74 0d                	je     801cff <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801cf2:	25 07 0e 00 00       	and    $0xe07,%eax
  801cf7:	83 c8 05             	or     $0x5,%eax
  801cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cfd:	eb 1b                	jmp    801d1a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  801cff:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801d04:	83 f8 01             	cmp    $0x1,%eax
  801d07:	19 c0                	sbb    %eax,%eax
  801d09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d0c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801d13:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801d1a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801d1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d20:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d24:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d2f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3a:	e8 4a fa ff ff       	call   801789 <sys_page_map>
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	79 20                	jns    801d63 <fork+0x114>
		panic("sys_page_map: %e", r);
  801d43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d47:	c7 44 24 08 8c 45 80 	movl   $0x80458c,0x8(%esp)
  801d4e:	00 
  801d4f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801d56:	00 
  801d57:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801d5e:	e8 04 ed ff ff       	call   800a67 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d66:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d6a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d6e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d75:	00 
  801d76:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d81:	e8 03 fa ff ff       	call   801789 <sys_page_map>
  801d86:	85 c0                	test   %eax,%eax
  801d88:	79 20                	jns    801daa <fork+0x15b>
		panic("sys_page_map: %e", r);
  801d8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d8e:	c7 44 24 08 8c 45 80 	movl   $0x80458c,0x8(%esp)
  801d95:	00 
  801d96:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  801d9d:	00 
  801d9e:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801da5:	e8 bd ec ff ff       	call   800a67 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801daa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801db0:	eb 06                	jmp    801db8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801db2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801db8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  801dbe:	0f 86 fa fe ff ff    	jbe    801cbe <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801dc4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801dcb:	00 
  801dcc:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801dd3:	ee 
  801dd4:	89 34 24             	mov    %esi,(%esp)
  801dd7:	e8 59 f9 ff ff       	call   801735 <sys_page_alloc>
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	79 20                	jns    801e00 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801de0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801de4:	c7 44 24 08 79 45 80 	movl   $0x804579,0x8(%esp)
  801deb:	00 
  801dec:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801df3:	00 
  801df4:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801dfb:	e8 67 ec ff ff       	call   800a67 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801e00:	c7 44 24 04 ad 3b 80 	movl   $0x803bad,0x4(%esp)
  801e07:	00 
  801e08:	89 34 24             	mov    %esi,(%esp)
  801e0b:	e8 e5 fa ff ff       	call   8018f5 <sys_env_set_pgfault_upcall>
  801e10:	85 c0                	test   %eax,%eax
  801e12:	79 20                	jns    801e34 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801e14:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e18:	c7 44 24 08 f8 45 80 	movl   $0x8045f8,0x8(%esp)
  801e1f:	00 
  801e20:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801e27:	00 
  801e28:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801e2f:	e8 33 ec ff ff       	call   800a67 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801e34:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801e3b:	00 
  801e3c:	89 34 24             	mov    %esi,(%esp)
  801e3f:	e8 0b fa ff ff       	call   80184f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801e44:	89 f0                	mov    %esi,%eax

}
  801e46:	83 c4 2c             	add    $0x2c,%esp
  801e49:	5b                   	pop    %ebx
  801e4a:	5e                   	pop    %esi
  801e4b:	5f                   	pop    %edi
  801e4c:	5d                   	pop    %ebp
  801e4d:	c3                   	ret    

00801e4e <sfork>:

// Challenge!
int
sfork(void)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	53                   	push   %ebx
  801e54:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801e57:	c7 04 24 3e 1a 80 00 	movl   $0x801a3e,(%esp)
  801e5e:	e8 b7 1c 00 00       	call   803b1a <set_pgfault_handler>
  801e63:	b8 08 00 00 00       	mov    $0x8,%eax
  801e68:	cd 30                	int    $0x30
  801e6a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	79 20                	jns    801e90 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801e70:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e74:	c7 44 24 08 d4 45 80 	movl   $0x8045d4,0x8(%esp)
  801e7b:	00 
  801e7c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801e83:	00 
  801e84:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801e8b:	e8 d7 eb ff ff       	call   800a67 <_panic>
  801e90:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801e92:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e97:	85 c0                	test   %eax,%eax
  801e99:	75 2d                	jne    801ec8 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  801e9b:	e8 57 f8 ff ff       	call   8016f7 <sys_getenvid>
  801ea0:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ea5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ea8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ead:	a3 28 64 80 00       	mov    %eax,0x806428
		set_pgfault_handler(pgfault);
  801eb2:	c7 04 24 3e 1a 80 00 	movl   $0x801a3e,(%esp)
  801eb9:	e8 5c 1c 00 00       	call   803b1a <set_pgfault_handler>
		return 0;
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	e9 1d 01 00 00       	jmp    801fe5 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801ec8:	89 d8                	mov    %ebx,%eax
  801eca:	c1 e8 16             	shr    $0x16,%eax
  801ecd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ed4:	a8 01                	test   $0x1,%al
  801ed6:	74 69                	je     801f41 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801ed8:	89 d8                	mov    %ebx,%eax
  801eda:	c1 e8 0c             	shr    $0xc,%eax
  801edd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ee4:	f6 c2 01             	test   $0x1,%dl
  801ee7:	74 50                	je     801f39 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801ee9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801ef0:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801ef3:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801ef9:	89 54 24 10          	mov    %edx,0x10(%esp)
  801efd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f01:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f10:	e8 74 f8 ff ff       	call   801789 <sys_page_map>
  801f15:	85 c0                	test   %eax,%eax
  801f17:	79 20                	jns    801f39 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801f19:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f1d:	c7 44 24 08 8c 45 80 	movl   $0x80458c,0x8(%esp)
  801f24:	00 
  801f25:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801f2c:	00 
  801f2d:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801f34:	e8 2e eb ff ff       	call   800a67 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801f39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f3f:	eb 06                	jmp    801f47 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801f41:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801f47:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  801f4d:	0f 86 75 ff ff ff    	jbe    801ec8 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801f53:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  801f5a:	ee 
  801f5b:	89 34 24             	mov    %esi,(%esp)
  801f5e:	e8 07 fc ff ff       	call   801b6a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801f63:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f6a:	00 
  801f6b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801f72:	ee 
  801f73:	89 34 24             	mov    %esi,(%esp)
  801f76:	e8 ba f7 ff ff       	call   801735 <sys_page_alloc>
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	79 20                	jns    801f9f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  801f7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f83:	c7 44 24 08 79 45 80 	movl   $0x804579,0x8(%esp)
  801f8a:	00 
  801f8b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801f92:	00 
  801f93:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801f9a:	e8 c8 ea ff ff       	call   800a67 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801f9f:	c7 44 24 04 ad 3b 80 	movl   $0x803bad,0x4(%esp)
  801fa6:	00 
  801fa7:	89 34 24             	mov    %esi,(%esp)
  801faa:	e8 46 f9 ff ff       	call   8018f5 <sys_env_set_pgfault_upcall>
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	79 20                	jns    801fd3 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801fb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb7:	c7 44 24 08 f8 45 80 	movl   $0x8045f8,0x8(%esp)
  801fbe:	00 
  801fbf:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801fc6:	00 
  801fc7:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  801fce:	e8 94 ea ff ff       	call   800a67 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801fd3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801fda:	00 
  801fdb:	89 34 24             	mov    %esi,(%esp)
  801fde:	e8 6c f8 ff ff       	call   80184f <sys_env_set_status>
	return envid;
  801fe3:	89 f0                	mov    %esi,%eax

}
  801fe5:	83 c4 2c             	add    $0x2c,%esp
  801fe8:	5b                   	pop    %ebx
  801fe9:	5e                   	pop    %esi
  801fea:	5f                   	pop    %edi
  801feb:	5d                   	pop    %ebp
  801fec:	c3                   	ret    

00801fed <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	53                   	push   %ebx
  801ff1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff7:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801ffa:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  801ffc:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801fff:	bb 00 00 00 00       	mov    $0x0,%ebx
  802004:	83 39 01             	cmpl   $0x1,(%ecx)
  802007:	7e 0f                	jle    802018 <argstart+0x2b>
  802009:	85 d2                	test   %edx,%edx
  80200b:	ba 00 00 00 00       	mov    $0x0,%edx
  802010:	bb e1 3f 80 00       	mov    $0x803fe1,%ebx
  802015:	0f 44 da             	cmove  %edx,%ebx
  802018:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  80201b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  802022:	5b                   	pop    %ebx
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    

00802025 <argnext>:

int
argnext(struct Argstate *args)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	53                   	push   %ebx
  802029:	83 ec 14             	sub    $0x14,%esp
  80202c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  80202f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802036:	8b 43 08             	mov    0x8(%ebx),%eax
  802039:	85 c0                	test   %eax,%eax
  80203b:	74 71                	je     8020ae <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  80203d:	80 38 00             	cmpb   $0x0,(%eax)
  802040:	75 50                	jne    802092 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802042:	8b 0b                	mov    (%ebx),%ecx
  802044:	83 39 01             	cmpl   $0x1,(%ecx)
  802047:	74 57                	je     8020a0 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  802049:	8b 53 04             	mov    0x4(%ebx),%edx
  80204c:	8b 42 04             	mov    0x4(%edx),%eax
  80204f:	80 38 2d             	cmpb   $0x2d,(%eax)
  802052:	75 4c                	jne    8020a0 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  802054:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  802058:	74 46                	je     8020a0 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80205a:	83 c0 01             	add    $0x1,%eax
  80205d:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802060:	8b 01                	mov    (%ecx),%eax
  802062:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  802069:	89 44 24 08          	mov    %eax,0x8(%esp)
  80206d:	8d 42 08             	lea    0x8(%edx),%eax
  802070:	89 44 24 04          	mov    %eax,0x4(%esp)
  802074:	83 c2 04             	add    $0x4,%edx
  802077:	89 14 24             	mov    %edx,(%esp)
  80207a:	e8 e5 f3 ff ff       	call   801464 <memmove>
		(*args->argc)--;
  80207f:	8b 03                	mov    (%ebx),%eax
  802081:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802084:	8b 43 08             	mov    0x8(%ebx),%eax
  802087:	80 38 2d             	cmpb   $0x2d,(%eax)
  80208a:	75 06                	jne    802092 <argnext+0x6d>
  80208c:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  802090:	74 0e                	je     8020a0 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  802092:	8b 53 08             	mov    0x8(%ebx),%edx
  802095:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  802098:	83 c2 01             	add    $0x1,%edx
  80209b:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  80209e:	eb 13                	jmp    8020b3 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  8020a0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8020a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020ac:	eb 05                	jmp    8020b3 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  8020ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8020b3:	83 c4 14             	add    $0x14,%esp
  8020b6:	5b                   	pop    %ebx
  8020b7:	5d                   	pop    %ebp
  8020b8:	c3                   	ret    

008020b9 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	53                   	push   %ebx
  8020bd:	83 ec 14             	sub    $0x14,%esp
  8020c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8020c3:	8b 43 08             	mov    0x8(%ebx),%eax
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	74 5a                	je     802124 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  8020ca:	80 38 00             	cmpb   $0x0,(%eax)
  8020cd:	74 0c                	je     8020db <argnextvalue+0x22>
		args->argvalue = args->curarg;
  8020cf:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8020d2:	c7 43 08 e1 3f 80 00 	movl   $0x803fe1,0x8(%ebx)
  8020d9:	eb 44                	jmp    80211f <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  8020db:	8b 03                	mov    (%ebx),%eax
  8020dd:	83 38 01             	cmpl   $0x1,(%eax)
  8020e0:	7e 2f                	jle    802111 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  8020e2:	8b 53 04             	mov    0x4(%ebx),%edx
  8020e5:	8b 4a 04             	mov    0x4(%edx),%ecx
  8020e8:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8020eb:	8b 00                	mov    (%eax),%eax
  8020ed:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8020f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f8:	8d 42 08             	lea    0x8(%edx),%eax
  8020fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ff:	83 c2 04             	add    $0x4,%edx
  802102:	89 14 24             	mov    %edx,(%esp)
  802105:	e8 5a f3 ff ff       	call   801464 <memmove>
		(*args->argc)--;
  80210a:	8b 03                	mov    (%ebx),%eax
  80210c:	83 28 01             	subl   $0x1,(%eax)
  80210f:	eb 0e                	jmp    80211f <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  802111:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  802118:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  80211f:	8b 43 0c             	mov    0xc(%ebx),%eax
  802122:	eb 05                	jmp    802129 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  802129:	83 c4 14             	add    $0x14,%esp
  80212c:	5b                   	pop    %ebx
  80212d:	5d                   	pop    %ebp
  80212e:	c3                   	ret    

0080212f <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 18             	sub    $0x18,%esp
  802135:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802138:	8b 51 0c             	mov    0xc(%ecx),%edx
  80213b:	89 d0                	mov    %edx,%eax
  80213d:	85 d2                	test   %edx,%edx
  80213f:	75 08                	jne    802149 <argvalue+0x1a>
  802141:	89 0c 24             	mov    %ecx,(%esp)
  802144:	e8 70 ff ff ff       	call   8020b9 <argnextvalue>
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    
  80214b:	66 90                	xchg   %ax,%ax
  80214d:	66 90                	xchg   %ax,%ax
  80214f:	90                   	nop

00802150 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	05 00 00 00 30       	add    $0x30000000,%eax
  80215b:	c1 e8 0c             	shr    $0xc,%eax
}
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    

00802160 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80216b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802170:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802175:	5d                   	pop    %ebp
  802176:	c3                   	ret    

00802177 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80217d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802182:	89 c2                	mov    %eax,%edx
  802184:	c1 ea 16             	shr    $0x16,%edx
  802187:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80218e:	f6 c2 01             	test   $0x1,%dl
  802191:	74 11                	je     8021a4 <fd_alloc+0x2d>
  802193:	89 c2                	mov    %eax,%edx
  802195:	c1 ea 0c             	shr    $0xc,%edx
  802198:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80219f:	f6 c2 01             	test   $0x1,%dl
  8021a2:	75 09                	jne    8021ad <fd_alloc+0x36>
			*fd_store = fd;
  8021a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ab:	eb 17                	jmp    8021c4 <fd_alloc+0x4d>
  8021ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8021b7:	75 c9                	jne    802182 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8021bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    

008021c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021cc:	83 f8 1f             	cmp    $0x1f,%eax
  8021cf:	77 36                	ja     802207 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8021d1:	c1 e0 0c             	shl    $0xc,%eax
  8021d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021d9:	89 c2                	mov    %eax,%edx
  8021db:	c1 ea 16             	shr    $0x16,%edx
  8021de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8021e5:	f6 c2 01             	test   $0x1,%dl
  8021e8:	74 24                	je     80220e <fd_lookup+0x48>
  8021ea:	89 c2                	mov    %eax,%edx
  8021ec:	c1 ea 0c             	shr    $0xc,%edx
  8021ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021f6:	f6 c2 01             	test   $0x1,%dl
  8021f9:	74 1a                	je     802215 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8021fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fe:	89 02                	mov    %eax,(%edx)
	return 0;
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	eb 13                	jmp    80221a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802207:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80220c:	eb 0c                	jmp    80221a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80220e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802213:	eb 05                	jmp    80221a <fd_lookup+0x54>
  802215:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80221a:	5d                   	pop    %ebp
  80221b:	c3                   	ret    

0080221c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 18             	sub    $0x18,%esp
  802222:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802225:	ba 00 00 00 00       	mov    $0x0,%edx
  80222a:	eb 13                	jmp    80223f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80222c:	39 08                	cmp    %ecx,(%eax)
  80222e:	75 0c                	jne    80223c <dev_lookup+0x20>
			*dev = devtab[i];
  802230:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802233:	89 01                	mov    %eax,(%ecx)
			return 0;
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
  80223a:	eb 38                	jmp    802274 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80223c:	83 c2 01             	add    $0x1,%edx
  80223f:	8b 04 95 98 46 80 00 	mov    0x804698(,%edx,4),%eax
  802246:	85 c0                	test   %eax,%eax
  802248:	75 e2                	jne    80222c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80224a:	a1 28 64 80 00       	mov    0x806428,%eax
  80224f:	8b 40 48             	mov    0x48(%eax),%eax
  802252:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802256:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225a:	c7 04 24 1c 46 80 00 	movl   $0x80461c,(%esp)
  802261:	e8 fa e8 ff ff       	call   800b60 <cprintf>
	*dev = 0;
  802266:	8b 45 0c             	mov    0xc(%ebp),%eax
  802269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80226f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	56                   	push   %esi
  80227a:	53                   	push   %ebx
  80227b:	83 ec 20             	sub    $0x20,%esp
  80227e:	8b 75 08             	mov    0x8(%ebp),%esi
  802281:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802284:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802287:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80228b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802291:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802294:	89 04 24             	mov    %eax,(%esp)
  802297:	e8 2a ff ff ff       	call   8021c6 <fd_lookup>
  80229c:	85 c0                	test   %eax,%eax
  80229e:	78 05                	js     8022a5 <fd_close+0x2f>
	    || fd != fd2)
  8022a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8022a3:	74 0c                	je     8022b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8022a5:	84 db                	test   %bl,%bl
  8022a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ac:	0f 44 c2             	cmove  %edx,%eax
  8022af:	eb 3f                	jmp    8022f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b8:	8b 06                	mov    (%esi),%eax
  8022ba:	89 04 24             	mov    %eax,(%esp)
  8022bd:	e8 5a ff ff ff       	call   80221c <dev_lookup>
  8022c2:	89 c3                	mov    %eax,%ebx
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	78 16                	js     8022de <fd_close+0x68>
		if (dev->dev_close)
  8022c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8022ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	74 07                	je     8022de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8022d7:	89 34 24             	mov    %esi,(%esp)
  8022da:	ff d0                	call   *%eax
  8022dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e9:	e8 ee f4 ff ff       	call   8017dc <sys_page_unmap>
	return r;
  8022ee:	89 d8                	mov    %ebx,%eax
}
  8022f0:	83 c4 20             	add    $0x20,%esp
  8022f3:	5b                   	pop    %ebx
  8022f4:	5e                   	pop    %esi
  8022f5:	5d                   	pop    %ebp
  8022f6:	c3                   	ret    

008022f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802300:	89 44 24 04          	mov    %eax,0x4(%esp)
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	89 04 24             	mov    %eax,(%esp)
  80230a:	e8 b7 fe ff ff       	call   8021c6 <fd_lookup>
  80230f:	89 c2                	mov    %eax,%edx
  802311:	85 d2                	test   %edx,%edx
  802313:	78 13                	js     802328 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  802315:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80231c:	00 
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	89 04 24             	mov    %eax,(%esp)
  802323:	e8 4e ff ff ff       	call   802276 <fd_close>
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <close_all>:

void
close_all(void)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	53                   	push   %ebx
  80232e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802331:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802336:	89 1c 24             	mov    %ebx,(%esp)
  802339:	e8 b9 ff ff ff       	call   8022f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80233e:	83 c3 01             	add    $0x1,%ebx
  802341:	83 fb 20             	cmp    $0x20,%ebx
  802344:	75 f0                	jne    802336 <close_all+0xc>
		close(i);
}
  802346:	83 c4 14             	add    $0x14,%esp
  802349:	5b                   	pop    %ebx
  80234a:	5d                   	pop    %ebp
  80234b:	c3                   	ret    

0080234c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	57                   	push   %edi
  802350:	56                   	push   %esi
  802351:	53                   	push   %ebx
  802352:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802355:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	89 04 24             	mov    %eax,(%esp)
  802362:	e8 5f fe ff ff       	call   8021c6 <fd_lookup>
  802367:	89 c2                	mov    %eax,%edx
  802369:	85 d2                	test   %edx,%edx
  80236b:	0f 88 e1 00 00 00    	js     802452 <dup+0x106>
		return r;
	close(newfdnum);
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	89 04 24             	mov    %eax,(%esp)
  802377:	e8 7b ff ff ff       	call   8022f7 <close>

	newfd = INDEX2FD(newfdnum);
  80237c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80237f:	c1 e3 0c             	shl    $0xc,%ebx
  802382:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238b:	89 04 24             	mov    %eax,(%esp)
  80238e:	e8 cd fd ff ff       	call   802160 <fd2data>
  802393:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  802395:	89 1c 24             	mov    %ebx,(%esp)
  802398:	e8 c3 fd ff ff       	call   802160 <fd2data>
  80239d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80239f:	89 f0                	mov    %esi,%eax
  8023a1:	c1 e8 16             	shr    $0x16,%eax
  8023a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8023ab:	a8 01                	test   $0x1,%al
  8023ad:	74 43                	je     8023f2 <dup+0xa6>
  8023af:	89 f0                	mov    %esi,%eax
  8023b1:	c1 e8 0c             	shr    $0xc,%eax
  8023b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8023bb:	f6 c2 01             	test   $0x1,%dl
  8023be:	74 32                	je     8023f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8023c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8023cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8023d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023db:	00 
  8023dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e7:	e8 9d f3 ff ff       	call   801789 <sys_page_map>
  8023ec:	89 c6                	mov    %eax,%esi
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	78 3e                	js     802430 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8023f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f5:	89 c2                	mov    %eax,%edx
  8023f7:	c1 ea 0c             	shr    $0xc,%edx
  8023fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802401:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802407:	89 54 24 10          	mov    %edx,0x10(%esp)
  80240b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80240f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802416:	00 
  802417:	89 44 24 04          	mov    %eax,0x4(%esp)
  80241b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802422:	e8 62 f3 ff ff       	call   801789 <sys_page_map>
  802427:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  802429:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80242c:	85 f6                	test   %esi,%esi
  80242e:	79 22                	jns    802452 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802430:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802434:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80243b:	e8 9c f3 ff ff       	call   8017dc <sys_page_unmap>
	sys_page_unmap(0, nva);
  802440:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802444:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80244b:	e8 8c f3 ff ff       	call   8017dc <sys_page_unmap>
	return r;
  802450:	89 f0                	mov    %esi,%eax
}
  802452:	83 c4 3c             	add    $0x3c,%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	53                   	push   %ebx
  80245e:	83 ec 24             	sub    $0x24,%esp
  802461:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802464:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246b:	89 1c 24             	mov    %ebx,(%esp)
  80246e:	e8 53 fd ff ff       	call   8021c6 <fd_lookup>
  802473:	89 c2                	mov    %eax,%edx
  802475:	85 d2                	test   %edx,%edx
  802477:	78 6d                	js     8024e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802479:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80247c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802483:	8b 00                	mov    (%eax),%eax
  802485:	89 04 24             	mov    %eax,(%esp)
  802488:	e8 8f fd ff ff       	call   80221c <dev_lookup>
  80248d:	85 c0                	test   %eax,%eax
  80248f:	78 55                	js     8024e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802494:	8b 50 08             	mov    0x8(%eax),%edx
  802497:	83 e2 03             	and    $0x3,%edx
  80249a:	83 fa 01             	cmp    $0x1,%edx
  80249d:	75 23                	jne    8024c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80249f:	a1 28 64 80 00       	mov    0x806428,%eax
  8024a4:	8b 40 48             	mov    0x48(%eax),%eax
  8024a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024af:	c7 04 24 5d 46 80 00 	movl   $0x80465d,(%esp)
  8024b6:	e8 a5 e6 ff ff       	call   800b60 <cprintf>
		return -E_INVAL;
  8024bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c0:	eb 24                	jmp    8024e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	8b 52 08             	mov    0x8(%edx),%edx
  8024c8:	85 d2                	test   %edx,%edx
  8024ca:	74 15                	je     8024e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8024cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024da:	89 04 24             	mov    %eax,(%esp)
  8024dd:	ff d2                	call   *%edx
  8024df:	eb 05                	jmp    8024e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8024e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8024e6:	83 c4 24             	add    $0x24,%esp
  8024e9:	5b                   	pop    %ebx
  8024ea:	5d                   	pop    %ebp
  8024eb:	c3                   	ret    

008024ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	57                   	push   %edi
  8024f0:	56                   	push   %esi
  8024f1:	53                   	push   %ebx
  8024f2:	83 ec 1c             	sub    $0x1c,%esp
  8024f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802500:	eb 23                	jmp    802525 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802502:	89 f0                	mov    %esi,%eax
  802504:	29 d8                	sub    %ebx,%eax
  802506:	89 44 24 08          	mov    %eax,0x8(%esp)
  80250a:	89 d8                	mov    %ebx,%eax
  80250c:	03 45 0c             	add    0xc(%ebp),%eax
  80250f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802513:	89 3c 24             	mov    %edi,(%esp)
  802516:	e8 3f ff ff ff       	call   80245a <read>
		if (m < 0)
  80251b:	85 c0                	test   %eax,%eax
  80251d:	78 10                	js     80252f <readn+0x43>
			return m;
		if (m == 0)
  80251f:	85 c0                	test   %eax,%eax
  802521:	74 0a                	je     80252d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802523:	01 c3                	add    %eax,%ebx
  802525:	39 f3                	cmp    %esi,%ebx
  802527:	72 d9                	jb     802502 <readn+0x16>
  802529:	89 d8                	mov    %ebx,%eax
  80252b:	eb 02                	jmp    80252f <readn+0x43>
  80252d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80252f:	83 c4 1c             	add    $0x1c,%esp
  802532:	5b                   	pop    %ebx
  802533:	5e                   	pop    %esi
  802534:	5f                   	pop    %edi
  802535:	5d                   	pop    %ebp
  802536:	c3                   	ret    

00802537 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	53                   	push   %ebx
  80253b:	83 ec 24             	sub    $0x24,%esp
  80253e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802541:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802544:	89 44 24 04          	mov    %eax,0x4(%esp)
  802548:	89 1c 24             	mov    %ebx,(%esp)
  80254b:	e8 76 fc ff ff       	call   8021c6 <fd_lookup>
  802550:	89 c2                	mov    %eax,%edx
  802552:	85 d2                	test   %edx,%edx
  802554:	78 68                	js     8025be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802556:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802559:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	89 04 24             	mov    %eax,(%esp)
  802565:	e8 b2 fc ff ff       	call   80221c <dev_lookup>
  80256a:	85 c0                	test   %eax,%eax
  80256c:	78 50                	js     8025be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80256e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802571:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802575:	75 23                	jne    80259a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802577:	a1 28 64 80 00       	mov    0x806428,%eax
  80257c:	8b 40 48             	mov    0x48(%eax),%eax
  80257f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802583:	89 44 24 04          	mov    %eax,0x4(%esp)
  802587:	c7 04 24 79 46 80 00 	movl   $0x804679,(%esp)
  80258e:	e8 cd e5 ff ff       	call   800b60 <cprintf>
		return -E_INVAL;
  802593:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802598:	eb 24                	jmp    8025be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80259a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259d:	8b 52 0c             	mov    0xc(%edx),%edx
  8025a0:	85 d2                	test   %edx,%edx
  8025a2:	74 15                	je     8025b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8025a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025b2:	89 04 24             	mov    %eax,(%esp)
  8025b5:	ff d2                	call   *%edx
  8025b7:	eb 05                	jmp    8025be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8025b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8025be:	83 c4 24             	add    $0x24,%esp
  8025c1:	5b                   	pop    %ebx
  8025c2:	5d                   	pop    %ebp
  8025c3:	c3                   	ret    

008025c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8025cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	89 04 24             	mov    %eax,(%esp)
  8025d7:	e8 ea fb ff ff       	call   8021c6 <fd_lookup>
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	78 0e                	js     8025ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8025e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8025e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	53                   	push   %ebx
  8025f4:	83 ec 24             	sub    $0x24,%esp
  8025f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802601:	89 1c 24             	mov    %ebx,(%esp)
  802604:	e8 bd fb ff ff       	call   8021c6 <fd_lookup>
  802609:	89 c2                	mov    %eax,%edx
  80260b:	85 d2                	test   %edx,%edx
  80260d:	78 61                	js     802670 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80260f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802612:	89 44 24 04          	mov    %eax,0x4(%esp)
  802616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	89 04 24             	mov    %eax,(%esp)
  80261e:	e8 f9 fb ff ff       	call   80221c <dev_lookup>
  802623:	85 c0                	test   %eax,%eax
  802625:	78 49                	js     802670 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80262e:	75 23                	jne    802653 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802630:	a1 28 64 80 00       	mov    0x806428,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802635:	8b 40 48             	mov    0x48(%eax),%eax
  802638:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80263c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802640:	c7 04 24 3c 46 80 00 	movl   $0x80463c,(%esp)
  802647:	e8 14 e5 ff ff       	call   800b60 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80264c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802651:	eb 1d                	jmp    802670 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  802653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802656:	8b 52 18             	mov    0x18(%edx),%edx
  802659:	85 d2                	test   %edx,%edx
  80265b:	74 0e                	je     80266b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80265d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802660:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802664:	89 04 24             	mov    %eax,(%esp)
  802667:	ff d2                	call   *%edx
  802669:	eb 05                	jmp    802670 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80266b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  802670:	83 c4 24             	add    $0x24,%esp
  802673:	5b                   	pop    %ebx
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    

00802676 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	53                   	push   %ebx
  80267a:	83 ec 24             	sub    $0x24,%esp
  80267d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802680:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802683:	89 44 24 04          	mov    %eax,0x4(%esp)
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	89 04 24             	mov    %eax,(%esp)
  80268d:	e8 34 fb ff ff       	call   8021c6 <fd_lookup>
  802692:	89 c2                	mov    %eax,%edx
  802694:	85 d2                	test   %edx,%edx
  802696:	78 52                	js     8026ea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802698:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80269b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	89 04 24             	mov    %eax,(%esp)
  8026a7:	e8 70 fb ff ff       	call   80221c <dev_lookup>
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	78 3a                	js     8026ea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8026b7:	74 2c                	je     8026e5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8026b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8026bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8026c3:	00 00 00 
	stat->st_isdir = 0;
  8026c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026cd:	00 00 00 
	stat->st_dev = dev;
  8026d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8026d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026dd:	89 14 24             	mov    %edx,(%esp)
  8026e0:	ff 50 14             	call   *0x14(%eax)
  8026e3:	eb 05                	jmp    8026ea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8026e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8026ea:	83 c4 24             	add    $0x24,%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5d                   	pop    %ebp
  8026ef:	c3                   	ret    

008026f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
  8026f3:	56                   	push   %esi
  8026f4:	53                   	push   %ebx
  8026f5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8026ff:	00 
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	89 04 24             	mov    %eax,(%esp)
  802706:	e8 99 02 00 00       	call   8029a4 <open>
  80270b:	89 c3                	mov    %eax,%ebx
  80270d:	85 db                	test   %ebx,%ebx
  80270f:	78 1b                	js     80272c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  802711:	8b 45 0c             	mov    0xc(%ebp),%eax
  802714:	89 44 24 04          	mov    %eax,0x4(%esp)
  802718:	89 1c 24             	mov    %ebx,(%esp)
  80271b:	e8 56 ff ff ff       	call   802676 <fstat>
  802720:	89 c6                	mov    %eax,%esi
	close(fd);
  802722:	89 1c 24             	mov    %ebx,(%esp)
  802725:	e8 cd fb ff ff       	call   8022f7 <close>
	return r;
  80272a:	89 f0                	mov    %esi,%eax
}
  80272c:	83 c4 10             	add    $0x10,%esp
  80272f:	5b                   	pop    %ebx
  802730:	5e                   	pop    %esi
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    

00802733 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
  802736:	56                   	push   %esi
  802737:	53                   	push   %ebx
  802738:	83 ec 10             	sub    $0x10,%esp
  80273b:	89 c6                	mov    %eax,%esi
  80273d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80273f:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802746:	75 11                	jne    802759 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802748:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80274f:	e8 5b 15 00 00       	call   803caf <ipc_find_env>
  802754:	a3 20 64 80 00       	mov    %eax,0x806420
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802759:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802760:	00 
  802761:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802768:	00 
  802769:	89 74 24 04          	mov    %esi,0x4(%esp)
  80276d:	a1 20 64 80 00       	mov    0x806420,%eax
  802772:	89 04 24             	mov    %eax,(%esp)
  802775:	e8 ce 14 00 00       	call   803c48 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80277a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802781:	00 
  802782:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802786:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80278d:	e8 4e 14 00 00       	call   803be0 <ipc_recv>
}
  802792:	83 c4 10             	add    $0x10,%esp
  802795:	5b                   	pop    %ebx
  802796:	5e                   	pop    %esi
  802797:	5d                   	pop    %ebp
  802798:	c3                   	ret    

00802799 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a5:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8027aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ad:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8027b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8027bc:	e8 72 ff ff ff       	call   802733 <fsipc>
}
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    

008027c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cf:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8027d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8027de:	e8 50 ff ff ff       	call   802733 <fsipc>
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	53                   	push   %ebx
  8027e9:	83 ec 14             	sub    $0x14,%esp
  8027ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f5:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8027fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ff:	b8 05 00 00 00       	mov    $0x5,%eax
  802804:	e8 2a ff ff ff       	call   802733 <fsipc>
  802809:	89 c2                	mov    %eax,%edx
  80280b:	85 d2                	test   %edx,%edx
  80280d:	78 2b                	js     80283a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80280f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802816:	00 
  802817:	89 1c 24             	mov    %ebx,(%esp)
  80281a:	e8 a8 ea ff ff       	call   8012c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80281f:	a1 80 70 80 00       	mov    0x807080,%eax
  802824:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80282a:	a1 84 70 80 00       	mov    0x807084,%eax
  80282f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283a:	83 c4 14             	add    $0x14,%esp
  80283d:	5b                   	pop    %ebx
  80283e:	5d                   	pop    %ebp
  80283f:	c3                   	ret    

00802840 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	53                   	push   %ebx
  802844:	83 ec 14             	sub    $0x14,%esp
  802847:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80284a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  802850:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  802855:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802858:	8b 55 08             	mov    0x8(%ebp),%edx
  80285b:	8b 52 0c             	mov    0xc(%edx),%edx
  80285e:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = count;
  802864:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, count);
  802869:	89 44 24 08          	mov    %eax,0x8(%esp)
  80286d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802870:	89 44 24 04          	mov    %eax,0x4(%esp)
  802874:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  80287b:	e8 e4 eb ff ff       	call   801464 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  802880:	c7 44 24 04 08 70 80 	movl   $0x807008,0x4(%esp)
  802887:	00 
  802888:	c7 04 24 ac 46 80 00 	movl   $0x8046ac,(%esp)
  80288f:	e8 cc e2 ff ff       	call   800b60 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802894:	ba 00 00 00 00       	mov    $0x0,%edx
  802899:	b8 04 00 00 00       	mov    $0x4,%eax
  80289e:	e8 90 fe ff ff       	call   802733 <fsipc>
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	78 53                	js     8028fa <devfile_write+0xba>
		return r;
	assert(r <= n);
  8028a7:	39 c3                	cmp    %eax,%ebx
  8028a9:	73 24                	jae    8028cf <devfile_write+0x8f>
  8028ab:	c7 44 24 0c b1 46 80 	movl   $0x8046b1,0xc(%esp)
  8028b2:	00 
  8028b3:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  8028ba:	00 
  8028bb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8028c2:	00 
  8028c3:	c7 04 24 b8 46 80 00 	movl   $0x8046b8,(%esp)
  8028ca:	e8 98 e1 ff ff       	call   800a67 <_panic>
	assert(r <= PGSIZE);
  8028cf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8028d4:	7e 24                	jle    8028fa <devfile_write+0xba>
  8028d6:	c7 44 24 0c c3 46 80 	movl   $0x8046c3,0xc(%esp)
  8028dd:	00 
  8028de:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  8028e5:	00 
  8028e6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8028ed:	00 
  8028ee:	c7 04 24 b8 46 80 00 	movl   $0x8046b8,(%esp)
  8028f5:	e8 6d e1 ff ff       	call   800a67 <_panic>
	return r;
}
  8028fa:	83 c4 14             	add    $0x14,%esp
  8028fd:	5b                   	pop    %ebx
  8028fe:	5d                   	pop    %ebp
  8028ff:	c3                   	ret    

00802900 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	56                   	push   %esi
  802904:	53                   	push   %ebx
  802905:	83 ec 10             	sub    $0x10,%esp
  802908:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	8b 40 0c             	mov    0xc(%eax),%eax
  802911:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802916:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80291c:	ba 00 00 00 00       	mov    $0x0,%edx
  802921:	b8 03 00 00 00       	mov    $0x3,%eax
  802926:	e8 08 fe ff ff       	call   802733 <fsipc>
  80292b:	89 c3                	mov    %eax,%ebx
  80292d:	85 c0                	test   %eax,%eax
  80292f:	78 6a                	js     80299b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802931:	39 c6                	cmp    %eax,%esi
  802933:	73 24                	jae    802959 <devfile_read+0x59>
  802935:	c7 44 24 0c b1 46 80 	movl   $0x8046b1,0xc(%esp)
  80293c:	00 
  80293d:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  802944:	00 
  802945:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80294c:	00 
  80294d:	c7 04 24 b8 46 80 00 	movl   $0x8046b8,(%esp)
  802954:	e8 0e e1 ff ff       	call   800a67 <_panic>
	assert(r <= PGSIZE);
  802959:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80295e:	7e 24                	jle    802984 <devfile_read+0x84>
  802960:	c7 44 24 0c c3 46 80 	movl   $0x8046c3,0xc(%esp)
  802967:	00 
  802968:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  80296f:	00 
  802970:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802977:	00 
  802978:	c7 04 24 b8 46 80 00 	movl   $0x8046b8,(%esp)
  80297f:	e8 e3 e0 ff ff       	call   800a67 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802984:	89 44 24 08          	mov    %eax,0x8(%esp)
  802988:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80298f:	00 
  802990:	8b 45 0c             	mov    0xc(%ebp),%eax
  802993:	89 04 24             	mov    %eax,(%esp)
  802996:	e8 c9 ea ff ff       	call   801464 <memmove>
	return r;
}
  80299b:	89 d8                	mov    %ebx,%eax
  80299d:	83 c4 10             	add    $0x10,%esp
  8029a0:	5b                   	pop    %ebx
  8029a1:	5e                   	pop    %esi
  8029a2:	5d                   	pop    %ebp
  8029a3:	c3                   	ret    

008029a4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8029a4:	55                   	push   %ebp
  8029a5:	89 e5                	mov    %esp,%ebp
  8029a7:	53                   	push   %ebx
  8029a8:	83 ec 24             	sub    $0x24,%esp
  8029ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8029ae:	89 1c 24             	mov    %ebx,(%esp)
  8029b1:	e8 da e8 ff ff       	call   801290 <strlen>
  8029b6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029bb:	7f 60                	jg     802a1d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8029bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029c0:	89 04 24             	mov    %eax,(%esp)
  8029c3:	e8 af f7 ff ff       	call   802177 <fd_alloc>
  8029c8:	89 c2                	mov    %eax,%edx
  8029ca:	85 d2                	test   %edx,%edx
  8029cc:	78 54                	js     802a22 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8029ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8029d2:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8029d9:	e8 e9 e8 ff ff       	call   8012c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8029de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e1:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8029e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ee:	e8 40 fd ff ff       	call   802733 <fsipc>
  8029f3:	89 c3                	mov    %eax,%ebx
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	79 17                	jns    802a10 <open+0x6c>
		fd_close(fd, 0);
  8029f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a00:	00 
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	89 04 24             	mov    %eax,(%esp)
  802a07:	e8 6a f8 ff ff       	call   802276 <fd_close>
		return r;
  802a0c:	89 d8                	mov    %ebx,%eax
  802a0e:	eb 12                	jmp    802a22 <open+0x7e>
	}

	return fd2num(fd);
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	89 04 24             	mov    %eax,(%esp)
  802a16:	e8 35 f7 ff ff       	call   802150 <fd2num>
  802a1b:	eb 05                	jmp    802a22 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  802a1d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802a22:	83 c4 24             	add    $0x24,%esp
  802a25:	5b                   	pop    %ebx
  802a26:	5d                   	pop    %ebp
  802a27:	c3                   	ret    

00802a28 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
  802a2b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  802a33:	b8 08 00 00 00       	mov    $0x8,%eax
  802a38:	e8 f6 fc ff ff       	call   802733 <fsipc>
}
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    

00802a3f <evict>:

int evict(void)
{
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
  802a42:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802a45:	c7 04 24 cf 46 80 00 	movl   $0x8046cf,(%esp)
  802a4c:	e8 0f e1 ff ff       	call   800b60 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802a51:	ba 00 00 00 00       	mov    $0x0,%edx
  802a56:	b8 09 00 00 00       	mov    $0x9,%eax
  802a5b:	e8 d3 fc ff ff       	call   802733 <fsipc>
}
  802a60:	c9                   	leave  
  802a61:	c3                   	ret    

00802a62 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802a62:	55                   	push   %ebp
  802a63:	89 e5                	mov    %esp,%ebp
  802a65:	53                   	push   %ebx
  802a66:	83 ec 14             	sub    $0x14,%esp
  802a69:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  802a6b:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802a6f:	7e 31                	jle    802aa2 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802a71:	8b 40 04             	mov    0x4(%eax),%eax
  802a74:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a78:	8d 43 10             	lea    0x10(%ebx),%eax
  802a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a7f:	8b 03                	mov    (%ebx),%eax
  802a81:	89 04 24             	mov    %eax,(%esp)
  802a84:	e8 ae fa ff ff       	call   802537 <write>
		if (result > 0)
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	7e 03                	jle    802a90 <writebuf+0x2e>
			b->result += result;
  802a8d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802a90:	39 43 04             	cmp    %eax,0x4(%ebx)
  802a93:	74 0d                	je     802aa2 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  802a95:	85 c0                	test   %eax,%eax
  802a97:	ba 00 00 00 00       	mov    $0x0,%edx
  802a9c:	0f 4f c2             	cmovg  %edx,%eax
  802a9f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802aa2:	83 c4 14             	add    $0x14,%esp
  802aa5:	5b                   	pop    %ebx
  802aa6:	5d                   	pop    %ebp
  802aa7:	c3                   	ret    

00802aa8 <putch>:

static void
putch(int ch, void *thunk)
{
  802aa8:	55                   	push   %ebp
  802aa9:	89 e5                	mov    %esp,%ebp
  802aab:	53                   	push   %ebx
  802aac:	83 ec 04             	sub    $0x4,%esp
  802aaf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  802ab2:	8b 53 04             	mov    0x4(%ebx),%edx
  802ab5:	8d 42 01             	lea    0x1(%edx),%eax
  802ab8:	89 43 04             	mov    %eax,0x4(%ebx)
  802abb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802abe:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  802ac2:	3d 00 01 00 00       	cmp    $0x100,%eax
  802ac7:	75 0e                	jne    802ad7 <putch+0x2f>
		writebuf(b);
  802ac9:	89 d8                	mov    %ebx,%eax
  802acb:	e8 92 ff ff ff       	call   802a62 <writebuf>
		b->idx = 0;
  802ad0:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  802ad7:	83 c4 04             	add    $0x4,%esp
  802ada:	5b                   	pop    %ebx
  802adb:	5d                   	pop    %ebp
  802adc:	c3                   	ret    

00802add <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802add:	55                   	push   %ebp
  802ade:	89 e5                	mov    %esp,%ebp
  802ae0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802aef:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802af6:	00 00 00 
	b.result = 0;
  802af9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802b00:	00 00 00 
	b.error = 1;
  802b03:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802b0a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  802b10:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b17:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b1b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b25:	c7 04 24 a8 2a 80 00 	movl   $0x802aa8,(%esp)
  802b2c:	e8 83 e1 ff ff       	call   800cb4 <vprintfmt>
	if (b.idx > 0)
  802b31:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802b38:	7e 0b                	jle    802b45 <vfprintf+0x68>
		writebuf(&b);
  802b3a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802b40:	e8 1d ff ff ff       	call   802a62 <writebuf>

	return (b.result ? b.result : b.error);
  802b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802b54:	c9                   	leave  
  802b55:	c3                   	ret    

00802b56 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
  802b59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802b5c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802b5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	89 04 24             	mov    %eax,(%esp)
  802b70:	e8 68 ff ff ff       	call   802add <vfprintf>
	va_end(ap);

	return cnt;
}
  802b75:	c9                   	leave  
  802b76:	c3                   	ret    

00802b77 <printf>:

int
printf(const char *fmt, ...)
{
  802b77:	55                   	push   %ebp
  802b78:	89 e5                	mov    %esp,%ebp
  802b7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802b7d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802b80:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802b92:	e8 46 ff ff ff       	call   802add <vfprintf>
	va_end(ap);

	return cnt;
}
  802b97:	c9                   	leave  
  802b98:	c3                   	ret    
  802b99:	66 90                	xchg   %ax,%ax
  802b9b:	66 90                	xchg   %ax,%ax
  802b9d:	66 90                	xchg   %ax,%ax
  802b9f:	90                   	nop

00802ba0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	57                   	push   %edi
  802ba4:	56                   	push   %esi
  802ba5:	53                   	push   %ebx
  802ba6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802bac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802bb3:	00 
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	89 04 24             	mov    %eax,(%esp)
  802bba:	e8 e5 fd ff ff       	call   8029a4 <open>
  802bbf:	89 c1                	mov    %eax,%ecx
  802bc1:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	0f 88 41 05 00 00    	js     803110 <spawn+0x570>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802bcf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802bd6:	00 
  802bd7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be1:	89 0c 24             	mov    %ecx,(%esp)
  802be4:	e8 03 f9 ff ff       	call   8024ec <readn>
  802be9:	3d 00 02 00 00       	cmp    $0x200,%eax
  802bee:	75 0c                	jne    802bfc <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802bf0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802bf7:	45 4c 46 
  802bfa:	74 36                	je     802c32 <spawn+0x92>
		close(fd);
  802bfc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802c02:	89 04 24             	mov    %eax,(%esp)
  802c05:	e8 ed f6 ff ff       	call   8022f7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802c0a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802c11:	46 
  802c12:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c1c:	c7 04 24 e8 46 80 00 	movl   $0x8046e8,(%esp)
  802c23:	e8 38 df ff ff       	call   800b60 <cprintf>
		return -E_NOT_EXEC;
  802c28:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802c2d:	e9 3d 05 00 00       	jmp    80316f <spawn+0x5cf>
  802c32:	b8 08 00 00 00       	mov    $0x8,%eax
  802c37:	cd 30                	int    $0x30
  802c39:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802c3f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802c45:	85 c0                	test   %eax,%eax
  802c47:	0f 88 cb 04 00 00    	js     803118 <spawn+0x578>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802c4d:	89 c6                	mov    %eax,%esi
  802c4f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802c55:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802c58:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802c5e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802c64:	b9 11 00 00 00       	mov    $0x11,%ecx
  802c69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802c6b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802c71:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802c77:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802c7c:	be 00 00 00 00       	mov    $0x0,%esi
  802c81:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c84:	eb 0f                	jmp    802c95 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802c86:	89 04 24             	mov    %eax,(%esp)
  802c89:	e8 02 e6 ff ff       	call   801290 <strlen>
  802c8e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802c92:	83 c3 01             	add    $0x1,%ebx
  802c95:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802c9c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	75 e3                	jne    802c86 <spawn+0xe6>
  802ca3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802ca9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802caf:	bf 00 10 40 00       	mov    $0x401000,%edi
  802cb4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802cb6:	89 fa                	mov    %edi,%edx
  802cb8:	83 e2 fc             	and    $0xfffffffc,%edx
  802cbb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802cc2:	29 c2                	sub    %eax,%edx
  802cc4:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802cca:	8d 42 f8             	lea    -0x8(%edx),%eax
  802ccd:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802cd2:	0f 86 50 04 00 00    	jbe    803128 <spawn+0x588>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802cd8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802cdf:	00 
  802ce0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ce7:	00 
  802ce8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cef:	e8 41 ea ff ff       	call   801735 <sys_page_alloc>
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	0f 88 73 04 00 00    	js     80316f <spawn+0x5cf>
  802cfc:	be 00 00 00 00       	mov    $0x0,%esi
  802d01:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802d07:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802d0a:	eb 30                	jmp    802d3c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  802d0c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802d12:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802d18:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  802d1b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d22:	89 3c 24             	mov    %edi,(%esp)
  802d25:	e8 9d e5 ff ff       	call   8012c7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802d2a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802d2d:	89 04 24             	mov    %eax,(%esp)
  802d30:	e8 5b e5 ff ff       	call   801290 <strlen>
  802d35:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802d39:	83 c6 01             	add    $0x1,%esi
  802d3c:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  802d42:	7c c8                	jl     802d0c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802d44:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802d4a:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802d50:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802d57:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802d5d:	74 24                	je     802d83 <spawn+0x1e3>
  802d5f:	c7 44 24 0c 6c 47 80 	movl   $0x80476c,0xc(%esp)
  802d66:	00 
  802d67:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  802d6e:	00 
  802d6f:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  802d76:	00 
  802d77:	c7 04 24 02 47 80 00 	movl   $0x804702,(%esp)
  802d7e:	e8 e4 dc ff ff       	call   800a67 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802d83:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802d89:	89 c8                	mov    %ecx,%eax
  802d8b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802d90:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802d93:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802d99:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802d9c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802da2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802da8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802daf:	00 
  802db0:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802db7:	ee 
  802db8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802dbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dc2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802dc9:	00 
  802dca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dd1:	e8 b3 e9 ff ff       	call   801789 <sys_page_map>
  802dd6:	89 c3                	mov    %eax,%ebx
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	0f 88 79 03 00 00    	js     803159 <spawn+0x5b9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802de0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802de7:	00 
  802de8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802def:	e8 e8 e9 ff ff       	call   8017dc <sys_page_unmap>
  802df4:	89 c3                	mov    %eax,%ebx
  802df6:	85 c0                	test   %eax,%eax
  802df8:	0f 88 5b 03 00 00    	js     803159 <spawn+0x5b9>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802dfe:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802e04:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802e0b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e11:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802e18:	00 00 00 
  802e1b:	e9 b6 01 00 00       	jmp    802fd6 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  802e20:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802e26:	83 38 01             	cmpl   $0x1,(%eax)
  802e29:	0f 85 99 01 00 00    	jne    802fc8 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802e2f:	89 c2                	mov    %eax,%edx
  802e31:	8b 40 18             	mov    0x18(%eax),%eax
  802e34:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802e37:	83 f8 01             	cmp    $0x1,%eax
  802e3a:	19 c0                	sbb    %eax,%eax
  802e3c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802e42:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  802e49:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e50:	89 d0                	mov    %edx,%eax
  802e52:	8b 4a 04             	mov    0x4(%edx),%ecx
  802e55:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802e5b:	8b 52 10             	mov    0x10(%edx),%edx
  802e5e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  802e64:	8b 48 14             	mov    0x14(%eax),%ecx
  802e67:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  802e6d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802e70:	89 f0                	mov    %esi,%eax
  802e72:	25 ff 0f 00 00       	and    $0xfff,%eax
  802e77:	74 14                	je     802e8d <spawn+0x2ed>
		va -= i;
  802e79:	29 c6                	sub    %eax,%esi
		memsz += i;
  802e7b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802e81:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  802e87:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802e8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e92:	e9 23 01 00 00       	jmp    802fba <spawn+0x41a>
		if (i >= filesz) {
  802e97:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  802e9d:	77 2b                	ja     802eca <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802e9f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802ea5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ea9:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ead:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802eb3:	89 04 24             	mov    %eax,(%esp)
  802eb6:	e8 7a e8 ff ff       	call   801735 <sys_page_alloc>
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	0f 89 eb 00 00 00    	jns    802fae <spawn+0x40e>
  802ec3:	89 c3                	mov    %eax,%ebx
  802ec5:	e9 6f 02 00 00       	jmp    803139 <spawn+0x599>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802eca:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ed1:	00 
  802ed2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ed9:	00 
  802eda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ee1:	e8 4f e8 ff ff       	call   801735 <sys_page_alloc>
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	0f 88 41 02 00 00    	js     80312f <spawn+0x58f>
  802eee:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802ef4:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802efa:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802f00:	89 04 24             	mov    %eax,(%esp)
  802f03:	e8 bc f6 ff ff       	call   8025c4 <seek>
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	0f 88 23 02 00 00    	js     803133 <spawn+0x593>
  802f10:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802f16:	29 f9                	sub    %edi,%ecx
  802f18:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802f1a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802f20:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f25:	0f 47 c2             	cmova  %edx,%eax
  802f28:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f2c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802f33:	00 
  802f34:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802f3a:	89 04 24             	mov    %eax,(%esp)
  802f3d:	e8 aa f5 ff ff       	call   8024ec <readn>
  802f42:	85 c0                	test   %eax,%eax
  802f44:	0f 88 ed 01 00 00    	js     803137 <spawn+0x597>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802f4a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802f50:	89 44 24 10          	mov    %eax,0x10(%esp)
  802f54:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802f58:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802f5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f62:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802f69:	00 
  802f6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f71:	e8 13 e8 ff ff       	call   801789 <sys_page_map>
  802f76:	85 c0                	test   %eax,%eax
  802f78:	79 20                	jns    802f9a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  802f7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f7e:	c7 44 24 08 0e 47 80 	movl   $0x80470e,0x8(%esp)
  802f85:	00 
  802f86:	c7 44 24 04 a8 01 00 	movl   $0x1a8,0x4(%esp)
  802f8d:	00 
  802f8e:	c7 04 24 02 47 80 00 	movl   $0x804702,(%esp)
  802f95:	e8 cd da ff ff       	call   800a67 <_panic>
			sys_page_unmap(0, UTEMP);
  802f9a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802fa1:	00 
  802fa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fa9:	e8 2e e8 ff ff       	call   8017dc <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802fae:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802fb4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802fba:	89 df                	mov    %ebx,%edi
  802fbc:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802fc2:	0f 87 cf fe ff ff    	ja     802e97 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802fc8:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  802fcf:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802fd6:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802fdd:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  802fe3:	0f 8c 37 fe ff ff    	jl     802e20 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802fe9:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802fef:	89 04 24             	mov    %eax,(%esp)
  802ff2:	e8 00 f3 ff ff       	call   8022f7 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
  802ff7:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ffc:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  803002:	89 d8                	mov    %ebx,%eax
  803004:	c1 e8 16             	shr    $0x16,%eax
  803007:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80300e:	a8 01                	test   $0x1,%al
  803010:	74 76                	je     803088 <spawn+0x4e8>
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
  803012:	89 d8                	mov    %ebx,%eax
  803014:	c1 e8 0c             	shr    $0xc,%eax
  803017:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80301e:	f6 c6 04             	test   $0x4,%dh
  803021:	74 5d                	je     803080 <spawn+0x4e0>
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  803023:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
				cprintf("\nspawn addr:%p\n",addr);
  80302a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80302e:	c7 04 24 2b 47 80 00 	movl   $0x80472b,(%esp)
  803035:	e8 26 db ff ff       	call   800b60 <cprintf>
		if(uvpd[PDX(addr)] & PTE_P)
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  80303a:	81 e7 07 0e 00 00    	and    $0xe07,%edi
				cprintf("\nspawn addr:%p\n",addr);
				if ((r = sys_page_map(0, (void *)addr, child, (void *)addr, perm)) < 0)
  803040:	89 7c 24 10          	mov    %edi,0x10(%esp)
  803044:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803048:	89 74 24 08          	mov    %esi,0x8(%esp)
  80304c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803050:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803057:	e8 2d e7 ff ff       	call   801789 <sys_page_map>
  80305c:	85 c0                	test   %eax,%eax
  80305e:	79 20                	jns    803080 <spawn+0x4e0>
					panic("sys_page_map: %e", r);
  803060:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803064:	c7 44 24 08 8c 45 80 	movl   $0x80458c,0x8(%esp)
  80306b:	00 
  80306c:	c7 44 24 04 c2 01 00 	movl   $0x1c2,0x4(%esp)
  803073:	00 
  803074:	c7 04 24 02 47 80 00 	movl   $0x804702,(%esp)
  80307b:	e8 e7 d9 ff ff       	call   800a67 <_panic>
			}
			addr += PGSIZE;
  803080:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  803086:	eb 06                	jmp    80308e <spawn+0x4ee>
		}
		else
		{
			addr = addr + PTSIZE;
  803088:	81 c3 00 00 40 00    	add    $0x400000,%ebx
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
  80308e:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  803094:	0f 86 68 ff ff ff    	jbe    803002 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80309a:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8030a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030a4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8030aa:	89 04 24             	mov    %eax,(%esp)
  8030ad:	e8 f0 e7 ff ff       	call   8018a2 <sys_env_set_trapframe>
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	79 20                	jns    8030d6 <spawn+0x536>
		panic("sys_env_set_trapframe: %e", r);
  8030b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030ba:	c7 44 24 08 3b 47 80 	movl   $0x80473b,0x8(%esp)
  8030c1:	00 
  8030c2:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  8030c9:	00 
  8030ca:	c7 04 24 02 47 80 00 	movl   $0x804702,(%esp)
  8030d1:	e8 91 d9 ff ff       	call   800a67 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8030d6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8030dd:	00 
  8030de:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8030e4:	89 04 24             	mov    %eax,(%esp)
  8030e7:	e8 63 e7 ff ff       	call   80184f <sys_env_set_status>
  8030ec:	85 c0                	test   %eax,%eax
  8030ee:	79 30                	jns    803120 <spawn+0x580>
		panic("sys_env_set_status: %e", r);
  8030f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030f4:	c7 44 24 08 55 47 80 	movl   $0x804755,0x8(%esp)
  8030fb:	00 
  8030fc:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  803103:	00 
  803104:	c7 04 24 02 47 80 00 	movl   $0x804702,(%esp)
  80310b:	e8 57 d9 ff ff       	call   800a67 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  803110:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  803116:	eb 57                	jmp    80316f <spawn+0x5cf>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  803118:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80311e:	eb 4f                	jmp    80316f <spawn+0x5cf>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  803120:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  803126:	eb 47                	jmp    80316f <spawn+0x5cf>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  803128:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80312d:	eb 40                	jmp    80316f <spawn+0x5cf>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80312f:	89 c3                	mov    %eax,%ebx
  803131:	eb 06                	jmp    803139 <spawn+0x599>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  803133:	89 c3                	mov    %eax,%ebx
  803135:	eb 02                	jmp    803139 <spawn+0x599>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803137:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803139:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80313f:	89 04 24             	mov    %eax,(%esp)
  803142:	e8 0c e5 ff ff       	call   801653 <sys_env_destroy>
	close(fd);
  803147:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80314d:	89 04 24             	mov    %eax,(%esp)
  803150:	e8 a2 f1 ff ff       	call   8022f7 <close>
	return r;
  803155:	89 d8                	mov    %ebx,%eax
  803157:	eb 16                	jmp    80316f <spawn+0x5cf>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803159:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803160:	00 
  803161:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803168:	e8 6f e6 ff ff       	call   8017dc <sys_page_unmap>
  80316d:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80316f:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  803175:	5b                   	pop    %ebx
  803176:	5e                   	pop    %esi
  803177:	5f                   	pop    %edi
  803178:	5d                   	pop    %ebp
  803179:	c3                   	ret    

0080317a <exec>:

int
exec(const char *prog, const char **argv)
{
  80317a:	55                   	push   %ebp
  80317b:	89 e5                	mov    %esp,%ebp
	sys_env_destroy(child);
	close(fd);
	return r;*/
	return 0;

}
  80317d:	b8 00 00 00 00       	mov    $0x0,%eax
  803182:	5d                   	pop    %ebp
  803183:	c3                   	ret    

00803184 <execl>:


int execl(const char *prog, const char *arg0, ...)
{
  803184:	55                   	push   %ebp
  803185:	89 e5                	mov    %esp,%ebp
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803187:	8d 45 10             	lea    0x10(%ebp),%eax


int execl(const char *prog, const char *arg0, ...)
{
	//works same as spawnl
	int argc=0;
  80318a:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80318f:	eb 03                	jmp    803194 <execl+0x10>
		argc++;
  803191:	83 c2 01             	add    $0x1,%edx
{
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803194:	83 c0 04             	add    $0x4,%eax
  803197:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80319b:	75 f4                	jne    803191 <execl+0xd>
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80319d:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a2:	eb 03                	jmp    8031a7 <execl+0x23>
		argv[i+1] = va_arg(vl, const char *);
  8031a4:	83 c0 01             	add    $0x1,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8031a7:	39 d0                	cmp    %edx,%eax
  8031a9:	75 f9                	jne    8031a4 <execl+0x20>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
}
  8031ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b0:	5d                   	pop    %ebp
  8031b1:	c3                   	ret    

008031b2 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8031b2:	55                   	push   %ebp
  8031b3:	89 e5                	mov    %esp,%ebp
  8031b5:	56                   	push   %esi
  8031b6:	53                   	push   %ebx
  8031b7:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8031ba:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8031bd:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8031c2:	eb 03                	jmp    8031c7 <spawnl+0x15>
		argc++;
  8031c4:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8031c7:	83 c0 04             	add    $0x4,%eax
  8031ca:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8031ce:	75 f4                	jne    8031c4 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8031d0:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  8031d7:	83 e0 f0             	and    $0xfffffff0,%eax
  8031da:	29 c4                	sub    %eax,%esp
  8031dc:	8d 44 24 0b          	lea    0xb(%esp),%eax
  8031e0:	c1 e8 02             	shr    $0x2,%eax
  8031e3:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  8031ea:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8031ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8031ef:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  8031f6:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  8031fd:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8031fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803203:	eb 0a                	jmp    80320f <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  803205:	83 c0 01             	add    $0x1,%eax
  803208:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  80320c:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80320f:	39 d0                	cmp    %edx,%eax
  803211:	75 f2                	jne    803205 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803213:	89 74 24 04          	mov    %esi,0x4(%esp)
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	89 04 24             	mov    %eax,(%esp)
  80321d:	e8 7e f9 ff ff       	call   802ba0 <spawn>
}
  803222:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803225:	5b                   	pop    %ebx
  803226:	5e                   	pop    %esi
  803227:	5d                   	pop    %ebp
  803228:	c3                   	ret    
  803229:	66 90                	xchg   %ax,%ax
  80322b:	66 90                	xchg   %ax,%ax
  80322d:	66 90                	xchg   %ax,%ax
  80322f:	90                   	nop

00803230 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803230:	55                   	push   %ebp
  803231:	89 e5                	mov    %esp,%ebp
  803233:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803236:	c7 44 24 04 92 47 80 	movl   $0x804792,0x4(%esp)
  80323d:	00 
  80323e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803241:	89 04 24             	mov    %eax,(%esp)
  803244:	e8 7e e0 ff ff       	call   8012c7 <strcpy>
	return 0;
}
  803249:	b8 00 00 00 00       	mov    $0x0,%eax
  80324e:	c9                   	leave  
  80324f:	c3                   	ret    

00803250 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803250:	55                   	push   %ebp
  803251:	89 e5                	mov    %esp,%ebp
  803253:	53                   	push   %ebx
  803254:	83 ec 14             	sub    $0x14,%esp
  803257:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80325a:	89 1c 24             	mov    %ebx,(%esp)
  80325d:	e8 85 0a 00 00       	call   803ce7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803262:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803267:	83 f8 01             	cmp    $0x1,%eax
  80326a:	75 0d                	jne    803279 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80326c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80326f:	89 04 24             	mov    %eax,(%esp)
  803272:	e8 29 03 00 00       	call   8035a0 <nsipc_close>
  803277:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  803279:	89 d0                	mov    %edx,%eax
  80327b:	83 c4 14             	add    $0x14,%esp
  80327e:	5b                   	pop    %ebx
  80327f:	5d                   	pop    %ebp
  803280:	c3                   	ret    

00803281 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803281:	55                   	push   %ebp
  803282:	89 e5                	mov    %esp,%ebp
  803284:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803287:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80328e:	00 
  80328f:	8b 45 10             	mov    0x10(%ebp),%eax
  803292:	89 44 24 08          	mov    %eax,0x8(%esp)
  803296:	8b 45 0c             	mov    0xc(%ebp),%eax
  803299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a3:	89 04 24             	mov    %eax,(%esp)
  8032a6:	e8 f0 03 00 00       	call   80369b <nsipc_send>
}
  8032ab:	c9                   	leave  
  8032ac:	c3                   	ret    

008032ad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8032ad:	55                   	push   %ebp
  8032ae:	89 e5                	mov    %esp,%ebp
  8032b0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8032b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8032ba:	00 
  8032bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8032be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8032c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032cf:	89 04 24             	mov    %eax,(%esp)
  8032d2:	e8 44 03 00 00       	call   80361b <nsipc_recv>
}
  8032d7:	c9                   	leave  
  8032d8:	c3                   	ret    

008032d9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8032d9:	55                   	push   %ebp
  8032da:	89 e5                	mov    %esp,%ebp
  8032dc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8032df:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8032e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8032e6:	89 04 24             	mov    %eax,(%esp)
  8032e9:	e8 d8 ee ff ff       	call   8021c6 <fd_lookup>
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	78 17                	js     803309 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  8032fb:	39 08                	cmp    %ecx,(%eax)
  8032fd:	75 05                	jne    803304 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8032ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803302:	eb 05                	jmp    803309 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  803304:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  803309:	c9                   	leave  
  80330a:	c3                   	ret    

0080330b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80330b:	55                   	push   %ebp
  80330c:	89 e5                	mov    %esp,%ebp
  80330e:	56                   	push   %esi
  80330f:	53                   	push   %ebx
  803310:	83 ec 20             	sub    $0x20,%esp
  803313:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803315:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803318:	89 04 24             	mov    %eax,(%esp)
  80331b:	e8 57 ee ff ff       	call   802177 <fd_alloc>
  803320:	89 c3                	mov    %eax,%ebx
  803322:	85 c0                	test   %eax,%eax
  803324:	78 21                	js     803347 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803326:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80332d:	00 
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	89 44 24 04          	mov    %eax,0x4(%esp)
  803335:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80333c:	e8 f4 e3 ff ff       	call   801735 <sys_page_alloc>
  803341:	89 c3                	mov    %eax,%ebx
  803343:	85 c0                	test   %eax,%eax
  803345:	79 0c                	jns    803353 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  803347:	89 34 24             	mov    %esi,(%esp)
  80334a:	e8 51 02 00 00       	call   8035a0 <nsipc_close>
		return r;
  80334f:	89 d8                	mov    %ebx,%eax
  803351:	eb 20                	jmp    803373 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803353:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80335e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803361:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  803368:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80336b:	89 14 24             	mov    %edx,(%esp)
  80336e:	e8 dd ed ff ff       	call   802150 <fd2num>
}
  803373:	83 c4 20             	add    $0x20,%esp
  803376:	5b                   	pop    %ebx
  803377:	5e                   	pop    %esi
  803378:	5d                   	pop    %ebp
  803379:	c3                   	ret    

0080337a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80337a:	55                   	push   %ebp
  80337b:	89 e5                	mov    %esp,%ebp
  80337d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	e8 51 ff ff ff       	call   8032d9 <fd2sockid>
		return r;
  803388:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80338a:	85 c0                	test   %eax,%eax
  80338c:	78 23                	js     8033b1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80338e:	8b 55 10             	mov    0x10(%ebp),%edx
  803391:	89 54 24 08          	mov    %edx,0x8(%esp)
  803395:	8b 55 0c             	mov    0xc(%ebp),%edx
  803398:	89 54 24 04          	mov    %edx,0x4(%esp)
  80339c:	89 04 24             	mov    %eax,(%esp)
  80339f:	e8 45 01 00 00       	call   8034e9 <nsipc_accept>
		return r;
  8033a4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8033a6:	85 c0                	test   %eax,%eax
  8033a8:	78 07                	js     8033b1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8033aa:	e8 5c ff ff ff       	call   80330b <alloc_sockfd>
  8033af:	89 c1                	mov    %eax,%ecx
}
  8033b1:	89 c8                	mov    %ecx,%eax
  8033b3:	c9                   	leave  
  8033b4:	c3                   	ret    

008033b5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033b5:	55                   	push   %ebp
  8033b6:	89 e5                	mov    %esp,%ebp
  8033b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	e8 16 ff ff ff       	call   8032d9 <fd2sockid>
  8033c3:	89 c2                	mov    %eax,%edx
  8033c5:	85 d2                	test   %edx,%edx
  8033c7:	78 16                	js     8033df <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8033c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8033cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033d7:	89 14 24             	mov    %edx,(%esp)
  8033da:	e8 60 01 00 00       	call   80353f <nsipc_bind>
}
  8033df:	c9                   	leave  
  8033e0:	c3                   	ret    

008033e1 <shutdown>:

int
shutdown(int s, int how)
{
  8033e1:	55                   	push   %ebp
  8033e2:	89 e5                	mov    %esp,%ebp
  8033e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	e8 ea fe ff ff       	call   8032d9 <fd2sockid>
  8033ef:	89 c2                	mov    %eax,%edx
  8033f1:	85 d2                	test   %edx,%edx
  8033f3:	78 0f                	js     803404 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8033f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033fc:	89 14 24             	mov    %edx,(%esp)
  8033ff:	e8 7a 01 00 00       	call   80357e <nsipc_shutdown>
}
  803404:	c9                   	leave  
  803405:	c3                   	ret    

00803406 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803406:	55                   	push   %ebp
  803407:	89 e5                	mov    %esp,%ebp
  803409:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	e8 c5 fe ff ff       	call   8032d9 <fd2sockid>
  803414:	89 c2                	mov    %eax,%edx
  803416:	85 d2                	test   %edx,%edx
  803418:	78 16                	js     803430 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80341a:	8b 45 10             	mov    0x10(%ebp),%eax
  80341d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803421:	8b 45 0c             	mov    0xc(%ebp),%eax
  803424:	89 44 24 04          	mov    %eax,0x4(%esp)
  803428:	89 14 24             	mov    %edx,(%esp)
  80342b:	e8 8a 01 00 00       	call   8035ba <nsipc_connect>
}
  803430:	c9                   	leave  
  803431:	c3                   	ret    

00803432 <listen>:

int
listen(int s, int backlog)
{
  803432:	55                   	push   %ebp
  803433:	89 e5                	mov    %esp,%ebp
  803435:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	e8 99 fe ff ff       	call   8032d9 <fd2sockid>
  803440:	89 c2                	mov    %eax,%edx
  803442:	85 d2                	test   %edx,%edx
  803444:	78 0f                	js     803455 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  803446:	8b 45 0c             	mov    0xc(%ebp),%eax
  803449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80344d:	89 14 24             	mov    %edx,(%esp)
  803450:	e8 a4 01 00 00       	call   8035f9 <nsipc_listen>
}
  803455:	c9                   	leave  
  803456:	c3                   	ret    

00803457 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803457:	55                   	push   %ebp
  803458:	89 e5                	mov    %esp,%ebp
  80345a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80345d:	8b 45 10             	mov    0x10(%ebp),%eax
  803460:	89 44 24 08          	mov    %eax,0x8(%esp)
  803464:	8b 45 0c             	mov    0xc(%ebp),%eax
  803467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	89 04 24             	mov    %eax,(%esp)
  803471:	e8 98 02 00 00       	call   80370e <nsipc_socket>
  803476:	89 c2                	mov    %eax,%edx
  803478:	85 d2                	test   %edx,%edx
  80347a:	78 05                	js     803481 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80347c:	e8 8a fe ff ff       	call   80330b <alloc_sockfd>
}
  803481:	c9                   	leave  
  803482:	c3                   	ret    

00803483 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803483:	55                   	push   %ebp
  803484:	89 e5                	mov    %esp,%ebp
  803486:	53                   	push   %ebx
  803487:	83 ec 14             	sub    $0x14,%esp
  80348a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80348c:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  803493:	75 11                	jne    8034a6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803495:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80349c:	e8 0e 08 00 00       	call   803caf <ipc_find_env>
  8034a1:	a3 24 64 80 00       	mov    %eax,0x806424
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8034a6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8034ad:	00 
  8034ae:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8034b5:	00 
  8034b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8034ba:	a1 24 64 80 00       	mov    0x806424,%eax
  8034bf:	89 04 24             	mov    %eax,(%esp)
  8034c2:	e8 81 07 00 00       	call   803c48 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8034c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8034ce:	00 
  8034cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8034d6:	00 
  8034d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034de:	e8 fd 06 00 00       	call   803be0 <ipc_recv>
}
  8034e3:	83 c4 14             	add    $0x14,%esp
  8034e6:	5b                   	pop    %ebx
  8034e7:	5d                   	pop    %ebp
  8034e8:	c3                   	ret    

008034e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034e9:	55                   	push   %ebp
  8034ea:	89 e5                	mov    %esp,%ebp
  8034ec:	56                   	push   %esi
  8034ed:	53                   	push   %ebx
  8034ee:	83 ec 10             	sub    $0x10,%esp
  8034f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8034fc:	8b 06                	mov    (%esi),%eax
  8034fe:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803503:	b8 01 00 00 00       	mov    $0x1,%eax
  803508:	e8 76 ff ff ff       	call   803483 <nsipc>
  80350d:	89 c3                	mov    %eax,%ebx
  80350f:	85 c0                	test   %eax,%eax
  803511:	78 23                	js     803536 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803513:	a1 10 80 80 00       	mov    0x808010,%eax
  803518:	89 44 24 08          	mov    %eax,0x8(%esp)
  80351c:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803523:	00 
  803524:	8b 45 0c             	mov    0xc(%ebp),%eax
  803527:	89 04 24             	mov    %eax,(%esp)
  80352a:	e8 35 df ff ff       	call   801464 <memmove>
		*addrlen = ret->ret_addrlen;
  80352f:	a1 10 80 80 00       	mov    0x808010,%eax
  803534:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  803536:	89 d8                	mov    %ebx,%eax
  803538:	83 c4 10             	add    $0x10,%esp
  80353b:	5b                   	pop    %ebx
  80353c:	5e                   	pop    %esi
  80353d:	5d                   	pop    %ebp
  80353e:	c3                   	ret    

0080353f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80353f:	55                   	push   %ebp
  803540:	89 e5                	mov    %esp,%ebp
  803542:	53                   	push   %ebx
  803543:	83 ec 14             	sub    $0x14,%esp
  803546:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803551:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803555:	8b 45 0c             	mov    0xc(%ebp),%eax
  803558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80355c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803563:	e8 fc de ff ff       	call   801464 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803568:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  80356e:	b8 02 00 00 00       	mov    $0x2,%eax
  803573:	e8 0b ff ff ff       	call   803483 <nsipc>
}
  803578:	83 c4 14             	add    $0x14,%esp
  80357b:	5b                   	pop    %ebx
  80357c:	5d                   	pop    %ebp
  80357d:	c3                   	ret    

0080357e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
  803581:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  80358c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358f:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803594:	b8 03 00 00 00       	mov    $0x3,%eax
  803599:	e8 e5 fe ff ff       	call   803483 <nsipc>
}
  80359e:	c9                   	leave  
  80359f:	c3                   	ret    

008035a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8035a0:	55                   	push   %ebp
  8035a1:	89 e5                	mov    %esp,%ebp
  8035a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8035a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a9:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8035ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8035b3:	e8 cb fe ff ff       	call   803483 <nsipc>
}
  8035b8:	c9                   	leave  
  8035b9:	c3                   	ret    

008035ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035ba:	55                   	push   %ebp
  8035bb:	89 e5                	mov    %esp,%ebp
  8035bd:	53                   	push   %ebx
  8035be:	83 ec 14             	sub    $0x14,%esp
  8035c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8035cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035d7:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8035de:	e8 81 de ff ff       	call   801464 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8035e3:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8035e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8035ee:	e8 90 fe ff ff       	call   803483 <nsipc>
}
  8035f3:	83 c4 14             	add    $0x14,%esp
  8035f6:	5b                   	pop    %ebx
  8035f7:	5d                   	pop    %ebp
  8035f8:	c3                   	ret    

008035f9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8035f9:	55                   	push   %ebp
  8035fa:	89 e5                	mov    %esp,%ebp
  8035fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360a:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80360f:	b8 06 00 00 00       	mov    $0x6,%eax
  803614:	e8 6a fe ff ff       	call   803483 <nsipc>
}
  803619:	c9                   	leave  
  80361a:	c3                   	ret    

0080361b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80361b:	55                   	push   %ebp
  80361c:	89 e5                	mov    %esp,%ebp
  80361e:	56                   	push   %esi
  80361f:	53                   	push   %ebx
  803620:	83 ec 10             	sub    $0x10,%esp
  803623:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80362e:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803634:	8b 45 14             	mov    0x14(%ebp),%eax
  803637:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80363c:	b8 07 00 00 00       	mov    $0x7,%eax
  803641:	e8 3d fe ff ff       	call   803483 <nsipc>
  803646:	89 c3                	mov    %eax,%ebx
  803648:	85 c0                	test   %eax,%eax
  80364a:	78 46                	js     803692 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80364c:	39 f0                	cmp    %esi,%eax
  80364e:	7f 07                	jg     803657 <nsipc_recv+0x3c>
  803650:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803655:	7e 24                	jle    80367b <nsipc_recv+0x60>
  803657:	c7 44 24 0c 9e 47 80 	movl   $0x80479e,0xc(%esp)
  80365e:	00 
  80365f:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  803666:	00 
  803667:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80366e:	00 
  80366f:	c7 04 24 b3 47 80 00 	movl   $0x8047b3,(%esp)
  803676:	e8 ec d3 ff ff       	call   800a67 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80367b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80367f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803686:	00 
  803687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368a:	89 04 24             	mov    %eax,(%esp)
  80368d:	e8 d2 dd ff ff       	call   801464 <memmove>
	}

	return r;
}
  803692:	89 d8                	mov    %ebx,%eax
  803694:	83 c4 10             	add    $0x10,%esp
  803697:	5b                   	pop    %ebx
  803698:	5e                   	pop    %esi
  803699:	5d                   	pop    %ebp
  80369a:	c3                   	ret    

0080369b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80369b:	55                   	push   %ebp
  80369c:	89 e5                	mov    %esp,%ebp
  80369e:	53                   	push   %ebx
  80369f:	83 ec 14             	sub    $0x14,%esp
  8036a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8036ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8036b3:	7e 24                	jle    8036d9 <nsipc_send+0x3e>
  8036b5:	c7 44 24 0c bf 47 80 	movl   $0x8047bf,0xc(%esp)
  8036bc:	00 
  8036bd:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  8036c4:	00 
  8036c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8036cc:	00 
  8036cd:	c7 04 24 b3 47 80 00 	movl   $0x8047b3,(%esp)
  8036d4:	e8 8e d3 ff ff       	call   800a67 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8036d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036e4:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8036eb:	e8 74 dd ff ff       	call   801464 <memmove>
	nsipcbuf.send.req_size = size;
  8036f0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8036f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8036f9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8036fe:	b8 08 00 00 00       	mov    $0x8,%eax
  803703:	e8 7b fd ff ff       	call   803483 <nsipc>
}
  803708:	83 c4 14             	add    $0x14,%esp
  80370b:	5b                   	pop    %ebx
  80370c:	5d                   	pop    %ebp
  80370d:	c3                   	ret    

0080370e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80370e:	55                   	push   %ebp
  80370f:	89 e5                	mov    %esp,%ebp
  803711:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80371c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803724:	8b 45 10             	mov    0x10(%ebp),%eax
  803727:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80372c:	b8 09 00 00 00       	mov    $0x9,%eax
  803731:	e8 4d fd ff ff       	call   803483 <nsipc>
}
  803736:	c9                   	leave  
  803737:	c3                   	ret    

00803738 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803738:	55                   	push   %ebp
  803739:	89 e5                	mov    %esp,%ebp
  80373b:	56                   	push   %esi
  80373c:	53                   	push   %ebx
  80373d:	83 ec 10             	sub    $0x10,%esp
  803740:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	89 04 24             	mov    %eax,(%esp)
  803749:	e8 12 ea ff ff       	call   802160 <fd2data>
  80374e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803750:	c7 44 24 04 cb 47 80 	movl   $0x8047cb,0x4(%esp)
  803757:	00 
  803758:	89 1c 24             	mov    %ebx,(%esp)
  80375b:	e8 67 db ff ff       	call   8012c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803760:	8b 46 04             	mov    0x4(%esi),%eax
  803763:	2b 06                	sub    (%esi),%eax
  803765:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80376b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803772:	00 00 00 
	stat->st_dev = &devpipe;
  803775:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  80377c:	50 80 00 
	return 0;
}
  80377f:	b8 00 00 00 00       	mov    $0x0,%eax
  803784:	83 c4 10             	add    $0x10,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5d                   	pop    %ebp
  80378a:	c3                   	ret    

0080378b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80378b:	55                   	push   %ebp
  80378c:	89 e5                	mov    %esp,%ebp
  80378e:	53                   	push   %ebx
  80378f:	83 ec 14             	sub    $0x14,%esp
  803792:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803795:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803799:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037a0:	e8 37 e0 ff ff       	call   8017dc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8037a5:	89 1c 24             	mov    %ebx,(%esp)
  8037a8:	e8 b3 e9 ff ff       	call   802160 <fd2data>
  8037ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037b8:	e8 1f e0 ff ff       	call   8017dc <sys_page_unmap>
}
  8037bd:	83 c4 14             	add    $0x14,%esp
  8037c0:	5b                   	pop    %ebx
  8037c1:	5d                   	pop    %ebp
  8037c2:	c3                   	ret    

008037c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037c3:	55                   	push   %ebp
  8037c4:	89 e5                	mov    %esp,%ebp
  8037c6:	57                   	push   %edi
  8037c7:	56                   	push   %esi
  8037c8:	53                   	push   %ebx
  8037c9:	83 ec 2c             	sub    $0x2c,%esp
  8037cc:	89 c6                	mov    %eax,%esi
  8037ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037d1:	a1 28 64 80 00       	mov    0x806428,%eax
  8037d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8037d9:	89 34 24             	mov    %esi,(%esp)
  8037dc:	e8 06 05 00 00       	call   803ce7 <pageref>
  8037e1:	89 c7                	mov    %eax,%edi
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	89 04 24             	mov    %eax,(%esp)
  8037e9:	e8 f9 04 00 00       	call   803ce7 <pageref>
  8037ee:	39 c7                	cmp    %eax,%edi
  8037f0:	0f 94 c2             	sete   %dl
  8037f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8037f6:	8b 0d 28 64 80 00    	mov    0x806428,%ecx
  8037fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8037ff:	39 fb                	cmp    %edi,%ebx
  803801:	74 21                	je     803824 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803803:	84 d2                	test   %dl,%dl
  803805:	74 ca                	je     8037d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803807:	8b 51 58             	mov    0x58(%ecx),%edx
  80380a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80380e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803812:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803816:	c7 04 24 d2 47 80 00 	movl   $0x8047d2,(%esp)
  80381d:	e8 3e d3 ff ff       	call   800b60 <cprintf>
  803822:	eb ad                	jmp    8037d1 <_pipeisclosed+0xe>
	}
}
  803824:	83 c4 2c             	add    $0x2c,%esp
  803827:	5b                   	pop    %ebx
  803828:	5e                   	pop    %esi
  803829:	5f                   	pop    %edi
  80382a:	5d                   	pop    %ebp
  80382b:	c3                   	ret    

0080382c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80382c:	55                   	push   %ebp
  80382d:	89 e5                	mov    %esp,%ebp
  80382f:	57                   	push   %edi
  803830:	56                   	push   %esi
  803831:	53                   	push   %ebx
  803832:	83 ec 1c             	sub    $0x1c,%esp
  803835:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803838:	89 34 24             	mov    %esi,(%esp)
  80383b:	e8 20 e9 ff ff       	call   802160 <fd2data>
  803840:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803842:	bf 00 00 00 00       	mov    $0x0,%edi
  803847:	eb 45                	jmp    80388e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803849:	89 da                	mov    %ebx,%edx
  80384b:	89 f0                	mov    %esi,%eax
  80384d:	e8 71 ff ff ff       	call   8037c3 <_pipeisclosed>
  803852:	85 c0                	test   %eax,%eax
  803854:	75 41                	jne    803897 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803856:	e8 bb de ff ff       	call   801716 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80385b:	8b 43 04             	mov    0x4(%ebx),%eax
  80385e:	8b 0b                	mov    (%ebx),%ecx
  803860:	8d 51 20             	lea    0x20(%ecx),%edx
  803863:	39 d0                	cmp    %edx,%eax
  803865:	73 e2                	jae    803849 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803867:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80386a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80386e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803871:	99                   	cltd   
  803872:	c1 ea 1b             	shr    $0x1b,%edx
  803875:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803878:	83 e1 1f             	and    $0x1f,%ecx
  80387b:	29 d1                	sub    %edx,%ecx
  80387d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  803881:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803885:	83 c0 01             	add    $0x1,%eax
  803888:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80388b:	83 c7 01             	add    $0x1,%edi
  80388e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803891:	75 c8                	jne    80385b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803893:	89 f8                	mov    %edi,%eax
  803895:	eb 05                	jmp    80389c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803897:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80389c:	83 c4 1c             	add    $0x1c,%esp
  80389f:	5b                   	pop    %ebx
  8038a0:	5e                   	pop    %esi
  8038a1:	5f                   	pop    %edi
  8038a2:	5d                   	pop    %ebp
  8038a3:	c3                   	ret    

008038a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038a4:	55                   	push   %ebp
  8038a5:	89 e5                	mov    %esp,%ebp
  8038a7:	57                   	push   %edi
  8038a8:	56                   	push   %esi
  8038a9:	53                   	push   %ebx
  8038aa:	83 ec 1c             	sub    $0x1c,%esp
  8038ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038b0:	89 3c 24             	mov    %edi,(%esp)
  8038b3:	e8 a8 e8 ff ff       	call   802160 <fd2data>
  8038b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038ba:	be 00 00 00 00       	mov    $0x0,%esi
  8038bf:	eb 3d                	jmp    8038fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038c1:	85 f6                	test   %esi,%esi
  8038c3:	74 04                	je     8038c9 <devpipe_read+0x25>
				return i;
  8038c5:	89 f0                	mov    %esi,%eax
  8038c7:	eb 43                	jmp    80390c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8038c9:	89 da                	mov    %ebx,%edx
  8038cb:	89 f8                	mov    %edi,%eax
  8038cd:	e8 f1 fe ff ff       	call   8037c3 <_pipeisclosed>
  8038d2:	85 c0                	test   %eax,%eax
  8038d4:	75 31                	jne    803907 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038d6:	e8 3b de ff ff       	call   801716 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8038db:	8b 03                	mov    (%ebx),%eax
  8038dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8038e0:	74 df                	je     8038c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038e2:	99                   	cltd   
  8038e3:	c1 ea 1b             	shr    $0x1b,%edx
  8038e6:	01 d0                	add    %edx,%eax
  8038e8:	83 e0 1f             	and    $0x1f,%eax
  8038eb:	29 d0                	sub    %edx,%eax
  8038ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8038f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8038f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8038f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038fb:	83 c6 01             	add    $0x1,%esi
  8038fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  803901:	75 d8                	jne    8038db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803903:	89 f0                	mov    %esi,%eax
  803905:	eb 05                	jmp    80390c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803907:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80390c:	83 c4 1c             	add    $0x1c,%esp
  80390f:	5b                   	pop    %ebx
  803910:	5e                   	pop    %esi
  803911:	5f                   	pop    %edi
  803912:	5d                   	pop    %ebp
  803913:	c3                   	ret    

00803914 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803914:	55                   	push   %ebp
  803915:	89 e5                	mov    %esp,%ebp
  803917:	56                   	push   %esi
  803918:	53                   	push   %ebx
  803919:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80391c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80391f:	89 04 24             	mov    %eax,(%esp)
  803922:	e8 50 e8 ff ff       	call   802177 <fd_alloc>
  803927:	89 c2                	mov    %eax,%edx
  803929:	85 d2                	test   %edx,%edx
  80392b:	0f 88 4d 01 00 00    	js     803a7e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803931:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803938:	00 
  803939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803940:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803947:	e8 e9 dd ff ff       	call   801735 <sys_page_alloc>
  80394c:	89 c2                	mov    %eax,%edx
  80394e:	85 d2                	test   %edx,%edx
  803950:	0f 88 28 01 00 00    	js     803a7e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803956:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803959:	89 04 24             	mov    %eax,(%esp)
  80395c:	e8 16 e8 ff ff       	call   802177 <fd_alloc>
  803961:	89 c3                	mov    %eax,%ebx
  803963:	85 c0                	test   %eax,%eax
  803965:	0f 88 fe 00 00 00    	js     803a69 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80396b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803972:	00 
  803973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803976:	89 44 24 04          	mov    %eax,0x4(%esp)
  80397a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803981:	e8 af dd ff ff       	call   801735 <sys_page_alloc>
  803986:	89 c3                	mov    %eax,%ebx
  803988:	85 c0                	test   %eax,%eax
  80398a:	0f 88 d9 00 00 00    	js     803a69 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803993:	89 04 24             	mov    %eax,(%esp)
  803996:	e8 c5 e7 ff ff       	call   802160 <fd2data>
  80399b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80399d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8039a4:	00 
  8039a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039b0:	e8 80 dd ff ff       	call   801735 <sys_page_alloc>
  8039b5:	89 c3                	mov    %eax,%ebx
  8039b7:	85 c0                	test   %eax,%eax
  8039b9:	0f 88 97 00 00 00    	js     803a56 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c2:	89 04 24             	mov    %eax,(%esp)
  8039c5:	e8 96 e7 ff ff       	call   802160 <fd2data>
  8039ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8039d1:	00 
  8039d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8039dd:	00 
  8039de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8039e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039e9:	e8 9b dd ff ff       	call   801789 <sys_page_map>
  8039ee:	89 c3                	mov    %eax,%ebx
  8039f0:	85 c0                	test   %eax,%eax
  8039f2:	78 52                	js     803a46 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8039f4:	8b 15 58 50 80 00    	mov    0x805058,%edx
  8039fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8039ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a09:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a12:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a17:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a21:	89 04 24             	mov    %eax,(%esp)
  803a24:	e8 27 e7 ff ff       	call   802150 <fd2num>
  803a29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803a2c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a31:	89 04 24             	mov    %eax,(%esp)
  803a34:	e8 17 e7 ff ff       	call   802150 <fd2num>
  803a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803a3c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a44:	eb 38                	jmp    803a7e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803a46:	89 74 24 04          	mov    %esi,0x4(%esp)
  803a4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a51:	e8 86 dd ff ff       	call   8017dc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a64:	e8 73 dd ff ff       	call   8017dc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a77:	e8 60 dd ff ff       	call   8017dc <sys_page_unmap>
  803a7c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  803a7e:	83 c4 30             	add    $0x30,%esp
  803a81:	5b                   	pop    %ebx
  803a82:	5e                   	pop    %esi
  803a83:	5d                   	pop    %ebp
  803a84:	c3                   	ret    

00803a85 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803a85:	55                   	push   %ebp
  803a86:	89 e5                	mov    %esp,%ebp
  803a88:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a92:	8b 45 08             	mov    0x8(%ebp),%eax
  803a95:	89 04 24             	mov    %eax,(%esp)
  803a98:	e8 29 e7 ff ff       	call   8021c6 <fd_lookup>
  803a9d:	89 c2                	mov    %eax,%edx
  803a9f:	85 d2                	test   %edx,%edx
  803aa1:	78 15                	js     803ab8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa6:	89 04 24             	mov    %eax,(%esp)
  803aa9:	e8 b2 e6 ff ff       	call   802160 <fd2data>
	return _pipeisclosed(fd, p);
  803aae:	89 c2                	mov    %eax,%edx
  803ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab3:	e8 0b fd ff ff       	call   8037c3 <_pipeisclosed>
}
  803ab8:	c9                   	leave  
  803ab9:	c3                   	ret    

00803aba <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803aba:	55                   	push   %ebp
  803abb:	89 e5                	mov    %esp,%ebp
  803abd:	56                   	push   %esi
  803abe:	53                   	push   %ebx
  803abf:	83 ec 10             	sub    $0x10,%esp
  803ac2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803ac5:	85 f6                	test   %esi,%esi
  803ac7:	75 24                	jne    803aed <wait+0x33>
  803ac9:	c7 44 24 0c ea 47 80 	movl   $0x8047ea,0xc(%esp)
  803ad0:	00 
  803ad1:	c7 44 24 08 fd 40 80 	movl   $0x8040fd,0x8(%esp)
  803ad8:	00 
  803ad9:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  803ae0:	00 
  803ae1:	c7 04 24 f5 47 80 00 	movl   $0x8047f5,(%esp)
  803ae8:	e8 7a cf ff ff       	call   800a67 <_panic>
	e = &envs[ENVX(envid)];
  803aed:	89 f3                	mov    %esi,%ebx
  803aef:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  803af5:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803af8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803afe:	eb 05                	jmp    803b05 <wait+0x4b>
		sys_yield();
  803b00:	e8 11 dc ff ff       	call   801716 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803b05:	8b 43 48             	mov    0x48(%ebx),%eax
  803b08:	39 f0                	cmp    %esi,%eax
  803b0a:	75 07                	jne    803b13 <wait+0x59>
  803b0c:	8b 43 54             	mov    0x54(%ebx),%eax
  803b0f:	85 c0                	test   %eax,%eax
  803b11:	75 ed                	jne    803b00 <wait+0x46>
		sys_yield();
}
  803b13:	83 c4 10             	add    $0x10,%esp
  803b16:	5b                   	pop    %ebx
  803b17:	5e                   	pop    %esi
  803b18:	5d                   	pop    %ebp
  803b19:	c3                   	ret    

00803b1a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b1a:	55                   	push   %ebp
  803b1b:	89 e5                	mov    %esp,%ebp
  803b1d:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  803b20:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803b27:	75 7a                	jne    803ba3 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  803b29:	e8 c9 db ff ff       	call   8016f7 <sys_getenvid>
  803b2e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803b35:	00 
  803b36:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803b3d:	ee 
  803b3e:	89 04 24             	mov    %eax,(%esp)
  803b41:	e8 ef db ff ff       	call   801735 <sys_page_alloc>
  803b46:	85 c0                	test   %eax,%eax
  803b48:	79 20                	jns    803b6a <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  803b4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b4e:	c7 44 24 08 79 45 80 	movl   $0x804579,0x8(%esp)
  803b55:	00 
  803b56:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  803b5d:	00 
  803b5e:	c7 04 24 00 48 80 00 	movl   $0x804800,(%esp)
  803b65:	e8 fd ce ff ff       	call   800a67 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  803b6a:	e8 88 db ff ff       	call   8016f7 <sys_getenvid>
  803b6f:	c7 44 24 04 ad 3b 80 	movl   $0x803bad,0x4(%esp)
  803b76:	00 
  803b77:	89 04 24             	mov    %eax,(%esp)
  803b7a:	e8 76 dd ff ff       	call   8018f5 <sys_env_set_pgfault_upcall>
  803b7f:	85 c0                	test   %eax,%eax
  803b81:	79 20                	jns    803ba3 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  803b83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b87:	c7 44 24 08 f8 45 80 	movl   $0x8045f8,0x8(%esp)
  803b8e:	00 
  803b8f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  803b96:	00 
  803b97:	c7 04 24 00 48 80 00 	movl   $0x804800,(%esp)
  803b9e:	e8 c4 ce ff ff       	call   800a67 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba6:	a3 00 90 80 00       	mov    %eax,0x809000
}
  803bab:	c9                   	leave  
  803bac:	c3                   	ret    

00803bad <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803bad:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803bae:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  803bb3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803bb5:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  803bb8:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  803bbc:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  803bc0:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  803bc3:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  803bc7:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  803bc9:	83 c4 08             	add    $0x8,%esp
	popal
  803bcc:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  803bcd:	83 c4 04             	add    $0x4,%esp
	popfl
  803bd0:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803bd1:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803bd2:	c3                   	ret    
  803bd3:	66 90                	xchg   %ax,%ax
  803bd5:	66 90                	xchg   %ax,%ax
  803bd7:	66 90                	xchg   %ax,%ax
  803bd9:	66 90                	xchg   %ax,%ax
  803bdb:	66 90                	xchg   %ax,%ax
  803bdd:	66 90                	xchg   %ax,%ax
  803bdf:	90                   	nop

00803be0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803be0:	55                   	push   %ebp
  803be1:	89 e5                	mov    %esp,%ebp
  803be3:	56                   	push   %esi
  803be4:	53                   	push   %ebx
  803be5:	83 ec 10             	sub    $0x10,%esp
  803be8:	8b 75 08             	mov    0x8(%ebp),%esi
  803beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  803bf1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  803bf3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  803bf8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803bfb:	89 04 24             	mov    %eax,(%esp)
  803bfe:	e8 68 dd ff ff       	call   80196b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  803c03:	85 c0                	test   %eax,%eax
  803c05:	75 26                	jne    803c2d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  803c07:	85 f6                	test   %esi,%esi
  803c09:	74 0a                	je     803c15 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  803c0b:	a1 28 64 80 00       	mov    0x806428,%eax
  803c10:	8b 40 74             	mov    0x74(%eax),%eax
  803c13:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  803c15:	85 db                	test   %ebx,%ebx
  803c17:	74 0a                	je     803c23 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  803c19:	a1 28 64 80 00       	mov    0x806428,%eax
  803c1e:	8b 40 78             	mov    0x78(%eax),%eax
  803c21:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  803c23:	a1 28 64 80 00       	mov    0x806428,%eax
  803c28:	8b 40 70             	mov    0x70(%eax),%eax
  803c2b:	eb 14                	jmp    803c41 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  803c2d:	85 f6                	test   %esi,%esi
  803c2f:	74 06                	je     803c37 <ipc_recv+0x57>
			*from_env_store = 0;
  803c31:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  803c37:	85 db                	test   %ebx,%ebx
  803c39:	74 06                	je     803c41 <ipc_recv+0x61>
			*perm_store = 0;
  803c3b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  803c41:	83 c4 10             	add    $0x10,%esp
  803c44:	5b                   	pop    %ebx
  803c45:	5e                   	pop    %esi
  803c46:	5d                   	pop    %ebp
  803c47:	c3                   	ret    

00803c48 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c48:	55                   	push   %ebp
  803c49:	89 e5                	mov    %esp,%ebp
  803c4b:	57                   	push   %edi
  803c4c:	56                   	push   %esi
  803c4d:	53                   	push   %ebx
  803c4e:	83 ec 1c             	sub    $0x1c,%esp
  803c51:	8b 7d 08             	mov    0x8(%ebp),%edi
  803c54:	8b 75 0c             	mov    0xc(%ebp),%esi
  803c57:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  803c5a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  803c5c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  803c61:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  803c64:	8b 45 14             	mov    0x14(%ebp),%eax
  803c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  803c73:	89 3c 24             	mov    %edi,(%esp)
  803c76:	e8 cd dc ff ff       	call   801948 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  803c7b:	85 c0                	test   %eax,%eax
  803c7d:	74 28                	je     803ca7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  803c7f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803c82:	74 1c                	je     803ca0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  803c84:	c7 44 24 08 10 48 80 	movl   $0x804810,0x8(%esp)
  803c8b:	00 
  803c8c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  803c93:	00 
  803c94:	c7 04 24 34 48 80 00 	movl   $0x804834,(%esp)
  803c9b:	e8 c7 cd ff ff       	call   800a67 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  803ca0:	e8 71 da ff ff       	call   801716 <sys_yield>
	}
  803ca5:	eb bd                	jmp    803c64 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  803ca7:	83 c4 1c             	add    $0x1c,%esp
  803caa:	5b                   	pop    %ebx
  803cab:	5e                   	pop    %esi
  803cac:	5f                   	pop    %edi
  803cad:	5d                   	pop    %ebp
  803cae:	c3                   	ret    

00803caf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803caf:	55                   	push   %ebp
  803cb0:	89 e5                	mov    %esp,%ebp
  803cb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803cb5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803cba:	6b d0 7c             	imul   $0x7c,%eax,%edx
  803cbd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803cc3:	8b 52 50             	mov    0x50(%edx),%edx
  803cc6:	39 ca                	cmp    %ecx,%edx
  803cc8:	75 0d                	jne    803cd7 <ipc_find_env+0x28>
			return envs[i].env_id;
  803cca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803ccd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  803cd2:	8b 40 40             	mov    0x40(%eax),%eax
  803cd5:	eb 0e                	jmp    803ce5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803cd7:	83 c0 01             	add    $0x1,%eax
  803cda:	3d 00 04 00 00       	cmp    $0x400,%eax
  803cdf:	75 d9                	jne    803cba <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803ce1:	66 b8 00 00          	mov    $0x0,%ax
}
  803ce5:	5d                   	pop    %ebp
  803ce6:	c3                   	ret    

00803ce7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ce7:	55                   	push   %ebp
  803ce8:	89 e5                	mov    %esp,%ebp
  803cea:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803ced:	89 d0                	mov    %edx,%eax
  803cef:	c1 e8 16             	shr    $0x16,%eax
  803cf2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803cf9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803cfe:	f6 c1 01             	test   $0x1,%cl
  803d01:	74 1d                	je     803d20 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  803d03:	c1 ea 0c             	shr    $0xc,%edx
  803d06:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803d0d:	f6 c2 01             	test   $0x1,%dl
  803d10:	74 0e                	je     803d20 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803d12:	c1 ea 0c             	shr    $0xc,%edx
  803d15:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803d1c:	ef 
  803d1d:	0f b7 c0             	movzwl %ax,%eax
}
  803d20:	5d                   	pop    %ebp
  803d21:	c3                   	ret    
  803d22:	66 90                	xchg   %ax,%ax
  803d24:	66 90                	xchg   %ax,%ax
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	66 90                	xchg   %ax,%ax
  803d2a:	66 90                	xchg   %ax,%ax
  803d2c:	66 90                	xchg   %ax,%ax
  803d2e:	66 90                	xchg   %ax,%ax

00803d30 <__udivdi3>:
  803d30:	55                   	push   %ebp
  803d31:	57                   	push   %edi
  803d32:	56                   	push   %esi
  803d33:	83 ec 0c             	sub    $0xc,%esp
  803d36:	8b 44 24 28          	mov    0x28(%esp),%eax
  803d3a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  803d3e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803d42:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803d46:	85 c0                	test   %eax,%eax
  803d48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803d4c:	89 ea                	mov    %ebp,%edx
  803d4e:	89 0c 24             	mov    %ecx,(%esp)
  803d51:	75 2d                	jne    803d80 <__udivdi3+0x50>
  803d53:	39 e9                	cmp    %ebp,%ecx
  803d55:	77 61                	ja     803db8 <__udivdi3+0x88>
  803d57:	85 c9                	test   %ecx,%ecx
  803d59:	89 ce                	mov    %ecx,%esi
  803d5b:	75 0b                	jne    803d68 <__udivdi3+0x38>
  803d5d:	b8 01 00 00 00       	mov    $0x1,%eax
  803d62:	31 d2                	xor    %edx,%edx
  803d64:	f7 f1                	div    %ecx
  803d66:	89 c6                	mov    %eax,%esi
  803d68:	31 d2                	xor    %edx,%edx
  803d6a:	89 e8                	mov    %ebp,%eax
  803d6c:	f7 f6                	div    %esi
  803d6e:	89 c5                	mov    %eax,%ebp
  803d70:	89 f8                	mov    %edi,%eax
  803d72:	f7 f6                	div    %esi
  803d74:	89 ea                	mov    %ebp,%edx
  803d76:	83 c4 0c             	add    $0xc,%esp
  803d79:	5e                   	pop    %esi
  803d7a:	5f                   	pop    %edi
  803d7b:	5d                   	pop    %ebp
  803d7c:	c3                   	ret    
  803d7d:	8d 76 00             	lea    0x0(%esi),%esi
  803d80:	39 e8                	cmp    %ebp,%eax
  803d82:	77 24                	ja     803da8 <__udivdi3+0x78>
  803d84:	0f bd e8             	bsr    %eax,%ebp
  803d87:	83 f5 1f             	xor    $0x1f,%ebp
  803d8a:	75 3c                	jne    803dc8 <__udivdi3+0x98>
  803d8c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803d90:	39 34 24             	cmp    %esi,(%esp)
  803d93:	0f 86 9f 00 00 00    	jbe    803e38 <__udivdi3+0x108>
  803d99:	39 d0                	cmp    %edx,%eax
  803d9b:	0f 82 97 00 00 00    	jb     803e38 <__udivdi3+0x108>
  803da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803da8:	31 d2                	xor    %edx,%edx
  803daa:	31 c0                	xor    %eax,%eax
  803dac:	83 c4 0c             	add    $0xc,%esp
  803daf:	5e                   	pop    %esi
  803db0:	5f                   	pop    %edi
  803db1:	5d                   	pop    %ebp
  803db2:	c3                   	ret    
  803db3:	90                   	nop
  803db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803db8:	89 f8                	mov    %edi,%eax
  803dba:	f7 f1                	div    %ecx
  803dbc:	31 d2                	xor    %edx,%edx
  803dbe:	83 c4 0c             	add    $0xc,%esp
  803dc1:	5e                   	pop    %esi
  803dc2:	5f                   	pop    %edi
  803dc3:	5d                   	pop    %ebp
  803dc4:	c3                   	ret    
  803dc5:	8d 76 00             	lea    0x0(%esi),%esi
  803dc8:	89 e9                	mov    %ebp,%ecx
  803dca:	8b 3c 24             	mov    (%esp),%edi
  803dcd:	d3 e0                	shl    %cl,%eax
  803dcf:	89 c6                	mov    %eax,%esi
  803dd1:	b8 20 00 00 00       	mov    $0x20,%eax
  803dd6:	29 e8                	sub    %ebp,%eax
  803dd8:	89 c1                	mov    %eax,%ecx
  803dda:	d3 ef                	shr    %cl,%edi
  803ddc:	89 e9                	mov    %ebp,%ecx
  803dde:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803de2:	8b 3c 24             	mov    (%esp),%edi
  803de5:	09 74 24 08          	or     %esi,0x8(%esp)
  803de9:	89 d6                	mov    %edx,%esi
  803deb:	d3 e7                	shl    %cl,%edi
  803ded:	89 c1                	mov    %eax,%ecx
  803def:	89 3c 24             	mov    %edi,(%esp)
  803df2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803df6:	d3 ee                	shr    %cl,%esi
  803df8:	89 e9                	mov    %ebp,%ecx
  803dfa:	d3 e2                	shl    %cl,%edx
  803dfc:	89 c1                	mov    %eax,%ecx
  803dfe:	d3 ef                	shr    %cl,%edi
  803e00:	09 d7                	or     %edx,%edi
  803e02:	89 f2                	mov    %esi,%edx
  803e04:	89 f8                	mov    %edi,%eax
  803e06:	f7 74 24 08          	divl   0x8(%esp)
  803e0a:	89 d6                	mov    %edx,%esi
  803e0c:	89 c7                	mov    %eax,%edi
  803e0e:	f7 24 24             	mull   (%esp)
  803e11:	39 d6                	cmp    %edx,%esi
  803e13:	89 14 24             	mov    %edx,(%esp)
  803e16:	72 30                	jb     803e48 <__udivdi3+0x118>
  803e18:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e1c:	89 e9                	mov    %ebp,%ecx
  803e1e:	d3 e2                	shl    %cl,%edx
  803e20:	39 c2                	cmp    %eax,%edx
  803e22:	73 05                	jae    803e29 <__udivdi3+0xf9>
  803e24:	3b 34 24             	cmp    (%esp),%esi
  803e27:	74 1f                	je     803e48 <__udivdi3+0x118>
  803e29:	89 f8                	mov    %edi,%eax
  803e2b:	31 d2                	xor    %edx,%edx
  803e2d:	e9 7a ff ff ff       	jmp    803dac <__udivdi3+0x7c>
  803e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803e38:	31 d2                	xor    %edx,%edx
  803e3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e3f:	e9 68 ff ff ff       	jmp    803dac <__udivdi3+0x7c>
  803e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803e48:	8d 47 ff             	lea    -0x1(%edi),%eax
  803e4b:	31 d2                	xor    %edx,%edx
  803e4d:	83 c4 0c             	add    $0xc,%esp
  803e50:	5e                   	pop    %esi
  803e51:	5f                   	pop    %edi
  803e52:	5d                   	pop    %ebp
  803e53:	c3                   	ret    
  803e54:	66 90                	xchg   %ax,%ax
  803e56:	66 90                	xchg   %ax,%ax
  803e58:	66 90                	xchg   %ax,%ax
  803e5a:	66 90                	xchg   %ax,%ax
  803e5c:	66 90                	xchg   %ax,%ax
  803e5e:	66 90                	xchg   %ax,%ax

00803e60 <__umoddi3>:
  803e60:	55                   	push   %ebp
  803e61:	57                   	push   %edi
  803e62:	56                   	push   %esi
  803e63:	83 ec 14             	sub    $0x14,%esp
  803e66:	8b 44 24 28          	mov    0x28(%esp),%eax
  803e6a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803e6e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803e72:	89 c7                	mov    %eax,%edi
  803e74:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e78:	8b 44 24 30          	mov    0x30(%esp),%eax
  803e7c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803e80:	89 34 24             	mov    %esi,(%esp)
  803e83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e87:	85 c0                	test   %eax,%eax
  803e89:	89 c2                	mov    %eax,%edx
  803e8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e8f:	75 17                	jne    803ea8 <__umoddi3+0x48>
  803e91:	39 fe                	cmp    %edi,%esi
  803e93:	76 4b                	jbe    803ee0 <__umoddi3+0x80>
  803e95:	89 c8                	mov    %ecx,%eax
  803e97:	89 fa                	mov    %edi,%edx
  803e99:	f7 f6                	div    %esi
  803e9b:	89 d0                	mov    %edx,%eax
  803e9d:	31 d2                	xor    %edx,%edx
  803e9f:	83 c4 14             	add    $0x14,%esp
  803ea2:	5e                   	pop    %esi
  803ea3:	5f                   	pop    %edi
  803ea4:	5d                   	pop    %ebp
  803ea5:	c3                   	ret    
  803ea6:	66 90                	xchg   %ax,%ax
  803ea8:	39 f8                	cmp    %edi,%eax
  803eaa:	77 54                	ja     803f00 <__umoddi3+0xa0>
  803eac:	0f bd e8             	bsr    %eax,%ebp
  803eaf:	83 f5 1f             	xor    $0x1f,%ebp
  803eb2:	75 5c                	jne    803f10 <__umoddi3+0xb0>
  803eb4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803eb8:	39 3c 24             	cmp    %edi,(%esp)
  803ebb:	0f 87 e7 00 00 00    	ja     803fa8 <__umoddi3+0x148>
  803ec1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803ec5:	29 f1                	sub    %esi,%ecx
  803ec7:	19 c7                	sbb    %eax,%edi
  803ec9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ecd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ed1:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ed5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803ed9:	83 c4 14             	add    $0x14,%esp
  803edc:	5e                   	pop    %esi
  803edd:	5f                   	pop    %edi
  803ede:	5d                   	pop    %ebp
  803edf:	c3                   	ret    
  803ee0:	85 f6                	test   %esi,%esi
  803ee2:	89 f5                	mov    %esi,%ebp
  803ee4:	75 0b                	jne    803ef1 <__umoddi3+0x91>
  803ee6:	b8 01 00 00 00       	mov    $0x1,%eax
  803eeb:	31 d2                	xor    %edx,%edx
  803eed:	f7 f6                	div    %esi
  803eef:	89 c5                	mov    %eax,%ebp
  803ef1:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ef5:	31 d2                	xor    %edx,%edx
  803ef7:	f7 f5                	div    %ebp
  803ef9:	89 c8                	mov    %ecx,%eax
  803efb:	f7 f5                	div    %ebp
  803efd:	eb 9c                	jmp    803e9b <__umoddi3+0x3b>
  803eff:	90                   	nop
  803f00:	89 c8                	mov    %ecx,%eax
  803f02:	89 fa                	mov    %edi,%edx
  803f04:	83 c4 14             	add    $0x14,%esp
  803f07:	5e                   	pop    %esi
  803f08:	5f                   	pop    %edi
  803f09:	5d                   	pop    %ebp
  803f0a:	c3                   	ret    
  803f0b:	90                   	nop
  803f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803f10:	8b 04 24             	mov    (%esp),%eax
  803f13:	be 20 00 00 00       	mov    $0x20,%esi
  803f18:	89 e9                	mov    %ebp,%ecx
  803f1a:	29 ee                	sub    %ebp,%esi
  803f1c:	d3 e2                	shl    %cl,%edx
  803f1e:	89 f1                	mov    %esi,%ecx
  803f20:	d3 e8                	shr    %cl,%eax
  803f22:	89 e9                	mov    %ebp,%ecx
  803f24:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f28:	8b 04 24             	mov    (%esp),%eax
  803f2b:	09 54 24 04          	or     %edx,0x4(%esp)
  803f2f:	89 fa                	mov    %edi,%edx
  803f31:	d3 e0                	shl    %cl,%eax
  803f33:	89 f1                	mov    %esi,%ecx
  803f35:	89 44 24 08          	mov    %eax,0x8(%esp)
  803f39:	8b 44 24 10          	mov    0x10(%esp),%eax
  803f3d:	d3 ea                	shr    %cl,%edx
  803f3f:	89 e9                	mov    %ebp,%ecx
  803f41:	d3 e7                	shl    %cl,%edi
  803f43:	89 f1                	mov    %esi,%ecx
  803f45:	d3 e8                	shr    %cl,%eax
  803f47:	89 e9                	mov    %ebp,%ecx
  803f49:	09 f8                	or     %edi,%eax
  803f4b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  803f4f:	f7 74 24 04          	divl   0x4(%esp)
  803f53:	d3 e7                	shl    %cl,%edi
  803f55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f59:	89 d7                	mov    %edx,%edi
  803f5b:	f7 64 24 08          	mull   0x8(%esp)
  803f5f:	39 d7                	cmp    %edx,%edi
  803f61:	89 c1                	mov    %eax,%ecx
  803f63:	89 14 24             	mov    %edx,(%esp)
  803f66:	72 2c                	jb     803f94 <__umoddi3+0x134>
  803f68:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  803f6c:	72 22                	jb     803f90 <__umoddi3+0x130>
  803f6e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803f72:	29 c8                	sub    %ecx,%eax
  803f74:	19 d7                	sbb    %edx,%edi
  803f76:	89 e9                	mov    %ebp,%ecx
  803f78:	89 fa                	mov    %edi,%edx
  803f7a:	d3 e8                	shr    %cl,%eax
  803f7c:	89 f1                	mov    %esi,%ecx
  803f7e:	d3 e2                	shl    %cl,%edx
  803f80:	89 e9                	mov    %ebp,%ecx
  803f82:	d3 ef                	shr    %cl,%edi
  803f84:	09 d0                	or     %edx,%eax
  803f86:	89 fa                	mov    %edi,%edx
  803f88:	83 c4 14             	add    $0x14,%esp
  803f8b:	5e                   	pop    %esi
  803f8c:	5f                   	pop    %edi
  803f8d:	5d                   	pop    %ebp
  803f8e:	c3                   	ret    
  803f8f:	90                   	nop
  803f90:	39 d7                	cmp    %edx,%edi
  803f92:	75 da                	jne    803f6e <__umoddi3+0x10e>
  803f94:	8b 14 24             	mov    (%esp),%edx
  803f97:	89 c1                	mov    %eax,%ecx
  803f99:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  803f9d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803fa1:	eb cb                	jmp    803f6e <__umoddi3+0x10e>
  803fa3:	90                   	nop
  803fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803fa8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  803fac:	0f 82 0f ff ff ff    	jb     803ec1 <__umoddi3+0x61>
  803fb2:	e9 1a ff ff ff       	jmp    803ed1 <__umoddi3+0x71>
