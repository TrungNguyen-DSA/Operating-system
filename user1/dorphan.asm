
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	92450513          	addi	a0,a0,-1756 # 930 <malloc+0xfe>
  14:	372000ef          	jal	386 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	91c50513          	addi	a0,a0,-1764 # 938 <malloc+0x106>
  24:	75a000ef          	jal	77e <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	2f4000ef          	jal	31e <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	90250513          	addi	a0,a0,-1790 # 930 <malloc+0xfe>
  36:	358000ef          	jal	38e <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	91250513          	addi	a0,a0,-1774 # 950 <malloc+0x11e>
  46:	738000ef          	jal	77e <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2d2000ef          	jal	31e <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	91850513          	addi	a0,a0,-1768 # 968 <malloc+0x136>
  58:	316000ef          	jal	36e <unlink>
  5c:	00054d63          	bltz	a0,76 <main+0x76>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	92850513          	addi	a0,a0,-1752 # 988 <malloc+0x156>
  68:	716000ef          	jal	77e <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800513          	li	a0,1000
  70:	33e000ef          	jal	3ae <pause>
  74:	bfe5                	j	6c <main+0x6c>
    printf("%s: unlink failed\n", s);
  76:	85a6                	mv	a1,s1
  78:	00001517          	auipc	a0,0x1
  7c:	8f850513          	addi	a0,a0,-1800 # 970 <malloc+0x13e>
  80:	6fe000ef          	jal	77e <printf>
    exit(1);
  84:	4505                	li	a0,1
  86:	298000ef          	jal	31e <exit>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  92:	f6fff0ef          	jal	0 <main>
  exit(r);
  96:	288000ef          	jal	31e <exit>

000000000000009a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a0:	87aa                	mv	a5,a0
  a2:	0585                	addi	a1,a1,1
  a4:	0785                	addi	a5,a5,1
  a6:	fff5c703          	lbu	a4,-1(a1)
  aa:	fee78fa3          	sb	a4,-1(a5)
  ae:	fb75                	bnez	a4,a2 <strcpy+0x8>
    ;
  return os;
}
  b0:	6422                	ld	s0,8(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cb91                	beqz	a5,d4 <strcmp+0x1e>
  c2:	0005c703          	lbu	a4,0(a1)
  c6:	00f71763          	bne	a4,a5,d4 <strcmp+0x1e>
    p++, q++;
  ca:	0505                	addi	a0,a0,1
  cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbe5                	bnez	a5,c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d4:	0005c503          	lbu	a0,0(a1)
}
  d8:	40a7853b          	subw	a0,a5,a0
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strlen>:

uint
strlen(const char *s)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cf91                	beqz	a5,108 <strlen+0x26>
  ee:	0505                	addi	a0,a0,1
  f0:	87aa                	mv	a5,a0
  f2:	86be                	mv	a3,a5
  f4:	0785                	addi	a5,a5,1
  f6:	fff7c703          	lbu	a4,-1(a5)
  fa:	ff65                	bnez	a4,f2 <strlen+0x10>
  fc:	40a6853b          	subw	a0,a3,a0
 100:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  for(n = 0; s[n]; n++)
 108:	4501                	li	a0,0
 10a:	bfe5                	j	102 <strlen+0x20>

000000000000010c <memset>:

void*
memset(void *dst, int c, uint n)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 112:	ca19                	beqz	a2,128 <memset+0x1c>
 114:	87aa                	mv	a5,a0
 116:	1602                	slli	a2,a2,0x20
 118:	9201                	srli	a2,a2,0x20
 11a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 122:	0785                	addi	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x12>
  }
  return dst;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char*
strchr(const char *s, char c)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  for(; *s; s++)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb99                	beqz	a5,14e <strchr+0x20>
    if(*s == c)
 13a:	00f58763          	beq	a1,a5,148 <strchr+0x1a>
  for(; *s; s++)
 13e:	0505                	addi	a0,a0,1
 140:	00054783          	lbu	a5,0(a0)
 144:	fbfd                	bnez	a5,13a <strchr+0xc>
      return (char*)s;
  return 0;
 146:	4501                	li	a0,0
}
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  return 0;
 14e:	4501                	li	a0,0
 150:	bfe5                	j	148 <strchr+0x1a>

