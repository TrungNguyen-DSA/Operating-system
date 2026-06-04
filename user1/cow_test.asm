
user/_cow_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define PAGE_SIZE 4096

// Tạo một vùng đệm tĩnh lớn hơn 1 trang để kiểm tra CoW
char global_buf[PAGE_SIZE * 2];

int main() {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
    printf("=== xv6 Copy-on-Write (CoW) Verification ===\n");
   c:	00001517          	auipc	a0,0x1
  10:	9f450513          	addi	a0,a0,-1548 # a00 <malloc+0x106>
  14:	033000ef          	jal	846 <printf>

    // Khởi tạo dữ liệu ban đầu cho vùng nhớ (Tương đương FIX #4)
    global_buf[0] = 'A';
  18:	00001497          	auipc	s1,0x1
  1c:	ff848493          	addi	s1,s1,-8 # 1010 <global_buf>
  20:	04100793          	li	a5,65
  24:	00f48023          	sb	a5,0(s1)
    global_buf[PAGE_SIZE] = 'B';
  28:	00002917          	auipc	s2,0x2
  2c:	fe890913          	addi	s2,s2,-24 # 2010 <global_buf+0x1000>
  30:	04200793          	li	a5,66
  34:	00f90023          	sb	a5,0(s2)

    printf("[Parent] PID: %d\n", getpid());
  38:	42e000ef          	jal	466 <getpid>
  3c:	85aa                	mv	a1,a0
  3e:	00001517          	auipc	a0,0x1
  42:	9fa50513          	addi	a0,a0,-1542 # a38 <malloc+0x13e>
  46:	001000ef          	jal	846 <printf>
    printf("[Parent] Buffer Address: 0x%p\n", global_buf);
  4a:	85a6                	mv	a1,s1
  4c:	00001517          	auipc	a0,0x1
  50:	a0450513          	addi	a0,a0,-1532 # a50 <malloc+0x156>
  54:	7f2000ef          	jal	846 <printf>
    printf("[Parent] Page 0 init: '%c' | Page 1 init: '%c'\n", global_buf[0], global_buf[PAGE_SIZE]);
  58:	00094603          	lbu	a2,0(s2)
  5c:	0004c583          	lbu	a1,0(s1)
  60:	00001517          	auipc	a0,0x1
  64:	a1050513          	addi	a0,a0,-1520 # a70 <malloc+0x176>
  68:	7de000ef          	jal	846 <printf>
    printf("[Parent] Forking now... (Kernel will map page tables as Read-only)\n\n");
  6c:	00001517          	auipc	a0,0x1
  70:	a3450513          	addi	a0,a0,-1484 # aa0 <malloc+0x1a6>
  74:	7d2000ef          	jal	846 <printf>

    int pid = fork();
  78:	366000ef          	jal	3de <fork>

    if (pid < 0) {
  7c:	08054163          	bltz	a0,fe <main+0xfe>
        printf("Fork failed\n");
        exit(1);
    } 
    else if (pid == 0) {
  80:	e941                	bnez	a0,110 <main+0x110>
        /* ===== TIÊN TRÌNH CON (CHILD) ===== */
        printf("[Child]  PID: %d\n", getpid());
  82:	3e4000ef          	jal	466 <getpid>
  86:	85aa                	mv	a1,a0
  88:	00001517          	auipc	a0,0x1
  8c:	a7050513          	addi	a0,a0,-1424 # af8 <malloc+0x1fe>
  90:	7b6000ef          	jal	846 <printf>
        printf("[Child]  Buffer Address: 0x%p (Virtual address matches Parent)\n", global_buf);
  94:	00001597          	auipc	a1,0x1
  98:	f7c58593          	addi	a1,a1,-132 # 1010 <global_buf>
  9c:	00001517          	auipc	a0,0x1
  a0:	a7450513          	addi	a0,a0,-1420 # b10 <malloc+0x216>
  a4:	7a2000ef          	jal	846 <printf>
        
        // Đọc dữ liệu: Vẫn đang dùng chung trang vật lý với cha
        printf("[Child]  Read Page 0 (Shared Physical Page): '%c'\n", global_buf[0]);
  a8:	00001497          	auipc	s1,0x1
  ac:	f6848493          	addi	s1,s1,-152 # 1010 <global_buf>
  b0:	0004c583          	lbu	a1,0(s1)
  b4:	00001517          	auipc	a0,0x1
  b8:	a9c50513          	addi	a0,a0,-1380 # b50 <malloc+0x256>
  bc:	78a000ef          	jal	846 <printf>

        printf("[Child]  Writing to Page 0... (This triggers Kernel Page Fault -> CoW Allocation)\n");
  c0:	00001517          	auipc	a0,0x1
  c4:	ac850513          	addi	a0,a0,-1336 # b88 <malloc+0x28e>
  c8:	77e000ef          	jal	846 <printf>
        /* * Hành vi ghi này kích hoạt Store Page Fault (Trap 15) trong xv6.
         * Kernel sẽ âm thầm cấp phát 1 trang vật lý mới, sao chép nội dung 'A' sang,
         * đổi quyền thành Read/Write, rồi mới cho phép ghi chữ 'Z' vào.
         */
        global_buf[0] = 'Z'; 
  cc:	05a00793          	li	a5,90
  d0:	00f48023          	sb	a5,0(s1)

        printf("[Child]  Page 0 after write: '%c' (Child's private copy)\n", global_buf[0]);
  d4:	05a00593          	li	a1,90
  d8:	00001517          	auipc	a0,0x1
  dc:	b0850513          	addi	a0,a0,-1272 # be0 <malloc+0x2e6>
  e0:	766000ef          	jal	846 <printf>
        printf("[Child]  Page 1 (Still shared/unmodified): '%c'\n\n", global_buf[PAGE_SIZE]);
  e4:	00002597          	auipc	a1,0x2
  e8:	f2c5c583          	lbu	a1,-212(a1) # 2010 <global_buf+0x1000>
  ec:	00001517          	auipc	a0,0x1
  f0:	b3450513          	addi	a0,a0,-1228 # c20 <malloc+0x326>
  f4:	752000ef          	jal	846 <printf>
        
        exit(0);
  f8:	4501                	li	a0,0
  fa:	2ec000ef          	jal	3e6 <exit>
        printf("Fork failed\n");
  fe:	00001517          	auipc	a0,0x1
 102:	9ea50513          	addi	a0,a0,-1558 # ae8 <malloc+0x1ee>
 106:	740000ef          	jal	846 <printf>
        exit(1);
 10a:	4505                	li	a0,1
 10c:	2da000ef          	jal	3e6 <exit>
    } 
    else {
        /* ===== TIÊN TRÌNH CHA (PARENT) ===== */
        // Chờ tiến trình con kết thúc hoàn toàn
        int status;
        wait(&status);
 110:	fdc40513          	addi	a0,s0,-36
 114:	2da000ef          	jal	3ee <wait>

        printf("[Parent] Child process finished.\n");
 118:	00001517          	auipc	a0,0x1
 11c:	b4050513          	addi	a0,a0,-1216 # c58 <malloc+0x35e>
 120:	726000ef          	jal	846 <printf>
        // Kiểm tra xem dữ liệu của cha có bị ảnh hưởng bởi hành vi ghi của con không
        printf("[Parent] Page 0 after fork: '%c' (Should remain 'A' - isolated by CoW)\n", global_buf[0]);
 124:	00001597          	auipc	a1,0x1
 128:	eec5c583          	lbu	a1,-276(a1) # 1010 <global_buf>
 12c:	00001517          	auipc	a0,0x1
 130:	b5450513          	addi	a0,a0,-1196 # c80 <malloc+0x386>
 134:	712000ef          	jal	846 <printf>
        printf("[Parent] Page 1: '%c'\n", global_buf[PAGE_SIZE]);
 138:	00002597          	auipc	a1,0x2
 13c:	ed85c583          	lbu	a1,-296(a1) # 2010 <global_buf+0x1000>
 140:	00001517          	auipc	a0,0x1
 144:	b8850513          	addi	a0,a0,-1144 # cc8 <malloc+0x3ce>
 148:	6fe000ef          	jal	846 <printf>
    }

    exit(0);
 14c:	4501                	li	a0,0
 14e:	298000ef          	jal	3e6 <exit>

0000000000000152 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 152:	1141                	addi	sp,sp,-16
 154:	e406                	sd	ra,8(sp)
 156:	e022                	sd	s0,0(sp)
 158:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 15a:	ea7ff0ef          	jal	0 <main>
  exit(r);
 15e:	288000ef          	jal	3e6 <exit>

0000000000000162 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 168:	87aa                	mv	a5,a0
 16a:	0585                	addi	a1,a1,1
 16c:	0785                	addi	a5,a5,1
 16e:	fff5c703          	lbu	a4,-1(a1)
 172:	fee78fa3          	sb	a4,-1(a5)
 176:	fb75                	bnez	a4,16a <strcpy+0x8>
    ;
  return os;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb91                	beqz	a5,19c <strcmp+0x1e>
 18a:	0005c703          	lbu	a4,0(a1)
 18e:	00f71763          	bne	a4,a5,19c <strcmp+0x1e>
    p++, q++;
 192:	0505                	addi	a0,a0,1
 194:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbe5                	bnez	a5,18a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19c:	0005c503          	lbu	a0,0(a1)
}
 1a0:	40a7853b          	subw	a0,a5,a0
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strlen>:

uint
strlen(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cf91                	beqz	a5,1d0 <strlen+0x26>
 1b6:	0505                	addi	a0,a0,1
 1b8:	87aa                	mv	a5,a0
 1ba:	86be                	mv	a3,a5
 1bc:	0785                	addi	a5,a5,1
 1be:	fff7c703          	lbu	a4,-1(a5)
 1c2:	ff65                	bnez	a4,1ba <strlen+0x10>
 1c4:	40a6853b          	subw	a0,a3,a0
 1c8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  for(n = 0; s[n]; n++)
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <strlen+0x20>

00000000000001d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1da:	ca19                	beqz	a2,1f0 <memset+0x1c>
 1dc:	87aa                	mv	a5,a0
 1de:	1602                	slli	a2,a2,0x20
 1e0:	9201                	srli	a2,a2,0x20
 1e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ea:	0785                	addi	a5,a5,1
 1ec:	fee79de3          	bne	a5,a4,1e6 <memset+0x12>
  }
  return dst;
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret

00000000000001f6 <strchr>:

char*
strchr(const char *s, char c)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	cb99                	beqz	a5,216 <strchr+0x20>
    if(*s == c)
 202:	00f58763          	beq	a1,a5,210 <strchr+0x1a>
  for(; *s; s++)
 206:	0505                	addi	a0,a0,1
 208:	00054783          	lbu	a5,0(a0)
 20c:	fbfd                	bnez	a5,202 <strchr+0xc>
      return (char*)s;
  return 0;
 20e:	4501                	li	a0,0
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  return 0;
 216:	4501                	li	a0,0
 218:	bfe5                	j	210 <strchr+0x1a>

