
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 dc 04 00 00       	call   80050d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003d:	c7 04 24 95 30 80 00 	movl   $0x803095,(%esp)
  800044:	e8 c8 05 00 00       	call   800611 <cprintf>
	exit();
  800049:	e8 07 05 00 00       	call   800555 <exit>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <umain>:

void umain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	57                   	push   %edi
  800054:	56                   	push   %esi
  800055:	53                   	push   %ebx
  800056:	83 ec 5c             	sub    $0x5c,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  800059:	c7 04 24 a0 2b 80 00 	movl   $0x802ba0,(%esp)
  800060:	e8 ac 05 00 00       	call   800611 <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800065:	c7 04 24 b0 2b 80 00 	movl   $0x802bb0,(%esp)
  80006c:	e8 64 04 00 00       	call   8004d5 <inet_addr>
  800071:	89 44 24 08          	mov    %eax,0x8(%esp)
  800075:	c7 44 24 04 b0 2b 80 	movl   $0x802bb0,0x4(%esp)
  80007c:	00 
  80007d:	c7 04 24 ba 2b 80 00 	movl   $0x802bba,(%esp)
  800084:	e8 88 05 00 00       	call   800611 <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800089:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800090:	00 
  800091:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800098:	00 
  800099:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8000a0:	e8 a2 1e 00 00       	call   801f47 <socket>
  8000a5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000a8:	85 c0                	test   %eax,%eax
  8000aa:	79 0a                	jns    8000b6 <umain+0x66>
		die("Failed to create socket");
  8000ac:	b8 cf 2b 80 00       	mov    $0x802bcf,%eax
  8000b1:	e8 7d ff ff ff       	call   800033 <die>

	cprintf("opened socket\n");
  8000b6:	c7 04 24 e7 2b 80 00 	movl   $0x802be7,(%esp)
  8000bd:	e8 4f 05 00 00       	call   800611 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000c2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8000c9:	00 
  8000ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000d1:	00 
  8000d2:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000d5:	89 1c 24             	mov    %ebx,(%esp)
  8000d8:	e8 fa 0c 00 00       	call   800dd7 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000dd:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000e1:	c7 04 24 b0 2b 80 00 	movl   $0x802bb0,(%esp)
  8000e8:	e8 e8 03 00 00       	call   8004d5 <inet_addr>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000f0:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000f7:	e8 aa 01 00 00       	call   8002a6 <htons>
  8000fc:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  800100:	c7 04 24 f6 2b 80 00 	movl   $0x802bf6,(%esp)
  800107:	e8 05 05 00 00       	call   800611 <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  80010c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800113:	00 
  800114:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800118:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80011b:	89 04 24             	mov    %eax,(%esp)
  80011e:	e8 d3 1d 00 00       	call   801ef6 <connect>
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0a                	jns    800131 <umain+0xe1>
		die("Failed to connect with server");
  800127:	b8 13 2c 80 00       	mov    $0x802c13,%eax
  80012c:	e8 02 ff ff ff       	call   800033 <die>

	cprintf("connected to server\n");
  800131:	c7 04 24 31 2c 80 00 	movl   $0x802c31,(%esp)
  800138:	e8 d4 04 00 00       	call   800611 <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80013d:	a1 00 40 80 00       	mov    0x804000,%eax
  800142:	89 04 24             	mov    %eax,(%esp)
  800145:	e8 06 0b 00 00       	call   800c50 <strlen>
  80014a:	89 c7                	mov    %eax,%edi
  80014c:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80014f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800153:	a1 00 40 80 00       	mov    0x804000,%eax
  800158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80015f:	89 04 24             	mov    %eax,(%esp)
  800162:	e8 80 16 00 00       	call   8017e7 <write>
  800167:	39 f8                	cmp    %edi,%eax
  800169:	74 0a                	je     800175 <umain+0x125>
		die("Mismatch in number of sent bytes");
  80016b:	b8 60 2c 80 00       	mov    $0x802c60,%eax
  800170:	e8 be fe ff ff       	call   800033 <die>

	// Receive the word back from the server
	cprintf("Received: \n");
  800175:	c7 04 24 46 2c 80 00 	movl   $0x802c46,(%esp)
  80017c:	e8 90 04 00 00       	call   800611 <cprintf>
{
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  800181:	be 00 00 00 00       	mov    $0x0,%esi

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800186:	8d 7d b8             	lea    -0x48(%ebp),%edi
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  800189:	eb 36                	jmp    8001c1 <umain+0x171>
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018b:	c7 44 24 08 1f 00 00 	movl   $0x1f,0x8(%esp)
  800192:	00 
  800193:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800197:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80019a:	89 04 24             	mov    %eax,(%esp)
  80019d:	e8 68 15 00 00       	call   80170a <read>
  8001a2:	89 c3                	mov    %eax,%ebx
  8001a4:	85 c0                	test   %eax,%eax
  8001a6:	7f 0a                	jg     8001b2 <umain+0x162>
			die("Failed to receive bytes from server");
  8001a8:	b8 84 2c 80 00       	mov    $0x802c84,%eax
  8001ad:	e8 81 fe ff ff       	call   800033 <die>
		}
		received += bytes;
  8001b2:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  8001b4:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  8001b9:	89 3c 24             	mov    %edi,(%esp)
  8001bc:	e8 50 04 00 00       	call   800611 <cprintf>
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8001c1:	39 75 b0             	cmp    %esi,-0x50(%ebp)
  8001c4:	77 c5                	ja     80018b <umain+0x13b>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8001c6:	c7 04 24 50 2c 80 00 	movl   $0x802c50,(%esp)
  8001cd:	e8 3f 04 00 00       	call   800611 <cprintf>

	close(sock);
  8001d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 ca 13 00 00       	call   8015a7 <close>
}
  8001dd:	83 c4 5c             	add    $0x5c,%esp
  8001e0:	5b                   	pop    %ebx
  8001e1:	5e                   	pop    %esi
  8001e2:	5f                   	pop    %edi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    
  8001e5:	66 90                	xchg   %ax,%ax
  8001e7:	66 90                	xchg   %ax,%ax
  8001e9:	66 90                	xchg   %ax,%ax
  8001eb:	66 90                	xchg   %ax,%ax
  8001ed:	66 90                	xchg   %ax,%ax
  8001ef:	90                   	nop

008001f0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001ff:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800203:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800206:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80020d:	be 00 00 00 00       	mov    $0x0,%esi
  800212:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800215:	eb 02                	jmp    800219 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800217:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800219:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80021c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80021f:	0f b6 c2             	movzbl %dl,%eax
  800222:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800225:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800228:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80022b:	66 c1 e8 0b          	shr    $0xb,%ax
  80022f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800231:	8d 4e 01             	lea    0x1(%esi),%ecx
  800234:	89 f3                	mov    %esi,%ebx
  800236:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800239:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80023c:	01 ff                	add    %edi,%edi
  80023e:	89 fb                	mov    %edi,%ebx
  800240:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800242:	83 c2 30             	add    $0x30,%edx
  800245:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800249:	84 c0                	test   %al,%al
  80024b:	75 ca                	jne    800217 <inet_ntoa+0x27>
  80024d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800250:	89 c8                	mov    %ecx,%eax
  800252:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800255:	89 cf                	mov    %ecx,%edi
  800257:	eb 0d                	jmp    800266 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800259:	0f b6 f0             	movzbl %al,%esi
  80025c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800261:	88 0a                	mov    %cl,(%edx)
  800263:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800266:	83 e8 01             	sub    $0x1,%eax
  800269:	3c ff                	cmp    $0xff,%al
  80026b:	75 ec                	jne    800259 <inet_ntoa+0x69>
  80026d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800270:	89 f9                	mov    %edi,%ecx
  800272:	0f b6 c9             	movzbl %cl,%ecx
  800275:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800278:	8d 41 01             	lea    0x1(%ecx),%eax
  80027b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80027e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800282:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  800286:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  80028a:	77 0a                	ja     800296 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80028c:	c6 01 2e             	movb   $0x2e,(%ecx)
  80028f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800294:	eb 81                	jmp    800217 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  800296:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  800299:	b8 00 50 80 00       	mov    $0x805000,%eax
  80029e:	83 c4 19             	add    $0x19,%esp
  8002a1:	5b                   	pop    %ebx
  8002a2:	5e                   	pop    %esi
  8002a3:	5f                   	pop    %edi
  8002a4:	5d                   	pop    %ebp
  8002a5:	c3                   	ret    

008002a6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002a9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002ad:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002b1:	5d                   	pop    %ebp
  8002b2:	c3                   	ret    

008002b3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002b6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002ba:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002c6:	89 d1                	mov    %edx,%ecx
  8002c8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002cb:	89 d0                	mov    %edx,%eax
  8002cd:	c1 e0 18             	shl    $0x18,%eax
  8002d0:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002d2:	89 d1                	mov    %edx,%ecx
  8002d4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8002da:	c1 e1 08             	shl    $0x8,%ecx
  8002dd:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  8002df:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8002e5:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002e8:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8002ea:	5d                   	pop    %ebp
  8002eb:	c3                   	ret    

008002ec <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	57                   	push   %edi
  8002f0:	56                   	push   %esi
  8002f1:	53                   	push   %ebx
  8002f2:	83 ec 20             	sub    $0x20,%esp
  8002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  8002f8:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8002fb:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8002fe:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800301:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800304:	80 f9 09             	cmp    $0x9,%cl
  800307:	0f 87 a6 01 00 00    	ja     8004b3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80030d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800314:	83 fa 30             	cmp    $0x30,%edx
  800317:	75 2b                	jne    800344 <inet_aton+0x58>
      c = *++cp;
  800319:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80031d:	89 d1                	mov    %edx,%ecx
  80031f:	83 e1 df             	and    $0xffffffdf,%ecx
  800322:	80 f9 58             	cmp    $0x58,%cl
  800325:	74 0f                	je     800336 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800327:	83 c0 01             	add    $0x1,%eax
  80032a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80032d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800334:	eb 0e                	jmp    800344 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800336:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80033a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80033d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800344:	83 c0 01             	add    $0x1,%eax
  800347:	bf 00 00 00 00       	mov    $0x0,%edi
  80034c:	eb 03                	jmp    800351 <inet_aton+0x65>
  80034e:	83 c0 01             	add    $0x1,%eax
  800351:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800354:	89 d3                	mov    %edx,%ebx
  800356:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800359:	80 f9 09             	cmp    $0x9,%cl
  80035c:	77 0d                	ja     80036b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80035e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800362:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800366:	0f be 10             	movsbl (%eax),%edx
  800369:	eb e3                	jmp    80034e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80036b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80036f:	75 30                	jne    8003a1 <inet_aton+0xb5>
  800371:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800374:	88 4d df             	mov    %cl,-0x21(%ebp)
  800377:	89 d1                	mov    %edx,%ecx
  800379:	83 e1 df             	and    $0xffffffdf,%ecx
  80037c:	83 e9 41             	sub    $0x41,%ecx
  80037f:	80 f9 05             	cmp    $0x5,%cl
  800382:	77 23                	ja     8003a7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800384:	89 fb                	mov    %edi,%ebx
  800386:	c1 e3 04             	shl    $0x4,%ebx
  800389:	8d 7a 0a             	lea    0xa(%edx),%edi
  80038c:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  800390:	19 c9                	sbb    %ecx,%ecx
  800392:	83 e1 20             	and    $0x20,%ecx
  800395:	83 c1 41             	add    $0x41,%ecx
  800398:	29 cf                	sub    %ecx,%edi
  80039a:	09 df                	or     %ebx,%edi
        c = *++cp;
  80039c:	0f be 10             	movsbl (%eax),%edx
  80039f:	eb ad                	jmp    80034e <inet_aton+0x62>
  8003a1:	89 d0                	mov    %edx,%eax
  8003a3:	89 f9                	mov    %edi,%ecx
  8003a5:	eb 04                	jmp    8003ab <inet_aton+0xbf>
  8003a7:	89 d0                	mov    %edx,%eax
  8003a9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8003ab:	83 f8 2e             	cmp    $0x2e,%eax
  8003ae:	75 22                	jne    8003d2 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8003b3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8003b6:	0f 84 fe 00 00 00    	je     8004ba <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8003bc:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8003c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8003c6:	8d 46 01             	lea    0x1(%esi),%eax
  8003c9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8003cd:	e9 2f ff ff ff       	jmp    800301 <inet_aton+0x15>
  8003d2:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003d4:	85 d2                	test   %edx,%edx
  8003d6:	74 27                	je     8003ff <inet_aton+0x113>
    return (0);
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003dd:	80 fb 1f             	cmp    $0x1f,%bl
  8003e0:	0f 86 e7 00 00 00    	jbe    8004cd <inet_aton+0x1e1>
  8003e6:	84 d2                	test   %dl,%dl
  8003e8:	0f 88 d3 00 00 00    	js     8004c1 <inet_aton+0x1d5>
  8003ee:	83 fa 20             	cmp    $0x20,%edx
  8003f1:	74 0c                	je     8003ff <inet_aton+0x113>
  8003f3:	83 ea 09             	sub    $0x9,%edx
  8003f6:	83 fa 04             	cmp    $0x4,%edx
  8003f9:	0f 87 ce 00 00 00    	ja     8004cd <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8003ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800402:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800405:	29 c2                	sub    %eax,%edx
  800407:	c1 fa 02             	sar    $0x2,%edx
  80040a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80040d:	83 fa 02             	cmp    $0x2,%edx
  800410:	74 22                	je     800434 <inet_aton+0x148>
  800412:	83 fa 02             	cmp    $0x2,%edx
  800415:	7f 0f                	jg     800426 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800417:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80041c:	85 d2                	test   %edx,%edx
  80041e:	0f 84 a9 00 00 00    	je     8004cd <inet_aton+0x1e1>
  800424:	eb 73                	jmp    800499 <inet_aton+0x1ad>
  800426:	83 fa 03             	cmp    $0x3,%edx
  800429:	74 26                	je     800451 <inet_aton+0x165>
  80042b:	83 fa 04             	cmp    $0x4,%edx
  80042e:	66 90                	xchg   %ax,%ax
  800430:	74 40                	je     800472 <inet_aton+0x186>
  800432:	eb 65                	jmp    800499 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800434:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800439:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80043f:	0f 87 88 00 00 00    	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800448:	c1 e0 18             	shl    $0x18,%eax
  80044b:	89 cf                	mov    %ecx,%edi
  80044d:	09 c7                	or     %eax,%edi
    break;
  80044f:	eb 48                	jmp    800499 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800456:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80045c:	77 6f                	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80045e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800461:	c1 e2 10             	shl    $0x10,%edx
  800464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800467:	c1 e0 18             	shl    $0x18,%eax
  80046a:	09 d0                	or     %edx,%eax
  80046c:	09 c8                	or     %ecx,%eax
  80046e:	89 c7                	mov    %eax,%edi
    break;
  800470:	eb 27                	jmp    800499 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800477:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80047d:	77 4e                	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80047f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800482:	c1 e2 10             	shl    $0x10,%edx
  800485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800488:	c1 e0 18             	shl    $0x18,%eax
  80048b:	09 c2                	or     %eax,%edx
  80048d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800490:	c1 e0 08             	shl    $0x8,%eax
  800493:	09 d0                	or     %edx,%eax
  800495:	09 c8                	or     %ecx,%eax
  800497:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  800499:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049d:	74 29                	je     8004c8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  80049f:	89 3c 24             	mov    %edi,(%esp)
  8004a2:	e8 19 fe ff ff       	call   8002c0 <htonl>
  8004a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004aa:	89 06                	mov    %eax,(%esi)
  return (1);
  8004ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8004b1:	eb 1a                	jmp    8004cd <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	eb 13                	jmp    8004cd <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8004ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bf:	eb 0c                	jmp    8004cd <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c6:	eb 05                	jmp    8004cd <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8004c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004cd:	83 c4 20             	add    $0x20,%esp
  8004d0:	5b                   	pop    %ebx
  8004d1:	5e                   	pop    %esi
  8004d2:	5f                   	pop    %edi
  8004d3:	5d                   	pop    %ebp
  8004d4:	c3                   	ret    

