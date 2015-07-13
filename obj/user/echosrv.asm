
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 fc 04 00 00       	call   80052d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003d:	c7 04 24 d5 30 80 00 	movl   $0x8030d5,(%esp)
  800044:	e8 e8 05 00 00       	call   800631 <cprintf>
	exit();
  800049:	e8 27 05 00 00       	call   800575 <exit>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <handle_client>:

void
handle_client(int sock)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	57                   	push   %edi
  800054:	56                   	push   %esi
  800055:	53                   	push   %ebx
  800056:	83 ec 3c             	sub    $0x3c,%esp
  800059:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  800063:	00 
  800064:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800067:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006b:	89 34 24             	mov    %esi,(%esp)
  80006e:	e8 b7 16 00 00       	call   80172a <read>
  800073:	89 c3                	mov    %eax,%ebx
  800075:	85 c0                	test   %eax,%eax
  800077:	78 05                	js     80007e <handle_client+0x2e>
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  800079:	8d 7d c8             	lea    -0x38(%ebp),%edi
  80007c:	eb 4e                	jmp    8000cc <handle_client+0x7c>
{
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");
  80007e:	b8 14 2c 80 00       	mov    $0x802c14,%eax
  800083:	e8 ab ff ff ff       	call   800033 <die>
  800088:	eb ef                	jmp    800079 <handle_client+0x29>

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80008a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80008e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800092:	89 34 24             	mov    %esi,(%esp)
  800095:	e8 6d 17 00 00       	call   801807 <write>
  80009a:	39 d8                	cmp    %ebx,%eax
  80009c:	74 0a                	je     8000a8 <handle_client+0x58>
			die("Failed to send bytes to client");
  80009e:	b8 40 2c 80 00       	mov    $0x802c40,%eax
  8000a3:	e8 8b ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000a8:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  8000af:	00 
  8000b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000b4:	89 34 24             	mov    %esi,(%esp)
  8000b7:	e8 6e 16 00 00       	call   80172a <read>
  8000bc:	89 c3                	mov    %eax,%ebx
  8000be:	85 c0                	test   %eax,%eax
  8000c0:	79 0a                	jns    8000cc <handle_client+0x7c>
			die("Failed to receive additional bytes from client");
  8000c2:	b8 60 2c 80 00       	mov    $0x802c60,%eax
  8000c7:	e8 67 ff ff ff       	call   800033 <die>
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cc:	85 db                	test   %ebx,%ebx
  8000ce:	7f ba                	jg     80008a <handle_client+0x3a>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 ef 14 00 00       	call   8015c7 <close>
}
  8000d8:	83 c4 3c             	add    $0x3c,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5f                   	pop    %edi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <umain>:

void
umain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 4c             	sub    $0x4c,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000e9:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8000f0:	00 
  8000f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000f8:	00 
  8000f9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800100:	e8 62 1e 00 00       	call   801f67 <socket>
  800105:	89 c6                	mov    %eax,%esi
  800107:	85 c0                	test   %eax,%eax
  800109:	79 0a                	jns    800115 <umain+0x35>
		die("Failed to create socket");
  80010b:	b8 c0 2b 80 00       	mov    $0x802bc0,%eax
  800110:	e8 1e ff ff ff       	call   800033 <die>

	cprintf("opened socket\n");
  800115:	c7 04 24 d8 2b 80 00 	movl   $0x802bd8,(%esp)
  80011c:	e8 10 05 00 00       	call   800631 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800121:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800128:	00 
  800129:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800130:	00 
  800131:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800134:	89 1c 24             	mov    %ebx,(%esp)
  800137:	e8 bb 0c 00 00       	call   800df7 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80013c:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800147:	e8 94 01 00 00       	call   8002e0 <htonl>
  80014c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  80014f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800156:	e8 6b 01 00 00       	call   8002c6 <htons>
  80015b:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  80015f:	c7 04 24 e7 2b 80 00 	movl   $0x802be7,(%esp)
  800166:	e8 c6 04 00 00       	call   800631 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80016b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800172:	00 
  800173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800177:	89 34 24             	mov    %esi,(%esp)
  80017a:	e8 46 1d 00 00       	call   801ec5 <bind>
  80017f:	85 c0                	test   %eax,%eax
  800181:	79 0a                	jns    80018d <umain+0xad>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800183:	b8 90 2c 80 00       	mov    $0x802c90,%eax
  800188:	e8 a6 fe ff ff       	call   800033 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80018d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  800194:	00 
  800195:	89 34 24             	mov    %esi,(%esp)
  800198:	e8 a5 1d 00 00       	call   801f42 <listen>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	79 0a                	jns    8001ab <umain+0xcb>
		die("Failed to listen on server socket");
  8001a1:	b8 b4 2c 80 00       	mov    $0x802cb4,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>

	cprintf("bound\n");
  8001ab:	c7 04 24 f7 2b 80 00 	movl   $0x802bf7,(%esp)
  8001b2:	e8 7a 04 00 00       	call   800631 <cprintf>

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  8001b7:	8d 7d c4             	lea    -0x3c(%ebp),%edi

	cprintf("bound\n");

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8001ba:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock =
  8001c1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001c5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cc:	89 34 24             	mov    %esi,(%esp)
  8001cf:	e8 b6 1c 00 00       	call   801e8a <accept>
  8001d4:	89 c3                	mov    %eax,%ebx
  8001d6:	85 c0                	test   %eax,%eax
  8001d8:	79 0a                	jns    8001e4 <umain+0x104>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001da:	b8 d8 2c 80 00       	mov    $0x802cd8,%eax
  8001df:	e8 4f fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e7:	89 04 24             	mov    %eax,(%esp)
  8001ea:	e8 21 00 00 00       	call   800210 <inet_ntoa>
  8001ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f3:	c7 04 24 fe 2b 80 00 	movl   $0x802bfe,(%esp)
  8001fa:	e8 32 04 00 00       	call   800631 <cprintf>
		handle_client(clientsock);
  8001ff:	89 1c 24             	mov    %ebx,(%esp)
  800202:	e8 49 fe ff ff       	call   800050 <handle_client>
	}
  800207:	eb b1                	jmp    8001ba <umain+0xda>
  800209:	66 90                	xchg   %ax,%ax
  80020b:	66 90                	xchg   %ax,%ax
  80020d:	66 90                	xchg   %ax,%ax
  80020f:	90                   	nop

00800210 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80021f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800223:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800226:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80022d:	be 00 00 00 00       	mov    $0x0,%esi
  800232:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800235:	eb 02                	jmp    800239 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800237:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800239:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80023c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80023f:	0f b6 c2             	movzbl %dl,%eax
  800242:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800245:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800248:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80024b:	66 c1 e8 0b          	shr    $0xb,%ax
  80024f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800251:	8d 4e 01             	lea    0x1(%esi),%ecx
  800254:	89 f3                	mov    %esi,%ebx
  800256:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800259:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80025c:	01 ff                	add    %edi,%edi
  80025e:	89 fb                	mov    %edi,%ebx
  800260:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800262:	83 c2 30             	add    $0x30,%edx
  800265:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800269:	84 c0                	test   %al,%al
  80026b:	75 ca                	jne    800237 <inet_ntoa+0x27>
  80026d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800270:	89 c8                	mov    %ecx,%eax
  800272:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800275:	89 cf                	mov    %ecx,%edi
  800277:	eb 0d                	jmp    800286 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800279:	0f b6 f0             	movzbl %al,%esi
  80027c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800281:	88 0a                	mov    %cl,(%edx)
  800283:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800286:	83 e8 01             	sub    $0x1,%eax
  800289:	3c ff                	cmp    $0xff,%al
  80028b:	75 ec                	jne    800279 <inet_ntoa+0x69>
  80028d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800290:	89 f9                	mov    %edi,%ecx
  800292:	0f b6 c9             	movzbl %cl,%ecx
  800295:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800298:	8d 41 01             	lea    0x1(%ecx),%eax
  80029b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80029e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8002a2:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  8002a6:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  8002aa:	77 0a                	ja     8002b6 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8002ac:	c6 01 2e             	movb   $0x2e,(%ecx)
  8002af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b4:	eb 81                	jmp    800237 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  8002b6:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  8002b9:	b8 00 50 80 00       	mov    $0x805000,%eax
  8002be:	83 c4 19             	add    $0x19,%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002c9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002cd:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002d6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002da:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002e6:	89 d1                	mov    %edx,%ecx
  8002e8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	c1 e0 18             	shl    $0x18,%eax
  8002f0:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002f2:	89 d1                	mov    %edx,%ecx
  8002f4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8002fa:	c1 e1 08             	shl    $0x8,%ecx
  8002fd:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  8002ff:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800305:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800308:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	57                   	push   %edi
  800310:	56                   	push   %esi
  800311:	53                   	push   %ebx
  800312:	83 ec 20             	sub    $0x20,%esp
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800318:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80031b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80031e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800321:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800324:	80 f9 09             	cmp    $0x9,%cl
  800327:	0f 87 a6 01 00 00    	ja     8004d3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80032d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800334:	83 fa 30             	cmp    $0x30,%edx
  800337:	75 2b                	jne    800364 <inet_aton+0x58>
      c = *++cp;
  800339:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80033d:	89 d1                	mov    %edx,%ecx
  80033f:	83 e1 df             	and    $0xffffffdf,%ecx
  800342:	80 f9 58             	cmp    $0x58,%cl
  800345:	74 0f                	je     800356 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800347:	83 c0 01             	add    $0x1,%eax
  80034a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80034d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800354:	eb 0e                	jmp    800364 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800356:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80035a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80035d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800364:	83 c0 01             	add    $0x1,%eax
  800367:	bf 00 00 00 00       	mov    $0x0,%edi
  80036c:	eb 03                	jmp    800371 <inet_aton+0x65>
  80036e:	83 c0 01             	add    $0x1,%eax
  800371:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800374:	89 d3                	mov    %edx,%ebx
  800376:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800379:	80 f9 09             	cmp    $0x9,%cl
  80037c:	77 0d                	ja     80038b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80037e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800382:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800386:	0f be 10             	movsbl (%eax),%edx
  800389:	eb e3                	jmp    80036e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80038b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80038f:	75 30                	jne    8003c1 <inet_aton+0xb5>
  800391:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800394:	88 4d df             	mov    %cl,-0x21(%ebp)
  800397:	89 d1                	mov    %edx,%ecx
  800399:	83 e1 df             	and    $0xffffffdf,%ecx
  80039c:	83 e9 41             	sub    $0x41,%ecx
  80039f:	80 f9 05             	cmp    $0x5,%cl
  8003a2:	77 23                	ja     8003c7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003a4:	89 fb                	mov    %edi,%ebx
  8003a6:	c1 e3 04             	shl    $0x4,%ebx
  8003a9:	8d 7a 0a             	lea    0xa(%edx),%edi
  8003ac:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  8003b0:	19 c9                	sbb    %ecx,%ecx
  8003b2:	83 e1 20             	and    $0x20,%ecx
  8003b5:	83 c1 41             	add    $0x41,%ecx
  8003b8:	29 cf                	sub    %ecx,%edi
  8003ba:	09 df                	or     %ebx,%edi
        c = *++cp;
  8003bc:	0f be 10             	movsbl (%eax),%edx
  8003bf:	eb ad                	jmp    80036e <inet_aton+0x62>
  8003c1:	89 d0                	mov    %edx,%eax
  8003c3:	89 f9                	mov    %edi,%ecx
  8003c5:	eb 04                	jmp    8003cb <inet_aton+0xbf>
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8003cb:	83 f8 2e             	cmp    $0x2e,%eax
  8003ce:	75 22                	jne    8003f2 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8003d3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8003d6:	0f 84 fe 00 00 00    	je     8004da <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8003dc:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8003e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8003e6:	8d 46 01             	lea    0x1(%esi),%eax
  8003e9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8003ed:	e9 2f ff ff ff       	jmp    800321 <inet_aton+0x15>
  8003f2:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 27                	je     80041f <inet_aton+0x113>
    return (0);
  8003f8:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003fd:	80 fb 1f             	cmp    $0x1f,%bl
  800400:	0f 86 e7 00 00 00    	jbe    8004ed <inet_aton+0x1e1>
  800406:	84 d2                	test   %dl,%dl
  800408:	0f 88 d3 00 00 00    	js     8004e1 <inet_aton+0x1d5>
  80040e:	83 fa 20             	cmp    $0x20,%edx
  800411:	74 0c                	je     80041f <inet_aton+0x113>
  800413:	83 ea 09             	sub    $0x9,%edx
  800416:	83 fa 04             	cmp    $0x4,%edx
  800419:	0f 87 ce 00 00 00    	ja     8004ed <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80041f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800422:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800425:	29 c2                	sub    %eax,%edx
  800427:	c1 fa 02             	sar    $0x2,%edx
  80042a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80042d:	83 fa 02             	cmp    $0x2,%edx
  800430:	74 22                	je     800454 <inet_aton+0x148>
  800432:	83 fa 02             	cmp    $0x2,%edx
  800435:	7f 0f                	jg     800446 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80043c:	85 d2                	test   %edx,%edx
  80043e:	0f 84 a9 00 00 00    	je     8004ed <inet_aton+0x1e1>
  800444:	eb 73                	jmp    8004b9 <inet_aton+0x1ad>
  800446:	83 fa 03             	cmp    $0x3,%edx
  800449:	74 26                	je     800471 <inet_aton+0x165>
  80044b:	83 fa 04             	cmp    $0x4,%edx
  80044e:	66 90                	xchg   %ax,%ax
  800450:	74 40                	je     800492 <inet_aton+0x186>
  800452:	eb 65                	jmp    8004b9 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800454:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800459:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80045f:	0f 87 88 00 00 00    	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800468:	c1 e0 18             	shl    $0x18,%eax
  80046b:	89 cf                	mov    %ecx,%edi
  80046d:	09 c7                	or     %eax,%edi
    break;
  80046f:	eb 48                	jmp    8004b9 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800476:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80047c:	77 6f                	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80047e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800481:	c1 e2 10             	shl    $0x10,%edx
  800484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800487:	c1 e0 18             	shl    $0x18,%eax
  80048a:	09 d0                	or     %edx,%eax
  80048c:	09 c8                	or     %ecx,%eax
  80048e:	89 c7                	mov    %eax,%edi
    break;
  800490:	eb 27                	jmp    8004b9 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800497:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80049d:	77 4e                	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80049f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a2:	c1 e2 10             	shl    $0x10,%edx
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	c1 e0 18             	shl    $0x18,%eax
  8004ab:	09 c2                	or     %eax,%edx
  8004ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004b0:	c1 e0 08             	shl    $0x8,%eax
  8004b3:	09 d0                	or     %edx,%eax
  8004b5:	09 c8                	or     %ecx,%eax
  8004b7:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  8004b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004bd:	74 29                	je     8004e8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  8004bf:	89 3c 24             	mov    %edi,(%esp)
  8004c2:	e8 19 fe ff ff       	call   8002e0 <htonl>
  8004c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ca:	89 06                	mov    %eax,(%esi)
  return (1);
  8004cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8004d1:	eb 1a                	jmp    8004ed <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8004d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d8:	eb 13                	jmp    8004ed <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8004da:	b8 00 00 00 00       	mov    $0x0,%eax
  8004df:	eb 0c                	jmp    8004ed <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	eb 05                	jmp    8004ed <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8004e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004ed:	83 c4 20             	add    $0x20,%esp
  8004f0:	5b                   	pop    %ebx
  8004f1:	5e                   	pop    %esi
  8004f2:	5f                   	pop    %edi
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	e8 ff fd ff ff       	call   80030c <inet_aton>
  80050d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80050f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800514:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 04 24             	mov    %eax,(%esp)
  800526:	e8 b5 fd ff ff       	call   8002e0 <htonl>
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
  800532:	83 ec 10             	sub    $0x10,%esp
  800535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800538:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80053b:	e8 97 0b 00 00       	call   8010d7 <sys_getenvid>
  800540:	25 ff 03 00 00       	and    $0x3ff,%eax
  800545:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800548:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80054d:	a3 18 50 80 00       	mov    %eax,0x805018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800552:	85 db                	test   %ebx,%ebx
  800554:	7e 07                	jle    80055d <libmain+0x30>
		binaryname = argv[0];
  800556:	8b 06                	mov    (%esi),%eax
  800558:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80055d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800561:	89 1c 24             	mov    %ebx,(%esp)
  800564:	e8 77 fb ff ff       	call   8000e0 <umain>

	// exit gracefully
	exit();
  800569:	e8 07 00 00 00       	call   800575 <exit>
}
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	5b                   	pop    %ebx
  800572:	5e                   	pop    %esi
  800573:	5d                   	pop    %ebp
  800574:	c3                   	ret    

