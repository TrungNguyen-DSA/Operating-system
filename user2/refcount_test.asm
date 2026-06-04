
user/_refcount_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <get_page>:
    int ref_count;
    int page_id;
} Page;

// Tăng reference count khi có tiến trình tham chiếu tới
void get_page(Page *p) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    p->ref_count++;
   8:	4110                	lw	a2,0(a0)
   a:	2605                	addiw	a2,a2,1
   c:	c110                	sw	a2,0(a0)
    printf("Process uses Page %d -> ref_count = %d\n", p->page_id, p->ref_count);
   e:	2601                	sext.w	a2,a2
  10:	414c                	lw	a1,4(a0)
  12:	00001517          	auipc	a0,0x1
  16:	9de50513          	addi	a0,a0,-1570 # 9f0 <malloc+0xf8>
  1a:	02b000ef          	jal	844 <printf>
}
  1e:	60a2                	ld	ra,8(sp)
  20:	6402                	ld	s0,0(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <put_page>:

// Giảm reference count khi tiến trình giải phóng tham chiếu
void put_page(Page *p) {
  26:	1101                	addi	sp,sp,-32
  28:	ec06                	sd	ra,24(sp)
  2a:	e822                	sd	s0,16(sp)
  2c:	e426                	sd	s1,8(sp)
  2e:	1000                	addi	s0,sp,32
  30:	84aa                	mv	s1,a0
    p->ref_count--;
  32:	4110                	lw	a2,0(a0)
  34:	367d                	addiw	a2,a2,-1
  36:	c110                	sw	a2,0(a0)
    printf("Process releases Page %d -> ref_count = %d\n", p->page_id, p->ref_count);
  38:	2601                	sext.w	a2,a2
  3a:	414c                	lw	a1,4(a0)
  3c:	00001517          	auipc	a0,0x1
  40:	9dc50513          	addi	a0,a0,-1572 # a18 <malloc+0x120>
  44:	001000ef          	jal	844 <printf>

    // Chỉ khi không còn ai sử dụng (ref_count == 0), Kernel mới giải phóng thực tế
    if (p->ref_count == 0) {
  48:	409c                	lw	a5,0(s1)
  4a:	c791                	beqz	a5,56 <put_page+0x30>
        printf("[KERNEL] ref_count = 0 -> Freeing Page %d memory physically!\n", p->page_id);
        free(p);
    }
}
  4c:	60e2                	ld	ra,24(sp)
  4e:	6442                	ld	s0,16(sp)
  50:	64a2                	ld	s1,8(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
        printf("[KERNEL] ref_count = 0 -> Freeing Page %d memory physically!\n", p->page_id);
  56:	40cc                	lw	a1,4(s1)
  58:	00001517          	auipc	a0,0x1
  5c:	9f050513          	addi	a0,a0,-1552 # a48 <malloc+0x150>
  60:	7e4000ef          	jal	844 <printf>
        free(p);
  64:	8526                	mv	a0,s1
  66:	011000ef          	jal	876 <free>
}
  6a:	b7cd                	j	4c <put_page+0x26>

000000000000006c <main>:

int main() {
  6c:	1101                	addi	sp,sp,-32
  6e:	ec06                	sd	ra,24(sp)
  70:	e822                	sd	s0,16(sp)
  72:	1000                	addi	s0,sp,32
    printf("=== xv6 Reference Counting Simulation ===\n");
  74:	00001517          	auipc	a0,0x1
  78:	a1450513          	addi	a0,a0,-1516 # a88 <malloc+0x190>
  7c:	7c8000ef          	jal	844 <printf>

    // Giả lập Kernel cấp phát một vùng nhớ Shared Page thông qua heap (sbrk/malloc)
    Page *shared_page = (Page*) malloc(sizeof(Page));
  80:	4521                	li	a0,8
  82:	077000ef          	jal	8f8 <malloc>
    if (shared_page == 0) {
  86:	c95d                	beqz	a0,13c <main+0xd0>
  88:	e426                	sd	s1,8(sp)
  8a:	84aa                	mv	s1,a0
        printf("Memory allocation failed\n");
        exit(1);
    }

    shared_page->page_id = 101;
  8c:	06500793          	li	a5,101
  90:	c15c                	sw	a5,4(a0)
    shared_page->ref_count = 0;
  92:	00052023          	sw	zero,0(a0)

    printf("[INITIAL] Shared Page created at address: 0x%p\n\n", shared_page);
  96:	85aa                	mv	a1,a0
  98:	00001517          	auipc	a0,0x1
  9c:	a4050513          	addi	a0,a0,-1472 # ad8 <malloc+0x1e0>
  a0:	7a4000ef          	jal	844 <printf>

    // Giả lập tình huống: Các tiến trình lần lượt ánh xạ (map) vào trang này
    printf("--- Processes Attaching ---\n");
  a4:	00001517          	auipc	a0,0x1
  a8:	a6c50513          	addi	a0,a0,-1428 # b10 <malloc+0x218>
  ac:	798000ef          	jal	844 <printf>
    printf("[Process A] "); get_page(shared_page);
  b0:	00001517          	auipc	a0,0x1
  b4:	a8050513          	addi	a0,a0,-1408 # b30 <malloc+0x238>
  b8:	78c000ef          	jal	844 <printf>
  bc:	8526                	mv	a0,s1
  be:	f43ff0ef          	jal	0 <get_page>
    printf("[Process B] "); get_page(shared_page);
  c2:	00001517          	auipc	a0,0x1
  c6:	a7e50513          	addi	a0,a0,-1410 # b40 <malloc+0x248>
  ca:	77a000ef          	jal	844 <printf>
  ce:	8526                	mv	a0,s1
  d0:	f31ff0ef          	jal	0 <get_page>
    printf("[Process C] "); get_page(shared_page);
  d4:	00001517          	auipc	a0,0x1
  d8:	a7c50513          	addi	a0,a0,-1412 # b50 <malloc+0x258>
  dc:	768000ef          	jal	844 <printf>
  e0:	8526                	mv	a0,s1
  e2:	f1fff0ef          	jal	0 <get_page>

    // Giả lập tình huống: Các tiến trình lần lượt thoát hoặc hủy ánh xạ (unmap)
    printf("\n--- Processes Exiting ---\n");
  e6:	00001517          	auipc	a0,0x1
  ea:	a7a50513          	addi	a0,a0,-1414 # b60 <malloc+0x268>
  ee:	756000ef          	jal	844 <printf>
    printf("[Process A] "); put_page(shared_page);
  f2:	00001517          	auipc	a0,0x1
  f6:	a3e50513          	addi	a0,a0,-1474 # b30 <malloc+0x238>
  fa:	74a000ef          	jal	844 <printf>
  fe:	8526                	mv	a0,s1
 100:	f27ff0ef          	jal	26 <put_page>
    printf("[Process B] "); put_page(shared_page);
 104:	00001517          	auipc	a0,0x1
 108:	a3c50513          	addi	a0,a0,-1476 # b40 <malloc+0x248>
 10c:	738000ef          	jal	844 <printf>
 110:	8526                	mv	a0,s1
 112:	f15ff0ef          	jal	26 <put_page>
    
    // Tại điểm này ref_count = 1, vùng nhớ vẫn phải được giữ nguyên vẹn
    printf("[STATUS] Page %d is still alive in Kernel because ref_count > 0\n", shared_page->page_id);
 116:	40cc                	lw	a1,4(s1)
 118:	00001517          	auipc	a0,0x1
 11c:	a6850513          	addi	a0,a0,-1432 # b80 <malloc+0x288>
 120:	724000ef          	jal	844 <printf>
    
    printf("[Process C] "); put_page(shared_page);
 124:	00001517          	auipc	a0,0x1
 128:	a2c50513          	addi	a0,a0,-1492 # b50 <malloc+0x258>
 12c:	718000ef          	jal	844 <printf>
 130:	8526                	mv	a0,s1
 132:	ef5ff0ef          	jal	26 <put_page>

    exit(0);
 136:	4501                	li	a0,0
 138:	2ac000ef          	jal	3e4 <exit>
 13c:	e426                	sd	s1,8(sp)
        printf("Memory allocation failed\n");
 13e:	00001517          	auipc	a0,0x1
 142:	97a50513          	addi	a0,a0,-1670 # ab8 <malloc+0x1c0>
 146:	6fe000ef          	jal	844 <printf>
        exit(1);
 14a:	4505                	li	a0,1
 14c:	298000ef          	jal	3e4 <exit>

0000000000000150 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 158:	f15ff0ef          	jal	6c <main>
  exit(r);
 15c:	288000ef          	jal	3e4 <exit>

0000000000000160 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 166:	87aa                	mv	a5,a0
 168:	0585                	addi	a1,a1,1
 16a:	0785                	addi	a5,a5,1
 16c:	fff5c703          	lbu	a4,-1(a1)
 170:	fee78fa3          	sb	a4,-1(a5)
 174:	fb75                	bnez	a4,168 <strcpy+0x8>
    ;
  return os;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	cb91                	beqz	a5,19a <strcmp+0x1e>
 188:	0005c703          	lbu	a4,0(a1)
 18c:	00f71763          	bne	a4,a5,19a <strcmp+0x1e>
    p++, q++;
 190:	0505                	addi	a0,a0,1
 192:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	fbe5                	bnez	a5,188 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19a:	0005c503          	lbu	a0,0(a1)
}
 19e:	40a7853b          	subw	a0,a5,a0
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strlen>:

uint
strlen(const char *s)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cf91                	beqz	a5,1ce <strlen+0x26>
 1b4:	0505                	addi	a0,a0,1
 1b6:	87aa                	mv	a5,a0
 1b8:	86be                	mv	a3,a5
 1ba:	0785                	addi	a5,a5,1
 1bc:	fff7c703          	lbu	a4,-1(a5)
 1c0:	ff65                	bnez	a4,1b8 <strlen+0x10>
 1c2:	40a6853b          	subw	a0,a3,a0
 1c6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  for(n = 0; s[n]; n++)
 1ce:	4501                	li	a0,0
 1d0:	bfe5                	j	1c8 <strlen+0x20>

00000000000001d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d8:	ca19                	beqz	a2,1ee <memset+0x1c>
 1da:	87aa                	mv	a5,a0
 1dc:	1602                	slli	a2,a2,0x20
 1de:	9201                	srli	a2,a2,0x20
 1e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e8:	0785                	addi	a5,a5,1
 1ea:	fee79de3          	bne	a5,a4,1e4 <memset+0x12>
  }
  return dst;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret

