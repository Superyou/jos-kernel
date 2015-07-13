
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 fa 02 00 00       	call   80032b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
  800048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80004e:	83 3d d0 51 80 00 00 	cmpl   $0x0,0x8051d0
  800055:	74 23                	je     80007a <ls1+0x3a>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800057:	89 f0                	mov    %esi,%eax
  800059:	3c 01                	cmp    $0x1,%al
  80005b:	19 c0                	sbb    %eax,%eax
  80005d:	83 e0 c9             	and    $0xffffffc9,%eax
  800060:	83 c0 64             	add    $0x64,%eax
  800063:	89 44 24 08          	mov    %eax,0x8(%esp)
  800067:	8b 45 10             	mov    0x10(%ebp),%eax
  80006a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006e:	c7 04 24 42 2c 80 00 	movl   $0x802c42,(%esp)
  800075:	e8 7d 1d 00 00       	call   801df7 <printf>
	if(prefix) {
  80007a:	85 db                	test   %ebx,%ebx
  80007c:	74 38                	je     8000b6 <ls1+0x76>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80007e:	b8 a8 2c 80 00       	mov    $0x802ca8,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800083:	80 3b 00             	cmpb   $0x0,(%ebx)
  800086:	74 1a                	je     8000a2 <ls1+0x62>
  800088:	89 1c 24             	mov    %ebx,(%esp)
  80008b:	e8 30 0a 00 00       	call   800ac0 <strlen>
  800090:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
			sep = "/";
  800095:	b8 40 2c 80 00       	mov    $0x802c40,%eax
  80009a:	ba a8 2c 80 00       	mov    $0x802ca8,%edx
  80009f:	0f 44 c2             	cmove  %edx,%eax
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000aa:	c7 04 24 4b 2c 80 00 	movl   $0x802c4b,(%esp)
  8000b1:	e8 41 1d 00 00       	call   801df7 <printf>
	}
	printf("%s", name);
  8000b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 f2 30 80 00 	movl   $0x8030f2,(%esp)
  8000c4:	e8 2e 1d 00 00       	call   801df7 <printf>
	if(flag['F'] && isdir)
  8000c9:	83 3d 38 51 80 00 00 	cmpl   $0x0,0x805138
  8000d0:	74 12                	je     8000e4 <ls1+0xa4>
  8000d2:	89 f0                	mov    %esi,%eax
  8000d4:	84 c0                	test   %al,%al
  8000d6:	74 0c                	je     8000e4 <ls1+0xa4>
		printf("/");
  8000d8:	c7 04 24 40 2c 80 00 	movl   $0x802c40,(%esp)
  8000df:	e8 13 1d 00 00       	call   801df7 <printf>
	printf("\n");
  8000e4:	c7 04 24 a7 2c 80 00 	movl   $0x802ca7,(%esp)
  8000eb:	e8 07 1d 00 00       	call   801df7 <printf>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800103:	8b 7d 08             	mov    0x8(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80010d:	00 
  80010e:	89 3c 24             	mov    %edi,(%esp)
  800111:	e8 0e 1b 00 00       	call   801c24 <open>
  800116:	89 c3                	mov    %eax,%ebx
  800118:	85 c0                	test   %eax,%eax
  80011a:	78 08                	js     800124 <lsdir+0x2d>
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80011c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800122:	eb 57                	jmp    80017b <lsdir+0x84>
{
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
  800124:	89 44 24 10          	mov    %eax,0x10(%esp)
  800128:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80012c:	c7 44 24 08 50 2c 80 	movl   $0x802c50,0x8(%esp)
  800133:	00 
  800134:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80013b:	00 
  80013c:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800143:	e8 44 02 00 00       	call   80038c <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800148:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80014f:	74 2a                	je     80017b <lsdir+0x84>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800151:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800155:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80015b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80015f:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800166:	0f 94 c0             	sete   %al
  800169:	0f b6 c0             	movzbl %al,%eax
  80016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800170:	8b 45 0c             	mov    0xc(%ebp),%eax
  800173:	89 04 24             	mov    %eax,(%esp)
  800176:	e8 c5 fe ff ff       	call   800040 <ls1>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80017b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800182:	00 
  800183:	89 74 24 04          	mov    %esi,0x4(%esp)
  800187:	89 1c 24             	mov    %ebx,(%esp)
  80018a:	e8 dd 15 00 00       	call   80176c <readn>
  80018f:	3d 00 01 00 00       	cmp    $0x100,%eax
  800194:	74 b2                	je     800148 <lsdir+0x51>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  800196:	85 c0                	test   %eax,%eax
  800198:	7e 20                	jle    8001ba <lsdir+0xc3>
		panic("short read in directory %s", path);
  80019a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80019e:	c7 44 24 08 66 2c 80 	movl   $0x802c66,0x8(%esp)
  8001a5:	00 
  8001a6:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001ad:	00 
  8001ae:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  8001b5:	e8 d2 01 00 00       	call   80038c <_panic>
	if (n < 0)
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	79 24                	jns    8001e2 <lsdir+0xeb>
		panic("error reading directory %s: %e", path, n);
  8001be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001c6:	c7 44 24 08 ac 2c 80 	movl   $0x802cac,0x8(%esp)
  8001cd:	00 
  8001ce:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001d5:	00 
  8001d6:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  8001dd:	e8 aa 01 00 00       	call   80038c <_panic>
}
  8001e2:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  8001e8:	5b                   	pop    %ebx
  8001e9:	5e                   	pop    %esi
  8001ea:	5f                   	pop    %edi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	53                   	push   %ebx
  8001f1:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  8001f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  8001fa:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	89 1c 24             	mov    %ebx,(%esp)
  800207:	e8 64 17 00 00       	call   801970 <stat>
  80020c:	85 c0                	test   %eax,%eax
  80020e:	79 24                	jns    800234 <ls+0x47>
		panic("stat %s: %e", path, r);
  800210:	89 44 24 10          	mov    %eax,0x10(%esp)
  800214:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800218:	c7 44 24 08 81 2c 80 	movl   $0x802c81,0x8(%esp)
  80021f:	00 
  800220:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800227:	00 
  800228:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  80022f:	e8 58 01 00 00       	call   80038c <_panic>
	if (st.st_isdir && !flag['d'])
  800234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800237:	85 c0                	test   %eax,%eax
  800239:	74 1a                	je     800255 <ls+0x68>
  80023b:	83 3d b0 51 80 00 00 	cmpl   $0x0,0x8051b0
  800242:	75 11                	jne    800255 <ls+0x68>
		lsdir(path, prefix);
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	89 1c 24             	mov    %ebx,(%esp)
  80024e:	e8 a4 fe ff ff       	call   8000f7 <lsdir>
  800253:	eb 23                	jmp    800278 <ls+0x8b>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  800255:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800259:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80025c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800260:	85 c0                	test   %eax,%eax
  800262:	0f 95 c0             	setne  %al
  800265:	0f b6 c0             	movzbl %al,%eax
  800268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800273:	e8 c8 fd ff ff       	call   800040 <ls1>
}
  800278:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  80027e:	5b                   	pop    %ebx
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    

00800281 <usage>:
	printf("\n");
}

void
usage(void)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800287:	c7 04 24 8d 2c 80 00 	movl   $0x802c8d,(%esp)
  80028e:	e8 64 1b 00 00       	call   801df7 <printf>
	exit();
  800293:	e8 db 00 00 00       	call   800373 <exit>
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <umain>:

void
umain(int argc, char **argv)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 20             	sub    $0x20,%esp
  8002a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  8002a5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b0:	8d 45 08             	lea    0x8(%ebp),%eax
  8002b3:	89 04 24             	mov    %eax,(%esp)
  8002b6:	e8 b3 0f 00 00       	call   80126e <argstart>
	while ((i = argnext(&args)) >= 0)
  8002bb:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  8002be:	eb 1e                	jmp    8002de <umain+0x44>
		switch (i) {
  8002c0:	83 f8 64             	cmp    $0x64,%eax
  8002c3:	74 0a                	je     8002cf <umain+0x35>
  8002c5:	83 f8 6c             	cmp    $0x6c,%eax
  8002c8:	74 05                	je     8002cf <umain+0x35>
  8002ca:	83 f8 46             	cmp    $0x46,%eax
  8002cd:	75 0a                	jne    8002d9 <umain+0x3f>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  8002cf:	83 04 85 20 50 80 00 	addl   $0x1,0x805020(,%eax,4)
  8002d6:	01 
			break;
  8002d7:	eb 05                	jmp    8002de <umain+0x44>
		default:
			usage();
  8002d9:	e8 a3 ff ff ff       	call   800281 <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8002de:	89 1c 24             	mov    %ebx,(%esp)
  8002e1:	e8 c0 0f 00 00       	call   8012a6 <argnext>
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	79 d6                	jns    8002c0 <umain+0x26>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8002ea:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002ee:	74 07                	je     8002f7 <umain+0x5d>
  8002f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  8002f5:	eb 28                	jmp    80031f <umain+0x85>
		ls("/", "");
  8002f7:	c7 44 24 04 a8 2c 80 	movl   $0x802ca8,0x4(%esp)
  8002fe:	00 
  8002ff:	c7 04 24 40 2c 80 00 	movl   $0x802c40,(%esp)
  800306:	e8 e2 fe ff ff       	call   8001ed <ls>
  80030b:	eb 17                	jmp    800324 <umain+0x8a>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  80030d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800310:	89 44 24 04          	mov    %eax,0x4(%esp)
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	e8 d1 fe ff ff       	call   8001ed <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80031c:	83 c3 01             	add    $0x1,%ebx
  80031f:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800322:	7c e9                	jl     80030d <umain+0x73>
			ls(argv[i], argv[i]);
	}
}
  800324:	83 c4 20             	add    $0x20,%esp
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    

0080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	56                   	push   %esi
  80032f:	53                   	push   %ebx
  800330:	83 ec 10             	sub    $0x10,%esp
  800333:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800336:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800339:	e8 e9 0b 00 00       	call   800f27 <sys_getenvid>
  80033e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800343:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800346:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80034b:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800350:	85 db                	test   %ebx,%ebx
  800352:	7e 07                	jle    80035b <libmain+0x30>
		binaryname = argv[0];
  800354:	8b 06                	mov    (%esi),%eax
  800356:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80035b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80035f:	89 1c 24             	mov    %ebx,(%esp)
  800362:	e8 33 ff ff ff       	call   80029a <umain>

	// exit gracefully
	exit();
  800367:	e8 07 00 00 00       	call   800373 <exit>
}
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800379:	e8 2c 12 00 00       	call   8015aa <close_all>
	sys_env_destroy(0);
  80037e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800385:	e8 f9 0a 00 00       	call   800e83 <sys_env_destroy>
}
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
  800391:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800394:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800397:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80039d:	e8 85 0b 00 00       	call   800f27 <sys_getenvid>
  8003a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b0:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b8:	c7 04 24 d8 2c 80 00 	movl   $0x802cd8,(%esp)
  8003bf:	e8 c1 00 00 00       	call   800485 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cb:	89 04 24             	mov    %eax,(%esp)
  8003ce:	e8 51 00 00 00       	call   800424 <vcprintf>
	cprintf("\n");
  8003d3:	c7 04 24 a7 2c 80 00 	movl   $0x802ca7,(%esp)
  8003da:	e8 a6 00 00 00       	call   800485 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003df:	cc                   	int3   
  8003e0:	eb fd                	jmp    8003df <_panic+0x53>

008003e2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	53                   	push   %ebx
  8003e6:	83 ec 14             	sub    $0x14,%esp
  8003e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ec:	8b 13                	mov    (%ebx),%edx
  8003ee:	8d 42 01             	lea    0x1(%edx),%eax
  8003f1:	89 03                	mov    %eax,(%ebx)
  8003f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ff:	75 19                	jne    80041a <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800401:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800408:	00 
  800409:	8d 43 08             	lea    0x8(%ebx),%eax
  80040c:	89 04 24             	mov    %eax,(%esp)
  80040f:	e8 32 0a 00 00       	call   800e46 <sys_cputs>
		b->idx = 0;
  800414:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80041a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80041e:	83 c4 14             	add    $0x14,%esp
  800421:	5b                   	pop    %ebx
  800422:	5d                   	pop    %ebp
  800423:	c3                   	ret    

00800424 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80042d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800434:	00 00 00 
	b.cnt = 0;
  800437:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80043e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80044f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800455:	89 44 24 04          	mov    %eax,0x4(%esp)
  800459:	c7 04 24 e2 03 80 00 	movl   $0x8003e2,(%esp)
  800460:	e8 6f 01 00 00       	call   8005d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800465:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80046b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800475:	89 04 24             	mov    %eax,(%esp)
  800478:	e8 c9 09 00 00       	call   800e46 <sys_cputs>

	return b.cnt;
}
  80047d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80048e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	89 04 24             	mov    %eax,(%esp)
  800498:	e8 87 ff ff ff       	call   800424 <vcprintf>
	va_end(ap);

	return cnt;
}
  80049d:	c9                   	leave  
  80049e:	c3                   	ret    
  80049f:	90                   	nop

008004a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	57                   	push   %edi
  8004a4:	56                   	push   %esi
  8004a5:	53                   	push   %ebx
  8004a6:	83 ec 3c             	sub    $0x3c,%esp
  8004a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ac:	89 d7                	mov    %edx,%edi
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	89 c3                	mov    %eax,%ebx
  8004b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004cd:	39 d9                	cmp    %ebx,%ecx
  8004cf:	72 05                	jb     8004d6 <printnum+0x36>
  8004d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d4:	77 69                	ja     80053f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004dd:	83 ee 01             	sub    $0x1,%esi
  8004e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004f0:	89 c3                	mov    %eax,%ebx
  8004f2:	89 d6                	mov    %edx,%esi
  8004f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 9c 24 00 00       	call   8029b0 <__udivdi3>
  800514:	89 d9                	mov    %ebx,%ecx
  800516:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80051a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	89 54 24 04          	mov    %edx,0x4(%esp)
  800525:	89 fa                	mov    %edi,%edx
  800527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052a:	e8 71 ff ff ff       	call   8004a0 <printnum>
  80052f:	eb 1b                	jmp    80054c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800531:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800535:	8b 45 18             	mov    0x18(%ebp),%eax
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	ff d3                	call   *%ebx
  80053d:	eb 03                	jmp    800542 <printnum+0xa2>
  80053f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800542:	83 ee 01             	sub    $0x1,%esi
  800545:	85 f6                	test   %esi,%esi
  800547:	7f e8                	jg     800531 <printnum+0x91>
  800549:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800550:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800554:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800557:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80055e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800565:	89 04 24             	mov    %eax,(%esp)
  800568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056f:	e8 6c 25 00 00       	call   802ae0 <__umoddi3>
  800574:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800578:	0f be 80 fb 2c 80 00 	movsbl 0x802cfb(%eax),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800585:	ff d0                	call   *%eax
}
  800587:	83 c4 3c             	add    $0x3c,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5e                   	pop    %esi
  80058c:	5f                   	pop    %edi
  80058d:	5d                   	pop    %ebp
  80058e:	c3                   	ret    

0080058f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800595:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	3b 50 04             	cmp    0x4(%eax),%edx
  80059e:	73 0a                	jae    8005aa <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005a3:	89 08                	mov    %ecx,(%eax)
  8005a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a8:	88 02                	mov    %al,(%edx)
}
  8005aa:	5d                   	pop    %ebp
  8005ab:	c3                   	ret    

