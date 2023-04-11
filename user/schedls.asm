
user/_schedls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    schedls();
   8:	00000097          	auipc	ra,0x0
   c:	508080e7          	jalr	1288(ra) # 510 <schedls>
    exit(0);
  10:	4501                	li	a0,0
  12:	00000097          	auipc	ra,0x0
  16:	456080e7          	jalr	1110(ra) # 468 <exit>

000000000000001a <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  1a:	1141                	addi	sp,sp,-16
  1c:	e422                	sd	s0,8(sp)
  1e:	0800                	addi	s0,sp,16
    lk->name = name;
  20:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  22:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  26:	57fd                	li	a5,-1
  28:	00f50823          	sb	a5,16(a0)
}
  2c:	6422                	ld	s0,8(sp)
  2e:	0141                	addi	sp,sp,16
  30:	8082                	ret

0000000000000032 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  32:	00054783          	lbu	a5,0(a0)
  36:	e399                	bnez	a5,3c <holding+0xa>
  38:	4501                	li	a0,0
}
  3a:	8082                	ret
{
  3c:	1101                	addi	sp,sp,-32
  3e:	ec06                	sd	ra,24(sp)
  40:	e822                	sd	s0,16(sp)
  42:	e426                	sd	s1,8(sp)
  44:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  46:	01054483          	lbu	s1,16(a0)
  4a:	00000097          	auipc	ra,0x0
  4e:	122080e7          	jalr	290(ra) # 16c <twhoami>
  52:	2501                	sext.w	a0,a0
  54:	40a48533          	sub	a0,s1,a0
  58:	00153513          	seqz	a0,a0
}
  5c:	60e2                	ld	ra,24(sp)
  5e:	6442                	ld	s0,16(sp)
  60:	64a2                	ld	s1,8(sp)
  62:	6105                	addi	sp,sp,32
  64:	8082                	ret

0000000000000066 <acquire>:

void acquire(struct lock *lk)
{
  66:	7179                	addi	sp,sp,-48
  68:	f406                	sd	ra,40(sp)
  6a:	f022                	sd	s0,32(sp)
  6c:	ec26                	sd	s1,24(sp)
  6e:	e84a                	sd	s2,16(sp)
  70:	e44e                	sd	s3,8(sp)
  72:	e052                	sd	s4,0(sp)
  74:	1800                	addi	s0,sp,48
  76:	8a2a                	mv	s4,a0
    if (holding(lk))
  78:	00000097          	auipc	ra,0x0
  7c:	fba080e7          	jalr	-70(ra) # 32 <holding>
  80:	e919                	bnez	a0,96 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  82:	ffca7493          	andi	s1,s4,-4
  86:	003a7913          	andi	s2,s4,3
  8a:	0039191b          	slliw	s2,s2,0x3
  8e:	4985                	li	s3,1
  90:	012999bb          	sllw	s3,s3,s2
  94:	a015                	j	b8 <acquire+0x52>
        printf("re-acquiring lock we already hold");
  96:	00001517          	auipc	a0,0x1
  9a:	90a50513          	addi	a0,a0,-1782 # 9a0 <malloc+0xee>
  9e:	00000097          	auipc	ra,0x0
  a2:	75c080e7          	jalr	1884(ra) # 7fa <printf>
        exit(-1);
  a6:	557d                	li	a0,-1
  a8:	00000097          	auipc	ra,0x0
  ac:	3c0080e7          	jalr	960(ra) # 468 <exit>
    {
        // give up the cpu for other threads
        tyield();
  b0:	00000097          	auipc	ra,0x0
  b4:	0b0080e7          	jalr	176(ra) # 160 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  b8:	4534a7af          	amoor.w.aq	a5,s3,(s1)
  bc:	0127d7bb          	srlw	a5,a5,s2
  c0:	0ff7f793          	zext.b	a5,a5
  c4:	f7f5                	bnez	a5,b0 <acquire+0x4a>
    }

    __sync_synchronize();
  c6:	0ff0000f          	fence

    lk->tid = twhoami();
  ca:	00000097          	auipc	ra,0x0
  ce:	0a2080e7          	jalr	162(ra) # 16c <twhoami>
  d2:	00aa0823          	sb	a0,16(s4)
}
  d6:	70a2                	ld	ra,40(sp)
  d8:	7402                	ld	s0,32(sp)
  da:	64e2                	ld	s1,24(sp)
  dc:	6942                	ld	s2,16(sp)
  de:	69a2                	ld	s3,8(sp)
  e0:	6a02                	ld	s4,0(sp)
  e2:	6145                	addi	sp,sp,48
  e4:	8082                	ret

00000000000000e6 <release>:

void release(struct lock *lk)
{
  e6:	1101                	addi	sp,sp,-32
  e8:	ec06                	sd	ra,24(sp)
  ea:	e822                	sd	s0,16(sp)
  ec:	e426                	sd	s1,8(sp)
  ee:	1000                	addi	s0,sp,32
  f0:	84aa                	mv	s1,a0
    if (!holding(lk))
  f2:	00000097          	auipc	ra,0x0
  f6:	f40080e7          	jalr	-192(ra) # 32 <holding>
  fa:	c11d                	beqz	a0,120 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
  fc:	57fd                	li	a5,-1
  fe:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 102:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 106:	0ff0000f          	fence
 10a:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 10e:	00000097          	auipc	ra,0x0
 112:	052080e7          	jalr	82(ra) # 160 <tyield>
}
 116:	60e2                	ld	ra,24(sp)
 118:	6442                	ld	s0,16(sp)
 11a:	64a2                	ld	s1,8(sp)
 11c:	6105                	addi	sp,sp,32
 11e:	8082                	ret
        printf("releasing lock we are not holding");
 120:	00001517          	auipc	a0,0x1
 124:	8a850513          	addi	a0,a0,-1880 # 9c8 <malloc+0x116>
 128:	00000097          	auipc	ra,0x0
 12c:	6d2080e7          	jalr	1746(ra) # 7fa <printf>
        exit(-1);
 130:	557d                	li	a0,-1
 132:	00000097          	auipc	ra,0x0
 136:	336080e7          	jalr	822(ra) # 468 <exit>

000000000000013a <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret

0000000000000146 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 146:	1141                	addi	sp,sp,-16
 148:	e422                	sd	s0,8(sp)
 14a:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 152:	1141                	addi	sp,sp,-16
 154:	e422                	sd	s0,8(sp)
 156:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 158:	4501                	li	a0,0
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret

0000000000000160 <tyield>:

void tyield()
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 166:	6422                	ld	s0,8(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret

000000000000016c <twhoami>:

uint8 twhoami()
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 172:	4501                	li	a0,0
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <tswtch>:
 17a:	00153023          	sd	ra,0(a0)
 17e:	00253423          	sd	sp,8(a0)
 182:	e900                	sd	s0,16(a0)
 184:	ed04                	sd	s1,24(a0)
 186:	03253023          	sd	s2,32(a0)
 18a:	03353423          	sd	s3,40(a0)
 18e:	03453823          	sd	s4,48(a0)
 192:	03553c23          	sd	s5,56(a0)
 196:	05653023          	sd	s6,64(a0)
 19a:	05753423          	sd	s7,72(a0)
 19e:	05853823          	sd	s8,80(a0)
 1a2:	05953c23          	sd	s9,88(a0)
 1a6:	07a53023          	sd	s10,96(a0)
 1aa:	07b53423          	sd	s11,104(a0)
 1ae:	0005b083          	ld	ra,0(a1)
 1b2:	0085b103          	ld	sp,8(a1)
 1b6:	6980                	ld	s0,16(a1)
 1b8:	6d84                	ld	s1,24(a1)
 1ba:	0205b903          	ld	s2,32(a1)
 1be:	0285b983          	ld	s3,40(a1)
 1c2:	0305ba03          	ld	s4,48(a1)
 1c6:	0385ba83          	ld	s5,56(a1)
 1ca:	0405bb03          	ld	s6,64(a1)
 1ce:	0485bb83          	ld	s7,72(a1)
 1d2:	0505bc03          	ld	s8,80(a1)
 1d6:	0585bc83          	ld	s9,88(a1)
 1da:	0605bd03          	ld	s10,96(a1)
 1de:	0685bd83          	ld	s11,104(a1)
 1e2:	8082                	ret

00000000000001e4 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 1ec:	00000097          	auipc	ra,0x0
 1f0:	e14080e7          	jalr	-492(ra) # 0 <main>
    exit(res);
 1f4:	00000097          	auipc	ra,0x0
 1f8:	274080e7          	jalr	628(ra) # 468 <exit>

00000000000001fc <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 202:	87aa                	mv	a5,a0
 204:	0585                	addi	a1,a1,1
 206:	0785                	addi	a5,a5,1
 208:	fff5c703          	lbu	a4,-1(a1)
 20c:	fee78fa3          	sb	a4,-1(a5)
 210:	fb75                	bnez	a4,204 <strcpy+0x8>
        ;
    return os;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <strcmp>:

int strcmp(const char *p, const char *q)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 21e:	00054783          	lbu	a5,0(a0)
 222:	cb91                	beqz	a5,236 <strcmp+0x1e>
 224:	0005c703          	lbu	a4,0(a1)
 228:	00f71763          	bne	a4,a5,236 <strcmp+0x1e>
        p++, q++;
 22c:	0505                	addi	a0,a0,1
 22e:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 230:	00054783          	lbu	a5,0(a0)
 234:	fbe5                	bnez	a5,224 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 236:	0005c503          	lbu	a0,0(a1)
}
 23a:	40a7853b          	subw	a0,a5,a0
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret

0000000000000244 <strlen>:

