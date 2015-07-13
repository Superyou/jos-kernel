
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 d5 03 00 00       	call   800406 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80004b:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	eb 0c                	jmp    800063 <sum+0x23>
		tot ^= i * s[i];
  800057:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005b:	0f af ca             	imul   %edx,%ecx
  80005e:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800060:	83 c2 01             	add    $0x1,%edx
  800063:	39 da                	cmp    %ebx,%edx
  800065:	7c f0                	jl     800057 <sum+0x17>
		tot ^= i * s[i];
	return tot;
}
  800067:	5b                   	pop    %ebx
  800068:	5e                   	pop    %esi
  800069:	5d                   	pop    %ebp
  80006a:	c3                   	ret    

0080006b <umain>:

void
umain(int argc, char **argv)
{
  80006b:	55                   	push   %ebp
  80006c:	89 e5                	mov    %esp,%ebp
  80006e:	57                   	push   %edi
  80006f:	56                   	push   %esi
  800070:	53                   	push   %ebx
  800071:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  800077:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80007a:	c7 04 24 e0 2f 80 00 	movl   $0x802fe0,(%esp)
  800081:	e8 da 04 00 00       	call   800560 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800086:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  800095:	e8 a6 ff ff ff       	call   800040 <sum>
  80009a:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009f:	74 1a                	je     8000bb <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000a8:	00 
  8000a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ad:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  8000b4:	e8 a7 04 00 00       	call   800560 <cprintf>
  8000b9:	eb 0c                	jmp    8000c7 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000bb:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  8000c2:	e8 99 04 00 00       	call   800560 <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000c7:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000ce:	00 
  8000cf:	c7 04 24 20 60 80 00 	movl   $0x806020,(%esp)
  8000d6:	e8 65 ff ff ff       	call   800040 <sum>
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 12                	je     8000f1 <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e3:	c7 04 24 e0 30 80 00 	movl   $0x8030e0,(%esp)
  8000ea:	e8 71 04 00 00       	call   800560 <cprintf>
  8000ef:	eb 0c                	jmp    8000fd <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000f1:	c7 04 24 06 30 80 00 	movl   $0x803006,(%esp)
  8000f8:	e8 63 04 00 00       	call   800560 <cprintf>

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000fd:	c7 44 24 04 1c 30 80 	movl   $0x80301c,0x4(%esp)
  800104:	00 
  800105:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80010b:	89 04 24             	mov    %eax,(%esp)
  80010e:	e8 e4 0a 00 00       	call   800bf7 <strcat>
	for (i = 0; i < argc; i++) {
  800113:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  800118:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80011e:	eb 32                	jmp    800152 <umain+0xe7>
		strcat(args, " '");
  800120:	c7 44 24 04 28 30 80 	movl   $0x803028,0x4(%esp)
  800127:	00 
  800128:	89 34 24             	mov    %esi,(%esp)
  80012b:	e8 c7 0a 00 00       	call   800bf7 <strcat>
		strcat(args, argv[i]);
  800130:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800133:	89 44 24 04          	mov    %eax,0x4(%esp)
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 b8 0a 00 00       	call   800bf7 <strcat>
		strcat(args, "'");
  80013f:	c7 44 24 04 29 30 80 	movl   $0x803029,0x4(%esp)
  800146:	00 
  800147:	89 34 24             	mov    %esi,(%esp)
  80014a:	e8 a8 0a 00 00       	call   800bf7 <strcat>
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80014f:	83 c3 01             	add    $0x1,%ebx
  800152:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800155:	7c c9                	jl     800120 <umain+0xb5>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  800157:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	c7 04 24 15 35 80 00 	movl   $0x803515,(%esp)
  800168:	e8 f3 03 00 00       	call   800560 <cprintf>

	cprintf("init: running sh\n");
  80016d:	c7 04 24 2b 30 80 00 	movl   $0x80302b,(%esp)
  800174:	e8 e7 03 00 00       	call   800560 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800180:	e8 72 13 00 00       	call   8014f7 <close>
	if ((r = opencons()) < 0)
  800185:	e8 21 02 00 00       	call   8003ab <opencons>
  80018a:	85 c0                	test   %eax,%eax
  80018c:	79 20                	jns    8001ae <umain+0x143>
		panic("opencons: %e", r);
  80018e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800192:	c7 44 24 08 3d 30 80 	movl   $0x80303d,0x8(%esp)
  800199:	00 
  80019a:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8001a1:	00 
  8001a2:	c7 04 24 4a 30 80 00 	movl   $0x80304a,(%esp)
  8001a9:	e8 b9 02 00 00       	call   800467 <_panic>
	if (r != 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	74 20                	je     8001d2 <umain+0x167>
		panic("first opencons used fd %d", r);
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 56 30 80 	movl   $0x803056,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 4a 30 80 00 	movl   $0x80304a,(%esp)
  8001cd:	e8 95 02 00 00       	call   800467 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001d9:	00 
  8001da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e1:	e8 66 13 00 00       	call   80154c <dup>
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	79 20                	jns    80020a <umain+0x19f>
		panic("dup: %e", r);
  8001ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ee:	c7 44 24 08 70 30 80 	movl   $0x803070,0x8(%esp)
  8001f5:	00 
  8001f6:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  8001fd:	00 
  8001fe:	c7 04 24 4a 30 80 00 	movl   $0x80304a,(%esp)
  800205:	e8 5d 02 00 00       	call   800467 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  80020a:	c7 04 24 78 30 80 00 	movl   $0x803078,(%esp)
  800211:	e8 4a 03 00 00       	call   800560 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800216:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80021d:	00 
  80021e:	c7 44 24 04 8c 30 80 	movl   $0x80308c,0x4(%esp)
  800225:	00 
  800226:	c7 04 24 8b 30 80 00 	movl   $0x80308b,(%esp)
  80022d:	e8 50 20 00 00       	call   802282 <spawnl>
		if (r < 0) {
  800232:	85 c0                	test   %eax,%eax
  800234:	79 12                	jns    800248 <umain+0x1dd>
			cprintf("init: spawn sh: %e\n", r);
  800236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023a:	c7 04 24 8f 30 80 00 	movl   $0x80308f,(%esp)
  800241:	e8 1a 03 00 00       	call   800560 <cprintf>
			continue;
  800246:	eb c2                	jmp    80020a <umain+0x19f>
		}
		wait(r);
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	e8 3a 29 00 00       	call   802b8a <wait>
  800250:	eb b8                	jmp    80020a <umain+0x19f>
  800252:	66 90                	xchg   %ax,%ax
  800254:	66 90                	xchg   %ax,%ax
  800256:	66 90                	xchg   %ax,%ax
  800258:	66 90                	xchg   %ax,%ax
  80025a:	66 90                	xchg   %ax,%ax
  80025c:	66 90                	xchg   %ax,%ax
  80025e:	66 90                	xchg   %ax,%ax

00800260 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800263:	b8 00 00 00 00       	mov    $0x0,%eax
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800270:	c7 44 24 04 0f 31 80 	movl   $0x80310f,0x4(%esp)
  800277:	00 
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	e8 54 09 00 00       	call   800bd7 <strcpy>
	return 0;
}
  800283:	b8 00 00 00 00       	mov    $0x0,%eax
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800296:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80029b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002a1:	eb 31                	jmp    8002d4 <devcons_write+0x4a>
		m = n - tot;
  8002a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8002a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8002a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8002ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8002b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002b7:	03 45 0c             	add    0xc(%ebp),%eax
  8002ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002be:	89 3c 24             	mov    %edi,(%esp)
  8002c1:	e8 ae 0a 00 00       	call   800d74 <memmove>
		sys_cputs(buf, m);
  8002c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ca:	89 3c 24             	mov    %edi,(%esp)
  8002cd:	e8 54 0c 00 00       	call   800f26 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002d2:	01 f3                	add    %esi,%ebx
  8002d4:	89 d8                	mov    %ebx,%eax
  8002d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8002d9:	72 c8                	jb     8002a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8002ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8002f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002f5:	75 07                	jne    8002fe <devcons_read+0x18>
  8002f7:	eb 2a                	jmp    800323 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8002f9:	e8 28 0d 00 00       	call   801026 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8002fe:	66 90                	xchg   %ax,%ax
  800300:	e8 3f 0c 00 00       	call   800f44 <sys_cgetc>
  800305:	85 c0                	test   %eax,%eax
  800307:	74 f0                	je     8002f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800309:	85 c0                	test   %eax,%eax
  80030b:	78 16                	js     800323 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80030d:	83 f8 04             	cmp    $0x4,%eax
  800310:	74 0c                	je     80031e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800312:	8b 55 0c             	mov    0xc(%ebp),%edx
  800315:	88 02                	mov    %al,(%edx)
	return 1;
  800317:	b8 01 00 00 00       	mov    $0x1,%eax
  80031c:	eb 05                	jmp    800323 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800331:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800338:	00 
  800339:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80033c:	89 04 24             	mov    %eax,(%esp)
  80033f:	e8 e2 0b 00 00       	call   800f26 <sys_cputs>
}
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <getchar>:

int
getchar(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80034c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800353:	00 
  800354:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800362:	e8 f3 12 00 00       	call   80165a <read>
	if (r < 0)
  800367:	85 c0                	test   %eax,%eax
  800369:	78 0f                	js     80037a <getchar+0x34>
		return r;
	if (r < 1)
  80036b:	85 c0                	test   %eax,%eax
  80036d:	7e 06                	jle    800375 <getchar+0x2f>
		return -E_EOF;
	return c;
  80036f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800373:	eb 05                	jmp    80037a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800375:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800382:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800385:	89 44 24 04          	mov    %eax,0x4(%esp)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	89 04 24             	mov    %eax,(%esp)
  80038f:	e8 32 10 00 00       	call   8013c6 <fd_lookup>
  800394:	85 c0                	test   %eax,%eax
  800396:	78 11                	js     8003a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80039b:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003a1:	39 10                	cmp    %edx,(%eax)
  8003a3:	0f 94 c0             	sete   %al
  8003a6:	0f b6 c0             	movzbl %al,%eax
}
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <opencons>:

int
opencons(void)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8003b4:	89 04 24             	mov    %eax,(%esp)
  8003b7:	e8 bb 0f 00 00       	call   801377 <fd_alloc>
		return r;
  8003bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003be:	85 c0                	test   %eax,%eax
  8003c0:	78 40                	js     800402 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8003c9:	00 
  8003ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003d8:	e8 68 0c 00 00       	call   801045 <sys_page_alloc>
		return r;
  8003dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	78 1f                	js     800402 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8003e3:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	e8 50 0f 00 00       	call   801350 <fd2num>
  800400:	89 c2                	mov    %eax,%edx
}
  800402:	89 d0                	mov    %edx,%eax
  800404:	c9                   	leave  
  800405:	c3                   	ret    

00800406 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	56                   	push   %esi
  80040a:	53                   	push   %ebx
  80040b:	83 ec 10             	sub    $0x10,%esp
  80040e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800411:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800414:	e8 ee 0b 00 00       	call   801007 <sys_getenvid>
  800419:	25 ff 03 00 00       	and    $0x3ff,%eax
  80041e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800421:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800426:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80042b:	85 db                	test   %ebx,%ebx
  80042d:	7e 07                	jle    800436 <libmain+0x30>
		binaryname = argv[0];
  80042f:	8b 06                	mov    (%esi),%eax
  800431:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  800436:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043a:	89 1c 24             	mov    %ebx,(%esp)
  80043d:	e8 29 fc ff ff       	call   80006b <umain>

	// exit gracefully
	exit();
  800442:	e8 07 00 00 00       	call   80044e <exit>
}
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	5b                   	pop    %ebx
  80044b:	5e                   	pop    %esi
  80044c:	5d                   	pop    %ebp
  80044d:	c3                   	ret    

0080044e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800454:	e8 d1 10 00 00       	call   80152a <close_all>
	sys_env_destroy(0);
  800459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800460:	e8 fe 0a 00 00       	call   800f63 <sys_env_destroy>
}
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	56                   	push   %esi
  80046b:	53                   	push   %ebx
  80046c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80046f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800472:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  800478:	e8 8a 0b 00 00       	call   801007 <sys_getenvid>
  80047d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800480:	89 54 24 10          	mov    %edx,0x10(%esp)
  800484:	8b 55 08             	mov    0x8(%ebp),%edx
  800487:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80048f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800493:	c7 04 24 28 31 80 00 	movl   $0x803128,(%esp)
  80049a:	e8 c1 00 00 00       	call   800560 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80049f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a6:	89 04 24             	mov    %eax,(%esp)
  8004a9:	e8 51 00 00 00       	call   8004ff <vcprintf>
	cprintf("\n");
  8004ae:	c7 04 24 63 35 80 00 	movl   $0x803563,(%esp)
  8004b5:	e8 a6 00 00 00       	call   800560 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ba:	cc                   	int3   
  8004bb:	eb fd                	jmp    8004ba <_panic+0x53>

008004bd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	53                   	push   %ebx
  8004c1:	83 ec 14             	sub    $0x14,%esp
  8004c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004c7:	8b 13                	mov    (%ebx),%edx
  8004c9:	8d 42 01             	lea    0x1(%edx),%eax
  8004cc:	89 03                	mov    %eax,(%ebx)
  8004ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004d1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 19                	jne    8004f5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8004dc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8004e3:	00 
  8004e4:	8d 43 08             	lea    0x8(%ebx),%eax
  8004e7:	89 04 24             	mov    %eax,(%esp)
  8004ea:	e8 37 0a 00 00       	call   800f26 <sys_cputs>
		b->idx = 0;
  8004ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8004f5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8004f9:	83 c4 14             	add    $0x14,%esp
  8004fc:	5b                   	pop    %ebx
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	89 44 24 08          	mov    %eax,0x8(%esp)
  80052a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800530:	89 44 24 04          	mov    %eax,0x4(%esp)
  800534:	c7 04 24 bd 04 80 00 	movl   $0x8004bd,(%esp)
  80053b:	e8 74 01 00 00       	call   8006b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800540:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800550:	89 04 24             	mov    %eax,(%esp)
  800553:	e8 ce 09 00 00       	call   800f26 <sys_cputs>

	return b.cnt;
}
  800558:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800566:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	89 04 24             	mov    %eax,(%esp)
  800573:	e8 87 ff ff ff       	call   8004ff <vcprintf>
	va_end(ap);

	return cnt;
}
  800578:	c9                   	leave  
  800579:	c3                   	ret    
  80057a:	66 90                	xchg   %ax,%ax
  80057c:	66 90                	xchg   %ax,%ax
  80057e:	66 90                	xchg   %ax,%ax

00800580 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 3c             	sub    $0x3c,%esp
  800589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058c:	89 d7                	mov    %edx,%edi
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	89 c3                	mov    %eax,%ebx
  800599:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80059c:	8b 45 10             	mov    0x10(%ebp),%eax
  80059f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ad:	39 d9                	cmp    %ebx,%ecx
  8005af:	72 05                	jb     8005b6 <printnum+0x36>
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	77 69                	ja     80061f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8005bd:	83 ee 01             	sub    $0x1,%esi
  8005c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8005c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8005cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8005d0:	89 c3                	mov    %eax,%ebx
  8005d2:	89 d6                	mov    %edx,%esi
  8005d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8005e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e5:	89 04 24             	mov    %eax,(%esp)
  8005e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ef:	e8 4c 27 00 00       	call   802d40 <__udivdi3>
  8005f4:	89 d9                	mov    %ebx,%ecx
  8005f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	89 54 24 04          	mov    %edx,0x4(%esp)
  800605:	89 fa                	mov    %edi,%edx
  800607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060a:	e8 71 ff ff ff       	call   800580 <printnum>
  80060f:	eb 1b                	jmp    80062c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800611:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800615:	8b 45 18             	mov    0x18(%ebp),%eax
  800618:	89 04 24             	mov    %eax,(%esp)
  80061b:	ff d3                	call   *%ebx
  80061d:	eb 03                	jmp    800622 <printnum+0xa2>
  80061f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800622:	83 ee 01             	sub    $0x1,%esi
  800625:	85 f6                	test   %esi,%esi
  800627:	7f e8                	jg     800611 <printnum+0x91>
  800629:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80062c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800630:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800634:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800637:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80063a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80063e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800645:	89 04 24             	mov    %eax,(%esp)
  800648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064f:	e8 1c 28 00 00       	call   802e70 <__umoddi3>
  800654:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800658:	0f be 80 4b 31 80 00 	movsbl 0x80314b(%eax),%eax
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800665:	ff d0                	call   *%eax
}
  800667:	83 c4 3c             	add    $0x3c,%esp
  80066a:	5b                   	pop    %ebx
  80066b:	5e                   	pop    %esi
  80066c:	5f                   	pop    %edi
  80066d:	5d                   	pop    %ebp
  80066e:	c3                   	ret    

0080066f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800675:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800679:	8b 10                	mov    (%eax),%edx
  80067b:	3b 50 04             	cmp    0x4(%eax),%edx
  80067e:	73 0a                	jae    80068a <sprintputch+0x1b>
		*b->buf++ = ch;
  800680:	8d 4a 01             	lea    0x1(%edx),%ecx
  800683:	89 08                	mov    %ecx,(%eax)
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	88 02                	mov    %al,(%edx)
}
  80068a:	5d                   	pop    %ebp
  80068b:	c3                   	ret    