008004d5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	89 04 24             	mov    %eax,(%esp)
  8004e8:	e8 ff fd ff ff       	call   8002ec <inet_aton>
  8004ed:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  8004ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004f4:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	89 04 24             	mov    %eax,(%esp)
  800506:	e8 b5 fd ff ff       	call   8002c0 <htonl>
}
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	56                   	push   %esi
  800511:	53                   	push   %ebx
  800512:	83 ec 10             	sub    $0x10,%esp
  800515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800518:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80051b:	e8 97 0b 00 00       	call   8010b7 <sys_getenvid>
  800520:	25 ff 03 00 00       	and    $0x3ff,%eax
  800525:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800528:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80052d:	a3 18 50 80 00       	mov    %eax,0x805018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800532:	85 db                	test   %ebx,%ebx
  800534:	7e 07                	jle    80053d <libmain+0x30>
		binaryname = argv[0];
  800536:	8b 06                	mov    (%esi),%eax
  800538:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  80053d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800541:	89 1c 24             	mov    %ebx,(%esp)
  800544:	e8 07 fb ff ff       	call   800050 <umain>

	// exit gracefully
	exit();
  800549:	e8 07 00 00 00       	call   800555 <exit>
}
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	5b                   	pop    %ebx
  800552:	5e                   	pop    %esi
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80055b:	e8 7a 10 00 00       	call   8015da <close_all>
	sys_env_destroy(0);
  800560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800567:	e8 a7 0a 00 00       	call   801013 <sys_env_destroy>
}
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	53                   	push   %ebx
  800572:	83 ec 14             	sub    $0x14,%esp
  800575:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800578:	8b 13                	mov    (%ebx),%edx
  80057a:	8d 42 01             	lea    0x1(%edx),%eax
  80057d:	89 03                	mov    %eax,(%ebx)
  80057f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800582:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800586:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058b:	75 19                	jne    8005a6 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80058d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800594:	00 
  800595:	8d 43 08             	lea    0x8(%ebx),%eax
  800598:	89 04 24             	mov    %eax,(%esp)
  80059b:	e8 36 0a 00 00       	call   800fd6 <sys_cputs>
		b->idx = 0;
  8005a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8005a6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005aa:	83 c4 14             	add    $0x14,%esp
  8005ad:	5b                   	pop    %ebx
  8005ae:	5d                   	pop    %ebp
  8005af:	c3                   	ret    

008005b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c0:	00 00 00 
	b.cnt = 0;
  8005c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e5:	c7 04 24 6e 05 80 00 	movl   $0x80056e,(%esp)
  8005ec:	e8 73 01 00 00       	call   800764 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005f1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800601:	89 04 24             	mov    %eax,(%esp)
  800604:	e8 cd 09 00 00       	call   800fd6 <sys_cputs>

	return b.cnt;
}
  800609:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80060f:	c9                   	leave  
  800610:	c3                   	ret    

00800611 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800617:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80061a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	89 04 24             	mov    %eax,(%esp)
  800624:	e8 87 ff ff ff       	call   8005b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800629:	c9                   	leave  
  80062a:	c3                   	ret    
  80062b:	66 90                	xchg   %ax,%ax
  80062d:	66 90                	xchg   %ax,%ax
  80062f:	90                   	nop

00800630 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	57                   	push   %edi
  800634:	56                   	push   %esi
  800635:	53                   	push   %ebx
  800636:	83 ec 3c             	sub    $0x3c,%esp
  800639:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063c:	89 d7                	mov    %edx,%edi
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	89 c3                	mov    %eax,%ebx
  800649:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80064c:	8b 45 10             	mov    0x10(%ebp),%eax
  80064f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800652:	b9 00 00 00 00       	mov    $0x0,%ecx
  800657:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80065d:	39 d9                	cmp    %ebx,%ecx
  80065f:	72 05                	jb     800666 <printnum+0x36>
  800661:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800664:	77 69                	ja     8006cf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800666:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800669:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80066d:	83 ee 01             	sub    $0x1,%esi
  800670:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800674:	89 44 24 08          	mov    %eax,0x8(%esp)
  800678:	8b 44 24 08          	mov    0x8(%esp),%eax
  80067c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800680:	89 c3                	mov    %eax,%ebx
  800682:	89 d6                	mov    %edx,%esi
  800684:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800687:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80068a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80068e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800695:	89 04 24             	mov    %eax,(%esp)
  800698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80069b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069f:	e8 5c 22 00 00       	call   802900 <__udivdi3>
  8006a4:	89 d9                	mov    %ebx,%ecx
  8006a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006aa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006ae:	89 04 24             	mov    %eax,(%esp)
  8006b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006b5:	89 fa                	mov    %edi,%edx
  8006b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ba:	e8 71 ff ff ff       	call   800630 <printnum>
  8006bf:	eb 1b                	jmp    8006dc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c8:	89 04 24             	mov    %eax,(%esp)
  8006cb:	ff d3                	call   *%ebx
  8006cd:	eb 03                	jmp    8006d2 <printnum+0xa2>
  8006cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d2:	83 ee 01             	sub    $0x1,%esi
  8006d5:	85 f6                	test   %esi,%esi
  8006d7:	7f e8                	jg     8006c1 <printnum+0x91>
  8006d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8006e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f5:	89 04 24             	mov    %eax,(%esp)
  8006f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ff:	e8 2c 23 00 00       	call   802a30 <__umoddi3>
  800704:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800708:	0f be 80 b2 2c 80 00 	movsbl 0x802cb2(%eax),%eax
  80070f:	89 04 24             	mov    %eax,(%esp)
  800712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800715:	ff d0                	call   *%eax
}
  800717:	83 c4 3c             	add    $0x3c,%esp
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800725:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	3b 50 04             	cmp    0x4(%eax),%edx
  80072e:	73 0a                	jae    80073a <sprintputch+0x1b>
		*b->buf++ = ch;
  800730:	8d 4a 01             	lea    0x1(%edx),%ecx
  800733:	89 08                	mov    %ecx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	88 02                	mov    %al,(%edx)
}
  80073a:	5d                   	pop    %ebp
  80073b:	c3                   	ret    

0080073c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800742:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800745:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800749:	8b 45 10             	mov    0x10(%ebp),%eax
  80074c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800750:	8b 45 0c             	mov    0xc(%ebp),%eax
  800753:	89 44 24 04          	mov    %eax,0x4(%esp)
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 04 24             	mov    %eax,(%esp)
  80075d:	e8 02 00 00 00       	call   800764 <vprintfmt>
	va_end(ap);
}
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	57                   	push   %edi
  800768:	56                   	push   %esi
  800769:	53                   	push   %ebx
  80076a:	83 ec 3c             	sub    $0x3c,%esp
  80076d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800770:	eb 17                	jmp    800789 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800772:	85 c0                	test   %eax,%eax
  800774:	0f 84 4b 04 00 00    	je     800bc5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80077a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80077d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800781:	89 04 24             	mov    %eax,(%esp)
  800784:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800787:	89 fb                	mov    %edi,%ebx
  800789:	8d 7b 01             	lea    0x1(%ebx),%edi
  80078c:	0f b6 03             	movzbl (%ebx),%eax
  80078f:	83 f8 25             	cmp    $0x25,%eax
  800792:	75 de                	jne    800772 <vprintfmt+0xe>
  800794:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800798:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80079f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8007a4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8007ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b0:	eb 18                	jmp    8007ca <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8007b8:	eb 10                	jmp    8007ca <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ba:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8007c0:	eb 08                	jmp    8007ca <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8007c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007c5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ca:	8d 5f 01             	lea    0x1(%edi),%ebx
  8007cd:	0f b6 17             	movzbl (%edi),%edx
  8007d0:	0f b6 c2             	movzbl %dl,%eax
  8007d3:	83 ea 23             	sub    $0x23,%edx
  8007d6:	80 fa 55             	cmp    $0x55,%dl
  8007d9:	0f 87 c2 03 00 00    	ja     800ba1 <vprintfmt+0x43d>
  8007df:	0f b6 d2             	movzbl %dl,%edx
  8007e2:	ff 24 95 00 2e 80 00 	jmp    *0x802e00(,%edx,4)
  8007e9:	89 df                	mov    %ebx,%edi
  8007eb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8007f0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8007f3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8007f7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8007fa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8007fd:	83 fa 09             	cmp    $0x9,%edx
  800800:	77 33                	ja     800835 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800802:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800805:	eb e9                	jmp    8007f0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8b 30                	mov    (%eax),%esi
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800812:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xd1>
  800816:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800819:	85 ff                	test   %edi,%edi
  80081b:	b8 00 00 00 00       	mov    $0x0,%eax
  800820:	0f 49 c7             	cmovns %edi,%eax
  800823:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800826:	89 df                	mov    %ebx,%edi
  800828:	eb a0                	jmp    8007ca <vprintfmt+0x66>
  80082a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80082c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800833:	eb 95                	jmp    8007ca <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800835:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800839:	79 8f                	jns    8007ca <vprintfmt+0x66>
  80083b:	eb 85                	jmp    8007c2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80083d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800840:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800842:	eb 86                	jmp    8007ca <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8d 70 04             	lea    0x4(%eax),%esi
  80084a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 04 24             	mov    %eax,(%esp)
  800859:	ff 55 08             	call   *0x8(%ebp)
  80085c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80085f:	e9 25 ff ff ff       	jmp    800789 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 70 04             	lea    0x4(%eax),%esi
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	99                   	cltd   
  80086d:	31 d0                	xor    %edx,%eax
  80086f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800871:	83 f8 15             	cmp    $0x15,%eax
  800874:	7f 0b                	jg     800881 <vprintfmt+0x11d>
  800876:	8b 14 85 60 2f 80 00 	mov    0x802f60(,%eax,4),%edx
  80087d:	85 d2                	test   %edx,%edx
  80087f:	75 26                	jne    8008a7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800881:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800885:	c7 44 24 08 ca 2c 80 	movl   $0x802cca,0x8(%esp)
  80088c:	00 
  80088d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800890:	89 44 24 04          	mov    %eax,0x4(%esp)
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 04 24             	mov    %eax,(%esp)
  80089a:	e8 9d fe ff ff       	call   80073c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80089f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8008a2:	e9 e2 fe ff ff       	jmp    800789 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8008a7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008ab:	c7 44 24 08 b2 30 80 	movl   $0x8030b2,0x8(%esp)
  8008b2:	00 
  8008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	89 04 24             	mov    %eax,(%esp)
  8008c0:	e8 77 fe ff ff       	call   80073c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008c5:	89 75 14             	mov    %esi,0x14(%ebp)
  8008c8:	e9 bc fe ff ff       	jmp    800789 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008d3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8008da:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8008dc:	85 ff                	test   %edi,%edi
  8008de:	b8 c3 2c 80 00       	mov    $0x802cc3,%eax
  8008e3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8008e6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8008ea:	0f 84 94 00 00 00    	je     800984 <vprintfmt+0x220>
  8008f0:	85 c9                	test   %ecx,%ecx
  8008f2:	0f 8e 94 00 00 00    	jle    80098c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008fc:	89 3c 24             	mov    %edi,(%esp)
  8008ff:	e8 64 03 00 00       	call   800c68 <strnlen>
  800904:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800907:	29 c1                	sub    %eax,%ecx
  800909:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80090c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800910:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800913:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800916:	8b 75 08             	mov    0x8(%ebp),%esi
  800919:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80091c:	89 cb                	mov    %ecx,%ebx
  80091e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800920:	eb 0f                	jmp    800931 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800922:	8b 45 0c             	mov    0xc(%ebp),%eax
  800925:	89 44 24 04          	mov    %eax,0x4(%esp)
  800929:	89 3c 24             	mov    %edi,(%esp)
  80092c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80092e:	83 eb 01             	sub    $0x1,%ebx
  800931:	85 db                	test   %ebx,%ebx
  800933:	7f ed                	jg     800922 <vprintfmt+0x1be>
  800935:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800938:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80093b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80093e:	85 c9                	test   %ecx,%ecx
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
  800945:	0f 49 c1             	cmovns %ecx,%eax
  800948:	29 c1                	sub    %eax,%ecx
  80094a:	89 cb                	mov    %ecx,%ebx
  80094c:	eb 44                	jmp    800992 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80094e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800952:	74 1e                	je     800972 <vprintfmt+0x20e>
  800954:	0f be d2             	movsbl %dl,%edx
  800957:	83 ea 20             	sub    $0x20,%edx
  80095a:	83 fa 5e             	cmp    $0x5e,%edx
  80095d:	76 13                	jbe    800972 <vprintfmt+0x20e>
					putch('?', putdat);
  80095f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800962:	89 44 24 04          	mov    %eax,0x4(%esp)
  800966:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80096d:	ff 55 08             	call   *0x8(%ebp)
  800970:	eb 0d                	jmp    80097f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800975:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800979:	89 04 24             	mov    %eax,(%esp)
  80097c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80097f:	83 eb 01             	sub    $0x1,%ebx
  800982:	eb 0e                	jmp    800992 <vprintfmt+0x22e>
  800984:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800987:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80098a:	eb 06                	jmp    800992 <vprintfmt+0x22e>
  80098c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80098f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800992:	83 c7 01             	add    $0x1,%edi
  800995:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800999:	0f be c2             	movsbl %dl,%eax
  80099c:	85 c0                	test   %eax,%eax
  80099e:	74 27                	je     8009c7 <vprintfmt+0x263>
  8009a0:	85 f6                	test   %esi,%esi
  8009a2:	78 aa                	js     80094e <vprintfmt+0x1ea>
  8009a4:	83 ee 01             	sub    $0x1,%esi
  8009a7:	79 a5                	jns    80094e <vprintfmt+0x1ea>
  8009a9:	89 d8                	mov    %ebx,%eax
  8009ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8009b1:	89 c3                	mov    %eax,%ebx
  8009b3:	eb 18                	jmp    8009cd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8009b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009b9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8009c0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c2:	83 eb 01             	sub    $0x1,%ebx
  8009c5:	eb 06                	jmp    8009cd <vprintfmt+0x269>
  8009c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8009cd:	85 db                	test   %ebx,%ebx
  8009cf:	7f e4                	jg     8009b5 <vprintfmt+0x251>
  8009d1:	89 75 08             	mov    %esi,0x8(%ebp)
  8009d4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8009da:	e9 aa fd ff ff       	jmp    800789 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8009df:	83 f9 01             	cmp    $0x1,%ecx
  8009e2:	7e 10                	jle    8009f4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	8b 30                	mov    (%eax),%esi
  8009e9:	8b 78 04             	mov    0x4(%eax),%edi
  8009ec:	8d 40 08             	lea    0x8(%eax),%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f2:	eb 26                	jmp    800a1a <vprintfmt+0x2b6>
	else if (lflag)
  8009f4:	85 c9                	test   %ecx,%ecx
  8009f6:	74 12                	je     800a0a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	8b 30                	mov    (%eax),%esi
  8009fd:	89 f7                	mov    %esi,%edi
  8009ff:	c1 ff 1f             	sar    $0x1f,%edi
  800a02:	8d 40 04             	lea    0x4(%eax),%eax
  800a05:	89 45 14             	mov    %eax,0x14(%ebp)
  800a08:	eb 10                	jmp    800a1a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	8b 30                	mov    (%eax),%esi
  800a0f:	89 f7                	mov    %esi,%edi
  800a11:	c1 ff 1f             	sar    $0x1f,%edi
  800a14:	8d 40 04             	lea    0x4(%eax),%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a1a:	89 f0                	mov    %esi,%eax
  800a1c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800a1e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800a23:	85 ff                	test   %edi,%edi
  800a25:	0f 89 3a 01 00 00    	jns    800b65 <vprintfmt+0x401>
				putch('-', putdat);
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a32:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800a39:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800a3c:	89 f0                	mov    %esi,%eax
  800a3e:	89 fa                	mov    %edi,%edx
  800a40:	f7 d8                	neg    %eax
  800a42:	83 d2 00             	adc    $0x0,%edx
  800a45:	f7 da                	neg    %edx
			}
			base = 10;
  800a47:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800a4c:	e9 14 01 00 00       	jmp    800b65 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a51:	83 f9 01             	cmp    $0x1,%ecx
  800a54:	7e 13                	jle    800a69 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	8b 50 04             	mov    0x4(%eax),%edx
  800a5c:	8b 00                	mov    (%eax),%eax
  800a5e:	8b 75 14             	mov    0x14(%ebp),%esi
  800a61:	8d 4e 08             	lea    0x8(%esi),%ecx
  800a64:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800a67:	eb 2c                	jmp    800a95 <vprintfmt+0x331>
	else if (lflag)
  800a69:	85 c9                	test   %ecx,%ecx
  800a6b:	74 15                	je     800a82 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	8b 00                	mov    (%eax),%eax
  800a72:	ba 00 00 00 00       	mov    $0x0,%edx
  800a77:	8b 75 14             	mov    0x14(%ebp),%esi
  800a7a:	8d 76 04             	lea    0x4(%esi),%esi
  800a7d:	89 75 14             	mov    %esi,0x14(%ebp)
  800a80:	eb 13                	jmp    800a95 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	8b 00                	mov    (%eax),%eax
  800a87:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8c:	8b 75 14             	mov    0x14(%ebp),%esi
  800a8f:	8d 76 04             	lea    0x4(%esi),%esi
  800a92:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800a95:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800a9a:	e9 c6 00 00 00       	jmp    800b65 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a9f:	83 f9 01             	cmp    $0x1,%ecx
  800aa2:	7e 13                	jle    800ab7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa7:	8b 50 04             	mov    0x4(%eax),%edx
  800aaa:	8b 00                	mov    (%eax),%eax
  800aac:	8b 75 14             	mov    0x14(%ebp),%esi
  800aaf:	8d 4e 08             	lea    0x8(%esi),%ecx
  800ab2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800ab5:	eb 24                	jmp    800adb <vprintfmt+0x377>
	else if (lflag)
  800ab7:	85 c9                	test   %ecx,%ecx
  800ab9:	74 11                	je     800acc <vprintfmt+0x368>
		return va_arg(*ap, long);
  800abb:	8b 45 14             	mov    0x14(%ebp),%eax
  800abe:	8b 00                	mov    (%eax),%eax
  800ac0:	99                   	cltd   
  800ac1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800ac4:	8d 71 04             	lea    0x4(%ecx),%esi
  800ac7:	89 75 14             	mov    %esi,0x14(%ebp)
  800aca:	eb 0f                	jmp    800adb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	99                   	cltd   
  800ad2:	8b 75 14             	mov    0x14(%ebp),%esi
  800ad5:	8d 76 04             	lea    0x4(%esi),%esi
  800ad8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  800adb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800ae0:	e9 80 00 00 00       	jmp    800b65 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ae5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aef:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800af6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b00:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b07:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b0a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b0e:	8b 06                	mov    (%esi),%eax
  800b10:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b15:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b1a:	eb 49                	jmp    800b65 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b1c:	83 f9 01             	cmp    $0x1,%ecx
  800b1f:	7e 13                	jle    800b34 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	8b 50 04             	mov    0x4(%eax),%edx
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	8b 75 14             	mov    0x14(%ebp),%esi
  800b2c:	8d 4e 08             	lea    0x8(%esi),%ecx
  800b2f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b32:	eb 2c                	jmp    800b60 <vprintfmt+0x3fc>
	else if (lflag)
  800b34:	85 c9                	test   %ecx,%ecx
  800b36:	74 15                	je     800b4d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b42:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800b45:	8d 71 04             	lea    0x4(%ecx),%esi
  800b48:	89 75 14             	mov    %esi,0x14(%ebp)
  800b4b:	eb 13                	jmp    800b60 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	8b 75 14             	mov    0x14(%ebp),%esi
  800b5a:	8d 76 04             	lea    0x4(%esi),%esi
  800b5d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800b60:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b65:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800b69:	89 74 24 10          	mov    %esi,0x10(%esp)
  800b6d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800b70:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b74:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b78:	89 04 24             	mov    %eax,(%esp)
  800b7b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	e8 a6 fa ff ff       	call   800630 <printnum>
			break;
  800b8a:	e9 fa fb ff ff       	jmp    800789 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800b96:	89 04 24             	mov    %eax,(%esp)
  800b99:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b9c:	e9 e8 fb ff ff       	jmp    800789 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800baf:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb2:	89 fb                	mov    %edi,%ebx
  800bb4:	eb 03                	jmp    800bb9 <vprintfmt+0x455>
  800bb6:	83 eb 01             	sub    $0x1,%ebx
  800bb9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800bbd:	75 f7                	jne    800bb6 <vprintfmt+0x452>
  800bbf:	90                   	nop
  800bc0:	e9 c4 fb ff ff       	jmp    800789 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800bc5:	83 c4 3c             	add    $0x3c,%esp
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 28             	sub    $0x28,%esp
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bdc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800be0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bea:	85 c0                	test   %eax,%eax
  800bec:	74 30                	je     800c1e <vsnprintf+0x51>
  800bee:	85 d2                	test   %edx,%edx
  800bf0:	7e 2c                	jle    800c1e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c00:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c07:	c7 04 24 1f 07 80 00 	movl   $0x80071f,(%esp)
  800c0e:	e8 51 fb ff ff       	call   800764 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c16:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	eb 05                	jmp    800c23 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800c1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c2b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c32:	8b 45 10             	mov    0x10(%ebp),%eax
  800c35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	89 04 24             	mov    %eax,(%esp)
  800c46:	e8 82 ff ff ff       	call   800bcd <vsnprintf>
	va_end(ap);

	return rc;
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    
  800c4d:	66 90                	xchg   %ax,%ax
  800c4f:	90                   	nop

