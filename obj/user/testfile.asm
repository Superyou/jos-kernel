
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 52 07 00 00       	call   800783 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800040:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  800047:	e8 0b 0f 00 00       	call   800f57 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80004c:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800052:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800059:	e8 41 17 00 00       	call   80179f <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80005e:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800065:	00 
  800066:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80006d:	00 
  80006e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800075:	00 
  800076:	89 04 24             	mov    %eax,(%esp)
  800079:	e8 ba 16 00 00       	call   801738 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  80007e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  80008d:	cc 
  80008e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800095:	e8 36 16 00 00       	call   8016d0 <ipc_recv>
}
  80009a:	83 c4 14             	add    $0x14,%esp
  80009d:	5b                   	pop    %ebx
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <umain>:

void
umain(int argc, char **argv)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	81 ec cc 02 00 00    	sub    $0x2cc,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b1:	b8 20 2e 80 00       	mov    $0x802e20,%eax
  8000b6:	e8 78 ff ff ff       	call   800033 <xopen>
  8000bb:	85 c0                	test   %eax,%eax
  8000bd:	79 25                	jns    8000e4 <umain+0x44>
  8000bf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000c2:	74 3c                	je     800100 <umain+0x60>
		panic("serve_open /not-found: %e", r);
  8000c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c8:	c7 44 24 08 2b 2e 80 	movl   $0x802e2b,0x8(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  8000d7:	00 
  8000d8:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8000df:	e8 00 07 00 00       	call   8007e4 <_panic>
	else if (r >= 0)
		panic("serve_open /not-found succeeded!");
  8000e4:	c7 44 24 08 e0 2f 80 	movl   $0x802fe0,0x8(%esp)
  8000eb:	00 
  8000ec:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000f3:	00 
  8000f4:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8000fb:	e8 e4 06 00 00       	call   8007e4 <_panic>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800100:	ba 00 00 00 00       	mov    $0x0,%edx
  800105:	b8 55 2e 80 00       	mov    $0x802e55,%eax
  80010a:	e8 24 ff ff ff       	call   800033 <xopen>
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0x93>
		panic("serve_open /newmotd: %e", r);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 5e 2e 80 	movl   $0x802e5e,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80012e:	e8 b1 06 00 00       	call   8007e4 <_panic>
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  800133:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  80013a:	75 12                	jne    80014e <umain+0xae>
  80013c:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  800143:	75 09                	jne    80014e <umain+0xae>
  800145:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  80014c:	74 1c                	je     80016a <umain+0xca>
		panic("serve_open did not fill struct Fd correctly\n");
  80014e:	c7 44 24 08 04 30 80 	movl   $0x803004,0x8(%esp)
  800155:	00 
  800156:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80015d:	00 
  80015e:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  800165:	e8 7a 06 00 00       	call   8007e4 <_panic>
	cprintf("serve_open is good\n");
  80016a:	c7 04 24 76 2e 80 00 	movl   $0x802e76,(%esp)
  800171:	e8 67 07 00 00       	call   8008dd <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800176:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800187:	ff 15 1c 40 80 00    	call   *0x80401c
  80018d:	85 c0                	test   %eax,%eax
  80018f:	79 20                	jns    8001b1 <umain+0x111>
		panic("file_stat: %e", r);
  800191:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800195:	c7 44 24 08 8a 2e 80 	movl   $0x802e8a,0x8(%esp)
  80019c:	00 
  80019d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8001a4:	00 
  8001a5:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8001ac:	e8 33 06 00 00       	call   8007e4 <_panic>
	if (strlen(msg) != st.st_size)
  8001b1:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 62 0d 00 00       	call   800f20 <strlen>
  8001be:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c1:	74 34                	je     8001f7 <umain+0x157>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8001c3:	a1 00 40 80 00       	mov    0x804000,%eax
  8001c8:	89 04 24             	mov    %eax,(%esp)
  8001cb:	e8 50 0d 00 00       	call   800f20 <strlen>
  8001d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001db:	c7 44 24 08 34 30 80 	movl   $0x803034,0x8(%esp)
  8001e2:	00 
  8001e3:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8001ea:	00 
  8001eb:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8001f2:	e8 ed 05 00 00       	call   8007e4 <_panic>
	cprintf("file_stat is good\n");
  8001f7:	c7 04 24 98 2e 80 00 	movl   $0x802e98,(%esp)
  8001fe:	e8 da 06 00 00       	call   8008dd <cprintf>

	memset(buf, 0, sizeof buf);
  800203:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800212:	00 
  800213:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800219:	89 1c 24             	mov    %ebx,(%esp)
  80021c:	e8 86 0e 00 00       	call   8010a7 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800221:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800228:	00 
  800229:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80022d:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800234:	ff 15 10 40 80 00    	call   *0x804010
  80023a:	85 c0                	test   %eax,%eax
  80023c:	79 20                	jns    80025e <umain+0x1be>
		panic("file_read: %e", r);
  80023e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800242:	c7 44 24 08 ab 2e 80 	movl   $0x802eab,0x8(%esp)
  800249:	00 
  80024a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  800251:	00 
  800252:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  800259:	e8 86 05 00 00       	call   8007e4 <_panic>
	if (strcmp(buf, msg) != 0)
  80025e:	a1 00 40 80 00       	mov    0x804000,%eax
  800263:	89 44 24 04          	mov    %eax,0x4(%esp)
  800267:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  80026d:	89 04 24             	mov    %eax,(%esp)
  800270:	e8 97 0d 00 00       	call   80100c <strcmp>
  800275:	85 c0                	test   %eax,%eax
  800277:	74 1c                	je     800295 <umain+0x1f5>
		panic("file_read returned wrong data");
  800279:	c7 44 24 08 b9 2e 80 	movl   $0x802eb9,0x8(%esp)
  800280:	00 
  800281:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800288:	00 
  800289:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  800290:	e8 4f 05 00 00       	call   8007e4 <_panic>
	cprintf("file_read is good\n");
  800295:	c7 04 24 d7 2e 80 00 	movl   $0x802ed7,(%esp)
  80029c:	e8 3c 06 00 00       	call   8008dd <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8002a1:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8002a8:	ff 15 18 40 80 00    	call   *0x804018
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	79 20                	jns    8002d2 <umain+0x232>
		panic("file_close: %e", r);
  8002b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b6:	c7 44 24 08 ea 2e 80 	movl   $0x802eea,0x8(%esp)
  8002bd:	00 
  8002be:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8002c5:	00 
  8002c6:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8002cd:	e8 12 05 00 00       	call   8007e4 <_panic>
	cprintf("file_close is good\n");
  8002d2:	c7 04 24 f9 2e 80 00 	movl   $0x802ef9,(%esp)
  8002d9:	e8 ff 05 00 00       	call   8008dd <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8002de:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8002e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e6:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8002eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ee:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8002f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f6:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8002fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8002fe:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  800305:	cc 
  800306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80030d:	e8 5a 11 00 00       	call   80146c <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  800312:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800319:	00 
  80031a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800320:	89 44 24 04          	mov    %eax,0x4(%esp)
  800324:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800327:	89 04 24             	mov    %eax,(%esp)
  80032a:	ff 15 10 40 80 00    	call   *0x804010
  800330:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800333:	74 20                	je     800355 <umain+0x2b5>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800335:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800339:	c7 44 24 08 5c 30 80 	movl   $0x80305c,0x8(%esp)
  800340:	00 
  800341:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800348:	00 
  800349:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  800350:	e8 8f 04 00 00       	call   8007e4 <_panic>
	cprintf("stale fileid is good\n");
  800355:	c7 04 24 0d 2f 80 00 	movl   $0x802f0d,(%esp)
  80035c:	e8 7c 05 00 00       	call   8008dd <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800361:	ba 02 01 00 00       	mov    $0x102,%edx
  800366:	b8 23 2f 80 00       	mov    $0x802f23,%eax
  80036b:	e8 c3 fc ff ff       	call   800033 <xopen>
  800370:	85 c0                	test   %eax,%eax
  800372:	79 20                	jns    800394 <umain+0x2f4>
		panic("serve_open /new-file: %e", r);
  800374:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800378:	c7 44 24 08 2d 2f 80 	movl   $0x802f2d,0x8(%esp)
  80037f:	00 
  800380:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  800387:	00 
  800388:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80038f:	e8 50 04 00 00       	call   8007e4 <_panic>

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800394:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  80039a:	a1 00 40 80 00       	mov    0x804000,%eax
  80039f:	89 04 24             	mov    %eax,(%esp)
  8003a2:	e8 79 0b 00 00       	call   800f20 <strlen>
  8003a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ab:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b4:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8003bb:	ff d3                	call   *%ebx
  8003bd:	89 c3                	mov    %eax,%ebx
  8003bf:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c4:	89 04 24             	mov    %eax,(%esp)
  8003c7:	e8 54 0b 00 00       	call   800f20 <strlen>
  8003cc:	39 c3                	cmp    %eax,%ebx
  8003ce:	74 20                	je     8003f0 <umain+0x350>
		panic("file_write: %e", r);
  8003d0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d4:	c7 44 24 08 46 2f 80 	movl   $0x802f46,0x8(%esp)
  8003db:	00 
  8003dc:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8003e3:	00 
  8003e4:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8003eb:	e8 f4 03 00 00       	call   8007e4 <_panic>
	cprintf("file_write is good\n");
  8003f0:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  8003f7:	e8 e1 04 00 00       	call   8008dd <cprintf>

	FVA->fd_offset = 0;
  8003fc:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800403:	00 00 00 
	memset(buf, 0, sizeof buf);
  800406:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80040d:	00 
  80040e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800415:	00 
  800416:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  80041c:	89 1c 24             	mov    %ebx,(%esp)
  80041f:	e8 83 0c 00 00       	call   8010a7 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800424:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80042b:	00 
  80042c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800430:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800437:	ff 15 10 40 80 00    	call   *0x804010
  80043d:	89 c3                	mov    %eax,%ebx
  80043f:	85 c0                	test   %eax,%eax
  800441:	79 20                	jns    800463 <umain+0x3c3>
		panic("file_read after file_write: %e", r);
  800443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800447:	c7 44 24 08 94 30 80 	movl   $0x803094,0x8(%esp)
  80044e:	00 
  80044f:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  800456:	00 
  800457:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80045e:	e8 81 03 00 00       	call   8007e4 <_panic>
	if (r != strlen(msg))
  800463:	a1 00 40 80 00       	mov    0x804000,%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	e8 b0 0a 00 00       	call   800f20 <strlen>
  800470:	39 d8                	cmp    %ebx,%eax
  800472:	74 20                	je     800494 <umain+0x3f4>
		panic("file_read after file_write returned wrong length: %d", r);
  800474:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800478:	c7 44 24 08 b4 30 80 	movl   $0x8030b4,0x8(%esp)
  80047f:	00 
  800480:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  800487:	00 
  800488:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80048f:	e8 50 03 00 00       	call   8007e4 <_panic>
	if (strcmp(buf, msg) != 0)
  800494:	a1 00 40 80 00       	mov    0x804000,%eax
  800499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049d:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004a3:	89 04 24             	mov    %eax,(%esp)
  8004a6:	e8 61 0b 00 00       	call   80100c <strcmp>
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 1c                	je     8004cb <umain+0x42b>
		panic("file_read after file_write returned wrong data");
  8004af:	c7 44 24 08 ec 30 80 	movl   $0x8030ec,0x8(%esp)
  8004b6:	00 
  8004b7:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8004be:	00 
  8004bf:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8004c6:	e8 19 03 00 00       	call   8007e4 <_panic>
	cprintf("file_read after file_write is good\n");
  8004cb:	c7 04 24 1c 31 80 00 	movl   $0x80311c,(%esp)
  8004d2:	e8 06 04 00 00       	call   8008dd <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8004d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004de:	00 
  8004df:	c7 04 24 20 2e 80 00 	movl   $0x802e20,(%esp)
  8004e6:	e8 49 1b 00 00       	call   802034 <open>
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	79 25                	jns    800514 <umain+0x474>
  8004ef:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8004f2:	74 3c                	je     800530 <umain+0x490>
		panic("open /not-found: %e", r);
  8004f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f8:	c7 44 24 08 31 2e 80 	movl   $0x802e31,0x8(%esp)
  8004ff:	00 
  800500:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  800507:	00 
  800508:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80050f:	e8 d0 02 00 00       	call   8007e4 <_panic>
	else if (r >= 0)
		panic("open /not-found succeeded!");
  800514:	c7 44 24 08 69 2f 80 	movl   $0x802f69,0x8(%esp)
  80051b:	00 
  80051c:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800523:	00 
  800524:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80052b:	e8 b4 02 00 00       	call   8007e4 <_panic>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800530:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800537:	00 
  800538:	c7 04 24 55 2e 80 00 	movl   $0x802e55,(%esp)
  80053f:	e8 f0 1a 00 00       	call   802034 <open>
  800544:	85 c0                	test   %eax,%eax
  800546:	79 20                	jns    800568 <umain+0x4c8>
		panic("open /newmotd: %e", r);
  800548:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054c:	c7 44 24 08 64 2e 80 	movl   $0x802e64,0x8(%esp)
  800553:	00 
  800554:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80055b:	00 
  80055c:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  800563:	e8 7c 02 00 00       	call   8007e4 <_panic>
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800568:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80056b:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800572:	75 12                	jne    800586 <umain+0x4e6>
  800574:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80057b:	75 09                	jne    800586 <umain+0x4e6>
  80057d:	83 b8 08 00 00 d0 00 	cmpl   $0x0,-0x2ffffff8(%eax)
  800584:	74 1c                	je     8005a2 <umain+0x502>
		panic("open did not fill struct Fd correctly\n");
  800586:	c7 44 24 08 40 31 80 	movl   $0x803140,0x8(%esp)
  80058d:	00 
  80058e:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  800595:	00 
  800596:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80059d:	e8 42 02 00 00       	call   8007e4 <_panic>
	cprintf("open is good\n");
  8005a2:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  8005a9:	e8 2f 03 00 00       	call   8008dd <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8005ae:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  8005b5:	00 
  8005b6:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  8005bd:	e8 72 1a 00 00       	call   802034 <open>
  8005c2:	89 c6                	mov    %eax,%esi
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	79 20                	jns    8005e8 <umain+0x548>
		panic("creat /big: %e", f);
  8005c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cc:	c7 44 24 08 89 2f 80 	movl   $0x802f89,0x8(%esp)
  8005d3:	00 
  8005d4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8005db:	00 
  8005dc:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8005e3:	e8 fc 01 00 00       	call   8007e4 <_panic>
	memset(buf, 0, sizeof(buf));
  8005e8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8005ef:	00 
  8005f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8005f7:	00 
  8005f8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	e8 a1 0a 00 00       	call   8010a7 <memset>
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800606:	bb 00 00 00 00       	mov    $0x0,%ebx
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
  80060b:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  800611:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800617:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80061e:	00 
  80061f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800623:	89 34 24             	mov    %esi,(%esp)
  800626:	e8 9c 15 00 00       	call   801bc7 <write>
  80062b:	85 c0                	test   %eax,%eax
  80062d:	79 24                	jns    800653 <umain+0x5b3>
			panic("write /big@%d: %e", i, r);
  80062f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800633:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800637:	c7 44 24 08 98 2f 80 	movl   $0x802f98,0x8(%esp)
  80063e:	00 
  80063f:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  800646:	00 
  800647:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80064e:	e8 91 01 00 00       	call   8007e4 <_panic>
  800653:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  800659:	89 c3                	mov    %eax,%ebx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80065b:	3d 00 e0 01 00       	cmp    $0x1e000,%eax
  800660:	75 af                	jne    800611 <umain+0x571>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800662:	89 34 24             	mov    %esi,(%esp)
  800665:	e8 1d 13 00 00       	call   801987 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80066a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800671:	00 
  800672:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800679:	e8 b6 19 00 00       	call   802034 <open>
  80067e:	89 c6                	mov    %eax,%esi
  800680:	85 c0                	test   %eax,%eax
  800682:	79 20                	jns    8006a4 <umain+0x604>
		panic("open /big: %e", f);
  800684:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800688:	c7 44 24 08 aa 2f 80 	movl   $0x802faa,0x8(%esp)
  80068f:	00 
  800690:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  800697:	00 
  800698:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80069f:	e8 40 01 00 00       	call   8007e4 <_panic>
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
  8006a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006a9:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  8006af:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006b5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8006bc:	00 
  8006bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c1:	89 34 24             	mov    %esi,(%esp)
  8006c4:	e8 b3 14 00 00       	call   801b7c <readn>
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	79 24                	jns    8006f1 <umain+0x651>
			panic("read /big@%d: %e", i, r);
  8006cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006d5:	c7 44 24 08 b8 2f 80 	movl   $0x802fb8,0x8(%esp)
  8006dc:	00 
  8006dd:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8006e4:	00 
  8006e5:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  8006ec:	e8 f3 00 00 00       	call   8007e4 <_panic>
		if (r != sizeof(buf))
  8006f1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8006f6:	74 2c                	je     800724 <umain+0x684>
			panic("read /big from %d returned %d < %d bytes",
  8006f8:	c7 44 24 14 00 02 00 	movl   $0x200,0x14(%esp)
  8006ff:	00 
  800700:	89 44 24 10          	mov    %eax,0x10(%esp)
  800704:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800708:	c7 44 24 08 68 31 80 	movl   $0x803168,0x8(%esp)
  80070f:	00 
  800710:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  800717:	00 
  800718:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80071f:	e8 c0 00 00 00       	call   8007e4 <_panic>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800724:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  80072a:	39 d8                	cmp    %ebx,%eax
  80072c:	74 24                	je     800752 <umain+0x6b2>
			panic("read /big from %d returned bad data %d",
  80072e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800732:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800736:	c7 44 24 08 94 31 80 	movl   $0x803194,0x8(%esp)
  80073d:	00 
  80073e:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800745:	00 
  800746:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  80074d:	e8 92 00 00 00       	call   8007e4 <_panic>
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800752:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
  800758:	81 fb ff df 01 00    	cmp    $0x1dfff,%ebx
  80075e:	0f 8e 4b ff ff ff    	jle    8006af <umain+0x60f>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800764:	89 34 24             	mov    %esi,(%esp)
  800767:	e8 1b 12 00 00       	call   801987 <close>
	cprintf("large file is good\n");
  80076c:	c7 04 24 c9 2f 80 00 	movl   $0x802fc9,(%esp)
  800773:	e8 65 01 00 00       	call   8008dd <cprintf>
}
  800778:	81 c4 cc 02 00 00    	add    $0x2cc,%esp
  80077e:	5b                   	pop    %ebx
  80077f:	5e                   	pop    %esi
  800780:	5f                   	pop    %edi
  800781:	5d                   	pop    %ebp
  800782:	c3                   	ret    

00800783 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	56                   	push   %esi
  800787:	53                   	push   %ebx
  800788:	83 ec 10             	sub    $0x10,%esp
  80078b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80078e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800791:	e8 f1 0b 00 00       	call   801387 <sys_getenvid>
  800796:	25 ff 03 00 00       	and    $0x3ff,%eax
  80079b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80079e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007a3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007a8:	85 db                	test   %ebx,%ebx
  8007aa:	7e 07                	jle    8007b3 <libmain+0x30>
		binaryname = argv[0];
  8007ac:	8b 06                	mov    (%esi),%eax
  8007ae:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8007b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b7:	89 1c 24             	mov    %ebx,(%esp)
  8007ba:	e8 e1 f8 ff ff       	call   8000a0 <umain>

	// exit gracefully
	exit();
  8007bf:	e8 07 00 00 00       	call   8007cb <exit>
}
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	5b                   	pop    %ebx
  8007c8:	5e                   	pop    %esi
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8007d1:	e8 e4 11 00 00       	call   8019ba <close_all>
	sys_env_destroy(0);
  8007d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007dd:	e8 01 0b 00 00       	call   8012e3 <sys_env_destroy>
}
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    