0000000000000152 <gets>:

char*
gets(char *buf, int max)
{
 152:	711d                	addi	sp,sp,-96
 154:	ec86                	sd	ra,88(sp)
 156:	e8a2                	sd	s0,80(sp)
 158:	e4a6                	sd	s1,72(sp)
 15a:	e0ca                	sd	s2,64(sp)
 15c:	fc4e                	sd	s3,56(sp)
 15e:	f852                	sd	s4,48(sp)
 160:	f456                	sd	s5,40(sp)
 162:	f05a                	sd	s6,32(sp)
 164:	ec5e                	sd	s7,24(sp)
 166:	1080                	addi	s0,sp,96
 168:	8baa                	mv	s7,a0
 16a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16c:	892a                	mv	s2,a0
 16e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 170:	4aa9                	li	s5,10
 172:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 174:	89a6                	mv	s3,s1
 176:	2485                	addiw	s1,s1,1
 178:	0344d663          	bge	s1,s4,1a4 <gets+0x52>
    cc = read(0, &c, 1);
 17c:	4605                	li	a2,1
 17e:	faf40593          	addi	a1,s0,-81
 182:	4501                	li	a0,0
 184:	1b2000ef          	jal	336 <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x52>
    buf[i++] = c;
 18c:	faf44783          	lbu	a5,-81(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01578763          	beq	a5,s5,1a2 <gets+0x50>
 198:	0905                	addi	s2,s2,1
 19a:	fd679de3          	bne	a5,s6,174 <gets+0x22>
    buf[i++] = c;
 19e:	89a6                	mv	s3,s1
 1a0:	a011                	j	1a4 <gets+0x52>
 1a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a4:	99de                	add	s3,s3,s7
 1a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6125                	addi	sp,sp,96
 1c0:	8082                	ret

00000000000001c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c2:	1101                	addi	sp,sp,-32
 1c4:	ec06                	sd	ra,24(sp)
 1c6:	e822                	sd	s0,16(sp)
 1c8:	e04a                	sd	s2,0(sp)
 1ca:	1000                	addi	s0,sp,32
 1cc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ce:	4581                	li	a1,0
 1d0:	18e000ef          	jal	35e <open>
  if(fd < 0)
 1d4:	02054263          	bltz	a0,1f8 <stat+0x36>
 1d8:	e426                	sd	s1,8(sp)
 1da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	198000ef          	jal	376 <fstat>
 1e2:	892a                	mv	s2,a0
  close(fd);
 1e4:	8526                	mv	a0,s1
 1e6:	160000ef          	jal	346 <close>
  return r;
 1ea:	64a2                	ld	s1,8(sp)
}
 1ec:	854a                	mv	a0,s2
 1ee:	60e2                	ld	ra,24(sp)
 1f0:	6442                	ld	s0,16(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	addi	sp,sp,32
 1f6:	8082                	ret
    return -1;
 1f8:	597d                	li	s2,-1
 1fa:	bfcd                	j	1ec <stat+0x2a>

00000000000001fc <atoi>:

int
atoi(const char *s)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 202:	00054683          	lbu	a3,0(a0)
 206:	fd06879b          	addiw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	4625                	li	a2,9
 210:	02f66863          	bltu	a2,a5,240 <atoi+0x44>
 214:	872a                	mv	a4,a0
  n = 0;
 216:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 218:	0705                	addi	a4,a4,1
 21a:	0025179b          	slliw	a5,a0,0x2
 21e:	9fa9                	addw	a5,a5,a0
 220:	0017979b          	slliw	a5,a5,0x1
 224:	9fb5                	addw	a5,a5,a3
 226:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22a:	00074683          	lbu	a3,0(a4)
 22e:	fd06879b          	addiw	a5,a3,-48
 232:	0ff7f793          	zext.b	a5,a5
 236:	fef671e3          	bgeu	a2,a5,218 <atoi+0x1c>
  return n;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <atoi+0x3e>

0000000000000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24a:	02b57463          	bgeu	a0,a1,272 <memmove+0x2e>
    while(n-- > 0)
 24e:	00c05f63          	blez	a2,26c <memmove+0x28>
 252:	1602                	slli	a2,a2,0x20
 254:	9201                	srli	a2,a2,0x20
 256:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25a:	872a                	mv	a4,a0
      *dst++ = *src++;
 25c:	0585                	addi	a1,a1,1
 25e:	0705                	addi	a4,a4,1
 260:	fff5c683          	lbu	a3,-1(a1)
 264:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 268:	fef71ae3          	bne	a4,a5,25c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
    dst += n;
 272:	00c50733          	add	a4,a0,a2
    src += n;
 276:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 278:	fec05ae3          	blez	a2,26c <memmove+0x28>
 27c:	fff6079b          	addiw	a5,a2,-1
 280:	1782                	slli	a5,a5,0x20
 282:	9381                	srli	a5,a5,0x20
 284:	fff7c793          	not	a5,a5
 288:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28a:	15fd                	addi	a1,a1,-1
 28c:	177d                	addi	a4,a4,-1
 28e:	0005c683          	lbu	a3,0(a1)
 292:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 296:	fee79ae3          	bne	a5,a4,28a <memmove+0x46>
 29a:	bfc9                	j	26c <memmove+0x28>

000000000000029c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a2:	ca05                	beqz	a2,2d2 <memcmp+0x36>
 2a4:	fff6069b          	addiw	a3,a2,-1
 2a8:	1682                	slli	a3,a3,0x20
 2aa:	9281                	srli	a3,a3,0x20
 2ac:	0685                	addi	a3,a3,1
 2ae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00e79863          	bne	a5,a4,2c8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2bc:	0505                	addi	a0,a0,1
    p2++;
 2be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c0:	fed518e3          	bne	a0,a3,2b0 <memcmp+0x14>
  }
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	a019                	j	2cc <memcmp+0x30>
      return *p1 - *p2;
 2c8:	40e7853b          	subw	a0,a5,a4
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <memcmp+0x30>

00000000000002d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2de:	f67ff0ef          	jal	244 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <sbrk>:

char *
sbrk(int n) {
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f2:	4585                	li	a1,1
 2f4:	0b2000ef          	jal	3a6 <sys_sbrk>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <sbrklazy>:

char *
sbrklazy(int n) {
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 308:	4589                	li	a1,2
 30a:	09c000ef          	jal	3a6 <sys_sbrk>
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 316:	4885                	li	a7,1
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exit>:
.global exit
exit:
 li a7, SYS_exit
 31e:	4889                	li	a7,2
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <wait>:
.global wait
wait:
 li a7, SYS_wait
 326:	488d                	li	a7,3
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32e:	4891                	li	a7,4
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <read>:
.global read
read:
 li a7, SYS_read
 336:	4895                	li	a7,5
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <write>:
.global write
write:
 li a7, SYS_write
 33e:	48c1                	li	a7,16
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <close>:
.global close
close:
 li a7, SYS_close
 346:	48d5                	li	a7,21
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <kill>:
.global kill
kill:
 li a7, SYS_kill
 34e:	4899                	li	a7,6
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <exec>:
.global exec
exec:
 li a7, SYS_exec
 356:	489d                	li	a7,7
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <open>:
.global open
open:
 li a7, SYS_open
 35e:	48bd                	li	a7,15
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 366:	48c5                	li	a7,17
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36e:	48c9                	li	a7,18
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 376:	48a1                	li	a7,8
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <link>:
.global link
link:
 li a7, SYS_link
 37e:	48cd                	li	a7,19
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 386:	48d1                	li	a7,20
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38e:	48a5                	li	a7,9
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <dup>:
.global dup
dup:
 li a7, SYS_dup
 396:	48a9                	li	a7,10
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39e:	48ad                	li	a7,11
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a6:	48b1                	li	a7,12
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ae:	48b5                	li	a7,13
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b6:	48b9                	li	a7,14
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <hello>:
.global hello
hello:
 li a7, SYS_hello
 3be:	48d9                	li	a7,22
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3c6:	48dd                	li	a7,23
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 3ce:	48e1                	li	a7,24
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 3d6:	48e5                	li	a7,25
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 3de:	48e9                	li	a7,26
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 3e6:	48ed                	li	a7,27
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 3ee:	48f1                	li	a7,28
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f6:	1101                	addi	sp,sp,-32
 3f8:	ec06                	sd	ra,24(sp)
 3fa:	e822                	sd	s0,16(sp)
 3fc:	1000                	addi	s0,sp,32
 3fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 402:	4605                	li	a2,1
 404:	fef40593          	addi	a1,s0,-17
 408:	f37ff0ef          	jal	33e <write>
}
 40c:	60e2                	ld	ra,24(sp)
 40e:	6442                	ld	s0,16(sp)
 410:	6105                	addi	sp,sp,32
 412:	8082                	ret

0000000000000414 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 414:	715d                	addi	sp,sp,-80
 416:	e486                	sd	ra,72(sp)
 418:	e0a2                	sd	s0,64(sp)
 41a:	f84a                	sd	s2,48(sp)
 41c:	0880                	addi	s0,sp,80
 41e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 420:	c299                	beqz	a3,426 <printint+0x12>
 422:	0805c363          	bltz	a1,4a8 <printint+0x94>
  neg = 0;
 426:	4881                	li	a7,0
 428:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 42c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 42e:	00000517          	auipc	a0,0x0
 432:	58250513          	addi	a0,a0,1410 # 9b0 <digits>
 436:	883e                	mv	a6,a5
 438:	2785                	addiw	a5,a5,1
 43a:	02c5f733          	remu	a4,a1,a2
 43e:	972a                	add	a4,a4,a0
 440:	00074703          	lbu	a4,0(a4)
 444:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 448:	872e                	mv	a4,a1
 44a:	02c5d5b3          	divu	a1,a1,a2
 44e:	0685                	addi	a3,a3,1
 450:	fec773e3          	bgeu	a4,a2,436 <printint+0x22>
  if(neg)
 454:	00088b63          	beqz	a7,46a <printint+0x56>
    buf[i++] = '-';
 458:	fd078793          	addi	a5,a5,-48
 45c:	97a2                	add	a5,a5,s0
 45e:	02d00713          	li	a4,45
 462:	fee78423          	sb	a4,-24(a5)
 466:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 46a:	02f05a63          	blez	a5,49e <printint+0x8a>
 46e:	fc26                	sd	s1,56(sp)
 470:	f44e                	sd	s3,40(sp)
 472:	fb840713          	addi	a4,s0,-72
 476:	00f704b3          	add	s1,a4,a5
 47a:	fff70993          	addi	s3,a4,-1
 47e:	99be                	add	s3,s3,a5
 480:	37fd                	addiw	a5,a5,-1
 482:	1782                	slli	a5,a5,0x20
 484:	9381                	srli	a5,a5,0x20
 486:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 48a:	fff4c583          	lbu	a1,-1(s1)
 48e:	854a                	mv	a0,s2
 490:	f67ff0ef          	jal	3f6 <putc>
  while(--i >= 0)
 494:	14fd                	addi	s1,s1,-1
 496:	ff349ae3          	bne	s1,s3,48a <printint+0x76>
 49a:	74e2                	ld	s1,56(sp)
 49c:	79a2                	ld	s3,40(sp)
}
 49e:	60a6                	ld	ra,72(sp)
 4a0:	6406                	ld	s0,64(sp)
 4a2:	7942                	ld	s2,48(sp)
 4a4:	6161                	addi	sp,sp,80
 4a6:	8082                	ret
    x = -xx;
 4a8:	40b005b3          	neg	a1,a1
    neg = 1;
 4ac:	4885                	li	a7,1
    x = -xx;
 4ae:	bfad                	j	428 <printint+0x14>

00000000000004b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b0:	711d                	addi	sp,sp,-96
 4b2:	ec86                	sd	ra,88(sp)
 4b4:	e8a2                	sd	s0,80(sp)
 4b6:	e0ca                	sd	s2,64(sp)
 4b8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ba:	0005c903          	lbu	s2,0(a1)
 4be:	28090663          	beqz	s2,74a <vprintf+0x29a>
 4c2:	e4a6                	sd	s1,72(sp)
 4c4:	fc4e                	sd	s3,56(sp)
 4c6:	f852                	sd	s4,48(sp)
 4c8:	f456                	sd	s5,40(sp)
 4ca:	f05a                	sd	s6,32(sp)
 4cc:	ec5e                	sd	s7,24(sp)
 4ce:	e862                	sd	s8,16(sp)
 4d0:	e466                	sd	s9,8(sp)
 4d2:	8b2a                	mv	s6,a0
 4d4:	8a2e                	mv	s4,a1
 4d6:	8bb2                	mv	s7,a2
  state = 0;
 4d8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4da:	4481                	li	s1,0
 4dc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4de:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e6:	06c00c93          	li	s9,108
 4ea:	a005                	j	50a <vprintf+0x5a>
        putc(fd, c0);
 4ec:	85ca                	mv	a1,s2
 4ee:	855a                	mv	a0,s6
 4f0:	f07ff0ef          	jal	3f6 <putc>
 4f4:	a019                	j	4fa <vprintf+0x4a>
    } else if(state == '%'){
 4f6:	03598263          	beq	s3,s5,51a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4fa:	2485                	addiw	s1,s1,1
 4fc:	8726                	mv	a4,s1
 4fe:	009a07b3          	add	a5,s4,s1
 502:	0007c903          	lbu	s2,0(a5)
 506:	22090a63          	beqz	s2,73a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 50a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 50e:	fe0994e3          	bnez	s3,4f6 <vprintf+0x46>
      if(c0 == '%'){
 512:	fd579de3          	bne	a5,s5,4ec <vprintf+0x3c>
        state = '%';
 516:	89be                	mv	s3,a5
 518:	b7cd                	j	4fa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 51a:	00ea06b3          	add	a3,s4,a4
 51e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 522:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 524:	c681                	beqz	a3,52c <vprintf+0x7c>
 526:	9752                	add	a4,a4,s4
 528:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 52c:	05878363          	beq	a5,s8,572 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 530:	05978d63          	beq	a5,s9,58a <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 534:	07500713          	li	a4,117
 538:	0ee78763          	beq	a5,a4,626 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 53c:	07800713          	li	a4,120
 540:	12e78963          	beq	a5,a4,672 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 544:	07000713          	li	a4,112
 548:	14e78e63          	beq	a5,a4,6a4 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 54c:	06300713          	li	a4,99
 550:	18e78e63          	beq	a5,a4,6ec <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 554:	07300713          	li	a4,115
 558:	1ae78463          	beq	a5,a4,700 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 55c:	02500713          	li	a4,37
 560:	04e79563          	bne	a5,a4,5aa <vprintf+0xfa>
        putc(fd, '%');
 564:	02500593          	li	a1,37
 568:	855a                	mv	a0,s6
 56a:	e8dff0ef          	jal	3f6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 56e:	4981                	li	s3,0
 570:	b769                	j	4fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 572:	008b8913          	addi	s2,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e95ff0ef          	jal	414 <printint>
 584:	8bca                	mv	s7,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	bf8d                	j	4fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 58a:	06400793          	li	a5,100
 58e:	02f68963          	beq	a3,a5,5c0 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 592:	06c00793          	li	a5,108
 596:	04f68263          	beq	a3,a5,5da <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 59a:	07500793          	li	a5,117
 59e:	0af68063          	beq	a3,a5,63e <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5a2:	07800793          	li	a5,120
 5a6:	0ef68263          	beq	a3,a5,68a <vprintf+0x1da>
        putc(fd, '%');
 5aa:	02500593          	li	a1,37
 5ae:	855a                	mv	a0,s6
 5b0:	e47ff0ef          	jal	3f6 <putc>
        putc(fd, c0);
 5b4:	85ca                	mv	a1,s2
 5b6:	855a                	mv	a0,s6
 5b8:	e3fff0ef          	jal	3f6 <putc>
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bf35                	j	4fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000bb583          	ld	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	e47ff0ef          	jal	414 <printint>
        i += 1;
 5d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d4:	8bca                	mv	s7,s2
      state = 0;
 5d6:	4981                	li	s3,0
        i += 1;
 5d8:	b70d                	j	4fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5da:	06400793          	li	a5,100
 5de:	02f60763          	beq	a2,a5,60c <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e2:	07500793          	li	a5,117
 5e6:	06f60963          	beq	a2,a5,658 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ea:	07800793          	li	a5,120
 5ee:	faf61ee3          	bne	a2,a5,5aa <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4641                	li	a2,16
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e15ff0ef          	jal	414 <printint>
        i += 2;
 604:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	8bca                	mv	s7,s2
      state = 0;
 608:	4981                	li	s3,0
        i += 2;
 60a:	bdc5                	j	4fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8913          	addi	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000bb583          	ld	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	dfbff0ef          	jal	414 <printint>
        i += 2;
 61e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
        i += 2;
 624:	bdd9                	j	4fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 626:	008b8913          	addi	s2,s7,8
 62a:	4681                	li	a3,0
 62c:	4629                	li	a2,10
 62e:	000be583          	lwu	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	de1ff0ef          	jal	414 <printint>
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bd7d                	j	4fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	008b8913          	addi	s2,s7,8
 642:	4681                	li	a3,0
 644:	4629                	li	a2,10
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	dc9ff0ef          	jal	414 <printint>
        i += 1;
 650:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
        i += 1;
 656:	b555                	j	4fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	008b8913          	addi	s2,s7,8
 65c:	4681                	li	a3,0
 65e:	4629                	li	a2,10
 660:	000bb583          	ld	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	dafff0ef          	jal	414 <printint>
        i += 2;
 66a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	b569                	j	4fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4641                	li	a2,16
 67a:	000be583          	lwu	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	d95ff0ef          	jal	414 <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	bd8d                	j	4fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4681                	li	a3,0
 690:	4641                	li	a2,16
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	d7dff0ef          	jal	414 <printint>
        i += 1;
 69c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
        i += 1;
 6a2:	bda1                	j	4fa <vprintf+0x4a>
 6a4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a6:	008b8d13          	addi	s10,s7,8
 6aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ae:	03000593          	li	a1,48
 6b2:	855a                	mv	a0,s6
 6b4:	d43ff0ef          	jal	3f6 <putc>
  putc(fd, 'x');
 6b8:	07800593          	li	a1,120
 6bc:	855a                	mv	a0,s6
 6be:	d39ff0ef          	jal	3f6 <putc>
 6c2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c4:	00000b97          	auipc	s7,0x0
 6c8:	2ecb8b93          	addi	s7,s7,748 # 9b0 <digits>
 6cc:	03c9d793          	srli	a5,s3,0x3c
 6d0:	97de                	add	a5,a5,s7
 6d2:	0007c583          	lbu	a1,0(a5)
 6d6:	855a                	mv	a0,s6
 6d8:	d1fff0ef          	jal	3f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6dc:	0992                	slli	s3,s3,0x4
 6de:	397d                	addiw	s2,s2,-1
 6e0:	fe0916e3          	bnez	s2,6cc <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6e4:	8bea                	mv	s7,s10
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	6d02                	ld	s10,0(sp)
 6ea:	bd01                	j	4fa <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	000bc583          	lbu	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	d01ff0ef          	jal	3f6 <putc>
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bbf5                	j	4fa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 700:	008b8993          	addi	s3,s7,8
 704:	000bb903          	ld	s2,0(s7)
 708:	00090f63          	beqz	s2,726 <vprintf+0x276>
        for(; *s; s++)
 70c:	00094583          	lbu	a1,0(s2)
 710:	c195                	beqz	a1,734 <vprintf+0x284>
          putc(fd, *s);
 712:	855a                	mv	a0,s6
 714:	ce3ff0ef          	jal	3f6 <putc>
        for(; *s; s++)
 718:	0905                	addi	s2,s2,1
 71a:	00094583          	lbu	a1,0(s2)
 71e:	f9f5                	bnez	a1,712 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 720:	8bce                	mv	s7,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	bbd9                	j	4fa <vprintf+0x4a>
          s = "(null)";
 726:	00000917          	auipc	s2,0x0
 72a:	28290913          	addi	s2,s2,642 # 9a8 <malloc+0x176>
        for(; *s; s++)
 72e:	02800593          	li	a1,40
 732:	b7c5                	j	712 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 734:	8bce                	mv	s7,s3
      state = 0;
 736:	4981                	li	s3,0
 738:	b3c9                	j	4fa <vprintf+0x4a>
 73a:	64a6                	ld	s1,72(sp)
 73c:	79e2                	ld	s3,56(sp)
 73e:	7a42                	ld	s4,48(sp)
 740:	7aa2                	ld	s5,40(sp)
 742:	7b02                	ld	s6,32(sp)
 744:	6be2                	ld	s7,24(sp)
 746:	6c42                	ld	s8,16(sp)
 748:	6ca2                	ld	s9,8(sp)
    }
  }
}
 74a:	60e6                	ld	ra,88(sp)
 74c:	6446                	ld	s0,80(sp)
 74e:	6906                	ld	s2,64(sp)
 750:	6125                	addi	sp,sp,96
 752:	8082                	ret