0080068c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80068c:	55                   	push   %ebp
  80068d:	89 e5                	mov    %esp,%ebp
  80068f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800692:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800695:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800699:	8b 45 10             	mov    0x10(%ebp),%eax
  80069c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	89 04 24             	mov    %eax,(%esp)
  8006ad:	e8 02 00 00 00       	call   8006b4 <vprintfmt>
	va_end(ap);
}
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	57                   	push   %edi
  8006b8:	56                   	push   %esi
  8006b9:	53                   	push   %ebx
  8006ba:	83 ec 3c             	sub    $0x3c,%esp
  8006bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006c0:	eb 17                	jmp    8006d9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8006c2:	85 c0                	test   %eax,%eax
  8006c4:	0f 84 4b 04 00 00    	je     800b15 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8006ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006d1:	89 04 24             	mov    %eax,(%esp)
  8006d4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8006d7:	89 fb                	mov    %edi,%ebx
  8006d9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8006dc:	0f b6 03             	movzbl (%ebx),%eax
  8006df:	83 f8 25             	cmp    $0x25,%eax
  8006e2:	75 de                	jne    8006c2 <vprintfmt+0xe>
  8006e4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8006e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8006f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8006fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800700:	eb 18                	jmp    80071a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800702:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800704:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800708:	eb 10                	jmp    80071a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80070a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80070c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800710:	eb 08                	jmp    80071a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800712:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800715:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80071d:	0f b6 17             	movzbl (%edi),%edx
  800720:	0f b6 c2             	movzbl %dl,%eax
  800723:	83 ea 23             	sub    $0x23,%edx
  800726:	80 fa 55             	cmp    $0x55,%dl
  800729:	0f 87 c2 03 00 00    	ja     800af1 <vprintfmt+0x43d>
  80072f:	0f b6 d2             	movzbl %dl,%edx
  800732:	ff 24 95 80 32 80 00 	jmp    *0x803280(,%edx,4)
  800739:	89 df                	mov    %ebx,%edi
  80073b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800740:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800743:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800747:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80074a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80074d:	83 fa 09             	cmp    $0x9,%edx
  800750:	77 33                	ja     800785 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800752:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800755:	eb e9                	jmp    800740 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 30                	mov    (%eax),%esi
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800762:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800764:	eb 1f                	jmp    800785 <vprintfmt+0xd1>
  800766:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800769:	85 ff                	test   %edi,%edi
  80076b:	b8 00 00 00 00       	mov    $0x0,%eax
  800770:	0f 49 c7             	cmovns %edi,%eax
  800773:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800776:	89 df                	mov    %ebx,%edi
  800778:	eb a0                	jmp    80071a <vprintfmt+0x66>
  80077a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80077c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800783:	eb 95                	jmp    80071a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 8f                	jns    80071a <vprintfmt+0x66>
  80078b:	eb 85                	jmp    800712 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80078d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800790:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800792:	eb 86                	jmp    80071a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 70 04             	lea    0x4(%eax),%esi
  80079a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	89 04 24             	mov    %eax,(%esp)
  8007a9:	ff 55 08             	call   *0x8(%ebp)
  8007ac:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8007af:	e9 25 ff ff ff       	jmp    8006d9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8d 70 04             	lea    0x4(%eax),%esi
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	99                   	cltd   
  8007bd:	31 d0                	xor    %edx,%eax
  8007bf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007c1:	83 f8 15             	cmp    $0x15,%eax
  8007c4:	7f 0b                	jg     8007d1 <vprintfmt+0x11d>
  8007c6:	8b 14 85 e0 33 80 00 	mov    0x8033e0(,%eax,4),%edx
  8007cd:	85 d2                	test   %edx,%edx
  8007cf:	75 26                	jne    8007f7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8007d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d5:	c7 44 24 08 63 31 80 	movl   $0x803163,0x8(%esp)
  8007dc:	00 
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	89 04 24             	mov    %eax,(%esp)
  8007ea:	e8 9d fe ff ff       	call   80068c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007ef:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8007f2:	e9 e2 fe ff ff       	jmp    8006d9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8007f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007fb:	c7 44 24 08 32 35 80 	movl   $0x803532,0x8(%esp)
  800802:	00 
  800803:	8b 45 0c             	mov    0xc(%ebp),%eax
  800806:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	89 04 24             	mov    %eax,(%esp)
  800810:	e8 77 fe ff ff       	call   80068c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800815:	89 75 14             	mov    %esi,0x14(%ebp)
  800818:	e9 bc fe ff ff       	jmp    8006d9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800823:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800826:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80082a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80082c:	85 ff                	test   %edi,%edi
  80082e:	b8 5c 31 80 00       	mov    $0x80315c,%eax
  800833:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800836:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80083a:	0f 84 94 00 00 00    	je     8008d4 <vprintfmt+0x220>
  800840:	85 c9                	test   %ecx,%ecx
  800842:	0f 8e 94 00 00 00    	jle    8008dc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800848:	89 74 24 04          	mov    %esi,0x4(%esp)
  80084c:	89 3c 24             	mov    %edi,(%esp)
  80084f:	e8 64 03 00 00       	call   800bb8 <strnlen>
  800854:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800857:	29 c1                	sub    %eax,%ecx
  800859:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80085c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800860:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800863:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800866:	8b 75 08             	mov    0x8(%ebp),%esi
  800869:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80086c:	89 cb                	mov    %ecx,%ebx
  80086e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800870:	eb 0f                	jmp    800881 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800872:	8b 45 0c             	mov    0xc(%ebp),%eax
  800875:	89 44 24 04          	mov    %eax,0x4(%esp)
  800879:	89 3c 24             	mov    %edi,(%esp)
  80087c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80087e:	83 eb 01             	sub    $0x1,%ebx
  800881:	85 db                	test   %ebx,%ebx
  800883:	7f ed                	jg     800872 <vprintfmt+0x1be>
  800885:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800888:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80088b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80088e:	85 c9                	test   %ecx,%ecx
  800890:	b8 00 00 00 00       	mov    $0x0,%eax
  800895:	0f 49 c1             	cmovns %ecx,%eax
  800898:	29 c1                	sub    %eax,%ecx
  80089a:	89 cb                	mov    %ecx,%ebx
  80089c:	eb 44                	jmp    8008e2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	74 1e                	je     8008c2 <vprintfmt+0x20e>
  8008a4:	0f be d2             	movsbl %dl,%edx
  8008a7:	83 ea 20             	sub    $0x20,%edx
  8008aa:	83 fa 5e             	cmp    $0x5e,%edx
  8008ad:	76 13                	jbe    8008c2 <vprintfmt+0x20e>
					putch('?', putdat);
  8008af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008bd:	ff 55 08             	call   *0x8(%ebp)
  8008c0:	eb 0d                	jmp    8008cf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8008c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008c9:	89 04 24             	mov    %eax,(%esp)
  8008cc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cf:	83 eb 01             	sub    $0x1,%ebx
  8008d2:	eb 0e                	jmp    8008e2 <vprintfmt+0x22e>
  8008d4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008d7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8008da:	eb 06                	jmp    8008e2 <vprintfmt+0x22e>
  8008dc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008df:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8008e2:	83 c7 01             	add    $0x1,%edi
  8008e5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008e9:	0f be c2             	movsbl %dl,%eax
  8008ec:	85 c0                	test   %eax,%eax
  8008ee:	74 27                	je     800917 <vprintfmt+0x263>
  8008f0:	85 f6                	test   %esi,%esi
  8008f2:	78 aa                	js     80089e <vprintfmt+0x1ea>
  8008f4:	83 ee 01             	sub    $0x1,%esi
  8008f7:	79 a5                	jns    80089e <vprintfmt+0x1ea>
  8008f9:	89 d8                	mov    %ebx,%eax
  8008fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800901:	89 c3                	mov    %eax,%ebx
  800903:	eb 18                	jmp    80091d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800905:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800909:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800910:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800912:	83 eb 01             	sub    $0x1,%ebx
  800915:	eb 06                	jmp    80091d <vprintfmt+0x269>
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80091d:	85 db                	test   %ebx,%ebx
  80091f:	7f e4                	jg     800905 <vprintfmt+0x251>
  800921:	89 75 08             	mov    %esi,0x8(%ebp)
  800924:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800927:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80092a:	e9 aa fd ff ff       	jmp    8006d9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80092f:	83 f9 01             	cmp    $0x1,%ecx
  800932:	7e 10                	jle    800944 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8b 30                	mov    (%eax),%esi
  800939:	8b 78 04             	mov    0x4(%eax),%edi
  80093c:	8d 40 08             	lea    0x8(%eax),%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	eb 26                	jmp    80096a <vprintfmt+0x2b6>
	else if (lflag)
  800944:	85 c9                	test   %ecx,%ecx
  800946:	74 12                	je     80095a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8b 30                	mov    (%eax),%esi
  80094d:	89 f7                	mov    %esi,%edi
  80094f:	c1 ff 1f             	sar    $0x1f,%edi
  800952:	8d 40 04             	lea    0x4(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	eb 10                	jmp    80096a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	8b 30                	mov    (%eax),%esi
  80095f:	89 f7                	mov    %esi,%edi
  800961:	c1 ff 1f             	sar    $0x1f,%edi
  800964:	8d 40 04             	lea    0x4(%eax),%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80096a:	89 f0                	mov    %esi,%eax
  80096c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80096e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800973:	85 ff                	test   %edi,%edi
  800975:	0f 89 3a 01 00 00    	jns    800ab5 <vprintfmt+0x401>
				putch('-', putdat);
  80097b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800982:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800989:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80098c:	89 f0                	mov    %esi,%eax
  80098e:	89 fa                	mov    %edi,%edx
  800990:	f7 d8                	neg    %eax
  800992:	83 d2 00             	adc    $0x0,%edx
  800995:	f7 da                	neg    %edx
			}
			base = 10;
  800997:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80099c:	e9 14 01 00 00       	jmp    800ab5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8009a1:	83 f9 01             	cmp    $0x1,%ecx
  8009a4:	7e 13                	jle    8009b9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	8b 50 04             	mov    0x4(%eax),%edx
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	8b 75 14             	mov    0x14(%ebp),%esi
  8009b1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8009b4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8009b7:	eb 2c                	jmp    8009e5 <vprintfmt+0x331>
	else if (lflag)
  8009b9:	85 c9                	test   %ecx,%ecx
  8009bb:	74 15                	je     8009d2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	8b 75 14             	mov    0x14(%ebp),%esi
  8009ca:	8d 76 04             	lea    0x4(%esi),%esi
  8009cd:	89 75 14             	mov    %esi,0x14(%ebp)
  8009d0:	eb 13                	jmp    8009e5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009dc:	8b 75 14             	mov    0x14(%ebp),%esi
  8009df:	8d 76 04             	lea    0x4(%esi),%esi
  8009e2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8009e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8009ea:	e9 c6 00 00 00       	jmp    800ab5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8009ef:	83 f9 01             	cmp    $0x1,%ecx
  8009f2:	7e 13                	jle    800a07 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	8b 50 04             	mov    0x4(%eax),%edx
  8009fa:	8b 00                	mov    (%eax),%eax
  8009fc:	8b 75 14             	mov    0x14(%ebp),%esi
  8009ff:	8d 4e 08             	lea    0x8(%esi),%ecx
  800a02:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800a05:	eb 24                	jmp    800a2b <vprintfmt+0x377>
	else if (lflag)
  800a07:	85 c9                	test   %ecx,%ecx
  800a09:	74 11                	je     800a1c <vprintfmt+0x368>
		return va_arg(*ap, long);
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	99                   	cltd   
  800a11:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800a14:	8d 71 04             	lea    0x4(%ecx),%esi
  800a17:	89 75 14             	mov    %esi,0x14(%ebp)
  800a1a:	eb 0f                	jmp    800a2b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	99                   	cltd   
  800a22:	8b 75 14             	mov    0x14(%ebp),%esi
  800a25:	8d 76 04             	lea    0x4(%esi),%esi
  800a28:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  800a2b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800a30:	e9 80 00 00 00       	jmp    800ab5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a35:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a46:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a50:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a57:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a5a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a5e:	8b 06                	mov    (%esi),%eax
  800a60:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a65:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800a6a:	eb 49                	jmp    800ab5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a6c:	83 f9 01             	cmp    $0x1,%ecx
  800a6f:	7e 13                	jle    800a84 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	8b 50 04             	mov    0x4(%eax),%edx
  800a77:	8b 00                	mov    (%eax),%eax
  800a79:	8b 75 14             	mov    0x14(%ebp),%esi
  800a7c:	8d 4e 08             	lea    0x8(%esi),%ecx
  800a7f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800a82:	eb 2c                	jmp    800ab0 <vprintfmt+0x3fc>
	else if (lflag)
  800a84:	85 c9                	test   %ecx,%ecx
  800a86:	74 15                	je     800a9d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	8b 00                	mov    (%eax),%eax
  800a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a92:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800a95:	8d 71 04             	lea    0x4(%ecx),%esi
  800a98:	89 75 14             	mov    %esi,0x14(%ebp)
  800a9b:	eb 13                	jmp    800ab0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	8b 00                	mov    (%eax),%eax
  800aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa7:	8b 75 14             	mov    0x14(%ebp),%esi
  800aaa:	8d 76 04             	lea    0x4(%esi),%esi
  800aad:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800ab0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ab5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800ab9:	89 74 24 10          	mov    %esi,0x10(%esp)
  800abd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800ac0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800ac4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ac8:	89 04 24             	mov    %eax,(%esp)
  800acb:	89 54 24 04          	mov    %edx,0x4(%esp)
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	e8 a6 fa ff ff       	call   800580 <printnum>
			break;
  800ada:	e9 fa fb ff ff       	jmp    8006d9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800adf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ae6:	89 04 24             	mov    %eax,(%esp)
  800ae9:	ff 55 08             	call   *0x8(%ebp)
			break;
  800aec:	e9 e8 fb ff ff       	jmp    8006d9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800aff:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b02:	89 fb                	mov    %edi,%ebx
  800b04:	eb 03                	jmp    800b09 <vprintfmt+0x455>
  800b06:	83 eb 01             	sub    $0x1,%ebx
  800b09:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800b0d:	75 f7                	jne    800b06 <vprintfmt+0x452>
  800b0f:	90                   	nop
  800b10:	e9 c4 fb ff ff       	jmp    8006d9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800b15:	83 c4 3c             	add    $0x3c,%esp
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5f                   	pop    %edi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 28             	sub    $0x28,%esp
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b30:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b3a:	85 c0                	test   %eax,%eax
  800b3c:	74 30                	je     800b6e <vsnprintf+0x51>
  800b3e:	85 d2                	test   %edx,%edx
  800b40:	7e 2c                	jle    800b6e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b42:	8b 45 14             	mov    0x14(%ebp),%eax
  800b45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b49:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b57:	c7 04 24 6f 06 80 00 	movl   $0x80066f,(%esp)
  800b5e:	e8 51 fb ff ff       	call   8006b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b6c:	eb 05                	jmp    800b73 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800b6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b7b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b82:	8b 45 10             	mov    0x10(%ebp),%eax
  800b85:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	89 04 24             	mov    %eax,(%esp)
  800b96:	e8 82 ff ff ff       	call   800b1d <vsnprintf>
	va_end(ap);

	return rc;
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    
  800b9d:	66 90                	xchg   %ax,%ax
  800b9f:	90                   	nop

00800ba0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bab:	eb 03                	jmp    800bb0 <strlen+0x10>
		n++;
  800bad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bb4:	75 f7                	jne    800bad <strlen+0xd>
		n++;
	return n;
}
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc6:	eb 03                	jmp    800bcb <strnlen+0x13>
		n++;
  800bc8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcb:	39 d0                	cmp    %edx,%eax
  800bcd:	74 06                	je     800bd5 <strnlen+0x1d>
  800bcf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800bd3:	75 f3                	jne    800bc8 <strnlen+0x10>
		n++;
	return n;
}
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	53                   	push   %ebx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800be1:	89 c2                	mov    %eax,%edx
  800be3:	83 c2 01             	add    $0x1,%edx
  800be6:	83 c1 01             	add    $0x1,%ecx
  800be9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800bed:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bf0:	84 db                	test   %bl,%bl
  800bf2:	75 ef                	jne    800be3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	53                   	push   %ebx
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c01:	89 1c 24             	mov    %ebx,(%esp)
  800c04:	e8 97 ff ff ff       	call   800ba0 <strlen>
	strcpy(dst + len, src);
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c10:	01 d8                	add    %ebx,%eax
  800c12:	89 04 24             	mov    %eax,(%esp)
  800c15:	e8 bd ff ff ff       	call   800bd7 <strcpy>
	return dst;
}
  800c1a:	89 d8                	mov    %ebx,%eax
  800c1c:	83 c4 08             	add    $0x8,%esp
  800c1f:	5b                   	pop    %ebx
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
  800c27:	8b 75 08             	mov    0x8(%ebp),%esi
  800c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2d:	89 f3                	mov    %esi,%ebx
  800c2f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c32:	89 f2                	mov    %esi,%edx
  800c34:	eb 0f                	jmp    800c45 <strncpy+0x23>
		*dst++ = *src;
  800c36:	83 c2 01             	add    $0x1,%edx
  800c39:	0f b6 01             	movzbl (%ecx),%eax
  800c3c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c3f:	80 39 01             	cmpb   $0x1,(%ecx)
  800c42:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c45:	39 da                	cmp    %ebx,%edx
  800c47:	75 ed                	jne    800c36 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c49:	89 f0                	mov    %esi,%eax
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	8b 75 08             	mov    0x8(%ebp),%esi
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c5d:	89 f0                	mov    %esi,%eax
  800c5f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c63:	85 c9                	test   %ecx,%ecx
  800c65:	75 0b                	jne    800c72 <strlcpy+0x23>
  800c67:	eb 1d                	jmp    800c86 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c69:	83 c0 01             	add    $0x1,%eax
  800c6c:	83 c2 01             	add    $0x1,%edx
  800c6f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c72:	39 d8                	cmp    %ebx,%eax
  800c74:	74 0b                	je     800c81 <strlcpy+0x32>
  800c76:	0f b6 0a             	movzbl (%edx),%ecx
  800c79:	84 c9                	test   %cl,%cl
  800c7b:	75 ec                	jne    800c69 <strlcpy+0x1a>
  800c7d:	89 c2                	mov    %eax,%edx
  800c7f:	eb 02                	jmp    800c83 <strlcpy+0x34>
  800c81:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800c83:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800c86:	29 f0                	sub    %esi,%eax
}
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c92:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c95:	eb 06                	jmp    800c9d <strcmp+0x11>
		p++, q++;
  800c97:	83 c1 01             	add    $0x1,%ecx
  800c9a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c9d:	0f b6 01             	movzbl (%ecx),%eax
  800ca0:	84 c0                	test   %al,%al
  800ca2:	74 04                	je     800ca8 <strcmp+0x1c>
  800ca4:	3a 02                	cmp    (%edx),%al
  800ca6:	74 ef                	je     800c97 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca8:	0f b6 c0             	movzbl %al,%eax
  800cab:	0f b6 12             	movzbl (%edx),%edx
  800cae:	29 d0                	sub    %edx,%eax
}
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    