00800c50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c56:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5b:	eb 03                	jmp    800c60 <strlen+0x10>
		n++;
  800c5d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c60:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c64:	75 f7                	jne    800c5d <strlen+0xd>
		n++;
	return n;
}
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	eb 03                	jmp    800c7b <strnlen+0x13>
		n++;
  800c78:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7b:	39 d0                	cmp    %edx,%eax
  800c7d:	74 06                	je     800c85 <strnlen+0x1d>
  800c7f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c83:	75 f3                	jne    800c78 <strnlen+0x10>
		n++;
	return n;
}
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	53                   	push   %ebx
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c91:	89 c2                	mov    %eax,%edx
  800c93:	83 c2 01             	add    $0x1,%edx
  800c96:	83 c1 01             	add    $0x1,%ecx
  800c99:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c9d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ca0:	84 db                	test   %bl,%bl
  800ca2:	75 ef                	jne    800c93 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	53                   	push   %ebx
  800cab:	83 ec 08             	sub    $0x8,%esp
  800cae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cb1:	89 1c 24             	mov    %ebx,(%esp)
  800cb4:	e8 97 ff ff ff       	call   800c50 <strlen>
	strcpy(dst + len, src);
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800cc0:	01 d8                	add    %ebx,%eax
  800cc2:	89 04 24             	mov    %eax,(%esp)
  800cc5:	e8 bd ff ff ff       	call   800c87 <strcpy>
	return dst;
}
  800cca:	89 d8                	mov    %ebx,%eax
  800ccc:	83 c4 08             	add    $0x8,%esp
  800ccf:	5b                   	pop    %ebx
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	8b 75 08             	mov    0x8(%ebp),%esi
  800cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdd:	89 f3                	mov    %esi,%ebx
  800cdf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ce2:	89 f2                	mov    %esi,%edx
  800ce4:	eb 0f                	jmp    800cf5 <strncpy+0x23>
		*dst++ = *src;
  800ce6:	83 c2 01             	add    $0x1,%edx
  800ce9:	0f b6 01             	movzbl (%ecx),%eax
  800cec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cef:	80 39 01             	cmpb   $0x1,(%ecx)
  800cf2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf5:	39 da                	cmp    %ebx,%edx
  800cf7:	75 ed                	jne    800ce6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800cf9:	89 f0                	mov    %esi,%eax
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	8b 75 08             	mov    0x8(%ebp),%esi
  800d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d0d:	89 f0                	mov    %esi,%eax
  800d0f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d13:	85 c9                	test   %ecx,%ecx
  800d15:	75 0b                	jne    800d22 <strlcpy+0x23>
  800d17:	eb 1d                	jmp    800d36 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d19:	83 c0 01             	add    $0x1,%eax
  800d1c:	83 c2 01             	add    $0x1,%edx
  800d1f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d22:	39 d8                	cmp    %ebx,%eax
  800d24:	74 0b                	je     800d31 <strlcpy+0x32>
  800d26:	0f b6 0a             	movzbl (%edx),%ecx
  800d29:	84 c9                	test   %cl,%cl
  800d2b:	75 ec                	jne    800d19 <strlcpy+0x1a>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	eb 02                	jmp    800d33 <strlcpy+0x34>
  800d31:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d33:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d36:	29 f0                	sub    %esi,%eax
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d42:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d45:	eb 06                	jmp    800d4d <strcmp+0x11>
		p++, q++;
  800d47:	83 c1 01             	add    $0x1,%ecx
  800d4a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d4d:	0f b6 01             	movzbl (%ecx),%eax
  800d50:	84 c0                	test   %al,%al
  800d52:	74 04                	je     800d58 <strcmp+0x1c>
  800d54:	3a 02                	cmp    (%edx),%al
  800d56:	74 ef                	je     800d47 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d58:	0f b6 c0             	movzbl %al,%eax
  800d5b:	0f b6 12             	movzbl (%edx),%edx
  800d5e:	29 d0                	sub    %edx,%eax
}
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	53                   	push   %ebx
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6c:	89 c3                	mov    %eax,%ebx
  800d6e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d71:	eb 06                	jmp    800d79 <strncmp+0x17>
		n--, p++, q++;
  800d73:	83 c0 01             	add    $0x1,%eax
  800d76:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d79:	39 d8                	cmp    %ebx,%eax
  800d7b:	74 15                	je     800d92 <strncmp+0x30>
  800d7d:	0f b6 08             	movzbl (%eax),%ecx
  800d80:	84 c9                	test   %cl,%cl
  800d82:	74 04                	je     800d88 <strncmp+0x26>
  800d84:	3a 0a                	cmp    (%edx),%cl
  800d86:	74 eb                	je     800d73 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d88:	0f b6 00             	movzbl (%eax),%eax
  800d8b:	0f b6 12             	movzbl (%edx),%edx
  800d8e:	29 d0                	sub    %edx,%eax
  800d90:	eb 05                	jmp    800d97 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d97:	5b                   	pop    %ebx
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800da4:	eb 07                	jmp    800dad <strchr+0x13>
		if (*s == c)
  800da6:	38 ca                	cmp    %cl,%dl
  800da8:	74 0f                	je     800db9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800daa:	83 c0 01             	add    $0x1,%eax
  800dad:	0f b6 10             	movzbl (%eax),%edx
  800db0:	84 d2                	test   %dl,%dl
  800db2:	75 f2                	jne    800da6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dc5:	eb 07                	jmp    800dce <strfind+0x13>
		if (*s == c)
  800dc7:	38 ca                	cmp    %cl,%dl
  800dc9:	74 0a                	je     800dd5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcb:	83 c0 01             	add    $0x1,%eax
  800dce:	0f b6 10             	movzbl (%eax),%edx
  800dd1:	84 d2                	test   %dl,%dl
  800dd3:	75 f2                	jne    800dc7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800de0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800de3:	85 c9                	test   %ecx,%ecx
  800de5:	74 36                	je     800e1d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800de7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ded:	75 28                	jne    800e17 <memset+0x40>
  800def:	f6 c1 03             	test   $0x3,%cl
  800df2:	75 23                	jne    800e17 <memset+0x40>
		c &= 0xFF;
  800df4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800df8:	89 d3                	mov    %edx,%ebx
  800dfa:	c1 e3 08             	shl    $0x8,%ebx
  800dfd:	89 d6                	mov    %edx,%esi
  800dff:	c1 e6 18             	shl    $0x18,%esi
  800e02:	89 d0                	mov    %edx,%eax
  800e04:	c1 e0 10             	shl    $0x10,%eax
  800e07:	09 f0                	or     %esi,%eax
  800e09:	09 c2                	or     %eax,%edx
  800e0b:	89 d0                	mov    %edx,%eax
  800e0d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e0f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800e12:	fc                   	cld    
  800e13:	f3 ab                	rep stos %eax,%es:(%edi)
  800e15:	eb 06                	jmp    800e1d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	fc                   	cld    
  800e1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e1d:	89 f8                	mov    %edi,%eax
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e32:	39 c6                	cmp    %eax,%esi
  800e34:	73 35                	jae    800e6b <memmove+0x47>
  800e36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e39:	39 d0                	cmp    %edx,%eax
  800e3b:	73 2e                	jae    800e6b <memmove+0x47>
		s += n;
		d += n;
  800e3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e40:	89 d6                	mov    %edx,%esi
  800e42:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e4a:	75 13                	jne    800e5f <memmove+0x3b>
  800e4c:	f6 c1 03             	test   $0x3,%cl
  800e4f:	75 0e                	jne    800e5f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e51:	83 ef 04             	sub    $0x4,%edi
  800e54:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e57:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e5a:	fd                   	std    
  800e5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e5d:	eb 09                	jmp    800e68 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e5f:	83 ef 01             	sub    $0x1,%edi
  800e62:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e65:	fd                   	std    
  800e66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e68:	fc                   	cld    
  800e69:	eb 1d                	jmp    800e88 <memmove+0x64>
  800e6b:	89 f2                	mov    %esi,%edx
  800e6d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e6f:	f6 c2 03             	test   $0x3,%dl
  800e72:	75 0f                	jne    800e83 <memmove+0x5f>
  800e74:	f6 c1 03             	test   $0x3,%cl
  800e77:	75 0a                	jne    800e83 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e79:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e7c:	89 c7                	mov    %eax,%edi
  800e7e:	fc                   	cld    
  800e7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e81:	eb 05                	jmp    800e88 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e83:	89 c7                	mov    %eax,%edi
  800e85:	fc                   	cld    
  800e86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	89 04 24             	mov    %eax,(%esp)
  800ea6:	e8 79 ff ff ff       	call   800e24 <memmove>
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb8:	89 d6                	mov    %edx,%esi
  800eba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ebd:	eb 1a                	jmp    800ed9 <memcmp+0x2c>
		if (*s1 != *s2)
  800ebf:	0f b6 02             	movzbl (%edx),%eax
  800ec2:	0f b6 19             	movzbl (%ecx),%ebx
  800ec5:	38 d8                	cmp    %bl,%al
  800ec7:	74 0a                	je     800ed3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	0f b6 db             	movzbl %bl,%ebx
  800ecf:	29 d8                	sub    %ebx,%eax
  800ed1:	eb 0f                	jmp    800ee2 <memcmp+0x35>
		s1++, s2++;
  800ed3:	83 c2 01             	add    $0x1,%edx
  800ed6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ed9:	39 f2                	cmp    %esi,%edx
  800edb:	75 e2                	jne    800ebf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ef4:	eb 07                	jmp    800efd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef6:	38 08                	cmp    %cl,(%eax)
  800ef8:	74 07                	je     800f01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efa:	83 c0 01             	add    $0x1,%eax
  800efd:	39 d0                	cmp    %edx,%eax
  800eff:	72 f5                	jb     800ef6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0f:	eb 03                	jmp    800f14 <strtol+0x11>
		s++;
  800f11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f14:	0f b6 0a             	movzbl (%edx),%ecx
  800f17:	80 f9 09             	cmp    $0x9,%cl
  800f1a:	74 f5                	je     800f11 <strtol+0xe>
  800f1c:	80 f9 20             	cmp    $0x20,%cl
  800f1f:	74 f0                	je     800f11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f21:	80 f9 2b             	cmp    $0x2b,%cl
  800f24:	75 0a                	jne    800f30 <strtol+0x2d>
		s++;
  800f26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f29:	bf 00 00 00 00       	mov    $0x0,%edi
  800f2e:	eb 11                	jmp    800f41 <strtol+0x3e>
  800f30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f35:	80 f9 2d             	cmp    $0x2d,%cl
  800f38:	75 07                	jne    800f41 <strtol+0x3e>
		s++, neg = 1;
  800f3a:	8d 52 01             	lea    0x1(%edx),%edx
  800f3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f46:	75 15                	jne    800f5d <strtol+0x5a>
  800f48:	80 3a 30             	cmpb   $0x30,(%edx)
  800f4b:	75 10                	jne    800f5d <strtol+0x5a>
  800f4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f51:	75 0a                	jne    800f5d <strtol+0x5a>
		s += 2, base = 16;
  800f53:	83 c2 02             	add    $0x2,%edx
  800f56:	b8 10 00 00 00       	mov    $0x10,%eax
  800f5b:	eb 10                	jmp    800f6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	75 0c                	jne    800f6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f63:	80 3a 30             	cmpb   $0x30,(%edx)
  800f66:	75 05                	jne    800f6d <strtol+0x6a>
		s++, base = 8;
  800f68:	83 c2 01             	add    $0x1,%edx
  800f6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f75:	0f b6 0a             	movzbl (%edx),%ecx
  800f78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f7b:	89 f0                	mov    %esi,%eax
  800f7d:	3c 09                	cmp    $0x9,%al
  800f7f:	77 08                	ja     800f89 <strtol+0x86>
			dig = *s - '0';
  800f81:	0f be c9             	movsbl %cl,%ecx
  800f84:	83 e9 30             	sub    $0x30,%ecx
  800f87:	eb 20                	jmp    800fa9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800f89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800f8c:	89 f0                	mov    %esi,%eax
  800f8e:	3c 19                	cmp    $0x19,%al
  800f90:	77 08                	ja     800f9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800f92:	0f be c9             	movsbl %cl,%ecx
  800f95:	83 e9 57             	sub    $0x57,%ecx
  800f98:	eb 0f                	jmp    800fa9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800f9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800f9d:	89 f0                	mov    %esi,%eax
  800f9f:	3c 19                	cmp    $0x19,%al
  800fa1:	77 16                	ja     800fb9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800fa3:	0f be c9             	movsbl %cl,%ecx
  800fa6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800fa9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800fac:	7d 0f                	jge    800fbd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800fae:	83 c2 01             	add    $0x1,%edx
  800fb1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800fb5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800fb7:	eb bc                	jmp    800f75 <strtol+0x72>
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	eb 02                	jmp    800fbf <strtol+0xbc>
  800fbd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800fbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc3:	74 05                	je     800fca <strtol+0xc7>
		*endptr = (char *) s;
  800fc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fc8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800fca:	f7 d8                	neg    %eax
  800fcc:	85 ff                	test   %edi,%edi
  800fce:	0f 44 c3             	cmove  %ebx,%eax
}
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	89 c3                	mov    %eax,%ebx
  800fe9:	89 c7                	mov    %eax,%edi
  800feb:	89 c6                	mov    %eax,%esi
  800fed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fef:	5b                   	pop    %ebx
  800ff0:	5e                   	pop    %esi
  800ff1:	5f                   	pop    %edi
  800ff2:	5d                   	pop    %ebp
  800ff3:	c3                   	ret    