00800575 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80057b:	e8 7a 10 00 00       	call   8015fa <close_all>
	sys_env_destroy(0);
  800580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800587:	e8 a7 0a 00 00       	call   801033 <sys_env_destroy>
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	53                   	push   %ebx
  800592:	83 ec 14             	sub    $0x14,%esp
  800595:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800598:	8b 13                	mov    (%ebx),%edx
  80059a:	8d 42 01             	lea    0x1(%edx),%eax
  80059d:	89 03                	mov    %eax,(%ebx)
  80059f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ab:	75 19                	jne    8005c6 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8005ad:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8005b4:	00 
  8005b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8005b8:	89 04 24             	mov    %eax,(%esp)
  8005bb:	e8 36 0a 00 00       	call   800ff6 <sys_cputs>
		b->idx = 0;
  8005c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8005c6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005ca:	83 c4 14             	add    $0x14,%esp
  8005cd:	5b                   	pop    %ebx
  8005ce:	5d                   	pop    %ebp
  8005cf:	c3                   	ret    

008005d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e0:	00 00 00 
	b.cnt = 0;
  8005e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800601:	89 44 24 04          	mov    %eax,0x4(%esp)
  800605:	c7 04 24 8e 05 80 00 	movl   $0x80058e,(%esp)
  80060c:	e8 73 01 00 00       	call   800784 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800611:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800617:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800621:	89 04 24             	mov    %eax,(%esp)
  800624:	e8 cd 09 00 00       	call   800ff6 <sys_cputs>

	return b.cnt;
}
  800629:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80062f:	c9                   	leave  
  800630:	c3                   	ret    

00800631 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800637:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80063a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	89 04 24             	mov    %eax,(%esp)
  800644:	e8 87 ff ff ff       	call   8005d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    
  80064b:	66 90                	xchg   %ax,%ax
  80064d:	66 90                	xchg   %ax,%ax
  80064f:	90                   	nop

00800650 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	57                   	push   %edi
  800654:	56                   	push   %esi
  800655:	53                   	push   %ebx
  800656:	83 ec 3c             	sub    $0x3c,%esp
  800659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065c:	89 d7                	mov    %edx,%edi
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800664:	8b 45 0c             	mov    0xc(%ebp),%eax
  800667:	89 c3                	mov    %eax,%ebx
  800669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80066c:	8b 45 10             	mov    0x10(%ebp),%eax
  80066f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800672:	b9 00 00 00 00       	mov    $0x0,%ecx
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80067d:	39 d9                	cmp    %ebx,%ecx
  80067f:	72 05                	jb     800686 <printnum+0x36>
  800681:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800684:	77 69                	ja     8006ef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800686:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800689:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80068d:	83 ee 01             	sub    $0x1,%esi
  800690:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800694:	89 44 24 08          	mov    %eax,0x8(%esp)
  800698:	8b 44 24 08          	mov    0x8(%esp),%eax
  80069c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8006a0:	89 c3                	mov    %eax,%ebx
  8006a2:	89 d6                	mov    %edx,%esi
  8006a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8006ae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8006b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b5:	89 04 24             	mov    %eax,(%esp)
  8006b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006bf:	e8 5c 22 00 00       	call   802920 <__udivdi3>
  8006c4:	89 d9                	mov    %ebx,%ecx
  8006c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006ce:	89 04 24             	mov    %eax,(%esp)
  8006d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006d5:	89 fa                	mov    %edi,%edx
  8006d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006da:	e8 71 ff ff ff       	call   800650 <printnum>
  8006df:	eb 1b                	jmp    8006fc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e8:	89 04 24             	mov    %eax,(%esp)
  8006eb:	ff d3                	call   *%ebx
  8006ed:	eb 03                	jmp    8006f2 <printnum+0xa2>
  8006ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f2:	83 ee 01             	sub    $0x1,%esi
  8006f5:	85 f6                	test   %esi,%esi
  8006f7:	7f e8                	jg     8006e1 <printnum+0x91>
  8006f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800700:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800704:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800707:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80070a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80070e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800715:	89 04 24             	mov    %eax,(%esp)
  800718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80071b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071f:	e8 2c 23 00 00       	call   802a50 <__umoddi3>
  800724:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800728:	0f be 80 05 2d 80 00 	movsbl 0x802d05(%eax),%eax
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800735:	ff d0                	call   *%eax
}
  800737:	83 c4 3c             	add    $0x3c,%esp
  80073a:	5b                   	pop    %ebx
  80073b:	5e                   	pop    %esi
  80073c:	5f                   	pop    %edi
  80073d:	5d                   	pop    %ebp
  80073e:	c3                   	ret    

0080073f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800745:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800749:	8b 10                	mov    (%eax),%edx
  80074b:	3b 50 04             	cmp    0x4(%eax),%edx
  80074e:	73 0a                	jae    80075a <sprintputch+0x1b>
		*b->buf++ = ch;
  800750:	8d 4a 01             	lea    0x1(%edx),%ecx
  800753:	89 08                	mov    %ecx,(%eax)
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	88 02                	mov    %al,(%edx)
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800765:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800769:	8b 45 10             	mov    0x10(%ebp),%eax
  80076c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800770:	8b 45 0c             	mov    0xc(%ebp),%eax
  800773:	89 44 24 04          	mov    %eax,0x4(%esp)
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 04 24             	mov    %eax,(%esp)
  80077d:	e8 02 00 00 00       	call   800784 <vprintfmt>
	va_end(ap);
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	57                   	push   %edi
  800788:	56                   	push   %esi
  800789:	53                   	push   %ebx
  80078a:	83 ec 3c             	sub    $0x3c,%esp
  80078d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800790:	eb 17                	jmp    8007a9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800792:	85 c0                	test   %eax,%eax
  800794:	0f 84 4b 04 00 00    	je     800be5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80079a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80079d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007a1:	89 04 24             	mov    %eax,(%esp)
  8007a4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8007a7:	89 fb                	mov    %edi,%ebx
  8007a9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8007ac:	0f b6 03             	movzbl (%ebx),%eax
  8007af:	83 f8 25             	cmp    $0x25,%eax
  8007b2:	75 de                	jne    800792 <vprintfmt+0xe>
  8007b4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8007b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8007c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8007cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d0:	eb 18                	jmp    8007ea <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8007d8:	eb 10                	jmp    8007ea <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007da:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8007e0:	eb 08                	jmp    8007ea <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8007e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007e5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ea:	8d 5f 01             	lea    0x1(%edi),%ebx
  8007ed:	0f b6 17             	movzbl (%edi),%edx
  8007f0:	0f b6 c2             	movzbl %dl,%eax
  8007f3:	83 ea 23             	sub    $0x23,%edx
  8007f6:	80 fa 55             	cmp    $0x55,%dl
  8007f9:	0f 87 c2 03 00 00    	ja     800bc1 <vprintfmt+0x43d>
  8007ff:	0f b6 d2             	movzbl %dl,%edx
  800802:	ff 24 95 40 2e 80 00 	jmp    *0x802e40(,%edx,4)
  800809:	89 df                	mov    %ebx,%edi
  80080b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800810:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800813:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800817:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80081a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80081d:	83 fa 09             	cmp    $0x9,%edx
  800820:	77 33                	ja     800855 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800822:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800825:	eb e9                	jmp    800810 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8b 30                	mov    (%eax),%esi
  80082c:	8d 40 04             	lea    0x4(%eax),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800832:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800834:	eb 1f                	jmp    800855 <vprintfmt+0xd1>
  800836:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800839:	85 ff                	test   %edi,%edi
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
  800840:	0f 49 c7             	cmovns %edi,%eax
  800843:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800846:	89 df                	mov    %ebx,%edi
  800848:	eb a0                	jmp    8007ea <vprintfmt+0x66>
  80084a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80084c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800853:	eb 95                	jmp    8007ea <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800855:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800859:	79 8f                	jns    8007ea <vprintfmt+0x66>
  80085b:	eb 85                	jmp    8007e2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80085d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800860:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800862:	eb 86                	jmp    8007ea <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 70 04             	lea    0x4(%eax),%esi
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 04 24             	mov    %eax,(%esp)
  800879:	ff 55 08             	call   *0x8(%ebp)
  80087c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80087f:	e9 25 ff ff ff       	jmp    8007a9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8d 70 04             	lea    0x4(%eax),%esi
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	99                   	cltd   
  80088d:	31 d0                	xor    %edx,%eax
  80088f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800891:	83 f8 15             	cmp    $0x15,%eax
  800894:	7f 0b                	jg     8008a1 <vprintfmt+0x11d>
  800896:	8b 14 85 a0 2f 80 00 	mov    0x802fa0(,%eax,4),%edx
  80089d:	85 d2                	test   %edx,%edx
  80089f:	75 26                	jne    8008c7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8008a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a5:	c7 44 24 08 1d 2d 80 	movl   $0x802d1d,0x8(%esp)
  8008ac:	00 
  8008ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	89 04 24             	mov    %eax,(%esp)
  8008ba:	e8 9d fe ff ff       	call   80075c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008bf:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8008c2:	e9 e2 fe ff ff       	jmp    8007a9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8008c7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008cb:	c7 44 24 08 f2 30 80 	movl   $0x8030f2,0x8(%esp)
  8008d2:	00 
  8008d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 04 24             	mov    %eax,(%esp)
  8008e0:	e8 77 fe ff ff       	call   80075c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e5:	89 75 14             	mov    %esi,0x14(%ebp)
  8008e8:	e9 bc fe ff ff       	jmp    8007a9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008f3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008f6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8008fa:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8008fc:	85 ff                	test   %edi,%edi
  8008fe:	b8 16 2d 80 00       	mov    $0x802d16,%eax
  800903:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800906:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80090a:	0f 84 94 00 00 00    	je     8009a4 <vprintfmt+0x220>
  800910:	85 c9                	test   %ecx,%ecx
  800912:	0f 8e 94 00 00 00    	jle    8009ac <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800918:	89 74 24 04          	mov    %esi,0x4(%esp)
  80091c:	89 3c 24             	mov    %edi,(%esp)
  80091f:	e8 64 03 00 00       	call   800c88 <strnlen>
  800924:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800927:	29 c1                	sub    %eax,%ecx
  800929:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80092c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800930:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800933:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800936:	8b 75 08             	mov    0x8(%ebp),%esi
  800939:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80093c:	89 cb                	mov    %ecx,%ebx
  80093e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800940:	eb 0f                	jmp    800951 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800942:	8b 45 0c             	mov    0xc(%ebp),%eax
  800945:	89 44 24 04          	mov    %eax,0x4(%esp)
  800949:	89 3c 24             	mov    %edi,(%esp)
  80094c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80094e:	83 eb 01             	sub    $0x1,%ebx
  800951:	85 db                	test   %ebx,%ebx
  800953:	7f ed                	jg     800942 <vprintfmt+0x1be>
  800955:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800958:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80095b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80095e:	85 c9                	test   %ecx,%ecx
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
  800965:	0f 49 c1             	cmovns %ecx,%eax
  800968:	29 c1                	sub    %eax,%ecx
  80096a:	89 cb                	mov    %ecx,%ebx
  80096c:	eb 44                	jmp    8009b2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80096e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800972:	74 1e                	je     800992 <vprintfmt+0x20e>
  800974:	0f be d2             	movsbl %dl,%edx
  800977:	83 ea 20             	sub    $0x20,%edx
  80097a:	83 fa 5e             	cmp    $0x5e,%edx
  80097d:	76 13                	jbe    800992 <vprintfmt+0x20e>
					putch('?', putdat);
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	89 44 24 04          	mov    %eax,0x4(%esp)
  800986:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80098d:	ff 55 08             	call   *0x8(%ebp)
  800990:	eb 0d                	jmp    80099f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800992:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800995:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800999:	89 04 24             	mov    %eax,(%esp)
  80099c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80099f:	83 eb 01             	sub    $0x1,%ebx
  8009a2:	eb 0e                	jmp    8009b2 <vprintfmt+0x22e>
  8009a4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8009aa:	eb 06                	jmp    8009b2 <vprintfmt+0x22e>
  8009ac:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8009b2:	83 c7 01             	add    $0x1,%edi
  8009b5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8009b9:	0f be c2             	movsbl %dl,%eax
  8009bc:	85 c0                	test   %eax,%eax
  8009be:	74 27                	je     8009e7 <vprintfmt+0x263>
  8009c0:	85 f6                	test   %esi,%esi
  8009c2:	78 aa                	js     80096e <vprintfmt+0x1ea>
  8009c4:	83 ee 01             	sub    $0x1,%esi
  8009c7:	79 a5                	jns    80096e <vprintfmt+0x1ea>
  8009c9:	89 d8                	mov    %ebx,%eax
  8009cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8009d1:	89 c3                	mov    %eax,%ebx
  8009d3:	eb 18                	jmp    8009ed <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8009d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009d9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8009e0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e2:	83 eb 01             	sub    $0x1,%ebx
  8009e5:	eb 06                	jmp    8009ed <vprintfmt+0x269>
  8009e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ea:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8009ed:	85 db                	test   %ebx,%ebx
  8009ef:	7f e4                	jg     8009d5 <vprintfmt+0x251>
  8009f1:	89 75 08             	mov    %esi,0x8(%ebp)
  8009f4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8009fa:	e9 aa fd ff ff       	jmp    8007a9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8009ff:	83 f9 01             	cmp    $0x1,%ecx
  800a02:	7e 10                	jle    800a14 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	8b 30                	mov    (%eax),%esi
  800a09:	8b 78 04             	mov    0x4(%eax),%edi
  800a0c:	8d 40 08             	lea    0x8(%eax),%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	eb 26                	jmp    800a3a <vprintfmt+0x2b6>
	else if (lflag)
  800a14:	85 c9                	test   %ecx,%ecx
  800a16:	74 12                	je     800a2a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	8b 30                	mov    (%eax),%esi
  800a1d:	89 f7                	mov    %esi,%edi
  800a1f:	c1 ff 1f             	sar    $0x1f,%edi
  800a22:	8d 40 04             	lea    0x4(%eax),%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	eb 10                	jmp    800a3a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	8b 30                	mov    (%eax),%esi
  800a2f:	89 f7                	mov    %esi,%edi
  800a31:	c1 ff 1f             	sar    $0x1f,%edi
  800a34:	8d 40 04             	lea    0x4(%eax),%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a3a:	89 f0                	mov    %esi,%eax
  800a3c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800a3e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800a43:	85 ff                	test   %edi,%edi
  800a45:	0f 89 3a 01 00 00    	jns    800b85 <vprintfmt+0x401>
				putch('-', putdat);
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a52:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800a59:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800a5c:	89 f0                	mov    %esi,%eax
  800a5e:	89 fa                	mov    %edi,%edx
  800a60:	f7 d8                	neg    %eax
  800a62:	83 d2 00             	adc    $0x0,%edx
  800a65:	f7 da                	neg    %edx
			}
			base = 10;
  800a67:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800a6c:	e9 14 01 00 00       	jmp    800b85 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a71:	83 f9 01             	cmp    $0x1,%ecx
  800a74:	7e 13                	jle    800a89 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	8b 50 04             	mov    0x4(%eax),%edx
  800a7c:	8b 00                	mov    (%eax),%eax
  800a7e:	8b 75 14             	mov    0x14(%ebp),%esi
  800a81:	8d 4e 08             	lea    0x8(%esi),%ecx
  800a84:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800a87:	eb 2c                	jmp    800ab5 <vprintfmt+0x331>
	else if (lflag)
  800a89:	85 c9                	test   %ecx,%ecx
  800a8b:	74 15                	je     800aa2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	8b 00                	mov    (%eax),%eax
  800a92:	ba 00 00 00 00       	mov    $0x0,%edx
  800a97:	8b 75 14             	mov    0x14(%ebp),%esi
  800a9a:	8d 76 04             	lea    0x4(%esi),%esi
  800a9d:	89 75 14             	mov    %esi,0x14(%ebp)
  800aa0:	eb 13                	jmp    800ab5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	8b 75 14             	mov    0x14(%ebp),%esi
  800aaf:	8d 76 04             	lea    0x4(%esi),%esi
  800ab2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800ab5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800aba:	e9 c6 00 00 00       	jmp    800b85 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800abf:	83 f9 01             	cmp    $0x1,%ecx
  800ac2:	7e 13                	jle    800ad7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	8b 75 14             	mov    0x14(%ebp),%esi
  800acf:	8d 4e 08             	lea    0x8(%esi),%ecx
  800ad2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800ad5:	eb 24                	jmp    800afb <vprintfmt+0x377>
	else if (lflag)
  800ad7:	85 c9                	test   %ecx,%ecx
  800ad9:	74 11                	je     800aec <vprintfmt+0x368>
		return va_arg(*ap, long);
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	8b 00                	mov    (%eax),%eax
  800ae0:	99                   	cltd   
  800ae1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800ae4:	8d 71 04             	lea    0x4(%ecx),%esi
  800ae7:	89 75 14             	mov    %esi,0x14(%ebp)
  800aea:	eb 0f                	jmp    800afb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	99                   	cltd   
  800af2:	8b 75 14             	mov    0x14(%ebp),%esi
  800af5:	8d 76 04             	lea    0x4(%esi),%esi
  800af8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  800afb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800b00:	e9 80 00 00 00       	jmp    800b85 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b05:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b16:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b20:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b27:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b2a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2e:	8b 06                	mov    (%esi),%eax
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b35:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b3a:	eb 49                	jmp    800b85 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b3c:	83 f9 01             	cmp    $0x1,%ecx
  800b3f:	7e 13                	jle    800b54 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800b41:	8b 45 14             	mov    0x14(%ebp),%eax
  800b44:	8b 50 04             	mov    0x4(%eax),%edx
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	8b 75 14             	mov    0x14(%ebp),%esi
  800b4c:	8d 4e 08             	lea    0x8(%esi),%ecx
  800b4f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b52:	eb 2c                	jmp    800b80 <vprintfmt+0x3fc>
	else if (lflag)
  800b54:	85 c9                	test   %ecx,%ecx
  800b56:	74 15                	je     800b6d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	8b 00                	mov    (%eax),%eax
  800b5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b62:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800b65:	8d 71 04             	lea    0x4(%ecx),%esi
  800b68:	89 75 14             	mov    %esi,0x14(%ebp)
  800b6b:	eb 13                	jmp    800b80 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
  800b77:	8b 75 14             	mov    0x14(%ebp),%esi
  800b7a:	8d 76 04             	lea    0x4(%esi),%esi
  800b7d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800b80:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b85:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800b89:	89 74 24 10          	mov    %esi,0x10(%esp)
  800b8d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800b90:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b94:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b98:	89 04 24             	mov    %eax,(%esp)
  800b9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	e8 a6 fa ff ff       	call   800650 <printnum>
			break;
  800baa:	e9 fa fb ff ff       	jmp    8007a9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800baf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800bb6:	89 04 24             	mov    %eax,(%esp)
  800bb9:	ff 55 08             	call   *0x8(%ebp)
			break;
  800bbc:	e9 e8 fb ff ff       	jmp    8007a9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bcf:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd2:	89 fb                	mov    %edi,%ebx
  800bd4:	eb 03                	jmp    800bd9 <vprintfmt+0x455>
  800bd6:	83 eb 01             	sub    $0x1,%ebx
  800bd9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800bdd:	75 f7                	jne    800bd6 <vprintfmt+0x452>
  800bdf:	90                   	nop
  800be0:	e9 c4 fb ff ff       	jmp    8007a9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800be5:	83 c4 3c             	add    $0x3c,%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5f                   	pop    %edi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 28             	sub    $0x28,%esp
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bfc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c00:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0a:	85 c0                	test   %eax,%eax
  800c0c:	74 30                	je     800c3e <vsnprintf+0x51>
  800c0e:	85 d2                	test   %edx,%edx
  800c10:	7e 2c                	jle    800c3e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c20:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c27:	c7 04 24 3f 07 80 00 	movl   $0x80073f,(%esp)
  800c2e:	e8 51 fb ff ff       	call   800784 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c36:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c3c:	eb 05                	jmp    800c43 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800c3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c4b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 04 24             	mov    %eax,(%esp)
  800c66:	e8 82 ff ff ff       	call   800bed <vsnprintf>
	va_end(ap);

	return rc;
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    
  800c6d:	66 90                	xchg   %ax,%ax
  800c6f:	90                   	nop

