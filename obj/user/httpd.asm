
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 6c 08 00 00       	call   80089d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 f5 37 80 00 	movl   $0x8037f5,(%esp)
  800051:	e8 a1 09 00 00       	call   8009f7 <cprintf>
	exit();
  800056:	e8 8a 08 00 00       	call   8008e5 <exit>
}
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    

0080005d <send_error>:
	return 0;
}

static int
send_error(struct http_request *req, int code)
{
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	57                   	push   %edi
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	81 ec 2c 02 00 00    	sub    $0x22c,%esp
  800069:	89 c6                	mov    %eax,%esi
	char buf[512];
	int r;

	struct error_messages *e = errors;
  80006b:	b9 00 40 80 00       	mov    $0x804000,%ecx
	while (e->code != 0 && e->msg != 0) {
  800070:	eb 07                	jmp    800079 <send_error+0x1c>
		if (e->code == code)
  800072:	39 d3                	cmp    %edx,%ebx
  800074:	74 11                	je     800087 <send_error+0x2a>
			break;
		e++;
  800076:	83 c1 08             	add    $0x8,%ecx
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800079:	8b 19                	mov    (%ecx),%ebx
  80007b:	85 db                	test   %ebx,%ebx
  80007d:	74 5d                	je     8000dc <send_error+0x7f>
  80007f:	83 79 04 00          	cmpl   $0x0,0x4(%ecx)
  800083:	75 ed                	jne    800072 <send_error+0x15>
  800085:	eb 04                	jmp    80008b <send_error+0x2e>
		if (e->code == code)
			break;
		e++;
	}

	if (e->code == 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	74 58                	je     8000e3 <send_error+0x86>
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80008b:	8b 41 04             	mov    0x4(%ecx),%eax
  80008e:	89 44 24 18          	mov    %eax,0x18(%esp)
  800092:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  800096:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009e:	c7 44 24 08 90 32 80 	movl   $0x803290,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  8000ad:	00 
  8000ae:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  8000b4:	89 3c 24             	mov    %edi,(%esp)
  8000b7:	e8 59 0f 00 00       	call   801015 <snprintf>
  8000bc:	89 c3                	mov    %eax,%ebx
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8000be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000c6:	8b 06                	mov    (%esi),%eax
  8000c8:	89 04 24             	mov    %eax,(%esp)
  8000cb:	e8 07 1b 00 00       	call   801bd7 <write>
  8000d0:	39 c3                	cmp    %eax,%ebx
  8000d2:	0f 95 c0             	setne  %al
  8000d5:	0f b6 c0             	movzbl %al,%eax
  8000d8:	f7 d8                	neg    %eax
  8000da:	eb 0c                	jmp    8000e8 <send_error+0x8b>
			break;
		e++;
	}

	if (e->code == 0)
		return -1;
  8000dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8000e1:	eb 05                	jmp    8000e8 <send_error+0x8b>
  8000e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	if (write(req->sock, buf, r) != r)
		return -1;

	return 0;
}
  8000e8:	81 c4 2c 02 00 00    	add    $0x22c,%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	81 ec 4c 03 00 00    	sub    $0x34c,%esp
  8000ff:	89 c6                	mov    %eax,%esi
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800101:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800108:	00 
  800109:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800113:	89 34 24             	mov    %esi,(%esp)
  800116:	e8 df 19 00 00       	call   801afa <read>
  80011b:	85 c0                	test   %eax,%eax
  80011d:	79 1c                	jns    80013b <handle_client+0x48>
			panic("failed to read");
  80011f:	c7 44 24 08 e0 31 80 	movl   $0x8031e0,0x8(%esp)
  800126:	00 
  800127:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  80012e:	00 
  80012f:	c7 04 24 ef 31 80 00 	movl   $0x8031ef,(%esp)
  800136:	e8 c3 07 00 00       	call   8008fe <_panic>

		memset(req, 0, sizeof(req));
  80013b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80014a:	00 
  80014b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80014e:	89 04 24             	mov    %eax,(%esp)
  800151:	e8 71 10 00 00       	call   8011c7 <memset>

		req->sock = sock;
  800156:	89 75 dc             	mov    %esi,-0x24(%ebp)
	int url_len, version_len;

	if (!req)
		return -1;

	if (strncmp(request, "GET ", 4) != 0)
  800159:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800160:	00 
  800161:	c7 44 24 04 fc 31 80 	movl   $0x8031fc,0x4(%esp)
  800168:	00 
  800169:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80016f:	89 04 24             	mov    %eax,(%esp)
  800172:	e8 db 0f 00 00       	call   801152 <strncmp>
  800177:	85 c0                	test   %eax,%eax
  800179:	0f 85 a4 02 00 00    	jne    800423 <handle_client+0x330>
		return -E_BAD_REQ;

	// skip GET
	request += 4;
  80017f:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
  800185:	eb 03                	jmp    80018a <handle_client+0x97>

	// get the url
	url = request;
	while (*request && *request != ' ')
		request++;
  800187:	83 c3 01             	add    $0x1,%ebx
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  80018a:	f6 03 df             	testb  $0xdf,(%ebx)
  80018d:	75 f8                	jne    800187 <handle_client+0x94>
		request++;
	url_len = request - url;
  80018f:	89 df                	mov    %ebx,%edi
  800191:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  800197:	29 c7                	sub    %eax,%edi

	req->url = malloc(url_len + 1);
  800199:	8d 47 01             	lea    0x1(%edi),%eax
  80019c:	89 04 24             	mov    %eax,(%esp)
  80019f:	e8 4e 25 00 00       	call   8026f2 <malloc>
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8001a7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001ab:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  8001b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8001b5:	89 04 24             	mov    %eax,(%esp)
  8001b8:	e8 57 10 00 00       	call   801214 <memmove>
	req->url[url_len] = '\0';
  8001bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c0:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)

	// skip space
	request++;
  8001c4:	83 c3 01             	add    $0x1,%ebx
  8001c7:	89 d8                	mov    %ebx,%eax
  8001c9:	eb 03                	jmp    8001ce <handle_client+0xdb>

	version = request;
	while (*request && *request != '\n')
		request++;
  8001cb:	83 c0 01             	add    $0x1,%eax

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  8001ce:	0f b6 10             	movzbl (%eax),%edx
  8001d1:	80 fa 0a             	cmp    $0xa,%dl
  8001d4:	74 04                	je     8001da <handle_client+0xe7>
  8001d6:	84 d2                	test   %dl,%dl
  8001d8:	75 f1                	jne    8001cb <handle_client+0xd8>
		request++;
	version_len = request - version;
  8001da:	29 d8                	sub    %ebx,%eax
  8001dc:	89 c7                	mov    %eax,%edi

	req->version = malloc(version_len + 1);
  8001de:	8d 40 01             	lea    0x1(%eax),%eax
  8001e1:	89 04 24             	mov    %eax,(%esp)
  8001e4:	e8 09 25 00 00       	call   8026f2 <malloc>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  8001ec:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 18 10 00 00       	call   801214 <memmove>
	req->version[version_len] = '\0';
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
send_file(struct http_request *req)
{
	int r;
	off_t file_size = -1;
	int fd;
	cprintf("\nurl:%s\n",req->url);
  800203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020a:	c7 04 24 01 32 80 00 	movl   $0x803201,(%esp)
  800211:	e8 e1 07 00 00       	call   8009f7 <cprintf>
	// set file_size to the size of the file

	// LAB 6: Your code here.
	//panic("send_file not implemented");

	if ((fd = open(req->url, O_RDONLY)) < 0){
  800216:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80021d:	00 
  80021e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800221:	89 04 24             	mov    %eax,(%esp)
  800224:	e8 1b 1e 00 00       	call   802044 <open>
  800229:	89 c7                	mov    %eax,%edi
  80022b:	85 c0                	test   %eax,%eax
  80022d:	79 12                	jns    800241 <handle_client+0x14e>
		send_error(req, 404);
  80022f:	ba 94 01 00 00       	mov    $0x194,%edx
  800234:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800237:	e8 21 fe ff ff       	call   80005d <send_error>
  80023c:	e9 c2 01 00 00       	jmp    800403 <handle_client+0x310>
		return -1;
	}
	if (fstat(fd, &st) >= 0) 
  800241:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	89 3c 24             	mov    %edi,(%esp)
  80024e:	e8 c3 1a 00 00       	call   801d16 <fstat>

static int
send_file(struct http_request *req)
{
	int r;
	off_t file_size = -1;
  800253:	c7 85 c4 fc ff ff ff 	movl   $0xffffffff,-0x33c(%ebp)
  80025a:	ff ff ff 

	if ((fd = open(req->url, O_RDONLY)) < 0){
		send_error(req, 404);
		return -1;
	}
	if (fstat(fd, &st) >= 0) 
  80025d:	85 c0                	test   %eax,%eax
  80025f:	78 38                	js     800299 <handle_client+0x1a6>
		if(st.st_isdir){
			cprintf("\nis dir\n");
			send_error(req, 404);
		}
		else
			file_size = st.st_size;
  800261:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
  800267:	89 85 c4 fc ff ff    	mov    %eax,-0x33c(%ebp)
		send_error(req, 404);
		return -1;
	}
	if (fstat(fd, &st) >= 0) 
	{	
		if(st.st_isdir){
  80026d:	83 bd d4 fd ff ff 00 	cmpl   $0x0,-0x22c(%ebp)
  800274:	74 23                	je     800299 <handle_client+0x1a6>
			cprintf("\nis dir\n");
  800276:	c7 04 24 0a 32 80 00 	movl   $0x80320a,(%esp)
  80027d:	e8 75 07 00 00       	call   8009f7 <cprintf>
			send_error(req, 404);
  800282:	ba 94 01 00 00       	mov    $0x194,%edx
  800287:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80028a:	e8 ce fd ff ff       	call   80005d <send_error>

static int
send_file(struct http_request *req)
{
	int r;
	off_t file_size = -1;
  80028f:	c7 85 c4 fc ff ff ff 	movl   $0xffffffff,-0x33c(%ebp)
  800296:	ff ff ff 
}

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
  800299:	bb 10 40 80 00       	mov    $0x804010,%ebx
  80029e:	eb 0a                	jmp    8002aa <handle_client+0x1b7>
	while (h->code != 0 && h->header!= 0) {
		if (h->code == code)
  8002a0:	3d c8 00 00 00       	cmp    $0xc8,%eax
  8002a5:	74 13                	je     8002ba <handle_client+0x1c7>
			break;
		h++;
  8002a7:	83 c3 08             	add    $0x8,%ebx

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  8002aa:	8b 03                	mov    (%ebx),%eax
  8002ac:	85 c0                	test   %eax,%eax
  8002ae:	0f 84 47 01 00 00    	je     8003fb <handle_client+0x308>
  8002b4:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  8002b8:	75 e6                	jne    8002a0 <handle_client+0x1ad>
	}

	if (h->code == 0)
		return -1;

	int len = strlen(h->header);
  8002ba:	8b 43 04             	mov    0x4(%ebx),%eax
  8002bd:	89 04 24             	mov    %eax,(%esp)
  8002c0:	e8 7b 0d 00 00       	call   801040 <strlen>
	if (write(req->sock, h->header, len) != len) {
  8002c5:	89 85 c0 fc ff ff    	mov    %eax,-0x340(%ebp)
  8002cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002cf:	8b 43 04             	mov    0x4(%ebx),%eax
  8002d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 f6 18 00 00       	call   801bd7 <write>
  8002e1:	39 85 c0 fc ff ff    	cmp    %eax,-0x340(%ebp)
  8002e7:	0f 84 45 01 00 00    	je     800432 <handle_client+0x33f>
		die("Failed to send bytes to client");
  8002ed:	b8 0c 33 80 00       	mov    $0x80330c,%eax
  8002f2:	e8 49 fd ff ff       	call   800040 <die>
  8002f7:	e9 36 01 00 00       	jmp    800432 <handle_client+0x33f>
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
	if (r > 63)
		panic("buffer too small!");
  8002fc:	c7 44 24 08 13 32 80 	movl   $0x803213,0x8(%esp)
  800303:	00 
  800304:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  80030b:	00 
  80030c:	c7 04 24 ef 31 80 00 	movl   $0x8031ef,(%esp)
  800313:	e8 e6 05 00 00       	call   8008fe <_panic>

	if (write(req->sock, buf, r) != r)
  800318:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80031c:	8d 85 d0 fc ff ff    	lea    -0x330(%ebp),%eax
  800322:	89 44 24 04          	mov    %eax,0x4(%esp)
  800326:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800329:	89 04 24             	mov    %eax,(%esp)
  80032c:	e8 a6 18 00 00       	call   801bd7 <write>
			file_size = st.st_size;
	}
	if ((r = send_header(req, 200)) < 0)
		goto end;

	if ((r = send_size(req, file_size)) < 0)
  800331:	39 c3                	cmp    %eax,%ebx
  800333:	0f 85 c2 00 00 00    	jne    8003fb <handle_client+0x308>

	type = mime_type(req->url);
	if (!type)
		return -1;

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  800339:	c7 44 24 0c 25 32 80 	movl   $0x803225,0xc(%esp)
  800340:	00 
  800341:	c7 44 24 08 2f 32 80 	movl   $0x80322f,0x8(%esp)
  800348:	00 
  800349:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  800350:	00 
  800351:	8d 85 d0 fc ff ff    	lea    -0x330(%ebp),%eax
  800357:	89 04 24             	mov    %eax,(%esp)
  80035a:	e8 b6 0c 00 00       	call   801015 <snprintf>
  80035f:	89 c3                	mov    %eax,%ebx
	if (r > 127)
  800361:	83 f8 7f             	cmp    $0x7f,%eax
  800364:	7e 1c                	jle    800382 <handle_client+0x28f>
		panic("buffer too small!");
  800366:	c7 44 24 08 13 32 80 	movl   $0x803213,0x8(%esp)
  80036d:	00 
  80036e:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800375:	00 
  800376:	c7 04 24 ef 31 80 00 	movl   $0x8031ef,(%esp)
  80037d:	e8 7c 05 00 00       	call   8008fe <_panic>

	if (write(req->sock, buf, r) != r)
  800382:	89 44 24 08          	mov    %eax,0x8(%esp)
  800386:	8d 85 d0 fc ff ff    	lea    -0x330(%ebp),%eax
  80038c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	89 04 24             	mov    %eax,(%esp)
  800396:	e8 3c 18 00 00       	call   801bd7 <write>
		goto end;

	if ((r = send_size(req, file_size)) < 0)
		goto end;

	if ((r = send_content_type(req)) < 0)
  80039b:	39 c3                	cmp    %eax,%ebx
  80039d:	75 5c                	jne    8003fb <handle_client+0x308>

static int
send_header_fin(struct http_request *req)
{
	const char *fin = "\r\n";
	int fin_len = strlen(fin);
  80039f:	c7 04 24 55 32 80 00 	movl   $0x803255,(%esp)
  8003a6:	e8 95 0c 00 00       	call   801040 <strlen>
  8003ab:	89 c3                	mov    %eax,%ebx

	if (write(req->sock, fin, fin_len) != fin_len)
  8003ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b1:	c7 44 24 04 55 32 80 	movl   $0x803255,0x4(%esp)
  8003b8:	00 
  8003b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003bc:	89 04 24             	mov    %eax,(%esp)
  8003bf:	e8 13 18 00 00       	call   801bd7 <write>
		goto end;

	if ((r = send_content_type(req)) < 0)
		goto end;

	if ((r = send_header_fin(req)) < 0)
  8003c4:	39 c3                	cmp    %eax,%ebx
  8003c6:	75 33                	jne    8003fb <handle_client+0x308>
send_data(struct http_request *req, int fd)
{
	// LAB 6: Your code here.
	char buf[100];
	int count=0;
	while((count=read(fd, buf, 100)))
  8003c8:	8d 9d d0 fc ff ff    	lea    -0x330(%ebp),%ebx
  8003ce:	eb 13                	jmp    8003e3 <handle_client+0x2f0>
	{
		write(req->sock, buf,count);
  8003d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003db:	89 04 24             	mov    %eax,(%esp)
  8003de:	e8 f4 17 00 00       	call   801bd7 <write>
send_data(struct http_request *req, int fd)
{
	// LAB 6: Your code here.
	char buf[100];
	int count=0;
	while((count=read(fd, buf, 100)))
  8003e3:	c7 44 24 08 64 00 00 	movl   $0x64,0x8(%esp)
  8003ea:	00 
  8003eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003ef:	89 3c 24             	mov    %edi,(%esp)
  8003f2:	e8 03 17 00 00       	call   801afa <read>
  8003f7:	85 c0                	test   %eax,%eax
  8003f9:	75 d5                	jne    8003d0 <handle_client+0x2dd>
		goto end;

	r = send_data(req, fd);

end:
	close(fd);
  8003fb:	89 3c 24             	mov    %edi,(%esp)
  8003fe:	e8 94 15 00 00       	call   801997 <close>
}

static void
req_free(struct http_request *req)
{
	free(req->url);
  800403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800406:	89 04 24             	mov    %eax,(%esp)
  800409:	e8 12 22 00 00       	call   802620 <free>
	free(req->version);
  80040e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	e8 07 22 00 00       	call   802620 <free>

		// no keep alive
		break;
	}

	close(sock);
  800419:	89 34 24             	mov    %esi,(%esp)
  80041c:	e8 76 15 00 00       	call   801997 <close>
  800421:	eb 47                	jmp    80046a <handle_client+0x377>

		req->sock = sock;

		r = http_request_parse(req, buffer);
		if (r == -E_BAD_REQ)
			send_error(req, 400);
  800423:	ba 90 01 00 00       	mov    $0x190,%edx
  800428:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80042b:	e8 2d fc ff ff       	call   80005d <send_error>
  800430:	eb d1                	jmp    800403 <handle_client+0x310>
send_size(struct http_request *req, off_t size)
{
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  800432:	8b 85 c4 fc ff ff    	mov    -0x33c(%ebp),%eax
  800438:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80043c:	c7 44 24 08 42 32 80 	movl   $0x803242,0x8(%esp)
  800443:	00 
  800444:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  80044b:	00 
  80044c:	8d 85 d0 fc ff ff    	lea    -0x330(%ebp),%eax
  800452:	89 04 24             	mov    %eax,(%esp)
  800455:	e8 bb 0b 00 00       	call   801015 <snprintf>
  80045a:	89 c3                	mov    %eax,%ebx
	if (r > 63)
  80045c:	83 f8 3f             	cmp    $0x3f,%eax
  80045f:	0f 8e b3 fe ff ff    	jle    800318 <handle_client+0x225>
  800465:	e9 92 fe ff ff       	jmp    8002fc <handle_client+0x209>
		// no keep alive
		break;
	}

	close(sock);
}
  80046a:	81 c4 4c 03 00 00    	add    $0x34c,%esp
  800470:	5b                   	pop    %ebx
  800471:	5e                   	pop    %esi
  800472:	5f                   	pop    %edi
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <umain>:

void
umain(int argc, char **argv)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	57                   	push   %edi
  800479:	56                   	push   %esi
  80047a:	53                   	push   %ebx
  80047b:	83 ec 4c             	sub    $0x4c,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  80047e:	c7 05 20 40 80 00 58 	movl   $0x803258,0x804020
  800485:	32 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800488:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80048f:	00 
  800490:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800497:	00 
  800498:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80049f:	e8 93 1e 00 00       	call   802337 <socket>
  8004a4:	89 c6                	mov    %eax,%esi
  8004a6:	85 c0                	test   %eax,%eax
  8004a8:	79 0a                	jns    8004b4 <umain+0x3f>
		die("Failed to create socket");
  8004aa:	b8 5f 32 80 00       	mov    $0x80325f,%eax
  8004af:	e8 8c fb ff ff       	call   800040 <die>

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  8004b4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8004bb:	00 
  8004bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004c3:	00 
  8004c4:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8004c7:	89 1c 24             	mov    %ebx,(%esp)
  8004ca:	e8 f8 0c 00 00       	call   8011c7 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  8004cf:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  8004d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004da:	e8 71 01 00 00       	call   800650 <htonl>
  8004df:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  8004e2:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  8004e9:	e8 48 01 00 00       	call   800636 <htons>
  8004ee:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  8004f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8004f9:	00 
  8004fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004fe:	89 34 24             	mov    %esi,(%esp)
  800501:	e8 8f 1d 00 00       	call   802295 <bind>
  800506:	85 c0                	test   %eax,%eax
  800508:	79 0a                	jns    800514 <umain+0x9f>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  80050a:	b8 2c 33 80 00       	mov    $0x80332c,%eax
  80050f:	e8 2c fb ff ff       	call   800040 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800514:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  80051b:	00 
  80051c:	89 34 24             	mov    %esi,(%esp)
  80051f:	e8 ee 1d 00 00       	call   802312 <listen>
  800524:	85 c0                	test   %eax,%eax
  800526:	79 0a                	jns    800532 <umain+0xbd>
		die("Failed to listen on server socket");
  800528:	b8 50 33 80 00       	mov    $0x803350,%eax
  80052d:	e8 0e fb ff ff       	call   800040 <die>

	cprintf("Waiting for http connections...\n");
  800532:	c7 04 24 74 33 80 00 	movl   $0x803374,(%esp)
  800539:	e8 b9 04 00 00       	call   8009f7 <cprintf>

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  80053e:	8d 7d c4             	lea    -0x3c(%ebp),%edi
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
  800541:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800548:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80054c:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80054f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800553:	89 34 24             	mov    %esi,(%esp)
  800556:	e8 ff 1c 00 00       	call   80225a <accept>
  80055b:	89 c3                	mov    %eax,%ebx
  80055d:	85 c0                	test   %eax,%eax
  80055f:	79 0a                	jns    80056b <umain+0xf6>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800561:	b8 98 33 80 00       	mov    $0x803398,%eax
  800566:	e8 d5 fa ff ff       	call   800040 <die>
		}
		handle_client(clientsock);
  80056b:	89 d8                	mov    %ebx,%eax
  80056d:	e8 81 fb ff ff       	call   8000f3 <handle_client>
	}
  800572:	eb cd                	jmp    800541 <umain+0xcc>
  800574:	66 90                	xchg   %ax,%ax
  800576:	66 90                	xchg   %ax,%ax
  800578:	66 90                	xchg   %ax,%ax
  80057a:	66 90                	xchg   %ax,%ax
  80057c:	66 90                	xchg   %ax,%ax
  80057e:	66 90                	xchg   %ax,%ax

00800580 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80058f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800593:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800596:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80059d:	be 00 00 00 00       	mov    $0x0,%esi
  8005a2:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8005a5:	eb 02                	jmp    8005a9 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8005a7:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8005a9:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005ac:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  8005af:	0f b6 c2             	movzbl %dl,%eax
  8005b2:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  8005b5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  8005b8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005bb:	66 c1 e8 0b          	shr    $0xb,%ax
  8005bf:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  8005c1:	8d 4e 01             	lea    0x1(%esi),%ecx
  8005c4:	89 f3                	mov    %esi,%ebx
  8005c6:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8005c9:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  8005cc:	01 ff                	add    %edi,%edi
  8005ce:	89 fb                	mov    %edi,%ebx
  8005d0:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  8005d2:	83 c2 30             	add    $0x30,%edx
  8005d5:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  8005d9:	84 c0                	test   %al,%al
  8005db:	75 ca                	jne    8005a7 <inet_ntoa+0x27>
  8005dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005e0:	89 c8                	mov    %ecx,%eax
  8005e2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005e5:	89 cf                	mov    %ecx,%edi
  8005e7:	eb 0d                	jmp    8005f6 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  8005e9:	0f b6 f0             	movzbl %al,%esi
  8005ec:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  8005f1:	88 0a                	mov    %cl,(%edx)
  8005f3:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8005f6:	83 e8 01             	sub    $0x1,%eax
  8005f9:	3c ff                	cmp    $0xff,%al
  8005fb:	75 ec                	jne    8005e9 <inet_ntoa+0x69>
  8005fd:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800600:	89 f9                	mov    %edi,%ecx
  800602:	0f b6 c9             	movzbl %cl,%ecx
  800605:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800608:	8d 41 01             	lea    0x1(%ecx),%eax
  80060b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80060e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800612:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  800616:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  80061a:	77 0a                	ja     800626 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80061c:	c6 01 2e             	movb   $0x2e,(%ecx)
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800624:	eb 81                	jmp    8005a7 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  800626:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  800629:	b8 00 50 80 00       	mov    $0x805000,%eax
  80062e:	83 c4 19             	add    $0x19,%esp
  800631:	5b                   	pop    %ebx
  800632:	5e                   	pop    %esi
  800633:	5f                   	pop    %edi
  800634:	5d                   	pop    %ebp
  800635:	c3                   	ret    

00800636 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800639:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80063d:	66 c1 c0 08          	rol    $0x8,%ax
}
  800641:	5d                   	pop    %ebp
  800642:	c3                   	ret    

00800643 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800646:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80064a:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  80064e:	5d                   	pop    %ebp
  80064f:	c3                   	ret    

00800650 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800656:	89 d1                	mov    %edx,%ecx
  800658:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80065b:	89 d0                	mov    %edx,%eax
  80065d:	c1 e0 18             	shl    $0x18,%eax
  800660:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800662:	89 d1                	mov    %edx,%ecx
  800664:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80066a:	c1 e1 08             	shl    $0x8,%ecx
  80066d:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  80066f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800675:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800678:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80067a:	5d                   	pop    %ebp
  80067b:	c3                   	ret    

0080067c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	57                   	push   %edi
  800680:	56                   	push   %esi
  800681:	53                   	push   %ebx
  800682:	83 ec 20             	sub    $0x20,%esp
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800688:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80068b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80068e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800691:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800694:	80 f9 09             	cmp    $0x9,%cl
  800697:	0f 87 a6 01 00 00    	ja     800843 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80069d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  8006a4:	83 fa 30             	cmp    $0x30,%edx
  8006a7:	75 2b                	jne    8006d4 <inet_aton+0x58>
      c = *++cp;
  8006a9:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8006ad:	89 d1                	mov    %edx,%ecx
  8006af:	83 e1 df             	and    $0xffffffdf,%ecx
  8006b2:	80 f9 58             	cmp    $0x58,%cl
  8006b5:	74 0f                	je     8006c6 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  8006b7:	83 c0 01             	add    $0x1,%eax
  8006ba:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  8006bd:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  8006c4:	eb 0e                	jmp    8006d4 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  8006c6:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8006ca:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  8006cd:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  8006d4:	83 c0 01             	add    $0x1,%eax
  8006d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8006dc:	eb 03                	jmp    8006e1 <inet_aton+0x65>
  8006de:	83 c0 01             	add    $0x1,%eax
  8006e1:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8006e4:	89 d3                	mov    %edx,%ebx
  8006e6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006e9:	80 f9 09             	cmp    $0x9,%cl
  8006ec:	77 0d                	ja     8006fb <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  8006ee:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  8006f2:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  8006f6:	0f be 10             	movsbl (%eax),%edx
  8006f9:	eb e3                	jmp    8006de <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  8006fb:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  8006ff:	75 30                	jne    800731 <inet_aton+0xb5>
  800701:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800704:	88 4d df             	mov    %cl,-0x21(%ebp)
  800707:	89 d1                	mov    %edx,%ecx
  800709:	83 e1 df             	and    $0xffffffdf,%ecx
  80070c:	83 e9 41             	sub    $0x41,%ecx
  80070f:	80 f9 05             	cmp    $0x5,%cl
  800712:	77 23                	ja     800737 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800714:	89 fb                	mov    %edi,%ebx
  800716:	c1 e3 04             	shl    $0x4,%ebx
  800719:	8d 7a 0a             	lea    0xa(%edx),%edi
  80071c:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  800720:	19 c9                	sbb    %ecx,%ecx
  800722:	83 e1 20             	and    $0x20,%ecx
  800725:	83 c1 41             	add    $0x41,%ecx
  800728:	29 cf                	sub    %ecx,%edi
  80072a:	09 df                	or     %ebx,%edi
        c = *++cp;
  80072c:	0f be 10             	movsbl (%eax),%edx
  80072f:	eb ad                	jmp    8006de <inet_aton+0x62>
  800731:	89 d0                	mov    %edx,%eax
  800733:	89 f9                	mov    %edi,%ecx
  800735:	eb 04                	jmp    80073b <inet_aton+0xbf>
  800737:	89 d0                	mov    %edx,%eax
  800739:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  80073b:	83 f8 2e             	cmp    $0x2e,%eax
  80073e:	75 22                	jne    800762 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800740:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800743:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800746:	0f 84 fe 00 00 00    	je     80084a <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  80074c:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  800750:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800753:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  800756:	8d 46 01             	lea    0x1(%esi),%eax
  800759:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  80075d:	e9 2f ff ff ff       	jmp    800691 <inet_aton+0x15>
  800762:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800764:	85 d2                	test   %edx,%edx
  800766:	74 27                	je     80078f <inet_aton+0x113>
    return (0);
  800768:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80076d:	80 fb 1f             	cmp    $0x1f,%bl
  800770:	0f 86 e7 00 00 00    	jbe    80085d <inet_aton+0x1e1>
  800776:	84 d2                	test   %dl,%dl
  800778:	0f 88 d3 00 00 00    	js     800851 <inet_aton+0x1d5>
  80077e:	83 fa 20             	cmp    $0x20,%edx
  800781:	74 0c                	je     80078f <inet_aton+0x113>
  800783:	83 ea 09             	sub    $0x9,%edx
  800786:	83 fa 04             	cmp    $0x4,%edx
  800789:	0f 87 ce 00 00 00    	ja     80085d <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80078f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800792:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800795:	29 c2                	sub    %eax,%edx
  800797:	c1 fa 02             	sar    $0x2,%edx
  80079a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80079d:	83 fa 02             	cmp    $0x2,%edx
  8007a0:	74 22                	je     8007c4 <inet_aton+0x148>
  8007a2:	83 fa 02             	cmp    $0x2,%edx
  8007a5:	7f 0f                	jg     8007b6 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  8007a7:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  8007ac:	85 d2                	test   %edx,%edx
  8007ae:	0f 84 a9 00 00 00    	je     80085d <inet_aton+0x1e1>
  8007b4:	eb 73                	jmp    800829 <inet_aton+0x1ad>
  8007b6:	83 fa 03             	cmp    $0x3,%edx
  8007b9:	74 26                	je     8007e1 <inet_aton+0x165>
  8007bb:	83 fa 04             	cmp    $0x4,%edx
  8007be:	66 90                	xchg   %ax,%ax
  8007c0:	74 40                	je     800802 <inet_aton+0x186>
  8007c2:	eb 65                	jmp    800829 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  8007c4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8007c9:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8007cf:	0f 87 88 00 00 00    	ja     80085d <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  8007d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007d8:	c1 e0 18             	shl    $0x18,%eax
  8007db:	89 cf                	mov    %ecx,%edi
  8007dd:	09 c7                	or     %eax,%edi
    break;
  8007df:	eb 48                	jmp    800829 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8007e6:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  8007ec:	77 6f                	ja     80085d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8007ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f1:	c1 e2 10             	shl    $0x10,%edx
  8007f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f7:	c1 e0 18             	shl    $0x18,%eax
  8007fa:	09 d0                	or     %edx,%eax
  8007fc:	09 c8                	or     %ecx,%eax
  8007fe:	89 c7                	mov    %eax,%edi
    break;
  800800:	eb 27                	jmp    800829 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800802:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800807:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80080d:	77 4e                	ja     80085d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80080f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800812:	c1 e2 10             	shl    $0x10,%edx
  800815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800818:	c1 e0 18             	shl    $0x18,%eax
  80081b:	09 c2                	or     %eax,%edx
  80081d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800820:	c1 e0 08             	shl    $0x8,%eax
  800823:	09 d0                	or     %edx,%eax
  800825:	09 c8                	or     %ecx,%eax
  800827:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  800829:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80082d:	74 29                	je     800858 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  80082f:	89 3c 24             	mov    %edi,(%esp)
  800832:	e8 19 fe ff ff       	call   800650 <htonl>
  800837:	8b 75 0c             	mov    0xc(%ebp),%esi
  80083a:	89 06                	mov    %eax,(%esi)
  return (1);
  80083c:	b8 01 00 00 00       	mov    $0x1,%eax
  800841:	eb 1a                	jmp    80085d <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
  800848:	eb 13                	jmp    80085d <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80084a:	b8 00 00 00 00       	mov    $0x0,%eax
  80084f:	eb 0c                	jmp    80085d <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
  800856:	eb 05                	jmp    80085d <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  800858:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80085d:	83 c4 20             	add    $0x20,%esp
  800860:	5b                   	pop    %ebx
  800861:	5e                   	pop    %esi
  800862:	5f                   	pop    %edi
  800863:	5d                   	pop    %ebp
  800864:	c3                   	ret    

00800865 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80086b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80086e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 04 24             	mov    %eax,(%esp)
  800878:	e8 ff fd ff ff       	call   80067c <inet_aton>
  80087d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80087f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800884:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800888:	c9                   	leave  
  800889:	c3                   	ret    

0080088a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	89 04 24             	mov    %eax,(%esp)
  800896:	e8 b5 fd ff ff       	call   800650 <htonl>
}
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	56                   	push   %esi
  8008a1:	53                   	push   %ebx
  8008a2:	83 ec 10             	sub    $0x10,%esp
  8008a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8008ab:	e8 f7 0b 00 00       	call   8014a7 <sys_getenvid>
  8008b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8008b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8008b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8008bd:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008c2:	85 db                	test   %ebx,%ebx
  8008c4:	7e 07                	jle    8008cd <libmain+0x30>
		binaryname = argv[0];
  8008c6:	8b 06                	mov    (%esi),%eax
  8008c8:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  8008cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008d1:	89 1c 24             	mov    %ebx,(%esp)
  8008d4:	e8 9c fb ff ff       	call   800475 <umain>

	// exit gracefully
	exit();
  8008d9:	e8 07 00 00 00       	call   8008e5 <exit>
}
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	5b                   	pop    %ebx
  8008e2:	5e                   	pop    %esi
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8008eb:	e8 da 10 00 00       	call   8019ca <close_all>
	sys_env_destroy(0);
  8008f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008f7:	e8 07 0b 00 00       	call   801403 <sys_env_destroy>
}
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	56                   	push   %esi
  800902:	53                   	push   %ebx
  800903:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800906:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800909:	8b 35 20 40 80 00    	mov    0x804020,%esi
  80090f:	e8 93 0b 00 00       	call   8014a7 <sys_getenvid>
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 54 24 10          	mov    %edx,0x10(%esp)
  80091b:	8b 55 08             	mov    0x8(%ebp),%edx
  80091e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800922:	89 74 24 08          	mov    %esi,0x8(%esp)
  800926:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092a:	c7 04 24 ec 33 80 00 	movl   $0x8033ec,(%esp)
  800931:	e8 c1 00 00 00       	call   8009f7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800936:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	89 04 24             	mov    %eax,(%esp)
  800940:	e8 51 00 00 00       	call   800996 <vcprintf>
	cprintf("\n");
  800945:	c7 04 24 56 32 80 00 	movl   $0x803256,(%esp)
  80094c:	e8 a6 00 00 00       	call   8009f7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800951:	cc                   	int3   
  800952:	eb fd                	jmp    800951 <_panic+0x53>

