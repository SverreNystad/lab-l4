
user/_time:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
    if (argc < 2)
   c:	4785                	li	a5,1
   e:	02a7db63          	bge	a5,a0,44 <main+0x44>
  12:	84ae                	mv	s1,a1
        printf("Time took 0 ticks\n");
        printf("Usage: time [exec] [arg1 arg2 ...]\n");
        exit(1);
    }

    int startticks = uptime();
  14:	00000097          	auipc	ra,0x0
  18:	586080e7          	jalr	1414(ra) # 59a <uptime>
  1c:	892a                	mv	s2,a0

    // we now start the program in a separate process:
    int uutPid = fork();
  1e:	00000097          	auipc	ra,0x0
  22:	4dc080e7          	jalr	1244(ra) # 4fa <fork>

    // check if fork worked:
    if (uutPid < 0)
  26:	04054463          	bltz	a0,6e <main+0x6e>
    {
        printf("fork failed... couldn't start %s", argv[1]);
        exit(1);
    }

    if (uutPid == 0)
  2a:	e125                	bnez	a0,8a <main+0x8a>
    {
        // we are the unit under test part of the program - execute the program immediately
        exec(argv[1], argv + 1); // pass rest of the command line to the executable as args
  2c:	00848593          	addi	a1,s1,8
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	508080e7          	jalr	1288(ra) # 53a <exec>
        // wait for the uut to finish
        wait(0);
        int endticks = uptime();
        printf("Executing %s took %d ticks\n", argv[1], endticks - startticks);
    }
    exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	4c6080e7          	jalr	1222(ra) # 502 <exit>
        printf("Time took 0 ticks\n");
  44:	00001517          	auipc	a0,0x1
  48:	9fc50513          	addi	a0,a0,-1540 # a40 <malloc+0xf4>
  4c:	00001097          	auipc	ra,0x1
  50:	848080e7          	jalr	-1976(ra) # 894 <printf>
        printf("Usage: time [exec] [arg1 arg2 ...]\n");
  54:	00001517          	auipc	a0,0x1
  58:	a0450513          	addi	a0,a0,-1532 # a58 <malloc+0x10c>
  5c:	00001097          	auipc	ra,0x1
  60:	838080e7          	jalr	-1992(ra) # 894 <printf>
        exit(1);
  64:	4505                	li	a0,1
  66:	00000097          	auipc	ra,0x0
  6a:	49c080e7          	jalr	1180(ra) # 502 <exit>
        printf("fork failed... couldn't start %s", argv[1]);
  6e:	648c                	ld	a1,8(s1)
  70:	00001517          	auipc	a0,0x1
  74:	a1050513          	addi	a0,a0,-1520 # a80 <malloc+0x134>
  78:	00001097          	auipc	ra,0x1
  7c:	81c080e7          	jalr	-2020(ra) # 894 <printf>
        exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	480080e7          	jalr	1152(ra) # 502 <exit>
        wait(0);
  8a:	4501                	li	a0,0
  8c:	00000097          	auipc	ra,0x0
  90:	47e080e7          	jalr	1150(ra) # 50a <wait>
        int endticks = uptime();
  94:	00000097          	auipc	ra,0x0
  98:	506080e7          	jalr	1286(ra) # 59a <uptime>
        printf("Executing %s took %d ticks\n", argv[1], endticks - startticks);
  9c:	4125063b          	subw	a2,a0,s2
  a0:	648c                	ld	a1,8(s1)
  a2:	00001517          	auipc	a0,0x1
  a6:	a0650513          	addi	a0,a0,-1530 # aa8 <malloc+0x15c>
  aa:	00000097          	auipc	ra,0x0
  ae:	7ea080e7          	jalr	2026(ra) # 894 <printf>
  b2:	b761                	j	3a <main+0x3a>

00000000000000b4 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
    lk->name = name;
  ba:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  bc:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  c0:	57fd                	li	a5,-1
  c2:	00f50823          	sb	a5,16(a0)
}
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  cc:	00054783          	lbu	a5,0(a0)
  d0:	e399                	bnez	a5,d6 <holding+0xa>
  d2:	4501                	li	a0,0
}
  d4:	8082                	ret
{
  d6:	1101                	addi	sp,sp,-32
  d8:	ec06                	sd	ra,24(sp)
  da:	e822                	sd	s0,16(sp)
  dc:	e426                	sd	s1,8(sp)
  de:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  e0:	01054483          	lbu	s1,16(a0)
  e4:	00000097          	auipc	ra,0x0
  e8:	122080e7          	jalr	290(ra) # 206 <twhoami>
  ec:	2501                	sext.w	a0,a0
  ee:	40a48533          	sub	a0,s1,a0
  f2:	00153513          	seqz	a0,a0
}
  f6:	60e2                	ld	ra,24(sp)
  f8:	6442                	ld	s0,16(sp)
  fa:	64a2                	ld	s1,8(sp)
  fc:	6105                	addi	sp,sp,32
  fe:	8082                	ret

0000000000000100 <acquire>:

void acquire(struct lock *lk)
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
 110:	8a2a                	mv	s4,a0
    if (holding(lk))
 112:	00000097          	auipc	ra,0x0
 116:	fba080e7          	jalr	-70(ra) # cc <holding>
 11a:	e919                	bnez	a0,130 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 11c:	ffca7493          	andi	s1,s4,-4
 120:	003a7913          	andi	s2,s4,3
 124:	0039191b          	slliw	s2,s2,0x3
 128:	4985                	li	s3,1
 12a:	012999bb          	sllw	s3,s3,s2
 12e:	a015                	j	152 <acquire+0x52>
        printf("re-acquiring lock we already hold");
 130:	00001517          	auipc	a0,0x1
 134:	99850513          	addi	a0,a0,-1640 # ac8 <malloc+0x17c>
 138:	00000097          	auipc	ra,0x0
 13c:	75c080e7          	jalr	1884(ra) # 894 <printf>
        exit(-1);
 140:	557d                	li	a0,-1
 142:	00000097          	auipc	ra,0x0
 146:	3c0080e7          	jalr	960(ra) # 502 <exit>
    {
        // give up the cpu for other threads
        tyield();
 14a:	00000097          	auipc	ra,0x0
 14e:	0b0080e7          	jalr	176(ra) # 1fa <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 152:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 156:	0127d7bb          	srlw	a5,a5,s2
 15a:	0ff7f793          	zext.b	a5,a5
 15e:	f7f5                	bnez	a5,14a <acquire+0x4a>
    }

    __sync_synchronize();
 160:	0ff0000f          	fence

    lk->tid = twhoami();
 164:	00000097          	auipc	ra,0x0
 168:	0a2080e7          	jalr	162(ra) # 206 <twhoami>
 16c:	00aa0823          	sb	a0,16(s4)
}
 170:	70a2                	ld	ra,40(sp)
 172:	7402                	ld	s0,32(sp)
 174:	64e2                	ld	s1,24(sp)
 176:	6942                	ld	s2,16(sp)
 178:	69a2                	ld	s3,8(sp)
 17a:	6a02                	ld	s4,0(sp)
 17c:	6145                	addi	sp,sp,48
 17e:	8082                	ret

0000000000000180 <release>:

void release(struct lock *lk)
{
 180:	1101                	addi	sp,sp,-32
 182:	ec06                	sd	ra,24(sp)
 184:	e822                	sd	s0,16(sp)
 186:	e426                	sd	s1,8(sp)
 188:	1000                	addi	s0,sp,32
 18a:	84aa                	mv	s1,a0
    if (!holding(lk))
 18c:	00000097          	auipc	ra,0x0
 190:	f40080e7          	jalr	-192(ra) # cc <holding>
 194:	c11d                	beqz	a0,1ba <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 196:	57fd                	li	a5,-1
 198:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 19c:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 1a0:	0ff0000f          	fence
 1a4:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 1a8:	00000097          	auipc	ra,0x0
 1ac:	052080e7          	jalr	82(ra) # 1fa <tyield>
}
 1b0:	60e2                	ld	ra,24(sp)
 1b2:	6442                	ld	s0,16(sp)
 1b4:	64a2                	ld	s1,8(sp)
 1b6:	6105                	addi	sp,sp,32
 1b8:	8082                	ret
        printf("releasing lock we are not holding");
 1ba:	00001517          	auipc	a0,0x1
 1be:	93650513          	addi	a0,a0,-1738 # af0 <malloc+0x1a4>
 1c2:	00000097          	auipc	ra,0x0
 1c6:	6d2080e7          	jalr	1746(ra) # 894 <printf>
        exit(-1);
 1ca:	557d                	li	a0,-1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	336080e7          	jalr	822(ra) # 502 <exit>

00000000000001d4 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret

00000000000001e0 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 1f2:	4501                	li	a0,0
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret

00000000000001fa <tyield>:

void tyield()
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret

0000000000000206 <twhoami>:

uint8 twhoami()
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 20c:	4501                	li	a0,0
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret

0000000000000214 <tswtch>:
 214:	00153023          	sd	ra,0(a0)
 218:	00253423          	sd	sp,8(a0)
 21c:	e900                	sd	s0,16(a0)
 21e:	ed04                	sd	s1,24(a0)
 220:	03253023          	sd	s2,32(a0)
 224:	03353423          	sd	s3,40(a0)
 228:	03453823          	sd	s4,48(a0)
 22c:	03553c23          	sd	s5,56(a0)
 230:	05653023          	sd	s6,64(a0)
 234:	05753423          	sd	s7,72(a0)
 238:	05853823          	sd	s8,80(a0)
 23c:	05953c23          	sd	s9,88(a0)
 240:	07a53023          	sd	s10,96(a0)
 244:	07b53423          	sd	s11,104(a0)
 248:	0005b083          	ld	ra,0(a1)
 24c:	0085b103          	ld	sp,8(a1)
 250:	6980                	ld	s0,16(a1)
 252:	6d84                	ld	s1,24(a1)
 254:	0205b903          	ld	s2,32(a1)
 258:	0285b983          	ld	s3,40(a1)
 25c:	0305ba03          	ld	s4,48(a1)
 260:	0385ba83          	ld	s5,56(a1)
 264:	0405bb03          	ld	s6,64(a1)
 268:	0485bb83          	ld	s7,72(a1)
 26c:	0505bc03          	ld	s8,80(a1)
 270:	0585bc83          	ld	s9,88(a1)
 274:	0605bd03          	ld	s10,96(a1)
 278:	0685bd83          	ld	s11,104(a1)
 27c:	8082                	ret

000000000000027e <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 286:	00000097          	auipc	ra,0x0
 28a:	d7a080e7          	jalr	-646(ra) # 0 <main>
    exit(res);
 28e:	00000097          	auipc	ra,0x0
 292:	274080e7          	jalr	628(ra) # 502 <exit>

0000000000000296 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 29c:	87aa                	mv	a5,a0
 29e:	0585                	addi	a1,a1,1
 2a0:	0785                	addi	a5,a5,1
 2a2:	fff5c703          	lbu	a4,-1(a1)
 2a6:	fee78fa3          	sb	a4,-1(a5)
 2aa:	fb75                	bnez	a4,29e <strcpy+0x8>
        ;
    return os;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strcmp>:

int strcmp(const char *p, const char *q)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cb91                	beqz	a5,2d0 <strcmp+0x1e>
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00f71763          	bne	a4,a5,2d0 <strcmp+0x1e>
        p++, q++;
 2c6:	0505                	addi	a0,a0,1
 2c8:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	fbe5                	bnez	a5,2be <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 2d0:	0005c503          	lbu	a0,0(a1)
}
 2d4:	40a7853b          	subw	a0,a5,a0
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <strlen>:

uint strlen(const char *s)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cf91                	beqz	a5,304 <strlen+0x26>
 2ea:	0505                	addi	a0,a0,1
 2ec:	87aa                	mv	a5,a0
 2ee:	4685                	li	a3,1
 2f0:	9e89                	subw	a3,a3,a0
 2f2:	00f6853b          	addw	a0,a3,a5
 2f6:	0785                	addi	a5,a5,1
 2f8:	fff7c703          	lbu	a4,-1(a5)
 2fc:	fb7d                	bnez	a4,2f2 <strlen+0x14>
        ;
    return n;
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
    for (n = 0; s[n]; n++)
 304:	4501                	li	a0,0
 306:	bfe5                	j	2fe <strlen+0x20>

0000000000000308 <memset>:

void *
memset(void *dst, int c, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 30e:	ca19                	beqz	a2,324 <memset+0x1c>
 310:	87aa                	mv	a5,a0
 312:	1602                	slli	a2,a2,0x20
 314:	9201                	srli	a2,a2,0x20
 316:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 31a:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 31e:	0785                	addi	a5,a5,1
 320:	fee79de3          	bne	a5,a4,31a <memset+0x12>
    }
    return dst;
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <strchr>:

char *
strchr(const char *s, char c)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
    for (; *s; s++)
 330:	00054783          	lbu	a5,0(a0)
 334:	cb99                	beqz	a5,34a <strchr+0x20>
        if (*s == c)
 336:	00f58763          	beq	a1,a5,344 <strchr+0x1a>
    for (; *s; s++)
 33a:	0505                	addi	a0,a0,1
 33c:	00054783          	lbu	a5,0(a0)
 340:	fbfd                	bnez	a5,336 <strchr+0xc>
            return (char *)s;
    return 0;
 342:	4501                	li	a0,0
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
    return 0;
 34a:	4501                	li	a0,0
 34c:	bfe5                	j	344 <strchr+0x1a>

000000000000034e <gets>:

char *
gets(char *buf, int max)
{
 34e:	711d                	addi	sp,sp,-96
 350:	ec86                	sd	ra,88(sp)
 352:	e8a2                	sd	s0,80(sp)
 354:	e4a6                	sd	s1,72(sp)
 356:	e0ca                	sd	s2,64(sp)
 358:	fc4e                	sd	s3,56(sp)
 35a:	f852                	sd	s4,48(sp)
 35c:	f456                	sd	s5,40(sp)
 35e:	f05a                	sd	s6,32(sp)
 360:	ec5e                	sd	s7,24(sp)
 362:	1080                	addi	s0,sp,96
 364:	8baa                	mv	s7,a0
 366:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 368:	892a                	mv	s2,a0
 36a:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 36c:	4aa9                	li	s5,10
 36e:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 370:	89a6                	mv	s3,s1
 372:	2485                	addiw	s1,s1,1
 374:	0344d863          	bge	s1,s4,3a4 <gets+0x56>
        cc = read(0, &c, 1);
 378:	4605                	li	a2,1
 37a:	faf40593          	addi	a1,s0,-81
 37e:	4501                	li	a0,0
 380:	00000097          	auipc	ra,0x0
 384:	19a080e7          	jalr	410(ra) # 51a <read>
        if (cc < 1)
 388:	00a05e63          	blez	a0,3a4 <gets+0x56>
        buf[i++] = c;
 38c:	faf44783          	lbu	a5,-81(s0)
 390:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 394:	01578763          	beq	a5,s5,3a2 <gets+0x54>
 398:	0905                	addi	s2,s2,1
 39a:	fd679be3          	bne	a5,s6,370 <gets+0x22>
    for (i = 0; i + 1 < max;)
 39e:	89a6                	mv	s3,s1
 3a0:	a011                	j	3a4 <gets+0x56>
 3a2:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 3a4:	99de                	add	s3,s3,s7
 3a6:	00098023          	sb	zero,0(s3)
    return buf;
}
 3aa:	855e                	mv	a0,s7
 3ac:	60e6                	ld	ra,88(sp)
 3ae:	6446                	ld	s0,80(sp)
 3b0:	64a6                	ld	s1,72(sp)
 3b2:	6906                	ld	s2,64(sp)
 3b4:	79e2                	ld	s3,56(sp)
 3b6:	7a42                	ld	s4,48(sp)
 3b8:	7aa2                	ld	s5,40(sp)
 3ba:	7b02                	ld	s6,32(sp)
 3bc:	6be2                	ld	s7,24(sp)
 3be:	6125                	addi	sp,sp,96
 3c0:	8082                	ret

00000000000003c2 <stat>:

int stat(const char *n, struct stat *st)
{
 3c2:	1101                	addi	sp,sp,-32
 3c4:	ec06                	sd	ra,24(sp)
 3c6:	e822                	sd	s0,16(sp)
 3c8:	e426                	sd	s1,8(sp)
 3ca:	e04a                	sd	s2,0(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 3d0:	4581                	li	a1,0
 3d2:	00000097          	auipc	ra,0x0
 3d6:	170080e7          	jalr	368(ra) # 542 <open>
    if (fd < 0)
 3da:	02054563          	bltz	a0,404 <stat+0x42>
 3de:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 3e0:	85ca                	mv	a1,s2
 3e2:	00000097          	auipc	ra,0x0
 3e6:	178080e7          	jalr	376(ra) # 55a <fstat>
 3ea:	892a                	mv	s2,a0
    close(fd);
 3ec:	8526                	mv	a0,s1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	13c080e7          	jalr	316(ra) # 52a <close>
    return r;
}
 3f6:	854a                	mv	a0,s2
 3f8:	60e2                	ld	ra,24(sp)
 3fa:	6442                	ld	s0,16(sp)
 3fc:	64a2                	ld	s1,8(sp)
 3fe:	6902                	ld	s2,0(sp)
 400:	6105                	addi	sp,sp,32
 402:	8082                	ret
        return -1;
 404:	597d                	li	s2,-1
 406:	bfc5                	j	3f6 <stat+0x34>

0000000000000408 <atoi>:

int atoi(const char *s)
{
 408:	1141                	addi	sp,sp,-16
 40a:	e422                	sd	s0,8(sp)
 40c:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 40e:	00054683          	lbu	a3,0(a0)
 412:	fd06879b          	addiw	a5,a3,-48
 416:	0ff7f793          	zext.b	a5,a5
 41a:	4625                	li	a2,9
 41c:	02f66863          	bltu	a2,a5,44c <atoi+0x44>
 420:	872a                	mv	a4,a0
    n = 0;
 422:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 424:	0705                	addi	a4,a4,1
 426:	0025179b          	slliw	a5,a0,0x2
 42a:	9fa9                	addw	a5,a5,a0
 42c:	0017979b          	slliw	a5,a5,0x1
 430:	9fb5                	addw	a5,a5,a3
 432:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 436:	00074683          	lbu	a3,0(a4)
 43a:	fd06879b          	addiw	a5,a3,-48
 43e:	0ff7f793          	zext.b	a5,a5
 442:	fef671e3          	bgeu	a2,a5,424 <atoi+0x1c>
    return n;
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
    n = 0;
 44c:	4501                	li	a0,0
 44e:	bfe5                	j	446 <atoi+0x3e>

0000000000000450 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e422                	sd	s0,8(sp)
 454:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 456:	02b57463          	bgeu	a0,a1,47e <memmove+0x2e>
    {
        while (n-- > 0)
 45a:	00c05f63          	blez	a2,478 <memmove+0x28>
 45e:	1602                	slli	a2,a2,0x20
 460:	9201                	srli	a2,a2,0x20
 462:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 466:	872a                	mv	a4,a0
            *dst++ = *src++;
 468:	0585                	addi	a1,a1,1
 46a:	0705                	addi	a4,a4,1
 46c:	fff5c683          	lbu	a3,-1(a1)
 470:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 474:	fee79ae3          	bne	a5,a4,468 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 478:	6422                	ld	s0,8(sp)
 47a:	0141                	addi	sp,sp,16
 47c:	8082                	ret
        dst += n;
 47e:	00c50733          	add	a4,a0,a2
        src += n;
 482:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 484:	fec05ae3          	blez	a2,478 <memmove+0x28>
 488:	fff6079b          	addiw	a5,a2,-1
 48c:	1782                	slli	a5,a5,0x20
 48e:	9381                	srli	a5,a5,0x20
 490:	fff7c793          	not	a5,a5
 494:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 496:	15fd                	addi	a1,a1,-1
 498:	177d                	addi	a4,a4,-1
 49a:	0005c683          	lbu	a3,0(a1)
 49e:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 4a2:	fee79ae3          	bne	a5,a4,496 <memmove+0x46>
 4a6:	bfc9                	j	478 <memmove+0x28>

00000000000004a8 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 4a8:	1141                	addi	sp,sp,-16
 4aa:	e422                	sd	s0,8(sp)
 4ac:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 4ae:	ca05                	beqz	a2,4de <memcmp+0x36>
 4b0:	fff6069b          	addiw	a3,a2,-1
 4b4:	1682                	slli	a3,a3,0x20
 4b6:	9281                	srli	a3,a3,0x20
 4b8:	0685                	addi	a3,a3,1
 4ba:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 4bc:	00054783          	lbu	a5,0(a0)
 4c0:	0005c703          	lbu	a4,0(a1)
 4c4:	00e79863          	bne	a5,a4,4d4 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 4c8:	0505                	addi	a0,a0,1
        p2++;
 4ca:	0585                	addi	a1,a1,1
    while (n-- > 0)
 4cc:	fed518e3          	bne	a0,a3,4bc <memcmp+0x14>
    }
    return 0;
 4d0:	4501                	li	a0,0
 4d2:	a019                	j	4d8 <memcmp+0x30>
            return *p1 - *p2;
 4d4:	40e7853b          	subw	a0,a5,a4
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
    return 0;
 4de:	4501                	li	a0,0
 4e0:	bfe5                	j	4d8 <memcmp+0x30>

00000000000004e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e406                	sd	ra,8(sp)
 4e6:	e022                	sd	s0,0(sp)
 4e8:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 4ea:	00000097          	auipc	ra,0x0
 4ee:	f66080e7          	jalr	-154(ra) # 450 <memmove>
}
 4f2:	60a2                	ld	ra,8(sp)
 4f4:	6402                	ld	s0,0(sp)
 4f6:	0141                	addi	sp,sp,16
 4f8:	8082                	ret

00000000000004fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4fa:	4885                	li	a7,1
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <exit>:
.global exit
exit:
 li a7, SYS_exit
 502:	4889                	li	a7,2
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <wait>:
.global wait
wait:
 li a7, SYS_wait
 50a:	488d                	li	a7,3
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 512:	4891                	li	a7,4
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <read>:
.global read
read:
 li a7, SYS_read
 51a:	4895                	li	a7,5
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <write>:
.global write
write:
 li a7, SYS_write
 522:	48c1                	li	a7,16
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <close>:
.global close
close:
 li a7, SYS_close
 52a:	48d5                	li	a7,21
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <kill>:
.global kill
kill:
 li a7, SYS_kill
 532:	4899                	li	a7,6
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exec>:
.global exec
exec:
 li a7, SYS_exec
 53a:	489d                	li	a7,7
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <open>:
.global open
open:
 li a7, SYS_open
 542:	48bd                	li	a7,15
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 54a:	48c5                	li	a7,17
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 552:	48c9                	li	a7,18
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55a:	48a1                	li	a7,8
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <link>:
.global link
link:
 li a7, SYS_link
 562:	48cd                	li	a7,19
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 56a:	48d1                	li	a7,20
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 572:	48a5                	li	a7,9
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <dup>:
.global dup
dup:
 li a7, SYS_dup
 57a:	48a9                	li	a7,10
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 582:	48ad                	li	a7,11
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 58a:	48b1                	li	a7,12
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 592:	48b5                	li	a7,13
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59a:	48b9                	li	a7,14
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5a2:	48d9                	li	a7,22
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 5aa:	48dd                	li	a7,23
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 5b2:	48e1                	li	a7,24
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ba:	1101                	addi	sp,sp,-32
 5bc:	ec06                	sd	ra,24(sp)
 5be:	e822                	sd	s0,16(sp)
 5c0:	1000                	addi	s0,sp,32
 5c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c6:	4605                	li	a2,1
 5c8:	fef40593          	addi	a1,s0,-17
 5cc:	00000097          	auipc	ra,0x0
 5d0:	f56080e7          	jalr	-170(ra) # 522 <write>
}
 5d4:	60e2                	ld	ra,24(sp)
 5d6:	6442                	ld	s0,16(sp)
 5d8:	6105                	addi	sp,sp,32
 5da:	8082                	ret