000000000000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	711d                	addi	sp,sp,-96
 21c:	ec86                	sd	ra,88(sp)
 21e:	e8a2                	sd	s0,80(sp)
 220:	e4a6                	sd	s1,72(sp)
 222:	e0ca                	sd	s2,64(sp)
 224:	fc4e                	sd	s3,56(sp)
 226:	f852                	sd	s4,48(sp)
 228:	f456                	sd	s5,40(sp)
 22a:	f05a                	sd	s6,32(sp)
 22c:	ec5e                	sd	s7,24(sp)
 22e:	1080                	addi	s0,sp,96
 230:	8baa                	mv	s7,a0
 232:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	892a                	mv	s2,a0
 236:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 238:	4aa9                	li	s5,10
 23a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23c:	89a6                	mv	s3,s1
 23e:	2485                	addiw	s1,s1,1
 240:	0344d663          	bge	s1,s4,26c <gets+0x52>
    cc = read(0, &c, 1);
 244:	4605                	li	a2,1
 246:	faf40593          	addi	a1,s0,-81
 24a:	4501                	li	a0,0
 24c:	1b2000ef          	jal	3fe <read>
    if(cc < 1)
 250:	00a05e63          	blez	a0,26c <gets+0x52>
    buf[i++] = c;
 254:	faf44783          	lbu	a5,-81(s0)
 258:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25c:	01578763          	beq	a5,s5,26a <gets+0x50>
 260:	0905                	addi	s2,s2,1
 262:	fd679de3          	bne	a5,s6,23c <gets+0x22>
    buf[i++] = c;
 266:	89a6                	mv	s3,s1
 268:	a011                	j	26c <gets+0x52>
 26a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26c:	99de                	add	s3,s3,s7
 26e:	00098023          	sb	zero,0(s3)
  return buf;
}
 272:	855e                	mv	a0,s7
 274:	60e6                	ld	ra,88(sp)
 276:	6446                	ld	s0,80(sp)
 278:	64a6                	ld	s1,72(sp)
 27a:	6906                	ld	s2,64(sp)
 27c:	79e2                	ld	s3,56(sp)
 27e:	7a42                	ld	s4,48(sp)
 280:	7aa2                	ld	s5,40(sp)
 282:	7b02                	ld	s6,32(sp)
 284:	6be2                	ld	s7,24(sp)
 286:	6125                	addi	sp,sp,96
 288:	8082                	ret

000000000000028a <stat>:

int
stat(const char *n, struct stat *st)
{
 28a:	1101                	addi	sp,sp,-32
 28c:	ec06                	sd	ra,24(sp)
 28e:	e822                	sd	s0,16(sp)
 290:	e04a                	sd	s2,0(sp)
 292:	1000                	addi	s0,sp,32
 294:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	4581                	li	a1,0
 298:	18e000ef          	jal	426 <open>
  if(fd < 0)
 29c:	02054263          	bltz	a0,2c0 <stat+0x36>
 2a0:	e426                	sd	s1,8(sp)
 2a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a4:	85ca                	mv	a1,s2
 2a6:	198000ef          	jal	43e <fstat>
 2aa:	892a                	mv	s2,a0
  close(fd);
 2ac:	8526                	mv	a0,s1
 2ae:	160000ef          	jal	40e <close>
  return r;
 2b2:	64a2                	ld	s1,8(sp)
}
 2b4:	854a                	mv	a0,s2
 2b6:	60e2                	ld	ra,24(sp)
 2b8:	6442                	ld	s0,16(sp)
 2ba:	6902                	ld	s2,0(sp)
 2bc:	6105                	addi	sp,sp,32
 2be:	8082                	ret
    return -1;
 2c0:	597d                	li	s2,-1
 2c2:	bfcd                	j	2b4 <stat+0x2a>

00000000000002c4 <atoi>:

int
atoi(const char *s)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ca:	00054683          	lbu	a3,0(a0)
 2ce:	fd06879b          	addiw	a5,a3,-48
 2d2:	0ff7f793          	zext.b	a5,a5
 2d6:	4625                	li	a2,9
 2d8:	02f66863          	bltu	a2,a5,308 <atoi+0x44>
 2dc:	872a                	mv	a4,a0
  n = 0;
 2de:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e0:	0705                	addi	a4,a4,1
 2e2:	0025179b          	slliw	a5,a0,0x2
 2e6:	9fa9                	addw	a5,a5,a0
 2e8:	0017979b          	slliw	a5,a5,0x1
 2ec:	9fb5                	addw	a5,a5,a3
 2ee:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f2:	00074683          	lbu	a3,0(a4)
 2f6:	fd06879b          	addiw	a5,a3,-48
 2fa:	0ff7f793          	zext.b	a5,a5
 2fe:	fef671e3          	bgeu	a2,a5,2e0 <atoi+0x1c>
  return n;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
  n = 0;
 308:	4501                	li	a0,0
 30a:	bfe5                	j	302 <atoi+0x3e>

