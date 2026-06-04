
user/_stacktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <overflow>:
#include "kernel/types.h"
#include "user/user.h"

// Thêm tham số hoặc điều kiện để đánh lừa trình biên dịch
void 
overflow(int n) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    char buffer[512]; 
    buffer[0] = (char)n;
    
    if(n % 10 == 0) {
   c:	47a9                	li	a5,10
   e:	02f567bb          	remw	a5,a0,a5
  12:	cb81                	beqz	a5,22 <overflow+0x22>
        printf("Stack depth: %d\n", n);
    }
    
    // Thêm một điều kiện không bao giờ xảy ra nhưng trình biên dịch không biết
    if(n > 0) {
  14:	00904f63          	bgtz	s1,32 <overflow+0x32>
        overflow(n + 1);
    }
    
    // Ngăn chặn việc tối ưu hóa (unused result)
    if(buffer[0] == 0) return;
}
  18:	60e2                	ld	ra,24(sp)
  1a:	6442                	ld	s0,16(sp)
  1c:	64a2                	ld	s1,8(sp)
  1e:	6105                	addi	sp,sp,32
  20:	8082                	ret
        printf("Stack depth: %d\n", n);
  22:	85aa                	mv	a1,a0
  24:	00001517          	auipc	a0,0x1
  28:	8dc50513          	addi	a0,a0,-1828 # 900 <malloc+0xfc>
  2c:	724000ef          	jal	750 <printf>
  30:	b7d5                	j	14 <overflow+0x14>
        overflow(n + 1);
  32:	0014851b          	addiw	a0,s1,1
  36:	fcbff0ef          	jal	0 <overflow>
    if(buffer[0] == 0) return;
  3a:	bff9                	j	18 <overflow+0x18>

000000000000003c <main>:

int main(int argc, char *argv[]) {
  3c:	1141                	addi	sp,sp,-16
  3e:	e406                	sd	ra,8(sp)
  40:	e022                	sd	s0,0(sp)
  42:	0800                	addi	s0,sp,16
    printf("--- BAT DAU TEST TRAN STACK  ---\n");
  44:	00001517          	auipc	a0,0x1
  48:	8d450513          	addi	a0,a0,-1836 # 918 <malloc+0x114>
  4c:	704000ef          	jal	750 <printf>
    overflow(1);
  50:	4505                	li	a0,1
  52:	fafff0ef          	jal	0 <overflow>
    exit(0);
  56:	4501                	li	a0,0
  58:	298000ef          	jal	2f0 <exit>

000000000000005c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  5c:	1141                	addi	sp,sp,-16
  5e:	e406                	sd	ra,8(sp)
  60:	e022                	sd	s0,0(sp)
  62:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  64:	fd9ff0ef          	jal	3c <main>
  exit(r);
  68:	288000ef          	jal	2f0 <exit>

000000000000006c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e422                	sd	s0,8(sp)
  70:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  72:	87aa                	mv	a5,a0
  74:	0585                	addi	a1,a1,1
  76:	0785                	addi	a5,a5,1
  78:	fff5c703          	lbu	a4,-1(a1)
  7c:	fee78fa3          	sb	a4,-1(a5)
  80:	fb75                	bnez	a4,74 <strcpy+0x8>
    ;
  return os;
}
  82:	6422                	ld	s0,8(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e422                	sd	s0,8(sp)
  8c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cb91                	beqz	a5,a6 <strcmp+0x1e>
  94:	0005c703          	lbu	a4,0(a1)
  98:	00f71763          	bne	a4,a5,a6 <strcmp+0x1e>
    p++, q++;
  9c:	0505                	addi	a0,a0,1
  9e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	fbe5                	bnez	a5,94 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a6:	0005c503          	lbu	a0,0(a1)
}
  aa:	40a7853b          	subw	a0,a5,a0
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cf91                	beqz	a5,da <strlen+0x26>
  c0:	0505                	addi	a0,a0,1
  c2:	87aa                	mv	a5,a0
  c4:	86be                	mv	a3,a5
  c6:	0785                	addi	a5,a5,1
  c8:	fff7c703          	lbu	a4,-1(a5)
  cc:	ff65                	bnez	a4,c4 <strlen+0x10>
  ce:	40a6853b          	subw	a0,a3,a0
  d2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret
  for(n = 0; s[n]; n++)
  da:	4501                	li	a0,0
  dc:	bfe5                	j	d4 <strlen+0x20>