00000000000005dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5dc:	7139                	addi	sp,sp,-64
 5de:	fc06                	sd	ra,56(sp)
 5e0:	f822                	sd	s0,48(sp)
 5e2:	f426                	sd	s1,40(sp)
 5e4:	f04a                	sd	s2,32(sp)
 5e6:	ec4e                	sd	s3,24(sp)
 5e8:	0080                	addi	s0,sp,64
 5ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ec:	c299                	beqz	a3,5f2 <printint+0x16>
 5ee:	0805c963          	bltz	a1,680 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f2:	2581                	sext.w	a1,a1
  neg = 0;
 5f4:	4881                	li	a7,0
 5f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5fc:	2601                	sext.w	a2,a2
 5fe:	00000517          	auipc	a0,0x0
 602:	57a50513          	addi	a0,a0,1402 # b78 <digits>
 606:	883a                	mv	a6,a4
 608:	2705                	addiw	a4,a4,1
 60a:	02c5f7bb          	remuw	a5,a1,a2
 60e:	1782                	slli	a5,a5,0x20
 610:	9381                	srli	a5,a5,0x20
 612:	97aa                	add	a5,a5,a0
 614:	0007c783          	lbu	a5,0(a5)
 618:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 61c:	0005879b          	sext.w	a5,a1
 620:	02c5d5bb          	divuw	a1,a1,a2
 624:	0685                	addi	a3,a3,1
 626:	fec7f0e3          	bgeu	a5,a2,606 <printint+0x2a>
  if(neg)
 62a:	00088c63          	beqz	a7,642 <printint+0x66>
    buf[i++] = '-';
 62e:	fd070793          	addi	a5,a4,-48
 632:	00878733          	add	a4,a5,s0
 636:	02d00793          	li	a5,45
 63a:	fef70823          	sb	a5,-16(a4)
 63e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 642:	02e05863          	blez	a4,672 <printint+0x96>
 646:	fc040793          	addi	a5,s0,-64
 64a:	00e78933          	add	s2,a5,a4
 64e:	fff78993          	addi	s3,a5,-1
 652:	99ba                	add	s3,s3,a4
 654:	377d                	addiw	a4,a4,-1
 656:	1702                	slli	a4,a4,0x20
 658:	9301                	srli	a4,a4,0x20
 65a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 65e:	fff94583          	lbu	a1,-1(s2)
 662:	8526                	mv	a0,s1
 664:	00000097          	auipc	ra,0x0
 668:	f56080e7          	jalr	-170(ra) # 5ba <putc>
  while(--i >= 0)
 66c:	197d                	addi	s2,s2,-1
 66e:	ff3918e3          	bne	s2,s3,65e <printint+0x82>
}
 672:	70e2                	ld	ra,56(sp)
 674:	7442                	ld	s0,48(sp)
 676:	74a2                	ld	s1,40(sp)
 678:	7902                	ld	s2,32(sp)
 67a:	69e2                	ld	s3,24(sp)
 67c:	6121                	addi	sp,sp,64
 67e:	8082                	ret
    x = -xx;
 680:	40b005bb          	negw	a1,a1
    neg = 1;
 684:	4885                	li	a7,1
    x = -xx;
 686:	bf85                	j	5f6 <printint+0x1a>