00800954 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	53                   	push   %ebx
  800958:	83 ec 14             	sub    $0x14,%esp
  80095b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80095e:	8b 13                	mov    (%ebx),%edx
  800960:	8d 42 01             	lea    0x1(%edx),%eax
  800963:	89 03                	mov    %eax,(%ebx)
  800965:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800968:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80096c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800971:	75 19                	jne    80098c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800973:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80097a:	00 
  80097b:	8d 43 08             	lea    0x8(%ebx),%eax
  80097e:	89 04 24             	mov    %eax,(%esp)
  800981:	e8 40 0a 00 00       	call   8013c6 <sys_cputs>
		b->idx = 0;
  800986:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80098c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800990:	83 c4 14             	add    $0x14,%esp
  800993:	5b                   	pop    %ebx
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80099f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009a6:	00 00 00 
	b.cnt = 0;
  8009a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009b0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8009b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cb:	c7 04 24 54 09 80 00 	movl   $0x800954,(%esp)
  8009d2:	e8 7d 01 00 00       	call   800b54 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8009d7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8009dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8009e7:	89 04 24             	mov    %eax,(%esp)
  8009ea:	e8 d7 09 00 00       	call   8013c6 <sys_cputs>

	return b.cnt;
}
  8009ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	89 04 24             	mov    %eax,(%esp)
  800a0a:	e8 87 ff ff ff       	call   800996 <vcprintf>
	va_end(ap);

	return cnt;
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    
  800a11:	66 90                	xchg   %ax,%ax
  800a13:	66 90                	xchg   %ax,%ax
  800a15:	66 90                	xchg   %ax,%ax
  800a17:	66 90                	xchg   %ax,%ax
  800a19:	66 90                	xchg   %ax,%ax
  800a1b:	66 90                	xchg   %ax,%ax
  800a1d:	66 90                	xchg   %ax,%ax
  800a1f:	90                   	nop

00800a20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	57                   	push   %edi
  800a24:	56                   	push   %esi
  800a25:	53                   	push   %ebx
  800a26:	83 ec 3c             	sub    $0x3c,%esp
  800a29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2c:	89 d7                	mov    %edx,%edi
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	89 c3                	mov    %eax,%ebx
  800a39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a47:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a4d:	39 d9                	cmp    %ebx,%ecx
  800a4f:	72 05                	jb     800a56 <printnum+0x36>
  800a51:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a54:	77 69                	ja     800abf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a56:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a59:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800a5d:	83 ee 01             	sub    $0x1,%esi
  800a60:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a64:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a68:	8b 44 24 08          	mov    0x8(%esp),%eax
  800a6c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800a70:	89 c3                	mov    %eax,%ebx
  800a72:	89 d6                	mov    %edx,%esi
  800a74:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a77:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800a7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  800a7e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800a82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a85:	89 04 24             	mov    %eax,(%esp)
  800a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8f:	e8 ac 24 00 00       	call   802f40 <__udivdi3>
  800a94:	89 d9                	mov    %ebx,%ecx
  800a96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a9a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a9e:	89 04 24             	mov    %eax,(%esp)
  800aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  800aa5:	89 fa                	mov    %edi,%edx
  800aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800aaa:	e8 71 ff ff ff       	call   800a20 <printnum>
  800aaf:	eb 1b                	jmp    800acc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ab1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	89 04 24             	mov    %eax,(%esp)
  800abb:	ff d3                	call   *%ebx
  800abd:	eb 03                	jmp    800ac2 <printnum+0xa2>
  800abf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ac2:	83 ee 01             	sub    $0x1,%esi
  800ac5:	85 f6                	test   %esi,%esi
  800ac7:	7f e8                	jg     800ab1 <printnum+0x91>
  800ac9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800acc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ad0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800ada:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ade:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae5:	89 04 24             	mov    %eax,(%esp)
  800ae8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aef:	e8 7c 25 00 00       	call   803070 <__umoddi3>
  800af4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800af8:	0f be 80 0f 34 80 00 	movsbl 0x80340f(%eax),%eax
  800aff:	89 04 24             	mov    %eax,(%esp)
  800b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b05:	ff d0                	call   *%eax
}
  800b07:	83 c4 3c             	add    $0x3c,%esp
  800b0a:	5b                   	pop    %ebx
  800b0b:	5e                   	pop    %esi
  800b0c:	5f                   	pop    %edi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b15:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b19:	8b 10                	mov    (%eax),%edx
  800b1b:	3b 50 04             	cmp    0x4(%eax),%edx
  800b1e:	73 0a                	jae    800b2a <sprintputch+0x1b>
		*b->buf++ = ch;
  800b20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b23:	89 08                	mov    %ecx,(%eax)
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	88 02                	mov    %al,(%edx)
}
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b32:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b39:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	89 04 24             	mov    %eax,(%esp)
  800b4d:	e8 02 00 00 00       	call   800b54 <vprintfmt>
	va_end(ap);
}
  800b52:	c9                   	leave  
  800b53:	c3                   	ret    