00000000000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e4:	ca19                	beqz	a2,fa <memset+0x1c>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x12>
  }
  return dst;
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e422                	sd	s0,8(sp)
 104:	0800                	addi	s0,sp,16
  for(; *s; s++)
 106:	00054783          	lbu	a5,0(a0)
 10a:	cb99                	beqz	a5,120 <strchr+0x20>
    if(*s == c)
 10c:	00f58763          	beq	a1,a5,11a <strchr+0x1a>
  for(; *s; s++)
 110:	0505                	addi	a0,a0,1
 112:	00054783          	lbu	a5,0(a0)
 116:	fbfd                	bnez	a5,10c <strchr+0xc>
      return (char*)s;
  return 0;
 118:	4501                	li	a0,0
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret
  return 0;
 120:	4501                	li	a0,0
 122:	bfe5                	j	11a <strchr+0x1a>

0000000000000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	711d                	addi	sp,sp,-96
 126:	ec86                	sd	ra,88(sp)
 128:	e8a2                	sd	s0,80(sp)
 12a:	e4a6                	sd	s1,72(sp)
 12c:	e0ca                	sd	s2,64(sp)
 12e:	fc4e                	sd	s3,56(sp)
 130:	f852                	sd	s4,48(sp)
 132:	f456                	sd	s5,40(sp)
 134:	f05a                	sd	s6,32(sp)
 136:	ec5e                	sd	s7,24(sp)
 138:	1080                	addi	s0,sp,96
 13a:	8baa                	mv	s7,a0
 13c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13e:	892a                	mv	s2,a0
 140:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 142:	4aa9                	li	s5,10
 144:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 146:	89a6                	mv	s3,s1
 148:	2485                	addiw	s1,s1,1
 14a:	0344d663          	bge	s1,s4,176 <gets+0x52>
    cc = read(0, &c, 1);
 14e:	4605                	li	a2,1
 150:	faf40593          	addi	a1,s0,-81
 154:	4501                	li	a0,0
 156:	1b2000ef          	jal	308 <read>
    if(cc < 1)
 15a:	00a05e63          	blez	a0,176 <gets+0x52>
    buf[i++] = c;
 15e:	faf44783          	lbu	a5,-81(s0)
 162:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 166:	01578763          	beq	a5,s5,174 <gets+0x50>
 16a:	0905                	addi	s2,s2,1
 16c:	fd679de3          	bne	a5,s6,146 <gets+0x22>
    buf[i++] = c;
 170:	89a6                	mv	s3,s1
 172:	a011                	j	176 <gets+0x52>
 174:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 176:	99de                	add	s3,s3,s7
 178:	00098023          	sb	zero,0(s3)
  return buf;
}
 17c:	855e                	mv	a0,s7
 17e:	60e6                	ld	ra,88(sp)
 180:	6446                	ld	s0,80(sp)
 182:	64a6                	ld	s1,72(sp)
 184:	6906                	ld	s2,64(sp)
 186:	79e2                	ld	s3,56(sp)
 188:	7a42                	ld	s4,48(sp)
 18a:	7aa2                	ld	s5,40(sp)
 18c:	7b02                	ld	s6,32(sp)
 18e:	6be2                	ld	s7,24(sp)
 190:	6125                	addi	sp,sp,96
 192:	8082                	ret

0000000000000194 <stat>:

int
stat(const char *n, struct stat *st)
{
 194:	1101                	addi	sp,sp,-32
 196:	ec06                	sd	ra,24(sp)
 198:	e822                	sd	s0,16(sp)
 19a:	e04a                	sd	s2,0(sp)
 19c:	1000                	addi	s0,sp,32
 19e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a0:	4581                	li	a1,0
 1a2:	18e000ef          	jal	330 <open>
  if(fd < 0)
 1a6:	02054263          	bltz	a0,1ca <stat+0x36>
 1aa:	e426                	sd	s1,8(sp)
 1ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ae:	85ca                	mv	a1,s2
 1b0:	198000ef          	jal	348 <fstat>
 1b4:	892a                	mv	s2,a0
  close(fd);
 1b6:	8526                	mv	a0,s1
 1b8:	160000ef          	jal	318 <close>
  return r;
 1bc:	64a2                	ld	s1,8(sp)
}
 1be:	854a                	mv	a0,s2
 1c0:	60e2                	ld	ra,24(sp)
 1c2:	6442                	ld	s0,16(sp)
 1c4:	6902                	ld	s2,0(sp)
 1c6:	6105                	addi	sp,sp,32
 1c8:	8082                	ret
    return -1;
 1ca:	597d                	li	s2,-1
 1cc:	bfcd                	j	1be <stat+0x2a>