00800ff4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	57                   	push   %edi
  800ff8:	56                   	push   %esi
  800ff9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffa:	ba 00 00 00 00       	mov    $0x0,%edx
  800fff:	b8 01 00 00 00       	mov    $0x1,%eax
  801004:	89 d1                	mov    %edx,%ecx
  801006:	89 d3                	mov    %edx,%ebx
  801008:	89 d7                	mov    %edx,%edi
  80100a:	89 d6                	mov    %edx,%esi
  80100c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	57                   	push   %edi
  801017:	56                   	push   %esi
  801018:	53                   	push   %ebx
  801019:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801021:	b8 03 00 00 00       	mov    $0x3,%eax
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	89 cb                	mov    %ecx,%ebx
  80102b:	89 cf                	mov    %ecx,%edi
  80102d:	89 ce                	mov    %ecx,%esi
  80102f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801031:	85 c0                	test   %eax,%eax
  801033:	7e 28                	jle    80105d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801035:	89 44 24 10          	mov    %eax,0x10(%esp)
  801039:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801040:	00 
  801041:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  801048:	00 
  801049:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801050:	00 
  801051:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801058:	e8 f9 16 00 00       	call   802756 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80105d:	83 c4 2c             	add    $0x2c,%esp
  801060:	5b                   	pop    %ebx
  801061:	5e                   	pop    %esi
  801062:	5f                   	pop    %edi
  801063:	5d                   	pop    %ebp
  801064:	c3                   	ret    

00801065 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	57                   	push   %edi
  801069:	56                   	push   %esi
  80106a:	53                   	push   %ebx
  80106b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801073:	b8 04 00 00 00       	mov    $0x4,%eax
  801078:	8b 55 08             	mov    0x8(%ebp),%edx
  80107b:	89 cb                	mov    %ecx,%ebx
  80107d:	89 cf                	mov    %ecx,%edi
  80107f:	89 ce                	mov    %ecx,%esi
  801081:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801083:	85 c0                	test   %eax,%eax
  801085:	7e 28                	jle    8010af <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801087:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801092:	00 
  801093:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  80109a:	00 
  80109b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a2:	00 
  8010a3:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8010aa:	e8 a7 16 00 00       	call   802756 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  8010af:	83 c4 2c             	add    $0x2c,%esp
  8010b2:	5b                   	pop    %ebx
  8010b3:	5e                   	pop    %esi
  8010b4:	5f                   	pop    %edi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	57                   	push   %edi
  8010bb:	56                   	push   %esi
  8010bc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8010c7:	89 d1                	mov    %edx,%ecx
  8010c9:	89 d3                	mov    %edx,%ebx
  8010cb:	89 d7                	mov    %edx,%edi
  8010cd:	89 d6                	mov    %edx,%esi
  8010cf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <sys_yield>:

void
sys_yield(void)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	57                   	push   %edi
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010e6:	89 d1                	mov    %edx,%ecx
  8010e8:	89 d3                	mov    %edx,%ebx
  8010ea:	89 d7                	mov    %edx,%edi
  8010ec:	89 d6                	mov    %edx,%esi
  8010ee:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
  8010fb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fe:	be 00 00 00 00       	mov    $0x0,%esi
  801103:	b8 05 00 00 00       	mov    $0x5,%eax
  801108:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801111:	89 f7                	mov    %esi,%edi
  801113:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801115:	85 c0                	test   %eax,%eax
  801117:	7e 28                	jle    801141 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801119:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801124:	00 
  801125:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  80112c:	00 
  80112d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801134:	00 
  801135:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  80113c:	e8 15 16 00 00       	call   802756 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801141:	83 c4 2c             	add    $0x2c,%esp
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	57                   	push   %edi
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
  80114f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801152:	b8 06 00 00 00       	mov    $0x6,%eax
  801157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115a:	8b 55 08             	mov    0x8(%ebp),%edx
  80115d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801160:	8b 7d 14             	mov    0x14(%ebp),%edi
  801163:	8b 75 18             	mov    0x18(%ebp),%esi
  801166:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801168:	85 c0                	test   %eax,%eax
  80116a:	7e 28                	jle    801194 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80116c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801170:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801177:	00 
  801178:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  80117f:	00 
  801180:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801187:	00 
  801188:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  80118f:	e8 c2 15 00 00       	call   802756 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801194:	83 c4 2c             	add    $0x2c,%esp
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5f                   	pop    %edi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8011af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b5:	89 df                	mov    %ebx,%edi
  8011b7:	89 de                	mov    %ebx,%esi
  8011b9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	7e 28                	jle    8011e7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8011ca:	00 
  8011cb:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  8011d2:	00 
  8011d3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011da:	00 
  8011db:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8011e2:	e8 6f 15 00 00       	call   802756 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011e7:	83 c4 2c             	add    $0x2c,%esp
  8011ea:	5b                   	pop    %ebx
  8011eb:	5e                   	pop    %esi
  8011ec:	5f                   	pop    %edi
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    

008011ef <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	57                   	push   %edi
  8011f3:	56                   	push   %esi
  8011f4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011fa:	b8 10 00 00 00       	mov    $0x10,%eax
  8011ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801202:	89 cb                	mov    %ecx,%ebx
  801204:	89 cf                	mov    %ecx,%edi
  801206:	89 ce                	mov    %ecx,%esi
  801208:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80120a:	5b                   	pop    %ebx
  80120b:	5e                   	pop    %esi
  80120c:	5f                   	pop    %edi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    

0080120f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	57                   	push   %edi
  801213:	56                   	push   %esi
  801214:	53                   	push   %ebx
  801215:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801218:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121d:	b8 09 00 00 00       	mov    $0x9,%eax
  801222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801225:	8b 55 08             	mov    0x8(%ebp),%edx
  801228:	89 df                	mov    %ebx,%edi
  80122a:	89 de                	mov    %ebx,%esi
  80122c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80122e:	85 c0                	test   %eax,%eax
  801230:	7e 28                	jle    80125a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801232:	89 44 24 10          	mov    %eax,0x10(%esp)
  801236:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80123d:	00 
  80123e:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  801245:	00 
  801246:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80124d:	00 
  80124e:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801255:	e8 fc 14 00 00       	call   802756 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80125a:	83 c4 2c             	add    $0x2c,%esp
  80125d:	5b                   	pop    %ebx
  80125e:	5e                   	pop    %esi
  80125f:	5f                   	pop    %edi
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    

00801262 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	57                   	push   %edi
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
  801268:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801270:	b8 0a 00 00 00       	mov    $0xa,%eax
  801275:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801278:	8b 55 08             	mov    0x8(%ebp),%edx
  80127b:	89 df                	mov    %ebx,%edi
  80127d:	89 de                	mov    %ebx,%esi
  80127f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801281:	85 c0                	test   %eax,%eax
  801283:	7e 28                	jle    8012ad <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801285:	89 44 24 10          	mov    %eax,0x10(%esp)
  801289:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801290:	00 
  801291:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  801298:	00 
  801299:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012a0:	00 
  8012a1:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8012a8:	e8 a9 14 00 00       	call   802756 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012ad:	83 c4 2c             	add    $0x2c,%esp
  8012b0:	5b                   	pop    %ebx
  8012b1:	5e                   	pop    %esi
  8012b2:	5f                   	pop    %edi
  8012b3:	5d                   	pop    %ebp
  8012b4:	c3                   	ret    

008012b5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	57                   	push   %edi
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ce:	89 df                	mov    %ebx,%edi
  8012d0:	89 de                	mov    %ebx,%esi
  8012d2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	7e 28                	jle    801300 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012dc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8012e3:	00 
  8012e4:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  8012eb:	00 
  8012ec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012f3:	00 
  8012f4:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8012fb:	e8 56 14 00 00       	call   802756 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801300:	83 c4 2c             	add    $0x2c,%esp
  801303:	5b                   	pop    %ebx
  801304:	5e                   	pop    %esi
  801305:	5f                   	pop    %edi
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    

00801308 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	57                   	push   %edi
  80130c:	56                   	push   %esi
  80130d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130e:	be 00 00 00 00       	mov    $0x0,%esi
  801313:	b8 0d 00 00 00       	mov    $0xd,%eax
  801318:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131b:	8b 55 08             	mov    0x8(%ebp),%edx
  80131e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801321:	8b 7d 14             	mov    0x14(%ebp),%edi
  801324:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801326:	5b                   	pop    %ebx
  801327:	5e                   	pop    %esi
  801328:	5f                   	pop    %edi
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    

0080132b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	57                   	push   %edi
  80132f:	56                   	push   %esi
  801330:	53                   	push   %ebx
  801331:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801334:	b9 00 00 00 00       	mov    $0x0,%ecx
  801339:	b8 0e 00 00 00       	mov    $0xe,%eax
  80133e:	8b 55 08             	mov    0x8(%ebp),%edx
  801341:	89 cb                	mov    %ecx,%ebx
  801343:	89 cf                	mov    %ecx,%edi
  801345:	89 ce                	mov    %ecx,%esi
  801347:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801349:	85 c0                	test   %eax,%eax
  80134b:	7e 28                	jle    801375 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80134d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801351:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801358:	00 
  801359:	c7 44 24 08 d7 2f 80 	movl   $0x802fd7,0x8(%esp)
  801360:	00 
  801361:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801368:	00 
  801369:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801370:	e8 e1 13 00 00       	call   802756 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801375:	83 c4 2c             	add    $0x2c,%esp
  801378:	5b                   	pop    %ebx
  801379:	5e                   	pop    %esi
  80137a:	5f                   	pop    %edi
  80137b:	5d                   	pop    %ebp
  80137c:	c3                   	ret    

0080137d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	57                   	push   %edi
  801381:	56                   	push   %esi
  801382:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801383:	ba 00 00 00 00       	mov    $0x0,%edx
  801388:	b8 0f 00 00 00       	mov    $0xf,%eax
  80138d:	89 d1                	mov    %edx,%ecx
  80138f:	89 d3                	mov    %edx,%ebx
  801391:	89 d7                	mov    %edx,%edi
  801393:	89 d6                	mov    %edx,%esi
  801395:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801397:	5b                   	pop    %ebx
  801398:	5e                   	pop    %esi
  801399:	5f                   	pop    %edi
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	57                   	push   %edi
  8013a0:	56                   	push   %esi
  8013a1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a7:	b8 11 00 00 00       	mov    $0x11,%eax
  8013ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013af:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b2:	89 df                	mov    %ebx,%edi
  8013b4:	89 de                	mov    %ebx,%esi
  8013b6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8013b8:	5b                   	pop    %ebx
  8013b9:	5e                   	pop    %esi
  8013ba:	5f                   	pop    %edi
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    

008013bd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	57                   	push   %edi
  8013c1:	56                   	push   %esi
  8013c2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c8:	b8 12 00 00 00       	mov    $0x12,%eax
  8013cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d3:	89 df                	mov    %ebx,%edi
  8013d5:	89 de                	mov    %ebx,%esi
  8013d7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8013d9:	5b                   	pop    %ebx
  8013da:	5e                   	pop    %esi
  8013db:	5f                   	pop    %edi
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	57                   	push   %edi
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013e9:	b8 13 00 00 00       	mov    $0x13,%eax
  8013ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f1:	89 cb                	mov    %ecx,%ebx
  8013f3:	89 cf                	mov    %ecx,%edi
  8013f5:	89 ce                	mov    %ecx,%esi
  8013f7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8013f9:	5b                   	pop    %ebx
  8013fa:	5e                   	pop    %esi
  8013fb:	5f                   	pop    %edi
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    
  8013fe:	66 90                	xchg   %ax,%ax

00801400 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	05 00 00 00 30       	add    $0x30000000,%eax
  80140b:	c1 e8 0c             	shr    $0xc,%eax
}
  80140e:	5d                   	pop    %ebp
  80140f:	c3                   	ret    

00801410 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80141b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801420:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801432:	89 c2                	mov    %eax,%edx
  801434:	c1 ea 16             	shr    $0x16,%edx
  801437:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80143e:	f6 c2 01             	test   $0x1,%dl
  801441:	74 11                	je     801454 <fd_alloc+0x2d>
  801443:	89 c2                	mov    %eax,%edx
  801445:	c1 ea 0c             	shr    $0xc,%edx
  801448:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	75 09                	jne    80145d <fd_alloc+0x36>
			*fd_store = fd;
  801454:	89 01                	mov    %eax,(%ecx)
			return 0;
  801456:	b8 00 00 00 00       	mov    $0x0,%eax
  80145b:	eb 17                	jmp    801474 <fd_alloc+0x4d>
  80145d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801462:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801467:	75 c9                	jne    801432 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801469:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80146f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    

00801476 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80147c:	83 f8 1f             	cmp    $0x1f,%eax
  80147f:	77 36                	ja     8014b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801481:	c1 e0 0c             	shl    $0xc,%eax
  801484:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801489:	89 c2                	mov    %eax,%edx
  80148b:	c1 ea 16             	shr    $0x16,%edx
  80148e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801495:	f6 c2 01             	test   $0x1,%dl
  801498:	74 24                	je     8014be <fd_lookup+0x48>
  80149a:	89 c2                	mov    %eax,%edx
  80149c:	c1 ea 0c             	shr    $0xc,%edx
  80149f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a6:	f6 c2 01             	test   $0x1,%dl
  8014a9:	74 1a                	je     8014c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8014b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b5:	eb 13                	jmp    8014ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bc:	eb 0c                	jmp    8014ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c3:	eb 05                	jmp    8014ca <fd_lookup+0x54>
  8014c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 18             	sub    $0x18,%esp
  8014d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014da:	eb 13                	jmp    8014ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8014dc:	39 08                	cmp    %ecx,(%eax)
  8014de:	75 0c                	jne    8014ec <dev_lookup+0x20>
			*dev = devtab[i];
  8014e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	eb 38                	jmp    801524 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014ec:	83 c2 01             	add    $0x1,%edx
  8014ef:	8b 04 95 80 30 80 00 	mov    0x803080(,%edx,4),%eax
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 e2                	jne    8014dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014fa:	a1 18 50 80 00       	mov    0x805018,%eax
  8014ff:	8b 40 48             	mov    0x48(%eax),%eax
  801502:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801506:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150a:	c7 04 24 04 30 80 00 	movl   $0x803004,(%esp)
  801511:	e8 fb f0 ff ff       	call   800611 <cprintf>
	*dev = 0;
  801516:	8b 45 0c             	mov    0xc(%ebp),%eax
  801519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80151f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	56                   	push   %esi
  80152a:	53                   	push   %ebx
  80152b:	83 ec 20             	sub    $0x20,%esp
  80152e:	8b 75 08             	mov    0x8(%ebp),%esi
  801531:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801534:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801537:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80153b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801541:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801544:	89 04 24             	mov    %eax,(%esp)
  801547:	e8 2a ff ff ff       	call   801476 <fd_lookup>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 05                	js     801555 <fd_close+0x2f>
	    || fd != fd2)
  801550:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801553:	74 0c                	je     801561 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801555:	84 db                	test   %bl,%bl
  801557:	ba 00 00 00 00       	mov    $0x0,%edx
  80155c:	0f 44 c2             	cmove  %edx,%eax
  80155f:	eb 3f                	jmp    8015a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801561:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801564:	89 44 24 04          	mov    %eax,0x4(%esp)
  801568:	8b 06                	mov    (%esi),%eax
  80156a:	89 04 24             	mov    %eax,(%esp)
  80156d:	e8 5a ff ff ff       	call   8014cc <dev_lookup>
  801572:	89 c3                	mov    %eax,%ebx
  801574:	85 c0                	test   %eax,%eax
  801576:	78 16                	js     80158e <fd_close+0x68>
		if (dev->dev_close)
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80157e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801583:	85 c0                	test   %eax,%eax
  801585:	74 07                	je     80158e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801587:	89 34 24             	mov    %esi,(%esp)
  80158a:	ff d0                	call   *%eax
  80158c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80158e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801592:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801599:	e8 fe fb ff ff       	call   80119c <sys_page_unmap>
	return r;
  80159e:	89 d8                	mov    %ebx,%eax
}
  8015a0:	83 c4 20             	add    $0x20,%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    