0000000000000688 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 688:	7119                	addi	sp,sp,-128
 68a:	fc86                	sd	ra,120(sp)
 68c:	f8a2                	sd	s0,112(sp)
 68e:	f4a6                	sd	s1,104(sp)
 690:	f0ca                	sd	s2,96(sp)
 692:	ecce                	sd	s3,88(sp)
 694:	e8d2                	sd	s4,80(sp)
 696:	e4d6                	sd	s5,72(sp)
 698:	e0da                	sd	s6,64(sp)
 69a:	fc5e                	sd	s7,56(sp)
 69c:	f862                	sd	s8,48(sp)
 69e:	f466                	sd	s9,40(sp)
 6a0:	f06a                	sd	s10,32(sp)
 6a2:	ec6e                	sd	s11,24(sp)
 6a4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a6:	0005c903          	lbu	s2,0(a1)
 6aa:	18090f63          	beqz	s2,848 <vprintf+0x1c0>
 6ae:	8aaa                	mv	s5,a0
 6b0:	8b32                	mv	s6,a2
 6b2:	00158493          	addi	s1,a1,1
  state = 0;
 6b6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6b8:	02500a13          	li	s4,37
 6bc:	4c55                	li	s8,21
 6be:	00000c97          	auipc	s9,0x0
 6c2:	462c8c93          	addi	s9,s9,1122 # b20 <malloc+0x1d4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c6:	02800d93          	li	s11,40
  putc(fd, 'x');
 6ca:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6cc:	00000b97          	auipc	s7,0x0
 6d0:	4acb8b93          	addi	s7,s7,1196 # b78 <digits>
 6d4:	a839                	j	6f2 <vprintf+0x6a>
        putc(fd, c);
 6d6:	85ca                	mv	a1,s2
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	ee0080e7          	jalr	-288(ra) # 5ba <putc>
 6e2:	a019                	j	6e8 <vprintf+0x60>
    } else if(state == '%'){
 6e4:	01498d63          	beq	s3,s4,6fe <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6e8:	0485                	addi	s1,s1,1
 6ea:	fff4c903          	lbu	s2,-1(s1)
 6ee:	14090d63          	beqz	s2,848 <vprintf+0x1c0>
    if(state == 0){
 6f2:	fe0999e3          	bnez	s3,6e4 <vprintf+0x5c>
      if(c == '%'){
 6f6:	ff4910e3          	bne	s2,s4,6d6 <vprintf+0x4e>
        state = '%';
 6fa:	89d2                	mv	s3,s4
 6fc:	b7f5                	j	6e8 <vprintf+0x60>
      if(c == 'd'){
 6fe:	11490c63          	beq	s2,s4,816 <vprintf+0x18e>
 702:	f9d9079b          	addiw	a5,s2,-99
 706:	0ff7f793          	zext.b	a5,a5
 70a:	10fc6e63          	bltu	s8,a5,826 <vprintf+0x19e>
 70e:	f9d9079b          	addiw	a5,s2,-99
 712:	0ff7f713          	zext.b	a4,a5
 716:	10ec6863          	bltu	s8,a4,826 <vprintf+0x19e>
 71a:	00271793          	slli	a5,a4,0x2
 71e:	97e6                	add	a5,a5,s9
 720:	439c                	lw	a5,0(a5)
 722:	97e6                	add	a5,a5,s9
 724:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 726:	008b0913          	addi	s2,s6,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000b2583          	lw	a1,0(s6)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	ea8080e7          	jalr	-344(ra) # 5dc <printint>
 73c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 73e:	4981                	li	s3,0
 740:	b765                	j	6e8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 742:	008b0913          	addi	s2,s6,8
 746:	4681                	li	a3,0
 748:	4629                	li	a2,10
 74a:	000b2583          	lw	a1,0(s6)
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e8c080e7          	jalr	-372(ra) # 5dc <printint>
 758:	8b4a                	mv	s6,s2
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b771                	j	6e8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 75e:	008b0913          	addi	s2,s6,8
 762:	4681                	li	a3,0
 764:	866a                	mv	a2,s10
 766:	000b2583          	lw	a1,0(s6)
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	e70080e7          	jalr	-400(ra) # 5dc <printint>
 774:	8b4a                	mv	s6,s2
      state = 0;
 776:	4981                	li	s3,0
 778:	bf85                	j	6e8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 77a:	008b0793          	addi	a5,s6,8
 77e:	f8f43423          	sd	a5,-120(s0)
 782:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 786:	03000593          	li	a1,48
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	e2e080e7          	jalr	-466(ra) # 5ba <putc>
  putc(fd, 'x');
 794:	07800593          	li	a1,120
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e20080e7          	jalr	-480(ra) # 5ba <putc>
 7a2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a4:	03c9d793          	srli	a5,s3,0x3c
 7a8:	97de                	add	a5,a5,s7
 7aa:	0007c583          	lbu	a1,0(a5)
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	e0a080e7          	jalr	-502(ra) # 5ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b8:	0992                	slli	s3,s3,0x4
 7ba:	397d                	addiw	s2,s2,-1
 7bc:	fe0914e3          	bnez	s2,7a4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7c0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b70d                	j	6e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 7c8:	008b0913          	addi	s2,s6,8
 7cc:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7d0:	02098163          	beqz	s3,7f2 <vprintf+0x16a>
        while(*s != 0){
 7d4:	0009c583          	lbu	a1,0(s3)
 7d8:	c5ad                	beqz	a1,842 <vprintf+0x1ba>
          putc(fd, *s);
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	dde080e7          	jalr	-546(ra) # 5ba <putc>
          s++;
 7e4:	0985                	addi	s3,s3,1
        while(*s != 0){
 7e6:	0009c583          	lbu	a1,0(s3)
 7ea:	f9e5                	bnez	a1,7da <vprintf+0x152>
        s = va_arg(ap, char*);
 7ec:	8b4a                	mv	s6,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bde5                	j	6e8 <vprintf+0x60>
          s = "(null)";
 7f2:	00000997          	auipc	s3,0x0
 7f6:	32698993          	addi	s3,s3,806 # b18 <malloc+0x1cc>
        while(*s != 0){
 7fa:	85ee                	mv	a1,s11
 7fc:	bff9                	j	7da <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7fe:	008b0913          	addi	s2,s6,8
 802:	000b4583          	lbu	a1,0(s6)
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	db2080e7          	jalr	-590(ra) # 5ba <putc>
 810:	8b4a                	mv	s6,s2
      state = 0;
 812:	4981                	li	s3,0
 814:	bdd1                	j	6e8 <vprintf+0x60>
        putc(fd, c);
 816:	85d2                	mv	a1,s4
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	da0080e7          	jalr	-608(ra) # 5ba <putc>
      state = 0;
 822:	4981                	li	s3,0
 824:	b5d1                	j	6e8 <vprintf+0x60>
        putc(fd, '%');
 826:	85d2                	mv	a1,s4
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	d90080e7          	jalr	-624(ra) # 5ba <putc>
        putc(fd, c);
 832:	85ca                	mv	a1,s2
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	d84080e7          	jalr	-636(ra) # 5ba <putc>
      state = 0;
 83e:	4981                	li	s3,0
 840:	b565                	j	6e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 842:	8b4a                	mv	s6,s2
      state = 0;
 844:	4981                	li	s3,0
 846:	b54d                	j	6e8 <vprintf+0x60>
    }
  }
}
 848:	70e6                	ld	ra,120(sp)
 84a:	7446                	ld	s0,112(sp)
 84c:	74a6                	ld	s1,104(sp)
 84e:	7906                	ld	s2,96(sp)
 850:	69e6                	ld	s3,88(sp)
 852:	6a46                	ld	s4,80(sp)
 854:	6aa6                	ld	s5,72(sp)
 856:	6b06                	ld	s6,64(sp)
 858:	7be2                	ld	s7,56(sp)
 85a:	7c42                	ld	s8,48(sp)
 85c:	7ca2                	ld	s9,40(sp)
 85e:	7d02                	ld	s10,32(sp)
 860:	6de2                	ld	s11,24(sp)
 862:	6109                	addi	sp,sp,128
 864:	8082                	ret

0000000000000866 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 866:	715d                	addi	sp,sp,-80
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e010                	sd	a2,0(s0)
 870:	e414                	sd	a3,8(s0)
 872:	e818                	sd	a4,16(s0)
 874:	ec1c                	sd	a5,24(s0)
 876:	03043023          	sd	a6,32(s0)
 87a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 87e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 882:	8622                	mv	a2,s0
 884:	00000097          	auipc	ra,0x0
 888:	e04080e7          	jalr	-508(ra) # 688 <vprintf>
}
 88c:	60e2                	ld	ra,24(sp)
 88e:	6442                	ld	s0,16(sp)
 890:	6161                	addi	sp,sp,80
 892:	8082                	ret

0000000000000894 <printf>:

void
printf(const char *fmt, ...)
{
 894:	711d                	addi	sp,sp,-96
 896:	ec06                	sd	ra,24(sp)
 898:	e822                	sd	s0,16(sp)
 89a:	1000                	addi	s0,sp,32
 89c:	e40c                	sd	a1,8(s0)
 89e:	e810                	sd	a2,16(s0)
 8a0:	ec14                	sd	a3,24(s0)
 8a2:	f018                	sd	a4,32(s0)
 8a4:	f41c                	sd	a5,40(s0)
 8a6:	03043823          	sd	a6,48(s0)
 8aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ae:	00840613          	addi	a2,s0,8
 8b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b6:	85aa                	mv	a1,a0
 8b8:	4505                	li	a0,1
 8ba:	00000097          	auipc	ra,0x0
 8be:	dce080e7          	jalr	-562(ra) # 688 <vprintf>
}
 8c2:	60e2                	ld	ra,24(sp)
 8c4:	6442                	ld	s0,16(sp)
 8c6:	6125                	addi	sp,sp,96
 8c8:	8082                	ret

00000000000008ca <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 8ca:	1141                	addi	sp,sp,-16
 8cc:	e422                	sd	s0,8(sp)
 8ce:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 8d0:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d4:	00000797          	auipc	a5,0x0
 8d8:	72c7b783          	ld	a5,1836(a5) # 1000 <freep>
 8dc:	a02d                	j	906 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 8de:	4618                	lw	a4,8(a2)
 8e0:	9f2d                	addw	a4,a4,a1
 8e2:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 8e6:	6398                	ld	a4,0(a5)
 8e8:	6310                	ld	a2,0(a4)
 8ea:	a83d                	j	928 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 8ec:	ff852703          	lw	a4,-8(a0)
 8f0:	9f31                	addw	a4,a4,a2
 8f2:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 8f4:	ff053683          	ld	a3,-16(a0)
 8f8:	a091                	j	93c <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	6398                	ld	a4,0(a5)
 8fc:	00e7e463          	bltu	a5,a4,904 <free+0x3a>
 900:	00e6ea63          	bltu	a3,a4,914 <free+0x4a>
{
 904:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 906:	fed7fae3          	bgeu	a5,a3,8fa <free+0x30>
 90a:	6398                	ld	a4,0(a5)
 90c:	00e6e463          	bltu	a3,a4,914 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	fee7eae3          	bltu	a5,a4,904 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 914:	ff852583          	lw	a1,-8(a0)
 918:	6390                	ld	a2,0(a5)
 91a:	02059813          	slli	a6,a1,0x20
 91e:	01c85713          	srli	a4,a6,0x1c
 922:	9736                	add	a4,a4,a3
 924:	fae60de3          	beq	a2,a4,8de <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 928:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 92c:	4790                	lw	a2,8(a5)
 92e:	02061593          	slli	a1,a2,0x20
 932:	01c5d713          	srli	a4,a1,0x1c
 936:	973e                	add	a4,a4,a5
 938:	fae68ae3          	beq	a3,a4,8ec <free+0x22>
        p->s.ptr = bp->s.ptr;
 93c:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 93e:	00000717          	auipc	a4,0x0
 942:	6cf73123          	sd	a5,1730(a4) # 1000 <freep>
}
 946:	6422                	ld	s0,8(sp)
 948:	0141                	addi	sp,sp,16
 94a:	8082                	ret

000000000000094c <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 94c:	7139                	addi	sp,sp,-64
 94e:	fc06                	sd	ra,56(sp)
 950:	f822                	sd	s0,48(sp)
 952:	f426                	sd	s1,40(sp)
 954:	f04a                	sd	s2,32(sp)
 956:	ec4e                	sd	s3,24(sp)
 958:	e852                	sd	s4,16(sp)
 95a:	e456                	sd	s5,8(sp)
 95c:	e05a                	sd	s6,0(sp)
 95e:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 960:	02051493          	slli	s1,a0,0x20
 964:	9081                	srli	s1,s1,0x20
 966:	04bd                	addi	s1,s1,15
 968:	8091                	srli	s1,s1,0x4
 96a:	0014899b          	addiw	s3,s1,1
 96e:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 970:	00000517          	auipc	a0,0x0
 974:	69053503          	ld	a0,1680(a0) # 1000 <freep>
 978:	c515                	beqz	a0,9a4 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 97a:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 97c:	4798                	lw	a4,8(a5)
 97e:	02977f63          	bgeu	a4,s1,9bc <malloc+0x70>
 982:	8a4e                	mv	s4,s3
 984:	0009871b          	sext.w	a4,s3
 988:	6685                	lui	a3,0x1
 98a:	00d77363          	bgeu	a4,a3,990 <malloc+0x44>
 98e:	6a05                	lui	s4,0x1
 990:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 994:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 998:	00000917          	auipc	s2,0x0
 99c:	66890913          	addi	s2,s2,1640 # 1000 <freep>
    if (p == (char *)-1)
 9a0:	5afd                	li	s5,-1
 9a2:	a895                	j	a16 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 9a4:	00000797          	auipc	a5,0x0
 9a8:	66c78793          	addi	a5,a5,1644 # 1010 <base>
 9ac:	00000717          	auipc	a4,0x0
 9b0:	64f73a23          	sd	a5,1620(a4) # 1000 <freep>
 9b4:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 9b6:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 9ba:	b7e1                	j	982 <malloc+0x36>
            if (p->s.size == nunits)
 9bc:	02e48c63          	beq	s1,a4,9f4 <malloc+0xa8>
                p->s.size -= nunits;
 9c0:	4137073b          	subw	a4,a4,s3
 9c4:	c798                	sw	a4,8(a5)
                p += p->s.size;
 9c6:	02071693          	slli	a3,a4,0x20
 9ca:	01c6d713          	srli	a4,a3,0x1c
 9ce:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 9d0:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 9d4:	00000717          	auipc	a4,0x0
 9d8:	62a73623          	sd	a0,1580(a4) # 1000 <freep>
            return (void *)(p + 1);
 9dc:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 9e0:	70e2                	ld	ra,56(sp)
 9e2:	7442                	ld	s0,48(sp)
 9e4:	74a2                	ld	s1,40(sp)
 9e6:	7902                	ld	s2,32(sp)
 9e8:	69e2                	ld	s3,24(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
 9f0:	6121                	addi	sp,sp,64
 9f2:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 9f4:	6398                	ld	a4,0(a5)
 9f6:	e118                	sd	a4,0(a0)
 9f8:	bff1                	j	9d4 <malloc+0x88>
    hp->s.size = nu;
 9fa:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 9fe:	0541                	addi	a0,a0,16
 a00:	00000097          	auipc	ra,0x0
 a04:	eca080e7          	jalr	-310(ra) # 8ca <free>
    return freep;
 a08:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 a0c:	d971                	beqz	a0,9e0 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 a0e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 a10:	4798                	lw	a4,8(a5)
 a12:	fa9775e3          	bgeu	a4,s1,9bc <malloc+0x70>
        if (p == freep)
 a16:	00093703          	ld	a4,0(s2)
 a1a:	853e                	mv	a0,a5
 a1c:	fef719e3          	bne	a4,a5,a0e <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 a20:	8552                	mv	a0,s4
 a22:	00000097          	auipc	ra,0x0
 a26:	b68080e7          	jalr	-1176(ra) # 58a <sbrk>
    if (p == (char *)-1)
 a2a:	fd5518e3          	bne	a0,s5,9fa <malloc+0xae>
                return 0;
 a2e:	4501                	li	a0,0
 a30:	bf45                	j	9e0 <malloc+0x94>