00800b54 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	83 ec 3c             	sub    $0x3c,%esp
  800b5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b60:	eb 17                	jmp    800b79 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800b62:	85 c0                	test   %eax,%eax
  800b64:	0f 84 4b 04 00 00    	je     800fb5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  800b6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800b71:	89 04 24             	mov    %eax,(%esp)
  800b74:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800b77:	89 fb                	mov    %edi,%ebx
  800b79:	8d 7b 01             	lea    0x1(%ebx),%edi
  800b7c:	0f b6 03             	movzbl (%ebx),%eax
  800b7f:	83 f8 25             	cmp    $0x25,%eax
  800b82:	75 de                	jne    800b62 <vprintfmt+0xe>
  800b84:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800b88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800b8f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800b94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800b9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba0:	eb 18                	jmp    800bba <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ba2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800ba4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800ba8:	eb 10                	jmp    800bba <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800baa:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bac:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800bb0:	eb 08                	jmp    800bba <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800bb2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800bb5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bba:	8d 5f 01             	lea    0x1(%edi),%ebx
  800bbd:	0f b6 17             	movzbl (%edi),%edx
  800bc0:	0f b6 c2             	movzbl %dl,%eax
  800bc3:	83 ea 23             	sub    $0x23,%edx
  800bc6:	80 fa 55             	cmp    $0x55,%dl
  800bc9:	0f 87 c2 03 00 00    	ja     800f91 <vprintfmt+0x43d>
  800bcf:	0f b6 d2             	movzbl %dl,%edx
  800bd2:	ff 24 95 60 35 80 00 	jmp    *0x803560(,%edx,4)
  800bd9:	89 df                	mov    %ebx,%edi
  800bdb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800be0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800be3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800be7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  800bea:	8d 50 d0             	lea    -0x30(%eax),%edx
  800bed:	83 fa 09             	cmp    $0x9,%edx
  800bf0:	77 33                	ja     800c25 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf5:	eb e9                	jmp    800be0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfa:	8b 30                	mov    (%eax),%esi
  800bfc:	8d 40 04             	lea    0x4(%eax),%eax
  800bff:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c02:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800c04:	eb 1f                	jmp    800c25 <vprintfmt+0xd1>
  800c06:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800c09:	85 ff                	test   %edi,%edi
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c10:	0f 49 c7             	cmovns %edi,%eax
  800c13:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c16:	89 df                	mov    %ebx,%edi
  800c18:	eb a0                	jmp    800bba <vprintfmt+0x66>
  800c1a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800c1c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800c23:	eb 95                	jmp    800bba <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800c25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c29:	79 8f                	jns    800bba <vprintfmt+0x66>
  800c2b:	eb 85                	jmp    800bb2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c2d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c30:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800c32:	eb 86                	jmp    800bba <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c34:	8b 45 14             	mov    0x14(%ebp),%eax
  800c37:	8d 70 04             	lea    0x4(%eax),%esi
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c41:	8b 45 14             	mov    0x14(%ebp),%eax
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	89 04 24             	mov    %eax,(%esp)
  800c49:	ff 55 08             	call   *0x8(%ebp)
  800c4c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  800c4f:	e9 25 ff ff ff       	jmp    800b79 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c54:	8b 45 14             	mov    0x14(%ebp),%eax
  800c57:	8d 70 04             	lea    0x4(%eax),%esi
  800c5a:	8b 00                	mov    (%eax),%eax
  800c5c:	99                   	cltd   
  800c5d:	31 d0                	xor    %edx,%eax
  800c5f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c61:	83 f8 15             	cmp    $0x15,%eax
  800c64:	7f 0b                	jg     800c71 <vprintfmt+0x11d>
  800c66:	8b 14 85 c0 36 80 00 	mov    0x8036c0(,%eax,4),%edx
  800c6d:	85 d2                	test   %edx,%edx
  800c6f:	75 26                	jne    800c97 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800c71:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c75:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800c7c:	00 
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	89 04 24             	mov    %eax,(%esp)
  800c8a:	e8 9d fe ff ff       	call   800b2c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c8f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800c92:	e9 e2 fe ff ff       	jmp    800b79 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800c97:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c9b:	c7 44 24 08 12 38 80 	movl   $0x803812,0x8(%esp)
  800ca2:	00 
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	89 04 24             	mov    %eax,(%esp)
  800cb0:	e8 77 fe ff ff       	call   800b2c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cb5:	89 75 14             	mov    %esi,0x14(%ebp)
  800cb8:	e9 bc fe ff ff       	jmp    800b79 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800cc3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cc6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800cca:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800ccc:	85 ff                	test   %edi,%edi
  800cce:	b8 20 34 80 00       	mov    $0x803420,%eax
  800cd3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800cd6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  800cda:	0f 84 94 00 00 00    	je     800d74 <vprintfmt+0x220>
  800ce0:	85 c9                	test   %ecx,%ecx
  800ce2:	0f 8e 94 00 00 00    	jle    800d7c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cec:	89 3c 24             	mov    %edi,(%esp)
  800cef:	e8 64 03 00 00       	call   801058 <strnlen>
  800cf4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800cf7:	29 c1                	sub    %eax,%ecx
  800cf9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  800cfc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800d00:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800d03:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800d06:	8b 75 08             	mov    0x8(%ebp),%esi
  800d09:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0c:	89 cb                	mov    %ecx,%ebx
  800d0e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d10:	eb 0f                	jmp    800d21 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d19:	89 3c 24             	mov    %edi,(%esp)
  800d1c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1e:	83 eb 01             	sub    $0x1,%ebx
  800d21:	85 db                	test   %ebx,%ebx
  800d23:	7f ed                	jg     800d12 <vprintfmt+0x1be>
  800d25:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800d28:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800d2b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d2e:	85 c9                	test   %ecx,%ecx
  800d30:	b8 00 00 00 00       	mov    $0x0,%eax
  800d35:	0f 49 c1             	cmovns %ecx,%eax
  800d38:	29 c1                	sub    %eax,%ecx
  800d3a:	89 cb                	mov    %ecx,%ebx
  800d3c:	eb 44                	jmp    800d82 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800d3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d42:	74 1e                	je     800d62 <vprintfmt+0x20e>
  800d44:	0f be d2             	movsbl %dl,%edx
  800d47:	83 ea 20             	sub    $0x20,%edx
  800d4a:	83 fa 5e             	cmp    $0x5e,%edx
  800d4d:	76 13                	jbe    800d62 <vprintfmt+0x20e>
					putch('?', putdat);
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d56:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800d5d:	ff 55 08             	call   *0x8(%ebp)
  800d60:	eb 0d                	jmp    800d6f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d69:	89 04 24             	mov    %eax,(%esp)
  800d6c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d6f:	83 eb 01             	sub    $0x1,%ebx
  800d72:	eb 0e                	jmp    800d82 <vprintfmt+0x22e>
  800d74:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d77:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800d7a:	eb 06                	jmp    800d82 <vprintfmt+0x22e>
  800d7c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d7f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800d82:	83 c7 01             	add    $0x1,%edi
  800d85:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800d89:	0f be c2             	movsbl %dl,%eax
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	74 27                	je     800db7 <vprintfmt+0x263>
  800d90:	85 f6                	test   %esi,%esi
  800d92:	78 aa                	js     800d3e <vprintfmt+0x1ea>
  800d94:	83 ee 01             	sub    $0x1,%esi
  800d97:	79 a5                	jns    800d3e <vprintfmt+0x1ea>
  800d99:	89 d8                	mov    %ebx,%eax
  800d9b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800da1:	89 c3                	mov    %eax,%ebx
  800da3:	eb 18                	jmp    800dbd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800da5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800da9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800db0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db2:	83 eb 01             	sub    $0x1,%ebx
  800db5:	eb 06                	jmp    800dbd <vprintfmt+0x269>
  800db7:	8b 75 08             	mov    0x8(%ebp),%esi
  800dba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800dbd:	85 db                	test   %ebx,%ebx
  800dbf:	7f e4                	jg     800da5 <vprintfmt+0x251>
  800dc1:	89 75 08             	mov    %esi,0x8(%ebp)
  800dc4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800dc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dca:	e9 aa fd ff ff       	jmp    800b79 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800dcf:	83 f9 01             	cmp    $0x1,%ecx
  800dd2:	7e 10                	jle    800de4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800dd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd7:	8b 30                	mov    (%eax),%esi
  800dd9:	8b 78 04             	mov    0x4(%eax),%edi
  800ddc:	8d 40 08             	lea    0x8(%eax),%eax
  800ddf:	89 45 14             	mov    %eax,0x14(%ebp)
  800de2:	eb 26                	jmp    800e0a <vprintfmt+0x2b6>
	else if (lflag)
  800de4:	85 c9                	test   %ecx,%ecx
  800de6:	74 12                	je     800dfa <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800de8:	8b 45 14             	mov    0x14(%ebp),%eax
  800deb:	8b 30                	mov    (%eax),%esi
  800ded:	89 f7                	mov    %esi,%edi
  800def:	c1 ff 1f             	sar    $0x1f,%edi
  800df2:	8d 40 04             	lea    0x4(%eax),%eax
  800df5:	89 45 14             	mov    %eax,0x14(%ebp)
  800df8:	eb 10                	jmp    800e0a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  800dfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfd:	8b 30                	mov    (%eax),%esi
  800dff:	89 f7                	mov    %esi,%edi
  800e01:	c1 ff 1f             	sar    $0x1f,%edi
  800e04:	8d 40 04             	lea    0x4(%eax),%eax
  800e07:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0a:	89 f0                	mov    %esi,%eax
  800e0c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800e0e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800e13:	85 ff                	test   %edi,%edi
  800e15:	0f 89 3a 01 00 00    	jns    800f55 <vprintfmt+0x401>
				putch('-', putdat);
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e22:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800e29:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800e2c:	89 f0                	mov    %esi,%eax
  800e2e:	89 fa                	mov    %edi,%edx
  800e30:	f7 d8                	neg    %eax
  800e32:	83 d2 00             	adc    $0x0,%edx
  800e35:	f7 da                	neg    %edx
			}
			base = 10;
  800e37:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e3c:	e9 14 01 00 00       	jmp    800f55 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800e41:	83 f9 01             	cmp    $0x1,%ecx
  800e44:	7e 13                	jle    800e59 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800e46:	8b 45 14             	mov    0x14(%ebp),%eax
  800e49:	8b 50 04             	mov    0x4(%eax),%edx
  800e4c:	8b 00                	mov    (%eax),%eax
  800e4e:	8b 75 14             	mov    0x14(%ebp),%esi
  800e51:	8d 4e 08             	lea    0x8(%esi),%ecx
  800e54:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800e57:	eb 2c                	jmp    800e85 <vprintfmt+0x331>
	else if (lflag)
  800e59:	85 c9                	test   %ecx,%ecx
  800e5b:	74 15                	je     800e72 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	8b 00                	mov    (%eax),%eax
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
  800e67:	8b 75 14             	mov    0x14(%ebp),%esi
  800e6a:	8d 76 04             	lea    0x4(%esi),%esi
  800e6d:	89 75 14             	mov    %esi,0x14(%ebp)
  800e70:	eb 13                	jmp    800e85 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800e72:	8b 45 14             	mov    0x14(%ebp),%eax
  800e75:	8b 00                	mov    (%eax),%eax
  800e77:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7c:	8b 75 14             	mov    0x14(%ebp),%esi
  800e7f:	8d 76 04             	lea    0x4(%esi),%esi
  800e82:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800e85:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800e8a:	e9 c6 00 00 00       	jmp    800f55 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800e8f:	83 f9 01             	cmp    $0x1,%ecx
  800e92:	7e 13                	jle    800ea7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800e94:	8b 45 14             	mov    0x14(%ebp),%eax
  800e97:	8b 50 04             	mov    0x4(%eax),%edx
  800e9a:	8b 00                	mov    (%eax),%eax
  800e9c:	8b 75 14             	mov    0x14(%ebp),%esi
  800e9f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800ea2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800ea5:	eb 24                	jmp    800ecb <vprintfmt+0x377>
	else if (lflag)
  800ea7:	85 c9                	test   %ecx,%ecx
  800ea9:	74 11                	je     800ebc <vprintfmt+0x368>
		return va_arg(*ap, long);
  800eab:	8b 45 14             	mov    0x14(%ebp),%eax
  800eae:	8b 00                	mov    (%eax),%eax
  800eb0:	99                   	cltd   
  800eb1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800eb4:	8d 71 04             	lea    0x4(%ecx),%esi
  800eb7:	89 75 14             	mov    %esi,0x14(%ebp)
  800eba:	eb 0f                	jmp    800ecb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  800ebc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebf:	8b 00                	mov    (%eax),%eax
  800ec1:	99                   	cltd   
  800ec2:	8b 75 14             	mov    0x14(%ebp),%esi
  800ec5:	8d 76 04             	lea    0x4(%esi),%esi
  800ec8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  800ecb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800ed0:	e9 80 00 00 00       	jmp    800f55 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ed5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800edf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800ee6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ef0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800ef7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800efa:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800efe:	8b 06                	mov    (%esi),%eax
  800f00:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800f05:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800f0a:	eb 49                	jmp    800f55 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f0c:	83 f9 01             	cmp    $0x1,%ecx
  800f0f:	7e 13                	jle    800f24 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800f11:	8b 45 14             	mov    0x14(%ebp),%eax
  800f14:	8b 50 04             	mov    0x4(%eax),%edx
  800f17:	8b 00                	mov    (%eax),%eax
  800f19:	8b 75 14             	mov    0x14(%ebp),%esi
  800f1c:	8d 4e 08             	lea    0x8(%esi),%ecx
  800f1f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800f22:	eb 2c                	jmp    800f50 <vprintfmt+0x3fc>
	else if (lflag)
  800f24:	85 c9                	test   %ecx,%ecx
  800f26:	74 15                	je     800f3d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800f28:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2b:	8b 00                	mov    (%eax),%eax
  800f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f32:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800f35:	8d 71 04             	lea    0x4(%ecx),%esi
  800f38:	89 75 14             	mov    %esi,0x14(%ebp)
  800f3b:	eb 13                	jmp    800f50 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  800f3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f40:	8b 00                	mov    (%eax),%eax
  800f42:	ba 00 00 00 00       	mov    $0x0,%edx
  800f47:	8b 75 14             	mov    0x14(%ebp),%esi
  800f4a:	8d 76 04             	lea    0x4(%esi),%esi
  800f4d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800f50:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f55:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800f59:	89 74 24 10          	mov    %esi,0x10(%esp)
  800f5d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800f60:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800f64:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f68:	89 04 24             	mov    %eax,(%esp)
  800f6b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	e8 a6 fa ff ff       	call   800a20 <printnum>
			break;
  800f7a:	e9 fa fb ff ff       	jmp    800b79 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f86:	89 04 24             	mov    %eax,(%esp)
  800f89:	ff 55 08             	call   *0x8(%ebp)
			break;
  800f8c:	e9 e8 fb ff ff       	jmp    800b79 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f98:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800f9f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fa2:	89 fb                	mov    %edi,%ebx
  800fa4:	eb 03                	jmp    800fa9 <vprintfmt+0x455>
  800fa6:	83 eb 01             	sub    $0x1,%ebx
  800fa9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800fad:	75 f7                	jne    800fa6 <vprintfmt+0x452>
  800faf:	90                   	nop
  800fb0:	e9 c4 fb ff ff       	jmp    800b79 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800fb5:	83 c4 3c             	add    $0x3c,%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 28             	sub    $0x28,%esp
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fcc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800fd0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800fd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	74 30                	je     80100e <vsnprintf+0x51>
  800fde:	85 d2                	test   %edx,%edx
  800fe0:	7e 2c                	jle    80100e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fe2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ff0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff7:	c7 04 24 0f 0b 80 00 	movl   $0x800b0f,(%esp)
  800ffe:	e8 51 fb ff ff       	call   800b54 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801003:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801006:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	eb 05                	jmp    801013 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80100e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80101b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80101e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 44 24 08          	mov    %eax,0x8(%esp)
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	89 04 24             	mov    %eax,(%esp)
  801036:	e8 82 ff ff ff       	call   800fbd <vsnprintf>
	va_end(ap);

	return rc;
}
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    
  80103d:	66 90                	xchg   %ax,%ax
  80103f:	90                   	nop

00801040 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801046:	b8 00 00 00 00       	mov    $0x0,%eax
  80104b:	eb 03                	jmp    801050 <strlen+0x10>
		n++;
  80104d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801050:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801054:	75 f7                	jne    80104d <strlen+0xd>
		n++;
	return n;
}
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80105e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
  801066:	eb 03                	jmp    80106b <strnlen+0x13>
		n++;
  801068:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106b:	39 d0                	cmp    %edx,%eax
  80106d:	74 06                	je     801075 <strnlen+0x1d>
  80106f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801073:	75 f3                	jne    801068 <strnlen+0x10>
		n++;
	return n;
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	53                   	push   %ebx
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801081:	89 c2                	mov    %eax,%edx
  801083:	83 c2 01             	add    $0x1,%edx
  801086:	83 c1 01             	add    $0x1,%ecx
  801089:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80108d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801090:	84 db                	test   %bl,%bl
  801092:	75 ef                	jne    801083 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801094:	5b                   	pop    %ebx
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	53                   	push   %ebx
  80109b:	83 ec 08             	sub    $0x8,%esp
  80109e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8010a1:	89 1c 24             	mov    %ebx,(%esp)
  8010a4:	e8 97 ff ff ff       	call   801040 <strlen>
	strcpy(dst + len, src);
  8010a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010b0:	01 d8                	add    %ebx,%eax
  8010b2:	89 04 24             	mov    %eax,(%esp)
  8010b5:	e8 bd ff ff ff       	call   801077 <strcpy>
	return dst;
}
  8010ba:	89 d8                	mov    %ebx,%eax
  8010bc:	83 c4 08             	add    $0x8,%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    

008010c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	56                   	push   %esi
  8010c6:	53                   	push   %ebx
  8010c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8010ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cd:	89 f3                	mov    %esi,%ebx
  8010cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010d2:	89 f2                	mov    %esi,%edx
  8010d4:	eb 0f                	jmp    8010e5 <strncpy+0x23>
		*dst++ = *src;
  8010d6:	83 c2 01             	add    $0x1,%edx
  8010d9:	0f b6 01             	movzbl (%ecx),%eax
  8010dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8010df:	80 39 01             	cmpb   $0x1,(%ecx)
  8010e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010e5:	39 da                	cmp    %ebx,%edx
  8010e7:	75 ed                	jne    8010d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8010e9:	89 f0                	mov    %esi,%eax
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    

008010ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	56                   	push   %esi
  8010f3:	53                   	push   %ebx
  8010f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010fd:	89 f0                	mov    %esi,%eax
  8010ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801103:	85 c9                	test   %ecx,%ecx
  801105:	75 0b                	jne    801112 <strlcpy+0x23>
  801107:	eb 1d                	jmp    801126 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801109:	83 c0 01             	add    $0x1,%eax
  80110c:	83 c2 01             	add    $0x1,%edx
  80110f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801112:	39 d8                	cmp    %ebx,%eax
  801114:	74 0b                	je     801121 <strlcpy+0x32>
  801116:	0f b6 0a             	movzbl (%edx),%ecx
  801119:	84 c9                	test   %cl,%cl
  80111b:	75 ec                	jne    801109 <strlcpy+0x1a>
  80111d:	89 c2                	mov    %eax,%edx
  80111f:	eb 02                	jmp    801123 <strlcpy+0x34>
  801121:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801123:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801126:	29 f0                	sub    %esi,%eax
}
  801128:	5b                   	pop    %ebx
  801129:	5e                   	pop    %esi
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801132:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801135:	eb 06                	jmp    80113d <strcmp+0x11>
		p++, q++;
  801137:	83 c1 01             	add    $0x1,%ecx
  80113a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80113d:	0f b6 01             	movzbl (%ecx),%eax
  801140:	84 c0                	test   %al,%al
  801142:	74 04                	je     801148 <strcmp+0x1c>
  801144:	3a 02                	cmp    (%edx),%al
  801146:	74 ef                	je     801137 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801148:	0f b6 c0             	movzbl %al,%eax
  80114b:	0f b6 12             	movzbl (%edx),%edx
  80114e:	29 d0                	sub    %edx,%eax
}
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	53                   	push   %ebx
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115c:	89 c3                	mov    %eax,%ebx
  80115e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801161:	eb 06                	jmp    801169 <strncmp+0x17>
		n--, p++, q++;
  801163:	83 c0 01             	add    $0x1,%eax
  801166:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801169:	39 d8                	cmp    %ebx,%eax
  80116b:	74 15                	je     801182 <strncmp+0x30>
  80116d:	0f b6 08             	movzbl (%eax),%ecx
  801170:	84 c9                	test   %cl,%cl
  801172:	74 04                	je     801178 <strncmp+0x26>
  801174:	3a 0a                	cmp    (%edx),%cl
  801176:	74 eb                	je     801163 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801178:	0f b6 00             	movzbl (%eax),%eax
  80117b:	0f b6 12             	movzbl (%edx),%edx
  80117e:	29 d0                	sub    %edx,%eax
  801180:	eb 05                	jmp    801187 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801182:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801187:	5b                   	pop    %ebx
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801194:	eb 07                	jmp    80119d <strchr+0x13>
		if (*s == c)
  801196:	38 ca                	cmp    %cl,%dl
  801198:	74 0f                	je     8011a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80119a:	83 c0 01             	add    $0x1,%eax
  80119d:	0f b6 10             	movzbl (%eax),%edx
  8011a0:	84 d2                	test   %dl,%dl
  8011a2:	75 f2                	jne    801196 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8011b5:	eb 07                	jmp    8011be <strfind+0x13>
		if (*s == c)
  8011b7:	38 ca                	cmp    %cl,%dl
  8011b9:	74 0a                	je     8011c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011bb:	83 c0 01             	add    $0x1,%eax
  8011be:	0f b6 10             	movzbl (%eax),%edx
  8011c1:	84 d2                	test   %dl,%dl
  8011c3:	75 f2                	jne    8011b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    

008011c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	57                   	push   %edi
  8011cb:	56                   	push   %esi
  8011cc:	53                   	push   %ebx
  8011cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8011d3:	85 c9                	test   %ecx,%ecx
  8011d5:	74 36                	je     80120d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8011d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8011dd:	75 28                	jne    801207 <memset+0x40>
  8011df:	f6 c1 03             	test   $0x3,%cl
  8011e2:	75 23                	jne    801207 <memset+0x40>
		c &= 0xFF;
  8011e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011e8:	89 d3                	mov    %edx,%ebx
  8011ea:	c1 e3 08             	shl    $0x8,%ebx
  8011ed:	89 d6                	mov    %edx,%esi
  8011ef:	c1 e6 18             	shl    $0x18,%esi
  8011f2:	89 d0                	mov    %edx,%eax
  8011f4:	c1 e0 10             	shl    $0x10,%eax
  8011f7:	09 f0                	or     %esi,%eax
  8011f9:	09 c2                	or     %eax,%edx
  8011fb:	89 d0                	mov    %edx,%eax
  8011fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801202:	fc                   	cld    
  801203:	f3 ab                	rep stos %eax,%es:(%edi)
  801205:	eb 06                	jmp    80120d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	fc                   	cld    
  80120b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80120d:	89 f8                	mov    %edi,%eax
  80120f:	5b                   	pop    %ebx
  801210:	5e                   	pop    %esi
  801211:	5f                   	pop    %edi
  801212:	5d                   	pop    %ebp
  801213:	c3                   	ret    