000000000000030c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 312:	02b57463          	bgeu	a0,a1,33a <memmove+0x2e>
    while(n-- > 0)
 316:	00c05f63          	blez	a2,334 <memmove+0x28>
 31a:	1602                	slli	a2,a2,0x20
 31c:	9201                	srli	a2,a2,0x20
 31e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 322:	872a                	mv	a4,a0
      *dst++ = *src++;
 324:	0585                	addi	a1,a1,1
 326:	0705                	addi	a4,a4,1
 328:	fff5c683          	lbu	a3,-1(a1)
 32c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 330:	fef71ae3          	bne	a4,a5,324 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
    dst += n;
 33a:	00c50733          	add	a4,a0,a2
    src += n;
 33e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 340:	fec05ae3          	blez	a2,334 <memmove+0x28>
 344:	fff6079b          	addiw	a5,a2,-1
 348:	1782                	slli	a5,a5,0x20
 34a:	9381                	srli	a5,a5,0x20
 34c:	fff7c793          	not	a5,a5
 350:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 352:	15fd                	addi	a1,a1,-1
 354:	177d                	addi	a4,a4,-1
 356:	0005c683          	lbu	a3,0(a1)
 35a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 35e:	fee79ae3          	bne	a5,a4,352 <memmove+0x46>
 362:	bfc9                	j	334 <memmove+0x28>

