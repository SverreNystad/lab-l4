
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
   8:	00000097          	auipc	ra,0x0
   c:	468080e7          	jalr	1128(ra) # 470 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	462080e7          	jalr	1122(ra) # 478 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	4e8080e7          	jalr	1256(ra) # 508 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
    lk->name = name;
  30:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  32:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  36:	57fd                	li	a5,-1
  38:	00f50823          	sb	a5,16(a0)
}
  3c:	6422                	ld	s0,8(sp)
  3e:	0141                	addi	sp,sp,16
  40:	8082                	ret

0000000000000042 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  42:	00054783          	lbu	a5,0(a0)
  46:	e399                	bnez	a5,4c <holding+0xa>
  48:	4501                	li	a0,0
}
  4a:	8082                	ret
{
  4c:	1101                	addi	sp,sp,-32
  4e:	ec06                	sd	ra,24(sp)
  50:	e822                	sd	s0,16(sp)
  52:	e426                	sd	s1,8(sp)
  54:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  56:	01054483          	lbu	s1,16(a0)
  5a:	00000097          	auipc	ra,0x0
  5e:	122080e7          	jalr	290(ra) # 17c <twhoami>
  62:	2501                	sext.w	a0,a0
  64:	40a48533          	sub	a0,s1,a0
  68:	00153513          	seqz	a0,a0
}
  6c:	60e2                	ld	ra,24(sp)
  6e:	6442                	ld	s0,16(sp)
  70:	64a2                	ld	s1,8(sp)
  72:	6105                	addi	sp,sp,32
  74:	8082                	ret

0000000000000076 <acquire>:

void acquire(struct lock *lk)
{
  76:	7179                	addi	sp,sp,-48
  78:	f406                	sd	ra,40(sp)
  7a:	f022                	sd	s0,32(sp)
  7c:	ec26                	sd	s1,24(sp)
  7e:	e84a                	sd	s2,16(sp)
  80:	e44e                	sd	s3,8(sp)
  82:	e052                	sd	s4,0(sp)
  84:	1800                	addi	s0,sp,48
  86:	8a2a                	mv	s4,a0
    if (holding(lk))
  88:	00000097          	auipc	ra,0x0
  8c:	fba080e7          	jalr	-70(ra) # 42 <holding>
  90:	e919                	bnez	a0,a6 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  92:	ffca7493          	andi	s1,s4,-4
  96:	003a7913          	andi	s2,s4,3
  9a:	0039191b          	slliw	s2,s2,0x3
  9e:	4985                	li	s3,1
  a0:	012999bb          	sllw	s3,s3,s2
  a4:	a015                	j	c8 <acquire+0x52>
        printf("re-acquiring lock we already hold");
  a6:	00001517          	auipc	a0,0x1
  aa:	90a50513          	addi	a0,a0,-1782 # 9b0 <malloc+0xee>
  ae:	00000097          	auipc	ra,0x0
  b2:	75c080e7          	jalr	1884(ra) # 80a <printf>
        exit(-1);
  b6:	557d                	li	a0,-1
  b8:	00000097          	auipc	ra,0x0
  bc:	3c0080e7          	jalr	960(ra) # 478 <exit>
    {
        // give up the cpu for other threads
        tyield();
  c0:	00000097          	auipc	ra,0x0
  c4:	0b0080e7          	jalr	176(ra) # 170 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  c8:	4534a7af          	amoor.w.aq	a5,s3,(s1)
  cc:	0127d7bb          	srlw	a5,a5,s2
  d0:	0ff7f793          	zext.b	a5,a5
  d4:	f7f5                	bnez	a5,c0 <acquire+0x4a>
    }

    __sync_synchronize();
  d6:	0ff0000f          	fence

    lk->tid = twhoami();
  da:	00000097          	auipc	ra,0x0
  de:	0a2080e7          	jalr	162(ra) # 17c <twhoami>
  e2:	00aa0823          	sb	a0,16(s4)
}
  e6:	70a2                	ld	ra,40(sp)
  e8:	7402                	ld	s0,32(sp)
  ea:	64e2                	ld	s1,24(sp)
  ec:	6942                	ld	s2,16(sp)
  ee:	69a2                	ld	s3,8(sp)
  f0:	6a02                	ld	s4,0(sp)
  f2:	6145                	addi	sp,sp,48
  f4:	8082                	ret

00000000000000f6 <release>:

void release(struct lock *lk)
{
  f6:	1101                	addi	sp,sp,-32
  f8:	ec06                	sd	ra,24(sp)
  fa:	e822                	sd	s0,16(sp)
  fc:	e426                	sd	s1,8(sp)
  fe:	1000                	addi	s0,sp,32
 100:	84aa                	mv	s1,a0
    if (!holding(lk))
 102:	00000097          	auipc	ra,0x0
 106:	f40080e7          	jalr	-192(ra) # 42 <holding>
 10a:	c11d                	beqz	a0,130 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 10c:	57fd                	li	a5,-1
 10e:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 112:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 116:	0ff0000f          	fence
 11a:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 11e:	00000097          	auipc	ra,0x0
 122:	052080e7          	jalr	82(ra) # 170 <tyield>
}
 126:	60e2                	ld	ra,24(sp)
 128:	6442                	ld	s0,16(sp)
 12a:	64a2                	ld	s1,8(sp)
 12c:	6105                	addi	sp,sp,32
 12e:	8082                	ret
        printf("releasing lock we are not holding");
 130:	00001517          	auipc	a0,0x1
 134:	8a850513          	addi	a0,a0,-1880 # 9d8 <malloc+0x116>
 138:	00000097          	auipc	ra,0x0
 13c:	6d2080e7          	jalr	1746(ra) # 80a <printf>
        exit(-1);
 140:	557d                	li	a0,-1
 142:	00000097          	auipc	ra,0x0
 146:	336080e7          	jalr	822(ra) # 478 <exit>