008005ac <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005b2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	89 04 24             	mov    %eax,(%esp)
  8005cd:	e8 02 00 00 00       	call   8005d4 <vprintfmt>
	va_end(ap);
}
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	57                   	push   %edi
  8005d8:	56                   	push   %esi
  8005d9:	53                   	push   %ebx
  8005da:	83 ec 3c             	sub    $0x3c,%esp
  8005dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005e0:	eb 17                	jmp    8005f9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8005e2:	85 c0                	test   %eax,%eax
  8005e4:	0f 84 4b 04 00 00    	je     800a35 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8005ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f1:	89 04 24             	mov    %eax,(%esp)
  8005f4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8005f7:	89 fb                	mov    %edi,%ebx
  8005f9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8005fc:	0f b6 03             	movzbl (%ebx),%eax
  8005ff:	83 f8 25             	cmp    $0x25,%eax
  800602:	75 de                	jne    8005e2 <vprintfmt+0xe>
  800604:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800608:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80060f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800614:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80061b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800620:	eb 18                	jmp    80063a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800622:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800624:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800628:	eb 10                	jmp    80063a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80062c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800630:	eb 08                	jmp    80063a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800632:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800635:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80063d:	0f b6 17             	movzbl (%edi),%edx
  800640:	0f b6 c2             	movzbl %dl,%eax
  800643:	83 ea 23             	sub    $0x23,%edx
  800646:	80 fa 55             	cmp    $0x55,%dl
  800649:	0f 87 c2 03 00 00    	ja     800a11 <vprintfmt+0x43d>
  80064f:	0f b6 d2             	movzbl %dl,%edx
  800652:	ff 24 95 40 2e 80 00 	jmp    *0x802e40(,%edx,4)
  800659:	89 df                	mov    %ebx,%edi
  80065b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800660:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800663:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800667:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80066a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80066d:	83 fa 09             	cmp    $0x9,%edx
  800670:	77 33                	ja     8006a5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800672:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800675:	eb e9                	jmp    800660 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 30                	mov    (%eax),%esi
  80067c:	8d 40 04             	lea    0x4(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800682:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800684:	eb 1f                	jmp    8006a5 <vprintfmt+0xd1>
  800686:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800689:	85 ff                	test   %edi,%edi
  80068b:	b8 00 00 00 00       	mov    $0x0,%eax
  800690:	0f 49 c7             	cmovns %edi,%eax
  800693:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800696:	89 df                	mov    %ebx,%edi
  800698:	eb a0                	jmp    80063a <vprintfmt+0x66>
  80069a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80069c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8006a3:	eb 95                	jmp    80063a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8006a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a9:	79 8f                	jns    80063a <vprintfmt+0x66>
  8006ab:	eb 85                	jmp    800632 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ad:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006b2:	eb 86                	jmp    80063a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 70 04             	lea    0x4(%eax),%esi
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 04 24             	mov    %eax,(%esp)
  8006c9:	ff 55 08             	call   *0x8(%ebp)
  8006cc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8006cf:	e9 25 ff ff ff       	jmp    8005f9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8d 70 04             	lea    0x4(%eax),%esi
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	99                   	cltd   
  8006dd:	31 d0                	xor    %edx,%eax
  8006df:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006e1:	83 f8 15             	cmp    $0x15,%eax
  8006e4:	7f 0b                	jg     8006f1 <vprintfmt+0x11d>
  8006e6:	8b 14 85 a0 2f 80 00 	mov    0x802fa0(,%eax,4),%edx
  8006ed:	85 d2                	test   %edx,%edx
  8006ef:	75 26                	jne    800717 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8006f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006f5:	c7 44 24 08 13 2d 80 	movl   $0x802d13,0x8(%esp)
  8006fc:	00 
  8006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800700:	89 44 24 04          	mov    %eax,0x4(%esp)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	89 04 24             	mov    %eax,(%esp)
  80070a:	e8 9d fe ff ff       	call   8005ac <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80070f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800712:	e9 e2 fe ff ff       	jmp    8005f9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800717:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80071b:	c7 44 24 08 f2 30 80 	movl   $0x8030f2,0x8(%esp)
  800722:	00 
  800723:	8b 45 0c             	mov    0xc(%ebp),%eax
  800726:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	89 04 24             	mov    %eax,(%esp)
  800730:	e8 77 fe ff ff       	call   8005ac <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800735:	89 75 14             	mov    %esi,0x14(%ebp)
  800738:	e9 bc fe ff ff       	jmp    8005f9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800743:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800746:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80074a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80074c:	85 ff                	test   %edi,%edi
  80074e:	b8 0c 2d 80 00       	mov    $0x802d0c,%eax
  800753:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800756:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80075a:	0f 84 94 00 00 00    	je     8007f4 <vprintfmt+0x220>
  800760:	85 c9                	test   %ecx,%ecx
  800762:	0f 8e 94 00 00 00    	jle    8007fc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800768:	89 74 24 04          	mov    %esi,0x4(%esp)
  80076c:	89 3c 24             	mov    %edi,(%esp)
  80076f:	e8 64 03 00 00       	call   800ad8 <strnlen>
  800774:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800777:	29 c1                	sub    %eax,%ecx
  800779:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80077c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800780:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800783:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800786:	8b 75 08             	mov    0x8(%ebp),%esi
  800789:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80078c:	89 cb                	mov    %ecx,%ebx
  80078e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800790:	eb 0f                	jmp    8007a1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800792:	8b 45 0c             	mov    0xc(%ebp),%eax
  800795:	89 44 24 04          	mov    %eax,0x4(%esp)
  800799:	89 3c 24             	mov    %edi,(%esp)
  80079c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80079e:	83 eb 01             	sub    $0x1,%ebx
  8007a1:	85 db                	test   %ebx,%ebx
  8007a3:	7f ed                	jg     800792 <vprintfmt+0x1be>
  8007a5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ae:	85 c9                	test   %ecx,%ecx
  8007b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b5:	0f 49 c1             	cmovns %ecx,%eax
  8007b8:	29 c1                	sub    %eax,%ecx
  8007ba:	89 cb                	mov    %ecx,%ebx
  8007bc:	eb 44                	jmp    800802 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c2:	74 1e                	je     8007e2 <vprintfmt+0x20e>
  8007c4:	0f be d2             	movsbl %dl,%edx
  8007c7:	83 ea 20             	sub    $0x20,%edx
  8007ca:	83 fa 5e             	cmp    $0x5e,%edx
  8007cd:	76 13                	jbe    8007e2 <vprintfmt+0x20e>
					putch('?', putdat);
  8007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007dd:	ff 55 08             	call   *0x8(%ebp)
  8007e0:	eb 0d                	jmp    8007ef <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8007e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007e9:	89 04 24             	mov    %eax,(%esp)
  8007ec:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ef:	83 eb 01             	sub    $0x1,%ebx
  8007f2:	eb 0e                	jmp    800802 <vprintfmt+0x22e>
  8007f4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8007fa:	eb 06                	jmp    800802 <vprintfmt+0x22e>
  8007fc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007ff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800802:	83 c7 01             	add    $0x1,%edi
  800805:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800809:	0f be c2             	movsbl %dl,%eax
  80080c:	85 c0                	test   %eax,%eax
  80080e:	74 27                	je     800837 <vprintfmt+0x263>
  800810:	85 f6                	test   %esi,%esi
  800812:	78 aa                	js     8007be <vprintfmt+0x1ea>
  800814:	83 ee 01             	sub    $0x1,%esi
  800817:	79 a5                	jns    8007be <vprintfmt+0x1ea>
  800819:	89 d8                	mov    %ebx,%eax
  80081b:	8b 75 08             	mov    0x8(%ebp),%esi
  80081e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800821:	89 c3                	mov    %eax,%ebx
  800823:	eb 18                	jmp    80083d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800825:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800829:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800830:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800832:	83 eb 01             	sub    $0x1,%ebx
  800835:	eb 06                	jmp    80083d <vprintfmt+0x269>
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80083d:	85 db                	test   %ebx,%ebx
  80083f:	7f e4                	jg     800825 <vprintfmt+0x251>
  800841:	89 75 08             	mov    %esi,0x8(%ebp)
  800844:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800847:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80084a:	e9 aa fd ff ff       	jmp    8005f9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80084f:	83 f9 01             	cmp    $0x1,%ecx
  800852:	7e 10                	jle    800864 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8b 30                	mov    (%eax),%esi
  800859:	8b 78 04             	mov    0x4(%eax),%edi
  80085c:	8d 40 08             	lea    0x8(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	eb 26                	jmp    80088a <vprintfmt+0x2b6>
	else if (lflag)
  800864:	85 c9                	test   %ecx,%ecx
  800866:	74 12                	je     80087a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 30                	mov    (%eax),%esi
  80086d:	89 f7                	mov    %esi,%edi
  80086f:	c1 ff 1f             	sar    $0x1f,%edi
  800872:	8d 40 04             	lea    0x4(%eax),%eax
  800875:	89 45 14             	mov    %eax,0x14(%ebp)
  800878:	eb 10                	jmp    80088a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8b 30                	mov    (%eax),%esi
  80087f:	89 f7                	mov    %esi,%edi
  800881:	c1 ff 1f             	sar    $0x1f,%edi
  800884:	8d 40 04             	lea    0x4(%eax),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	89 f0                	mov    %esi,%eax
  80088c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80088e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800893:	85 ff                	test   %edi,%edi
  800895:	0f 89 3a 01 00 00    	jns    8009d5 <vprintfmt+0x401>
				putch('-', putdat);
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008a9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008ac:	89 f0                	mov    %esi,%eax
  8008ae:	89 fa                	mov    %edi,%edx
  8008b0:	f7 d8                	neg    %eax
  8008b2:	83 d2 00             	adc    $0x0,%edx
  8008b5:	f7 da                	neg    %edx
			}
			base = 10;
  8008b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008bc:	e9 14 01 00 00       	jmp    8009d5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008c1:	83 f9 01             	cmp    $0x1,%ecx
  8008c4:	7e 13                	jle    8008d9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	8b 50 04             	mov    0x4(%eax),%edx
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8b 75 14             	mov    0x14(%ebp),%esi
  8008d1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8008d4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008d7:	eb 2c                	jmp    800905 <vprintfmt+0x331>
	else if (lflag)
  8008d9:	85 c9                	test   %ecx,%ecx
  8008db:	74 15                	je     8008f2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e7:	8b 75 14             	mov    0x14(%ebp),%esi
  8008ea:	8d 76 04             	lea    0x4(%esi),%esi
  8008ed:	89 75 14             	mov    %esi,0x14(%ebp)
  8008f0:	eb 13                	jmp    800905 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fc:	8b 75 14             	mov    0x14(%ebp),%esi
  8008ff:	8d 76 04             	lea    0x4(%esi),%esi
  800902:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800905:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80090a:	e9 c6 00 00 00       	jmp    8009d5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80090f:	83 f9 01             	cmp    $0x1,%ecx
  800912:	7e 13                	jle    800927 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	8b 50 04             	mov    0x4(%eax),%edx
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	8b 75 14             	mov    0x14(%ebp),%esi
  80091f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800922:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800925:	eb 24                	jmp    80094b <vprintfmt+0x377>
	else if (lflag)
  800927:	85 c9                	test   %ecx,%ecx
  800929:	74 11                	je     80093c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	99                   	cltd   
  800931:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800934:	8d 71 04             	lea    0x4(%ecx),%esi
  800937:	89 75 14             	mov    %esi,0x14(%ebp)
  80093a:	eb 0f                	jmp    80094b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	99                   	cltd   
  800942:	8b 75 14             	mov    0x14(%ebp),%esi
  800945:	8d 76 04             	lea    0x4(%esi),%esi
  800948:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80094b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800950:	e9 80 00 00 00       	jmp    8009d5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800955:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800966:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800970:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800977:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80097a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80097e:	8b 06                	mov    (%esi),%eax
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800985:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80098a:	eb 49                	jmp    8009d5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80098c:	83 f9 01             	cmp    $0x1,%ecx
  80098f:	7e 13                	jle    8009a4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8b 50 04             	mov    0x4(%eax),%edx
  800997:	8b 00                	mov    (%eax),%eax
  800999:	8b 75 14             	mov    0x14(%ebp),%esi
  80099c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80099f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8009a2:	eb 2c                	jmp    8009d0 <vprintfmt+0x3fc>
	else if (lflag)
  8009a4:	85 c9                	test   %ecx,%ecx
  8009a6:	74 15                	je     8009bd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8009a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8009b5:	8d 71 04             	lea    0x4(%ecx),%esi
  8009b8:	89 75 14             	mov    %esi,0x14(%ebp)
  8009bb:	eb 13                	jmp    8009d0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	8b 75 14             	mov    0x14(%ebp),%esi
  8009ca:	8d 76 04             	lea    0x4(%esi),%esi
  8009cd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8009d0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009d5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8009d9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8009dd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8009e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009e8:	89 04 24             	mov    %eax,(%esp)
  8009eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	e8 a6 fa ff ff       	call   8004a0 <printnum>
			break;
  8009fa:	e9 fa fb ff ff       	jmp    8005f9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a06:	89 04 24             	mov    %eax,(%esp)
  800a09:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a0c:	e9 e8 fb ff ff       	jmp    8005f9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a18:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a1f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a22:	89 fb                	mov    %edi,%ebx
  800a24:	eb 03                	jmp    800a29 <vprintfmt+0x455>
  800a26:	83 eb 01             	sub    $0x1,%ebx
  800a29:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800a2d:	75 f7                	jne    800a26 <vprintfmt+0x452>
  800a2f:	90                   	nop
  800a30:	e9 c4 fb ff ff       	jmp    8005f9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800a35:	83 c4 3c             	add    $0x3c,%esp
  800a38:	5b                   	pop    %ebx
  800a39:	5e                   	pop    %esi
  800a3a:	5f                   	pop    %edi
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	83 ec 28             	sub    $0x28,%esp
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a50:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a5a:	85 c0                	test   %eax,%eax
  800a5c:	74 30                	je     800a8e <vsnprintf+0x51>
  800a5e:	85 d2                	test   %edx,%edx
  800a60:	7e 2c                	jle    800a8e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a69:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a77:	c7 04 24 8f 05 80 00 	movl   $0x80058f,(%esp)
  800a7e:	e8 51 fb ff ff       	call   8005d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a86:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a8c:	eb 05                	jmp    800a93 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a93:	c9                   	leave  
  800a94:	c3                   	ret    

00800a95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a9b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800aa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	89 04 24             	mov    %eax,(%esp)
  800ab6:	e8 82 ff ff ff       	call   800a3d <vsnprintf>
	va_end(ap);

	return rc;
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    
  800abd:	66 90                	xchg   %ax,%ax
  800abf:	90                   	nop

00800ac0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  800acb:	eb 03                	jmp    800ad0 <strlen+0x10>
		n++;
  800acd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ad4:	75 f7                	jne    800acd <strlen+0xd>
		n++;
	return n;
}
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ade:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae6:	eb 03                	jmp    800aeb <strnlen+0x13>
		n++;
  800ae8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aeb:	39 d0                	cmp    %edx,%eax
  800aed:	74 06                	je     800af5 <strnlen+0x1d>
  800aef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800af3:	75 f3                	jne    800ae8 <strnlen+0x10>
		n++;
	return n;
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	53                   	push   %ebx
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b01:	89 c2                	mov    %eax,%edx
  800b03:	83 c2 01             	add    $0x1,%edx
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b0d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b10:	84 db                	test   %bl,%bl
  800b12:	75 ef                	jne    800b03 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b14:	5b                   	pop    %ebx
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b21:	89 1c 24             	mov    %ebx,(%esp)
  800b24:	e8 97 ff ff ff       	call   800ac0 <strlen>
	strcpy(dst + len, src);
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b30:	01 d8                	add    %ebx,%eax
  800b32:	89 04 24             	mov    %eax,(%esp)
  800b35:	e8 bd ff ff ff       	call   800af7 <strcpy>
	return dst;
}
  800b3a:	89 d8                	mov    %ebx,%eax
  800b3c:	83 c4 08             	add    $0x8,%esp
  800b3f:	5b                   	pop    %ebx
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	56                   	push   %esi
  800b46:	53                   	push   %ebx
  800b47:	8b 75 08             	mov    0x8(%ebp),%esi
  800b4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4d:	89 f3                	mov    %esi,%ebx
  800b4f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b52:	89 f2                	mov    %esi,%edx
  800b54:	eb 0f                	jmp    800b65 <strncpy+0x23>
		*dst++ = *src;
  800b56:	83 c2 01             	add    $0x1,%edx
  800b59:	0f b6 01             	movzbl (%ecx),%eax
  800b5c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b5f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b62:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b65:	39 da                	cmp    %ebx,%edx
  800b67:	75 ed                	jne    800b56 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b69:	89 f0                	mov    %esi,%eax
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	8b 75 08             	mov    0x8(%ebp),%esi
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b83:	85 c9                	test   %ecx,%ecx
  800b85:	75 0b                	jne    800b92 <strlcpy+0x23>
  800b87:	eb 1d                	jmp    800ba6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b92:	39 d8                	cmp    %ebx,%eax
  800b94:	74 0b                	je     800ba1 <strlcpy+0x32>
  800b96:	0f b6 0a             	movzbl (%edx),%ecx
  800b99:	84 c9                	test   %cl,%cl
  800b9b:	75 ec                	jne    800b89 <strlcpy+0x1a>
  800b9d:	89 c2                	mov    %eax,%edx
  800b9f:	eb 02                	jmp    800ba3 <strlcpy+0x34>
  800ba1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800ba3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800ba6:	29 f0                	sub    %esi,%eax
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bb5:	eb 06                	jmp    800bbd <strcmp+0x11>
		p++, q++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bbd:	0f b6 01             	movzbl (%ecx),%eax
  800bc0:	84 c0                	test   %al,%al
  800bc2:	74 04                	je     800bc8 <strcmp+0x1c>
  800bc4:	3a 02                	cmp    (%edx),%al
  800bc6:	74 ef                	je     800bb7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc8:	0f b6 c0             	movzbl %al,%eax
  800bcb:	0f b6 12             	movzbl (%edx),%edx
  800bce:	29 d0                	sub    %edx,%eax
}
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	53                   	push   %ebx
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdc:	89 c3                	mov    %eax,%ebx
  800bde:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800be1:	eb 06                	jmp    800be9 <strncmp+0x17>
		n--, p++, q++;
  800be3:	83 c0 01             	add    $0x1,%eax
  800be6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800be9:	39 d8                	cmp    %ebx,%eax
  800beb:	74 15                	je     800c02 <strncmp+0x30>
  800bed:	0f b6 08             	movzbl (%eax),%ecx
  800bf0:	84 c9                	test   %cl,%cl
  800bf2:	74 04                	je     800bf8 <strncmp+0x26>
  800bf4:	3a 0a                	cmp    (%edx),%cl
  800bf6:	74 eb                	je     800be3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf8:	0f b6 00             	movzbl (%eax),%eax
  800bfb:	0f b6 12             	movzbl (%edx),%edx
  800bfe:	29 d0                	sub    %edx,%eax
  800c00:	eb 05                	jmp    800c07 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c14:	eb 07                	jmp    800c1d <strchr+0x13>
		if (*s == c)
  800c16:	38 ca                	cmp    %cl,%dl
  800c18:	74 0f                	je     800c29 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	0f b6 10             	movzbl (%eax),%edx
  800c20:	84 d2                	test   %dl,%dl
  800c22:	75 f2                	jne    800c16 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800c24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c35:	eb 07                	jmp    800c3e <strfind+0x13>
		if (*s == c)
  800c37:	38 ca                	cmp    %cl,%dl
  800c39:	74 0a                	je     800c45 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c3b:	83 c0 01             	add    $0x1,%eax
  800c3e:	0f b6 10             	movzbl (%eax),%edx
  800c41:	84 d2                	test   %dl,%dl
  800c43:	75 f2                	jne    800c37 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c53:	85 c9                	test   %ecx,%ecx
  800c55:	74 36                	je     800c8d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c57:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c5d:	75 28                	jne    800c87 <memset+0x40>
  800c5f:	f6 c1 03             	test   $0x3,%cl
  800c62:	75 23                	jne    800c87 <memset+0x40>
		c &= 0xFF;
  800c64:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c68:	89 d3                	mov    %edx,%ebx
  800c6a:	c1 e3 08             	shl    $0x8,%ebx
  800c6d:	89 d6                	mov    %edx,%esi
  800c6f:	c1 e6 18             	shl    $0x18,%esi
  800c72:	89 d0                	mov    %edx,%eax
  800c74:	c1 e0 10             	shl    $0x10,%eax
  800c77:	09 f0                	or     %esi,%eax
  800c79:	09 c2                	or     %eax,%edx
  800c7b:	89 d0                	mov    %edx,%eax
  800c7d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c7f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c82:	fc                   	cld    
  800c83:	f3 ab                	rep stos %eax,%es:(%edi)
  800c85:	eb 06                	jmp    800c8d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8a:	fc                   	cld    
  800c8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c8d:	89 f8                	mov    %edi,%eax
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca2:	39 c6                	cmp    %eax,%esi
  800ca4:	73 35                	jae    800cdb <memmove+0x47>
  800ca6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ca9:	39 d0                	cmp    %edx,%eax
  800cab:	73 2e                	jae    800cdb <memmove+0x47>
		s += n;
		d += n;
  800cad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800cb0:	89 d6                	mov    %edx,%esi
  800cb2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cba:	75 13                	jne    800ccf <memmove+0x3b>
  800cbc:	f6 c1 03             	test   $0x3,%cl
  800cbf:	75 0e                	jne    800ccf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cc1:	83 ef 04             	sub    $0x4,%edi
  800cc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800cca:	fd                   	std    
  800ccb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ccd:	eb 09                	jmp    800cd8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ccf:	83 ef 01             	sub    $0x1,%edi
  800cd2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800cd5:	fd                   	std    
  800cd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cd8:	fc                   	cld    
  800cd9:	eb 1d                	jmp    800cf8 <memmove+0x64>
  800cdb:	89 f2                	mov    %esi,%edx
  800cdd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cdf:	f6 c2 03             	test   $0x3,%dl
  800ce2:	75 0f                	jne    800cf3 <memmove+0x5f>
  800ce4:	f6 c1 03             	test   $0x3,%cl
  800ce7:	75 0a                	jne    800cf3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ce9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cec:	89 c7                	mov    %eax,%edi
  800cee:	fc                   	cld    
  800cef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf1:	eb 05                	jmp    800cf8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cf3:	89 c7                	mov    %eax,%edi
  800cf5:	fc                   	cld    
  800cf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	89 04 24             	mov    %eax,(%esp)
  800d16:	e8 79 ff ff ff       	call   800c94 <memmove>
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	89 d6                	mov    %edx,%esi
  800d2a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d2d:	eb 1a                	jmp    800d49 <memcmp+0x2c>
		if (*s1 != *s2)
  800d2f:	0f b6 02             	movzbl (%edx),%eax
  800d32:	0f b6 19             	movzbl (%ecx),%ebx
  800d35:	38 d8                	cmp    %bl,%al
  800d37:	74 0a                	je     800d43 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800d39:	0f b6 c0             	movzbl %al,%eax
  800d3c:	0f b6 db             	movzbl %bl,%ebx
  800d3f:	29 d8                	sub    %ebx,%eax
  800d41:	eb 0f                	jmp    800d52 <memcmp+0x35>
		s1++, s2++;
  800d43:	83 c2 01             	add    $0x1,%edx
  800d46:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d49:	39 f2                	cmp    %esi,%edx
  800d4b:	75 e2                	jne    800d2f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d5f:	89 c2                	mov    %eax,%edx
  800d61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d64:	eb 07                	jmp    800d6d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d66:	38 08                	cmp    %cl,(%eax)
  800d68:	74 07                	je     800d71 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d6a:	83 c0 01             	add    $0x1,%eax
  800d6d:	39 d0                	cmp    %edx,%eax
  800d6f:	72 f5                	jb     800d66 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7f:	eb 03                	jmp    800d84 <strtol+0x11>
		s++;
  800d81:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d84:	0f b6 0a             	movzbl (%edx),%ecx
  800d87:	80 f9 09             	cmp    $0x9,%cl
  800d8a:	74 f5                	je     800d81 <strtol+0xe>
  800d8c:	80 f9 20             	cmp    $0x20,%cl
  800d8f:	74 f0                	je     800d81 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d91:	80 f9 2b             	cmp    $0x2b,%cl
  800d94:	75 0a                	jne    800da0 <strtol+0x2d>
		s++;
  800d96:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d99:	bf 00 00 00 00       	mov    $0x0,%edi
  800d9e:	eb 11                	jmp    800db1 <strtol+0x3e>
  800da0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800da5:	80 f9 2d             	cmp    $0x2d,%cl
  800da8:	75 07                	jne    800db1 <strtol+0x3e>
		s++, neg = 1;
  800daa:	8d 52 01             	lea    0x1(%edx),%edx
  800dad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800db6:	75 15                	jne    800dcd <strtol+0x5a>
  800db8:	80 3a 30             	cmpb   $0x30,(%edx)
  800dbb:	75 10                	jne    800dcd <strtol+0x5a>
  800dbd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800dc1:	75 0a                	jne    800dcd <strtol+0x5a>
		s += 2, base = 16;
  800dc3:	83 c2 02             	add    $0x2,%edx
  800dc6:	b8 10 00 00 00       	mov    $0x10,%eax
  800dcb:	eb 10                	jmp    800ddd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	75 0c                	jne    800ddd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dd1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dd3:	80 3a 30             	cmpb   $0x30,(%edx)
  800dd6:	75 05                	jne    800ddd <strtol+0x6a>
		s++, base = 8;
  800dd8:	83 c2 01             	add    $0x1,%edx
  800ddb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ddd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800de5:	0f b6 0a             	movzbl (%edx),%ecx
  800de8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800deb:	89 f0                	mov    %esi,%eax
  800ded:	3c 09                	cmp    $0x9,%al
  800def:	77 08                	ja     800df9 <strtol+0x86>
			dig = *s - '0';
  800df1:	0f be c9             	movsbl %cl,%ecx
  800df4:	83 e9 30             	sub    $0x30,%ecx
  800df7:	eb 20                	jmp    800e19 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800df9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dfc:	89 f0                	mov    %esi,%eax
  800dfe:	3c 19                	cmp    $0x19,%al
  800e00:	77 08                	ja     800e0a <strtol+0x97>
			dig = *s - 'a' + 10;
  800e02:	0f be c9             	movsbl %cl,%ecx
  800e05:	83 e9 57             	sub    $0x57,%ecx
  800e08:	eb 0f                	jmp    800e19 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800e0a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e0d:	89 f0                	mov    %esi,%eax
  800e0f:	3c 19                	cmp    $0x19,%al
  800e11:	77 16                	ja     800e29 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800e13:	0f be c9             	movsbl %cl,%ecx
  800e16:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e19:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800e1c:	7d 0f                	jge    800e2d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800e1e:	83 c2 01             	add    $0x1,%edx
  800e21:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800e25:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800e27:	eb bc                	jmp    800de5 <strtol+0x72>
  800e29:	89 d8                	mov    %ebx,%eax
  800e2b:	eb 02                	jmp    800e2f <strtol+0xbc>
  800e2d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800e2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e33:	74 05                	je     800e3a <strtol+0xc7>
		*endptr = (char *) s;
  800e35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e38:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e3a:	f7 d8                	neg    %eax
  800e3c:	85 ff                	test   %edi,%edi
  800e3e:	0f 44 c3             	cmove  %ebx,%eax
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	89 c3                	mov    %eax,%ebx
  800e59:	89 c7                	mov    %eax,%edi
  800e5b:	89 c6                	mov    %eax,%esi
  800e5d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e74:	89 d1                	mov    %edx,%ecx
  800e76:	89 d3                	mov    %edx,%ebx
  800e78:	89 d7                	mov    %edx,%edi
  800e7a:	89 d6                	mov    %edx,%esi
  800e7c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e91:	b8 03 00 00 00       	mov    $0x3,%eax
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	89 cb                	mov    %ecx,%ebx
  800e9b:	89 cf                	mov    %ecx,%edi
  800e9d:	89 ce                	mov    %ecx,%esi
  800e9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	7e 28                	jle    800ecd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  800eb8:	00 
  800eb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec0:	00 
  800ec1:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  800ec8:	e8 bf f4 ff ff       	call   80038c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ecd:	83 c4 2c             	add    $0x2c,%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
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
  800ede:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee3:	b8 04 00 00 00       	mov    $0x4,%eax
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	89 cb                	mov    %ecx,%ebx
  800eed:	89 cf                	mov    %ecx,%edi
  800eef:	89 ce                	mov    %ecx,%esi
  800ef1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7e 28                	jle    800f1f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f02:	00 
  800f03:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  800f0a:	00 
  800f0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f12:	00 
  800f13:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  800f1a:	e8 6d f4 ff ff       	call   80038c <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800f1f:	83 c4 2c             	add    $0x2c,%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5f                   	pop    %edi
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	57                   	push   %edi
  800f2b:	56                   	push   %esi
  800f2c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f32:	b8 02 00 00 00       	mov    $0x2,%eax
  800f37:	89 d1                	mov    %edx,%ecx
  800f39:	89 d3                	mov    %edx,%ebx
  800f3b:	89 d7                	mov    %edx,%edi
  800f3d:	89 d6                	mov    %edx,%esi
  800f3f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_yield>:

void
sys_yield(void)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f51:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f56:	89 d1                	mov    %edx,%ecx
  800f58:	89 d3                	mov    %edx,%ebx
  800f5a:	89 d7                	mov    %edx,%edi
  800f5c:	89 d6                	mov    %edx,%esi
  800f5e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800f6e:	be 00 00 00 00       	mov    $0x0,%esi
  800f73:	b8 05 00 00 00       	mov    $0x5,%eax
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f81:	89 f7                	mov    %esi,%edi
  800f83:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	7e 28                	jle    800fb1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f89:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f94:	00 
  800f95:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  800f9c:	00 
  800f9d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa4:	00 
  800fa5:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  800fac:	e8 db f3 ff ff       	call   80038c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fb1:	83 c4 2c             	add    $0x2c,%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    

00800fb9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc2:	b8 06 00 00 00       	mov    $0x6,%eax
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd3:	8b 75 18             	mov    0x18(%ebp),%esi
  800fd6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	7e 28                	jle    801004 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fe7:	00 
  800fe8:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  800fef:	00 
  800ff0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff7:	00 
  800ff8:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  800fff:	e8 88 f3 ff ff       	call   80038c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801004:	83 c4 2c             	add    $0x2c,%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5f                   	pop    %edi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
  801012:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801015:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101a:	b8 07 00 00 00       	mov    $0x7,%eax
  80101f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801022:	8b 55 08             	mov    0x8(%ebp),%edx
  801025:	89 df                	mov    %ebx,%edi
  801027:	89 de                	mov    %ebx,%esi
  801029:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	7e 28                	jle    801057 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80102f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801033:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80103a:	00 
  80103b:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  801042:	00 
  801043:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104a:	00 
  80104b:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  801052:	e8 35 f3 ff ff       	call   80038c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801057:	83 c4 2c             	add    $0x2c,%esp
  80105a:	5b                   	pop    %ebx
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801065:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106a:	b8 10 00 00 00       	mov    $0x10,%eax
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	89 cb                	mov    %ecx,%ebx
  801074:	89 cf                	mov    %ecx,%edi
  801076:	89 ce                	mov    %ecx,%esi
  801078:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
  801085:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801088:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108d:	b8 09 00 00 00       	mov    $0x9,%eax
  801092:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	89 df                	mov    %ebx,%edi
  80109a:	89 de                	mov    %ebx,%esi
  80109c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	7e 28                	jle    8010ca <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010ad:	00 
  8010ae:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  8010b5:	00 
  8010b6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010bd:	00 
  8010be:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  8010c5:	e8 c2 f2 ff ff       	call   80038c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010ca:	83 c4 2c             	add    $0x2c,%esp
  8010cd:	5b                   	pop    %ebx
  8010ce:	5e                   	pop    %esi
  8010cf:	5f                   	pop    %edi
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	89 df                	mov    %ebx,%edi
  8010ed:	89 de                	mov    %ebx,%esi
  8010ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	7e 28                	jle    80111d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801100:	00 
  801101:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  801108:	00 
  801109:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801110:	00 
  801111:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  801118:	e8 6f f2 ff ff       	call   80038c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80111d:	83 c4 2c             	add    $0x2c,%esp
  801120:	5b                   	pop    %ebx
  801121:	5e                   	pop    %esi
  801122:	5f                   	pop    %edi
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	b8 0b 00 00 00       	mov    $0xb,%eax
  801138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	89 df                	mov    %ebx,%edi
  801140:	89 de                	mov    %ebx,%esi
  801142:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801144:	85 c0                	test   %eax,%eax
  801146:	7e 28                	jle    801170 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801148:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801153:	00 
  801154:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  80115b:	00 
  80115c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801163:	00 
  801164:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  80116b:	e8 1c f2 ff ff       	call   80038c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801170:	83 c4 2c             	add    $0x2c,%esp
  801173:	5b                   	pop    %ebx
  801174:	5e                   	pop    %esi
  801175:	5f                   	pop    %edi
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    