00000000000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	cb99                	beqz	a5,214 <strchr+0x20>
    if(*s == c)
 200:	00f58763          	beq	a1,a5,20e <strchr+0x1a>
  for(; *s; s++)
 204:	0505                	addi	a0,a0,1
 206:	00054783          	lbu	a5,0(a0)
 20a:	fbfd                	bnez	a5,200 <strchr+0xc>
      return (char*)s;
  return 0;
 20c:	4501                	li	a0,0
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  return 0;
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <strchr+0x1a>

0000000000000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	711d                	addi	sp,sp,-96
 21a:	ec86                	sd	ra,88(sp)
 21c:	e8a2                	sd	s0,80(sp)
 21e:	e4a6                	sd	s1,72(sp)
 220:	e0ca                	sd	s2,64(sp)
 222:	fc4e                	sd	s3,56(sp)
 224:	f852                	sd	s4,48(sp)
 226:	f456                	sd	s5,40(sp)
 228:	f05a                	sd	s6,32(sp)
 22a:	ec5e                	sd	s7,24(sp)
 22c:	1080                	addi	s0,sp,96
 22e:	8baa                	mv	s7,a0
 230:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 232:	892a                	mv	s2,a0
 234:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 236:	4aa9                	li	s5,10
 238:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23a:	89a6                	mv	s3,s1
 23c:	2485                	addiw	s1,s1,1
 23e:	0344d663          	bge	s1,s4,26a <gets+0x52>
    cc = read(0, &c, 1);
 242:	4605                	li	a2,1
 244:	faf40593          	addi	a1,s0,-81
 248:	4501                	li	a0,0
 24a:	1b2000ef          	jal	3fc <read>
    if(cc < 1)
 24e:	00a05e63          	blez	a0,26a <gets+0x52>
    buf[i++] = c;
 252:	faf44783          	lbu	a5,-81(s0)
 256:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25a:	01578763          	beq	a5,s5,268 <gets+0x50>
 25e:	0905                	addi	s2,s2,1
 260:	fd679de3          	bne	a5,s6,23a <gets+0x22>
    buf[i++] = c;
 264:	89a6                	mv	s3,s1
 266:	a011                	j	26a <gets+0x52>
 268:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26a:	99de                	add	s3,s3,s7
 26c:	00098023          	sb	zero,0(s3)
  return buf;
}
 270:	855e                	mv	a0,s7
 272:	60e6                	ld	ra,88(sp)
 274:	6446                	ld	s0,80(sp)
 276:	64a6                	ld	s1,72(sp)
 278:	6906                	ld	s2,64(sp)
 27a:	79e2                	ld	s3,56(sp)
 27c:	7a42                	ld	s4,48(sp)
 27e:	7aa2                	ld	s5,40(sp)
 280:	7b02                	ld	s6,32(sp)
 282:	6be2                	ld	s7,24(sp)
 284:	6125                	addi	sp,sp,96
 286:	8082                	ret