00800c70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	eb 03                	jmp    800c80 <strlen+0x10>
		n++;
  800c7d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c80:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c84:	75 f7                	jne    800c7d <strlen+0xd>
		n++;
	return n;
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
  800c96:	eb 03                	jmp    800c9b <strnlen+0x13>
		n++;
  800c98:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9b:	39 d0                	cmp    %edx,%eax
  800c9d:	74 06                	je     800ca5 <strnlen+0x1d>
  800c9f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ca3:	75 f3                	jne    800c98 <strnlen+0x10>
		n++;
	return n;
}
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	53                   	push   %ebx
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cb1:	89 c2                	mov    %eax,%edx
  800cb3:	83 c2 01             	add    $0x1,%edx
  800cb6:	83 c1 01             	add    $0x1,%ecx
  800cb9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800cbd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc0:	84 db                	test   %bl,%bl
  800cc2:	75 ef                	jne    800cb3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cd1:	89 1c 24             	mov    %ebx,(%esp)
  800cd4:	e8 97 ff ff ff       	call   800c70 <strlen>
	strcpy(dst + len, src);
  800cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ce0:	01 d8                	add    %ebx,%eax
  800ce2:	89 04 24             	mov    %eax,(%esp)
  800ce5:	e8 bd ff ff ff       	call   800ca7 <strcpy>
	return dst;
}
  800cea:	89 d8                	mov    %ebx,%eax
  800cec:	83 c4 08             	add    $0x8,%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
  800cf7:	8b 75 08             	mov    0x8(%ebp),%esi
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	89 f3                	mov    %esi,%ebx
  800cff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d02:	89 f2                	mov    %esi,%edx
  800d04:	eb 0f                	jmp    800d15 <strncpy+0x23>
		*dst++ = *src;
  800d06:	83 c2 01             	add    $0x1,%edx
  800d09:	0f b6 01             	movzbl (%ecx),%eax
  800d0c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d0f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d12:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d15:	39 da                	cmp    %ebx,%edx
  800d17:	75 ed                	jne    800d06 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d19:	89 f0                	mov    %esi,%eax
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    

00800d1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	8b 75 08             	mov    0x8(%ebp),%esi
  800d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d2d:	89 f0                	mov    %esi,%eax
  800d2f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d33:	85 c9                	test   %ecx,%ecx
  800d35:	75 0b                	jne    800d42 <strlcpy+0x23>
  800d37:	eb 1d                	jmp    800d56 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d39:	83 c0 01             	add    $0x1,%eax
  800d3c:	83 c2 01             	add    $0x1,%edx
  800d3f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d42:	39 d8                	cmp    %ebx,%eax
  800d44:	74 0b                	je     800d51 <strlcpy+0x32>
  800d46:	0f b6 0a             	movzbl (%edx),%ecx
  800d49:	84 c9                	test   %cl,%cl
  800d4b:	75 ec                	jne    800d39 <strlcpy+0x1a>
  800d4d:	89 c2                	mov    %eax,%edx
  800d4f:	eb 02                	jmp    800d53 <strlcpy+0x34>
  800d51:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d53:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d56:	29 f0                	sub    %esi,%eax
}
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d65:	eb 06                	jmp    800d6d <strcmp+0x11>
		p++, q++;
  800d67:	83 c1 01             	add    $0x1,%ecx
  800d6a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d6d:	0f b6 01             	movzbl (%ecx),%eax
  800d70:	84 c0                	test   %al,%al
  800d72:	74 04                	je     800d78 <strcmp+0x1c>
  800d74:	3a 02                	cmp    (%edx),%al
  800d76:	74 ef                	je     800d67 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d78:	0f b6 c0             	movzbl %al,%eax
  800d7b:	0f b6 12             	movzbl (%edx),%edx
  800d7e:	29 d0                	sub    %edx,%eax
}
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	53                   	push   %ebx
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8c:	89 c3                	mov    %eax,%ebx
  800d8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d91:	eb 06                	jmp    800d99 <strncmp+0x17>
		n--, p++, q++;
  800d93:	83 c0 01             	add    $0x1,%eax
  800d96:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d99:	39 d8                	cmp    %ebx,%eax
  800d9b:	74 15                	je     800db2 <strncmp+0x30>
  800d9d:	0f b6 08             	movzbl (%eax),%ecx
  800da0:	84 c9                	test   %cl,%cl
  800da2:	74 04                	je     800da8 <strncmp+0x26>
  800da4:	3a 0a                	cmp    (%edx),%cl
  800da6:	74 eb                	je     800d93 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da8:	0f b6 00             	movzbl (%eax),%eax
  800dab:	0f b6 12             	movzbl (%edx),%edx
  800dae:	29 d0                	sub    %edx,%eax
  800db0:	eb 05                	jmp    800db7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800db2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800db7:	5b                   	pop    %ebx
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dc4:	eb 07                	jmp    800dcd <strchr+0x13>
		if (*s == c)
  800dc6:	38 ca                	cmp    %cl,%dl
  800dc8:	74 0f                	je     800dd9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dca:	83 c0 01             	add    $0x1,%eax
  800dcd:	0f b6 10             	movzbl (%eax),%edx
  800dd0:	84 d2                	test   %dl,%dl
  800dd2:	75 f2                	jne    800dc6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800dd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800de5:	eb 07                	jmp    800dee <strfind+0x13>
		if (*s == c)
  800de7:	38 ca                	cmp    %cl,%dl
  800de9:	74 0a                	je     800df5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800deb:	83 c0 01             	add    $0x1,%eax
  800dee:	0f b6 10             	movzbl (%eax),%edx
  800df1:	84 d2                	test   %dl,%dl
  800df3:	75 f2                	jne    800de7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    

00800df7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	57                   	push   %edi
  800dfb:	56                   	push   %esi
  800dfc:	53                   	push   %ebx
  800dfd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e03:	85 c9                	test   %ecx,%ecx
  800e05:	74 36                	je     800e3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e0d:	75 28                	jne    800e37 <memset+0x40>
  800e0f:	f6 c1 03             	test   $0x3,%cl
  800e12:	75 23                	jne    800e37 <memset+0x40>
		c &= 0xFF;
  800e14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e18:	89 d3                	mov    %edx,%ebx
  800e1a:	c1 e3 08             	shl    $0x8,%ebx
  800e1d:	89 d6                	mov    %edx,%esi
  800e1f:	c1 e6 18             	shl    $0x18,%esi
  800e22:	89 d0                	mov    %edx,%eax
  800e24:	c1 e0 10             	shl    $0x10,%eax
  800e27:	09 f0                	or     %esi,%eax
  800e29:	09 c2                	or     %eax,%edx
  800e2b:	89 d0                	mov    %edx,%eax
  800e2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800e32:	fc                   	cld    
  800e33:	f3 ab                	rep stos %eax,%es:(%edi)
  800e35:	eb 06                	jmp    800e3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	fc                   	cld    
  800e3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e3d:	89 f8                	mov    %edi,%eax
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    

00800e44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e52:	39 c6                	cmp    %eax,%esi
  800e54:	73 35                	jae    800e8b <memmove+0x47>
  800e56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e59:	39 d0                	cmp    %edx,%eax
  800e5b:	73 2e                	jae    800e8b <memmove+0x47>
		s += n;
		d += n;
  800e5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e60:	89 d6                	mov    %edx,%esi
  800e62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e6a:	75 13                	jne    800e7f <memmove+0x3b>
  800e6c:	f6 c1 03             	test   $0x3,%cl
  800e6f:	75 0e                	jne    800e7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e71:	83 ef 04             	sub    $0x4,%edi
  800e74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e7a:	fd                   	std    
  800e7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e7d:	eb 09                	jmp    800e88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e7f:	83 ef 01             	sub    $0x1,%edi
  800e82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e85:	fd                   	std    
  800e86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e88:	fc                   	cld    
  800e89:	eb 1d                	jmp    800ea8 <memmove+0x64>
  800e8b:	89 f2                	mov    %esi,%edx
  800e8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e8f:	f6 c2 03             	test   $0x3,%dl
  800e92:	75 0f                	jne    800ea3 <memmove+0x5f>
  800e94:	f6 c1 03             	test   $0x3,%cl
  800e97:	75 0a                	jne    800ea3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e9c:	89 c7                	mov    %eax,%edi
  800e9e:	fc                   	cld    
  800e9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ea1:	eb 05                	jmp    800ea8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ea3:	89 c7                	mov    %eax,%edi
  800ea5:	fc                   	cld    
  800ea6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	89 04 24             	mov    %eax,(%esp)
  800ec6:	e8 79 ff ff ff       	call   800e44 <memmove>
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	89 d6                	mov    %edx,%esi
  800eda:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800edd:	eb 1a                	jmp    800ef9 <memcmp+0x2c>
		if (*s1 != *s2)
  800edf:	0f b6 02             	movzbl (%edx),%eax
  800ee2:	0f b6 19             	movzbl (%ecx),%ebx
  800ee5:	38 d8                	cmp    %bl,%al
  800ee7:	74 0a                	je     800ef3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ee9:	0f b6 c0             	movzbl %al,%eax
  800eec:	0f b6 db             	movzbl %bl,%ebx
  800eef:	29 d8                	sub    %ebx,%eax
  800ef1:	eb 0f                	jmp    800f02 <memcmp+0x35>
		s1++, s2++;
  800ef3:	83 c2 01             	add    $0x1,%edx
  800ef6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ef9:	39 f2                	cmp    %esi,%edx
  800efb:	75 e2                	jne    800edf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800efd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f0f:	89 c2                	mov    %eax,%edx
  800f11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f14:	eb 07                	jmp    800f1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f16:	38 08                	cmp    %cl,(%eax)
  800f18:	74 07                	je     800f21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f1a:	83 c0 01             	add    $0x1,%eax
  800f1d:	39 d0                	cmp    %edx,%eax
  800f1f:	72 f5                	jb     800f16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2f:	eb 03                	jmp    800f34 <strtol+0x11>
		s++;
  800f31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f34:	0f b6 0a             	movzbl (%edx),%ecx
  800f37:	80 f9 09             	cmp    $0x9,%cl
  800f3a:	74 f5                	je     800f31 <strtol+0xe>
  800f3c:	80 f9 20             	cmp    $0x20,%cl
  800f3f:	74 f0                	je     800f31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f41:	80 f9 2b             	cmp    $0x2b,%cl
  800f44:	75 0a                	jne    800f50 <strtol+0x2d>
		s++;
  800f46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f49:	bf 00 00 00 00       	mov    $0x0,%edi
  800f4e:	eb 11                	jmp    800f61 <strtol+0x3e>
  800f50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f55:	80 f9 2d             	cmp    $0x2d,%cl
  800f58:	75 07                	jne    800f61 <strtol+0x3e>
		s++, neg = 1;
  800f5a:	8d 52 01             	lea    0x1(%edx),%edx
  800f5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f66:	75 15                	jne    800f7d <strtol+0x5a>
  800f68:	80 3a 30             	cmpb   $0x30,(%edx)
  800f6b:	75 10                	jne    800f7d <strtol+0x5a>
  800f6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f71:	75 0a                	jne    800f7d <strtol+0x5a>
		s += 2, base = 16;
  800f73:	83 c2 02             	add    $0x2,%edx
  800f76:	b8 10 00 00 00       	mov    $0x10,%eax
  800f7b:	eb 10                	jmp    800f8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	75 0c                	jne    800f8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f83:	80 3a 30             	cmpb   $0x30,(%edx)
  800f86:	75 05                	jne    800f8d <strtol+0x6a>
		s++, base = 8;
  800f88:	83 c2 01             	add    $0x1,%edx
  800f8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f95:	0f b6 0a             	movzbl (%edx),%ecx
  800f98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f9b:	89 f0                	mov    %esi,%eax
  800f9d:	3c 09                	cmp    $0x9,%al
  800f9f:	77 08                	ja     800fa9 <strtol+0x86>
			dig = *s - '0';
  800fa1:	0f be c9             	movsbl %cl,%ecx
  800fa4:	83 e9 30             	sub    $0x30,%ecx
  800fa7:	eb 20                	jmp    800fc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800fa9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800fac:	89 f0                	mov    %esi,%eax
  800fae:	3c 19                	cmp    $0x19,%al
  800fb0:	77 08                	ja     800fba <strtol+0x97>
			dig = *s - 'a' + 10;
  800fb2:	0f be c9             	movsbl %cl,%ecx
  800fb5:	83 e9 57             	sub    $0x57,%ecx
  800fb8:	eb 0f                	jmp    800fc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800fba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800fbd:	89 f0                	mov    %esi,%eax
  800fbf:	3c 19                	cmp    $0x19,%al
  800fc1:	77 16                	ja     800fd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800fc3:	0f be c9             	movsbl %cl,%ecx
  800fc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800fc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800fcc:	7d 0f                	jge    800fdd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800fce:	83 c2 01             	add    $0x1,%edx
  800fd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800fd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800fd7:	eb bc                	jmp    800f95 <strtol+0x72>
  800fd9:	89 d8                	mov    %ebx,%eax
  800fdb:	eb 02                	jmp    800fdf <strtol+0xbc>
  800fdd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800fdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe3:	74 05                	je     800fea <strtol+0xc7>
		*endptr = (char *) s;
  800fe5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fe8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800fea:	f7 d8                	neg    %eax
  800fec:	85 ff                	test   %edi,%edi
  800fee:	0f 44 c3             	cmove  %ebx,%eax
}
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  801001:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801004:	8b 55 08             	mov    0x8(%ebp),%edx
  801007:	89 c3                	mov    %eax,%ebx
  801009:	89 c7                	mov    %eax,%edi
  80100b:	89 c6                	mov    %eax,%esi
  80100d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5f                   	pop    %edi
  801012:	5d                   	pop    %ebp
  801013:	c3                   	ret    