008015a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	89 04 24             	mov    %eax,(%esp)
  8015ba:	e8 b7 fe ff ff       	call   801476 <fd_lookup>
  8015bf:	89 c2                	mov    %eax,%edx
  8015c1:	85 d2                	test   %edx,%edx
  8015c3:	78 13                	js     8015d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8015c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015cc:	00 
  8015cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d0:	89 04 24             	mov    %eax,(%esp)
  8015d3:	e8 4e ff ff ff       	call   801526 <fd_close>
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <close_all>:

void
close_all(void)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	53                   	push   %ebx
  8015de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015e6:	89 1c 24             	mov    %ebx,(%esp)
  8015e9:	e8 b9 ff ff ff       	call   8015a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ee:	83 c3 01             	add    $0x1,%ebx
  8015f1:	83 fb 20             	cmp    $0x20,%ebx
  8015f4:	75 f0                	jne    8015e6 <close_all+0xc>
		close(i);
}
  8015f6:	83 c4 14             	add    $0x14,%esp
  8015f9:	5b                   	pop    %ebx
  8015fa:	5d                   	pop    %ebp
  8015fb:	c3                   	ret    

008015fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	57                   	push   %edi
  801600:	56                   	push   %esi
  801601:	53                   	push   %ebx
  801602:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801605:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	89 04 24             	mov    %eax,(%esp)
  801612:	e8 5f fe ff ff       	call   801476 <fd_lookup>
  801617:	89 c2                	mov    %eax,%edx
  801619:	85 d2                	test   %edx,%edx
  80161b:	0f 88 e1 00 00 00    	js     801702 <dup+0x106>
		return r;
	close(newfdnum);
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	e8 7b ff ff ff       	call   8015a7 <close>

	newfd = INDEX2FD(newfdnum);
  80162c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80162f:	c1 e3 0c             	shl    $0xc,%ebx
  801632:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80163b:	89 04 24             	mov    %eax,(%esp)
  80163e:	e8 cd fd ff ff       	call   801410 <fd2data>
  801643:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801645:	89 1c 24             	mov    %ebx,(%esp)
  801648:	e8 c3 fd ff ff       	call   801410 <fd2data>
  80164d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80164f:	89 f0                	mov    %esi,%eax
  801651:	c1 e8 16             	shr    $0x16,%eax
  801654:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80165b:	a8 01                	test   $0x1,%al
  80165d:	74 43                	je     8016a2 <dup+0xa6>
  80165f:	89 f0                	mov    %esi,%eax
  801661:	c1 e8 0c             	shr    $0xc,%eax
  801664:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80166b:	f6 c2 01             	test   $0x1,%dl
  80166e:	74 32                	je     8016a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801670:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801677:	25 07 0e 00 00       	and    $0xe07,%eax
  80167c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801680:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801684:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80168b:	00 
  80168c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801690:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801697:	e8 ad fa ff ff       	call   801149 <sys_page_map>
  80169c:	89 c6                	mov    %eax,%esi
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 3e                	js     8016e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a5:	89 c2                	mov    %eax,%edx
  8016a7:	c1 ea 0c             	shr    $0xc,%edx
  8016aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016c6:	00 
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d2:	e8 72 fa ff ff       	call   801149 <sys_page_map>
  8016d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016dc:	85 f6                	test   %esi,%esi
  8016de:	79 22                	jns    801702 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016eb:	e8 ac fa ff ff       	call   80119c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fb:	e8 9c fa ff ff       	call   80119c <sys_page_unmap>
	return r;
  801700:	89 f0                	mov    %esi,%eax
}
  801702:	83 c4 3c             	add    $0x3c,%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5f                   	pop    %edi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	53                   	push   %ebx
  80170e:	83 ec 24             	sub    $0x24,%esp
  801711:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801714:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	89 1c 24             	mov    %ebx,(%esp)
  80171e:	e8 53 fd ff ff       	call   801476 <fd_lookup>
  801723:	89 c2                	mov    %eax,%edx
  801725:	85 d2                	test   %edx,%edx
  801727:	78 6d                	js     801796 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801729:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	89 04 24             	mov    %eax,(%esp)
  801738:	e8 8f fd ff ff       	call   8014cc <dev_lookup>
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 55                	js     801796 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801744:	8b 50 08             	mov    0x8(%eax),%edx
  801747:	83 e2 03             	and    $0x3,%edx
  80174a:	83 fa 01             	cmp    $0x1,%edx
  80174d:	75 23                	jne    801772 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80174f:	a1 18 50 80 00       	mov    0x805018,%eax
  801754:	8b 40 48             	mov    0x48(%eax),%eax
  801757:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80175b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175f:	c7 04 24 45 30 80 00 	movl   $0x803045,(%esp)
  801766:	e8 a6 ee ff ff       	call   800611 <cprintf>
		return -E_INVAL;
  80176b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801770:	eb 24                	jmp    801796 <read+0x8c>
	}
	if (!dev->dev_read)
  801772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801775:	8b 52 08             	mov    0x8(%edx),%edx
  801778:	85 d2                	test   %edx,%edx
  80177a:	74 15                	je     801791 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80177c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801783:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801786:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80178a:	89 04 24             	mov    %eax,(%esp)
  80178d:	ff d2                	call   *%edx
  80178f:	eb 05                	jmp    801796 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801791:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801796:	83 c4 24             	add    $0x24,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5d                   	pop    %ebp
  80179b:	c3                   	ret    

0080179c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	57                   	push   %edi
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 1c             	sub    $0x1c,%esp
  8017a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b0:	eb 23                	jmp    8017d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017b2:	89 f0                	mov    %esi,%eax
  8017b4:	29 d8                	sub    %ebx,%eax
  8017b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ba:	89 d8                	mov    %ebx,%eax
  8017bc:	03 45 0c             	add    0xc(%ebp),%eax
  8017bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c3:	89 3c 24             	mov    %edi,(%esp)
  8017c6:	e8 3f ff ff ff       	call   80170a <read>
		if (m < 0)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	78 10                	js     8017df <readn+0x43>
			return m;
		if (m == 0)
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	74 0a                	je     8017dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017d3:	01 c3                	add    %eax,%ebx
  8017d5:	39 f3                	cmp    %esi,%ebx
  8017d7:	72 d9                	jb     8017b2 <readn+0x16>
  8017d9:	89 d8                	mov    %ebx,%eax
  8017db:	eb 02                	jmp    8017df <readn+0x43>
  8017dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017df:	83 c4 1c             	add    $0x1c,%esp
  8017e2:	5b                   	pop    %ebx
  8017e3:	5e                   	pop    %esi
  8017e4:	5f                   	pop    %edi
  8017e5:	5d                   	pop    %ebp
  8017e6:	c3                   	ret    

008017e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	53                   	push   %ebx
  8017eb:	83 ec 24             	sub    $0x24,%esp
  8017ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f8:	89 1c 24             	mov    %ebx,(%esp)
  8017fb:	e8 76 fc ff ff       	call   801476 <fd_lookup>
  801800:	89 c2                	mov    %eax,%edx
  801802:	85 d2                	test   %edx,%edx
  801804:	78 68                	js     80186e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801806:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801809:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	8b 00                	mov    (%eax),%eax
  801812:	89 04 24             	mov    %eax,(%esp)
  801815:	e8 b2 fc ff ff       	call   8014cc <dev_lookup>
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 50                	js     80186e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801821:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801825:	75 23                	jne    80184a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801827:	a1 18 50 80 00       	mov    0x805018,%eax
  80182c:	8b 40 48             	mov    0x48(%eax),%eax
  80182f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801833:	89 44 24 04          	mov    %eax,0x4(%esp)
  801837:	c7 04 24 61 30 80 00 	movl   $0x803061,(%esp)
  80183e:	e8 ce ed ff ff       	call   800611 <cprintf>
		return -E_INVAL;
  801843:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801848:	eb 24                	jmp    80186e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80184a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184d:	8b 52 0c             	mov    0xc(%edx),%edx
  801850:	85 d2                	test   %edx,%edx
  801852:	74 15                	je     801869 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801854:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801857:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80185b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801862:	89 04 24             	mov    %eax,(%esp)
  801865:	ff d2                	call   *%edx
  801867:	eb 05                	jmp    80186e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801869:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80186e:	83 c4 24             	add    $0x24,%esp
  801871:	5b                   	pop    %ebx
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    

00801874 <seek>:

int
seek(int fdnum, off_t offset)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80187a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80187d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	89 04 24             	mov    %eax,(%esp)
  801887:	e8 ea fb ff ff       	call   801476 <fd_lookup>
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 0e                	js     80189e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801890:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801899:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 24             	sub    $0x24,%esp
  8018a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b1:	89 1c 24             	mov    %ebx,(%esp)
  8018b4:	e8 bd fb ff ff       	call   801476 <fd_lookup>
  8018b9:	89 c2                	mov    %eax,%edx
  8018bb:	85 d2                	test   %edx,%edx
  8018bd:	78 61                	js     801920 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c9:	8b 00                	mov    (%eax),%eax
  8018cb:	89 04 24             	mov    %eax,(%esp)
  8018ce:	e8 f9 fb ff ff       	call   8014cc <dev_lookup>
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 49                	js     801920 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018de:	75 23                	jne    801903 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018e0:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018e5:	8b 40 48             	mov    0x48(%eax),%eax
  8018e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f0:	c7 04 24 24 30 80 00 	movl   $0x803024,(%esp)
  8018f7:	e8 15 ed ff ff       	call   800611 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801901:	eb 1d                	jmp    801920 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801906:	8b 52 18             	mov    0x18(%edx),%edx
  801909:	85 d2                	test   %edx,%edx
  80190b:	74 0e                	je     80191b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80190d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801910:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801914:	89 04 24             	mov    %eax,(%esp)
  801917:	ff d2                	call   *%edx
  801919:	eb 05                	jmp    801920 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80191b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801920:	83 c4 24             	add    $0x24,%esp
  801923:	5b                   	pop    %ebx
  801924:	5d                   	pop    %ebp
  801925:	c3                   	ret    

00801926 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	53                   	push   %ebx
  80192a:	83 ec 24             	sub    $0x24,%esp
  80192d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801930:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801933:	89 44 24 04          	mov    %eax,0x4(%esp)
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	89 04 24             	mov    %eax,(%esp)
  80193d:	e8 34 fb ff ff       	call   801476 <fd_lookup>
  801942:	89 c2                	mov    %eax,%edx
  801944:	85 d2                	test   %edx,%edx
  801946:	78 52                	js     80199a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801948:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801952:	8b 00                	mov    (%eax),%eax
  801954:	89 04 24             	mov    %eax,(%esp)
  801957:	e8 70 fb ff ff       	call   8014cc <dev_lookup>
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 3a                	js     80199a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801963:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801967:	74 2c                	je     801995 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801969:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80196c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801973:	00 00 00 
	stat->st_isdir = 0;
  801976:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80197d:	00 00 00 
	stat->st_dev = dev;
  801980:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801986:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80198a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198d:	89 14 24             	mov    %edx,(%esp)
  801990:	ff 50 14             	call   *0x14(%eax)
  801993:	eb 05                	jmp    80199a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801995:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80199a:	83 c4 24             	add    $0x24,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    

008019a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019af:	00 
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	89 04 24             	mov    %eax,(%esp)
  8019b6:	e8 99 02 00 00       	call   801c54 <open>
  8019bb:	89 c3                	mov    %eax,%ebx
  8019bd:	85 db                	test   %ebx,%ebx
  8019bf:	78 1b                	js     8019dc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8019c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c8:	89 1c 24             	mov    %ebx,(%esp)
  8019cb:	e8 56 ff ff ff       	call   801926 <fstat>
  8019d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019d2:	89 1c 24             	mov    %ebx,(%esp)
  8019d5:	e8 cd fb ff ff       	call   8015a7 <close>
	return r;
  8019da:	89 f0                	mov    %esi,%eax
}
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	56                   	push   %esi
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 10             	sub    $0x10,%esp
  8019eb:	89 c6                	mov    %eax,%esi
  8019ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019ef:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  8019f6:	75 11                	jne    801a09 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019ff:	e8 7b 0e 00 00       	call   80287f <ipc_find_env>
  801a04:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a09:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a10:	00 
  801a11:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a18:	00 
  801a19:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a1d:	a1 10 50 80 00       	mov    0x805010,%eax
  801a22:	89 04 24             	mov    %eax,(%esp)
  801a25:	e8 ee 0d 00 00       	call   802818 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a31:	00 
  801a32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3d:	e8 6e 0d 00 00       	call   8027b0 <ipc_recv>
}
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 40 0c             	mov    0xc(%eax),%eax
  801a55:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	b8 02 00 00 00       	mov    $0x2,%eax
  801a6c:	e8 72 ff ff ff       	call   8019e3 <fsipc>
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a84:	ba 00 00 00 00       	mov    $0x0,%edx
  801a89:	b8 06 00 00 00       	mov    $0x6,%eax
  801a8e:	e8 50 ff ff ff       	call   8019e3 <fsipc>
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	53                   	push   %ebx
  801a99:	83 ec 14             	sub    $0x14,%esp
  801a9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ab4:	e8 2a ff ff ff       	call   8019e3 <fsipc>
  801ab9:	89 c2                	mov    %eax,%edx
  801abb:	85 d2                	test   %edx,%edx
  801abd:	78 2b                	js     801aea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801abf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ac6:	00 
  801ac7:	89 1c 24             	mov    %ebx,(%esp)
  801aca:	e8 b8 f1 ff ff       	call   800c87 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801acf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ad4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ada:	a1 84 60 80 00       	mov    0x806084,%eax
  801adf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aea:	83 c4 14             	add    $0x14,%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	53                   	push   %ebx
  801af4:	83 ec 14             	sub    $0x14,%esp
  801af7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801afa:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801b00:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801b05:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b08:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0b:	8b 52 0c             	mov    0xc(%edx),%edx
  801b0e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801b14:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801b19:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b24:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b2b:	e8 f4 f2 ff ff       	call   800e24 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801b30:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801b37:	00 
  801b38:	c7 04 24 94 30 80 00 	movl   $0x803094,(%esp)
  801b3f:	e8 cd ea ff ff       	call   800611 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b44:	ba 00 00 00 00       	mov    $0x0,%edx
  801b49:	b8 04 00 00 00       	mov    $0x4,%eax
  801b4e:	e8 90 fe ff ff       	call   8019e3 <fsipc>
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 53                	js     801baa <devfile_write+0xba>
		return r;
	assert(r <= n);
  801b57:	39 c3                	cmp    %eax,%ebx
  801b59:	73 24                	jae    801b7f <devfile_write+0x8f>
  801b5b:	c7 44 24 0c 99 30 80 	movl   $0x803099,0xc(%esp)
  801b62:	00 
  801b63:	c7 44 24 08 a0 30 80 	movl   $0x8030a0,0x8(%esp)
  801b6a:	00 
  801b6b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801b72:	00 
  801b73:	c7 04 24 b5 30 80 00 	movl   $0x8030b5,(%esp)
  801b7a:	e8 d7 0b 00 00       	call   802756 <_panic>
	assert(r <= PGSIZE);
  801b7f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b84:	7e 24                	jle    801baa <devfile_write+0xba>
  801b86:	c7 44 24 0c c0 30 80 	movl   $0x8030c0,0xc(%esp)
  801b8d:	00 
  801b8e:	c7 44 24 08 a0 30 80 	movl   $0x8030a0,0x8(%esp)
  801b95:	00 
  801b96:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801b9d:	00 
  801b9e:	c7 04 24 b5 30 80 00 	movl   $0x8030b5,(%esp)
  801ba5:	e8 ac 0b 00 00       	call   802756 <_panic>
	return r;
}
  801baa:	83 c4 14             	add    $0x14,%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    