00000000000001ce <atoi>:

int
atoi(const char *s)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d4:	00054683          	lbu	a3,0(a0)
 1d8:	fd06879b          	addiw	a5,a3,-48
 1dc:	0ff7f793          	zext.b	a5,a5
 1e0:	4625                	li	a2,9
 1e2:	02f66863          	bltu	a2,a5,212 <atoi+0x44>
 1e6:	872a                	mv	a4,a0
  n = 0;
 1e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ea:	0705                	addi	a4,a4,1
 1ec:	0025179b          	slliw	a5,a0,0x2
 1f0:	9fa9                	addw	a5,a5,a0
 1f2:	0017979b          	slliw	a5,a5,0x1
 1f6:	9fb5                	addw	a5,a5,a3
 1f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fc:	00074683          	lbu	a3,0(a4)
 200:	fd06879b          	addiw	a5,a3,-48
 204:	0ff7f793          	zext.b	a5,a5
 208:	fef671e3          	bgeu	a2,a5,1ea <atoi+0x1c>
  return n;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
  n = 0;
 212:	4501                	li	a0,0
 214:	bfe5                	j	20c <atoi+0x3e>

0000000000000216 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21c:	02b57463          	bgeu	a0,a1,244 <memmove+0x2e>
    while(n-- > 0)
 220:	00c05f63          	blez	a2,23e <memmove+0x28>
 224:	1602                	slli	a2,a2,0x20
 226:	9201                	srli	a2,a2,0x20
 228:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22c:	872a                	mv	a4,a0
      *dst++ = *src++;
 22e:	0585                	addi	a1,a1,1
 230:	0705                	addi	a4,a4,1
 232:	fff5c683          	lbu	a3,-1(a1)
 236:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23a:	fef71ae3          	bne	a4,a5,22e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
    dst += n;
 244:	00c50733          	add	a4,a0,a2
    src += n;
 248:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 24a:	fec05ae3          	blez	a2,23e <memmove+0x28>
 24e:	fff6079b          	addiw	a5,a2,-1
 252:	1782                	slli	a5,a5,0x20
 254:	9381                	srli	a5,a5,0x20
 256:	fff7c793          	not	a5,a5
 25a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25c:	15fd                	addi	a1,a1,-1
 25e:	177d                	addi	a4,a4,-1
 260:	0005c683          	lbu	a3,0(a1)
 264:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x46>
 26c:	bfc9                	j	23e <memmove+0x28>

000000000000026e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 274:	ca05                	beqz	a2,2a4 <memcmp+0x36>
 276:	fff6069b          	addiw	a3,a2,-1
 27a:	1682                	slli	a3,a3,0x20
 27c:	9281                	srli	a3,a3,0x20
 27e:	0685                	addi	a3,a3,1
 280:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 282:	00054783          	lbu	a5,0(a0)
 286:	0005c703          	lbu	a4,0(a1)
 28a:	00e79863          	bne	a5,a4,29a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28e:	0505                	addi	a0,a0,1
    p2++;
 290:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 292:	fed518e3          	bne	a0,a3,282 <memcmp+0x14>
  }
  return 0;
 296:	4501                	li	a0,0
 298:	a019                	j	29e <memcmp+0x30>
      return *p1 - *p2;
 29a:	40e7853b          	subw	a0,a5,a4
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <memcmp+0x30>

00000000000002a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b0:	f67ff0ef          	jal	216 <memmove>
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <sbrk>:

char *
sbrk(int n) {
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2c4:	4585                	li	a1,1
 2c6:	0b2000ef          	jal	378 <sys_sbrk>
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <sbrklazy>:

char *
sbrklazy(int n) {
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2da:	4589                	li	a1,2
 2dc:	09c000ef          	jal	378 <sys_sbrk>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e8:	4885                	li	a7,1
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f0:	4889                	li	a7,2
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f8:	488d                	li	a7,3
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 300:	4891                	li	a7,4
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <read>:
.global read
read:
 li a7, SYS_read
 308:	4895                	li	a7,5
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <write>:
.global write
write:
 li a7, SYS_write
 310:	48c1                	li	a7,16
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <close>:
.global close
close:
 li a7, SYS_close
 318:	48d5                	li	a7,21
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <kill>:
.global kill
kill:
 li a7, SYS_kill
 320:	4899                	li	a7,6
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <exec>:
.global exec
exec:
 li a7, SYS_exec
 328:	489d                	li	a7,7
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <open>:
.global open
open:
 li a7, SYS_open
 330:	48bd                	li	a7,15
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 338:	48c5                	li	a7,17
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 340:	48c9                	li	a7,18
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 348:	48a1                	li	a7,8
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <link>:
.global link
link:
 li a7, SYS_link
 350:	48cd                	li	a7,19
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 358:	48d1                	li	a7,20
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 360:	48a5                	li	a7,9
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <dup>:
.global dup
dup:
 li a7, SYS_dup
 368:	48a9                	li	a7,10
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 370:	48ad                	li	a7,11
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 378:	48b1                	li	a7,12
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <pause>:
.global pause
pause:
 li a7, SYS_pause
 380:	48b5                	li	a7,13
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 388:	48b9                	li	a7,14
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <hello>:
.global hello
hello:
 li a7, SYS_hello
 390:	48d9                	li	a7,22
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <ps>:
.global ps
ps:
 li a7, SYS_ps
 398:	48dd                	li	a7,23
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 3a0:	48e1                	li	a7,24
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 3a8:	48e5                	li	a7,25
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 3b0:	48e9                	li	a7,26
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 3b8:	48ed                	li	a7,27
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 3c0:	48f1                	li	a7,28
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c8:	1101                	addi	sp,sp,-32
 3ca:	ec06                	sd	ra,24(sp)
 3cc:	e822                	sd	s0,16(sp)
 3ce:	1000                	addi	s0,sp,32
 3d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d4:	4605                	li	a2,1
 3d6:	fef40593          	addi	a1,s0,-17
 3da:	f37ff0ef          	jal	310 <write>
}
 3de:	60e2                	ld	ra,24(sp)
 3e0:	6442                	ld	s0,16(sp)
 3e2:	6105                	addi	sp,sp,32
 3e4:	8082                	ret

00000000000003e6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3e6:	715d                	addi	sp,sp,-80
 3e8:	e486                	sd	ra,72(sp)
 3ea:	e0a2                	sd	s0,64(sp)
 3ec:	f84a                	sd	s2,48(sp)
 3ee:	0880                	addi	s0,sp,80
 3f0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3f2:	c299                	beqz	a3,3f8 <printint+0x12>
 3f4:	0805c363          	bltz	a1,47a <printint+0x94>
  neg = 0;
 3f8:	4881                	li	a7,0
 3fa:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3fe:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 400:	00000517          	auipc	a0,0x0
 404:	54850513          	addi	a0,a0,1352 # 948 <digits>
 408:	883e                	mv	a6,a5
 40a:	2785                	addiw	a5,a5,1
 40c:	02c5f733          	remu	a4,a1,a2
 410:	972a                	add	a4,a4,a0
 412:	00074703          	lbu	a4,0(a4)
 416:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 41a:	872e                	mv	a4,a1
 41c:	02c5d5b3          	divu	a1,a1,a2
 420:	0685                	addi	a3,a3,1
 422:	fec773e3          	bgeu	a4,a2,408 <printint+0x22>
  if(neg)
 426:	00088b63          	beqz	a7,43c <printint+0x56>
    buf[i++] = '-';
 42a:	fd078793          	addi	a5,a5,-48
 42e:	97a2                	add	a5,a5,s0
 430:	02d00713          	li	a4,45
 434:	fee78423          	sb	a4,-24(a5)
 438:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 43c:	02f05a63          	blez	a5,470 <printint+0x8a>
 440:	fc26                	sd	s1,56(sp)
 442:	f44e                	sd	s3,40(sp)
 444:	fb840713          	addi	a4,s0,-72
 448:	00f704b3          	add	s1,a4,a5
 44c:	fff70993          	addi	s3,a4,-1
 450:	99be                	add	s3,s3,a5
 452:	37fd                	addiw	a5,a5,-1
 454:	1782                	slli	a5,a5,0x20
 456:	9381                	srli	a5,a5,0x20
 458:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 45c:	fff4c583          	lbu	a1,-1(s1)
 460:	854a                	mv	a0,s2
 462:	f67ff0ef          	jal	3c8 <putc>
  while(--i >= 0)
 466:	14fd                	addi	s1,s1,-1
 468:	ff349ae3          	bne	s1,s3,45c <printint+0x76>
 46c:	74e2                	ld	s1,56(sp)
 46e:	79a2                	ld	s3,40(sp)
}
 470:	60a6                	ld	ra,72(sp)
 472:	6406                	ld	s0,64(sp)
 474:	7942                	ld	s2,48(sp)
 476:	6161                	addi	sp,sp,80
 478:	8082                	ret
    x = -xx;
 47a:	40b005b3          	neg	a1,a1
    neg = 1;
 47e:	4885                	li	a7,1
    x = -xx;
 480:	bfad                	j	3fa <printint+0x14>