000000000000014a <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e422                	sd	s0,8(sp)
 14e:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 168:	4501                	li	a0,0
 16a:	6422                	ld	s0,8(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret

0000000000000170 <tyield>:

void tyield()
{
 170:	1141                	addi	sp,sp,-16
 172:	e422                	sd	s0,8(sp)
 174:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <twhoami>:

uint8 twhoami()
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 182:	4501                	li	a0,0
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <tswtch>:
 18a:	00153023          	sd	ra,0(a0)
 18e:	00253423          	sd	sp,8(a0)
 192:	e900                	sd	s0,16(a0)
 194:	ed04                	sd	s1,24(a0)
 196:	03253023          	sd	s2,32(a0)
 19a:	03353423          	sd	s3,40(a0)
 19e:	03453823          	sd	s4,48(a0)
 1a2:	03553c23          	sd	s5,56(a0)
 1a6:	05653023          	sd	s6,64(a0)
 1aa:	05753423          	sd	s7,72(a0)
 1ae:	05853823          	sd	s8,80(a0)
 1b2:	05953c23          	sd	s9,88(a0)
 1b6:	07a53023          	sd	s10,96(a0)
 1ba:	07b53423          	sd	s11,104(a0)
 1be:	0005b083          	ld	ra,0(a1)
 1c2:	0085b103          	ld	sp,8(a1)
 1c6:	6980                	ld	s0,16(a1)
 1c8:	6d84                	ld	s1,24(a1)
 1ca:	0205b903          	ld	s2,32(a1)
 1ce:	0285b983          	ld	s3,40(a1)
 1d2:	0305ba03          	ld	s4,48(a1)
 1d6:	0385ba83          	ld	s5,56(a1)
 1da:	0405bb03          	ld	s6,64(a1)
 1de:	0485bb83          	ld	s7,72(a1)
 1e2:	0505bc03          	ld	s8,80(a1)
 1e6:	0585bc83          	ld	s9,88(a1)
 1ea:	0605bd03          	ld	s10,96(a1)
 1ee:	0685bd83          	ld	s11,104(a1)
 1f2:	8082                	ret

00000000000001f4 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e406                	sd	ra,8(sp)
 1f8:	e022                	sd	s0,0(sp)
 1fa:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 1fc:	00000097          	auipc	ra,0x0
 200:	e04080e7          	jalr	-508(ra) # 0 <main>
    exit(res);
 204:	00000097          	auipc	ra,0x0
 208:	274080e7          	jalr	628(ra) # 478 <exit>

000000000000020c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 212:	87aa                	mv	a5,a0
 214:	0585                	addi	a1,a1,1
 216:	0785                	addi	a5,a5,1
 218:	fff5c703          	lbu	a4,-1(a1)
 21c:	fee78fa3          	sb	a4,-1(a5)
 220:	fb75                	bnez	a4,214 <strcpy+0x8>
        ;
    return os;
}
 222:	6422                	ld	s0,8(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret

0000000000000228 <strcmp>:

int strcmp(const char *p, const char *q)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e422                	sd	s0,8(sp)
 22c:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 22e:	00054783          	lbu	a5,0(a0)
 232:	cb91                	beqz	a5,246 <strcmp+0x1e>
 234:	0005c703          	lbu	a4,0(a1)
 238:	00f71763          	bne	a4,a5,246 <strcmp+0x1e>
        p++, q++;
 23c:	0505                	addi	a0,a0,1
 23e:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 240:	00054783          	lbu	a5,0(a0)
 244:	fbe5                	bnez	a5,234 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 246:	0005c503          	lbu	a0,0(a1)
}
 24a:	40a7853b          	subw	a0,a5,a0
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret

0000000000000254 <strlen>:

uint strlen(const char *s)
{
 254:	1141                	addi	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 25a:	00054783          	lbu	a5,0(a0)
 25e:	cf91                	beqz	a5,27a <strlen+0x26>
 260:	0505                	addi	a0,a0,1
 262:	87aa                	mv	a5,a0
 264:	4685                	li	a3,1
 266:	9e89                	subw	a3,a3,a0
 268:	00f6853b          	addw	a0,a3,a5
 26c:	0785                	addi	a5,a5,1
 26e:	fff7c703          	lbu	a4,-1(a5)
 272:	fb7d                	bnez	a4,268 <strlen+0x14>
        ;
    return n;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
    for (n = 0; s[n]; n++)
 27a:	4501                	li	a0,0
 27c:	bfe5                	j	274 <strlen+0x20>

000000000000027e <memset>:

void *
memset(void *dst, int c, uint n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 284:	ca19                	beqz	a2,29a <memset+0x1c>
 286:	87aa                	mv	a5,a0
 288:	1602                	slli	a2,a2,0x20
 28a:	9201                	srli	a2,a2,0x20
 28c:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 290:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 294:	0785                	addi	a5,a5,1
 296:	fee79de3          	bne	a5,a4,290 <memset+0x12>
    }
    return dst;
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <strchr>:

char *
strchr(const char *s, char c)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
    for (; *s; s++)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	cb99                	beqz	a5,2c0 <strchr+0x20>
        if (*s == c)
 2ac:	00f58763          	beq	a1,a5,2ba <strchr+0x1a>
    for (; *s; s++)
 2b0:	0505                	addi	a0,a0,1
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	fbfd                	bnez	a5,2ac <strchr+0xc>
            return (char *)s;
    return 0;
 2b8:	4501                	li	a0,0
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
    return 0;
 2c0:	4501                	li	a0,0
 2c2:	bfe5                	j	2ba <strchr+0x1a>

00000000000002c4 <gets>:

char *
gets(char *buf, int max)
{
 2c4:	711d                	addi	sp,sp,-96
 2c6:	ec86                	sd	ra,88(sp)
 2c8:	e8a2                	sd	s0,80(sp)
 2ca:	e4a6                	sd	s1,72(sp)
 2cc:	e0ca                	sd	s2,64(sp)
 2ce:	fc4e                	sd	s3,56(sp)
 2d0:	f852                	sd	s4,48(sp)
 2d2:	f456                	sd	s5,40(sp)
 2d4:	f05a                	sd	s6,32(sp)
 2d6:	ec5e                	sd	s7,24(sp)
 2d8:	1080                	addi	s0,sp,96
 2da:	8baa                	mv	s7,a0
 2dc:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 2de:	892a                	mv	s2,a0
 2e0:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 2e2:	4aa9                	li	s5,10
 2e4:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 2e6:	89a6                	mv	s3,s1
 2e8:	2485                	addiw	s1,s1,1
 2ea:	0344d863          	bge	s1,s4,31a <gets+0x56>
        cc = read(0, &c, 1);
 2ee:	4605                	li	a2,1
 2f0:	faf40593          	addi	a1,s0,-81
 2f4:	4501                	li	a0,0
 2f6:	00000097          	auipc	ra,0x0
 2fa:	19a080e7          	jalr	410(ra) # 490 <read>
        if (cc < 1)
 2fe:	00a05e63          	blez	a0,31a <gets+0x56>
        buf[i++] = c;
 302:	faf44783          	lbu	a5,-81(s0)
 306:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 30a:	01578763          	beq	a5,s5,318 <gets+0x54>
 30e:	0905                	addi	s2,s2,1
 310:	fd679be3          	bne	a5,s6,2e6 <gets+0x22>
    for (i = 0; i + 1 < max;)
 314:	89a6                	mv	s3,s1
 316:	a011                	j	31a <gets+0x56>
 318:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 31a:	99de                	add	s3,s3,s7
 31c:	00098023          	sb	zero,0(s3)
    return buf;
}
 320:	855e                	mv	a0,s7
 322:	60e6                	ld	ra,88(sp)
 324:	6446                	ld	s0,80(sp)
 326:	64a6                	ld	s1,72(sp)
 328:	6906                	ld	s2,64(sp)
 32a:	79e2                	ld	s3,56(sp)
 32c:	7a42                	ld	s4,48(sp)
 32e:	7aa2                	ld	s5,40(sp)
 330:	7b02                	ld	s6,32(sp)
 332:	6be2                	ld	s7,24(sp)
 334:	6125                	addi	sp,sp,96
 336:	8082                	ret

0000000000000338 <stat>:

int stat(const char *n, struct stat *st)
{
 338:	1101                	addi	sp,sp,-32
 33a:	ec06                	sd	ra,24(sp)
 33c:	e822                	sd	s0,16(sp)
 33e:	e426                	sd	s1,8(sp)
 340:	e04a                	sd	s2,0(sp)
 342:	1000                	addi	s0,sp,32
 344:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 346:	4581                	li	a1,0
 348:	00000097          	auipc	ra,0x0
 34c:	170080e7          	jalr	368(ra) # 4b8 <open>
    if (fd < 0)
 350:	02054563          	bltz	a0,37a <stat+0x42>
 354:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 356:	85ca                	mv	a1,s2
 358:	00000097          	auipc	ra,0x0
 35c:	178080e7          	jalr	376(ra) # 4d0 <fstat>
 360:	892a                	mv	s2,a0
    close(fd);
 362:	8526                	mv	a0,s1
 364:	00000097          	auipc	ra,0x0
 368:	13c080e7          	jalr	316(ra) # 4a0 <close>
    return r;
}
 36c:	854a                	mv	a0,s2
 36e:	60e2                	ld	ra,24(sp)
 370:	6442                	ld	s0,16(sp)
 372:	64a2                	ld	s1,8(sp)
 374:	6902                	ld	s2,0(sp)
 376:	6105                	addi	sp,sp,32
 378:	8082                	ret
        return -1;
 37a:	597d                	li	s2,-1
 37c:	bfc5                	j	36c <stat+0x34>

000000000000037e <atoi>:

int atoi(const char *s)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 384:	00054683          	lbu	a3,0(a0)
 388:	fd06879b          	addiw	a5,a3,-48
 38c:	0ff7f793          	zext.b	a5,a5
 390:	4625                	li	a2,9
 392:	02f66863          	bltu	a2,a5,3c2 <atoi+0x44>
 396:	872a                	mv	a4,a0
    n = 0;
 398:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 39a:	0705                	addi	a4,a4,1
 39c:	0025179b          	slliw	a5,a0,0x2
 3a0:	9fa9                	addw	a5,a5,a0
 3a2:	0017979b          	slliw	a5,a5,0x1
 3a6:	9fb5                	addw	a5,a5,a3
 3a8:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 3ac:	00074683          	lbu	a3,0(a4)
 3b0:	fd06879b          	addiw	a5,a3,-48
 3b4:	0ff7f793          	zext.b	a5,a5
 3b8:	fef671e3          	bgeu	a2,a5,39a <atoi+0x1c>
    return n;
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
    n = 0;
 3c2:	4501                	li	a0,0
 3c4:	bfe5                	j	3bc <atoi+0x3e>

00000000000003c6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 3cc:	02b57463          	bgeu	a0,a1,3f4 <memmove+0x2e>
    {
        while (n-- > 0)
 3d0:	00c05f63          	blez	a2,3ee <memmove+0x28>
 3d4:	1602                	slli	a2,a2,0x20
 3d6:	9201                	srli	a2,a2,0x20
 3d8:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 3dc:	872a                	mv	a4,a0
            *dst++ = *src++;
 3de:	0585                	addi	a1,a1,1
 3e0:	0705                	addi	a4,a4,1
 3e2:	fff5c683          	lbu	a3,-1(a1)
 3e6:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 3ea:	fee79ae3          	bne	a5,a4,3de <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret
        dst += n;
 3f4:	00c50733          	add	a4,a0,a2
        src += n;
 3f8:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 3fa:	fec05ae3          	blez	a2,3ee <memmove+0x28>
 3fe:	fff6079b          	addiw	a5,a2,-1
 402:	1782                	slli	a5,a5,0x20
 404:	9381                	srli	a5,a5,0x20
 406:	fff7c793          	not	a5,a5
 40a:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 40c:	15fd                	addi	a1,a1,-1
 40e:	177d                	addi	a4,a4,-1
 410:	0005c683          	lbu	a3,0(a1)
 414:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 418:	fee79ae3          	bne	a5,a4,40c <memmove+0x46>
 41c:	bfc9                	j	3ee <memmove+0x28>

000000000000041e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 424:	ca05                	beqz	a2,454 <memcmp+0x36>
 426:	fff6069b          	addiw	a3,a2,-1
 42a:	1682                	slli	a3,a3,0x20
 42c:	9281                	srli	a3,a3,0x20
 42e:	0685                	addi	a3,a3,1
 430:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 432:	00054783          	lbu	a5,0(a0)
 436:	0005c703          	lbu	a4,0(a1)
 43a:	00e79863          	bne	a5,a4,44a <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 43e:	0505                	addi	a0,a0,1
        p2++;
 440:	0585                	addi	a1,a1,1
    while (n-- > 0)
 442:	fed518e3          	bne	a0,a3,432 <memcmp+0x14>
    }
    return 0;
 446:	4501                	li	a0,0
 448:	a019                	j	44e <memcmp+0x30>
            return *p1 - *p2;
 44a:	40e7853b          	subw	a0,a5,a4
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
    return 0;
 454:	4501                	li	a0,0
 456:	bfe5                	j	44e <memcmp+0x30>

0000000000000458 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e406                	sd	ra,8(sp)
 45c:	e022                	sd	s0,0(sp)
 45e:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 460:	00000097          	auipc	ra,0x0
 464:	f66080e7          	jalr	-154(ra) # 3c6 <memmove>
}
 468:	60a2                	ld	ra,8(sp)
 46a:	6402                	ld	s0,0(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret

0000000000000470 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 470:	4885                	li	a7,1
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <exit>:
.global exit
exit:
 li a7, SYS_exit
 478:	4889                	li	a7,2
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <wait>:
.global wait
wait:
 li a7, SYS_wait
 480:	488d                	li	a7,3
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 488:	4891                	li	a7,4
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <read>:
.global read
read:
 li a7, SYS_read
 490:	4895                	li	a7,5
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <write>:
.global write
write:
 li a7, SYS_write
 498:	48c1                	li	a7,16
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <close>:
.global close
close:
 li a7, SYS_close
 4a0:	48d5                	li	a7,21
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a8:	4899                	li	a7,6
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4b0:	489d                	li	a7,7
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <open>:
.global open
open:
 li a7, SYS_open
 4b8:	48bd                	li	a7,15
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4c0:	48c5                	li	a7,17
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c8:	48c9                	li	a7,18
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4d0:	48a1                	li	a7,8
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <link>:
.global link
link:
 li a7, SYS_link
 4d8:	48cd                	li	a7,19
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e0:	48d1                	li	a7,20
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4e8:	48a5                	li	a7,9
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f0:	48a9                	li	a7,10
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4f8:	48ad                	li	a7,11
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 500:	48b1                	li	a7,12
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 508:	48b5                	li	a7,13
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 510:	48b9                	li	a7,14
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <ps>:
.global ps
ps:
 li a7, SYS_ps
 518:	48d9                	li	a7,22
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 520:	48dd                	li	a7,23
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 528:	48e1                	li	a7,24
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 530:	1101                	addi	sp,sp,-32
 532:	ec06                	sd	ra,24(sp)
 534:	e822                	sd	s0,16(sp)
 536:	1000                	addi	s0,sp,32
 538:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 53c:	4605                	li	a2,1
 53e:	fef40593          	addi	a1,s0,-17
 542:	00000097          	auipc	ra,0x0
 546:	f56080e7          	jalr	-170(ra) # 498 <write>
}
 54a:	60e2                	ld	ra,24(sp)
 54c:	6442                	ld	s0,16(sp)
 54e:	6105                	addi	sp,sp,32
 550:	8082                	ret

0000000000000552 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 552:	7139                	addi	sp,sp,-64
 554:	fc06                	sd	ra,56(sp)
 556:	f822                	sd	s0,48(sp)
 558:	f426                	sd	s1,40(sp)
 55a:	f04a                	sd	s2,32(sp)
 55c:	ec4e                	sd	s3,24(sp)
 55e:	0080                	addi	s0,sp,64
 560:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 562:	c299                	beqz	a3,568 <printint+0x16>
 564:	0805c963          	bltz	a1,5f6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 568:	2581                	sext.w	a1,a1
  neg = 0;
 56a:	4881                	li	a7,0
 56c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 570:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 572:	2601                	sext.w	a2,a2
 574:	00000517          	auipc	a0,0x0
 578:	4ec50513          	addi	a0,a0,1260 # a60 <digits>
 57c:	883a                	mv	a6,a4
 57e:	2705                	addiw	a4,a4,1
 580:	02c5f7bb          	remuw	a5,a1,a2
 584:	1782                	slli	a5,a5,0x20
 586:	9381                	srli	a5,a5,0x20
 588:	97aa                	add	a5,a5,a0
 58a:	0007c783          	lbu	a5,0(a5)
 58e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 592:	0005879b          	sext.w	a5,a1
 596:	02c5d5bb          	divuw	a1,a1,a2
 59a:	0685                	addi	a3,a3,1
 59c:	fec7f0e3          	bgeu	a5,a2,57c <printint+0x2a>
  if(neg)
 5a0:	00088c63          	beqz	a7,5b8 <printint+0x66>
    buf[i++] = '-';
 5a4:	fd070793          	addi	a5,a4,-48
 5a8:	00878733          	add	a4,a5,s0
 5ac:	02d00793          	li	a5,45
 5b0:	fef70823          	sb	a5,-16(a4)
 5b4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5b8:	02e05863          	blez	a4,5e8 <printint+0x96>
 5bc:	fc040793          	addi	a5,s0,-64
 5c0:	00e78933          	add	s2,a5,a4
 5c4:	fff78993          	addi	s3,a5,-1
 5c8:	99ba                	add	s3,s3,a4
 5ca:	377d                	addiw	a4,a4,-1
 5cc:	1702                	slli	a4,a4,0x20
 5ce:	9301                	srli	a4,a4,0x20
 5d0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d4:	fff94583          	lbu	a1,-1(s2)
 5d8:	8526                	mv	a0,s1
 5da:	00000097          	auipc	ra,0x0
 5de:	f56080e7          	jalr	-170(ra) # 530 <putc>
  while(--i >= 0)
 5e2:	197d                	addi	s2,s2,-1
 5e4:	ff3918e3          	bne	s2,s3,5d4 <printint+0x82>
}
 5e8:	70e2                	ld	ra,56(sp)
 5ea:	7442                	ld	s0,48(sp)
 5ec:	74a2                	ld	s1,40(sp)
 5ee:	7902                	ld	s2,32(sp)
 5f0:	69e2                	ld	s3,24(sp)
 5f2:	6121                	addi	sp,sp,64
 5f4:	8082                	ret
    x = -xx;
 5f6:	40b005bb          	negw	a1,a1
    neg = 1;
 5fa:	4885                	li	a7,1
    x = -xx;
 5fc:	bf85                	j	56c <printint+0x1a>