008007e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	56                   	push   %esi
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8007ec:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007ef:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8007f5:	e8 8d 0b 00 00       	call   801387 <sys_getenvid>
  8007fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fd:	89 54 24 10          	mov    %edx,0x10(%esp)
  800801:	8b 55 08             	mov    0x8(%ebp),%edx
  800804:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800808:	89 74 24 08          	mov    %esi,0x8(%esp)
  80080c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800810:	c7 04 24 ec 31 80 00 	movl   $0x8031ec,(%esp)
  800817:	e8 c1 00 00 00       	call   8008dd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80081c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	89 04 24             	mov    %eax,(%esp)
  800826:	e8 51 00 00 00       	call   80087c <vcprintf>
	cprintf("\n");
  80082b:	c7 04 24 73 36 80 00 	movl   $0x803673,(%esp)
  800832:	e8 a6 00 00 00       	call   8008dd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800837:	cc                   	int3   
  800838:	eb fd                	jmp    800837 <_panic+0x53>

0080083a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	53                   	push   %ebx
  80083e:	83 ec 14             	sub    $0x14,%esp
  800841:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800844:	8b 13                	mov    (%ebx),%edx
  800846:	8d 42 01             	lea    0x1(%edx),%eax
  800849:	89 03                	mov    %eax,(%ebx)
  80084b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800852:	3d ff 00 00 00       	cmp    $0xff,%eax
  800857:	75 19                	jne    800872 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800859:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800860:	00 
  800861:	8d 43 08             	lea    0x8(%ebx),%eax
  800864:	89 04 24             	mov    %eax,(%esp)
  800867:	e8 3a 0a 00 00       	call   8012a6 <sys_cputs>
		b->idx = 0;
  80086c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800872:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800876:	83 c4 14             	add    $0x14,%esp
  800879:	5b                   	pop    %ebx
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800885:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80088c:	00 00 00 
	b.cnt = 0;
  80088f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800896:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b1:	c7 04 24 3a 08 80 00 	movl   $0x80083a,(%esp)
  8008b8:	e8 77 01 00 00       	call   800a34 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8008bd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008cd:	89 04 24             	mov    %eax,(%esp)
  8008d0:	e8 d1 09 00 00       	call   8012a6 <sys_cputs>

	return b.cnt;
}
  8008d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008e3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8008e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	89 04 24             	mov    %eax,(%esp)
  8008f0:	e8 87 ff ff ff       	call   80087c <vcprintf>
	va_end(ap);

	return cnt;
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    
  8008f7:	66 90                	xchg   %ax,%ax
  8008f9:	66 90                	xchg   %ax,%ax
  8008fb:	66 90                	xchg   %ax,%ax
  8008fd:	66 90                	xchg   %ax,%ax
  8008ff:	90                   	nop

00800900 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	57                   	push   %edi
  800904:	56                   	push   %esi
  800905:	53                   	push   %ebx
  800906:	83 ec 3c             	sub    $0x3c,%esp
  800909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090c:	89 d7                	mov    %edx,%edi
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	89 c3                	mov    %eax,%ebx
  800919:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80091c:	8b 45 10             	mov    0x10(%ebp),%eax
  80091f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800922:	b9 00 00 00 00       	mov    $0x0,%ecx
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80092d:	39 d9                	cmp    %ebx,%ecx
  80092f:	72 05                	jb     800936 <printnum+0x36>
  800931:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800934:	77 69                	ja     80099f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800936:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800939:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80093d:	83 ee 01             	sub    $0x1,%esi
  800940:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800944:	89 44 24 08          	mov    %eax,0x8(%esp)
  800948:	8b 44 24 08          	mov    0x8(%esp),%eax
  80094c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800950:	89 c3                	mov    %eax,%ebx
  800952:	89 d6                	mov    %edx,%esi
  800954:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800957:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80095a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80095e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800965:	89 04 24             	mov    %eax,(%esp)
  800968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096f:	e8 0c 22 00 00       	call   802b80 <__udivdi3>
  800974:	89 d9                	mov    %ebx,%ecx
  800976:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80097a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80097e:	89 04 24             	mov    %eax,(%esp)
  800981:	89 54 24 04          	mov    %edx,0x4(%esp)
  800985:	89 fa                	mov    %edi,%edx
  800987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80098a:	e8 71 ff ff ff       	call   800900 <printnum>
  80098f:	eb 1b                	jmp    8009ac <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800991:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800995:	8b 45 18             	mov    0x18(%ebp),%eax
  800998:	89 04 24             	mov    %eax,(%esp)
  80099b:	ff d3                	call   *%ebx
  80099d:	eb 03                	jmp    8009a2 <printnum+0xa2>
  80099f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a2:	83 ee 01             	sub    $0x1,%esi
  8009a5:	85 f6                	test   %esi,%esi
  8009a7:	7f e8                	jg     800991 <printnum+0x91>
  8009a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009b0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8009ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009be:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c5:	89 04 24             	mov    %eax,(%esp)
  8009c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cf:	e8 dc 22 00 00       	call   802cb0 <__umoddi3>
  8009d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009d8:	0f be 80 0f 32 80 00 	movsbl 0x80320f(%eax),%eax
  8009df:	89 04 24             	mov    %eax,(%esp)
  8009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
}
  8009e7:	83 c4 3c             	add    $0x3c,%esp
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8009f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8009f9:	8b 10                	mov    (%eax),%edx
  8009fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8009fe:	73 0a                	jae    800a0a <sprintputch+0x1b>
		*b->buf++ = ch;
  800a00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a03:	89 08                	mov    %ecx,(%eax)
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	88 02                	mov    %al,(%edx)
}
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a12:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a19:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	89 04 24             	mov    %eax,(%esp)
  800a2d:	e8 02 00 00 00       	call   800a34 <vprintfmt>
	va_end(ap);
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	83 ec 3c             	sub    $0x3c,%esp
  800a3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a40:	eb 17                	jmp    800a59 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800a42:	85 c0                	test   %eax,%eax
  800a44:	0f 84 4b 04 00 00    	je     800e95 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  800a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a51:	89 04 24             	mov    %eax,(%esp)
  800a54:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800a57:	89 fb                	mov    %edi,%ebx
  800a59:	8d 7b 01             	lea    0x1(%ebx),%edi
  800a5c:	0f b6 03             	movzbl (%ebx),%eax
  800a5f:	83 f8 25             	cmp    $0x25,%eax
  800a62:	75 de                	jne    800a42 <vprintfmt+0xe>
  800a64:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800a68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800a6f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800a74:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800a7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a80:	eb 18                	jmp    800a9a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a82:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800a84:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800a88:	eb 10                	jmp    800a9a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a8a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a8c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800a90:	eb 08                	jmp    800a9a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800a92:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a95:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a9a:	8d 5f 01             	lea    0x1(%edi),%ebx
  800a9d:	0f b6 17             	movzbl (%edi),%edx
  800aa0:	0f b6 c2             	movzbl %dl,%eax
  800aa3:	83 ea 23             	sub    $0x23,%edx
  800aa6:	80 fa 55             	cmp    $0x55,%dl
  800aa9:	0f 87 c2 03 00 00    	ja     800e71 <vprintfmt+0x43d>
  800aaf:	0f b6 d2             	movzbl %dl,%edx
  800ab2:	ff 24 95 60 33 80 00 	jmp    *0x803360(,%edx,4)
  800ab9:	89 df                	mov    %ebx,%edi
  800abb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800ac0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800ac3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800ac7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  800aca:	8d 50 d0             	lea    -0x30(%eax),%edx
  800acd:	83 fa 09             	cmp    $0x9,%edx
  800ad0:	77 33                	ja     800b05 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ad5:	eb e9                	jmp    800ac0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	8b 30                	mov    (%eax),%esi
  800adc:	8d 40 04             	lea    0x4(%eax),%eax
  800adf:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ae2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800ae4:	eb 1f                	jmp    800b05 <vprintfmt+0xd1>
  800ae6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800ae9:	85 ff                	test   %edi,%edi
  800aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  800af0:	0f 49 c7             	cmovns %edi,%eax
  800af3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800af6:	89 df                	mov    %ebx,%edi
  800af8:	eb a0                	jmp    800a9a <vprintfmt+0x66>
  800afa:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800afc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800b03:	eb 95                	jmp    800a9a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800b05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b09:	79 8f                	jns    800a9a <vprintfmt+0x66>
  800b0b:	eb 85                	jmp    800a92 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b0d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b10:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800b12:	eb 86                	jmp    800a9a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	8d 70 04             	lea    0x4(%eax),%esi
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	89 04 24             	mov    %eax,(%esp)
  800b29:	ff 55 08             	call   *0x8(%ebp)
  800b2c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  800b2f:	e9 25 ff ff ff       	jmp    800a59 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	8d 70 04             	lea    0x4(%eax),%esi
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	99                   	cltd   
  800b3d:	31 d0                	xor    %edx,%eax
  800b3f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b41:	83 f8 15             	cmp    $0x15,%eax
  800b44:	7f 0b                	jg     800b51 <vprintfmt+0x11d>
  800b46:	8b 14 85 c0 34 80 00 	mov    0x8034c0(,%eax,4),%edx
  800b4d:	85 d2                	test   %edx,%edx
  800b4f:	75 26                	jne    800b77 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800b51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b55:	c7 44 24 08 27 32 80 	movl   $0x803227,0x8(%esp)
  800b5c:	00 
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	89 04 24             	mov    %eax,(%esp)
  800b6a:	e8 9d fe ff ff       	call   800a0c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b6f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800b72:	e9 e2 fe ff ff       	jmp    800a59 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800b77:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b7b:	c7 44 24 08 42 36 80 	movl   $0x803642,0x8(%esp)
  800b82:	00 
  800b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 04 24             	mov    %eax,(%esp)
  800b90:	e8 77 fe ff ff       	call   800a0c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b95:	89 75 14             	mov    %esi,0x14(%ebp)
  800b98:	e9 bc fe ff ff       	jmp    800a59 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ba3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ba6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800baa:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800bac:	85 ff                	test   %edi,%edi
  800bae:	b8 20 32 80 00       	mov    $0x803220,%eax
  800bb3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800bb6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  800bba:	0f 84 94 00 00 00    	je     800c54 <vprintfmt+0x220>
  800bc0:	85 c9                	test   %ecx,%ecx
  800bc2:	0f 8e 94 00 00 00    	jle    800c5c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bc8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bcc:	89 3c 24             	mov    %edi,(%esp)
  800bcf:	e8 64 03 00 00       	call   800f38 <strnlen>
  800bd4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800bd7:	29 c1                	sub    %eax,%ecx
  800bd9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  800bdc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800be0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800be3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800be6:	8b 75 08             	mov    0x8(%ebp),%esi
  800be9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bec:	89 cb                	mov    %ecx,%ebx
  800bee:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf0:	eb 0f                	jmp    800c01 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf9:	89 3c 24             	mov    %edi,(%esp)
  800bfc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bfe:	83 eb 01             	sub    $0x1,%ebx
  800c01:	85 db                	test   %ebx,%ebx
  800c03:	7f ed                	jg     800bf2 <vprintfmt+0x1be>
  800c05:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800c08:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800c0b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800c0e:	85 c9                	test   %ecx,%ecx
  800c10:	b8 00 00 00 00       	mov    $0x0,%eax
  800c15:	0f 49 c1             	cmovns %ecx,%eax
  800c18:	29 c1                	sub    %eax,%ecx
  800c1a:	89 cb                	mov    %ecx,%ebx
  800c1c:	eb 44                	jmp    800c62 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800c1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c22:	74 1e                	je     800c42 <vprintfmt+0x20e>
  800c24:	0f be d2             	movsbl %dl,%edx
  800c27:	83 ea 20             	sub    $0x20,%edx
  800c2a:	83 fa 5e             	cmp    $0x5e,%edx
  800c2d:	76 13                	jbe    800c42 <vprintfmt+0x20e>
					putch('?', putdat);
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c36:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800c3d:	ff 55 08             	call   *0x8(%ebp)
  800c40:	eb 0d                	jmp    800c4f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800c42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c45:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c49:	89 04 24             	mov    %eax,(%esp)
  800c4c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c4f:	83 eb 01             	sub    $0x1,%ebx
  800c52:	eb 0e                	jmp    800c62 <vprintfmt+0x22e>
  800c54:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c57:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800c5a:	eb 06                	jmp    800c62 <vprintfmt+0x22e>
  800c5c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c5f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800c62:	83 c7 01             	add    $0x1,%edi
  800c65:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800c69:	0f be c2             	movsbl %dl,%eax
  800c6c:	85 c0                	test   %eax,%eax
  800c6e:	74 27                	je     800c97 <vprintfmt+0x263>
  800c70:	85 f6                	test   %esi,%esi
  800c72:	78 aa                	js     800c1e <vprintfmt+0x1ea>
  800c74:	83 ee 01             	sub    $0x1,%esi
  800c77:	79 a5                	jns    800c1e <vprintfmt+0x1ea>
  800c79:	89 d8                	mov    %ebx,%eax
  800c7b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c7e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c81:	89 c3                	mov    %eax,%ebx
  800c83:	eb 18                	jmp    800c9d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800c85:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c89:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800c90:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c92:	83 eb 01             	sub    $0x1,%ebx
  800c95:	eb 06                	jmp    800c9d <vprintfmt+0x269>
  800c97:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c9d:	85 db                	test   %ebx,%ebx
  800c9f:	7f e4                	jg     800c85 <vprintfmt+0x251>
  800ca1:	89 75 08             	mov    %esi,0x8(%ebp)
  800ca4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800ca7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800caa:	e9 aa fd ff ff       	jmp    800a59 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800caf:	83 f9 01             	cmp    $0x1,%ecx
  800cb2:	7e 10                	jle    800cc4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	8b 30                	mov    (%eax),%esi
  800cb9:	8b 78 04             	mov    0x4(%eax),%edi
  800cbc:	8d 40 08             	lea    0x8(%eax),%eax
  800cbf:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc2:	eb 26                	jmp    800cea <vprintfmt+0x2b6>
	else if (lflag)
  800cc4:	85 c9                	test   %ecx,%ecx
  800cc6:	74 12                	je     800cda <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800cc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccb:	8b 30                	mov    (%eax),%esi
  800ccd:	89 f7                	mov    %esi,%edi
  800ccf:	c1 ff 1f             	sar    $0x1f,%edi
  800cd2:	8d 40 04             	lea    0x4(%eax),%eax
  800cd5:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd8:	eb 10                	jmp    800cea <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	8b 30                	mov    (%eax),%esi
  800cdf:	89 f7                	mov    %esi,%edi
  800ce1:	c1 ff 1f             	sar    $0x1f,%edi
  800ce4:	8d 40 04             	lea    0x4(%eax),%eax
  800ce7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800cea:	89 f0                	mov    %esi,%eax
  800cec:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800cee:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800cf3:	85 ff                	test   %edi,%edi
  800cf5:	0f 89 3a 01 00 00    	jns    800e35 <vprintfmt+0x401>
				putch('-', putdat);
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d02:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800d09:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800d0c:	89 f0                	mov    %esi,%eax
  800d0e:	89 fa                	mov    %edi,%edx
  800d10:	f7 d8                	neg    %eax
  800d12:	83 d2 00             	adc    $0x0,%edx
  800d15:	f7 da                	neg    %edx
			}
			base = 10;
  800d17:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800d1c:	e9 14 01 00 00       	jmp    800e35 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800d21:	83 f9 01             	cmp    $0x1,%ecx
  800d24:	7e 13                	jle    800d39 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800d26:	8b 45 14             	mov    0x14(%ebp),%eax
  800d29:	8b 50 04             	mov    0x4(%eax),%edx
  800d2c:	8b 00                	mov    (%eax),%eax
  800d2e:	8b 75 14             	mov    0x14(%ebp),%esi
  800d31:	8d 4e 08             	lea    0x8(%esi),%ecx
  800d34:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800d37:	eb 2c                	jmp    800d65 <vprintfmt+0x331>
	else if (lflag)
  800d39:	85 c9                	test   %ecx,%ecx
  800d3b:	74 15                	je     800d52 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  800d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d40:	8b 00                	mov    (%eax),%eax
  800d42:	ba 00 00 00 00       	mov    $0x0,%edx
  800d47:	8b 75 14             	mov    0x14(%ebp),%esi
  800d4a:	8d 76 04             	lea    0x4(%esi),%esi
  800d4d:	89 75 14             	mov    %esi,0x14(%ebp)
  800d50:	eb 13                	jmp    800d65 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5c:	8b 75 14             	mov    0x14(%ebp),%esi
  800d5f:	8d 76 04             	lea    0x4(%esi),%esi
  800d62:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800d65:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800d6a:	e9 c6 00 00 00       	jmp    800e35 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800d6f:	83 f9 01             	cmp    $0x1,%ecx
  800d72:	7e 13                	jle    800d87 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800d74:	8b 45 14             	mov    0x14(%ebp),%eax
  800d77:	8b 50 04             	mov    0x4(%eax),%edx
  800d7a:	8b 00                	mov    (%eax),%eax
  800d7c:	8b 75 14             	mov    0x14(%ebp),%esi
  800d7f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800d82:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800d85:	eb 24                	jmp    800dab <vprintfmt+0x377>
	else if (lflag)
  800d87:	85 c9                	test   %ecx,%ecx
  800d89:	74 11                	je     800d9c <vprintfmt+0x368>
		return va_arg(*ap, long);
  800d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	99                   	cltd   
  800d91:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800d94:	8d 71 04             	lea    0x4(%ecx),%esi
  800d97:	89 75 14             	mov    %esi,0x14(%ebp)
  800d9a:	eb 0f                	jmp    800dab <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  800d9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9f:	8b 00                	mov    (%eax),%eax
  800da1:	99                   	cltd   
  800da2:	8b 75 14             	mov    0x14(%ebp),%esi
  800da5:	8d 76 04             	lea    0x4(%esi),%esi
  800da8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  800dab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800db0:	e9 80 00 00 00       	jmp    800e35 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dbf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800dc6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800dd7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800dda:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dde:	8b 06                	mov    (%esi),%eax
  800de0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800de5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800dea:	eb 49                	jmp    800e35 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800dec:	83 f9 01             	cmp    $0x1,%ecx
  800def:	7e 13                	jle    800e04 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800df1:	8b 45 14             	mov    0x14(%ebp),%eax
  800df4:	8b 50 04             	mov    0x4(%eax),%edx
  800df7:	8b 00                	mov    (%eax),%eax
  800df9:	8b 75 14             	mov    0x14(%ebp),%esi
  800dfc:	8d 4e 08             	lea    0x8(%esi),%ecx
  800dff:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800e02:	eb 2c                	jmp    800e30 <vprintfmt+0x3fc>
	else if (lflag)
  800e04:	85 c9                	test   %ecx,%ecx
  800e06:	74 15                	je     800e1d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800e08:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0b:	8b 00                	mov    (%eax),%eax
  800e0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e12:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800e15:	8d 71 04             	lea    0x4(%ecx),%esi
  800e18:	89 75 14             	mov    %esi,0x14(%ebp)
  800e1b:	eb 13                	jmp    800e30 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  800e1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e20:	8b 00                	mov    (%eax),%eax
  800e22:	ba 00 00 00 00       	mov    $0x0,%edx
  800e27:	8b 75 14             	mov    0x14(%ebp),%esi
  800e2a:	8d 76 04             	lea    0x4(%esi),%esi
  800e2d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800e30:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e35:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800e39:	89 74 24 10          	mov    %esi,0x10(%esp)
  800e3d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800e40:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800e44:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e48:	89 04 24             	mov    %eax,(%esp)
  800e4b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	e8 a6 fa ff ff       	call   800900 <printnum>
			break;
  800e5a:	e9 fa fb ff ff       	jmp    800a59 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e66:	89 04 24             	mov    %eax,(%esp)
  800e69:	ff 55 08             	call   *0x8(%ebp)
			break;
  800e6c:	e9 e8 fb ff ff       	jmp    800a59 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e78:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800e7f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e82:	89 fb                	mov    %edi,%ebx
  800e84:	eb 03                	jmp    800e89 <vprintfmt+0x455>
  800e86:	83 eb 01             	sub    $0x1,%ebx
  800e89:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800e8d:	75 f7                	jne    800e86 <vprintfmt+0x452>
  800e8f:	90                   	nop
  800e90:	e9 c4 fb ff ff       	jmp    800a59 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800e95:	83 c4 3c             	add    $0x3c,%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    

