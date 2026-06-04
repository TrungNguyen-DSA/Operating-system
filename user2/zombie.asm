
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2a2000ef          	jal	2aa <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2a0000ef          	jal	2b2 <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	32a000ef          	jal	342 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  26:	fdbff0ef          	jal	0 <main>
  exit(r);
  2a:	288000ef          	jal	2b2 <exit>

000000000000002e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e422                	sd	s0,8(sp)
  32:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  34:	87aa                	mv	a5,a0
  36:	0585                	addi	a1,a1,1
  38:	0785                	addi	a5,a5,1
  3a:	fff5c703          	lbu	a4,-1(a1)
  3e:	fee78fa3          	sb	a4,-1(a5)
  42:	fb75                	bnez	a4,36 <strcpy+0x8>
    ;
  return os;
}
  44:	6422                	ld	s0,8(sp)
  46:	0141                	addi	sp,sp,16
  48:	8082                	ret

000000000000004a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4a:	1141                	addi	sp,sp,-16
  4c:	e422                	sd	s0,8(sp)
  4e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	cb91                	beqz	a5,68 <strcmp+0x1e>
  56:	0005c703          	lbu	a4,0(a1)
  5a:	00f71763          	bne	a4,a5,68 <strcmp+0x1e>
    p++, q++;
  5e:	0505                	addi	a0,a0,1
  60:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  62:	00054783          	lbu	a5,0(a0)
  66:	fbe5                	bnez	a5,56 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  68:	0005c503          	lbu	a0,0(a1)
}
  6c:	40a7853b          	subw	a0,a5,a0
  70:	6422                	ld	s0,8(sp)
  72:	0141                	addi	sp,sp,16
  74:	8082                	ret

0000000000000076 <strlen>:

uint
strlen(const char *s)
{
  76:	1141                	addi	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cf91                	beqz	a5,9c <strlen+0x26>
  82:	0505                	addi	a0,a0,1
  84:	87aa                	mv	a5,a0
  86:	86be                	mv	a3,a5
  88:	0785                	addi	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	ff65                	bnez	a4,86 <strlen+0x10>
  90:	40a6853b          	subw	a0,a3,a0
  94:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  96:	6422                	ld	s0,8(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret
  for(n = 0; s[n]; n++)
  9c:	4501                	li	a0,0
  9e:	bfe5                	j	96 <strlen+0x20>

00000000000000a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a6:	ca19                	beqz	a2,bc <memset+0x1c>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x12>
  }
  return dst;
}
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strchr>:

char*
strchr(const char *s, char c)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb99                	beqz	a5,e2 <strchr+0x20>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1a>
  for(; *s; s++)
  d2:	0505                	addi	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xc>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  return 0;
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strchr+0x1a>

00000000000000e6 <gets>:

char*
gets(char *buf, int max)
{
  e6:	711d                	addi	sp,sp,-96
  e8:	ec86                	sd	ra,88(sp)
  ea:	e8a2                	sd	s0,80(sp)
  ec:	e4a6                	sd	s1,72(sp)
  ee:	e0ca                	sd	s2,64(sp)
  f0:	fc4e                	sd	s3,56(sp)
  f2:	f852                	sd	s4,48(sp)
  f4:	f456                	sd	s5,40(sp)
  f6:	f05a                	sd	s6,32(sp)
  f8:	ec5e                	sd	s7,24(sp)
  fa:	1080                	addi	s0,sp,96
  fc:	8baa                	mv	s7,a0
  fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	892a                	mv	s2,a0
 102:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 104:	4aa9                	li	s5,10
 106:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 108:	89a6                	mv	s3,s1
 10a:	2485                	addiw	s1,s1,1
 10c:	0344d663          	bge	s1,s4,138 <gets+0x52>
    cc = read(0, &c, 1);
 110:	4605                	li	a2,1
 112:	faf40593          	addi	a1,s0,-81
 116:	4501                	li	a0,0
 118:	1b2000ef          	jal	2ca <read>
    if(cc < 1)
 11c:	00a05e63          	blez	a0,138 <gets+0x52>
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	01578763          	beq	a5,s5,136 <gets+0x50>
 12c:	0905                	addi	s2,s2,1
 12e:	fd679de3          	bne	a5,s6,108 <gets+0x22>
    buf[i++] = c;
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x52>
 136:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
  return buf;
}
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	addi	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e04a                	sd	s2,0(sp)
 15e:	1000                	addi	s0,sp,32
 160:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 162:	4581                	li	a1,0
 164:	18e000ef          	jal	2f2 <open>
  if(fd < 0)
 168:	02054263          	bltz	a0,18c <stat+0x36>
 16c:	e426                	sd	s1,8(sp)
 16e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 170:	85ca                	mv	a1,s2
 172:	198000ef          	jal	30a <fstat>
 176:	892a                	mv	s2,a0
  close(fd);
 178:	8526                	mv	a0,s1
 17a:	160000ef          	jal	2da <close>
  return r;
 17e:	64a2                	ld	s1,8(sp)
}
 180:	854a                	mv	a0,s2
 182:	60e2                	ld	ra,24(sp)
 184:	6442                	ld	s0,16(sp)
 186:	6902                	ld	s2,0(sp)
 188:	6105                	addi	sp,sp,32
 18a:	8082                	ret
    return -1;
 18c:	597d                	li	s2,-1
 18e:	bfcd                	j	180 <stat+0x2a>