0000000000000288 <stat>:

int
stat(const char *n, struct stat *st)
{
 288:	1101                	addi	sp,sp,-32
 28a:	ec06                	sd	ra,24(sp)
 28c:	e822                	sd	s0,16(sp)
 28e:	e04a                	sd	s2,0(sp)
 290:	1000                	addi	s0,sp,32
 292:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 294:	4581                	li	a1,0
 296:	18e000ef          	jal	424 <open>
  if(fd < 0)
 29a:	02054263          	bltz	a0,2be <stat+0x36>
 29e:	e426                	sd	s1,8(sp)
 2a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a2:	85ca                	mv	a1,s2
 2a4:	198000ef          	jal	43c <fstat>
 2a8:	892a                	mv	s2,a0
  close(fd);
 2aa:	8526                	mv	a0,s1
 2ac:	160000ef          	jal	40c <close>
  return r;
 2b0:	64a2                	ld	s1,8(sp)
}
 2b2:	854a                	mv	a0,s2
 2b4:	60e2                	ld	ra,24(sp)
 2b6:	6442                	ld	s0,16(sp)
 2b8:	6902                	ld	s2,0(sp)
 2ba:	6105                	addi	sp,sp,32
 2bc:	8082                	ret
    return -1;
 2be:	597d                	li	s2,-1
 2c0:	bfcd                	j	2b2 <stat+0x2a>

00000000000002c2 <atoi>:

int
atoi(const char *s)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c8:	00054683          	lbu	a3,0(a0)
 2cc:	fd06879b          	addiw	a5,a3,-48
 2d0:	0ff7f793          	zext.b	a5,a5
 2d4:	4625                	li	a2,9
 2d6:	02f66863          	bltu	a2,a5,306 <atoi+0x44>
 2da:	872a                	mv	a4,a0
  n = 0;
 2dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2de:	0705                	addi	a4,a4,1
 2e0:	0025179b          	slliw	a5,a0,0x2
 2e4:	9fa9                	addw	a5,a5,a0
 2e6:	0017979b          	slliw	a5,a5,0x1
 2ea:	9fb5                	addw	a5,a5,a3
 2ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f0:	00074683          	lbu	a3,0(a4)
 2f4:	fd06879b          	addiw	a5,a3,-48
 2f8:	0ff7f793          	zext.b	a5,a5
 2fc:	fef671e3          	bgeu	a2,a5,2de <atoi+0x1c>
  return n;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  n = 0;
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <atoi+0x3e>