00800e9d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 28             	sub    $0x28,%esp
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eac:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800eb0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800eb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	74 30                	je     800eee <vsnprintf+0x51>
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	7e 2c                	jle    800eee <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ed0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ed3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ed7:	c7 04 24 ef 09 80 00 	movl   $0x8009ef,(%esp)
  800ede:	e8 51 fb ff ff       	call   800a34 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ee6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	eb 05                	jmp    800ef3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800eee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800efb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800efe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f02:	8b 45 10             	mov    0x10(%ebp),%eax
  800f05:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	89 04 24             	mov    %eax,(%esp)
  800f16:	e8 82 ff ff ff       	call   800e9d <vsnprintf>
	va_end(ap);

	return rc;
}
  800f1b:	c9                   	leave  
  800f1c:	c3                   	ret    
  800f1d:	66 90                	xchg   %ax,%ax
  800f1f:	90                   	nop

00800f20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f26:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2b:	eb 03                	jmp    800f30 <strlen+0x10>
		n++;
  800f2d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f30:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f34:	75 f7                	jne    800f2d <strlen+0xd>
		n++;
	return n;
}
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f41:	b8 00 00 00 00       	mov    $0x0,%eax
  800f46:	eb 03                	jmp    800f4b <strnlen+0x13>
		n++;
  800f48:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f4b:	39 d0                	cmp    %edx,%eax
  800f4d:	74 06                	je     800f55 <strnlen+0x1d>
  800f4f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800f53:	75 f3                	jne    800f48 <strnlen+0x10>
		n++;
	return n;
}
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	53                   	push   %ebx
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f61:	89 c2                	mov    %eax,%edx
  800f63:	83 c2 01             	add    $0x1,%edx
  800f66:	83 c1 01             	add    $0x1,%ecx
  800f69:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800f6d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f70:	84 db                	test   %bl,%bl
  800f72:	75 ef                	jne    800f63 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800f74:	5b                   	pop    %ebx
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	53                   	push   %ebx
  800f7b:	83 ec 08             	sub    $0x8,%esp
  800f7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f81:	89 1c 24             	mov    %ebx,(%esp)
  800f84:	e8 97 ff ff ff       	call   800f20 <strlen>
	strcpy(dst + len, src);
  800f89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f90:	01 d8                	add    %ebx,%eax
  800f92:	89 04 24             	mov    %eax,(%esp)
  800f95:	e8 bd ff ff ff       	call   800f57 <strcpy>
	return dst;
}
  800f9a:	89 d8                	mov    %ebx,%eax
  800f9c:	83 c4 08             	add    $0x8,%esp
  800f9f:	5b                   	pop    %ebx
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    

00800fa2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
  800fa7:	8b 75 08             	mov    0x8(%ebp),%esi
  800faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fad:	89 f3                	mov    %esi,%ebx
  800faf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fb2:	89 f2                	mov    %esi,%edx
  800fb4:	eb 0f                	jmp    800fc5 <strncpy+0x23>
		*dst++ = *src;
  800fb6:	83 c2 01             	add    $0x1,%edx
  800fb9:	0f b6 01             	movzbl (%ecx),%eax
  800fbc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800fbf:	80 39 01             	cmpb   $0x1,(%ecx)
  800fc2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fc5:	39 da                	cmp    %ebx,%edx
  800fc7:	75 ed                	jne    800fb6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800fc9:	89 f0                	mov    %esi,%eax
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	8b 75 08             	mov    0x8(%ebp),%esi
  800fd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800fdd:	89 f0                	mov    %esi,%eax
  800fdf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800fe3:	85 c9                	test   %ecx,%ecx
  800fe5:	75 0b                	jne    800ff2 <strlcpy+0x23>
  800fe7:	eb 1d                	jmp    801006 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800fe9:	83 c0 01             	add    $0x1,%eax
  800fec:	83 c2 01             	add    $0x1,%edx
  800fef:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ff2:	39 d8                	cmp    %ebx,%eax
  800ff4:	74 0b                	je     801001 <strlcpy+0x32>
  800ff6:	0f b6 0a             	movzbl (%edx),%ecx
  800ff9:	84 c9                	test   %cl,%cl
  800ffb:	75 ec                	jne    800fe9 <strlcpy+0x1a>
  800ffd:	89 c2                	mov    %eax,%edx
  800fff:	eb 02                	jmp    801003 <strlcpy+0x34>
  801001:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801003:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801006:	29 f0                	sub    %esi,%eax
}
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801012:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801015:	eb 06                	jmp    80101d <strcmp+0x11>
		p++, q++;
  801017:	83 c1 01             	add    $0x1,%ecx
  80101a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80101d:	0f b6 01             	movzbl (%ecx),%eax
  801020:	84 c0                	test   %al,%al
  801022:	74 04                	je     801028 <strcmp+0x1c>
  801024:	3a 02                	cmp    (%edx),%al
  801026:	74 ef                	je     801017 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801028:	0f b6 c0             	movzbl %al,%eax
  80102b:	0f b6 12             	movzbl (%edx),%edx
  80102e:	29 d0                	sub    %edx,%eax
}
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    

00801032 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	53                   	push   %ebx
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103c:	89 c3                	mov    %eax,%ebx
  80103e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801041:	eb 06                	jmp    801049 <strncmp+0x17>
		n--, p++, q++;
  801043:	83 c0 01             	add    $0x1,%eax
  801046:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801049:	39 d8                	cmp    %ebx,%eax
  80104b:	74 15                	je     801062 <strncmp+0x30>
  80104d:	0f b6 08             	movzbl (%eax),%ecx
  801050:	84 c9                	test   %cl,%cl
  801052:	74 04                	je     801058 <strncmp+0x26>
  801054:	3a 0a                	cmp    (%edx),%cl
  801056:	74 eb                	je     801043 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801058:	0f b6 00             	movzbl (%eax),%eax
  80105b:	0f b6 12             	movzbl (%edx),%edx
  80105e:	29 d0                	sub    %edx,%eax
  801060:	eb 05                	jmp    801067 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801062:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801067:	5b                   	pop    %ebx
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801074:	eb 07                	jmp    80107d <strchr+0x13>
		if (*s == c)
  801076:	38 ca                	cmp    %cl,%dl
  801078:	74 0f                	je     801089 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80107a:	83 c0 01             	add    $0x1,%eax
  80107d:	0f b6 10             	movzbl (%eax),%edx
  801080:	84 d2                	test   %dl,%dl
  801082:	75 f2                	jne    801076 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801084:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801095:	eb 07                	jmp    80109e <strfind+0x13>
		if (*s == c)
  801097:	38 ca                	cmp    %cl,%dl
  801099:	74 0a                	je     8010a5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80109b:	83 c0 01             	add    $0x1,%eax
  80109e:	0f b6 10             	movzbl (%eax),%edx
  8010a1:	84 d2                	test   %dl,%dl
  8010a3:	75 f2                	jne    801097 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	57                   	push   %edi
  8010ab:	56                   	push   %esi
  8010ac:	53                   	push   %ebx
  8010ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8010b3:	85 c9                	test   %ecx,%ecx
  8010b5:	74 36                	je     8010ed <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8010b7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8010bd:	75 28                	jne    8010e7 <memset+0x40>
  8010bf:	f6 c1 03             	test   $0x3,%cl
  8010c2:	75 23                	jne    8010e7 <memset+0x40>
		c &= 0xFF;
  8010c4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010c8:	89 d3                	mov    %edx,%ebx
  8010ca:	c1 e3 08             	shl    $0x8,%ebx
  8010cd:	89 d6                	mov    %edx,%esi
  8010cf:	c1 e6 18             	shl    $0x18,%esi
  8010d2:	89 d0                	mov    %edx,%eax
  8010d4:	c1 e0 10             	shl    $0x10,%eax
  8010d7:	09 f0                	or     %esi,%eax
  8010d9:	09 c2                	or     %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8010df:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010e2:	fc                   	cld    
  8010e3:	f3 ab                	rep stos %eax,%es:(%edi)
  8010e5:	eb 06                	jmp    8010ed <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	fc                   	cld    
  8010eb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8010ed:	89 f8                	mov    %edi,%eax
  8010ef:	5b                   	pop    %ebx
  8010f0:	5e                   	pop    %esi
  8010f1:	5f                   	pop    %edi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	57                   	push   %edi
  8010f8:	56                   	push   %esi
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801102:	39 c6                	cmp    %eax,%esi
  801104:	73 35                	jae    80113b <memmove+0x47>
  801106:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801109:	39 d0                	cmp    %edx,%eax
  80110b:	73 2e                	jae    80113b <memmove+0x47>
		s += n;
		d += n;
  80110d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801110:	89 d6                	mov    %edx,%esi
  801112:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801114:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80111a:	75 13                	jne    80112f <memmove+0x3b>
  80111c:	f6 c1 03             	test   $0x3,%cl
  80111f:	75 0e                	jne    80112f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801121:	83 ef 04             	sub    $0x4,%edi
  801124:	8d 72 fc             	lea    -0x4(%edx),%esi
  801127:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80112a:	fd                   	std    
  80112b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80112d:	eb 09                	jmp    801138 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80112f:	83 ef 01             	sub    $0x1,%edi
  801132:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801135:	fd                   	std    
  801136:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801138:	fc                   	cld    
  801139:	eb 1d                	jmp    801158 <memmove+0x64>
  80113b:	89 f2                	mov    %esi,%edx
  80113d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80113f:	f6 c2 03             	test   $0x3,%dl
  801142:	75 0f                	jne    801153 <memmove+0x5f>
  801144:	f6 c1 03             	test   $0x3,%cl
  801147:	75 0a                	jne    801153 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801149:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80114c:	89 c7                	mov    %eax,%edi
  80114e:	fc                   	cld    
  80114f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801151:	eb 05                	jmp    801158 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801153:	89 c7                	mov    %eax,%edi
  801155:	fc                   	cld    
  801156:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	89 44 24 08          	mov    %eax,0x8(%esp)
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	89 04 24             	mov    %eax,(%esp)
  801176:	e8 79 ff ff ff       	call   8010f4 <memmove>
}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	56                   	push   %esi
  801181:	53                   	push   %ebx
  801182:	8b 55 08             	mov    0x8(%ebp),%edx
  801185:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801188:	89 d6                	mov    %edx,%esi
  80118a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80118d:	eb 1a                	jmp    8011a9 <memcmp+0x2c>
		if (*s1 != *s2)
  80118f:	0f b6 02             	movzbl (%edx),%eax
  801192:	0f b6 19             	movzbl (%ecx),%ebx
  801195:	38 d8                	cmp    %bl,%al
  801197:	74 0a                	je     8011a3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801199:	0f b6 c0             	movzbl %al,%eax
  80119c:	0f b6 db             	movzbl %bl,%ebx
  80119f:	29 d8                	sub    %ebx,%eax
  8011a1:	eb 0f                	jmp    8011b2 <memcmp+0x35>
		s1++, s2++;
  8011a3:	83 c2 01             	add    $0x1,%edx
  8011a6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8011a9:	39 f2                	cmp    %esi,%edx
  8011ab:	75 e2                	jne    80118f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b2:	5b                   	pop    %ebx
  8011b3:	5e                   	pop    %esi
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8011bf:	89 c2                	mov    %eax,%edx
  8011c1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8011c4:	eb 07                	jmp    8011cd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011c6:	38 08                	cmp    %cl,(%eax)
  8011c8:	74 07                	je     8011d1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ca:	83 c0 01             	add    $0x1,%eax
  8011cd:	39 d0                	cmp    %edx,%eax
  8011cf:	72 f5                	jb     8011c6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	57                   	push   %edi
  8011d7:	56                   	push   %esi
  8011d8:	53                   	push   %ebx
  8011d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011dc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011df:	eb 03                	jmp    8011e4 <strtol+0x11>
		s++;
  8011e1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e4:	0f b6 0a             	movzbl (%edx),%ecx
  8011e7:	80 f9 09             	cmp    $0x9,%cl
  8011ea:	74 f5                	je     8011e1 <strtol+0xe>
  8011ec:	80 f9 20             	cmp    $0x20,%cl
  8011ef:	74 f0                	je     8011e1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011f1:	80 f9 2b             	cmp    $0x2b,%cl
  8011f4:	75 0a                	jne    801200 <strtol+0x2d>
		s++;
  8011f6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8011f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8011fe:	eb 11                	jmp    801211 <strtol+0x3e>
  801200:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801205:	80 f9 2d             	cmp    $0x2d,%cl
  801208:	75 07                	jne    801211 <strtol+0x3e>
		s++, neg = 1;
  80120a:	8d 52 01             	lea    0x1(%edx),%edx
  80120d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801211:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801216:	75 15                	jne    80122d <strtol+0x5a>
  801218:	80 3a 30             	cmpb   $0x30,(%edx)
  80121b:	75 10                	jne    80122d <strtol+0x5a>
  80121d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801221:	75 0a                	jne    80122d <strtol+0x5a>
		s += 2, base = 16;
  801223:	83 c2 02             	add    $0x2,%edx
  801226:	b8 10 00 00 00       	mov    $0x10,%eax
  80122b:	eb 10                	jmp    80123d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80122d:	85 c0                	test   %eax,%eax
  80122f:	75 0c                	jne    80123d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801231:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801233:	80 3a 30             	cmpb   $0x30,(%edx)
  801236:	75 05                	jne    80123d <strtol+0x6a>
		s++, base = 8;
  801238:	83 c2 01             	add    $0x1,%edx
  80123b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80123d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801242:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801245:	0f b6 0a             	movzbl (%edx),%ecx
  801248:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80124b:	89 f0                	mov    %esi,%eax
  80124d:	3c 09                	cmp    $0x9,%al
  80124f:	77 08                	ja     801259 <strtol+0x86>
			dig = *s - '0';
  801251:	0f be c9             	movsbl %cl,%ecx
  801254:	83 e9 30             	sub    $0x30,%ecx
  801257:	eb 20                	jmp    801279 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801259:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80125c:	89 f0                	mov    %esi,%eax
  80125e:	3c 19                	cmp    $0x19,%al
  801260:	77 08                	ja     80126a <strtol+0x97>
			dig = *s - 'a' + 10;
  801262:	0f be c9             	movsbl %cl,%ecx
  801265:	83 e9 57             	sub    $0x57,%ecx
  801268:	eb 0f                	jmp    801279 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80126a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80126d:	89 f0                	mov    %esi,%eax
  80126f:	3c 19                	cmp    $0x19,%al
  801271:	77 16                	ja     801289 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801273:	0f be c9             	movsbl %cl,%ecx
  801276:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801279:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80127c:	7d 0f                	jge    80128d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80127e:	83 c2 01             	add    $0x1,%edx
  801281:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801285:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801287:	eb bc                	jmp    801245 <strtol+0x72>
  801289:	89 d8                	mov    %ebx,%eax
  80128b:	eb 02                	jmp    80128f <strtol+0xbc>
  80128d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80128f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801293:	74 05                	je     80129a <strtol+0xc7>
		*endptr = (char *) s;
  801295:	8b 75 0c             	mov    0xc(%ebp),%esi
  801298:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80129a:	f7 d8                	neg    %eax
  80129c:	85 ff                	test   %edi,%edi
  80129e:	0f 44 c3             	cmove  %ebx,%eax
}
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    