0000000000000190 <atoi>:

int
atoi(const char *s)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 196:	00054683          	lbu	a3,0(a0)
 19a:	fd06879b          	addiw	a5,a3,-48
 19e:	0ff7f793          	zext.b	a5,a5
 1a2:	4625                	li	a2,9
 1a4:	02f66863          	bltu	a2,a5,1d4 <atoi+0x44>
 1a8:	872a                	mv	a4,a0
  n = 0;
 1aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ac:	0705                	addi	a4,a4,1
 1ae:	0025179b          	slliw	a5,a0,0x2
 1b2:	9fa9                	addw	a5,a5,a0
 1b4:	0017979b          	slliw	a5,a5,0x1
 1b8:	9fb5                	addw	a5,a5,a3
 1ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1be:	00074683          	lbu	a3,0(a4)
 1c2:	fd06879b          	addiw	a5,a3,-48
 1c6:	0ff7f793          	zext.b	a5,a5
 1ca:	fef671e3          	bgeu	a2,a5,1ac <atoi+0x1c>
  return n;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret
  n = 0;
 1d4:	4501                	li	a0,0
 1d6:	bfe5                	j	1ce <atoi+0x3e>

00000000000001d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1de:	02b57463          	bgeu	a0,a1,206 <memmove+0x2e>
    while(n-- > 0)
 1e2:	00c05f63          	blez	a2,200 <memmove+0x28>
 1e6:	1602                	slli	a2,a2,0x20
 1e8:	9201                	srli	a2,a2,0x20
 1ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f0:	0585                	addi	a1,a1,1
 1f2:	0705                	addi	a4,a4,1
 1f4:	fff5c683          	lbu	a3,-1(a1)
 1f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fc:	fef71ae3          	bne	a4,a5,1f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret
    dst += n;
 206:	00c50733          	add	a4,a0,a2
    src += n;
 20a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20c:	fec05ae3          	blez	a2,200 <memmove+0x28>
 210:	fff6079b          	addiw	a5,a2,-1
 214:	1782                	slli	a5,a5,0x20
 216:	9381                	srli	a5,a5,0x20
 218:	fff7c793          	not	a5,a5
 21c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 21e:	15fd                	addi	a1,a1,-1
 220:	177d                	addi	a4,a4,-1
 222:	0005c683          	lbu	a3,0(a1)
 226:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22a:	fee79ae3          	bne	a5,a4,21e <memmove+0x46>
 22e:	bfc9                	j	200 <memmove+0x28>

0000000000000230 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 236:	ca05                	beqz	a2,266 <memcmp+0x36>
 238:	fff6069b          	addiw	a3,a2,-1
 23c:	1682                	slli	a3,a3,0x20
 23e:	9281                	srli	a3,a3,0x20
 240:	0685                	addi	a3,a3,1
 242:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 244:	00054783          	lbu	a5,0(a0)
 248:	0005c703          	lbu	a4,0(a1)
 24c:	00e79863          	bne	a5,a4,25c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 250:	0505                	addi	a0,a0,1
    p2++;
 252:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 254:	fed518e3          	bne	a0,a3,244 <memcmp+0x14>
  }
  return 0;
 258:	4501                	li	a0,0
 25a:	a019                	j	260 <memcmp+0x30>
      return *p1 - *p2;
 25c:	40e7853b          	subw	a0,a5,a4
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  return 0;
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <memcmp+0x30>