00801014 <sys_cgetc>:

int
sys_cgetc(void)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	57                   	push   %edi
  801018:	56                   	push   %esi
  801019:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101a:	ba 00 00 00 00       	mov    $0x0,%edx
  80101f:	b8 01 00 00 00       	mov    $0x1,%eax
  801024:	89 d1                	mov    %edx,%ecx
  801026:	89 d3                	mov    %edx,%ebx
  801028:	89 d7                	mov    %edx,%edi
  80102a:	89 d6                	mov    %edx,%esi
  80102c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80102e:	5b                   	pop    %ebx
  80102f:	5e                   	pop    %esi
  801030:	5f                   	pop    %edi
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801041:	b8 03 00 00 00       	mov    $0x3,%eax
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	89 cb                	mov    %ecx,%ebx
  80104b:	89 cf                	mov    %ecx,%edi
  80104d:	89 ce                	mov    %ecx,%esi
  80104f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801051:	85 c0                	test   %eax,%eax
  801053:	7e 28                	jle    80107d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801055:	89 44 24 10          	mov    %eax,0x10(%esp)
  801059:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801060:	00 
  801061:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  801068:	00 
  801069:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801070:	00 
  801071:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  801078:	e8 f9 16 00 00       	call   802776 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80107d:	83 c4 2c             	add    $0x2c,%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801093:	b8 04 00 00 00       	mov    $0x4,%eax
  801098:	8b 55 08             	mov    0x8(%ebp),%edx
  80109b:	89 cb                	mov    %ecx,%ebx
  80109d:	89 cf                	mov    %ecx,%edi
  80109f:	89 ce                	mov    %ecx,%esi
  8010a1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	7e 28                	jle    8010cf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010b2:	00 
  8010b3:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  8010ba:	00 
  8010bb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c2:	00 
  8010c3:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  8010ca:	e8 a7 16 00 00       	call   802776 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  8010cf:	83 c4 2c             	add    $0x2c,%esp
  8010d2:	5b                   	pop    %ebx
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	57                   	push   %edi
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e2:	b8 02 00 00 00       	mov    $0x2,%eax
  8010e7:	89 d1                	mov    %edx,%ecx
  8010e9:	89 d3                	mov    %edx,%ebx
  8010eb:	89 d7                	mov    %edx,%edi
  8010ed:	89 d6                	mov    %edx,%esi
  8010ef:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010f1:	5b                   	pop    %ebx
  8010f2:	5e                   	pop    %esi
  8010f3:	5f                   	pop    %edi
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <sys_yield>:

void
sys_yield(void)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801101:	b8 0c 00 00 00       	mov    $0xc,%eax
  801106:	89 d1                	mov    %edx,%ecx
  801108:	89 d3                	mov    %edx,%ebx
  80110a:	89 d7                	mov    %edx,%edi
  80110c:	89 d6                	mov    %edx,%esi
  80110e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5f                   	pop    %edi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	57                   	push   %edi
  801119:	56                   	push   %esi
  80111a:	53                   	push   %ebx
  80111b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111e:	be 00 00 00 00       	mov    $0x0,%esi
  801123:	b8 05 00 00 00       	mov    $0x5,%eax
  801128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801131:	89 f7                	mov    %esi,%edi
  801133:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801135:	85 c0                	test   %eax,%eax
  801137:	7e 28                	jle    801161 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801139:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801144:	00 
  801145:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  80114c:	00 
  80114d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801154:	00 
  801155:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  80115c:	e8 15 16 00 00       	call   802776 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801161:	83 c4 2c             	add    $0x2c,%esp
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	57                   	push   %edi
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
  80116f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801172:	b8 06 00 00 00       	mov    $0x6,%eax
  801177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117a:	8b 55 08             	mov    0x8(%ebp),%edx
  80117d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801180:	8b 7d 14             	mov    0x14(%ebp),%edi
  801183:	8b 75 18             	mov    0x18(%ebp),%esi
  801186:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801188:	85 c0                	test   %eax,%eax
  80118a:	7e 28                	jle    8011b4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80118c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801190:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801197:	00 
  801198:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  80119f:	00 
  8011a0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a7:	00 
  8011a8:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  8011af:	e8 c2 15 00 00       	call   802776 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011b4:	83 c4 2c             	add    $0x2c,%esp
  8011b7:	5b                   	pop    %ebx
  8011b8:	5e                   	pop    %esi
  8011b9:	5f                   	pop    %edi
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    

008011bc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	57                   	push   %edi
  8011c0:	56                   	push   %esi
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ca:	b8 07 00 00 00       	mov    $0x7,%eax
  8011cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d5:	89 df                	mov    %ebx,%edi
  8011d7:	89 de                	mov    %ebx,%esi
  8011d9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	7e 28                	jle    801207 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011df:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8011ea:	00 
  8011eb:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  8011f2:	00 
  8011f3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011fa:	00 
  8011fb:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  801202:	e8 6f 15 00 00       	call   802776 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801207:	83 c4 2c             	add    $0x2c,%esp
  80120a:	5b                   	pop    %ebx
  80120b:	5e                   	pop    %esi
  80120c:	5f                   	pop    %edi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    

0080120f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	57                   	push   %edi
  801213:	56                   	push   %esi
  801214:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801215:	b9 00 00 00 00       	mov    $0x0,%ecx
  80121a:	b8 10 00 00 00       	mov    $0x10,%eax
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	89 cb                	mov    %ecx,%ebx
  801224:	89 cf                	mov    %ecx,%edi
  801226:	89 ce                	mov    %ecx,%esi
  801228:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80122a:	5b                   	pop    %ebx
  80122b:	5e                   	pop    %esi
  80122c:	5f                   	pop    %edi
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    

0080122f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	57                   	push   %edi
  801233:	56                   	push   %esi
  801234:	53                   	push   %ebx
  801235:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801238:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123d:	b8 09 00 00 00       	mov    $0x9,%eax
  801242:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801245:	8b 55 08             	mov    0x8(%ebp),%edx
  801248:	89 df                	mov    %ebx,%edi
  80124a:	89 de                	mov    %ebx,%esi
  80124c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80124e:	85 c0                	test   %eax,%eax
  801250:	7e 28                	jle    80127a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801252:	89 44 24 10          	mov    %eax,0x10(%esp)
  801256:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80125d:	00 
  80125e:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  801265:	00 
  801266:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126d:	00 
  80126e:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  801275:	e8 fc 14 00 00       	call   802776 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80127a:	83 c4 2c             	add    $0x2c,%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    

00801282 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	57                   	push   %edi
  801286:	56                   	push   %esi
  801287:	53                   	push   %ebx
  801288:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801290:	b8 0a 00 00 00       	mov    $0xa,%eax
  801295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801298:	8b 55 08             	mov    0x8(%ebp),%edx
  80129b:	89 df                	mov    %ebx,%edi
  80129d:	89 de                	mov    %ebx,%esi
  80129f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	7e 28                	jle    8012cd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8012b0:	00 
  8012b1:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  8012b8:	00 
  8012b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c0:	00 
  8012c1:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  8012c8:	e8 a9 14 00 00       	call   802776 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012cd:	83 c4 2c             	add    $0x2c,%esp
  8012d0:	5b                   	pop    %ebx
  8012d1:	5e                   	pop    %esi
  8012d2:	5f                   	pop    %edi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	57                   	push   %edi
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
  8012db:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ee:	89 df                	mov    %ebx,%edi
  8012f0:	89 de                	mov    %ebx,%esi
  8012f2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	7e 28                	jle    801320 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012fc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801303:	00 
  801304:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  80130b:	00 
  80130c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801313:	00 
  801314:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  80131b:	e8 56 14 00 00       	call   802776 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801320:	83 c4 2c             	add    $0x2c,%esp
  801323:	5b                   	pop    %ebx
  801324:	5e                   	pop    %esi
  801325:	5f                   	pop    %edi
  801326:	5d                   	pop    %ebp
  801327:	c3                   	ret    

00801328 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	57                   	push   %edi
  80132c:	56                   	push   %esi
  80132d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132e:	be 00 00 00 00       	mov    $0x0,%esi
  801333:	b8 0d 00 00 00       	mov    $0xd,%eax
  801338:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133b:	8b 55 08             	mov    0x8(%ebp),%edx
  80133e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801341:	8b 7d 14             	mov    0x14(%ebp),%edi
  801344:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	57                   	push   %edi
  80134f:	56                   	push   %esi
  801350:	53                   	push   %ebx
  801351:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801354:	b9 00 00 00 00       	mov    $0x0,%ecx
  801359:	b8 0e 00 00 00       	mov    $0xe,%eax
  80135e:	8b 55 08             	mov    0x8(%ebp),%edx
  801361:	89 cb                	mov    %ecx,%ebx
  801363:	89 cf                	mov    %ecx,%edi
  801365:	89 ce                	mov    %ecx,%esi
  801367:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801369:	85 c0                	test   %eax,%eax
  80136b:	7e 28                	jle    801395 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80136d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801371:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801378:	00 
  801379:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  801380:	00 
  801381:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801388:	00 
  801389:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  801390:	e8 e1 13 00 00       	call   802776 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801395:	83 c4 2c             	add    $0x2c,%esp
  801398:	5b                   	pop    %ebx
  801399:	5e                   	pop    %esi
  80139a:	5f                   	pop    %edi
  80139b:	5d                   	pop    %ebp
  80139c:	c3                   	ret    

0080139d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	57                   	push   %edi
  8013a1:	56                   	push   %esi
  8013a2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013ad:	89 d1                	mov    %edx,%ecx
  8013af:	89 d3                	mov    %edx,%ebx
  8013b1:	89 d7                	mov    %edx,%edi
  8013b3:	89 d6                	mov    %edx,%esi
  8013b5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5f                   	pop    %edi
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	57                   	push   %edi
  8013c0:	56                   	push   %esi
  8013c1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c7:	b8 11 00 00 00       	mov    $0x11,%eax
  8013cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d2:	89 df                	mov    %ebx,%edi
  8013d4:	89 de                	mov    %ebx,%esi
  8013d6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5f                   	pop    %edi
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    

008013dd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	57                   	push   %edi
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e8:	b8 12 00 00 00       	mov    $0x12,%eax
  8013ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f3:	89 df                	mov    %ebx,%edi
  8013f5:	89 de                	mov    %ebx,%esi
  8013f7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8013f9:	5b                   	pop    %ebx
  8013fa:	5e                   	pop    %esi
  8013fb:	5f                   	pop    %edi
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	57                   	push   %edi
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801404:	b9 00 00 00 00       	mov    $0x0,%ecx
  801409:	b8 13 00 00 00       	mov    $0x13,%eax
  80140e:	8b 55 08             	mov    0x8(%ebp),%edx
  801411:	89 cb                	mov    %ecx,%ebx
  801413:	89 cf                	mov    %ecx,%edi
  801415:	89 ce                	mov    %ecx,%esi
  801417:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801419:	5b                   	pop    %ebx
  80141a:	5e                   	pop    %esi
  80141b:	5f                   	pop    %edi
  80141c:	5d                   	pop    %ebp
  80141d:	c3                   	ret    
  80141e:	66 90                	xchg   %ax,%ax

00801420 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	05 00 00 00 30       	add    $0x30000000,%eax
  80142b:	c1 e8 0c             	shr    $0xc,%eax
}
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80143b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801440:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801452:	89 c2                	mov    %eax,%edx
  801454:	c1 ea 16             	shr    $0x16,%edx
  801457:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80145e:	f6 c2 01             	test   $0x1,%dl
  801461:	74 11                	je     801474 <fd_alloc+0x2d>
  801463:	89 c2                	mov    %eax,%edx
  801465:	c1 ea 0c             	shr    $0xc,%edx
  801468:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80146f:	f6 c2 01             	test   $0x1,%dl
  801472:	75 09                	jne    80147d <fd_alloc+0x36>
			*fd_store = fd;
  801474:	89 01                	mov    %eax,(%ecx)
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 17                	jmp    801494 <fd_alloc+0x4d>
  80147d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801482:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801487:	75 c9                	jne    801452 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801489:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80148f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801494:	5d                   	pop    %ebp
  801495:	c3                   	ret    

00801496 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80149c:	83 f8 1f             	cmp    $0x1f,%eax
  80149f:	77 36                	ja     8014d7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014a1:	c1 e0 0c             	shl    $0xc,%eax
  8014a4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014a9:	89 c2                	mov    %eax,%edx
  8014ab:	c1 ea 16             	shr    $0x16,%edx
  8014ae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014b5:	f6 c2 01             	test   $0x1,%dl
  8014b8:	74 24                	je     8014de <fd_lookup+0x48>
  8014ba:	89 c2                	mov    %eax,%edx
  8014bc:	c1 ea 0c             	shr    $0xc,%edx
  8014bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014c6:	f6 c2 01             	test   $0x1,%dl
  8014c9:	74 1a                	je     8014e5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	89 02                	mov    %eax,(%edx)
	return 0;
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d5:	eb 13                	jmp    8014ea <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014dc:	eb 0c                	jmp    8014ea <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e3:	eb 05                	jmp    8014ea <fd_lookup+0x54>
  8014e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    

008014ec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 18             	sub    $0x18,%esp
  8014f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fa:	eb 13                	jmp    80150f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8014fc:	39 08                	cmp    %ecx,(%eax)
  8014fe:	75 0c                	jne    80150c <dev_lookup+0x20>
			*dev = devtab[i];
  801500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801503:	89 01                	mov    %eax,(%ecx)
			return 0;
  801505:	b8 00 00 00 00       	mov    $0x0,%eax
  80150a:	eb 38                	jmp    801544 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80150c:	83 c2 01             	add    $0x1,%edx
  80150f:	8b 04 95 c0 30 80 00 	mov    0x8030c0(,%edx,4),%eax
  801516:	85 c0                	test   %eax,%eax
  801518:	75 e2                	jne    8014fc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80151a:	a1 18 50 80 00       	mov    0x805018,%eax
  80151f:	8b 40 48             	mov    0x48(%eax),%eax
  801522:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801526:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152a:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  801531:	e8 fb f0 ff ff       	call   800631 <cprintf>
	*dev = 0;
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80153f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	83 ec 20             	sub    $0x20,%esp
  80154e:	8b 75 08             	mov    0x8(%ebp),%esi
  801551:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801554:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801557:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80155b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801561:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 2a ff ff ff       	call   801496 <fd_lookup>
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 05                	js     801575 <fd_close+0x2f>
	    || fd != fd2)
  801570:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801573:	74 0c                	je     801581 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801575:	84 db                	test   %bl,%bl
  801577:	ba 00 00 00 00       	mov    $0x0,%edx
  80157c:	0f 44 c2             	cmove  %edx,%eax
  80157f:	eb 3f                	jmp    8015c0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801581:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801584:	89 44 24 04          	mov    %eax,0x4(%esp)
  801588:	8b 06                	mov    (%esi),%eax
  80158a:	89 04 24             	mov    %eax,(%esp)
  80158d:	e8 5a ff ff ff       	call   8014ec <dev_lookup>
  801592:	89 c3                	mov    %eax,%ebx
  801594:	85 c0                	test   %eax,%eax
  801596:	78 16                	js     8015ae <fd_close+0x68>
		if (dev->dev_close)
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80159e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 07                	je     8015ae <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015a7:	89 34 24             	mov    %esi,(%esp)
  8015aa:	ff d0                	call   *%eax
  8015ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b9:	e8 fe fb ff ff       	call   8011bc <sys_page_unmap>
	return r;
  8015be:	89 d8                	mov    %ebx,%eax
}
  8015c0:	83 c4 20             	add    $0x20,%esp
  8015c3:	5b                   	pop    %ebx
  8015c4:	5e                   	pop    %esi
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    