00801178 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	57                   	push   %edi
  80117c:	56                   	push   %esi
  80117d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117e:	be 00 00 00 00       	mov    $0x0,%esi
  801183:	b8 0d 00 00 00       	mov    $0xd,%eax
  801188:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118b:	8b 55 08             	mov    0x8(%ebp),%edx
  80118e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801191:	8b 7d 14             	mov    0x14(%ebp),%edi
  801194:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801196:	5b                   	pop    %ebx
  801197:	5e                   	pop    %esi
  801198:	5f                   	pop    %edi
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	57                   	push   %edi
  80119f:	56                   	push   %esi
  8011a0:	53                   	push   %ebx
  8011a1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	89 cb                	mov    %ecx,%ebx
  8011b3:	89 cf                	mov    %ecx,%edi
  8011b5:	89 ce                	mov    %ecx,%esi
  8011b7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	7e 28                	jle    8011e5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8011c8:	00 
  8011c9:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  8011d0:	00 
  8011d1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d8:	00 
  8011d9:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  8011e0:	e8 a7 f1 ff ff       	call   80038c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011e5:	83 c4 2c             	add    $0x2c,%esp
  8011e8:	5b                   	pop    %ebx
  8011e9:	5e                   	pop    %esi
  8011ea:	5f                   	pop    %edi
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	57                   	push   %edi
  8011f1:	56                   	push   %esi
  8011f2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011fd:	89 d1                	mov    %edx,%ecx
  8011ff:	89 d3                	mov    %edx,%ebx
  801201:	89 d7                	mov    %edx,%edi
  801203:	89 d6                	mov    %edx,%esi
  801205:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	57                   	push   %edi
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801212:	bb 00 00 00 00       	mov    $0x0,%ebx
  801217:	b8 11 00 00 00       	mov    $0x11,%eax
  80121c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	89 df                	mov    %ebx,%edi
  801224:	89 de                	mov    %ebx,%esi
  801226:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801228:	5b                   	pop    %ebx
  801229:	5e                   	pop    %esi
  80122a:	5f                   	pop    %edi
  80122b:	5d                   	pop    %ebp
  80122c:	c3                   	ret    

0080122d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801233:	bb 00 00 00 00       	mov    $0x0,%ebx
  801238:	b8 12 00 00 00       	mov    $0x12,%eax
  80123d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801240:	8b 55 08             	mov    0x8(%ebp),%edx
  801243:	89 df                	mov    %ebx,%edi
  801245:	89 de                	mov    %ebx,%esi
  801247:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801249:	5b                   	pop    %ebx
  80124a:	5e                   	pop    %esi
  80124b:	5f                   	pop    %edi
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801254:	b9 00 00 00 00       	mov    $0x0,%ecx
  801259:	b8 13 00 00 00       	mov    $0x13,%eax
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 cb                	mov    %ecx,%ebx
  801263:	89 cf                	mov    %ecx,%edi
  801265:	89 ce                	mov    %ecx,%esi
  801267:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801269:	5b                   	pop    %ebx
  80126a:	5e                   	pop    %esi
  80126b:	5f                   	pop    %edi
  80126c:	5d                   	pop    %ebp
  80126d:	c3                   	ret    

0080126e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	53                   	push   %ebx
  801272:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801275:	8b 55 0c             	mov    0xc(%ebp),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80127b:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  80127d:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801280:	bb 00 00 00 00       	mov    $0x0,%ebx
  801285:	83 39 01             	cmpl   $0x1,(%ecx)
  801288:	7e 0f                	jle    801299 <argstart+0x2b>
  80128a:	85 d2                	test   %edx,%edx
  80128c:	ba 00 00 00 00       	mov    $0x0,%edx
  801291:	bb a8 2c 80 00       	mov    $0x802ca8,%ebx
  801296:	0f 44 da             	cmove  %edx,%ebx
  801299:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  80129c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8012a3:	5b                   	pop    %ebx
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    

008012a6 <argnext>:

int
argnext(struct Argstate *args)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	53                   	push   %ebx
  8012aa:	83 ec 14             	sub    $0x14,%esp
  8012ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8012b0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8012b7:	8b 43 08             	mov    0x8(%ebx),%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 71                	je     80132f <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  8012be:	80 38 00             	cmpb   $0x0,(%eax)
  8012c1:	75 50                	jne    801313 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8012c3:	8b 0b                	mov    (%ebx),%ecx
  8012c5:	83 39 01             	cmpl   $0x1,(%ecx)
  8012c8:	74 57                	je     801321 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  8012ca:	8b 53 04             	mov    0x4(%ebx),%edx
  8012cd:	8b 42 04             	mov    0x4(%edx),%eax
  8012d0:	80 38 2d             	cmpb   $0x2d,(%eax)
  8012d3:	75 4c                	jne    801321 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  8012d5:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8012d9:	74 46                	je     801321 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8012db:	83 c0 01             	add    $0x1,%eax
  8012de:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8012e1:	8b 01                	mov    (%ecx),%eax
  8012e3:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8012ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012ee:	8d 42 08             	lea    0x8(%edx),%eax
  8012f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f5:	83 c2 04             	add    $0x4,%edx
  8012f8:	89 14 24             	mov    %edx,(%esp)
  8012fb:	e8 94 f9 ff ff       	call   800c94 <memmove>
		(*args->argc)--;
  801300:	8b 03                	mov    (%ebx),%eax
  801302:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801305:	8b 43 08             	mov    0x8(%ebx),%eax
  801308:	80 38 2d             	cmpb   $0x2d,(%eax)
  80130b:	75 06                	jne    801313 <argnext+0x6d>
  80130d:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801311:	74 0e                	je     801321 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801313:	8b 53 08             	mov    0x8(%ebx),%edx
  801316:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801319:	83 c2 01             	add    $0x1,%edx
  80131c:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  80131f:	eb 13                	jmp    801334 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801321:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80132d:	eb 05                	jmp    801334 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  80132f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801334:	83 c4 14             	add    $0x14,%esp
  801337:	5b                   	pop    %ebx
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    

0080133a <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	53                   	push   %ebx
  80133e:	83 ec 14             	sub    $0x14,%esp
  801341:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801344:	8b 43 08             	mov    0x8(%ebx),%eax
  801347:	85 c0                	test   %eax,%eax
  801349:	74 5a                	je     8013a5 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  80134b:	80 38 00             	cmpb   $0x0,(%eax)
  80134e:	74 0c                	je     80135c <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801350:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801353:	c7 43 08 a8 2c 80 00 	movl   $0x802ca8,0x8(%ebx)
  80135a:	eb 44                	jmp    8013a0 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  80135c:	8b 03                	mov    (%ebx),%eax
  80135e:	83 38 01             	cmpl   $0x1,(%eax)
  801361:	7e 2f                	jle    801392 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801363:	8b 53 04             	mov    0x4(%ebx),%edx
  801366:	8b 4a 04             	mov    0x4(%edx),%ecx
  801369:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80136c:	8b 00                	mov    (%eax),%eax
  80136e:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801375:	89 44 24 08          	mov    %eax,0x8(%esp)
  801379:	8d 42 08             	lea    0x8(%edx),%eax
  80137c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801380:	83 c2 04             	add    $0x4,%edx
  801383:	89 14 24             	mov    %edx,(%esp)
  801386:	e8 09 f9 ff ff       	call   800c94 <memmove>
		(*args->argc)--;
  80138b:	8b 03                	mov    (%ebx),%eax
  80138d:	83 28 01             	subl   $0x1,(%eax)
  801390:	eb 0e                	jmp    8013a0 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801392:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801399:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8013a0:	8b 43 0c             	mov    0xc(%ebx),%eax
  8013a3:	eb 05                	jmp    8013aa <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  8013aa:	83 c4 14             	add    $0x14,%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    

008013b0 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 18             	sub    $0x18,%esp
  8013b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8013b9:	8b 51 0c             	mov    0xc(%ecx),%edx
  8013bc:	89 d0                	mov    %edx,%eax
  8013be:	85 d2                	test   %edx,%edx
  8013c0:	75 08                	jne    8013ca <argvalue+0x1a>
  8013c2:	89 0c 24             	mov    %ecx,(%esp)
  8013c5:	e8 70 ff ff ff       	call   80133a <argnextvalue>
}
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    
  8013cc:	66 90                	xchg   %ax,%ax
  8013ce:	66 90                	xchg   %ax,%ax

008013d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013db:	c1 e8 0c             	shr    $0xc,%eax
}
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013f5:	5d                   	pop    %ebp
  8013f6:	c3                   	ret    

008013f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801402:	89 c2                	mov    %eax,%edx
  801404:	c1 ea 16             	shr    $0x16,%edx
  801407:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80140e:	f6 c2 01             	test   $0x1,%dl
  801411:	74 11                	je     801424 <fd_alloc+0x2d>
  801413:	89 c2                	mov    %eax,%edx
  801415:	c1 ea 0c             	shr    $0xc,%edx
  801418:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80141f:	f6 c2 01             	test   $0x1,%dl
  801422:	75 09                	jne    80142d <fd_alloc+0x36>
			*fd_store = fd;
  801424:	89 01                	mov    %eax,(%ecx)
			return 0;
  801426:	b8 00 00 00 00       	mov    $0x0,%eax
  80142b:	eb 17                	jmp    801444 <fd_alloc+0x4d>
  80142d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801432:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801437:	75 c9                	jne    801402 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801439:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80143f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801444:	5d                   	pop    %ebp
  801445:	c3                   	ret    

00801446 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80144c:	83 f8 1f             	cmp    $0x1f,%eax
  80144f:	77 36                	ja     801487 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801451:	c1 e0 0c             	shl    $0xc,%eax
  801454:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801459:	89 c2                	mov    %eax,%edx
  80145b:	c1 ea 16             	shr    $0x16,%edx
  80145e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801465:	f6 c2 01             	test   $0x1,%dl
  801468:	74 24                	je     80148e <fd_lookup+0x48>
  80146a:	89 c2                	mov    %eax,%edx
  80146c:	c1 ea 0c             	shr    $0xc,%edx
  80146f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801476:	f6 c2 01             	test   $0x1,%dl
  801479:	74 1a                	je     801495 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80147b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147e:	89 02                	mov    %eax,(%edx)
	return 0;
  801480:	b8 00 00 00 00       	mov    $0x0,%eax
  801485:	eb 13                	jmp    80149a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801487:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148c:	eb 0c                	jmp    80149a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80148e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801493:	eb 05                	jmp    80149a <fd_lookup+0x54>
  801495:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80149a:	5d                   	pop    %ebp
  80149b:	c3                   	ret    

0080149c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 18             	sub    $0x18,%esp
  8014a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014aa:	eb 13                	jmp    8014bf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8014ac:	39 08                	cmp    %ecx,(%eax)
  8014ae:	75 0c                	jne    8014bc <dev_lookup+0x20>
			*dev = devtab[i];
  8014b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ba:	eb 38                	jmp    8014f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014bc:	83 c2 01             	add    $0x1,%edx
  8014bf:	8b 04 95 c0 30 80 00 	mov    0x8030c0(,%edx,4),%eax
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	75 e2                	jne    8014ac <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ca:	a1 20 54 80 00       	mov    0x805420,%eax
  8014cf:	8b 40 48             	mov    0x48(%eax),%eax
  8014d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014da:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  8014e1:	e8 9f ef ff ff       	call   800485 <cprintf>
	*dev = 0;
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	56                   	push   %esi
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 20             	sub    $0x20,%esp
  8014fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801501:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801504:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801507:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80150b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801511:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801514:	89 04 24             	mov    %eax,(%esp)
  801517:	e8 2a ff ff ff       	call   801446 <fd_lookup>
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 05                	js     801525 <fd_close+0x2f>
	    || fd != fd2)
  801520:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801523:	74 0c                	je     801531 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801525:	84 db                	test   %bl,%bl
  801527:	ba 00 00 00 00       	mov    $0x0,%edx
  80152c:	0f 44 c2             	cmove  %edx,%eax
  80152f:	eb 3f                	jmp    801570 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801531:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801534:	89 44 24 04          	mov    %eax,0x4(%esp)
  801538:	8b 06                	mov    (%esi),%eax
  80153a:	89 04 24             	mov    %eax,(%esp)
  80153d:	e8 5a ff ff ff       	call   80149c <dev_lookup>
  801542:	89 c3                	mov    %eax,%ebx
  801544:	85 c0                	test   %eax,%eax
  801546:	78 16                	js     80155e <fd_close+0x68>
		if (dev->dev_close)
  801548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80154e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801553:	85 c0                	test   %eax,%eax
  801555:	74 07                	je     80155e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801557:	89 34 24             	mov    %esi,(%esp)
  80155a:	ff d0                	call   *%eax
  80155c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80155e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801562:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801569:	e8 9e fa ff ff       	call   80100c <sys_page_unmap>
	return r;
  80156e:	89 d8                	mov    %ebx,%eax
}
  801570:	83 c4 20             	add    $0x20,%esp
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801580:	89 44 24 04          	mov    %eax,0x4(%esp)
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	89 04 24             	mov    %eax,(%esp)
  80158a:	e8 b7 fe ff ff       	call   801446 <fd_lookup>
  80158f:	89 c2                	mov    %eax,%edx
  801591:	85 d2                	test   %edx,%edx
  801593:	78 13                	js     8015a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801595:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80159c:	00 
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	89 04 24             	mov    %eax,(%esp)
  8015a3:	e8 4e ff ff ff       	call   8014f6 <fd_close>
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <close_all>:

void
close_all(void)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015b6:	89 1c 24             	mov    %ebx,(%esp)
  8015b9:	e8 b9 ff ff ff       	call   801577 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015be:	83 c3 01             	add    $0x1,%ebx
  8015c1:	83 fb 20             	cmp    $0x20,%ebx
  8015c4:	75 f0                	jne    8015b6 <close_all+0xc>
		close(i);
}
  8015c6:	83 c4 14             	add    $0x14,%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5d                   	pop    %ebp
  8015cb:	c3                   	ret    

008015cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	57                   	push   %edi
  8015d0:	56                   	push   %esi
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	89 04 24             	mov    %eax,(%esp)
  8015e2:	e8 5f fe ff ff       	call   801446 <fd_lookup>
  8015e7:	89 c2                	mov    %eax,%edx
  8015e9:	85 d2                	test   %edx,%edx
  8015eb:	0f 88 e1 00 00 00    	js     8016d2 <dup+0x106>
		return r;
	close(newfdnum);
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	89 04 24             	mov    %eax,(%esp)
  8015f7:	e8 7b ff ff ff       	call   801577 <close>

	newfd = INDEX2FD(newfdnum);
  8015fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015ff:	c1 e3 0c             	shl    $0xc,%ebx
  801602:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80160b:	89 04 24             	mov    %eax,(%esp)
  80160e:	e8 cd fd ff ff       	call   8013e0 <fd2data>
  801613:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801615:	89 1c 24             	mov    %ebx,(%esp)
  801618:	e8 c3 fd ff ff       	call   8013e0 <fd2data>
  80161d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80161f:	89 f0                	mov    %esi,%eax
  801621:	c1 e8 16             	shr    $0x16,%eax
  801624:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80162b:	a8 01                	test   $0x1,%al
  80162d:	74 43                	je     801672 <dup+0xa6>
  80162f:	89 f0                	mov    %esi,%eax
  801631:	c1 e8 0c             	shr    $0xc,%eax
  801634:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80163b:	f6 c2 01             	test   $0x1,%dl
  80163e:	74 32                	je     801672 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801640:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801647:	25 07 0e 00 00       	and    $0xe07,%eax
  80164c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801650:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801654:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80165b:	00 
  80165c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801667:	e8 4d f9 ff ff       	call   800fb9 <sys_page_map>
  80166c:	89 c6                	mov    %eax,%esi
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 3e                	js     8016b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801675:	89 c2                	mov    %eax,%edx
  801677:	c1 ea 0c             	shr    $0xc,%edx
  80167a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801681:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801687:	89 54 24 10          	mov    %edx,0x10(%esp)
  80168b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80168f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801696:	00 
  801697:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a2:	e8 12 f9 ff ff       	call   800fb9 <sys_page_map>
  8016a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016ac:	85 f6                	test   %esi,%esi
  8016ae:	79 22                	jns    8016d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bb:	e8 4c f9 ff ff       	call   80100c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016cb:	e8 3c f9 ff ff       	call   80100c <sys_page_unmap>
	return r;
  8016d0:	89 f0                	mov    %esi,%eax
}
  8016d2:	83 c4 3c             	add    $0x3c,%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    