00800cb2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	89 c3                	mov    %eax,%ebx
  800cbe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cc1:	eb 06                	jmp    800cc9 <strncmp+0x17>
		n--, p++, q++;
  800cc3:	83 c0 01             	add    $0x1,%eax
  800cc6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800cc9:	39 d8                	cmp    %ebx,%eax
  800ccb:	74 15                	je     800ce2 <strncmp+0x30>
  800ccd:	0f b6 08             	movzbl (%eax),%ecx
  800cd0:	84 c9                	test   %cl,%cl
  800cd2:	74 04                	je     800cd8 <strncmp+0x26>
  800cd4:	3a 0a                	cmp    (%edx),%cl
  800cd6:	74 eb                	je     800cc3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd8:	0f b6 00             	movzbl (%eax),%eax
  800cdb:	0f b6 12             	movzbl (%edx),%edx
  800cde:	29 d0                	sub    %edx,%eax
  800ce0:	eb 05                	jmp    800ce7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ce2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ce7:	5b                   	pop    %ebx
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf4:	eb 07                	jmp    800cfd <strchr+0x13>
		if (*s == c)
  800cf6:	38 ca                	cmp    %cl,%dl
  800cf8:	74 0f                	je     800d09 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cfa:	83 c0 01             	add    $0x1,%eax
  800cfd:	0f b6 10             	movzbl (%eax),%edx
  800d00:	84 d2                	test   %dl,%dl
  800d02:	75 f2                	jne    800cf6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d15:	eb 07                	jmp    800d1e <strfind+0x13>
		if (*s == c)
  800d17:	38 ca                	cmp    %cl,%dl
  800d19:	74 0a                	je     800d25 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d1b:	83 c0 01             	add    $0x1,%eax
  800d1e:	0f b6 10             	movzbl (%eax),%edx
  800d21:	84 d2                	test   %dl,%dl
  800d23:	75 f2                	jne    800d17 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d33:	85 c9                	test   %ecx,%ecx
  800d35:	74 36                	je     800d6d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d37:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d3d:	75 28                	jne    800d67 <memset+0x40>
  800d3f:	f6 c1 03             	test   $0x3,%cl
  800d42:	75 23                	jne    800d67 <memset+0x40>
		c &= 0xFF;
  800d44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d48:	89 d3                	mov    %edx,%ebx
  800d4a:	c1 e3 08             	shl    $0x8,%ebx
  800d4d:	89 d6                	mov    %edx,%esi
  800d4f:	c1 e6 18             	shl    $0x18,%esi
  800d52:	89 d0                	mov    %edx,%eax
  800d54:	c1 e0 10             	shl    $0x10,%eax
  800d57:	09 f0                	or     %esi,%eax
  800d59:	09 c2                	or     %eax,%edx
  800d5b:	89 d0                	mov    %edx,%eax
  800d5d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d5f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d62:	fc                   	cld    
  800d63:	f3 ab                	rep stos %eax,%es:(%edi)
  800d65:	eb 06                	jmp    800d6d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	fc                   	cld    
  800d6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d6d:	89 f8                	mov    %edi,%eax
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d82:	39 c6                	cmp    %eax,%esi
  800d84:	73 35                	jae    800dbb <memmove+0x47>
  800d86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d89:	39 d0                	cmp    %edx,%eax
  800d8b:	73 2e                	jae    800dbb <memmove+0x47>
		s += n;
		d += n;
  800d8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800d90:	89 d6                	mov    %edx,%esi
  800d92:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d94:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d9a:	75 13                	jne    800daf <memmove+0x3b>
  800d9c:	f6 c1 03             	test   $0x3,%cl
  800d9f:	75 0e                	jne    800daf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800da1:	83 ef 04             	sub    $0x4,%edi
  800da4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800da7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800daa:	fd                   	std    
  800dab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dad:	eb 09                	jmp    800db8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800daf:	83 ef 01             	sub    $0x1,%edi
  800db2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800db5:	fd                   	std    
  800db6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800db8:	fc                   	cld    
  800db9:	eb 1d                	jmp    800dd8 <memmove+0x64>
  800dbb:	89 f2                	mov    %esi,%edx
  800dbd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dbf:	f6 c2 03             	test   $0x3,%dl
  800dc2:	75 0f                	jne    800dd3 <memmove+0x5f>
  800dc4:	f6 c1 03             	test   $0x3,%cl
  800dc7:	75 0a                	jne    800dd3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dc9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800dcc:	89 c7                	mov    %eax,%edi
  800dce:	fc                   	cld    
  800dcf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dd1:	eb 05                	jmp    800dd8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800dd3:	89 c7                	mov    %eax,%edi
  800dd5:	fc                   	cld    
  800dd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 04 24             	mov    %eax,(%esp)
  800df6:	e8 79 ff ff ff       	call   800d74 <memmove>
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e08:	89 d6                	mov    %edx,%esi
  800e0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e0d:	eb 1a                	jmp    800e29 <memcmp+0x2c>
		if (*s1 != *s2)
  800e0f:	0f b6 02             	movzbl (%edx),%eax
  800e12:	0f b6 19             	movzbl (%ecx),%ebx
  800e15:	38 d8                	cmp    %bl,%al
  800e17:	74 0a                	je     800e23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800e19:	0f b6 c0             	movzbl %al,%eax
  800e1c:	0f b6 db             	movzbl %bl,%ebx
  800e1f:	29 d8                	sub    %ebx,%eax
  800e21:	eb 0f                	jmp    800e32 <memcmp+0x35>
		s1++, s2++;
  800e23:	83 c2 01             	add    $0x1,%edx
  800e26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e29:	39 f2                	cmp    %esi,%edx
  800e2b:	75 e2                	jne    800e0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e44:	eb 07                	jmp    800e4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e46:	38 08                	cmp    %cl,(%eax)
  800e48:	74 07                	je     800e51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e4a:	83 c0 01             	add    $0x1,%eax
  800e4d:	39 d0                	cmp    %edx,%eax
  800e4f:	72 f5                	jb     800e46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5f:	eb 03                	jmp    800e64 <strtol+0x11>
		s++;
  800e61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e64:	0f b6 0a             	movzbl (%edx),%ecx
  800e67:	80 f9 09             	cmp    $0x9,%cl
  800e6a:	74 f5                	je     800e61 <strtol+0xe>
  800e6c:	80 f9 20             	cmp    $0x20,%cl
  800e6f:	74 f0                	je     800e61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e71:	80 f9 2b             	cmp    $0x2b,%cl
  800e74:	75 0a                	jne    800e80 <strtol+0x2d>
		s++;
  800e76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e79:	bf 00 00 00 00       	mov    $0x0,%edi
  800e7e:	eb 11                	jmp    800e91 <strtol+0x3e>
  800e80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e85:	80 f9 2d             	cmp    $0x2d,%cl
  800e88:	75 07                	jne    800e91 <strtol+0x3e>
		s++, neg = 1;
  800e8a:	8d 52 01             	lea    0x1(%edx),%edx
  800e8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800e96:	75 15                	jne    800ead <strtol+0x5a>
  800e98:	80 3a 30             	cmpb   $0x30,(%edx)
  800e9b:	75 10                	jne    800ead <strtol+0x5a>
  800e9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ea1:	75 0a                	jne    800ead <strtol+0x5a>
		s += 2, base = 16;
  800ea3:	83 c2 02             	add    $0x2,%edx
  800ea6:	b8 10 00 00 00       	mov    $0x10,%eax
  800eab:	eb 10                	jmp    800ebd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 0c                	jne    800ebd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eb1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800eb3:	80 3a 30             	cmpb   $0x30,(%edx)
  800eb6:	75 05                	jne    800ebd <strtol+0x6a>
		s++, base = 8;
  800eb8:	83 c2 01             	add    $0x1,%edx
  800ebb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ebd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ec5:	0f b6 0a             	movzbl (%edx),%ecx
  800ec8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800ecb:	89 f0                	mov    %esi,%eax
  800ecd:	3c 09                	cmp    $0x9,%al
  800ecf:	77 08                	ja     800ed9 <strtol+0x86>
			dig = *s - '0';
  800ed1:	0f be c9             	movsbl %cl,%ecx
  800ed4:	83 e9 30             	sub    $0x30,%ecx
  800ed7:	eb 20                	jmp    800ef9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ed9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800edc:	89 f0                	mov    %esi,%eax
  800ede:	3c 19                	cmp    $0x19,%al
  800ee0:	77 08                	ja     800eea <strtol+0x97>
			dig = *s - 'a' + 10;
  800ee2:	0f be c9             	movsbl %cl,%ecx
  800ee5:	83 e9 57             	sub    $0x57,%ecx
  800ee8:	eb 0f                	jmp    800ef9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800eea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800eed:	89 f0                	mov    %esi,%eax
  800eef:	3c 19                	cmp    $0x19,%al
  800ef1:	77 16                	ja     800f09 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ef3:	0f be c9             	movsbl %cl,%ecx
  800ef6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ef9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800efc:	7d 0f                	jge    800f0d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800efe:	83 c2 01             	add    $0x1,%edx
  800f01:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800f05:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800f07:	eb bc                	jmp    800ec5 <strtol+0x72>
  800f09:	89 d8                	mov    %ebx,%eax
  800f0b:	eb 02                	jmp    800f0f <strtol+0xbc>
  800f0d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800f0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f13:	74 05                	je     800f1a <strtol+0xc7>
		*endptr = (char *) s;
  800f15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f18:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800f1a:	f7 d8                	neg    %eax
  800f1c:	85 ff                	test   %edi,%edi
  800f1e:	0f 44 c3             	cmove  %ebx,%eax
}
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	57                   	push   %edi
  800f2a:	56                   	push   %esi
  800f2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	89 c3                	mov    %eax,%ebx
  800f39:	89 c7                	mov    %eax,%edi
  800f3b:	89 c6                	mov    %eax,%esi
  800f3d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f3f:	5b                   	pop    %ebx
  800f40:	5e                   	pop    %esi
  800f41:	5f                   	pop    %edi
  800f42:	5d                   	pop    %ebp
  800f43:	c3                   	ret    

00800f44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800f54:	89 d1                	mov    %edx,%ecx
  800f56:	89 d3                	mov    %edx,%ebx
  800f58:	89 d7                	mov    %edx,%edi
  800f5a:	89 d6                	mov    %edx,%esi
  800f5c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f71:	b8 03 00 00 00       	mov    $0x3,%eax
  800f76:	8b 55 08             	mov    0x8(%ebp),%edx
  800f79:	89 cb                	mov    %ecx,%ebx
  800f7b:	89 cf                	mov    %ecx,%edi
  800f7d:	89 ce                	mov    %ecx,%esi
  800f7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	7e 28                	jle    800fad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f89:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f90:	00 
  800f91:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  800f98:	00 
  800f99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa0:	00 
  800fa1:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  800fa8:	e8 ba f4 ff ff       	call   800467 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fad:	83 c4 2c             	add    $0x2c,%esp
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
  800fbb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc3:	b8 04 00 00 00       	mov    $0x4,%eax
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	89 cb                	mov    %ecx,%ebx
  800fcd:	89 cf                	mov    %ecx,%edi
  800fcf:	89 ce                	mov    %ecx,%esi
  800fd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	7e 28                	jle    800fff <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fe2:	00 
  800fe3:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  800fea:	00 
  800feb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff2:	00 
  800ff3:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  800ffa:	e8 68 f4 ff ff       	call   800467 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800fff:	83 c4 2c             	add    $0x2c,%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100d:	ba 00 00 00 00       	mov    $0x0,%edx
  801012:	b8 02 00 00 00       	mov    $0x2,%eax
  801017:	89 d1                	mov    %edx,%ecx
  801019:	89 d3                	mov    %edx,%ebx
  80101b:	89 d7                	mov    %edx,%edi
  80101d:	89 d6                	mov    %edx,%esi
  80101f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <sys_yield>:

void
sys_yield(void)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102c:	ba 00 00 00 00       	mov    $0x0,%edx
  801031:	b8 0c 00 00 00       	mov    $0xc,%eax
  801036:	89 d1                	mov    %edx,%ecx
  801038:	89 d3                	mov    %edx,%ebx
  80103a:	89 d7                	mov    %edx,%edi
  80103c:	89 d6                	mov    %edx,%esi
  80103e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801040:	5b                   	pop    %ebx
  801041:	5e                   	pop    %esi
  801042:	5f                   	pop    %edi
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	57                   	push   %edi
  801049:	56                   	push   %esi
  80104a:	53                   	push   %ebx
  80104b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104e:	be 00 00 00 00       	mov    $0x0,%esi
  801053:	b8 05 00 00 00       	mov    $0x5,%eax
  801058:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801061:	89 f7                	mov    %esi,%edi
  801063:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801065:	85 c0                	test   %eax,%eax
  801067:	7e 28                	jle    801091 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801069:	89 44 24 10          	mov    %eax,0x10(%esp)
  80106d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801074:	00 
  801075:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  80107c:	00 
  80107d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801084:	00 
  801085:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  80108c:	e8 d6 f3 ff ff       	call   800467 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801091:	83 c4 2c             	add    $0x2c,%esp
  801094:	5b                   	pop    %ebx
  801095:	5e                   	pop    %esi
  801096:	5f                   	pop    %edi
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	57                   	push   %edi
  80109d:	56                   	push   %esi
  80109e:	53                   	push   %ebx
  80109f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a2:	b8 06 00 00 00       	mov    $0x6,%eax
  8010a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8010b6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	7e 28                	jle    8010e4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010c7:	00 
  8010c8:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  8010cf:	00 
  8010d0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d7:	00 
  8010d8:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  8010df:	e8 83 f3 ff ff       	call   800467 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010e4:	83 c4 2c             	add    $0x2c,%esp
  8010e7:	5b                   	pop    %ebx
  8010e8:	5e                   	pop    %esi
  8010e9:	5f                   	pop    %edi
  8010ea:	5d                   	pop    %ebp
  8010eb:	c3                   	ret    

008010ec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	57                   	push   %edi
  8010f0:	56                   	push   %esi
  8010f1:	53                   	push   %ebx
  8010f2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fa:	b8 07 00 00 00       	mov    $0x7,%eax
  8010ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801102:	8b 55 08             	mov    0x8(%ebp),%edx
  801105:	89 df                	mov    %ebx,%edi
  801107:	89 de                	mov    %ebx,%esi
  801109:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80110b:	85 c0                	test   %eax,%eax
  80110d:	7e 28                	jle    801137 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801113:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80111a:	00 
  80111b:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  801122:	00 
  801123:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80112a:	00 
  80112b:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  801132:	e8 30 f3 ff ff       	call   800467 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801137:	83 c4 2c             	add    $0x2c,%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	57                   	push   %edi
  801143:	56                   	push   %esi
  801144:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801145:	b9 00 00 00 00       	mov    $0x0,%ecx
  80114a:	b8 10 00 00 00       	mov    $0x10,%eax
  80114f:	8b 55 08             	mov    0x8(%ebp),%edx
  801152:	89 cb                	mov    %ecx,%ebx
  801154:	89 cf                	mov    %ecx,%edi
  801156:	89 ce                	mov    %ecx,%esi
  801158:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80115a:	5b                   	pop    %ebx
  80115b:	5e                   	pop    %esi
  80115c:	5f                   	pop    %edi
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    

0080115f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	57                   	push   %edi
  801163:	56                   	push   %esi
  801164:	53                   	push   %ebx
  801165:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801168:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116d:	b8 09 00 00 00       	mov    $0x9,%eax
  801172:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	89 df                	mov    %ebx,%edi
  80117a:	89 de                	mov    %ebx,%esi
  80117c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80117e:	85 c0                	test   %eax,%eax
  801180:	7e 28                	jle    8011aa <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801182:	89 44 24 10          	mov    %eax,0x10(%esp)
  801186:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80118d:	00 
  80118e:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  801195:	00 
  801196:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80119d:	00 
  80119e:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  8011a5:	e8 bd f2 ff ff       	call   800467 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011aa:	83 c4 2c             	add    $0x2c,%esp
  8011ad:	5b                   	pop    %ebx
  8011ae:	5e                   	pop    %esi
  8011af:	5f                   	pop    %edi
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    

008011b2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	57                   	push   %edi
  8011b6:	56                   	push   %esi
  8011b7:	53                   	push   %ebx
  8011b8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cb:	89 df                	mov    %ebx,%edi
  8011cd:	89 de                	mov    %ebx,%esi
  8011cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	7e 28                	jle    8011fd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011e0:	00 
  8011e1:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  8011e8:	00 
  8011e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f0:	00 
  8011f1:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  8011f8:	e8 6a f2 ff ff       	call   800467 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011fd:	83 c4 2c             	add    $0x2c,%esp
  801200:	5b                   	pop    %ebx
  801201:	5e                   	pop    %esi
  801202:	5f                   	pop    %edi
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    

00801205 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	57                   	push   %edi
  801209:	56                   	push   %esi
  80120a:	53                   	push   %ebx
  80120b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801213:	b8 0b 00 00 00       	mov    $0xb,%eax
  801218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121b:	8b 55 08             	mov    0x8(%ebp),%edx
  80121e:	89 df                	mov    %ebx,%edi
  801220:	89 de                	mov    %ebx,%esi
  801222:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801224:	85 c0                	test   %eax,%eax
  801226:	7e 28                	jle    801250 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801228:	89 44 24 10          	mov    %eax,0x10(%esp)
  80122c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801233:	00 
  801234:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  80123b:	00 
  80123c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801243:	00 
  801244:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  80124b:	e8 17 f2 ff ff       	call   800467 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801250:	83 c4 2c             	add    $0x2c,%esp
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5f                   	pop    %edi
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	57                   	push   %edi
  80125c:	56                   	push   %esi
  80125d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125e:	be 00 00 00 00       	mov    $0x0,%esi
  801263:	b8 0d 00 00 00       	mov    $0xd,%eax
  801268:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126b:	8b 55 08             	mov    0x8(%ebp),%edx
  80126e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801271:	8b 7d 14             	mov    0x14(%ebp),%edi
  801274:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    