000000000000030a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 310:	02b57463          	bgeu	a0,a1,338 <memmove+0x2e>
    while(n-- > 0)
 314:	00c05f63          	blez	a2,332 <memmove+0x28>
 318:	1602                	slli	a2,a2,0x20
 31a:	9201                	srli	a2,a2,0x20
 31c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 320:	872a                	mv	a4,a0
      *dst++ = *src++;
 322:	0585                	addi	a1,a1,1
 324:	0705                	addi	a4,a4,1
 326:	fff5c683          	lbu	a3,-1(a1)
 32a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 32e:	fef71ae3          	bne	a4,a5,322 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
    dst += n;
 338:	00c50733          	add	a4,a0,a2
    src += n;
 33c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 33e:	fec05ae3          	blez	a2,332 <memmove+0x28>
 342:	fff6079b          	addiw	a5,a2,-1
 346:	1782                	slli	a5,a5,0x20
 348:	9381                	srli	a5,a5,0x20
 34a:	fff7c793          	not	a5,a5
 34e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 350:	15fd                	addi	a1,a1,-1
 352:	177d                	addi	a4,a4,-1
 354:	0005c683          	lbu	a3,0(a1)
 358:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 35c:	fee79ae3          	bne	a5,a4,350 <memmove+0x46>
 360:	bfc9                	j	332 <memmove+0x28>