00801bb0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 10             	sub    $0x10,%esp
  801bb8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bc6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd1:	b8 03 00 00 00       	mov    $0x3,%eax
  801bd6:	e8 08 fe ff ff       	call   8019e3 <fsipc>
  801bdb:	89 c3                	mov    %eax,%ebx
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	78 6a                	js     801c4b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801be1:	39 c6                	cmp    %eax,%esi
  801be3:	73 24                	jae    801c09 <devfile_read+0x59>
  801be5:	c7 44 24 0c 99 30 80 	movl   $0x803099,0xc(%esp)
  801bec:	00 
  801bed:	c7 44 24 08 a0 30 80 	movl   $0x8030a0,0x8(%esp)
  801bf4:	00 
  801bf5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801bfc:	00 
  801bfd:	c7 04 24 b5 30 80 00 	movl   $0x8030b5,(%esp)
  801c04:	e8 4d 0b 00 00       	call   802756 <_panic>
	assert(r <= PGSIZE);
  801c09:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c0e:	7e 24                	jle    801c34 <devfile_read+0x84>
  801c10:	c7 44 24 0c c0 30 80 	movl   $0x8030c0,0xc(%esp)
  801c17:	00 
  801c18:	c7 44 24 08 a0 30 80 	movl   $0x8030a0,0x8(%esp)
  801c1f:	00 
  801c20:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c27:	00 
  801c28:	c7 04 24 b5 30 80 00 	movl   $0x8030b5,(%esp)
  801c2f:	e8 22 0b 00 00       	call   802756 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c34:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c38:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c3f:	00 
  801c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c43:	89 04 24             	mov    %eax,(%esp)
  801c46:	e8 d9 f1 ff ff       	call   800e24 <memmove>
	return r;
}
  801c4b:	89 d8                	mov    %ebx,%eax
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5e                   	pop    %esi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    

00801c54 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	53                   	push   %ebx
  801c58:	83 ec 24             	sub    $0x24,%esp
  801c5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c5e:	89 1c 24             	mov    %ebx,(%esp)
  801c61:	e8 ea ef ff ff       	call   800c50 <strlen>
  801c66:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c6b:	7f 60                	jg     801ccd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c70:	89 04 24             	mov    %eax,(%esp)
  801c73:	e8 af f7 ff ff       	call   801427 <fd_alloc>
  801c78:	89 c2                	mov    %eax,%edx
  801c7a:	85 d2                	test   %edx,%edx
  801c7c:	78 54                	js     801cd2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c82:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c89:	e8 f9 ef ff ff       	call   800c87 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c91:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c99:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9e:	e8 40 fd ff ff       	call   8019e3 <fsipc>
  801ca3:	89 c3                	mov    %eax,%ebx
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	79 17                	jns    801cc0 <open+0x6c>
		fd_close(fd, 0);
  801ca9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cb0:	00 
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	89 04 24             	mov    %eax,(%esp)
  801cb7:	e8 6a f8 ff ff       	call   801526 <fd_close>
		return r;
  801cbc:	89 d8                	mov    %ebx,%eax
  801cbe:	eb 12                	jmp    801cd2 <open+0x7e>
	}

	return fd2num(fd);
  801cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc3:	89 04 24             	mov    %eax,(%esp)
  801cc6:	e8 35 f7 ff ff       	call   801400 <fd2num>
  801ccb:	eb 05                	jmp    801cd2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801ccd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801cd2:	83 c4 24             	add    $0x24,%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    

00801cd8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cde:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce3:	b8 08 00 00 00       	mov    $0x8,%eax
  801ce8:	e8 f6 fc ff ff       	call   8019e3 <fsipc>
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <evict>:

int evict(void)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801cf5:	c7 04 24 cc 30 80 00 	movl   $0x8030cc,(%esp)
  801cfc:	e8 10 e9 ff ff       	call   800611 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801d01:	ba 00 00 00 00       	mov    $0x0,%edx
  801d06:	b8 09 00 00 00       	mov    $0x9,%eax
  801d0b:	e8 d3 fc ff ff       	call   8019e3 <fsipc>
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	66 90                	xchg   %ax,%ax
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	66 90                	xchg   %ax,%ax
  801d1a:	66 90                	xchg   %ax,%ax
  801d1c:	66 90                	xchg   %ax,%ax
  801d1e:	66 90                	xchg   %ax,%ax

00801d20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d26:	c7 44 24 04 e5 30 80 	movl   $0x8030e5,0x4(%esp)
  801d2d:	00 
  801d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d31:	89 04 24             	mov    %eax,(%esp)
  801d34:	e8 4e ef ff ff       	call   800c87 <strcpy>
	return 0;
}
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	53                   	push   %ebx
  801d44:	83 ec 14             	sub    $0x14,%esp
  801d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d4a:	89 1c 24             	mov    %ebx,(%esp)
  801d4d:	e8 65 0b 00 00       	call   8028b7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d57:	83 f8 01             	cmp    $0x1,%eax
  801d5a:	75 0d                	jne    801d69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d5f:	89 04 24             	mov    %eax,(%esp)
  801d62:	e8 29 03 00 00       	call   802090 <nsipc_close>
  801d67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d69:	89 d0                	mov    %edx,%eax
  801d6b:	83 c4 14             	add    $0x14,%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d7e:	00 
  801d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	8b 40 0c             	mov    0xc(%eax),%eax
  801d93:	89 04 24             	mov    %eax,(%esp)
  801d96:	e8 f0 03 00 00       	call   80218b <nsipc_send>
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801da3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801daa:	00 
  801dab:	8b 45 10             	mov    0x10(%ebp),%eax
  801dae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbf:	89 04 24             	mov    %eax,(%esp)
  801dc2:	e8 44 03 00 00       	call   80210b <nsipc_recv>
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dcf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dd2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dd6:	89 04 24             	mov    %eax,(%esp)
  801dd9:	e8 98 f6 ff ff       	call   801476 <fd_lookup>
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 17                	js     801df9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de5:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801deb:	39 08                	cmp    %ecx,(%eax)
  801ded:	75 05                	jne    801df4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801def:	8b 40 0c             	mov    0xc(%eax),%eax
  801df2:	eb 05                	jmp    801df9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801df4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	83 ec 20             	sub    $0x20,%esp
  801e03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e08:	89 04 24             	mov    %eax,(%esp)
  801e0b:	e8 17 f6 ff ff       	call   801427 <fd_alloc>
  801e10:	89 c3                	mov    %eax,%ebx
  801e12:	85 c0                	test   %eax,%eax
  801e14:	78 21                	js     801e37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e1d:	00 
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e2c:	e8 c4 f2 ff ff       	call   8010f5 <sys_page_alloc>
  801e31:	89 c3                	mov    %eax,%ebx
  801e33:	85 c0                	test   %eax,%eax
  801e35:	79 0c                	jns    801e43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e37:	89 34 24             	mov    %esi,(%esp)
  801e3a:	e8 51 02 00 00       	call   802090 <nsipc_close>
		return r;
  801e3f:	89 d8                	mov    %ebx,%eax
  801e41:	eb 20                	jmp    801e63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e43:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e5b:	89 14 24             	mov    %edx,(%esp)
  801e5e:	e8 9d f5 ff ff       	call   801400 <fd2num>
}
  801e63:	83 c4 20             	add    $0x20,%esp
  801e66:	5b                   	pop    %ebx
  801e67:	5e                   	pop    %esi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	e8 51 ff ff ff       	call   801dc9 <fd2sockid>
		return r;
  801e78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 23                	js     801ea1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e7e:	8b 55 10             	mov    0x10(%ebp),%edx
  801e81:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e8c:	89 04 24             	mov    %eax,(%esp)
  801e8f:	e8 45 01 00 00       	call   801fd9 <nsipc_accept>
		return r;
  801e94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 07                	js     801ea1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e9a:	e8 5c ff ff ff       	call   801dfb <alloc_sockfd>
  801e9f:	89 c1                	mov    %eax,%ecx
}
  801ea1:	89 c8                	mov    %ecx,%eax
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	e8 16 ff ff ff       	call   801dc9 <fd2sockid>
  801eb3:	89 c2                	mov    %eax,%edx
  801eb5:	85 d2                	test   %edx,%edx
  801eb7:	78 16                	js     801ecf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec7:	89 14 24             	mov    %edx,(%esp)
  801eca:	e8 60 01 00 00       	call   80202f <nsipc_bind>
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <shutdown>:

int
shutdown(int s, int how)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	e8 ea fe ff ff       	call   801dc9 <fd2sockid>
  801edf:	89 c2                	mov    %eax,%edx
  801ee1:	85 d2                	test   %edx,%edx
  801ee3:	78 0f                	js     801ef4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eec:	89 14 24             	mov    %edx,(%esp)
  801eef:	e8 7a 01 00 00       	call   80206e <nsipc_shutdown>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	e8 c5 fe ff ff       	call   801dc9 <fd2sockid>
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	85 d2                	test   %edx,%edx
  801f08:	78 16                	js     801f20 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f18:	89 14 24             	mov    %edx,(%esp)
  801f1b:	e8 8a 01 00 00       	call   8020aa <nsipc_connect>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <listen>:

int
listen(int s, int backlog)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	e8 99 fe ff ff       	call   801dc9 <fd2sockid>
  801f30:	89 c2                	mov    %eax,%edx
  801f32:	85 d2                	test   %edx,%edx
  801f34:	78 0f                	js     801f45 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3d:	89 14 24             	mov    %edx,(%esp)
  801f40:	e8 a4 01 00 00       	call   8020e9 <nsipc_listen>
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	89 04 24             	mov    %eax,(%esp)
  801f61:	e8 98 02 00 00       	call   8021fe <nsipc_socket>
  801f66:	89 c2                	mov    %eax,%edx
  801f68:	85 d2                	test   %edx,%edx
  801f6a:	78 05                	js     801f71 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f6c:	e8 8a fe ff ff       	call   801dfb <alloc_sockfd>
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	53                   	push   %ebx
  801f77:	83 ec 14             	sub    $0x14,%esp
  801f7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f7c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801f83:	75 11                	jne    801f96 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f85:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f8c:	e8 ee 08 00 00       	call   80287f <ipc_find_env>
  801f91:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f96:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f9d:	00 
  801f9e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801fa5:	00 
  801fa6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801faa:	a1 14 50 80 00       	mov    0x805014,%eax
  801faf:	89 04 24             	mov    %eax,(%esp)
  801fb2:	e8 61 08 00 00       	call   802818 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fb7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fbe:	00 
  801fbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fc6:	00 
  801fc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fce:	e8 dd 07 00 00       	call   8027b0 <ipc_recv>
}
  801fd3:	83 c4 14             	add    $0x14,%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5d                   	pop    %ebp
  801fd8:	c3                   	ret    

00801fd9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	56                   	push   %esi
  801fdd:	53                   	push   %ebx
  801fde:	83 ec 10             	sub    $0x10,%esp
  801fe1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fec:	8b 06                	mov    (%esi),%eax
  801fee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ff3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff8:	e8 76 ff ff ff       	call   801f73 <nsipc>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 23                	js     802026 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802003:	a1 10 70 80 00       	mov    0x807010,%eax
  802008:	89 44 24 08          	mov    %eax,0x8(%esp)
  80200c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802013:	00 
  802014:	8b 45 0c             	mov    0xc(%ebp),%eax
  802017:	89 04 24             	mov    %eax,(%esp)
  80201a:	e8 05 ee ff ff       	call   800e24 <memmove>
		*addrlen = ret->ret_addrlen;
  80201f:	a1 10 70 80 00       	mov    0x807010,%eax
  802024:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802026:	89 d8                	mov    %ebx,%eax
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5d                   	pop    %ebp
  80202e:	c3                   	ret    

0080202f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	53                   	push   %ebx
  802033:	83 ec 14             	sub    $0x14,%esp
  802036:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802041:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802045:	8b 45 0c             	mov    0xc(%ebp),%eax
  802048:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802053:	e8 cc ed ff ff       	call   800e24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802058:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80205e:	b8 02 00 00 00       	mov    $0x2,%eax
  802063:	e8 0b ff ff ff       	call   801f73 <nsipc>
}
  802068:	83 c4 14             	add    $0x14,%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5d                   	pop    %ebp
  80206d:	c3                   	ret    

0080206e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802084:	b8 03 00 00 00       	mov    $0x3,%eax
  802089:	e8 e5 fe ff ff       	call   801f73 <nsipc>
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <nsipc_close>:

int
nsipc_close(int s)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80209e:	b8 04 00 00 00       	mov    $0x4,%eax
  8020a3:	e8 cb fe ff ff       	call   801f73 <nsipc>
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	53                   	push   %ebx
  8020ae:	83 ec 14             	sub    $0x14,%esp
  8020b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020ce:	e8 51 ed ff ff       	call   800e24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020d3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8020de:	e8 90 fe ff ff       	call   801f73 <nsipc>
}
  8020e3:	83 c4 14             	add    $0x14,%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    

008020e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802104:	e8 6a fe ff ff       	call   801f73 <nsipc>
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	56                   	push   %esi
  80210f:	53                   	push   %ebx
  802110:	83 ec 10             	sub    $0x10,%esp
  802113:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80211e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802124:	8b 45 14             	mov    0x14(%ebp),%eax
  802127:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80212c:	b8 07 00 00 00       	mov    $0x7,%eax
  802131:	e8 3d fe ff ff       	call   801f73 <nsipc>
  802136:	89 c3                	mov    %eax,%ebx
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 46                	js     802182 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80213c:	39 f0                	cmp    %esi,%eax
  80213e:	7f 07                	jg     802147 <nsipc_recv+0x3c>
  802140:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802145:	7e 24                	jle    80216b <nsipc_recv+0x60>
  802147:	c7 44 24 0c f1 30 80 	movl   $0x8030f1,0xc(%esp)
  80214e:	00 
  80214f:	c7 44 24 08 a0 30 80 	movl   $0x8030a0,0x8(%esp)
  802156:	00 
  802157:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80215e:	00 
  80215f:	c7 04 24 06 31 80 00 	movl   $0x803106,(%esp)
  802166:	e8 eb 05 00 00       	call   802756 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80216b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802176:	00 
  802177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217a:	89 04 24             	mov    %eax,(%esp)
  80217d:	e8 a2 ec ff ff       	call   800e24 <memmove>
	}

	return r;
}
  802182:	89 d8                	mov    %ebx,%eax
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    

0080218b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	53                   	push   %ebx
  80218f:	83 ec 14             	sub    $0x14,%esp
  802192:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80219d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021a3:	7e 24                	jle    8021c9 <nsipc_send+0x3e>
  8021a5:	c7 44 24 0c 12 31 80 	movl   $0x803112,0xc(%esp)
  8021ac:	00 
  8021ad:	c7 44 24 08 a0 30 80 	movl   $0x8030a0,0x8(%esp)
  8021b4:	00 
  8021b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8021bc:	00 
  8021bd:	c7 04 24 06 31 80 00 	movl   $0x803106,(%esp)
  8021c4:	e8 8d 05 00 00       	call   802756 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8021db:	e8 44 ec ff ff       	call   800e24 <memmove>
	nsipcbuf.send.req_size = size;
  8021e0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8021f3:	e8 7b fd ff ff       	call   801f73 <nsipc>
}
  8021f8:	83 c4 14             	add    $0x14,%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    