0080127b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	57                   	push   %edi
  80127f:	56                   	push   %esi
  801280:	53                   	push   %ebx
  801281:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801284:	b9 00 00 00 00       	mov    $0x0,%ecx
  801289:	b8 0e 00 00 00       	mov    $0xe,%eax
  80128e:	8b 55 08             	mov    0x8(%ebp),%edx
  801291:	89 cb                	mov    %ecx,%ebx
  801293:	89 cf                	mov    %ecx,%edi
  801295:	89 ce                	mov    %ecx,%esi
  801297:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801299:	85 c0                	test   %eax,%eax
  80129b:	7e 28                	jle    8012c5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80129d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8012a8:	00 
  8012a9:	c7 44 24 08 57 34 80 	movl   $0x803457,0x8(%esp)
  8012b0:	00 
  8012b1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012b8:	00 
  8012b9:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  8012c0:	e8 a2 f1 ff ff       	call   800467 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012c5:	83 c4 2c             	add    $0x2c,%esp
  8012c8:	5b                   	pop    %ebx
  8012c9:	5e                   	pop    %esi
  8012ca:	5f                   	pop    %edi
  8012cb:	5d                   	pop    %ebp
  8012cc:	c3                   	ret    

008012cd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	57                   	push   %edi
  8012d1:	56                   	push   %esi
  8012d2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012dd:	89 d1                	mov    %edx,%ecx
  8012df:	89 d3                	mov    %edx,%ebx
  8012e1:	89 d7                	mov    %edx,%edi
  8012e3:	89 d6                	mov    %edx,%esi
  8012e5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5f                   	pop    %edi
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f7:	b8 11 00 00 00       	mov    $0x11,%eax
  8012fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801302:	89 df                	mov    %ebx,%edi
  801304:	89 de                	mov    %ebx,%esi
  801306:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5f                   	pop    %edi
  80130b:	5d                   	pop    %ebp
  80130c:	c3                   	ret    

0080130d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	57                   	push   %edi
  801311:	56                   	push   %esi
  801312:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801313:	bb 00 00 00 00       	mov    $0x0,%ebx
  801318:	b8 12 00 00 00       	mov    $0x12,%eax
  80131d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801320:	8b 55 08             	mov    0x8(%ebp),%edx
  801323:	89 df                	mov    %ebx,%edi
  801325:	89 de                	mov    %ebx,%esi
  801327:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801329:	5b                   	pop    %ebx
  80132a:	5e                   	pop    %esi
  80132b:	5f                   	pop    %edi
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    

0080132e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	57                   	push   %edi
  801332:	56                   	push   %esi
  801333:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801334:	b9 00 00 00 00       	mov    $0x0,%ecx
  801339:	b8 13 00 00 00       	mov    $0x13,%eax
  80133e:	8b 55 08             	mov    0x8(%ebp),%edx
  801341:	89 cb                	mov    %ecx,%ebx
  801343:	89 cf                	mov    %ecx,%edi
  801345:	89 ce                	mov    %ecx,%esi
  801347:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801349:	5b                   	pop    %ebx
  80134a:	5e                   	pop    %esi
  80134b:	5f                   	pop    %edi
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    
  80134e:	66 90                	xchg   %ax,%ax

00801350 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	05 00 00 00 30       	add    $0x30000000,%eax
  80135b:	c1 e8 0c             	shr    $0xc,%eax
}
  80135e:	5d                   	pop    %ebp
  80135f:	c3                   	ret    

00801360 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80136b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801370:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    

00801377 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801382:	89 c2                	mov    %eax,%edx
  801384:	c1 ea 16             	shr    $0x16,%edx
  801387:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80138e:	f6 c2 01             	test   $0x1,%dl
  801391:	74 11                	je     8013a4 <fd_alloc+0x2d>
  801393:	89 c2                	mov    %eax,%edx
  801395:	c1 ea 0c             	shr    $0xc,%edx
  801398:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139f:	f6 c2 01             	test   $0x1,%dl
  8013a2:	75 09                	jne    8013ad <fd_alloc+0x36>
			*fd_store = fd;
  8013a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ab:	eb 17                	jmp    8013c4 <fd_alloc+0x4d>
  8013ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013b7:	75 c9                	jne    801382 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013cc:	83 f8 1f             	cmp    $0x1f,%eax
  8013cf:	77 36                	ja     801407 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013d1:	c1 e0 0c             	shl    $0xc,%eax
  8013d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	c1 ea 16             	shr    $0x16,%edx
  8013de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013e5:	f6 c2 01             	test   $0x1,%dl
  8013e8:	74 24                	je     80140e <fd_lookup+0x48>
  8013ea:	89 c2                	mov    %eax,%edx
  8013ec:	c1 ea 0c             	shr    $0xc,%edx
  8013ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f6:	f6 c2 01             	test   $0x1,%dl
  8013f9:	74 1a                	je     801415 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	eb 13                	jmp    80141a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140c:	eb 0c                	jmp    80141a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80140e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801413:	eb 05                	jmp    80141a <fd_lookup+0x54>
  801415:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 18             	sub    $0x18,%esp
  801422:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801425:	ba 00 00 00 00       	mov    $0x0,%edx
  80142a:	eb 13                	jmp    80143f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80142c:	39 08                	cmp    %ecx,(%eax)
  80142e:	75 0c                	jne    80143c <dev_lookup+0x20>
			*dev = devtab[i];
  801430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801433:	89 01                	mov    %eax,(%ecx)
			return 0;
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
  80143a:	eb 38                	jmp    801474 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80143c:	83 c2 01             	add    $0x1,%edx
  80143f:	8b 04 95 00 35 80 00 	mov    0x803500(,%edx,4),%eax
  801446:	85 c0                	test   %eax,%eax
  801448:	75 e2                	jne    80142c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80144a:	a1 90 77 80 00       	mov    0x807790,%eax
  80144f:	8b 40 48             	mov    0x48(%eax),%eax
  801452:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145a:	c7 04 24 84 34 80 00 	movl   $0x803484,(%esp)
  801461:	e8 fa f0 ff ff       	call   800560 <cprintf>
	*dev = 0;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80146f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	56                   	push   %esi
  80147a:	53                   	push   %ebx
  80147b:	83 ec 20             	sub    $0x20,%esp
  80147e:	8b 75 08             	mov    0x8(%ebp),%esi
  801481:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801484:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801487:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80148b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801491:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801494:	89 04 24             	mov    %eax,(%esp)
  801497:	e8 2a ff ff ff       	call   8013c6 <fd_lookup>
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 05                	js     8014a5 <fd_close+0x2f>
	    || fd != fd2)
  8014a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014a3:	74 0c                	je     8014b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8014a5:	84 db                	test   %bl,%bl
  8014a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ac:	0f 44 c2             	cmove  %edx,%eax
  8014af:	eb 3f                	jmp    8014f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b8:	8b 06                	mov    (%esi),%eax
  8014ba:	89 04 24             	mov    %eax,(%esp)
  8014bd:	e8 5a ff ff ff       	call   80141c <dev_lookup>
  8014c2:	89 c3                	mov    %eax,%ebx
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	78 16                	js     8014de <fd_close+0x68>
		if (dev->dev_close)
  8014c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 07                	je     8014de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8014d7:	89 34 24             	mov    %esi,(%esp)
  8014da:	ff d0                	call   *%eax
  8014dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014e9:	e8 fe fb ff ff       	call   8010ec <sys_page_unmap>
	return r;
  8014ee:	89 d8                	mov    %ebx,%eax
}
  8014f0:	83 c4 20             	add    $0x20,%esp
  8014f3:	5b                   	pop    %ebx
  8014f4:	5e                   	pop    %esi
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801500:	89 44 24 04          	mov    %eax,0x4(%esp)
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	89 04 24             	mov    %eax,(%esp)
  80150a:	e8 b7 fe ff ff       	call   8013c6 <fd_lookup>
  80150f:	89 c2                	mov    %eax,%edx
  801511:	85 d2                	test   %edx,%edx
  801513:	78 13                	js     801528 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801515:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80151c:	00 
  80151d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801520:	89 04 24             	mov    %eax,(%esp)
  801523:	e8 4e ff ff ff       	call   801476 <fd_close>
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <close_all>:

void
close_all(void)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	53                   	push   %ebx
  80152e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801531:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801536:	89 1c 24             	mov    %ebx,(%esp)
  801539:	e8 b9 ff ff ff       	call   8014f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80153e:	83 c3 01             	add    $0x1,%ebx
  801541:	83 fb 20             	cmp    $0x20,%ebx
  801544:	75 f0                	jne    801536 <close_all+0xc>
		close(i);
}
  801546:	83 c4 14             	add    $0x14,%esp
  801549:	5b                   	pop    %ebx
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    

0080154c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	57                   	push   %edi
  801550:	56                   	push   %esi
  801551:	53                   	push   %ebx
  801552:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801555:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	89 04 24             	mov    %eax,(%esp)
  801562:	e8 5f fe ff ff       	call   8013c6 <fd_lookup>
  801567:	89 c2                	mov    %eax,%edx
  801569:	85 d2                	test   %edx,%edx
  80156b:	0f 88 e1 00 00 00    	js     801652 <dup+0x106>
		return r;
	close(newfdnum);
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	89 04 24             	mov    %eax,(%esp)
  801577:	e8 7b ff ff ff       	call   8014f7 <close>

	newfd = INDEX2FD(newfdnum);
  80157c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80157f:	c1 e3 0c             	shl    $0xc,%ebx
  801582:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158b:	89 04 24             	mov    %eax,(%esp)
  80158e:	e8 cd fd ff ff       	call   801360 <fd2data>
  801593:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801595:	89 1c 24             	mov    %ebx,(%esp)
  801598:	e8 c3 fd ff ff       	call   801360 <fd2data>
  80159d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80159f:	89 f0                	mov    %esi,%eax
  8015a1:	c1 e8 16             	shr    $0x16,%eax
  8015a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ab:	a8 01                	test   $0x1,%al
  8015ad:	74 43                	je     8015f2 <dup+0xa6>
  8015af:	89 f0                	mov    %esi,%eax
  8015b1:	c1 e8 0c             	shr    $0xc,%eax
  8015b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015bb:	f6 c2 01             	test   $0x1,%dl
  8015be:	74 32                	je     8015f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015db:	00 
  8015dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e7:	e8 ad fa ff ff       	call   801099 <sys_page_map>
  8015ec:	89 c6                	mov    %eax,%esi
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 3e                	js     801630 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f5:	89 c2                	mov    %eax,%edx
  8015f7:	c1 ea 0c             	shr    $0xc,%edx
  8015fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801601:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801607:	89 54 24 10          	mov    %edx,0x10(%esp)
  80160b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80160f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801616:	00 
  801617:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801622:	e8 72 fa ff ff       	call   801099 <sys_page_map>
  801627:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80162c:	85 f6                	test   %esi,%esi
  80162e:	79 22                	jns    801652 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801630:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801634:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80163b:	e8 ac fa ff ff       	call   8010ec <sys_page_unmap>
	sys_page_unmap(0, nva);
  801640:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801644:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80164b:	e8 9c fa ff ff       	call   8010ec <sys_page_unmap>
	return r;
  801650:	89 f0                	mov    %esi,%eax
}
  801652:	83 c4 3c             	add    $0x3c,%esp
  801655:	5b                   	pop    %ebx
  801656:	5e                   	pop    %esi
  801657:	5f                   	pop    %edi
  801658:	5d                   	pop    %ebp
  801659:	c3                   	ret    

0080165a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	53                   	push   %ebx
  80165e:	83 ec 24             	sub    $0x24,%esp
  801661:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801664:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801667:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166b:	89 1c 24             	mov    %ebx,(%esp)
  80166e:	e8 53 fd ff ff       	call   8013c6 <fd_lookup>
  801673:	89 c2                	mov    %eax,%edx
  801675:	85 d2                	test   %edx,%edx
  801677:	78 6d                	js     8016e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	8b 00                	mov    (%eax),%eax
  801685:	89 04 24             	mov    %eax,(%esp)
  801688:	e8 8f fd ff ff       	call   80141c <dev_lookup>
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 55                	js     8016e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	8b 50 08             	mov    0x8(%eax),%edx
  801697:	83 e2 03             	and    $0x3,%edx
  80169a:	83 fa 01             	cmp    $0x1,%edx
  80169d:	75 23                	jne    8016c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80169f:	a1 90 77 80 00       	mov    0x807790,%eax
  8016a4:	8b 40 48             	mov    0x48(%eax),%eax
  8016a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016af:	c7 04 24 c5 34 80 00 	movl   $0x8034c5,(%esp)
  8016b6:	e8 a5 ee ff ff       	call   800560 <cprintf>
		return -E_INVAL;
  8016bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c0:	eb 24                	jmp    8016e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8016c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c5:	8b 52 08             	mov    0x8(%edx),%edx
  8016c8:	85 d2                	test   %edx,%edx
  8016ca:	74 15                	je     8016e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016da:	89 04 24             	mov    %eax,(%esp)
  8016dd:	ff d2                	call   *%edx
  8016df:	eb 05                	jmp    8016e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8016e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8016e6:	83 c4 24             	add    $0x24,%esp
  8016e9:	5b                   	pop    %ebx
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	57                   	push   %edi
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
  8016f2:	83 ec 1c             	sub    $0x1c,%esp
  8016f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801700:	eb 23                	jmp    801725 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801702:	89 f0                	mov    %esi,%eax
  801704:	29 d8                	sub    %ebx,%eax
  801706:	89 44 24 08          	mov    %eax,0x8(%esp)
  80170a:	89 d8                	mov    %ebx,%eax
  80170c:	03 45 0c             	add    0xc(%ebp),%eax
  80170f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801713:	89 3c 24             	mov    %edi,(%esp)
  801716:	e8 3f ff ff ff       	call   80165a <read>
		if (m < 0)
  80171b:	85 c0                	test   %eax,%eax
  80171d:	78 10                	js     80172f <readn+0x43>
			return m;
		if (m == 0)
  80171f:	85 c0                	test   %eax,%eax
  801721:	74 0a                	je     80172d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801723:	01 c3                	add    %eax,%ebx
  801725:	39 f3                	cmp    %esi,%ebx
  801727:	72 d9                	jb     801702 <readn+0x16>
  801729:	89 d8                	mov    %ebx,%eax
  80172b:	eb 02                	jmp    80172f <readn+0x43>
  80172d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80172f:	83 c4 1c             	add    $0x1c,%esp
  801732:	5b                   	pop    %ebx
  801733:	5e                   	pop    %esi
  801734:	5f                   	pop    %edi
  801735:	5d                   	pop    %ebp
  801736:	c3                   	ret    

00801737 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	53                   	push   %ebx
  80173b:	83 ec 24             	sub    $0x24,%esp
  80173e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801741:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801744:	89 44 24 04          	mov    %eax,0x4(%esp)
  801748:	89 1c 24             	mov    %ebx,(%esp)
  80174b:	e8 76 fc ff ff       	call   8013c6 <fd_lookup>
  801750:	89 c2                	mov    %eax,%edx
  801752:	85 d2                	test   %edx,%edx
  801754:	78 68                	js     8017be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801756:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801759:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	8b 00                	mov    (%eax),%eax
  801762:	89 04 24             	mov    %eax,(%esp)
  801765:	e8 b2 fc ff ff       	call   80141c <dev_lookup>
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 50                	js     8017be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80176e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801771:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801775:	75 23                	jne    80179a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801777:	a1 90 77 80 00       	mov    0x807790,%eax
  80177c:	8b 40 48             	mov    0x48(%eax),%eax
  80177f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801783:	89 44 24 04          	mov    %eax,0x4(%esp)
  801787:	c7 04 24 e1 34 80 00 	movl   $0x8034e1,(%esp)
  80178e:	e8 cd ed ff ff       	call   800560 <cprintf>
		return -E_INVAL;
  801793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801798:	eb 24                	jmp    8017be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80179a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179d:	8b 52 0c             	mov    0xc(%edx),%edx
  8017a0:	85 d2                	test   %edx,%edx
  8017a2:	74 15                	je     8017b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017b2:	89 04 24             	mov    %eax,(%esp)
  8017b5:	ff d2                	call   *%edx
  8017b7:	eb 05                	jmp    8017be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017be:	83 c4 24             	add    $0x24,%esp
  8017c1:	5b                   	pop    %ebx
  8017c2:	5d                   	pop    %ebp
  8017c3:	c3                   	ret    

008017c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	89 04 24             	mov    %eax,(%esp)
  8017d7:	e8 ea fb ff ff       	call   8013c6 <fd_lookup>
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 0e                	js     8017ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 24             	sub    $0x24,%esp
  8017f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801801:	89 1c 24             	mov    %ebx,(%esp)
  801804:	e8 bd fb ff ff       	call   8013c6 <fd_lookup>
  801809:	89 c2                	mov    %eax,%edx
  80180b:	85 d2                	test   %edx,%edx
  80180d:	78 61                	js     801870 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801812:	89 44 24 04          	mov    %eax,0x4(%esp)
  801816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801819:	8b 00                	mov    (%eax),%eax
  80181b:	89 04 24             	mov    %eax,(%esp)
  80181e:	e8 f9 fb ff ff       	call   80141c <dev_lookup>
  801823:	85 c0                	test   %eax,%eax
  801825:	78 49                	js     801870 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80182e:	75 23                	jne    801853 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801830:	a1 90 77 80 00       	mov    0x807790,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801835:	8b 40 48             	mov    0x48(%eax),%eax
  801838:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80183c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801840:	c7 04 24 a4 34 80 00 	movl   $0x8034a4,(%esp)
  801847:	e8 14 ed ff ff       	call   800560 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80184c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801851:	eb 1d                	jmp    801870 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801856:	8b 52 18             	mov    0x18(%edx),%edx
  801859:	85 d2                	test   %edx,%edx
  80185b:	74 0e                	je     80186b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80185d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801860:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801864:	89 04 24             	mov    %eax,(%esp)
  801867:	ff d2                	call   *%edx
  801869:	eb 05                	jmp    801870 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80186b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801870:	83 c4 24             	add    $0x24,%esp
  801873:	5b                   	pop    %ebx
  801874:	5d                   	pop    %ebp
  801875:	c3                   	ret    

00801876 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	53                   	push   %ebx
  80187a:	83 ec 24             	sub    $0x24,%esp
  80187d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801880:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801883:	89 44 24 04          	mov    %eax,0x4(%esp)
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	89 04 24             	mov    %eax,(%esp)
  80188d:	e8 34 fb ff ff       	call   8013c6 <fd_lookup>
  801892:	89 c2                	mov    %eax,%edx
  801894:	85 d2                	test   %edx,%edx
  801896:	78 52                	js     8018ea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801898:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	8b 00                	mov    (%eax),%eax
  8018a4:	89 04 24             	mov    %eax,(%esp)
  8018a7:	e8 70 fb ff ff       	call   80141c <dev_lookup>
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 3a                	js     8018ea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8018b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018b7:	74 2c                	je     8018e5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018c3:	00 00 00 
	stat->st_isdir = 0;
  8018c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018cd:	00 00 00 
	stat->st_dev = dev;
  8018d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018dd:	89 14 24             	mov    %edx,(%esp)
  8018e0:	ff 50 14             	call   *0x14(%eax)
  8018e3:	eb 05                	jmp    8018ea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018ea:	83 c4 24             	add    $0x24,%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    