008016da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 24             	sub    $0x24,%esp
  8016e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016eb:	89 1c 24             	mov    %ebx,(%esp)
  8016ee:	e8 53 fd ff ff       	call   801446 <fd_lookup>
  8016f3:	89 c2                	mov    %eax,%edx
  8016f5:	85 d2                	test   %edx,%edx
  8016f7:	78 6d                	js     801766 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	8b 00                	mov    (%eax),%eax
  801705:	89 04 24             	mov    %eax,(%esp)
  801708:	e8 8f fd ff ff       	call   80149c <dev_lookup>
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 55                	js     801766 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801714:	8b 50 08             	mov    0x8(%eax),%edx
  801717:	83 e2 03             	and    $0x3,%edx
  80171a:	83 fa 01             	cmp    $0x1,%edx
  80171d:	75 23                	jne    801742 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80171f:	a1 20 54 80 00       	mov    0x805420,%eax
  801724:	8b 40 48             	mov    0x48(%eax),%eax
  801727:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80172b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172f:	c7 04 24 85 30 80 00 	movl   $0x803085,(%esp)
  801736:	e8 4a ed ff ff       	call   800485 <cprintf>
		return -E_INVAL;
  80173b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801740:	eb 24                	jmp    801766 <read+0x8c>
	}
	if (!dev->dev_read)
  801742:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801745:	8b 52 08             	mov    0x8(%edx),%edx
  801748:	85 d2                	test   %edx,%edx
  80174a:	74 15                	je     801761 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80174c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801753:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801756:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80175a:	89 04 24             	mov    %eax,(%esp)
  80175d:	ff d2                	call   *%edx
  80175f:	eb 05                	jmp    801766 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801761:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801766:	83 c4 24             	add    $0x24,%esp
  801769:	5b                   	pop    %ebx
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	57                   	push   %edi
  801770:	56                   	push   %esi
  801771:	53                   	push   %ebx
  801772:	83 ec 1c             	sub    $0x1c,%esp
  801775:	8b 7d 08             	mov    0x8(%ebp),%edi
  801778:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80177b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801780:	eb 23                	jmp    8017a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801782:	89 f0                	mov    %esi,%eax
  801784:	29 d8                	sub    %ebx,%eax
  801786:	89 44 24 08          	mov    %eax,0x8(%esp)
  80178a:	89 d8                	mov    %ebx,%eax
  80178c:	03 45 0c             	add    0xc(%ebp),%eax
  80178f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801793:	89 3c 24             	mov    %edi,(%esp)
  801796:	e8 3f ff ff ff       	call   8016da <read>
		if (m < 0)
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 10                	js     8017af <readn+0x43>
			return m;
		if (m == 0)
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	74 0a                	je     8017ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017a3:	01 c3                	add    %eax,%ebx
  8017a5:	39 f3                	cmp    %esi,%ebx
  8017a7:	72 d9                	jb     801782 <readn+0x16>
  8017a9:	89 d8                	mov    %ebx,%eax
  8017ab:	eb 02                	jmp    8017af <readn+0x43>
  8017ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017af:	83 c4 1c             	add    $0x1c,%esp
  8017b2:	5b                   	pop    %ebx
  8017b3:	5e                   	pop    %esi
  8017b4:	5f                   	pop    %edi
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 24             	sub    $0x24,%esp
  8017be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c8:	89 1c 24             	mov    %ebx,(%esp)
  8017cb:	e8 76 fc ff ff       	call   801446 <fd_lookup>
  8017d0:	89 c2                	mov    %eax,%edx
  8017d2:	85 d2                	test   %edx,%edx
  8017d4:	78 68                	js     80183e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e0:	8b 00                	mov    (%eax),%eax
  8017e2:	89 04 24             	mov    %eax,(%esp)
  8017e5:	e8 b2 fc ff ff       	call   80149c <dev_lookup>
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 50                	js     80183e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017f5:	75 23                	jne    80181a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017f7:	a1 20 54 80 00       	mov    0x805420,%eax
  8017fc:	8b 40 48             	mov    0x48(%eax),%eax
  8017ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801803:	89 44 24 04          	mov    %eax,0x4(%esp)
  801807:	c7 04 24 a1 30 80 00 	movl   $0x8030a1,(%esp)
  80180e:	e8 72 ec ff ff       	call   800485 <cprintf>
		return -E_INVAL;
  801813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801818:	eb 24                	jmp    80183e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80181a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181d:	8b 52 0c             	mov    0xc(%edx),%edx
  801820:	85 d2                	test   %edx,%edx
  801822:	74 15                	je     801839 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801824:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801827:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80182b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80182e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801832:	89 04 24             	mov    %eax,(%esp)
  801835:	ff d2                	call   *%edx
  801837:	eb 05                	jmp    80183e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801839:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80183e:	83 c4 24             	add    $0x24,%esp
  801841:	5b                   	pop    %ebx
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    

00801844 <seek>:

int
seek(int fdnum, off_t offset)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80184a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80184d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	89 04 24             	mov    %eax,(%esp)
  801857:	e8 ea fb ff ff       	call   801446 <fd_lookup>
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 0e                	js     80186e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	53                   	push   %ebx
  801874:	83 ec 24             	sub    $0x24,%esp
  801877:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801881:	89 1c 24             	mov    %ebx,(%esp)
  801884:	e8 bd fb ff ff       	call   801446 <fd_lookup>
  801889:	89 c2                	mov    %eax,%edx
  80188b:	85 d2                	test   %edx,%edx
  80188d:	78 61                	js     8018f0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801892:	89 44 24 04          	mov    %eax,0x4(%esp)
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801899:	8b 00                	mov    (%eax),%eax
  80189b:	89 04 24             	mov    %eax,(%esp)
  80189e:	e8 f9 fb ff ff       	call   80149c <dev_lookup>
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 49                	js     8018f0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018ae:	75 23                	jne    8018d3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018b0:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b5:	8b 40 48             	mov    0x48(%eax),%eax
  8018b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c0:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  8018c7:	e8 b9 eb ff ff       	call   800485 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d1:	eb 1d                	jmp    8018f0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d6:	8b 52 18             	mov    0x18(%edx),%edx
  8018d9:	85 d2                	test   %edx,%edx
  8018db:	74 0e                	je     8018eb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018e4:	89 04 24             	mov    %eax,(%esp)
  8018e7:	ff d2                	call   *%edx
  8018e9:	eb 05                	jmp    8018f0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018f0:	83 c4 24             	add    $0x24,%esp
  8018f3:	5b                   	pop    %ebx
  8018f4:	5d                   	pop    %ebp
  8018f5:	c3                   	ret    

008018f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	53                   	push   %ebx
  8018fa:	83 ec 24             	sub    $0x24,%esp
  8018fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801900:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801903:	89 44 24 04          	mov    %eax,0x4(%esp)
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	89 04 24             	mov    %eax,(%esp)
  80190d:	e8 34 fb ff ff       	call   801446 <fd_lookup>
  801912:	89 c2                	mov    %eax,%edx
  801914:	85 d2                	test   %edx,%edx
  801916:	78 52                	js     80196a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801918:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801922:	8b 00                	mov    (%eax),%eax
  801924:	89 04 24             	mov    %eax,(%esp)
  801927:	e8 70 fb ff ff       	call   80149c <dev_lookup>
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 3a                	js     80196a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801933:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801937:	74 2c                	je     801965 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801939:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80193c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801943:	00 00 00 
	stat->st_isdir = 0;
  801946:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80194d:	00 00 00 
	stat->st_dev = dev;
  801950:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801956:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80195a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80195d:	89 14 24             	mov    %edx,(%esp)
  801960:	ff 50 14             	call   *0x14(%eax)
  801963:	eb 05                	jmp    80196a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801965:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80196a:	83 c4 24             	add    $0x24,%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    

00801970 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
  801975:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801978:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80197f:	00 
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	89 04 24             	mov    %eax,(%esp)
  801986:	e8 99 02 00 00       	call   801c24 <open>
  80198b:	89 c3                	mov    %eax,%ebx
  80198d:	85 db                	test   %ebx,%ebx
  80198f:	78 1b                	js     8019ac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	89 1c 24             	mov    %ebx,(%esp)
  80199b:	e8 56 ff ff ff       	call   8018f6 <fstat>
  8019a0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019a2:	89 1c 24             	mov    %ebx,(%esp)
  8019a5:	e8 cd fb ff ff       	call   801577 <close>
	return r;
  8019aa:	89 f0                	mov    %esi,%eax
}
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5d                   	pop    %ebp
  8019b2:	c3                   	ret    

008019b3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 10             	sub    $0x10,%esp
  8019bb:	89 c6                	mov    %eax,%esi
  8019bd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019bf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8019c6:	75 11                	jne    8019d9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019cf:	e8 5b 0f 00 00       	call   80292f <ipc_find_env>
  8019d4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019d9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019e0:	00 
  8019e1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8019e8:	00 
  8019e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019ed:	a1 00 50 80 00       	mov    0x805000,%eax
  8019f2:	89 04 24             	mov    %eax,(%esp)
  8019f5:	e8 ce 0e 00 00       	call   8028c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a01:	00 
  801a02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a0d:	e8 4e 0e 00 00       	call   802860 <ipc_recv>
}
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    

00801a19 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	8b 40 0c             	mov    0xc(%eax),%eax
  801a25:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
  801a37:	b8 02 00 00 00       	mov    $0x2,%eax
  801a3c:	e8 72 ff ff ff       	call   8019b3 <fsipc>
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a54:	ba 00 00 00 00       	mov    $0x0,%edx
  801a59:	b8 06 00 00 00       	mov    $0x6,%eax
  801a5e:	e8 50 ff ff ff       	call   8019b3 <fsipc>
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	53                   	push   %ebx
  801a69:	83 ec 14             	sub    $0x14,%esp
  801a6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8b 40 0c             	mov    0xc(%eax),%eax
  801a75:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a84:	e8 2a ff ff ff       	call   8019b3 <fsipc>
  801a89:	89 c2                	mov    %eax,%edx
  801a8b:	85 d2                	test   %edx,%edx
  801a8d:	78 2b                	js     801aba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a8f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a96:	00 
  801a97:	89 1c 24             	mov    %ebx,(%esp)
  801a9a:	e8 58 f0 ff ff       	call   800af7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a9f:	a1 80 60 80 00       	mov    0x806080,%eax
  801aa4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aaa:	a1 84 60 80 00       	mov    0x806084,%eax
  801aaf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aba:	83 c4 14             	add    $0x14,%esp
  801abd:	5b                   	pop    %ebx
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    

00801ac0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 14             	sub    $0x14,%esp
  801ac7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801aca:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801ad0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ad5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ad8:	8b 55 08             	mov    0x8(%ebp),%edx
  801adb:	8b 52 0c             	mov    0xc(%edx),%edx
  801ade:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801ae4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801ae9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af4:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801afb:	e8 94 f1 ff ff       	call   800c94 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801b00:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801b07:	00 
  801b08:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  801b0f:	e8 71 e9 ff ff       	call   800485 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b14:	ba 00 00 00 00       	mov    $0x0,%edx
  801b19:	b8 04 00 00 00       	mov    $0x4,%eax
  801b1e:	e8 90 fe ff ff       	call   8019b3 <fsipc>
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 53                	js     801b7a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801b27:	39 c3                	cmp    %eax,%ebx
  801b29:	73 24                	jae    801b4f <devfile_write+0x8f>
  801b2b:	c7 44 24 0c d9 30 80 	movl   $0x8030d9,0xc(%esp)
  801b32:	00 
  801b33:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  801b3a:	00 
  801b3b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801b42:	00 
  801b43:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  801b4a:	e8 3d e8 ff ff       	call   80038c <_panic>
	assert(r <= PGSIZE);
  801b4f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b54:	7e 24                	jle    801b7a <devfile_write+0xba>
  801b56:	c7 44 24 0c 00 31 80 	movl   $0x803100,0xc(%esp)
  801b5d:	00 
  801b5e:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  801b65:	00 
  801b66:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801b6d:	00 
  801b6e:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  801b75:	e8 12 e8 ff ff       	call   80038c <_panic>
	return r;
}
  801b7a:	83 c4 14             	add    $0x14,%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    

00801b80 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	83 ec 10             	sub    $0x10,%esp
  801b88:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b91:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b96:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba1:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba6:	e8 08 fe ff ff       	call   8019b3 <fsipc>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	85 c0                	test   %eax,%eax
  801baf:	78 6a                	js     801c1b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801bb1:	39 c6                	cmp    %eax,%esi
  801bb3:	73 24                	jae    801bd9 <devfile_read+0x59>
  801bb5:	c7 44 24 0c d9 30 80 	movl   $0x8030d9,0xc(%esp)
  801bbc:	00 
  801bbd:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  801bc4:	00 
  801bc5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801bcc:	00 
  801bcd:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  801bd4:	e8 b3 e7 ff ff       	call   80038c <_panic>
	assert(r <= PGSIZE);
  801bd9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bde:	7e 24                	jle    801c04 <devfile_read+0x84>
  801be0:	c7 44 24 0c 00 31 80 	movl   $0x803100,0xc(%esp)
  801be7:	00 
  801be8:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  801bef:	00 
  801bf0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801bf7:	00 
  801bf8:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  801bff:	e8 88 e7 ff ff       	call   80038c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c04:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c08:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c0f:	00 
  801c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c13:	89 04 24             	mov    %eax,(%esp)
  801c16:	e8 79 f0 ff ff       	call   800c94 <memmove>
	return r;
}
  801c1b:	89 d8                	mov    %ebx,%eax
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    

00801c24 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	53                   	push   %ebx
  801c28:	83 ec 24             	sub    $0x24,%esp
  801c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c2e:	89 1c 24             	mov    %ebx,(%esp)
  801c31:	e8 8a ee ff ff       	call   800ac0 <strlen>
  801c36:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c3b:	7f 60                	jg     801c9d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c40:	89 04 24             	mov    %eax,(%esp)
  801c43:	e8 af f7 ff ff       	call   8013f7 <fd_alloc>
  801c48:	89 c2                	mov    %eax,%edx
  801c4a:	85 d2                	test   %edx,%edx
  801c4c:	78 54                	js     801ca2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c52:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c59:	e8 99 ee ff ff       	call   800af7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c61:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c69:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6e:	e8 40 fd ff ff       	call   8019b3 <fsipc>
  801c73:	89 c3                	mov    %eax,%ebx
  801c75:	85 c0                	test   %eax,%eax
  801c77:	79 17                	jns    801c90 <open+0x6c>
		fd_close(fd, 0);
  801c79:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c80:	00 
  801c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c84:	89 04 24             	mov    %eax,(%esp)
  801c87:	e8 6a f8 ff ff       	call   8014f6 <fd_close>
		return r;
  801c8c:	89 d8                	mov    %ebx,%eax
  801c8e:	eb 12                	jmp    801ca2 <open+0x7e>
	}

	return fd2num(fd);
  801c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c93:	89 04 24             	mov    %eax,(%esp)
  801c96:	e8 35 f7 ff ff       	call   8013d0 <fd2num>
  801c9b:	eb 05                	jmp    801ca2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c9d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ca2:	83 c4 24             	add    $0x24,%esp
  801ca5:	5b                   	pop    %ebx
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    

00801ca8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cae:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb3:	b8 08 00 00 00       	mov    $0x8,%eax
  801cb8:	e8 f6 fc ff ff       	call   8019b3 <fsipc>
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <evict>:

int evict(void)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801cc5:	c7 04 24 0c 31 80 00 	movl   $0x80310c,(%esp)
  801ccc:	e8 b4 e7 ff ff       	call   800485 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd6:	b8 09 00 00 00       	mov    $0x9,%eax
  801cdb:	e8 d3 fc ff ff       	call   8019b3 <fsipc>
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	53                   	push   %ebx
  801ce6:	83 ec 14             	sub    $0x14,%esp
  801ce9:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801ceb:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801cef:	7e 31                	jle    801d22 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801cf1:	8b 40 04             	mov    0x4(%eax),%eax
  801cf4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf8:	8d 43 10             	lea    0x10(%ebx),%eax
  801cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cff:	8b 03                	mov    (%ebx),%eax
  801d01:	89 04 24             	mov    %eax,(%esp)
  801d04:	e8 ae fa ff ff       	call   8017b7 <write>
		if (result > 0)
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	7e 03                	jle    801d10 <writebuf+0x2e>
			b->result += result;
  801d0d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801d10:	39 43 04             	cmp    %eax,0x4(%ebx)
  801d13:	74 0d                	je     801d22 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801d15:	85 c0                	test   %eax,%eax
  801d17:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1c:	0f 4f c2             	cmovg  %edx,%eax
  801d1f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801d22:	83 c4 14             	add    $0x14,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5d                   	pop    %ebp
  801d27:	c3                   	ret    

00801d28 <putch>:

static void
putch(int ch, void *thunk)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801d32:	8b 53 04             	mov    0x4(%ebx),%edx
  801d35:	8d 42 01             	lea    0x1(%edx),%eax
  801d38:	89 43 04             	mov    %eax,0x4(%ebx)
  801d3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d3e:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801d42:	3d 00 01 00 00       	cmp    $0x100,%eax
  801d47:	75 0e                	jne    801d57 <putch+0x2f>
		writebuf(b);
  801d49:	89 d8                	mov    %ebx,%eax
  801d4b:	e8 92 ff ff ff       	call   801ce2 <writebuf>
		b->idx = 0;
  801d50:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801d57:	83 c4 04             	add    $0x4,%esp
  801d5a:	5b                   	pop    %ebx
  801d5b:	5d                   	pop    %ebp
  801d5c:	c3                   	ret    

00801d5d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801d6f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801d76:	00 00 00 
	b.result = 0;
  801d79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d80:	00 00 00 
	b.error = 1;
  801d83:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801d8a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d90:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d97:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d9b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801da1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da5:	c7 04 24 28 1d 80 00 	movl   $0x801d28,(%esp)
  801dac:	e8 23 e8 ff ff       	call   8005d4 <vprintfmt>
	if (b.idx > 0)
  801db1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801db8:	7e 0b                	jle    801dc5 <vfprintf+0x68>
		writebuf(&b);
  801dba:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801dc0:	e8 1d ff ff ff       	call   801ce2 <writebuf>

	return (b.result ? b.result : b.error);
  801dc5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ddc:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ddf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	89 04 24             	mov    %eax,(%esp)
  801df0:	e8 68 ff ff ff       	call   801d5d <vfprintf>
	va_end(ap);

	return cnt;
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <printf>:

int
printf(const char *fmt, ...)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801dfd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801e00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e12:	e8 46 ff ff ff       	call   801d5d <vfprintf>
	va_end(ap);

	return cnt;
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    
  801e19:	66 90                	xchg   %ax,%ax
  801e1b:	66 90                	xchg   %ax,%ax
  801e1d:	66 90                	xchg   %ax,%ax
  801e1f:	90                   	nop

00801e20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e26:	c7 44 24 04 25 31 80 	movl   $0x803125,0x4(%esp)
  801e2d:	00 
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	89 04 24             	mov    %eax,(%esp)
  801e34:	e8 be ec ff ff       	call   800af7 <strcpy>
	return 0;
}
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	53                   	push   %ebx
  801e44:	83 ec 14             	sub    $0x14,%esp
  801e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e4a:	89 1c 24             	mov    %ebx,(%esp)
  801e4d:	e8 15 0b 00 00       	call   802967 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e57:	83 f8 01             	cmp    $0x1,%eax
  801e5a:	75 0d                	jne    801e69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e5f:	89 04 24             	mov    %eax,(%esp)
  801e62:	e8 29 03 00 00       	call   802190 <nsipc_close>
  801e67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e69:	89 d0                	mov    %edx,%eax
  801e6b:	83 c4 14             	add    $0x14,%esp
  801e6e:	5b                   	pop    %ebx
  801e6f:	5d                   	pop    %ebp
  801e70:	c3                   	ret    

00801e71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e7e:	00 
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8b 40 0c             	mov    0xc(%eax),%eax
  801e93:	89 04 24             	mov    %eax,(%esp)
  801e96:	e8 f0 03 00 00       	call   80228b <nsipc_send>
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ea3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eaa:	00 
  801eab:	8b 45 10             	mov    0x10(%ebp),%eax
  801eae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebf:	89 04 24             	mov    %eax,(%esp)
  801ec2:	e8 44 03 00 00       	call   80220b <nsipc_recv>
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ecf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ed2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ed6:	89 04 24             	mov    %eax,(%esp)
  801ed9:	e8 68 f5 ff ff       	call   801446 <fd_lookup>
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 17                	js     801ef9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801eeb:	39 08                	cmp    %ecx,(%eax)
  801eed:	75 05                	jne    801ef4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801eef:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef2:	eb 05                	jmp    801ef9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ef4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	56                   	push   %esi
  801eff:	53                   	push   %ebx
  801f00:	83 ec 20             	sub    $0x20,%esp
  801f03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f08:	89 04 24             	mov    %eax,(%esp)
  801f0b:	e8 e7 f4 ff ff       	call   8013f7 <fd_alloc>
  801f10:	89 c3                	mov    %eax,%ebx
  801f12:	85 c0                	test   %eax,%eax
  801f14:	78 21                	js     801f37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f1d:	00 
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f2c:	e8 34 f0 ff ff       	call   800f65 <sys_page_alloc>
  801f31:	89 c3                	mov    %eax,%ebx
  801f33:	85 c0                	test   %eax,%eax
  801f35:	79 0c                	jns    801f43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f37:	89 34 24             	mov    %esi,(%esp)
  801f3a:	e8 51 02 00 00       	call   802190 <nsipc_close>
		return r;
  801f3f:	89 d8                	mov    %ebx,%eax
  801f41:	eb 20                	jmp    801f63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f43:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f5b:	89 14 24             	mov    %edx,(%esp)
  801f5e:	e8 6d f4 ff ff       	call   8013d0 <fd2num>
}
  801f63:	83 c4 20             	add    $0x20,%esp
  801f66:	5b                   	pop    %ebx
  801f67:	5e                   	pop    %esi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    

00801f6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	e8 51 ff ff ff       	call   801ec9 <fd2sockid>
		return r;
  801f78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 23                	js     801fa1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f7e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f81:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f8c:	89 04 24             	mov    %eax,(%esp)
  801f8f:	e8 45 01 00 00       	call   8020d9 <nsipc_accept>
		return r;
  801f94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f96:	85 c0                	test   %eax,%eax
  801f98:	78 07                	js     801fa1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f9a:	e8 5c ff ff ff       	call   801efb <alloc_sockfd>
  801f9f:	89 c1                	mov    %eax,%ecx
}
  801fa1:	89 c8                	mov    %ecx,%eax
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	e8 16 ff ff ff       	call   801ec9 <fd2sockid>
  801fb3:	89 c2                	mov    %eax,%edx
  801fb5:	85 d2                	test   %edx,%edx
  801fb7:	78 16                	js     801fcf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc7:	89 14 24             	mov    %edx,(%esp)
  801fca:	e8 60 01 00 00       	call   80212f <nsipc_bind>
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <shutdown>:

int
shutdown(int s, int how)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	e8 ea fe ff ff       	call   801ec9 <fd2sockid>
  801fdf:	89 c2                	mov    %eax,%edx
  801fe1:	85 d2                	test   %edx,%edx
  801fe3:	78 0f                	js     801ff4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fec:	89 14 24             	mov    %edx,(%esp)
  801fef:	e8 7a 01 00 00       	call   80216e <nsipc_shutdown>
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	e8 c5 fe ff ff       	call   801ec9 <fd2sockid>
  802004:	89 c2                	mov    %eax,%edx
  802006:	85 d2                	test   %edx,%edx
  802008:	78 16                	js     802020 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80200a:	8b 45 10             	mov    0x10(%ebp),%eax
  80200d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802011:	8b 45 0c             	mov    0xc(%ebp),%eax
  802014:	89 44 24 04          	mov    %eax,0x4(%esp)
  802018:	89 14 24             	mov    %edx,(%esp)
  80201b:	e8 8a 01 00 00       	call   8021aa <nsipc_connect>
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <listen>:

int
listen(int s, int backlog)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	e8 99 fe ff ff       	call   801ec9 <fd2sockid>
  802030:	89 c2                	mov    %eax,%edx
  802032:	85 d2                	test   %edx,%edx
  802034:	78 0f                	js     802045 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802036:	8b 45 0c             	mov    0xc(%ebp),%eax
  802039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203d:	89 14 24             	mov    %edx,(%esp)
  802040:	e8 a4 01 00 00       	call   8021e9 <nsipc_listen>
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80204d:	8b 45 10             	mov    0x10(%ebp),%eax
  802050:	89 44 24 08          	mov    %eax,0x8(%esp)
  802054:	8b 45 0c             	mov    0xc(%ebp),%eax
  802057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	89 04 24             	mov    %eax,(%esp)
  802061:	e8 98 02 00 00       	call   8022fe <nsipc_socket>
  802066:	89 c2                	mov    %eax,%edx
  802068:	85 d2                	test   %edx,%edx
  80206a:	78 05                	js     802071 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80206c:	e8 8a fe ff ff       	call   801efb <alloc_sockfd>
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	53                   	push   %ebx
  802077:	83 ec 14             	sub    $0x14,%esp
  80207a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80207c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802083:	75 11                	jne    802096 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802085:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80208c:	e8 9e 08 00 00       	call   80292f <ipc_find_env>
  802091:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802096:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80209d:	00 
  80209e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8020a5:	00 
  8020a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020aa:	a1 04 50 80 00       	mov    0x805004,%eax
  8020af:	89 04 24             	mov    %eax,(%esp)
  8020b2:	e8 11 08 00 00       	call   8028c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020be:	00 
  8020bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020c6:	00 
  8020c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ce:	e8 8d 07 00 00       	call   802860 <ipc_recv>
}
  8020d3:	83 c4 14             	add    $0x14,%esp
  8020d6:	5b                   	pop    %ebx
  8020d7:	5d                   	pop    %ebp
  8020d8:	c3                   	ret    

008020d9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	56                   	push   %esi
  8020dd:	53                   	push   %ebx
  8020de:	83 ec 10             	sub    $0x10,%esp
  8020e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020ec:	8b 06                	mov    (%esi),%eax
  8020ee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f8:	e8 76 ff ff ff       	call   802073 <nsipc>
  8020fd:	89 c3                	mov    %eax,%ebx
  8020ff:	85 c0                	test   %eax,%eax
  802101:	78 23                	js     802126 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802103:	a1 10 70 80 00       	mov    0x807010,%eax
  802108:	89 44 24 08          	mov    %eax,0x8(%esp)
  80210c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802113:	00 
  802114:	8b 45 0c             	mov    0xc(%ebp),%eax
  802117:	89 04 24             	mov    %eax,(%esp)
  80211a:	e8 75 eb ff ff       	call   800c94 <memmove>
		*addrlen = ret->ret_addrlen;
  80211f:	a1 10 70 80 00       	mov    0x807010,%eax
  802124:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802126:	89 d8                	mov    %ebx,%eax
  802128:	83 c4 10             	add    $0x10,%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5e                   	pop    %esi
  80212d:	5d                   	pop    %ebp
  80212e:	c3                   	ret    

0080212f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	53                   	push   %ebx
  802133:	83 ec 14             	sub    $0x14,%esp
  802136:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802141:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802145:	8b 45 0c             	mov    0xc(%ebp),%eax
  802148:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802153:	e8 3c eb ff ff       	call   800c94 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802158:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80215e:	b8 02 00 00 00       	mov    $0x2,%eax
  802163:	e8 0b ff ff ff       	call   802073 <nsipc>
}
  802168:	83 c4 14             	add    $0x14,%esp
  80216b:	5b                   	pop    %ebx
  80216c:	5d                   	pop    %ebp
  80216d:	c3                   	ret    

0080216e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80217c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802184:	b8 03 00 00 00       	mov    $0x3,%eax
  802189:	e8 e5 fe ff ff       	call   802073 <nsipc>
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <nsipc_close>:

int
nsipc_close(int s)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80219e:	b8 04 00 00 00       	mov    $0x4,%eax
  8021a3:	e8 cb fe ff ff       	call   802073 <nsipc>
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	53                   	push   %ebx
  8021ae:	83 ec 14             	sub    $0x14,%esp
  8021b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021ce:	e8 c1 ea ff ff       	call   800c94 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021d3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021de:	e8 90 fe ff ff       	call   802073 <nsipc>
}
  8021e3:	83 c4 14             	add    $0x14,%esp
  8021e6:	5b                   	pop    %ebx
  8021e7:	5d                   	pop    %ebp
  8021e8:	c3                   	ret    

008021e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802204:	e8 6a fe ff ff       	call   802073 <nsipc>
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	83 ec 10             	sub    $0x10,%esp
  802213:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80221e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802224:	8b 45 14             	mov    0x14(%ebp),%eax
  802227:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80222c:	b8 07 00 00 00       	mov    $0x7,%eax
  802231:	e8 3d fe ff ff       	call   802073 <nsipc>
  802236:	89 c3                	mov    %eax,%ebx
  802238:	85 c0                	test   %eax,%eax
  80223a:	78 46                	js     802282 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80223c:	39 f0                	cmp    %esi,%eax
  80223e:	7f 07                	jg     802247 <nsipc_recv+0x3c>
  802240:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802245:	7e 24                	jle    80226b <nsipc_recv+0x60>
  802247:	c7 44 24 0c 31 31 80 	movl   $0x803131,0xc(%esp)
  80224e:	00 
  80224f:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  802256:	00 
  802257:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80225e:	00 
  80225f:	c7 04 24 46 31 80 00 	movl   $0x803146,(%esp)
  802266:	e8 21 e1 ff ff       	call   80038c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80226b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80226f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802276:	00 
  802277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227a:	89 04 24             	mov    %eax,(%esp)
  80227d:	e8 12 ea ff ff       	call   800c94 <memmove>
	}

	return r;
}
  802282:	89 d8                	mov    %ebx,%eax
  802284:	83 c4 10             	add    $0x10,%esp
  802287:	5b                   	pop    %ebx
  802288:	5e                   	pop    %esi
  802289:	5d                   	pop    %ebp
  80228a:	c3                   	ret    

0080228b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	53                   	push   %ebx
  80228f:	83 ec 14             	sub    $0x14,%esp
  802292:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80229d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022a3:	7e 24                	jle    8022c9 <nsipc_send+0x3e>
  8022a5:	c7 44 24 0c 52 31 80 	movl   $0x803152,0xc(%esp)
  8022ac:	00 
  8022ad:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  8022b4:	00 
  8022b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8022bc:	00 
  8022bd:	c7 04 24 46 31 80 00 	movl   $0x803146,(%esp)
  8022c4:	e8 c3 e0 ff ff       	call   80038c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022db:	e8 b4 e9 ff ff       	call   800c94 <memmove>
	nsipcbuf.send.req_size = size;
  8022e0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8022f3:	e8 7b fd ff ff       	call   802073 <nsipc>
}
  8022f8:	83 c4 14             	add    $0x14,%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80230c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802314:	8b 45 10             	mov    0x10(%ebp),%eax
  802317:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80231c:	b8 09 00 00 00       	mov    $0x9,%eax
  802321:	e8 4d fd ff ff       	call   802073 <nsipc>
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	56                   	push   %esi
  80232c:	53                   	push   %ebx
  80232d:	83 ec 10             	sub    $0x10,%esp
  802330:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	89 04 24             	mov    %eax,(%esp)
  802339:	e8 a2 f0 ff ff       	call   8013e0 <fd2data>
  80233e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802340:	c7 44 24 04 5e 31 80 	movl   $0x80315e,0x4(%esp)
  802347:	00 
  802348:	89 1c 24             	mov    %ebx,(%esp)
  80234b:	e8 a7 e7 ff ff       	call   800af7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802350:	8b 46 04             	mov    0x4(%esi),%eax
  802353:	2b 06                	sub    (%esi),%eax
  802355:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80235b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802362:	00 00 00 
	stat->st_dev = &devpipe;
  802365:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80236c:	40 80 00 
	return 0;
}
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	5b                   	pop    %ebx
  802378:	5e                   	pop    %esi
  802379:	5d                   	pop    %ebp
  80237a:	c3                   	ret    