00801214 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	57                   	push   %edi
  801218:	56                   	push   %esi
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80121f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801222:	39 c6                	cmp    %eax,%esi
  801224:	73 35                	jae    80125b <memmove+0x47>
  801226:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801229:	39 d0                	cmp    %edx,%eax
  80122b:	73 2e                	jae    80125b <memmove+0x47>
		s += n;
		d += n;
  80122d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801230:	89 d6                	mov    %edx,%esi
  801232:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801234:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80123a:	75 13                	jne    80124f <memmove+0x3b>
  80123c:	f6 c1 03             	test   $0x3,%cl
  80123f:	75 0e                	jne    80124f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801241:	83 ef 04             	sub    $0x4,%edi
  801244:	8d 72 fc             	lea    -0x4(%edx),%esi
  801247:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80124a:	fd                   	std    
  80124b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80124d:	eb 09                	jmp    801258 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80124f:	83 ef 01             	sub    $0x1,%edi
  801252:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801255:	fd                   	std    
  801256:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801258:	fc                   	cld    
  801259:	eb 1d                	jmp    801278 <memmove+0x64>
  80125b:	89 f2                	mov    %esi,%edx
  80125d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80125f:	f6 c2 03             	test   $0x3,%dl
  801262:	75 0f                	jne    801273 <memmove+0x5f>
  801264:	f6 c1 03             	test   $0x3,%cl
  801267:	75 0a                	jne    801273 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801269:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80126c:	89 c7                	mov    %eax,%edi
  80126e:	fc                   	cld    
  80126f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801271:	eb 05                	jmp    801278 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801273:	89 c7                	mov    %eax,%edi
  801275:	fc                   	cld    
  801276:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801278:	5e                   	pop    %esi
  801279:	5f                   	pop    %edi
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801282:	8b 45 10             	mov    0x10(%ebp),%eax
  801285:	89 44 24 08          	mov    %eax,0x8(%esp)
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	89 04 24             	mov    %eax,(%esp)
  801296:	e8 79 ff ff ff       	call   801214 <memmove>
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a8:	89 d6                	mov    %edx,%esi
  8012aa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012ad:	eb 1a                	jmp    8012c9 <memcmp+0x2c>
		if (*s1 != *s2)
  8012af:	0f b6 02             	movzbl (%edx),%eax
  8012b2:	0f b6 19             	movzbl (%ecx),%ebx
  8012b5:	38 d8                	cmp    %bl,%al
  8012b7:	74 0a                	je     8012c3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8012b9:	0f b6 c0             	movzbl %al,%eax
  8012bc:	0f b6 db             	movzbl %bl,%ebx
  8012bf:	29 d8                	sub    %ebx,%eax
  8012c1:	eb 0f                	jmp    8012d2 <memcmp+0x35>
		s1++, s2++;
  8012c3:	83 c2 01             	add    $0x1,%edx
  8012c6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012c9:	39 f2                	cmp    %esi,%edx
  8012cb:	75 e2                	jne    8012af <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8012df:	89 c2                	mov    %eax,%edx
  8012e1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8012e4:	eb 07                	jmp    8012ed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012e6:	38 08                	cmp    %cl,(%eax)
  8012e8:	74 07                	je     8012f1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012ea:	83 c0 01             	add    $0x1,%eax
  8012ed:	39 d0                	cmp    %edx,%eax
  8012ef:	72 f5                	jb     8012e6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    

008012f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	57                   	push   %edi
  8012f7:	56                   	push   %esi
  8012f8:	53                   	push   %ebx
  8012f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012ff:	eb 03                	jmp    801304 <strtol+0x11>
		s++;
  801301:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801304:	0f b6 0a             	movzbl (%edx),%ecx
  801307:	80 f9 09             	cmp    $0x9,%cl
  80130a:	74 f5                	je     801301 <strtol+0xe>
  80130c:	80 f9 20             	cmp    $0x20,%cl
  80130f:	74 f0                	je     801301 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801311:	80 f9 2b             	cmp    $0x2b,%cl
  801314:	75 0a                	jne    801320 <strtol+0x2d>
		s++;
  801316:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801319:	bf 00 00 00 00       	mov    $0x0,%edi
  80131e:	eb 11                	jmp    801331 <strtol+0x3e>
  801320:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801325:	80 f9 2d             	cmp    $0x2d,%cl
  801328:	75 07                	jne    801331 <strtol+0x3e>
		s++, neg = 1;
  80132a:	8d 52 01             	lea    0x1(%edx),%edx
  80132d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801331:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801336:	75 15                	jne    80134d <strtol+0x5a>
  801338:	80 3a 30             	cmpb   $0x30,(%edx)
  80133b:	75 10                	jne    80134d <strtol+0x5a>
  80133d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801341:	75 0a                	jne    80134d <strtol+0x5a>
		s += 2, base = 16;
  801343:	83 c2 02             	add    $0x2,%edx
  801346:	b8 10 00 00 00       	mov    $0x10,%eax
  80134b:	eb 10                	jmp    80135d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80134d:	85 c0                	test   %eax,%eax
  80134f:	75 0c                	jne    80135d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801351:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801353:	80 3a 30             	cmpb   $0x30,(%edx)
  801356:	75 05                	jne    80135d <strtol+0x6a>
		s++, base = 8;
  801358:	83 c2 01             	add    $0x1,%edx
  80135b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80135d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801362:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801365:	0f b6 0a             	movzbl (%edx),%ecx
  801368:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80136b:	89 f0                	mov    %esi,%eax
  80136d:	3c 09                	cmp    $0x9,%al
  80136f:	77 08                	ja     801379 <strtol+0x86>
			dig = *s - '0';
  801371:	0f be c9             	movsbl %cl,%ecx
  801374:	83 e9 30             	sub    $0x30,%ecx
  801377:	eb 20                	jmp    801399 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801379:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80137c:	89 f0                	mov    %esi,%eax
  80137e:	3c 19                	cmp    $0x19,%al
  801380:	77 08                	ja     80138a <strtol+0x97>
			dig = *s - 'a' + 10;
  801382:	0f be c9             	movsbl %cl,%ecx
  801385:	83 e9 57             	sub    $0x57,%ecx
  801388:	eb 0f                	jmp    801399 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80138a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80138d:	89 f0                	mov    %esi,%eax
  80138f:	3c 19                	cmp    $0x19,%al
  801391:	77 16                	ja     8013a9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801393:	0f be c9             	movsbl %cl,%ecx
  801396:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801399:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80139c:	7d 0f                	jge    8013ad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80139e:	83 c2 01             	add    $0x1,%edx
  8013a1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8013a5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8013a7:	eb bc                	jmp    801365 <strtol+0x72>
  8013a9:	89 d8                	mov    %ebx,%eax
  8013ab:	eb 02                	jmp    8013af <strtol+0xbc>
  8013ad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8013af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013b3:	74 05                	je     8013ba <strtol+0xc7>
		*endptr = (char *) s;
  8013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8013ba:	f7 d8                	neg    %eax
  8013bc:	85 ff                	test   %edi,%edi
  8013be:	0f 44 c3             	cmove  %ebx,%eax
}
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5f                   	pop    %edi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	57                   	push   %edi
  8013ca:	56                   	push   %esi
  8013cb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d7:	89 c3                	mov    %eax,%ebx
  8013d9:	89 c7                	mov    %eax,%edi
  8013db:	89 c6                	mov    %eax,%esi
  8013dd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8013df:	5b                   	pop    %ebx
  8013e0:	5e                   	pop    %esi
  8013e1:	5f                   	pop    %edi
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    

008013e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	57                   	push   %edi
  8013e8:	56                   	push   %esi
  8013e9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8013f4:	89 d1                	mov    %edx,%ecx
  8013f6:	89 d3                	mov    %edx,%ebx
  8013f8:	89 d7                	mov    %edx,%edi
  8013fa:	89 d6                	mov    %edx,%esi
  8013fc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8013fe:	5b                   	pop    %ebx
  8013ff:	5e                   	pop    %esi
  801400:	5f                   	pop    %edi
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    

00801403 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	57                   	push   %edi
  801407:	56                   	push   %esi
  801408:	53                   	push   %ebx
  801409:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801411:	b8 03 00 00 00       	mov    $0x3,%eax
  801416:	8b 55 08             	mov    0x8(%ebp),%edx
  801419:	89 cb                	mov    %ecx,%ebx
  80141b:	89 cf                	mov    %ecx,%edi
  80141d:	89 ce                	mov    %ecx,%esi
  80141f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801421:	85 c0                	test   %eax,%eax
  801423:	7e 28                	jle    80144d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801425:	89 44 24 10          	mov    %eax,0x10(%esp)
  801429:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801430:	00 
  801431:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  801438:	00 
  801439:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801440:	00 
  801441:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  801448:	e8 b1 f4 ff ff       	call   8008fe <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80144d:	83 c4 2c             	add    $0x2c,%esp
  801450:	5b                   	pop    %ebx
  801451:	5e                   	pop    %esi
  801452:	5f                   	pop    %edi
  801453:	5d                   	pop    %ebp
  801454:	c3                   	ret    

00801455 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	57                   	push   %edi
  801459:	56                   	push   %esi
  80145a:	53                   	push   %ebx
  80145b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801463:	b8 04 00 00 00       	mov    $0x4,%eax
  801468:	8b 55 08             	mov    0x8(%ebp),%edx
  80146b:	89 cb                	mov    %ecx,%ebx
  80146d:	89 cf                	mov    %ecx,%edi
  80146f:	89 ce                	mov    %ecx,%esi
  801471:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801473:	85 c0                	test   %eax,%eax
  801475:	7e 28                	jle    80149f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801477:	89 44 24 10          	mov    %eax,0x10(%esp)
  80147b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801482:	00 
  801483:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  80148a:	00 
  80148b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801492:	00 
  801493:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  80149a:	e8 5f f4 ff ff       	call   8008fe <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  80149f:	83 c4 2c             	add    $0x2c,%esp
  8014a2:	5b                   	pop    %ebx
  8014a3:	5e                   	pop    %esi
  8014a4:	5f                   	pop    %edi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    

008014a7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	57                   	push   %edi
  8014ab:	56                   	push   %esi
  8014ac:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b2:	b8 02 00 00 00       	mov    $0x2,%eax
  8014b7:	89 d1                	mov    %edx,%ecx
  8014b9:	89 d3                	mov    %edx,%ebx
  8014bb:	89 d7                	mov    %edx,%edi
  8014bd:	89 d6                	mov    %edx,%esi
  8014bf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8014c1:	5b                   	pop    %ebx
  8014c2:	5e                   	pop    %esi
  8014c3:	5f                   	pop    %edi
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <sys_yield>:

void
sys_yield(void)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	57                   	push   %edi
  8014ca:	56                   	push   %esi
  8014cb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8014d6:	89 d1                	mov    %edx,%ecx
  8014d8:	89 d3                	mov    %edx,%ebx
  8014da:	89 d7                	mov    %edx,%edi
  8014dc:	89 d6                	mov    %edx,%esi
  8014de:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8014e0:	5b                   	pop    %ebx
  8014e1:	5e                   	pop    %esi
  8014e2:	5f                   	pop    %edi
  8014e3:	5d                   	pop    %ebp
  8014e4:	c3                   	ret    

008014e5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	57                   	push   %edi
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ee:	be 00 00 00 00       	mov    $0x0,%esi
  8014f3:	b8 05 00 00 00       	mov    $0x5,%eax
  8014f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801501:	89 f7                	mov    %esi,%edi
  801503:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801505:	85 c0                	test   %eax,%eax
  801507:	7e 28                	jle    801531 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801509:	89 44 24 10          	mov    %eax,0x10(%esp)
  80150d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801514:	00 
  801515:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  80151c:	00 
  80151d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801524:	00 
  801525:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  80152c:	e8 cd f3 ff ff       	call   8008fe <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801531:	83 c4 2c             	add    $0x2c,%esp
  801534:	5b                   	pop    %ebx
  801535:	5e                   	pop    %esi
  801536:	5f                   	pop    %edi
  801537:	5d                   	pop    %ebp
  801538:	c3                   	ret    

00801539 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	57                   	push   %edi
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801542:	b8 06 00 00 00       	mov    $0x6,%eax
  801547:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80154a:	8b 55 08             	mov    0x8(%ebp),%edx
  80154d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801550:	8b 7d 14             	mov    0x14(%ebp),%edi
  801553:	8b 75 18             	mov    0x18(%ebp),%esi
  801556:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801558:	85 c0                	test   %eax,%eax
  80155a:	7e 28                	jle    801584 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80155c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801560:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801567:	00 
  801568:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  80156f:	00 
  801570:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801577:	00 
  801578:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  80157f:	e8 7a f3 ff ff       	call   8008fe <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801584:	83 c4 2c             	add    $0x2c,%esp
  801587:	5b                   	pop    %ebx
  801588:	5e                   	pop    %esi
  801589:	5f                   	pop    %edi
  80158a:	5d                   	pop    %ebp
  80158b:	c3                   	ret    

0080158c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	57                   	push   %edi
  801590:	56                   	push   %esi
  801591:	53                   	push   %ebx
  801592:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801595:	bb 00 00 00 00       	mov    $0x0,%ebx
  80159a:	b8 07 00 00 00       	mov    $0x7,%eax
  80159f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a5:	89 df                	mov    %ebx,%edi
  8015a7:	89 de                	mov    %ebx,%esi
  8015a9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	7e 28                	jle    8015d7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015af:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015b3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015ba:	00 
  8015bb:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  8015c2:	00 
  8015c3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015ca:	00 
  8015cb:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  8015d2:	e8 27 f3 ff ff       	call   8008fe <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015d7:	83 c4 2c             	add    $0x2c,%esp
  8015da:	5b                   	pop    %ebx
  8015db:	5e                   	pop    %esi
  8015dc:	5f                   	pop    %edi
  8015dd:	5d                   	pop    %ebp
  8015de:	c3                   	ret    

008015df <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	57                   	push   %edi
  8015e3:	56                   	push   %esi
  8015e4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015ea:	b8 10 00 00 00       	mov    $0x10,%eax
  8015ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f2:	89 cb                	mov    %ecx,%ebx
  8015f4:	89 cf                	mov    %ecx,%edi
  8015f6:	89 ce                	mov    %ecx,%esi
  8015f8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5f                   	pop    %edi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	57                   	push   %edi
  801603:	56                   	push   %esi
  801604:	53                   	push   %ebx
  801605:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801608:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160d:	b8 09 00 00 00       	mov    $0x9,%eax
  801612:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801615:	8b 55 08             	mov    0x8(%ebp),%edx
  801618:	89 df                	mov    %ebx,%edi
  80161a:	89 de                	mov    %ebx,%esi
  80161c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80161e:	85 c0                	test   %eax,%eax
  801620:	7e 28                	jle    80164a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801622:	89 44 24 10          	mov    %eax,0x10(%esp)
  801626:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80162d:	00 
  80162e:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  801635:	00 
  801636:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80163d:	00 
  80163e:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  801645:	e8 b4 f2 ff ff       	call   8008fe <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80164a:	83 c4 2c             	add    $0x2c,%esp
  80164d:	5b                   	pop    %ebx
  80164e:	5e                   	pop    %esi
  80164f:	5f                   	pop    %edi
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    

00801652 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	57                   	push   %edi
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80165b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801660:	b8 0a 00 00 00       	mov    $0xa,%eax
  801665:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801668:	8b 55 08             	mov    0x8(%ebp),%edx
  80166b:	89 df                	mov    %ebx,%edi
  80166d:	89 de                	mov    %ebx,%esi
  80166f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801671:	85 c0                	test   %eax,%eax
  801673:	7e 28                	jle    80169d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801675:	89 44 24 10          	mov    %eax,0x10(%esp)
  801679:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801680:	00 
  801681:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  801688:	00 
  801689:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801690:	00 
  801691:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  801698:	e8 61 f2 ff ff       	call   8008fe <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80169d:	83 c4 2c             	add    $0x2c,%esp
  8016a0:	5b                   	pop    %ebx
  8016a1:	5e                   	pop    %esi
  8016a2:	5f                   	pop    %edi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  8016ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016be:	89 df                	mov    %ebx,%edi
  8016c0:	89 de                	mov    %ebx,%esi
  8016c2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	7e 28                	jle    8016f0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016cc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8016d3:	00 
  8016d4:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  8016db:	00 
  8016dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016e3:	00 
  8016e4:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  8016eb:	e8 0e f2 ff ff       	call   8008fe <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8016f0:	83 c4 2c             	add    $0x2c,%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5f                   	pop    %edi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    

008016f8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	57                   	push   %edi
  8016fc:	56                   	push   %esi
  8016fd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016fe:	be 00 00 00 00       	mov    $0x0,%esi
  801703:	b8 0d 00 00 00       	mov    $0xd,%eax
  801708:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80170b:	8b 55 08             	mov    0x8(%ebp),%edx
  80170e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801711:	8b 7d 14             	mov    0x14(%ebp),%edi
  801714:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801716:	5b                   	pop    %ebx
  801717:	5e                   	pop    %esi
  801718:	5f                   	pop    %edi
  801719:	5d                   	pop    %ebp
  80171a:	c3                   	ret    

0080171b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	57                   	push   %edi
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
  801721:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801724:	b9 00 00 00 00       	mov    $0x0,%ecx
  801729:	b8 0e 00 00 00       	mov    $0xe,%eax
  80172e:	8b 55 08             	mov    0x8(%ebp),%edx
  801731:	89 cb                	mov    %ecx,%ebx
  801733:	89 cf                	mov    %ecx,%edi
  801735:	89 ce                	mov    %ecx,%esi
  801737:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801739:	85 c0                	test   %eax,%eax
  80173b:	7e 28                	jle    801765 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80173d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801741:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801748:	00 
  801749:	c7 44 24 08 37 37 80 	movl   $0x803737,0x8(%esp)
  801750:	00 
  801751:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801758:	00 
  801759:	c7 04 24 54 37 80 00 	movl   $0x803754,(%esp)
  801760:	e8 99 f1 ff ff       	call   8008fe <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801765:	83 c4 2c             	add    $0x2c,%esp
  801768:	5b                   	pop    %ebx
  801769:	5e                   	pop    %esi
  80176a:	5f                   	pop    %edi
  80176b:	5d                   	pop    %ebp
  80176c:	c3                   	ret    

0080176d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	57                   	push   %edi
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	b8 0f 00 00 00       	mov    $0xf,%eax
  80177d:	89 d1                	mov    %edx,%ecx
  80177f:	89 d3                	mov    %edx,%ebx
  801781:	89 d7                	mov    %edx,%edi
  801783:	89 d6                	mov    %edx,%esi
  801785:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801787:	5b                   	pop    %ebx
  801788:	5e                   	pop    %esi
  801789:	5f                   	pop    %edi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    

0080178c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	57                   	push   %edi
  801790:	56                   	push   %esi
  801791:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801792:	bb 00 00 00 00       	mov    $0x0,%ebx
  801797:	b8 11 00 00 00       	mov    $0x11,%eax
  80179c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179f:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a2:	89 df                	mov    %ebx,%edi
  8017a4:	89 de                	mov    %ebx,%esi
  8017a6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8017a8:	5b                   	pop    %ebx
  8017a9:	5e                   	pop    %esi
  8017aa:	5f                   	pop    %edi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	57                   	push   %edi
  8017b1:	56                   	push   %esi
  8017b2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b8:	b8 12 00 00 00       	mov    $0x12,%eax
  8017bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c3:	89 df                	mov    %ebx,%edi
  8017c5:	89 de                	mov    %ebx,%esi
  8017c7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8017c9:	5b                   	pop    %ebx
  8017ca:	5e                   	pop    %esi
  8017cb:	5f                   	pop    %edi
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    

008017ce <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	57                   	push   %edi
  8017d2:	56                   	push   %esi
  8017d3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d9:	b8 13 00 00 00       	mov    $0x13,%eax
  8017de:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e1:	89 cb                	mov    %ecx,%ebx
  8017e3:	89 cf                	mov    %ecx,%edi
  8017e5:	89 ce                	mov    %ecx,%esi
  8017e7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5f                   	pop    %edi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    
  8017ee:	66 90                	xchg   %ax,%ax

008017f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80180b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801810:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80181d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801822:	89 c2                	mov    %eax,%edx
  801824:	c1 ea 16             	shr    $0x16,%edx
  801827:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80182e:	f6 c2 01             	test   $0x1,%dl
  801831:	74 11                	je     801844 <fd_alloc+0x2d>
  801833:	89 c2                	mov    %eax,%edx
  801835:	c1 ea 0c             	shr    $0xc,%edx
  801838:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80183f:	f6 c2 01             	test   $0x1,%dl
  801842:	75 09                	jne    80184d <fd_alloc+0x36>
			*fd_store = fd;
  801844:	89 01                	mov    %eax,(%ecx)
			return 0;
  801846:	b8 00 00 00 00       	mov    $0x0,%eax
  80184b:	eb 17                	jmp    801864 <fd_alloc+0x4d>
  80184d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801852:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801857:	75 c9                	jne    801822 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801859:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80185f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801864:	5d                   	pop    %ebp
  801865:	c3                   	ret    