008012a6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	57                   	push   %edi
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b7:	89 c3                	mov    %eax,%ebx
  8012b9:	89 c7                	mov    %eax,%edi
  8012bb:	89 c6                	mov    %eax,%esi
  8012bd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5f                   	pop    %edi
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    

008012c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	57                   	push   %edi
  8012c8:	56                   	push   %esi
  8012c9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8012cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8012d4:	89 d1                	mov    %edx,%ecx
  8012d6:	89 d3                	mov    %edx,%ebx
  8012d8:	89 d7                	mov    %edx,%edi
  8012da:	89 d6                	mov    %edx,%esi
  8012dc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8012de:	5b                   	pop    %ebx
  8012df:	5e                   	pop    %esi
  8012e0:	5f                   	pop    %edi
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	57                   	push   %edi
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8012f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f9:	89 cb                	mov    %ecx,%ebx
  8012fb:	89 cf                	mov    %ecx,%edi
  8012fd:	89 ce                	mov    %ecx,%esi
  8012ff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801301:	85 c0                	test   %eax,%eax
  801303:	7e 28                	jle    80132d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801305:	89 44 24 10          	mov    %eax,0x10(%esp)
  801309:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801310:	00 
  801311:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  801318:	00 
  801319:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801320:	00 
  801321:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  801328:	e8 b7 f4 ff ff       	call   8007e4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80132d:	83 c4 2c             	add    $0x2c,%esp
  801330:	5b                   	pop    %ebx
  801331:	5e                   	pop    %esi
  801332:	5f                   	pop    %edi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	57                   	push   %edi
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80133e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801343:	b8 04 00 00 00       	mov    $0x4,%eax
  801348:	8b 55 08             	mov    0x8(%ebp),%edx
  80134b:	89 cb                	mov    %ecx,%ebx
  80134d:	89 cf                	mov    %ecx,%edi
  80134f:	89 ce                	mov    %ecx,%esi
  801351:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801353:	85 c0                	test   %eax,%eax
  801355:	7e 28                	jle    80137f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801357:	89 44 24 10          	mov    %eax,0x10(%esp)
  80135b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801362:	00 
  801363:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  80136a:	00 
  80136b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801372:	00 
  801373:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  80137a:	e8 65 f4 ff ff       	call   8007e4 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  80137f:	83 c4 2c             	add    $0x2c,%esp
  801382:	5b                   	pop    %ebx
  801383:	5e                   	pop    %esi
  801384:	5f                   	pop    %edi
  801385:	5d                   	pop    %ebp
  801386:	c3                   	ret    

00801387 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	57                   	push   %edi
  80138b:	56                   	push   %esi
  80138c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80138d:	ba 00 00 00 00       	mov    $0x0,%edx
  801392:	b8 02 00 00 00       	mov    $0x2,%eax
  801397:	89 d1                	mov    %edx,%ecx
  801399:	89 d3                	mov    %edx,%ebx
  80139b:	89 d7                	mov    %edx,%edi
  80139d:	89 d6                	mov    %edx,%esi
  80139f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013a1:	5b                   	pop    %ebx
  8013a2:	5e                   	pop    %esi
  8013a3:	5f                   	pop    %edi
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <sys_yield>:

void
sys_yield(void)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	57                   	push   %edi
  8013aa:	56                   	push   %esi
  8013ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8013b6:	89 d1                	mov    %edx,%ecx
  8013b8:	89 d3                	mov    %edx,%ebx
  8013ba:	89 d7                	mov    %edx,%edi
  8013bc:	89 d6                	mov    %edx,%esi
  8013be:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5f                   	pop    %edi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    

008013c5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	57                   	push   %edi
  8013c9:	56                   	push   %esi
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ce:	be 00 00 00 00       	mov    $0x0,%esi
  8013d3:	b8 05 00 00 00       	mov    $0x5,%eax
  8013d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013db:	8b 55 08             	mov    0x8(%ebp),%edx
  8013de:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013e1:	89 f7                	mov    %esi,%edi
  8013e3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	7e 28                	jle    801411 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013ed:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8013f4:	00 
  8013f5:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  8013fc:	00 
  8013fd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801404:	00 
  801405:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  80140c:	e8 d3 f3 ff ff       	call   8007e4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801411:	83 c4 2c             	add    $0x2c,%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5f                   	pop    %edi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	57                   	push   %edi
  80141d:	56                   	push   %esi
  80141e:	53                   	push   %ebx
  80141f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801422:	b8 06 00 00 00       	mov    $0x6,%eax
  801427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142a:	8b 55 08             	mov    0x8(%ebp),%edx
  80142d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801430:	8b 7d 14             	mov    0x14(%ebp),%edi
  801433:	8b 75 18             	mov    0x18(%ebp),%esi
  801436:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801438:	85 c0                	test   %eax,%eax
  80143a:	7e 28                	jle    801464 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80143c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801440:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801447:	00 
  801448:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  80144f:	00 
  801450:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801457:	00 
  801458:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  80145f:	e8 80 f3 ff ff       	call   8007e4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801464:	83 c4 2c             	add    $0x2c,%esp
  801467:	5b                   	pop    %ebx
  801468:	5e                   	pop    %esi
  801469:	5f                   	pop    %edi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    

0080146c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	57                   	push   %edi
  801470:	56                   	push   %esi
  801471:	53                   	push   %ebx
  801472:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147a:	b8 07 00 00 00       	mov    $0x7,%eax
  80147f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801482:	8b 55 08             	mov    0x8(%ebp),%edx
  801485:	89 df                	mov    %ebx,%edi
  801487:	89 de                	mov    %ebx,%esi
  801489:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80148b:	85 c0                	test   %eax,%eax
  80148d:	7e 28                	jle    8014b7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80148f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801493:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80149a:	00 
  80149b:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  8014a2:	00 
  8014a3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014aa:	00 
  8014ab:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  8014b2:	e8 2d f3 ff ff       	call   8007e4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8014b7:	83 c4 2c             	add    $0x2c,%esp
  8014ba:	5b                   	pop    %ebx
  8014bb:	5e                   	pop    %esi
  8014bc:	5f                   	pop    %edi
  8014bd:	5d                   	pop    %ebp
  8014be:	c3                   	ret    

008014bf <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	57                   	push   %edi
  8014c3:	56                   	push   %esi
  8014c4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014ca:	b8 10 00 00 00       	mov    $0x10,%eax
  8014cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d2:	89 cb                	mov    %ecx,%ebx
  8014d4:	89 cf                	mov    %ecx,%edi
  8014d6:	89 ce                	mov    %ecx,%esi
  8014d8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5f                   	pop    %edi
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    

008014df <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	57                   	push   %edi
  8014e3:	56                   	push   %esi
  8014e4:	53                   	push   %ebx
  8014e5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ed:	b8 09 00 00 00       	mov    $0x9,%eax
  8014f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f8:	89 df                	mov    %ebx,%edi
  8014fa:	89 de                	mov    %ebx,%esi
  8014fc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014fe:	85 c0                	test   %eax,%eax
  801500:	7e 28                	jle    80152a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801502:	89 44 24 10          	mov    %eax,0x10(%esp)
  801506:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80150d:	00 
  80150e:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  801515:	00 
  801516:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80151d:	00 
  80151e:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  801525:	e8 ba f2 ff ff       	call   8007e4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80152a:	83 c4 2c             	add    $0x2c,%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5e                   	pop    %esi
  80152f:	5f                   	pop    %edi
  801530:	5d                   	pop    %ebp
  801531:	c3                   	ret    

00801532 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	57                   	push   %edi
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80153b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801540:	b8 0a 00 00 00       	mov    $0xa,%eax
  801545:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801548:	8b 55 08             	mov    0x8(%ebp),%edx
  80154b:	89 df                	mov    %ebx,%edi
  80154d:	89 de                	mov    %ebx,%esi
  80154f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801551:	85 c0                	test   %eax,%eax
  801553:	7e 28                	jle    80157d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801555:	89 44 24 10          	mov    %eax,0x10(%esp)
  801559:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801560:	00 
  801561:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  801568:	00 
  801569:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801570:	00 
  801571:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  801578:	e8 67 f2 ff ff       	call   8007e4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80157d:	83 c4 2c             	add    $0x2c,%esp
  801580:	5b                   	pop    %ebx
  801581:	5e                   	pop    %esi
  801582:	5f                   	pop    %edi
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	57                   	push   %edi
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
  80158b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80158e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801593:	b8 0b 00 00 00       	mov    $0xb,%eax
  801598:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80159b:	8b 55 08             	mov    0x8(%ebp),%edx
  80159e:	89 df                	mov    %ebx,%edi
  8015a0:	89 de                	mov    %ebx,%esi
  8015a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	7e 28                	jle    8015d0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015ac:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8015b3:	00 
  8015b4:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  8015bb:	00 
  8015bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015c3:	00 
  8015c4:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  8015cb:	e8 14 f2 ff ff       	call   8007e4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8015d0:	83 c4 2c             	add    $0x2c,%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5e                   	pop    %esi
  8015d5:	5f                   	pop    %edi
  8015d6:	5d                   	pop    %ebp
  8015d7:	c3                   	ret    

008015d8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	57                   	push   %edi
  8015dc:	56                   	push   %esi
  8015dd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015de:	be 00 00 00 00       	mov    $0x0,%esi
  8015e3:	b8 0d 00 00 00       	mov    $0xd,%eax
  8015e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015f1:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015f4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8015f6:	5b                   	pop    %ebx
  8015f7:	5e                   	pop    %esi
  8015f8:	5f                   	pop    %edi
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    

008015fb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	57                   	push   %edi
  8015ff:	56                   	push   %esi
  801600:	53                   	push   %ebx
  801601:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801604:	b9 00 00 00 00       	mov    $0x0,%ecx
  801609:	b8 0e 00 00 00       	mov    $0xe,%eax
  80160e:	8b 55 08             	mov    0x8(%ebp),%edx
  801611:	89 cb                	mov    %ecx,%ebx
  801613:	89 cf                	mov    %ecx,%edi
  801615:	89 ce                	mov    %ecx,%esi
  801617:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801619:	85 c0                	test   %eax,%eax
  80161b:	7e 28                	jle    801645 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80161d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801621:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801628:	00 
  801629:	c7 44 24 08 37 35 80 	movl   $0x803537,0x8(%esp)
  801630:	00 
  801631:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801638:	00 
  801639:	c7 04 24 54 35 80 00 	movl   $0x803554,(%esp)
  801640:	e8 9f f1 ff ff       	call   8007e4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801645:	83 c4 2c             	add    $0x2c,%esp
  801648:	5b                   	pop    %ebx
  801649:	5e                   	pop    %esi
  80164a:	5f                   	pop    %edi
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    

0080164d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	57                   	push   %edi
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801653:	ba 00 00 00 00       	mov    $0x0,%edx
  801658:	b8 0f 00 00 00       	mov    $0xf,%eax
  80165d:	89 d1                	mov    %edx,%ecx
  80165f:	89 d3                	mov    %edx,%ebx
  801661:	89 d7                	mov    %edx,%edi
  801663:	89 d6                	mov    %edx,%esi
  801665:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801667:	5b                   	pop    %ebx
  801668:	5e                   	pop    %esi
  801669:	5f                   	pop    %edi
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	57                   	push   %edi
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801672:	bb 00 00 00 00       	mov    $0x0,%ebx
  801677:	b8 11 00 00 00       	mov    $0x11,%eax
  80167c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167f:	8b 55 08             	mov    0x8(%ebp),%edx
  801682:	89 df                	mov    %ebx,%edi
  801684:	89 de                	mov    %ebx,%esi
  801686:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801688:	5b                   	pop    %ebx
  801689:	5e                   	pop    %esi
  80168a:	5f                   	pop    %edi
  80168b:	5d                   	pop    %ebp
  80168c:	c3                   	ret    

0080168d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	57                   	push   %edi
  801691:	56                   	push   %esi
  801692:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801693:	bb 00 00 00 00       	mov    $0x0,%ebx
  801698:	b8 12 00 00 00       	mov    $0x12,%eax
  80169d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a3:	89 df                	mov    %ebx,%edi
  8016a5:	89 de                	mov    %ebx,%esi
  8016a7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8016a9:	5b                   	pop    %ebx
  8016aa:	5e                   	pop    %esi
  8016ab:	5f                   	pop    %edi
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    

008016ae <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	57                   	push   %edi
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b9:	b8 13 00 00 00       	mov    $0x13,%eax
  8016be:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c1:	89 cb                	mov    %ecx,%ebx
  8016c3:	89 cf                	mov    %ecx,%edi
  8016c5:	89 ce                	mov    %ecx,%esi
  8016c7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8016c9:	5b                   	pop    %ebx
  8016ca:	5e                   	pop    %esi
  8016cb:	5f                   	pop    %edi
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    
  8016ce:	66 90                	xchg   %ax,%ax

008016d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	83 ec 10             	sub    $0x10,%esp
  8016d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8016db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8016e1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8016e3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8016e8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8016eb:	89 04 24             	mov    %eax,(%esp)
  8016ee:	e8 08 ff ff ff       	call   8015fb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	75 26                	jne    80171d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8016f7:	85 f6                	test   %esi,%esi
  8016f9:	74 0a                	je     801705 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8016fb:	a1 08 50 80 00       	mov    0x805008,%eax
  801700:	8b 40 74             	mov    0x74(%eax),%eax
  801703:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  801705:	85 db                	test   %ebx,%ebx
  801707:	74 0a                	je     801713 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  801709:	a1 08 50 80 00       	mov    0x805008,%eax
  80170e:	8b 40 78             	mov    0x78(%eax),%eax
  801711:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801713:	a1 08 50 80 00       	mov    0x805008,%eax
  801718:	8b 40 70             	mov    0x70(%eax),%eax
  80171b:	eb 14                	jmp    801731 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80171d:	85 f6                	test   %esi,%esi
  80171f:	74 06                	je     801727 <ipc_recv+0x57>
			*from_env_store = 0;
  801721:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801727:	85 db                	test   %ebx,%ebx
  801729:	74 06                	je     801731 <ipc_recv+0x61>
			*perm_store = 0;
  80172b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	5b                   	pop    %ebx
  801735:	5e                   	pop    %esi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	57                   	push   %edi
  80173c:	56                   	push   %esi
  80173d:	53                   	push   %ebx
  80173e:	83 ec 1c             	sub    $0x1c,%esp
  801741:	8b 7d 08             	mov    0x8(%ebp),%edi
  801744:	8b 75 0c             	mov    0xc(%ebp),%esi
  801747:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80174a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80174c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801751:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801754:	8b 45 14             	mov    0x14(%ebp),%eax
  801757:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80175b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80175f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801763:	89 3c 24             	mov    %edi,(%esp)
  801766:	e8 6d fe ff ff       	call   8015d8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80176b:	85 c0                	test   %eax,%eax
  80176d:	74 28                	je     801797 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80176f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801772:	74 1c                	je     801790 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  801774:	c7 44 24 08 64 35 80 	movl   $0x803564,0x8(%esp)
  80177b:	00 
  80177c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801783:	00 
  801784:	c7 04 24 85 35 80 00 	movl   $0x803585,(%esp)
  80178b:	e8 54 f0 ff ff       	call   8007e4 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  801790:	e8 11 fc ff ff       	call   8013a6 <sys_yield>
	}
  801795:	eb bd                	jmp    801754 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  801797:	83 c4 1c             	add    $0x1c,%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5f                   	pop    %edi
  80179d:	5d                   	pop    %ebp
  80179e:	c3                   	ret    

