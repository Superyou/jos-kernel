
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 92 0f 00 00       	call   800fd6 <sys_yield>
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>
		sys_yield();

	close(0);
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 52 14 00 00       	call   8014a7 <close>
	if ((r = opencons()) < 0)
  800055:	e8 11 02 00 00       	call   80026b <opencons>
  80005a:	85 c0                	test   %eax,%eax
  80005c:	79 20                	jns    80007e <umain+0x4b>
		panic("opencons: %e", r);
  80005e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800062:	c7 44 24 08 c0 29 80 	movl   $0x8029c0,0x8(%esp)
  800069:	00 
  80006a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800071:	00 
  800072:	c7 04 24 cd 29 80 00 	movl   $0x8029cd,(%esp)
  800079:	e8 a9 02 00 00       	call   800327 <_panic>
	if (r != 0)
  80007e:	85 c0                	test   %eax,%eax
  800080:	74 20                	je     8000a2 <umain+0x6f>
		panic("first opencons used fd %d", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 dc 29 80 	movl   $0x8029dc,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 cd 29 80 00 	movl   $0x8029cd,(%esp)
  80009d:	e8 85 02 00 00       	call   800327 <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000a9:	00 
  8000aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b1:	e8 46 14 00 00       	call   8014fc <dup>
  8000b6:	85 c0                	test   %eax,%eax
  8000b8:	79 20                	jns    8000da <umain+0xa7>
		panic("dup: %e", r);
  8000ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000be:	c7 44 24 08 f6 29 80 	movl   $0x8029f6,0x8(%esp)
  8000c5:	00 
  8000c6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000cd:	00 
  8000ce:	c7 04 24 cd 29 80 00 	movl   $0x8029cd,(%esp)
  8000d5:	e8 4d 02 00 00       	call   800327 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000da:	c7 04 24 fe 29 80 00 	movl   $0x8029fe,(%esp)
  8000e1:	e8 7a 09 00 00       	call   800a60 <readline>
		if (buf != NULL)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	74 1a                	je     800104 <umain+0xd1>
			fprintf(1, "%s\n", buf);
  8000ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ee:	c7 44 24 04 45 2e 80 	movl   $0x802e45,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fd:	e8 04 1c 00 00       	call   801d06 <fprintf>
  800102:	eb d6                	jmp    8000da <umain+0xa7>
		else
			fprintf(1, "(end of file received)\n");
  800104:	c7 44 24 04 0c 2a 80 	movl   $0x802a0c,0x4(%esp)
  80010b:	00 
  80010c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800113:	e8 ee 1b 00 00       	call   801d06 <fprintf>
  800118:	eb c0                	jmp    8000da <umain+0xa7>
  80011a:	66 90                	xchg   %ax,%ax
  80011c:	66 90                	xchg   %ax,%ax
  80011e:	66 90                	xchg   %ax,%ax

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 24 2a 80 	movl   $0x802a24,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 44 0a 00 00       	call   800b87 <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800156:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80015b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800161:	eb 31                	jmp    800194 <devcons_write+0x4a>
		m = n - tot;
  800163:	8b 75 10             	mov    0x10(%ebp),%esi
  800166:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  800168:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80016b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800170:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800173:	89 74 24 08          	mov    %esi,0x8(%esp)
  800177:	03 45 0c             	add    0xc(%ebp),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	89 3c 24             	mov    %edi,(%esp)
  800181:	e8 9e 0b 00 00       	call   800d24 <memmove>
		sys_cputs(buf, m);
  800186:	89 74 24 04          	mov    %esi,0x4(%esp)
  80018a:	89 3c 24             	mov    %edi,(%esp)
  80018d:	e8 44 0d 00 00       	call   800ed6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800192:	01 f3                	add    %esi,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800199:	72 c8                	jb     800163 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80019b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8001ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8001b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001b5:	75 07                	jne    8001be <devcons_read+0x18>
  8001b7:	eb 2a                	jmp    8001e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001b9:	e8 18 0e 00 00       	call   800fd6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001be:	66 90                	xchg   %ax,%ax
  8001c0:	e8 2f 0d 00 00       	call   800ef4 <sys_cgetc>
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 f0                	je     8001b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	78 16                	js     8001e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001cd:	83 f8 04             	cmp    $0x4,%eax
  8001d0:	74 0c                	je     8001de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	88 02                	mov    %al,(%edx)
	return 1;
  8001d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8001dc:	eb 05                	jmp    8001e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8001de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8001e3:	c9                   	leave  
  8001e4:	c3                   	ret    

008001e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001f8:	00 
  8001f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001fc:	89 04 24             	mov    %eax,(%esp)
  8001ff:	e8 d2 0c 00 00       	call   800ed6 <sys_cputs>
}
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <getchar>:

int
getchar(void)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80020c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800213:	00 
  800214:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800222:	e8 e3 13 00 00       	call   80160a <read>
	if (r < 0)
  800227:	85 c0                	test   %eax,%eax
  800229:	78 0f                	js     80023a <getchar+0x34>
		return r;
	if (r < 1)
  80022b:	85 c0                	test   %eax,%eax
  80022d:	7e 06                	jle    800235 <getchar+0x2f>
		return -E_EOF;
	return c;
  80022f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800233:	eb 05                	jmp    80023a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800235:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800242:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800245:	89 44 24 04          	mov    %eax,0x4(%esp)
  800249:	8b 45 08             	mov    0x8(%ebp),%eax
  80024c:	89 04 24             	mov    %eax,(%esp)
  80024f:	e8 22 11 00 00       	call   801376 <fd_lookup>
  800254:	85 c0                	test   %eax,%eax
  800256:	78 11                	js     800269 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025b:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800261:	39 10                	cmp    %edx,(%eax)
  800263:	0f 94 c0             	sete   %al
  800266:	0f b6 c0             	movzbl %al,%eax
}
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <opencons>:

int
opencons(void)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800271:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800274:	89 04 24             	mov    %eax,(%esp)
  800277:	e8 ab 10 00 00       	call   801327 <fd_alloc>
		return r;
  80027c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	78 40                	js     8002c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800282:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800289:	00 
  80028a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80028d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800291:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800298:	e8 58 0d 00 00       	call   800ff5 <sys_page_alloc>
		return r;
  80029d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	78 1f                	js     8002c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8002a3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8002ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	e8 40 10 00 00       	call   801300 <fd2num>
  8002c0:	89 c2                	mov    %eax,%edx
}
  8002c2:	89 d0                	mov    %edx,%eax
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    

008002c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 10             	sub    $0x10,%esp
  8002ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002d1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8002d4:	e8 de 0c 00 00       	call   800fb7 <sys_getenvid>
  8002d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002de:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e6:	a3 08 44 80 00       	mov    %eax,0x804408

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002eb:	85 db                	test   %ebx,%ebx
  8002ed:	7e 07                	jle    8002f6 <libmain+0x30>
		binaryname = argv[0];
  8002ef:	8b 06                	mov    (%esi),%eax
  8002f1:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  8002f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002fa:	89 1c 24             	mov    %ebx,(%esp)
  8002fd:	e8 31 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800302:	e8 07 00 00 00       	call   80030e <exit>
}
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800314:	e8 c1 11 00 00       	call   8014da <close_all>
	sys_env_destroy(0);
  800319:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800320:	e8 ee 0b 00 00       	call   800f13 <sys_env_destroy>
}
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	56                   	push   %esi
  80032b:	53                   	push   %ebx
  80032c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80032f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800332:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  800338:	e8 7a 0c 00 00       	call   800fb7 <sys_getenvid>
  80033d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800340:	89 54 24 10          	mov    %edx,0x10(%esp)
  800344:	8b 55 08             	mov    0x8(%ebp),%edx
  800347:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80034b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  80035a:	e8 c1 00 00 00       	call   800420 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800363:	8b 45 10             	mov    0x10(%ebp),%eax
  800366:	89 04 24             	mov    %eax,(%esp)
  800369:	e8 51 00 00 00       	call   8003bf <vcprintf>
	cprintf("\n");
  80036e:	c7 04 24 22 2a 80 00 	movl   $0x802a22,(%esp)
  800375:	e8 a6 00 00 00       	call   800420 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037a:	cc                   	int3   
  80037b:	eb fd                	jmp    80037a <_panic+0x53>

0080037d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	53                   	push   %ebx
  800381:	83 ec 14             	sub    $0x14,%esp
  800384:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800387:	8b 13                	mov    (%ebx),%edx
  800389:	8d 42 01             	lea    0x1(%edx),%eax
  80038c:	89 03                	mov    %eax,(%ebx)
  80038e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800391:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800395:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039a:	75 19                	jne    8003b5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80039c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003a3:	00 
  8003a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a7:	89 04 24             	mov    %eax,(%esp)
  8003aa:	e8 27 0b 00 00       	call   800ed6 <sys_cputs>
		b->idx = 0;
  8003af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b9:	83 c4 14             	add    $0x14,%esp
  8003bc:	5b                   	pop    %ebx
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003cf:	00 00 00 
	b.cnt = 0;
  8003d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f4:	c7 04 24 7d 03 80 00 	movl   $0x80037d,(%esp)
  8003fb:	e8 74 01 00 00       	call   800574 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800400:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800410:	89 04 24             	mov    %eax,(%esp)
  800413:	e8 be 0a 00 00       	call   800ed6 <sys_cputs>

	return b.cnt;
}
  800418:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800426:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800429:	89 44 24 04          	mov    %eax,0x4(%esp)
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	89 04 24             	mov    %eax,(%esp)
  800433:	e8 87 ff ff ff       	call   8003bf <vcprintf>
	va_end(ap);

	return cnt;
}
  800438:	c9                   	leave  
  800439:	c3                   	ret    
  80043a:	66 90                	xchg   %ax,%ax
  80043c:	66 90                	xchg   %ax,%ax
  80043e:	66 90                	xchg   %ax,%ax

00800440 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	57                   	push   %edi
  800444:	56                   	push   %esi
  800445:	53                   	push   %ebx
  800446:	83 ec 3c             	sub    $0x3c,%esp
  800449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044c:	89 d7                	mov    %edx,%edi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800454:	8b 45 0c             	mov    0xc(%ebp),%eax
  800457:	89 c3                	mov    %eax,%ebx
  800459:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80045c:	8b 45 10             	mov    0x10(%ebp),%eax
  80045f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800462:	b9 00 00 00 00       	mov    $0x0,%ecx
  800467:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80046d:	39 d9                	cmp    %ebx,%ecx
  80046f:	72 05                	jb     800476 <printnum+0x36>
  800471:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800474:	77 69                	ja     8004df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800476:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800479:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80047d:	83 ee 01             	sub    $0x1,%esi
  800480:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800484:	89 44 24 08          	mov    %eax,0x8(%esp)
  800488:	8b 44 24 08          	mov    0x8(%esp),%eax
  80048c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800490:	89 c3                	mov    %eax,%ebx
  800492:	89 d6                	mov    %edx,%esi
  800494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800497:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80049a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80049e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a5:	89 04 24             	mov    %eax,(%esp)
  8004a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004af:	e8 7c 22 00 00       	call   802730 <__udivdi3>
  8004b4:	89 d9                	mov    %ebx,%ecx
  8004b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004c5:	89 fa                	mov    %edi,%edx
  8004c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ca:	e8 71 ff ff ff       	call   800440 <printnum>
  8004cf:	eb 1b                	jmp    8004ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d8:	89 04 24             	mov    %eax,(%esp)
  8004db:	ff d3                	call   *%ebx
  8004dd:	eb 03                	jmp    8004e2 <printnum+0xa2>
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e2:	83 ee 01             	sub    $0x1,%esi
  8004e5:	85 f6                	test   %esi,%esi
  8004e7:	7f e8                	jg     8004d1 <printnum+0x91>
  8004e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 4c 23 00 00       	call   802860 <__umoddi3>
  800514:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800518:	0f be 80 5f 2a 80 00 	movsbl 0x802a5f(%eax),%eax
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800525:	ff d0                	call   *%eax
}
  800527:	83 c4 3c             	add    $0x3c,%esp
  80052a:	5b                   	pop    %ebx
  80052b:	5e                   	pop    %esi
  80052c:	5f                   	pop    %edi
  80052d:	5d                   	pop    %ebp
  80052e:	c3                   	ret    

0080052f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800535:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800539:	8b 10                	mov    (%eax),%edx
  80053b:	3b 50 04             	cmp    0x4(%eax),%edx
  80053e:	73 0a                	jae    80054a <sprintputch+0x1b>
		*b->buf++ = ch;
  800540:	8d 4a 01             	lea    0x1(%edx),%ecx
  800543:	89 08                	mov    %ecx,(%eax)
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	88 02                	mov    %al,(%edx)
}
  80054a:	5d                   	pop    %ebp
  80054b:	c3                   	ret    