00801866 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80186c:	83 f8 1f             	cmp    $0x1f,%eax
  80186f:	77 36                	ja     8018a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801871:	c1 e0 0c             	shl    $0xc,%eax
  801874:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801879:	89 c2                	mov    %eax,%edx
  80187b:	c1 ea 16             	shr    $0x16,%edx
  80187e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801885:	f6 c2 01             	test   $0x1,%dl
  801888:	74 24                	je     8018ae <fd_lookup+0x48>
  80188a:	89 c2                	mov    %eax,%edx
  80188c:	c1 ea 0c             	shr    $0xc,%edx
  80188f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801896:	f6 c2 01             	test   $0x1,%dl
  801899:	74 1a                	je     8018b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	89 02                	mov    %eax,(%edx)
	return 0;
  8018a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a5:	eb 13                	jmp    8018ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018ac:	eb 0c                	jmp    8018ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b3:	eb 05                	jmp    8018ba <fd_lookup+0x54>
  8018b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 18             	sub    $0x18,%esp
  8018c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ca:	eb 13                	jmp    8018df <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8018cc:	39 08                	cmp    %ecx,(%eax)
  8018ce:	75 0c                	jne    8018dc <dev_lookup+0x20>
			*dev = devtab[i];
  8018d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018da:	eb 38                	jmp    801914 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018dc:	83 c2 01             	add    $0x1,%edx
  8018df:	8b 04 95 e0 37 80 00 	mov    0x8037e0(,%edx,4),%eax
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	75 e2                	jne    8018cc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018ea:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8018ef:	8b 40 48             	mov    0x48(%eax),%eax
  8018f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fa:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  801901:	e8 f1 f0 ff ff       	call   8009f7 <cprintf>
	*dev = 0;
  801906:	8b 45 0c             	mov    0xc(%ebp),%eax
  801909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80190f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	56                   	push   %esi
  80191a:	53                   	push   %ebx
  80191b:	83 ec 20             	sub    $0x20,%esp
  80191e:	8b 75 08             	mov    0x8(%ebp),%esi
  801921:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801924:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80192b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801931:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801934:	89 04 24             	mov    %eax,(%esp)
  801937:	e8 2a ff ff ff       	call   801866 <fd_lookup>
  80193c:	85 c0                	test   %eax,%eax
  80193e:	78 05                	js     801945 <fd_close+0x2f>
	    || fd != fd2)
  801940:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801943:	74 0c                	je     801951 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801945:	84 db                	test   %bl,%bl
  801947:	ba 00 00 00 00       	mov    $0x0,%edx
  80194c:	0f 44 c2             	cmove  %edx,%eax
  80194f:	eb 3f                	jmp    801990 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801951:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801954:	89 44 24 04          	mov    %eax,0x4(%esp)
  801958:	8b 06                	mov    (%esi),%eax
  80195a:	89 04 24             	mov    %eax,(%esp)
  80195d:	e8 5a ff ff ff       	call   8018bc <dev_lookup>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	85 c0                	test   %eax,%eax
  801966:	78 16                	js     80197e <fd_close+0x68>
		if (dev->dev_close)
  801968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80196e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801973:	85 c0                	test   %eax,%eax
  801975:	74 07                	je     80197e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801977:	89 34 24             	mov    %esi,(%esp)
  80197a:	ff d0                	call   *%eax
  80197c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80197e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801982:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801989:	e8 fe fb ff ff       	call   80158c <sys_page_unmap>
	return r;
  80198e:	89 d8                	mov    %ebx,%eax
}
  801990:	83 c4 20             	add    $0x20,%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    

00801997 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80199d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	89 04 24             	mov    %eax,(%esp)
  8019aa:	e8 b7 fe ff ff       	call   801866 <fd_lookup>
  8019af:	89 c2                	mov    %eax,%edx
  8019b1:	85 d2                	test   %edx,%edx
  8019b3:	78 13                	js     8019c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8019b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019bc:	00 
  8019bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c0:	89 04 24             	mov    %eax,(%esp)
  8019c3:	e8 4e ff ff ff       	call   801916 <fd_close>
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <close_all>:

void
close_all(void)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	53                   	push   %ebx
  8019ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019d6:	89 1c 24             	mov    %ebx,(%esp)
  8019d9:	e8 b9 ff ff ff       	call   801997 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019de:	83 c3 01             	add    $0x1,%ebx
  8019e1:	83 fb 20             	cmp    $0x20,%ebx
  8019e4:	75 f0                	jne    8019d6 <close_all+0xc>
		close(i);
}
  8019e6:	83 c4 14             	add    $0x14,%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5d                   	pop    %ebp
  8019eb:	c3                   	ret    

008019ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	57                   	push   %edi
  8019f0:	56                   	push   %esi
  8019f1:	53                   	push   %ebx
  8019f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	89 04 24             	mov    %eax,(%esp)
  801a02:	e8 5f fe ff ff       	call   801866 <fd_lookup>
  801a07:	89 c2                	mov    %eax,%edx
  801a09:	85 d2                	test   %edx,%edx
  801a0b:	0f 88 e1 00 00 00    	js     801af2 <dup+0x106>
		return r;
	close(newfdnum);
  801a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a14:	89 04 24             	mov    %eax,(%esp)
  801a17:	e8 7b ff ff ff       	call   801997 <close>

	newfd = INDEX2FD(newfdnum);
  801a1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a1f:	c1 e3 0c             	shl    $0xc,%ebx
  801a22:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a2b:	89 04 24             	mov    %eax,(%esp)
  801a2e:	e8 cd fd ff ff       	call   801800 <fd2data>
  801a33:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a35:	89 1c 24             	mov    %ebx,(%esp)
  801a38:	e8 c3 fd ff ff       	call   801800 <fd2data>
  801a3d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a3f:	89 f0                	mov    %esi,%eax
  801a41:	c1 e8 16             	shr    $0x16,%eax
  801a44:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a4b:	a8 01                	test   $0x1,%al
  801a4d:	74 43                	je     801a92 <dup+0xa6>
  801a4f:	89 f0                	mov    %esi,%eax
  801a51:	c1 e8 0c             	shr    $0xc,%eax
  801a54:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a5b:	f6 c2 01             	test   $0x1,%dl
  801a5e:	74 32                	je     801a92 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a60:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a67:	25 07 0e 00 00       	and    $0xe07,%eax
  801a6c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a70:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a74:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a7b:	00 
  801a7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a87:	e8 ad fa ff ff       	call   801539 <sys_page_map>
  801a8c:	89 c6                	mov    %eax,%esi
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 3e                	js     801ad0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a95:	89 c2                	mov    %eax,%edx
  801a97:	c1 ea 0c             	shr    $0xc,%edx
  801a9a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801aa1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801aa7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801aab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801aaf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ab6:	00 
  801ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac2:	e8 72 fa ff ff       	call   801539 <sys_page_map>
  801ac7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801acc:	85 f6                	test   %esi,%esi
  801ace:	79 22                	jns    801af2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ad0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ad4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801adb:	e8 ac fa ff ff       	call   80158c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ae0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ae4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aeb:	e8 9c fa ff ff       	call   80158c <sys_page_unmap>
	return r;
  801af0:	89 f0                	mov    %esi,%eax
}
  801af2:	83 c4 3c             	add    $0x3c,%esp
  801af5:	5b                   	pop    %ebx
  801af6:	5e                   	pop    %esi
  801af7:	5f                   	pop    %edi
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    

00801afa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	53                   	push   %ebx
  801afe:	83 ec 24             	sub    $0x24,%esp
  801b01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0b:	89 1c 24             	mov    %ebx,(%esp)
  801b0e:	e8 53 fd ff ff       	call   801866 <fd_lookup>
  801b13:	89 c2                	mov    %eax,%edx
  801b15:	85 d2                	test   %edx,%edx
  801b17:	78 6d                	js     801b86 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b23:	8b 00                	mov    (%eax),%eax
  801b25:	89 04 24             	mov    %eax,(%esp)
  801b28:	e8 8f fd ff ff       	call   8018bc <dev_lookup>
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 55                	js     801b86 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b34:	8b 50 08             	mov    0x8(%eax),%edx
  801b37:	83 e2 03             	and    $0x3,%edx
  801b3a:	83 fa 01             	cmp    $0x1,%edx
  801b3d:	75 23                	jne    801b62 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b3f:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801b44:	8b 40 48             	mov    0x48(%eax),%eax
  801b47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4f:	c7 04 24 a5 37 80 00 	movl   $0x8037a5,(%esp)
  801b56:	e8 9c ee ff ff       	call   8009f7 <cprintf>
		return -E_INVAL;
  801b5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b60:	eb 24                	jmp    801b86 <read+0x8c>
	}
	if (!dev->dev_read)
  801b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b65:	8b 52 08             	mov    0x8(%edx),%edx
  801b68:	85 d2                	test   %edx,%edx
  801b6a:	74 15                	je     801b81 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b7a:	89 04 24             	mov    %eax,(%esp)
  801b7d:	ff d2                	call   *%edx
  801b7f:	eb 05                	jmp    801b86 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b81:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b86:	83 c4 24             	add    $0x24,%esp
  801b89:	5b                   	pop    %ebx
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    

00801b8c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	57                   	push   %edi
  801b90:	56                   	push   %esi
  801b91:	53                   	push   %ebx
  801b92:	83 ec 1c             	sub    $0x1c,%esp
  801b95:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b98:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ba0:	eb 23                	jmp    801bc5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ba2:	89 f0                	mov    %esi,%eax
  801ba4:	29 d8                	sub    %ebx,%eax
  801ba6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801baa:	89 d8                	mov    %ebx,%eax
  801bac:	03 45 0c             	add    0xc(%ebp),%eax
  801baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb3:	89 3c 24             	mov    %edi,(%esp)
  801bb6:	e8 3f ff ff ff       	call   801afa <read>
		if (m < 0)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 10                	js     801bcf <readn+0x43>
			return m;
		if (m == 0)
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	74 0a                	je     801bcd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bc3:	01 c3                	add    %eax,%ebx
  801bc5:	39 f3                	cmp    %esi,%ebx
  801bc7:	72 d9                	jb     801ba2 <readn+0x16>
  801bc9:	89 d8                	mov    %ebx,%eax
  801bcb:	eb 02                	jmp    801bcf <readn+0x43>
  801bcd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bcf:	83 c4 1c             	add    $0x1c,%esp
  801bd2:	5b                   	pop    %ebx
  801bd3:	5e                   	pop    %esi
  801bd4:	5f                   	pop    %edi
  801bd5:	5d                   	pop    %ebp
  801bd6:	c3                   	ret    

00801bd7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	53                   	push   %ebx
  801bdb:	83 ec 24             	sub    $0x24,%esp
  801bde:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be8:	89 1c 24             	mov    %ebx,(%esp)
  801beb:	e8 76 fc ff ff       	call   801866 <fd_lookup>
  801bf0:	89 c2                	mov    %eax,%edx
  801bf2:	85 d2                	test   %edx,%edx
  801bf4:	78 68                	js     801c5e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	89 04 24             	mov    %eax,(%esp)
  801c05:	e8 b2 fc ff ff       	call   8018bc <dev_lookup>
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 50                	js     801c5e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c11:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c15:	75 23                	jne    801c3a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c17:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801c1c:	8b 40 48             	mov    0x48(%eax),%eax
  801c1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c27:	c7 04 24 c1 37 80 00 	movl   $0x8037c1,(%esp)
  801c2e:	e8 c4 ed ff ff       	call   8009f7 <cprintf>
		return -E_INVAL;
  801c33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c38:	eb 24                	jmp    801c5e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c3d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c40:	85 d2                	test   %edx,%edx
  801c42:	74 15                	je     801c59 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c52:	89 04 24             	mov    %eax,(%esp)
  801c55:	ff d2                	call   *%edx
  801c57:	eb 05                	jmp    801c5e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c59:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c5e:	83 c4 24             	add    $0x24,%esp
  801c61:	5b                   	pop    %ebx
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    

00801c64 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c6a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	89 04 24             	mov    %eax,(%esp)
  801c77:	e8 ea fb ff ff       	call   801866 <fd_lookup>
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 0e                	js     801c8e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c86:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
  801c94:	83 ec 24             	sub    $0x24,%esp
  801c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca1:	89 1c 24             	mov    %ebx,(%esp)
  801ca4:	e8 bd fb ff ff       	call   801866 <fd_lookup>
  801ca9:	89 c2                	mov    %eax,%edx
  801cab:	85 d2                	test   %edx,%edx
  801cad:	78 61                	js     801d10 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801caf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb9:	8b 00                	mov    (%eax),%eax
  801cbb:	89 04 24             	mov    %eax,(%esp)
  801cbe:	e8 f9 fb ff ff       	call   8018bc <dev_lookup>
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 49                	js     801d10 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cce:	75 23                	jne    801cf3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801cd0:	a1 1c 50 80 00       	mov    0x80501c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cd5:	8b 40 48             	mov    0x48(%eax),%eax
  801cd8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce0:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  801ce7:	e8 0b ed ff ff       	call   8009f7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801cec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cf1:	eb 1d                	jmp    801d10 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf6:	8b 52 18             	mov    0x18(%edx),%edx
  801cf9:	85 d2                	test   %edx,%edx
  801cfb:	74 0e                	je     801d0b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d00:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d04:	89 04 24             	mov    %eax,(%esp)
  801d07:	ff d2                	call   *%edx
  801d09:	eb 05                	jmp    801d10 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801d0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d10:	83 c4 24             	add    $0x24,%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    

00801d16 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	53                   	push   %ebx
  801d1a:	83 ec 24             	sub    $0x24,%esp
  801d1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	89 04 24             	mov    %eax,(%esp)
  801d2d:	e8 34 fb ff ff       	call   801866 <fd_lookup>
  801d32:	89 c2                	mov    %eax,%edx
  801d34:	85 d2                	test   %edx,%edx
  801d36:	78 52                	js     801d8a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d42:	8b 00                	mov    (%eax),%eax
  801d44:	89 04 24             	mov    %eax,(%esp)
  801d47:	e8 70 fb ff ff       	call   8018bc <dev_lookup>
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	78 3a                	js     801d8a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d57:	74 2c                	je     801d85 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d59:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d5c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d63:	00 00 00 
	stat->st_isdir = 0;
  801d66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d6d:	00 00 00 
	stat->st_dev = dev;
  801d70:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7d:	89 14 24             	mov    %edx,(%esp)
  801d80:	ff 50 14             	call   *0x14(%eax)
  801d83:	eb 05                	jmp    801d8a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d8a:	83 c4 24             	add    $0x24,%esp
  801d8d:	5b                   	pop    %ebx
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    

00801d90 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d9f:	00 
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	89 04 24             	mov    %eax,(%esp)
  801da6:	e8 99 02 00 00       	call   802044 <open>
  801dab:	89 c3                	mov    %eax,%ebx
  801dad:	85 db                	test   %ebx,%ebx
  801daf:	78 1b                	js     801dcc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db8:	89 1c 24             	mov    %ebx,(%esp)
  801dbb:	e8 56 ff ff ff       	call   801d16 <fstat>
  801dc0:	89 c6                	mov    %eax,%esi
	close(fd);
  801dc2:	89 1c 24             	mov    %ebx,(%esp)
  801dc5:	e8 cd fb ff ff       	call   801997 <close>
	return r;
  801dca:	89 f0                	mov    %esi,%eax
}
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 10             	sub    $0x10,%esp
  801ddb:	89 c6                	mov    %eax,%esi
  801ddd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ddf:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801de6:	75 11                	jne    801df9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801de8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801def:	e8 cb 10 00 00       	call   802ebf <ipc_find_env>
  801df4:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801df9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e00:	00 
  801e01:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e08:	00 
  801e09:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e0d:	a1 10 50 80 00       	mov    0x805010,%eax
  801e12:	89 04 24             	mov    %eax,(%esp)
  801e15:	e8 3e 10 00 00       	call   802e58 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e21:	00 
  801e22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e2d:	e8 be 0f 00 00       	call   802df0 <ipc_recv>
}
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	5b                   	pop    %ebx
  801e36:	5e                   	pop    %esi
  801e37:	5d                   	pop    %ebp
  801e38:	c3                   	ret    

00801e39 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	8b 40 0c             	mov    0xc(%eax),%eax
  801e45:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e52:	ba 00 00 00 00       	mov    $0x0,%edx
  801e57:	b8 02 00 00 00       	mov    $0x2,%eax
  801e5c:	e8 72 ff ff ff       	call   801dd3 <fsipc>
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e74:	ba 00 00 00 00       	mov    $0x0,%edx
  801e79:	b8 06 00 00 00       	mov    $0x6,%eax
  801e7e:	e8 50 ff ff ff       	call   801dd3 <fsipc>
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	53                   	push   %ebx
  801e89:	83 ec 14             	sub    $0x14,%esp
  801e8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	8b 40 0c             	mov    0xc(%eax),%eax
  801e95:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9f:	b8 05 00 00 00       	mov    $0x5,%eax
  801ea4:	e8 2a ff ff ff       	call   801dd3 <fsipc>
  801ea9:	89 c2                	mov    %eax,%edx
  801eab:	85 d2                	test   %edx,%edx
  801ead:	78 2b                	js     801eda <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801eaf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801eb6:	00 
  801eb7:	89 1c 24             	mov    %ebx,(%esp)
  801eba:	e8 b8 f1 ff ff       	call   801077 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ebf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ec4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eca:	a1 84 60 80 00       	mov    0x806084,%eax
  801ecf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eda:	83 c4 14             	add    $0x14,%esp
  801edd:	5b                   	pop    %ebx
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    

00801ee0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 14             	sub    $0x14,%esp
  801ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801eea:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801ef0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ef5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  801efb:	8b 52 0c             	mov    0xc(%edx),%edx
  801efe:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801f04:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801f09:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f14:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801f1b:	e8 f4 f2 ff ff       	call   801214 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801f20:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801f27:	00 
  801f28:	c7 04 24 f4 37 80 00 	movl   $0x8037f4,(%esp)
  801f2f:	e8 c3 ea ff ff       	call   8009f7 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f34:	ba 00 00 00 00       	mov    $0x0,%edx
  801f39:	b8 04 00 00 00       	mov    $0x4,%eax
  801f3e:	e8 90 fe ff ff       	call   801dd3 <fsipc>
  801f43:	85 c0                	test   %eax,%eax
  801f45:	78 53                	js     801f9a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801f47:	39 c3                	cmp    %eax,%ebx
  801f49:	73 24                	jae    801f6f <devfile_write+0x8f>
  801f4b:	c7 44 24 0c f9 37 80 	movl   $0x8037f9,0xc(%esp)
  801f52:	00 
  801f53:	c7 44 24 08 00 38 80 	movl   $0x803800,0x8(%esp)
  801f5a:	00 
  801f5b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801f62:	00 
  801f63:	c7 04 24 15 38 80 00 	movl   $0x803815,(%esp)
  801f6a:	e8 8f e9 ff ff       	call   8008fe <_panic>
	assert(r <= PGSIZE);
  801f6f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f74:	7e 24                	jle    801f9a <devfile_write+0xba>
  801f76:	c7 44 24 0c 20 38 80 	movl   $0x803820,0xc(%esp)
  801f7d:	00 
  801f7e:	c7 44 24 08 00 38 80 	movl   $0x803800,0x8(%esp)
  801f85:	00 
  801f86:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801f8d:	00 
  801f8e:	c7 04 24 15 38 80 00 	movl   $0x803815,(%esp)
  801f95:	e8 64 e9 ff ff       	call   8008fe <_panic>
	return r;
}
  801f9a:	83 c4 14             	add    $0x14,%esp
  801f9d:	5b                   	pop    %ebx
  801f9e:	5d                   	pop    %ebp
  801f9f:	c3                   	ret    