0080179f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8017aa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8017ad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8017b3:	8b 52 50             	mov    0x50(%edx),%edx
  8017b6:	39 ca                	cmp    %ecx,%edx
  8017b8:	75 0d                	jne    8017c7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8017ba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8017bd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8017c2:	8b 40 40             	mov    0x40(%eax),%eax
  8017c5:	eb 0e                	jmp    8017d5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8017c7:	83 c0 01             	add    $0x1,%eax
  8017ca:	3d 00 04 00 00       	cmp    $0x400,%eax
  8017cf:	75 d9                	jne    8017aa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8017d1:	66 b8 00 00          	mov    $0x0,%ax
}
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    
  8017d7:	66 90                	xchg   %ax,%ax
  8017d9:	66 90                	xchg   %ax,%ax
  8017db:	66 90                	xchg   %ax,%ax
  8017dd:	66 90                	xchg   %ax,%ax
  8017df:	90                   	nop

008017e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8017fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801800:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    

00801807 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801812:	89 c2                	mov    %eax,%edx
  801814:	c1 ea 16             	shr    $0x16,%edx
  801817:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80181e:	f6 c2 01             	test   $0x1,%dl
  801821:	74 11                	je     801834 <fd_alloc+0x2d>
  801823:	89 c2                	mov    %eax,%edx
  801825:	c1 ea 0c             	shr    $0xc,%edx
  801828:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80182f:	f6 c2 01             	test   $0x1,%dl
  801832:	75 09                	jne    80183d <fd_alloc+0x36>
			*fd_store = fd;
  801834:	89 01                	mov    %eax,(%ecx)
			return 0;
  801836:	b8 00 00 00 00       	mov    $0x0,%eax
  80183b:	eb 17                	jmp    801854 <fd_alloc+0x4d>
  80183d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801842:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801847:	75 c9                	jne    801812 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801849:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80184f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801854:	5d                   	pop    %ebp
  801855:	c3                   	ret    

00801856 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80185c:	83 f8 1f             	cmp    $0x1f,%eax
  80185f:	77 36                	ja     801897 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801861:	c1 e0 0c             	shl    $0xc,%eax
  801864:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801869:	89 c2                	mov    %eax,%edx
  80186b:	c1 ea 16             	shr    $0x16,%edx
  80186e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801875:	f6 c2 01             	test   $0x1,%dl
  801878:	74 24                	je     80189e <fd_lookup+0x48>
  80187a:	89 c2                	mov    %eax,%edx
  80187c:	c1 ea 0c             	shr    $0xc,%edx
  80187f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801886:	f6 c2 01             	test   $0x1,%dl
  801889:	74 1a                	je     8018a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	89 02                	mov    %eax,(%edx)
	return 0;
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
  801895:	eb 13                	jmp    8018aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801897:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80189c:	eb 0c                	jmp    8018aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80189e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a3:	eb 05                	jmp    8018aa <fd_lookup+0x54>
  8018a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 18             	sub    $0x18,%esp
  8018b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ba:	eb 13                	jmp    8018cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8018bc:	39 08                	cmp    %ecx,(%eax)
  8018be:	75 0c                	jne    8018cc <dev_lookup+0x20>
			*dev = devtab[i];
  8018c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ca:	eb 38                	jmp    801904 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018cc:	83 c2 01             	add    $0x1,%edx
  8018cf:	8b 04 95 10 36 80 00 	mov    0x803610(,%edx,4),%eax
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	75 e2                	jne    8018bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018da:	a1 08 50 80 00       	mov    0x805008,%eax
  8018df:	8b 40 48             	mov    0x48(%eax),%eax
  8018e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ea:	c7 04 24 90 35 80 00 	movl   $0x803590,(%esp)
  8018f1:	e8 e7 ef ff ff       	call   8008dd <cprintf>
	*dev = 0;
  8018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
  80190b:	83 ec 20             	sub    $0x20,%esp
  80190e:	8b 75 08             	mov    0x8(%ebp),%esi
  801911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801914:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801917:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80191b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801921:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801924:	89 04 24             	mov    %eax,(%esp)
  801927:	e8 2a ff ff ff       	call   801856 <fd_lookup>
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 05                	js     801935 <fd_close+0x2f>
	    || fd != fd2)
  801930:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801933:	74 0c                	je     801941 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801935:	84 db                	test   %bl,%bl
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	0f 44 c2             	cmove  %edx,%eax
  80193f:	eb 3f                	jmp    801980 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801941:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801944:	89 44 24 04          	mov    %eax,0x4(%esp)
  801948:	8b 06                	mov    (%esi),%eax
  80194a:	89 04 24             	mov    %eax,(%esp)
  80194d:	e8 5a ff ff ff       	call   8018ac <dev_lookup>
  801952:	89 c3                	mov    %eax,%ebx
  801954:	85 c0                	test   %eax,%eax
  801956:	78 16                	js     80196e <fd_close+0x68>
		if (dev->dev_close)
  801958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80195e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801963:	85 c0                	test   %eax,%eax
  801965:	74 07                	je     80196e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801967:	89 34 24             	mov    %esi,(%esp)
  80196a:	ff d0                	call   *%eax
  80196c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80196e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801972:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801979:	e8 ee fa ff ff       	call   80146c <sys_page_unmap>
	return r;
  80197e:	89 d8                	mov    %ebx,%eax
}
  801980:	83 c4 20             	add    $0x20,%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80198d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801990:	89 44 24 04          	mov    %eax,0x4(%esp)
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	89 04 24             	mov    %eax,(%esp)
  80199a:	e8 b7 fe ff ff       	call   801856 <fd_lookup>
  80199f:	89 c2                	mov    %eax,%edx
  8019a1:	85 d2                	test   %edx,%edx
  8019a3:	78 13                	js     8019b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8019a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019ac:	00 
  8019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b0:	89 04 24             	mov    %eax,(%esp)
  8019b3:	e8 4e ff ff ff       	call   801906 <fd_close>
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <close_all>:

void
close_all(void)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	53                   	push   %ebx
  8019be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019c6:	89 1c 24             	mov    %ebx,(%esp)
  8019c9:	e8 b9 ff ff ff       	call   801987 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019ce:	83 c3 01             	add    $0x1,%ebx
  8019d1:	83 fb 20             	cmp    $0x20,%ebx
  8019d4:	75 f0                	jne    8019c6 <close_all+0xc>
		close(i);
}
  8019d6:	83 c4 14             	add    $0x14,%esp
  8019d9:	5b                   	pop    %ebx
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    

008019dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	57                   	push   %edi
  8019e0:	56                   	push   %esi
  8019e1:	53                   	push   %ebx
  8019e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 04 24             	mov    %eax,(%esp)
  8019f2:	e8 5f fe ff ff       	call   801856 <fd_lookup>
  8019f7:	89 c2                	mov    %eax,%edx
  8019f9:	85 d2                	test   %edx,%edx
  8019fb:	0f 88 e1 00 00 00    	js     801ae2 <dup+0x106>
		return r;
	close(newfdnum);
  801a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a04:	89 04 24             	mov    %eax,(%esp)
  801a07:	e8 7b ff ff ff       	call   801987 <close>

	newfd = INDEX2FD(newfdnum);
  801a0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a0f:	c1 e3 0c             	shl    $0xc,%ebx
  801a12:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1b:	89 04 24             	mov    %eax,(%esp)
  801a1e:	e8 cd fd ff ff       	call   8017f0 <fd2data>
  801a23:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a25:	89 1c 24             	mov    %ebx,(%esp)
  801a28:	e8 c3 fd ff ff       	call   8017f0 <fd2data>
  801a2d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a2f:	89 f0                	mov    %esi,%eax
  801a31:	c1 e8 16             	shr    $0x16,%eax
  801a34:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a3b:	a8 01                	test   $0x1,%al
  801a3d:	74 43                	je     801a82 <dup+0xa6>
  801a3f:	89 f0                	mov    %esi,%eax
  801a41:	c1 e8 0c             	shr    $0xc,%eax
  801a44:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a4b:	f6 c2 01             	test   $0x1,%dl
  801a4e:	74 32                	je     801a82 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a50:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a57:	25 07 0e 00 00       	and    $0xe07,%eax
  801a5c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a60:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a64:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a6b:	00 
  801a6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a77:	e8 9d f9 ff ff       	call   801419 <sys_page_map>
  801a7c:	89 c6                	mov    %eax,%esi
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 3e                	js     801ac0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a85:	89 c2                	mov    %eax,%edx
  801a87:	c1 ea 0c             	shr    $0xc,%edx
  801a8a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a91:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a97:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aa6:	00 
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab2:	e8 62 f9 ff ff       	call   801419 <sys_page_map>
  801ab7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801abc:	85 f6                	test   %esi,%esi
  801abe:	79 22                	jns    801ae2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ac0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ac4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801acb:	e8 9c f9 ff ff       	call   80146c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ad0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ad4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801adb:	e8 8c f9 ff ff       	call   80146c <sys_page_unmap>
	return r;
  801ae0:	89 f0                	mov    %esi,%eax
}
  801ae2:	83 c4 3c             	add    $0x3c,%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5f                   	pop    %edi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    

00801aea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	53                   	push   %ebx
  801aee:	83 ec 24             	sub    $0x24,%esp
  801af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afb:	89 1c 24             	mov    %ebx,(%esp)
  801afe:	e8 53 fd ff ff       	call   801856 <fd_lookup>
  801b03:	89 c2                	mov    %eax,%edx
  801b05:	85 d2                	test   %edx,%edx
  801b07:	78 6d                	js     801b76 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b13:	8b 00                	mov    (%eax),%eax
  801b15:	89 04 24             	mov    %eax,(%esp)
  801b18:	e8 8f fd ff ff       	call   8018ac <dev_lookup>
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	78 55                	js     801b76 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b24:	8b 50 08             	mov    0x8(%eax),%edx
  801b27:	83 e2 03             	and    $0x3,%edx
  801b2a:	83 fa 01             	cmp    $0x1,%edx
  801b2d:	75 23                	jne    801b52 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b2f:	a1 08 50 80 00       	mov    0x805008,%eax
  801b34:	8b 40 48             	mov    0x48(%eax),%eax
  801b37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3f:	c7 04 24 d4 35 80 00 	movl   $0x8035d4,(%esp)
  801b46:	e8 92 ed ff ff       	call   8008dd <cprintf>
		return -E_INVAL;
  801b4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b50:	eb 24                	jmp    801b76 <read+0x8c>
	}
	if (!dev->dev_read)
  801b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b55:	8b 52 08             	mov    0x8(%edx),%edx
  801b58:	85 d2                	test   %edx,%edx
  801b5a:	74 15                	je     801b71 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b6a:	89 04 24             	mov    %eax,(%esp)
  801b6d:	ff d2                	call   *%edx
  801b6f:	eb 05                	jmp    801b76 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b71:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b76:	83 c4 24             	add    $0x24,%esp
  801b79:	5b                   	pop    %ebx
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    

00801b7c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	57                   	push   %edi
  801b80:	56                   	push   %esi
  801b81:	53                   	push   %ebx
  801b82:	83 ec 1c             	sub    $0x1c,%esp
  801b85:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b88:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b90:	eb 23                	jmp    801bb5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b92:	89 f0                	mov    %esi,%eax
  801b94:	29 d8                	sub    %ebx,%eax
  801b96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b9a:	89 d8                	mov    %ebx,%eax
  801b9c:	03 45 0c             	add    0xc(%ebp),%eax
  801b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba3:	89 3c 24             	mov    %edi,(%esp)
  801ba6:	e8 3f ff ff ff       	call   801aea <read>
		if (m < 0)
  801bab:	85 c0                	test   %eax,%eax
  801bad:	78 10                	js     801bbf <readn+0x43>
			return m;
		if (m == 0)
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	74 0a                	je     801bbd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bb3:	01 c3                	add    %eax,%ebx
  801bb5:	39 f3                	cmp    %esi,%ebx
  801bb7:	72 d9                	jb     801b92 <readn+0x16>
  801bb9:	89 d8                	mov    %ebx,%eax
  801bbb:	eb 02                	jmp    801bbf <readn+0x43>
  801bbd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bbf:	83 c4 1c             	add    $0x1c,%esp
  801bc2:	5b                   	pop    %ebx
  801bc3:	5e                   	pop    %esi
  801bc4:	5f                   	pop    %edi
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    

00801bc7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	53                   	push   %ebx
  801bcb:	83 ec 24             	sub    $0x24,%esp
  801bce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bd1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd8:	89 1c 24             	mov    %ebx,(%esp)
  801bdb:	e8 76 fc ff ff       	call   801856 <fd_lookup>
  801be0:	89 c2                	mov    %eax,%edx
  801be2:	85 d2                	test   %edx,%edx
  801be4:	78 68                	js     801c4e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801be6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf0:	8b 00                	mov    (%eax),%eax
  801bf2:	89 04 24             	mov    %eax,(%esp)
  801bf5:	e8 b2 fc ff ff       	call   8018ac <dev_lookup>
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	78 50                	js     801c4e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c01:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c05:	75 23                	jne    801c2a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c07:	a1 08 50 80 00       	mov    0x805008,%eax
  801c0c:	8b 40 48             	mov    0x48(%eax),%eax
  801c0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c17:	c7 04 24 f0 35 80 00 	movl   $0x8035f0,(%esp)
  801c1e:	e8 ba ec ff ff       	call   8008dd <cprintf>
		return -E_INVAL;
  801c23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c28:	eb 24                	jmp    801c4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c30:	85 d2                	test   %edx,%edx
  801c32:	74 15                	je     801c49 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c42:	89 04 24             	mov    %eax,(%esp)
  801c45:	ff d2                	call   *%edx
  801c47:	eb 05                	jmp    801c4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c49:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c4e:	83 c4 24             	add    $0x24,%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    

00801c54 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c5a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	e8 ea fb ff ff       	call   801856 <fd_lookup>
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 0e                	js     801c7e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c76:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	53                   	push   %ebx
  801c84:	83 ec 24             	sub    $0x24,%esp
  801c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c91:	89 1c 24             	mov    %ebx,(%esp)
  801c94:	e8 bd fb ff ff       	call   801856 <fd_lookup>
  801c99:	89 c2                	mov    %eax,%edx
  801c9b:	85 d2                	test   %edx,%edx
  801c9d:	78 61                	js     801d00 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca9:	8b 00                	mov    (%eax),%eax
  801cab:	89 04 24             	mov    %eax,(%esp)
  801cae:	e8 f9 fb ff ff       	call   8018ac <dev_lookup>
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	78 49                	js     801d00 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cbe:	75 23                	jne    801ce3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801cc0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cc5:	8b 40 48             	mov    0x48(%eax),%eax
  801cc8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd0:	c7 04 24 b0 35 80 00 	movl   $0x8035b0,(%esp)
  801cd7:	e8 01 ec ff ff       	call   8008dd <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801cdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ce1:	eb 1d                	jmp    801d00 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce6:	8b 52 18             	mov    0x18(%edx),%edx
  801ce9:	85 d2                	test   %edx,%edx
  801ceb:	74 0e                	je     801cfb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cf0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cf4:	89 04 24             	mov    %eax,(%esp)
  801cf7:	ff d2                	call   *%edx
  801cf9:	eb 05                	jmp    801d00 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801cfb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d00:	83 c4 24             	add    $0x24,%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	53                   	push   %ebx
  801d0a:	83 ec 24             	sub    $0x24,%esp
  801d0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 04 24             	mov    %eax,(%esp)
  801d1d:	e8 34 fb ff ff       	call   801856 <fd_lookup>
  801d22:	89 c2                	mov    %eax,%edx
  801d24:	85 d2                	test   %edx,%edx
  801d26:	78 52                	js     801d7a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	89 04 24             	mov    %eax,(%esp)
  801d37:	e8 70 fb ff ff       	call   8018ac <dev_lookup>
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	78 3a                	js     801d7a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d47:	74 2c                	je     801d75 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d49:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d53:	00 00 00 
	stat->st_isdir = 0;
  801d56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d5d:	00 00 00 
	stat->st_dev = dev;
  801d60:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d6d:	89 14 24             	mov    %edx,(%esp)
  801d70:	ff 50 14             	call   *0x14(%eax)
  801d73:	eb 05                	jmp    801d7a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d7a:	83 c4 24             	add    $0x24,%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    

00801d80 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
  801d85:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d8f:	00 
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	89 04 24             	mov    %eax,(%esp)
  801d96:	e8 99 02 00 00       	call   802034 <open>
  801d9b:	89 c3                	mov    %eax,%ebx
  801d9d:	85 db                	test   %ebx,%ebx
  801d9f:	78 1b                	js     801dbc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da8:	89 1c 24             	mov    %ebx,(%esp)
  801dab:	e8 56 ff ff ff       	call   801d06 <fstat>
  801db0:	89 c6                	mov    %eax,%esi
	close(fd);
  801db2:	89 1c 24             	mov    %ebx,(%esp)
  801db5:	e8 cd fb ff ff       	call   801987 <close>
	return r;
  801dba:	89 f0                	mov    %esi,%eax
}
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	5b                   	pop    %ebx
  801dc0:	5e                   	pop    %esi
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    