0080054c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80054c:	55                   	push   %ebp
  80054d:	89 e5                	mov    %esp,%ebp
  80054f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800552:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800555:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800559:	8b 45 10             	mov    0x10(%ebp),%eax
  80055c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800560:	8b 45 0c             	mov    0xc(%ebp),%eax
  800563:	89 44 24 04          	mov    %eax,0x4(%esp)
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	89 04 24             	mov    %eax,(%esp)
  80056d:	e8 02 00 00 00       	call   800574 <vprintfmt>
	va_end(ap);
}
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	57                   	push   %edi
  800578:	56                   	push   %esi
  800579:	53                   	push   %ebx
  80057a:	83 ec 3c             	sub    $0x3c,%esp
  80057d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800580:	eb 17                	jmp    800599 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800582:	85 c0                	test   %eax,%eax
  800584:	0f 84 4b 04 00 00    	je     8009d5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80058a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80058d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800591:	89 04 24             	mov    %eax,(%esp)
  800594:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800597:	89 fb                	mov    %edi,%ebx
  800599:	8d 7b 01             	lea    0x1(%ebx),%edi
  80059c:	0f b6 03             	movzbl (%ebx),%eax
  80059f:	83 f8 25             	cmp    $0x25,%eax
  8005a2:	75 de                	jne    800582 <vprintfmt+0xe>
  8005a4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8005a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005af:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8005b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c0:	eb 18                	jmp    8005da <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8005c4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8005c8:	eb 10                	jmp    8005da <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005cc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8005d0:	eb 08                	jmp    8005da <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8005d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005d5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8d 5f 01             	lea    0x1(%edi),%ebx
  8005dd:	0f b6 17             	movzbl (%edi),%edx
  8005e0:	0f b6 c2             	movzbl %dl,%eax
  8005e3:	83 ea 23             	sub    $0x23,%edx
  8005e6:	80 fa 55             	cmp    $0x55,%dl
  8005e9:	0f 87 c2 03 00 00    	ja     8009b1 <vprintfmt+0x43d>
  8005ef:	0f b6 d2             	movzbl %dl,%edx
  8005f2:	ff 24 95 a0 2b 80 00 	jmp    *0x802ba0(,%edx,4)
  8005f9:	89 df                	mov    %ebx,%edi
  8005fb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800600:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800603:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800607:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80060a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80060d:	83 fa 09             	cmp    $0x9,%edx
  800610:	77 33                	ja     800645 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800612:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800615:	eb e9                	jmp    800600 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 30                	mov    (%eax),%esi
  80061c:	8d 40 04             	lea    0x4(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800622:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800624:	eb 1f                	jmp    800645 <vprintfmt+0xd1>
  800626:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800629:	85 ff                	test   %edi,%edi
  80062b:	b8 00 00 00 00       	mov    $0x0,%eax
  800630:	0f 49 c7             	cmovns %edi,%eax
  800633:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800636:	89 df                	mov    %ebx,%edi
  800638:	eb a0                	jmp    8005da <vprintfmt+0x66>
  80063a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80063c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800643:	eb 95                	jmp    8005da <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800645:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800649:	79 8f                	jns    8005da <vprintfmt+0x66>
  80064b:	eb 85                	jmp    8005d2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80064d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800650:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800652:	eb 86                	jmp    8005da <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 70 04             	lea    0x4(%eax),%esi
  80065a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	89 04 24             	mov    %eax,(%esp)
  800669:	ff 55 08             	call   *0x8(%ebp)
  80066c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80066f:	e9 25 ff ff ff       	jmp    800599 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 70 04             	lea    0x4(%eax),%esi
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	99                   	cltd   
  80067d:	31 d0                	xor    %edx,%eax
  80067f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800681:	83 f8 15             	cmp    $0x15,%eax
  800684:	7f 0b                	jg     800691 <vprintfmt+0x11d>
  800686:	8b 14 85 00 2d 80 00 	mov    0x802d00(,%eax,4),%edx
  80068d:	85 d2                	test   %edx,%edx
  80068f:	75 26                	jne    8006b7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800691:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800695:	c7 44 24 08 77 2a 80 	movl   $0x802a77,0x8(%esp)
  80069c:	00 
  80069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	89 04 24             	mov    %eax,(%esp)
  8006aa:	e8 9d fe ff ff       	call   80054c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006af:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8006b2:	e9 e2 fe ff ff       	jmp    800599 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8006b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006bb:	c7 44 24 08 62 2e 80 	movl   $0x802e62,0x8(%esp)
  8006c2:	00 
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	89 04 24             	mov    %eax,(%esp)
  8006d0:	e8 77 fe ff ff       	call   80054c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d5:	89 75 14             	mov    %esi,0x14(%ebp)
  8006d8:	e9 bc fe ff ff       	jmp    800599 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006ea:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8006ec:	85 ff                	test   %edi,%edi
  8006ee:	b8 70 2a 80 00       	mov    $0x802a70,%eax
  8006f3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8006f6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8006fa:	0f 84 94 00 00 00    	je     800794 <vprintfmt+0x220>
  800700:	85 c9                	test   %ecx,%ecx
  800702:	0f 8e 94 00 00 00    	jle    80079c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070c:	89 3c 24             	mov    %edi,(%esp)
  80070f:	e8 54 04 00 00       	call   800b68 <strnlen>
  800714:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800717:	29 c1                	sub    %eax,%ecx
  800719:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80071c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800720:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800723:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800726:	8b 75 08             	mov    0x8(%ebp),%esi
  800729:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80072c:	89 cb                	mov    %ecx,%ebx
  80072e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	eb 0f                	jmp    800741 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 44 24 04          	mov    %eax,0x4(%esp)
  800739:	89 3c 24             	mov    %edi,(%esp)
  80073c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80073e:	83 eb 01             	sub    $0x1,%ebx
  800741:	85 db                	test   %ebx,%ebx
  800743:	7f ed                	jg     800732 <vprintfmt+0x1be>
  800745:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800748:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80074b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80074e:	85 c9                	test   %ecx,%ecx
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	0f 49 c1             	cmovns %ecx,%eax
  800758:	29 c1                	sub    %eax,%ecx
  80075a:	89 cb                	mov    %ecx,%ebx
  80075c:	eb 44                	jmp    8007a2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80075e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800762:	74 1e                	je     800782 <vprintfmt+0x20e>
  800764:	0f be d2             	movsbl %dl,%edx
  800767:	83 ea 20             	sub    $0x20,%edx
  80076a:	83 fa 5e             	cmp    $0x5e,%edx
  80076d:	76 13                	jbe    800782 <vprintfmt+0x20e>
					putch('?', putdat);
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	89 44 24 04          	mov    %eax,0x4(%esp)
  800776:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80077d:	ff 55 08             	call   *0x8(%ebp)
  800780:	eb 0d                	jmp    80078f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800782:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800785:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800789:	89 04 24             	mov    %eax,(%esp)
  80078c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078f:	83 eb 01             	sub    $0x1,%ebx
  800792:	eb 0e                	jmp    8007a2 <vprintfmt+0x22e>
  800794:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800797:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80079a:	eb 06                	jmp    8007a2 <vprintfmt+0x22e>
  80079c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80079f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8007a2:	83 c7 01             	add    $0x1,%edi
  8007a5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8007a9:	0f be c2             	movsbl %dl,%eax
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	74 27                	je     8007d7 <vprintfmt+0x263>
  8007b0:	85 f6                	test   %esi,%esi
  8007b2:	78 aa                	js     80075e <vprintfmt+0x1ea>
  8007b4:	83 ee 01             	sub    $0x1,%esi
  8007b7:	79 a5                	jns    80075e <vprintfmt+0x1ea>
  8007b9:	89 d8                	mov    %ebx,%eax
  8007bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007c1:	89 c3                	mov    %eax,%ebx
  8007c3:	eb 18                	jmp    8007dd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007d0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d2:	83 eb 01             	sub    $0x1,%ebx
  8007d5:	eb 06                	jmp    8007dd <vprintfmt+0x269>
  8007d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007da:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007dd:	85 db                	test   %ebx,%ebx
  8007df:	7f e4                	jg     8007c5 <vprintfmt+0x251>
  8007e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8007e4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007ea:	e9 aa fd ff ff       	jmp    800599 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007ef:	83 f9 01             	cmp    $0x1,%ecx
  8007f2:	7e 10                	jle    800804 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8b 30                	mov    (%eax),%esi
  8007f9:	8b 78 04             	mov    0x4(%eax),%edi
  8007fc:	8d 40 08             	lea    0x8(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	eb 26                	jmp    80082a <vprintfmt+0x2b6>
	else if (lflag)
  800804:	85 c9                	test   %ecx,%ecx
  800806:	74 12                	je     80081a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 30                	mov    (%eax),%esi
  80080d:	89 f7                	mov    %esi,%edi
  80080f:	c1 ff 1f             	sar    $0x1f,%edi
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
  800818:	eb 10                	jmp    80082a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 30                	mov    (%eax),%esi
  80081f:	89 f7                	mov    %esi,%edi
  800821:	c1 ff 1f             	sar    $0x1f,%edi
  800824:	8d 40 04             	lea    0x4(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80082a:	89 f0                	mov    %esi,%eax
  80082c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80082e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800833:	85 ff                	test   %edi,%edi
  800835:	0f 89 3a 01 00 00    	jns    800975 <vprintfmt+0x401>
				putch('-', putdat);
  80083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800842:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800849:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80084c:	89 f0                	mov    %esi,%eax
  80084e:	89 fa                	mov    %edi,%edx
  800850:	f7 d8                	neg    %eax
  800852:	83 d2 00             	adc    $0x0,%edx
  800855:	f7 da                	neg    %edx
			}
			base = 10;
  800857:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80085c:	e9 14 01 00 00       	jmp    800975 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800861:	83 f9 01             	cmp    $0x1,%ecx
  800864:	7e 13                	jle    800879 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 50 04             	mov    0x4(%eax),%edx
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	8b 75 14             	mov    0x14(%ebp),%esi
  800871:	8d 4e 08             	lea    0x8(%esi),%ecx
  800874:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800877:	eb 2c                	jmp    8008a5 <vprintfmt+0x331>
	else if (lflag)
  800879:	85 c9                	test   %ecx,%ecx
  80087b:	74 15                	je     800892 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	ba 00 00 00 00       	mov    $0x0,%edx
  800887:	8b 75 14             	mov    0x14(%ebp),%esi
  80088a:	8d 76 04             	lea    0x4(%esi),%esi
  80088d:	89 75 14             	mov    %esi,0x14(%ebp)
  800890:	eb 13                	jmp    8008a5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	8b 75 14             	mov    0x14(%ebp),%esi
  80089f:	8d 76 04             	lea    0x4(%esi),%esi
  8008a2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8008a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8008aa:	e9 c6 00 00 00       	jmp    800975 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008af:	83 f9 01             	cmp    $0x1,%ecx
  8008b2:	7e 13                	jle    8008c7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	8b 75 14             	mov    0x14(%ebp),%esi
  8008bf:	8d 4e 08             	lea    0x8(%esi),%ecx
  8008c2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008c5:	eb 24                	jmp    8008eb <vprintfmt+0x377>
	else if (lflag)
  8008c7:	85 c9                	test   %ecx,%ecx
  8008c9:	74 11                	je     8008dc <vprintfmt+0x368>
		return va_arg(*ap, long);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	99                   	cltd   
  8008d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008d4:	8d 71 04             	lea    0x4(%ecx),%esi
  8008d7:	89 75 14             	mov    %esi,0x14(%ebp)
  8008da:	eb 0f                	jmp    8008eb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	99                   	cltd   
  8008e2:	8b 75 14             	mov    0x14(%ebp),%esi
  8008e5:	8d 76 04             	lea    0x4(%esi),%esi
  8008e8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8008eb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8008f0:	e9 80 00 00 00       	jmp    800975 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  8008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800906:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800910:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800917:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80091a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80091e:	8b 06                	mov    (%esi),%eax
  800920:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800925:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80092a:	eb 49                	jmp    800975 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80092c:	83 f9 01             	cmp    $0x1,%ecx
  80092f:	7e 13                	jle    800944 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8b 50 04             	mov    0x4(%eax),%edx
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8b 75 14             	mov    0x14(%ebp),%esi
  80093c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80093f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800942:	eb 2c                	jmp    800970 <vprintfmt+0x3fc>
	else if (lflag)
  800944:	85 c9                	test   %ecx,%ecx
  800946:	74 15                	je     80095d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	ba 00 00 00 00       	mov    $0x0,%edx
  800952:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800955:	8d 71 04             	lea    0x4(%ecx),%esi
  800958:	89 75 14             	mov    %esi,0x14(%ebp)
  80095b:	eb 13                	jmp    800970 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	ba 00 00 00 00       	mov    $0x0,%edx
  800967:	8b 75 14             	mov    0x14(%ebp),%esi
  80096a:	8d 76 04             	lea    0x4(%esi),%esi
  80096d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800970:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800975:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800979:	89 74 24 10          	mov    %esi,0x10(%esp)
  80097d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800980:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800984:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800988:	89 04 24             	mov    %eax,(%esp)
  80098b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	e8 a6 fa ff ff       	call   800440 <printnum>
			break;
  80099a:	e9 fa fb ff ff       	jmp    800599 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80099f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009a6:	89 04 24             	mov    %eax,(%esp)
  8009a9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009ac:	e9 e8 fb ff ff       	jmp    800599 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009bf:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c2:	89 fb                	mov    %edi,%ebx
  8009c4:	eb 03                	jmp    8009c9 <vprintfmt+0x455>
  8009c6:	83 eb 01             	sub    $0x1,%ebx
  8009c9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009cd:	75 f7                	jne    8009c6 <vprintfmt+0x452>
  8009cf:	90                   	nop
  8009d0:	e9 c4 fb ff ff       	jmp    800599 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009d5:	83 c4 3c             	add    $0x3c,%esp
  8009d8:	5b                   	pop    %ebx
  8009d9:	5e                   	pop    %esi
  8009da:	5f                   	pop    %edi
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 28             	sub    $0x28,%esp
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ec:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009f0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009fa:	85 c0                	test   %eax,%eax
  8009fc:	74 30                	je     800a2e <vsnprintf+0x51>
  8009fe:	85 d2                	test   %edx,%edx
  800a00:	7e 2c                	jle    800a2e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a02:	8b 45 14             	mov    0x14(%ebp),%eax
  800a05:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a09:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a10:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a17:	c7 04 24 2f 05 80 00 	movl   $0x80052f,(%esp)
  800a1e:	e8 51 fb ff ff       	call   800574 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a26:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a2c:	eb 05                	jmp    800a33 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a3b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	89 04 24             	mov    %eax,(%esp)
  800a56:	e8 82 ff ff ff       	call   8009dd <vsnprintf>
	va_end(ap);

	return rc;
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    
  800a5d:	66 90                	xchg   %ax,%ax
  800a5f:	90                   	nop

00800a60 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	57                   	push   %edi
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	83 ec 1c             	sub    $0x1c,%esp
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a6c:	85 c0                	test   %eax,%eax
  800a6e:	74 18                	je     800a88 <readline+0x28>
		fprintf(1, "%s", prompt);
  800a70:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a74:	c7 44 24 04 62 2e 80 	movl   $0x802e62,0x4(%esp)
  800a7b:	00 
  800a7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a83:	e8 7e 12 00 00       	call   801d06 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  800a88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a8f:	e8 a8 f7 ff ff       	call   80023c <iscons>
  800a94:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  800a96:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  800a9b:	e8 66 f7 ff ff       	call   800206 <getchar>
  800aa0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	79 25                	jns    800acb <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  800aab:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800aae:	0f 84 88 00 00 00    	je     800b3c <readline+0xdc>
				cprintf("read error: %e\n", c);
  800ab4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ab8:	c7 04 24 77 2d 80 00 	movl   $0x802d77,(%esp)
  800abf:	e8 5c f9 ff ff       	call   800420 <cprintf>
			return NULL;
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac9:	eb 71                	jmp    800b3c <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800acb:	83 f8 7f             	cmp    $0x7f,%eax
  800ace:	74 05                	je     800ad5 <readline+0x75>
  800ad0:	83 f8 08             	cmp    $0x8,%eax
  800ad3:	75 19                	jne    800aee <readline+0x8e>
  800ad5:	85 f6                	test   %esi,%esi
  800ad7:	7e 15                	jle    800aee <readline+0x8e>
			if (echoing)
  800ad9:	85 ff                	test   %edi,%edi
  800adb:	74 0c                	je     800ae9 <readline+0x89>
				cputchar('\b');
  800add:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800ae4:	e8 fc f6 ff ff       	call   8001e5 <cputchar>
			i--;
  800ae9:	83 ee 01             	sub    $0x1,%esi
  800aec:	eb ad                	jmp    800a9b <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800aee:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800af4:	7f 1c                	jg     800b12 <readline+0xb2>
  800af6:	83 fb 1f             	cmp    $0x1f,%ebx
  800af9:	7e 17                	jle    800b12 <readline+0xb2>
			if (echoing)
  800afb:	85 ff                	test   %edi,%edi
  800afd:	74 08                	je     800b07 <readline+0xa7>
				cputchar(c);
  800aff:	89 1c 24             	mov    %ebx,(%esp)
  800b02:	e8 de f6 ff ff       	call   8001e5 <cputchar>
			buf[i++] = c;
  800b07:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800b0d:	8d 76 01             	lea    0x1(%esi),%esi
  800b10:	eb 89                	jmp    800a9b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800b12:	83 fb 0d             	cmp    $0xd,%ebx
  800b15:	74 09                	je     800b20 <readline+0xc0>
  800b17:	83 fb 0a             	cmp    $0xa,%ebx
  800b1a:	0f 85 7b ff ff ff    	jne    800a9b <readline+0x3b>
			if (echoing)
  800b20:	85 ff                	test   %edi,%edi
  800b22:	74 0c                	je     800b30 <readline+0xd0>
				cputchar('\n');
  800b24:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800b2b:	e8 b5 f6 ff ff       	call   8001e5 <cputchar>
			buf[i] = 0;
  800b30:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800b37:	b8 00 40 80 00       	mov    $0x804000,%eax
		}
	}
}
  800b3c:	83 c4 1c             	add    $0x1c,%esp
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    
  800b44:	66 90                	xchg   %ax,%ax
  800b46:	66 90                	xchg   %ax,%ax
  800b48:	66 90                	xchg   %ax,%ax
  800b4a:	66 90                	xchg   %ax,%ax
  800b4c:	66 90                	xchg   %ax,%ax
  800b4e:	66 90                	xchg   %ax,%ax