008015c7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	89 04 24             	mov    %eax,(%esp)
  8015da:	e8 b7 fe ff ff       	call   801496 <fd_lookup>
  8015df:	89 c2                	mov    %eax,%edx
  8015e1:	85 d2                	test   %edx,%edx
  8015e3:	78 13                	js     8015f8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8015e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015ec:	00 
  8015ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f0:	89 04 24             	mov    %eax,(%esp)
  8015f3:	e8 4e ff ff ff       	call   801546 <fd_close>
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <close_all>:

void
close_all(void)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801601:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801606:	89 1c 24             	mov    %ebx,(%esp)
  801609:	e8 b9 ff ff ff       	call   8015c7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80160e:	83 c3 01             	add    $0x1,%ebx
  801611:	83 fb 20             	cmp    $0x20,%ebx
  801614:	75 f0                	jne    801606 <close_all+0xc>
		close(i);
}
  801616:	83 c4 14             	add    $0x14,%esp
  801619:	5b                   	pop    %ebx
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	57                   	push   %edi
  801620:	56                   	push   %esi
  801621:	53                   	push   %ebx
  801622:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801625:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	89 04 24             	mov    %eax,(%esp)
  801632:	e8 5f fe ff ff       	call   801496 <fd_lookup>
  801637:	89 c2                	mov    %eax,%edx
  801639:	85 d2                	test   %edx,%edx
  80163b:	0f 88 e1 00 00 00    	js     801722 <dup+0x106>
		return r;
	close(newfdnum);
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	89 04 24             	mov    %eax,(%esp)
  801647:	e8 7b ff ff ff       	call   8015c7 <close>

	newfd = INDEX2FD(newfdnum);
  80164c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80164f:	c1 e3 0c             	shl    $0xc,%ebx
  801652:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80165b:	89 04 24             	mov    %eax,(%esp)
  80165e:	e8 cd fd ff ff       	call   801430 <fd2data>
  801663:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801665:	89 1c 24             	mov    %ebx,(%esp)
  801668:	e8 c3 fd ff ff       	call   801430 <fd2data>
  80166d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80166f:	89 f0                	mov    %esi,%eax
  801671:	c1 e8 16             	shr    $0x16,%eax
  801674:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80167b:	a8 01                	test   $0x1,%al
  80167d:	74 43                	je     8016c2 <dup+0xa6>
  80167f:	89 f0                	mov    %esi,%eax
  801681:	c1 e8 0c             	shr    $0xc,%eax
  801684:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80168b:	f6 c2 01             	test   $0x1,%dl
  80168e:	74 32                	je     8016c2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801690:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801697:	25 07 0e 00 00       	and    $0xe07,%eax
  80169c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016a0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016ab:	00 
  8016ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b7:	e8 ad fa ff ff       	call   801169 <sys_page_map>
  8016bc:	89 c6                	mov    %eax,%esi
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 3e                	js     801700 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016c5:	89 c2                	mov    %eax,%edx
  8016c7:	c1 ea 0c             	shr    $0xc,%edx
  8016ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016d1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016d7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016e6:	00 
  8016e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f2:	e8 72 fa ff ff       	call   801169 <sys_page_map>
  8016f7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016fc:	85 f6                	test   %esi,%esi
  8016fe:	79 22                	jns    801722 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801700:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801704:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80170b:	e8 ac fa ff ff       	call   8011bc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801714:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171b:	e8 9c fa ff ff       	call   8011bc <sys_page_unmap>
	return r;
  801720:	89 f0                	mov    %esi,%eax
}
  801722:	83 c4 3c             	add    $0x3c,%esp
  801725:	5b                   	pop    %ebx
  801726:	5e                   	pop    %esi
  801727:	5f                   	pop    %edi
  801728:	5d                   	pop    %ebp
  801729:	c3                   	ret    

0080172a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	53                   	push   %ebx
  80172e:	83 ec 24             	sub    $0x24,%esp
  801731:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801734:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801737:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173b:	89 1c 24             	mov    %ebx,(%esp)
  80173e:	e8 53 fd ff ff       	call   801496 <fd_lookup>
  801743:	89 c2                	mov    %eax,%edx
  801745:	85 d2                	test   %edx,%edx
  801747:	78 6d                	js     8017b6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	8b 00                	mov    (%eax),%eax
  801755:	89 04 24             	mov    %eax,(%esp)
  801758:	e8 8f fd ff ff       	call   8014ec <dev_lookup>
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 55                	js     8017b6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801764:	8b 50 08             	mov    0x8(%eax),%edx
  801767:	83 e2 03             	and    $0x3,%edx
  80176a:	83 fa 01             	cmp    $0x1,%edx
  80176d:	75 23                	jne    801792 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80176f:	a1 18 50 80 00       	mov    0x805018,%eax
  801774:	8b 40 48             	mov    0x48(%eax),%eax
  801777:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80177b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177f:	c7 04 24 85 30 80 00 	movl   $0x803085,(%esp)
  801786:	e8 a6 ee ff ff       	call   800631 <cprintf>
		return -E_INVAL;
  80178b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801790:	eb 24                	jmp    8017b6 <read+0x8c>
	}
	if (!dev->dev_read)
  801792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801795:	8b 52 08             	mov    0x8(%edx),%edx
  801798:	85 d2                	test   %edx,%edx
  80179a:	74 15                	je     8017b1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80179c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017aa:	89 04 24             	mov    %eax,(%esp)
  8017ad:	ff d2                	call   *%edx
  8017af:	eb 05                	jmp    8017b6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017b6:	83 c4 24             	add    $0x24,%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	57                   	push   %edi
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 1c             	sub    $0x1c,%esp
  8017c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017d0:	eb 23                	jmp    8017f5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017d2:	89 f0                	mov    %esi,%eax
  8017d4:	29 d8                	sub    %ebx,%eax
  8017d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017da:	89 d8                	mov    %ebx,%eax
  8017dc:	03 45 0c             	add    0xc(%ebp),%eax
  8017df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e3:	89 3c 24             	mov    %edi,(%esp)
  8017e6:	e8 3f ff ff ff       	call   80172a <read>
		if (m < 0)
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 10                	js     8017ff <readn+0x43>
			return m;
		if (m == 0)
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	74 0a                	je     8017fd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017f3:	01 c3                	add    %eax,%ebx
  8017f5:	39 f3                	cmp    %esi,%ebx
  8017f7:	72 d9                	jb     8017d2 <readn+0x16>
  8017f9:	89 d8                	mov    %ebx,%eax
  8017fb:	eb 02                	jmp    8017ff <readn+0x43>
  8017fd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017ff:	83 c4 1c             	add    $0x1c,%esp
  801802:	5b                   	pop    %ebx
  801803:	5e                   	pop    %esi
  801804:	5f                   	pop    %edi
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    

00801807 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	53                   	push   %ebx
  80180b:	83 ec 24             	sub    $0x24,%esp
  80180e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801811:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801814:	89 44 24 04          	mov    %eax,0x4(%esp)
  801818:	89 1c 24             	mov    %ebx,(%esp)
  80181b:	e8 76 fc ff ff       	call   801496 <fd_lookup>
  801820:	89 c2                	mov    %eax,%edx
  801822:	85 d2                	test   %edx,%edx
  801824:	78 68                	js     80188e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801826:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801830:	8b 00                	mov    (%eax),%eax
  801832:	89 04 24             	mov    %eax,(%esp)
  801835:	e8 b2 fc ff ff       	call   8014ec <dev_lookup>
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 50                	js     80188e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801845:	75 23                	jne    80186a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801847:	a1 18 50 80 00       	mov    0x805018,%eax
  80184c:	8b 40 48             	mov    0x48(%eax),%eax
  80184f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801853:	89 44 24 04          	mov    %eax,0x4(%esp)
  801857:	c7 04 24 a1 30 80 00 	movl   $0x8030a1,(%esp)
  80185e:	e8 ce ed ff ff       	call   800631 <cprintf>
		return -E_INVAL;
  801863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801868:	eb 24                	jmp    80188e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80186a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186d:	8b 52 0c             	mov    0xc(%edx),%edx
  801870:	85 d2                	test   %edx,%edx
  801872:	74 15                	je     801889 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801874:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801877:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80187b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80187e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801882:	89 04 24             	mov    %eax,(%esp)
  801885:	ff d2                	call   *%edx
  801887:	eb 05                	jmp    80188e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801889:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80188e:	83 c4 24             	add    $0x24,%esp
  801891:	5b                   	pop    %ebx
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    

00801894 <seek>:

int
seek(int fdnum, off_t offset)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80189d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	89 04 24             	mov    %eax,(%esp)
  8018a7:	e8 ea fb ff ff       	call   801496 <fd_lookup>
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 0e                	js     8018be <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 24             	sub    $0x24,%esp
  8018c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d1:	89 1c 24             	mov    %ebx,(%esp)
  8018d4:	e8 bd fb ff ff       	call   801496 <fd_lookup>
  8018d9:	89 c2                	mov    %eax,%edx
  8018db:	85 d2                	test   %edx,%edx
  8018dd:	78 61                	js     801940 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e9:	8b 00                	mov    (%eax),%eax
  8018eb:	89 04 24             	mov    %eax,(%esp)
  8018ee:	e8 f9 fb ff ff       	call   8014ec <dev_lookup>
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 49                	js     801940 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fe:	75 23                	jne    801923 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801900:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801905:	8b 40 48             	mov    0x48(%eax),%eax
  801908:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80190c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801910:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  801917:	e8 15 ed ff ff       	call   800631 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80191c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801921:	eb 1d                	jmp    801940 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801923:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801926:	8b 52 18             	mov    0x18(%edx),%edx
  801929:	85 d2                	test   %edx,%edx
  80192b:	74 0e                	je     80193b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80192d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801930:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801934:	89 04 24             	mov    %eax,(%esp)
  801937:	ff d2                	call   *%edx
  801939:	eb 05                	jmp    801940 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80193b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801940:	83 c4 24             	add    $0x24,%esp
  801943:	5b                   	pop    %ebx
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	53                   	push   %ebx
  80194a:	83 ec 24             	sub    $0x24,%esp
  80194d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801950:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801953:	89 44 24 04          	mov    %eax,0x4(%esp)
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	89 04 24             	mov    %eax,(%esp)
  80195d:	e8 34 fb ff ff       	call   801496 <fd_lookup>
  801962:	89 c2                	mov    %eax,%edx
  801964:	85 d2                	test   %edx,%edx
  801966:	78 52                	js     8019ba <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801968:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	e8 70 fb ff ff       	call   8014ec <dev_lookup>
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 3a                	js     8019ba <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801983:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801987:	74 2c                	je     8019b5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801989:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80198c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801993:	00 00 00 
	stat->st_isdir = 0;
  801996:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80199d:	00 00 00 
	stat->st_dev = dev;
  8019a0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ad:	89 14 24             	mov    %edx,(%esp)
  8019b0:	ff 50 14             	call   *0x14(%eax)
  8019b3:	eb 05                	jmp    8019ba <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8019b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8019ba:	83 c4 24             	add    $0x24,%esp
  8019bd:	5b                   	pop    %ebx
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    

008019c0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	56                   	push   %esi
  8019c4:	53                   	push   %ebx
  8019c5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019cf:	00 
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	89 04 24             	mov    %eax,(%esp)
  8019d6:	e8 99 02 00 00       	call   801c74 <open>
  8019db:	89 c3                	mov    %eax,%ebx
  8019dd:	85 db                	test   %ebx,%ebx
  8019df:	78 1b                	js     8019fc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8019e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e8:	89 1c 24             	mov    %ebx,(%esp)
  8019eb:	e8 56 ff ff ff       	call   801946 <fstat>
  8019f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019f2:	89 1c 24             	mov    %ebx,(%esp)
  8019f5:	e8 cd fb ff ff       	call   8015c7 <close>
	return r;
  8019fa:	89 f0                	mov    %esi,%eax
}
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	83 ec 10             	sub    $0x10,%esp
  801a0b:	89 c6                	mov    %eax,%esi
  801a0d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a0f:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801a16:	75 11                	jne    801a29 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a1f:	e8 7b 0e 00 00       	call   80289f <ipc_find_env>
  801a24:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a29:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a30:	00 
  801a31:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a38:	00 
  801a39:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a3d:	a1 10 50 80 00       	mov    0x805010,%eax
  801a42:	89 04 24             	mov    %eax,(%esp)
  801a45:	e8 ee 0d 00 00       	call   802838 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a4a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a51:	00 
  801a52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5d:	e8 6e 0d 00 00       	call   8027d0 <ipc_recv>
}
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	5b                   	pop    %ebx
  801a66:	5e                   	pop    %esi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    

00801a69 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8b 40 0c             	mov    0xc(%eax),%eax
  801a75:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
  801a87:	b8 02 00 00 00       	mov    $0x2,%eax
  801a8c:	e8 72 ff ff ff       	call   801a03 <fsipc>
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801aa4:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa9:	b8 06 00 00 00       	mov    $0x6,%eax
  801aae:	e8 50 ff ff ff       	call   801a03 <fsipc>
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	53                   	push   %ebx
  801ab9:	83 ec 14             	sub    $0x14,%esp
  801abc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aca:	ba 00 00 00 00       	mov    $0x0,%edx
  801acf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ad4:	e8 2a ff ff ff       	call   801a03 <fsipc>
  801ad9:	89 c2                	mov    %eax,%edx
  801adb:	85 d2                	test   %edx,%edx
  801add:	78 2b                	js     801b0a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801adf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ae6:	00 
  801ae7:	89 1c 24             	mov    %ebx,(%esp)
  801aea:	e8 b8 f1 ff ff       	call   800ca7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801aef:	a1 80 60 80 00       	mov    0x806080,%eax
  801af4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801afa:	a1 84 60 80 00       	mov    0x806084,%eax
  801aff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0a:	83 c4 14             	add    $0x14,%esp
  801b0d:	5b                   	pop    %ebx
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	53                   	push   %ebx
  801b14:	83 ec 14             	sub    $0x14,%esp
  801b17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801b1a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801b20:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801b25:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b28:	8b 55 08             	mov    0x8(%ebp),%edx
  801b2b:	8b 52 0c             	mov    0xc(%edx),%edx
  801b2e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801b34:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801b39:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b44:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b4b:	e8 f4 f2 ff ff       	call   800e44 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801b50:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801b57:	00 
  801b58:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  801b5f:	e8 cd ea ff ff       	call   800631 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b64:	ba 00 00 00 00       	mov    $0x0,%edx
  801b69:	b8 04 00 00 00       	mov    $0x4,%eax
  801b6e:	e8 90 fe ff ff       	call   801a03 <fsipc>
  801b73:	85 c0                	test   %eax,%eax
  801b75:	78 53                	js     801bca <devfile_write+0xba>
		return r;
	assert(r <= n);
  801b77:	39 c3                	cmp    %eax,%ebx
  801b79:	73 24                	jae    801b9f <devfile_write+0x8f>
  801b7b:	c7 44 24 0c d9 30 80 	movl   $0x8030d9,0xc(%esp)
  801b82:	00 
  801b83:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  801b8a:	00 
  801b8b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801b92:	00 
  801b93:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  801b9a:	e8 d7 0b 00 00       	call   802776 <_panic>
	assert(r <= PGSIZE);
  801b9f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ba4:	7e 24                	jle    801bca <devfile_write+0xba>
  801ba6:	c7 44 24 0c 00 31 80 	movl   $0x803100,0xc(%esp)
  801bad:	00 
  801bae:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  801bb5:	00 
  801bb6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801bbd:	00 
  801bbe:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  801bc5:	e8 ac 0b 00 00       	call   802776 <_panic>
	return r;
}
  801bca:	83 c4 14             	add    $0x14,%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    