000000000000026a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e406                	sd	ra,8(sp)
 26e:	e022                	sd	s0,0(sp)
 270:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 272:	f67ff0ef          	jal	1d8 <memmove>
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret

000000000000027e <sbrk>:

char *
sbrk(int n) {
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 286:	4585                	li	a1,1
 288:	0b2000ef          	jal	33a <sys_sbrk>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <sbrklazy>:

char *
sbrklazy(int n) {
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 29c:	4589                	li	a1,2
 29e:	09c000ef          	jal	33a <sys_sbrk>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2aa:	4885                	li	a7,1
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b2:	4889                	li	a7,2
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ba:	488d                	li	a7,3
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c2:	4891                	li	a7,4
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <read>:
.global read
read:
 li a7, SYS_read
 2ca:	4895                	li	a7,5
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <write>:
.global write
write:
 li a7, SYS_write
 2d2:	48c1                	li	a7,16
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <close>:
.global close
close:
 li a7, SYS_close
 2da:	48d5                	li	a7,21
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e2:	4899                	li	a7,6
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ea:	489d                	li	a7,7
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <open>:
.global open
open:
 li a7, SYS_open
 2f2:	48bd                	li	a7,15
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2fa:	48c5                	li	a7,17
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 302:	48c9                	li	a7,18
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30a:	48a1                	li	a7,8
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <link>:
.global link
link:
 li a7, SYS_link
 312:	48cd                	li	a7,19
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31a:	48d1                	li	a7,20
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 322:	48a5                	li	a7,9
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <dup>:
.global dup
dup:
 li a7, SYS_dup
 32a:	48a9                	li	a7,10
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 332:	48ad                	li	a7,11
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 33a:	48b1                	li	a7,12
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <pause>:
.global pause
pause:
 li a7, SYS_pause
 342:	48b5                	li	a7,13
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 34a:	48b9                	li	a7,14
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <hello>:
.global hello
hello:
 li a7, SYS_hello
 352:	48d9                	li	a7,22
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <ps>:
.global ps
ps:
 li a7, SYS_ps
 35a:	48dd                	li	a7,23
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 362:	48e1                	li	a7,24
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 36a:	48e5                	li	a7,25
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 372:	48e9                	li	a7,26
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 37a:	48ed                	li	a7,27
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 382:	48f1                	li	a7,28
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38a:	1101                	addi	sp,sp,-32
 38c:	ec06                	sd	ra,24(sp)
 38e:	e822                	sd	s0,16(sp)
 390:	1000                	addi	s0,sp,32
 392:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 396:	4605                	li	a2,1
 398:	fef40593          	addi	a1,s0,-17
 39c:	f37ff0ef          	jal	2d2 <write>
}
 3a0:	60e2                	ld	ra,24(sp)
 3a2:	6442                	ld	s0,16(sp)
 3a4:	6105                	addi	sp,sp,32
 3a6:	8082                	ret

00000000000003a8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3a8:	715d                	addi	sp,sp,-80
 3aa:	e486                	sd	ra,72(sp)
 3ac:	e0a2                	sd	s0,64(sp)
 3ae:	f84a                	sd	s2,48(sp)
 3b0:	0880                	addi	s0,sp,80
 3b2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3b4:	c299                	beqz	a3,3ba <printint+0x12>
 3b6:	0805c363          	bltz	a1,43c <printint+0x94>
  neg = 0;
 3ba:	4881                	li	a7,0
 3bc:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3c0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3c2:	00000517          	auipc	a0,0x0
 3c6:	50650513          	addi	a0,a0,1286 # 8c8 <digits>
 3ca:	883e                	mv	a6,a5
 3cc:	2785                	addiw	a5,a5,1
 3ce:	02c5f733          	remu	a4,a1,a2
 3d2:	972a                	add	a4,a4,a0
 3d4:	00074703          	lbu	a4,0(a4)
 3d8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3dc:	872e                	mv	a4,a1
 3de:	02c5d5b3          	divu	a1,a1,a2
 3e2:	0685                	addi	a3,a3,1
 3e4:	fec773e3          	bgeu	a4,a2,3ca <printint+0x22>
  if(neg)
 3e8:	00088b63          	beqz	a7,3fe <printint+0x56>
    buf[i++] = '-';
 3ec:	fd078793          	addi	a5,a5,-48
 3f0:	97a2                	add	a5,a5,s0
 3f2:	02d00713          	li	a4,45
 3f6:	fee78423          	sb	a4,-24(a5)
 3fa:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 3fe:	02f05a63          	blez	a5,432 <printint+0x8a>
 402:	fc26                	sd	s1,56(sp)
 404:	f44e                	sd	s3,40(sp)
 406:	fb840713          	addi	a4,s0,-72
 40a:	00f704b3          	add	s1,a4,a5
 40e:	fff70993          	addi	s3,a4,-1
 412:	99be                	add	s3,s3,a5
 414:	37fd                	addiw	a5,a5,-1
 416:	1782                	slli	a5,a5,0x20
 418:	9381                	srli	a5,a5,0x20
 41a:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 41e:	fff4c583          	lbu	a1,-1(s1)
 422:	854a                	mv	a0,s2
 424:	f67ff0ef          	jal	38a <putc>
  while(--i >= 0)
 428:	14fd                	addi	s1,s1,-1
 42a:	ff349ae3          	bne	s1,s3,41e <printint+0x76>
 42e:	74e2                	ld	s1,56(sp)
 430:	79a2                	ld	s3,40(sp)
}
 432:	60a6                	ld	ra,72(sp)
 434:	6406                	ld	s0,64(sp)
 436:	7942                	ld	s2,48(sp)
 438:	6161                	addi	sp,sp,80
 43a:	8082                	ret
    x = -xx;
 43c:	40b005b3          	neg	a1,a1
    neg = 1;
 440:	4885                	li	a7,1
    x = -xx;
 442:	bfad                	j	3bc <printint+0x14>