00800b50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5b:	eb 03                	jmp    800b60 <strlen+0x10>
		n++;
  800b5d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b60:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b64:	75 f7                	jne    800b5d <strlen+0xd>
		n++;
	return n;
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
  800b76:	eb 03                	jmp    800b7b <strnlen+0x13>
		n++;
  800b78:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7b:	39 d0                	cmp    %edx,%eax
  800b7d:	74 06                	je     800b85 <strnlen+0x1d>
  800b7f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b83:	75 f3                	jne    800b78 <strnlen+0x10>
		n++;
	return n;
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b91:	89 c2                	mov    %eax,%edx
  800b93:	83 c2 01             	add    $0x1,%edx
  800b96:	83 c1 01             	add    $0x1,%ecx
  800b99:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b9d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ba0:	84 db                	test   %bl,%bl
  800ba2:	75 ef                	jne    800b93 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	53                   	push   %ebx
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bb1:	89 1c 24             	mov    %ebx,(%esp)
  800bb4:	e8 97 ff ff ff       	call   800b50 <strlen>
	strcpy(dst + len, src);
  800bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bc0:	01 d8                	add    %ebx,%eax
  800bc2:	89 04 24             	mov    %eax,(%esp)
  800bc5:	e8 bd ff ff ff       	call   800b87 <strcpy>
	return dst;
}
  800bca:	89 d8                	mov    %ebx,%eax
  800bcc:	83 c4 08             	add    $0x8,%esp
  800bcf:	5b                   	pop    %ebx
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	8b 75 08             	mov    0x8(%ebp),%esi
  800bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be2:	89 f2                	mov    %esi,%edx
  800be4:	eb 0f                	jmp    800bf5 <strncpy+0x23>
		*dst++ = *src;
  800be6:	83 c2 01             	add    $0x1,%edx
  800be9:	0f b6 01             	movzbl (%ecx),%eax
  800bec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bef:	80 39 01             	cmpb   $0x1,(%ecx)
  800bf2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf5:	39 da                	cmp    %ebx,%edx
  800bf7:	75 ed                	jne    800be6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bf9:	89 f0                	mov    %esi,%eax
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	8b 75 08             	mov    0x8(%ebp),%esi
  800c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c0d:	89 f0                	mov    %esi,%eax
  800c0f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c13:	85 c9                	test   %ecx,%ecx
  800c15:	75 0b                	jne    800c22 <strlcpy+0x23>
  800c17:	eb 1d                	jmp    800c36 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c19:	83 c0 01             	add    $0x1,%eax
  800c1c:	83 c2 01             	add    $0x1,%edx
  800c1f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c22:	39 d8                	cmp    %ebx,%eax
  800c24:	74 0b                	je     800c31 <strlcpy+0x32>
  800c26:	0f b6 0a             	movzbl (%edx),%ecx
  800c29:	84 c9                	test   %cl,%cl
  800c2b:	75 ec                	jne    800c19 <strlcpy+0x1a>
  800c2d:	89 c2                	mov    %eax,%edx
  800c2f:	eb 02                	jmp    800c33 <strlcpy+0x34>
  800c31:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800c33:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800c36:	29 f0                	sub    %esi,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c45:	eb 06                	jmp    800c4d <strcmp+0x11>
		p++, q++;
  800c47:	83 c1 01             	add    $0x1,%ecx
  800c4a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c4d:	0f b6 01             	movzbl (%ecx),%eax
  800c50:	84 c0                	test   %al,%al
  800c52:	74 04                	je     800c58 <strcmp+0x1c>
  800c54:	3a 02                	cmp    (%edx),%al
  800c56:	74 ef                	je     800c47 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	0f b6 c0             	movzbl %al,%eax
  800c5b:	0f b6 12             	movzbl (%edx),%edx
  800c5e:	29 d0                	sub    %edx,%eax
}
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	53                   	push   %ebx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	89 c3                	mov    %eax,%ebx
  800c6e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c71:	eb 06                	jmp    800c79 <strncmp+0x17>
		n--, p++, q++;
  800c73:	83 c0 01             	add    $0x1,%eax
  800c76:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c79:	39 d8                	cmp    %ebx,%eax
  800c7b:	74 15                	je     800c92 <strncmp+0x30>
  800c7d:	0f b6 08             	movzbl (%eax),%ecx
  800c80:	84 c9                	test   %cl,%cl
  800c82:	74 04                	je     800c88 <strncmp+0x26>
  800c84:	3a 0a                	cmp    (%edx),%cl
  800c86:	74 eb                	je     800c73 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c88:	0f b6 00             	movzbl (%eax),%eax
  800c8b:	0f b6 12             	movzbl (%edx),%edx
  800c8e:	29 d0                	sub    %edx,%eax
  800c90:	eb 05                	jmp    800c97 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c92:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c97:	5b                   	pop    %ebx
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca4:	eb 07                	jmp    800cad <strchr+0x13>
		if (*s == c)
  800ca6:	38 ca                	cmp    %cl,%dl
  800ca8:	74 0f                	je     800cb9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800caa:	83 c0 01             	add    $0x1,%eax
  800cad:	0f b6 10             	movzbl (%eax),%edx
  800cb0:	84 d2                	test   %dl,%dl
  800cb2:	75 f2                	jne    800ca6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc5:	eb 07                	jmp    800cce <strfind+0x13>
		if (*s == c)
  800cc7:	38 ca                	cmp    %cl,%dl
  800cc9:	74 0a                	je     800cd5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ccb:	83 c0 01             	add    $0x1,%eax
  800cce:	0f b6 10             	movzbl (%eax),%edx
  800cd1:	84 d2                	test   %dl,%dl
  800cd3:	75 f2                	jne    800cc7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce3:	85 c9                	test   %ecx,%ecx
  800ce5:	74 36                	je     800d1d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ced:	75 28                	jne    800d17 <memset+0x40>
  800cef:	f6 c1 03             	test   $0x3,%cl
  800cf2:	75 23                	jne    800d17 <memset+0x40>
		c &= 0xFF;
  800cf4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf8:	89 d3                	mov    %edx,%ebx
  800cfa:	c1 e3 08             	shl    $0x8,%ebx
  800cfd:	89 d6                	mov    %edx,%esi
  800cff:	c1 e6 18             	shl    $0x18,%esi
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	c1 e0 10             	shl    $0x10,%eax
  800d07:	09 f0                	or     %esi,%eax
  800d09:	09 c2                	or     %eax,%edx
  800d0b:	89 d0                	mov    %edx,%eax
  800d0d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d12:	fc                   	cld    
  800d13:	f3 ab                	rep stos %eax,%es:(%edi)
  800d15:	eb 06                	jmp    800d1d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	fc                   	cld    
  800d1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1d:	89 f8                	mov    %edi,%eax
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d32:	39 c6                	cmp    %eax,%esi
  800d34:	73 35                	jae    800d6b <memmove+0x47>
  800d36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d39:	39 d0                	cmp    %edx,%eax
  800d3b:	73 2e                	jae    800d6b <memmove+0x47>
		s += n;
		d += n;
  800d3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d4a:	75 13                	jne    800d5f <memmove+0x3b>
  800d4c:	f6 c1 03             	test   $0x3,%cl
  800d4f:	75 0e                	jne    800d5f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d51:	83 ef 04             	sub    $0x4,%edi
  800d54:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d57:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d5a:	fd                   	std    
  800d5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d5d:	eb 09                	jmp    800d68 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d5f:	83 ef 01             	sub    $0x1,%edi
  800d62:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d65:	fd                   	std    
  800d66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d68:	fc                   	cld    
  800d69:	eb 1d                	jmp    800d88 <memmove+0x64>
  800d6b:	89 f2                	mov    %esi,%edx
  800d6d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6f:	f6 c2 03             	test   $0x3,%dl
  800d72:	75 0f                	jne    800d83 <memmove+0x5f>
  800d74:	f6 c1 03             	test   $0x3,%cl
  800d77:	75 0a                	jne    800d83 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d79:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d7c:	89 c7                	mov    %eax,%edi
  800d7e:	fc                   	cld    
  800d7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d81:	eb 05                	jmp    800d88 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d83:	89 c7                	mov    %eax,%edi
  800d85:	fc                   	cld    
  800d86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	89 04 24             	mov    %eax,(%esp)
  800da6:	e8 79 ff ff ff       	call   800d24 <memmove>
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	89 d6                	mov    %edx,%esi
  800dba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbd:	eb 1a                	jmp    800dd9 <memcmp+0x2c>
		if (*s1 != *s2)
  800dbf:	0f b6 02             	movzbl (%edx),%eax
  800dc2:	0f b6 19             	movzbl (%ecx),%ebx
  800dc5:	38 d8                	cmp    %bl,%al
  800dc7:	74 0a                	je     800dd3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800dc9:	0f b6 c0             	movzbl %al,%eax
  800dcc:	0f b6 db             	movzbl %bl,%ebx
  800dcf:	29 d8                	sub    %ebx,%eax
  800dd1:	eb 0f                	jmp    800de2 <memcmp+0x35>
		s1++, s2++;
  800dd3:	83 c2 01             	add    $0x1,%edx
  800dd6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dd9:	39 f2                	cmp    %esi,%edx
  800ddb:	75 e2                	jne    800dbf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800def:	89 c2                	mov    %eax,%edx
  800df1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df4:	eb 07                	jmp    800dfd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800df6:	38 08                	cmp    %cl,(%eax)
  800df8:	74 07                	je     800e01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dfa:	83 c0 01             	add    $0x1,%eax
  800dfd:	39 d0                	cmp    %edx,%eax
  800dff:	72 f5                	jb     800df6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0f:	eb 03                	jmp    800e14 <strtol+0x11>
		s++;
  800e11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e14:	0f b6 0a             	movzbl (%edx),%ecx
  800e17:	80 f9 09             	cmp    $0x9,%cl
  800e1a:	74 f5                	je     800e11 <strtol+0xe>
  800e1c:	80 f9 20             	cmp    $0x20,%cl
  800e1f:	74 f0                	je     800e11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e21:	80 f9 2b             	cmp    $0x2b,%cl
  800e24:	75 0a                	jne    800e30 <strtol+0x2d>
		s++;
  800e26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e29:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2e:	eb 11                	jmp    800e41 <strtol+0x3e>
  800e30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e35:	80 f9 2d             	cmp    $0x2d,%cl
  800e38:	75 07                	jne    800e41 <strtol+0x3e>
		s++, neg = 1;
  800e3a:	8d 52 01             	lea    0x1(%edx),%edx
  800e3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800e46:	75 15                	jne    800e5d <strtol+0x5a>
  800e48:	80 3a 30             	cmpb   $0x30,(%edx)
  800e4b:	75 10                	jne    800e5d <strtol+0x5a>
  800e4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e51:	75 0a                	jne    800e5d <strtol+0x5a>
		s += 2, base = 16;
  800e53:	83 c2 02             	add    $0x2,%edx
  800e56:	b8 10 00 00 00       	mov    $0x10,%eax
  800e5b:	eb 10                	jmp    800e6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 0c                	jne    800e6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e63:	80 3a 30             	cmpb   $0x30,(%edx)
  800e66:	75 05                	jne    800e6d <strtol+0x6a>
		s++, base = 8;
  800e68:	83 c2 01             	add    $0x1,%edx
  800e6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e75:	0f b6 0a             	movzbl (%edx),%ecx
  800e78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800e7b:	89 f0                	mov    %esi,%eax
  800e7d:	3c 09                	cmp    $0x9,%al
  800e7f:	77 08                	ja     800e89 <strtol+0x86>
			dig = *s - '0';
  800e81:	0f be c9             	movsbl %cl,%ecx
  800e84:	83 e9 30             	sub    $0x30,%ecx
  800e87:	eb 20                	jmp    800ea9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800e89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800e8c:	89 f0                	mov    %esi,%eax
  800e8e:	3c 19                	cmp    $0x19,%al
  800e90:	77 08                	ja     800e9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800e92:	0f be c9             	movsbl %cl,%ecx
  800e95:	83 e9 57             	sub    $0x57,%ecx
  800e98:	eb 0f                	jmp    800ea9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800e9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e9d:	89 f0                	mov    %esi,%eax
  800e9f:	3c 19                	cmp    $0x19,%al
  800ea1:	77 16                	ja     800eb9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ea3:	0f be c9             	movsbl %cl,%ecx
  800ea6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ea9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800eac:	7d 0f                	jge    800ebd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800eae:	83 c2 01             	add    $0x1,%edx
  800eb1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800eb5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800eb7:	eb bc                	jmp    800e75 <strtol+0x72>
  800eb9:	89 d8                	mov    %ebx,%eax
  800ebb:	eb 02                	jmp    800ebf <strtol+0xbc>
  800ebd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ebf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec3:	74 05                	je     800eca <strtol+0xc7>
		*endptr = (char *) s;
  800ec5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ec8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800eca:	f7 d8                	neg    %eax
  800ecc:	85 ff                	test   %edi,%edi
  800ece:	0f 44 c3             	cmove  %ebx,%eax
}
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	89 c3                	mov    %eax,%ebx
  800ee9:	89 c7                	mov    %eax,%edi
  800eeb:	89 c6                	mov    %eax,%esi
  800eed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    

00800ef4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efa:	ba 00 00 00 00       	mov    $0x0,%edx
  800eff:	b8 01 00 00 00       	mov    $0x1,%eax
  800f04:	89 d1                	mov    %edx,%ecx
  800f06:	89 d3                	mov    %edx,%ebx
  800f08:	89 d7                	mov    %edx,%edi
  800f0a:	89 d6                	mov    %edx,%esi
  800f0c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f21:	b8 03 00 00 00       	mov    $0x3,%eax
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	89 cb                	mov    %ecx,%ebx
  800f2b:	89 cf                	mov    %ecx,%edi
  800f2d:	89 ce                	mov    %ecx,%esi
  800f2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	7e 28                	jle    800f5d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f39:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f40:	00 
  800f41:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800f48:	00 
  800f49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f50:	00 
  800f51:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800f58:	e8 ca f3 ff ff       	call   800327 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f5d:	83 c4 2c             	add    $0x2c,%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
  800f6b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f73:	b8 04 00 00 00       	mov    $0x4,%eax
  800f78:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7b:	89 cb                	mov    %ecx,%ebx
  800f7d:	89 cf                	mov    %ecx,%edi
  800f7f:	89 ce                	mov    %ecx,%esi
  800f81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	7e 28                	jle    800faf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f92:	00 
  800f93:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  800f9a:	00 
  800f9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa2:	00 
  800fa3:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  800faa:	e8 78 f3 ff ff       	call   800327 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800faf:	83 c4 2c             	add    $0x2c,%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	57                   	push   %edi
  800fbb:	56                   	push   %esi
  800fbc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc2:	b8 02 00 00 00       	mov    $0x2,%eax
  800fc7:	89 d1                	mov    %edx,%ecx
  800fc9:	89 d3                	mov    %edx,%ebx
  800fcb:	89 d7                	mov    %edx,%edi
  800fcd:	89 d6                	mov    %edx,%esi
  800fcf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <sys_yield>:

void
sys_yield(void)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	57                   	push   %edi
  800fda:	56                   	push   %esi
  800fdb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fe6:	89 d1                	mov    %edx,%ecx
  800fe8:	89 d3                	mov    %edx,%ebx
  800fea:	89 d7                	mov    %edx,%edi
  800fec:	89 d6                	mov    %edx,%esi
  800fee:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	57                   	push   %edi
  800ff9:	56                   	push   %esi
  800ffa:	53                   	push   %ebx
  800ffb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffe:	be 00 00 00 00       	mov    $0x0,%esi
  801003:	b8 05 00 00 00       	mov    $0x5,%eax
  801008:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100b:	8b 55 08             	mov    0x8(%ebp),%edx
  80100e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801011:	89 f7                	mov    %esi,%edi
  801013:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801015:	85 c0                	test   %eax,%eax
  801017:	7e 28                	jle    801041 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801019:	89 44 24 10          	mov    %eax,0x10(%esp)
  80101d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801024:	00 
  801025:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  80102c:	00 
  80102d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801034:	00 
  801035:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  80103c:	e8 e6 f2 ff ff       	call   800327 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801041:	83 c4 2c             	add    $0x2c,%esp
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
  80104f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801052:	b8 06 00 00 00       	mov    $0x6,%eax
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801060:	8b 7d 14             	mov    0x14(%ebp),%edi
  801063:	8b 75 18             	mov    0x18(%ebp),%esi
  801066:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801068:	85 c0                	test   %eax,%eax
  80106a:	7e 28                	jle    801094 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801070:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801077:	00 
  801078:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  80107f:	00 
  801080:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801087:	00 
  801088:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  80108f:	e8 93 f2 ff ff       	call   800327 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801094:	83 c4 2c             	add    $0x2c,%esp
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5f                   	pop    %edi
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	57                   	push   %edi
  8010a0:	56                   	push   %esi
  8010a1:	53                   	push   %ebx
  8010a2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8010af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b5:	89 df                	mov    %ebx,%edi
  8010b7:	89 de                	mov    %ebx,%esi
  8010b9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	7e 28                	jle    8010e7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8010ca:	00 
  8010cb:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  8010d2:	00 
  8010d3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010da:	00 
  8010db:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  8010e2:	e8 40 f2 ff ff       	call   800327 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010e7:	83 c4 2c             	add    $0x2c,%esp
  8010ea:	5b                   	pop    %ebx
  8010eb:	5e                   	pop    %esi
  8010ec:	5f                   	pop    %edi
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    

008010ef <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	57                   	push   %edi
  8010f3:	56                   	push   %esi
  8010f4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010fa:	b8 10 00 00 00       	mov    $0x10,%eax
  8010ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801102:	89 cb                	mov    %ecx,%ebx
  801104:	89 cf                	mov    %ecx,%edi
  801106:	89 ce                	mov    %ecx,%esi
  801108:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80110a:	5b                   	pop    %ebx
  80110b:	5e                   	pop    %esi
  80110c:	5f                   	pop    %edi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	57                   	push   %edi
  801113:	56                   	push   %esi
  801114:	53                   	push   %ebx
  801115:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801118:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111d:	b8 09 00 00 00       	mov    $0x9,%eax
  801122:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	89 df                	mov    %ebx,%edi
  80112a:	89 de                	mov    %ebx,%esi
  80112c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80112e:	85 c0                	test   %eax,%eax
  801130:	7e 28                	jle    80115a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801132:	89 44 24 10          	mov    %eax,0x10(%esp)
  801136:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80113d:	00 
  80113e:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  801145:	00 
  801146:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80114d:	00 
  80114e:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  801155:	e8 cd f1 ff ff       	call   800327 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80115a:	83 c4 2c             	add    $0x2c,%esp
  80115d:	5b                   	pop    %ebx
  80115e:	5e                   	pop    %esi
  80115f:	5f                   	pop    %edi
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    

00801162 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	57                   	push   %edi
  801166:	56                   	push   %esi
  801167:	53                   	push   %ebx
  801168:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801170:	b8 0a 00 00 00       	mov    $0xa,%eax
  801175:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801178:	8b 55 08             	mov    0x8(%ebp),%edx
  80117b:	89 df                	mov    %ebx,%edi
  80117d:	89 de                	mov    %ebx,%esi
  80117f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801181:	85 c0                	test   %eax,%eax
  801183:	7e 28                	jle    8011ad <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801185:	89 44 24 10          	mov    %eax,0x10(%esp)
  801189:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801190:	00 
  801191:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  801198:	00 
  801199:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a0:	00 
  8011a1:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  8011a8:	e8 7a f1 ff ff       	call   800327 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011ad:	83 c4 2c             	add    $0x2c,%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	57                   	push   %edi
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ce:	89 df                	mov    %ebx,%edi
  8011d0:	89 de                	mov    %ebx,%esi
  8011d2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	7e 28                	jle    801200 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011dc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f3:	00 
  8011f4:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  8011fb:	e8 27 f1 ff ff       	call   800327 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801200:	83 c4 2c             	add    $0x2c,%esp
  801203:	5b                   	pop    %ebx
  801204:	5e                   	pop    %esi
  801205:	5f                   	pop    %edi
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	57                   	push   %edi
  80120c:	56                   	push   %esi
  80120d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120e:	be 00 00 00 00       	mov    $0x0,%esi
  801213:	b8 0d 00 00 00       	mov    $0xd,%eax
  801218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121b:	8b 55 08             	mov    0x8(%ebp),%edx
  80121e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801221:	8b 7d 14             	mov    0x14(%ebp),%edi
  801224:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801226:	5b                   	pop    %ebx
  801227:	5e                   	pop    %esi
  801228:	5f                   	pop    %edi
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	57                   	push   %edi
  80122f:	56                   	push   %esi
  801230:	53                   	push   %ebx
  801231:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801234:	b9 00 00 00 00       	mov    $0x0,%ecx
  801239:	b8 0e 00 00 00       	mov    $0xe,%eax
  80123e:	8b 55 08             	mov    0x8(%ebp),%edx
  801241:	89 cb                	mov    %ecx,%ebx
  801243:	89 cf                	mov    %ecx,%edi
  801245:	89 ce                	mov    %ecx,%esi
  801247:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801249:	85 c0                	test   %eax,%eax
  80124b:	7e 28                	jle    801275 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801251:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801258:	00 
  801259:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  801260:	00 
  801261:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801268:	00 
  801269:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  801270:	e8 b2 f0 ff ff       	call   800327 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801275:	83 c4 2c             	add    $0x2c,%esp
  801278:	5b                   	pop    %ebx
  801279:	5e                   	pop    %esi
  80127a:	5f                   	pop    %edi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	57                   	push   %edi
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801283:	ba 00 00 00 00       	mov    $0x0,%edx
  801288:	b8 0f 00 00 00       	mov    $0xf,%eax
  80128d:	89 d1                	mov    %edx,%ecx
  80128f:	89 d3                	mov    %edx,%ebx
  801291:	89 d7                	mov    %edx,%edi
  801293:	89 d6                	mov    %edx,%esi
  801295:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5f                   	pop    %edi
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a7:	b8 11 00 00 00       	mov    $0x11,%eax
  8012ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b2:	89 df                	mov    %ebx,%edi
  8012b4:	89 de                	mov    %ebx,%esi
  8012b6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5f                   	pop    %edi
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	57                   	push   %edi
  8012c1:	56                   	push   %esi
  8012c2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c8:	b8 12 00 00 00       	mov    $0x12,%eax
  8012cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d3:	89 df                	mov    %ebx,%edi
  8012d5:	89 de                	mov    %ebx,%esi
  8012d7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8012d9:	5b                   	pop    %ebx
  8012da:	5e                   	pop    %esi
  8012db:	5f                   	pop    %edi
  8012dc:	5d                   	pop    %ebp
  8012dd:	c3                   	ret    

008012de <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	57                   	push   %edi
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012e9:	b8 13 00 00 00       	mov    $0x13,%eax
  8012ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f1:	89 cb                	mov    %ecx,%ebx
  8012f3:	89 cf                	mov    %ecx,%edi
  8012f5:	89 ce                	mov    %ecx,%esi
  8012f7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8012f9:	5b                   	pop    %ebx
  8012fa:	5e                   	pop    %esi
  8012fb:	5f                   	pop    %edi
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    
  8012fe:	66 90                	xchg   %ax,%ax

00801300 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	05 00 00 00 30       	add    $0x30000000,%eax
  80130b:	c1 e8 0c             	shr    $0xc,%eax
}
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80131b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801320:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801325:	5d                   	pop    %ebp
  801326:	c3                   	ret    

00801327 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801332:	89 c2                	mov    %eax,%edx
  801334:	c1 ea 16             	shr    $0x16,%edx
  801337:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80133e:	f6 c2 01             	test   $0x1,%dl
  801341:	74 11                	je     801354 <fd_alloc+0x2d>
  801343:	89 c2                	mov    %eax,%edx
  801345:	c1 ea 0c             	shr    $0xc,%edx
  801348:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134f:	f6 c2 01             	test   $0x1,%dl
  801352:	75 09                	jne    80135d <fd_alloc+0x36>
			*fd_store = fd;
  801354:	89 01                	mov    %eax,(%ecx)
			return 0;
  801356:	b8 00 00 00 00       	mov    $0x0,%eax
  80135b:	eb 17                	jmp    801374 <fd_alloc+0x4d>
  80135d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801362:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801367:	75 c9                	jne    801332 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801369:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80136f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80137c:	83 f8 1f             	cmp    $0x1f,%eax
  80137f:	77 36                	ja     8013b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801381:	c1 e0 0c             	shl    $0xc,%eax
  801384:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801389:	89 c2                	mov    %eax,%edx
  80138b:	c1 ea 16             	shr    $0x16,%edx
  80138e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801395:	f6 c2 01             	test   $0x1,%dl
  801398:	74 24                	je     8013be <fd_lookup+0x48>
  80139a:	89 c2                	mov    %eax,%edx
  80139c:	c1 ea 0c             	shr    $0xc,%edx
  80139f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013a6:	f6 c2 01             	test   $0x1,%dl
  8013a9:	74 1a                	je     8013c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b5:	eb 13                	jmp    8013ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bc:	eb 0c                	jmp    8013ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c3:	eb 05                	jmp    8013ca <fd_lookup+0x54>
  8013c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 18             	sub    $0x18,%esp
  8013d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013da:	eb 13                	jmp    8013ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8013dc:	39 08                	cmp    %ecx,(%eax)
  8013de:	75 0c                	jne    8013ec <dev_lookup+0x20>
			*dev = devtab[i];
  8013e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ea:	eb 38                	jmp    801424 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013ec:	83 c2 01             	add    $0x1,%edx
  8013ef:	8b 04 95 30 2e 80 00 	mov    0x802e30(,%edx,4),%eax
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	75 e2                	jne    8013dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013fa:	a1 08 44 80 00       	mov    0x804408,%eax
  8013ff:	8b 40 48             	mov    0x48(%eax),%eax
  801402:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140a:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  801411:	e8 0a f0 ff ff       	call   800420 <cprintf>
	*dev = 0;
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80141f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	56                   	push   %esi
  80142a:	53                   	push   %ebx
  80142b:	83 ec 20             	sub    $0x20,%esp
  80142e:	8b 75 08             	mov    0x8(%ebp),%esi
  801431:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801434:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801437:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80143b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801441:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801444:	89 04 24             	mov    %eax,(%esp)
  801447:	e8 2a ff ff ff       	call   801376 <fd_lookup>
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 05                	js     801455 <fd_close+0x2f>
	    || fd != fd2)
  801450:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801453:	74 0c                	je     801461 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801455:	84 db                	test   %bl,%bl
  801457:	ba 00 00 00 00       	mov    $0x0,%edx
  80145c:	0f 44 c2             	cmove  %edx,%eax
  80145f:	eb 3f                	jmp    8014a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801461:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801464:	89 44 24 04          	mov    %eax,0x4(%esp)
  801468:	8b 06                	mov    (%esi),%eax
  80146a:	89 04 24             	mov    %eax,(%esp)
  80146d:	e8 5a ff ff ff       	call   8013cc <dev_lookup>
  801472:	89 c3                	mov    %eax,%ebx
  801474:	85 c0                	test   %eax,%eax
  801476:	78 16                	js     80148e <fd_close+0x68>
		if (dev->dev_close)
  801478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80147e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801483:	85 c0                	test   %eax,%eax
  801485:	74 07                	je     80148e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801487:	89 34 24             	mov    %esi,(%esp)
  80148a:	ff d0                	call   *%eax
  80148c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80148e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801492:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801499:	e8 fe fb ff ff       	call   80109c <sys_page_unmap>
	return r;
  80149e:	89 d8                	mov    %ebx,%eax
}
  8014a0:	83 c4 20             	add    $0x20,%esp
  8014a3:	5b                   	pop    %ebx
  8014a4:	5e                   	pop    %esi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    

008014a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	89 04 24             	mov    %eax,(%esp)
  8014ba:	e8 b7 fe ff ff       	call   801376 <fd_lookup>
  8014bf:	89 c2                	mov    %eax,%edx
  8014c1:	85 d2                	test   %edx,%edx
  8014c3:	78 13                	js     8014d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8014c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014cc:	00 
  8014cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d0:	89 04 24             	mov    %eax,(%esp)
  8014d3:	e8 4e ff ff ff       	call   801426 <fd_close>
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <close_all>:

void
close_all(void)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	53                   	push   %ebx
  8014de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014e6:	89 1c 24             	mov    %ebx,(%esp)
  8014e9:	e8 b9 ff ff ff       	call   8014a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ee:	83 c3 01             	add    $0x1,%ebx
  8014f1:	83 fb 20             	cmp    $0x20,%ebx
  8014f4:	75 f0                	jne    8014e6 <close_all+0xc>
		close(i);
}
  8014f6:	83 c4 14             	add    $0x14,%esp
  8014f9:	5b                   	pop    %ebx
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    

008014fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	57                   	push   %edi
  801500:	56                   	push   %esi
  801501:	53                   	push   %ebx
  801502:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801505:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	89 04 24             	mov    %eax,(%esp)
  801512:	e8 5f fe ff ff       	call   801376 <fd_lookup>
  801517:	89 c2                	mov    %eax,%edx
  801519:	85 d2                	test   %edx,%edx
  80151b:	0f 88 e1 00 00 00    	js     801602 <dup+0x106>
		return r;
	close(newfdnum);
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	e8 7b ff ff ff       	call   8014a7 <close>

	newfd = INDEX2FD(newfdnum);
  80152c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80152f:	c1 e3 0c             	shl    $0xc,%ebx
  801532:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80153b:	89 04 24             	mov    %eax,(%esp)
  80153e:	e8 cd fd ff ff       	call   801310 <fd2data>
  801543:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801545:	89 1c 24             	mov    %ebx,(%esp)
  801548:	e8 c3 fd ff ff       	call   801310 <fd2data>
  80154d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80154f:	89 f0                	mov    %esi,%eax
  801551:	c1 e8 16             	shr    $0x16,%eax
  801554:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80155b:	a8 01                	test   $0x1,%al
  80155d:	74 43                	je     8015a2 <dup+0xa6>
  80155f:	89 f0                	mov    %esi,%eax
  801561:	c1 e8 0c             	shr    $0xc,%eax
  801564:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80156b:	f6 c2 01             	test   $0x1,%dl
  80156e:	74 32                	je     8015a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801570:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801577:	25 07 0e 00 00       	and    $0xe07,%eax
  80157c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801580:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801584:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80158b:	00 
  80158c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801590:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801597:	e8 ad fa ff ff       	call   801049 <sys_page_map>
  80159c:	89 c6                	mov    %eax,%esi
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 3e                	js     8015e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a5:	89 c2                	mov    %eax,%edx
  8015a7:	c1 ea 0c             	shr    $0xc,%edx
  8015aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8015b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015c6:	00 
  8015c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d2:	e8 72 fa ff ff       	call   801049 <sys_page_map>
  8015d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015dc:	85 f6                	test   %esi,%esi
  8015de:	79 22                	jns    801602 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015eb:	e8 ac fa ff ff       	call   80109c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015fb:	e8 9c fa ff ff       	call   80109c <sys_page_unmap>
	return r;
  801600:	89 f0                	mov    %esi,%eax
}
  801602:	83 c4 3c             	add    $0x3c,%esp
  801605:	5b                   	pop    %ebx
  801606:	5e                   	pop    %esi
  801607:	5f                   	pop    %edi
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    