00801bd0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	83 ec 10             	sub    $0x10,%esp
  801bd8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	8b 40 0c             	mov    0xc(%eax),%eax
  801be1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801be6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bec:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf1:	b8 03 00 00 00       	mov    $0x3,%eax
  801bf6:	e8 08 fe ff ff       	call   801a03 <fsipc>
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	78 6a                	js     801c6b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c01:	39 c6                	cmp    %eax,%esi
  801c03:	73 24                	jae    801c29 <devfile_read+0x59>
  801c05:	c7 44 24 0c d9 30 80 	movl   $0x8030d9,0xc(%esp)
  801c0c:	00 
  801c0d:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  801c14:	00 
  801c15:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c1c:	00 
  801c1d:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  801c24:	e8 4d 0b 00 00       	call   802776 <_panic>
	assert(r <= PGSIZE);
  801c29:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c2e:	7e 24                	jle    801c54 <devfile_read+0x84>
  801c30:	c7 44 24 0c 00 31 80 	movl   $0x803100,0xc(%esp)
  801c37:	00 
  801c38:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  801c3f:	00 
  801c40:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c47:	00 
  801c48:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  801c4f:	e8 22 0b 00 00       	call   802776 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c54:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c58:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c5f:	00 
  801c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c63:	89 04 24             	mov    %eax,(%esp)
  801c66:	e8 d9 f1 ff ff       	call   800e44 <memmove>
	return r;
}
  801c6b:	89 d8                	mov    %ebx,%eax
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    

00801c74 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	53                   	push   %ebx
  801c78:	83 ec 24             	sub    $0x24,%esp
  801c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c7e:	89 1c 24             	mov    %ebx,(%esp)
  801c81:	e8 ea ef ff ff       	call   800c70 <strlen>
  801c86:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c8b:	7f 60                	jg     801ced <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c90:	89 04 24             	mov    %eax,(%esp)
  801c93:	e8 af f7 ff ff       	call   801447 <fd_alloc>
  801c98:	89 c2                	mov    %eax,%edx
  801c9a:	85 d2                	test   %edx,%edx
  801c9c:	78 54                	js     801cf2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c9e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ca2:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801ca9:	e8 f9 ef ff ff       	call   800ca7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbe:	e8 40 fd ff ff       	call   801a03 <fsipc>
  801cc3:	89 c3                	mov    %eax,%ebx
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	79 17                	jns    801ce0 <open+0x6c>
		fd_close(fd, 0);
  801cc9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cd0:	00 
  801cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd4:	89 04 24             	mov    %eax,(%esp)
  801cd7:	e8 6a f8 ff ff       	call   801546 <fd_close>
		return r;
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	eb 12                	jmp    801cf2 <open+0x7e>
	}

	return fd2num(fd);
  801ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce3:	89 04 24             	mov    %eax,(%esp)
  801ce6:	e8 35 f7 ff ff       	call   801420 <fd2num>
  801ceb:	eb 05                	jmp    801cf2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801ced:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801cf2:	83 c4 24             	add    $0x24,%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    

00801cf8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801d03:	b8 08 00 00 00       	mov    $0x8,%eax
  801d08:	e8 f6 fc ff ff       	call   801a03 <fsipc>
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <evict>:

int evict(void)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801d15:	c7 04 24 0c 31 80 00 	movl   $0x80310c,(%esp)
  801d1c:	e8 10 e9 ff ff       	call   800631 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801d21:	ba 00 00 00 00       	mov    $0x0,%edx
  801d26:	b8 09 00 00 00       	mov    $0x9,%eax
  801d2b:	e8 d3 fc ff ff       	call   801a03 <fsipc>
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    
  801d32:	66 90                	xchg   %ax,%ax
  801d34:	66 90                	xchg   %ax,%ax
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	66 90                	xchg   %ax,%ax
  801d3a:	66 90                	xchg   %ax,%ax
  801d3c:	66 90                	xchg   %ax,%ax
  801d3e:	66 90                	xchg   %ax,%ax

00801d40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d46:	c7 44 24 04 25 31 80 	movl   $0x803125,0x4(%esp)
  801d4d:	00 
  801d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d51:	89 04 24             	mov    %eax,(%esp)
  801d54:	e8 4e ef ff ff       	call   800ca7 <strcpy>
	return 0;
}
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	53                   	push   %ebx
  801d64:	83 ec 14             	sub    $0x14,%esp
  801d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d6a:	89 1c 24             	mov    %ebx,(%esp)
  801d6d:	e8 65 0b 00 00       	call   8028d7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d72:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d77:	83 f8 01             	cmp    $0x1,%eax
  801d7a:	75 0d                	jne    801d89 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d7c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d7f:	89 04 24             	mov    %eax,(%esp)
  801d82:	e8 29 03 00 00       	call   8020b0 <nsipc_close>
  801d87:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	83 c4 14             	add    $0x14,%esp
  801d8e:	5b                   	pop    %ebx
  801d8f:	5d                   	pop    %ebp
  801d90:	c3                   	ret    

00801d91 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d97:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d9e:	00 
  801d9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801da2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	8b 40 0c             	mov    0xc(%eax),%eax
  801db3:	89 04 24             	mov    %eax,(%esp)
  801db6:	e8 f0 03 00 00       	call   8021ab <nsipc_send>
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801dc3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dca:	00 
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddf:	89 04 24             	mov    %eax,(%esp)
  801de2:	e8 44 03 00 00       	call   80212b <nsipc_recv>
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801def:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801df2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801df6:	89 04 24             	mov    %eax,(%esp)
  801df9:	e8 98 f6 ff ff       	call   801496 <fd_lookup>
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	78 17                	js     801e19 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e0b:	39 08                	cmp    %ecx,(%eax)
  801e0d:	75 05                	jne    801e14 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e12:	eb 05                	jmp    801e19 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801e14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 20             	sub    $0x20,%esp
  801e23:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e28:	89 04 24             	mov    %eax,(%esp)
  801e2b:	e8 17 f6 ff ff       	call   801447 <fd_alloc>
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 21                	js     801e57 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e36:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e3d:	00 
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e4c:	e8 c4 f2 ff ff       	call   801115 <sys_page_alloc>
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	85 c0                	test   %eax,%eax
  801e55:	79 0c                	jns    801e63 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e57:	89 34 24             	mov    %esi,(%esp)
  801e5a:	e8 51 02 00 00       	call   8020b0 <nsipc_close>
		return r;
  801e5f:	89 d8                	mov    %ebx,%eax
  801e61:	eb 20                	jmp    801e83 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e63:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e71:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e78:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e7b:	89 14 24             	mov    %edx,(%esp)
  801e7e:	e8 9d f5 ff ff       	call   801420 <fd2num>
}
  801e83:	83 c4 20             	add    $0x20,%esp
  801e86:	5b                   	pop    %ebx
  801e87:	5e                   	pop    %esi
  801e88:	5d                   	pop    %ebp
  801e89:	c3                   	ret    

00801e8a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	e8 51 ff ff ff       	call   801de9 <fd2sockid>
		return r;
  801e98:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	78 23                	js     801ec1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e9e:	8b 55 10             	mov    0x10(%ebp),%edx
  801ea1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eac:	89 04 24             	mov    %eax,(%esp)
  801eaf:	e8 45 01 00 00       	call   801ff9 <nsipc_accept>
		return r;
  801eb4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	78 07                	js     801ec1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801eba:	e8 5c ff ff ff       	call   801e1b <alloc_sockfd>
  801ebf:	89 c1                	mov    %eax,%ecx
}
  801ec1:	89 c8                	mov    %ecx,%eax
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	e8 16 ff ff ff       	call   801de9 <fd2sockid>
  801ed3:	89 c2                	mov    %eax,%edx
  801ed5:	85 d2                	test   %edx,%edx
  801ed7:	78 16                	js     801eef <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  801edc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee7:	89 14 24             	mov    %edx,(%esp)
  801eea:	e8 60 01 00 00       	call   80204f <nsipc_bind>
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <shutdown>:

int
shutdown(int s, int how)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	e8 ea fe ff ff       	call   801de9 <fd2sockid>
  801eff:	89 c2                	mov    %eax,%edx
  801f01:	85 d2                	test   %edx,%edx
  801f03:	78 0f                	js     801f14 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0c:	89 14 24             	mov    %edx,(%esp)
  801f0f:	e8 7a 01 00 00       	call   80208e <nsipc_shutdown>
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	e8 c5 fe ff ff       	call   801de9 <fd2sockid>
  801f24:	89 c2                	mov    %eax,%edx
  801f26:	85 d2                	test   %edx,%edx
  801f28:	78 16                	js     801f40 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f38:	89 14 24             	mov    %edx,(%esp)
  801f3b:	e8 8a 01 00 00       	call   8020ca <nsipc_connect>
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <listen>:

int
listen(int s, int backlog)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	e8 99 fe ff ff       	call   801de9 <fd2sockid>
  801f50:	89 c2                	mov    %eax,%edx
  801f52:	85 d2                	test   %edx,%edx
  801f54:	78 0f                	js     801f65 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5d:	89 14 24             	mov    %edx,(%esp)
  801f60:	e8 a4 01 00 00       	call   802109 <nsipc_listen>
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f70:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	89 04 24             	mov    %eax,(%esp)
  801f81:	e8 98 02 00 00       	call   80221e <nsipc_socket>
  801f86:	89 c2                	mov    %eax,%edx
  801f88:	85 d2                	test   %edx,%edx
  801f8a:	78 05                	js     801f91 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f8c:	e8 8a fe ff ff       	call   801e1b <alloc_sockfd>
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	53                   	push   %ebx
  801f97:	83 ec 14             	sub    $0x14,%esp
  801f9a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f9c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801fa3:	75 11                	jne    801fb6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fa5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801fac:	e8 ee 08 00 00       	call   80289f <ipc_find_env>
  801fb1:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fb6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801fbd:	00 
  801fbe:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801fc5:	00 
  801fc6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fca:	a1 14 50 80 00       	mov    0x805014,%eax
  801fcf:	89 04 24             	mov    %eax,(%esp)
  801fd2:	e8 61 08 00 00       	call   802838 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fd7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fde:	00 
  801fdf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fe6:	00 
  801fe7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fee:	e8 dd 07 00 00       	call   8027d0 <ipc_recv>
}
  801ff3:	83 c4 14             	add    $0x14,%esp
  801ff6:	5b                   	pop    %ebx
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    

00801ff9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	56                   	push   %esi
  801ffd:	53                   	push   %ebx
  801ffe:	83 ec 10             	sub    $0x10,%esp
  802001:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80200c:	8b 06                	mov    (%esi),%eax
  80200e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802013:	b8 01 00 00 00       	mov    $0x1,%eax
  802018:	e8 76 ff ff ff       	call   801f93 <nsipc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 23                	js     802046 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802023:	a1 10 70 80 00       	mov    0x807010,%eax
  802028:	89 44 24 08          	mov    %eax,0x8(%esp)
  80202c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802033:	00 
  802034:	8b 45 0c             	mov    0xc(%ebp),%eax
  802037:	89 04 24             	mov    %eax,(%esp)
  80203a:	e8 05 ee ff ff       	call   800e44 <memmove>
		*addrlen = ret->ret_addrlen;
  80203f:	a1 10 70 80 00       	mov    0x807010,%eax
  802044:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802046:	89 d8                	mov    %ebx,%eax
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    

0080204f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	53                   	push   %ebx
  802053:	83 ec 14             	sub    $0x14,%esp
  802056:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802061:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802065:	8b 45 0c             	mov    0xc(%ebp),%eax
  802068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802073:	e8 cc ed ff ff       	call   800e44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802078:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80207e:	b8 02 00 00 00       	mov    $0x2,%eax
  802083:	e8 0b ff ff ff       	call   801f93 <nsipc>
}
  802088:	83 c4 14             	add    $0x14,%esp
  80208b:	5b                   	pop    %ebx
  80208c:	5d                   	pop    %ebp
  80208d:	c3                   	ret    

0080208e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80209c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020a9:	e8 e5 fe ff ff       	call   801f93 <nsipc>
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020be:	b8 04 00 00 00       	mov    $0x4,%eax
  8020c3:	e8 cb fe ff ff       	call   801f93 <nsipc>
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	53                   	push   %ebx
  8020ce:	83 ec 14             	sub    $0x14,%esp
  8020d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020ee:	e8 51 ed ff ff       	call   800e44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020f3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020f9:	b8 05 00 00 00       	mov    $0x5,%eax
  8020fe:	e8 90 fe ff ff       	call   801f93 <nsipc>
}
  802103:	83 c4 14             	add    $0x14,%esp
  802106:	5b                   	pop    %ebx
  802107:	5d                   	pop    %ebp
  802108:	c3                   	ret    

00802109 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80211f:	b8 06 00 00 00       	mov    $0x6,%eax
  802124:	e8 6a fe ff ff       	call   801f93 <nsipc>
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	83 ec 10             	sub    $0x10,%esp
  802133:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80213e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802144:	8b 45 14             	mov    0x14(%ebp),%eax
  802147:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80214c:	b8 07 00 00 00       	mov    $0x7,%eax
  802151:	e8 3d fe ff ff       	call   801f93 <nsipc>
  802156:	89 c3                	mov    %eax,%ebx
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 46                	js     8021a2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80215c:	39 f0                	cmp    %esi,%eax
  80215e:	7f 07                	jg     802167 <nsipc_recv+0x3c>
  802160:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802165:	7e 24                	jle    80218b <nsipc_recv+0x60>
  802167:	c7 44 24 0c 31 31 80 	movl   $0x803131,0xc(%esp)
  80216e:	00 
  80216f:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  802176:	00 
  802177:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80217e:	00 
  80217f:	c7 04 24 46 31 80 00 	movl   $0x803146,(%esp)
  802186:	e8 eb 05 00 00       	call   802776 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80218b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80218f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802196:	00 
  802197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219a:	89 04 24             	mov    %eax,(%esp)
  80219d:	e8 a2 ec ff ff       	call   800e44 <memmove>
	}

	return r;
}
  8021a2:	89 d8                	mov    %ebx,%eax
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5d                   	pop    %ebp
  8021aa:	c3                   	ret    

008021ab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	53                   	push   %ebx
  8021af:	83 ec 14             	sub    $0x14,%esp
  8021b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021bd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021c3:	7e 24                	jle    8021e9 <nsipc_send+0x3e>
  8021c5:	c7 44 24 0c 52 31 80 	movl   $0x803152,0xc(%esp)
  8021cc:	00 
  8021cd:	c7 44 24 08 e0 30 80 	movl   $0x8030e0,0x8(%esp)
  8021d4:	00 
  8021d5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8021dc:	00 
  8021dd:	c7 04 24 46 31 80 00 	movl   $0x803146,(%esp)
  8021e4:	e8 8d 05 00 00       	call   802776 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8021fb:	e8 44 ec ff ff       	call   800e44 <memmove>
	nsipcbuf.send.req_size = size;
  802200:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802206:	8b 45 14             	mov    0x14(%ebp),%eax
  802209:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80220e:	b8 08 00 00 00       	mov    $0x8,%eax
  802213:	e8 7b fd ff ff       	call   801f93 <nsipc>
}
  802218:	83 c4 14             	add    $0x14,%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5d                   	pop    %ebp
  80221d:	c3                   	ret    