00801fa0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	56                   	push   %esi
  801fa4:	53                   	push   %ebx
  801fa5:	83 ec 10             	sub    $0x10,%esp
  801fa8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801fb6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801fbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc1:	b8 03 00 00 00       	mov    $0x3,%eax
  801fc6:	e8 08 fe ff ff       	call   801dd3 <fsipc>
  801fcb:	89 c3                	mov    %eax,%ebx
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	78 6a                	js     80203b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801fd1:	39 c6                	cmp    %eax,%esi
  801fd3:	73 24                	jae    801ff9 <devfile_read+0x59>
  801fd5:	c7 44 24 0c f9 37 80 	movl   $0x8037f9,0xc(%esp)
  801fdc:	00 
  801fdd:	c7 44 24 08 00 38 80 	movl   $0x803800,0x8(%esp)
  801fe4:	00 
  801fe5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801fec:	00 
  801fed:	c7 04 24 15 38 80 00 	movl   $0x803815,(%esp)
  801ff4:	e8 05 e9 ff ff       	call   8008fe <_panic>
	assert(r <= PGSIZE);
  801ff9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ffe:	7e 24                	jle    802024 <devfile_read+0x84>
  802000:	c7 44 24 0c 20 38 80 	movl   $0x803820,0xc(%esp)
  802007:	00 
  802008:	c7 44 24 08 00 38 80 	movl   $0x803800,0x8(%esp)
  80200f:	00 
  802010:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802017:	00 
  802018:	c7 04 24 15 38 80 00 	movl   $0x803815,(%esp)
  80201f:	e8 da e8 ff ff       	call   8008fe <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802024:	89 44 24 08          	mov    %eax,0x8(%esp)
  802028:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80202f:	00 
  802030:	8b 45 0c             	mov    0xc(%ebp),%eax
  802033:	89 04 24             	mov    %eax,(%esp)
  802036:	e8 d9 f1 ff ff       	call   801214 <memmove>
	return r;
}
  80203b:	89 d8                	mov    %ebx,%eax
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	53                   	push   %ebx
  802048:	83 ec 24             	sub    $0x24,%esp
  80204b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80204e:	89 1c 24             	mov    %ebx,(%esp)
  802051:	e8 ea ef ff ff       	call   801040 <strlen>
  802056:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80205b:	7f 60                	jg     8020bd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80205d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802060:	89 04 24             	mov    %eax,(%esp)
  802063:	e8 af f7 ff ff       	call   801817 <fd_alloc>
  802068:	89 c2                	mov    %eax,%edx
  80206a:	85 d2                	test   %edx,%edx
  80206c:	78 54                	js     8020c2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80206e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802072:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802079:	e8 f9 ef ff ff       	call   801077 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802089:	b8 01 00 00 00       	mov    $0x1,%eax
  80208e:	e8 40 fd ff ff       	call   801dd3 <fsipc>
  802093:	89 c3                	mov    %eax,%ebx
  802095:	85 c0                	test   %eax,%eax
  802097:	79 17                	jns    8020b0 <open+0x6c>
		fd_close(fd, 0);
  802099:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020a0:	00 
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	89 04 24             	mov    %eax,(%esp)
  8020a7:	e8 6a f8 ff ff       	call   801916 <fd_close>
		return r;
  8020ac:	89 d8                	mov    %ebx,%eax
  8020ae:	eb 12                	jmp    8020c2 <open+0x7e>
	}

	return fd2num(fd);
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	89 04 24             	mov    %eax,(%esp)
  8020b6:	e8 35 f7 ff ff       	call   8017f0 <fd2num>
  8020bb:	eb 05                	jmp    8020c2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8020bd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8020c2:	83 c4 24             	add    $0x24,%esp
  8020c5:	5b                   	pop    %ebx
  8020c6:	5d                   	pop    %ebp
  8020c7:	c3                   	ret    

008020c8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8020ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8020d8:	e8 f6 fc ff ff       	call   801dd3 <fsipc>
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <evict>:

int evict(void)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  8020e5:	c7 04 24 2c 38 80 00 	movl   $0x80382c,(%esp)
  8020ec:	e8 06 e9 ff ff       	call   8009f7 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  8020f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f6:	b8 09 00 00 00       	mov    $0x9,%eax
  8020fb:	e8 d3 fc ff ff       	call   801dd3 <fsipc>
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    
  802102:	66 90                	xchg   %ax,%ax
  802104:	66 90                	xchg   %ax,%ax
  802106:	66 90                	xchg   %ax,%ax
  802108:	66 90                	xchg   %ax,%ax
  80210a:	66 90                	xchg   %ax,%ax
  80210c:	66 90                	xchg   %ax,%ax
  80210e:	66 90                	xchg   %ax,%ax

00802110 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802116:	c7 44 24 04 45 38 80 	movl   $0x803845,0x4(%esp)
  80211d:	00 
  80211e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802121:	89 04 24             	mov    %eax,(%esp)
  802124:	e8 4e ef ff ff       	call   801077 <strcpy>
	return 0;
}
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	53                   	push   %ebx
  802134:	83 ec 14             	sub    $0x14,%esp
  802137:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80213a:	89 1c 24             	mov    %ebx,(%esp)
  80213d:	e8 b5 0d 00 00       	call   802ef7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802142:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802147:	83 f8 01             	cmp    $0x1,%eax
  80214a:	75 0d                	jne    802159 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80214c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80214f:	89 04 24             	mov    %eax,(%esp)
  802152:	e8 29 03 00 00       	call   802480 <nsipc_close>
  802157:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802159:	89 d0                	mov    %edx,%eax
  80215b:	83 c4 14             	add    $0x14,%esp
  80215e:	5b                   	pop    %ebx
  80215f:	5d                   	pop    %ebp
  802160:	c3                   	ret    

00802161 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802167:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80216e:	00 
  80216f:	8b 45 10             	mov    0x10(%ebp),%eax
  802172:	89 44 24 08          	mov    %eax,0x8(%esp)
  802176:	8b 45 0c             	mov    0xc(%ebp),%eax
  802179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	8b 40 0c             	mov    0xc(%eax),%eax
  802183:	89 04 24             	mov    %eax,(%esp)
  802186:	e8 f0 03 00 00       	call   80257b <nsipc_send>
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802193:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80219a:	00 
  80219b:	8b 45 10             	mov    0x10(%ebp),%eax
  80219e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8021af:	89 04 24             	mov    %eax,(%esp)
  8021b2:	e8 44 03 00 00       	call   8024fb <nsipc_recv>
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021bf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021c6:	89 04 24             	mov    %eax,(%esp)
  8021c9:	e8 98 f6 ff ff       	call   801866 <fd_lookup>
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	78 17                	js     8021e9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  8021db:	39 08                	cmp    %ecx,(%eax)
  8021dd:	75 05                	jne    8021e4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021df:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e2:	eb 05                	jmp    8021e9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8021e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	83 ec 20             	sub    $0x20,%esp
  8021f3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f8:	89 04 24             	mov    %eax,(%esp)
  8021fb:	e8 17 f6 ff ff       	call   801817 <fd_alloc>
  802200:	89 c3                	mov    %eax,%ebx
  802202:	85 c0                	test   %eax,%eax
  802204:	78 21                	js     802227 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802206:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80220d:	00 
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	89 44 24 04          	mov    %eax,0x4(%esp)
  802215:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80221c:	e8 c4 f2 ff ff       	call   8014e5 <sys_page_alloc>
  802221:	89 c3                	mov    %eax,%ebx
  802223:	85 c0                	test   %eax,%eax
  802225:	79 0c                	jns    802233 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802227:	89 34 24             	mov    %esi,(%esp)
  80222a:	e8 51 02 00 00       	call   802480 <nsipc_close>
		return r;
  80222f:	89 d8                	mov    %ebx,%eax
  802231:	eb 20                	jmp    802253 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802233:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80223e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802241:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802248:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80224b:	89 14 24             	mov    %edx,(%esp)
  80224e:	e8 9d f5 ff ff       	call   8017f0 <fd2num>
}
  802253:	83 c4 20             	add    $0x20,%esp
  802256:	5b                   	pop    %ebx
  802257:	5e                   	pop    %esi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    

0080225a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	e8 51 ff ff ff       	call   8021b9 <fd2sockid>
		return r;
  802268:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80226a:	85 c0                	test   %eax,%eax
  80226c:	78 23                	js     802291 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80226e:	8b 55 10             	mov    0x10(%ebp),%edx
  802271:	89 54 24 08          	mov    %edx,0x8(%esp)
  802275:	8b 55 0c             	mov    0xc(%ebp),%edx
  802278:	89 54 24 04          	mov    %edx,0x4(%esp)
  80227c:	89 04 24             	mov    %eax,(%esp)
  80227f:	e8 45 01 00 00       	call   8023c9 <nsipc_accept>
		return r;
  802284:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802286:	85 c0                	test   %eax,%eax
  802288:	78 07                	js     802291 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80228a:	e8 5c ff ff ff       	call   8021eb <alloc_sockfd>
  80228f:	89 c1                	mov    %eax,%ecx
}
  802291:	89 c8                	mov    %ecx,%eax
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	e8 16 ff ff ff       	call   8021b9 <fd2sockid>
  8022a3:	89 c2                	mov    %eax,%edx
  8022a5:	85 d2                	test   %edx,%edx
  8022a7:	78 16                	js     8022bf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8022a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b7:	89 14 24             	mov    %edx,(%esp)
  8022ba:	e8 60 01 00 00       	call   80241f <nsipc_bind>
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <shutdown>:

int
shutdown(int s, int how)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	e8 ea fe ff ff       	call   8021b9 <fd2sockid>
  8022cf:	89 c2                	mov    %eax,%edx
  8022d1:	85 d2                	test   %edx,%edx
  8022d3:	78 0f                	js     8022e4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8022d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022dc:	89 14 24             	mov    %edx,(%esp)
  8022df:	e8 7a 01 00 00       	call   80245e <nsipc_shutdown>
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	e8 c5 fe ff ff       	call   8021b9 <fd2sockid>
  8022f4:	89 c2                	mov    %eax,%edx
  8022f6:	85 d2                	test   %edx,%edx
  8022f8:	78 16                	js     802310 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8022fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802301:	8b 45 0c             	mov    0xc(%ebp),%eax
  802304:	89 44 24 04          	mov    %eax,0x4(%esp)
  802308:	89 14 24             	mov    %edx,(%esp)
  80230b:	e8 8a 01 00 00       	call   80249a <nsipc_connect>
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <listen>:

int
listen(int s, int backlog)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	e8 99 fe ff ff       	call   8021b9 <fd2sockid>
  802320:	89 c2                	mov    %eax,%edx
  802322:	85 d2                	test   %edx,%edx
  802324:	78 0f                	js     802335 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802326:	8b 45 0c             	mov    0xc(%ebp),%eax
  802329:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232d:	89 14 24             	mov    %edx,(%esp)
  802330:	e8 a4 01 00 00       	call   8024d9 <nsipc_listen>
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80233d:	8b 45 10             	mov    0x10(%ebp),%eax
  802340:	89 44 24 08          	mov    %eax,0x8(%esp)
  802344:	8b 45 0c             	mov    0xc(%ebp),%eax
  802347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	89 04 24             	mov    %eax,(%esp)
  802351:	e8 98 02 00 00       	call   8025ee <nsipc_socket>
  802356:	89 c2                	mov    %eax,%edx
  802358:	85 d2                	test   %edx,%edx
  80235a:	78 05                	js     802361 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80235c:	e8 8a fe ff ff       	call   8021eb <alloc_sockfd>
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	53                   	push   %ebx
  802367:	83 ec 14             	sub    $0x14,%esp
  80236a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80236c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802373:	75 11                	jne    802386 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802375:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80237c:	e8 3e 0b 00 00       	call   802ebf <ipc_find_env>
  802381:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802386:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80238d:	00 
  80238e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802395:	00 
  802396:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80239a:	a1 14 50 80 00       	mov    0x805014,%eax
  80239f:	89 04 24             	mov    %eax,(%esp)
  8023a2:	e8 b1 0a 00 00       	call   802e58 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023ae:	00 
  8023af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023b6:	00 
  8023b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023be:	e8 2d 0a 00 00       	call   802df0 <ipc_recv>
}
  8023c3:	83 c4 14             	add    $0x14,%esp
  8023c6:	5b                   	pop    %ebx
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    

008023c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	56                   	push   %esi
  8023cd:	53                   	push   %ebx
  8023ce:	83 ec 10             	sub    $0x10,%esp
  8023d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023dc:	8b 06                	mov    (%esi),%eax
  8023de:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e8:	e8 76 ff ff ff       	call   802363 <nsipc>
  8023ed:	89 c3                	mov    %eax,%ebx
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	78 23                	js     802416 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023f3:	a1 10 70 80 00       	mov    0x807010,%eax
  8023f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023fc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802403:	00 
  802404:	8b 45 0c             	mov    0xc(%ebp),%eax
  802407:	89 04 24             	mov    %eax,(%esp)
  80240a:	e8 05 ee ff ff       	call   801214 <memmove>
		*addrlen = ret->ret_addrlen;
  80240f:	a1 10 70 80 00       	mov    0x807010,%eax
  802414:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802416:	89 d8                	mov    %ebx,%eax
  802418:	83 c4 10             	add    $0x10,%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5e                   	pop    %esi
  80241d:	5d                   	pop    %ebp
  80241e:	c3                   	ret    

0080241f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	53                   	push   %ebx
  802423:	83 ec 14             	sub    $0x14,%esp
  802426:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802431:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802435:	8b 45 0c             	mov    0xc(%ebp),%eax
  802438:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802443:	e8 cc ed ff ff       	call   801214 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802448:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80244e:	b8 02 00 00 00       	mov    $0x2,%eax
  802453:	e8 0b ff ff ff       	call   802363 <nsipc>
}
  802458:	83 c4 14             	add    $0x14,%esp
  80245b:	5b                   	pop    %ebx
  80245c:	5d                   	pop    %ebp
  80245d:	c3                   	ret    

0080245e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80246c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802474:	b8 03 00 00 00       	mov    $0x3,%eax
  802479:	e8 e5 fe ff ff       	call   802363 <nsipc>
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <nsipc_close>:

int
nsipc_close(int s)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80248e:	b8 04 00 00 00       	mov    $0x4,%eax
  802493:	e8 cb fe ff ff       	call   802363 <nsipc>
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	53                   	push   %ebx
  80249e:	83 ec 14             	sub    $0x14,%esp
  8024a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8024be:	e8 51 ed ff ff       	call   801214 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024c3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8024c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8024ce:	e8 90 fe ff ff       	call   802363 <nsipc>
}
  8024d3:	83 c4 14             	add    $0x14,%esp
  8024d6:	5b                   	pop    %ebx
  8024d7:	5d                   	pop    %ebp
  8024d8:	c3                   	ret    

008024d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8024e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ea:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8024ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8024f4:	e8 6a fe ff ff       	call   802363 <nsipc>
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	56                   	push   %esi
  8024ff:	53                   	push   %ebx
  802500:	83 ec 10             	sub    $0x10,%esp
  802503:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80250e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802514:	8b 45 14             	mov    0x14(%ebp),%eax
  802517:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80251c:	b8 07 00 00 00       	mov    $0x7,%eax
  802521:	e8 3d fe ff ff       	call   802363 <nsipc>
  802526:	89 c3                	mov    %eax,%ebx
  802528:	85 c0                	test   %eax,%eax
  80252a:	78 46                	js     802572 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80252c:	39 f0                	cmp    %esi,%eax
  80252e:	7f 07                	jg     802537 <nsipc_recv+0x3c>
  802530:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802535:	7e 24                	jle    80255b <nsipc_recv+0x60>
  802537:	c7 44 24 0c 51 38 80 	movl   $0x803851,0xc(%esp)
  80253e:	00 
  80253f:	c7 44 24 08 00 38 80 	movl   $0x803800,0x8(%esp)
  802546:	00 
  802547:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80254e:	00 
  80254f:	c7 04 24 66 38 80 00 	movl   $0x803866,(%esp)
  802556:	e8 a3 e3 ff ff       	call   8008fe <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80255b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80255f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802566:	00 
  802567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256a:	89 04 24             	mov    %eax,(%esp)
  80256d:	e8 a2 ec ff ff       	call   801214 <memmove>
	}

	return r;
}
  802572:	89 d8                	mov    %ebx,%eax
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5d                   	pop    %ebp
  80257a:	c3                   	ret    

0080257b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	53                   	push   %ebx
  80257f:	83 ec 14             	sub    $0x14,%esp
  802582:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80258d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802593:	7e 24                	jle    8025b9 <nsipc_send+0x3e>
  802595:	c7 44 24 0c 72 38 80 	movl   $0x803872,0xc(%esp)
  80259c:	00 
  80259d:	c7 44 24 08 00 38 80 	movl   $0x803800,0x8(%esp)
  8025a4:	00 
  8025a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8025ac:	00 
  8025ad:	c7 04 24 66 38 80 00 	movl   $0x803866,(%esp)
  8025b4:	e8 45 e3 ff ff       	call   8008fe <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8025b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8025cb:	e8 44 ec ff ff       	call   801214 <memmove>
	nsipcbuf.send.req_size = size;
  8025d0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8025d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8025de:	b8 08 00 00 00       	mov    $0x8,%eax
  8025e3:	e8 7b fd ff ff       	call   802363 <nsipc>
}
  8025e8:	83 c4 14             	add    $0x14,%esp
  8025eb:	5b                   	pop    %ebx
  8025ec:	5d                   	pop    %ebp
  8025ed:	c3                   	ret    

008025ee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8025fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ff:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802604:	8b 45 10             	mov    0x10(%ebp),%eax
  802607:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80260c:	b8 09 00 00 00       	mov    $0x9,%eax
  802611:	e8 4d fd ff ff       	call   802363 <nsipc>
}
  802616:	c9                   	leave  
  802617:	c3                   	ret    
  802618:	66 90                	xchg   %ax,%ax
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <free>:
	return v;
}

void
free(void *v)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	53                   	push   %ebx
  802624:	83 ec 14             	sub    $0x14,%esp
  802627:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  80262a:	85 db                	test   %ebx,%ebx
  80262c:	0f 84 ba 00 00 00    	je     8026ec <free+0xcc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  802632:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  802638:	76 08                	jbe    802642 <free+0x22>
  80263a:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  802640:	76 24                	jbe    802666 <free+0x46>
  802642:	c7 44 24 0c 80 38 80 	movl   $0x803880,0xc(%esp)
  802649:	00 
  80264a:	c7 44 24 08 00 38 80 	movl   $0x803800,0x8(%esp)
  802651:	00 
  802652:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  802659:	00 
  80265a:	c7 04 24 ae 38 80 00 	movl   $0x8038ae,(%esp)
  802661:	e8 98 e2 ff ff       	call   8008fe <_panic>

	c = ROUNDDOWN(v, PGSIZE);
  802666:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  80266c:	eb 4a                	jmp    8026b8 <free+0x98>
		sys_page_unmap(0, c);
  80266e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802672:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802679:	e8 0e ef ff ff       	call   80158c <sys_page_unmap>
		c += PGSIZE;
  80267e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802684:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  80268a:	76 08                	jbe    802694 <free+0x74>
  80268c:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  802692:	76 24                	jbe    8026b8 <free+0x98>
  802694:	c7 44 24 0c bb 38 80 	movl   $0x8038bb,0xc(%esp)
  80269b:	00 
  80269c:	c7 44 24 08 00 38 80 	movl   $0x803800,0x8(%esp)
  8026a3:	00 
  8026a4:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  8026ab:	00 
  8026ac:	c7 04 24 ae 38 80 00 	movl   $0x8038ae,(%esp)
  8026b3:	e8 46 e2 ff ff       	call   8008fe <_panic>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8026b8:	89 d8                	mov    %ebx,%eax
  8026ba:	c1 e8 0c             	shr    $0xc,%eax
  8026bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8026c4:	f6 c4 02             	test   $0x2,%ah
  8026c7:	75 a5                	jne    80266e <free+0x4e>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  8026c9:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  8026cf:	83 e8 01             	sub    $0x1,%eax
  8026d2:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	75 10                	jne    8026ec <free+0xcc>
		sys_page_unmap(0, c);
  8026dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e7:	e8 a0 ee ff ff       	call   80158c <sys_page_unmap>
}
  8026ec:	83 c4 14             	add    $0x14,%esp
  8026ef:	5b                   	pop    %ebx
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    

008026f2 <malloc>:
	return 1;
}

void*
malloc(size_t n)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	57                   	push   %edi
  8026f6:	56                   	push   %esi
  8026f7:	53                   	push   %ebx
  8026f8:	83 ec 2c             	sub    $0x2c,%esp
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  8026fb:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802702:	75 0a                	jne    80270e <malloc+0x1c>
		mptr = mbegin;
  802704:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  80270b:	00 00 08 

	n = ROUNDUP(n, 4);
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	83 c0 03             	add    $0x3,%eax
  802714:	83 e0 fc             	and    $0xfffffffc,%eax
  802717:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (n >= MAXMALLOC)
  80271a:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  80271f:	0f 87 64 01 00 00    	ja     802889 <malloc+0x197>
		return 0;

	if ((uintptr_t) mptr % PGSIZE){
  802725:	a1 18 50 80 00       	mov    0x805018,%eax
  80272a:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80272f:	75 15                	jne    802746 <malloc+0x54>
  802731:	8b 35 18 50 80 00    	mov    0x805018,%esi
	return 1;
}