0080160a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	53                   	push   %ebx
  80160e:	83 ec 24             	sub    $0x24,%esp
  801611:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801614:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801617:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161b:	89 1c 24             	mov    %ebx,(%esp)
  80161e:	e8 53 fd ff ff       	call   801376 <fd_lookup>
  801623:	89 c2                	mov    %eax,%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	78 6d                	js     801696 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801629:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	89 04 24             	mov    %eax,(%esp)
  801638:	e8 8f fd ff ff       	call   8013cc <dev_lookup>
  80163d:	85 c0                	test   %eax,%eax
  80163f:	78 55                	js     801696 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 50 08             	mov    0x8(%eax),%edx
  801647:	83 e2 03             	and    $0x3,%edx
  80164a:	83 fa 01             	cmp    $0x1,%edx
  80164d:	75 23                	jne    801672 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80164f:	a1 08 44 80 00       	mov    0x804408,%eax
  801654:	8b 40 48             	mov    0x48(%eax),%eax
  801657:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80165b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165f:	c7 04 24 f5 2d 80 00 	movl   $0x802df5,(%esp)
  801666:	e8 b5 ed ff ff       	call   800420 <cprintf>
		return -E_INVAL;
  80166b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801670:	eb 24                	jmp    801696 <read+0x8c>
	}
	if (!dev->dev_read)
  801672:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801675:	8b 52 08             	mov    0x8(%edx),%edx
  801678:	85 d2                	test   %edx,%edx
  80167a:	74 15                	je     801691 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80167c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801683:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801686:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80168a:	89 04 24             	mov    %eax,(%esp)
  80168d:	ff d2                	call   *%edx
  80168f:	eb 05                	jmp    801696 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801691:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801696:	83 c4 24             	add    $0x24,%esp
  801699:	5b                   	pop    %ebx
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    

0080169c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	57                   	push   %edi
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 1c             	sub    $0x1c,%esp
  8016a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b0:	eb 23                	jmp    8016d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016b2:	89 f0                	mov    %esi,%eax
  8016b4:	29 d8                	sub    %ebx,%eax
  8016b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016ba:	89 d8                	mov    %ebx,%eax
  8016bc:	03 45 0c             	add    0xc(%ebp),%eax
  8016bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c3:	89 3c 24             	mov    %edi,(%esp)
  8016c6:	e8 3f ff ff ff       	call   80160a <read>
		if (m < 0)
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 10                	js     8016df <readn+0x43>
			return m;
		if (m == 0)
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	74 0a                	je     8016dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016d3:	01 c3                	add    %eax,%ebx
  8016d5:	39 f3                	cmp    %esi,%ebx
  8016d7:	72 d9                	jb     8016b2 <readn+0x16>
  8016d9:	89 d8                	mov    %ebx,%eax
  8016db:	eb 02                	jmp    8016df <readn+0x43>
  8016dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016df:	83 c4 1c             	add    $0x1c,%esp
  8016e2:	5b                   	pop    %ebx
  8016e3:	5e                   	pop    %esi
  8016e4:	5f                   	pop    %edi
  8016e5:	5d                   	pop    %ebp
  8016e6:	c3                   	ret    

008016e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	53                   	push   %ebx
  8016eb:	83 ec 24             	sub    $0x24,%esp
  8016ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f8:	89 1c 24             	mov    %ebx,(%esp)
  8016fb:	e8 76 fc ff ff       	call   801376 <fd_lookup>
  801700:	89 c2                	mov    %eax,%edx
  801702:	85 d2                	test   %edx,%edx
  801704:	78 68                	js     80176e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801706:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801709:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801710:	8b 00                	mov    (%eax),%eax
  801712:	89 04 24             	mov    %eax,(%esp)
  801715:	e8 b2 fc ff ff       	call   8013cc <dev_lookup>
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 50                	js     80176e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801721:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801725:	75 23                	jne    80174a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801727:	a1 08 44 80 00       	mov    0x804408,%eax
  80172c:	8b 40 48             	mov    0x48(%eax),%eax
  80172f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801733:	89 44 24 04          	mov    %eax,0x4(%esp)
  801737:	c7 04 24 11 2e 80 00 	movl   $0x802e11,(%esp)
  80173e:	e8 dd ec ff ff       	call   800420 <cprintf>
		return -E_INVAL;
  801743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801748:	eb 24                	jmp    80176e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80174a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174d:	8b 52 0c             	mov    0xc(%edx),%edx
  801750:	85 d2                	test   %edx,%edx
  801752:	74 15                	je     801769 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801754:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801757:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80175b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80175e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801762:	89 04 24             	mov    %eax,(%esp)
  801765:	ff d2                	call   *%edx
  801767:	eb 05                	jmp    80176e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801769:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80176e:	83 c4 24             	add    $0x24,%esp
  801771:	5b                   	pop    %ebx
  801772:	5d                   	pop    %ebp
  801773:	c3                   	ret    

00801774 <seek>:

int
seek(int fdnum, off_t offset)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80177a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80177d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	89 04 24             	mov    %eax,(%esp)
  801787:	e8 ea fb ff ff       	call   801376 <fd_lookup>
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 0e                	js     80179e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801790:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801793:	8b 55 0c             	mov    0xc(%ebp),%edx
  801796:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 24             	sub    $0x24,%esp
  8017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b1:	89 1c 24             	mov    %ebx,(%esp)
  8017b4:	e8 bd fb ff ff       	call   801376 <fd_lookup>
  8017b9:	89 c2                	mov    %eax,%edx
  8017bb:	85 d2                	test   %edx,%edx
  8017bd:	78 61                	js     801820 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	8b 00                	mov    (%eax),%eax
  8017cb:	89 04 24             	mov    %eax,(%esp)
  8017ce:	e8 f9 fb ff ff       	call   8013cc <dev_lookup>
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 49                	js     801820 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017de:	75 23                	jne    801803 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017e0:	a1 08 44 80 00       	mov    0x804408,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017e5:	8b 40 48             	mov    0x48(%eax),%eax
  8017e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f0:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  8017f7:	e8 24 ec ff ff       	call   800420 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801801:	eb 1d                	jmp    801820 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801806:	8b 52 18             	mov    0x18(%edx),%edx
  801809:	85 d2                	test   %edx,%edx
  80180b:	74 0e                	je     80181b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80180d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801810:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801814:	89 04 24             	mov    %eax,(%esp)
  801817:	ff d2                	call   *%edx
  801819:	eb 05                	jmp    801820 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80181b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801820:	83 c4 24             	add    $0x24,%esp
  801823:	5b                   	pop    %ebx
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	53                   	push   %ebx
  80182a:	83 ec 24             	sub    $0x24,%esp
  80182d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801830:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801833:	89 44 24 04          	mov    %eax,0x4(%esp)
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	89 04 24             	mov    %eax,(%esp)
  80183d:	e8 34 fb ff ff       	call   801376 <fd_lookup>
  801842:	89 c2                	mov    %eax,%edx
  801844:	85 d2                	test   %edx,%edx
  801846:	78 52                	js     80189a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801848:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801852:	8b 00                	mov    (%eax),%eax
  801854:	89 04 24             	mov    %eax,(%esp)
  801857:	e8 70 fb ff ff       	call   8013cc <dev_lookup>
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 3a                	js     80189a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801863:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801867:	74 2c                	je     801895 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801869:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80186c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801873:	00 00 00 
	stat->st_isdir = 0;
  801876:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80187d:	00 00 00 
	stat->st_dev = dev;
  801880:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801886:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80188a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80188d:	89 14 24             	mov    %edx,(%esp)
  801890:	ff 50 14             	call   *0x14(%eax)
  801893:	eb 05                	jmp    80189a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801895:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80189a:	83 c4 24             	add    $0x24,%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5d                   	pop    %ebp
  80189f:	c3                   	ret    

008018a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	56                   	push   %esi
  8018a4:	53                   	push   %ebx
  8018a5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018af:	00 
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	89 04 24             	mov    %eax,(%esp)
  8018b6:	e8 99 02 00 00       	call   801b54 <open>
  8018bb:	89 c3                	mov    %eax,%ebx
  8018bd:	85 db                	test   %ebx,%ebx
  8018bf:	78 1b                	js     8018dc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c8:	89 1c 24             	mov    %ebx,(%esp)
  8018cb:	e8 56 ff ff ff       	call   801826 <fstat>
  8018d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8018d2:	89 1c 24             	mov    %ebx,(%esp)
  8018d5:	e8 cd fb ff ff       	call   8014a7 <close>
	return r;
  8018da:	89 f0                	mov    %esi,%eax
}
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
  8018e8:	83 ec 10             	sub    $0x10,%esp
  8018eb:	89 c6                	mov    %eax,%esi
  8018ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018ef:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  8018f6:	75 11                	jne    801909 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8018ff:	e8 ab 0d 00 00       	call   8026af <ipc_find_env>
  801904:	a3 00 44 80 00       	mov    %eax,0x804400
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801909:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801910:	00 
  801911:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801918:	00 
  801919:	89 74 24 04          	mov    %esi,0x4(%esp)
  80191d:	a1 00 44 80 00       	mov    0x804400,%eax
  801922:	89 04 24             	mov    %eax,(%esp)
  801925:	e8 1e 0d 00 00       	call   802648 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80192a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801931:	00 
  801932:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801936:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80193d:	e8 9e 0c 00 00       	call   8025e0 <ipc_recv>
}
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8b 40 0c             	mov    0xc(%eax),%eax
  801955:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801962:	ba 00 00 00 00       	mov    $0x0,%edx
  801967:	b8 02 00 00 00       	mov    $0x2,%eax
  80196c:	e8 72 ff ff ff       	call   8018e3 <fsipc>
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8b 40 0c             	mov    0xc(%eax),%eax
  80197f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801984:	ba 00 00 00 00       	mov    $0x0,%edx
  801989:	b8 06 00 00 00       	mov    $0x6,%eax
  80198e:	e8 50 ff ff ff       	call   8018e3 <fsipc>
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	53                   	push   %ebx
  801999:	83 ec 14             	sub    $0x14,%esp
  80199c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019af:	b8 05 00 00 00       	mov    $0x5,%eax
  8019b4:	e8 2a ff ff ff       	call   8018e3 <fsipc>
  8019b9:	89 c2                	mov    %eax,%edx
  8019bb:	85 d2                	test   %edx,%edx
  8019bd:	78 2b                	js     8019ea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019bf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8019c6:	00 
  8019c7:	89 1c 24             	mov    %ebx,(%esp)
  8019ca:	e8 b8 f1 ff ff       	call   800b87 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019cf:	a1 80 50 80 00       	mov    0x805080,%eax
  8019d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019da:	a1 84 50 80 00       	mov    0x805084,%eax
  8019df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ea:	83 c4 14             	add    $0x14,%esp
  8019ed:	5b                   	pop    %ebx
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    

008019f0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	53                   	push   %ebx
  8019f4:	83 ec 14             	sub    $0x14,%esp
  8019f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  8019fa:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801a00:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801a05:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a08:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0b:	8b 52 0c             	mov    0xc(%edx),%edx
  801a0e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801a14:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801a19:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a24:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  801a2b:	e8 f4 f2 ff ff       	call   800d24 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801a30:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801a37:	00 
  801a38:	c7 04 24 44 2e 80 00 	movl   $0x802e44,(%esp)
  801a3f:	e8 dc e9 ff ff       	call   800420 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a44:	ba 00 00 00 00       	mov    $0x0,%edx
  801a49:	b8 04 00 00 00       	mov    $0x4,%eax
  801a4e:	e8 90 fe ff ff       	call   8018e3 <fsipc>
  801a53:	85 c0                	test   %eax,%eax
  801a55:	78 53                	js     801aaa <devfile_write+0xba>
		return r;
	assert(r <= n);
  801a57:	39 c3                	cmp    %eax,%ebx
  801a59:	73 24                	jae    801a7f <devfile_write+0x8f>
  801a5b:	c7 44 24 0c 49 2e 80 	movl   $0x802e49,0xc(%esp)
  801a62:	00 
  801a63:	c7 44 24 08 50 2e 80 	movl   $0x802e50,0x8(%esp)
  801a6a:	00 
  801a6b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801a72:	00 
  801a73:	c7 04 24 65 2e 80 00 	movl   $0x802e65,(%esp)
  801a7a:	e8 a8 e8 ff ff       	call   800327 <_panic>
	assert(r <= PGSIZE);
  801a7f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a84:	7e 24                	jle    801aaa <devfile_write+0xba>
  801a86:	c7 44 24 0c 70 2e 80 	movl   $0x802e70,0xc(%esp)
  801a8d:	00 
  801a8e:	c7 44 24 08 50 2e 80 	movl   $0x802e50,0x8(%esp)
  801a95:	00 
  801a96:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801a9d:	00 
  801a9e:	c7 04 24 65 2e 80 00 	movl   $0x802e65,(%esp)
  801aa5:	e8 7d e8 ff ff       	call   800327 <_panic>
	return r;
}
  801aaa:	83 c4 14             	add    $0x14,%esp
  801aad:	5b                   	pop    %ebx
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	56                   	push   %esi
  801ab4:	53                   	push   %ebx
  801ab5:	83 ec 10             	sub    $0x10,%esp
  801ab8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ac6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801acc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad1:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad6:	e8 08 fe ff ff       	call   8018e3 <fsipc>
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 6a                	js     801b4b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ae1:	39 c6                	cmp    %eax,%esi
  801ae3:	73 24                	jae    801b09 <devfile_read+0x59>
  801ae5:	c7 44 24 0c 49 2e 80 	movl   $0x802e49,0xc(%esp)
  801aec:	00 
  801aed:	c7 44 24 08 50 2e 80 	movl   $0x802e50,0x8(%esp)
  801af4:	00 
  801af5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801afc:	00 
  801afd:	c7 04 24 65 2e 80 00 	movl   $0x802e65,(%esp)
  801b04:	e8 1e e8 ff ff       	call   800327 <_panic>
	assert(r <= PGSIZE);
  801b09:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b0e:	7e 24                	jle    801b34 <devfile_read+0x84>
  801b10:	c7 44 24 0c 70 2e 80 	movl   $0x802e70,0xc(%esp)
  801b17:	00 
  801b18:	c7 44 24 08 50 2e 80 	movl   $0x802e50,0x8(%esp)
  801b1f:	00 
  801b20:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b27:	00 
  801b28:	c7 04 24 65 2e 80 00 	movl   $0x802e65,(%esp)
  801b2f:	e8 f3 e7 ff ff       	call   800327 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b34:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b38:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b3f:	00 
  801b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b43:	89 04 24             	mov    %eax,(%esp)
  801b46:	e8 d9 f1 ff ff       	call   800d24 <memmove>
	return r;
}
  801b4b:	89 d8                	mov    %ebx,%eax
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	5b                   	pop    %ebx
  801b51:	5e                   	pop    %esi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    