0080221e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80222c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802234:	8b 45 10             	mov    0x10(%ebp),%eax
  802237:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80223c:	b8 09 00 00 00       	mov    $0x9,%eax
  802241:	e8 4d fd ff ff       	call   801f93 <nsipc>
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	56                   	push   %esi
  80224c:	53                   	push   %ebx
  80224d:	83 ec 10             	sub    $0x10,%esp
  802250:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	89 04 24             	mov    %eax,(%esp)
  802259:	e8 d2 f1 ff ff       	call   801430 <fd2data>
  80225e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802260:	c7 44 24 04 5e 31 80 	movl   $0x80315e,0x4(%esp)
  802267:	00 
  802268:	89 1c 24             	mov    %ebx,(%esp)
  80226b:	e8 37 ea ff ff       	call   800ca7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802270:	8b 46 04             	mov    0x4(%esi),%eax
  802273:	2b 06                	sub    (%esi),%eax
  802275:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80227b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802282:	00 00 00 
	stat->st_dev = &devpipe;
  802285:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80228c:	40 80 00 
	return 0;
}
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	83 c4 10             	add    $0x10,%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5d                   	pop    %ebp
  80229a:	c3                   	ret    

0080229b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	53                   	push   %ebx
  80229f:	83 ec 14             	sub    $0x14,%esp
  8022a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b0:	e8 07 ef ff ff       	call   8011bc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022b5:	89 1c 24             	mov    %ebx,(%esp)
  8022b8:	e8 73 f1 ff ff       	call   801430 <fd2data>
  8022bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c8:	e8 ef ee ff ff       	call   8011bc <sys_page_unmap>
}
  8022cd:	83 c4 14             	add    $0x14,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    

008022d3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	57                   	push   %edi
  8022d7:	56                   	push   %esi
  8022d8:	53                   	push   %ebx
  8022d9:	83 ec 2c             	sub    $0x2c,%esp
  8022dc:	89 c6                	mov    %eax,%esi
  8022de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8022e1:	a1 18 50 80 00       	mov    0x805018,%eax
  8022e6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022e9:	89 34 24             	mov    %esi,(%esp)
  8022ec:	e8 e6 05 00 00       	call   8028d7 <pageref>
  8022f1:	89 c7                	mov    %eax,%edi
  8022f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f6:	89 04 24             	mov    %eax,(%esp)
  8022f9:	e8 d9 05 00 00       	call   8028d7 <pageref>
  8022fe:	39 c7                	cmp    %eax,%edi
  802300:	0f 94 c2             	sete   %dl
  802303:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802306:	8b 0d 18 50 80 00    	mov    0x805018,%ecx
  80230c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80230f:	39 fb                	cmp    %edi,%ebx
  802311:	74 21                	je     802334 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802313:	84 d2                	test   %dl,%dl
  802315:	74 ca                	je     8022e1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802317:	8b 51 58             	mov    0x58(%ecx),%edx
  80231a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80231e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802322:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802326:	c7 04 24 65 31 80 00 	movl   $0x803165,(%esp)
  80232d:	e8 ff e2 ff ff       	call   800631 <cprintf>
  802332:	eb ad                	jmp    8022e1 <_pipeisclosed+0xe>
	}
}
  802334:	83 c4 2c             	add    $0x2c,%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    

0080233c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	57                   	push   %edi
  802340:	56                   	push   %esi
  802341:	53                   	push   %ebx
  802342:	83 ec 1c             	sub    $0x1c,%esp
  802345:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802348:	89 34 24             	mov    %esi,(%esp)
  80234b:	e8 e0 f0 ff ff       	call   801430 <fd2data>
  802350:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802352:	bf 00 00 00 00       	mov    $0x0,%edi
  802357:	eb 45                	jmp    80239e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802359:	89 da                	mov    %ebx,%edx
  80235b:	89 f0                	mov    %esi,%eax
  80235d:	e8 71 ff ff ff       	call   8022d3 <_pipeisclosed>
  802362:	85 c0                	test   %eax,%eax
  802364:	75 41                	jne    8023a7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802366:	e8 8b ed ff ff       	call   8010f6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80236b:	8b 43 04             	mov    0x4(%ebx),%eax
  80236e:	8b 0b                	mov    (%ebx),%ecx
  802370:	8d 51 20             	lea    0x20(%ecx),%edx
  802373:	39 d0                	cmp    %edx,%eax
  802375:	73 e2                	jae    802359 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80237a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80237e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802381:	99                   	cltd   
  802382:	c1 ea 1b             	shr    $0x1b,%edx
  802385:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802388:	83 e1 1f             	and    $0x1f,%ecx
  80238b:	29 d1                	sub    %edx,%ecx
  80238d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802391:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802395:	83 c0 01             	add    $0x1,%eax
  802398:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80239b:	83 c7 01             	add    $0x1,%edi
  80239e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023a1:	75 c8                	jne    80236b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023a3:	89 f8                	mov    %edi,%eax
  8023a5:	eb 05                	jmp    8023ac <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8023ac:	83 c4 1c             	add    $0x1c,%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    

008023b4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	57                   	push   %edi
  8023b8:	56                   	push   %esi
  8023b9:	53                   	push   %ebx
  8023ba:	83 ec 1c             	sub    $0x1c,%esp
  8023bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023c0:	89 3c 24             	mov    %edi,(%esp)
  8023c3:	e8 68 f0 ff ff       	call   801430 <fd2data>
  8023c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023ca:	be 00 00 00 00       	mov    $0x0,%esi
  8023cf:	eb 3d                	jmp    80240e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023d1:	85 f6                	test   %esi,%esi
  8023d3:	74 04                	je     8023d9 <devpipe_read+0x25>
				return i;
  8023d5:	89 f0                	mov    %esi,%eax
  8023d7:	eb 43                	jmp    80241c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023d9:	89 da                	mov    %ebx,%edx
  8023db:	89 f8                	mov    %edi,%eax
  8023dd:	e8 f1 fe ff ff       	call   8022d3 <_pipeisclosed>
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	75 31                	jne    802417 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023e6:	e8 0b ed ff ff       	call   8010f6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023eb:	8b 03                	mov    (%ebx),%eax
  8023ed:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023f0:	74 df                	je     8023d1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023f2:	99                   	cltd   
  8023f3:	c1 ea 1b             	shr    $0x1b,%edx
  8023f6:	01 d0                	add    %edx,%eax
  8023f8:	83 e0 1f             	and    $0x1f,%eax
  8023fb:	29 d0                	sub    %edx,%eax
  8023fd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802402:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802405:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802408:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80240b:	83 c6 01             	add    $0x1,%esi
  80240e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802411:	75 d8                	jne    8023eb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802413:	89 f0                	mov    %esi,%eax
  802415:	eb 05                	jmp    80241c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80241c:	83 c4 1c             	add    $0x1c,%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5f                   	pop    %edi
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    

00802424 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	56                   	push   %esi
  802428:	53                   	push   %ebx
  802429:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80242c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80242f:	89 04 24             	mov    %eax,(%esp)
  802432:	e8 10 f0 ff ff       	call   801447 <fd_alloc>
  802437:	89 c2                	mov    %eax,%edx
  802439:	85 d2                	test   %edx,%edx
  80243b:	0f 88 4d 01 00 00    	js     80258e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802441:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802448:	00 
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802450:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802457:	e8 b9 ec ff ff       	call   801115 <sys_page_alloc>
  80245c:	89 c2                	mov    %eax,%edx
  80245e:	85 d2                	test   %edx,%edx
  802460:	0f 88 28 01 00 00    	js     80258e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802466:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802469:	89 04 24             	mov    %eax,(%esp)
  80246c:	e8 d6 ef ff ff       	call   801447 <fd_alloc>
  802471:	89 c3                	mov    %eax,%ebx
  802473:	85 c0                	test   %eax,%eax
  802475:	0f 88 fe 00 00 00    	js     802579 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80247b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802482:	00 
  802483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802486:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802491:	e8 7f ec ff ff       	call   801115 <sys_page_alloc>
  802496:	89 c3                	mov    %eax,%ebx
  802498:	85 c0                	test   %eax,%eax
  80249a:	0f 88 d9 00 00 00    	js     802579 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	89 04 24             	mov    %eax,(%esp)
  8024a6:	e8 85 ef ff ff       	call   801430 <fd2data>
  8024ab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ad:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024b4:	00 
  8024b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c0:	e8 50 ec ff ff       	call   801115 <sys_page_alloc>
  8024c5:	89 c3                	mov    %eax,%ebx
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	0f 88 97 00 00 00    	js     802566 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d2:	89 04 24             	mov    %eax,(%esp)
  8024d5:	e8 56 ef ff ff       	call   801430 <fd2data>
  8024da:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024e1:	00 
  8024e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024ed:	00 
  8024ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024f9:	e8 6b ec ff ff       	call   801169 <sys_page_map>
  8024fe:	89 c3                	mov    %eax,%ebx
  802500:	85 c0                	test   %eax,%eax
  802502:	78 52                	js     802556 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802504:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802519:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80251f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802522:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	89 04 24             	mov    %eax,(%esp)
  802534:	e8 e7 ee ff ff       	call   801420 <fd2num>
  802539:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80253c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80253e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802541:	89 04 24             	mov    %eax,(%esp)
  802544:	e8 d7 ee ff ff       	call   801420 <fd2num>
  802549:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80254c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
  802554:	eb 38                	jmp    80258e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802556:	89 74 24 04          	mov    %esi,0x4(%esp)
  80255a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802561:	e8 56 ec ff ff       	call   8011bc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802574:	e8 43 ec ff ff       	call   8011bc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802587:	e8 30 ec ff ff       	call   8011bc <sys_page_unmap>
  80258c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80258e:	83 c4 30             	add    $0x30,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5d                   	pop    %ebp
  802594:	c3                   	ret    

00802595 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80259b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	89 04 24             	mov    %eax,(%esp)
  8025a8:	e8 e9 ee ff ff       	call   801496 <fd_lookup>
  8025ad:	89 c2                	mov    %eax,%edx
  8025af:	85 d2                	test   %edx,%edx
  8025b1:	78 15                	js     8025c8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	89 04 24             	mov    %eax,(%esp)
  8025b9:	e8 72 ee ff ff       	call   801430 <fd2data>
	return _pipeisclosed(fd, p);
  8025be:	89 c2                	mov    %eax,%edx
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	e8 0b fd ff ff       	call   8022d3 <_pipeisclosed>
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    
  8025ca:	66 90                	xchg   %ax,%ax
  8025cc:	66 90                	xchg   %ax,%ax
  8025ce:	66 90                	xchg   %ax,%ax

008025d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	5d                   	pop    %ebp
  8025d9:	c3                   	ret    

008025da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8025e0:	c7 44 24 04 7d 31 80 	movl   $0x80317d,0x4(%esp)
  8025e7:	00 
  8025e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025eb:	89 04 24             	mov    %eax,(%esp)
  8025ee:	e8 b4 e6 ff ff       	call   800ca7 <strcpy>
	return 0;
}
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	57                   	push   %edi
  8025fe:	56                   	push   %esi
  8025ff:	53                   	push   %ebx
  802600:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802606:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80260b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802611:	eb 31                	jmp    802644 <devcons_write+0x4a>
		m = n - tot;
  802613:	8b 75 10             	mov    0x10(%ebp),%esi
  802616:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802618:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80261b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802620:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802623:	89 74 24 08          	mov    %esi,0x8(%esp)
  802627:	03 45 0c             	add    0xc(%ebp),%eax
  80262a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262e:	89 3c 24             	mov    %edi,(%esp)
  802631:	e8 0e e8 ff ff       	call   800e44 <memmove>
		sys_cputs(buf, m);
  802636:	89 74 24 04          	mov    %esi,0x4(%esp)
  80263a:	89 3c 24             	mov    %edi,(%esp)
  80263d:	e8 b4 e9 ff ff       	call   800ff6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802642:	01 f3                	add    %esi,%ebx
  802644:	89 d8                	mov    %ebx,%eax
  802646:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802649:	72 c8                	jb     802613 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80264b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    

00802656 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80265c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802661:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802665:	75 07                	jne    80266e <devcons_read+0x18>
  802667:	eb 2a                	jmp    802693 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802669:	e8 88 ea ff ff       	call   8010f6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80266e:	66 90                	xchg   %ax,%ax
  802670:	e8 9f e9 ff ff       	call   801014 <sys_cgetc>
  802675:	85 c0                	test   %eax,%eax
  802677:	74 f0                	je     802669 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802679:	85 c0                	test   %eax,%eax
  80267b:	78 16                	js     802693 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80267d:	83 f8 04             	cmp    $0x4,%eax
  802680:	74 0c                	je     80268e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802682:	8b 55 0c             	mov    0xc(%ebp),%edx
  802685:	88 02                	mov    %al,(%edx)
	return 1;
  802687:	b8 01 00 00 00       	mov    $0x1,%eax
  80268c:	eb 05                	jmp    802693 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80268e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8026a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8026a8:	00 
  8026a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026ac:	89 04 24             	mov    %eax,(%esp)
  8026af:	e8 42 e9 ff ff       	call   800ff6 <sys_cputs>
}
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <getchar>:

int
getchar(void)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
  8026b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026c3:	00 
  8026c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d2:	e8 53 f0 ff ff       	call   80172a <read>
	if (r < 0)
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	78 0f                	js     8026ea <getchar+0x34>
		return r;
	if (r < 1)
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	7e 06                	jle    8026e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8026df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8026e3:	eb 05                	jmp    8026ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8026e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fc:	89 04 24             	mov    %eax,(%esp)
  8026ff:	e8 92 ed ff ff       	call   801496 <fd_lookup>
  802704:	85 c0                	test   %eax,%eax
  802706:	78 11                	js     802719 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802711:	39 10                	cmp    %edx,(%eax)
  802713:	0f 94 c0             	sete   %al
  802716:	0f b6 c0             	movzbl %al,%eax
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <opencons>:

int
opencons(void)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802721:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802724:	89 04 24             	mov    %eax,(%esp)
  802727:	e8 1b ed ff ff       	call   801447 <fd_alloc>
		return r;
  80272c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80272e:	85 c0                	test   %eax,%eax
  802730:	78 40                	js     802772 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802732:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802739:	00 
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802741:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802748:	e8 c8 e9 ff ff       	call   801115 <sys_page_alloc>
		return r;
  80274d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80274f:	85 c0                	test   %eax,%eax
  802751:	78 1f                	js     802772 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802753:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802768:	89 04 24             	mov    %eax,(%esp)
  80276b:	e8 b0 ec ff ff       	call   801420 <fd2num>
  802770:	89 c2                	mov    %eax,%edx
}
  802772:	89 d0                	mov    %edx,%eax
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	56                   	push   %esi
  80277a:	53                   	push   %ebx
  80277b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80277e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802781:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802787:	e8 4b e9 ff ff       	call   8010d7 <sys_getenvid>
  80278c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802793:	8b 55 08             	mov    0x8(%ebp),%edx
  802796:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80279a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80279e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a2:	c7 04 24 8c 31 80 00 	movl   $0x80318c,(%esp)
  8027a9:	e8 83 de ff ff       	call   800631 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8027b5:	89 04 24             	mov    %eax,(%esp)
  8027b8:	e8 13 de ff ff       	call   8005d0 <vcprintf>
	cprintf("\n");
  8027bd:	c7 04 24 23 31 80 00 	movl   $0x803123,(%esp)
  8027c4:	e8 68 de ff ff       	call   800631 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027c9:	cc                   	int3   
  8027ca:	eb fd                	jmp    8027c9 <_panic+0x53>
  8027cc:	66 90                	xchg   %ax,%ax
  8027ce:	66 90                	xchg   %ax,%ax

008027d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	56                   	push   %esi
  8027d4:	53                   	push   %ebx
  8027d5:	83 ec 10             	sub    $0x10,%esp
  8027d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8027db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8027e1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8027e3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8027e8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027eb:	89 04 24             	mov    %eax,(%esp)
  8027ee:	e8 58 eb ff ff       	call   80134b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	75 26                	jne    80281d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8027f7:	85 f6                	test   %esi,%esi
  8027f9:	74 0a                	je     802805 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8027fb:	a1 18 50 80 00       	mov    0x805018,%eax
  802800:	8b 40 74             	mov    0x74(%eax),%eax
  802803:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802805:	85 db                	test   %ebx,%ebx
  802807:	74 0a                	je     802813 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802809:	a1 18 50 80 00       	mov    0x805018,%eax
  80280e:	8b 40 78             	mov    0x78(%eax),%eax
  802811:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802813:	a1 18 50 80 00       	mov    0x805018,%eax
  802818:	8b 40 70             	mov    0x70(%eax),%eax
  80281b:	eb 14                	jmp    802831 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80281d:	85 f6                	test   %esi,%esi
  80281f:	74 06                	je     802827 <ipc_recv+0x57>
			*from_env_store = 0;
  802821:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802827:	85 db                	test   %ebx,%ebx
  802829:	74 06                	je     802831 <ipc_recv+0x61>
			*perm_store = 0;
  80282b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802831:	83 c4 10             	add    $0x10,%esp
  802834:	5b                   	pop    %ebx
  802835:	5e                   	pop    %esi
  802836:	5d                   	pop    %ebp
  802837:	c3                   	ret    

