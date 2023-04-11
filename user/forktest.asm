
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	33c080e7          	jalr	828(ra) # 348 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	570080e7          	jalr	1392(ra) # 58c <write>
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void
forktest(void)
{
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  3a:	00001517          	auipc	a0,0x1
  3e:	a6650513          	addi	a0,a0,-1434 # aa0 <malloc+0xea>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>

  for(n=0; n<N; n++){
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	514080e7          	jalr	1300(ra) # 564 <fork>
    if(pid < 0)
  58:	02054763          	bltz	a0,86 <forktest+0x58>
      break;
    if(pid == 0)
  5c:	c10d                	beqz	a0,7e <forktest+0x50>
  for(n=0; n<N; n++){
  5e:	2485                	addiw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  64:	00001517          	auipc	a0,0x1
  68:	a4c50513          	addi	a0,a0,-1460 # ab0 <malloc+0xfa>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
    exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	4f6080e7          	jalr	1270(ra) # 56c <exit>
      exit(0);
  7e:	00000097          	auipc	ra,0x0
  82:	4ee080e7          	jalr	1262(ra) # 56c <exit>
  if(n == N){
  86:	3e800793          	li	a5,1000
  8a:	fcf48de3          	beq	s1,a5,64 <forktest+0x36>
  }

  for(; n > 0; n--){
  8e:	00905b63          	blez	s1,a4 <forktest+0x76>
    if(wait(0) < 0){
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	4e0080e7          	jalr	1248(ra) # 574 <wait>
  9c:	02054a63          	bltz	a0,d0 <forktest+0xa2>
  for(; n > 0; n--){
  a0:	34fd                	addiw	s1,s1,-1
  a2:	f8e5                	bnez	s1,92 <forktest+0x64>
      print("wait stopped early\n");
      exit(1);
    }
  }

  if(wait(0) != -1){
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	4ce080e7          	jalr	1230(ra) # 574 <wait>
  ae:	57fd                	li	a5,-1
  b0:	02f51d63          	bne	a0,a5,ea <forktest+0xbc>
    print("wait got too many\n");
    exit(1);
  }

  print("fork test OK\n");
  b4:	00001517          	auipc	a0,0x1
  b8:	a4c50513          	addi	a0,a0,-1460 # b00 <malloc+0x14a>
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <print>
}
  c4:	60e2                	ld	ra,24(sp)
  c6:	6442                	ld	s0,16(sp)
  c8:	64a2                	ld	s1,8(sp)
  ca:	6902                	ld	s2,0(sp)
  cc:	6105                	addi	sp,sp,32
  ce:	8082                	ret
      print("wait stopped early\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	a0050513          	addi	a0,a0,-1536 # ad0 <malloc+0x11a>
  d8:	00000097          	auipc	ra,0x0
  dc:	f28080e7          	jalr	-216(ra) # 0 <print>
      exit(1);
  e0:	4505                	li	a0,1
  e2:	00000097          	auipc	ra,0x0
  e6:	48a080e7          	jalr	1162(ra) # 56c <exit>
    print("wait got too many\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	9fe50513          	addi	a0,a0,-1538 # ae8 <malloc+0x132>
  f2:	00000097          	auipc	ra,0x0
  f6:	f0e080e7          	jalr	-242(ra) # 0 <print>
    exit(1);
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	470080e7          	jalr	1136(ra) # 56c <exit>

0000000000000104 <main>:

int
main(void)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  forktest();
 10c:	00000097          	auipc	ra,0x0
 110:	f22080e7          	jalr	-222(ra) # 2e <forktest>
  exit(0);
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	456080e7          	jalr	1110(ra) # 56c <exit>

000000000000011e <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
    lk->name = name;
 124:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
 126:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
 12a:	57fd                	li	a5,-1
 12c:	00f50823          	sb	a5,16(a0)
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret

0000000000000136 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
 136:	00054783          	lbu	a5,0(a0)
 13a:	e399                	bnez	a5,140 <holding+0xa>
 13c:	4501                	li	a0,0
}
 13e:	8082                	ret
{
 140:	1101                	addi	sp,sp,-32
 142:	ec06                	sd	ra,24(sp)
 144:	e822                	sd	s0,16(sp)
 146:	e426                	sd	s1,8(sp)
 148:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
 14a:	01054483          	lbu	s1,16(a0)
 14e:	00000097          	auipc	ra,0x0
 152:	122080e7          	jalr	290(ra) # 270 <twhoami>
 156:	2501                	sext.w	a0,a0
 158:	40a48533          	sub	a0,s1,a0
 15c:	00153513          	seqz	a0,a0
}
 160:	60e2                	ld	ra,24(sp)
 162:	6442                	ld	s0,16(sp)
 164:	64a2                	ld	s1,8(sp)
 166:	6105                	addi	sp,sp,32
 168:	8082                	ret

000000000000016a <acquire>:

void acquire(struct lock *lk)
{
 16a:	7179                	addi	sp,sp,-48
 16c:	f406                	sd	ra,40(sp)
 16e:	f022                	sd	s0,32(sp)
 170:	ec26                	sd	s1,24(sp)
 172:	e84a                	sd	s2,16(sp)
 174:	e44e                	sd	s3,8(sp)
 176:	e052                	sd	s4,0(sp)
 178:	1800                	addi	s0,sp,48
 17a:	8a2a                	mv	s4,a0
    if (holding(lk))
 17c:	00000097          	auipc	ra,0x0
 180:	fba080e7          	jalr	-70(ra) # 136 <holding>
 184:	e919                	bnez	a0,19a <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 186:	ffca7493          	andi	s1,s4,-4
 18a:	003a7913          	andi	s2,s4,3
 18e:	0039191b          	slliw	s2,s2,0x3
 192:	4985                	li	s3,1
 194:	012999bb          	sllw	s3,s3,s2
 198:	a015                	j	1bc <acquire+0x52>
        printf("re-acquiring lock we already hold");
 19a:	00001517          	auipc	a0,0x1
 19e:	97650513          	addi	a0,a0,-1674 # b10 <malloc+0x15a>
 1a2:	00000097          	auipc	ra,0x0
 1a6:	75c080e7          	jalr	1884(ra) # 8fe <printf>
        exit(-1);
 1aa:	557d                	li	a0,-1
 1ac:	00000097          	auipc	ra,0x0
 1b0:	3c0080e7          	jalr	960(ra) # 56c <exit>
    {
        // give up the cpu for other threads
        tyield();
 1b4:	00000097          	auipc	ra,0x0
 1b8:	0b0080e7          	jalr	176(ra) # 264 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 1bc:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 1c0:	0127d7bb          	srlw	a5,a5,s2
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	f7f5                	bnez	a5,1b4 <acquire+0x4a>
    }

    __sync_synchronize();
 1ca:	0ff0000f          	fence

    lk->tid = twhoami();
 1ce:	00000097          	auipc	ra,0x0
 1d2:	0a2080e7          	jalr	162(ra) # 270 <twhoami>
 1d6:	00aa0823          	sb	a0,16(s4)
}
 1da:	70a2                	ld	ra,40(sp)
 1dc:	7402                	ld	s0,32(sp)
 1de:	64e2                	ld	s1,24(sp)
 1e0:	6942                	ld	s2,16(sp)
 1e2:	69a2                	ld	s3,8(sp)
 1e4:	6a02                	ld	s4,0(sp)
 1e6:	6145                	addi	sp,sp,48
 1e8:	8082                	ret

00000000000001ea <release>:

void release(struct lock *lk)
{
 1ea:	1101                	addi	sp,sp,-32
 1ec:	ec06                	sd	ra,24(sp)
 1ee:	e822                	sd	s0,16(sp)
 1f0:	e426                	sd	s1,8(sp)
 1f2:	1000                	addi	s0,sp,32
 1f4:	84aa                	mv	s1,a0
    if (!holding(lk))
 1f6:	00000097          	auipc	ra,0x0
 1fa:	f40080e7          	jalr	-192(ra) # 136 <holding>
 1fe:	c11d                	beqz	a0,224 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 200:	57fd                	li	a5,-1
 202:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 206:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 20a:	0ff0000f          	fence
 20e:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 212:	00000097          	auipc	ra,0x0
 216:	052080e7          	jalr	82(ra) # 264 <tyield>
}
 21a:	60e2                	ld	ra,24(sp)
 21c:	6442                	ld	s0,16(sp)
 21e:	64a2                	ld	s1,8(sp)
 220:	6105                	addi	sp,sp,32
 222:	8082                	ret
        printf("releasing lock we are not holding");
 224:	00001517          	auipc	a0,0x1
 228:	91450513          	addi	a0,a0,-1772 # b38 <malloc+0x182>
 22c:	00000097          	auipc	ra,0x0
 230:	6d2080e7          	jalr	1746(ra) # 8fe <printf>
        exit(-1);
 234:	557d                	li	a0,-1
 236:	00000097          	auipc	ra,0x0
 23a:	336080e7          	jalr	822(ra) # 56c <exit>

000000000000023e <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret

000000000000024a <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 250:	6422                	ld	s0,8(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret

0000000000000256 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 25c:	4501                	li	a0,0
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <tyield>:

void tyield()
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret

0000000000000270 <twhoami>:

uint8 twhoami()
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 276:	4501                	li	a0,0
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret

000000000000027e <tswtch>:
 27e:	00153023          	sd	ra,0(a0)
 282:	00253423          	sd	sp,8(a0)
 286:	e900                	sd	s0,16(a0)
 288:	ed04                	sd	s1,24(a0)
 28a:	03253023          	sd	s2,32(a0)
 28e:	03353423          	sd	s3,40(a0)
 292:	03453823          	sd	s4,48(a0)
 296:	03553c23          	sd	s5,56(a0)
 29a:	05653023          	sd	s6,64(a0)
 29e:	05753423          	sd	s7,72(a0)
 2a2:	05853823          	sd	s8,80(a0)
 2a6:	05953c23          	sd	s9,88(a0)
 2aa:	07a53023          	sd	s10,96(a0)
 2ae:	07b53423          	sd	s11,104(a0)
 2b2:	0005b083          	ld	ra,0(a1)
 2b6:	0085b103          	ld	sp,8(a1)
 2ba:	6980                	ld	s0,16(a1)
 2bc:	6d84                	ld	s1,24(a1)
 2be:	0205b903          	ld	s2,32(a1)
 2c2:	0285b983          	ld	s3,40(a1)
 2c6:	0305ba03          	ld	s4,48(a1)
 2ca:	0385ba83          	ld	s5,56(a1)
 2ce:	0405bb03          	ld	s6,64(a1)
 2d2:	0485bb83          	ld	s7,72(a1)
 2d6:	0505bc03          	ld	s8,80(a1)
 2da:	0585bc83          	ld	s9,88(a1)
 2de:	0605bd03          	ld	s10,96(a1)
 2e2:	0685bd83          	ld	s11,104(a1)
 2e6:	8082                	ret

00000000000002e8 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 2f0:	00000097          	auipc	ra,0x0
 2f4:	e14080e7          	jalr	-492(ra) # 104 <main>
    exit(res);
 2f8:	00000097          	auipc	ra,0x0
 2fc:	274080e7          	jalr	628(ra) # 56c <exit>

0000000000000300 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 306:	87aa                	mv	a5,a0
 308:	0585                	addi	a1,a1,1
 30a:	0785                	addi	a5,a5,1
 30c:	fff5c703          	lbu	a4,-1(a1)
 310:	fee78fa3          	sb	a4,-1(a5)
 314:	fb75                	bnez	a4,308 <strcpy+0x8>
        ;
    return os;
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strcmp>:

int strcmp(const char *p, const char *q)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 322:	00054783          	lbu	a5,0(a0)
 326:	cb91                	beqz	a5,33a <strcmp+0x1e>
 328:	0005c703          	lbu	a4,0(a1)
 32c:	00f71763          	bne	a4,a5,33a <strcmp+0x1e>
        p++, q++;
 330:	0505                	addi	a0,a0,1
 332:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 334:	00054783          	lbu	a5,0(a0)
 338:	fbe5                	bnez	a5,328 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 33a:	0005c503          	lbu	a0,0(a1)
}
 33e:	40a7853b          	subw	a0,a5,a0
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <strlen>:

uint strlen(const char *s)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 34e:	00054783          	lbu	a5,0(a0)
 352:	cf91                	beqz	a5,36e <strlen+0x26>
 354:	0505                	addi	a0,a0,1
 356:	87aa                	mv	a5,a0
 358:	4685                	li	a3,1
 35a:	9e89                	subw	a3,a3,a0
 35c:	00f6853b          	addw	a0,a3,a5
 360:	0785                	addi	a5,a5,1
 362:	fff7c703          	lbu	a4,-1(a5)
 366:	fb7d                	bnez	a4,35c <strlen+0x14>
        ;
    return n;
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
    for (n = 0; s[n]; n++)
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <strlen+0x20>

0000000000000372 <memset>:

void *
memset(void *dst, int c, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e422                	sd	s0,8(sp)
 376:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 378:	ca19                	beqz	a2,38e <memset+0x1c>
 37a:	87aa                	mv	a5,a0
 37c:	1602                	slli	a2,a2,0x20
 37e:	9201                	srli	a2,a2,0x20
 380:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 384:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 388:	0785                	addi	a5,a5,1
 38a:	fee79de3          	bne	a5,a4,384 <memset+0x12>
    }
    return dst;
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <strchr>:

char *
strchr(const char *s, char c)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
    for (; *s; s++)
 39a:	00054783          	lbu	a5,0(a0)
 39e:	cb99                	beqz	a5,3b4 <strchr+0x20>
        if (*s == c)
 3a0:	00f58763          	beq	a1,a5,3ae <strchr+0x1a>
    for (; *s; s++)
 3a4:	0505                	addi	a0,a0,1
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	fbfd                	bnez	a5,3a0 <strchr+0xc>
            return (char *)s;
    return 0;
 3ac:	4501                	li	a0,0
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
    return 0;
 3b4:	4501                	li	a0,0
 3b6:	bfe5                	j	3ae <strchr+0x1a>

00000000000003b8 <gets>:

char *
gets(char *buf, int max)
{
 3b8:	711d                	addi	sp,sp,-96
 3ba:	ec86                	sd	ra,88(sp)
 3bc:	e8a2                	sd	s0,80(sp)
 3be:	e4a6                	sd	s1,72(sp)
 3c0:	e0ca                	sd	s2,64(sp)
 3c2:	fc4e                	sd	s3,56(sp)
 3c4:	f852                	sd	s4,48(sp)
 3c6:	f456                	sd	s5,40(sp)
 3c8:	f05a                	sd	s6,32(sp)
 3ca:	ec5e                	sd	s7,24(sp)
 3cc:	1080                	addi	s0,sp,96
 3ce:	8baa                	mv	s7,a0
 3d0:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 3d2:	892a                	mv	s2,a0
 3d4:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 3d6:	4aa9                	li	s5,10
 3d8:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 3da:	89a6                	mv	s3,s1
 3dc:	2485                	addiw	s1,s1,1
 3de:	0344d863          	bge	s1,s4,40e <gets+0x56>
        cc = read(0, &c, 1);
 3e2:	4605                	li	a2,1
 3e4:	faf40593          	addi	a1,s0,-81
 3e8:	4501                	li	a0,0
 3ea:	00000097          	auipc	ra,0x0
 3ee:	19a080e7          	jalr	410(ra) # 584 <read>
        if (cc < 1)
 3f2:	00a05e63          	blez	a0,40e <gets+0x56>
        buf[i++] = c;
 3f6:	faf44783          	lbu	a5,-81(s0)
 3fa:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 3fe:	01578763          	beq	a5,s5,40c <gets+0x54>
 402:	0905                	addi	s2,s2,1
 404:	fd679be3          	bne	a5,s6,3da <gets+0x22>
    for (i = 0; i + 1 < max;)
 408:	89a6                	mv	s3,s1
 40a:	a011                	j	40e <gets+0x56>
 40c:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 40e:	99de                	add	s3,s3,s7
 410:	00098023          	sb	zero,0(s3)
    return buf;
}
 414:	855e                	mv	a0,s7
 416:	60e6                	ld	ra,88(sp)
 418:	6446                	ld	s0,80(sp)
 41a:	64a6                	ld	s1,72(sp)
 41c:	6906                	ld	s2,64(sp)
 41e:	79e2                	ld	s3,56(sp)
 420:	7a42                	ld	s4,48(sp)
 422:	7aa2                	ld	s5,40(sp)
 424:	7b02                	ld	s6,32(sp)
 426:	6be2                	ld	s7,24(sp)
 428:	6125                	addi	sp,sp,96
 42a:	8082                	ret

000000000000042c <stat>:

int stat(const char *n, struct stat *st)
{
 42c:	1101                	addi	sp,sp,-32
 42e:	ec06                	sd	ra,24(sp)
 430:	e822                	sd	s0,16(sp)
 432:	e426                	sd	s1,8(sp)
 434:	e04a                	sd	s2,0(sp)
 436:	1000                	addi	s0,sp,32
 438:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 43a:	4581                	li	a1,0
 43c:	00000097          	auipc	ra,0x0
 440:	170080e7          	jalr	368(ra) # 5ac <open>
    if (fd < 0)
 444:	02054563          	bltz	a0,46e <stat+0x42>
 448:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 44a:	85ca                	mv	a1,s2
 44c:	00000097          	auipc	ra,0x0
 450:	178080e7          	jalr	376(ra) # 5c4 <fstat>
 454:	892a                	mv	s2,a0
    close(fd);
 456:	8526                	mv	a0,s1
 458:	00000097          	auipc	ra,0x0
 45c:	13c080e7          	jalr	316(ra) # 594 <close>
    return r;
}
 460:	854a                	mv	a0,s2
 462:	60e2                	ld	ra,24(sp)
 464:	6442                	ld	s0,16(sp)
 466:	64a2                	ld	s1,8(sp)
 468:	6902                	ld	s2,0(sp)
 46a:	6105                	addi	sp,sp,32
 46c:	8082                	ret
        return -1;
 46e:	597d                	li	s2,-1
 470:	bfc5                	j	460 <stat+0x34>

0000000000000472 <atoi>:

int atoi(const char *s)
{
 472:	1141                	addi	sp,sp,-16
 474:	e422                	sd	s0,8(sp)
 476:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 478:	00054683          	lbu	a3,0(a0)
 47c:	fd06879b          	addiw	a5,a3,-48
 480:	0ff7f793          	zext.b	a5,a5
 484:	4625                	li	a2,9
 486:	02f66863          	bltu	a2,a5,4b6 <atoi+0x44>
 48a:	872a                	mv	a4,a0
    n = 0;
 48c:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 48e:	0705                	addi	a4,a4,1
 490:	0025179b          	slliw	a5,a0,0x2
 494:	9fa9                	addw	a5,a5,a0
 496:	0017979b          	slliw	a5,a5,0x1
 49a:	9fb5                	addw	a5,a5,a3
 49c:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 4a0:	00074683          	lbu	a3,0(a4)
 4a4:	fd06879b          	addiw	a5,a3,-48
 4a8:	0ff7f793          	zext.b	a5,a5
 4ac:	fef671e3          	bgeu	a2,a5,48e <atoi+0x1c>
    return n;
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret
    n = 0;
 4b6:	4501                	li	a0,0
 4b8:	bfe5                	j	4b0 <atoi+0x3e>

00000000000004ba <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 4c0:	02b57463          	bgeu	a0,a1,4e8 <memmove+0x2e>
    {
        while (n-- > 0)
 4c4:	00c05f63          	blez	a2,4e2 <memmove+0x28>
 4c8:	1602                	slli	a2,a2,0x20
 4ca:	9201                	srli	a2,a2,0x20
 4cc:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 4d0:	872a                	mv	a4,a0
            *dst++ = *src++;
 4d2:	0585                	addi	a1,a1,1
 4d4:	0705                	addi	a4,a4,1
 4d6:	fff5c683          	lbu	a3,-1(a1)
 4da:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 4de:	fee79ae3          	bne	a5,a4,4d2 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 4e2:	6422                	ld	s0,8(sp)
 4e4:	0141                	addi	sp,sp,16
 4e6:	8082                	ret
        dst += n;
 4e8:	00c50733          	add	a4,a0,a2
        src += n;
 4ec:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 4ee:	fec05ae3          	blez	a2,4e2 <memmove+0x28>
 4f2:	fff6079b          	addiw	a5,a2,-1
 4f6:	1782                	slli	a5,a5,0x20
 4f8:	9381                	srli	a5,a5,0x20
 4fa:	fff7c793          	not	a5,a5
 4fe:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 500:	15fd                	addi	a1,a1,-1
 502:	177d                	addi	a4,a4,-1
 504:	0005c683          	lbu	a3,0(a1)
 508:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 50c:	fee79ae3          	bne	a5,a4,500 <memmove+0x46>
 510:	bfc9                	j	4e2 <memmove+0x28>

0000000000000512 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 512:	1141                	addi	sp,sp,-16
 514:	e422                	sd	s0,8(sp)
 516:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 518:	ca05                	beqz	a2,548 <memcmp+0x36>
 51a:	fff6069b          	addiw	a3,a2,-1
 51e:	1682                	slli	a3,a3,0x20
 520:	9281                	srli	a3,a3,0x20
 522:	0685                	addi	a3,a3,1
 524:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 526:	00054783          	lbu	a5,0(a0)
 52a:	0005c703          	lbu	a4,0(a1)
 52e:	00e79863          	bne	a5,a4,53e <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 532:	0505                	addi	a0,a0,1
        p2++;
 534:	0585                	addi	a1,a1,1
    while (n-- > 0)
 536:	fed518e3          	bne	a0,a3,526 <memcmp+0x14>
    }
    return 0;
 53a:	4501                	li	a0,0
 53c:	a019                	j	542 <memcmp+0x30>
            return *p1 - *p2;
 53e:	40e7853b          	subw	a0,a5,a4
}
 542:	6422                	ld	s0,8(sp)
 544:	0141                	addi	sp,sp,16
 546:	8082                	ret
    return 0;
 548:	4501                	li	a0,0
 54a:	bfe5                	j	542 <memcmp+0x30>

000000000000054c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e406                	sd	ra,8(sp)
 550:	e022                	sd	s0,0(sp)
 552:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 554:	00000097          	auipc	ra,0x0
 558:	f66080e7          	jalr	-154(ra) # 4ba <memmove>
}
 55c:	60a2                	ld	ra,8(sp)
 55e:	6402                	ld	s0,0(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret

0000000000000564 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 564:	4885                	li	a7,1
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exit>:
.global exit
exit:
 li a7, SYS_exit
 56c:	4889                	li	a7,2
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <wait>:
.global wait
wait:
 li a7, SYS_wait
 574:	488d                	li	a7,3
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57c:	4891                	li	a7,4
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <read>:
.global read
read:
 li a7, SYS_read
 584:	4895                	li	a7,5
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <write>:
.global write
write:
 li a7, SYS_write
 58c:	48c1                	li	a7,16
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <close>:
.global close
close:
 li a7, SYS_close
 594:	48d5                	li	a7,21
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <kill>:
.global kill
kill:
 li a7, SYS_kill
 59c:	4899                	li	a7,6
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a4:	489d                	li	a7,7
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <open>:
.global open
open:
 li a7, SYS_open
 5ac:	48bd                	li	a7,15
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b4:	48c5                	li	a7,17
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5bc:	48c9                	li	a7,18
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c4:	48a1                	li	a7,8
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <link>:
.global link
link:
 li a7, SYS_link
 5cc:	48cd                	li	a7,19
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d4:	48d1                	li	a7,20
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5dc:	48a5                	li	a7,9
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e4:	48a9                	li	a7,10
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ec:	48ad                	li	a7,11
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f4:	48b1                	li	a7,12
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fc:	48b5                	li	a7,13
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 604:	48b9                	li	a7,14
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <ps>:
.global ps
ps:
 li a7, SYS_ps
 60c:	48d9                	li	a7,22
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 614:	48dd                	li	a7,23
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 61c:	48e1                	li	a7,24
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 624:	1101                	addi	sp,sp,-32
 626:	ec06                	sd	ra,24(sp)
 628:	e822                	sd	s0,16(sp)
 62a:	1000                	addi	s0,sp,32
 62c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 630:	4605                	li	a2,1
 632:	fef40593          	addi	a1,s0,-17
 636:	00000097          	auipc	ra,0x0
 63a:	f56080e7          	jalr	-170(ra) # 58c <write>
}
 63e:	60e2                	ld	ra,24(sp)
 640:	6442                	ld	s0,16(sp)
 642:	6105                	addi	sp,sp,32
 644:	8082                	ret

0000000000000646 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 646:	7139                	addi	sp,sp,-64
 648:	fc06                	sd	ra,56(sp)
 64a:	f822                	sd	s0,48(sp)
 64c:	f426                	sd	s1,40(sp)
 64e:	f04a                	sd	s2,32(sp)
 650:	ec4e                	sd	s3,24(sp)
 652:	0080                	addi	s0,sp,64
 654:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 656:	c299                	beqz	a3,65c <printint+0x16>
 658:	0805c963          	bltz	a1,6ea <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 65c:	2581                	sext.w	a1,a1
  neg = 0;
 65e:	4881                	li	a7,0
 660:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 664:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 666:	2601                	sext.w	a2,a2
 668:	00000517          	auipc	a0,0x0
 66c:	55850513          	addi	a0,a0,1368 # bc0 <digits>
 670:	883a                	mv	a6,a4
 672:	2705                	addiw	a4,a4,1
 674:	02c5f7bb          	remuw	a5,a1,a2
 678:	1782                	slli	a5,a5,0x20
 67a:	9381                	srli	a5,a5,0x20
 67c:	97aa                	add	a5,a5,a0
 67e:	0007c783          	lbu	a5,0(a5)
 682:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 686:	0005879b          	sext.w	a5,a1
 68a:	02c5d5bb          	divuw	a1,a1,a2
 68e:	0685                	addi	a3,a3,1
 690:	fec7f0e3          	bgeu	a5,a2,670 <printint+0x2a>
  if(neg)
 694:	00088c63          	beqz	a7,6ac <printint+0x66>
    buf[i++] = '-';
 698:	fd070793          	addi	a5,a4,-48
 69c:	00878733          	add	a4,a5,s0
 6a0:	02d00793          	li	a5,45
 6a4:	fef70823          	sb	a5,-16(a4)
 6a8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6ac:	02e05863          	blez	a4,6dc <printint+0x96>
 6b0:	fc040793          	addi	a5,s0,-64
 6b4:	00e78933          	add	s2,a5,a4
 6b8:	fff78993          	addi	s3,a5,-1
 6bc:	99ba                	add	s3,s3,a4
 6be:	377d                	addiw	a4,a4,-1
 6c0:	1702                	slli	a4,a4,0x20
 6c2:	9301                	srli	a4,a4,0x20
 6c4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6c8:	fff94583          	lbu	a1,-1(s2)
 6cc:	8526                	mv	a0,s1
 6ce:	00000097          	auipc	ra,0x0
 6d2:	f56080e7          	jalr	-170(ra) # 624 <putc>
  while(--i >= 0)
 6d6:	197d                	addi	s2,s2,-1
 6d8:	ff3918e3          	bne	s2,s3,6c8 <printint+0x82>
}
 6dc:	70e2                	ld	ra,56(sp)
 6de:	7442                	ld	s0,48(sp)
 6e0:	74a2                	ld	s1,40(sp)
 6e2:	7902                	ld	s2,32(sp)
 6e4:	69e2                	ld	s3,24(sp)
 6e6:	6121                	addi	sp,sp,64
 6e8:	8082                	ret
    x = -xx;
 6ea:	40b005bb          	negw	a1,a1
    neg = 1;
 6ee:	4885                	li	a7,1
    x = -xx;
 6f0:	bf85                	j	660 <printint+0x1a>

00000000000006f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6f2:	7119                	addi	sp,sp,-128
 6f4:	fc86                	sd	ra,120(sp)
 6f6:	f8a2                	sd	s0,112(sp)
 6f8:	f4a6                	sd	s1,104(sp)
 6fa:	f0ca                	sd	s2,96(sp)
 6fc:	ecce                	sd	s3,88(sp)
 6fe:	e8d2                	sd	s4,80(sp)
 700:	e4d6                	sd	s5,72(sp)
 702:	e0da                	sd	s6,64(sp)
 704:	fc5e                	sd	s7,56(sp)
 706:	f862                	sd	s8,48(sp)
 708:	f466                	sd	s9,40(sp)
 70a:	f06a                	sd	s10,32(sp)
 70c:	ec6e                	sd	s11,24(sp)
 70e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 710:	0005c903          	lbu	s2,0(a1)
 714:	18090f63          	beqz	s2,8b2 <vprintf+0x1c0>
 718:	8aaa                	mv	s5,a0
 71a:	8b32                	mv	s6,a2
 71c:	00158493          	addi	s1,a1,1
  state = 0;
 720:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 722:	02500a13          	li	s4,37
 726:	4c55                	li	s8,21
 728:	00000c97          	auipc	s9,0x0
 72c:	440c8c93          	addi	s9,s9,1088 # b68 <malloc+0x1b2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 730:	02800d93          	li	s11,40
  putc(fd, 'x');
 734:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 736:	00000b97          	auipc	s7,0x0
 73a:	48ab8b93          	addi	s7,s7,1162 # bc0 <digits>
 73e:	a839                	j	75c <vprintf+0x6a>
        putc(fd, c);
 740:	85ca                	mv	a1,s2
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	ee0080e7          	jalr	-288(ra) # 624 <putc>
 74c:	a019                	j	752 <vprintf+0x60>
    } else if(state == '%'){
 74e:	01498d63          	beq	s3,s4,768 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 752:	0485                	addi	s1,s1,1
 754:	fff4c903          	lbu	s2,-1(s1)
 758:	14090d63          	beqz	s2,8b2 <vprintf+0x1c0>
    if(state == 0){
 75c:	fe0999e3          	bnez	s3,74e <vprintf+0x5c>
      if(c == '%'){
 760:	ff4910e3          	bne	s2,s4,740 <vprintf+0x4e>
        state = '%';
 764:	89d2                	mv	s3,s4
 766:	b7f5                	j	752 <vprintf+0x60>
      if(c == 'd'){
 768:	11490c63          	beq	s2,s4,880 <vprintf+0x18e>
 76c:	f9d9079b          	addiw	a5,s2,-99
 770:	0ff7f793          	zext.b	a5,a5
 774:	10fc6e63          	bltu	s8,a5,890 <vprintf+0x19e>
 778:	f9d9079b          	addiw	a5,s2,-99
 77c:	0ff7f713          	zext.b	a4,a5
 780:	10ec6863          	bltu	s8,a4,890 <vprintf+0x19e>
 784:	00271793          	slli	a5,a4,0x2
 788:	97e6                	add	a5,a5,s9
 78a:	439c                	lw	a5,0(a5)
 78c:	97e6                	add	a5,a5,s9
 78e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 790:	008b0913          	addi	s2,s6,8
 794:	4685                	li	a3,1
 796:	4629                	li	a2,10
 798:	000b2583          	lw	a1,0(s6)
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	ea8080e7          	jalr	-344(ra) # 646 <printint>
 7a6:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b765                	j	752 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ac:	008b0913          	addi	s2,s6,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000b2583          	lw	a1,0(s6)
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	e8c080e7          	jalr	-372(ra) # 646 <printint>
 7c2:	8b4a                	mv	s6,s2
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b771                	j	752 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7c8:	008b0913          	addi	s2,s6,8
 7cc:	4681                	li	a3,0
 7ce:	866a                	mv	a2,s10
 7d0:	000b2583          	lw	a1,0(s6)
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	e70080e7          	jalr	-400(ra) # 646 <printint>
 7de:	8b4a                	mv	s6,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bf85                	j	752 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7e4:	008b0793          	addi	a5,s6,8
 7e8:	f8f43423          	sd	a5,-120(s0)
 7ec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7f0:	03000593          	li	a1,48
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e2e080e7          	jalr	-466(ra) # 624 <putc>
  putc(fd, 'x');
 7fe:	07800593          	li	a1,120
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e20080e7          	jalr	-480(ra) # 624 <putc>
 80c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80e:	03c9d793          	srli	a5,s3,0x3c
 812:	97de                	add	a5,a5,s7
 814:	0007c583          	lbu	a1,0(a5)
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e0a080e7          	jalr	-502(ra) # 624 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 822:	0992                	slli	s3,s3,0x4
 824:	397d                	addiw	s2,s2,-1
 826:	fe0914e3          	bnez	s2,80e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 82a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 82e:	4981                	li	s3,0
 830:	b70d                	j	752 <vprintf+0x60>
        s = va_arg(ap, char*);
 832:	008b0913          	addi	s2,s6,8
 836:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 83a:	02098163          	beqz	s3,85c <vprintf+0x16a>
        while(*s != 0){
 83e:	0009c583          	lbu	a1,0(s3)
 842:	c5ad                	beqz	a1,8ac <vprintf+0x1ba>
          putc(fd, *s);
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	dde080e7          	jalr	-546(ra) # 624 <putc>
          s++;
 84e:	0985                	addi	s3,s3,1
        while(*s != 0){
 850:	0009c583          	lbu	a1,0(s3)
 854:	f9e5                	bnez	a1,844 <vprintf+0x152>
        s = va_arg(ap, char*);
 856:	8b4a                	mv	s6,s2
      state = 0;
 858:	4981                	li	s3,0
 85a:	bde5                	j	752 <vprintf+0x60>
          s = "(null)";
 85c:	00000997          	auipc	s3,0x0
 860:	30498993          	addi	s3,s3,772 # b60 <malloc+0x1aa>
        while(*s != 0){
 864:	85ee                	mv	a1,s11
 866:	bff9                	j	844 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 868:	008b0913          	addi	s2,s6,8
 86c:	000b4583          	lbu	a1,0(s6)
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	db2080e7          	jalr	-590(ra) # 624 <putc>
 87a:	8b4a                	mv	s6,s2
      state = 0;
 87c:	4981                	li	s3,0
 87e:	bdd1                	j	752 <vprintf+0x60>
        putc(fd, c);
 880:	85d2                	mv	a1,s4
 882:	8556                	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	da0080e7          	jalr	-608(ra) # 624 <putc>
      state = 0;
 88c:	4981                	li	s3,0
 88e:	b5d1                	j	752 <vprintf+0x60>
        putc(fd, '%');
 890:	85d2                	mv	a1,s4
 892:	8556                	mv	a0,s5
 894:	00000097          	auipc	ra,0x0
 898:	d90080e7          	jalr	-624(ra) # 624 <putc>
        putc(fd, c);
 89c:	85ca                	mv	a1,s2
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	d84080e7          	jalr	-636(ra) # 624 <putc>
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	b565                	j	752 <vprintf+0x60>
        s = va_arg(ap, char*);
 8ac:	8b4a                	mv	s6,s2
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	b54d                	j	752 <vprintf+0x60>
    }
  }
}
 8b2:	70e6                	ld	ra,120(sp)
 8b4:	7446                	ld	s0,112(sp)
 8b6:	74a6                	ld	s1,104(sp)
 8b8:	7906                	ld	s2,96(sp)
 8ba:	69e6                	ld	s3,88(sp)
 8bc:	6a46                	ld	s4,80(sp)
 8be:	6aa6                	ld	s5,72(sp)
 8c0:	6b06                	ld	s6,64(sp)
 8c2:	7be2                	ld	s7,56(sp)
 8c4:	7c42                	ld	s8,48(sp)
 8c6:	7ca2                	ld	s9,40(sp)
 8c8:	7d02                	ld	s10,32(sp)
 8ca:	6de2                	ld	s11,24(sp)
 8cc:	6109                	addi	sp,sp,128
 8ce:	8082                	ret

00000000000008d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d0:	715d                	addi	sp,sp,-80
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	1000                	addi	s0,sp,32
 8d8:	e010                	sd	a2,0(s0)
 8da:	e414                	sd	a3,8(s0)
 8dc:	e818                	sd	a4,16(s0)
 8de:	ec1c                	sd	a5,24(s0)
 8e0:	03043023          	sd	a6,32(s0)
 8e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ec:	8622                	mv	a2,s0
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e04080e7          	jalr	-508(ra) # 6f2 <vprintf>
}
 8f6:	60e2                	ld	ra,24(sp)
 8f8:	6442                	ld	s0,16(sp)
 8fa:	6161                	addi	sp,sp,80
 8fc:	8082                	ret

00000000000008fe <printf>:

void
printf(const char *fmt, ...)
{
 8fe:	711d                	addi	sp,sp,-96
 900:	ec06                	sd	ra,24(sp)
 902:	e822                	sd	s0,16(sp)
 904:	1000                	addi	s0,sp,32
 906:	e40c                	sd	a1,8(s0)
 908:	e810                	sd	a2,16(s0)
 90a:	ec14                	sd	a3,24(s0)
 90c:	f018                	sd	a4,32(s0)
 90e:	f41c                	sd	a5,40(s0)
 910:	03043823          	sd	a6,48(s0)
 914:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 918:	00840613          	addi	a2,s0,8
 91c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 920:	85aa                	mv	a1,a0
 922:	4505                	li	a0,1
 924:	00000097          	auipc	ra,0x0
 928:	dce080e7          	jalr	-562(ra) # 6f2 <vprintf>
}
 92c:	60e2                	ld	ra,24(sp)
 92e:	6442                	ld	s0,16(sp)
 930:	6125                	addi	sp,sp,96
 932:	8082                	ret

0000000000000934 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 934:	1141                	addi	sp,sp,-16
 936:	e422                	sd	s0,8(sp)
 938:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 93a:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93e:	00000797          	auipc	a5,0x0
 942:	29a7b783          	ld	a5,666(a5) # bd8 <freep>
 946:	a02d                	j	970 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 948:	4618                	lw	a4,8(a2)
 94a:	9f2d                	addw	a4,a4,a1
 94c:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 950:	6398                	ld	a4,0(a5)
 952:	6310                	ld	a2,0(a4)
 954:	a83d                	j	992 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 956:	ff852703          	lw	a4,-8(a0)
 95a:	9f31                	addw	a4,a4,a2
 95c:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 95e:	ff053683          	ld	a3,-16(a0)
 962:	a091                	j	9a6 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 964:	6398                	ld	a4,0(a5)
 966:	00e7e463          	bltu	a5,a4,96e <free+0x3a>
 96a:	00e6ea63          	bltu	a3,a4,97e <free+0x4a>
{
 96e:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 970:	fed7fae3          	bgeu	a5,a3,964 <free+0x30>
 974:	6398                	ld	a4,0(a5)
 976:	00e6e463          	bltu	a3,a4,97e <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97a:	fee7eae3          	bltu	a5,a4,96e <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 97e:	ff852583          	lw	a1,-8(a0)
 982:	6390                	ld	a2,0(a5)
 984:	02059813          	slli	a6,a1,0x20
 988:	01c85713          	srli	a4,a6,0x1c
 98c:	9736                	add	a4,a4,a3
 98e:	fae60de3          	beq	a2,a4,948 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 992:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 996:	4790                	lw	a2,8(a5)
 998:	02061593          	slli	a1,a2,0x20
 99c:	01c5d713          	srli	a4,a1,0x1c
 9a0:	973e                	add	a4,a4,a5
 9a2:	fae68ae3          	beq	a3,a4,956 <free+0x22>
        p->s.ptr = bp->s.ptr;
 9a6:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 9a8:	00000717          	auipc	a4,0x0
 9ac:	22f73823          	sd	a5,560(a4) # bd8 <freep>
}
 9b0:	6422                	ld	s0,8(sp)
 9b2:	0141                	addi	sp,sp,16
 9b4:	8082                	ret

00000000000009b6 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 9b6:	7139                	addi	sp,sp,-64
 9b8:	fc06                	sd	ra,56(sp)
 9ba:	f822                	sd	s0,48(sp)
 9bc:	f426                	sd	s1,40(sp)
 9be:	f04a                	sd	s2,32(sp)
 9c0:	ec4e                	sd	s3,24(sp)
 9c2:	e852                	sd	s4,16(sp)
 9c4:	e456                	sd	s5,8(sp)
 9c6:	e05a                	sd	s6,0(sp)
 9c8:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9ca:	02051493          	slli	s1,a0,0x20
 9ce:	9081                	srli	s1,s1,0x20
 9d0:	04bd                	addi	s1,s1,15
 9d2:	8091                	srli	s1,s1,0x4
 9d4:	0014899b          	addiw	s3,s1,1
 9d8:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 9da:	00000517          	auipc	a0,0x0
 9de:	1fe53503          	ld	a0,510(a0) # bd8 <freep>
 9e2:	c515                	beqz	a0,a0e <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9e4:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 9e6:	4798                	lw	a4,8(a5)
 9e8:	02977f63          	bgeu	a4,s1,a26 <malloc+0x70>
 9ec:	8a4e                	mv	s4,s3
 9ee:	0009871b          	sext.w	a4,s3
 9f2:	6685                	lui	a3,0x1
 9f4:	00d77363          	bgeu	a4,a3,9fa <malloc+0x44>
 9f8:	6a05                	lui	s4,0x1
 9fa:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 9fe:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 a02:	00000917          	auipc	s2,0x0
 a06:	1d690913          	addi	s2,s2,470 # bd8 <freep>
    if (p == (char *)-1)
 a0a:	5afd                	li	s5,-1
 a0c:	a895                	j	a80 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 a0e:	00000797          	auipc	a5,0x0
 a12:	1d278793          	addi	a5,a5,466 # be0 <base>
 a16:	00000717          	auipc	a4,0x0
 a1a:	1cf73123          	sd	a5,450(a4) # bd8 <freep>
 a1e:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 a20:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 a24:	b7e1                	j	9ec <malloc+0x36>
            if (p->s.size == nunits)
 a26:	02e48c63          	beq	s1,a4,a5e <malloc+0xa8>
                p->s.size -= nunits;
 a2a:	4137073b          	subw	a4,a4,s3
 a2e:	c798                	sw	a4,8(a5)
                p += p->s.size;
 a30:	02071693          	slli	a3,a4,0x20
 a34:	01c6d713          	srli	a4,a3,0x1c
 a38:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 a3a:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 a3e:	00000717          	auipc	a4,0x0
 a42:	18a73d23          	sd	a0,410(a4) # bd8 <freep>
            return (void *)(p + 1);
 a46:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 a4a:	70e2                	ld	ra,56(sp)
 a4c:	7442                	ld	s0,48(sp)
 a4e:	74a2                	ld	s1,40(sp)
 a50:	7902                	ld	s2,32(sp)
 a52:	69e2                	ld	s3,24(sp)
 a54:	6a42                	ld	s4,16(sp)
 a56:	6aa2                	ld	s5,8(sp)
 a58:	6b02                	ld	s6,0(sp)
 a5a:	6121                	addi	sp,sp,64
 a5c:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 a5e:	6398                	ld	a4,0(a5)
 a60:	e118                	sd	a4,0(a0)
 a62:	bff1                	j	a3e <malloc+0x88>
    hp->s.size = nu;
 a64:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 a68:	0541                	addi	a0,a0,16
 a6a:	00000097          	auipc	ra,0x0
 a6e:	eca080e7          	jalr	-310(ra) # 934 <free>
    return freep;
 a72:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 a76:	d971                	beqz	a0,a4a <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 a78:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 a7a:	4798                	lw	a4,8(a5)
 a7c:	fa9775e3          	bgeu	a4,s1,a26 <malloc+0x70>
        if (p == freep)
 a80:	00093703          	ld	a4,0(s2)
 a84:	853e                	mv	a0,a5
 a86:	fef719e3          	bne	a4,a5,a78 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 a8a:	8552                	mv	a0,s4
 a8c:	00000097          	auipc	ra,0x0
 a90:	b68080e7          	jalr	-1176(ra) # 5f4 <sbrk>
    if (p == (char *)-1)
 a94:	fd5518e3          	bne	a0,s5,a64 <malloc+0xae>
                return 0;
 a98:	4501                	li	a0,0
 a9a:	bf45                	j	a4a <malloc+0x94>