008018f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	56                   	push   %esi
  8018f4:	53                   	push   %ebx
  8018f5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018ff:	00 
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	89 04 24             	mov    %eax,(%esp)
  801906:	e8 99 02 00 00       	call   801ba4 <open>
  80190b:	89 c3                	mov    %eax,%ebx
  80190d:	85 db                	test   %ebx,%ebx
  80190f:	78 1b                	js     80192c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801911:	8b 45 0c             	mov    0xc(%ebp),%eax
  801914:	89 44 24 04          	mov    %eax,0x4(%esp)
  801918:	89 1c 24             	mov    %ebx,(%esp)
  80191b:	e8 56 ff ff ff       	call   801876 <fstat>
  801920:	89 c6                	mov    %eax,%esi
	close(fd);
  801922:	89 1c 24             	mov    %ebx,(%esp)
  801925:	e8 cd fb ff ff       	call   8014f7 <close>
	return r;
  80192a:	89 f0                	mov    %esi,%eax
}
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	56                   	push   %esi
  801937:	53                   	push   %ebx
  801938:	83 ec 10             	sub    $0x10,%esp
  80193b:	89 c6                	mov    %eax,%esi
  80193d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80193f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801946:	75 11                	jne    801959 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801948:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80194f:	e8 6b 13 00 00       	call   802cbf <ipc_find_env>
  801954:	a3 00 60 80 00       	mov    %eax,0x806000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801959:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801960:	00 
  801961:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  801968:	00 
  801969:	89 74 24 04          	mov    %esi,0x4(%esp)
  80196d:	a1 00 60 80 00       	mov    0x806000,%eax
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	e8 de 12 00 00       	call   802c58 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80197a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801981:	00 
  801982:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801986:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198d:	e8 5e 12 00 00       	call   802bf0 <ipc_recv>
}
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	5b                   	pop    %ebx
  801996:	5e                   	pop    %esi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    

00801999 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a5:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019bc:	e8 72 ff ff ff       	call   801933 <fsipc>
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019cf:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8019de:	e8 50 ff ff ff       	call   801933 <fsipc>
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 14             	sub    $0x14,%esp
  8019ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f5:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801a04:	e8 2a ff ff ff       	call   801933 <fsipc>
  801a09:	89 c2                	mov    %eax,%edx
  801a0b:	85 d2                	test   %edx,%edx
  801a0d:	78 2b                	js     801a3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a0f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801a16:	00 
  801a17:	89 1c 24             	mov    %ebx,(%esp)
  801a1a:	e8 b8 f1 ff ff       	call   800bd7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a1f:	a1 80 80 80 00       	mov    0x808080,%eax
  801a24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a2a:	a1 84 80 80 00       	mov    0x808084,%eax
  801a2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3a:	83 c4 14             	add    $0x14,%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 14             	sub    $0x14,%esp
  801a47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801a4a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801a50:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801a55:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a58:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5b:	8b 52 0c             	mov    0xc(%edx),%edx
  801a5e:	89 15 00 80 80 00    	mov    %edx,0x808000
	fsipcbuf.write.req_n = count;
  801a64:	a3 04 80 80 00       	mov    %eax,0x808004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801a69:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a74:	c7 04 24 08 80 80 00 	movl   $0x808008,(%esp)
  801a7b:	e8 f4 f2 ff ff       	call   800d74 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801a80:	c7 44 24 04 08 80 80 	movl   $0x808008,0x4(%esp)
  801a87:	00 
  801a88:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  801a8f:	e8 cc ea ff ff       	call   800560 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a94:	ba 00 00 00 00       	mov    $0x0,%edx
  801a99:	b8 04 00 00 00       	mov    $0x4,%eax
  801a9e:	e8 90 fe ff ff       	call   801933 <fsipc>
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 53                	js     801afa <devfile_write+0xba>
		return r;
	assert(r <= n);
  801aa7:	39 c3                	cmp    %eax,%ebx
  801aa9:	73 24                	jae    801acf <devfile_write+0x8f>
  801aab:	c7 44 24 0c 19 35 80 	movl   $0x803519,0xc(%esp)
  801ab2:	00 
  801ab3:	c7 44 24 08 20 35 80 	movl   $0x803520,0x8(%esp)
  801aba:	00 
  801abb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801ac2:	00 
  801ac3:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  801aca:	e8 98 e9 ff ff       	call   800467 <_panic>
	assert(r <= PGSIZE);
  801acf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ad4:	7e 24                	jle    801afa <devfile_write+0xba>
  801ad6:	c7 44 24 0c 40 35 80 	movl   $0x803540,0xc(%esp)
  801add:	00 
  801ade:	c7 44 24 08 20 35 80 	movl   $0x803520,0x8(%esp)
  801ae5:	00 
  801ae6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801aed:	00 
  801aee:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  801af5:	e8 6d e9 ff ff       	call   800467 <_panic>
	return r;
}
  801afa:	83 c4 14             	add    $0x14,%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    

00801b00 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	56                   	push   %esi
  801b04:	53                   	push   %ebx
  801b05:	83 ec 10             	sub    $0x10,%esp
  801b08:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b11:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801b16:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b21:	b8 03 00 00 00       	mov    $0x3,%eax
  801b26:	e8 08 fe ff ff       	call   801933 <fsipc>
  801b2b:	89 c3                	mov    %eax,%ebx
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 6a                	js     801b9b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b31:	39 c6                	cmp    %eax,%esi
  801b33:	73 24                	jae    801b59 <devfile_read+0x59>
  801b35:	c7 44 24 0c 19 35 80 	movl   $0x803519,0xc(%esp)
  801b3c:	00 
  801b3d:	c7 44 24 08 20 35 80 	movl   $0x803520,0x8(%esp)
  801b44:	00 
  801b45:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b4c:	00 
  801b4d:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  801b54:	e8 0e e9 ff ff       	call   800467 <_panic>
	assert(r <= PGSIZE);
  801b59:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b5e:	7e 24                	jle    801b84 <devfile_read+0x84>
  801b60:	c7 44 24 0c 40 35 80 	movl   $0x803540,0xc(%esp)
  801b67:	00 
  801b68:	c7 44 24 08 20 35 80 	movl   $0x803520,0x8(%esp)
  801b6f:	00 
  801b70:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b77:	00 
  801b78:	c7 04 24 35 35 80 00 	movl   $0x803535,(%esp)
  801b7f:	e8 e3 e8 ff ff       	call   800467 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b84:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b88:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801b8f:	00 
  801b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b93:	89 04 24             	mov    %eax,(%esp)
  801b96:	e8 d9 f1 ff ff       	call   800d74 <memmove>
	return r;
}
  801b9b:	89 d8                	mov    %ebx,%eax
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	5b                   	pop    %ebx
  801ba1:	5e                   	pop    %esi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 24             	sub    $0x24,%esp
  801bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bae:	89 1c 24             	mov    %ebx,(%esp)
  801bb1:	e8 ea ef ff ff       	call   800ba0 <strlen>
  801bb6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bbb:	7f 60                	jg     801c1d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc0:	89 04 24             	mov    %eax,(%esp)
  801bc3:	e8 af f7 ff ff       	call   801377 <fd_alloc>
  801bc8:	89 c2                	mov    %eax,%edx
  801bca:	85 d2                	test   %edx,%edx
  801bcc:	78 54                	js     801c22 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bd2:	c7 04 24 00 80 80 00 	movl   $0x808000,(%esp)
  801bd9:	e8 f9 ef ff ff       	call   800bd7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be1:	a3 00 84 80 00       	mov    %eax,0x808400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bee:	e8 40 fd ff ff       	call   801933 <fsipc>
  801bf3:	89 c3                	mov    %eax,%ebx
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	79 17                	jns    801c10 <open+0x6c>
		fd_close(fd, 0);
  801bf9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c00:	00 
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c04:	89 04 24             	mov    %eax,(%esp)
  801c07:	e8 6a f8 ff ff       	call   801476 <fd_close>
		return r;
  801c0c:	89 d8                	mov    %ebx,%eax
  801c0e:	eb 12                	jmp    801c22 <open+0x7e>
	}

	return fd2num(fd);
  801c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c13:	89 04 24             	mov    %eax,(%esp)
  801c16:	e8 35 f7 ff ff       	call   801350 <fd2num>
  801c1b:	eb 05                	jmp    801c22 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c1d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c22:	83 c4 24             	add    $0x24,%esp
  801c25:	5b                   	pop    %ebx
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    

00801c28 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c33:	b8 08 00 00 00       	mov    $0x8,%eax
  801c38:	e8 f6 fc ff ff       	call   801933 <fsipc>
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <evict>:

int evict(void)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801c45:	c7 04 24 4c 35 80 00 	movl   $0x80354c,(%esp)
  801c4c:	e8 0f e9 ff ff       	call   800560 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	b8 09 00 00 00       	mov    $0x9,%eax
  801c5b:	e8 d3 fc ff ff       	call   801933 <fsipc>
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	66 90                	xchg   %ax,%ax
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	66 90                	xchg   %ax,%ax
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	66 90                	xchg   %ax,%ax
  801c6e:	66 90                	xchg   %ax,%ax

00801c70 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	57                   	push   %edi
  801c74:	56                   	push   %esi
  801c75:	53                   	push   %ebx
  801c76:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801c7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c83:	00 
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	89 04 24             	mov    %eax,(%esp)
  801c8a:	e8 15 ff ff ff       	call   801ba4 <open>
  801c8f:	89 c1                	mov    %eax,%ecx
  801c91:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801c97:	85 c0                	test   %eax,%eax
  801c99:	0f 88 41 05 00 00    	js     8021e0 <spawn+0x570>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801c9f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801ca6:	00 
  801ca7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb1:	89 0c 24             	mov    %ecx,(%esp)
  801cb4:	e8 33 fa ff ff       	call   8016ec <readn>
  801cb9:	3d 00 02 00 00       	cmp    $0x200,%eax
  801cbe:	75 0c                	jne    801ccc <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801cc0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801cc7:	45 4c 46 
  801cca:	74 36                	je     801d02 <spawn+0x92>
		close(fd);
  801ccc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801cd2:	89 04 24             	mov    %eax,(%esp)
  801cd5:	e8 1d f8 ff ff       	call   8014f7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801cda:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801ce1:	46 
  801ce2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	c7 04 24 65 35 80 00 	movl   $0x803565,(%esp)
  801cf3:	e8 68 e8 ff ff       	call   800560 <cprintf>
		return -E_NOT_EXEC;
  801cf8:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801cfd:	e9 3d 05 00 00       	jmp    80223f <spawn+0x5cf>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801d02:	b8 08 00 00 00       	mov    $0x8,%eax
  801d07:	cd 30                	int    $0x30
  801d09:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801d0f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801d15:	85 c0                	test   %eax,%eax
  801d17:	0f 88 cb 04 00 00    	js     8021e8 <spawn+0x578>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801d1d:	89 c6                	mov    %eax,%esi
  801d1f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801d25:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801d28:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801d2e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801d34:	b9 11 00 00 00       	mov    $0x11,%ecx
  801d39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801d3b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801d41:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d47:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801d4c:	be 00 00 00 00       	mov    $0x0,%esi
  801d51:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d54:	eb 0f                	jmp    801d65 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801d56:	89 04 24             	mov    %eax,(%esp)
  801d59:	e8 42 ee ff ff       	call   800ba0 <strlen>
  801d5e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d62:	83 c3 01             	add    $0x1,%ebx
  801d65:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801d6c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	75 e3                	jne    801d56 <spawn+0xe6>
  801d73:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d79:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801d7f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801d84:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d86:	89 fa                	mov    %edi,%edx
  801d88:	83 e2 fc             	and    $0xfffffffc,%edx
  801d8b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801d92:	29 c2                	sub    %eax,%edx
  801d94:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801d9a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801d9d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801da2:	0f 86 50 04 00 00    	jbe    8021f8 <spawn+0x588>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801da8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801daf:	00 
  801db0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801db7:	00 
  801db8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dbf:	e8 81 f2 ff ff       	call   801045 <sys_page_alloc>
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	0f 88 73 04 00 00    	js     80223f <spawn+0x5cf>
  801dcc:	be 00 00 00 00       	mov    $0x0,%esi
  801dd1:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801dd7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801dda:	eb 30                	jmp    801e0c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801ddc:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801de2:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801de8:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801deb:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df2:	89 3c 24             	mov    %edi,(%esp)
  801df5:	e8 dd ed ff ff       	call   800bd7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801dfa:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801dfd:	89 04 24             	mov    %eax,(%esp)
  801e00:	e8 9b ed ff ff       	call   800ba0 <strlen>
  801e05:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e09:	83 c6 01             	add    $0x1,%esi
  801e0c:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  801e12:	7c c8                	jl     801ddc <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801e14:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e1a:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801e20:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e27:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801e2d:	74 24                	je     801e53 <spawn+0x1e3>
  801e2f:	c7 44 24 0c fc 35 80 	movl   $0x8035fc,0xc(%esp)
  801e36:	00 
  801e37:	c7 44 24 08 20 35 80 	movl   $0x803520,0x8(%esp)
  801e3e:	00 
  801e3f:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  801e46:	00 
  801e47:	c7 04 24 7f 35 80 00 	movl   $0x80357f,(%esp)
  801e4e:	e8 14 e6 ff ff       	call   800467 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801e53:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801e59:	89 c8                	mov    %ecx,%eax
  801e5b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801e60:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801e63:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801e69:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801e6c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801e72:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e78:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801e7f:	00 
  801e80:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801e87:	ee 
  801e88:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e92:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e99:	00 
  801e9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea1:	e8 f3 f1 ff ff       	call   801099 <sys_page_map>
  801ea6:	89 c3                	mov    %eax,%ebx
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	0f 88 79 03 00 00    	js     802229 <spawn+0x5b9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801eb0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801eb7:	00 
  801eb8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ebf:	e8 28 f2 ff ff       	call   8010ec <sys_page_unmap>
  801ec4:	89 c3                	mov    %eax,%ebx
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	0f 88 5b 03 00 00    	js     802229 <spawn+0x5b9>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801ece:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ed4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801edb:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ee1:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801ee8:	00 00 00 
  801eeb:	e9 b6 01 00 00       	jmp    8020a6 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801ef0:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801ef6:	83 38 01             	cmpl   $0x1,(%eax)
  801ef9:	0f 85 99 01 00 00    	jne    802098 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801eff:	89 c2                	mov    %eax,%edx
  801f01:	8b 40 18             	mov    0x18(%eax),%eax
  801f04:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801f07:	83 f8 01             	cmp    $0x1,%eax
  801f0a:	19 c0                	sbb    %eax,%eax
  801f0c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801f12:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801f19:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801f20:	89 d0                	mov    %edx,%eax
  801f22:	8b 4a 04             	mov    0x4(%edx),%ecx
  801f25:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801f2b:	8b 52 10             	mov    0x10(%edx),%edx
  801f2e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801f34:	8b 48 14             	mov    0x14(%eax),%ecx
  801f37:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801f3d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801f40:	89 f0                	mov    %esi,%eax
  801f42:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f47:	74 14                	je     801f5d <spawn+0x2ed>
		va -= i;
  801f49:	29 c6                	sub    %eax,%esi
		memsz += i;
  801f4b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801f51:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801f57:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801f5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f62:	e9 23 01 00 00       	jmp    80208a <spawn+0x41a>
		if (i >= filesz) {
  801f67:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801f6d:	77 2b                	ja     801f9a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801f6f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f75:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f79:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f7d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f83:	89 04 24             	mov    %eax,(%esp)
  801f86:	e8 ba f0 ff ff       	call   801045 <sys_page_alloc>
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	0f 89 eb 00 00 00    	jns    80207e <spawn+0x40e>
  801f93:	89 c3                	mov    %eax,%ebx
  801f95:	e9 6f 02 00 00       	jmp    802209 <spawn+0x599>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f9a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801fa1:	00 
  801fa2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fa9:	00 
  801faa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb1:	e8 8f f0 ff ff       	call   801045 <sys_page_alloc>
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	0f 88 41 02 00 00    	js     8021ff <spawn+0x58f>
  801fbe:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801fc4:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fca:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801fd0:	89 04 24             	mov    %eax,(%esp)
  801fd3:	e8 ec f7 ff ff       	call   8017c4 <seek>
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	0f 88 23 02 00 00    	js     802203 <spawn+0x593>
  801fe0:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801fe6:	29 f9                	sub    %edi,%ecx
  801fe8:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801fea:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801ff0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ff5:	0f 47 c2             	cmova  %edx,%eax
  801ff8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ffc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802003:	00 
  802004:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 da f6 ff ff       	call   8016ec <readn>
  802012:	85 c0                	test   %eax,%eax
  802014:	0f 88 ed 01 00 00    	js     802207 <spawn+0x597>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80201a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802020:	89 44 24 10          	mov    %eax,0x10(%esp)
  802024:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802028:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80202e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802032:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802039:	00 
  80203a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802041:	e8 53 f0 ff ff       	call   801099 <sys_page_map>
  802046:	85 c0                	test   %eax,%eax
  802048:	79 20                	jns    80206a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  80204a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80204e:	c7 44 24 08 8b 35 80 	movl   $0x80358b,0x8(%esp)
  802055:	00 
  802056:	c7 44 24 04 a8 01 00 	movl   $0x1a8,0x4(%esp)
  80205d:	00 
  80205e:	c7 04 24 7f 35 80 00 	movl   $0x80357f,(%esp)
  802065:	e8 fd e3 ff ff       	call   800467 <_panic>
			sys_page_unmap(0, UTEMP);
  80206a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802071:	00 
  802072:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802079:	e8 6e f0 ff ff       	call   8010ec <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80207e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802084:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80208a:	89 df                	mov    %ebx,%edi
  80208c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802092:	0f 87 cf fe ff ff    	ja     801f67 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802098:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  80209f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  8020a6:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8020ad:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  8020b3:	0f 8c 37 fe ff ff    	jl     801ef0 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8020b9:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020bf:	89 04 24             	mov    %eax,(%esp)
  8020c2:	e8 30 f4 ff ff       	call   8014f7 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
  8020c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020cc:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8020d2:	89 d8                	mov    %ebx,%eax
  8020d4:	c1 e8 16             	shr    $0x16,%eax
  8020d7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020de:	a8 01                	test   $0x1,%al
  8020e0:	74 76                	je     802158 <spawn+0x4e8>
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
  8020e2:	89 d8                	mov    %ebx,%eax
  8020e4:	c1 e8 0c             	shr    $0xc,%eax
  8020e7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020ee:	f6 c6 04             	test   $0x4,%dh
  8020f1:	74 5d                	je     802150 <spawn+0x4e0>
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  8020f3:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
				cprintf("\nspawn addr:%p\n",addr);
  8020fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020fe:	c7 04 24 a8 35 80 00 	movl   $0x8035a8,(%esp)
  802105:	e8 56 e4 ff ff       	call   800560 <cprintf>
		if(uvpd[PDX(addr)] & PTE_P)
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  80210a:	81 e7 07 0e 00 00    	and    $0xe07,%edi
				cprintf("\nspawn addr:%p\n",addr);
				if ((r = sys_page_map(0, (void *)addr, child, (void *)addr, perm)) < 0)
  802110:	89 7c 24 10          	mov    %edi,0x10(%esp)
  802114:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802118:	89 74 24 08          	mov    %esi,0x8(%esp)
  80211c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802127:	e8 6d ef ff ff       	call   801099 <sys_page_map>
  80212c:	85 c0                	test   %eax,%eax
  80212e:	79 20                	jns    802150 <spawn+0x4e0>
					panic("sys_page_map: %e", r);
  802130:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802134:	c7 44 24 08 b8 35 80 	movl   $0x8035b8,0x8(%esp)
  80213b:	00 
  80213c:	c7 44 24 04 c2 01 00 	movl   $0x1c2,0x4(%esp)
  802143:	00 
  802144:	c7 04 24 7f 35 80 00 	movl   $0x80357f,(%esp)
  80214b:	e8 17 e3 ff ff       	call   800467 <_panic>
			}
			addr += PGSIZE;
  802150:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802156:	eb 06                	jmp    80215e <spawn+0x4ee>
		}
		else
		{
			addr = addr + PTSIZE;
  802158:	81 c3 00 00 40 00    	add    $0x400000,%ebx
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
  80215e:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  802164:	0f 86 68 ff ff ff    	jbe    8020d2 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80216a:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802170:	89 44 24 04          	mov    %eax,0x4(%esp)
  802174:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80217a:	89 04 24             	mov    %eax,(%esp)
  80217d:	e8 30 f0 ff ff       	call   8011b2 <sys_env_set_trapframe>
  802182:	85 c0                	test   %eax,%eax
  802184:	79 20                	jns    8021a6 <spawn+0x536>
		panic("sys_env_set_trapframe: %e", r);
  802186:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80218a:	c7 44 24 08 c9 35 80 	movl   $0x8035c9,0x8(%esp)
  802191:	00 
  802192:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802199:	00 
  80219a:	c7 04 24 7f 35 80 00 	movl   $0x80357f,(%esp)
  8021a1:	e8 c1 e2 ff ff       	call   800467 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8021a6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8021ad:	00 
  8021ae:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021b4:	89 04 24             	mov    %eax,(%esp)
  8021b7:	e8 a3 ef ff ff       	call   80115f <sys_env_set_status>
  8021bc:	85 c0                	test   %eax,%eax
  8021be:	79 30                	jns    8021f0 <spawn+0x580>
		panic("sys_env_set_status: %e", r);
  8021c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021c4:	c7 44 24 08 e3 35 80 	movl   $0x8035e3,0x8(%esp)
  8021cb:	00 
  8021cc:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8021d3:	00 
  8021d4:	c7 04 24 7f 35 80 00 	movl   $0x80357f,(%esp)
  8021db:	e8 87 e2 ff ff       	call   800467 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8021e0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8021e6:	eb 57                	jmp    80223f <spawn+0x5cf>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8021e8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021ee:	eb 4f                	jmp    80223f <spawn+0x5cf>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8021f0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021f6:	eb 47                	jmp    80223f <spawn+0x5cf>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8021f8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8021fd:	eb 40                	jmp    80223f <spawn+0x5cf>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8021ff:	89 c3                	mov    %eax,%ebx
  802201:	eb 06                	jmp    802209 <spawn+0x599>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802203:	89 c3                	mov    %eax,%ebx
  802205:	eb 02                	jmp    802209 <spawn+0x599>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802207:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802209:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80220f:	89 04 24             	mov    %eax,(%esp)
  802212:	e8 4c ed ff ff       	call   800f63 <sys_env_destroy>
	close(fd);
  802217:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80221d:	89 04 24             	mov    %eax,(%esp)
  802220:	e8 d2 f2 ff ff       	call   8014f7 <close>
	return r;
  802225:	89 d8                	mov    %ebx,%eax
  802227:	eb 16                	jmp    80223f <spawn+0x5cf>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802229:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802230:	00 
  802231:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802238:	e8 af ee ff ff       	call   8010ec <sys_page_unmap>
  80223d:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80223f:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    

0080224a <exec>:

int
exec(const char *prog, const char **argv)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	sys_env_destroy(child);
	close(fd);
	return r;*/
	return 0;

}
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    