uint strlen(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 24a:	00054783          	lbu	a5,0(a0)
 24e:	cf91                	beqz	a5,26a <strlen+0x26>
 250:	0505                	addi	a0,a0,1
 252:	87aa                	mv	a5,a0
 254:	4685                	li	a3,1
 256:	9e89                	subw	a3,a3,a0
 258:	00f6853b          	addw	a0,a3,a5
 25c:	0785                	addi	a5,a5,1
 25e:	fff7c703          	lbu	a4,-1(a5)
 262:	fb7d                	bnez	a4,258 <strlen+0x14>
        ;
    return n;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
    for (n = 0; s[n]; n++)
 26a:	4501                	li	a0,0
 26c:	bfe5                	j	264 <strlen+0x20>

000000000000026e <memset>:

void *
memset(void *dst, int c, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 274:	ca19                	beqz	a2,28a <memset+0x1c>
 276:	87aa                	mv	a5,a0
 278:	1602                	slli	a2,a2,0x20
 27a:	9201                	srli	a2,a2,0x20
 27c:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 280:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 284:	0785                	addi	a5,a5,1
 286:	fee79de3          	bne	a5,a4,280 <memset+0x12>
    }
    return dst;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <strchr>:

char *
strchr(const char *s, char c)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
    for (; *s; s++)
 296:	00054783          	lbu	a5,0(a0)
 29a:	cb99                	beqz	a5,2b0 <strchr+0x20>
        if (*s == c)
 29c:	00f58763          	beq	a1,a5,2aa <strchr+0x1a>
    for (; *s; s++)
 2a0:	0505                	addi	a0,a0,1
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbfd                	bnez	a5,29c <strchr+0xc>
            return (char *)s;
    return 0;
 2a8:	4501                	li	a0,0
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
    return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <strchr+0x1a>

00000000000002b4 <gets>:

char *
gets(char *buf, int max)
{
 2b4:	711d                	addi	sp,sp,-96
 2b6:	ec86                	sd	ra,88(sp)
 2b8:	e8a2                	sd	s0,80(sp)
 2ba:	e4a6                	sd	s1,72(sp)
 2bc:	e0ca                	sd	s2,64(sp)
 2be:	fc4e                	sd	s3,56(sp)
 2c0:	f852                	sd	s4,48(sp)
 2c2:	f456                	sd	s5,40(sp)
 2c4:	f05a                	sd	s6,32(sp)
 2c6:	ec5e                	sd	s7,24(sp)
 2c8:	1080                	addi	s0,sp,96
 2ca:	8baa                	mv	s7,a0
 2cc:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 2ce:	892a                	mv	s2,a0
 2d0:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 2d2:	4aa9                	li	s5,10
 2d4:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 2d6:	89a6                	mv	s3,s1
 2d8:	2485                	addiw	s1,s1,1
 2da:	0344d863          	bge	s1,s4,30a <gets+0x56>
        cc = read(0, &c, 1);
 2de:	4605                	li	a2,1
 2e0:	faf40593          	addi	a1,s0,-81
 2e4:	4501                	li	a0,0
 2e6:	00000097          	auipc	ra,0x0
 2ea:	19a080e7          	jalr	410(ra) # 480 <read>
        if (cc < 1)
 2ee:	00a05e63          	blez	a0,30a <gets+0x56>
        buf[i++] = c;
 2f2:	faf44783          	lbu	a5,-81(s0)
 2f6:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 2fa:	01578763          	beq	a5,s5,308 <gets+0x54>
 2fe:	0905                	addi	s2,s2,1
 300:	fd679be3          	bne	a5,s6,2d6 <gets+0x22>
    for (i = 0; i + 1 < max;)
 304:	89a6                	mv	s3,s1
 306:	a011                	j	30a <gets+0x56>
 308:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 30a:	99de                	add	s3,s3,s7
 30c:	00098023          	sb	zero,0(s3)
    return buf;
}
 310:	855e                	mv	a0,s7
 312:	60e6                	ld	ra,88(sp)
 314:	6446                	ld	s0,80(sp)
 316:	64a6                	ld	s1,72(sp)
 318:	6906                	ld	s2,64(sp)
 31a:	79e2                	ld	s3,56(sp)
 31c:	7a42                	ld	s4,48(sp)
 31e:	7aa2                	ld	s5,40(sp)
 320:	7b02                	ld	s6,32(sp)
 322:	6be2                	ld	s7,24(sp)
 324:	6125                	addi	sp,sp,96
 326:	8082                	ret

0000000000000328 <stat>:

int stat(const char *n, struct stat *st)
{
 328:	1101                	addi	sp,sp,-32
 32a:	ec06                	sd	ra,24(sp)
 32c:	e822                	sd	s0,16(sp)
 32e:	e426                	sd	s1,8(sp)
 330:	e04a                	sd	s2,0(sp)
 332:	1000                	addi	s0,sp,32
 334:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 336:	4581                	li	a1,0
 338:	00000097          	auipc	ra,0x0
 33c:	170080e7          	jalr	368(ra) # 4a8 <open>
    if (fd < 0)
 340:	02054563          	bltz	a0,36a <stat+0x42>
 344:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 346:	85ca                	mv	a1,s2
 348:	00000097          	auipc	ra,0x0
 34c:	178080e7          	jalr	376(ra) # 4c0 <fstat>
 350:	892a                	mv	s2,a0
    close(fd);
 352:	8526                	mv	a0,s1
 354:	00000097          	auipc	ra,0x0
 358:	13c080e7          	jalr	316(ra) # 490 <close>
    return r;
}
 35c:	854a                	mv	a0,s2
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	64a2                	ld	s1,8(sp)
 364:	6902                	ld	s2,0(sp)
 366:	6105                	addi	sp,sp,32
 368:	8082                	ret
        return -1;
 36a:	597d                	li	s2,-1
 36c:	bfc5                	j	35c <stat+0x34>

000000000000036e <atoi>:

int atoi(const char *s)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 374:	00054683          	lbu	a3,0(a0)
 378:	fd06879b          	addiw	a5,a3,-48
 37c:	0ff7f793          	zext.b	a5,a5
 380:	4625                	li	a2,9
 382:	02f66863          	bltu	a2,a5,3b2 <atoi+0x44>
 386:	872a                	mv	a4,a0
    n = 0;
 388:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 38a:	0705                	addi	a4,a4,1
 38c:	0025179b          	slliw	a5,a0,0x2
 390:	9fa9                	addw	a5,a5,a0
 392:	0017979b          	slliw	a5,a5,0x1
 396:	9fb5                	addw	a5,a5,a3
 398:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 39c:	00074683          	lbu	a3,0(a4)
 3a0:	fd06879b          	addiw	a5,a3,-48
 3a4:	0ff7f793          	zext.b	a5,a5
 3a8:	fef671e3          	bgeu	a2,a5,38a <atoi+0x1c>
    return n;
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
    n = 0;
 3b2:	4501                	li	a0,0
 3b4:	bfe5                	j	3ac <atoi+0x3e>

00000000000003b6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e422                	sd	s0,8(sp)
 3ba:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 3bc:	02b57463          	bgeu	a0,a1,3e4 <memmove+0x2e>
    {
        while (n-- > 0)
 3c0:	00c05f63          	blez	a2,3de <memmove+0x28>
 3c4:	1602                	slli	a2,a2,0x20
 3c6:	9201                	srli	a2,a2,0x20
 3c8:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 3cc:	872a                	mv	a4,a0
            *dst++ = *src++;
 3ce:	0585                	addi	a1,a1,1
 3d0:	0705                	addi	a4,a4,1
 3d2:	fff5c683          	lbu	a3,-1(a1)
 3d6:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 3da:	fee79ae3          	bne	a5,a4,3ce <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 3de:	6422                	ld	s0,8(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret
        dst += n;
 3e4:	00c50733          	add	a4,a0,a2
        src += n;
 3e8:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 3ea:	fec05ae3          	blez	a2,3de <memmove+0x28>
 3ee:	fff6079b          	addiw	a5,a2,-1
 3f2:	1782                	slli	a5,a5,0x20
 3f4:	9381                	srli	a5,a5,0x20
 3f6:	fff7c793          	not	a5,a5
 3fa:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 3fc:	15fd                	addi	a1,a1,-1
 3fe:	177d                	addi	a4,a4,-1
 400:	0005c683          	lbu	a3,0(a1)
 404:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 408:	fee79ae3          	bne	a5,a4,3fc <memmove+0x46>
 40c:	bfc9                	j	3de <memmove+0x28>

000000000000040e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 414:	ca05                	beqz	a2,444 <memcmp+0x36>
 416:	fff6069b          	addiw	a3,a2,-1
 41a:	1682                	slli	a3,a3,0x20
 41c:	9281                	srli	a3,a3,0x20
 41e:	0685                	addi	a3,a3,1
 420:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 422:	00054783          	lbu	a5,0(a0)
 426:	0005c703          	lbu	a4,0(a1)
 42a:	00e79863          	bne	a5,a4,43a <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 42e:	0505                	addi	a0,a0,1
        p2++;
 430:	0585                	addi	a1,a1,1
    while (n-- > 0)
 432:	fed518e3          	bne	a0,a3,422 <memcmp+0x14>
    }
    return 0;
 436:	4501                	li	a0,0
 438:	a019                	j	43e <memcmp+0x30>
            return *p1 - *p2;
 43a:	40e7853b          	subw	a0,a5,a4
}
 43e:	6422                	ld	s0,8(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret
    return 0;
 444:	4501                	li	a0,0
 446:	bfe5                	j	43e <memcmp+0x30>

0000000000000448 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 448:	1141                	addi	sp,sp,-16
 44a:	e406                	sd	ra,8(sp)
 44c:	e022                	sd	s0,0(sp)
 44e:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 450:	00000097          	auipc	ra,0x0
 454:	f66080e7          	jalr	-154(ra) # 3b6 <memmove>
}
 458:	60a2                	ld	ra,8(sp)
 45a:	6402                	ld	s0,0(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret

0000000000000460 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 460:	4885                	li	a7,1
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <exit>:
.global exit
exit:
 li a7, SYS_exit
 468:	4889                	li	a7,2
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <wait>:
.global wait
wait:
 li a7, SYS_wait
 470:	488d                	li	a7,3
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 478:	4891                	li	a7,4
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <read>:
.global read
read:
 li a7, SYS_read
 480:	4895                	li	a7,5
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <write>:
.global write
write:
 li a7, SYS_write
 488:	48c1                	li	a7,16
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <close>:
.global close
close:
 li a7, SYS_close
 490:	48d5                	li	a7,21
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <kill>:
.global kill
kill:
 li a7, SYS_kill
 498:	4899                	li	a7,6
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a0:	489d                	li	a7,7
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <open>:
.global open
open:
 li a7, SYS_open
 4a8:	48bd                	li	a7,15
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b0:	48c5                	li	a7,17
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b8:	48c9                	li	a7,18
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c0:	48a1                	li	a7,8
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <link>:
.global link
link:
 li a7, SYS_link
 4c8:	48cd                	li	a7,19
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d0:	48d1                	li	a7,20
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d8:	48a5                	li	a7,9
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e0:	48a9                	li	a7,10
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e8:	48ad                	li	a7,11
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f0:	48b1                	li	a7,12
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4f8:	48b5                	li	a7,13
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 500:	48b9                	li	a7,14
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <ps>:
.global ps
ps:
 li a7, SYS_ps
 508:	48d9                	li	a7,22
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 510:	48dd                	li	a7,23
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 518:	48e1                	li	a7,24
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 520:	1101                	addi	sp,sp,-32
 522:	ec06                	sd	ra,24(sp)
 524:	e822                	sd	s0,16(sp)
 526:	1000                	addi	s0,sp,32
 528:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 52c:	4605                	li	a2,1
 52e:	fef40593          	addi	a1,s0,-17
 532:	00000097          	auipc	ra,0x0
 536:	f56080e7          	jalr	-170(ra) # 488 <write>
}
 53a:	60e2                	ld	ra,24(sp)
 53c:	6442                	ld	s0,16(sp)
 53e:	6105                	addi	sp,sp,32
 540:	8082                	ret

0000000000000542 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 542:	7139                	addi	sp,sp,-64
 544:	fc06                	sd	ra,56(sp)
 546:	f822                	sd	s0,48(sp)
 548:	f426                	sd	s1,40(sp)
 54a:	f04a                	sd	s2,32(sp)
 54c:	ec4e                	sd	s3,24(sp)
 54e:	0080                	addi	s0,sp,64
 550:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 552:	c299                	beqz	a3,558 <printint+0x16>
 554:	0805c963          	bltz	a1,5e6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 558:	2581                	sext.w	a1,a1
  neg = 0;
 55a:	4881                	li	a7,0
 55c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 560:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 562:	2601                	sext.w	a2,a2
 564:	00000517          	auipc	a0,0x0
 568:	4ec50513          	addi	a0,a0,1260 # a50 <digits>
 56c:	883a                	mv	a6,a4
 56e:	2705                	addiw	a4,a4,1
 570:	02c5f7bb          	remuw	a5,a1,a2
 574:	1782                	slli	a5,a5,0x20
 576:	9381                	srli	a5,a5,0x20
 578:	97aa                	add	a5,a5,a0
 57a:	0007c783          	lbu	a5,0(a5)
 57e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 582:	0005879b          	sext.w	a5,a1
 586:	02c5d5bb          	divuw	a1,a1,a2
 58a:	0685                	addi	a3,a3,1
 58c:	fec7f0e3          	bgeu	a5,a2,56c <printint+0x2a>
  if(neg)
 590:	00088c63          	beqz	a7,5a8 <printint+0x66>
    buf[i++] = '-';
 594:	fd070793          	addi	a5,a4,-48
 598:	00878733          	add	a4,a5,s0
 59c:	02d00793          	li	a5,45
 5a0:	fef70823          	sb	a5,-16(a4)
 5a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5a8:	02e05863          	blez	a4,5d8 <printint+0x96>
 5ac:	fc040793          	addi	a5,s0,-64
 5b0:	00e78933          	add	s2,a5,a4
 5b4:	fff78993          	addi	s3,a5,-1
 5b8:	99ba                	add	s3,s3,a4
 5ba:	377d                	addiw	a4,a4,-1
 5bc:	1702                	slli	a4,a4,0x20
 5be:	9301                	srli	a4,a4,0x20
 5c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c4:	fff94583          	lbu	a1,-1(s2)
 5c8:	8526                	mv	a0,s1
 5ca:	00000097          	auipc	ra,0x0
 5ce:	f56080e7          	jalr	-170(ra) # 520 <putc>
  while(--i >= 0)
 5d2:	197d                	addi	s2,s2,-1
 5d4:	ff3918e3          	bne	s2,s3,5c4 <printint+0x82>
}
 5d8:	70e2                	ld	ra,56(sp)
 5da:	7442                	ld	s0,48(sp)
 5dc:	74a2                	ld	s1,40(sp)
 5de:	7902                	ld	s2,32(sp)
 5e0:	69e2                	ld	s3,24(sp)
 5e2:	6121                	addi	sp,sp,64
 5e4:	8082                	ret
    x = -xx;
 5e6:	40b005bb          	negw	a1,a1
    neg = 1;
 5ea:	4885                	li	a7,1
    x = -xx;
 5ec:	bf85                	j	55c <printint+0x1a>