0080237b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	53                   	push   %ebx
  80237f:	83 ec 14             	sub    $0x14,%esp
  802382:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802385:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802389:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802390:	e8 77 ec ff ff       	call   80100c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802395:	89 1c 24             	mov    %ebx,(%esp)
  802398:	e8 43 f0 ff ff       	call   8013e0 <fd2data>
  80239d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a8:	e8 5f ec ff ff       	call   80100c <sys_page_unmap>
}
  8023ad:	83 c4 14             	add    $0x14,%esp
  8023b0:	5b                   	pop    %ebx
  8023b1:	5d                   	pop    %ebp
  8023b2:	c3                   	ret    

008023b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	57                   	push   %edi
  8023b7:	56                   	push   %esi
  8023b8:	53                   	push   %ebx
  8023b9:	83 ec 2c             	sub    $0x2c,%esp
  8023bc:	89 c6                	mov    %eax,%esi
  8023be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023c1:	a1 20 54 80 00       	mov    0x805420,%eax
  8023c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023c9:	89 34 24             	mov    %esi,(%esp)
  8023cc:	e8 96 05 00 00       	call   802967 <pageref>
  8023d1:	89 c7                	mov    %eax,%edi
  8023d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d6:	89 04 24             	mov    %eax,(%esp)
  8023d9:	e8 89 05 00 00       	call   802967 <pageref>
  8023de:	39 c7                	cmp    %eax,%edi
  8023e0:	0f 94 c2             	sete   %dl
  8023e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023e6:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  8023ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8023ef:	39 fb                	cmp    %edi,%ebx
  8023f1:	74 21                	je     802414 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023f3:	84 d2                	test   %dl,%dl
  8023f5:	74 ca                	je     8023c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802402:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802406:	c7 04 24 65 31 80 00 	movl   $0x803165,(%esp)
  80240d:	e8 73 e0 ff ff       	call   800485 <cprintf>
  802412:	eb ad                	jmp    8023c1 <_pipeisclosed+0xe>
	}
}
  802414:	83 c4 2c             	add    $0x2c,%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5f                   	pop    %edi
  80241a:	5d                   	pop    %ebp
  80241b:	c3                   	ret    

0080241c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	57                   	push   %edi
  802420:	56                   	push   %esi
  802421:	53                   	push   %ebx
  802422:	83 ec 1c             	sub    $0x1c,%esp
  802425:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802428:	89 34 24             	mov    %esi,(%esp)
  80242b:	e8 b0 ef ff ff       	call   8013e0 <fd2data>
  802430:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802432:	bf 00 00 00 00       	mov    $0x0,%edi
  802437:	eb 45                	jmp    80247e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802439:	89 da                	mov    %ebx,%edx
  80243b:	89 f0                	mov    %esi,%eax
  80243d:	e8 71 ff ff ff       	call   8023b3 <_pipeisclosed>
  802442:	85 c0                	test   %eax,%eax
  802444:	75 41                	jne    802487 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802446:	e8 fb ea ff ff       	call   800f46 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80244b:	8b 43 04             	mov    0x4(%ebx),%eax
  80244e:	8b 0b                	mov    (%ebx),%ecx
  802450:	8d 51 20             	lea    0x20(%ecx),%edx
  802453:	39 d0                	cmp    %edx,%eax
  802455:	73 e2                	jae    802439 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802457:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80245a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80245e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802461:	99                   	cltd   
  802462:	c1 ea 1b             	shr    $0x1b,%edx
  802465:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802468:	83 e1 1f             	and    $0x1f,%ecx
  80246b:	29 d1                	sub    %edx,%ecx
  80246d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802471:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802475:	83 c0 01             	add    $0x1,%eax
  802478:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80247b:	83 c7 01             	add    $0x1,%edi
  80247e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802481:	75 c8                	jne    80244b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802483:	89 f8                	mov    %edi,%eax
  802485:	eb 05                	jmp    80248c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80248c:	83 c4 1c             	add    $0x1c,%esp
  80248f:	5b                   	pop    %ebx
  802490:	5e                   	pop    %esi
  802491:	5f                   	pop    %edi
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    

00802494 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	57                   	push   %edi
  802498:	56                   	push   %esi
  802499:	53                   	push   %ebx
  80249a:	83 ec 1c             	sub    $0x1c,%esp
  80249d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8024a0:	89 3c 24             	mov    %edi,(%esp)
  8024a3:	e8 38 ef ff ff       	call   8013e0 <fd2data>
  8024a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024aa:	be 00 00 00 00       	mov    $0x0,%esi
  8024af:	eb 3d                	jmp    8024ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024b1:	85 f6                	test   %esi,%esi
  8024b3:	74 04                	je     8024b9 <devpipe_read+0x25>
				return i;
  8024b5:	89 f0                	mov    %esi,%eax
  8024b7:	eb 43                	jmp    8024fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024b9:	89 da                	mov    %ebx,%edx
  8024bb:	89 f8                	mov    %edi,%eax
  8024bd:	e8 f1 fe ff ff       	call   8023b3 <_pipeisclosed>
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	75 31                	jne    8024f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024c6:	e8 7b ea ff ff       	call   800f46 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024cb:	8b 03                	mov    (%ebx),%eax
  8024cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024d0:	74 df                	je     8024b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024d2:	99                   	cltd   
  8024d3:	c1 ea 1b             	shr    $0x1b,%edx
  8024d6:	01 d0                	add    %edx,%eax
  8024d8:	83 e0 1f             	and    $0x1f,%eax
  8024db:	29 d0                	sub    %edx,%eax
  8024dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024eb:	83 c6 01             	add    $0x1,%esi
  8024ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024f1:	75 d8                	jne    8024cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024f3:	89 f0                	mov    %esi,%eax
  8024f5:	eb 05                	jmp    8024fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024fc:	83 c4 1c             	add    $0x1c,%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5f                   	pop    %edi
  802502:	5d                   	pop    %ebp
  802503:	c3                   	ret    

00802504 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	56                   	push   %esi
  802508:	53                   	push   %ebx
  802509:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80250c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80250f:	89 04 24             	mov    %eax,(%esp)
  802512:	e8 e0 ee ff ff       	call   8013f7 <fd_alloc>
  802517:	89 c2                	mov    %eax,%edx
  802519:	85 d2                	test   %edx,%edx
  80251b:	0f 88 4d 01 00 00    	js     80266e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802521:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802528:	00 
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802537:	e8 29 ea ff ff       	call   800f65 <sys_page_alloc>
  80253c:	89 c2                	mov    %eax,%edx
  80253e:	85 d2                	test   %edx,%edx
  802540:	0f 88 28 01 00 00    	js     80266e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802546:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802549:	89 04 24             	mov    %eax,(%esp)
  80254c:	e8 a6 ee ff ff       	call   8013f7 <fd_alloc>
  802551:	89 c3                	mov    %eax,%ebx
  802553:	85 c0                	test   %eax,%eax
  802555:	0f 88 fe 00 00 00    	js     802659 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80255b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802562:	00 
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802571:	e8 ef e9 ff ff       	call   800f65 <sys_page_alloc>
  802576:	89 c3                	mov    %eax,%ebx
  802578:	85 c0                	test   %eax,%eax
  80257a:	0f 88 d9 00 00 00    	js     802659 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	89 04 24             	mov    %eax,(%esp)
  802586:	e8 55 ee ff ff       	call   8013e0 <fd2data>
  80258b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80258d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802594:	00 
  802595:	89 44 24 04          	mov    %eax,0x4(%esp)
  802599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a0:	e8 c0 e9 ff ff       	call   800f65 <sys_page_alloc>
  8025a5:	89 c3                	mov    %eax,%ebx
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	0f 88 97 00 00 00    	js     802646 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	89 04 24             	mov    %eax,(%esp)
  8025b5:	e8 26 ee ff ff       	call   8013e0 <fd2data>
  8025ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025c1:	00 
  8025c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025cd:	00 
  8025ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d9:	e8 db e9 ff ff       	call   800fb9 <sys_page_map>
  8025de:	89 c3                	mov    %eax,%ebx
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	78 52                	js     802636 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025e4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025f9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802602:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	89 04 24             	mov    %eax,(%esp)
  802614:	e8 b7 ed ff ff       	call   8013d0 <fd2num>
  802619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80261e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802621:	89 04 24             	mov    %eax,(%esp)
  802624:	e8 a7 ed ff ff       	call   8013d0 <fd2num>
  802629:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80262c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
  802634:	eb 38                	jmp    80266e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802636:	89 74 24 04          	mov    %esi,0x4(%esp)
  80263a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802641:	e8 c6 e9 ff ff       	call   80100c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	89 44 24 04          	mov    %eax,0x4(%esp)
  80264d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802654:	e8 b3 e9 ff ff       	call   80100c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802667:	e8 a0 e9 ff ff       	call   80100c <sys_page_unmap>
  80266c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80266e:	83 c4 30             	add    $0x30,%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5d                   	pop    %ebp
  802674:	c3                   	ret    

00802675 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80267b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	89 04 24             	mov    %eax,(%esp)
  802688:	e8 b9 ed ff ff       	call   801446 <fd_lookup>
  80268d:	89 c2                	mov    %eax,%edx
  80268f:	85 d2                	test   %edx,%edx
  802691:	78 15                	js     8026a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	89 04 24             	mov    %eax,(%esp)
  802699:	e8 42 ed ff ff       	call   8013e0 <fd2data>
	return _pipeisclosed(fd, p);
  80269e:	89 c2                	mov    %eax,%edx
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	e8 0b fd ff ff       	call   8023b3 <_pipeisclosed>
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    
  8026aa:	66 90                	xchg   %ax,%ax
  8026ac:	66 90                	xchg   %ax,%ax
  8026ae:	66 90                	xchg   %ax,%ax

008026b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    

008026ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026c0:	c7 44 24 04 7d 31 80 	movl   $0x80317d,0x4(%esp)
  8026c7:	00 
  8026c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026cb:	89 04 24             	mov    %eax,(%esp)
  8026ce:	e8 24 e4 ff ff       	call   800af7 <strcpy>
	return 0;
}
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    

008026da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
  8026dd:	57                   	push   %edi
  8026de:	56                   	push   %esi
  8026df:	53                   	push   %ebx
  8026e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026f1:	eb 31                	jmp    802724 <devcons_write+0x4a>
		m = n - tot;
  8026f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8026f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8026f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8026fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802700:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802703:	89 74 24 08          	mov    %esi,0x8(%esp)
  802707:	03 45 0c             	add    0xc(%ebp),%eax
  80270a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80270e:	89 3c 24             	mov    %edi,(%esp)
  802711:	e8 7e e5 ff ff       	call   800c94 <memmove>
		sys_cputs(buf, m);
  802716:	89 74 24 04          	mov    %esi,0x4(%esp)
  80271a:	89 3c 24             	mov    %edi,(%esp)
  80271d:	e8 24 e7 ff ff       	call   800e46 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802722:	01 f3                	add    %esi,%ebx
  802724:	89 d8                	mov    %ebx,%eax
  802726:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802729:	72 c8                	jb     8026f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80272b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5f                   	pop    %edi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    

00802736 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802741:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802745:	75 07                	jne    80274e <devcons_read+0x18>
  802747:	eb 2a                	jmp    802773 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802749:	e8 f8 e7 ff ff       	call   800f46 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80274e:	66 90                	xchg   %ax,%ax
  802750:	e8 0f e7 ff ff       	call   800e64 <sys_cgetc>
  802755:	85 c0                	test   %eax,%eax
  802757:	74 f0                	je     802749 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802759:	85 c0                	test   %eax,%eax
  80275b:	78 16                	js     802773 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80275d:	83 f8 04             	cmp    $0x4,%eax
  802760:	74 0c                	je     80276e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802762:	8b 55 0c             	mov    0xc(%ebp),%edx
  802765:	88 02                	mov    %al,(%edx)
	return 1;
  802767:	b8 01 00 00 00       	mov    $0x1,%eax
  80276c:	eb 05                	jmp    802773 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80276e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802773:	c9                   	leave  
  802774:	c3                   	ret    

00802775 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
  802778:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802781:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802788:	00 
  802789:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80278c:	89 04 24             	mov    %eax,(%esp)
  80278f:	e8 b2 e6 ff ff       	call   800e46 <sys_cputs>
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <getchar>:

int
getchar(void)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80279c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027a3:	00 
  8027a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b2:	e8 23 ef ff ff       	call   8016da <read>
	if (r < 0)
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	78 0f                	js     8027ca <getchar+0x34>
		return r;
	if (r < 1)
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	7e 06                	jle    8027c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027c3:	eb 05                	jmp    8027ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
  8027cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	89 04 24             	mov    %eax,(%esp)
  8027df:	e8 62 ec ff ff       	call   801446 <fd_lookup>
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	78 11                	js     8027f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027f1:	39 10                	cmp    %edx,(%eax)
  8027f3:	0f 94 c0             	sete   %al
  8027f6:	0f b6 c0             	movzbl %al,%eax
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <opencons>:

int
opencons(void)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802801:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802804:	89 04 24             	mov    %eax,(%esp)
  802807:	e8 eb eb ff ff       	call   8013f7 <fd_alloc>
		return r;
  80280c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80280e:	85 c0                	test   %eax,%eax
  802810:	78 40                	js     802852 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802812:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802819:	00 
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802821:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802828:	e8 38 e7 ff ff       	call   800f65 <sys_page_alloc>
		return r;
  80282d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80282f:	85 c0                	test   %eax,%eax
  802831:	78 1f                	js     802852 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802833:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802848:	89 04 24             	mov    %eax,(%esp)
  80284b:	e8 80 eb ff ff       	call   8013d0 <fd2num>
  802850:	89 c2                	mov    %eax,%edx
}
  802852:	89 d0                	mov    %edx,%eax
  802854:	c9                   	leave  
  802855:	c3                   	ret    
  802856:	66 90                	xchg   %ax,%ax
  802858:	66 90                	xchg   %ax,%ax
  80285a:	66 90                	xchg   %ax,%ax
  80285c:	66 90                	xchg   %ax,%ax
  80285e:	66 90                	xchg   %ax,%ax

00802860 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	56                   	push   %esi
  802864:	53                   	push   %ebx
  802865:	83 ec 10             	sub    $0x10,%esp
  802868:	8b 75 08             	mov    0x8(%ebp),%esi
  80286b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802871:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802873:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802878:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80287b:	89 04 24             	mov    %eax,(%esp)
  80287e:	e8 18 e9 ff ff       	call   80119b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802883:	85 c0                	test   %eax,%eax
  802885:	75 26                	jne    8028ad <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802887:	85 f6                	test   %esi,%esi
  802889:	74 0a                	je     802895 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80288b:	a1 20 54 80 00       	mov    0x805420,%eax
  802890:	8b 40 74             	mov    0x74(%eax),%eax
  802893:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802895:	85 db                	test   %ebx,%ebx
  802897:	74 0a                	je     8028a3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802899:	a1 20 54 80 00       	mov    0x805420,%eax
  80289e:	8b 40 78             	mov    0x78(%eax),%eax
  8028a1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8028a3:	a1 20 54 80 00       	mov    0x805420,%eax
  8028a8:	8b 40 70             	mov    0x70(%eax),%eax
  8028ab:	eb 14                	jmp    8028c1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8028ad:	85 f6                	test   %esi,%esi
  8028af:	74 06                	je     8028b7 <ipc_recv+0x57>
			*from_env_store = 0;
  8028b1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8028b7:	85 db                	test   %ebx,%ebx
  8028b9:	74 06                	je     8028c1 <ipc_recv+0x61>
			*perm_store = 0;
  8028bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  8028c1:	83 c4 10             	add    $0x10,%esp
  8028c4:	5b                   	pop    %ebx
  8028c5:	5e                   	pop    %esi
  8028c6:	5d                   	pop    %ebp
  8028c7:	c3                   	ret    