00801dc3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
  801dc8:	83 ec 10             	sub    $0x10,%esp
  801dcb:	89 c6                	mov    %eax,%esi
  801dcd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801dcf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801dd6:	75 11                	jne    801de9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801dd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801ddf:	e8 bb f9 ff ff       	call   80179f <ipc_find_env>
  801de4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801de9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801df0:	00 
  801df1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801df8:	00 
  801df9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dfd:	a1 00 50 80 00       	mov    0x805000,%eax
  801e02:	89 04 24             	mov    %eax,(%esp)
  801e05:	e8 2e f9 ff ff       	call   801738 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e11:	00 
  801e12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e1d:	e8 ae f8 ff ff       	call   8016d0 <ipc_recv>
}
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	5b                   	pop    %ebx
  801e26:	5e                   	pop    %esi
  801e27:	5d                   	pop    %ebp
  801e28:	c3                   	ret    

00801e29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	8b 40 0c             	mov    0xc(%eax),%eax
  801e35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e42:	ba 00 00 00 00       	mov    $0x0,%edx
  801e47:	b8 02 00 00 00       	mov    $0x2,%eax
  801e4c:	e8 72 ff ff ff       	call   801dc3 <fsipc>
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e64:	ba 00 00 00 00       	mov    $0x0,%edx
  801e69:	b8 06 00 00 00       	mov    $0x6,%eax
  801e6e:	e8 50 ff ff ff       	call   801dc3 <fsipc>
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	53                   	push   %ebx
  801e79:	83 ec 14             	sub    $0x14,%esp
  801e7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8b 40 0c             	mov    0xc(%eax),%eax
  801e85:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e94:	e8 2a ff ff ff       	call   801dc3 <fsipc>
  801e99:	89 c2                	mov    %eax,%edx
  801e9b:	85 d2                	test   %edx,%edx
  801e9d:	78 2b                	js     801eca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e9f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ea6:	00 
  801ea7:	89 1c 24             	mov    %ebx,(%esp)
  801eaa:	e8 a8 f0 ff ff       	call   800f57 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801eaf:	a1 80 60 80 00       	mov    0x806080,%eax
  801eb4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eba:	a1 84 60 80 00       	mov    0x806084,%eax
  801ebf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eca:	83 c4 14             	add    $0x14,%esp
  801ecd:	5b                   	pop    %ebx
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    

00801ed0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 14             	sub    $0x14,%esp
  801ed7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801eda:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801ee0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ee5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  801eeb:	8b 52 0c             	mov    0xc(%edx),%edx
  801eee:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801ef4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801ef9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f04:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801f0b:	e8 e4 f1 ff ff       	call   8010f4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801f10:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801f17:	00 
  801f18:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  801f1f:	e8 b9 e9 ff ff       	call   8008dd <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f24:	ba 00 00 00 00       	mov    $0x0,%edx
  801f29:	b8 04 00 00 00       	mov    $0x4,%eax
  801f2e:	e8 90 fe ff ff       	call   801dc3 <fsipc>
  801f33:	85 c0                	test   %eax,%eax
  801f35:	78 53                	js     801f8a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801f37:	39 c3                	cmp    %eax,%ebx
  801f39:	73 24                	jae    801f5f <devfile_write+0x8f>
  801f3b:	c7 44 24 0c 29 36 80 	movl   $0x803629,0xc(%esp)
  801f42:	00 
  801f43:	c7 44 24 08 30 36 80 	movl   $0x803630,0x8(%esp)
  801f4a:	00 
  801f4b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801f52:	00 
  801f53:	c7 04 24 45 36 80 00 	movl   $0x803645,(%esp)
  801f5a:	e8 85 e8 ff ff       	call   8007e4 <_panic>
	assert(r <= PGSIZE);
  801f5f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f64:	7e 24                	jle    801f8a <devfile_write+0xba>
  801f66:	c7 44 24 0c 50 36 80 	movl   $0x803650,0xc(%esp)
  801f6d:	00 
  801f6e:	c7 44 24 08 30 36 80 	movl   $0x803630,0x8(%esp)
  801f75:	00 
  801f76:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801f7d:	00 
  801f7e:	c7 04 24 45 36 80 00 	movl   $0x803645,(%esp)
  801f85:	e8 5a e8 ff ff       	call   8007e4 <_panic>
	return r;
}
  801f8a:	83 c4 14             	add    $0x14,%esp
  801f8d:	5b                   	pop    %ebx
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    

00801f90 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	56                   	push   %esi
  801f94:	53                   	push   %ebx
  801f95:	83 ec 10             	sub    $0x10,%esp
  801f98:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801fa6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801fac:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb1:	b8 03 00 00 00       	mov    $0x3,%eax
  801fb6:	e8 08 fe ff ff       	call   801dc3 <fsipc>
  801fbb:	89 c3                	mov    %eax,%ebx
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	78 6a                	js     80202b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801fc1:	39 c6                	cmp    %eax,%esi
  801fc3:	73 24                	jae    801fe9 <devfile_read+0x59>
  801fc5:	c7 44 24 0c 29 36 80 	movl   $0x803629,0xc(%esp)
  801fcc:	00 
  801fcd:	c7 44 24 08 30 36 80 	movl   $0x803630,0x8(%esp)
  801fd4:	00 
  801fd5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801fdc:	00 
  801fdd:	c7 04 24 45 36 80 00 	movl   $0x803645,(%esp)
  801fe4:	e8 fb e7 ff ff       	call   8007e4 <_panic>
	assert(r <= PGSIZE);
  801fe9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fee:	7e 24                	jle    802014 <devfile_read+0x84>
  801ff0:	c7 44 24 0c 50 36 80 	movl   $0x803650,0xc(%esp)
  801ff7:	00 
  801ff8:	c7 44 24 08 30 36 80 	movl   $0x803630,0x8(%esp)
  801fff:	00 
  802000:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802007:	00 
  802008:	c7 04 24 45 36 80 00 	movl   $0x803645,(%esp)
  80200f:	e8 d0 e7 ff ff       	call   8007e4 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802014:	89 44 24 08          	mov    %eax,0x8(%esp)
  802018:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80201f:	00 
  802020:	8b 45 0c             	mov    0xc(%ebp),%eax
  802023:	89 04 24             	mov    %eax,(%esp)
  802026:	e8 c9 f0 ff ff       	call   8010f4 <memmove>
	return r;
}
  80202b:	89 d8                	mov    %ebx,%eax
  80202d:	83 c4 10             	add    $0x10,%esp
  802030:	5b                   	pop    %ebx
  802031:	5e                   	pop    %esi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    

00802034 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	53                   	push   %ebx
  802038:	83 ec 24             	sub    $0x24,%esp
  80203b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80203e:	89 1c 24             	mov    %ebx,(%esp)
  802041:	e8 da ee ff ff       	call   800f20 <strlen>
  802046:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80204b:	7f 60                	jg     8020ad <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80204d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802050:	89 04 24             	mov    %eax,(%esp)
  802053:	e8 af f7 ff ff       	call   801807 <fd_alloc>
  802058:	89 c2                	mov    %eax,%edx
  80205a:	85 d2                	test   %edx,%edx
  80205c:	78 54                	js     8020b2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80205e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802062:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802069:	e8 e9 ee ff ff       	call   800f57 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80206e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802071:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802079:	b8 01 00 00 00       	mov    $0x1,%eax
  80207e:	e8 40 fd ff ff       	call   801dc3 <fsipc>
  802083:	89 c3                	mov    %eax,%ebx
  802085:	85 c0                	test   %eax,%eax
  802087:	79 17                	jns    8020a0 <open+0x6c>
		fd_close(fd, 0);
  802089:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802090:	00 
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	89 04 24             	mov    %eax,(%esp)
  802097:	e8 6a f8 ff ff       	call   801906 <fd_close>
		return r;
  80209c:	89 d8                	mov    %ebx,%eax
  80209e:	eb 12                	jmp    8020b2 <open+0x7e>
	}

	return fd2num(fd);
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	89 04 24             	mov    %eax,(%esp)
  8020a6:	e8 35 f7 ff ff       	call   8017e0 <fd2num>
  8020ab:	eb 05                	jmp    8020b2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8020ad:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8020b2:	83 c4 24             	add    $0x24,%esp
  8020b5:	5b                   	pop    %ebx
  8020b6:	5d                   	pop    %ebp
  8020b7:	c3                   	ret    

008020b8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8020be:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c3:	b8 08 00 00 00       	mov    $0x8,%eax
  8020c8:	e8 f6 fc ff ff       	call   801dc3 <fsipc>
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <evict>:

int evict(void)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  8020d5:	c7 04 24 5c 36 80 00 	movl   $0x80365c,(%esp)
  8020dc:	e8 fc e7 ff ff       	call   8008dd <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  8020e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e6:	b8 09 00 00 00       	mov    $0x9,%eax
  8020eb:	e8 d3 fc ff ff       	call   801dc3 <fsipc>
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    
  8020f2:	66 90                	xchg   %ax,%ax
  8020f4:	66 90                	xchg   %ax,%ax
  8020f6:	66 90                	xchg   %ax,%ax
  8020f8:	66 90                	xchg   %ax,%ax
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	66 90                	xchg   %ax,%ax
  8020fe:	66 90                	xchg   %ax,%ax

00802100 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802106:	c7 44 24 04 75 36 80 	movl   $0x803675,0x4(%esp)
  80210d:	00 
  80210e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802111:	89 04 24             	mov    %eax,(%esp)
  802114:	e8 3e ee ff ff       	call   800f57 <strcpy>
	return 0;
}
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	53                   	push   %ebx
  802124:	83 ec 14             	sub    $0x14,%esp
  802127:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80212a:	89 1c 24             	mov    %ebx,(%esp)
  80212d:	e8 04 0a 00 00       	call   802b36 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802132:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802137:	83 f8 01             	cmp    $0x1,%eax
  80213a:	75 0d                	jne    802149 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80213c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80213f:	89 04 24             	mov    %eax,(%esp)
  802142:	e8 29 03 00 00       	call   802470 <nsipc_close>
  802147:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802149:	89 d0                	mov    %edx,%eax
  80214b:	83 c4 14             	add    $0x14,%esp
  80214e:	5b                   	pop    %ebx
  80214f:	5d                   	pop    %ebp
  802150:	c3                   	ret    

00802151 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802157:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80215e:	00 
  80215f:	8b 45 10             	mov    0x10(%ebp),%eax
  802162:	89 44 24 08          	mov    %eax,0x8(%esp)
  802166:	8b 45 0c             	mov    0xc(%ebp),%eax
  802169:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 40 0c             	mov    0xc(%eax),%eax
  802173:	89 04 24             	mov    %eax,(%esp)
  802176:	e8 f0 03 00 00       	call   80256b <nsipc_send>
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802183:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80218a:	00 
  80218b:	8b 45 10             	mov    0x10(%ebp),%eax
  80218e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802192:	8b 45 0c             	mov    0xc(%ebp),%eax
  802195:	89 44 24 04          	mov    %eax,0x4(%esp)
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	8b 40 0c             	mov    0xc(%eax),%eax
  80219f:	89 04 24             	mov    %eax,(%esp)
  8021a2:	e8 44 03 00 00       	call   8024eb <nsipc_recv>
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021af:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021b6:	89 04 24             	mov    %eax,(%esp)
  8021b9:	e8 98 f6 ff ff       	call   801856 <fd_lookup>
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 17                	js     8021d9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  8021cb:	39 08                	cmp    %ecx,(%eax)
  8021cd:	75 05                	jne    8021d4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d2:	eb 05                	jmp    8021d9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8021d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	83 ec 20             	sub    $0x20,%esp
  8021e3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e8:	89 04 24             	mov    %eax,(%esp)
  8021eb:	e8 17 f6 ff ff       	call   801807 <fd_alloc>
  8021f0:	89 c3                	mov    %eax,%ebx
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	78 21                	js     802217 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8021f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021fd:	00 
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	89 44 24 04          	mov    %eax,0x4(%esp)
  802205:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220c:	e8 b4 f1 ff ff       	call   8013c5 <sys_page_alloc>
  802211:	89 c3                	mov    %eax,%ebx
  802213:	85 c0                	test   %eax,%eax
  802215:	79 0c                	jns    802223 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802217:	89 34 24             	mov    %esi,(%esp)
  80221a:	e8 51 02 00 00       	call   802470 <nsipc_close>
		return r;
  80221f:	89 d8                	mov    %ebx,%eax
  802221:	eb 20                	jmp    802243 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802223:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80222e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802231:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802238:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80223b:	89 14 24             	mov    %edx,(%esp)
  80223e:	e8 9d f5 ff ff       	call   8017e0 <fd2num>
}
  802243:	83 c4 20             	add    $0x20,%esp
  802246:	5b                   	pop    %ebx
  802247:	5e                   	pop    %esi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    

0080224a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	e8 51 ff ff ff       	call   8021a9 <fd2sockid>
		return r;
  802258:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80225a:	85 c0                	test   %eax,%eax
  80225c:	78 23                	js     802281 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80225e:	8b 55 10             	mov    0x10(%ebp),%edx
  802261:	89 54 24 08          	mov    %edx,0x8(%esp)
  802265:	8b 55 0c             	mov    0xc(%ebp),%edx
  802268:	89 54 24 04          	mov    %edx,0x4(%esp)
  80226c:	89 04 24             	mov    %eax,(%esp)
  80226f:	e8 45 01 00 00       	call   8023b9 <nsipc_accept>
		return r;
  802274:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802276:	85 c0                	test   %eax,%eax
  802278:	78 07                	js     802281 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80227a:	e8 5c ff ff ff       	call   8021db <alloc_sockfd>
  80227f:	89 c1                	mov    %eax,%ecx
}
  802281:	89 c8                	mov    %ecx,%eax
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	e8 16 ff ff ff       	call   8021a9 <fd2sockid>
  802293:	89 c2                	mov    %eax,%edx
  802295:	85 d2                	test   %edx,%edx
  802297:	78 16                	js     8022af <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802299:	8b 45 10             	mov    0x10(%ebp),%eax
  80229c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a7:	89 14 24             	mov    %edx,(%esp)
  8022aa:	e8 60 01 00 00       	call   80240f <nsipc_bind>
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <shutdown>:

int
shutdown(int s, int how)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	e8 ea fe ff ff       	call   8021a9 <fd2sockid>
  8022bf:	89 c2                	mov    %eax,%edx
  8022c1:	85 d2                	test   %edx,%edx
  8022c3:	78 0f                	js     8022d4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8022c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cc:	89 14 24             	mov    %edx,(%esp)
  8022cf:	e8 7a 01 00 00       	call   80244e <nsipc_shutdown>
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	e8 c5 fe ff ff       	call   8021a9 <fd2sockid>
  8022e4:	89 c2                	mov    %eax,%edx
  8022e6:	85 d2                	test   %edx,%edx
  8022e8:	78 16                	js     802300 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8022ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f8:	89 14 24             	mov    %edx,(%esp)
  8022fb:	e8 8a 01 00 00       	call   80248a <nsipc_connect>
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <listen>:

int
listen(int s, int backlog)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	e8 99 fe ff ff       	call   8021a9 <fd2sockid>
  802310:	89 c2                	mov    %eax,%edx
  802312:	85 d2                	test   %edx,%edx
  802314:	78 0f                	js     802325 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231d:	89 14 24             	mov    %edx,(%esp)
  802320:	e8 a4 01 00 00       	call   8024c9 <nsipc_listen>
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80232d:	8b 45 10             	mov    0x10(%ebp),%eax
  802330:	89 44 24 08          	mov    %eax,0x8(%esp)
  802334:	8b 45 0c             	mov    0xc(%ebp),%eax
  802337:	89 44 24 04          	mov    %eax,0x4(%esp)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	89 04 24             	mov    %eax,(%esp)
  802341:	e8 98 02 00 00       	call   8025de <nsipc_socket>
  802346:	89 c2                	mov    %eax,%edx
  802348:	85 d2                	test   %edx,%edx
  80234a:	78 05                	js     802351 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80234c:	e8 8a fe ff ff       	call   8021db <alloc_sockfd>
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
  802356:	53                   	push   %ebx
  802357:	83 ec 14             	sub    $0x14,%esp
  80235a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80235c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802363:	75 11                	jne    802376 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802365:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80236c:	e8 2e f4 ff ff       	call   80179f <ipc_find_env>
  802371:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802376:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80237d:	00 
  80237e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802385:	00 
  802386:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80238a:	a1 04 50 80 00       	mov    0x805004,%eax
  80238f:	89 04 24             	mov    %eax,(%esp)
  802392:	e8 a1 f3 ff ff       	call   801738 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802397:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80239e:	00 
  80239f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023a6:	00 
  8023a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ae:	e8 1d f3 ff ff       	call   8016d0 <ipc_recv>
}
  8023b3:	83 c4 14             	add    $0x14,%esp
  8023b6:	5b                   	pop    %ebx
  8023b7:	5d                   	pop    %ebp
  8023b8:	c3                   	ret    

008023b9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	56                   	push   %esi
  8023bd:	53                   	push   %ebx
  8023be:	83 ec 10             	sub    $0x10,%esp
  8023c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023cc:	8b 06                	mov    (%esi),%eax
  8023ce:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d8:	e8 76 ff ff ff       	call   802353 <nsipc>
  8023dd:	89 c3                	mov    %eax,%ebx
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	78 23                	js     802406 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023e3:	a1 10 70 80 00       	mov    0x807010,%eax
  8023e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ec:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8023f3:	00 
  8023f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f7:	89 04 24             	mov    %eax,(%esp)
  8023fa:	e8 f5 ec ff ff       	call   8010f4 <memmove>
		*addrlen = ret->ret_addrlen;
  8023ff:	a1 10 70 80 00       	mov    0x807010,%eax
  802404:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802406:	89 d8                	mov    %ebx,%eax
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	5b                   	pop    %ebx
  80240c:	5e                   	pop    %esi
  80240d:	5d                   	pop    %ebp
  80240e:	c3                   	ret    

