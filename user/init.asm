
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"

char *argv[] = {"sh", 0};

int main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
    int pid, wpid;

    if (open("console", O_RDWR) < 0)
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	a7250513          	addi	a0,a0,-1422 # a80 <malloc+0xf0>
  16:	00000097          	auipc	ra,0x0
  1a:	570080e7          	jalr	1392(ra) # 586 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    {
        mknod("console", CONSOLE, 0);
        open("console", O_RDWR);
    }
    dup(0); // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	59a080e7          	jalr	1434(ra) # 5be <dup>
    dup(0); // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	590080e7          	jalr	1424(ra) # 5be <dup>

    for (;;)
    {
        printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	a5290913          	addi	s2,s2,-1454 # a88 <malloc+0xf8>
  3e:	854a                	mv	a0,s2
  40:	00001097          	auipc	ra,0x1
  44:	898080e7          	jalr	-1896(ra) # 8d8 <printf>
        pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	4f6080e7          	jalr	1270(ra) # 53e <fork>
  50:	84aa                	mv	s1,a0
        if (pid < 0)
  52:	04054d63          	bltz	a0,ac <main+0xac>
        {
            printf("init: fork failed\n");
            exit(1);
        }
        if (pid == 0)
  56:	c925                	beqz	a0,c6 <main+0xc6>

        for (;;)
        {
            // this call to wait() returns if the shell exits,
            // or if a parentless process exits.
            wpid = wait((int *)0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	4f4080e7          	jalr	1268(ra) # 54e <wait>
            if (wpid == pid)
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
            {
                // the shell exited; restart it.
                break;
            }
            else if (wpid < 0)
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
            {
                printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	a6e50513          	addi	a0,a0,-1426 # ad8 <malloc+0x148>
  72:	00001097          	auipc	ra,0x1
  76:	866080e7          	jalr	-1946(ra) # 8d8 <printf>
                exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	4ca080e7          	jalr	1226(ra) # 546 <exit>
        mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	9f850513          	addi	a0,a0,-1544 # a80 <malloc+0xf0>
  90:	00000097          	auipc	ra,0x0
  94:	4fe080e7          	jalr	1278(ra) # 58e <mknod>
        open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	9e650513          	addi	a0,a0,-1562 # a80 <malloc+0xf0>
  a2:	00000097          	auipc	ra,0x0
  a6:	4e4080e7          	jalr	1252(ra) # 586 <open>
  aa:	bfa5                	j	22 <main+0x22>
            printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	9f450513          	addi	a0,a0,-1548 # aa0 <malloc+0x110>
  b4:	00001097          	auipc	ra,0x1
  b8:	824080e7          	jalr	-2012(ra) # 8d8 <printf>
            exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	488080e7          	jalr	1160(ra) # 546 <exit>
            exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	addi	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	9ea50513          	addi	a0,a0,-1558 # ab8 <malloc+0x128>
  d6:	00000097          	auipc	ra,0x0
  da:	4a8080e7          	jalr	1192(ra) # 57e <exec>
            printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	9e250513          	addi	a0,a0,-1566 # ac0 <malloc+0x130>
  e6:	00000097          	auipc	ra,0x0
  ea:	7f2080e7          	jalr	2034(ra) # 8d8 <printf>
            exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	456080e7          	jalr	1110(ra) # 546 <exit>

00000000000000f8 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
    lk->name = name;
  fe:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
 100:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
 104:	57fd                	li	a5,-1
 106:	00f50823          	sb	a5,16(a0)
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret

0000000000000110 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
 110:	00054783          	lbu	a5,0(a0)
 114:	e399                	bnez	a5,11a <holding+0xa>
 116:	4501                	li	a0,0
}
 118:	8082                	ret
{
 11a:	1101                	addi	sp,sp,-32
 11c:	ec06                	sd	ra,24(sp)
 11e:	e822                	sd	s0,16(sp)
 120:	e426                	sd	s1,8(sp)
 122:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
 124:	01054483          	lbu	s1,16(a0)
 128:	00000097          	auipc	ra,0x0
 12c:	122080e7          	jalr	290(ra) # 24a <twhoami>
 130:	2501                	sext.w	a0,a0
 132:	40a48533          	sub	a0,s1,a0
 136:	00153513          	seqz	a0,a0
}
 13a:	60e2                	ld	ra,24(sp)
 13c:	6442                	ld	s0,16(sp)
 13e:	64a2                	ld	s1,8(sp)
 140:	6105                	addi	sp,sp,32
 142:	8082                	ret

0000000000000144 <acquire>:

void acquire(struct lock *lk)
{
 144:	7179                	addi	sp,sp,-48
 146:	f406                	sd	ra,40(sp)
 148:	f022                	sd	s0,32(sp)
 14a:	ec26                	sd	s1,24(sp)
 14c:	e84a                	sd	s2,16(sp)
 14e:	e44e                	sd	s3,8(sp)
 150:	e052                	sd	s4,0(sp)
 152:	1800                	addi	s0,sp,48
 154:	8a2a                	mv	s4,a0
    if (holding(lk))
 156:	00000097          	auipc	ra,0x0
 15a:	fba080e7          	jalr	-70(ra) # 110 <holding>
 15e:	e919                	bnez	a0,174 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 160:	ffca7493          	andi	s1,s4,-4
 164:	003a7913          	andi	s2,s4,3
 168:	0039191b          	slliw	s2,s2,0x3
 16c:	4985                	li	s3,1
 16e:	012999bb          	sllw	s3,s3,s2
 172:	a015                	j	196 <acquire+0x52>
        printf("re-acquiring lock we already hold");
 174:	00001517          	auipc	a0,0x1
 178:	98450513          	addi	a0,a0,-1660 # af8 <malloc+0x168>
 17c:	00000097          	auipc	ra,0x0
 180:	75c080e7          	jalr	1884(ra) # 8d8 <printf>
        exit(-1);
 184:	557d                	li	a0,-1
 186:	00000097          	auipc	ra,0x0
 18a:	3c0080e7          	jalr	960(ra) # 546 <exit>
    {
        // give up the cpu for other threads
        tyield();
 18e:	00000097          	auipc	ra,0x0
 192:	0b0080e7          	jalr	176(ra) # 23e <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 196:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 19a:	0127d7bb          	srlw	a5,a5,s2
 19e:	0ff7f793          	zext.b	a5,a5
 1a2:	f7f5                	bnez	a5,18e <acquire+0x4a>
    }

    __sync_synchronize();
 1a4:	0ff0000f          	fence

    lk->tid = twhoami();
 1a8:	00000097          	auipc	ra,0x0
 1ac:	0a2080e7          	jalr	162(ra) # 24a <twhoami>
 1b0:	00aa0823          	sb	a0,16(s4)
}
 1b4:	70a2                	ld	ra,40(sp)
 1b6:	7402                	ld	s0,32(sp)
 1b8:	64e2                	ld	s1,24(sp)
 1ba:	6942                	ld	s2,16(sp)
 1bc:	69a2                	ld	s3,8(sp)
 1be:	6a02                	ld	s4,0(sp)
 1c0:	6145                	addi	sp,sp,48
 1c2:	8082                	ret

00000000000001c4 <release>:

void release(struct lock *lk)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e426                	sd	s1,8(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	84aa                	mv	s1,a0
    if (!holding(lk))
 1d0:	00000097          	auipc	ra,0x0
 1d4:	f40080e7          	jalr	-192(ra) # 110 <holding>
 1d8:	c11d                	beqz	a0,1fe <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 1da:	57fd                	li	a5,-1
 1dc:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 1e0:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 1e4:	0ff0000f          	fence
 1e8:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 1ec:	00000097          	auipc	ra,0x0
 1f0:	052080e7          	jalr	82(ra) # 23e <tyield>
}
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	64a2                	ld	s1,8(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
        printf("releasing lock we are not holding");
 1fe:	00001517          	auipc	a0,0x1
 202:	92250513          	addi	a0,a0,-1758 # b20 <malloc+0x190>
 206:	00000097          	auipc	ra,0x0
 20a:	6d2080e7          	jalr	1746(ra) # 8d8 <printf>
        exit(-1);
 20e:	557d                	li	a0,-1
 210:	00000097          	auipc	ra,0x0
 214:	336080e7          	jalr	822(ra) # 546 <exit>

0000000000000218 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret

0000000000000224 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret

0000000000000230 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 236:	4501                	li	a0,0
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <tyield>:

void tyield()
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret

000000000000024a <twhoami>:

uint8 twhoami()
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 250:	4501                	li	a0,0
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret

0000000000000258 <tswtch>:
 258:	00153023          	sd	ra,0(a0)
 25c:	00253423          	sd	sp,8(a0)
 260:	e900                	sd	s0,16(a0)
 262:	ed04                	sd	s1,24(a0)
 264:	03253023          	sd	s2,32(a0)
 268:	03353423          	sd	s3,40(a0)
 26c:	03453823          	sd	s4,48(a0)
 270:	03553c23          	sd	s5,56(a0)
 274:	05653023          	sd	s6,64(a0)
 278:	05753423          	sd	s7,72(a0)
 27c:	05853823          	sd	s8,80(a0)
 280:	05953c23          	sd	s9,88(a0)
 284:	07a53023          	sd	s10,96(a0)
 288:	07b53423          	sd	s11,104(a0)
 28c:	0005b083          	ld	ra,0(a1)
 290:	0085b103          	ld	sp,8(a1)
 294:	6980                	ld	s0,16(a1)
 296:	6d84                	ld	s1,24(a1)
 298:	0205b903          	ld	s2,32(a1)
 29c:	0285b983          	ld	s3,40(a1)
 2a0:	0305ba03          	ld	s4,48(a1)
 2a4:	0385ba83          	ld	s5,56(a1)
 2a8:	0405bb03          	ld	s6,64(a1)
 2ac:	0485bb83          	ld	s7,72(a1)
 2b0:	0505bc03          	ld	s8,80(a1)
 2b4:	0585bc83          	ld	s9,88(a1)
 2b8:	0605bd03          	ld	s10,96(a1)
 2bc:	0685bd83          	ld	s11,104(a1)
 2c0:	8082                	ret

00000000000002c2 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 2ca:	00000097          	auipc	ra,0x0
 2ce:	d36080e7          	jalr	-714(ra) # 0 <main>
    exit(res);
 2d2:	00000097          	auipc	ra,0x0
 2d6:	274080e7          	jalr	628(ra) # 546 <exit>

00000000000002da <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 2e0:	87aa                	mv	a5,a0
 2e2:	0585                	addi	a1,a1,1
 2e4:	0785                	addi	a5,a5,1
 2e6:	fff5c703          	lbu	a4,-1(a1)
 2ea:	fee78fa3          	sb	a4,-1(a5)
 2ee:	fb75                	bnez	a4,2e2 <strcpy+0x8>
        ;
    return os;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <strcmp>:

int strcmp(const char *p, const char *q)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	cb91                	beqz	a5,314 <strcmp+0x1e>
 302:	0005c703          	lbu	a4,0(a1)
 306:	00f71763          	bne	a4,a5,314 <strcmp+0x1e>
        p++, q++;
 30a:	0505                	addi	a0,a0,1
 30c:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 30e:	00054783          	lbu	a5,0(a0)
 312:	fbe5                	bnez	a5,302 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 314:	0005c503          	lbu	a0,0(a1)
}
 318:	40a7853b          	subw	a0,a5,a0
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <strlen>:

uint strlen(const char *s)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 328:	00054783          	lbu	a5,0(a0)
 32c:	cf91                	beqz	a5,348 <strlen+0x26>
 32e:	0505                	addi	a0,a0,1
 330:	87aa                	mv	a5,a0
 332:	4685                	li	a3,1
 334:	9e89                	subw	a3,a3,a0
 336:	00f6853b          	addw	a0,a3,a5
 33a:	0785                	addi	a5,a5,1
 33c:	fff7c703          	lbu	a4,-1(a5)
 340:	fb7d                	bnez	a4,336 <strlen+0x14>
        ;
    return n;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
    for (n = 0; s[n]; n++)
 348:	4501                	li	a0,0
 34a:	bfe5                	j	342 <strlen+0x20>

000000000000034c <memset>:

void *
memset(void *dst, int c, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 352:	ca19                	beqz	a2,368 <memset+0x1c>
 354:	87aa                	mv	a5,a0
 356:	1602                	slli	a2,a2,0x20
 358:	9201                	srli	a2,a2,0x20
 35a:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 35e:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 362:	0785                	addi	a5,a5,1
 364:	fee79de3          	bne	a5,a4,35e <memset+0x12>
    }
    return dst;
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret

000000000000036e <strchr>:

char *
strchr(const char *s, char c)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
    for (; *s; s++)
 374:	00054783          	lbu	a5,0(a0)
 378:	cb99                	beqz	a5,38e <strchr+0x20>
        if (*s == c)
 37a:	00f58763          	beq	a1,a5,388 <strchr+0x1a>
    for (; *s; s++)
 37e:	0505                	addi	a0,a0,1
 380:	00054783          	lbu	a5,0(a0)
 384:	fbfd                	bnez	a5,37a <strchr+0xc>
            return (char *)s;
    return 0;
 386:	4501                	li	a0,0
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
    return 0;
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <strchr+0x1a>

0000000000000392 <gets>:

char *
gets(char *buf, int max)
{
 392:	711d                	addi	sp,sp,-96
 394:	ec86                	sd	ra,88(sp)
 396:	e8a2                	sd	s0,80(sp)
 398:	e4a6                	sd	s1,72(sp)
 39a:	e0ca                	sd	s2,64(sp)
 39c:	fc4e                	sd	s3,56(sp)
 39e:	f852                	sd	s4,48(sp)
 3a0:	f456                	sd	s5,40(sp)
 3a2:	f05a                	sd	s6,32(sp)
 3a4:	ec5e                	sd	s7,24(sp)
 3a6:	1080                	addi	s0,sp,96
 3a8:	8baa                	mv	s7,a0
 3aa:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 3ac:	892a                	mv	s2,a0
 3ae:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 3b0:	4aa9                	li	s5,10
 3b2:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 3b4:	89a6                	mv	s3,s1
 3b6:	2485                	addiw	s1,s1,1
 3b8:	0344d863          	bge	s1,s4,3e8 <gets+0x56>
        cc = read(0, &c, 1);
 3bc:	4605                	li	a2,1
 3be:	faf40593          	addi	a1,s0,-81
 3c2:	4501                	li	a0,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	19a080e7          	jalr	410(ra) # 55e <read>
        if (cc < 1)
 3cc:	00a05e63          	blez	a0,3e8 <gets+0x56>
        buf[i++] = c;
 3d0:	faf44783          	lbu	a5,-81(s0)
 3d4:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 3d8:	01578763          	beq	a5,s5,3e6 <gets+0x54>
 3dc:	0905                	addi	s2,s2,1
 3de:	fd679be3          	bne	a5,s6,3b4 <gets+0x22>
    for (i = 0; i + 1 < max;)
 3e2:	89a6                	mv	s3,s1
 3e4:	a011                	j	3e8 <gets+0x56>
 3e6:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 3e8:	99de                	add	s3,s3,s7
 3ea:	00098023          	sb	zero,0(s3)
    return buf;
}
 3ee:	855e                	mv	a0,s7
 3f0:	60e6                	ld	ra,88(sp)
 3f2:	6446                	ld	s0,80(sp)
 3f4:	64a6                	ld	s1,72(sp)
 3f6:	6906                	ld	s2,64(sp)
 3f8:	79e2                	ld	s3,56(sp)
 3fa:	7a42                	ld	s4,48(sp)
 3fc:	7aa2                	ld	s5,40(sp)
 3fe:	7b02                	ld	s6,32(sp)
 400:	6be2                	ld	s7,24(sp)
 402:	6125                	addi	sp,sp,96
 404:	8082                	ret

0000000000000406 <stat>:

int stat(const char *n, struct stat *st)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	e426                	sd	s1,8(sp)
 40e:	e04a                	sd	s2,0(sp)
 410:	1000                	addi	s0,sp,32
 412:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 414:	4581                	li	a1,0
 416:	00000097          	auipc	ra,0x0
 41a:	170080e7          	jalr	368(ra) # 586 <open>
    if (fd < 0)
 41e:	02054563          	bltz	a0,448 <stat+0x42>
 422:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 424:	85ca                	mv	a1,s2
 426:	00000097          	auipc	ra,0x0
 42a:	178080e7          	jalr	376(ra) # 59e <fstat>
 42e:	892a                	mv	s2,a0
    close(fd);
 430:	8526                	mv	a0,s1
 432:	00000097          	auipc	ra,0x0
 436:	13c080e7          	jalr	316(ra) # 56e <close>
    return r;
}
 43a:	854a                	mv	a0,s2
 43c:	60e2                	ld	ra,24(sp)
 43e:	6442                	ld	s0,16(sp)
 440:	64a2                	ld	s1,8(sp)
 442:	6902                	ld	s2,0(sp)
 444:	6105                	addi	sp,sp,32
 446:	8082                	ret
        return -1;
 448:	597d                	li	s2,-1
 44a:	bfc5                	j	43a <stat+0x34>

000000000000044c <atoi>:

int atoi(const char *s)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e422                	sd	s0,8(sp)
 450:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 452:	00054683          	lbu	a3,0(a0)
 456:	fd06879b          	addiw	a5,a3,-48
 45a:	0ff7f793          	zext.b	a5,a5
 45e:	4625                	li	a2,9
 460:	02f66863          	bltu	a2,a5,490 <atoi+0x44>
 464:	872a                	mv	a4,a0
    n = 0;
 466:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 468:	0705                	addi	a4,a4,1
 46a:	0025179b          	slliw	a5,a0,0x2
 46e:	9fa9                	addw	a5,a5,a0
 470:	0017979b          	slliw	a5,a5,0x1
 474:	9fb5                	addw	a5,a5,a3
 476:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 47a:	00074683          	lbu	a3,0(a4)
 47e:	fd06879b          	addiw	a5,a3,-48
 482:	0ff7f793          	zext.b	a5,a5
 486:	fef671e3          	bgeu	a2,a5,468 <atoi+0x1c>
    return n;
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
    n = 0;
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <atoi+0x3e>

0000000000000494 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 494:	1141                	addi	sp,sp,-16
 496:	e422                	sd	s0,8(sp)
 498:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 49a:	02b57463          	bgeu	a0,a1,4c2 <memmove+0x2e>
    {
        while (n-- > 0)
 49e:	00c05f63          	blez	a2,4bc <memmove+0x28>
 4a2:	1602                	slli	a2,a2,0x20
 4a4:	9201                	srli	a2,a2,0x20
 4a6:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 4aa:	872a                	mv	a4,a0
            *dst++ = *src++;
 4ac:	0585                	addi	a1,a1,1
 4ae:	0705                	addi	a4,a4,1
 4b0:	fff5c683          	lbu	a3,-1(a1)
 4b4:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 4b8:	fee79ae3          	bne	a5,a4,4ac <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 4bc:	6422                	ld	s0,8(sp)
 4be:	0141                	addi	sp,sp,16
 4c0:	8082                	ret
        dst += n;
 4c2:	00c50733          	add	a4,a0,a2
        src += n;
 4c6:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 4c8:	fec05ae3          	blez	a2,4bc <memmove+0x28>
 4cc:	fff6079b          	addiw	a5,a2,-1
 4d0:	1782                	slli	a5,a5,0x20
 4d2:	9381                	srli	a5,a5,0x20
 4d4:	fff7c793          	not	a5,a5
 4d8:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 4da:	15fd                	addi	a1,a1,-1
 4dc:	177d                	addi	a4,a4,-1
 4de:	0005c683          	lbu	a3,0(a1)
 4e2:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 4e6:	fee79ae3          	bne	a5,a4,4da <memmove+0x46>
 4ea:	bfc9                	j	4bc <memmove+0x28>

00000000000004ec <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 4ec:	1141                	addi	sp,sp,-16
 4ee:	e422                	sd	s0,8(sp)
 4f0:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 4f2:	ca05                	beqz	a2,522 <memcmp+0x36>
 4f4:	fff6069b          	addiw	a3,a2,-1
 4f8:	1682                	slli	a3,a3,0x20
 4fa:	9281                	srli	a3,a3,0x20
 4fc:	0685                	addi	a3,a3,1
 4fe:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 500:	00054783          	lbu	a5,0(a0)
 504:	0005c703          	lbu	a4,0(a1)
 508:	00e79863          	bne	a5,a4,518 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 50c:	0505                	addi	a0,a0,1
        p2++;
 50e:	0585                	addi	a1,a1,1
    while (n-- > 0)
 510:	fed518e3          	bne	a0,a3,500 <memcmp+0x14>
    }
    return 0;
 514:	4501                	li	a0,0
 516:	a019                	j	51c <memcmp+0x30>
            return *p1 - *p2;
 518:	40e7853b          	subw	a0,a5,a4
}
 51c:	6422                	ld	s0,8(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret
    return 0;
 522:	4501                	li	a0,0
 524:	bfe5                	j	51c <memcmp+0x30>

0000000000000526 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 526:	1141                	addi	sp,sp,-16
 528:	e406                	sd	ra,8(sp)
 52a:	e022                	sd	s0,0(sp)
 52c:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 52e:	00000097          	auipc	ra,0x0
 532:	f66080e7          	jalr	-154(ra) # 494 <memmove>
}
 536:	60a2                	ld	ra,8(sp)
 538:	6402                	ld	s0,0(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret

000000000000053e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 53e:	4885                	li	a7,1
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exit>:
.global exit
exit:
 li a7, SYS_exit
 546:	4889                	li	a7,2
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <wait>:
.global wait
wait:
 li a7, SYS_wait
 54e:	488d                	li	a7,3
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 556:	4891                	li	a7,4
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <read>:
.global read
read:
 li a7, SYS_read
 55e:	4895                	li	a7,5
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <write>:
.global write
write:
 li a7, SYS_write
 566:	48c1                	li	a7,16
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <close>:
.global close
close:
 li a7, SYS_close
 56e:	48d5                	li	a7,21
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <kill>:
.global kill
kill:
 li a7, SYS_kill
 576:	4899                	li	a7,6
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <exec>:
.global exec
exec:
 li a7, SYS_exec
 57e:	489d                	li	a7,7
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <open>:
.global open
open:
 li a7, SYS_open
 586:	48bd                	li	a7,15
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 58e:	48c5                	li	a7,17
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 596:	48c9                	li	a7,18
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 59e:	48a1                	li	a7,8
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <link>:
.global link
link:
 li a7, SYS_link
 5a6:	48cd                	li	a7,19
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ae:	48d1                	li	a7,20
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b6:	48a5                	li	a7,9
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <dup>:
.global dup
dup:
 li a7, SYS_dup
 5be:	48a9                	li	a7,10
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c6:	48ad                	li	a7,11
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ce:	48b1                	li	a7,12
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d6:	48b5                	li	a7,13
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5de:	48b9                	li	a7,14
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5e6:	48d9                	li	a7,22
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 5ee:	48dd                	li	a7,23
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 5f6:	48e1                	li	a7,24
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5fe:	1101                	addi	sp,sp,-32
 600:	ec06                	sd	ra,24(sp)
 602:	e822                	sd	s0,16(sp)
 604:	1000                	addi	s0,sp,32
 606:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 60a:	4605                	li	a2,1
 60c:	fef40593          	addi	a1,s0,-17
 610:	00000097          	auipc	ra,0x0
 614:	f56080e7          	jalr	-170(ra) # 566 <write>
}
 618:	60e2                	ld	ra,24(sp)
 61a:	6442                	ld	s0,16(sp)
 61c:	6105                	addi	sp,sp,32
 61e:	8082                	ret

0000000000000620 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	7139                	addi	sp,sp,-64
 622:	fc06                	sd	ra,56(sp)
 624:	f822                	sd	s0,48(sp)
 626:	f426                	sd	s1,40(sp)
 628:	f04a                	sd	s2,32(sp)
 62a:	ec4e                	sd	s3,24(sp)
 62c:	0080                	addi	s0,sp,64
 62e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 630:	c299                	beqz	a3,636 <printint+0x16>
 632:	0805c963          	bltz	a1,6c4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 636:	2581                	sext.w	a1,a1
  neg = 0;
 638:	4881                	li	a7,0
 63a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 63e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 640:	2601                	sext.w	a2,a2
 642:	00000517          	auipc	a0,0x0
 646:	56650513          	addi	a0,a0,1382 # ba8 <digits>
 64a:	883a                	mv	a6,a4
 64c:	2705                	addiw	a4,a4,1
 64e:	02c5f7bb          	remuw	a5,a1,a2
 652:	1782                	slli	a5,a5,0x20
 654:	9381                	srli	a5,a5,0x20
 656:	97aa                	add	a5,a5,a0
 658:	0007c783          	lbu	a5,0(a5)
 65c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 660:	0005879b          	sext.w	a5,a1
 664:	02c5d5bb          	divuw	a1,a1,a2
 668:	0685                	addi	a3,a3,1
 66a:	fec7f0e3          	bgeu	a5,a2,64a <printint+0x2a>
  if(neg)
 66e:	00088c63          	beqz	a7,686 <printint+0x66>
    buf[i++] = '-';
 672:	fd070793          	addi	a5,a4,-48
 676:	00878733          	add	a4,a5,s0
 67a:	02d00793          	li	a5,45
 67e:	fef70823          	sb	a5,-16(a4)
 682:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 686:	02e05863          	blez	a4,6b6 <printint+0x96>
 68a:	fc040793          	addi	a5,s0,-64
 68e:	00e78933          	add	s2,a5,a4
 692:	fff78993          	addi	s3,a5,-1
 696:	99ba                	add	s3,s3,a4
 698:	377d                	addiw	a4,a4,-1
 69a:	1702                	slli	a4,a4,0x20
 69c:	9301                	srli	a4,a4,0x20
 69e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6a2:	fff94583          	lbu	a1,-1(s2)
 6a6:	8526                	mv	a0,s1
 6a8:	00000097          	auipc	ra,0x0
 6ac:	f56080e7          	jalr	-170(ra) # 5fe <putc>
  while(--i >= 0)
 6b0:	197d                	addi	s2,s2,-1
 6b2:	ff3918e3          	bne	s2,s3,6a2 <printint+0x82>
}
 6b6:	70e2                	ld	ra,56(sp)
 6b8:	7442                	ld	s0,48(sp)
 6ba:	74a2                	ld	s1,40(sp)
 6bc:	7902                	ld	s2,32(sp)
 6be:	69e2                	ld	s3,24(sp)
 6c0:	6121                	addi	sp,sp,64
 6c2:	8082                	ret
    x = -xx;
 6c4:	40b005bb          	negw	a1,a1
    neg = 1;
 6c8:	4885                	li	a7,1
    x = -xx;
 6ca:	bf85                	j	63a <printint+0x1a>