008021fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80220c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802214:	8b 45 10             	mov    0x10(%ebp),%eax
  802217:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80221c:	b8 09 00 00 00       	mov    $0x9,%eax
  802221:	e8 4d fd ff ff       	call   801f73 <nsipc>
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	56                   	push   %esi
  80222c:	53                   	push   %ebx
  80222d:	83 ec 10             	sub    $0x10,%esp
  802230:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 d2 f1 ff ff       	call   801410 <fd2data>
  80223e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802240:	c7 44 24 04 1e 31 80 	movl   $0x80311e,0x4(%esp)
  802247:	00 
  802248:	89 1c 24             	mov    %ebx,(%esp)
  80224b:	e8 37 ea ff ff       	call   800c87 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802250:	8b 46 04             	mov    0x4(%esi),%eax
  802253:	2b 06                	sub    (%esi),%eax
  802255:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80225b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802262:	00 00 00 
	stat->st_dev = &devpipe;
  802265:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80226c:	40 80 00 
	return 0;
}
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    

0080227b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	53                   	push   %ebx
  80227f:	83 ec 14             	sub    $0x14,%esp
  802282:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802285:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802290:	e8 07 ef ff ff       	call   80119c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802295:	89 1c 24             	mov    %ebx,(%esp)
  802298:	e8 73 f1 ff ff       	call   801410 <fd2data>
  80229d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a8:	e8 ef ee ff ff       	call   80119c <sys_page_unmap>
}
  8022ad:	83 c4 14             	add    $0x14,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    

008022b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	57                   	push   %edi
  8022b7:	56                   	push   %esi
  8022b8:	53                   	push   %ebx
  8022b9:	83 ec 2c             	sub    $0x2c,%esp
  8022bc:	89 c6                	mov    %eax,%esi
  8022be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8022c1:	a1 18 50 80 00       	mov    0x805018,%eax
  8022c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022c9:	89 34 24             	mov    %esi,(%esp)
  8022cc:	e8 e6 05 00 00       	call   8028b7 <pageref>
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d6:	89 04 24             	mov    %eax,(%esp)
  8022d9:	e8 d9 05 00 00       	call   8028b7 <pageref>
  8022de:	39 c7                	cmp    %eax,%edi
  8022e0:	0f 94 c2             	sete   %dl
  8022e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8022e6:	8b 0d 18 50 80 00    	mov    0x805018,%ecx
  8022ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8022ef:	39 fb                	cmp    %edi,%ebx
  8022f1:	74 21                	je     802314 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8022f3:	84 d2                	test   %dl,%dl
  8022f5:	74 ca                	je     8022c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8022fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802302:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802306:	c7 04 24 25 31 80 00 	movl   $0x803125,(%esp)
  80230d:	e8 ff e2 ff ff       	call   800611 <cprintf>
  802312:	eb ad                	jmp    8022c1 <_pipeisclosed+0xe>
	}
}
  802314:	83 c4 2c             	add    $0x2c,%esp
  802317:	5b                   	pop    %ebx
  802318:	5e                   	pop    %esi
  802319:	5f                   	pop    %edi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    

0080231c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	57                   	push   %edi
  802320:	56                   	push   %esi
  802321:	53                   	push   %ebx
  802322:	83 ec 1c             	sub    $0x1c,%esp
  802325:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802328:	89 34 24             	mov    %esi,(%esp)
  80232b:	e8 e0 f0 ff ff       	call   801410 <fd2data>
  802330:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802332:	bf 00 00 00 00       	mov    $0x0,%edi
  802337:	eb 45                	jmp    80237e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802339:	89 da                	mov    %ebx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	e8 71 ff ff ff       	call   8022b3 <_pipeisclosed>
  802342:	85 c0                	test   %eax,%eax
  802344:	75 41                	jne    802387 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802346:	e8 8b ed ff ff       	call   8010d6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80234b:	8b 43 04             	mov    0x4(%ebx),%eax
  80234e:	8b 0b                	mov    (%ebx),%ecx
  802350:	8d 51 20             	lea    0x20(%ecx),%edx
  802353:	39 d0                	cmp    %edx,%eax
  802355:	73 e2                	jae    802339 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80235a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80235e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802361:	99                   	cltd   
  802362:	c1 ea 1b             	shr    $0x1b,%edx
  802365:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802368:	83 e1 1f             	and    $0x1f,%ecx
  80236b:	29 d1                	sub    %edx,%ecx
  80236d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802371:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802375:	83 c0 01             	add    $0x1,%eax
  802378:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80237b:	83 c7 01             	add    $0x1,%edi
  80237e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802381:	75 c8                	jne    80234b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802383:	89 f8                	mov    %edi,%eax
  802385:	eb 05                	jmp    80238c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80238c:	83 c4 1c             	add    $0x1c,%esp
  80238f:	5b                   	pop    %ebx
  802390:	5e                   	pop    %esi
  802391:	5f                   	pop    %edi
  802392:	5d                   	pop    %ebp
  802393:	c3                   	ret    

00802394 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	57                   	push   %edi
  802398:	56                   	push   %esi
  802399:	53                   	push   %ebx
  80239a:	83 ec 1c             	sub    $0x1c,%esp
  80239d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023a0:	89 3c 24             	mov    %edi,(%esp)
  8023a3:	e8 68 f0 ff ff       	call   801410 <fd2data>
  8023a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023aa:	be 00 00 00 00       	mov    $0x0,%esi
  8023af:	eb 3d                	jmp    8023ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023b1:	85 f6                	test   %esi,%esi
  8023b3:	74 04                	je     8023b9 <devpipe_read+0x25>
				return i;
  8023b5:	89 f0                	mov    %esi,%eax
  8023b7:	eb 43                	jmp    8023fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023b9:	89 da                	mov    %ebx,%edx
  8023bb:	89 f8                	mov    %edi,%eax
  8023bd:	e8 f1 fe ff ff       	call   8022b3 <_pipeisclosed>
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	75 31                	jne    8023f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023c6:	e8 0b ed ff ff       	call   8010d6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023cb:	8b 03                	mov    (%ebx),%eax
  8023cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023d0:	74 df                	je     8023b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023d2:	99                   	cltd   
  8023d3:	c1 ea 1b             	shr    $0x1b,%edx
  8023d6:	01 d0                	add    %edx,%eax
  8023d8:	83 e0 1f             	and    $0x1f,%eax
  8023db:	29 d0                	sub    %edx,%eax
  8023dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023eb:	83 c6 01             	add    $0x1,%esi
  8023ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023f1:	75 d8                	jne    8023cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023f3:	89 f0                	mov    %esi,%eax
  8023f5:	eb 05                	jmp    8023fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8023fc:	83 c4 1c             	add    $0x1c,%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5f                   	pop    %edi
  802402:	5d                   	pop    %ebp
  802403:	c3                   	ret    

00802404 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	56                   	push   %esi
  802408:	53                   	push   %ebx
  802409:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80240c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80240f:	89 04 24             	mov    %eax,(%esp)
  802412:	e8 10 f0 ff ff       	call   801427 <fd_alloc>
  802417:	89 c2                	mov    %eax,%edx
  802419:	85 d2                	test   %edx,%edx
  80241b:	0f 88 4d 01 00 00    	js     80256e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802421:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802428:	00 
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802430:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802437:	e8 b9 ec ff ff       	call   8010f5 <sys_page_alloc>
  80243c:	89 c2                	mov    %eax,%edx
  80243e:	85 d2                	test   %edx,%edx
  802440:	0f 88 28 01 00 00    	js     80256e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802446:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802449:	89 04 24             	mov    %eax,(%esp)
  80244c:	e8 d6 ef ff ff       	call   801427 <fd_alloc>
  802451:	89 c3                	mov    %eax,%ebx
  802453:	85 c0                	test   %eax,%eax
  802455:	0f 88 fe 00 00 00    	js     802559 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802462:	00 
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802471:	e8 7f ec ff ff       	call   8010f5 <sys_page_alloc>
  802476:	89 c3                	mov    %eax,%ebx
  802478:	85 c0                	test   %eax,%eax
  80247a:	0f 88 d9 00 00 00    	js     802559 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	89 04 24             	mov    %eax,(%esp)
  802486:	e8 85 ef ff ff       	call   801410 <fd2data>
  80248b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802494:	00 
  802495:	89 44 24 04          	mov    %eax,0x4(%esp)
  802499:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a0:	e8 50 ec ff ff       	call   8010f5 <sys_page_alloc>
  8024a5:	89 c3                	mov    %eax,%ebx
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	0f 88 97 00 00 00    	js     802546 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b2:	89 04 24             	mov    %eax,(%esp)
  8024b5:	e8 56 ef ff ff       	call   801410 <fd2data>
  8024ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024c1:	00 
  8024c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024cd:	00 
  8024ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d9:	e8 6b ec ff ff       	call   801149 <sys_page_map>
  8024de:	89 c3                	mov    %eax,%ebx
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	78 52                	js     802536 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024e4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8024f9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	89 04 24             	mov    %eax,(%esp)
  802514:	e8 e7 ee ff ff       	call   801400 <fd2num>
  802519:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	89 04 24             	mov    %eax,(%esp)
  802524:	e8 d7 ee ff ff       	call   801400 <fd2num>
  802529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80252c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
  802534:	eb 38                	jmp    80256e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802536:	89 74 24 04          	mov    %esi,0x4(%esp)
  80253a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802541:	e8 56 ec ff ff       	call   80119c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802554:	e8 43 ec ff ff       	call   80119c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802567:	e8 30 ec ff ff       	call   80119c <sys_page_unmap>
  80256c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80256e:	83 c4 30             	add    $0x30,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5d                   	pop    %ebp
  802574:	c3                   	ret    

00802575 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80257b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	89 04 24             	mov    %eax,(%esp)
  802588:	e8 e9 ee ff ff       	call   801476 <fd_lookup>
  80258d:	89 c2                	mov    %eax,%edx
  80258f:	85 d2                	test   %edx,%edx
  802591:	78 15                	js     8025a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	89 04 24             	mov    %eax,(%esp)
  802599:	e8 72 ee ff ff       	call   801410 <fd2data>
	return _pipeisclosed(fd, p);
  80259e:	89 c2                	mov    %eax,%edx
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	e8 0b fd ff ff       	call   8022b3 <_pipeisclosed>
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    
  8025aa:	66 90                	xchg   %ax,%ax
  8025ac:	66 90                	xchg   %ax,%ax
  8025ae:	66 90                	xchg   %ax,%ax

008025b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    

008025ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8025c0:	c7 44 24 04 3d 31 80 	movl   $0x80313d,0x4(%esp)
  8025c7:	00 
  8025c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cb:	89 04 24             	mov    %eax,(%esp)
  8025ce:	e8 b4 e6 ff ff       	call   800c87 <strcpy>
	return 0;
}
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	57                   	push   %edi
  8025de:	56                   	push   %esi
  8025df:	53                   	push   %ebx
  8025e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025f1:	eb 31                	jmp    802624 <devcons_write+0x4a>
		m = n - tot;
  8025f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8025f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8025f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8025fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802600:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802603:	89 74 24 08          	mov    %esi,0x8(%esp)
  802607:	03 45 0c             	add    0xc(%ebp),%eax
  80260a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260e:	89 3c 24             	mov    %edi,(%esp)
  802611:	e8 0e e8 ff ff       	call   800e24 <memmove>
		sys_cputs(buf, m);
  802616:	89 74 24 04          	mov    %esi,0x4(%esp)
  80261a:	89 3c 24             	mov    %edi,(%esp)
  80261d:	e8 b4 e9 ff ff       	call   800fd6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802622:	01 f3                	add    %esi,%ebx
  802624:	89 d8                	mov    %ebx,%eax
  802626:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802629:	72 c8                	jb     8025f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80262b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    

00802636 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802641:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802645:	75 07                	jne    80264e <devcons_read+0x18>
  802647:	eb 2a                	jmp    802673 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802649:	e8 88 ea ff ff       	call   8010d6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80264e:	66 90                	xchg   %ax,%ax
  802650:	e8 9f e9 ff ff       	call   800ff4 <sys_cgetc>
  802655:	85 c0                	test   %eax,%eax
  802657:	74 f0                	je     802649 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802659:	85 c0                	test   %eax,%eax
  80265b:	78 16                	js     802673 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80265d:	83 f8 04             	cmp    $0x4,%eax
  802660:	74 0c                	je     80266e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802662:	8b 55 0c             	mov    0xc(%ebp),%edx
  802665:	88 02                	mov    %al,(%edx)
	return 1;
  802667:	b8 01 00 00 00       	mov    $0x1,%eax
  80266c:	eb 05                	jmp    802673 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802681:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802688:	00 
  802689:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80268c:	89 04 24             	mov    %eax,(%esp)
  80268f:	e8 42 e9 ff ff       	call   800fd6 <sys_cputs>
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <getchar>:

int
getchar(void)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80269c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026a3:	00 
  8026a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b2:	e8 53 f0 ff ff       	call   80170a <read>
	if (r < 0)
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	78 0f                	js     8026ca <getchar+0x34>
		return r;
	if (r < 1)
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	7e 06                	jle    8026c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8026bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8026c3:	eb 05                	jmp    8026ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8026c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	89 04 24             	mov    %eax,(%esp)
  8026df:	e8 92 ed ff ff       	call   801476 <fd_lookup>
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	78 11                	js     8026f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8026f1:	39 10                	cmp    %edx,(%eax)
  8026f3:	0f 94 c0             	sete   %al
  8026f6:	0f b6 c0             	movzbl %al,%eax
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <opencons>:

int
opencons(void)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802701:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802704:	89 04 24             	mov    %eax,(%esp)
  802707:	e8 1b ed ff ff       	call   801427 <fd_alloc>
		return r;
  80270c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80270e:	85 c0                	test   %eax,%eax
  802710:	78 40                	js     802752 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802712:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802719:	00 
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802721:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802728:	e8 c8 e9 ff ff       	call   8010f5 <sys_page_alloc>
		return r;
  80272d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80272f:	85 c0                	test   %eax,%eax
  802731:	78 1f                	js     802752 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802733:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802748:	89 04 24             	mov    %eax,(%esp)
  80274b:	e8 b0 ec ff ff       	call   801400 <fd2num>
  802750:	89 c2                	mov    %eax,%edx
}
  802752:	89 d0                	mov    %edx,%eax
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	56                   	push   %esi
  80275a:	53                   	push   %ebx
  80275b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80275e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802761:	8b 35 04 40 80 00    	mov    0x804004,%esi
  802767:	e8 4b e9 ff ff       	call   8010b7 <sys_getenvid>
  80276c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802773:	8b 55 08             	mov    0x8(%ebp),%edx
  802776:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80277a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80277e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802782:	c7 04 24 4c 31 80 00 	movl   $0x80314c,(%esp)
  802789:	e8 83 de ff ff       	call   800611 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80278e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802792:	8b 45 10             	mov    0x10(%ebp),%eax
  802795:	89 04 24             	mov    %eax,(%esp)
  802798:	e8 13 de ff ff       	call   8005b0 <vcprintf>
	cprintf("\n");
  80279d:	c7 04 24 50 2c 80 00 	movl   $0x802c50,(%esp)
  8027a4:	e8 68 de ff ff       	call   800611 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027a9:	cc                   	int3   
  8027aa:	eb fd                	jmp    8027a9 <_panic+0x53>
  8027ac:	66 90                	xchg   %ax,%ax
  8027ae:	66 90                	xchg   %ax,%ax

008027b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
  8027b5:	83 ec 10             	sub    $0x10,%esp
  8027b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8027bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8027c1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8027c3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8027c8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027cb:	89 04 24             	mov    %eax,(%esp)
  8027ce:	e8 58 eb ff ff       	call   80132b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	75 26                	jne    8027fd <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8027d7:	85 f6                	test   %esi,%esi
  8027d9:	74 0a                	je     8027e5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8027db:	a1 18 50 80 00       	mov    0x805018,%eax
  8027e0:	8b 40 74             	mov    0x74(%eax),%eax
  8027e3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8027e5:	85 db                	test   %ebx,%ebx
  8027e7:	74 0a                	je     8027f3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8027e9:	a1 18 50 80 00       	mov    0x805018,%eax
  8027ee:	8b 40 78             	mov    0x78(%eax),%eax
  8027f1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8027f3:	a1 18 50 80 00       	mov    0x805018,%eax
  8027f8:	8b 40 70             	mov    0x70(%eax),%eax
  8027fb:	eb 14                	jmp    802811 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8027fd:	85 f6                	test   %esi,%esi
  8027ff:	74 06                	je     802807 <ipc_recv+0x57>
			*from_env_store = 0;
  802801:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802807:	85 db                	test   %ebx,%ebx
  802809:	74 06                	je     802811 <ipc_recv+0x61>
			*perm_store = 0;
  80280b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	5b                   	pop    %ebx
  802815:	5e                   	pop    %esi
  802816:	5d                   	pop    %ebp
  802817:	c3                   	ret    