00802838 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	57                   	push   %edi
  80283c:	56                   	push   %esi
  80283d:	53                   	push   %ebx
  80283e:	83 ec 1c             	sub    $0x1c,%esp
  802841:	8b 7d 08             	mov    0x8(%ebp),%edi
  802844:	8b 75 0c             	mov    0xc(%ebp),%esi
  802847:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80284a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80284c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802851:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802854:	8b 45 14             	mov    0x14(%ebp),%eax
  802857:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80285b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80285f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802863:	89 3c 24             	mov    %edi,(%esp)
  802866:	e8 bd ea ff ff       	call   801328 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 28                	je     802897 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80286f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802872:	74 1c                	je     802890 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802874:	c7 44 24 08 b0 31 80 	movl   $0x8031b0,0x8(%esp)
  80287b:	00 
  80287c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802883:	00 
  802884:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  80288b:	e8 e6 fe ff ff       	call   802776 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802890:	e8 61 e8 ff ff       	call   8010f6 <sys_yield>
	}
  802895:	eb bd                	jmp    802854 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802897:	83 c4 1c             	add    $0x1c,%esp
  80289a:	5b                   	pop    %ebx
  80289b:	5e                   	pop    %esi
  80289c:	5f                   	pop    %edi
  80289d:	5d                   	pop    %ebp
  80289e:	c3                   	ret    

0080289f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028aa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8028ad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028b3:	8b 52 50             	mov    0x50(%edx),%edx
  8028b6:	39 ca                	cmp    %ecx,%edx
  8028b8:	75 0d                	jne    8028c7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8028ba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8028bd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8028c2:	8b 40 40             	mov    0x40(%eax),%eax
  8028c5:	eb 0e                	jmp    8028d5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028c7:	83 c0 01             	add    $0x1,%eax
  8028ca:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028cf:	75 d9                	jne    8028aa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8028d1:	66 b8 00 00          	mov    $0x0,%ax
}
  8028d5:	5d                   	pop    %ebp
  8028d6:	c3                   	ret    

008028d7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028dd:	89 d0                	mov    %edx,%eax
  8028df:	c1 e8 16             	shr    $0x16,%eax
  8028e2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028e9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028ee:	f6 c1 01             	test   $0x1,%cl
  8028f1:	74 1d                	je     802910 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8028f3:	c1 ea 0c             	shr    $0xc,%edx
  8028f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028fd:	f6 c2 01             	test   $0x1,%dl
  802900:	74 0e                	je     802910 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802902:	c1 ea 0c             	shr    $0xc,%edx
  802905:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80290c:	ef 
  80290d:	0f b7 c0             	movzwl %ax,%eax
}
  802910:	5d                   	pop    %ebp
  802911:	c3                   	ret    
  802912:	66 90                	xchg   %ax,%ax
  802914:	66 90                	xchg   %ax,%ax
  802916:	66 90                	xchg   %ax,%ax
  802918:	66 90                	xchg   %ax,%ax
  80291a:	66 90                	xchg   %ax,%ax
  80291c:	66 90                	xchg   %ax,%ax
  80291e:	66 90                	xchg   %ax,%ax

00802920 <__udivdi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	83 ec 0c             	sub    $0xc,%esp
  802926:	8b 44 24 28          	mov    0x28(%esp),%eax
  80292a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80292e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802932:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802936:	85 c0                	test   %eax,%eax
  802938:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80293c:	89 ea                	mov    %ebp,%edx
  80293e:	89 0c 24             	mov    %ecx,(%esp)
  802941:	75 2d                	jne    802970 <__udivdi3+0x50>
  802943:	39 e9                	cmp    %ebp,%ecx
  802945:	77 61                	ja     8029a8 <__udivdi3+0x88>
  802947:	85 c9                	test   %ecx,%ecx
  802949:	89 ce                	mov    %ecx,%esi
  80294b:	75 0b                	jne    802958 <__udivdi3+0x38>
  80294d:	b8 01 00 00 00       	mov    $0x1,%eax
  802952:	31 d2                	xor    %edx,%edx
  802954:	f7 f1                	div    %ecx
  802956:	89 c6                	mov    %eax,%esi
  802958:	31 d2                	xor    %edx,%edx
  80295a:	89 e8                	mov    %ebp,%eax
  80295c:	f7 f6                	div    %esi
  80295e:	89 c5                	mov    %eax,%ebp
  802960:	89 f8                	mov    %edi,%eax
  802962:	f7 f6                	div    %esi
  802964:	89 ea                	mov    %ebp,%edx
  802966:	83 c4 0c             	add    $0xc,%esp
  802969:	5e                   	pop    %esi
  80296a:	5f                   	pop    %edi
  80296b:	5d                   	pop    %ebp
  80296c:	c3                   	ret    
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	39 e8                	cmp    %ebp,%eax
  802972:	77 24                	ja     802998 <__udivdi3+0x78>
  802974:	0f bd e8             	bsr    %eax,%ebp
  802977:	83 f5 1f             	xor    $0x1f,%ebp
  80297a:	75 3c                	jne    8029b8 <__udivdi3+0x98>
  80297c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802980:	39 34 24             	cmp    %esi,(%esp)
  802983:	0f 86 9f 00 00 00    	jbe    802a28 <__udivdi3+0x108>
  802989:	39 d0                	cmp    %edx,%eax
  80298b:	0f 82 97 00 00 00    	jb     802a28 <__udivdi3+0x108>
  802991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802998:	31 d2                	xor    %edx,%edx
  80299a:	31 c0                	xor    %eax,%eax
  80299c:	83 c4 0c             	add    $0xc,%esp
  80299f:	5e                   	pop    %esi
  8029a0:	5f                   	pop    %edi
  8029a1:	5d                   	pop    %ebp
  8029a2:	c3                   	ret    
  8029a3:	90                   	nop
  8029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	89 f8                	mov    %edi,%eax
  8029aa:	f7 f1                	div    %ecx
  8029ac:	31 d2                	xor    %edx,%edx
  8029ae:	83 c4 0c             	add    $0xc,%esp
  8029b1:	5e                   	pop    %esi
  8029b2:	5f                   	pop    %edi
  8029b3:	5d                   	pop    %ebp
  8029b4:	c3                   	ret    
  8029b5:	8d 76 00             	lea    0x0(%esi),%esi
  8029b8:	89 e9                	mov    %ebp,%ecx
  8029ba:	8b 3c 24             	mov    (%esp),%edi
  8029bd:	d3 e0                	shl    %cl,%eax
  8029bf:	89 c6                	mov    %eax,%esi
  8029c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8029c6:	29 e8                	sub    %ebp,%eax
  8029c8:	89 c1                	mov    %eax,%ecx
  8029ca:	d3 ef                	shr    %cl,%edi
  8029cc:	89 e9                	mov    %ebp,%ecx
  8029ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029d2:	8b 3c 24             	mov    (%esp),%edi
  8029d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8029d9:	89 d6                	mov    %edx,%esi
  8029db:	d3 e7                	shl    %cl,%edi
  8029dd:	89 c1                	mov    %eax,%ecx
  8029df:	89 3c 24             	mov    %edi,(%esp)
  8029e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029e6:	d3 ee                	shr    %cl,%esi
  8029e8:	89 e9                	mov    %ebp,%ecx
  8029ea:	d3 e2                	shl    %cl,%edx
  8029ec:	89 c1                	mov    %eax,%ecx
  8029ee:	d3 ef                	shr    %cl,%edi
  8029f0:	09 d7                	or     %edx,%edi
  8029f2:	89 f2                	mov    %esi,%edx
  8029f4:	89 f8                	mov    %edi,%eax
  8029f6:	f7 74 24 08          	divl   0x8(%esp)
  8029fa:	89 d6                	mov    %edx,%esi
  8029fc:	89 c7                	mov    %eax,%edi
  8029fe:	f7 24 24             	mull   (%esp)
  802a01:	39 d6                	cmp    %edx,%esi
  802a03:	89 14 24             	mov    %edx,(%esp)
  802a06:	72 30                	jb     802a38 <__udivdi3+0x118>
  802a08:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a0c:	89 e9                	mov    %ebp,%ecx
  802a0e:	d3 e2                	shl    %cl,%edx
  802a10:	39 c2                	cmp    %eax,%edx
  802a12:	73 05                	jae    802a19 <__udivdi3+0xf9>
  802a14:	3b 34 24             	cmp    (%esp),%esi
  802a17:	74 1f                	je     802a38 <__udivdi3+0x118>
  802a19:	89 f8                	mov    %edi,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	e9 7a ff ff ff       	jmp    80299c <__udivdi3+0x7c>
  802a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a28:	31 d2                	xor    %edx,%edx
  802a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a2f:	e9 68 ff ff ff       	jmp    80299c <__udivdi3+0x7c>
  802a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a38:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	83 c4 0c             	add    $0xc,%esp
  802a40:	5e                   	pop    %esi
  802a41:	5f                   	pop    %edi
  802a42:	5d                   	pop    %ebp
  802a43:	c3                   	ret    
  802a44:	66 90                	xchg   %ax,%ax
  802a46:	66 90                	xchg   %ax,%ax
  802a48:	66 90                	xchg   %ax,%ax
  802a4a:	66 90                	xchg   %ax,%ax
  802a4c:	66 90                	xchg   %ax,%ax
  802a4e:	66 90                	xchg   %ax,%ax

00802a50 <__umoddi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	83 ec 14             	sub    $0x14,%esp
  802a56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a5a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a5e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a62:	89 c7                	mov    %eax,%edi
  802a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a68:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a6c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a70:	89 34 24             	mov    %esi,(%esp)
  802a73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a77:	85 c0                	test   %eax,%eax
  802a79:	89 c2                	mov    %eax,%edx
  802a7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a7f:	75 17                	jne    802a98 <__umoddi3+0x48>
  802a81:	39 fe                	cmp    %edi,%esi
  802a83:	76 4b                	jbe    802ad0 <__umoddi3+0x80>
  802a85:	89 c8                	mov    %ecx,%eax
  802a87:	89 fa                	mov    %edi,%edx
  802a89:	f7 f6                	div    %esi
  802a8b:	89 d0                	mov    %edx,%eax
  802a8d:	31 d2                	xor    %edx,%edx
  802a8f:	83 c4 14             	add    $0x14,%esp
  802a92:	5e                   	pop    %esi
  802a93:	5f                   	pop    %edi
  802a94:	5d                   	pop    %ebp
  802a95:	c3                   	ret    
  802a96:	66 90                	xchg   %ax,%ax
  802a98:	39 f8                	cmp    %edi,%eax
  802a9a:	77 54                	ja     802af0 <__umoddi3+0xa0>
  802a9c:	0f bd e8             	bsr    %eax,%ebp
  802a9f:	83 f5 1f             	xor    $0x1f,%ebp
  802aa2:	75 5c                	jne    802b00 <__umoddi3+0xb0>
  802aa4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802aa8:	39 3c 24             	cmp    %edi,(%esp)
  802aab:	0f 87 e7 00 00 00    	ja     802b98 <__umoddi3+0x148>
  802ab1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ab5:	29 f1                	sub    %esi,%ecx
  802ab7:	19 c7                	sbb    %eax,%edi
  802ab9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802abd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ac1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ac5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ac9:	83 c4 14             	add    $0x14,%esp
  802acc:	5e                   	pop    %esi
  802acd:	5f                   	pop    %edi
  802ace:	5d                   	pop    %ebp
  802acf:	c3                   	ret    
  802ad0:	85 f6                	test   %esi,%esi
  802ad2:	89 f5                	mov    %esi,%ebp
  802ad4:	75 0b                	jne    802ae1 <__umoddi3+0x91>
  802ad6:	b8 01 00 00 00       	mov    $0x1,%eax
  802adb:	31 d2                	xor    %edx,%edx
  802add:	f7 f6                	div    %esi
  802adf:	89 c5                	mov    %eax,%ebp
  802ae1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ae5:	31 d2                	xor    %edx,%edx
  802ae7:	f7 f5                	div    %ebp
  802ae9:	89 c8                	mov    %ecx,%eax
  802aeb:	f7 f5                	div    %ebp
  802aed:	eb 9c                	jmp    802a8b <__umoddi3+0x3b>
  802aef:	90                   	nop
  802af0:	89 c8                	mov    %ecx,%eax
  802af2:	89 fa                	mov    %edi,%edx
  802af4:	83 c4 14             	add    $0x14,%esp
  802af7:	5e                   	pop    %esi
  802af8:	5f                   	pop    %edi
  802af9:	5d                   	pop    %ebp
  802afa:	c3                   	ret    
  802afb:	90                   	nop
  802afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b00:	8b 04 24             	mov    (%esp),%eax
  802b03:	be 20 00 00 00       	mov    $0x20,%esi
  802b08:	89 e9                	mov    %ebp,%ecx
  802b0a:	29 ee                	sub    %ebp,%esi
  802b0c:	d3 e2                	shl    %cl,%edx
  802b0e:	89 f1                	mov    %esi,%ecx
  802b10:	d3 e8                	shr    %cl,%eax
  802b12:	89 e9                	mov    %ebp,%ecx
  802b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b18:	8b 04 24             	mov    (%esp),%eax
  802b1b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b1f:	89 fa                	mov    %edi,%edx
  802b21:	d3 e0                	shl    %cl,%eax
  802b23:	89 f1                	mov    %esi,%ecx
  802b25:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b29:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b2d:	d3 ea                	shr    %cl,%edx
  802b2f:	89 e9                	mov    %ebp,%ecx
  802b31:	d3 e7                	shl    %cl,%edi
  802b33:	89 f1                	mov    %esi,%ecx
  802b35:	d3 e8                	shr    %cl,%eax
  802b37:	89 e9                	mov    %ebp,%ecx
  802b39:	09 f8                	or     %edi,%eax
  802b3b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b3f:	f7 74 24 04          	divl   0x4(%esp)
  802b43:	d3 e7                	shl    %cl,%edi
  802b45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b49:	89 d7                	mov    %edx,%edi
  802b4b:	f7 64 24 08          	mull   0x8(%esp)
  802b4f:	39 d7                	cmp    %edx,%edi
  802b51:	89 c1                	mov    %eax,%ecx
  802b53:	89 14 24             	mov    %edx,(%esp)
  802b56:	72 2c                	jb     802b84 <__umoddi3+0x134>
  802b58:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b5c:	72 22                	jb     802b80 <__umoddi3+0x130>
  802b5e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b62:	29 c8                	sub    %ecx,%eax
  802b64:	19 d7                	sbb    %edx,%edi
  802b66:	89 e9                	mov    %ebp,%ecx
  802b68:	89 fa                	mov    %edi,%edx
  802b6a:	d3 e8                	shr    %cl,%eax
  802b6c:	89 f1                	mov    %esi,%ecx
  802b6e:	d3 e2                	shl    %cl,%edx
  802b70:	89 e9                	mov    %ebp,%ecx
  802b72:	d3 ef                	shr    %cl,%edi
  802b74:	09 d0                	or     %edx,%eax
  802b76:	89 fa                	mov    %edi,%edx
  802b78:	83 c4 14             	add    $0x14,%esp
  802b7b:	5e                   	pop    %esi
  802b7c:	5f                   	pop    %edi
  802b7d:	5d                   	pop    %ebp
  802b7e:	c3                   	ret    
  802b7f:	90                   	nop
  802b80:	39 d7                	cmp    %edx,%edi
  802b82:	75 da                	jne    802b5e <__umoddi3+0x10e>
  802b84:	8b 14 24             	mov    (%esp),%edx
  802b87:	89 c1                	mov    %eax,%ecx
  802b89:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b8d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b91:	eb cb                	jmp    802b5e <__umoddi3+0x10e>
  802b93:	90                   	nop
  802b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b98:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b9c:	0f 82 0f ff ff ff    	jb     802ab1 <__umoddi3+0x61>
  802ba2:	e9 1a ff ff ff       	jmp    802ac1 <__umoddi3+0x71>