00802254 <execl>:


int execl(const char *prog, const char *arg0, ...)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802257:	8d 45 10             	lea    0x10(%ebp),%eax


int execl(const char *prog, const char *arg0, ...)
{
	//works same as spawnl
	int argc=0;
  80225a:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80225f:	eb 03                	jmp    802264 <execl+0x10>
		argc++;
  802261:	83 c2 01             	add    $0x1,%edx
{
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802264:	83 c0 04             	add    $0x4,%eax
  802267:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80226b:	75 f4                	jne    802261 <execl+0xd>
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
  802272:	eb 03                	jmp    802277 <execl+0x23>
		argv[i+1] = va_arg(vl, const char *);
  802274:	83 c0 01             	add    $0x1,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802277:	39 d0                	cmp    %edx,%eax
  802279:	75 f9                	jne    802274 <execl+0x20>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
}
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
  802280:	5d                   	pop    %ebp
  802281:	c3                   	ret    

00802282 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	56                   	push   %esi
  802286:	53                   	push   %ebx
  802287:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80228a:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80228d:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802292:	eb 03                	jmp    802297 <spawnl+0x15>
		argc++;
  802294:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802297:	83 c0 04             	add    $0x4,%eax
  80229a:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80229e:	75 f4                	jne    802294 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8022a0:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  8022a7:	83 e0 f0             	and    $0xfffffff0,%eax
  8022aa:	29 c4                	sub    %eax,%esp
  8022ac:	8d 44 24 0b          	lea    0xb(%esp),%eax
  8022b0:	c1 e8 02             	shr    $0x2,%eax
  8022b3:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  8022ba:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8022bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022bf:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  8022c6:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  8022cd:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	eb 0a                	jmp    8022df <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  8022d5:	83 c0 01             	add    $0x1,%eax
  8022d8:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  8022dc:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8022df:	39 d0                	cmp    %edx,%eax
  8022e1:	75 f2                	jne    8022d5 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8022e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	89 04 24             	mov    %eax,(%esp)
  8022ed:	e8 7e f9 ff ff       	call   801c70 <spawn>
}
  8022f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f5:	5b                   	pop    %ebx
  8022f6:	5e                   	pop    %esi
  8022f7:	5d                   	pop    %ebp
  8022f8:	c3                   	ret    
  8022f9:	66 90                	xchg   %ax,%ax
  8022fb:	66 90                	xchg   %ax,%ax
  8022fd:	66 90                	xchg   %ax,%ax
  8022ff:	90                   	nop

00802300 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802306:	c7 44 24 04 22 36 80 	movl   $0x803622,0x4(%esp)
  80230d:	00 
  80230e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802311:	89 04 24             	mov    %eax,(%esp)
  802314:	e8 be e8 ff ff       	call   800bd7 <strcpy>
	return 0;
}
  802319:	b8 00 00 00 00       	mov    $0x0,%eax
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	53                   	push   %ebx
  802324:	83 ec 14             	sub    $0x14,%esp
  802327:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80232a:	89 1c 24             	mov    %ebx,(%esp)
  80232d:	e8 c5 09 00 00       	call   802cf7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802332:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802337:	83 f8 01             	cmp    $0x1,%eax
  80233a:	75 0d                	jne    802349 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80233c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80233f:	89 04 24             	mov    %eax,(%esp)
  802342:	e8 29 03 00 00       	call   802670 <nsipc_close>
  802347:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802349:	89 d0                	mov    %edx,%eax
  80234b:	83 c4 14             	add    $0x14,%esp
  80234e:	5b                   	pop    %ebx
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    

00802351 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802357:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80235e:	00 
  80235f:	8b 45 10             	mov    0x10(%ebp),%eax
  802362:	89 44 24 08          	mov    %eax,0x8(%esp)
  802366:	8b 45 0c             	mov    0xc(%ebp),%eax
  802369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8b 40 0c             	mov    0xc(%eax),%eax
  802373:	89 04 24             	mov    %eax,(%esp)
  802376:	e8 f0 03 00 00       	call   80276b <nsipc_send>
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
  802380:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802383:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80238a:	00 
  80238b:	8b 45 10             	mov    0x10(%ebp),%eax
  80238e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802392:	8b 45 0c             	mov    0xc(%ebp),%eax
  802395:	89 44 24 04          	mov    %eax,0x4(%esp)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8b 40 0c             	mov    0xc(%eax),%eax
  80239f:	89 04 24             	mov    %eax,(%esp)
  8023a2:	e8 44 03 00 00       	call   8026eb <nsipc_recv>
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8023af:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8023b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023b6:	89 04 24             	mov    %eax,(%esp)
  8023b9:	e8 08 f0 ff ff       	call   8013c6 <fd_lookup>
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	78 17                	js     8023d9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  8023cb:	39 08                	cmp    %ecx,(%eax)
  8023cd:	75 05                	jne    8023d4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8023cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d2:	eb 05                	jmp    8023d9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8023d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	83 ec 20             	sub    $0x20,%esp
  8023e3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8023e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023e8:	89 04 24             	mov    %eax,(%esp)
  8023eb:	e8 87 ef ff ff       	call   801377 <fd_alloc>
  8023f0:	89 c3                	mov    %eax,%ebx
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	78 21                	js     802417 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8023f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023fd:	00 
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	89 44 24 04          	mov    %eax,0x4(%esp)
  802405:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80240c:	e8 34 ec ff ff       	call   801045 <sys_page_alloc>
  802411:	89 c3                	mov    %eax,%ebx
  802413:	85 c0                	test   %eax,%eax
  802415:	79 0c                	jns    802423 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802417:	89 34 24             	mov    %esi,(%esp)
  80241a:	e8 51 02 00 00       	call   802670 <nsipc_close>
		return r;
  80241f:	89 d8                	mov    %ebx,%eax
  802421:	eb 20                	jmp    802443 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802423:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80242e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802431:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802438:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80243b:	89 14 24             	mov    %edx,(%esp)
  80243e:	e8 0d ef ff ff       	call   801350 <fd2num>
}
  802443:	83 c4 20             	add    $0x20,%esp
  802446:	5b                   	pop    %ebx
  802447:	5e                   	pop    %esi
  802448:	5d                   	pop    %ebp
  802449:	c3                   	ret    

0080244a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	e8 51 ff ff ff       	call   8023a9 <fd2sockid>
		return r;
  802458:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80245a:	85 c0                	test   %eax,%eax
  80245c:	78 23                	js     802481 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80245e:	8b 55 10             	mov    0x10(%ebp),%edx
  802461:	89 54 24 08          	mov    %edx,0x8(%esp)
  802465:	8b 55 0c             	mov    0xc(%ebp),%edx
  802468:	89 54 24 04          	mov    %edx,0x4(%esp)
  80246c:	89 04 24             	mov    %eax,(%esp)
  80246f:	e8 45 01 00 00       	call   8025b9 <nsipc_accept>
		return r;
  802474:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802476:	85 c0                	test   %eax,%eax
  802478:	78 07                	js     802481 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80247a:	e8 5c ff ff ff       	call   8023db <alloc_sockfd>
  80247f:	89 c1                	mov    %eax,%ecx
}
  802481:	89 c8                	mov    %ecx,%eax
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	e8 16 ff ff ff       	call   8023a9 <fd2sockid>
  802493:	89 c2                	mov    %eax,%edx
  802495:	85 d2                	test   %edx,%edx
  802497:	78 16                	js     8024af <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802499:	8b 45 10             	mov    0x10(%ebp),%eax
  80249c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a7:	89 14 24             	mov    %edx,(%esp)
  8024aa:	e8 60 01 00 00       	call   80260f <nsipc_bind>
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <shutdown>:

int
shutdown(int s, int how)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	e8 ea fe ff ff       	call   8023a9 <fd2sockid>
  8024bf:	89 c2                	mov    %eax,%edx
  8024c1:	85 d2                	test   %edx,%edx
  8024c3:	78 0f                	js     8024d4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8024c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cc:	89 14 24             	mov    %edx,(%esp)
  8024cf:	e8 7a 01 00 00       	call   80264e <nsipc_shutdown>
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	e8 c5 fe ff ff       	call   8023a9 <fd2sockid>
  8024e4:	89 c2                	mov    %eax,%edx
  8024e6:	85 d2                	test   %edx,%edx
  8024e8:	78 16                	js     802500 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8024ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f8:	89 14 24             	mov    %edx,(%esp)
  8024fb:	e8 8a 01 00 00       	call   80268a <nsipc_connect>
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <listen>:

int
listen(int s, int backlog)
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
  802505:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802508:	8b 45 08             	mov    0x8(%ebp),%eax
  80250b:	e8 99 fe ff ff       	call   8023a9 <fd2sockid>
  802510:	89 c2                	mov    %eax,%edx
  802512:	85 d2                	test   %edx,%edx
  802514:	78 0f                	js     802525 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802516:	8b 45 0c             	mov    0xc(%ebp),%eax
  802519:	89 44 24 04          	mov    %eax,0x4(%esp)
  80251d:	89 14 24             	mov    %edx,(%esp)
  802520:	e8 a4 01 00 00       	call   8026c9 <nsipc_listen>
}
  802525:	c9                   	leave  
  802526:	c3                   	ret    

00802527 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80252d:	8b 45 10             	mov    0x10(%ebp),%eax
  802530:	89 44 24 08          	mov    %eax,0x8(%esp)
  802534:	8b 45 0c             	mov    0xc(%ebp),%eax
  802537:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	89 04 24             	mov    %eax,(%esp)
  802541:	e8 98 02 00 00       	call   8027de <nsipc_socket>
  802546:	89 c2                	mov    %eax,%edx
  802548:	85 d2                	test   %edx,%edx
  80254a:	78 05                	js     802551 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80254c:	e8 8a fe ff ff       	call   8023db <alloc_sockfd>
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	53                   	push   %ebx
  802557:	83 ec 14             	sub    $0x14,%esp
  80255a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80255c:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802563:	75 11                	jne    802576 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802565:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80256c:	e8 4e 07 00 00       	call   802cbf <ipc_find_env>
  802571:	a3 04 60 80 00       	mov    %eax,0x806004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802576:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80257d:	00 
  80257e:	c7 44 24 08 00 90 80 	movl   $0x809000,0x8(%esp)
  802585:	00 
  802586:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80258a:	a1 04 60 80 00       	mov    0x806004,%eax
  80258f:	89 04 24             	mov    %eax,(%esp)
  802592:	e8 c1 06 00 00       	call   802c58 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802597:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80259e:	00 
  80259f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8025a6:	00 
  8025a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025ae:	e8 3d 06 00 00       	call   802bf0 <ipc_recv>
}
  8025b3:	83 c4 14             	add    $0x14,%esp
  8025b6:	5b                   	pop    %ebx
  8025b7:	5d                   	pop    %ebp
  8025b8:	c3                   	ret    

008025b9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	56                   	push   %esi
  8025bd:	53                   	push   %ebx
  8025be:	83 ec 10             	sub    $0x10,%esp
  8025c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8025cc:	8b 06                	mov    (%esi),%eax
  8025ce:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d8:	e8 76 ff ff ff       	call   802553 <nsipc>
  8025dd:	89 c3                	mov    %eax,%ebx
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	78 23                	js     802606 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8025e3:	a1 10 90 80 00       	mov    0x809010,%eax
  8025e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025ec:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  8025f3:	00 
  8025f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f7:	89 04 24             	mov    %eax,(%esp)
  8025fa:	e8 75 e7 ff ff       	call   800d74 <memmove>
		*addrlen = ret->ret_addrlen;
  8025ff:	a1 10 90 80 00       	mov    0x809010,%eax
  802604:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802606:	89 d8                	mov    %ebx,%eax
  802608:	83 c4 10             	add    $0x10,%esp
  80260b:	5b                   	pop    %ebx
  80260c:	5e                   	pop    %esi
  80260d:	5d                   	pop    %ebp
  80260e:	c3                   	ret    

0080260f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	53                   	push   %ebx
  802613:	83 ec 14             	sub    $0x14,%esp
  802616:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802621:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802625:	8b 45 0c             	mov    0xc(%ebp),%eax
  802628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262c:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  802633:	e8 3c e7 ff ff       	call   800d74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802638:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  80263e:	b8 02 00 00 00       	mov    $0x2,%eax
  802643:	e8 0b ff ff ff       	call   802553 <nsipc>
}
  802648:	83 c4 14             	add    $0x14,%esp
  80264b:	5b                   	pop    %ebx
  80264c:	5d                   	pop    %ebp
  80264d:	c3                   	ret    

0080264e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  80265c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265f:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  802664:	b8 03 00 00 00       	mov    $0x3,%eax
  802669:	e8 e5 fe ff ff       	call   802553 <nsipc>
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <nsipc_close>:

int
nsipc_close(int s)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  80267e:	b8 04 00 00 00       	mov    $0x4,%eax
  802683:	e8 cb fe ff ff       	call   802553 <nsipc>
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	53                   	push   %ebx
  80268e:	83 ec 14             	sub    $0x14,%esp
  802691:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80269c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a7:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  8026ae:	e8 c1 e6 ff ff       	call   800d74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8026b3:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  8026b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8026be:	e8 90 fe ff ff       	call   802553 <nsipc>
}
  8026c3:	83 c4 14             	add    $0x14,%esp
  8026c6:	5b                   	pop    %ebx
  8026c7:	5d                   	pop    %ebp
  8026c8:	c3                   	ret    

008026c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8026c9:	55                   	push   %ebp
  8026ca:	89 e5                	mov    %esp,%ebp
  8026cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  8026d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026da:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  8026df:	b8 06 00 00 00       	mov    $0x6,%eax
  8026e4:	e8 6a fe ff ff       	call   802553 <nsipc>
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	56                   	push   %esi
  8026ef:	53                   	push   %ebx
  8026f0:	83 ec 10             	sub    $0x10,%esp
  8026f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  8026fe:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  802704:	8b 45 14             	mov    0x14(%ebp),%eax
  802707:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80270c:	b8 07 00 00 00       	mov    $0x7,%eax
  802711:	e8 3d fe ff ff       	call   802553 <nsipc>
  802716:	89 c3                	mov    %eax,%ebx
  802718:	85 c0                	test   %eax,%eax
  80271a:	78 46                	js     802762 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80271c:	39 f0                	cmp    %esi,%eax
  80271e:	7f 07                	jg     802727 <nsipc_recv+0x3c>
  802720:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802725:	7e 24                	jle    80274b <nsipc_recv+0x60>
  802727:	c7 44 24 0c 2e 36 80 	movl   $0x80362e,0xc(%esp)
  80272e:	00 
  80272f:	c7 44 24 08 20 35 80 	movl   $0x803520,0x8(%esp)
  802736:	00 
  802737:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80273e:	00 
  80273f:	c7 04 24 43 36 80 00 	movl   $0x803643,(%esp)
  802746:	e8 1c dd ff ff       	call   800467 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80274b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80274f:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  802756:	00 
  802757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275a:	89 04 24             	mov    %eax,(%esp)
  80275d:	e8 12 e6 ff ff       	call   800d74 <memmove>
	}

	return r;
}
  802762:	89 d8                	mov    %ebx,%eax
  802764:	83 c4 10             	add    $0x10,%esp
  802767:	5b                   	pop    %ebx
  802768:	5e                   	pop    %esi
  802769:	5d                   	pop    %ebp
  80276a:	c3                   	ret    

0080276b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	53                   	push   %ebx
  80276f:	83 ec 14             	sub    $0x14,%esp
  802772:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802775:	8b 45 08             	mov    0x8(%ebp),%eax
  802778:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  80277d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802783:	7e 24                	jle    8027a9 <nsipc_send+0x3e>
  802785:	c7 44 24 0c 4f 36 80 	movl   $0x80364f,0xc(%esp)
  80278c:	00 
  80278d:	c7 44 24 08 20 35 80 	movl   $0x803520,0x8(%esp)
  802794:	00 
  802795:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80279c:	00 
  80279d:	c7 04 24 43 36 80 00 	movl   $0x803643,(%esp)
  8027a4:	e8 be dc ff ff       	call   800467 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8027a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b4:	c7 04 24 0c 90 80 00 	movl   $0x80900c,(%esp)
  8027bb:	e8 b4 e5 ff ff       	call   800d74 <memmove>
	nsipcbuf.send.req_size = size;
  8027c0:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  8027c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8027c9:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  8027ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8027d3:	e8 7b fd ff ff       	call   802553 <nsipc>
}
  8027d8:	83 c4 14             	add    $0x14,%esp
  8027db:	5b                   	pop    %ebx
  8027dc:	5d                   	pop    %ebp
  8027dd:	c3                   	ret    

008027de <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
  8027e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  8027ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ef:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  8027f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f7:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  8027fc:	b8 09 00 00 00       	mov    $0x9,%eax
  802801:	e8 4d fd ff ff       	call   802553 <nsipc>
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
  80280b:	56                   	push   %esi
  80280c:	53                   	push   %ebx
  80280d:	83 ec 10             	sub    $0x10,%esp
  802810:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	89 04 24             	mov    %eax,(%esp)
  802819:	e8 42 eb ff ff       	call   801360 <fd2data>
  80281e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802820:	c7 44 24 04 5b 36 80 	movl   $0x80365b,0x4(%esp)
  802827:	00 
  802828:	89 1c 24             	mov    %ebx,(%esp)
  80282b:	e8 a7 e3 ff ff       	call   800bd7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802830:	8b 46 04             	mov    0x4(%esi),%eax
  802833:	2b 06                	sub    (%esi),%eax
  802835:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80283b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802842:	00 00 00 
	stat->st_dev = &devpipe;
  802845:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  80284c:	57 80 00 
	return 0;
}
  80284f:	b8 00 00 00 00       	mov    $0x0,%eax
  802854:	83 c4 10             	add    $0x10,%esp
  802857:	5b                   	pop    %ebx
  802858:	5e                   	pop    %esi
  802859:	5d                   	pop    %ebp
  80285a:	c3                   	ret    

0080285b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	53                   	push   %ebx
  80285f:	83 ec 14             	sub    $0x14,%esp
  802862:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802865:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802869:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802870:	e8 77 e8 ff ff       	call   8010ec <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802875:	89 1c 24             	mov    %ebx,(%esp)
  802878:	e8 e3 ea ff ff       	call   801360 <fd2data>
  80287d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802881:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802888:	e8 5f e8 ff ff       	call   8010ec <sys_page_unmap>
}
  80288d:	83 c4 14             	add    $0x14,%esp
  802890:	5b                   	pop    %ebx
  802891:	5d                   	pop    %ebp
  802892:	c3                   	ret    

00802893 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
  802896:	57                   	push   %edi
  802897:	56                   	push   %esi
  802898:	53                   	push   %ebx
  802899:	83 ec 2c             	sub    $0x2c,%esp
  80289c:	89 c6                	mov    %eax,%esi
  80289e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8028a1:	a1 90 77 80 00       	mov    0x807790,%eax
  8028a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8028a9:	89 34 24             	mov    %esi,(%esp)
  8028ac:	e8 46 04 00 00       	call   802cf7 <pageref>
  8028b1:	89 c7                	mov    %eax,%edi
  8028b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b6:	89 04 24             	mov    %eax,(%esp)
  8028b9:	e8 39 04 00 00       	call   802cf7 <pageref>
  8028be:	39 c7                	cmp    %eax,%edi
  8028c0:	0f 94 c2             	sete   %dl
  8028c3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8028c6:	8b 0d 90 77 80 00    	mov    0x807790,%ecx
  8028cc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8028cf:	39 fb                	cmp    %edi,%ebx
  8028d1:	74 21                	je     8028f4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8028d3:	84 d2                	test   %dl,%dl
  8028d5:	74 ca                	je     8028a1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8028d7:	8b 51 58             	mov    0x58(%ecx),%edx
  8028da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028e6:	c7 04 24 62 36 80 00 	movl   $0x803662,(%esp)
  8028ed:	e8 6e dc ff ff       	call   800560 <cprintf>
  8028f2:	eb ad                	jmp    8028a1 <_pipeisclosed+0xe>
	}
}
  8028f4:	83 c4 2c             	add    $0x2c,%esp
  8028f7:	5b                   	pop    %ebx
  8028f8:	5e                   	pop    %esi
  8028f9:	5f                   	pop    %edi
  8028fa:	5d                   	pop    %ebp
  8028fb:	c3                   	ret    

008028fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	57                   	push   %edi
  802900:	56                   	push   %esi
  802901:	53                   	push   %ebx
  802902:	83 ec 1c             	sub    $0x1c,%esp
  802905:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802908:	89 34 24             	mov    %esi,(%esp)
  80290b:	e8 50 ea ff ff       	call   801360 <fd2data>
  802910:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802912:	bf 00 00 00 00       	mov    $0x0,%edi
  802917:	eb 45                	jmp    80295e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802919:	89 da                	mov    %ebx,%edx
  80291b:	89 f0                	mov    %esi,%eax
  80291d:	e8 71 ff ff ff       	call   802893 <_pipeisclosed>
  802922:	85 c0                	test   %eax,%eax
  802924:	75 41                	jne    802967 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802926:	e8 fb e6 ff ff       	call   801026 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80292b:	8b 43 04             	mov    0x4(%ebx),%eax
  80292e:	8b 0b                	mov    (%ebx),%ecx
  802930:	8d 51 20             	lea    0x20(%ecx),%edx
  802933:	39 d0                	cmp    %edx,%eax
  802935:	73 e2                	jae    802919 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802937:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80293a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80293e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802941:	99                   	cltd   
  802942:	c1 ea 1b             	shr    $0x1b,%edx
  802945:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802948:	83 e1 1f             	and    $0x1f,%ecx
  80294b:	29 d1                	sub    %edx,%ecx
  80294d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802951:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802955:	83 c0 01             	add    $0x1,%eax
  802958:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80295b:	83 c7 01             	add    $0x1,%edi
  80295e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802961:	75 c8                	jne    80292b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802963:	89 f8                	mov    %edi,%eax
  802965:	eb 05                	jmp    80296c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80296c:	83 c4 1c             	add    $0x1c,%esp
  80296f:	5b                   	pop    %ebx
  802970:	5e                   	pop    %esi
  802971:	5f                   	pop    %edi
  802972:	5d                   	pop    %ebp
  802973:	c3                   	ret    

00802974 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802974:	55                   	push   %ebp
  802975:	89 e5                	mov    %esp,%ebp
  802977:	57                   	push   %edi
  802978:	56                   	push   %esi
  802979:	53                   	push   %ebx
  80297a:	83 ec 1c             	sub    $0x1c,%esp
  80297d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802980:	89 3c 24             	mov    %edi,(%esp)
  802983:	e8 d8 e9 ff ff       	call   801360 <fd2data>
  802988:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80298a:	be 00 00 00 00       	mov    $0x0,%esi
  80298f:	eb 3d                	jmp    8029ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802991:	85 f6                	test   %esi,%esi
  802993:	74 04                	je     802999 <devpipe_read+0x25>
				return i;
  802995:	89 f0                	mov    %esi,%eax
  802997:	eb 43                	jmp    8029dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802999:	89 da                	mov    %ebx,%edx
  80299b:	89 f8                	mov    %edi,%eax
  80299d:	e8 f1 fe ff ff       	call   802893 <_pipeisclosed>
  8029a2:	85 c0                	test   %eax,%eax
  8029a4:	75 31                	jne    8029d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8029a6:	e8 7b e6 ff ff       	call   801026 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8029ab:	8b 03                	mov    (%ebx),%eax
  8029ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8029b0:	74 df                	je     802991 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8029b2:	99                   	cltd   
  8029b3:	c1 ea 1b             	shr    $0x1b,%edx
  8029b6:	01 d0                	add    %edx,%eax
  8029b8:	83 e0 1f             	and    $0x1f,%eax
  8029bb:	29 d0                	sub    %edx,%eax
  8029bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8029c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8029c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029cb:	83 c6 01             	add    $0x1,%esi
  8029ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029d1:	75 d8                	jne    8029ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8029d3:	89 f0                	mov    %esi,%eax
  8029d5:	eb 05                	jmp    8029dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8029d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8029dc:	83 c4 1c             	add    $0x1c,%esp
  8029df:	5b                   	pop    %ebx
  8029e0:	5e                   	pop    %esi
  8029e1:	5f                   	pop    %edi
  8029e2:	5d                   	pop    %ebp
  8029e3:	c3                   	ret    

008029e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8029e4:	55                   	push   %ebp
  8029e5:	89 e5                	mov    %esp,%ebp
  8029e7:	56                   	push   %esi
  8029e8:	53                   	push   %ebx
  8029e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8029ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029ef:	89 04 24             	mov    %eax,(%esp)
  8029f2:	e8 80 e9 ff ff       	call   801377 <fd_alloc>
  8029f7:	89 c2                	mov    %eax,%edx
  8029f9:	85 d2                	test   %edx,%edx
  8029fb:	0f 88 4d 01 00 00    	js     802b4e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a01:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a08:	00 
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a17:	e8 29 e6 ff ff       	call   801045 <sys_page_alloc>
  802a1c:	89 c2                	mov    %eax,%edx
  802a1e:	85 d2                	test   %edx,%edx
  802a20:	0f 88 28 01 00 00    	js     802b4e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802a26:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a29:	89 04 24             	mov    %eax,(%esp)
  802a2c:	e8 46 e9 ff ff       	call   801377 <fd_alloc>
  802a31:	89 c3                	mov    %eax,%ebx
  802a33:	85 c0                	test   %eax,%eax
  802a35:	0f 88 fe 00 00 00    	js     802b39 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a3b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a42:	00 
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a51:	e8 ef e5 ff ff       	call   801045 <sys_page_alloc>
  802a56:	89 c3                	mov    %eax,%ebx
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	0f 88 d9 00 00 00    	js     802b39 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	89 04 24             	mov    %eax,(%esp)
  802a66:	e8 f5 e8 ff ff       	call   801360 <fd2data>
  802a6b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a6d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a74:	00 
  802a75:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a80:	e8 c0 e5 ff ff       	call   801045 <sys_page_alloc>
  802a85:	89 c3                	mov    %eax,%ebx
  802a87:	85 c0                	test   %eax,%eax
  802a89:	0f 88 97 00 00 00    	js     802b26 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	89 04 24             	mov    %eax,(%esp)
  802a95:	e8 c6 e8 ff ff       	call   801360 <fd2data>
  802a9a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802aa1:	00 
  802aa2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802aa6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802aad:	00 
  802aae:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ab2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ab9:	e8 db e5 ff ff       	call   801099 <sys_page_map>
  802abe:	89 c3                	mov    %eax,%ebx
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	78 52                	js     802b16 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802ac4:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802ad9:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	89 04 24             	mov    %eax,(%esp)
  802af4:	e8 57 e8 ff ff       	call   801350 <fd2num>
  802af9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802afc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	89 04 24             	mov    %eax,(%esp)
  802b04:	e8 47 e8 ff ff       	call   801350 <fd2num>
  802b09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b0c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b14:	eb 38                	jmp    802b4e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802b16:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b21:	e8 c6 e5 ff ff       	call   8010ec <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b34:	e8 b3 e5 ff ff       	call   8010ec <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b47:	e8 a0 e5 ff ff       	call   8010ec <sys_page_unmap>
  802b4c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802b4e:	83 c4 30             	add    $0x30,%esp
  802b51:	5b                   	pop    %ebx
  802b52:	5e                   	pop    %esi
  802b53:	5d                   	pop    %ebp
  802b54:	c3                   	ret    

00802b55 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802b55:	55                   	push   %ebp
  802b56:	89 e5                	mov    %esp,%ebp
  802b58:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	89 04 24             	mov    %eax,(%esp)
  802b68:	e8 59 e8 ff ff       	call   8013c6 <fd_lookup>
  802b6d:	89 c2                	mov    %eax,%edx
  802b6f:	85 d2                	test   %edx,%edx
  802b71:	78 15                	js     802b88 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	89 04 24             	mov    %eax,(%esp)
  802b79:	e8 e2 e7 ff ff       	call   801360 <fd2data>
	return _pipeisclosed(fd, p);
  802b7e:	89 c2                	mov    %eax,%edx
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	e8 0b fd ff ff       	call   802893 <_pipeisclosed>
}
  802b88:	c9                   	leave  
  802b89:	c3                   	ret    

00802b8a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802b8a:	55                   	push   %ebp
  802b8b:	89 e5                	mov    %esp,%ebp
  802b8d:	56                   	push   %esi
  802b8e:	53                   	push   %ebx
  802b8f:	83 ec 10             	sub    $0x10,%esp
  802b92:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802b95:	85 f6                	test   %esi,%esi
  802b97:	75 24                	jne    802bbd <wait+0x33>
  802b99:	c7 44 24 0c 7a 36 80 	movl   $0x80367a,0xc(%esp)
  802ba0:	00 
  802ba1:	c7 44 24 08 20 35 80 	movl   $0x803520,0x8(%esp)
  802ba8:	00 
  802ba9:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802bb0:	00 
  802bb1:	c7 04 24 85 36 80 00 	movl   $0x803685,(%esp)
  802bb8:	e8 aa d8 ff ff       	call   800467 <_panic>
	e = &envs[ENVX(envid)];
  802bbd:	89 f3                	mov    %esi,%ebx
  802bbf:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802bc5:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802bc8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802bce:	eb 05                	jmp    802bd5 <wait+0x4b>
		sys_yield();
  802bd0:	e8 51 e4 ff ff       	call   801026 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802bd5:	8b 43 48             	mov    0x48(%ebx),%eax
  802bd8:	39 f0                	cmp    %esi,%eax
  802bda:	75 07                	jne    802be3 <wait+0x59>
  802bdc:	8b 43 54             	mov    0x54(%ebx),%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	75 ed                	jne    802bd0 <wait+0x46>
		sys_yield();
}
  802be3:	83 c4 10             	add    $0x10,%esp
  802be6:	5b                   	pop    %ebx
  802be7:	5e                   	pop    %esi
  802be8:	5d                   	pop    %ebp
  802be9:	c3                   	ret    
  802bea:	66 90                	xchg   %ax,%ax
  802bec:	66 90                	xchg   %ax,%ax
  802bee:	66 90                	xchg   %ax,%ax

00802bf0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	56                   	push   %esi
  802bf4:	53                   	push   %ebx
  802bf5:	83 ec 10             	sub    $0x10,%esp
  802bf8:	8b 75 08             	mov    0x8(%ebp),%esi
  802bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802c01:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802c03:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802c08:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c0b:	89 04 24             	mov    %eax,(%esp)
  802c0e:	e8 68 e6 ff ff       	call   80127b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802c13:	85 c0                	test   %eax,%eax
  802c15:	75 26                	jne    802c3d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802c17:	85 f6                	test   %esi,%esi
  802c19:	74 0a                	je     802c25 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802c1b:	a1 90 77 80 00       	mov    0x807790,%eax
  802c20:	8b 40 74             	mov    0x74(%eax),%eax
  802c23:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802c25:	85 db                	test   %ebx,%ebx
  802c27:	74 0a                	je     802c33 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802c29:	a1 90 77 80 00       	mov    0x807790,%eax
  802c2e:	8b 40 78             	mov    0x78(%eax),%eax
  802c31:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802c33:	a1 90 77 80 00       	mov    0x807790,%eax
  802c38:	8b 40 70             	mov    0x70(%eax),%eax
  802c3b:	eb 14                	jmp    802c51 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802c3d:	85 f6                	test   %esi,%esi
  802c3f:	74 06                	je     802c47 <ipc_recv+0x57>
			*from_env_store = 0;
  802c41:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802c47:	85 db                	test   %ebx,%ebx
  802c49:	74 06                	je     802c51 <ipc_recv+0x61>
			*perm_store = 0;
  802c4b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802c51:	83 c4 10             	add    $0x10,%esp
  802c54:	5b                   	pop    %ebx
  802c55:	5e                   	pop    %esi
  802c56:	5d                   	pop    %ebp
  802c57:	c3                   	ret    