0000000000000754 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 754:	715d                	addi	sp,sp,-80
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e010                	sd	a2,0(s0)
 75e:	e414                	sd	a3,8(s0)
 760:	e818                	sd	a4,16(s0)
 762:	ec1c                	sd	a5,24(s0)
 764:	03043023          	sd	a6,32(s0)
 768:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 770:	8622                	mv	a2,s0
 772:	d3fff0ef          	jal	4b0 <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	d0dff0ef          	jal	4b0 <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6125                	addi	sp,sp,96
 7ae:	8082                	ret

00000000000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	1141                	addi	sp,sp,-16
 7b2:	e422                	sd	s0,8(sp)
 7b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ba:	00001797          	auipc	a5,0x1
 7be:	8467b783          	ld	a5,-1978(a5) # 1000 <freep>
 7c2:	a02d                	j	7ec <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c4:	4618                	lw	a4,8(a2)
 7c6:	9f2d                	addw	a4,a4,a1
 7c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	6398                	ld	a4,0(a5)
 7ce:	6310                	ld	a2,0(a4)
 7d0:	a83d                	j	80e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d2:	ff852703          	lw	a4,-8(a0)
 7d6:	9f31                	addw	a4,a4,a2
 7d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7da:	ff053683          	ld	a3,-16(a0)
 7de:	a091                	j	822 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e7e463          	bltu	a5,a4,7ea <free+0x3a>
 7e6:	00e6ea63          	bltu	a3,a4,7fa <free+0x4a>
{
 7ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	fed7fae3          	bgeu	a5,a3,7e0 <free+0x30>
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e6e463          	bltu	a3,a4,7fa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	fee7eae3          	bltu	a5,a4,7ea <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7fa:	ff852583          	lw	a1,-8(a0)
 7fe:	6390                	ld	a2,0(a5)
 800:	02059813          	slli	a6,a1,0x20
 804:	01c85713          	srli	a4,a6,0x1c
 808:	9736                	add	a4,a4,a3
 80a:	fae60de3          	beq	a2,a4,7c4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 80e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 812:	4790                	lw	a2,8(a5)
 814:	02061593          	slli	a1,a2,0x20
 818:	01c5d713          	srli	a4,a1,0x1c
 81c:	973e                	add	a4,a4,a5
 81e:	fae68ae3          	beq	a3,a4,7d2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 822:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 824:	00000717          	auipc	a4,0x0
 828:	7cf73e23          	sd	a5,2012(a4) # 1000 <freep>
}
 82c:	6422                	ld	s0,8(sp)
 82e:	0141                	addi	sp,sp,16
 830:	8082                	ret