0000000000000364 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 36a:	ca05                	beqz	a2,39a <memcmp+0x36>
 36c:	fff6069b          	addiw	a3,a2,-1
 370:	1682                	slli	a3,a3,0x20
 372:	9281                	srli	a3,a3,0x20
 374:	0685                	addi	a3,a3,1
 376:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 378:	00054783          	lbu	a5,0(a0)
 37c:	0005c703          	lbu	a4,0(a1)
 380:	00e79863          	bne	a5,a4,390 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 384:	0505                	addi	a0,a0,1
    p2++;
 386:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 388:	fed518e3          	bne	a0,a3,378 <memcmp+0x14>
  }
  return 0;
 38c:	4501                	li	a0,0
 38e:	a019                	j	394 <memcmp+0x30>
      return *p1 - *p2;
 390:	40e7853b          	subw	a0,a5,a4
}
 394:	6422                	ld	s0,8(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret
  return 0;
 39a:	4501                	li	a0,0
 39c:	bfe5                	j	394 <memcmp+0x30>

000000000000039e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e406                	sd	ra,8(sp)
 3a2:	e022                	sd	s0,0(sp)
 3a4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3a6:	f67ff0ef          	jal	30c <memmove>
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret

00000000000003b2 <sbrk>:

char *
sbrk(int n) {
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e406                	sd	ra,8(sp)
 3b6:	e022                	sd	s0,0(sp)
 3b8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3ba:	4585                	li	a1,1
 3bc:	0b2000ef          	jal	46e <sys_sbrk>
}
 3c0:	60a2                	ld	ra,8(sp)
 3c2:	6402                	ld	s0,0(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret

00000000000003c8 <sbrklazy>:

char *
sbrklazy(int n) {
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e406                	sd	ra,8(sp)
 3cc:	e022                	sd	s0,0(sp)
 3ce:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3d0:	4589                	li	a1,2
 3d2:	09c000ef          	jal	46e <sys_sbrk>
}
 3d6:	60a2                	ld	ra,8(sp)
 3d8:	6402                	ld	s0,0(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret

00000000000003de <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3de:	4885                	li	a7,1
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e6:	4889                	li	a7,2
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ee:	488d                	li	a7,3
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f6:	4891                	li	a7,4
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <read>:
.global read
read:
 li a7, SYS_read
 3fe:	4895                	li	a7,5
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <write>:
.global write
write:
 li a7, SYS_write
 406:	48c1                	li	a7,16
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <close>:
.global close
close:
 li a7, SYS_close
 40e:	48d5                	li	a7,21
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <kill>:
.global kill
kill:
 li a7, SYS_kill
 416:	4899                	li	a7,6
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <exec>:
.global exec
exec:
 li a7, SYS_exec
 41e:	489d                	li	a7,7
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <open>:
.global open
open:
 li a7, SYS_open
 426:	48bd                	li	a7,15
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 42e:	48c5                	li	a7,17
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 436:	48c9                	li	a7,18
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 43e:	48a1                	li	a7,8
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <link>:
.global link
link:
 li a7, SYS_link
 446:	48cd                	li	a7,19
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 44e:	48d1                	li	a7,20
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 456:	48a5                	li	a7,9
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <dup>:
.global dup
dup:
 li a7, SYS_dup
 45e:	48a9                	li	a7,10
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 466:	48ad                	li	a7,11
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 46e:	48b1                	li	a7,12
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <pause>:
.global pause
pause:
 li a7, SYS_pause
 476:	48b5                	li	a7,13
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 47e:	48b9                	li	a7,14
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <hello>:
.global hello
hello:
 li a7, SYS_hello
 486:	48d9                	li	a7,22
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <ps>:
.global ps
ps:
 li a7, SYS_ps
 48e:	48dd                	li	a7,23
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 496:	48e1                	li	a7,24
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 49e:	48e5                	li	a7,25
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 4a6:	48e9                	li	a7,26
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 4ae:	48ed                	li	a7,27
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 4b6:	48f1                	li	a7,28
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4be:	1101                	addi	sp,sp,-32
 4c0:	ec06                	sd	ra,24(sp)
 4c2:	e822                	sd	s0,16(sp)
 4c4:	1000                	addi	s0,sp,32
 4c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ca:	4605                	li	a2,1
 4cc:	fef40593          	addi	a1,s0,-17
 4d0:	f37ff0ef          	jal	406 <write>
}
 4d4:	60e2                	ld	ra,24(sp)
 4d6:	6442                	ld	s0,16(sp)
 4d8:	6105                	addi	sp,sp,32
 4da:	8082                	ret

00000000000004dc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4dc:	715d                	addi	sp,sp,-80
 4de:	e486                	sd	ra,72(sp)
 4e0:	e0a2                	sd	s0,64(sp)
 4e2:	f84a                	sd	s2,48(sp)
 4e4:	0880                	addi	s0,sp,80
 4e6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4e8:	c299                	beqz	a3,4ee <printint+0x12>
 4ea:	0805c363          	bltz	a1,570 <printint+0x94>
  neg = 0;
 4ee:	4881                	li	a7,0
 4f0:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4f4:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4f6:	00000517          	auipc	a0,0x0
 4fa:	7f250513          	addi	a0,a0,2034 # ce8 <digits>
 4fe:	883e                	mv	a6,a5
 500:	2785                	addiw	a5,a5,1
 502:	02c5f733          	remu	a4,a1,a2
 506:	972a                	add	a4,a4,a0
 508:	00074703          	lbu	a4,0(a4)
 50c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 510:	872e                	mv	a4,a1
 512:	02c5d5b3          	divu	a1,a1,a2
 516:	0685                	addi	a3,a3,1
 518:	fec773e3          	bgeu	a4,a2,4fe <printint+0x22>
  if(neg)
 51c:	00088b63          	beqz	a7,532 <printint+0x56>
    buf[i++] = '-';
 520:	fd078793          	addi	a5,a5,-48
 524:	97a2                	add	a5,a5,s0
 526:	02d00713          	li	a4,45
 52a:	fee78423          	sb	a4,-24(a5)
 52e:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 532:	02f05a63          	blez	a5,566 <printint+0x8a>
 536:	fc26                	sd	s1,56(sp)
 538:	f44e                	sd	s3,40(sp)
 53a:	fb840713          	addi	a4,s0,-72
 53e:	00f704b3          	add	s1,a4,a5
 542:	fff70993          	addi	s3,a4,-1
 546:	99be                	add	s3,s3,a5
 548:	37fd                	addiw	a5,a5,-1
 54a:	1782                	slli	a5,a5,0x20
 54c:	9381                	srli	a5,a5,0x20
 54e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 552:	fff4c583          	lbu	a1,-1(s1)
 556:	854a                	mv	a0,s2
 558:	f67ff0ef          	jal	4be <putc>
  while(--i >= 0)
 55c:	14fd                	addi	s1,s1,-1
 55e:	ff349ae3          	bne	s1,s3,552 <printint+0x76>
 562:	74e2                	ld	s1,56(sp)
 564:	79a2                	ld	s3,40(sp)
}
 566:	60a6                	ld	ra,72(sp)
 568:	6406                	ld	s0,64(sp)
 56a:	7942                	ld	s2,48(sp)
 56c:	6161                	addi	sp,sp,80
 56e:	8082                	ret
    x = -xx;
 570:	40b005b3          	neg	a1,a1
    neg = 1;
 574:	4885                	li	a7,1
    x = -xx;
 576:	bfad                	j	4f0 <printint+0x14>

0000000000000578 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 578:	711d                	addi	sp,sp,-96
 57a:	ec86                	sd	ra,88(sp)
 57c:	e8a2                	sd	s0,80(sp)
 57e:	e0ca                	sd	s2,64(sp)
 580:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 582:	0005c903          	lbu	s2,0(a1)
 586:	28090663          	beqz	s2,812 <vprintf+0x29a>
 58a:	e4a6                	sd	s1,72(sp)
 58c:	fc4e                	sd	s3,56(sp)
 58e:	f852                	sd	s4,48(sp)
 590:	f456                	sd	s5,40(sp)
 592:	f05a                	sd	s6,32(sp)
 594:	ec5e                	sd	s7,24(sp)
 596:	e862                	sd	s8,16(sp)
 598:	e466                	sd	s9,8(sp)
 59a:	8b2a                	mv	s6,a0
 59c:	8a2e                	mv	s4,a1
 59e:	8bb2                	mv	s7,a2
  state = 0;
 5a0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5a2:	4481                	li	s1,0
 5a4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5aa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ae:	06c00c93          	li	s9,108
 5b2:	a005                	j	5d2 <vprintf+0x5a>
        putc(fd, c0);
 5b4:	85ca                	mv	a1,s2
 5b6:	855a                	mv	a0,s6
 5b8:	f07ff0ef          	jal	4be <putc>
 5bc:	a019                	j	5c2 <vprintf+0x4a>
    } else if(state == '%'){
 5be:	03598263          	beq	s3,s5,5e2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5c2:	2485                	addiw	s1,s1,1
 5c4:	8726                	mv	a4,s1
 5c6:	009a07b3          	add	a5,s4,s1
 5ca:	0007c903          	lbu	s2,0(a5)
 5ce:	22090a63          	beqz	s2,802 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5d2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d6:	fe0994e3          	bnez	s3,5be <vprintf+0x46>
      if(c0 == '%'){
 5da:	fd579de3          	bne	a5,s5,5b4 <vprintf+0x3c>
        state = '%';
 5de:	89be                	mv	s3,a5
 5e0:	b7cd                	j	5c2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e2:	00ea06b3          	add	a3,s4,a4
 5e6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ec:	c681                	beqz	a3,5f4 <vprintf+0x7c>
 5ee:	9752                	add	a4,a4,s4
 5f0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f4:	05878363          	beq	a5,s8,63a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5f8:	05978d63          	beq	a5,s9,652 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5fc:	07500713          	li	a4,117
 600:	0ee78763          	beq	a5,a4,6ee <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 604:	07800713          	li	a4,120
 608:	12e78963          	beq	a5,a4,73a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 60c:	07000713          	li	a4,112
 610:	14e78e63          	beq	a5,a4,76c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 614:	06300713          	li	a4,99
 618:	18e78e63          	beq	a5,a4,7b4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 61c:	07300713          	li	a4,115
 620:	1ae78463          	beq	a5,a4,7c8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 624:	02500713          	li	a4,37
 628:	04e79563          	bne	a5,a4,672 <vprintf+0xfa>
        putc(fd, '%');
 62c:	02500593          	li	a1,37
 630:	855a                	mv	a0,s6
 632:	e8dff0ef          	jal	4be <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 636:	4981                	li	s3,0
 638:	b769                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e95ff0ef          	jal	4dc <printint>
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	bf8d                	j	5c2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 652:	06400793          	li	a5,100
 656:	02f68963          	beq	a3,a5,688 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65a:	06c00793          	li	a5,108
 65e:	04f68263          	beq	a3,a5,6a2 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 662:	07500793          	li	a5,117
 666:	0af68063          	beq	a3,a5,706 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 66a:	07800793          	li	a5,120
 66e:	0ef68263          	beq	a3,a5,752 <vprintf+0x1da>
        putc(fd, '%');
 672:	02500593          	li	a1,37
 676:	855a                	mv	a0,s6
 678:	e47ff0ef          	jal	4be <putc>
        putc(fd, c0);
 67c:	85ca                	mv	a1,s2
 67e:	855a                	mv	a0,s6
 680:	e3fff0ef          	jal	4be <putc>
      state = 0;
 684:	4981                	li	s3,0
 686:	bf35                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	008b8913          	addi	s2,s7,8
 68c:	4685                	li	a3,1
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	e47ff0ef          	jal	4dc <printint>
        i += 1;
 69a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 1;
 6a0:	b70d                	j	5c2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a2:	06400793          	li	a5,100
 6a6:	02f60763          	beq	a2,a5,6d4 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6aa:	07500793          	li	a5,117
 6ae:	06f60963          	beq	a2,a5,720 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b2:	07800793          	li	a5,120
 6b6:	faf61ee3          	bne	a2,a5,672 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4681                	li	a3,0
 6c0:	4641                	li	a2,16
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	e15ff0ef          	jal	4dc <printint>
        i += 2;
 6cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
        i += 2;
 6d2:	bdc5                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4685                	li	a3,1
 6da:	4629                	li	a2,10
 6dc:	000bb583          	ld	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	dfbff0ef          	jal	4dc <printint>
        i += 2;
 6e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
        i += 2;
 6ec:	bdd9                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	4681                	li	a3,0
 6f4:	4629                	li	a2,10
 6f6:	000be583          	lwu	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	de1ff0ef          	jal	4dc <printint>
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
 704:	bd7d                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 706:	008b8913          	addi	s2,s7,8
 70a:	4681                	li	a3,0
 70c:	4629                	li	a2,10
 70e:	000bb583          	ld	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	dc9ff0ef          	jal	4dc <printint>
        i += 1;
 718:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
        i += 1;
 71e:	b555                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 720:	008b8913          	addi	s2,s7,8
 724:	4681                	li	a3,0
 726:	4629                	li	a2,10
 728:	000bb583          	ld	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	dafff0ef          	jal	4dc <printint>
        i += 2;
 732:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
        i += 2;
 738:	b569                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4681                	li	a3,0
 740:	4641                	li	a2,16
 742:	000be583          	lwu	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	d95ff0ef          	jal	4dc <printint>
 74c:	8bca                	mv	s7,s2
      state = 0;
 74e:	4981                	li	s3,0
 750:	bd8d                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 752:	008b8913          	addi	s2,s7,8
 756:	4681                	li	a3,0
 758:	4641                	li	a2,16
 75a:	000bb583          	ld	a1,0(s7)
 75e:	855a                	mv	a0,s6
 760:	d7dff0ef          	jal	4dc <printint>
        i += 1;
 764:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
        i += 1;
 76a:	bda1                	j	5c2 <vprintf+0x4a>
 76c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 76e:	008b8d13          	addi	s10,s7,8
 772:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 776:	03000593          	li	a1,48
 77a:	855a                	mv	a0,s6
 77c:	d43ff0ef          	jal	4be <putc>
  putc(fd, 'x');
 780:	07800593          	li	a1,120
 784:	855a                	mv	a0,s6
 786:	d39ff0ef          	jal	4be <putc>
 78a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78c:	00000b97          	auipc	s7,0x0
 790:	55cb8b93          	addi	s7,s7,1372 # ce8 <digits>
 794:	03c9d793          	srli	a5,s3,0x3c
 798:	97de                	add	a5,a5,s7
 79a:	0007c583          	lbu	a1,0(a5)
 79e:	855a                	mv	a0,s6
 7a0:	d1fff0ef          	jal	4be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a4:	0992                	slli	s3,s3,0x4
 7a6:	397d                	addiw	s2,s2,-1
 7a8:	fe0916e3          	bnez	s2,794 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7ac:	8bea                	mv	s7,s10
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	6d02                	ld	s10,0(sp)
 7b2:	bd01                	j	5c2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	000bc583          	lbu	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	d01ff0ef          	jal	4be <putc>
 7c2:	8bca                	mv	s7,s2
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bbf5                	j	5c2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7c8:	008b8993          	addi	s3,s7,8
 7cc:	000bb903          	ld	s2,0(s7)
 7d0:	00090f63          	beqz	s2,7ee <vprintf+0x276>
        for(; *s; s++)
 7d4:	00094583          	lbu	a1,0(s2)
 7d8:	c195                	beqz	a1,7fc <vprintf+0x284>
          putc(fd, *s);
 7da:	855a                	mv	a0,s6
 7dc:	ce3ff0ef          	jal	4be <putc>
        for(; *s; s++)
 7e0:	0905                	addi	s2,s2,1
 7e2:	00094583          	lbu	a1,0(s2)
 7e6:	f9f5                	bnez	a1,7da <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7e8:	8bce                	mv	s7,s3
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	bbd9                	j	5c2 <vprintf+0x4a>
          s = "(null)";
 7ee:	00000917          	auipc	s2,0x0
 7f2:	4f290913          	addi	s2,s2,1266 # ce0 <malloc+0x3e6>
        for(; *s; s++)
 7f6:	02800593          	li	a1,40
 7fa:	b7c5                	j	7da <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7fc:	8bce                	mv	s7,s3
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b3c9                	j	5c2 <vprintf+0x4a>
 802:	64a6                	ld	s1,72(sp)
 804:	79e2                	ld	s3,56(sp)
 806:	7a42                	ld	s4,48(sp)
 808:	7aa2                	ld	s5,40(sp)
 80a:	7b02                	ld	s6,32(sp)
 80c:	6be2                	ld	s7,24(sp)
 80e:	6c42                	ld	s8,16(sp)
 810:	6ca2                	ld	s9,8(sp)
    }
  }
}
 812:	60e6                	ld	ra,88(sp)
 814:	6446                	ld	s0,80(sp)
 816:	6906                	ld	s2,64(sp)
 818:	6125                	addi	sp,sp,96
 81a:	8082                	ret