00802c58 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802c58:	55                   	push   %ebp
  802c59:	89 e5                	mov    %esp,%ebp
  802c5b:	57                   	push   %edi
  802c5c:	56                   	push   %esi
  802c5d:	53                   	push   %ebx
  802c5e:	83 ec 1c             	sub    $0x1c,%esp
  802c61:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c64:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c67:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802c6a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802c6c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802c71:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802c74:	8b 45 14             	mov    0x14(%ebp),%eax
  802c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c7f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c83:	89 3c 24             	mov    %edi,(%esp)
  802c86:	e8 cd e5 ff ff       	call   801258 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 28                	je     802cb7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802c8f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c92:	74 1c                	je     802cb0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802c94:	c7 44 24 08 90 36 80 	movl   $0x803690,0x8(%esp)
  802c9b:	00 
  802c9c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802ca3:	00 
  802ca4:	c7 04 24 b4 36 80 00 	movl   $0x8036b4,(%esp)
  802cab:	e8 b7 d7 ff ff       	call   800467 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802cb0:	e8 71 e3 ff ff       	call   801026 <sys_yield>
	}
  802cb5:	eb bd                	jmp    802c74 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802cb7:	83 c4 1c             	add    $0x1c,%esp
  802cba:	5b                   	pop    %ebx
  802cbb:	5e                   	pop    %esi
  802cbc:	5f                   	pop    %edi
  802cbd:	5d                   	pop    %ebp
  802cbe:	c3                   	ret    

00802cbf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802cbf:	55                   	push   %ebp
  802cc0:	89 e5                	mov    %esp,%ebp
  802cc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802cc5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802cca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802ccd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802cd3:	8b 52 50             	mov    0x50(%edx),%edx
  802cd6:	39 ca                	cmp    %ecx,%edx
  802cd8:	75 0d                	jne    802ce7 <ipc_find_env+0x28>
			return envs[i].env_id;
  802cda:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802cdd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802ce2:	8b 40 40             	mov    0x40(%eax),%eax
  802ce5:	eb 0e                	jmp    802cf5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802ce7:	83 c0 01             	add    $0x1,%eax
  802cea:	3d 00 04 00 00       	cmp    $0x400,%eax
  802cef:	75 d9                	jne    802cca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802cf1:	66 b8 00 00          	mov    $0x0,%ax
}
  802cf5:	5d                   	pop    %ebp
  802cf6:	c3                   	ret    

00802cf7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802cf7:	55                   	push   %ebp
  802cf8:	89 e5                	mov    %esp,%ebp
  802cfa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802cfd:	89 d0                	mov    %edx,%eax
  802cff:	c1 e8 16             	shr    $0x16,%eax
  802d02:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d09:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d0e:	f6 c1 01             	test   $0x1,%cl
  802d11:	74 1d                	je     802d30 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802d13:	c1 ea 0c             	shr    $0xc,%edx
  802d16:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d1d:	f6 c2 01             	test   $0x1,%dl
  802d20:	74 0e                	je     802d30 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d22:	c1 ea 0c             	shr    $0xc,%edx
  802d25:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d2c:	ef 
  802d2d:	0f b7 c0             	movzwl %ax,%eax
}
  802d30:	5d                   	pop    %ebp
  802d31:	c3                   	ret    
  802d32:	66 90                	xchg   %ax,%ax
  802d34:	66 90                	xchg   %ax,%ax
  802d36:	66 90                	xchg   %ax,%ax
  802d38:	66 90                	xchg   %ax,%ax
  802d3a:	66 90                	xchg   %ax,%ax
  802d3c:	66 90                	xchg   %ax,%ax
  802d3e:	66 90                	xchg   %ax,%ax

00802d40 <__udivdi3>:
  802d40:	55                   	push   %ebp
  802d41:	57                   	push   %edi
  802d42:	56                   	push   %esi
  802d43:	83 ec 0c             	sub    $0xc,%esp
  802d46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802d4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802d4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802d52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802d56:	85 c0                	test   %eax,%eax
  802d58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d5c:	89 ea                	mov    %ebp,%edx
  802d5e:	89 0c 24             	mov    %ecx,(%esp)
  802d61:	75 2d                	jne    802d90 <__udivdi3+0x50>
  802d63:	39 e9                	cmp    %ebp,%ecx
  802d65:	77 61                	ja     802dc8 <__udivdi3+0x88>
  802d67:	85 c9                	test   %ecx,%ecx
  802d69:	89 ce                	mov    %ecx,%esi
  802d6b:	75 0b                	jne    802d78 <__udivdi3+0x38>
  802d6d:	b8 01 00 00 00       	mov    $0x1,%eax
  802d72:	31 d2                	xor    %edx,%edx
  802d74:	f7 f1                	div    %ecx
  802d76:	89 c6                	mov    %eax,%esi
  802d78:	31 d2                	xor    %edx,%edx
  802d7a:	89 e8                	mov    %ebp,%eax
  802d7c:	f7 f6                	div    %esi
  802d7e:	89 c5                	mov    %eax,%ebp
  802d80:	89 f8                	mov    %edi,%eax
  802d82:	f7 f6                	div    %esi
  802d84:	89 ea                	mov    %ebp,%edx
  802d86:	83 c4 0c             	add    $0xc,%esp
  802d89:	5e                   	pop    %esi
  802d8a:	5f                   	pop    %edi
  802d8b:	5d                   	pop    %ebp
  802d8c:	c3                   	ret    
  802d8d:	8d 76 00             	lea    0x0(%esi),%esi
  802d90:	39 e8                	cmp    %ebp,%eax
  802d92:	77 24                	ja     802db8 <__udivdi3+0x78>
  802d94:	0f bd e8             	bsr    %eax,%ebp
  802d97:	83 f5 1f             	xor    $0x1f,%ebp
  802d9a:	75 3c                	jne    802dd8 <__udivdi3+0x98>
  802d9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802da0:	39 34 24             	cmp    %esi,(%esp)
  802da3:	0f 86 9f 00 00 00    	jbe    802e48 <__udivdi3+0x108>
  802da9:	39 d0                	cmp    %edx,%eax
  802dab:	0f 82 97 00 00 00    	jb     802e48 <__udivdi3+0x108>
  802db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802db8:	31 d2                	xor    %edx,%edx
  802dba:	31 c0                	xor    %eax,%eax
  802dbc:	83 c4 0c             	add    $0xc,%esp
  802dbf:	5e                   	pop    %esi
  802dc0:	5f                   	pop    %edi
  802dc1:	5d                   	pop    %ebp
  802dc2:	c3                   	ret    
  802dc3:	90                   	nop
  802dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dc8:	89 f8                	mov    %edi,%eax
  802dca:	f7 f1                	div    %ecx
  802dcc:	31 d2                	xor    %edx,%edx
  802dce:	83 c4 0c             	add    $0xc,%esp
  802dd1:	5e                   	pop    %esi
  802dd2:	5f                   	pop    %edi
  802dd3:	5d                   	pop    %ebp
  802dd4:	c3                   	ret    
  802dd5:	8d 76 00             	lea    0x0(%esi),%esi
  802dd8:	89 e9                	mov    %ebp,%ecx
  802dda:	8b 3c 24             	mov    (%esp),%edi
  802ddd:	d3 e0                	shl    %cl,%eax
  802ddf:	89 c6                	mov    %eax,%esi
  802de1:	b8 20 00 00 00       	mov    $0x20,%eax
  802de6:	29 e8                	sub    %ebp,%eax
  802de8:	89 c1                	mov    %eax,%ecx
  802dea:	d3 ef                	shr    %cl,%edi
  802dec:	89 e9                	mov    %ebp,%ecx
  802dee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802df2:	8b 3c 24             	mov    (%esp),%edi
  802df5:	09 74 24 08          	or     %esi,0x8(%esp)
  802df9:	89 d6                	mov    %edx,%esi
  802dfb:	d3 e7                	shl    %cl,%edi
  802dfd:	89 c1                	mov    %eax,%ecx
  802dff:	89 3c 24             	mov    %edi,(%esp)
  802e02:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802e06:	d3 ee                	shr    %cl,%esi
  802e08:	89 e9                	mov    %ebp,%ecx
  802e0a:	d3 e2                	shl    %cl,%edx
  802e0c:	89 c1                	mov    %eax,%ecx
  802e0e:	d3 ef                	shr    %cl,%edi
  802e10:	09 d7                	or     %edx,%edi
  802e12:	89 f2                	mov    %esi,%edx
  802e14:	89 f8                	mov    %edi,%eax
  802e16:	f7 74 24 08          	divl   0x8(%esp)
  802e1a:	89 d6                	mov    %edx,%esi
  802e1c:	89 c7                	mov    %eax,%edi
  802e1e:	f7 24 24             	mull   (%esp)
  802e21:	39 d6                	cmp    %edx,%esi
  802e23:	89 14 24             	mov    %edx,(%esp)
  802e26:	72 30                	jb     802e58 <__udivdi3+0x118>
  802e28:	8b 54 24 04          	mov    0x4(%esp),%edx
  802e2c:	89 e9                	mov    %ebp,%ecx
  802e2e:	d3 e2                	shl    %cl,%edx
  802e30:	39 c2                	cmp    %eax,%edx
  802e32:	73 05                	jae    802e39 <__udivdi3+0xf9>
  802e34:	3b 34 24             	cmp    (%esp),%esi
  802e37:	74 1f                	je     802e58 <__udivdi3+0x118>
  802e39:	89 f8                	mov    %edi,%eax
  802e3b:	31 d2                	xor    %edx,%edx
  802e3d:	e9 7a ff ff ff       	jmp    802dbc <__udivdi3+0x7c>
  802e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e48:	31 d2                	xor    %edx,%edx
  802e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802e4f:	e9 68 ff ff ff       	jmp    802dbc <__udivdi3+0x7c>
  802e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e58:	8d 47 ff             	lea    -0x1(%edi),%eax
  802e5b:	31 d2                	xor    %edx,%edx
  802e5d:	83 c4 0c             	add    $0xc,%esp
  802e60:	5e                   	pop    %esi
  802e61:	5f                   	pop    %edi
  802e62:	5d                   	pop    %ebp
  802e63:	c3                   	ret    
  802e64:	66 90                	xchg   %ax,%ax
  802e66:	66 90                	xchg   %ax,%ax
  802e68:	66 90                	xchg   %ax,%ax
  802e6a:	66 90                	xchg   %ax,%ax
  802e6c:	66 90                	xchg   %ax,%ax
  802e6e:	66 90                	xchg   %ax,%ax

00802e70 <__umoddi3>:
  802e70:	55                   	push   %ebp
  802e71:	57                   	push   %edi
  802e72:	56                   	push   %esi
  802e73:	83 ec 14             	sub    $0x14,%esp
  802e76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802e7a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802e7e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802e82:	89 c7                	mov    %eax,%edi
  802e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e88:	8b 44 24 30          	mov    0x30(%esp),%eax
  802e8c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802e90:	89 34 24             	mov    %esi,(%esp)
  802e93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e97:	85 c0                	test   %eax,%eax
  802e99:	89 c2                	mov    %eax,%edx
  802e9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e9f:	75 17                	jne    802eb8 <__umoddi3+0x48>
  802ea1:	39 fe                	cmp    %edi,%esi
  802ea3:	76 4b                	jbe    802ef0 <__umoddi3+0x80>
  802ea5:	89 c8                	mov    %ecx,%eax
  802ea7:	89 fa                	mov    %edi,%edx
  802ea9:	f7 f6                	div    %esi
  802eab:	89 d0                	mov    %edx,%eax
  802ead:	31 d2                	xor    %edx,%edx
  802eaf:	83 c4 14             	add    $0x14,%esp
  802eb2:	5e                   	pop    %esi
  802eb3:	5f                   	pop    %edi
  802eb4:	5d                   	pop    %ebp
  802eb5:	c3                   	ret    
  802eb6:	66 90                	xchg   %ax,%ax
  802eb8:	39 f8                	cmp    %edi,%eax
  802eba:	77 54                	ja     802f10 <__umoddi3+0xa0>
  802ebc:	0f bd e8             	bsr    %eax,%ebp
  802ebf:	83 f5 1f             	xor    $0x1f,%ebp
  802ec2:	75 5c                	jne    802f20 <__umoddi3+0xb0>
  802ec4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ec8:	39 3c 24             	cmp    %edi,(%esp)
  802ecb:	0f 87 e7 00 00 00    	ja     802fb8 <__umoddi3+0x148>
  802ed1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ed5:	29 f1                	sub    %esi,%ecx
  802ed7:	19 c7                	sbb    %eax,%edi
  802ed9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802edd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ee1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ee5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ee9:	83 c4 14             	add    $0x14,%esp
  802eec:	5e                   	pop    %esi
  802eed:	5f                   	pop    %edi
  802eee:	5d                   	pop    %ebp
  802eef:	c3                   	ret    
  802ef0:	85 f6                	test   %esi,%esi
  802ef2:	89 f5                	mov    %esi,%ebp
  802ef4:	75 0b                	jne    802f01 <__umoddi3+0x91>
  802ef6:	b8 01 00 00 00       	mov    $0x1,%eax
  802efb:	31 d2                	xor    %edx,%edx
  802efd:	f7 f6                	div    %esi
  802eff:	89 c5                	mov    %eax,%ebp
  802f01:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f05:	31 d2                	xor    %edx,%edx
  802f07:	f7 f5                	div    %ebp
  802f09:	89 c8                	mov    %ecx,%eax
  802f0b:	f7 f5                	div    %ebp
  802f0d:	eb 9c                	jmp    802eab <__umoddi3+0x3b>
  802f0f:	90                   	nop
  802f10:	89 c8                	mov    %ecx,%eax
  802f12:	89 fa                	mov    %edi,%edx
  802f14:	83 c4 14             	add    $0x14,%esp
  802f17:	5e                   	pop    %esi
  802f18:	5f                   	pop    %edi
  802f19:	5d                   	pop    %ebp
  802f1a:	c3                   	ret    
  802f1b:	90                   	nop
  802f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f20:	8b 04 24             	mov    (%esp),%eax
  802f23:	be 20 00 00 00       	mov    $0x20,%esi
  802f28:	89 e9                	mov    %ebp,%ecx
  802f2a:	29 ee                	sub    %ebp,%esi
  802f2c:	d3 e2                	shl    %cl,%edx
  802f2e:	89 f1                	mov    %esi,%ecx
  802f30:	d3 e8                	shr    %cl,%eax
  802f32:	89 e9                	mov    %ebp,%ecx
  802f34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f38:	8b 04 24             	mov    (%esp),%eax
  802f3b:	09 54 24 04          	or     %edx,0x4(%esp)
  802f3f:	89 fa                	mov    %edi,%edx
  802f41:	d3 e0                	shl    %cl,%eax
  802f43:	89 f1                	mov    %esi,%ecx
  802f45:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f49:	8b 44 24 10          	mov    0x10(%esp),%eax
  802f4d:	d3 ea                	shr    %cl,%edx
  802f4f:	89 e9                	mov    %ebp,%ecx
  802f51:	d3 e7                	shl    %cl,%edi
  802f53:	89 f1                	mov    %esi,%ecx
  802f55:	d3 e8                	shr    %cl,%eax
  802f57:	89 e9                	mov    %ebp,%ecx
  802f59:	09 f8                	or     %edi,%eax
  802f5b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802f5f:	f7 74 24 04          	divl   0x4(%esp)
  802f63:	d3 e7                	shl    %cl,%edi
  802f65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f69:	89 d7                	mov    %edx,%edi
  802f6b:	f7 64 24 08          	mull   0x8(%esp)
  802f6f:	39 d7                	cmp    %edx,%edi
  802f71:	89 c1                	mov    %eax,%ecx
  802f73:	89 14 24             	mov    %edx,(%esp)
  802f76:	72 2c                	jb     802fa4 <__umoddi3+0x134>
  802f78:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802f7c:	72 22                	jb     802fa0 <__umoddi3+0x130>
  802f7e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802f82:	29 c8                	sub    %ecx,%eax
  802f84:	19 d7                	sbb    %edx,%edi
  802f86:	89 e9                	mov    %ebp,%ecx
  802f88:	89 fa                	mov    %edi,%edx
  802f8a:	d3 e8                	shr    %cl,%eax
  802f8c:	89 f1                	mov    %esi,%ecx
  802f8e:	d3 e2                	shl    %cl,%edx
  802f90:	89 e9                	mov    %ebp,%ecx
  802f92:	d3 ef                	shr    %cl,%edi
  802f94:	09 d0                	or     %edx,%eax
  802f96:	89 fa                	mov    %edi,%edx
  802f98:	83 c4 14             	add    $0x14,%esp
  802f9b:	5e                   	pop    %esi
  802f9c:	5f                   	pop    %edi
  802f9d:	5d                   	pop    %ebp
  802f9e:	c3                   	ret    
  802f9f:	90                   	nop
  802fa0:	39 d7                	cmp    %edx,%edi
  802fa2:	75 da                	jne    802f7e <__umoddi3+0x10e>
  802fa4:	8b 14 24             	mov    (%esp),%edx
  802fa7:	89 c1                	mov    %eax,%ecx
  802fa9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802fad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802fb1:	eb cb                	jmp    802f7e <__umoddi3+0x10e>
  802fb3:	90                   	nop
  802fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fb8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802fbc:	0f 82 0f ff ff ff    	jb     802ed1 <__umoddi3+0x61>
  802fc2:	e9 1a ff ff ff       	jmp    802ee1 <__umoddi3+0x71>