0000000000000832 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 832:	7139                	addi	sp,sp,-64
 834:	fc06                	sd	ra,56(sp)
 836:	f822                	sd	s0,48(sp)
 838:	f426                	sd	s1,40(sp)
 83a:	ec4e                	sd	s3,24(sp)
 83c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83e:	02051493          	slli	s1,a0,0x20
 842:	9081                	srli	s1,s1,0x20
 844:	04bd                	addi	s1,s1,15
 846:	8091                	srli	s1,s1,0x4
 848:	0014899b          	addiw	s3,s1,1
 84c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 84e:	00000517          	auipc	a0,0x0
 852:	7b253503          	ld	a0,1970(a0) # 1000 <freep>
 856:	c915                	beqz	a0,88a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85a:	4798                	lw	a4,8(a5)
 85c:	08977a63          	bgeu	a4,s1,8f0 <malloc+0xbe>
 860:	f04a                	sd	s2,32(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 868:	8a4e                	mv	s4,s3
 86a:	0009871b          	sext.w	a4,s3
 86e:	6685                	lui	a3,0x1
 870:	00d77363          	bgeu	a4,a3,876 <malloc+0x44>
 874:	6a05                	lui	s4,0x1
 876:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87e:	00000917          	auipc	s2,0x0
 882:	78290913          	addi	s2,s2,1922 # 1000 <freep>
  if(p == SBRK_ERROR)
 886:	5afd                	li	s5,-1
 888:	a081                	j	8c8 <malloc+0x96>
 88a:	f04a                	sd	s2,32(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 892:	00001797          	auipc	a5,0x1
 896:	97678793          	addi	a5,a5,-1674 # 1208 <base>
 89a:	00000717          	auipc	a4,0x0
 89e:	76f73323          	sd	a5,1894(a4) # 1000 <freep>
 8a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a8:	b7c1                	j	868 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	e118                	sd	a4,0(a0)
 8ae:	a8a9                	j	908 <malloc+0xd6>
  hp->s.size = nu;
 8b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b4:	0541                	addi	a0,a0,16
 8b6:	efbff0ef          	jal	7b0 <free>
  return freep;
 8ba:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8be:	c12d                	beqz	a0,920 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	02977263          	bgeu	a4,s1,8e8 <malloc+0xb6>
    if(p == freep)
 8c8:	00093703          	ld	a4,0(s2)
 8cc:	853e                	mv	a0,a5
 8ce:	fef719e3          	bne	a4,a5,8c0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8d2:	8552                	mv	a0,s4
 8d4:	a17ff0ef          	jal	2ea <sbrk>
  if(p == SBRK_ERROR)
 8d8:	fd551ce3          	bne	a0,s5,8b0 <malloc+0x7e>
        return 0;
 8dc:	4501                	li	a0,0
 8de:	7902                	ld	s2,32(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	a03d                	j	914 <malloc+0xe2>
 8e8:	7902                	ld	s2,32(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f0:	fae48de3          	beq	s1,a4,8aa <malloc+0x78>
        p->s.size -= nunits;
 8f4:	4137073b          	subw	a4,a4,s3
 8f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fa:	02071693          	slli	a3,a4,0x20
 8fe:	01c6d713          	srli	a4,a3,0x1c
 902:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 904:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 908:	00000717          	auipc	a4,0x0
 90c:	6ea73c23          	sd	a0,1784(a4) # 1000 <freep>
      return (void*)(p + 1);
 910:	01078513          	addi	a0,a5,16
  }
}
 914:	70e2                	ld	ra,56(sp)
 916:	7442                	ld	s0,48(sp)
 918:	74a2                	ld	s1,40(sp)
 91a:	69e2                	ld	s3,24(sp)
 91c:	6121                	addi	sp,sp,64
 91e:	8082                	ret
 920:	7902                	ld	s2,32(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
 928:	b7f5                	j	914 <malloc+0xe2>