0080240f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	53                   	push   %ebx
  802413:	83 ec 14             	sub    $0x14,%esp
  802416:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802421:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802425:	8b 45 0c             	mov    0xc(%ebp),%eax
  802428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80242c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802433:	e8 bc ec ff ff       	call   8010f4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802438:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80243e:	b8 02 00 00 00       	mov    $0x2,%eax
  802443:	e8 0b ff ff ff       	call   802353 <nsipc>
}
  802448:	83 c4 14             	add    $0x14,%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5d                   	pop    %ebp
  80244d:	c3                   	ret    

0080244e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80245c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802464:	b8 03 00 00 00       	mov    $0x3,%eax
  802469:	e8 e5 fe ff ff       	call   802353 <nsipc>
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <nsipc_close>:

int
nsipc_close(int s)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80247e:	b8 04 00 00 00       	mov    $0x4,%eax
  802483:	e8 cb fe ff ff       	call   802353 <nsipc>
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	53                   	push   %ebx
  80248e:	83 ec 14             	sub    $0x14,%esp
  802491:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80249c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8024ae:	e8 41 ec ff ff       	call   8010f4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024b3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8024b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8024be:	e8 90 fe ff ff       	call   802353 <nsipc>
}
  8024c3:	83 c4 14             	add    $0x14,%esp
  8024c6:	5b                   	pop    %ebx
  8024c7:	5d                   	pop    %ebp
  8024c8:	c3                   	ret    

008024c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8024df:	b8 06 00 00 00       	mov    $0x6,%eax
  8024e4:	e8 6a fe ff ff       	call   802353 <nsipc>
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	56                   	push   %esi
  8024ef:	53                   	push   %ebx
  8024f0:	83 ec 10             	sub    $0x10,%esp
  8024f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8024fe:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802504:	8b 45 14             	mov    0x14(%ebp),%eax
  802507:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80250c:	b8 07 00 00 00       	mov    $0x7,%eax
  802511:	e8 3d fe ff ff       	call   802353 <nsipc>
  802516:	89 c3                	mov    %eax,%ebx
  802518:	85 c0                	test   %eax,%eax
  80251a:	78 46                	js     802562 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80251c:	39 f0                	cmp    %esi,%eax
  80251e:	7f 07                	jg     802527 <nsipc_recv+0x3c>
  802520:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802525:	7e 24                	jle    80254b <nsipc_recv+0x60>
  802527:	c7 44 24 0c 81 36 80 	movl   $0x803681,0xc(%esp)
  80252e:	00 
  80252f:	c7 44 24 08 30 36 80 	movl   $0x803630,0x8(%esp)
  802536:	00 
  802537:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80253e:	00 
  80253f:	c7 04 24 96 36 80 00 	movl   $0x803696,(%esp)
  802546:	e8 99 e2 ff ff       	call   8007e4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80254b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80254f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802556:	00 
  802557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255a:	89 04 24             	mov    %eax,(%esp)
  80255d:	e8 92 eb ff ff       	call   8010f4 <memmove>
	}

	return r;
}
  802562:	89 d8                	mov    %ebx,%eax
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	5b                   	pop    %ebx
  802568:	5e                   	pop    %esi
  802569:	5d                   	pop    %ebp
  80256a:	c3                   	ret    

0080256b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	53                   	push   %ebx
  80256f:	83 ec 14             	sub    $0x14,%esp
  802572:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80257d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802583:	7e 24                	jle    8025a9 <nsipc_send+0x3e>
  802585:	c7 44 24 0c a2 36 80 	movl   $0x8036a2,0xc(%esp)
  80258c:	00 
  80258d:	c7 44 24 08 30 36 80 	movl   $0x803630,0x8(%esp)
  802594:	00 
  802595:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80259c:	00 
  80259d:	c7 04 24 96 36 80 00 	movl   $0x803696,(%esp)
  8025a4:	e8 3b e2 ff ff       	call   8007e4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8025a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8025bb:	e8 34 eb ff ff       	call   8010f4 <memmove>
	nsipcbuf.send.req_size = size;
  8025c0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8025c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025c9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8025ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8025d3:	e8 7b fd ff ff       	call   802353 <nsipc>
}
  8025d8:	83 c4 14             	add    $0x14,%esp
  8025db:	5b                   	pop    %ebx
  8025dc:	5d                   	pop    %ebp
  8025dd:	c3                   	ret    

008025de <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8025ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ef:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8025f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8025fc:	b8 09 00 00 00       	mov    $0x9,%eax
  802601:	e8 4d fd ff ff       	call   802353 <nsipc>
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	56                   	push   %esi
  80260c:	53                   	push   %ebx
  80260d:	83 ec 10             	sub    $0x10,%esp
  802610:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	89 04 24             	mov    %eax,(%esp)
  802619:	e8 d2 f1 ff ff       	call   8017f0 <fd2data>
  80261e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802620:	c7 44 24 04 ae 36 80 	movl   $0x8036ae,0x4(%esp)
  802627:	00 
  802628:	89 1c 24             	mov    %ebx,(%esp)
  80262b:	e8 27 e9 ff ff       	call   800f57 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802630:	8b 46 04             	mov    0x4(%esi),%eax
  802633:	2b 06                	sub    (%esi),%eax
  802635:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80263b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802642:	00 00 00 
	stat->st_dev = &devpipe;
  802645:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80264c:	40 80 00 
	return 0;
}
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	5b                   	pop    %ebx
  802658:	5e                   	pop    %esi
  802659:	5d                   	pop    %ebp
  80265a:	c3                   	ret    

0080265b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	53                   	push   %ebx
  80265f:	83 ec 14             	sub    $0x14,%esp
  802662:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802665:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802669:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802670:	e8 f7 ed ff ff       	call   80146c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802675:	89 1c 24             	mov    %ebx,(%esp)
  802678:	e8 73 f1 ff ff       	call   8017f0 <fd2data>
  80267d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802681:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802688:	e8 df ed ff ff       	call   80146c <sys_page_unmap>
}
  80268d:	83 c4 14             	add    $0x14,%esp
  802690:	5b                   	pop    %ebx
  802691:	5d                   	pop    %ebp
  802692:	c3                   	ret    

00802693 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	57                   	push   %edi
  802697:	56                   	push   %esi
  802698:	53                   	push   %ebx
  802699:	83 ec 2c             	sub    $0x2c,%esp
  80269c:	89 c6                	mov    %eax,%esi
  80269e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8026a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8026a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026a9:	89 34 24             	mov    %esi,(%esp)
  8026ac:	e8 85 04 00 00       	call   802b36 <pageref>
  8026b1:	89 c7                	mov    %eax,%edi
  8026b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b6:	89 04 24             	mov    %eax,(%esp)
  8026b9:	e8 78 04 00 00       	call   802b36 <pageref>
  8026be:	39 c7                	cmp    %eax,%edi
  8026c0:	0f 94 c2             	sete   %dl
  8026c3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8026c6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8026cc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8026cf:	39 fb                	cmp    %edi,%ebx
  8026d1:	74 21                	je     8026f4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8026d3:	84 d2                	test   %dl,%dl
  8026d5:	74 ca                	je     8026a1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8026d7:	8b 51 58             	mov    0x58(%ecx),%edx
  8026da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026e6:	c7 04 24 b5 36 80 00 	movl   $0x8036b5,(%esp)
  8026ed:	e8 eb e1 ff ff       	call   8008dd <cprintf>
  8026f2:	eb ad                	jmp    8026a1 <_pipeisclosed+0xe>
	}
}
  8026f4:	83 c4 2c             	add    $0x2c,%esp
  8026f7:	5b                   	pop    %ebx
  8026f8:	5e                   	pop    %esi
  8026f9:	5f                   	pop    %edi
  8026fa:	5d                   	pop    %ebp
  8026fb:	c3                   	ret    

008026fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	57                   	push   %edi
  802700:	56                   	push   %esi
  802701:	53                   	push   %ebx
  802702:	83 ec 1c             	sub    $0x1c,%esp
  802705:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802708:	89 34 24             	mov    %esi,(%esp)
  80270b:	e8 e0 f0 ff ff       	call   8017f0 <fd2data>
  802710:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802712:	bf 00 00 00 00       	mov    $0x0,%edi
  802717:	eb 45                	jmp    80275e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802719:	89 da                	mov    %ebx,%edx
  80271b:	89 f0                	mov    %esi,%eax
  80271d:	e8 71 ff ff ff       	call   802693 <_pipeisclosed>
  802722:	85 c0                	test   %eax,%eax
  802724:	75 41                	jne    802767 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802726:	e8 7b ec ff ff       	call   8013a6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80272b:	8b 43 04             	mov    0x4(%ebx),%eax
  80272e:	8b 0b                	mov    (%ebx),%ecx
  802730:	8d 51 20             	lea    0x20(%ecx),%edx
  802733:	39 d0                	cmp    %edx,%eax
  802735:	73 e2                	jae    802719 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802737:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80273a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80273e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802741:	99                   	cltd   
  802742:	c1 ea 1b             	shr    $0x1b,%edx
  802745:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802748:	83 e1 1f             	and    $0x1f,%ecx
  80274b:	29 d1                	sub    %edx,%ecx
  80274d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802751:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802755:	83 c0 01             	add    $0x1,%eax
  802758:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80275b:	83 c7 01             	add    $0x1,%edi
  80275e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802761:	75 c8                	jne    80272b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802763:	89 f8                	mov    %edi,%eax
  802765:	eb 05                	jmp    80276c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80276c:	83 c4 1c             	add    $0x1c,%esp
  80276f:	5b                   	pop    %ebx
  802770:	5e                   	pop    %esi
  802771:	5f                   	pop    %edi
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    

00802774 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	57                   	push   %edi
  802778:	56                   	push   %esi
  802779:	53                   	push   %ebx
  80277a:	83 ec 1c             	sub    $0x1c,%esp
  80277d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802780:	89 3c 24             	mov    %edi,(%esp)
  802783:	e8 68 f0 ff ff       	call   8017f0 <fd2data>
  802788:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80278a:	be 00 00 00 00       	mov    $0x0,%esi
  80278f:	eb 3d                	jmp    8027ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802791:	85 f6                	test   %esi,%esi
  802793:	74 04                	je     802799 <devpipe_read+0x25>
				return i;
  802795:	89 f0                	mov    %esi,%eax
  802797:	eb 43                	jmp    8027dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802799:	89 da                	mov    %ebx,%edx
  80279b:	89 f8                	mov    %edi,%eax
  80279d:	e8 f1 fe ff ff       	call   802693 <_pipeisclosed>
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	75 31                	jne    8027d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027a6:	e8 fb eb ff ff       	call   8013a6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8027ab:	8b 03                	mov    (%ebx),%eax
  8027ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027b0:	74 df                	je     802791 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027b2:	99                   	cltd   
  8027b3:	c1 ea 1b             	shr    $0x1b,%edx
  8027b6:	01 d0                	add    %edx,%eax
  8027b8:	83 e0 1f             	and    $0x1f,%eax
  8027bb:	29 d0                	sub    %edx,%eax
  8027bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027cb:	83 c6 01             	add    $0x1,%esi
  8027ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027d1:	75 d8                	jne    8027ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8027d3:	89 f0                	mov    %esi,%eax
  8027d5:	eb 05                	jmp    8027dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8027dc:	83 c4 1c             	add    $0x1c,%esp
  8027df:	5b                   	pop    %ebx
  8027e0:	5e                   	pop    %esi
  8027e1:	5f                   	pop    %edi
  8027e2:	5d                   	pop    %ebp
  8027e3:	c3                   	ret    

008027e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	56                   	push   %esi
  8027e8:	53                   	push   %ebx
  8027e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ef:	89 04 24             	mov    %eax,(%esp)
  8027f2:	e8 10 f0 ff ff       	call   801807 <fd_alloc>
  8027f7:	89 c2                	mov    %eax,%edx
  8027f9:	85 d2                	test   %edx,%edx
  8027fb:	0f 88 4d 01 00 00    	js     80294e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802801:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802808:	00 
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802810:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802817:	e8 a9 eb ff ff       	call   8013c5 <sys_page_alloc>
  80281c:	89 c2                	mov    %eax,%edx
  80281e:	85 d2                	test   %edx,%edx
  802820:	0f 88 28 01 00 00    	js     80294e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802826:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802829:	89 04 24             	mov    %eax,(%esp)
  80282c:	e8 d6 ef ff ff       	call   801807 <fd_alloc>
  802831:	89 c3                	mov    %eax,%ebx
  802833:	85 c0                	test   %eax,%eax
  802835:	0f 88 fe 00 00 00    	js     802939 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80283b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802842:	00 
  802843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802846:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802851:	e8 6f eb ff ff       	call   8013c5 <sys_page_alloc>
  802856:	89 c3                	mov    %eax,%ebx
  802858:	85 c0                	test   %eax,%eax
  80285a:	0f 88 d9 00 00 00    	js     802939 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	89 04 24             	mov    %eax,(%esp)
  802866:	e8 85 ef ff ff       	call   8017f0 <fd2data>
  80286b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80286d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802874:	00 
  802875:	89 44 24 04          	mov    %eax,0x4(%esp)
  802879:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802880:	e8 40 eb ff ff       	call   8013c5 <sys_page_alloc>
  802885:	89 c3                	mov    %eax,%ebx
  802887:	85 c0                	test   %eax,%eax
  802889:	0f 88 97 00 00 00    	js     802926 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	89 04 24             	mov    %eax,(%esp)
  802895:	e8 56 ef ff ff       	call   8017f0 <fd2data>
  80289a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8028a1:	00 
  8028a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8028ad:	00 
  8028ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b9:	e8 5b eb ff ff       	call   801419 <sys_page_map>
  8028be:	89 c3                	mov    %eax,%ebx
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	78 52                	js     802916 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8028c4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8028d9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	89 04 24             	mov    %eax,(%esp)
  8028f4:	e8 e7 ee ff ff       	call   8017e0 <fd2num>
  8028f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028fc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802901:	89 04 24             	mov    %eax,(%esp)
  802904:	e8 d7 ee ff ff       	call   8017e0 <fd2num>
  802909:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80290c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80290f:	b8 00 00 00 00       	mov    $0x0,%eax
  802914:	eb 38                	jmp    80294e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802916:	89 74 24 04          	mov    %esi,0x4(%esp)
  80291a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802921:	e8 46 eb ff ff       	call   80146c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	89 44 24 04          	mov    %eax,0x4(%esp)
  80292d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802934:	e8 33 eb ff ff       	call   80146c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802940:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802947:	e8 20 eb ff ff       	call   80146c <sys_page_unmap>
  80294c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80294e:	83 c4 30             	add    $0x30,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5d                   	pop    %ebp
  802954:	c3                   	ret    

00802955 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80295b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80295e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	89 04 24             	mov    %eax,(%esp)
  802968:	e8 e9 ee ff ff       	call   801856 <fd_lookup>
  80296d:	89 c2                	mov    %eax,%edx
  80296f:	85 d2                	test   %edx,%edx
  802971:	78 15                	js     802988 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	89 04 24             	mov    %eax,(%esp)
  802979:	e8 72 ee ff ff       	call   8017f0 <fd2data>
	return _pipeisclosed(fd, p);
  80297e:	89 c2                	mov    %eax,%edx
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	e8 0b fd ff ff       	call   802693 <_pipeisclosed>
}
  802988:	c9                   	leave  
  802989:	c3                   	ret    
  80298a:	66 90                	xchg   %ax,%ax
  80298c:	66 90                	xchg   %ax,%ax
  80298e:	66 90                	xchg   %ax,%ax

00802990 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	5d                   	pop    %ebp
  802999:	c3                   	ret    

0080299a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8029a0:	c7 44 24 04 cd 36 80 	movl   $0x8036cd,0x4(%esp)
  8029a7:	00 
  8029a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ab:	89 04 24             	mov    %eax,(%esp)
  8029ae:	e8 a4 e5 ff ff       	call   800f57 <strcpy>
	return 0;
}
  8029b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	57                   	push   %edi
  8029be:	56                   	push   %esi
  8029bf:	53                   	push   %ebx
  8029c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029d1:	eb 31                	jmp    802a04 <devcons_write+0x4a>
		m = n - tot;
  8029d3:	8b 75 10             	mov    0x10(%ebp),%esi
  8029d6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8029d8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8029db:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8029e0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8029e7:	03 45 0c             	add    0xc(%ebp),%eax
  8029ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ee:	89 3c 24             	mov    %edi,(%esp)
  8029f1:	e8 fe e6 ff ff       	call   8010f4 <memmove>
		sys_cputs(buf, m);
  8029f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029fa:	89 3c 24             	mov    %edi,(%esp)
  8029fd:	e8 a4 e8 ff ff       	call   8012a6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a02:	01 f3                	add    %esi,%ebx
  802a04:	89 d8                	mov    %ebx,%eax
  802a06:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802a09:	72 c8                	jb     8029d3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a0b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a11:	5b                   	pop    %ebx
  802a12:	5e                   	pop    %esi
  802a13:	5f                   	pop    %edi
  802a14:	5d                   	pop    %ebp
  802a15:	c3                   	ret    