void*
malloc(size_t n)
{
  802737:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  80273e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802741:	8d 78 04             	lea    0x4(%eax),%edi
  802744:	eb 50                	jmp    802796 <malloc+0xa4>
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  802746:	89 c1                	mov    %eax,%ecx
  802748:	c1 e9 0c             	shr    $0xc,%ecx
  80274b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80274e:	8d 54 18 03          	lea    0x3(%eax,%ebx,1),%edx
  802752:	c1 ea 0c             	shr    $0xc,%edx
  802755:	39 d1                	cmp    %edx,%ecx
  802757:	75 1f                	jne    802778 <malloc+0x86>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  802759:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80275f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
			(*ref)++;
  802765:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			v = mptr;
			mptr += n;
  802769:	89 da                	mov    %ebx,%edx
  80276b:	01 c2                	add    %eax,%edx
  80276d:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  802773:	e9 2f 01 00 00       	jmp    8028a7 <malloc+0x1b5>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  802778:	89 04 24             	mov    %eax,(%esp)
  80277b:	e8 a0 fe ff ff       	call   802620 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  802780:	a1 18 50 80 00       	mov    0x805018,%eax
  802785:	05 00 10 00 00       	add    $0x1000,%eax
  80278a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80278f:	a3 18 50 80 00       	mov    %eax,0x805018
  802794:	eb 9b                	jmp    802731 <malloc+0x3f>
  802796:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  802799:	89 fb                	mov    %edi,%ebx
  80279b:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  80279e:	89 f0                	mov    %esi,%eax
  8027a0:	eb 36                	jmp    8027d8 <malloc+0xe6>
		if (va >= (uintptr_t) mend
  8027a2:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  8027a7:	0f 87 e3 00 00 00    	ja     802890 <malloc+0x19e>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  8027ad:	89 c2                	mov    %eax,%edx
  8027af:	c1 ea 16             	shr    $0x16,%edx
  8027b2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027b9:	f6 c2 01             	test   $0x1,%dl
  8027bc:	74 15                	je     8027d3 <malloc+0xe1>
  8027be:	89 c2                	mov    %eax,%edx
  8027c0:	c1 ea 0c             	shr    $0xc,%edx
  8027c3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8027ca:	f6 c2 01             	test   $0x1,%dl
  8027cd:	0f 85 bd 00 00 00    	jne    802890 <malloc+0x19e>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8027d3:	05 00 10 00 00       	add    $0x1000,%eax
  8027d8:	39 c1                	cmp    %eax,%ecx
  8027da:	77 c6                	ja     8027a2 <malloc+0xb0>
  8027dc:	eb 7e                	jmp    80285c <malloc+0x16a>
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
			if (++nwrap == 2)
  8027de:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  8027e2:	74 07                	je     8027eb <malloc+0xf9>
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
  8027e4:	be 00 00 00 08       	mov    $0x8000000,%esi
  8027e9:	eb ab                	jmp    802796 <malloc+0xa4>
  8027eb:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8027f2:	00 00 08 
			if (++nwrap == 2)
				return 0;	/* out of address space */
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fa:	e9 a8 00 00 00       	jmp    8028a7 <malloc+0x1b5>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8027ff:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
  802805:	39 df                	cmp    %ebx,%edi
  802807:	19 c0                	sbb    %eax,%eax
  802809:	25 00 02 00 00       	and    $0x200,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  80280e:	83 c8 07             	or     $0x7,%eax
  802811:	89 44 24 08          	mov    %eax,0x8(%esp)
  802815:	03 15 18 50 80 00    	add    0x805018,%edx
  80281b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80281f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802826:	e8 ba ec ff ff       	call   8014e5 <sys_page_alloc>
  80282b:	85 c0                	test   %eax,%eax
  80282d:	78 22                	js     802851 <malloc+0x15f>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  80282f:	89 fe                	mov    %edi,%esi
  802831:	eb 36                	jmp    802869 <malloc+0x177>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
				sys_page_unmap(0, mptr + i);
  802833:	89 f0                	mov    %esi,%eax
  802835:	03 05 18 50 80 00    	add    0x805018,%eax
  80283b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80283f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802846:	e8 41 ed ff ff       	call   80158c <sys_page_unmap>
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  80284b:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  802851:	85 f6                	test   %esi,%esi
  802853:	79 de                	jns    802833 <malloc+0x141>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
  80285a:	eb 4b                	jmp    8028a7 <malloc+0x1b5>
  80285c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285f:	a3 18 50 80 00       	mov    %eax,0x805018
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802864:	be 00 00 00 00       	mov    $0x0,%esi
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  802869:	89 f2                	mov    %esi,%edx
  80286b:	39 de                	cmp    %ebx,%esi
  80286d:	72 90                	jb     8027ff <malloc+0x10d>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  80286f:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802874:	c7 44 30 fc 02 00 00 	movl   $0x2,-0x4(%eax,%esi,1)
  80287b:	00 
	v = mptr;
	mptr += n;
  80287c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80287f:	01 c2                	add    %eax,%edx
  802881:	89 15 18 50 80 00    	mov    %edx,0x805018
	return v;
  802887:	eb 1e                	jmp    8028a7 <malloc+0x1b5>
		mptr = mbegin;

	n = ROUNDUP(n, 4);

	if (n >= MAXMALLOC)
		return 0;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax
  80288e:	eb 17                	jmp    8028a7 <malloc+0x1b5>
  802890:	81 c6 00 10 00 00    	add    $0x1000,%esi
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
  802896:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
  80289c:	0f 84 3c ff ff ff    	je     8027de <malloc+0xec>
  8028a2:	e9 ef fe ff ff       	jmp    802796 <malloc+0xa4>
	ref = (uint32_t*) (mptr + i - 4);
	*ref = 2;	/* reference for mptr, reference for returned block */
	v = mptr;
	mptr += n;
	return v;
}
  8028a7:	83 c4 2c             	add    $0x2c,%esp
  8028aa:	5b                   	pop    %ebx
  8028ab:	5e                   	pop    %esi
  8028ac:	5f                   	pop    %edi
  8028ad:	5d                   	pop    %ebp
  8028ae:	c3                   	ret    

008028af <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8028af:	55                   	push   %ebp
  8028b0:	89 e5                	mov    %esp,%ebp
  8028b2:	56                   	push   %esi
  8028b3:	53                   	push   %ebx
  8028b4:	83 ec 10             	sub    $0x10,%esp
  8028b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	89 04 24             	mov    %eax,(%esp)
  8028c0:	e8 3b ef ff ff       	call   801800 <fd2data>
  8028c5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8028c7:	c7 44 24 04 d3 38 80 	movl   $0x8038d3,0x4(%esp)
  8028ce:	00 
  8028cf:	89 1c 24             	mov    %ebx,(%esp)
  8028d2:	e8 a0 e7 ff ff       	call   801077 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8028d7:	8b 46 04             	mov    0x4(%esi),%eax
  8028da:	2b 06                	sub    (%esi),%eax
  8028dc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8028e2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8028e9:	00 00 00 
	stat->st_dev = &devpipe;
  8028ec:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  8028f3:	40 80 00 
	return 0;
}
  8028f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fb:	83 c4 10             	add    $0x10,%esp
  8028fe:	5b                   	pop    %ebx
  8028ff:	5e                   	pop    %esi
  802900:	5d                   	pop    %ebp
  802901:	c3                   	ret    

00802902 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	53                   	push   %ebx
  802906:	83 ec 14             	sub    $0x14,%esp
  802909:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80290c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802910:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802917:	e8 70 ec ff ff       	call   80158c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80291c:	89 1c 24             	mov    %ebx,(%esp)
  80291f:	e8 dc ee ff ff       	call   801800 <fd2data>
  802924:	89 44 24 04          	mov    %eax,0x4(%esp)
  802928:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80292f:	e8 58 ec ff ff       	call   80158c <sys_page_unmap>
}
  802934:	83 c4 14             	add    $0x14,%esp
  802937:	5b                   	pop    %ebx
  802938:	5d                   	pop    %ebp
  802939:	c3                   	ret    

0080293a <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	57                   	push   %edi
  80293e:	56                   	push   %esi
  80293f:	53                   	push   %ebx
  802940:	83 ec 2c             	sub    $0x2c,%esp
  802943:	89 c6                	mov    %eax,%esi
  802945:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802948:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80294d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802950:	89 34 24             	mov    %esi,(%esp)
  802953:	e8 9f 05 00 00       	call   802ef7 <pageref>
  802958:	89 c7                	mov    %eax,%edi
  80295a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295d:	89 04 24             	mov    %eax,(%esp)
  802960:	e8 92 05 00 00       	call   802ef7 <pageref>
  802965:	39 c7                	cmp    %eax,%edi
  802967:	0f 94 c2             	sete   %dl
  80296a:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80296d:	8b 0d 1c 50 80 00    	mov    0x80501c,%ecx
  802973:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802976:	39 fb                	cmp    %edi,%ebx
  802978:	74 21                	je     80299b <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80297a:	84 d2                	test   %dl,%dl
  80297c:	74 ca                	je     802948 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80297e:	8b 51 58             	mov    0x58(%ecx),%edx
  802981:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802985:	89 54 24 08          	mov    %edx,0x8(%esp)
  802989:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80298d:	c7 04 24 da 38 80 00 	movl   $0x8038da,(%esp)
  802994:	e8 5e e0 ff ff       	call   8009f7 <cprintf>
  802999:	eb ad                	jmp    802948 <_pipeisclosed+0xe>
	}
}
  80299b:	83 c4 2c             	add    $0x2c,%esp
  80299e:	5b                   	pop    %ebx
  80299f:	5e                   	pop    %esi
  8029a0:	5f                   	pop    %edi
  8029a1:	5d                   	pop    %ebp
  8029a2:	c3                   	ret    

008029a3 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
  8029a6:	57                   	push   %edi
  8029a7:	56                   	push   %esi
  8029a8:	53                   	push   %ebx
  8029a9:	83 ec 1c             	sub    $0x1c,%esp
  8029ac:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8029af:	89 34 24             	mov    %esi,(%esp)
  8029b2:	e8 49 ee ff ff       	call   801800 <fd2data>
  8029b7:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8029be:	eb 45                	jmp    802a05 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8029c0:	89 da                	mov    %ebx,%edx
  8029c2:	89 f0                	mov    %esi,%eax
  8029c4:	e8 71 ff ff ff       	call   80293a <_pipeisclosed>
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	75 41                	jne    802a0e <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8029cd:	e8 f4 ea ff ff       	call   8014c6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8029d2:	8b 43 04             	mov    0x4(%ebx),%eax
  8029d5:	8b 0b                	mov    (%ebx),%ecx
  8029d7:	8d 51 20             	lea    0x20(%ecx),%edx
  8029da:	39 d0                	cmp    %edx,%eax
  8029dc:	73 e2                	jae    8029c0 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8029de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029e1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8029e5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8029e8:	99                   	cltd   
  8029e9:	c1 ea 1b             	shr    $0x1b,%edx
  8029ec:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8029ef:	83 e1 1f             	and    $0x1f,%ecx
  8029f2:	29 d1                	sub    %edx,%ecx
  8029f4:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8029f8:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8029fc:	83 c0 01             	add    $0x1,%eax
  8029ff:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a02:	83 c7 01             	add    $0x1,%edi
  802a05:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a08:	75 c8                	jne    8029d2 <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802a0a:	89 f8                	mov    %edi,%eax
  802a0c:	eb 05                	jmp    802a13 <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802a0e:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802a13:	83 c4 1c             	add    $0x1c,%esp
  802a16:	5b                   	pop    %ebx
  802a17:	5e                   	pop    %esi
  802a18:	5f                   	pop    %edi
  802a19:	5d                   	pop    %ebp
  802a1a:	c3                   	ret    

00802a1b <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
  802a1e:	57                   	push   %edi
  802a1f:	56                   	push   %esi
  802a20:	53                   	push   %ebx
  802a21:	83 ec 1c             	sub    $0x1c,%esp
  802a24:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802a27:	89 3c 24             	mov    %edi,(%esp)
  802a2a:	e8 d1 ed ff ff       	call   801800 <fd2data>
  802a2f:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a31:	be 00 00 00 00       	mov    $0x0,%esi
  802a36:	eb 3d                	jmp    802a75 <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802a38:	85 f6                	test   %esi,%esi
  802a3a:	74 04                	je     802a40 <devpipe_read+0x25>
				return i;
  802a3c:	89 f0                	mov    %esi,%eax
  802a3e:	eb 43                	jmp    802a83 <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802a40:	89 da                	mov    %ebx,%edx
  802a42:	89 f8                	mov    %edi,%eax
  802a44:	e8 f1 fe ff ff       	call   80293a <_pipeisclosed>
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	75 31                	jne    802a7e <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802a4d:	e8 74 ea ff ff       	call   8014c6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802a52:	8b 03                	mov    (%ebx),%eax
  802a54:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a57:	74 df                	je     802a38 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802a59:	99                   	cltd   
  802a5a:	c1 ea 1b             	shr    $0x1b,%edx
  802a5d:	01 d0                	add    %edx,%eax
  802a5f:	83 e0 1f             	and    $0x1f,%eax
  802a62:	29 d0                	sub    %edx,%eax
  802a64:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802a69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a6c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802a6f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a72:	83 c6 01             	add    $0x1,%esi
  802a75:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a78:	75 d8                	jne    802a52 <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802a7a:	89 f0                	mov    %esi,%eax
  802a7c:	eb 05                	jmp    802a83 <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802a7e:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802a83:	83 c4 1c             	add    $0x1c,%esp
  802a86:	5b                   	pop    %ebx
  802a87:	5e                   	pop    %esi
  802a88:	5f                   	pop    %edi
  802a89:	5d                   	pop    %ebp
  802a8a:	c3                   	ret    

00802a8b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	56                   	push   %esi
  802a8f:	53                   	push   %ebx
  802a90:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a96:	89 04 24             	mov    %eax,(%esp)
  802a99:	e8 79 ed ff ff       	call   801817 <fd_alloc>
  802a9e:	89 c2                	mov    %eax,%edx
  802aa0:	85 d2                	test   %edx,%edx
  802aa2:	0f 88 4d 01 00 00    	js     802bf5 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802aa8:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802aaf:	00 
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802abe:	e8 22 ea ff ff       	call   8014e5 <sys_page_alloc>
  802ac3:	89 c2                	mov    %eax,%edx
  802ac5:	85 d2                	test   %edx,%edx
  802ac7:	0f 88 28 01 00 00    	js     802bf5 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802acd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ad0:	89 04 24             	mov    %eax,(%esp)
  802ad3:	e8 3f ed ff ff       	call   801817 <fd_alloc>
  802ad8:	89 c3                	mov    %eax,%ebx
  802ada:	85 c0                	test   %eax,%eax
  802adc:	0f 88 fe 00 00 00    	js     802be0 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ae2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ae9:	00 
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802af8:	e8 e8 e9 ff ff       	call   8014e5 <sys_page_alloc>
  802afd:	89 c3                	mov    %eax,%ebx
  802aff:	85 c0                	test   %eax,%eax
  802b01:	0f 88 d9 00 00 00    	js     802be0 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	89 04 24             	mov    %eax,(%esp)
  802b0d:	e8 ee ec ff ff       	call   801800 <fd2data>
  802b12:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b14:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b1b:	00 
  802b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b27:	e8 b9 e9 ff ff       	call   8014e5 <sys_page_alloc>
  802b2c:	89 c3                	mov    %eax,%ebx
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	0f 88 97 00 00 00    	js     802bcd <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	89 04 24             	mov    %eax,(%esp)
  802b3c:	e8 bf ec ff ff       	call   801800 <fd2data>
  802b41:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802b48:	00 
  802b49:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b4d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802b54:	00 
  802b55:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b60:	e8 d4 e9 ff ff       	call   801539 <sys_page_map>
  802b65:	89 c3                	mov    %eax,%ebx
  802b67:	85 c0                	test   %eax,%eax
  802b69:	78 52                	js     802bbd <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802b6b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802b80:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	89 04 24             	mov    %eax,(%esp)
  802b9b:	e8 50 ec ff ff       	call   8017f0 <fd2num>
  802ba0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ba3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	89 04 24             	mov    %eax,(%esp)
  802bab:	e8 40 ec ff ff       	call   8017f0 <fd2num>
  802bb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bb3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbb:	eb 38                	jmp    802bf5 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802bbd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bc8:	e8 bf e9 ff ff       	call   80158c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bdb:	e8 ac e9 ff ff       	call   80158c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bee:	e8 99 e9 ff ff       	call   80158c <sys_page_unmap>
  802bf3:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802bf5:	83 c4 30             	add    $0x30,%esp
  802bf8:	5b                   	pop    %ebx
  802bf9:	5e                   	pop    %esi
  802bfa:	5d                   	pop    %ebp
  802bfb:	c3                   	ret    

00802bfc <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
  802bff:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	89 04 24             	mov    %eax,(%esp)
  802c0f:	e8 52 ec ff ff       	call   801866 <fd_lookup>
  802c14:	89 c2                	mov    %eax,%edx
  802c16:	85 d2                	test   %edx,%edx
  802c18:	78 15                	js     802c2f <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	89 04 24             	mov    %eax,(%esp)
  802c20:	e8 db eb ff ff       	call   801800 <fd2data>
	return _pipeisclosed(fd, p);
  802c25:	89 c2                	mov    %eax,%edx
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	e8 0b fd ff ff       	call   80293a <_pipeisclosed>
}
  802c2f:	c9                   	leave  
  802c30:	c3                   	ret    
  802c31:	66 90                	xchg   %ax,%ax
  802c33:	66 90                	xchg   %ax,%ax
  802c35:	66 90                	xchg   %ax,%ax
  802c37:	66 90                	xchg   %ax,%ax
  802c39:	66 90                	xchg   %ax,%ax
  802c3b:	66 90                	xchg   %ax,%ax
  802c3d:	66 90                	xchg   %ax,%ax
  802c3f:	90                   	nop

00802c40 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802c43:	b8 00 00 00 00       	mov    $0x0,%eax
  802c48:	5d                   	pop    %ebp
  802c49:	c3                   	ret    

00802c4a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802c4a:	55                   	push   %ebp
  802c4b:	89 e5                	mov    %esp,%ebp
  802c4d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802c50:	c7 44 24 04 f2 38 80 	movl   $0x8038f2,0x4(%esp)
  802c57:	00 
  802c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c5b:	89 04 24             	mov    %eax,(%esp)
  802c5e:	e8 14 e4 ff ff       	call   801077 <strcpy>
	return 0;
}
  802c63:	b8 00 00 00 00       	mov    $0x0,%eax
  802c68:	c9                   	leave  
  802c69:	c3                   	ret    

00802c6a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c6a:	55                   	push   %ebp
  802c6b:	89 e5                	mov    %esp,%ebp
  802c6d:	57                   	push   %edi
  802c6e:	56                   	push   %esi
  802c6f:	53                   	push   %ebx
  802c70:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c76:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802c7b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c81:	eb 31                	jmp    802cb4 <devcons_write+0x4a>
		m = n - tot;
  802c83:	8b 75 10             	mov    0x10(%ebp),%esi
  802c86:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802c88:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802c8b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802c90:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802c93:	89 74 24 08          	mov    %esi,0x8(%esp)
  802c97:	03 45 0c             	add    0xc(%ebp),%eax
  802c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c9e:	89 3c 24             	mov    %edi,(%esp)
  802ca1:	e8 6e e5 ff ff       	call   801214 <memmove>
		sys_cputs(buf, m);
  802ca6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802caa:	89 3c 24             	mov    %edi,(%esp)
  802cad:	e8 14 e7 ff ff       	call   8013c6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802cb2:	01 f3                	add    %esi,%ebx
  802cb4:	89 d8                	mov    %ebx,%eax
  802cb6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802cb9:	72 c8                	jb     802c83 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802cbb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802cc1:	5b                   	pop    %ebx
  802cc2:	5e                   	pop    %esi
  802cc3:	5f                   	pop    %edi
  802cc4:	5d                   	pop    %ebp
  802cc5:	c3                   	ret    

00802cc6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802cc6:	55                   	push   %ebp
  802cc7:	89 e5                	mov    %esp,%ebp
  802cc9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802ccc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802cd5:	75 07                	jne    802cde <devcons_read+0x18>
  802cd7:	eb 2a                	jmp    802d03 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802cd9:	e8 e8 e7 ff ff       	call   8014c6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802cde:	66 90                	xchg   %ax,%ax
  802ce0:	e8 ff e6 ff ff       	call   8013e4 <sys_cgetc>
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 f0                	je     802cd9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	78 16                	js     802d03 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802ced:	83 f8 04             	cmp    $0x4,%eax
  802cf0:	74 0c                	je     802cfe <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf5:	88 02                	mov    %al,(%edx)
	return 1;
  802cf7:	b8 01 00 00 00       	mov    $0x1,%eax
  802cfc:	eb 05                	jmp    802d03 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802d03:	c9                   	leave  
  802d04:	c3                   	ret    

00802d05 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802d05:	55                   	push   %ebp
  802d06:	89 e5                	mov    %esp,%ebp
  802d08:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802d11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802d18:	00 
  802d19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d1c:	89 04 24             	mov    %eax,(%esp)
  802d1f:	e8 a2 e6 ff ff       	call   8013c6 <sys_cputs>
}
  802d24:	c9                   	leave  
  802d25:	c3                   	ret    

00802d26 <getchar>:

int
getchar(void)
{
  802d26:	55                   	push   %ebp
  802d27:	89 e5                	mov    %esp,%ebp
  802d29:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802d2c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802d33:	00 
  802d34:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d37:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d42:	e8 b3 ed ff ff       	call   801afa <read>
	if (r < 0)
  802d47:	85 c0                	test   %eax,%eax
  802d49:	78 0f                	js     802d5a <getchar+0x34>
		return r;
	if (r < 1)
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	7e 06                	jle    802d55 <getchar+0x2f>
		return -E_EOF;
	return c;
  802d4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802d53:	eb 05                	jmp    802d5a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802d55:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802d5a:	c9                   	leave  
  802d5b:	c3                   	ret    

00802d5c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802d5c:	55                   	push   %ebp
  802d5d:	89 e5                	mov    %esp,%ebp
  802d5f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	89 04 24             	mov    %eax,(%esp)
  802d6f:	e8 f2 ea ff ff       	call   801866 <fd_lookup>
  802d74:	85 c0                	test   %eax,%eax
  802d76:	78 11                	js     802d89 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802d81:	39 10                	cmp    %edx,(%eax)
  802d83:	0f 94 c0             	sete   %al
  802d86:	0f b6 c0             	movzbl %al,%eax
}
  802d89:	c9                   	leave  
  802d8a:	c3                   	ret    

00802d8b <opencons>:

int
opencons(void)
{
  802d8b:	55                   	push   %ebp
  802d8c:	89 e5                	mov    %esp,%ebp
  802d8e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802d91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d94:	89 04 24             	mov    %eax,(%esp)
  802d97:	e8 7b ea ff ff       	call   801817 <fd_alloc>
		return r;
  802d9c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	78 40                	js     802de2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802da2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802da9:	00 
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  802db1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802db8:	e8 28 e7 ff ff       	call   8014e5 <sys_page_alloc>
		return r;
  802dbd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	78 1f                	js     802de2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802dc3:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802dd8:	89 04 24             	mov    %eax,(%esp)
  802ddb:	e8 10 ea ff ff       	call   8017f0 <fd2num>
  802de0:	89 c2                	mov    %eax,%edx
}
  802de2:	89 d0                	mov    %edx,%eax
  802de4:	c9                   	leave  
  802de5:	c3                   	ret    
  802de6:	66 90                	xchg   %ax,%ax
  802de8:	66 90                	xchg   %ax,%ax
  802dea:	66 90                	xchg   %ax,%ax
  802dec:	66 90                	xchg   %ax,%ax
  802dee:	66 90                	xchg   %ax,%ax

00802df0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	56                   	push   %esi
  802df4:	53                   	push   %ebx
  802df5:	83 ec 10             	sub    $0x10,%esp
  802df8:	8b 75 08             	mov    0x8(%ebp),%esi
  802dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802e01:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802e03:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802e08:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802e0b:	89 04 24             	mov    %eax,(%esp)
  802e0e:	e8 08 e9 ff ff       	call   80171b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802e13:	85 c0                	test   %eax,%eax
  802e15:	75 26                	jne    802e3d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802e17:	85 f6                	test   %esi,%esi
  802e19:	74 0a                	je     802e25 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802e1b:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802e20:	8b 40 74             	mov    0x74(%eax),%eax
  802e23:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802e25:	85 db                	test   %ebx,%ebx
  802e27:	74 0a                	je     802e33 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802e29:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802e2e:	8b 40 78             	mov    0x78(%eax),%eax
  802e31:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802e33:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802e38:	8b 40 70             	mov    0x70(%eax),%eax
  802e3b:	eb 14                	jmp    802e51 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802e3d:	85 f6                	test   %esi,%esi
  802e3f:	74 06                	je     802e47 <ipc_recv+0x57>
			*from_env_store = 0;
  802e41:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802e47:	85 db                	test   %ebx,%ebx
  802e49:	74 06                	je     802e51 <ipc_recv+0x61>
			*perm_store = 0;
  802e4b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802e51:	83 c4 10             	add    $0x10,%esp
  802e54:	5b                   	pop    %ebx
  802e55:	5e                   	pop    %esi
  802e56:	5d                   	pop    %ebp
  802e57:	c3                   	ret    

00802e58 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802e58:	55                   	push   %ebp
  802e59:	89 e5                	mov    %esp,%ebp
  802e5b:	57                   	push   %edi
  802e5c:	56                   	push   %esi
  802e5d:	53                   	push   %ebx
  802e5e:	83 ec 1c             	sub    $0x1c,%esp
  802e61:	8b 7d 08             	mov    0x8(%ebp),%edi
  802e64:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e67:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802e6a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802e6c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802e71:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802e74:	8b 45 14             	mov    0x14(%ebp),%eax
  802e77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e7f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e83:	89 3c 24             	mov    %edi,(%esp)
  802e86:	e8 6d e8 ff ff       	call   8016f8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 28                	je     802eb7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802e8f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802e92:	74 1c                	je     802eb0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802e94:	c7 44 24 08 00 39 80 	movl   $0x803900,0x8(%esp)
  802e9b:	00 
  802e9c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802ea3:	00 
  802ea4:	c7 04 24 24 39 80 00 	movl   $0x803924,(%esp)
  802eab:	e8 4e da ff ff       	call   8008fe <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802eb0:	e8 11 e6 ff ff       	call   8014c6 <sys_yield>
	}
  802eb5:	eb bd                	jmp    802e74 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802eb7:	83 c4 1c             	add    $0x1c,%esp
  802eba:	5b                   	pop    %ebx
  802ebb:	5e                   	pop    %esi
  802ebc:	5f                   	pop    %edi
  802ebd:	5d                   	pop    %ebp
  802ebe:	c3                   	ret    

00802ebf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ebf:	55                   	push   %ebp
  802ec0:	89 e5                	mov    %esp,%ebp
  802ec2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ec5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802eca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802ecd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ed3:	8b 52 50             	mov    0x50(%edx),%edx
  802ed6:	39 ca                	cmp    %ecx,%edx
  802ed8:	75 0d                	jne    802ee7 <ipc_find_env+0x28>
			return envs[i].env_id;
  802eda:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802edd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802ee2:	8b 40 40             	mov    0x40(%eax),%eax
  802ee5:	eb 0e                	jmp    802ef5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802ee7:	83 c0 01             	add    $0x1,%eax
  802eea:	3d 00 04 00 00       	cmp    $0x400,%eax
  802eef:	75 d9                	jne    802eca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802ef1:	66 b8 00 00          	mov    $0x0,%ax
}
  802ef5:	5d                   	pop    %ebp
  802ef6:	c3                   	ret    

00802ef7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ef7:	55                   	push   %ebp
  802ef8:	89 e5                	mov    %esp,%ebp
  802efa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802efd:	89 d0                	mov    %edx,%eax
  802eff:	c1 e8 16             	shr    $0x16,%eax
  802f02:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802f09:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802f0e:	f6 c1 01             	test   $0x1,%cl
  802f11:	74 1d                	je     802f30 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802f13:	c1 ea 0c             	shr    $0xc,%edx
  802f16:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802f1d:	f6 c2 01             	test   $0x1,%dl
  802f20:	74 0e                	je     802f30 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802f22:	c1 ea 0c             	shr    $0xc,%edx
  802f25:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802f2c:	ef 
  802f2d:	0f b7 c0             	movzwl %ax,%eax
}
  802f30:	5d                   	pop    %ebp
  802f31:	c3                   	ret    
  802f32:	66 90                	xchg   %ax,%ax
  802f34:	66 90                	xchg   %ax,%ax
  802f36:	66 90                	xchg   %ax,%ax
  802f38:	66 90                	xchg   %ax,%ax
  802f3a:	66 90                	xchg   %ax,%ax
  802f3c:	66 90                	xchg   %ax,%ax
  802f3e:	66 90                	xchg   %ax,%ax

00802f40 <__udivdi3>:
  802f40:	55                   	push   %ebp
  802f41:	57                   	push   %edi
  802f42:	56                   	push   %esi
  802f43:	83 ec 0c             	sub    $0xc,%esp
  802f46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802f4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802f4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802f52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802f56:	85 c0                	test   %eax,%eax
  802f58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802f5c:	89 ea                	mov    %ebp,%edx
  802f5e:	89 0c 24             	mov    %ecx,(%esp)
  802f61:	75 2d                	jne    802f90 <__udivdi3+0x50>
  802f63:	39 e9                	cmp    %ebp,%ecx
  802f65:	77 61                	ja     802fc8 <__udivdi3+0x88>
  802f67:	85 c9                	test   %ecx,%ecx
  802f69:	89 ce                	mov    %ecx,%esi
  802f6b:	75 0b                	jne    802f78 <__udivdi3+0x38>
  802f6d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f72:	31 d2                	xor    %edx,%edx
  802f74:	f7 f1                	div    %ecx
  802f76:	89 c6                	mov    %eax,%esi
  802f78:	31 d2                	xor    %edx,%edx
  802f7a:	89 e8                	mov    %ebp,%eax
  802f7c:	f7 f6                	div    %esi
  802f7e:	89 c5                	mov    %eax,%ebp
  802f80:	89 f8                	mov    %edi,%eax
  802f82:	f7 f6                	div    %esi
  802f84:	89 ea                	mov    %ebp,%edx
  802f86:	83 c4 0c             	add    $0xc,%esp
  802f89:	5e                   	pop    %esi
  802f8a:	5f                   	pop    %edi
  802f8b:	5d                   	pop    %ebp
  802f8c:	c3                   	ret    
  802f8d:	8d 76 00             	lea    0x0(%esi),%esi
  802f90:	39 e8                	cmp    %ebp,%eax
  802f92:	77 24                	ja     802fb8 <__udivdi3+0x78>
  802f94:	0f bd e8             	bsr    %eax,%ebp
  802f97:	83 f5 1f             	xor    $0x1f,%ebp
  802f9a:	75 3c                	jne    802fd8 <__udivdi3+0x98>
  802f9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802fa0:	39 34 24             	cmp    %esi,(%esp)
  802fa3:	0f 86 9f 00 00 00    	jbe    803048 <__udivdi3+0x108>
  802fa9:	39 d0                	cmp    %edx,%eax
  802fab:	0f 82 97 00 00 00    	jb     803048 <__udivdi3+0x108>
  802fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fb8:	31 d2                	xor    %edx,%edx
  802fba:	31 c0                	xor    %eax,%eax
  802fbc:	83 c4 0c             	add    $0xc,%esp
  802fbf:	5e                   	pop    %esi
  802fc0:	5f                   	pop    %edi
  802fc1:	5d                   	pop    %ebp
  802fc2:	c3                   	ret    
  802fc3:	90                   	nop
  802fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fc8:	89 f8                	mov    %edi,%eax
  802fca:	f7 f1                	div    %ecx
  802fcc:	31 d2                	xor    %edx,%edx
  802fce:	83 c4 0c             	add    $0xc,%esp
  802fd1:	5e                   	pop    %esi
  802fd2:	5f                   	pop    %edi
  802fd3:	5d                   	pop    %ebp
  802fd4:	c3                   	ret    
  802fd5:	8d 76 00             	lea    0x0(%esi),%esi
  802fd8:	89 e9                	mov    %ebp,%ecx
  802fda:	8b 3c 24             	mov    (%esp),%edi
  802fdd:	d3 e0                	shl    %cl,%eax
  802fdf:	89 c6                	mov    %eax,%esi
  802fe1:	b8 20 00 00 00       	mov    $0x20,%eax
  802fe6:	29 e8                	sub    %ebp,%eax
  802fe8:	89 c1                	mov    %eax,%ecx
  802fea:	d3 ef                	shr    %cl,%edi
  802fec:	89 e9                	mov    %ebp,%ecx
  802fee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ff2:	8b 3c 24             	mov    (%esp),%edi
  802ff5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ff9:	89 d6                	mov    %edx,%esi
  802ffb:	d3 e7                	shl    %cl,%edi
  802ffd:	89 c1                	mov    %eax,%ecx
  802fff:	89 3c 24             	mov    %edi,(%esp)
  803002:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803006:	d3 ee                	shr    %cl,%esi
  803008:	89 e9                	mov    %ebp,%ecx
  80300a:	d3 e2                	shl    %cl,%edx
  80300c:	89 c1                	mov    %eax,%ecx
  80300e:	d3 ef                	shr    %cl,%edi
  803010:	09 d7                	or     %edx,%edi
  803012:	89 f2                	mov    %esi,%edx
  803014:	89 f8                	mov    %edi,%eax
  803016:	f7 74 24 08          	divl   0x8(%esp)
  80301a:	89 d6                	mov    %edx,%esi
  80301c:	89 c7                	mov    %eax,%edi
  80301e:	f7 24 24             	mull   (%esp)
  803021:	39 d6                	cmp    %edx,%esi
  803023:	89 14 24             	mov    %edx,(%esp)
  803026:	72 30                	jb     803058 <__udivdi3+0x118>
  803028:	8b 54 24 04          	mov    0x4(%esp),%edx
  80302c:	89 e9                	mov    %ebp,%ecx
  80302e:	d3 e2                	shl    %cl,%edx
  803030:	39 c2                	cmp    %eax,%edx
  803032:	73 05                	jae    803039 <__udivdi3+0xf9>
  803034:	3b 34 24             	cmp    (%esp),%esi
  803037:	74 1f                	je     803058 <__udivdi3+0x118>
  803039:	89 f8                	mov    %edi,%eax
  80303b:	31 d2                	xor    %edx,%edx
  80303d:	e9 7a ff ff ff       	jmp    802fbc <__udivdi3+0x7c>
  803042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803048:	31 d2                	xor    %edx,%edx
  80304a:	b8 01 00 00 00       	mov    $0x1,%eax
  80304f:	e9 68 ff ff ff       	jmp    802fbc <__udivdi3+0x7c>
  803054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803058:	8d 47 ff             	lea    -0x1(%edi),%eax
  80305b:	31 d2                	xor    %edx,%edx
  80305d:	83 c4 0c             	add    $0xc,%esp
  803060:	5e                   	pop    %esi
  803061:	5f                   	pop    %edi
  803062:	5d                   	pop    %ebp
  803063:	c3                   	ret    
  803064:	66 90                	xchg   %ax,%ax
  803066:	66 90                	xchg   %ax,%ax
  803068:	66 90                	xchg   %ax,%ax
  80306a:	66 90                	xchg   %ax,%ax
  80306c:	66 90                	xchg   %ax,%ax
  80306e:	66 90                	xchg   %ax,%ax

00803070 <__umoddi3>:
  803070:	55                   	push   %ebp
  803071:	57                   	push   %edi
  803072:	56                   	push   %esi
  803073:	83 ec 14             	sub    $0x14,%esp
  803076:	8b 44 24 28          	mov    0x28(%esp),%eax
  80307a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80307e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803082:	89 c7                	mov    %eax,%edi
  803084:	89 44 24 04          	mov    %eax,0x4(%esp)
  803088:	8b 44 24 30          	mov    0x30(%esp),%eax
  80308c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803090:	89 34 24             	mov    %esi,(%esp)
  803093:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803097:	85 c0                	test   %eax,%eax
  803099:	89 c2                	mov    %eax,%edx
  80309b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80309f:	75 17                	jne    8030b8 <__umoddi3+0x48>
  8030a1:	39 fe                	cmp    %edi,%esi
  8030a3:	76 4b                	jbe    8030f0 <__umoddi3+0x80>
  8030a5:	89 c8                	mov    %ecx,%eax
  8030a7:	89 fa                	mov    %edi,%edx
  8030a9:	f7 f6                	div    %esi
  8030ab:	89 d0                	mov    %edx,%eax
  8030ad:	31 d2                	xor    %edx,%edx
  8030af:	83 c4 14             	add    $0x14,%esp
  8030b2:	5e                   	pop    %esi
  8030b3:	5f                   	pop    %edi
  8030b4:	5d                   	pop    %ebp
  8030b5:	c3                   	ret    
  8030b6:	66 90                	xchg   %ax,%ax
  8030b8:	39 f8                	cmp    %edi,%eax
  8030ba:	77 54                	ja     803110 <__umoddi3+0xa0>
  8030bc:	0f bd e8             	bsr    %eax,%ebp
  8030bf:	83 f5 1f             	xor    $0x1f,%ebp
  8030c2:	75 5c                	jne    803120 <__umoddi3+0xb0>
  8030c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8030c8:	39 3c 24             	cmp    %edi,(%esp)
  8030cb:	0f 87 e7 00 00 00    	ja     8031b8 <__umoddi3+0x148>
  8030d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8030d5:	29 f1                	sub    %esi,%ecx
  8030d7:	19 c7                	sbb    %eax,%edi
  8030d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8030e9:	83 c4 14             	add    $0x14,%esp
  8030ec:	5e                   	pop    %esi
  8030ed:	5f                   	pop    %edi
  8030ee:	5d                   	pop    %ebp
  8030ef:	c3                   	ret    
  8030f0:	85 f6                	test   %esi,%esi
  8030f2:	89 f5                	mov    %esi,%ebp
  8030f4:	75 0b                	jne    803101 <__umoddi3+0x91>
  8030f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030fb:	31 d2                	xor    %edx,%edx
  8030fd:	f7 f6                	div    %esi
  8030ff:	89 c5                	mov    %eax,%ebp
  803101:	8b 44 24 04          	mov    0x4(%esp),%eax
  803105:	31 d2                	xor    %edx,%edx
  803107:	f7 f5                	div    %ebp
  803109:	89 c8                	mov    %ecx,%eax
  80310b:	f7 f5                	div    %ebp
  80310d:	eb 9c                	jmp    8030ab <__umoddi3+0x3b>
  80310f:	90                   	nop
  803110:	89 c8                	mov    %ecx,%eax
  803112:	89 fa                	mov    %edi,%edx
  803114:	83 c4 14             	add    $0x14,%esp
  803117:	5e                   	pop    %esi
  803118:	5f                   	pop    %edi
  803119:	5d                   	pop    %ebp
  80311a:	c3                   	ret    
  80311b:	90                   	nop
  80311c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803120:	8b 04 24             	mov    (%esp),%eax
  803123:	be 20 00 00 00       	mov    $0x20,%esi
  803128:	89 e9                	mov    %ebp,%ecx
  80312a:	29 ee                	sub    %ebp,%esi
  80312c:	d3 e2                	shl    %cl,%edx
  80312e:	89 f1                	mov    %esi,%ecx
  803130:	d3 e8                	shr    %cl,%eax
  803132:	89 e9                	mov    %ebp,%ecx
  803134:	89 44 24 04          	mov    %eax,0x4(%esp)
  803138:	8b 04 24             	mov    (%esp),%eax
  80313b:	09 54 24 04          	or     %edx,0x4(%esp)
  80313f:	89 fa                	mov    %edi,%edx
  803141:	d3 e0                	shl    %cl,%eax
  803143:	89 f1                	mov    %esi,%ecx
  803145:	89 44 24 08          	mov    %eax,0x8(%esp)
  803149:	8b 44 24 10          	mov    0x10(%esp),%eax
  80314d:	d3 ea                	shr    %cl,%edx
  80314f:	89 e9                	mov    %ebp,%ecx
  803151:	d3 e7                	shl    %cl,%edi
  803153:	89 f1                	mov    %esi,%ecx
  803155:	d3 e8                	shr    %cl,%eax
  803157:	89 e9                	mov    %ebp,%ecx
  803159:	09 f8                	or     %edi,%eax
  80315b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80315f:	f7 74 24 04          	divl   0x4(%esp)
  803163:	d3 e7                	shl    %cl,%edi
  803165:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803169:	89 d7                	mov    %edx,%edi
  80316b:	f7 64 24 08          	mull   0x8(%esp)
  80316f:	39 d7                	cmp    %edx,%edi
  803171:	89 c1                	mov    %eax,%ecx
  803173:	89 14 24             	mov    %edx,(%esp)
  803176:	72 2c                	jb     8031a4 <__umoddi3+0x134>
  803178:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80317c:	72 22                	jb     8031a0 <__umoddi3+0x130>
  80317e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803182:	29 c8                	sub    %ecx,%eax
  803184:	19 d7                	sbb    %edx,%edi
  803186:	89 e9                	mov    %ebp,%ecx
  803188:	89 fa                	mov    %edi,%edx
  80318a:	d3 e8                	shr    %cl,%eax
  80318c:	89 f1                	mov    %esi,%ecx
  80318e:	d3 e2                	shl    %cl,%edx
  803190:	89 e9                	mov    %ebp,%ecx
  803192:	d3 ef                	shr    %cl,%edi
  803194:	09 d0                	or     %edx,%eax
  803196:	89 fa                	mov    %edi,%edx
  803198:	83 c4 14             	add    $0x14,%esp
  80319b:	5e                   	pop    %esi
  80319c:	5f                   	pop    %edi
  80319d:	5d                   	pop    %ebp
  80319e:	c3                   	ret    
  80319f:	90                   	nop
  8031a0:	39 d7                	cmp    %edx,%edi
  8031a2:	75 da                	jne    80317e <__umoddi3+0x10e>
  8031a4:	8b 14 24             	mov    (%esp),%edx
  8031a7:	89 c1                	mov    %eax,%ecx
  8031a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8031ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8031b1:	eb cb                	jmp    80317e <__umoddi3+0x10e>
  8031b3:	90                   	nop
  8031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8031b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8031bc:	0f 82 0f ff ff ff    	jb     8030d1 <__umoddi3+0x61>
  8031c2:	e9 1a ff ff ff       	jmp    8030e1 <__umoddi3+0x71>