0000000000000444 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 444:	711d                	addi	sp,sp,-96
 446:	ec86                	sd	ra,88(sp)
 448:	e8a2                	sd	s0,80(sp)
 44a:	e0ca                	sd	s2,64(sp)
 44c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44e:	0005c903          	lbu	s2,0(a1)
 452:	28090663          	beqz	s2,6de <vprintf+0x29a>
 456:	e4a6                	sd	s1,72(sp)
 458:	fc4e                	sd	s3,56(sp)
 45a:	f852                	sd	s4,48(sp)
 45c:	f456                	sd	s5,40(sp)
 45e:	f05a                	sd	s6,32(sp)
 460:	ec5e                	sd	s7,24(sp)
 462:	e862                	sd	s8,16(sp)
 464:	e466                	sd	s9,8(sp)
 466:	8b2a                	mv	s6,a0
 468:	8a2e                	mv	s4,a1
 46a:	8bb2                	mv	s7,a2
  state = 0;
 46c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 46e:	4481                	li	s1,0
 470:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 472:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 476:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 47a:	06c00c93          	li	s9,108
 47e:	a005                	j	49e <vprintf+0x5a>
        putc(fd, c0);
 480:	85ca                	mv	a1,s2
 482:	855a                	mv	a0,s6
 484:	f07ff0ef          	jal	38a <putc>
 488:	a019                	j	48e <vprintf+0x4a>
    } else if(state == '%'){
 48a:	03598263          	beq	s3,s5,4ae <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 48e:	2485                	addiw	s1,s1,1
 490:	8726                	mv	a4,s1
 492:	009a07b3          	add	a5,s4,s1
 496:	0007c903          	lbu	s2,0(a5)
 49a:	22090a63          	beqz	s2,6ce <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 49e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a2:	fe0994e3          	bnez	s3,48a <vprintf+0x46>
      if(c0 == '%'){
 4a6:	fd579de3          	bne	a5,s5,480 <vprintf+0x3c>
        state = '%';
 4aa:	89be                	mv	s3,a5
 4ac:	b7cd                	j	48e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ae:	00ea06b3          	add	a3,s4,a4
 4b2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4b8:	c681                	beqz	a3,4c0 <vprintf+0x7c>
 4ba:	9752                	add	a4,a4,s4
 4bc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4c0:	05878363          	beq	a5,s8,506 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4c4:	05978d63          	beq	a5,s9,51e <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c8:	07500713          	li	a4,117
 4cc:	0ee78763          	beq	a5,a4,5ba <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4d0:	07800713          	li	a4,120
 4d4:	12e78963          	beq	a5,a4,606 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4d8:	07000713          	li	a4,112
 4dc:	14e78e63          	beq	a5,a4,638 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4e0:	06300713          	li	a4,99
 4e4:	18e78e63          	beq	a5,a4,680 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4e8:	07300713          	li	a4,115
 4ec:	1ae78463          	beq	a5,a4,694 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4f0:	02500713          	li	a4,37
 4f4:	04e79563          	bne	a5,a4,53e <vprintf+0xfa>
        putc(fd, '%');
 4f8:	02500593          	li	a1,37
 4fc:	855a                	mv	a0,s6
 4fe:	e8dff0ef          	jal	38a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 502:	4981                	li	s3,0
 504:	b769                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 506:	008b8913          	addi	s2,s7,8
 50a:	4685                	li	a3,1
 50c:	4629                	li	a2,10
 50e:	000ba583          	lw	a1,0(s7)
 512:	855a                	mv	a0,s6
 514:	e95ff0ef          	jal	3a8 <printint>
 518:	8bca                	mv	s7,s2
      state = 0;
 51a:	4981                	li	s3,0
 51c:	bf8d                	j	48e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 51e:	06400793          	li	a5,100
 522:	02f68963          	beq	a3,a5,554 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 526:	06c00793          	li	a5,108
 52a:	04f68263          	beq	a3,a5,56e <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 52e:	07500793          	li	a5,117
 532:	0af68063          	beq	a3,a5,5d2 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 536:	07800793          	li	a5,120
 53a:	0ef68263          	beq	a3,a5,61e <vprintf+0x1da>
        putc(fd, '%');
 53e:	02500593          	li	a1,37
 542:	855a                	mv	a0,s6
 544:	e47ff0ef          	jal	38a <putc>
        putc(fd, c0);
 548:	85ca                	mv	a1,s2
 54a:	855a                	mv	a0,s6
 54c:	e3fff0ef          	jal	38a <putc>
      state = 0;
 550:	4981                	li	s3,0
 552:	bf35                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 554:	008b8913          	addi	s2,s7,8
 558:	4685                	li	a3,1
 55a:	4629                	li	a2,10
 55c:	000bb583          	ld	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	e47ff0ef          	jal	3a8 <printint>
        i += 1;
 566:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 568:	8bca                	mv	s7,s2
      state = 0;
 56a:	4981                	li	s3,0
        i += 1;
 56c:	b70d                	j	48e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 56e:	06400793          	li	a5,100
 572:	02f60763          	beq	a2,a5,5a0 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 576:	07500793          	li	a5,117
 57a:	06f60963          	beq	a2,a5,5ec <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 57e:	07800793          	li	a5,120
 582:	faf61ee3          	bne	a2,a5,53e <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 586:	008b8913          	addi	s2,s7,8
 58a:	4681                	li	a3,0
 58c:	4641                	li	a2,16
 58e:	000bb583          	ld	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e15ff0ef          	jal	3a8 <printint>
        i += 2;
 598:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
        i += 2;
 59e:	bdc5                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000bb583          	ld	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	dfbff0ef          	jal	3a8 <printint>
        i += 2;
 5b2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b4:	8bca                	mv	s7,s2
      state = 0;
 5b6:	4981                	li	s3,0
        i += 2;
 5b8:	bdd9                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4681                	li	a3,0
 5c0:	4629                	li	a2,10
 5c2:	000be583          	lwu	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	de1ff0ef          	jal	3a8 <printint>
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bd7d                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4629                	li	a2,10
 5da:	000bb583          	ld	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	dc9ff0ef          	jal	3a8 <printint>
        i += 1;
 5e4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
        i += 1;
 5ea:	b555                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000bb583          	ld	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	dafff0ef          	jal	3a8 <printint>
        i += 2;
 5fe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	b569                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 606:	008b8913          	addi	s2,s7,8
 60a:	4681                	li	a3,0
 60c:	4641                	li	a2,16
 60e:	000be583          	lwu	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	d95ff0ef          	jal	3a8 <printint>
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bd8d                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61e:	008b8913          	addi	s2,s7,8
 622:	4681                	li	a3,0
 624:	4641                	li	a2,16
 626:	000bb583          	ld	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	d7dff0ef          	jal	3a8 <printint>
        i += 1;
 630:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
        i += 1;
 636:	bda1                	j	48e <vprintf+0x4a>
 638:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 63a:	008b8d13          	addi	s10,s7,8
 63e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 642:	03000593          	li	a1,48
 646:	855a                	mv	a0,s6
 648:	d43ff0ef          	jal	38a <putc>
  putc(fd, 'x');
 64c:	07800593          	li	a1,120
 650:	855a                	mv	a0,s6
 652:	d39ff0ef          	jal	38a <putc>
 656:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 658:	00000b97          	auipc	s7,0x0
 65c:	270b8b93          	addi	s7,s7,624 # 8c8 <digits>
 660:	03c9d793          	srli	a5,s3,0x3c
 664:	97de                	add	a5,a5,s7
 666:	0007c583          	lbu	a1,0(a5)
 66a:	855a                	mv	a0,s6
 66c:	d1fff0ef          	jal	38a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 670:	0992                	slli	s3,s3,0x4
 672:	397d                	addiw	s2,s2,-1
 674:	fe0916e3          	bnez	s2,660 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 678:	8bea                	mv	s7,s10
      state = 0;
 67a:	4981                	li	s3,0
 67c:	6d02                	ld	s10,0(sp)
 67e:	bd01                	j	48e <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 680:	008b8913          	addi	s2,s7,8
 684:	000bc583          	lbu	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	d01ff0ef          	jal	38a <putc>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	bbf5                	j	48e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 694:	008b8993          	addi	s3,s7,8
 698:	000bb903          	ld	s2,0(s7)
 69c:	00090f63          	beqz	s2,6ba <vprintf+0x276>
        for(; *s; s++)
 6a0:	00094583          	lbu	a1,0(s2)
 6a4:	c195                	beqz	a1,6c8 <vprintf+0x284>
          putc(fd, *s);
 6a6:	855a                	mv	a0,s6
 6a8:	ce3ff0ef          	jal	38a <putc>
        for(; *s; s++)
 6ac:	0905                	addi	s2,s2,1
 6ae:	00094583          	lbu	a1,0(s2)
 6b2:	f9f5                	bnez	a1,6a6 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6b4:	8bce                	mv	s7,s3
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bbd9                	j	48e <vprintf+0x4a>
          s = "(null)";
 6ba:	00000917          	auipc	s2,0x0
 6be:	20690913          	addi	s2,s2,518 # 8c0 <malloc+0xfa>
        for(; *s; s++)
 6c2:	02800593          	li	a1,40
 6c6:	b7c5                	j	6a6 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6c8:	8bce                	mv	s7,s3
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b3c9                	j	48e <vprintf+0x4a>
 6ce:	64a6                	ld	s1,72(sp)
 6d0:	79e2                	ld	s3,56(sp)
 6d2:	7a42                	ld	s4,48(sp)
 6d4:	7aa2                	ld	s5,40(sp)
 6d6:	7b02                	ld	s6,32(sp)
 6d8:	6be2                	ld	s7,24(sp)
 6da:	6c42                	ld	s8,16(sp)
 6dc:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6de:	60e6                	ld	ra,88(sp)
 6e0:	6446                	ld	s0,80(sp)
 6e2:	6906                	ld	s2,64(sp)
 6e4:	6125                	addi	sp,sp,96
 6e6:	8082                	ret

00000000000006e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e8:	715d                	addi	sp,sp,-80
 6ea:	ec06                	sd	ra,24(sp)
 6ec:	e822                	sd	s0,16(sp)
 6ee:	1000                	addi	s0,sp,32
 6f0:	e010                	sd	a2,0(s0)
 6f2:	e414                	sd	a3,8(s0)
 6f4:	e818                	sd	a4,16(s0)
 6f6:	ec1c                	sd	a5,24(s0)
 6f8:	03043023          	sd	a6,32(s0)
 6fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 700:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 704:	8622                	mv	a2,s0
 706:	d3fff0ef          	jal	444 <vprintf>
}
 70a:	60e2                	ld	ra,24(sp)
 70c:	6442                	ld	s0,16(sp)
 70e:	6161                	addi	sp,sp,80
 710:	8082                	ret

0000000000000712 <printf>:

void
printf(const char *fmt, ...)
{
 712:	711d                	addi	sp,sp,-96
 714:	ec06                	sd	ra,24(sp)
 716:	e822                	sd	s0,16(sp)
 718:	1000                	addi	s0,sp,32
 71a:	e40c                	sd	a1,8(s0)
 71c:	e810                	sd	a2,16(s0)
 71e:	ec14                	sd	a3,24(s0)
 720:	f018                	sd	a4,32(s0)
 722:	f41c                	sd	a5,40(s0)
 724:	03043823          	sd	a6,48(s0)
 728:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72c:	00840613          	addi	a2,s0,8
 730:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 734:	85aa                	mv	a1,a0
 736:	4505                	li	a0,1
 738:	d0dff0ef          	jal	444 <vprintf>
}
 73c:	60e2                	ld	ra,24(sp)
 73e:	6442                	ld	s0,16(sp)
 740:	6125                	addi	sp,sp,96
 742:	8082                	ret

0000000000000744 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 744:	1141                	addi	sp,sp,-16
 746:	e422                	sd	s0,8(sp)
 748:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74e:	00001797          	auipc	a5,0x1
 752:	8b27b783          	ld	a5,-1870(a5) # 1000 <freep>
 756:	a02d                	j	780 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 758:	4618                	lw	a4,8(a2)
 75a:	9f2d                	addw	a4,a4,a1
 75c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	6398                	ld	a4,0(a5)
 762:	6310                	ld	a2,0(a4)
 764:	a83d                	j	7a2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 766:	ff852703          	lw	a4,-8(a0)
 76a:	9f31                	addw	a4,a4,a2
 76c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 76e:	ff053683          	ld	a3,-16(a0)
 772:	a091                	j	7b6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	6398                	ld	a4,0(a5)
 776:	00e7e463          	bltu	a5,a4,77e <free+0x3a>
 77a:	00e6ea63          	bltu	a3,a4,78e <free+0x4a>
{
 77e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 780:	fed7fae3          	bgeu	a5,a3,774 <free+0x30>
 784:	6398                	ld	a4,0(a5)
 786:	00e6e463          	bltu	a3,a4,78e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78a:	fee7eae3          	bltu	a5,a4,77e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 78e:	ff852583          	lw	a1,-8(a0)
 792:	6390                	ld	a2,0(a5)
 794:	02059813          	slli	a6,a1,0x20
 798:	01c85713          	srli	a4,a6,0x1c
 79c:	9736                	add	a4,a4,a3
 79e:	fae60de3          	beq	a2,a4,758 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a6:	4790                	lw	a2,8(a5)
 7a8:	02061593          	slli	a1,a2,0x20
 7ac:	01c5d713          	srli	a4,a1,0x1c
 7b0:	973e                	add	a4,a4,a5
 7b2:	fae68ae3          	beq	a3,a4,766 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7b6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b8:	00001717          	auipc	a4,0x1
 7bc:	84f73423          	sd	a5,-1976(a4) # 1000 <freep>
}
 7c0:	6422                	ld	s0,8(sp)
 7c2:	0141                	addi	sp,sp,16
 7c4:	8082                	ret

00000000000007c6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c6:	7139                	addi	sp,sp,-64
 7c8:	fc06                	sd	ra,56(sp)
 7ca:	f822                	sd	s0,48(sp)
 7cc:	f426                	sd	s1,40(sp)
 7ce:	ec4e                	sd	s3,24(sp)
 7d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d2:	02051493          	slli	s1,a0,0x20
 7d6:	9081                	srli	s1,s1,0x20
 7d8:	04bd                	addi	s1,s1,15
 7da:	8091                	srli	s1,s1,0x4
 7dc:	0014899b          	addiw	s3,s1,1
 7e0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7e2:	00001517          	auipc	a0,0x1
 7e6:	81e53503          	ld	a0,-2018(a0) # 1000 <freep>
 7ea:	c915                	beqz	a0,81e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ee:	4798                	lw	a4,8(a5)
 7f0:	08977a63          	bgeu	a4,s1,884 <malloc+0xbe>
 7f4:	f04a                	sd	s2,32(sp)
 7f6:	e852                	sd	s4,16(sp)
 7f8:	e456                	sd	s5,8(sp)
 7fa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7fc:	8a4e                	mv	s4,s3
 7fe:	0009871b          	sext.w	a4,s3
 802:	6685                	lui	a3,0x1
 804:	00d77363          	bgeu	a4,a3,80a <malloc+0x44>
 808:	6a05                	lui	s4,0x1
 80a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 80e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 812:	00000917          	auipc	s2,0x0
 816:	7ee90913          	addi	s2,s2,2030 # 1000 <freep>
  if(p == SBRK_ERROR)
 81a:	5afd                	li	s5,-1
 81c:	a081                	j	85c <malloc+0x96>
 81e:	f04a                	sd	s2,32(sp)
 820:	e852                	sd	s4,16(sp)
 822:	e456                	sd	s5,8(sp)
 824:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 826:	00000797          	auipc	a5,0x0
 82a:	7ea78793          	addi	a5,a5,2026 # 1010 <base>
 82e:	00000717          	auipc	a4,0x0
 832:	7cf73923          	sd	a5,2002(a4) # 1000 <freep>
 836:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 838:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83c:	b7c1                	j	7fc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 83e:	6398                	ld	a4,0(a5)
 840:	e118                	sd	a4,0(a0)
 842:	a8a9                	j	89c <malloc+0xd6>
  hp->s.size = nu;
 844:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 848:	0541                	addi	a0,a0,16
 84a:	efbff0ef          	jal	744 <free>
  return freep;
 84e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 852:	c12d                	beqz	a0,8b4 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 854:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 856:	4798                	lw	a4,8(a5)
 858:	02977263          	bgeu	a4,s1,87c <malloc+0xb6>
    if(p == freep)
 85c:	00093703          	ld	a4,0(s2)
 860:	853e                	mv	a0,a5
 862:	fef719e3          	bne	a4,a5,854 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 866:	8552                	mv	a0,s4
 868:	a17ff0ef          	jal	27e <sbrk>
  if(p == SBRK_ERROR)
 86c:	fd551ce3          	bne	a0,s5,844 <malloc+0x7e>
        return 0;
 870:	4501                	li	a0,0
 872:	7902                	ld	s2,32(sp)
 874:	6a42                	ld	s4,16(sp)
 876:	6aa2                	ld	s5,8(sp)
 878:	6b02                	ld	s6,0(sp)
 87a:	a03d                	j	8a8 <malloc+0xe2>
 87c:	7902                	ld	s2,32(sp)
 87e:	6a42                	ld	s4,16(sp)
 880:	6aa2                	ld	s5,8(sp)
 882:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 884:	fae48de3          	beq	s1,a4,83e <malloc+0x78>
        p->s.size -= nunits;
 888:	4137073b          	subw	a4,a4,s3
 88c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 88e:	02071693          	slli	a3,a4,0x20
 892:	01c6d713          	srli	a4,a3,0x1c
 896:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 898:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89c:	00000717          	auipc	a4,0x0
 8a0:	76a73223          	sd	a0,1892(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a4:	01078513          	addi	a0,a5,16
  }
}
 8a8:	70e2                	ld	ra,56(sp)
 8aa:	7442                	ld	s0,48(sp)
 8ac:	74a2                	ld	s1,40(sp)
 8ae:	69e2                	ld	s3,24(sp)
 8b0:	6121                	addi	sp,sp,64
 8b2:	8082                	ret
 8b4:	7902                	ld	s2,32(sp)
 8b6:	6a42                	ld	s4,16(sp)
 8b8:	6aa2                	ld	s5,8(sp)
 8ba:	6b02                	ld	s6,0(sp)
 8bc:	b7f5                	j	8a8 <malloc+0xe2>