00801b54 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	53                   	push   %ebx
  801b58:	83 ec 24             	sub    $0x24,%esp
  801b5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b5e:	89 1c 24             	mov    %ebx,(%esp)
  801b61:	e8 ea ef ff ff       	call   800b50 <strlen>
  801b66:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b6b:	7f 60                	jg     801bcd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b70:	89 04 24             	mov    %eax,(%esp)
  801b73:	e8 af f7 ff ff       	call   801327 <fd_alloc>
  801b78:	89 c2                	mov    %eax,%edx
  801b7a:	85 d2                	test   %edx,%edx
  801b7c:	78 54                	js     801bd2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b82:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801b89:	e8 f9 ef ff ff       	call   800b87 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b91:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b99:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9e:	e8 40 fd ff ff       	call   8018e3 <fsipc>
  801ba3:	89 c3                	mov    %eax,%ebx
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	79 17                	jns    801bc0 <open+0x6c>
		fd_close(fd, 0);
  801ba9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bb0:	00 
  801bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb4:	89 04 24             	mov    %eax,(%esp)
  801bb7:	e8 6a f8 ff ff       	call   801426 <fd_close>
		return r;
  801bbc:	89 d8                	mov    %ebx,%eax
  801bbe:	eb 12                	jmp    801bd2 <open+0x7e>
	}

	return fd2num(fd);
  801bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc3:	89 04 24             	mov    %eax,(%esp)
  801bc6:	e8 35 f7 ff ff       	call   801300 <fd2num>
  801bcb:	eb 05                	jmp    801bd2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801bcd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801bd2:	83 c4 24             	add    $0x24,%esp
  801bd5:	5b                   	pop    %ebx
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    

00801bd8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bde:	ba 00 00 00 00       	mov    $0x0,%edx
  801be3:	b8 08 00 00 00       	mov    $0x8,%eax
  801be8:	e8 f6 fc ff ff       	call   8018e3 <fsipc>
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <evict>:

int evict(void)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801bf5:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  801bfc:	e8 1f e8 ff ff       	call   800420 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801c01:	ba 00 00 00 00       	mov    $0x0,%edx
  801c06:	b8 09 00 00 00       	mov    $0x9,%eax
  801c0b:	e8 d3 fc ff ff       	call   8018e3 <fsipc>
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	53                   	push   %ebx
  801c16:	83 ec 14             	sub    $0x14,%esp
  801c19:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801c1b:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801c1f:	7e 31                	jle    801c52 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c21:	8b 40 04             	mov    0x4(%eax),%eax
  801c24:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c28:	8d 43 10             	lea    0x10(%ebx),%eax
  801c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2f:	8b 03                	mov    (%ebx),%eax
  801c31:	89 04 24             	mov    %eax,(%esp)
  801c34:	e8 ae fa ff ff       	call   8016e7 <write>
		if (result > 0)
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	7e 03                	jle    801c40 <writebuf+0x2e>
			b->result += result;
  801c3d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801c40:	39 43 04             	cmp    %eax,0x4(%ebx)
  801c43:	74 0d                	je     801c52 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801c45:	85 c0                	test   %eax,%eax
  801c47:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4c:	0f 4f c2             	cmovg  %edx,%eax
  801c4f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801c52:	83 c4 14             	add    $0x14,%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    

00801c58 <putch>:

static void
putch(int ch, void *thunk)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	53                   	push   %ebx
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c62:	8b 53 04             	mov    0x4(%ebx),%edx
  801c65:	8d 42 01             	lea    0x1(%edx),%eax
  801c68:	89 43 04             	mov    %eax,0x4(%ebx)
  801c6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6e:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801c72:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c77:	75 0e                	jne    801c87 <putch+0x2f>
		writebuf(b);
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	e8 92 ff ff ff       	call   801c12 <writebuf>
		b->idx = 0;
  801c80:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c87:	83 c4 04             	add    $0x4,%esp
  801c8a:	5b                   	pop    %ebx
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    

00801c8d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c9f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801ca6:	00 00 00 
	b.result = 0;
  801ca9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801cb0:	00 00 00 
	b.error = 1;
  801cb3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801cba:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ccb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd5:	c7 04 24 58 1c 80 00 	movl   $0x801c58,(%esp)
  801cdc:	e8 93 e8 ff ff       	call   800574 <vprintfmt>
	if (b.idx > 0)
  801ce1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801ce8:	7e 0b                	jle    801cf5 <vfprintf+0x68>
		writebuf(&b);
  801cea:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801cf0:	e8 1d ff ff ff       	call   801c12 <writebuf>

	return (b.result ? b.result : b.error);
  801cf5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d0c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	89 04 24             	mov    %eax,(%esp)
  801d20:	e8 68 ff ff ff       	call   801c8d <vfprintf>
	va_end(ap);

	return cnt;
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <printf>:

int
printf(const char *fmt, ...)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d2d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d30:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d42:	e8 46 ff ff ff       	call   801c8d <vfprintf>
	va_end(ap);

	return cnt;
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    
  801d49:	66 90                	xchg   %ax,%ax
  801d4b:	66 90                	xchg   %ax,%ax
  801d4d:	66 90                	xchg   %ax,%ax
  801d4f:	90                   	nop

00801d50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d56:	c7 44 24 04 95 2e 80 	movl   $0x802e95,0x4(%esp)
  801d5d:	00 
  801d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d61:	89 04 24             	mov    %eax,(%esp)
  801d64:	e8 1e ee ff ff       	call   800b87 <strcpy>
	return 0;
}
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	53                   	push   %ebx
  801d74:	83 ec 14             	sub    $0x14,%esp
  801d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d7a:	89 1c 24             	mov    %ebx,(%esp)
  801d7d:	e8 65 09 00 00       	call   8026e7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d82:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d87:	83 f8 01             	cmp    $0x1,%eax
  801d8a:	75 0d                	jne    801d99 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d8c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d8f:	89 04 24             	mov    %eax,(%esp)
  801d92:	e8 29 03 00 00       	call   8020c0 <nsipc_close>
  801d97:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d99:	89 d0                	mov    %edx,%eax
  801d9b:	83 c4 14             	add    $0x14,%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    

00801da1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801da7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dae:	00 
  801daf:	8b 45 10             	mov    0x10(%ebp),%eax
  801db2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc3:	89 04 24             	mov    %eax,(%esp)
  801dc6:	e8 f0 03 00 00       	call   8021bb <nsipc_send>
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801dd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dda:	00 
  801ddb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dde:	89 44 24 08          	mov    %eax,0x8(%esp)
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	8b 40 0c             	mov    0xc(%eax),%eax
  801def:	89 04 24             	mov    %eax,(%esp)
  801df2:	e8 44 03 00 00       	call   80213b <nsipc_recv>
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e02:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e06:	89 04 24             	mov    %eax,(%esp)
  801e09:	e8 68 f5 ff ff       	call   801376 <fd_lookup>
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	78 17                	js     801e29 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e15:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801e1b:	39 08                	cmp    %ecx,(%eax)
  801e1d:	75 05                	jne    801e24 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e22:	eb 05                	jmp    801e29 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801e24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	83 ec 20             	sub    $0x20,%esp
  801e33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e38:	89 04 24             	mov    %eax,(%esp)
  801e3b:	e8 e7 f4 ff ff       	call   801327 <fd_alloc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	85 c0                	test   %eax,%eax
  801e44:	78 21                	js     801e67 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e4d:	00 
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e5c:	e8 94 f1 ff ff       	call   800ff5 <sys_page_alloc>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	85 c0                	test   %eax,%eax
  801e65:	79 0c                	jns    801e73 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e67:	89 34 24             	mov    %esi,(%esp)
  801e6a:	e8 51 02 00 00       	call   8020c0 <nsipc_close>
		return r;
  801e6f:	89 d8                	mov    %ebx,%eax
  801e71:	eb 20                	jmp    801e93 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e73:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e81:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e88:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e8b:	89 14 24             	mov    %edx,(%esp)
  801e8e:	e8 6d f4 ff ff       	call   801300 <fd2num>
}
  801e93:	83 c4 20             	add    $0x20,%esp
  801e96:	5b                   	pop    %ebx
  801e97:	5e                   	pop    %esi
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    

00801e9a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	e8 51 ff ff ff       	call   801df9 <fd2sockid>
		return r;
  801ea8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	78 23                	js     801ed1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801eae:	8b 55 10             	mov    0x10(%ebp),%edx
  801eb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ebc:	89 04 24             	mov    %eax,(%esp)
  801ebf:	e8 45 01 00 00       	call   802009 <nsipc_accept>
		return r;
  801ec4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	78 07                	js     801ed1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801eca:	e8 5c ff ff ff       	call   801e2b <alloc_sockfd>
  801ecf:	89 c1                	mov    %eax,%ecx
}
  801ed1:	89 c8                	mov    %ecx,%eax
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	e8 16 ff ff ff       	call   801df9 <fd2sockid>
  801ee3:	89 c2                	mov    %eax,%edx
  801ee5:	85 d2                	test   %edx,%edx
  801ee7:	78 16                	js     801eff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  801eec:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef7:	89 14 24             	mov    %edx,(%esp)
  801efa:	e8 60 01 00 00       	call   80205f <nsipc_bind>
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <shutdown>:

int
shutdown(int s, int how)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	e8 ea fe ff ff       	call   801df9 <fd2sockid>
  801f0f:	89 c2                	mov    %eax,%edx
  801f11:	85 d2                	test   %edx,%edx
  801f13:	78 0f                	js     801f24 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1c:	89 14 24             	mov    %edx,(%esp)
  801f1f:	e8 7a 01 00 00       	call   80209e <nsipc_shutdown>
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	e8 c5 fe ff ff       	call   801df9 <fd2sockid>
  801f34:	89 c2                	mov    %eax,%edx
  801f36:	85 d2                	test   %edx,%edx
  801f38:	78 16                	js     801f50 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f48:	89 14 24             	mov    %edx,(%esp)
  801f4b:	e8 8a 01 00 00       	call   8020da <nsipc_connect>
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <listen>:

int
listen(int s, int backlog)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	e8 99 fe ff ff       	call   801df9 <fd2sockid>
  801f60:	89 c2                	mov    %eax,%edx
  801f62:	85 d2                	test   %edx,%edx
  801f64:	78 0f                	js     801f75 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6d:	89 14 24             	mov    %edx,(%esp)
  801f70:	e8 a4 01 00 00       	call   802119 <nsipc_listen>
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	89 04 24             	mov    %eax,(%esp)
  801f91:	e8 98 02 00 00       	call   80222e <nsipc_socket>
  801f96:	89 c2                	mov    %eax,%edx
  801f98:	85 d2                	test   %edx,%edx
  801f9a:	78 05                	js     801fa1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f9c:	e8 8a fe ff ff       	call   801e2b <alloc_sockfd>
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	53                   	push   %ebx
  801fa7:	83 ec 14             	sub    $0x14,%esp
  801faa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fac:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801fb3:	75 11                	jne    801fc6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fb5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801fbc:	e8 ee 06 00 00       	call   8026af <ipc_find_env>
  801fc1:	a3 04 44 80 00       	mov    %eax,0x804404
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fc6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801fcd:	00 
  801fce:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801fd5:	00 
  801fd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fda:	a1 04 44 80 00       	mov    0x804404,%eax
  801fdf:	89 04 24             	mov    %eax,(%esp)
  801fe2:	e8 61 06 00 00       	call   802648 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fe7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fee:	00 
  801fef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ff6:	00 
  801ff7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ffe:	e8 dd 05 00 00       	call   8025e0 <ipc_recv>
}
  802003:	83 c4 14             	add    $0x14,%esp
  802006:	5b                   	pop    %ebx
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	56                   	push   %esi
  80200d:	53                   	push   %ebx
  80200e:	83 ec 10             	sub    $0x10,%esp
  802011:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80201c:	8b 06                	mov    (%esi),%eax
  80201e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802023:	b8 01 00 00 00       	mov    $0x1,%eax
  802028:	e8 76 ff ff ff       	call   801fa3 <nsipc>
  80202d:	89 c3                	mov    %eax,%ebx
  80202f:	85 c0                	test   %eax,%eax
  802031:	78 23                	js     802056 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802033:	a1 10 60 80 00       	mov    0x806010,%eax
  802038:	89 44 24 08          	mov    %eax,0x8(%esp)
  80203c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802043:	00 
  802044:	8b 45 0c             	mov    0xc(%ebp),%eax
  802047:	89 04 24             	mov    %eax,(%esp)
  80204a:	e8 d5 ec ff ff       	call   800d24 <memmove>
		*addrlen = ret->ret_addrlen;
  80204f:	a1 10 60 80 00       	mov    0x806010,%eax
  802054:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802056:	89 d8                	mov    %ebx,%eax
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	5b                   	pop    %ebx
  80205c:	5e                   	pop    %esi
  80205d:	5d                   	pop    %ebp
  80205e:	c3                   	ret    

0080205f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	53                   	push   %ebx
  802063:	83 ec 14             	sub    $0x14,%esp
  802066:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802071:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802075:	8b 45 0c             	mov    0xc(%ebp),%eax
  802078:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802083:	e8 9c ec ff ff       	call   800d24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802088:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80208e:	b8 02 00 00 00       	mov    $0x2,%eax
  802093:	e8 0b ff ff ff       	call   801fa3 <nsipc>
}
  802098:	83 c4 14             	add    $0x14,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    

0080209e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8020ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020af:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8020b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020b9:	e8 e5 fe ff ff       	call   801fa3 <nsipc>
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8020ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8020d3:	e8 cb fe ff ff       	call   801fa3 <nsipc>
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	53                   	push   %ebx
  8020de:	83 ec 14             	sub    $0x14,%esp
  8020e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8020fe:	e8 21 ec ff ff       	call   800d24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802103:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802109:	b8 05 00 00 00       	mov    $0x5,%eax
  80210e:	e8 90 fe ff ff       	call   801fa3 <nsipc>
}
  802113:	83 c4 14             	add    $0x14,%esp
  802116:	5b                   	pop    %ebx
  802117:	5d                   	pop    %ebp
  802118:	c3                   	ret    

00802119 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80212f:	b8 06 00 00 00       	mov    $0x6,%eax
  802134:	e8 6a fe ff ff       	call   801fa3 <nsipc>
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	56                   	push   %esi
  80213f:	53                   	push   %ebx
  802140:	83 ec 10             	sub    $0x10,%esp
  802143:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80214e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802154:	8b 45 14             	mov    0x14(%ebp),%eax
  802157:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80215c:	b8 07 00 00 00       	mov    $0x7,%eax
  802161:	e8 3d fe ff ff       	call   801fa3 <nsipc>
  802166:	89 c3                	mov    %eax,%ebx
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 46                	js     8021b2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80216c:	39 f0                	cmp    %esi,%eax
  80216e:	7f 07                	jg     802177 <nsipc_recv+0x3c>
  802170:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802175:	7e 24                	jle    80219b <nsipc_recv+0x60>
  802177:	c7 44 24 0c a1 2e 80 	movl   $0x802ea1,0xc(%esp)
  80217e:	00 
  80217f:	c7 44 24 08 50 2e 80 	movl   $0x802e50,0x8(%esp)
  802186:	00 
  802187:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80218e:	00 
  80218f:	c7 04 24 b6 2e 80 00 	movl   $0x802eb6,(%esp)
  802196:	e8 8c e1 ff ff       	call   800327 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80219b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80219f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8021a6:	00 
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	89 04 24             	mov    %eax,(%esp)
  8021ad:	e8 72 eb ff ff       	call   800d24 <memmove>
	}

	return r;
}
  8021b2:	89 d8                	mov    %ebx,%eax
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5d                   	pop    %ebp
  8021ba:	c3                   	ret    