00802818 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	57                   	push   %edi
  80281c:	56                   	push   %esi
  80281d:	53                   	push   %ebx
  80281e:	83 ec 1c             	sub    $0x1c,%esp
  802821:	8b 7d 08             	mov    0x8(%ebp),%edi
  802824:	8b 75 0c             	mov    0xc(%ebp),%esi
  802827:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80282a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80282c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802831:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802834:	8b 45 14             	mov    0x14(%ebp),%eax
  802837:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80283b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80283f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802843:	89 3c 24             	mov    %edi,(%esp)
  802846:	e8 bd ea ff ff       	call   801308 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80284b:	85 c0                	test   %eax,%eax
  80284d:	74 28                	je     802877 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80284f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802852:	74 1c                	je     802870 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802854:	c7 44 24 08 70 31 80 	movl   $0x803170,0x8(%esp)
  80285b:	00 
  80285c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802863:	00 
  802864:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  80286b:	e8 e6 fe ff ff       	call   802756 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802870:	e8 61 e8 ff ff       	call   8010d6 <sys_yield>
	}
  802875:	eb bd                	jmp    802834 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802877:	83 c4 1c             	add    $0x1c,%esp
  80287a:	5b                   	pop    %ebx
  80287b:	5e                   	pop    %esi
  80287c:	5f                   	pop    %edi
  80287d:	5d                   	pop    %ebp
  80287e:	c3                   	ret    

0080287f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802885:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80288a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80288d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802893:	8b 52 50             	mov    0x50(%edx),%edx
  802896:	39 ca                	cmp    %ecx,%edx
  802898:	75 0d                	jne    8028a7 <ipc_find_env+0x28>
			return envs[i].env_id;
  80289a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80289d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8028a2:	8b 40 40             	mov    0x40(%eax),%eax
  8028a5:	eb 0e                	jmp    8028b5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028a7:	83 c0 01             	add    $0x1,%eax
  8028aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028af:	75 d9                	jne    80288a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8028b1:	66 b8 00 00          	mov    $0x0,%ax
}
  8028b5:	5d                   	pop    %ebp
  8028b6:	c3                   	ret    

008028b7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028bd:	89 d0                	mov    %edx,%eax
  8028bf:	c1 e8 16             	shr    $0x16,%eax
  8028c2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028c9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028ce:	f6 c1 01             	test   $0x1,%cl
  8028d1:	74 1d                	je     8028f0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8028d3:	c1 ea 0c             	shr    $0xc,%edx
  8028d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028dd:	f6 c2 01             	test   $0x1,%dl
  8028e0:	74 0e                	je     8028f0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028e2:	c1 ea 0c             	shr    $0xc,%edx
  8028e5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028ec:	ef 
  8028ed:	0f b7 c0             	movzwl %ax,%eax
}
  8028f0:	5d                   	pop    %ebp
  8028f1:	c3                   	ret    
  8028f2:	66 90                	xchg   %ax,%ax
  8028f4:	66 90                	xchg   %ax,%ax
  8028f6:	66 90                	xchg   %ax,%ax
  8028f8:	66 90                	xchg   %ax,%ax
  8028fa:	66 90                	xchg   %ax,%ax
  8028fc:	66 90                	xchg   %ax,%ax
  8028fe:	66 90                	xchg   %ax,%ax

00802900 <__udivdi3>:
  802900:	55                   	push   %ebp
  802901:	57                   	push   %edi
  802902:	56                   	push   %esi
  802903:	83 ec 0c             	sub    $0xc,%esp
  802906:	8b 44 24 28          	mov    0x28(%esp),%eax
  80290a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80290e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802912:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802916:	85 c0                	test   %eax,%eax
  802918:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80291c:	89 ea                	mov    %ebp,%edx
  80291e:	89 0c 24             	mov    %ecx,(%esp)
  802921:	75 2d                	jne    802950 <__udivdi3+0x50>
  802923:	39 e9                	cmp    %ebp,%ecx
  802925:	77 61                	ja     802988 <__udivdi3+0x88>
  802927:	85 c9                	test   %ecx,%ecx
  802929:	89 ce                	mov    %ecx,%esi
  80292b:	75 0b                	jne    802938 <__udivdi3+0x38>
  80292d:	b8 01 00 00 00       	mov    $0x1,%eax
  802932:	31 d2                	xor    %edx,%edx
  802934:	f7 f1                	div    %ecx
  802936:	89 c6                	mov    %eax,%esi
  802938:	31 d2                	xor    %edx,%edx
  80293a:	89 e8                	mov    %ebp,%eax
  80293c:	f7 f6                	div    %esi
  80293e:	89 c5                	mov    %eax,%ebp
  802940:	89 f8                	mov    %edi,%eax
  802942:	f7 f6                	div    %esi
  802944:	89 ea                	mov    %ebp,%edx
  802946:	83 c4 0c             	add    $0xc,%esp
  802949:	5e                   	pop    %esi
  80294a:	5f                   	pop    %edi
  80294b:	5d                   	pop    %ebp
  80294c:	c3                   	ret    
  80294d:	8d 76 00             	lea    0x0(%esi),%esi
  802950:	39 e8                	cmp    %ebp,%eax
  802952:	77 24                	ja     802978 <__udivdi3+0x78>
  802954:	0f bd e8             	bsr    %eax,%ebp
  802957:	83 f5 1f             	xor    $0x1f,%ebp
  80295a:	75 3c                	jne    802998 <__udivdi3+0x98>
  80295c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802960:	39 34 24             	cmp    %esi,(%esp)
  802963:	0f 86 9f 00 00 00    	jbe    802a08 <__udivdi3+0x108>
  802969:	39 d0                	cmp    %edx,%eax
  80296b:	0f 82 97 00 00 00    	jb     802a08 <__udivdi3+0x108>
  802971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802978:	31 d2                	xor    %edx,%edx
  80297a:	31 c0                	xor    %eax,%eax
  80297c:	83 c4 0c             	add    $0xc,%esp
  80297f:	5e                   	pop    %esi
  802980:	5f                   	pop    %edi
  802981:	5d                   	pop    %ebp
  802982:	c3                   	ret    
  802983:	90                   	nop
  802984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802988:	89 f8                	mov    %edi,%eax
  80298a:	f7 f1                	div    %ecx
  80298c:	31 d2                	xor    %edx,%edx
  80298e:	83 c4 0c             	add    $0xc,%esp
  802991:	5e                   	pop    %esi
  802992:	5f                   	pop    %edi
  802993:	5d                   	pop    %ebp
  802994:	c3                   	ret    
  802995:	8d 76 00             	lea    0x0(%esi),%esi
  802998:	89 e9                	mov    %ebp,%ecx
  80299a:	8b 3c 24             	mov    (%esp),%edi
  80299d:	d3 e0                	shl    %cl,%eax
  80299f:	89 c6                	mov    %eax,%esi
  8029a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8029a6:	29 e8                	sub    %ebp,%eax
  8029a8:	89 c1                	mov    %eax,%ecx
  8029aa:	d3 ef                	shr    %cl,%edi
  8029ac:	89 e9                	mov    %ebp,%ecx
  8029ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029b2:	8b 3c 24             	mov    (%esp),%edi
  8029b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8029b9:	89 d6                	mov    %edx,%esi
  8029bb:	d3 e7                	shl    %cl,%edi
  8029bd:	89 c1                	mov    %eax,%ecx
  8029bf:	89 3c 24             	mov    %edi,(%esp)
  8029c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029c6:	d3 ee                	shr    %cl,%esi
  8029c8:	89 e9                	mov    %ebp,%ecx
  8029ca:	d3 e2                	shl    %cl,%edx
  8029cc:	89 c1                	mov    %eax,%ecx
  8029ce:	d3 ef                	shr    %cl,%edi
  8029d0:	09 d7                	or     %edx,%edi
  8029d2:	89 f2                	mov    %esi,%edx
  8029d4:	89 f8                	mov    %edi,%eax
  8029d6:	f7 74 24 08          	divl   0x8(%esp)
  8029da:	89 d6                	mov    %edx,%esi
  8029dc:	89 c7                	mov    %eax,%edi
  8029de:	f7 24 24             	mull   (%esp)
  8029e1:	39 d6                	cmp    %edx,%esi
  8029e3:	89 14 24             	mov    %edx,(%esp)
  8029e6:	72 30                	jb     802a18 <__udivdi3+0x118>
  8029e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029ec:	89 e9                	mov    %ebp,%ecx
  8029ee:	d3 e2                	shl    %cl,%edx
  8029f0:	39 c2                	cmp    %eax,%edx
  8029f2:	73 05                	jae    8029f9 <__udivdi3+0xf9>
  8029f4:	3b 34 24             	cmp    (%esp),%esi
  8029f7:	74 1f                	je     802a18 <__udivdi3+0x118>
  8029f9:	89 f8                	mov    %edi,%eax
  8029fb:	31 d2                	xor    %edx,%edx
  8029fd:	e9 7a ff ff ff       	jmp    80297c <__udivdi3+0x7c>
  802a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a08:	31 d2                	xor    %edx,%edx
  802a0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a0f:	e9 68 ff ff ff       	jmp    80297c <__udivdi3+0x7c>
  802a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a18:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	83 c4 0c             	add    $0xc,%esp
  802a20:	5e                   	pop    %esi
  802a21:	5f                   	pop    %edi
  802a22:	5d                   	pop    %ebp
  802a23:	c3                   	ret    
  802a24:	66 90                	xchg   %ax,%ax
  802a26:	66 90                	xchg   %ax,%ax
  802a28:	66 90                	xchg   %ax,%ax
  802a2a:	66 90                	xchg   %ax,%ax
  802a2c:	66 90                	xchg   %ax,%ax
  802a2e:	66 90                	xchg   %ax,%ax

00802a30 <__umoddi3>:
  802a30:	55                   	push   %ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	83 ec 14             	sub    $0x14,%esp
  802a36:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a3a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a3e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a42:	89 c7                	mov    %eax,%edi
  802a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a48:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a50:	89 34 24             	mov    %esi,(%esp)
  802a53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a57:	85 c0                	test   %eax,%eax
  802a59:	89 c2                	mov    %eax,%edx
  802a5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a5f:	75 17                	jne    802a78 <__umoddi3+0x48>
  802a61:	39 fe                	cmp    %edi,%esi
  802a63:	76 4b                	jbe    802ab0 <__umoddi3+0x80>
  802a65:	89 c8                	mov    %ecx,%eax
  802a67:	89 fa                	mov    %edi,%edx
  802a69:	f7 f6                	div    %esi
  802a6b:	89 d0                	mov    %edx,%eax
  802a6d:	31 d2                	xor    %edx,%edx
  802a6f:	83 c4 14             	add    $0x14,%esp
  802a72:	5e                   	pop    %esi
  802a73:	5f                   	pop    %edi
  802a74:	5d                   	pop    %ebp
  802a75:	c3                   	ret    
  802a76:	66 90                	xchg   %ax,%ax
  802a78:	39 f8                	cmp    %edi,%eax
  802a7a:	77 54                	ja     802ad0 <__umoddi3+0xa0>
  802a7c:	0f bd e8             	bsr    %eax,%ebp
  802a7f:	83 f5 1f             	xor    $0x1f,%ebp
  802a82:	75 5c                	jne    802ae0 <__umoddi3+0xb0>
  802a84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a88:	39 3c 24             	cmp    %edi,(%esp)
  802a8b:	0f 87 e7 00 00 00    	ja     802b78 <__umoddi3+0x148>
  802a91:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a95:	29 f1                	sub    %esi,%ecx
  802a97:	19 c7                	sbb    %eax,%edi
  802a99:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aa1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802aa5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802aa9:	83 c4 14             	add    $0x14,%esp
  802aac:	5e                   	pop    %esi
  802aad:	5f                   	pop    %edi
  802aae:	5d                   	pop    %ebp
  802aaf:	c3                   	ret    
  802ab0:	85 f6                	test   %esi,%esi
  802ab2:	89 f5                	mov    %esi,%ebp
  802ab4:	75 0b                	jne    802ac1 <__umoddi3+0x91>
  802ab6:	b8 01 00 00 00       	mov    $0x1,%eax
  802abb:	31 d2                	xor    %edx,%edx
  802abd:	f7 f6                	div    %esi
  802abf:	89 c5                	mov    %eax,%ebp
  802ac1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ac5:	31 d2                	xor    %edx,%edx
  802ac7:	f7 f5                	div    %ebp
  802ac9:	89 c8                	mov    %ecx,%eax
  802acb:	f7 f5                	div    %ebp
  802acd:	eb 9c                	jmp    802a6b <__umoddi3+0x3b>
  802acf:	90                   	nop
  802ad0:	89 c8                	mov    %ecx,%eax
  802ad2:	89 fa                	mov    %edi,%edx
  802ad4:	83 c4 14             	add    $0x14,%esp
  802ad7:	5e                   	pop    %esi
  802ad8:	5f                   	pop    %edi
  802ad9:	5d                   	pop    %ebp
  802ada:	c3                   	ret    
  802adb:	90                   	nop
  802adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ae0:	8b 04 24             	mov    (%esp),%eax
  802ae3:	be 20 00 00 00       	mov    $0x20,%esi
  802ae8:	89 e9                	mov    %ebp,%ecx
  802aea:	29 ee                	sub    %ebp,%esi
  802aec:	d3 e2                	shl    %cl,%edx
  802aee:	89 f1                	mov    %esi,%ecx
  802af0:	d3 e8                	shr    %cl,%eax
  802af2:	89 e9                	mov    %ebp,%ecx
  802af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af8:	8b 04 24             	mov    (%esp),%eax
  802afb:	09 54 24 04          	or     %edx,0x4(%esp)
  802aff:	89 fa                	mov    %edi,%edx
  802b01:	d3 e0                	shl    %cl,%eax
  802b03:	89 f1                	mov    %esi,%ecx
  802b05:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b09:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b0d:	d3 ea                	shr    %cl,%edx
  802b0f:	89 e9                	mov    %ebp,%ecx
  802b11:	d3 e7                	shl    %cl,%edi
  802b13:	89 f1                	mov    %esi,%ecx
  802b15:	d3 e8                	shr    %cl,%eax
  802b17:	89 e9                	mov    %ebp,%ecx
  802b19:	09 f8                	or     %edi,%eax
  802b1b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b1f:	f7 74 24 04          	divl   0x4(%esp)
  802b23:	d3 e7                	shl    %cl,%edi
  802b25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b29:	89 d7                	mov    %edx,%edi
  802b2b:	f7 64 24 08          	mull   0x8(%esp)
  802b2f:	39 d7                	cmp    %edx,%edi
  802b31:	89 c1                	mov    %eax,%ecx
  802b33:	89 14 24             	mov    %edx,(%esp)
  802b36:	72 2c                	jb     802b64 <__umoddi3+0x134>
  802b38:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b3c:	72 22                	jb     802b60 <__umoddi3+0x130>
  802b3e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b42:	29 c8                	sub    %ecx,%eax
  802b44:	19 d7                	sbb    %edx,%edi
  802b46:	89 e9                	mov    %ebp,%ecx
  802b48:	89 fa                	mov    %edi,%edx
  802b4a:	d3 e8                	shr    %cl,%eax
  802b4c:	89 f1                	mov    %esi,%ecx
  802b4e:	d3 e2                	shl    %cl,%edx
  802b50:	89 e9                	mov    %ebp,%ecx
  802b52:	d3 ef                	shr    %cl,%edi
  802b54:	09 d0                	or     %edx,%eax
  802b56:	89 fa                	mov    %edi,%edx
  802b58:	83 c4 14             	add    $0x14,%esp
  802b5b:	5e                   	pop    %esi
  802b5c:	5f                   	pop    %edi
  802b5d:	5d                   	pop    %ebp
  802b5e:	c3                   	ret    
  802b5f:	90                   	nop
  802b60:	39 d7                	cmp    %edx,%edi
  802b62:	75 da                	jne    802b3e <__umoddi3+0x10e>
  802b64:	8b 14 24             	mov    (%esp),%edx
  802b67:	89 c1                	mov    %eax,%ecx
  802b69:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b6d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b71:	eb cb                	jmp    802b3e <__umoddi3+0x10e>
  802b73:	90                   	nop
  802b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b78:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b7c:	0f 82 0f ff ff ff    	jb     802a91 <__umoddi3+0x61>
  802b82:	e9 1a ff ff ff       	jmp    802aa1 <__umoddi3+0x71>