00000000000005ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ee:	7119                	addi	sp,sp,-128
 5f0:	fc86                	sd	ra,120(sp)
 5f2:	f8a2                	sd	s0,112(sp)
 5f4:	f4a6                	sd	s1,104(sp)
 5f6:	f0ca                	sd	s2,96(sp)
 5f8:	ecce                	sd	s3,88(sp)
 5fa:	e8d2                	sd	s4,80(sp)
 5fc:	e4d6                	sd	s5,72(sp)
 5fe:	e0da                	sd	s6,64(sp)
 600:	fc5e                	sd	s7,56(sp)
 602:	f862                	sd	s8,48(sp)
 604:	f466                	sd	s9,40(sp)
 606:	f06a                	sd	s10,32(sp)
 608:	ec6e                	sd	s11,24(sp)
 60a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 60c:	0005c903          	lbu	s2,0(a1)
 610:	18090f63          	beqz	s2,7ae <vprintf+0x1c0>
 614:	8aaa                	mv	s5,a0
 616:	8b32                	mv	s6,a2
 618:	00158493          	addi	s1,a1,1
  state = 0;
 61c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 61e:	02500a13          	li	s4,37
 622:	4c55                	li	s8,21
 624:	00000c97          	auipc	s9,0x0
 628:	3d4c8c93          	addi	s9,s9,980 # 9f8 <malloc+0x146>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 62c:	02800d93          	li	s11,40
  putc(fd, 'x');
 630:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 632:	00000b97          	auipc	s7,0x0
 636:	41eb8b93          	addi	s7,s7,1054 # a50 <digits>
 63a:	a839                	j	658 <vprintf+0x6a>
        putc(fd, c);
 63c:	85ca                	mv	a1,s2
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	ee0080e7          	jalr	-288(ra) # 520 <putc>
 648:	a019                	j	64e <vprintf+0x60>
    } else if(state == '%'){
 64a:	01498d63          	beq	s3,s4,664 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 64e:	0485                	addi	s1,s1,1
 650:	fff4c903          	lbu	s2,-1(s1)
 654:	14090d63          	beqz	s2,7ae <vprintf+0x1c0>
    if(state == 0){
 658:	fe0999e3          	bnez	s3,64a <vprintf+0x5c>
      if(c == '%'){
 65c:	ff4910e3          	bne	s2,s4,63c <vprintf+0x4e>
        state = '%';
 660:	89d2                	mv	s3,s4
 662:	b7f5                	j	64e <vprintf+0x60>
      if(c == 'd'){
 664:	11490c63          	beq	s2,s4,77c <vprintf+0x18e>
 668:	f9d9079b          	addiw	a5,s2,-99
 66c:	0ff7f793          	zext.b	a5,a5
 670:	10fc6e63          	bltu	s8,a5,78c <vprintf+0x19e>
 674:	f9d9079b          	addiw	a5,s2,-99
 678:	0ff7f713          	zext.b	a4,a5
 67c:	10ec6863          	bltu	s8,a4,78c <vprintf+0x19e>
 680:	00271793          	slli	a5,a4,0x2
 684:	97e6                	add	a5,a5,s9
 686:	439c                	lw	a5,0(a5)
 688:	97e6                	add	a5,a5,s9
 68a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 68c:	008b0913          	addi	s2,s6,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000b2583          	lw	a1,0(s6)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	ea8080e7          	jalr	-344(ra) # 542 <printint>
 6a2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b765                	j	64e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	008b0913          	addi	s2,s6,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000b2583          	lw	a1,0(s6)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e8c080e7          	jalr	-372(ra) # 542 <printint>
 6be:	8b4a                	mv	s6,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b771                	j	64e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6c4:	008b0913          	addi	s2,s6,8
 6c8:	4681                	li	a3,0
 6ca:	866a                	mv	a2,s10
 6cc:	000b2583          	lw	a1,0(s6)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e70080e7          	jalr	-400(ra) # 542 <printint>
 6da:	8b4a                	mv	s6,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bf85                	j	64e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6e0:	008b0793          	addi	a5,s6,8
 6e4:	f8f43423          	sd	a5,-120(s0)
 6e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6ec:	03000593          	li	a1,48
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e2e080e7          	jalr	-466(ra) # 520 <putc>
  putc(fd, 'x');
 6fa:	07800593          	li	a1,120
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e20080e7          	jalr	-480(ra) # 520 <putc>
 708:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70a:	03c9d793          	srli	a5,s3,0x3c
 70e:	97de                	add	a5,a5,s7
 710:	0007c583          	lbu	a1,0(a5)
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	e0a080e7          	jalr	-502(ra) # 520 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71e:	0992                	slli	s3,s3,0x4
 720:	397d                	addiw	s2,s2,-1
 722:	fe0914e3          	bnez	s2,70a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 726:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b70d                	j	64e <vprintf+0x60>
        s = va_arg(ap, char*);
 72e:	008b0913          	addi	s2,s6,8
 732:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 736:	02098163          	beqz	s3,758 <vprintf+0x16a>
        while(*s != 0){
 73a:	0009c583          	lbu	a1,0(s3)
 73e:	c5ad                	beqz	a1,7a8 <vprintf+0x1ba>
          putc(fd, *s);
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	dde080e7          	jalr	-546(ra) # 520 <putc>
          s++;
 74a:	0985                	addi	s3,s3,1
        while(*s != 0){
 74c:	0009c583          	lbu	a1,0(s3)
 750:	f9e5                	bnez	a1,740 <vprintf+0x152>
        s = va_arg(ap, char*);
 752:	8b4a                	mv	s6,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bde5                	j	64e <vprintf+0x60>
          s = "(null)";
 758:	00000997          	auipc	s3,0x0
 75c:	29898993          	addi	s3,s3,664 # 9f0 <malloc+0x13e>
        while(*s != 0){
 760:	85ee                	mv	a1,s11
 762:	bff9                	j	740 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 764:	008b0913          	addi	s2,s6,8
 768:	000b4583          	lbu	a1,0(s6)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	db2080e7          	jalr	-590(ra) # 520 <putc>
 776:	8b4a                	mv	s6,s2
      state = 0;
 778:	4981                	li	s3,0
 77a:	bdd1                	j	64e <vprintf+0x60>
        putc(fd, c);
 77c:	85d2                	mv	a1,s4
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	da0080e7          	jalr	-608(ra) # 520 <putc>
      state = 0;
 788:	4981                	li	s3,0
 78a:	b5d1                	j	64e <vprintf+0x60>
        putc(fd, '%');
 78c:	85d2                	mv	a1,s4
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	d90080e7          	jalr	-624(ra) # 520 <putc>
        putc(fd, c);
 798:	85ca                	mv	a1,s2
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	d84080e7          	jalr	-636(ra) # 520 <putc>
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b565                	j	64e <vprintf+0x60>
        s = va_arg(ap, char*);
 7a8:	8b4a                	mv	s6,s2
      state = 0;
 7aa:	4981                	li	s3,0
 7ac:	b54d                	j	64e <vprintf+0x60>
    }
  }
}
 7ae:	70e6                	ld	ra,120(sp)
 7b0:	7446                	ld	s0,112(sp)
 7b2:	74a6                	ld	s1,104(sp)
 7b4:	7906                	ld	s2,96(sp)
 7b6:	69e6                	ld	s3,88(sp)
 7b8:	6a46                	ld	s4,80(sp)
 7ba:	6aa6                	ld	s5,72(sp)
 7bc:	6b06                	ld	s6,64(sp)
 7be:	7be2                	ld	s7,56(sp)
 7c0:	7c42                	ld	s8,48(sp)
 7c2:	7ca2                	ld	s9,40(sp)
 7c4:	7d02                	ld	s10,32(sp)
 7c6:	6de2                	ld	s11,24(sp)
 7c8:	6109                	addi	sp,sp,128
 7ca:	8082                	ret

00000000000007cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7cc:	715d                	addi	sp,sp,-80
 7ce:	ec06                	sd	ra,24(sp)
 7d0:	e822                	sd	s0,16(sp)
 7d2:	1000                	addi	s0,sp,32
 7d4:	e010                	sd	a2,0(s0)
 7d6:	e414                	sd	a3,8(s0)
 7d8:	e818                	sd	a4,16(s0)
 7da:	ec1c                	sd	a5,24(s0)
 7dc:	03043023          	sd	a6,32(s0)
 7e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e8:	8622                	mv	a2,s0
 7ea:	00000097          	auipc	ra,0x0
 7ee:	e04080e7          	jalr	-508(ra) # 5ee <vprintf>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6161                	addi	sp,sp,80
 7f8:	8082                	ret

00000000000007fa <printf>:

void
printf(const char *fmt, ...)
{
 7fa:	711d                	addi	sp,sp,-96
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e40c                	sd	a1,8(s0)
 804:	e810                	sd	a2,16(s0)
 806:	ec14                	sd	a3,24(s0)
 808:	f018                	sd	a4,32(s0)
 80a:	f41c                	sd	a5,40(s0)
 80c:	03043823          	sd	a6,48(s0)
 810:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	00840613          	addi	a2,s0,8
 818:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81c:	85aa                	mv	a1,a0
 81e:	4505                	li	a0,1
 820:	00000097          	auipc	ra,0x0
 824:	dce080e7          	jalr	-562(ra) # 5ee <vprintf>
}
 828:	60e2                	ld	ra,24(sp)
 82a:	6442                	ld	s0,16(sp)
 82c:	6125                	addi	sp,sp,96
 82e:	8082                	ret

0000000000000830 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 830:	1141                	addi	sp,sp,-16
 832:	e422                	sd	s0,8(sp)
 834:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 836:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83a:	00000797          	auipc	a5,0x0
 83e:	7c67b783          	ld	a5,1990(a5) # 1000 <freep>
 842:	a02d                	j	86c <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 844:	4618                	lw	a4,8(a2)
 846:	9f2d                	addw	a4,a4,a1
 848:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 84c:	6398                	ld	a4,0(a5)
 84e:	6310                	ld	a2,0(a4)
 850:	a83d                	j	88e <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 852:	ff852703          	lw	a4,-8(a0)
 856:	9f31                	addw	a4,a4,a2
 858:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 85a:	ff053683          	ld	a3,-16(a0)
 85e:	a091                	j	8a2 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	6398                	ld	a4,0(a5)
 862:	00e7e463          	bltu	a5,a4,86a <free+0x3a>
 866:	00e6ea63          	bltu	a3,a4,87a <free+0x4a>
{
 86a:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	fed7fae3          	bgeu	a5,a3,860 <free+0x30>
 870:	6398                	ld	a4,0(a5)
 872:	00e6e463          	bltu	a3,a4,87a <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 876:	fee7eae3          	bltu	a5,a4,86a <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 87a:	ff852583          	lw	a1,-8(a0)
 87e:	6390                	ld	a2,0(a5)
 880:	02059813          	slli	a6,a1,0x20
 884:	01c85713          	srli	a4,a6,0x1c
 888:	9736                	add	a4,a4,a3
 88a:	fae60de3          	beq	a2,a4,844 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 88e:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 892:	4790                	lw	a2,8(a5)
 894:	02061593          	slli	a1,a2,0x20
 898:	01c5d713          	srli	a4,a1,0x1c
 89c:	973e                	add	a4,a4,a5
 89e:	fae68ae3          	beq	a3,a4,852 <free+0x22>
        p->s.ptr = bp->s.ptr;
 8a2:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74f73e23          	sd	a5,1884(a4) # 1000 <freep>
}
 8ac:	6422                	ld	s0,8(sp)
 8ae:	0141                	addi	sp,sp,16
 8b0:	8082                	ret

00000000000008b2 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 8b2:	7139                	addi	sp,sp,-64
 8b4:	fc06                	sd	ra,56(sp)
 8b6:	f822                	sd	s0,48(sp)
 8b8:	f426                	sd	s1,40(sp)
 8ba:	f04a                	sd	s2,32(sp)
 8bc:	ec4e                	sd	s3,24(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
 8c4:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8c6:	02051493          	slli	s1,a0,0x20
 8ca:	9081                	srli	s1,s1,0x20
 8cc:	04bd                	addi	s1,s1,15
 8ce:	8091                	srli	s1,s1,0x4
 8d0:	0014899b          	addiw	s3,s1,1
 8d4:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 8d6:	00000517          	auipc	a0,0x0
 8da:	72a53503          	ld	a0,1834(a0) # 1000 <freep>
 8de:	c515                	beqz	a0,90a <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 8e0:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 8e2:	4798                	lw	a4,8(a5)
 8e4:	02977f63          	bgeu	a4,s1,922 <malloc+0x70>
 8e8:	8a4e                	mv	s4,s3
 8ea:	0009871b          	sext.w	a4,s3
 8ee:	6685                	lui	a3,0x1
 8f0:	00d77363          	bgeu	a4,a3,8f6 <malloc+0x44>
 8f4:	6a05                	lui	s4,0x1
 8f6:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 8fa:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 8fe:	00000917          	auipc	s2,0x0
 902:	70290913          	addi	s2,s2,1794 # 1000 <freep>
    if (p == (char *)-1)
 906:	5afd                	li	s5,-1
 908:	a895                	j	97c <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 90a:	00000797          	auipc	a5,0x0
 90e:	70678793          	addi	a5,a5,1798 # 1010 <base>
 912:	00000717          	auipc	a4,0x0
 916:	6ef73723          	sd	a5,1774(a4) # 1000 <freep>
 91a:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 91c:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 920:	b7e1                	j	8e8 <malloc+0x36>
            if (p->s.size == nunits)
 922:	02e48c63          	beq	s1,a4,95a <malloc+0xa8>
                p->s.size -= nunits;
 926:	4137073b          	subw	a4,a4,s3
 92a:	c798                	sw	a4,8(a5)
                p += p->s.size;
 92c:	02071693          	slli	a3,a4,0x20
 930:	01c6d713          	srli	a4,a3,0x1c
 934:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 936:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 93a:	00000717          	auipc	a4,0x0
 93e:	6ca73323          	sd	a0,1734(a4) # 1000 <freep>
            return (void *)(p + 1);
 942:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 946:	70e2                	ld	ra,56(sp)
 948:	7442                	ld	s0,48(sp)
 94a:	74a2                	ld	s1,40(sp)
 94c:	7902                	ld	s2,32(sp)
 94e:	69e2                	ld	s3,24(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
 956:	6121                	addi	sp,sp,64
 958:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 95a:	6398                	ld	a4,0(a5)
 95c:	e118                	sd	a4,0(a0)
 95e:	bff1                	j	93a <malloc+0x88>
    hp->s.size = nu;
 960:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 964:	0541                	addi	a0,a0,16
 966:	00000097          	auipc	ra,0x0
 96a:	eca080e7          	jalr	-310(ra) # 830 <free>
    return freep;
 96e:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 972:	d971                	beqz	a0,946 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 974:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 976:	4798                	lw	a4,8(a5)
 978:	fa9775e3          	bgeu	a4,s1,922 <malloc+0x70>
        if (p == freep)
 97c:	00093703          	ld	a4,0(s2)
 980:	853e                	mv	a0,a5
 982:	fef719e3          	bne	a4,a5,974 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 986:	8552                	mv	a0,s4
 988:	00000097          	auipc	ra,0x0
 98c:	b68080e7          	jalr	-1176(ra) # 4f0 <sbrk>
    if (p == (char *)-1)
 990:	fd5518e3          	bne	a0,s5,960 <malloc+0xae>
                return 0;
 994:	4501                	li	a0,0
 996:	bf45                	j	946 <malloc+0x94>
