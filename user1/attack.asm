
user/_attack:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_read_test>:
#include "kernel/types.h"
#include "user/user.h"

// Hàm thực hiện Test 1: Đọc bộ nhớ Kernel
void do_read_test(volatile unsigned long *addr) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    printf("[TEST 1] Read kernel memory...\n");
   c:	00001517          	auipc	a0,0x1
  10:	99450513          	addi	a0,a0,-1644 # 9a0 <malloc+0xf8>
  14:	7e0000ef          	jal	7f4 <printf>
    int pid = fork();
  18:	374000ef          	jal	38c <fork>
    
    if(pid < 0) {
  1c:	02054263          	bltz	a0,40 <do_read_test+0x40>
        printf("Fork failed\n");
        exit(1);
    }
    
    if(pid == 0) {
  20:	c90d                	beqz	a0,52 <do_read_test+0x52>
        printf("[FAIL] Read succeeded: 0x%p ❌\n", (void*)val);
        exit(0);
    } else {
        // Tiến trình cha chờ xem con có bị sập do Page Fault không
        int status;
        wait(&status);
  22:	fdc40513          	addi	a0,s0,-36
  26:	376000ef          	jal	39c <wait>
        printf("[OK] Read blocked (Process terminated by Kernel) ✅\n");
  2a:	00001517          	auipc	a0,0x1
  2e:	9d650513          	addi	a0,a0,-1578 # a00 <malloc+0x158>
  32:	7c2000ef          	jal	7f4 <printf>
    }
}
  36:	70a2                	ld	ra,40(sp)
  38:	7402                	ld	s0,32(sp)
  3a:	64e2                	ld	s1,24(sp)
  3c:	6145                	addi	sp,sp,48
  3e:	8082                	ret
        printf("Fork failed\n");
  40:	00001517          	auipc	a0,0x1
  44:	98050513          	addi	a0,a0,-1664 # 9c0 <malloc+0x118>
  48:	7ac000ef          	jal	7f4 <printf>
        exit(1);
  4c:	4505                	li	a0,1
  4e:	346000ef          	jal	394 <exit>
        unsigned long val = *addr;
  52:	608c                	ld	a1,0(s1)
        printf("[FAIL] Read succeeded: 0x%p ❌\n", (void*)val);
  54:	00001517          	auipc	a0,0x1
  58:	98450513          	addi	a0,a0,-1660 # 9d8 <malloc+0x130>
  5c:	798000ef          	jal	7f4 <printf>
        exit(0);
  60:	4501                	li	a0,0
  62:	332000ef          	jal	394 <exit>

0000000000000066 <do_write_test>:

// Hàm thực hiện Test 2: Ghi bộ nhớ Kernel
void do_write_test(volatile unsigned long *addr) {
  66:	7179                	addi	sp,sp,-48
  68:	f406                	sd	ra,40(sp)
  6a:	f022                	sd	s0,32(sp)
  6c:	ec26                	sd	s1,24(sp)
  6e:	1800                	addi	s0,sp,48
  70:	84aa                	mv	s1,a0
    printf("\n[TEST 2] Write kernel memory...\n");
  72:	00001517          	auipc	a0,0x1
  76:	9c650513          	addi	a0,a0,-1594 # a38 <malloc+0x190>
  7a:	77a000ef          	jal	7f4 <printf>
    int pid = fork();
  7e:	30e000ef          	jal	38c <fork>
    
    if(pid < 0) {
  82:	02054263          	bltz	a0,a6 <do_write_test+0x40>
        printf("Fork failed\n");
        exit(1);
    }
    
    if(pid == 0) {
  86:	c90d                	beqz	a0,b8 <do_write_test+0x52>
        printf("[FAIL] Write succeeded ❌\n");
        exit(0);
    } else {
        // Tiến trình cha chờ xem con có bị sập không
        int status;
        wait(&status);
  88:	fdc40513          	addi	a0,s0,-36
  8c:	310000ef          	jal	39c <wait>
        printf("[OK] Write blocked (Process terminated by Kernel) ✅\n");
  90:	00001517          	auipc	a0,0x1
  94:	9f050513          	addi	a0,a0,-1552 # a80 <malloc+0x1d8>
  98:	75c000ef          	jal	7f4 <printf>
    }
}
  9c:	70a2                	ld	ra,40(sp)
  9e:	7402                	ld	s0,32(sp)
  a0:	64e2                	ld	s1,24(sp)
  a2:	6145                	addi	sp,sp,48
  a4:	8082                	ret
        printf("Fork failed\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	91a50513          	addi	a0,a0,-1766 # 9c0 <malloc+0x118>
  ae:	746000ef          	jal	7f4 <printf>
        exit(1);
  b2:	4505                	li	a0,1
  b4:	2e0000ef          	jal	394 <exit>
        *addr = 0xDEADBEEF;
  b8:	37ab77b7          	lui	a5,0x37ab7
  bc:	078a                	slli	a5,a5,0x2
  be:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab5edf>
  c2:	e09c                	sd	a5,0(s1)
        printf("[FAIL] Write succeeded ❌\n");
  c4:	00001517          	auipc	a0,0x1
  c8:	99c50513          	addi	a0,a0,-1636 # a60 <malloc+0x1b8>
  cc:	728000ef          	jal	7f4 <printf>
        exit(0);
  d0:	4501                	li	a0,0
  d2:	2c2000ef          	jal	394 <exit>

00000000000000d6 <main>:

int main() {
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
    printf("=== User Space Attack Simulation (Fork-based) ===\n");
  de:	00001517          	auipc	a0,0x1
  e2:	9da50513          	addi	a0,a0,-1574 # ab8 <malloc+0x210>
  e6:	70e000ef          	jal	7f4 <printf>
    
    // Địa chỉ Kernel Base trong xv6 RISC-V
    volatile unsigned long *kernel_addr = (unsigned long *)0x80000000;

    do_read_test(kernel_addr);
  ea:	4505                	li	a0,1
  ec:	057e                	slli	a0,a0,0x1f
  ee:	f13ff0ef          	jal	0 <do_read_test>
    do_write_test(kernel_addr);
  f2:	4505                	li	a0,1
  f4:	057e                	slli	a0,a0,0x1f
  f6:	f71ff0ef          	jal	66 <do_write_test>

    exit(0);
  fa:	4501                	li	a0,0
  fc:	298000ef          	jal	394 <exit>

0000000000000100 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 108:	fcfff0ef          	jal	d6 <main>
  exit(r);
 10c:	288000ef          	jal	394 <exit>

0000000000000110 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 116:	87aa                	mv	a5,a0
 118:	0585                	addi	a1,a1,1
 11a:	0785                	addi	a5,a5,1
 11c:	fff5c703          	lbu	a4,-1(a1)
 120:	fee78fa3          	sb	a4,-1(a5)
 124:	fb75                	bnez	a4,118 <strcpy+0x8>
    ;
  return os;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb91                	beqz	a5,14a <strcmp+0x1e>
 138:	0005c703          	lbu	a4,0(a1)
 13c:	00f71763          	bne	a4,a5,14a <strcmp+0x1e>
    p++, q++;
 140:	0505                	addi	a0,a0,1
 142:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	fbe5                	bnez	a5,138 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14a:	0005c503          	lbu	a0,0(a1)
}
 14e:	40a7853b          	subw	a0,a5,a0
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x26>
 164:	0505                	addi	a0,a0,1
 166:	87aa                	mv	a5,a0
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x10>
 172:	40a6853b          	subw	a0,a3,a0
 176:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for(n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfe5                	j	178 <strlen+0x20>

0000000000000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 188:	ca19                	beqz	a2,19e <memset+0x1c>
 18a:	87aa                	mv	a5,a0
 18c:	1602                	slli	a2,a2,0x20
 18e:	9201                	srli	a2,a2,0x20
 190:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 198:	0785                	addi	a5,a5,1
 19a:	fee79de3          	bne	a5,a4,194 <memset+0x12>
  }
  return dst;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb99                	beqz	a5,1c4 <strchr+0x20>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1a>
  for(; *s; s++)
 1b4:	0505                	addi	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xc>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  return 0;
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strchr+0x1a>

00000000000001c8 <gets>:

char*
gets(char *buf, int max)
{
 1c8:	711d                	addi	sp,sp,-96
 1ca:	ec86                	sd	ra,88(sp)
 1cc:	e8a2                	sd	s0,80(sp)
 1ce:	e4a6                	sd	s1,72(sp)
 1d0:	e0ca                	sd	s2,64(sp)
 1d2:	fc4e                	sd	s3,56(sp)
 1d4:	f852                	sd	s4,48(sp)
 1d6:	f456                	sd	s5,40(sp)
 1d8:	f05a                	sd	s6,32(sp)
 1da:	ec5e                	sd	s7,24(sp)
 1dc:	1080                	addi	s0,sp,96
 1de:	8baa                	mv	s7,a0
 1e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	892a                	mv	s2,a0
 1e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e6:	4aa9                	li	s5,10
 1e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ea:	89a6                	mv	s3,s1
 1ec:	2485                	addiw	s1,s1,1
 1ee:	0344d663          	bge	s1,s4,21a <gets+0x52>
    cc = read(0, &c, 1);
 1f2:	4605                	li	a2,1
 1f4:	faf40593          	addi	a1,s0,-81
 1f8:	4501                	li	a0,0
 1fa:	1b2000ef          	jal	3ac <read>
    if(cc < 1)
 1fe:	00a05e63          	blez	a0,21a <gets+0x52>
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20a:	01578763          	beq	a5,s5,218 <gets+0x50>
 20e:	0905                	addi	s2,s2,1
 210:	fd679de3          	bne	a5,s6,1ea <gets+0x22>
    buf[i++] = c;
 214:	89a6                	mv	s3,s1
 216:	a011                	j	21a <gets+0x52>
 218:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21a:	99de                	add	s3,s3,s7
 21c:	00098023          	sb	zero,0(s3)
  return buf;
}
 220:	855e                	mv	a0,s7
 222:	60e6                	ld	ra,88(sp)
 224:	6446                	ld	s0,80(sp)
 226:	64a6                	ld	s1,72(sp)
 228:	6906                	ld	s2,64(sp)
 22a:	79e2                	ld	s3,56(sp)
 22c:	7a42                	ld	s4,48(sp)
 22e:	7aa2                	ld	s5,40(sp)
 230:	7b02                	ld	s6,32(sp)
 232:	6be2                	ld	s7,24(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e04a                	sd	s2,0(sp)
 240:	1000                	addi	s0,sp,32
 242:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	4581                	li	a1,0
 246:	18e000ef          	jal	3d4 <open>
  if(fd < 0)
 24a:	02054263          	bltz	a0,26e <stat+0x36>
 24e:	e426                	sd	s1,8(sp)
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	198000ef          	jal	3ec <fstat>
 258:	892a                	mv	s2,a0
  close(fd);
 25a:	8526                	mv	a0,s1
 25c:	160000ef          	jal	3bc <close>
  return r;
 260:	64a2                	ld	s1,8(sp)
}
 262:	854a                	mv	a0,s2
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	6902                	ld	s2,0(sp)
 26a:	6105                	addi	sp,sp,32
 26c:	8082                	ret
    return -1;
 26e:	597d                	li	s2,-1
 270:	bfcd                	j	262 <stat+0x2a>

0000000000000272 <atoi>:

int
atoi(const char *s)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 278:	00054683          	lbu	a3,0(a0)
 27c:	fd06879b          	addiw	a5,a3,-48
 280:	0ff7f793          	zext.b	a5,a5
 284:	4625                	li	a2,9
 286:	02f66863          	bltu	a2,a5,2b6 <atoi+0x44>
 28a:	872a                	mv	a4,a0
  n = 0;
 28c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 28e:	0705                	addi	a4,a4,1
 290:	0025179b          	slliw	a5,a0,0x2
 294:	9fa9                	addw	a5,a5,a0
 296:	0017979b          	slliw	a5,a5,0x1
 29a:	9fb5                	addw	a5,a5,a3
 29c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a0:	00074683          	lbu	a3,0(a4)
 2a4:	fd06879b          	addiw	a5,a3,-48
 2a8:	0ff7f793          	zext.b	a5,a5
 2ac:	fef671e3          	bgeu	a2,a5,28e <atoi+0x1c>
  return n;
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  n = 0;
 2b6:	4501                	li	a0,0
 2b8:	bfe5                	j	2b0 <atoi+0x3e>

00000000000002ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c0:	02b57463          	bgeu	a0,a1,2e8 <memmove+0x2e>
    while(n-- > 0)
 2c4:	00c05f63          	blez	a2,2e2 <memmove+0x28>
 2c8:	1602                	slli	a2,a2,0x20
 2ca:	9201                	srli	a2,a2,0x20
 2cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d2:	0585                	addi	a1,a1,1
 2d4:	0705                	addi	a4,a4,1
 2d6:	fff5c683          	lbu	a3,-1(a1)
 2da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2de:	fef71ae3          	bne	a4,a5,2d2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
    dst += n;
 2e8:	00c50733          	add	a4,a0,a2
    src += n;
 2ec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ee:	fec05ae3          	blez	a2,2e2 <memmove+0x28>
 2f2:	fff6079b          	addiw	a5,a2,-1
 2f6:	1782                	slli	a5,a5,0x20
 2f8:	9381                	srli	a5,a5,0x20
 2fa:	fff7c793          	not	a5,a5
 2fe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 300:	15fd                	addi	a1,a1,-1
 302:	177d                	addi	a4,a4,-1
 304:	0005c683          	lbu	a3,0(a1)
 308:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 30c:	fee79ae3          	bne	a5,a4,300 <memmove+0x46>
 310:	bfc9                	j	2e2 <memmove+0x28>

0000000000000312 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 318:	ca05                	beqz	a2,348 <memcmp+0x36>
 31a:	fff6069b          	addiw	a3,a2,-1
 31e:	1682                	slli	a3,a3,0x20
 320:	9281                	srli	a3,a3,0x20
 322:	0685                	addi	a3,a3,1
 324:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 326:	00054783          	lbu	a5,0(a0)
 32a:	0005c703          	lbu	a4,0(a1)
 32e:	00e79863          	bne	a5,a4,33e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 332:	0505                	addi	a0,a0,1
    p2++;
 334:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 336:	fed518e3          	bne	a0,a3,326 <memcmp+0x14>
  }
  return 0;
 33a:	4501                	li	a0,0
 33c:	a019                	j	342 <memcmp+0x30>
      return *p1 - *p2;
 33e:	40e7853b          	subw	a0,a5,a4
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
  return 0;
 348:	4501                	li	a0,0
 34a:	bfe5                	j	342 <memcmp+0x30>