00802a16 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a16:	55                   	push   %ebp
  802a17:	89 e5                	mov    %esp,%ebp
  802a19:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802a1c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802a21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a25:	75 07                	jne    802a2e <devcons_read+0x18>
  802a27:	eb 2a                	jmp    802a53 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a29:	e8 78 e9 ff ff       	call   8013a6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802a2e:	66 90                	xchg   %ax,%ax
  802a30:	e8 8f e8 ff ff       	call   8012c4 <sys_cgetc>
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 f0                	je     802a29 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	78 16                	js     802a53 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802a3d:	83 f8 04             	cmp    $0x4,%eax
  802a40:	74 0c                	je     802a4e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802a42:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a45:	88 02                	mov    %al,(%edx)
	return 1;
  802a47:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4c:	eb 05                	jmp    802a53 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802a4e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802a53:	c9                   	leave  
  802a54:	c3                   	ret    

00802a55 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a55:	55                   	push   %ebp
  802a56:	89 e5                	mov    %esp,%ebp
  802a58:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a61:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a68:	00 
  802a69:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a6c:	89 04 24             	mov    %eax,(%esp)
  802a6f:	e8 32 e8 ff ff       	call   8012a6 <sys_cputs>
}
  802a74:	c9                   	leave  
  802a75:	c3                   	ret    

00802a76 <getchar>:

int
getchar(void)
{
  802a76:	55                   	push   %ebp
  802a77:	89 e5                	mov    %esp,%ebp
  802a79:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a7c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a83:	00 
  802a84:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a8b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a92:	e8 53 f0 ff ff       	call   801aea <read>
	if (r < 0)
  802a97:	85 c0                	test   %eax,%eax
  802a99:	78 0f                	js     802aaa <getchar+0x34>
		return r;
	if (r < 1)
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	7e 06                	jle    802aa5 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a9f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802aa3:	eb 05                	jmp    802aaa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802aa5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802aaa:	c9                   	leave  
  802aab:	c3                   	ret    

00802aac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802aac:	55                   	push   %ebp
  802aad:	89 e5                	mov    %esp,%ebp
  802aaf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ab2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	89 04 24             	mov    %eax,(%esp)
  802abf:	e8 92 ed ff ff       	call   801856 <fd_lookup>
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	78 11                	js     802ad9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802ad1:	39 10                	cmp    %edx,(%eax)
  802ad3:	0f 94 c0             	sete   %al
  802ad6:	0f b6 c0             	movzbl %al,%eax
}
  802ad9:	c9                   	leave  
  802ada:	c3                   	ret    

00802adb <opencons>:

int
opencons(void)
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ae1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ae4:	89 04 24             	mov    %eax,(%esp)
  802ae7:	e8 1b ed ff ff       	call   801807 <fd_alloc>
		return r;
  802aec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802aee:	85 c0                	test   %eax,%eax
  802af0:	78 40                	js     802b32 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802af2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802af9:	00 
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b08:	e8 b8 e8 ff ff       	call   8013c5 <sys_page_alloc>
		return r;
  802b0d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	78 1f                	js     802b32 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b13:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b28:	89 04 24             	mov    %eax,(%esp)
  802b2b:	e8 b0 ec ff ff       	call   8017e0 <fd2num>
  802b30:	89 c2                	mov    %eax,%edx
}
  802b32:	89 d0                	mov    %edx,%eax
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
  802b39:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b3c:	89 d0                	mov    %edx,%eax
  802b3e:	c1 e8 16             	shr    $0x16,%eax
  802b41:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b48:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b4d:	f6 c1 01             	test   $0x1,%cl
  802b50:	74 1d                	je     802b6f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b52:	c1 ea 0c             	shr    $0xc,%edx
  802b55:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b5c:	f6 c2 01             	test   $0x1,%dl
  802b5f:	74 0e                	je     802b6f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b61:	c1 ea 0c             	shr    $0xc,%edx
  802b64:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b6b:	ef 
  802b6c:	0f b7 c0             	movzwl %ax,%eax
}
  802b6f:	5d                   	pop    %ebp
  802b70:	c3                   	ret    
  802b71:	66 90                	xchg   %ax,%ax
  802b73:	66 90                	xchg   %ax,%ax
  802b75:	66 90                	xchg   %ax,%ax
  802b77:	66 90                	xchg   %ax,%ax
  802b79:	66 90                	xchg   %ax,%ax
  802b7b:	66 90                	xchg   %ax,%ax
  802b7d:	66 90                	xchg   %ax,%ax
  802b7f:	90                   	nop

00802b80 <__udivdi3>:
  802b80:	55                   	push   %ebp
  802b81:	57                   	push   %edi
  802b82:	56                   	push   %esi
  802b83:	83 ec 0c             	sub    $0xc,%esp
  802b86:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b8a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b8e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b92:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b96:	85 c0                	test   %eax,%eax
  802b98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b9c:	89 ea                	mov    %ebp,%edx
  802b9e:	89 0c 24             	mov    %ecx,(%esp)
  802ba1:	75 2d                	jne    802bd0 <__udivdi3+0x50>
  802ba3:	39 e9                	cmp    %ebp,%ecx
  802ba5:	77 61                	ja     802c08 <__udivdi3+0x88>
  802ba7:	85 c9                	test   %ecx,%ecx
  802ba9:	89 ce                	mov    %ecx,%esi
  802bab:	75 0b                	jne    802bb8 <__udivdi3+0x38>
  802bad:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb2:	31 d2                	xor    %edx,%edx
  802bb4:	f7 f1                	div    %ecx
  802bb6:	89 c6                	mov    %eax,%esi
  802bb8:	31 d2                	xor    %edx,%edx
  802bba:	89 e8                	mov    %ebp,%eax
  802bbc:	f7 f6                	div    %esi
  802bbe:	89 c5                	mov    %eax,%ebp
  802bc0:	89 f8                	mov    %edi,%eax
  802bc2:	f7 f6                	div    %esi
  802bc4:	89 ea                	mov    %ebp,%edx
  802bc6:	83 c4 0c             	add    $0xc,%esp
  802bc9:	5e                   	pop    %esi
  802bca:	5f                   	pop    %edi
  802bcb:	5d                   	pop    %ebp
  802bcc:	c3                   	ret    
  802bcd:	8d 76 00             	lea    0x0(%esi),%esi
  802bd0:	39 e8                	cmp    %ebp,%eax
  802bd2:	77 24                	ja     802bf8 <__udivdi3+0x78>
  802bd4:	0f bd e8             	bsr    %eax,%ebp
  802bd7:	83 f5 1f             	xor    $0x1f,%ebp
  802bda:	75 3c                	jne    802c18 <__udivdi3+0x98>
  802bdc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802be0:	39 34 24             	cmp    %esi,(%esp)
  802be3:	0f 86 9f 00 00 00    	jbe    802c88 <__udivdi3+0x108>
  802be9:	39 d0                	cmp    %edx,%eax
  802beb:	0f 82 97 00 00 00    	jb     802c88 <__udivdi3+0x108>
  802bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bf8:	31 d2                	xor    %edx,%edx
  802bfa:	31 c0                	xor    %eax,%eax
  802bfc:	83 c4 0c             	add    $0xc,%esp
  802bff:	5e                   	pop    %esi
  802c00:	5f                   	pop    %edi
  802c01:	5d                   	pop    %ebp
  802c02:	c3                   	ret    
  802c03:	90                   	nop
  802c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c08:	89 f8                	mov    %edi,%eax
  802c0a:	f7 f1                	div    %ecx
  802c0c:	31 d2                	xor    %edx,%edx
  802c0e:	83 c4 0c             	add    $0xc,%esp
  802c11:	5e                   	pop    %esi
  802c12:	5f                   	pop    %edi
  802c13:	5d                   	pop    %ebp
  802c14:	c3                   	ret    
  802c15:	8d 76 00             	lea    0x0(%esi),%esi
  802c18:	89 e9                	mov    %ebp,%ecx
  802c1a:	8b 3c 24             	mov    (%esp),%edi
  802c1d:	d3 e0                	shl    %cl,%eax
  802c1f:	89 c6                	mov    %eax,%esi
  802c21:	b8 20 00 00 00       	mov    $0x20,%eax
  802c26:	29 e8                	sub    %ebp,%eax
  802c28:	89 c1                	mov    %eax,%ecx
  802c2a:	d3 ef                	shr    %cl,%edi
  802c2c:	89 e9                	mov    %ebp,%ecx
  802c2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c32:	8b 3c 24             	mov    (%esp),%edi
  802c35:	09 74 24 08          	or     %esi,0x8(%esp)
  802c39:	89 d6                	mov    %edx,%esi
  802c3b:	d3 e7                	shl    %cl,%edi
  802c3d:	89 c1                	mov    %eax,%ecx
  802c3f:	89 3c 24             	mov    %edi,(%esp)
  802c42:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c46:	d3 ee                	shr    %cl,%esi
  802c48:	89 e9                	mov    %ebp,%ecx
  802c4a:	d3 e2                	shl    %cl,%edx
  802c4c:	89 c1                	mov    %eax,%ecx
  802c4e:	d3 ef                	shr    %cl,%edi
  802c50:	09 d7                	or     %edx,%edi
  802c52:	89 f2                	mov    %esi,%edx
  802c54:	89 f8                	mov    %edi,%eax
  802c56:	f7 74 24 08          	divl   0x8(%esp)
  802c5a:	89 d6                	mov    %edx,%esi
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	f7 24 24             	mull   (%esp)
  802c61:	39 d6                	cmp    %edx,%esi
  802c63:	89 14 24             	mov    %edx,(%esp)
  802c66:	72 30                	jb     802c98 <__udivdi3+0x118>
  802c68:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c6c:	89 e9                	mov    %ebp,%ecx
  802c6e:	d3 e2                	shl    %cl,%edx
  802c70:	39 c2                	cmp    %eax,%edx
  802c72:	73 05                	jae    802c79 <__udivdi3+0xf9>
  802c74:	3b 34 24             	cmp    (%esp),%esi
  802c77:	74 1f                	je     802c98 <__udivdi3+0x118>
  802c79:	89 f8                	mov    %edi,%eax
  802c7b:	31 d2                	xor    %edx,%edx
  802c7d:	e9 7a ff ff ff       	jmp    802bfc <__udivdi3+0x7c>
  802c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c88:	31 d2                	xor    %edx,%edx
  802c8a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c8f:	e9 68 ff ff ff       	jmp    802bfc <__udivdi3+0x7c>
  802c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c98:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c9b:	31 d2                	xor    %edx,%edx
  802c9d:	83 c4 0c             	add    $0xc,%esp
  802ca0:	5e                   	pop    %esi
  802ca1:	5f                   	pop    %edi
  802ca2:	5d                   	pop    %ebp
  802ca3:	c3                   	ret    
  802ca4:	66 90                	xchg   %ax,%ax
  802ca6:	66 90                	xchg   %ax,%ax
  802ca8:	66 90                	xchg   %ax,%ax
  802caa:	66 90                	xchg   %ax,%ax
  802cac:	66 90                	xchg   %ax,%ax
  802cae:	66 90                	xchg   %ax,%ax

00802cb0 <__umoddi3>:
  802cb0:	55                   	push   %ebp
  802cb1:	57                   	push   %edi
  802cb2:	56                   	push   %esi
  802cb3:	83 ec 14             	sub    $0x14,%esp
  802cb6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cbe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802cc2:	89 c7                	mov    %eax,%edi
  802cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cc8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802ccc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802cd0:	89 34 24             	mov    %esi,(%esp)
  802cd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	89 c2                	mov    %eax,%edx
  802cdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cdf:	75 17                	jne    802cf8 <__umoddi3+0x48>
  802ce1:	39 fe                	cmp    %edi,%esi
  802ce3:	76 4b                	jbe    802d30 <__umoddi3+0x80>
  802ce5:	89 c8                	mov    %ecx,%eax
  802ce7:	89 fa                	mov    %edi,%edx
  802ce9:	f7 f6                	div    %esi
  802ceb:	89 d0                	mov    %edx,%eax
  802ced:	31 d2                	xor    %edx,%edx
  802cef:	83 c4 14             	add    $0x14,%esp
  802cf2:	5e                   	pop    %esi
  802cf3:	5f                   	pop    %edi
  802cf4:	5d                   	pop    %ebp
  802cf5:	c3                   	ret    
  802cf6:	66 90                	xchg   %ax,%ax
  802cf8:	39 f8                	cmp    %edi,%eax
  802cfa:	77 54                	ja     802d50 <__umoddi3+0xa0>
  802cfc:	0f bd e8             	bsr    %eax,%ebp
  802cff:	83 f5 1f             	xor    $0x1f,%ebp
  802d02:	75 5c                	jne    802d60 <__umoddi3+0xb0>
  802d04:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d08:	39 3c 24             	cmp    %edi,(%esp)
  802d0b:	0f 87 e7 00 00 00    	ja     802df8 <__umoddi3+0x148>
  802d11:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d15:	29 f1                	sub    %esi,%ecx
  802d17:	19 c7                	sbb    %eax,%edi
  802d19:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d21:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d25:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d29:	83 c4 14             	add    $0x14,%esp
  802d2c:	5e                   	pop    %esi
  802d2d:	5f                   	pop    %edi
  802d2e:	5d                   	pop    %ebp
  802d2f:	c3                   	ret    
  802d30:	85 f6                	test   %esi,%esi
  802d32:	89 f5                	mov    %esi,%ebp
  802d34:	75 0b                	jne    802d41 <__umoddi3+0x91>
  802d36:	b8 01 00 00 00       	mov    $0x1,%eax
  802d3b:	31 d2                	xor    %edx,%edx
  802d3d:	f7 f6                	div    %esi
  802d3f:	89 c5                	mov    %eax,%ebp
  802d41:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d45:	31 d2                	xor    %edx,%edx
  802d47:	f7 f5                	div    %ebp
  802d49:	89 c8                	mov    %ecx,%eax
  802d4b:	f7 f5                	div    %ebp
  802d4d:	eb 9c                	jmp    802ceb <__umoddi3+0x3b>
  802d4f:	90                   	nop
  802d50:	89 c8                	mov    %ecx,%eax
  802d52:	89 fa                	mov    %edi,%edx
  802d54:	83 c4 14             	add    $0x14,%esp
  802d57:	5e                   	pop    %esi
  802d58:	5f                   	pop    %edi
  802d59:	5d                   	pop    %ebp
  802d5a:	c3                   	ret    
  802d5b:	90                   	nop
  802d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d60:	8b 04 24             	mov    (%esp),%eax
  802d63:	be 20 00 00 00       	mov    $0x20,%esi
  802d68:	89 e9                	mov    %ebp,%ecx
  802d6a:	29 ee                	sub    %ebp,%esi
  802d6c:	d3 e2                	shl    %cl,%edx
  802d6e:	89 f1                	mov    %esi,%ecx
  802d70:	d3 e8                	shr    %cl,%eax
  802d72:	89 e9                	mov    %ebp,%ecx
  802d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d78:	8b 04 24             	mov    (%esp),%eax
  802d7b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d7f:	89 fa                	mov    %edi,%edx
  802d81:	d3 e0                	shl    %cl,%eax
  802d83:	89 f1                	mov    %esi,%ecx
  802d85:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d89:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d8d:	d3 ea                	shr    %cl,%edx
  802d8f:	89 e9                	mov    %ebp,%ecx
  802d91:	d3 e7                	shl    %cl,%edi
  802d93:	89 f1                	mov    %esi,%ecx
  802d95:	d3 e8                	shr    %cl,%eax
  802d97:	89 e9                	mov    %ebp,%ecx
  802d99:	09 f8                	or     %edi,%eax
  802d9b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d9f:	f7 74 24 04          	divl   0x4(%esp)
  802da3:	d3 e7                	shl    %cl,%edi
  802da5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802da9:	89 d7                	mov    %edx,%edi
  802dab:	f7 64 24 08          	mull   0x8(%esp)
  802daf:	39 d7                	cmp    %edx,%edi
  802db1:	89 c1                	mov    %eax,%ecx
  802db3:	89 14 24             	mov    %edx,(%esp)
  802db6:	72 2c                	jb     802de4 <__umoddi3+0x134>
  802db8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802dbc:	72 22                	jb     802de0 <__umoddi3+0x130>
  802dbe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802dc2:	29 c8                	sub    %ecx,%eax
  802dc4:	19 d7                	sbb    %edx,%edi
  802dc6:	89 e9                	mov    %ebp,%ecx
  802dc8:	89 fa                	mov    %edi,%edx
  802dca:	d3 e8                	shr    %cl,%eax
  802dcc:	89 f1                	mov    %esi,%ecx
  802dce:	d3 e2                	shl    %cl,%edx
  802dd0:	89 e9                	mov    %ebp,%ecx
  802dd2:	d3 ef                	shr    %cl,%edi
  802dd4:	09 d0                	or     %edx,%eax
  802dd6:	89 fa                	mov    %edi,%edx
  802dd8:	83 c4 14             	add    $0x14,%esp
  802ddb:	5e                   	pop    %esi
  802ddc:	5f                   	pop    %edi
  802ddd:	5d                   	pop    %ebp
  802dde:	c3                   	ret    
  802ddf:	90                   	nop
  802de0:	39 d7                	cmp    %edx,%edi
  802de2:	75 da                	jne    802dbe <__umoddi3+0x10e>
  802de4:	8b 14 24             	mov    (%esp),%edx
  802de7:	89 c1                	mov    %eax,%ecx
  802de9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802ded:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802df1:	eb cb                	jmp    802dbe <__umoddi3+0x10e>
  802df3:	90                   	nop
  802df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802df8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802dfc:	0f 82 0f ff ff ff    	jb     802d11 <__umoddi3+0x61>
  802e02:	e9 1a ff ff ff       	jmp    802d21 <__umoddi3+0x71>