0000000000000362 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 368:	ca05                	beqz	a2,398 <memcmp+0x36>
 36a:	fff6069b          	addiw	a3,a2,-1
 36e:	1682                	slli	a3,a3,0x20
 370:	9281                	srli	a3,a3,0x20
 372:	0685                	addi	a3,a3,1
 374:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 376:	00054783          	lbu	a5,0(a0)
 37a:	0005c703          	lbu	a4,0(a1)
 37e:	00e79863          	bne	a5,a4,38e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 382:	0505                	addi	a0,a0,1
    p2++;
 384:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 386:	fed518e3          	bne	a0,a3,376 <memcmp+0x14>
  }
  return 0;
 38a:	4501                	li	a0,0
 38c:	a019                	j	392 <memcmp+0x30>
      return *p1 - *p2;
 38e:	40e7853b          	subw	a0,a5,a4
}
 392:	6422                	ld	s0,8(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
  return 0;
 398:	4501                	li	a0,0
 39a:	bfe5                	j	392 <memcmp+0x30>

000000000000039c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3a4:	f67ff0ef          	jal	30a <memmove>
}
 3a8:	60a2                	ld	ra,8(sp)
 3aa:	6402                	ld	s0,0(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret

00000000000003b0 <sbrk>:

char *
sbrk(int n) {
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e406                	sd	ra,8(sp)
 3b4:	e022                	sd	s0,0(sp)
 3b6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3b8:	4585                	li	a1,1
 3ba:	0b2000ef          	jal	46c <sys_sbrk>
}
 3be:	60a2                	ld	ra,8(sp)
 3c0:	6402                	ld	s0,0(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret

00000000000003c6 <sbrklazy>:

char *
sbrklazy(int n) {
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e406                	sd	ra,8(sp)
 3ca:	e022                	sd	s0,0(sp)
 3cc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3ce:	4589                	li	a1,2
 3d0:	09c000ef          	jal	46c <sys_sbrk>
}
 3d4:	60a2                	ld	ra,8(sp)
 3d6:	6402                	ld	s0,0(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret

00000000000003dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3dc:	4885                	li	a7,1
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e4:	4889                	li	a7,2
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ec:	488d                	li	a7,3
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f4:	4891                	li	a7,4
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <read>:
.global read
read:
 li a7, SYS_read
 3fc:	4895                	li	a7,5
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <write>:
.global write
write:
 li a7, SYS_write
 404:	48c1                	li	a7,16
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <close>:
.global close
close:
 li a7, SYS_close
 40c:	48d5                	li	a7,21
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <kill>:
.global kill
kill:
 li a7, SYS_kill
 414:	4899                	li	a7,6
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <exec>:
.global exec
exec:
 li a7, SYS_exec
 41c:	489d                	li	a7,7
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <open>:
.global open
open:
 li a7, SYS_open
 424:	48bd                	li	a7,15
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 42c:	48c5                	li	a7,17
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 434:	48c9                	li	a7,18
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 43c:	48a1                	li	a7,8
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <link>:
.global link
link:
 li a7, SYS_link
 444:	48cd                	li	a7,19
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 44c:	48d1                	li	a7,20
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 454:	48a5                	li	a7,9
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <dup>:
.global dup
dup:
 li a7, SYS_dup
 45c:	48a9                	li	a7,10
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 464:	48ad                	li	a7,11
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 46c:	48b1                	li	a7,12
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <pause>:
.global pause
pause:
 li a7, SYS_pause
 474:	48b5                	li	a7,13
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 47c:	48b9                	li	a7,14
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <hello>:
.global hello
hello:
 li a7, SYS_hello
 484:	48d9                	li	a7,22
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <ps>:
.global ps
ps:
 li a7, SYS_ps
 48c:	48dd                	li	a7,23
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 494:	48e1                	li	a7,24
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 49c:	48e5                	li	a7,25
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 4a4:	48e9                	li	a7,26
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 4ac:	48ed                	li	a7,27
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 4b4:	48f1                	li	a7,28
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4bc:	1101                	addi	sp,sp,-32
 4be:	ec06                	sd	ra,24(sp)
 4c0:	e822                	sd	s0,16(sp)
 4c2:	1000                	addi	s0,sp,32
 4c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c8:	4605                	li	a2,1
 4ca:	fef40593          	addi	a1,s0,-17
 4ce:	f37ff0ef          	jal	404 <write>
}
 4d2:	60e2                	ld	ra,24(sp)
 4d4:	6442                	ld	s0,16(sp)
 4d6:	6105                	addi	sp,sp,32
 4d8:	8082                	ret

00000000000004da <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4da:	715d                	addi	sp,sp,-80
 4dc:	e486                	sd	ra,72(sp)
 4de:	e0a2                	sd	s0,64(sp)
 4e0:	f84a                	sd	s2,48(sp)
 4e2:	0880                	addi	s0,sp,80
 4e4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4e6:	c299                	beqz	a3,4ec <printint+0x12>
 4e8:	0805c363          	bltz	a1,56e <printint+0x94>
  neg = 0;
 4ec:	4881                	li	a7,0
 4ee:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4f2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4f4:	00000517          	auipc	a0,0x0
 4f8:	6dc50513          	addi	a0,a0,1756 # bd0 <digits>
 4fc:	883e                	mv	a6,a5
 4fe:	2785                	addiw	a5,a5,1
 500:	02c5f733          	remu	a4,a1,a2
 504:	972a                	add	a4,a4,a0
 506:	00074703          	lbu	a4,0(a4)
 50a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 50e:	872e                	mv	a4,a1
 510:	02c5d5b3          	divu	a1,a1,a2
 514:	0685                	addi	a3,a3,1
 516:	fec773e3          	bgeu	a4,a2,4fc <printint+0x22>
  if(neg)
 51a:	00088b63          	beqz	a7,530 <printint+0x56>
    buf[i++] = '-';
 51e:	fd078793          	addi	a5,a5,-48
 522:	97a2                	add	a5,a5,s0
 524:	02d00713          	li	a4,45
 528:	fee78423          	sb	a4,-24(a5)
 52c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 530:	02f05a63          	blez	a5,564 <printint+0x8a>
 534:	fc26                	sd	s1,56(sp)
 536:	f44e                	sd	s3,40(sp)
 538:	fb840713          	addi	a4,s0,-72
 53c:	00f704b3          	add	s1,a4,a5
 540:	fff70993          	addi	s3,a4,-1
 544:	99be                	add	s3,s3,a5
 546:	37fd                	addiw	a5,a5,-1
 548:	1782                	slli	a5,a5,0x20
 54a:	9381                	srli	a5,a5,0x20
 54c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 550:	fff4c583          	lbu	a1,-1(s1)
 554:	854a                	mv	a0,s2
 556:	f67ff0ef          	jal	4bc <putc>
  while(--i >= 0)
 55a:	14fd                	addi	s1,s1,-1
 55c:	ff349ae3          	bne	s1,s3,550 <printint+0x76>
 560:	74e2                	ld	s1,56(sp)
 562:	79a2                	ld	s3,40(sp)
}
 564:	60a6                	ld	ra,72(sp)
 566:	6406                	ld	s0,64(sp)
 568:	7942                	ld	s2,48(sp)
 56a:	6161                	addi	sp,sp,80
 56c:	8082                	ret
    x = -xx;
 56e:	40b005b3          	neg	a1,a1
    neg = 1;
 572:	4885                	li	a7,1
    x = -xx;
 574:	bfad                	j	4ee <printint+0x14>

0000000000000576 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 576:	711d                	addi	sp,sp,-96
 578:	ec86                	sd	ra,88(sp)
 57a:	e8a2                	sd	s0,80(sp)
 57c:	e0ca                	sd	s2,64(sp)
 57e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 580:	0005c903          	lbu	s2,0(a1)
 584:	28090663          	beqz	s2,810 <vprintf+0x29a>
 588:	e4a6                	sd	s1,72(sp)
 58a:	fc4e                	sd	s3,56(sp)
 58c:	f852                	sd	s4,48(sp)
 58e:	f456                	sd	s5,40(sp)
 590:	f05a                	sd	s6,32(sp)
 592:	ec5e                	sd	s7,24(sp)
 594:	e862                	sd	s8,16(sp)
 596:	e466                	sd	s9,8(sp)
 598:	8b2a                	mv	s6,a0
 59a:	8a2e                	mv	s4,a1
 59c:	8bb2                	mv	s7,a2
  state = 0;
 59e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5a0:	4481                	li	s1,0
 5a2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5a8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ac:	06c00c93          	li	s9,108
 5b0:	a005                	j	5d0 <vprintf+0x5a>
        putc(fd, c0);
 5b2:	85ca                	mv	a1,s2
 5b4:	855a                	mv	a0,s6
 5b6:	f07ff0ef          	jal	4bc <putc>
 5ba:	a019                	j	5c0 <vprintf+0x4a>
    } else if(state == '%'){
 5bc:	03598263          	beq	s3,s5,5e0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5c0:	2485                	addiw	s1,s1,1
 5c2:	8726                	mv	a4,s1
 5c4:	009a07b3          	add	a5,s4,s1
 5c8:	0007c903          	lbu	s2,0(a5)
 5cc:	22090a63          	beqz	s2,800 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5d0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d4:	fe0994e3          	bnez	s3,5bc <vprintf+0x46>
      if(c0 == '%'){
 5d8:	fd579de3          	bne	a5,s5,5b2 <vprintf+0x3c>
        state = '%';
 5dc:	89be                	mv	s3,a5
 5de:	b7cd                	j	5c0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e0:	00ea06b3          	add	a3,s4,a4
 5e4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5e8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ea:	c681                	beqz	a3,5f2 <vprintf+0x7c>
 5ec:	9752                	add	a4,a4,s4
 5ee:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f2:	05878363          	beq	a5,s8,638 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5f6:	05978d63          	beq	a5,s9,650 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5fa:	07500713          	li	a4,117
 5fe:	0ee78763          	beq	a5,a4,6ec <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 602:	07800713          	li	a4,120
 606:	12e78963          	beq	a5,a4,738 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 60a:	07000713          	li	a4,112
 60e:	14e78e63          	beq	a5,a4,76a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 612:	06300713          	li	a4,99
 616:	18e78e63          	beq	a5,a4,7b2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 61a:	07300713          	li	a4,115
 61e:	1ae78463          	beq	a5,a4,7c6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 622:	02500713          	li	a4,37
 626:	04e79563          	bne	a5,a4,670 <vprintf+0xfa>
        putc(fd, '%');
 62a:	02500593          	li	a1,37
 62e:	855a                	mv	a0,s6
 630:	e8dff0ef          	jal	4bc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 634:	4981                	li	s3,0
 636:	b769                	j	5c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 638:	008b8913          	addi	s2,s7,8
 63c:	4685                	li	a3,1
 63e:	4629                	li	a2,10
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	e95ff0ef          	jal	4da <printint>
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bf8d                	j	5c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 650:	06400793          	li	a5,100
 654:	02f68963          	beq	a3,a5,686 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 658:	06c00793          	li	a5,108
 65c:	04f68263          	beq	a3,a5,6a0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 660:	07500793          	li	a5,117
 664:	0af68063          	beq	a3,a5,704 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 668:	07800793          	li	a5,120
 66c:	0ef68263          	beq	a3,a5,750 <vprintf+0x1da>
        putc(fd, '%');
 670:	02500593          	li	a1,37
 674:	855a                	mv	a0,s6
 676:	e47ff0ef          	jal	4bc <putc>
        putc(fd, c0);
 67a:	85ca                	mv	a1,s2
 67c:	855a                	mv	a0,s6
 67e:	e3fff0ef          	jal	4bc <putc>
      state = 0;
 682:	4981                	li	s3,0
 684:	bf35                	j	5c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 686:	008b8913          	addi	s2,s7,8
 68a:	4685                	li	a3,1
 68c:	4629                	li	a2,10
 68e:	000bb583          	ld	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	e47ff0ef          	jal	4da <printint>
        i += 1;
 698:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
        i += 1;
 69e:	b70d                	j	5c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a0:	06400793          	li	a5,100
 6a4:	02f60763          	beq	a2,a5,6d2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6a8:	07500793          	li	a5,117
 6ac:	06f60963          	beq	a2,a5,71e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b0:	07800793          	li	a5,120
 6b4:	faf61ee3          	bne	a2,a5,670 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4681                	li	a3,0
 6be:	4641                	li	a2,16
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e15ff0ef          	jal	4da <printint>
        i += 2;
 6ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 2;
 6d0:	bdc5                	j	5c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	4685                	li	a3,1
 6d8:	4629                	li	a2,10
 6da:	000bb583          	ld	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	dfbff0ef          	jal	4da <printint>
        i += 2;
 6e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
        i += 2;
 6ea:	bdd9                	j	5c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4629                	li	a2,10
 6f4:	000be583          	lwu	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	de1ff0ef          	jal	4da <printint>
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	bd7d                	j	5c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 704:	008b8913          	addi	s2,s7,8
 708:	4681                	li	a3,0
 70a:	4629                	li	a2,10
 70c:	000bb583          	ld	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	dc9ff0ef          	jal	4da <printint>
        i += 1;
 716:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 1;
 71c:	b555                	j	5c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71e:	008b8913          	addi	s2,s7,8
 722:	4681                	li	a3,0
 724:	4629                	li	a2,10
 726:	000bb583          	ld	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	dafff0ef          	jal	4da <printint>
        i += 2;
 730:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 732:	8bca                	mv	s7,s2
      state = 0;
 734:	4981                	li	s3,0
        i += 2;
 736:	b569                	j	5c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 738:	008b8913          	addi	s2,s7,8
 73c:	4681                	li	a3,0
 73e:	4641                	li	a2,16
 740:	000be583          	lwu	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	d95ff0ef          	jal	4da <printint>
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bd8d                	j	5c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4641                	li	a2,16
 758:	000bb583          	ld	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	d7dff0ef          	jal	4da <printint>
        i += 1;
 762:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
        i += 1;
 768:	bda1                	j	5c0 <vprintf+0x4a>
 76a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 76c:	008b8d13          	addi	s10,s7,8
 770:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 774:	03000593          	li	a1,48
 778:	855a                	mv	a0,s6
 77a:	d43ff0ef          	jal	4bc <putc>
  putc(fd, 'x');
 77e:	07800593          	li	a1,120
 782:	855a                	mv	a0,s6
 784:	d39ff0ef          	jal	4bc <putc>
 788:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78a:	00000b97          	auipc	s7,0x0
 78e:	446b8b93          	addi	s7,s7,1094 # bd0 <digits>
 792:	03c9d793          	srli	a5,s3,0x3c
 796:	97de                	add	a5,a5,s7
 798:	0007c583          	lbu	a1,0(a5)
 79c:	855a                	mv	a0,s6
 79e:	d1fff0ef          	jal	4bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a2:	0992                	slli	s3,s3,0x4
 7a4:	397d                	addiw	s2,s2,-1
 7a6:	fe0916e3          	bnez	s2,792 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7aa:	8bea                	mv	s7,s10
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	6d02                	ld	s10,0(sp)
 7b0:	bd01                	j	5c0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7b2:	008b8913          	addi	s2,s7,8
 7b6:	000bc583          	lbu	a1,0(s7)
 7ba:	855a                	mv	a0,s6
 7bc:	d01ff0ef          	jal	4bc <putc>
 7c0:	8bca                	mv	s7,s2
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bbf5                	j	5c0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7c6:	008b8993          	addi	s3,s7,8
 7ca:	000bb903          	ld	s2,0(s7)
 7ce:	00090f63          	beqz	s2,7ec <vprintf+0x276>
        for(; *s; s++)
 7d2:	00094583          	lbu	a1,0(s2)
 7d6:	c195                	beqz	a1,7fa <vprintf+0x284>
          putc(fd, *s);
 7d8:	855a                	mv	a0,s6
 7da:	ce3ff0ef          	jal	4bc <putc>
        for(; *s; s++)
 7de:	0905                	addi	s2,s2,1
 7e0:	00094583          	lbu	a1,0(s2)
 7e4:	f9f5                	bnez	a1,7d8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7e6:	8bce                	mv	s7,s3
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bbd9                	j	5c0 <vprintf+0x4a>
          s = "(null)";
 7ec:	00000917          	auipc	s2,0x0
 7f0:	3dc90913          	addi	s2,s2,988 # bc8 <malloc+0x2d0>
        for(; *s; s++)
 7f4:	02800593          	li	a1,40
 7f8:	b7c5                	j	7d8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7fa:	8bce                	mv	s7,s3
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	b3c9                	j	5c0 <vprintf+0x4a>
 800:	64a6                	ld	s1,72(sp)
 802:	79e2                	ld	s3,56(sp)
 804:	7a42                	ld	s4,48(sp)
 806:	7aa2                	ld	s5,40(sp)
 808:	7b02                	ld	s6,32(sp)
 80a:	6be2                	ld	s7,24(sp)
 80c:	6c42                	ld	s8,16(sp)
 80e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 810:	60e6                	ld	ra,88(sp)
 812:	6446                	ld	s0,80(sp)
 814:	6906                	ld	s2,64(sp)
 816:	6125                	addi	sp,sp,96
 818:	8082                	ret

000000000000081a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81a:	715d                	addi	sp,sp,-80
 81c:	ec06                	sd	ra,24(sp)
 81e:	e822                	sd	s0,16(sp)
 820:	1000                	addi	s0,sp,32
 822:	e010                	sd	a2,0(s0)
 824:	e414                	sd	a3,8(s0)
 826:	e818                	sd	a4,16(s0)
 828:	ec1c                	sd	a5,24(s0)
 82a:	03043023          	sd	a6,32(s0)
 82e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 832:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 836:	8622                	mv	a2,s0
 838:	d3fff0ef          	jal	576 <vprintf>
}
 83c:	60e2                	ld	ra,24(sp)
 83e:	6442                	ld	s0,16(sp)
 840:	6161                	addi	sp,sp,80
 842:	8082                	ret

0000000000000844 <printf>:

void
printf(const char *fmt, ...)
{
 844:	711d                	addi	sp,sp,-96
 846:	ec06                	sd	ra,24(sp)
 848:	e822                	sd	s0,16(sp)
 84a:	1000                	addi	s0,sp,32
 84c:	e40c                	sd	a1,8(s0)
 84e:	e810                	sd	a2,16(s0)
 850:	ec14                	sd	a3,24(s0)
 852:	f018                	sd	a4,32(s0)
 854:	f41c                	sd	a5,40(s0)
 856:	03043823          	sd	a6,48(s0)
 85a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 85e:	00840613          	addi	a2,s0,8
 862:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 866:	85aa                	mv	a1,a0
 868:	4505                	li	a0,1
 86a:	d0dff0ef          	jal	576 <vprintf>
}
 86e:	60e2                	ld	ra,24(sp)
 870:	6442                	ld	s0,16(sp)
 872:	6125                	addi	sp,sp,96
 874:	8082                	ret

0000000000000876 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 876:	1141                	addi	sp,sp,-16
 878:	e422                	sd	s0,8(sp)
 87a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 880:	00000797          	auipc	a5,0x0
 884:	7807b783          	ld	a5,1920(a5) # 1000 <freep>
 888:	a02d                	j	8b2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 88a:	4618                	lw	a4,8(a2)
 88c:	9f2d                	addw	a4,a4,a1
 88e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	6310                	ld	a2,0(a4)
 896:	a83d                	j	8d4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 898:	ff852703          	lw	a4,-8(a0)
 89c:	9f31                	addw	a4,a4,a2
 89e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a0:	ff053683          	ld	a3,-16(a0)
 8a4:	a091                	j	8e8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e7e463          	bltu	a5,a4,8b0 <free+0x3a>
 8ac:	00e6ea63          	bltu	a3,a4,8c0 <free+0x4a>
{
 8b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	fed7fae3          	bgeu	a5,a3,8a6 <free+0x30>
 8b6:	6398                	ld	a4,0(a5)
 8b8:	00e6e463          	bltu	a3,a4,8c0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	fee7eae3          	bltu	a5,a4,8b0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8c0:	ff852583          	lw	a1,-8(a0)
 8c4:	6390                	ld	a2,0(a5)
 8c6:	02059813          	slli	a6,a1,0x20
 8ca:	01c85713          	srli	a4,a6,0x1c
 8ce:	9736                	add	a4,a4,a3
 8d0:	fae60de3          	beq	a2,a4,88a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d8:	4790                	lw	a2,8(a5)
 8da:	02061593          	slli	a1,a2,0x20
 8de:	01c5d713          	srli	a4,a1,0x1c
 8e2:	973e                	add	a4,a4,a5
 8e4:	fae68ae3          	beq	a3,a4,898 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8e8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ea:	00000717          	auipc	a4,0x0
 8ee:	70f73b23          	sd	a5,1814(a4) # 1000 <freep>
}
 8f2:	6422                	ld	s0,8(sp)
 8f4:	0141                	addi	sp,sp,16
 8f6:	8082                	ret

00000000000008f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f8:	7139                	addi	sp,sp,-64
 8fa:	fc06                	sd	ra,56(sp)
 8fc:	f822                	sd	s0,48(sp)
 8fe:	f426                	sd	s1,40(sp)
 900:	ec4e                	sd	s3,24(sp)
 902:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 904:	02051493          	slli	s1,a0,0x20
 908:	9081                	srli	s1,s1,0x20
 90a:	04bd                	addi	s1,s1,15
 90c:	8091                	srli	s1,s1,0x4
 90e:	0014899b          	addiw	s3,s1,1
 912:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 914:	00000517          	auipc	a0,0x0
 918:	6ec53503          	ld	a0,1772(a0) # 1000 <freep>
 91c:	c915                	beqz	a0,950 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 920:	4798                	lw	a4,8(a5)
 922:	08977a63          	bgeu	a4,s1,9b6 <malloc+0xbe>
 926:	f04a                	sd	s2,32(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 92e:	8a4e                	mv	s4,s3
 930:	0009871b          	sext.w	a4,s3
 934:	6685                	lui	a3,0x1
 936:	00d77363          	bgeu	a4,a3,93c <malloc+0x44>
 93a:	6a05                	lui	s4,0x1
 93c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 940:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 944:	00000917          	auipc	s2,0x0
 948:	6bc90913          	addi	s2,s2,1724 # 1000 <freep>
  if(p == SBRK_ERROR)
 94c:	5afd                	li	s5,-1
 94e:	a081                	j	98e <malloc+0x96>
 950:	f04a                	sd	s2,32(sp)
 952:	e852                	sd	s4,16(sp)
 954:	e456                	sd	s5,8(sp)
 956:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 958:	00000797          	auipc	a5,0x0
 95c:	6b878793          	addi	a5,a5,1720 # 1010 <base>
 960:	00000717          	auipc	a4,0x0
 964:	6af73023          	sd	a5,1696(a4) # 1000 <freep>
 968:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 96e:	b7c1                	j	92e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	e118                	sd	a4,0(a0)
 974:	a8a9                	j	9ce <malloc+0xd6>
  hp->s.size = nu;
 976:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97a:	0541                	addi	a0,a0,16
 97c:	efbff0ef          	jal	876 <free>
  return freep;
 980:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 984:	c12d                	beqz	a0,9e6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 986:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 988:	4798                	lw	a4,8(a5)
 98a:	02977263          	bgeu	a4,s1,9ae <malloc+0xb6>
    if(p == freep)
 98e:	00093703          	ld	a4,0(s2)
 992:	853e                	mv	a0,a5
 994:	fef719e3          	bne	a4,a5,986 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 998:	8552                	mv	a0,s4
 99a:	a17ff0ef          	jal	3b0 <sbrk>
  if(p == SBRK_ERROR)
 99e:	fd551ce3          	bne	a0,s5,976 <malloc+0x7e>
        return 0;
 9a2:	4501                	li	a0,0
 9a4:	7902                	ld	s2,32(sp)
 9a6:	6a42                	ld	s4,16(sp)
 9a8:	6aa2                	ld	s5,8(sp)
 9aa:	6b02                	ld	s6,0(sp)
 9ac:	a03d                	j	9da <malloc+0xe2>
 9ae:	7902                	ld	s2,32(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b6:	fae48de3          	beq	s1,a4,970 <malloc+0x78>
        p->s.size -= nunits;
 9ba:	4137073b          	subw	a4,a4,s3
 9be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c0:	02071693          	slli	a3,a4,0x20
 9c4:	01c6d713          	srli	a4,a3,0x1c
 9c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ce:	00000717          	auipc	a4,0x0
 9d2:	62a73923          	sd	a0,1586(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d6:	01078513          	addi	a0,a5,16
  }
}
 9da:	70e2                	ld	ra,56(sp)
 9dc:	7442                	ld	s0,48(sp)
 9de:	74a2                	ld	s1,40(sp)
 9e0:	69e2                	ld	s3,24(sp)
 9e2:	6121                	addi	sp,sp,64
 9e4:	8082                	ret
 9e6:	7902                	ld	s2,32(sp)
 9e8:	6a42                	ld	s4,16(sp)
 9ea:	6aa2                	ld	s5,8(sp)
 9ec:	6b02                	ld	s6,0(sp)
 9ee:	b7f5                	j	9da <malloc+0xe2>