00000000000006cc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6cc:	7119                	addi	sp,sp,-128
 6ce:	fc86                	sd	ra,120(sp)
 6d0:	f8a2                	sd	s0,112(sp)
 6d2:	f4a6                	sd	s1,104(sp)
 6d4:	f0ca                	sd	s2,96(sp)
 6d6:	ecce                	sd	s3,88(sp)
 6d8:	e8d2                	sd	s4,80(sp)
 6da:	e4d6                	sd	s5,72(sp)
 6dc:	e0da                	sd	s6,64(sp)
 6de:	fc5e                	sd	s7,56(sp)
 6e0:	f862                	sd	s8,48(sp)
 6e2:	f466                	sd	s9,40(sp)
 6e4:	f06a                	sd	s10,32(sp)
 6e6:	ec6e                	sd	s11,24(sp)
 6e8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6ea:	0005c903          	lbu	s2,0(a1)
 6ee:	18090f63          	beqz	s2,88c <vprintf+0x1c0>
 6f2:	8aaa                	mv	s5,a0
 6f4:	8b32                	mv	s6,a2
 6f6:	00158493          	addi	s1,a1,1
  state = 0;
 6fa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6fc:	02500a13          	li	s4,37
 700:	4c55                	li	s8,21
 702:	00000c97          	auipc	s9,0x0
 706:	44ec8c93          	addi	s9,s9,1102 # b50 <malloc+0x1c0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 70a:	02800d93          	li	s11,40
  putc(fd, 'x');
 70e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 710:	00000b97          	auipc	s7,0x0
 714:	498b8b93          	addi	s7,s7,1176 # ba8 <digits>
 718:	a839                	j	736 <vprintf+0x6a>
        putc(fd, c);
 71a:	85ca                	mv	a1,s2
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	ee0080e7          	jalr	-288(ra) # 5fe <putc>
 726:	a019                	j	72c <vprintf+0x60>
    } else if(state == '%'){
 728:	01498d63          	beq	s3,s4,742 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 72c:	0485                	addi	s1,s1,1
 72e:	fff4c903          	lbu	s2,-1(s1)
 732:	14090d63          	beqz	s2,88c <vprintf+0x1c0>
    if(state == 0){
 736:	fe0999e3          	bnez	s3,728 <vprintf+0x5c>
      if(c == '%'){
 73a:	ff4910e3          	bne	s2,s4,71a <vprintf+0x4e>
        state = '%';
 73e:	89d2                	mv	s3,s4
 740:	b7f5                	j	72c <vprintf+0x60>
      if(c == 'd'){
 742:	11490c63          	beq	s2,s4,85a <vprintf+0x18e>
 746:	f9d9079b          	addiw	a5,s2,-99
 74a:	0ff7f793          	zext.b	a5,a5
 74e:	10fc6e63          	bltu	s8,a5,86a <vprintf+0x19e>
 752:	f9d9079b          	addiw	a5,s2,-99
 756:	0ff7f713          	zext.b	a4,a5
 75a:	10ec6863          	bltu	s8,a4,86a <vprintf+0x19e>
 75e:	00271793          	slli	a5,a4,0x2
 762:	97e6                	add	a5,a5,s9
 764:	439c                	lw	a5,0(a5)
 766:	97e6                	add	a5,a5,s9
 768:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 76a:	008b0913          	addi	s2,s6,8
 76e:	4685                	li	a3,1
 770:	4629                	li	a2,10
 772:	000b2583          	lw	a1,0(s6)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	ea8080e7          	jalr	-344(ra) # 620 <printint>
 780:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 782:	4981                	li	s3,0
 784:	b765                	j	72c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 786:	008b0913          	addi	s2,s6,8
 78a:	4681                	li	a3,0
 78c:	4629                	li	a2,10
 78e:	000b2583          	lw	a1,0(s6)
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	e8c080e7          	jalr	-372(ra) # 620 <printint>
 79c:	8b4a                	mv	s6,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b771                	j	72c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7a2:	008b0913          	addi	s2,s6,8
 7a6:	4681                	li	a3,0
 7a8:	866a                	mv	a2,s10
 7aa:	000b2583          	lw	a1,0(s6)
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	e70080e7          	jalr	-400(ra) # 620 <printint>
 7b8:	8b4a                	mv	s6,s2
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bf85                	j	72c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7be:	008b0793          	addi	a5,s6,8
 7c2:	f8f43423          	sd	a5,-120(s0)
 7c6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7ca:	03000593          	li	a1,48
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e2e080e7          	jalr	-466(ra) # 5fe <putc>
  putc(fd, 'x');
 7d8:	07800593          	li	a1,120
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e20080e7          	jalr	-480(ra) # 5fe <putc>
 7e6:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e8:	03c9d793          	srli	a5,s3,0x3c
 7ec:	97de                	add	a5,a5,s7
 7ee:	0007c583          	lbu	a1,0(a5)
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e0a080e7          	jalr	-502(ra) # 5fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7fc:	0992                	slli	s3,s3,0x4
 7fe:	397d                	addiw	s2,s2,-1
 800:	fe0914e3          	bnez	s2,7e8 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 804:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 808:	4981                	li	s3,0
 80a:	b70d                	j	72c <vprintf+0x60>
        s = va_arg(ap, char*);
 80c:	008b0913          	addi	s2,s6,8
 810:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 814:	02098163          	beqz	s3,836 <vprintf+0x16a>
        while(*s != 0){
 818:	0009c583          	lbu	a1,0(s3)
 81c:	c5ad                	beqz	a1,886 <vprintf+0x1ba>
          putc(fd, *s);
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	dde080e7          	jalr	-546(ra) # 5fe <putc>
          s++;
 828:	0985                	addi	s3,s3,1
        while(*s != 0){
 82a:	0009c583          	lbu	a1,0(s3)
 82e:	f9e5                	bnez	a1,81e <vprintf+0x152>
        s = va_arg(ap, char*);
 830:	8b4a                	mv	s6,s2
      state = 0;
 832:	4981                	li	s3,0
 834:	bde5                	j	72c <vprintf+0x60>
          s = "(null)";
 836:	00000997          	auipc	s3,0x0
 83a:	31298993          	addi	s3,s3,786 # b48 <malloc+0x1b8>
        while(*s != 0){
 83e:	85ee                	mv	a1,s11
 840:	bff9                	j	81e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 842:	008b0913          	addi	s2,s6,8
 846:	000b4583          	lbu	a1,0(s6)
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	db2080e7          	jalr	-590(ra) # 5fe <putc>
 854:	8b4a                	mv	s6,s2
      state = 0;
 856:	4981                	li	s3,0
 858:	bdd1                	j	72c <vprintf+0x60>
        putc(fd, c);
 85a:	85d2                	mv	a1,s4
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	da0080e7          	jalr	-608(ra) # 5fe <putc>
      state = 0;
 866:	4981                	li	s3,0
 868:	b5d1                	j	72c <vprintf+0x60>
        putc(fd, '%');
 86a:	85d2                	mv	a1,s4
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	d90080e7          	jalr	-624(ra) # 5fe <putc>
        putc(fd, c);
 876:	85ca                	mv	a1,s2
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	d84080e7          	jalr	-636(ra) # 5fe <putc>
      state = 0;
 882:	4981                	li	s3,0
 884:	b565                	j	72c <vprintf+0x60>
        s = va_arg(ap, char*);
 886:	8b4a                	mv	s6,s2
      state = 0;
 888:	4981                	li	s3,0
 88a:	b54d                	j	72c <vprintf+0x60>
    }
  }
}
 88c:	70e6                	ld	ra,120(sp)
 88e:	7446                	ld	s0,112(sp)
 890:	74a6                	ld	s1,104(sp)
 892:	7906                	ld	s2,96(sp)
 894:	69e6                	ld	s3,88(sp)
 896:	6a46                	ld	s4,80(sp)
 898:	6aa6                	ld	s5,72(sp)
 89a:	6b06                	ld	s6,64(sp)
 89c:	7be2                	ld	s7,56(sp)
 89e:	7c42                	ld	s8,48(sp)
 8a0:	7ca2                	ld	s9,40(sp)
 8a2:	7d02                	ld	s10,32(sp)
 8a4:	6de2                	ld	s11,24(sp)
 8a6:	6109                	addi	sp,sp,128
 8a8:	8082                	ret

00000000000008aa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8aa:	715d                	addi	sp,sp,-80
 8ac:	ec06                	sd	ra,24(sp)
 8ae:	e822                	sd	s0,16(sp)
 8b0:	1000                	addi	s0,sp,32
 8b2:	e010                	sd	a2,0(s0)
 8b4:	e414                	sd	a3,8(s0)
 8b6:	e818                	sd	a4,16(s0)
 8b8:	ec1c                	sd	a5,24(s0)
 8ba:	03043023          	sd	a6,32(s0)
 8be:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c6:	8622                	mv	a2,s0
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e04080e7          	jalr	-508(ra) # 6cc <vprintf>
}
 8d0:	60e2                	ld	ra,24(sp)
 8d2:	6442                	ld	s0,16(sp)
 8d4:	6161                	addi	sp,sp,80
 8d6:	8082                	ret

00000000000008d8 <printf>:

void
printf(const char *fmt, ...)
{
 8d8:	711d                	addi	sp,sp,-96
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	e40c                	sd	a1,8(s0)
 8e2:	e810                	sd	a2,16(s0)
 8e4:	ec14                	sd	a3,24(s0)
 8e6:	f018                	sd	a4,32(s0)
 8e8:	f41c                	sd	a5,40(s0)
 8ea:	03043823          	sd	a6,48(s0)
 8ee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f2:	00840613          	addi	a2,s0,8
 8f6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8fa:	85aa                	mv	a1,a0
 8fc:	4505                	li	a0,1
 8fe:	00000097          	auipc	ra,0x0
 902:	dce080e7          	jalr	-562(ra) # 6cc <vprintf>
}
 906:	60e2                	ld	ra,24(sp)
 908:	6442                	ld	s0,16(sp)
 90a:	6125                	addi	sp,sp,96
 90c:	8082                	ret

000000000000090e <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 90e:	1141                	addi	sp,sp,-16
 910:	e422                	sd	s0,8(sp)
 912:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 914:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 918:	00000797          	auipc	a5,0x0
 91c:	6f87b783          	ld	a5,1784(a5) # 1010 <freep>
 920:	a02d                	j	94a <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 922:	4618                	lw	a4,8(a2)
 924:	9f2d                	addw	a4,a4,a1
 926:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 92a:	6398                	ld	a4,0(a5)
 92c:	6310                	ld	a2,0(a4)
 92e:	a83d                	j	96c <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 930:	ff852703          	lw	a4,-8(a0)
 934:	9f31                	addw	a4,a4,a2
 936:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 938:	ff053683          	ld	a3,-16(a0)
 93c:	a091                	j	980 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93e:	6398                	ld	a4,0(a5)
 940:	00e7e463          	bltu	a5,a4,948 <free+0x3a>
 944:	00e6ea63          	bltu	a3,a4,958 <free+0x4a>
{
 948:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94a:	fed7fae3          	bgeu	a5,a3,93e <free+0x30>
 94e:	6398                	ld	a4,0(a5)
 950:	00e6e463          	bltu	a3,a4,958 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 954:	fee7eae3          	bltu	a5,a4,948 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 958:	ff852583          	lw	a1,-8(a0)
 95c:	6390                	ld	a2,0(a5)
 95e:	02059813          	slli	a6,a1,0x20
 962:	01c85713          	srli	a4,a6,0x1c
 966:	9736                	add	a4,a4,a3
 968:	fae60de3          	beq	a2,a4,922 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 96c:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 970:	4790                	lw	a2,8(a5)
 972:	02061593          	slli	a1,a2,0x20
 976:	01c5d713          	srli	a4,a1,0x1c
 97a:	973e                	add	a4,a4,a5
 97c:	fae68ae3          	beq	a3,a4,930 <free+0x22>
        p->s.ptr = bp->s.ptr;
 980:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 982:	00000717          	auipc	a4,0x0
 986:	68f73723          	sd	a5,1678(a4) # 1010 <freep>
}
 98a:	6422                	ld	s0,8(sp)
 98c:	0141                	addi	sp,sp,16
 98e:	8082                	ret

0000000000000990 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 990:	7139                	addi	sp,sp,-64
 992:	fc06                	sd	ra,56(sp)
 994:	f822                	sd	s0,48(sp)
 996:	f426                	sd	s1,40(sp)
 998:	f04a                	sd	s2,32(sp)
 99a:	ec4e                	sd	s3,24(sp)
 99c:	e852                	sd	s4,16(sp)
 99e:	e456                	sd	s5,8(sp)
 9a0:	e05a                	sd	s6,0(sp)
 9a2:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9a4:	02051493          	slli	s1,a0,0x20
 9a8:	9081                	srli	s1,s1,0x20
 9aa:	04bd                	addi	s1,s1,15
 9ac:	8091                	srli	s1,s1,0x4
 9ae:	0014899b          	addiw	s3,s1,1
 9b2:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 9b4:	00000517          	auipc	a0,0x0
 9b8:	65c53503          	ld	a0,1628(a0) # 1010 <freep>
 9bc:	c515                	beqz	a0,9e8 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9be:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 9c0:	4798                	lw	a4,8(a5)
 9c2:	02977f63          	bgeu	a4,s1,a00 <malloc+0x70>
 9c6:	8a4e                	mv	s4,s3
 9c8:	0009871b          	sext.w	a4,s3
 9cc:	6685                	lui	a3,0x1
 9ce:	00d77363          	bgeu	a4,a3,9d4 <malloc+0x44>
 9d2:	6a05                	lui	s4,0x1
 9d4:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 9d8:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 9dc:	00000917          	auipc	s2,0x0
 9e0:	63490913          	addi	s2,s2,1588 # 1010 <freep>
    if (p == (char *)-1)
 9e4:	5afd                	li	s5,-1
 9e6:	a895                	j	a5a <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 9e8:	00000797          	auipc	a5,0x0
 9ec:	63878793          	addi	a5,a5,1592 # 1020 <base>
 9f0:	00000717          	auipc	a4,0x0
 9f4:	62f73023          	sd	a5,1568(a4) # 1010 <freep>
 9f8:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 9fa:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 9fe:	b7e1                	j	9c6 <malloc+0x36>
            if (p->s.size == nunits)
 a00:	02e48c63          	beq	s1,a4,a38 <malloc+0xa8>
                p->s.size -= nunits;
 a04:	4137073b          	subw	a4,a4,s3
 a08:	c798                	sw	a4,8(a5)
                p += p->s.size;
 a0a:	02071693          	slli	a3,a4,0x20
 a0e:	01c6d713          	srli	a4,a3,0x1c
 a12:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 a14:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 a18:	00000717          	auipc	a4,0x0
 a1c:	5ea73c23          	sd	a0,1528(a4) # 1010 <freep>
            return (void *)(p + 1);
 a20:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 a24:	70e2                	ld	ra,56(sp)
 a26:	7442                	ld	s0,48(sp)
 a28:	74a2                	ld	s1,40(sp)
 a2a:	7902                	ld	s2,32(sp)
 a2c:	69e2                	ld	s3,24(sp)
 a2e:	6a42                	ld	s4,16(sp)
 a30:	6aa2                	ld	s5,8(sp)
 a32:	6b02                	ld	s6,0(sp)
 a34:	6121                	addi	sp,sp,64
 a36:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 a38:	6398                	ld	a4,0(a5)
 a3a:	e118                	sd	a4,0(a0)
 a3c:	bff1                	j	a18 <malloc+0x88>
    hp->s.size = nu;
 a3e:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 a42:	0541                	addi	a0,a0,16
 a44:	00000097          	auipc	ra,0x0
 a48:	eca080e7          	jalr	-310(ra) # 90e <free>
    return freep;
 a4c:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 a50:	d971                	beqz	a0,a24 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 a52:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 a54:	4798                	lw	a4,8(a5)
 a56:	fa9775e3          	bgeu	a4,s1,a00 <malloc+0x70>
        if (p == freep)
 a5a:	00093703          	ld	a4,0(s2)
 a5e:	853e                	mv	a0,a5
 a60:	fef719e3          	bne	a4,a5,a52 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 a64:	8552                	mv	a0,s4
 a66:	00000097          	auipc	ra,0x0
 a6a:	b68080e7          	jalr	-1176(ra) # 5ce <sbrk>
    if (p == (char *)-1)
 a6e:	fd5518e3          	bne	a0,s5,a3e <malloc+0xae>
                return 0;
 a72:	4501                	li	a0,0
 a74:	bf45                	j	a24 <malloc+0x94>