008028c8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028c8:	55                   	push   %ebp
  8028c9:	89 e5                	mov    %esp,%ebp
  8028cb:	57                   	push   %edi
  8028cc:	56                   	push   %esi
  8028cd:	53                   	push   %ebx
  8028ce:	83 ec 1c             	sub    $0x1c,%esp
  8028d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028d7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  8028da:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  8028dc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8028e1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8028e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8028e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028f3:	89 3c 24             	mov    %edi,(%esp)
  8028f6:	e8 7d e8 ff ff       	call   801178 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 28                	je     802927 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8028ff:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802902:	74 1c                	je     802920 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802904:	c7 44 24 08 8c 31 80 	movl   $0x80318c,0x8(%esp)
  80290b:	00 
  80290c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802913:	00 
  802914:	c7 04 24 b0 31 80 00 	movl   $0x8031b0,(%esp)
  80291b:	e8 6c da ff ff       	call   80038c <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802920:	e8 21 e6 ff ff       	call   800f46 <sys_yield>
	}
  802925:	eb bd                	jmp    8028e4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802927:	83 c4 1c             	add    $0x1c,%esp
  80292a:	5b                   	pop    %ebx
  80292b:	5e                   	pop    %esi
  80292c:	5f                   	pop    %edi
  80292d:	5d                   	pop    %ebp
  80292e:	c3                   	ret    

0080292f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802935:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80293a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80293d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802943:	8b 52 50             	mov    0x50(%edx),%edx
  802946:	39 ca                	cmp    %ecx,%edx
  802948:	75 0d                	jne    802957 <ipc_find_env+0x28>
			return envs[i].env_id;
  80294a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80294d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802952:	8b 40 40             	mov    0x40(%eax),%eax
  802955:	eb 0e                	jmp    802965 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802957:	83 c0 01             	add    $0x1,%eax
  80295a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80295f:	75 d9                	jne    80293a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802961:	66 b8 00 00          	mov    $0x0,%ax
}
  802965:	5d                   	pop    %ebp
  802966:	c3                   	ret    

00802967 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
  80296a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80296d:	89 d0                	mov    %edx,%eax
  80296f:	c1 e8 16             	shr    $0x16,%eax
  802972:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802979:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80297e:	f6 c1 01             	test   $0x1,%cl
  802981:	74 1d                	je     8029a0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802983:	c1 ea 0c             	shr    $0xc,%edx
  802986:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80298d:	f6 c2 01             	test   $0x1,%dl
  802990:	74 0e                	je     8029a0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802992:	c1 ea 0c             	shr    $0xc,%edx
  802995:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80299c:	ef 
  80299d:	0f b7 c0             	movzwl %ax,%eax
}
  8029a0:	5d                   	pop    %ebp
  8029a1:	c3                   	ret    
  8029a2:	66 90                	xchg   %ax,%ax
  8029a4:	66 90                	xchg   %ax,%ax
  8029a6:	66 90                	xchg   %ax,%ax
  8029a8:	66 90                	xchg   %ax,%ax
  8029aa:	66 90                	xchg   %ax,%ax
  8029ac:	66 90                	xchg   %ax,%ax
  8029ae:	66 90                	xchg   %ax,%ax

008029b0 <__udivdi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	83 ec 0c             	sub    $0xc,%esp
  8029b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8029be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8029c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8029cc:	89 ea                	mov    %ebp,%edx
  8029ce:	89 0c 24             	mov    %ecx,(%esp)
  8029d1:	75 2d                	jne    802a00 <__udivdi3+0x50>
  8029d3:	39 e9                	cmp    %ebp,%ecx
  8029d5:	77 61                	ja     802a38 <__udivdi3+0x88>
  8029d7:	85 c9                	test   %ecx,%ecx
  8029d9:	89 ce                	mov    %ecx,%esi
  8029db:	75 0b                	jne    8029e8 <__udivdi3+0x38>
  8029dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e2:	31 d2                	xor    %edx,%edx
  8029e4:	f7 f1                	div    %ecx
  8029e6:	89 c6                	mov    %eax,%esi
  8029e8:	31 d2                	xor    %edx,%edx
  8029ea:	89 e8                	mov    %ebp,%eax
  8029ec:	f7 f6                	div    %esi
  8029ee:	89 c5                	mov    %eax,%ebp
  8029f0:	89 f8                	mov    %edi,%eax
  8029f2:	f7 f6                	div    %esi
  8029f4:	89 ea                	mov    %ebp,%edx
  8029f6:	83 c4 0c             	add    $0xc,%esp
  8029f9:	5e                   	pop    %esi
  8029fa:	5f                   	pop    %edi
  8029fb:	5d                   	pop    %ebp
  8029fc:	c3                   	ret    
  8029fd:	8d 76 00             	lea    0x0(%esi),%esi
  802a00:	39 e8                	cmp    %ebp,%eax
  802a02:	77 24                	ja     802a28 <__udivdi3+0x78>
  802a04:	0f bd e8             	bsr    %eax,%ebp
  802a07:	83 f5 1f             	xor    $0x1f,%ebp
  802a0a:	75 3c                	jne    802a48 <__udivdi3+0x98>
  802a0c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a10:	39 34 24             	cmp    %esi,(%esp)
  802a13:	0f 86 9f 00 00 00    	jbe    802ab8 <__udivdi3+0x108>
  802a19:	39 d0                	cmp    %edx,%eax
  802a1b:	0f 82 97 00 00 00    	jb     802ab8 <__udivdi3+0x108>
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	31 d2                	xor    %edx,%edx
  802a2a:	31 c0                	xor    %eax,%eax
  802a2c:	83 c4 0c             	add    $0xc,%esp
  802a2f:	5e                   	pop    %esi
  802a30:	5f                   	pop    %edi
  802a31:	5d                   	pop    %ebp
  802a32:	c3                   	ret    
  802a33:	90                   	nop
  802a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 f8                	mov    %edi,%eax
  802a3a:	f7 f1                	div    %ecx
  802a3c:	31 d2                	xor    %edx,%edx
  802a3e:	83 c4 0c             	add    $0xc,%esp
  802a41:	5e                   	pop    %esi
  802a42:	5f                   	pop    %edi
  802a43:	5d                   	pop    %ebp
  802a44:	c3                   	ret    
  802a45:	8d 76 00             	lea    0x0(%esi),%esi
  802a48:	89 e9                	mov    %ebp,%ecx
  802a4a:	8b 3c 24             	mov    (%esp),%edi
  802a4d:	d3 e0                	shl    %cl,%eax
  802a4f:	89 c6                	mov    %eax,%esi
  802a51:	b8 20 00 00 00       	mov    $0x20,%eax
  802a56:	29 e8                	sub    %ebp,%eax
  802a58:	89 c1                	mov    %eax,%ecx
  802a5a:	d3 ef                	shr    %cl,%edi
  802a5c:	89 e9                	mov    %ebp,%ecx
  802a5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a62:	8b 3c 24             	mov    (%esp),%edi
  802a65:	09 74 24 08          	or     %esi,0x8(%esp)
  802a69:	89 d6                	mov    %edx,%esi
  802a6b:	d3 e7                	shl    %cl,%edi
  802a6d:	89 c1                	mov    %eax,%ecx
  802a6f:	89 3c 24             	mov    %edi,(%esp)
  802a72:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a76:	d3 ee                	shr    %cl,%esi
  802a78:	89 e9                	mov    %ebp,%ecx
  802a7a:	d3 e2                	shl    %cl,%edx
  802a7c:	89 c1                	mov    %eax,%ecx
  802a7e:	d3 ef                	shr    %cl,%edi
  802a80:	09 d7                	or     %edx,%edi
  802a82:	89 f2                	mov    %esi,%edx
  802a84:	89 f8                	mov    %edi,%eax
  802a86:	f7 74 24 08          	divl   0x8(%esp)
  802a8a:	89 d6                	mov    %edx,%esi
  802a8c:	89 c7                	mov    %eax,%edi
  802a8e:	f7 24 24             	mull   (%esp)
  802a91:	39 d6                	cmp    %edx,%esi
  802a93:	89 14 24             	mov    %edx,(%esp)
  802a96:	72 30                	jb     802ac8 <__udivdi3+0x118>
  802a98:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a9c:	89 e9                	mov    %ebp,%ecx
  802a9e:	d3 e2                	shl    %cl,%edx
  802aa0:	39 c2                	cmp    %eax,%edx
  802aa2:	73 05                	jae    802aa9 <__udivdi3+0xf9>
  802aa4:	3b 34 24             	cmp    (%esp),%esi
  802aa7:	74 1f                	je     802ac8 <__udivdi3+0x118>
  802aa9:	89 f8                	mov    %edi,%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	e9 7a ff ff ff       	jmp    802a2c <__udivdi3+0x7c>
  802ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ab8:	31 d2                	xor    %edx,%edx
  802aba:	b8 01 00 00 00       	mov    $0x1,%eax
  802abf:	e9 68 ff ff ff       	jmp    802a2c <__udivdi3+0x7c>
  802ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	83 c4 0c             	add    $0xc,%esp
  802ad0:	5e                   	pop    %esi
  802ad1:	5f                   	pop    %edi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    
  802ad4:	66 90                	xchg   %ax,%ax
  802ad6:	66 90                	xchg   %ax,%ax
  802ad8:	66 90                	xchg   %ax,%ax
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__umoddi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	83 ec 14             	sub    $0x14,%esp
  802ae6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802aee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802af2:	89 c7                	mov    %eax,%edi
  802af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802afc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b00:	89 34 24             	mov    %esi,(%esp)
  802b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b07:	85 c0                	test   %eax,%eax
  802b09:	89 c2                	mov    %eax,%edx
  802b0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b0f:	75 17                	jne    802b28 <__umoddi3+0x48>
  802b11:	39 fe                	cmp    %edi,%esi
  802b13:	76 4b                	jbe    802b60 <__umoddi3+0x80>
  802b15:	89 c8                	mov    %ecx,%eax
  802b17:	89 fa                	mov    %edi,%edx
  802b19:	f7 f6                	div    %esi
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	31 d2                	xor    %edx,%edx
  802b1f:	83 c4 14             	add    $0x14,%esp
  802b22:	5e                   	pop    %esi
  802b23:	5f                   	pop    %edi
  802b24:	5d                   	pop    %ebp
  802b25:	c3                   	ret    
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	39 f8                	cmp    %edi,%eax
  802b2a:	77 54                	ja     802b80 <__umoddi3+0xa0>
  802b2c:	0f bd e8             	bsr    %eax,%ebp
  802b2f:	83 f5 1f             	xor    $0x1f,%ebp
  802b32:	75 5c                	jne    802b90 <__umoddi3+0xb0>
  802b34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b38:	39 3c 24             	cmp    %edi,(%esp)
  802b3b:	0f 87 e7 00 00 00    	ja     802c28 <__umoddi3+0x148>
  802b41:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b45:	29 f1                	sub    %esi,%ecx
  802b47:	19 c7                	sbb    %eax,%edi
  802b49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b51:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b55:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b59:	83 c4 14             	add    $0x14,%esp
  802b5c:	5e                   	pop    %esi
  802b5d:	5f                   	pop    %edi
  802b5e:	5d                   	pop    %ebp
  802b5f:	c3                   	ret    
  802b60:	85 f6                	test   %esi,%esi
  802b62:	89 f5                	mov    %esi,%ebp
  802b64:	75 0b                	jne    802b71 <__umoddi3+0x91>
  802b66:	b8 01 00 00 00       	mov    $0x1,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	f7 f6                	div    %esi
  802b6f:	89 c5                	mov    %eax,%ebp
  802b71:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b75:	31 d2                	xor    %edx,%edx
  802b77:	f7 f5                	div    %ebp
  802b79:	89 c8                	mov    %ecx,%eax
  802b7b:	f7 f5                	div    %ebp
  802b7d:	eb 9c                	jmp    802b1b <__umoddi3+0x3b>
  802b7f:	90                   	nop
  802b80:	89 c8                	mov    %ecx,%eax
  802b82:	89 fa                	mov    %edi,%edx
  802b84:	83 c4 14             	add    $0x14,%esp
  802b87:	5e                   	pop    %esi
  802b88:	5f                   	pop    %edi
  802b89:	5d                   	pop    %ebp
  802b8a:	c3                   	ret    
  802b8b:	90                   	nop
  802b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b90:	8b 04 24             	mov    (%esp),%eax
  802b93:	be 20 00 00 00       	mov    $0x20,%esi
  802b98:	89 e9                	mov    %ebp,%ecx
  802b9a:	29 ee                	sub    %ebp,%esi
  802b9c:	d3 e2                	shl    %cl,%edx
  802b9e:	89 f1                	mov    %esi,%ecx
  802ba0:	d3 e8                	shr    %cl,%eax
  802ba2:	89 e9                	mov    %ebp,%ecx
  802ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ba8:	8b 04 24             	mov    (%esp),%eax
  802bab:	09 54 24 04          	or     %edx,0x4(%esp)
  802baf:	89 fa                	mov    %edi,%edx
  802bb1:	d3 e0                	shl    %cl,%eax
  802bb3:	89 f1                	mov    %esi,%ecx
  802bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bb9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802bbd:	d3 ea                	shr    %cl,%edx
  802bbf:	89 e9                	mov    %ebp,%ecx
  802bc1:	d3 e7                	shl    %cl,%edi
  802bc3:	89 f1                	mov    %esi,%ecx
  802bc5:	d3 e8                	shr    %cl,%eax
  802bc7:	89 e9                	mov    %ebp,%ecx
  802bc9:	09 f8                	or     %edi,%eax
  802bcb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802bcf:	f7 74 24 04          	divl   0x4(%esp)
  802bd3:	d3 e7                	shl    %cl,%edi
  802bd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bd9:	89 d7                	mov    %edx,%edi
  802bdb:	f7 64 24 08          	mull   0x8(%esp)
  802bdf:	39 d7                	cmp    %edx,%edi
  802be1:	89 c1                	mov    %eax,%ecx
  802be3:	89 14 24             	mov    %edx,(%esp)
  802be6:	72 2c                	jb     802c14 <__umoddi3+0x134>
  802be8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802bec:	72 22                	jb     802c10 <__umoddi3+0x130>
  802bee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802bf2:	29 c8                	sub    %ecx,%eax
  802bf4:	19 d7                	sbb    %edx,%edi
  802bf6:	89 e9                	mov    %ebp,%ecx
  802bf8:	89 fa                	mov    %edi,%edx
  802bfa:	d3 e8                	shr    %cl,%eax
  802bfc:	89 f1                	mov    %esi,%ecx
  802bfe:	d3 e2                	shl    %cl,%edx
  802c00:	89 e9                	mov    %ebp,%ecx
  802c02:	d3 ef                	shr    %cl,%edi
  802c04:	09 d0                	or     %edx,%eax
  802c06:	89 fa                	mov    %edi,%edx
  802c08:	83 c4 14             	add    $0x14,%esp
  802c0b:	5e                   	pop    %esi
  802c0c:	5f                   	pop    %edi
  802c0d:	5d                   	pop    %ebp
  802c0e:	c3                   	ret    
  802c0f:	90                   	nop
  802c10:	39 d7                	cmp    %edx,%edi
  802c12:	75 da                	jne    802bee <__umoddi3+0x10e>
  802c14:	8b 14 24             	mov    (%esp),%edx
  802c17:	89 c1                	mov    %eax,%ecx
  802c19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c21:	eb cb                	jmp    802bee <__umoddi3+0x10e>
  802c23:	90                   	nop
  802c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c2c:	0f 82 0f ff ff ff    	jb     802b41 <__umoddi3+0x61>
  802c32:	e9 1a ff ff ff       	jmp    802b51 <__umoddi3+0x71>