000000000000034c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 354:	f67ff0ef          	jal	2ba <memmove>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <sbrk>:

char *
sbrk(int n) {
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 368:	4585                	li	a1,1
 36a:	0b2000ef          	jal	41c <sys_sbrk>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <sbrklazy>:

char *
sbrklazy(int n) {
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 37e:	4589                	li	a1,2
 380:	09c000ef          	jal	41c <sys_sbrk>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38c:	4885                	li	a7,1
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <exit>:
.global exit
exit:
 li a7, SYS_exit
 394:	4889                	li	a7,2
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <wait>:
.global wait
wait:
 li a7, SYS_wait
 39c:	488d                	li	a7,3
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a4:	4891                	li	a7,4
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <read>:
.global read
read:
 li a7, SYS_read
 3ac:	4895                	li	a7,5
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <write>:
.global write
write:
 li a7, SYS_write
 3b4:	48c1                	li	a7,16
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <close>:
.global close
close:
 li a7, SYS_close
 3bc:	48d5                	li	a7,21
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c4:	4899                	li	a7,6
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3cc:	489d                	li	a7,7
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <open>:
.global open
open:
 li a7, SYS_open
 3d4:	48bd                	li	a7,15
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3dc:	48c5                	li	a7,17
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e4:	48c9                	li	a7,18
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ec:	48a1                	li	a7,8
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <link>:
.global link
link:
 li a7, SYS_link
 3f4:	48cd                	li	a7,19
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fc:	48d1                	li	a7,20
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 404:	48a5                	li	a7,9
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <dup>:
.global dup
dup:
 li a7, SYS_dup
 40c:	48a9                	li	a7,10
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 414:	48ad                	li	a7,11
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 41c:	48b1                	li	a7,12
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <pause>:
.global pause
pause:
 li a7, SYS_pause
 424:	48b5                	li	a7,13
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42c:	48b9                	li	a7,14
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <hello>:
.global hello
hello:
 li a7, SYS_hello
 434:	48d9                	li	a7,22
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <ps>:
.global ps
ps:
 li a7, SYS_ps
 43c:	48dd                	li	a7,23
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 444:	48e1                	li	a7,24
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 44c:	48e5                	li	a7,25
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 454:	48e9                	li	a7,26
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 45c:	48ed                	li	a7,27
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 464:	48f1                	li	a7,28
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	1000                	addi	s0,sp,32
 474:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 478:	4605                	li	a2,1
 47a:	fef40593          	addi	a1,s0,-17
 47e:	f37ff0ef          	jal	3b4 <write>
}
 482:	60e2                	ld	ra,24(sp)
 484:	6442                	ld	s0,16(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret

000000000000048a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 48a:	715d                	addi	sp,sp,-80
 48c:	e486                	sd	ra,72(sp)
 48e:	e0a2                	sd	s0,64(sp)
 490:	f84a                	sd	s2,48(sp)
 492:	0880                	addi	s0,sp,80
 494:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 496:	c299                	beqz	a3,49c <printint+0x12>
 498:	0805c363          	bltz	a1,51e <printint+0x94>
  neg = 0;
 49c:	4881                	li	a7,0
 49e:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4a2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4a4:	00000517          	auipc	a0,0x0
 4a8:	65450513          	addi	a0,a0,1620 # af8 <digits>
 4ac:	883e                	mv	a6,a5
 4ae:	2785                	addiw	a5,a5,1
 4b0:	02c5f733          	remu	a4,a1,a2
 4b4:	972a                	add	a4,a4,a0
 4b6:	00074703          	lbu	a4,0(a4)
 4ba:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4be:	872e                	mv	a4,a1
 4c0:	02c5d5b3          	divu	a1,a1,a2
 4c4:	0685                	addi	a3,a3,1
 4c6:	fec773e3          	bgeu	a4,a2,4ac <printint+0x22>
  if(neg)
 4ca:	00088b63          	beqz	a7,4e0 <printint+0x56>
    buf[i++] = '-';
 4ce:	fd078793          	addi	a5,a5,-48
 4d2:	97a2                	add	a5,a5,s0
 4d4:	02d00713          	li	a4,45
 4d8:	fee78423          	sb	a4,-24(a5)
 4dc:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4e0:	02f05a63          	blez	a5,514 <printint+0x8a>
 4e4:	fc26                	sd	s1,56(sp)
 4e6:	f44e                	sd	s3,40(sp)
 4e8:	fb840713          	addi	a4,s0,-72
 4ec:	00f704b3          	add	s1,a4,a5
 4f0:	fff70993          	addi	s3,a4,-1
 4f4:	99be                	add	s3,s3,a5
 4f6:	37fd                	addiw	a5,a5,-1
 4f8:	1782                	slli	a5,a5,0x20
 4fa:	9381                	srli	a5,a5,0x20
 4fc:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 500:	fff4c583          	lbu	a1,-1(s1)
 504:	854a                	mv	a0,s2
 506:	f67ff0ef          	jal	46c <putc>
  while(--i >= 0)
 50a:	14fd                	addi	s1,s1,-1
 50c:	ff349ae3          	bne	s1,s3,500 <printint+0x76>
 510:	74e2                	ld	s1,56(sp)
 512:	79a2                	ld	s3,40(sp)
}
 514:	60a6                	ld	ra,72(sp)
 516:	6406                	ld	s0,64(sp)
 518:	7942                	ld	s2,48(sp)
 51a:	6161                	addi	sp,sp,80
 51c:	8082                	ret
    x = -xx;
 51e:	40b005b3          	neg	a1,a1
    neg = 1;
 522:	4885                	li	a7,1
    x = -xx;
 524:	bfad                	j	49e <printint+0x14>

0000000000000526 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 526:	711d                	addi	sp,sp,-96
 528:	ec86                	sd	ra,88(sp)
 52a:	e8a2                	sd	s0,80(sp)
 52c:	e0ca                	sd	s2,64(sp)
 52e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 530:	0005c903          	lbu	s2,0(a1)
 534:	28090663          	beqz	s2,7c0 <vprintf+0x29a>
 538:	e4a6                	sd	s1,72(sp)
 53a:	fc4e                	sd	s3,56(sp)
 53c:	f852                	sd	s4,48(sp)
 53e:	f456                	sd	s5,40(sp)
 540:	f05a                	sd	s6,32(sp)
 542:	ec5e                	sd	s7,24(sp)
 544:	e862                	sd	s8,16(sp)
 546:	e466                	sd	s9,8(sp)
 548:	8b2a                	mv	s6,a0
 54a:	8a2e                	mv	s4,a1
 54c:	8bb2                	mv	s7,a2
  state = 0;
 54e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 550:	4481                	li	s1,0
 552:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 554:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 558:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 55c:	06c00c93          	li	s9,108
 560:	a005                	j	580 <vprintf+0x5a>
        putc(fd, c0);
 562:	85ca                	mv	a1,s2
 564:	855a                	mv	a0,s6
 566:	f07ff0ef          	jal	46c <putc>
 56a:	a019                	j	570 <vprintf+0x4a>
    } else if(state == '%'){
 56c:	03598263          	beq	s3,s5,590 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 570:	2485                	addiw	s1,s1,1
 572:	8726                	mv	a4,s1
 574:	009a07b3          	add	a5,s4,s1
 578:	0007c903          	lbu	s2,0(a5)
 57c:	22090a63          	beqz	s2,7b0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 580:	0009079b          	sext.w	a5,s2
    if(state == 0){
 584:	fe0994e3          	bnez	s3,56c <vprintf+0x46>
      if(c0 == '%'){
 588:	fd579de3          	bne	a5,s5,562 <vprintf+0x3c>
        state = '%';
 58c:	89be                	mv	s3,a5
 58e:	b7cd                	j	570 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 590:	00ea06b3          	add	a3,s4,a4
 594:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 598:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 59a:	c681                	beqz	a3,5a2 <vprintf+0x7c>
 59c:	9752                	add	a4,a4,s4
 59e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5a2:	05878363          	beq	a5,s8,5e8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5a6:	05978d63          	beq	a5,s9,600 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5aa:	07500713          	li	a4,117
 5ae:	0ee78763          	beq	a5,a4,69c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5b2:	07800713          	li	a4,120
 5b6:	12e78963          	beq	a5,a4,6e8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ba:	07000713          	li	a4,112
 5be:	14e78e63          	beq	a5,a4,71a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5c2:	06300713          	li	a4,99
 5c6:	18e78e63          	beq	a5,a4,762 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5ca:	07300713          	li	a4,115
 5ce:	1ae78463          	beq	a5,a4,776 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5d2:	02500713          	li	a4,37
 5d6:	04e79563          	bne	a5,a4,620 <vprintf+0xfa>
        putc(fd, '%');
 5da:	02500593          	li	a1,37
 5de:	855a                	mv	a0,s6
 5e0:	e8dff0ef          	jal	46c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b769                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4685                	li	a3,1
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	e95ff0ef          	jal	48a <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bf8d                	j	570 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 600:	06400793          	li	a5,100
 604:	02f68963          	beq	a3,a5,636 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 608:	06c00793          	li	a5,108
 60c:	04f68263          	beq	a3,a5,650 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 610:	07500793          	li	a5,117
 614:	0af68063          	beq	a3,a5,6b4 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 618:	07800793          	li	a5,120
 61c:	0ef68263          	beq	a3,a5,700 <vprintf+0x1da>
        putc(fd, '%');
 620:	02500593          	li	a1,37
 624:	855a                	mv	a0,s6
 626:	e47ff0ef          	jal	46c <putc>
        putc(fd, c0);
 62a:	85ca                	mv	a1,s2
 62c:	855a                	mv	a0,s6
 62e:	e3fff0ef          	jal	46c <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	bf35                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	008b8913          	addi	s2,s7,8
 63a:	4685                	li	a3,1
 63c:	4629                	li	a2,10
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e47ff0ef          	jal	48a <printint>
        i += 1;
 648:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 1;
 64e:	b70d                	j	570 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 650:	06400793          	li	a5,100
 654:	02f60763          	beq	a2,a5,682 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 658:	07500793          	li	a5,117
 65c:	06f60963          	beq	a2,a5,6ce <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 660:	07800793          	li	a5,120
 664:	faf61ee3          	bne	a2,a5,620 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	008b8913          	addi	s2,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e15ff0ef          	jal	48a <printint>
        i += 2;
 67a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 2;
 680:	bdc5                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	008b8913          	addi	s2,s7,8
 686:	4685                	li	a3,1
 688:	4629                	li	a2,10
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	dfbff0ef          	jal	48a <printint>
        i += 2;
 694:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	bdd9                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000be583          	lwu	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	de1ff0ef          	jal	48a <printint>
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bd7d                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	dc9ff0ef          	jal	48a <printint>
        i += 1;
 6c6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 1;
 6cc:	b555                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000bb583          	ld	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	dafff0ef          	jal	48a <printint>
        i += 2;
 6e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	b569                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000be583          	lwu	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	d95ff0ef          	jal	48a <printint>
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bd8d                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4641                	li	a2,16
 708:	000bb583          	ld	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	d7dff0ef          	jal	48a <printint>
        i += 1;
 712:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
        i += 1;
 718:	bda1                	j	570 <vprintf+0x4a>
 71a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 71c:	008b8d13          	addi	s10,s7,8
 720:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 724:	03000593          	li	a1,48
 728:	855a                	mv	a0,s6
 72a:	d43ff0ef          	jal	46c <putc>
  putc(fd, 'x');
 72e:	07800593          	li	a1,120
 732:	855a                	mv	a0,s6
 734:	d39ff0ef          	jal	46c <putc>
 738:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73a:	00000b97          	auipc	s7,0x0
 73e:	3beb8b93          	addi	s7,s7,958 # af8 <digits>
 742:	03c9d793          	srli	a5,s3,0x3c
 746:	97de                	add	a5,a5,s7
 748:	0007c583          	lbu	a1,0(a5)
 74c:	855a                	mv	a0,s6
 74e:	d1fff0ef          	jal	46c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 752:	0992                	slli	s3,s3,0x4
 754:	397d                	addiw	s2,s2,-1
 756:	fe0916e3          	bnez	s2,742 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 75a:	8bea                	mv	s7,s10
      state = 0;
 75c:	4981                	li	s3,0
 75e:	6d02                	ld	s10,0(sp)
 760:	bd01                	j	570 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 762:	008b8913          	addi	s2,s7,8
 766:	000bc583          	lbu	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	d01ff0ef          	jal	46c <putc>
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
 774:	bbf5                	j	570 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 776:	008b8993          	addi	s3,s7,8
 77a:	000bb903          	ld	s2,0(s7)
 77e:	00090f63          	beqz	s2,79c <vprintf+0x276>
        for(; *s; s++)
 782:	00094583          	lbu	a1,0(s2)
 786:	c195                	beqz	a1,7aa <vprintf+0x284>
          putc(fd, *s);
 788:	855a                	mv	a0,s6
 78a:	ce3ff0ef          	jal	46c <putc>
        for(; *s; s++)
 78e:	0905                	addi	s2,s2,1
 790:	00094583          	lbu	a1,0(s2)
 794:	f9f5                	bnez	a1,788 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 796:	8bce                	mv	s7,s3
      state = 0;
 798:	4981                	li	s3,0
 79a:	bbd9                	j	570 <vprintf+0x4a>
          s = "(null)";
 79c:	00000917          	auipc	s2,0x0
 7a0:	35490913          	addi	s2,s2,852 # af0 <malloc+0x248>
        for(; *s; s++)
 7a4:	02800593          	li	a1,40
 7a8:	b7c5                	j	788 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7aa:	8bce                	mv	s7,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b3c9                	j	570 <vprintf+0x4a>
 7b0:	64a6                	ld	s1,72(sp)
 7b2:	79e2                	ld	s3,56(sp)
 7b4:	7a42                	ld	s4,48(sp)
 7b6:	7aa2                	ld	s5,40(sp)
 7b8:	7b02                	ld	s6,32(sp)
 7ba:	6be2                	ld	s7,24(sp)
 7bc:	6c42                	ld	s8,16(sp)
 7be:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7c0:	60e6                	ld	ra,88(sp)
 7c2:	6446                	ld	s0,80(sp)
 7c4:	6906                	ld	s2,64(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret

00000000000007ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ca:	715d                	addi	sp,sp,-80
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e010                	sd	a2,0(s0)
 7d4:	e414                	sd	a3,8(s0)
 7d6:	e818                	sd	a4,16(s0)
 7d8:	ec1c                	sd	a5,24(s0)
 7da:	03043023          	sd	a6,32(s0)
 7de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e6:	8622                	mv	a2,s0
 7e8:	d3fff0ef          	jal	526 <vprintf>
}
 7ec:	60e2                	ld	ra,24(sp)
 7ee:	6442                	ld	s0,16(sp)
 7f0:	6161                	addi	sp,sp,80
 7f2:	8082                	ret

00000000000007f4 <printf>:

void
printf(const char *fmt, ...)
{
 7f4:	711d                	addi	sp,sp,-96
 7f6:	ec06                	sd	ra,24(sp)
 7f8:	e822                	sd	s0,16(sp)
 7fa:	1000                	addi	s0,sp,32
 7fc:	e40c                	sd	a1,8(s0)
 7fe:	e810                	sd	a2,16(s0)
 800:	ec14                	sd	a3,24(s0)
 802:	f018                	sd	a4,32(s0)
 804:	f41c                	sd	a5,40(s0)
 806:	03043823          	sd	a6,48(s0)
 80a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	00840613          	addi	a2,s0,8
 812:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 816:	85aa                	mv	a1,a0
 818:	4505                	li	a0,1
 81a:	d0dff0ef          	jal	526 <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6125                	addi	sp,sp,96
 824:	8082                	ret

0000000000000826 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 826:	1141                	addi	sp,sp,-16
 828:	e422                	sd	s0,8(sp)
 82a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 830:	00000797          	auipc	a5,0x0
 834:	7d07b783          	ld	a5,2000(a5) # 1000 <freep>
 838:	a02d                	j	862 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 83a:	4618                	lw	a4,8(a2)
 83c:	9f2d                	addw	a4,a4,a1
 83e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	6398                	ld	a4,0(a5)
 844:	6310                	ld	a2,0(a4)
 846:	a83d                	j	884 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 848:	ff852703          	lw	a4,-8(a0)
 84c:	9f31                	addw	a4,a4,a2
 84e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 850:	ff053683          	ld	a3,-16(a0)
 854:	a091                	j	898 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	6398                	ld	a4,0(a5)
 858:	00e7e463          	bltu	a5,a4,860 <free+0x3a>
 85c:	00e6ea63          	bltu	a3,a4,870 <free+0x4a>
{
 860:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	fed7fae3          	bgeu	a5,a3,856 <free+0x30>
 866:	6398                	ld	a4,0(a5)
 868:	00e6e463          	bltu	a3,a4,870 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	fee7eae3          	bltu	a5,a4,860 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 870:	ff852583          	lw	a1,-8(a0)
 874:	6390                	ld	a2,0(a5)
 876:	02059813          	slli	a6,a1,0x20
 87a:	01c85713          	srli	a4,a6,0x1c
 87e:	9736                	add	a4,a4,a3
 880:	fae60de3          	beq	a2,a4,83a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 884:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 888:	4790                	lw	a2,8(a5)
 88a:	02061593          	slli	a1,a2,0x20
 88e:	01c5d713          	srli	a4,a1,0x1c
 892:	973e                	add	a4,a4,a5
 894:	fae68ae3          	beq	a3,a4,848 <free+0x22>
    p->s.ptr = bp->s.ptr;
 898:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 89a:	00000717          	auipc	a4,0x0
 89e:	76f73323          	sd	a5,1894(a4) # 1000 <freep>
}
 8a2:	6422                	ld	s0,8(sp)
 8a4:	0141                	addi	sp,sp,16
 8a6:	8082                	ret

00000000000008a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a8:	7139                	addi	sp,sp,-64
 8aa:	fc06                	sd	ra,56(sp)
 8ac:	f822                	sd	s0,48(sp)
 8ae:	f426                	sd	s1,40(sp)
 8b0:	ec4e                	sd	s3,24(sp)
 8b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b4:	02051493          	slli	s1,a0,0x20
 8b8:	9081                	srli	s1,s1,0x20
 8ba:	04bd                	addi	s1,s1,15
 8bc:	8091                	srli	s1,s1,0x4
 8be:	0014899b          	addiw	s3,s1,1
 8c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c4:	00000517          	auipc	a0,0x0
 8c8:	73c53503          	ld	a0,1852(a0) # 1000 <freep>
 8cc:	c915                	beqz	a0,900 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	08977a63          	bgeu	a4,s1,966 <malloc+0xbe>
 8d6:	f04a                	sd	s2,32(sp)
 8d8:	e852                	sd	s4,16(sp)
 8da:	e456                	sd	s5,8(sp)
 8dc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8de:	8a4e                	mv	s4,s3
 8e0:	0009871b          	sext.w	a4,s3
 8e4:	6685                	lui	a3,0x1
 8e6:	00d77363          	bgeu	a4,a3,8ec <malloc+0x44>
 8ea:	6a05                	lui	s4,0x1
 8ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f4:	00000917          	auipc	s2,0x0
 8f8:	70c90913          	addi	s2,s2,1804 # 1000 <freep>
  if(p == SBRK_ERROR)
 8fc:	5afd                	li	s5,-1
 8fe:	a081                	j	93e <malloc+0x96>
 900:	f04a                	sd	s2,32(sp)
 902:	e852                	sd	s4,16(sp)
 904:	e456                	sd	s5,8(sp)
 906:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 908:	00000797          	auipc	a5,0x0
 90c:	70878793          	addi	a5,a5,1800 # 1010 <base>
 910:	00000717          	auipc	a4,0x0
 914:	6ef73823          	sd	a5,1776(a4) # 1000 <freep>
 918:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 91e:	b7c1                	j	8de <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 920:	6398                	ld	a4,0(a5)
 922:	e118                	sd	a4,0(a0)
 924:	a8a9                	j	97e <malloc+0xd6>
  hp->s.size = nu;
 926:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92a:	0541                	addi	a0,a0,16
 92c:	efbff0ef          	jal	826 <free>
  return freep;
 930:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 934:	c12d                	beqz	a0,996 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 936:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 938:	4798                	lw	a4,8(a5)
 93a:	02977263          	bgeu	a4,s1,95e <malloc+0xb6>
    if(p == freep)
 93e:	00093703          	ld	a4,0(s2)
 942:	853e                	mv	a0,a5
 944:	fef719e3          	bne	a4,a5,936 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 948:	8552                	mv	a0,s4
 94a:	a17ff0ef          	jal	360 <sbrk>
  if(p == SBRK_ERROR)
 94e:	fd551ce3          	bne	a0,s5,926 <malloc+0x7e>
        return 0;
 952:	4501                	li	a0,0
 954:	7902                	ld	s2,32(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
 95c:	a03d                	j	98a <malloc+0xe2>
 95e:	7902                	ld	s2,32(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 966:	fae48de3          	beq	s1,a4,920 <malloc+0x78>
        p->s.size -= nunits;
 96a:	4137073b          	subw	a4,a4,s3
 96e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 970:	02071693          	slli	a3,a4,0x20
 974:	01c6d713          	srli	a4,a3,0x1c
 978:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97e:	00000717          	auipc	a4,0x0
 982:	68a73123          	sd	a0,1666(a4) # 1000 <freep>
      return (void*)(p + 1);
 986:	01078513          	addi	a0,a5,16
  }
}
 98a:	70e2                	ld	ra,56(sp)
 98c:	7442                	ld	s0,48(sp)
 98e:	74a2                	ld	s1,40(sp)
 990:	69e2                	ld	s3,24(sp)
 992:	6121                	addi	sp,sp,64
 994:	8082                	ret
 996:	7902                	ld	s2,32(sp)
 998:	6a42                	ld	s4,16(sp)
 99a:	6aa2                	ld	s5,8(sp)
 99c:	6b02                	ld	s6,0(sp)
 99e:	b7f5                	j	98a <malloc+0xe2>