008021bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	53                   	push   %ebx
  8021bf:	83 ec 14             	sub    $0x14,%esp
  8021c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021d3:	7e 24                	jle    8021f9 <nsipc_send+0x3e>
  8021d5:	c7 44 24 0c c2 2e 80 	movl   $0x802ec2,0xc(%esp)
  8021dc:	00 
  8021dd:	c7 44 24 08 50 2e 80 	movl   $0x802e50,0x8(%esp)
  8021e4:	00 
  8021e5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8021ec:	00 
  8021ed:	c7 04 24 b6 2e 80 00 	movl   $0x802eb6,(%esp)
  8021f4:	e8 2e e1 ff ff       	call   800327 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802200:	89 44 24 04          	mov    %eax,0x4(%esp)
  802204:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80220b:	e8 14 eb ff ff       	call   800d24 <memmove>
	nsipcbuf.send.req_size = size;
  802210:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802216:	8b 45 14             	mov    0x14(%ebp),%eax
  802219:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80221e:	b8 08 00 00 00       	mov    $0x8,%eax
  802223:	e8 7b fd ff ff       	call   801fa3 <nsipc>
}
  802228:	83 c4 14             	add    $0x14,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    

0080222e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80223c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802244:	8b 45 10             	mov    0x10(%ebp),%eax
  802247:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80224c:	b8 09 00 00 00       	mov    $0x9,%eax
  802251:	e8 4d fd ff ff       	call   801fa3 <nsipc>
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	56                   	push   %esi
  80225c:	53                   	push   %ebx
  80225d:	83 ec 10             	sub    $0x10,%esp
  802260:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	89 04 24             	mov    %eax,(%esp)
  802269:	e8 a2 f0 ff ff       	call   801310 <fd2data>
  80226e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802270:	c7 44 24 04 ce 2e 80 	movl   $0x802ece,0x4(%esp)
  802277:	00 
  802278:	89 1c 24             	mov    %ebx,(%esp)
  80227b:	e8 07 e9 ff ff       	call   800b87 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802280:	8b 46 04             	mov    0x4(%esi),%eax
  802283:	2b 06                	sub    (%esi),%eax
  802285:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80228b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802292:	00 00 00 
	stat->st_dev = &devpipe;
  802295:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  80229c:	30 80 00 
	return 0;
}
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5d                   	pop    %ebp
  8022aa:	c3                   	ret    

008022ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	53                   	push   %ebx
  8022af:	83 ec 14             	sub    $0x14,%esp
  8022b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c0:	e8 d7 ed ff ff       	call   80109c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022c5:	89 1c 24             	mov    %ebx,(%esp)
  8022c8:	e8 43 f0 ff ff       	call   801310 <fd2data>
  8022cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d8:	e8 bf ed ff ff       	call   80109c <sys_page_unmap>
}
  8022dd:	83 c4 14             	add    $0x14,%esp
  8022e0:	5b                   	pop    %ebx
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    

008022e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	57                   	push   %edi
  8022e7:	56                   	push   %esi
  8022e8:	53                   	push   %ebx
  8022e9:	83 ec 2c             	sub    $0x2c,%esp
  8022ec:	89 c6                	mov    %eax,%esi
  8022ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8022f1:	a1 08 44 80 00       	mov    0x804408,%eax
  8022f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022f9:	89 34 24             	mov    %esi,(%esp)
  8022fc:	e8 e6 03 00 00       	call   8026e7 <pageref>
  802301:	89 c7                	mov    %eax,%edi
  802303:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802306:	89 04 24             	mov    %eax,(%esp)
  802309:	e8 d9 03 00 00       	call   8026e7 <pageref>
  80230e:	39 c7                	cmp    %eax,%edi
  802310:	0f 94 c2             	sete   %dl
  802313:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802316:	8b 0d 08 44 80 00    	mov    0x804408,%ecx
  80231c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80231f:	39 fb                	cmp    %edi,%ebx
  802321:	74 21                	je     802344 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802323:	84 d2                	test   %dl,%dl
  802325:	74 ca                	je     8022f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802327:	8b 51 58             	mov    0x58(%ecx),%edx
  80232a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80232e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802332:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802336:	c7 04 24 d5 2e 80 00 	movl   $0x802ed5,(%esp)
  80233d:	e8 de e0 ff ff       	call   800420 <cprintf>
  802342:	eb ad                	jmp    8022f1 <_pipeisclosed+0xe>
	}
}
  802344:	83 c4 2c             	add    $0x2c,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5f                   	pop    %edi
  80234a:	5d                   	pop    %ebp
  80234b:	c3                   	ret    

0080234c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	57                   	push   %edi
  802350:	56                   	push   %esi
  802351:	53                   	push   %ebx
  802352:	83 ec 1c             	sub    $0x1c,%esp
  802355:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802358:	89 34 24             	mov    %esi,(%esp)
  80235b:	e8 b0 ef ff ff       	call   801310 <fd2data>
  802360:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802362:	bf 00 00 00 00       	mov    $0x0,%edi
  802367:	eb 45                	jmp    8023ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802369:	89 da                	mov    %ebx,%edx
  80236b:	89 f0                	mov    %esi,%eax
  80236d:	e8 71 ff ff ff       	call   8022e3 <_pipeisclosed>
  802372:	85 c0                	test   %eax,%eax
  802374:	75 41                	jne    8023b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802376:	e8 5b ec ff ff       	call   800fd6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80237b:	8b 43 04             	mov    0x4(%ebx),%eax
  80237e:	8b 0b                	mov    (%ebx),%ecx
  802380:	8d 51 20             	lea    0x20(%ecx),%edx
  802383:	39 d0                	cmp    %edx,%eax
  802385:	73 e2                	jae    802369 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80238a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80238e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802391:	99                   	cltd   
  802392:	c1 ea 1b             	shr    $0x1b,%edx
  802395:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802398:	83 e1 1f             	and    $0x1f,%ecx
  80239b:	29 d1                	sub    %edx,%ecx
  80239d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8023a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8023a5:	83 c0 01             	add    $0x1,%eax
  8023a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023ab:	83 c7 01             	add    $0x1,%edi
  8023ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023b1:	75 c8                	jne    80237b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023b3:	89 f8                	mov    %edi,%eax
  8023b5:	eb 05                	jmp    8023bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8023bc:	83 c4 1c             	add    $0x1c,%esp
  8023bf:	5b                   	pop    %ebx
  8023c0:	5e                   	pop    %esi
  8023c1:	5f                   	pop    %edi
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    

008023c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	57                   	push   %edi
  8023c8:	56                   	push   %esi
  8023c9:	53                   	push   %ebx
  8023ca:	83 ec 1c             	sub    $0x1c,%esp
  8023cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023d0:	89 3c 24             	mov    %edi,(%esp)
  8023d3:	e8 38 ef ff ff       	call   801310 <fd2data>
  8023d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023da:	be 00 00 00 00       	mov    $0x0,%esi
  8023df:	eb 3d                	jmp    80241e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023e1:	85 f6                	test   %esi,%esi
  8023e3:	74 04                	je     8023e9 <devpipe_read+0x25>
				return i;
  8023e5:	89 f0                	mov    %esi,%eax
  8023e7:	eb 43                	jmp    80242c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023e9:	89 da                	mov    %ebx,%edx
  8023eb:	89 f8                	mov    %edi,%eax
  8023ed:	e8 f1 fe ff ff       	call   8022e3 <_pipeisclosed>
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	75 31                	jne    802427 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023f6:	e8 db eb ff ff       	call   800fd6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023fb:	8b 03                	mov    (%ebx),%eax
  8023fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802400:	74 df                	je     8023e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802402:	99                   	cltd   
  802403:	c1 ea 1b             	shr    $0x1b,%edx
  802406:	01 d0                	add    %edx,%eax
  802408:	83 e0 1f             	and    $0x1f,%eax
  80240b:	29 d0                	sub    %edx,%eax
  80240d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802412:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802415:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802418:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80241b:	83 c6 01             	add    $0x1,%esi
  80241e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802421:	75 d8                	jne    8023fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802423:	89 f0                	mov    %esi,%eax
  802425:	eb 05                	jmp    80242c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80242c:	83 c4 1c             	add    $0x1c,%esp
  80242f:	5b                   	pop    %ebx
  802430:	5e                   	pop    %esi
  802431:	5f                   	pop    %edi
  802432:	5d                   	pop    %ebp
  802433:	c3                   	ret    

00802434 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	56                   	push   %esi
  802438:	53                   	push   %ebx
  802439:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80243c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80243f:	89 04 24             	mov    %eax,(%esp)
  802442:	e8 e0 ee ff ff       	call   801327 <fd_alloc>
  802447:	89 c2                	mov    %eax,%edx
  802449:	85 d2                	test   %edx,%edx
  80244b:	0f 88 4d 01 00 00    	js     80259e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802451:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802458:	00 
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802460:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802467:	e8 89 eb ff ff       	call   800ff5 <sys_page_alloc>
  80246c:	89 c2                	mov    %eax,%edx
  80246e:	85 d2                	test   %edx,%edx
  802470:	0f 88 28 01 00 00    	js     80259e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802476:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802479:	89 04 24             	mov    %eax,(%esp)
  80247c:	e8 a6 ee ff ff       	call   801327 <fd_alloc>
  802481:	89 c3                	mov    %eax,%ebx
  802483:	85 c0                	test   %eax,%eax
  802485:	0f 88 fe 00 00 00    	js     802589 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802492:	00 
  802493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80249a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a1:	e8 4f eb ff ff       	call   800ff5 <sys_page_alloc>
  8024a6:	89 c3                	mov    %eax,%ebx
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	0f 88 d9 00 00 00    	js     802589 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	89 04 24             	mov    %eax,(%esp)
  8024b6:	e8 55 ee ff ff       	call   801310 <fd2data>
  8024bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024c4:	00 
  8024c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d0:	e8 20 eb ff ff       	call   800ff5 <sys_page_alloc>
  8024d5:	89 c3                	mov    %eax,%ebx
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	0f 88 97 00 00 00    	js     802576 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	89 04 24             	mov    %eax,(%esp)
  8024e5:	e8 26 ee ff ff       	call   801310 <fd2data>
  8024ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024f1:	00 
  8024f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024fd:	00 
  8024fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802502:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802509:	e8 3b eb ff ff       	call   801049 <sys_page_map>
  80250e:	89 c3                	mov    %eax,%ebx
  802510:	85 c0                	test   %eax,%eax
  802512:	78 52                	js     802566 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802514:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802529:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802532:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802537:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	89 04 24             	mov    %eax,(%esp)
  802544:	e8 b7 ed ff ff       	call   801300 <fd2num>
  802549:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80254c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	89 04 24             	mov    %eax,(%esp)
  802554:	e8 a7 ed ff ff       	call   801300 <fd2num>
  802559:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80255c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80255f:	b8 00 00 00 00       	mov    $0x0,%eax
  802564:	eb 38                	jmp    80259e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802566:	89 74 24 04          	mov    %esi,0x4(%esp)
  80256a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802571:	e8 26 eb ff ff       	call   80109c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80257d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802584:	e8 13 eb ff ff       	call   80109c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802590:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802597:	e8 00 eb ff ff       	call   80109c <sys_page_unmap>
  80259c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80259e:	83 c4 30             	add    $0x30,%esp
  8025a1:	5b                   	pop    %ebx
  8025a2:	5e                   	pop    %esi
  8025a3:	5d                   	pop    %ebp
  8025a4:	c3                   	ret    

008025a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	89 04 24             	mov    %eax,(%esp)
  8025b8:	e8 b9 ed ff ff       	call   801376 <fd_lookup>
  8025bd:	89 c2                	mov    %eax,%edx
  8025bf:	85 d2                	test   %edx,%edx
  8025c1:	78 15                	js     8025d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	89 04 24             	mov    %eax,(%esp)
  8025c9:	e8 42 ed ff ff       	call   801310 <fd2data>
	return _pipeisclosed(fd, p);
  8025ce:	89 c2                	mov    %eax,%edx
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	e8 0b fd ff ff       	call   8022e3 <_pipeisclosed>
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    
  8025da:	66 90                	xchg   %ax,%ax
  8025dc:	66 90                	xchg   %ax,%ax
  8025de:	66 90                	xchg   %ax,%ax

008025e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	56                   	push   %esi
  8025e4:	53                   	push   %ebx
  8025e5:	83 ec 10             	sub    $0x10,%esp
  8025e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8025eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8025f1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8025f3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8025f8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8025fb:	89 04 24             	mov    %eax,(%esp)
  8025fe:	e8 28 ec ff ff       	call   80122b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802603:	85 c0                	test   %eax,%eax
  802605:	75 26                	jne    80262d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802607:	85 f6                	test   %esi,%esi
  802609:	74 0a                	je     802615 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80260b:	a1 08 44 80 00       	mov    0x804408,%eax
  802610:	8b 40 74             	mov    0x74(%eax),%eax
  802613:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802615:	85 db                	test   %ebx,%ebx
  802617:	74 0a                	je     802623 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802619:	a1 08 44 80 00       	mov    0x804408,%eax
  80261e:	8b 40 78             	mov    0x78(%eax),%eax
  802621:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802623:	a1 08 44 80 00       	mov    0x804408,%eax
  802628:	8b 40 70             	mov    0x70(%eax),%eax
  80262b:	eb 14                	jmp    802641 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80262d:	85 f6                	test   %esi,%esi
  80262f:	74 06                	je     802637 <ipc_recv+0x57>
			*from_env_store = 0;
  802631:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802637:	85 db                	test   %ebx,%ebx
  802639:	74 06                	je     802641 <ipc_recv+0x61>
			*perm_store = 0;
  80263b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802641:	83 c4 10             	add    $0x10,%esp
  802644:	5b                   	pop    %ebx
  802645:	5e                   	pop    %esi
  802646:	5d                   	pop    %ebp
  802647:	c3                   	ret    

00802648 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	57                   	push   %edi
  80264c:	56                   	push   %esi
  80264d:	53                   	push   %ebx
  80264e:	83 ec 1c             	sub    $0x1c,%esp
  802651:	8b 7d 08             	mov    0x8(%ebp),%edi
  802654:	8b 75 0c             	mov    0xc(%ebp),%esi
  802657:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80265a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80265c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802661:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802664:	8b 45 14             	mov    0x14(%ebp),%eax
  802667:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80266b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80266f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802673:	89 3c 24             	mov    %edi,(%esp)
  802676:	e8 8d eb ff ff       	call   801208 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80267b:	85 c0                	test   %eax,%eax
  80267d:	74 28                	je     8026a7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80267f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802682:	74 1c                	je     8026a0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802684:	c7 44 24 08 f0 2e 80 	movl   $0x802ef0,0x8(%esp)
  80268b:	00 
  80268c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802693:	00 
  802694:	c7 04 24 14 2f 80 00 	movl   $0x802f14,(%esp)
  80269b:	e8 87 dc ff ff       	call   800327 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8026a0:	e8 31 e9 ff ff       	call   800fd6 <sys_yield>
	}
  8026a5:	eb bd                	jmp    802664 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8026a7:	83 c4 1c             	add    $0x1c,%esp
  8026aa:	5b                   	pop    %ebx
  8026ab:	5e                   	pop    %esi
  8026ac:	5f                   	pop    %edi
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    