0000000000000482 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 482:	711d                	addi	sp,sp,-96
 484:	ec86                	sd	ra,88(sp)
 486:	e8a2                	sd	s0,80(sp)
 488:	e0ca                	sd	s2,64(sp)
 48a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48c:	0005c903          	lbu	s2,0(a1)
 490:	28090663          	beqz	s2,71c <vprintf+0x29a>
 494:	e4a6                	sd	s1,72(sp)
 496:	fc4e                	sd	s3,56(sp)
 498:	f852                	sd	s4,48(sp)
 49a:	f456                	sd	s5,40(sp)
 49c:	f05a                	sd	s6,32(sp)
 49e:	ec5e                	sd	s7,24(sp)
 4a0:	e862                	sd	s8,16(sp)
 4a2:	e466                	sd	s9,8(sp)
 4a4:	8b2a                	mv	s6,a0
 4a6:	8a2e                	mv	s4,a1
 4a8:	8bb2                	mv	s7,a2
  state = 0;
 4aa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ac:	4481                	li	s1,0
 4ae:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b8:	06c00c93          	li	s9,108
 4bc:	a005                	j	4dc <vprintf+0x5a>
        putc(fd, c0);
 4be:	85ca                	mv	a1,s2
 4c0:	855a                	mv	a0,s6
 4c2:	f07ff0ef          	jal	3c8 <putc>
 4c6:	a019                	j	4cc <vprintf+0x4a>
    } else if(state == '%'){
 4c8:	03598263          	beq	s3,s5,4ec <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4cc:	2485                	addiw	s1,s1,1
 4ce:	8726                	mv	a4,s1
 4d0:	009a07b3          	add	a5,s4,s1
 4d4:	0007c903          	lbu	s2,0(a5)
 4d8:	22090a63          	beqz	s2,70c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4dc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4e0:	fe0994e3          	bnez	s3,4c8 <vprintf+0x46>
      if(c0 == '%'){
 4e4:	fd579de3          	bne	a5,s5,4be <vprintf+0x3c>
        state = '%';
 4e8:	89be                	mv	s3,a5
 4ea:	b7cd                	j	4cc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ec:	00ea06b3          	add	a3,s4,a4
 4f0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4f6:	c681                	beqz	a3,4fe <vprintf+0x7c>
 4f8:	9752                	add	a4,a4,s4
 4fa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4fe:	05878363          	beq	a5,s8,544 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 502:	05978d63          	beq	a5,s9,55c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 506:	07500713          	li	a4,117
 50a:	0ee78763          	beq	a5,a4,5f8 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 50e:	07800713          	li	a4,120
 512:	12e78963          	beq	a5,a4,644 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 516:	07000713          	li	a4,112
 51a:	14e78e63          	beq	a5,a4,676 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 51e:	06300713          	li	a4,99
 522:	18e78e63          	beq	a5,a4,6be <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 526:	07300713          	li	a4,115
 52a:	1ae78463          	beq	a5,a4,6d2 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 52e:	02500713          	li	a4,37
 532:	04e79563          	bne	a5,a4,57c <vprintf+0xfa>
        putc(fd, '%');
 536:	02500593          	li	a1,37
 53a:	855a                	mv	a0,s6
 53c:	e8dff0ef          	jal	3c8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 540:	4981                	li	s3,0
 542:	b769                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 544:	008b8913          	addi	s2,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e95ff0ef          	jal	3e6 <printint>
 556:	8bca                	mv	s7,s2
      state = 0;
 558:	4981                	li	s3,0
 55a:	bf8d                	j	4cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 55c:	06400793          	li	a5,100
 560:	02f68963          	beq	a3,a5,592 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 564:	06c00793          	li	a5,108
 568:	04f68263          	beq	a3,a5,5ac <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 56c:	07500793          	li	a5,117
 570:	0af68063          	beq	a3,a5,610 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 574:	07800793          	li	a5,120
 578:	0ef68263          	beq	a3,a5,65c <vprintf+0x1da>
        putc(fd, '%');
 57c:	02500593          	li	a1,37
 580:	855a                	mv	a0,s6
 582:	e47ff0ef          	jal	3c8 <putc>
        putc(fd, c0);
 586:	85ca                	mv	a1,s2
 588:	855a                	mv	a0,s6
 58a:	e3fff0ef          	jal	3c8 <putc>
      state = 0;
 58e:	4981                	li	s3,0
 590:	bf35                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000bb583          	ld	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e47ff0ef          	jal	3e6 <printint>
        i += 1;
 5a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
        i += 1;
 5aa:	b70d                	j	4cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ac:	06400793          	li	a5,100
 5b0:	02f60763          	beq	a2,a5,5de <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b4:	07500793          	li	a5,117
 5b8:	06f60963          	beq	a2,a5,62a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5bc:	07800793          	li	a5,120
 5c0:	faf61ee3          	bne	a2,a5,57c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000bb583          	ld	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e15ff0ef          	jal	3e6 <printint>
        i += 2;
 5d6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
        i += 2;
 5dc:	bdc5                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000bb583          	ld	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	dfbff0ef          	jal	3e6 <printint>
        i += 2;
 5f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	bdd9                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000be583          	lwu	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	de1ff0ef          	jal	3e6 <printint>
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bd7d                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4629                	li	a2,10
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	dc9ff0ef          	jal	3e6 <printint>
        i += 1;
 622:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 1;
 628:	b555                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	dafff0ef          	jal	3e6 <printint>
        i += 2;
 63c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	b569                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000be583          	lwu	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	d95ff0ef          	jal	3e6 <printint>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bd8d                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000bb583          	ld	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	d7dff0ef          	jal	3e6 <printint>
        i += 1;
 66e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 1;
 674:	bda1                	j	4cc <vprintf+0x4a>
 676:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 678:	008b8d13          	addi	s10,s7,8
 67c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 680:	03000593          	li	a1,48
 684:	855a                	mv	a0,s6
 686:	d43ff0ef          	jal	3c8 <putc>
  putc(fd, 'x');
 68a:	07800593          	li	a1,120
 68e:	855a                	mv	a0,s6
 690:	d39ff0ef          	jal	3c8 <putc>
 694:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	00000b97          	auipc	s7,0x0
 69a:	2b2b8b93          	addi	s7,s7,690 # 948 <digits>
 69e:	03c9d793          	srli	a5,s3,0x3c
 6a2:	97de                	add	a5,a5,s7
 6a4:	0007c583          	lbu	a1,0(a5)
 6a8:	855a                	mv	a0,s6
 6aa:	d1fff0ef          	jal	3c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ae:	0992                	slli	s3,s3,0x4
 6b0:	397d                	addiw	s2,s2,-1
 6b2:	fe0916e3          	bnez	s2,69e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6b6:	8bea                	mv	s7,s10
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	6d02                	ld	s10,0(sp)
 6bc:	bd01                	j	4cc <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6be:	008b8913          	addi	s2,s7,8
 6c2:	000bc583          	lbu	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	d01ff0ef          	jal	3c8 <putc>
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bbf5                	j	4cc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6d2:	008b8993          	addi	s3,s7,8
 6d6:	000bb903          	ld	s2,0(s7)
 6da:	00090f63          	beqz	s2,6f8 <vprintf+0x276>
        for(; *s; s++)
 6de:	00094583          	lbu	a1,0(s2)
 6e2:	c195                	beqz	a1,706 <vprintf+0x284>
          putc(fd, *s);
 6e4:	855a                	mv	a0,s6
 6e6:	ce3ff0ef          	jal	3c8 <putc>
        for(; *s; s++)
 6ea:	0905                	addi	s2,s2,1
 6ec:	00094583          	lbu	a1,0(s2)
 6f0:	f9f5                	bnez	a1,6e4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6f2:	8bce                	mv	s7,s3
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bbd9                	j	4cc <vprintf+0x4a>
          s = "(null)";
 6f8:	00000917          	auipc	s2,0x0
 6fc:	24890913          	addi	s2,s2,584 # 940 <malloc+0x13c>
        for(; *s; s++)
 700:	02800593          	li	a1,40
 704:	b7c5                	j	6e4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 706:	8bce                	mv	s7,s3
      state = 0;
 708:	4981                	li	s3,0
 70a:	b3c9                	j	4cc <vprintf+0x4a>
 70c:	64a6                	ld	s1,72(sp)
 70e:	79e2                	ld	s3,56(sp)
 710:	7a42                	ld	s4,48(sp)
 712:	7aa2                	ld	s5,40(sp)
 714:	7b02                	ld	s6,32(sp)
 716:	6be2                	ld	s7,24(sp)
 718:	6c42                	ld	s8,16(sp)
 71a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 71c:	60e6                	ld	ra,88(sp)
 71e:	6446                	ld	s0,80(sp)
 720:	6906                	ld	s2,64(sp)
 722:	6125                	addi	sp,sp,96
 724:	8082                	ret

0000000000000726 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 726:	715d                	addi	sp,sp,-80
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e010                	sd	a2,0(s0)
 730:	e414                	sd	a3,8(s0)
 732:	e818                	sd	a4,16(s0)
 734:	ec1c                	sd	a5,24(s0)
 736:	03043023          	sd	a6,32(s0)
 73a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 742:	8622                	mv	a2,s0
 744:	d3fff0ef          	jal	482 <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6161                	addi	sp,sp,80
 74e:	8082                	ret

0000000000000750 <printf>:

void
printf(const char *fmt, ...)
{
 750:	711d                	addi	sp,sp,-96
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e40c                	sd	a1,8(s0)
 75a:	e810                	sd	a2,16(s0)
 75c:	ec14                	sd	a3,24(s0)
 75e:	f018                	sd	a4,32(s0)
 760:	f41c                	sd	a5,40(s0)
 762:	03043823          	sd	a6,48(s0)
 766:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	00840613          	addi	a2,s0,8
 76e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 772:	85aa                	mv	a1,a0
 774:	4505                	li	a0,1
 776:	d0dff0ef          	jal	482 <vprintf>
}
 77a:	60e2                	ld	ra,24(sp)
 77c:	6442                	ld	s0,16(sp)
 77e:	6125                	addi	sp,sp,96
 780:	8082                	ret

0000000000000782 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 782:	1141                	addi	sp,sp,-16
 784:	e422                	sd	s0,8(sp)
 786:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 788:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	00001797          	auipc	a5,0x1
 790:	8747b783          	ld	a5,-1932(a5) # 1000 <freep>
 794:	a02d                	j	7be <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 796:	4618                	lw	a4,8(a2)
 798:	9f2d                	addw	a4,a4,a1
 79a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	6398                	ld	a4,0(a5)
 7a0:	6310                	ld	a2,0(a4)
 7a2:	a83d                	j	7e0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a4:	ff852703          	lw	a4,-8(a0)
 7a8:	9f31                	addw	a4,a4,a2
 7aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ac:	ff053683          	ld	a3,-16(a0)
 7b0:	a091                	j	7f4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	6398                	ld	a4,0(a5)
 7b4:	00e7e463          	bltu	a5,a4,7bc <free+0x3a>
 7b8:	00e6ea63          	bltu	a3,a4,7cc <free+0x4a>
{
 7bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	fed7fae3          	bgeu	a5,a3,7b2 <free+0x30>
 7c2:	6398                	ld	a4,0(a5)
 7c4:	00e6e463          	bltu	a3,a4,7cc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	fee7eae3          	bltu	a5,a4,7bc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7cc:	ff852583          	lw	a1,-8(a0)
 7d0:	6390                	ld	a2,0(a5)
 7d2:	02059813          	slli	a6,a1,0x20
 7d6:	01c85713          	srli	a4,a6,0x1c
 7da:	9736                	add	a4,a4,a3
 7dc:	fae60de3          	beq	a2,a4,796 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e4:	4790                	lw	a2,8(a5)
 7e6:	02061593          	slli	a1,a2,0x20
 7ea:	01c5d713          	srli	a4,a1,0x1c
 7ee:	973e                	add	a4,a4,a5
 7f0:	fae68ae3          	beq	a3,a4,7a4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7f4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80f73523          	sd	a5,-2038(a4) # 1000 <freep>
}
 7fe:	6422                	ld	s0,8(sp)
 800:	0141                	addi	sp,sp,16
 802:	8082                	ret

0000000000000804 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 804:	7139                	addi	sp,sp,-64
 806:	fc06                	sd	ra,56(sp)
 808:	f822                	sd	s0,48(sp)
 80a:	f426                	sd	s1,40(sp)
 80c:	ec4e                	sd	s3,24(sp)
 80e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 810:	02051493          	slli	s1,a0,0x20
 814:	9081                	srli	s1,s1,0x20
 816:	04bd                	addi	s1,s1,15
 818:	8091                	srli	s1,s1,0x4
 81a:	0014899b          	addiw	s3,s1,1
 81e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 820:	00000517          	auipc	a0,0x0
 824:	7e053503          	ld	a0,2016(a0) # 1000 <freep>
 828:	c915                	beqz	a0,85c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82c:	4798                	lw	a4,8(a5)
 82e:	08977a63          	bgeu	a4,s1,8c2 <malloc+0xbe>
 832:	f04a                	sd	s2,32(sp)
 834:	e852                	sd	s4,16(sp)
 836:	e456                	sd	s5,8(sp)
 838:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 83a:	8a4e                	mv	s4,s3
 83c:	0009871b          	sext.w	a4,s3
 840:	6685                	lui	a3,0x1
 842:	00d77363          	bgeu	a4,a3,848 <malloc+0x44>
 846:	6a05                	lui	s4,0x1
 848:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 850:	00000917          	auipc	s2,0x0
 854:	7b090913          	addi	s2,s2,1968 # 1000 <freep>
  if(p == SBRK_ERROR)
 858:	5afd                	li	s5,-1
 85a:	a081                	j	89a <malloc+0x96>
 85c:	f04a                	sd	s2,32(sp)
 85e:	e852                	sd	s4,16(sp)
 860:	e456                	sd	s5,8(sp)
 862:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 864:	00000797          	auipc	a5,0x0
 868:	7ac78793          	addi	a5,a5,1964 # 1010 <base>
 86c:	00000717          	auipc	a4,0x0
 870:	78f73a23          	sd	a5,1940(a4) # 1000 <freep>
 874:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 876:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87a:	b7c1                	j	83a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	e118                	sd	a4,0(a0)
 880:	a8a9                	j	8da <malloc+0xd6>
  hp->s.size = nu;
 882:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 886:	0541                	addi	a0,a0,16
 888:	efbff0ef          	jal	782 <free>
  return freep;
 88c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 890:	c12d                	beqz	a0,8f2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	02977263          	bgeu	a4,s1,8ba <malloc+0xb6>
    if(p == freep)
 89a:	00093703          	ld	a4,0(s2)
 89e:	853e                	mv	a0,a5
 8a0:	fef719e3          	bne	a4,a5,892 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8a4:	8552                	mv	a0,s4
 8a6:	a17ff0ef          	jal	2bc <sbrk>
  if(p == SBRK_ERROR)
 8aa:	fd551ce3          	bne	a0,s5,882 <malloc+0x7e>
        return 0;
 8ae:	4501                	li	a0,0
 8b0:	7902                	ld	s2,32(sp)
 8b2:	6a42                	ld	s4,16(sp)
 8b4:	6aa2                	ld	s5,8(sp)
 8b6:	6b02                	ld	s6,0(sp)
 8b8:	a03d                	j	8e6 <malloc+0xe2>
 8ba:	7902                	ld	s2,32(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c2:	fae48de3          	beq	s1,a4,87c <malloc+0x78>
        p->s.size -= nunits;
 8c6:	4137073b          	subw	a4,a4,s3
 8ca:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8cc:	02071693          	slli	a3,a4,0x20
 8d0:	01c6d713          	srli	a4,a3,0x1c
 8d4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8da:	00000717          	auipc	a4,0x0
 8de:	72a73323          	sd	a0,1830(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e2:	01078513          	addi	a0,a5,16
  }
}
 8e6:	70e2                	ld	ra,56(sp)
 8e8:	7442                	ld	s0,48(sp)
 8ea:	74a2                	ld	s1,40(sp)
 8ec:	69e2                	ld	s3,24(sp)
 8ee:	6121                	addi	sp,sp,64
 8f0:	8082                	ret
 8f2:	7902                	ld	s2,32(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
 8fa:	b7f5                	j	8e6 <malloc+0xe2>