00000000000005fe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fe:	7119                	addi	sp,sp,-128
 600:	fc86                	sd	ra,120(sp)
 602:	f8a2                	sd	s0,112(sp)
 604:	f4a6                	sd	s1,104(sp)
 606:	f0ca                	sd	s2,96(sp)
 608:	ecce                	sd	s3,88(sp)
 60a:	e8d2                	sd	s4,80(sp)
 60c:	e4d6                	sd	s5,72(sp)
 60e:	e0da                	sd	s6,64(sp)
 610:	fc5e                	sd	s7,56(sp)
 612:	f862                	sd	s8,48(sp)
 614:	f466                	sd	s9,40(sp)
 616:	f06a                	sd	s10,32(sp)
 618:	ec6e                	sd	s11,24(sp)
 61a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 61c:	0005c903          	lbu	s2,0(a1)
 620:	18090f63          	beqz	s2,7be <vprintf+0x1c0>
 624:	8aaa                	mv	s5,a0
 626:	8b32                	mv	s6,a2
 628:	00158493          	addi	s1,a1,1
  state = 0;
 62c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 62e:	02500a13          	li	s4,37
 632:	4c55                	li	s8,21
 634:	00000c97          	auipc	s9,0x0
 638:	3d4c8c93          	addi	s9,s9,980 # a08 <malloc+0x146>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63c:	02800d93          	li	s11,40
  putc(fd, 'x');
 640:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	00000b97          	auipc	s7,0x0
 646:	41eb8b93          	addi	s7,s7,1054 # a60 <digits>
 64a:	a839                	j	668 <vprintf+0x6a>
        putc(fd, c);
 64c:	85ca                	mv	a1,s2
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	ee0080e7          	jalr	-288(ra) # 530 <putc>
 658:	a019                	j	65e <vprintf+0x60>
    } else if(state == '%'){
 65a:	01498d63          	beq	s3,s4,674 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 65e:	0485                	addi	s1,s1,1
 660:	fff4c903          	lbu	s2,-1(s1)
 664:	14090d63          	beqz	s2,7be <vprintf+0x1c0>
    if(state == 0){
 668:	fe0999e3          	bnez	s3,65a <vprintf+0x5c>
      if(c == '%'){
 66c:	ff4910e3          	bne	s2,s4,64c <vprintf+0x4e>
        state = '%';
 670:	89d2                	mv	s3,s4
 672:	b7f5                	j	65e <vprintf+0x60>
      if(c == 'd'){
 674:	11490c63          	beq	s2,s4,78c <vprintf+0x18e>
 678:	f9d9079b          	addiw	a5,s2,-99
 67c:	0ff7f793          	zext.b	a5,a5
 680:	10fc6e63          	bltu	s8,a5,79c <vprintf+0x19e>
 684:	f9d9079b          	addiw	a5,s2,-99
 688:	0ff7f713          	zext.b	a4,a5
 68c:	10ec6863          	bltu	s8,a4,79c <vprintf+0x19e>
 690:	00271793          	slli	a5,a4,0x2
 694:	97e6                	add	a5,a5,s9
 696:	439c                	lw	a5,0(a5)
 698:	97e6                	add	a5,a5,s9
 69a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 69c:	008b0913          	addi	s2,s6,8
 6a0:	4685                	li	a3,1
 6a2:	4629                	li	a2,10
 6a4:	000b2583          	lw	a1,0(s6)
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	ea8080e7          	jalr	-344(ra) # 552 <printint>
 6b2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b765                	j	65e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	008b0913          	addi	s2,s6,8
 6bc:	4681                	li	a3,0
 6be:	4629                	li	a2,10
 6c0:	000b2583          	lw	a1,0(s6)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e8c080e7          	jalr	-372(ra) # 552 <printint>
 6ce:	8b4a                	mv	s6,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b771                	j	65e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6d4:	008b0913          	addi	s2,s6,8
 6d8:	4681                	li	a3,0
 6da:	866a                	mv	a2,s10
 6dc:	000b2583          	lw	a1,0(s6)
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e70080e7          	jalr	-400(ra) # 552 <printint>
 6ea:	8b4a                	mv	s6,s2
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bf85                	j	65e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6f0:	008b0793          	addi	a5,s6,8
 6f4:	f8f43423          	sd	a5,-120(s0)
 6f8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6fc:	03000593          	li	a1,48
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	e2e080e7          	jalr	-466(ra) # 530 <putc>
  putc(fd, 'x');
 70a:	07800593          	li	a1,120
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e20080e7          	jalr	-480(ra) # 530 <putc>
 718:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71a:	03c9d793          	srli	a5,s3,0x3c
 71e:	97de                	add	a5,a5,s7
 720:	0007c583          	lbu	a1,0(a5)
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	e0a080e7          	jalr	-502(ra) # 530 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72e:	0992                	slli	s3,s3,0x4
 730:	397d                	addiw	s2,s2,-1
 732:	fe0914e3          	bnez	s2,71a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 736:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b70d                	j	65e <vprintf+0x60>
        s = va_arg(ap, char*);
 73e:	008b0913          	addi	s2,s6,8
 742:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 746:	02098163          	beqz	s3,768 <vprintf+0x16a>
        while(*s != 0){
 74a:	0009c583          	lbu	a1,0(s3)
 74e:	c5ad                	beqz	a1,7b8 <vprintf+0x1ba>
          putc(fd, *s);
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	dde080e7          	jalr	-546(ra) # 530 <putc>
          s++;
 75a:	0985                	addi	s3,s3,1
        while(*s != 0){
 75c:	0009c583          	lbu	a1,0(s3)
 760:	f9e5                	bnez	a1,750 <vprintf+0x152>
        s = va_arg(ap, char*);
 762:	8b4a                	mv	s6,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	bde5                	j	65e <vprintf+0x60>
          s = "(null)";
 768:	00000997          	auipc	s3,0x0
 76c:	29898993          	addi	s3,s3,664 # a00 <malloc+0x13e>
        while(*s != 0){
 770:	85ee                	mv	a1,s11
 772:	bff9                	j	750 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 774:	008b0913          	addi	s2,s6,8
 778:	000b4583          	lbu	a1,0(s6)
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	db2080e7          	jalr	-590(ra) # 530 <putc>
 786:	8b4a                	mv	s6,s2
      state = 0;
 788:	4981                	li	s3,0
 78a:	bdd1                	j	65e <vprintf+0x60>
        putc(fd, c);
 78c:	85d2                	mv	a1,s4
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	da0080e7          	jalr	-608(ra) # 530 <putc>
      state = 0;
 798:	4981                	li	s3,0
 79a:	b5d1                	j	65e <vprintf+0x60>
        putc(fd, '%');
 79c:	85d2                	mv	a1,s4
 79e:	8556                	mv	a0,s5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	d90080e7          	jalr	-624(ra) # 530 <putc>
        putc(fd, c);
 7a8:	85ca                	mv	a1,s2
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	d84080e7          	jalr	-636(ra) # 530 <putc>
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	b565                	j	65e <vprintf+0x60>
        s = va_arg(ap, char*);
 7b8:	8b4a                	mv	s6,s2
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b54d                	j	65e <vprintf+0x60>
    }
  }
}
 7be:	70e6                	ld	ra,120(sp)
 7c0:	7446                	ld	s0,112(sp)
 7c2:	74a6                	ld	s1,104(sp)
 7c4:	7906                	ld	s2,96(sp)
 7c6:	69e6                	ld	s3,88(sp)
 7c8:	6a46                	ld	s4,80(sp)
 7ca:	6aa6                	ld	s5,72(sp)
 7cc:	6b06                	ld	s6,64(sp)
 7ce:	7be2                	ld	s7,56(sp)
 7d0:	7c42                	ld	s8,48(sp)
 7d2:	7ca2                	ld	s9,40(sp)
 7d4:	7d02                	ld	s10,32(sp)
 7d6:	6de2                	ld	s11,24(sp)
 7d8:	6109                	addi	sp,sp,128
 7da:	8082                	ret

00000000000007dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7dc:	715d                	addi	sp,sp,-80
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e010                	sd	a2,0(s0)
 7e6:	e414                	sd	a3,8(s0)
 7e8:	e818                	sd	a4,16(s0)
 7ea:	ec1c                	sd	a5,24(s0)
 7ec:	03043023          	sd	a6,32(s0)
 7f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f8:	8622                	mv	a2,s0
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e04080e7          	jalr	-508(ra) # 5fe <vprintf>
}
 802:	60e2                	ld	ra,24(sp)
 804:	6442                	ld	s0,16(sp)
 806:	6161                	addi	sp,sp,80
 808:	8082                	ret

000000000000080a <printf>:

void
printf(const char *fmt, ...)
{
 80a:	711d                	addi	sp,sp,-96
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e40c                	sd	a1,8(s0)
 814:	e810                	sd	a2,16(s0)
 816:	ec14                	sd	a3,24(s0)
 818:	f018                	sd	a4,32(s0)
 81a:	f41c                	sd	a5,40(s0)
 81c:	03043823          	sd	a6,48(s0)
 820:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 824:	00840613          	addi	a2,s0,8
 828:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82c:	85aa                	mv	a1,a0
 82e:	4505                	li	a0,1
 830:	00000097          	auipc	ra,0x0
 834:	dce080e7          	jalr	-562(ra) # 5fe <vprintf>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6125                	addi	sp,sp,96
 83e:	8082                	ret

0000000000000840 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 840:	1141                	addi	sp,sp,-16
 842:	e422                	sd	s0,8(sp)
 844:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 846:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	00000797          	auipc	a5,0x0
 84e:	7b67b783          	ld	a5,1974(a5) # 1000 <freep>
 852:	a02d                	j	87c <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 854:	4618                	lw	a4,8(a2)
 856:	9f2d                	addw	a4,a4,a1
 858:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 85c:	6398                	ld	a4,0(a5)
 85e:	6310                	ld	a2,0(a4)
 860:	a83d                	j	89e <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 862:	ff852703          	lw	a4,-8(a0)
 866:	9f31                	addw	a4,a4,a2
 868:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 86a:	ff053683          	ld	a3,-16(a0)
 86e:	a091                	j	8b2 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	6398                	ld	a4,0(a5)
 872:	00e7e463          	bltu	a5,a4,87a <free+0x3a>
 876:	00e6ea63          	bltu	a3,a4,88a <free+0x4a>
{
 87a:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87c:	fed7fae3          	bgeu	a5,a3,870 <free+0x30>
 880:	6398                	ld	a4,0(a5)
 882:	00e6e463          	bltu	a3,a4,88a <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 886:	fee7eae3          	bltu	a5,a4,87a <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 88a:	ff852583          	lw	a1,-8(a0)
 88e:	6390                	ld	a2,0(a5)
 890:	02059813          	slli	a6,a1,0x20
 894:	01c85713          	srli	a4,a6,0x1c
 898:	9736                	add	a4,a4,a3
 89a:	fae60de3          	beq	a2,a4,854 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 89e:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 8a2:	4790                	lw	a2,8(a5)
 8a4:	02061593          	slli	a1,a2,0x20
 8a8:	01c5d713          	srli	a4,a1,0x1c
 8ac:	973e                	add	a4,a4,a5
 8ae:	fae68ae3          	beq	a3,a4,862 <free+0x22>
        p->s.ptr = bp->s.ptr;
 8b2:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74f73623          	sd	a5,1868(a4) # 1000 <freep>
}
 8bc:	6422                	ld	s0,8(sp)
 8be:	0141                	addi	sp,sp,16
 8c0:	8082                	ret

00000000000008c2 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 8c2:	7139                	addi	sp,sp,-64
 8c4:	fc06                	sd	ra,56(sp)
 8c6:	f822                	sd	s0,48(sp)
 8c8:	f426                	sd	s1,40(sp)
 8ca:	f04a                	sd	s2,32(sp)
 8cc:	ec4e                	sd	s3,24(sp)
 8ce:	e852                	sd	s4,16(sp)
 8d0:	e456                	sd	s5,8(sp)
 8d2:	e05a                	sd	s6,0(sp)
 8d4:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8d6:	02051493          	slli	s1,a0,0x20
 8da:	9081                	srli	s1,s1,0x20
 8dc:	04bd                	addi	s1,s1,15
 8de:	8091                	srli	s1,s1,0x4
 8e0:	0014899b          	addiw	s3,s1,1
 8e4:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 8e6:	00000517          	auipc	a0,0x0
 8ea:	71a53503          	ld	a0,1818(a0) # 1000 <freep>
 8ee:	c515                	beqz	a0,91a <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 8f0:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 8f2:	4798                	lw	a4,8(a5)
 8f4:	02977f63          	bgeu	a4,s1,932 <malloc+0x70>
 8f8:	8a4e                	mv	s4,s3
 8fa:	0009871b          	sext.w	a4,s3
 8fe:	6685                	lui	a3,0x1
 900:	00d77363          	bgeu	a4,a3,906 <malloc+0x44>
 904:	6a05                	lui	s4,0x1
 906:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 90a:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 90e:	00000917          	auipc	s2,0x0
 912:	6f290913          	addi	s2,s2,1778 # 1000 <freep>
    if (p == (char *)-1)
 916:	5afd                	li	s5,-1
 918:	a895                	j	98c <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 91a:	00000797          	auipc	a5,0x0
 91e:	6f678793          	addi	a5,a5,1782 # 1010 <base>
 922:	00000717          	auipc	a4,0x0
 926:	6cf73f23          	sd	a5,1758(a4) # 1000 <freep>
 92a:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 92c:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 930:	b7e1                	j	8f8 <malloc+0x36>
            if (p->s.size == nunits)
 932:	02e48c63          	beq	s1,a4,96a <malloc+0xa8>
                p->s.size -= nunits;
 936:	4137073b          	subw	a4,a4,s3
 93a:	c798                	sw	a4,8(a5)
                p += p->s.size;
 93c:	02071693          	slli	a3,a4,0x20
 940:	01c6d713          	srli	a4,a3,0x1c
 944:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 946:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 94a:	00000717          	auipc	a4,0x0
 94e:	6aa73b23          	sd	a0,1718(a4) # 1000 <freep>
            return (void *)(p + 1);
 952:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 956:	70e2                	ld	ra,56(sp)
 958:	7442                	ld	s0,48(sp)
 95a:	74a2                	ld	s1,40(sp)
 95c:	7902                	ld	s2,32(sp)
 95e:	69e2                	ld	s3,24(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
 966:	6121                	addi	sp,sp,64
 968:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 96a:	6398                	ld	a4,0(a5)
 96c:	e118                	sd	a4,0(a0)
 96e:	bff1                	j	94a <malloc+0x88>
    hp->s.size = nu;
 970:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 974:	0541                	addi	a0,a0,16
 976:	00000097          	auipc	ra,0x0
 97a:	eca080e7          	jalr	-310(ra) # 840 <free>
    return freep;
 97e:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 982:	d971                	beqz	a0,956 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 984:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 986:	4798                	lw	a4,8(a5)
 988:	fa9775e3          	bgeu	a4,s1,932 <malloc+0x70>
        if (p == freep)
 98c:	00093703          	ld	a4,0(s2)
 990:	853e                	mv	a0,a5
 992:	fef719e3          	bne	a4,a5,984 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 996:	8552                	mv	a0,s4
 998:	00000097          	auipc	ra,0x0
 99c:	b68080e7          	jalr	-1176(ra) # 500 <sbrk>
    if (p == (char *)-1)
 9a0:	fd5518e3          	bne	a0,s5,970 <malloc+0xae>
                return 0;
 9a4:	4501                	li	a0,0
 9a6:	bf45                	j	956 <malloc+0x94>