008026af <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
  8026b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026ba:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026bd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026c3:	8b 52 50             	mov    0x50(%edx),%edx
  8026c6:	39 ca                	cmp    %ecx,%edx
  8026c8:	75 0d                	jne    8026d7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8026ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026cd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8026d2:	8b 40 40             	mov    0x40(%eax),%eax
  8026d5:	eb 0e                	jmp    8026e5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8026d7:	83 c0 01             	add    $0x1,%eax
  8026da:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026df:	75 d9                	jne    8026ba <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8026e1:	66 b8 00 00          	mov    $0x0,%ax
}
  8026e5:	5d                   	pop    %ebp
  8026e6:	c3                   	ret    

008026e7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026e7:	55                   	push   %ebp
  8026e8:	89 e5                	mov    %esp,%ebp
  8026ea:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026ed:	89 d0                	mov    %edx,%eax
  8026ef:	c1 e8 16             	shr    $0x16,%eax
  8026f2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026f9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026fe:	f6 c1 01             	test   $0x1,%cl
  802701:	74 1d                	je     802720 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802703:	c1 ea 0c             	shr    $0xc,%edx
  802706:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80270d:	f6 c2 01             	test   $0x1,%dl
  802710:	74 0e                	je     802720 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802712:	c1 ea 0c             	shr    $0xc,%edx
  802715:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80271c:	ef 
  80271d:	0f b7 c0             	movzwl %ax,%eax
}
  802720:	5d                   	pop    %ebp
  802721:	c3                   	ret    
  802722:	66 90                	xchg   %ax,%ax
  802724:	66 90                	xchg   %ax,%ax
  802726:	66 90                	xchg   %ax,%ax
  802728:	66 90                	xchg   %ax,%ax
  80272a:	66 90                	xchg   %ax,%ax
  80272c:	66 90                	xchg   %ax,%ax
  80272e:	66 90                	xchg   %ax,%ax

00802730 <__udivdi3>:
  802730:	55                   	push   %ebp
  802731:	57                   	push   %edi
  802732:	56                   	push   %esi
  802733:	83 ec 0c             	sub    $0xc,%esp
  802736:	8b 44 24 28          	mov    0x28(%esp),%eax
  80273a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80273e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802742:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802746:	85 c0                	test   %eax,%eax
  802748:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80274c:	89 ea                	mov    %ebp,%edx
  80274e:	89 0c 24             	mov    %ecx,(%esp)
  802751:	75 2d                	jne    802780 <__udivdi3+0x50>
  802753:	39 e9                	cmp    %ebp,%ecx
  802755:	77 61                	ja     8027b8 <__udivdi3+0x88>
  802757:	85 c9                	test   %ecx,%ecx
  802759:	89 ce                	mov    %ecx,%esi
  80275b:	75 0b                	jne    802768 <__udivdi3+0x38>
  80275d:	b8 01 00 00 00       	mov    $0x1,%eax
  802762:	31 d2                	xor    %edx,%edx
  802764:	f7 f1                	div    %ecx
  802766:	89 c6                	mov    %eax,%esi
  802768:	31 d2                	xor    %edx,%edx
  80276a:	89 e8                	mov    %ebp,%eax
  80276c:	f7 f6                	div    %esi
  80276e:	89 c5                	mov    %eax,%ebp
  802770:	89 f8                	mov    %edi,%eax
  802772:	f7 f6                	div    %esi
  802774:	89 ea                	mov    %ebp,%edx
  802776:	83 c4 0c             	add    $0xc,%esp
  802779:	5e                   	pop    %esi
  80277a:	5f                   	pop    %edi
  80277b:	5d                   	pop    %ebp
  80277c:	c3                   	ret    
  80277d:	8d 76 00             	lea    0x0(%esi),%esi
  802780:	39 e8                	cmp    %ebp,%eax
  802782:	77 24                	ja     8027a8 <__udivdi3+0x78>
  802784:	0f bd e8             	bsr    %eax,%ebp
  802787:	83 f5 1f             	xor    $0x1f,%ebp
  80278a:	75 3c                	jne    8027c8 <__udivdi3+0x98>
  80278c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802790:	39 34 24             	cmp    %esi,(%esp)
  802793:	0f 86 9f 00 00 00    	jbe    802838 <__udivdi3+0x108>
  802799:	39 d0                	cmp    %edx,%eax
  80279b:	0f 82 97 00 00 00    	jb     802838 <__udivdi3+0x108>
  8027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027a8:	31 d2                	xor    %edx,%edx
  8027aa:	31 c0                	xor    %eax,%eax
  8027ac:	83 c4 0c             	add    $0xc,%esp
  8027af:	5e                   	pop    %esi
  8027b0:	5f                   	pop    %edi
  8027b1:	5d                   	pop    %ebp
  8027b2:	c3                   	ret    
  8027b3:	90                   	nop
  8027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027b8:	89 f8                	mov    %edi,%eax
  8027ba:	f7 f1                	div    %ecx
  8027bc:	31 d2                	xor    %edx,%edx
  8027be:	83 c4 0c             	add    $0xc,%esp
  8027c1:	5e                   	pop    %esi
  8027c2:	5f                   	pop    %edi
  8027c3:	5d                   	pop    %ebp
  8027c4:	c3                   	ret    
  8027c5:	8d 76 00             	lea    0x0(%esi),%esi
  8027c8:	89 e9                	mov    %ebp,%ecx
  8027ca:	8b 3c 24             	mov    (%esp),%edi
  8027cd:	d3 e0                	shl    %cl,%eax
  8027cf:	89 c6                	mov    %eax,%esi
  8027d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8027d6:	29 e8                	sub    %ebp,%eax
  8027d8:	89 c1                	mov    %eax,%ecx
  8027da:	d3 ef                	shr    %cl,%edi
  8027dc:	89 e9                	mov    %ebp,%ecx
  8027de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027e2:	8b 3c 24             	mov    (%esp),%edi
  8027e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8027e9:	89 d6                	mov    %edx,%esi
  8027eb:	d3 e7                	shl    %cl,%edi
  8027ed:	89 c1                	mov    %eax,%ecx
  8027ef:	89 3c 24             	mov    %edi,(%esp)
  8027f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8027f6:	d3 ee                	shr    %cl,%esi
  8027f8:	89 e9                	mov    %ebp,%ecx
  8027fa:	d3 e2                	shl    %cl,%edx
  8027fc:	89 c1                	mov    %eax,%ecx
  8027fe:	d3 ef                	shr    %cl,%edi
  802800:	09 d7                	or     %edx,%edi
  802802:	89 f2                	mov    %esi,%edx
  802804:	89 f8                	mov    %edi,%eax
  802806:	f7 74 24 08          	divl   0x8(%esp)
  80280a:	89 d6                	mov    %edx,%esi
  80280c:	89 c7                	mov    %eax,%edi
  80280e:	f7 24 24             	mull   (%esp)
  802811:	39 d6                	cmp    %edx,%esi
  802813:	89 14 24             	mov    %edx,(%esp)
  802816:	72 30                	jb     802848 <__udivdi3+0x118>
  802818:	8b 54 24 04          	mov    0x4(%esp),%edx
  80281c:	89 e9                	mov    %ebp,%ecx
  80281e:	d3 e2                	shl    %cl,%edx
  802820:	39 c2                	cmp    %eax,%edx
  802822:	73 05                	jae    802829 <__udivdi3+0xf9>
  802824:	3b 34 24             	cmp    (%esp),%esi
  802827:	74 1f                	je     802848 <__udivdi3+0x118>
  802829:	89 f8                	mov    %edi,%eax
  80282b:	31 d2                	xor    %edx,%edx
  80282d:	e9 7a ff ff ff       	jmp    8027ac <__udivdi3+0x7c>
  802832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802838:	31 d2                	xor    %edx,%edx
  80283a:	b8 01 00 00 00       	mov    $0x1,%eax
  80283f:	e9 68 ff ff ff       	jmp    8027ac <__udivdi3+0x7c>
  802844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802848:	8d 47 ff             	lea    -0x1(%edi),%eax
  80284b:	31 d2                	xor    %edx,%edx
  80284d:	83 c4 0c             	add    $0xc,%esp
  802850:	5e                   	pop    %esi
  802851:	5f                   	pop    %edi
  802852:	5d                   	pop    %ebp
  802853:	c3                   	ret    
  802854:	66 90                	xchg   %ax,%ax
  802856:	66 90                	xchg   %ax,%ax
  802858:	66 90                	xchg   %ax,%ax
  80285a:	66 90                	xchg   %ax,%ax
  80285c:	66 90                	xchg   %ax,%ax
  80285e:	66 90                	xchg   %ax,%ax

00802860 <__umoddi3>:
  802860:	55                   	push   %ebp
  802861:	57                   	push   %edi
  802862:	56                   	push   %esi
  802863:	83 ec 14             	sub    $0x14,%esp
  802866:	8b 44 24 28          	mov    0x28(%esp),%eax
  80286a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80286e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802872:	89 c7                	mov    %eax,%edi
  802874:	89 44 24 04          	mov    %eax,0x4(%esp)
  802878:	8b 44 24 30          	mov    0x30(%esp),%eax
  80287c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802880:	89 34 24             	mov    %esi,(%esp)
  802883:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802887:	85 c0                	test   %eax,%eax
  802889:	89 c2                	mov    %eax,%edx
  80288b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80288f:	75 17                	jne    8028a8 <__umoddi3+0x48>
  802891:	39 fe                	cmp    %edi,%esi
  802893:	76 4b                	jbe    8028e0 <__umoddi3+0x80>
  802895:	89 c8                	mov    %ecx,%eax
  802897:	89 fa                	mov    %edi,%edx
  802899:	f7 f6                	div    %esi
  80289b:	89 d0                	mov    %edx,%eax
  80289d:	31 d2                	xor    %edx,%edx
  80289f:	83 c4 14             	add    $0x14,%esp
  8028a2:	5e                   	pop    %esi
  8028a3:	5f                   	pop    %edi
  8028a4:	5d                   	pop    %ebp
  8028a5:	c3                   	ret    
  8028a6:	66 90                	xchg   %ax,%ax
  8028a8:	39 f8                	cmp    %edi,%eax
  8028aa:	77 54                	ja     802900 <__umoddi3+0xa0>
  8028ac:	0f bd e8             	bsr    %eax,%ebp
  8028af:	83 f5 1f             	xor    $0x1f,%ebp
  8028b2:	75 5c                	jne    802910 <__umoddi3+0xb0>
  8028b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8028b8:	39 3c 24             	cmp    %edi,(%esp)
  8028bb:	0f 87 e7 00 00 00    	ja     8029a8 <__umoddi3+0x148>
  8028c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8028c5:	29 f1                	sub    %esi,%ecx
  8028c7:	19 c7                	sbb    %eax,%edi
  8028c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8028d9:	83 c4 14             	add    $0x14,%esp
  8028dc:	5e                   	pop    %esi
  8028dd:	5f                   	pop    %edi
  8028de:	5d                   	pop    %ebp
  8028df:	c3                   	ret    
  8028e0:	85 f6                	test   %esi,%esi
  8028e2:	89 f5                	mov    %esi,%ebp
  8028e4:	75 0b                	jne    8028f1 <__umoddi3+0x91>
  8028e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028eb:	31 d2                	xor    %edx,%edx
  8028ed:	f7 f6                	div    %esi
  8028ef:	89 c5                	mov    %eax,%ebp
  8028f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028f5:	31 d2                	xor    %edx,%edx
  8028f7:	f7 f5                	div    %ebp
  8028f9:	89 c8                	mov    %ecx,%eax
  8028fb:	f7 f5                	div    %ebp
  8028fd:	eb 9c                	jmp    80289b <__umoddi3+0x3b>
  8028ff:	90                   	nop
  802900:	89 c8                	mov    %ecx,%eax
  802902:	89 fa                	mov    %edi,%edx
  802904:	83 c4 14             	add    $0x14,%esp
  802907:	5e                   	pop    %esi
  802908:	5f                   	pop    %edi
  802909:	5d                   	pop    %ebp
  80290a:	c3                   	ret    
  80290b:	90                   	nop
  80290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802910:	8b 04 24             	mov    (%esp),%eax
  802913:	be 20 00 00 00       	mov    $0x20,%esi
  802918:	89 e9                	mov    %ebp,%ecx
  80291a:	29 ee                	sub    %ebp,%esi
  80291c:	d3 e2                	shl    %cl,%edx
  80291e:	89 f1                	mov    %esi,%ecx
  802920:	d3 e8                	shr    %cl,%eax
  802922:	89 e9                	mov    %ebp,%ecx
  802924:	89 44 24 04          	mov    %eax,0x4(%esp)
  802928:	8b 04 24             	mov    (%esp),%eax
  80292b:	09 54 24 04          	or     %edx,0x4(%esp)
  80292f:	89 fa                	mov    %edi,%edx
  802931:	d3 e0                	shl    %cl,%eax
  802933:	89 f1                	mov    %esi,%ecx
  802935:	89 44 24 08          	mov    %eax,0x8(%esp)
  802939:	8b 44 24 10          	mov    0x10(%esp),%eax
  80293d:	d3 ea                	shr    %cl,%edx
  80293f:	89 e9                	mov    %ebp,%ecx
  802941:	d3 e7                	shl    %cl,%edi
  802943:	89 f1                	mov    %esi,%ecx
  802945:	d3 e8                	shr    %cl,%eax
  802947:	89 e9                	mov    %ebp,%ecx
  802949:	09 f8                	or     %edi,%eax
  80294b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80294f:	f7 74 24 04          	divl   0x4(%esp)
  802953:	d3 e7                	shl    %cl,%edi
  802955:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802959:	89 d7                	mov    %edx,%edi
  80295b:	f7 64 24 08          	mull   0x8(%esp)
  80295f:	39 d7                	cmp    %edx,%edi
  802961:	89 c1                	mov    %eax,%ecx
  802963:	89 14 24             	mov    %edx,(%esp)
  802966:	72 2c                	jb     802994 <__umoddi3+0x134>
  802968:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80296c:	72 22                	jb     802990 <__umoddi3+0x130>
  80296e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802972:	29 c8                	sub    %ecx,%eax
  802974:	19 d7                	sbb    %edx,%edi
  802976:	89 e9                	mov    %ebp,%ecx
  802978:	89 fa                	mov    %edi,%edx
  80297a:	d3 e8                	shr    %cl,%eax
  80297c:	89 f1                	mov    %esi,%ecx
  80297e:	d3 e2                	shl    %cl,%edx
  802980:	89 e9                	mov    %ebp,%ecx
  802982:	d3 ef                	shr    %cl,%edi
  802984:	09 d0                	or     %edx,%eax
  802986:	89 fa                	mov    %edi,%edx
  802988:	83 c4 14             	add    $0x14,%esp
  80298b:	5e                   	pop    %esi
  80298c:	5f                   	pop    %edi
  80298d:	5d                   	pop    %ebp
  80298e:	c3                   	ret    
  80298f:	90                   	nop
  802990:	39 d7                	cmp    %edx,%edi
  802992:	75 da                	jne    80296e <__umoddi3+0x10e>
  802994:	8b 14 24             	mov    (%esp),%edx
  802997:	89 c1                	mov    %eax,%ecx
  802999:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80299d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8029a1:	eb cb                	jmp    80296e <__umoddi3+0x10e>
  8029a3:	90                   	nop
  8029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8029ac:	0f 82 0f ff ff ff    	jb     8028c1 <__umoddi3+0x61>
  8029b2:	e9 1a ff ff ff       	jmp    8028d1 <__umoddi3+0x71>