000000000000081c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81c:	715d                	addi	sp,sp,-80
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e010                	sd	a2,0(s0)
 826:	e414                	sd	a3,8(s0)
 828:	e818                	sd	a4,16(s0)
 82a:	ec1c                	sd	a5,24(s0)
 82c:	03043023          	sd	a6,32(s0)
 830:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 834:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 838:	8622                	mv	a2,s0
 83a:	d3fff0ef          	jal	578 <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6161                	addi	sp,sp,80
 844:	8082                	ret

0000000000000846 <printf>:

void
printf(const char *fmt, ...)
{
 846:	711d                	addi	sp,sp,-96
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	e40c                	sd	a1,8(s0)
 850:	e810                	sd	a2,16(s0)
 852:	ec14                	sd	a3,24(s0)
 854:	f018                	sd	a4,32(s0)
 856:	f41c                	sd	a5,40(s0)
 858:	03043823          	sd	a6,48(s0)
 85c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 860:	00840613          	addi	a2,s0,8
 864:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 868:	85aa                	mv	a1,a0
 86a:	4505                	li	a0,1
 86c:	d0dff0ef          	jal	578 <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6125                	addi	sp,sp,96
 876:	8082                	ret

0000000000000878 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 878:	1141                	addi	sp,sp,-16
 87a:	e422                	sd	s0,8(sp)
 87c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 882:	00000797          	auipc	a5,0x0
 886:	77e7b783          	ld	a5,1918(a5) # 1000 <freep>
 88a:	a02d                	j	8b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 88c:	4618                	lw	a4,8(a2)
 88e:	9f2d                	addw	a4,a4,a1
 890:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	6398                	ld	a4,0(a5)
 896:	6310                	ld	a2,0(a4)
 898:	a83d                	j	8d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 89a:	ff852703          	lw	a4,-8(a0)
 89e:	9f31                	addw	a4,a4,a2
 8a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a2:	ff053683          	ld	a3,-16(a0)
 8a6:	a091                	j	8ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a8:	6398                	ld	a4,0(a5)
 8aa:	00e7e463          	bltu	a5,a4,8b2 <free+0x3a>
 8ae:	00e6ea63          	bltu	a3,a4,8c2 <free+0x4a>
{
 8b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b4:	fed7fae3          	bgeu	a5,a3,8a8 <free+0x30>
 8b8:	6398                	ld	a4,0(a5)
 8ba:	00e6e463          	bltu	a3,a4,8c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	fee7eae3          	bltu	a5,a4,8b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8c2:	ff852583          	lw	a1,-8(a0)
 8c6:	6390                	ld	a2,0(a5)
 8c8:	02059813          	slli	a6,a1,0x20
 8cc:	01c85713          	srli	a4,a6,0x1c
 8d0:	9736                	add	a4,a4,a3
 8d2:	fae60de3          	beq	a2,a4,88c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8da:	4790                	lw	a2,8(a5)
 8dc:	02061593          	slli	a1,a2,0x20
 8e0:	01c5d713          	srli	a4,a1,0x1c
 8e4:	973e                	add	a4,a4,a5
 8e6:	fae68ae3          	beq	a3,a4,89a <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70f73a23          	sd	a5,1812(a4) # 1000 <freep>
}
 8f4:	6422                	ld	s0,8(sp)
 8f6:	0141                	addi	sp,sp,16
 8f8:	8082                	ret

00000000000008fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8fa:	7139                	addi	sp,sp,-64
 8fc:	fc06                	sd	ra,56(sp)
 8fe:	f822                	sd	s0,48(sp)
 900:	f426                	sd	s1,40(sp)
 902:	ec4e                	sd	s3,24(sp)
 904:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 906:	02051493          	slli	s1,a0,0x20
 90a:	9081                	srli	s1,s1,0x20
 90c:	04bd                	addi	s1,s1,15
 90e:	8091                	srli	s1,s1,0x4
 910:	0014899b          	addiw	s3,s1,1
 914:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 916:	00000517          	auipc	a0,0x0
 91a:	6ea53503          	ld	a0,1770(a0) # 1000 <freep>
 91e:	c915                	beqz	a0,952 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 922:	4798                	lw	a4,8(a5)
 924:	08977a63          	bgeu	a4,s1,9b8 <malloc+0xbe>
 928:	f04a                	sd	s2,32(sp)
 92a:	e852                	sd	s4,16(sp)
 92c:	e456                	sd	s5,8(sp)
 92e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 930:	8a4e                	mv	s4,s3
 932:	0009871b          	sext.w	a4,s3
 936:	6685                	lui	a3,0x1
 938:	00d77363          	bgeu	a4,a3,93e <malloc+0x44>
 93c:	6a05                	lui	s4,0x1
 93e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 942:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 946:	00000917          	auipc	s2,0x0
 94a:	6ba90913          	addi	s2,s2,1722 # 1000 <freep>
  if(p == SBRK_ERROR)
 94e:	5afd                	li	s5,-1
 950:	a081                	j	990 <malloc+0x96>
 952:	f04a                	sd	s2,32(sp)
 954:	e852                	sd	s4,16(sp)
 956:	e456                	sd	s5,8(sp)
 958:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 95a:	00002797          	auipc	a5,0x2
 95e:	6b678793          	addi	a5,a5,1718 # 3010 <base>
 962:	00000717          	auipc	a4,0x0
 966:	68f73f23          	sd	a5,1694(a4) # 1000 <freep>
 96a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 970:	b7c1                	j	930 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 972:	6398                	ld	a4,0(a5)
 974:	e118                	sd	a4,0(a0)
 976:	a8a9                	j	9d0 <malloc+0xd6>
  hp->s.size = nu;
 978:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97c:	0541                	addi	a0,a0,16
 97e:	efbff0ef          	jal	878 <free>
  return freep;
 982:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 986:	c12d                	beqz	a0,9e8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 988:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98a:	4798                	lw	a4,8(a5)
 98c:	02977263          	bgeu	a4,s1,9b0 <malloc+0xb6>
    if(p == freep)
 990:	00093703          	ld	a4,0(s2)
 994:	853e                	mv	a0,a5
 996:	fef719e3          	bne	a4,a5,988 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 99a:	8552                	mv	a0,s4
 99c:	a17ff0ef          	jal	3b2 <sbrk>
  if(p == SBRK_ERROR)
 9a0:	fd551ce3          	bne	a0,s5,978 <malloc+0x7e>
        return 0;
 9a4:	4501                	li	a0,0
 9a6:	7902                	ld	s2,32(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
 9ae:	a03d                	j	9dc <malloc+0xe2>
 9b0:	7902                	ld	s2,32(sp)
 9b2:	6a42                	ld	s4,16(sp)
 9b4:	6aa2                	ld	s5,8(sp)
 9b6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b8:	fae48de3          	beq	s1,a4,972 <malloc+0x78>
        p->s.size -= nunits;
 9bc:	4137073b          	subw	a4,a4,s3
 9c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c2:	02071693          	slli	a3,a4,0x20
 9c6:	01c6d713          	srli	a4,a3,0x1c
 9ca:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9cc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d0:	00000717          	auipc	a4,0x0
 9d4:	62a73823          	sd	a0,1584(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d8:	01078513          	addi	a0,a5,16
  }
}
 9dc:	70e2                	ld	ra,56(sp)
 9de:	7442                	ld	s0,48(sp)
 9e0:	74a2                	ld	s1,40(sp)
 9e2:	69e2                	ld	s3,24(sp)
 9e4:	6121                	addi	sp,sp,64
 9e6:	8082                	ret
 9e8:	7902                	ld	s2,32(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
 9f0:	b7f5                	j	9dc <malloc+0xe2>
