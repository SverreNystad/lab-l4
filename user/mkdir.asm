
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	02091793          	slli	a5,s2,0x20
  20:	01d7d913          	srli	s2,a5,0x1d
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	504080e7          	jalr	1284(ra) # 52e <mkdir>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: mkdir files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	9c258593          	addi	a1,a1,-1598 # a00 <malloc+0xf0>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	7e2080e7          	jalr	2018(ra) # 82a <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	474080e7          	jalr	1140(ra) # 4c6 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	9bc58593          	addi	a1,a1,-1604 # a18 <malloc+0x108>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	7c4080e7          	jalr	1988(ra) # 82a <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	456080e7          	jalr	1110(ra) # 4c6 <exit>

0000000000000078 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
    lk->name = name;
  7e:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  80:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  84:	57fd                	li	a5,-1
  86:	00f50823          	sb	a5,16(a0)
}
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret

0000000000000090 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  90:	00054783          	lbu	a5,0(a0)
  94:	e399                	bnez	a5,9a <holding+0xa>
  96:	4501                	li	a0,0
}
  98:	8082                	ret
{
  9a:	1101                	addi	sp,sp,-32
  9c:	ec06                	sd	ra,24(sp)
  9e:	e822                	sd	s0,16(sp)
  a0:	e426                	sd	s1,8(sp)
  a2:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  a4:	01054483          	lbu	s1,16(a0)
  a8:	00000097          	auipc	ra,0x0
  ac:	122080e7          	jalr	290(ra) # 1ca <twhoami>
  b0:	2501                	sext.w	a0,a0
  b2:	40a48533          	sub	a0,s1,a0
  b6:	00153513          	seqz	a0,a0
}
  ba:	60e2                	ld	ra,24(sp)
  bc:	6442                	ld	s0,16(sp)
  be:	64a2                	ld	s1,8(sp)
  c0:	6105                	addi	sp,sp,32
  c2:	8082                	ret

00000000000000c4 <acquire>:

void acquire(struct lock *lk)
{
  c4:	7179                	addi	sp,sp,-48
  c6:	f406                	sd	ra,40(sp)
  c8:	f022                	sd	s0,32(sp)
  ca:	ec26                	sd	s1,24(sp)
  cc:	e84a                	sd	s2,16(sp)
  ce:	e44e                	sd	s3,8(sp)
  d0:	e052                	sd	s4,0(sp)
  d2:	1800                	addi	s0,sp,48
  d4:	8a2a                	mv	s4,a0
    if (holding(lk))
  d6:	00000097          	auipc	ra,0x0
  da:	fba080e7          	jalr	-70(ra) # 90 <holding>
  de:	e919                	bnez	a0,f4 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  e0:	ffca7493          	andi	s1,s4,-4
  e4:	003a7913          	andi	s2,s4,3
  e8:	0039191b          	slliw	s2,s2,0x3
  ec:	4985                	li	s3,1
  ee:	012999bb          	sllw	s3,s3,s2
  f2:	a015                	j	116 <acquire+0x52>
        printf("re-acquiring lock we already hold");
  f4:	00001517          	auipc	a0,0x1
  f8:	94450513          	addi	a0,a0,-1724 # a38 <malloc+0x128>
  fc:	00000097          	auipc	ra,0x0
 100:	75c080e7          	jalr	1884(ra) # 858 <printf>
        exit(-1);
 104:	557d                	li	a0,-1
 106:	00000097          	auipc	ra,0x0
 10a:	3c0080e7          	jalr	960(ra) # 4c6 <exit>
    {
        // give up the cpu for other threads
        tyield();
 10e:	00000097          	auipc	ra,0x0
 112:	0b0080e7          	jalr	176(ra) # 1be <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 116:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 11a:	0127d7bb          	srlw	a5,a5,s2
 11e:	0ff7f793          	zext.b	a5,a5
 122:	f7f5                	bnez	a5,10e <acquire+0x4a>
    }

    __sync_synchronize();
 124:	0ff0000f          	fence

    lk->tid = twhoami();
 128:	00000097          	auipc	ra,0x0
 12c:	0a2080e7          	jalr	162(ra) # 1ca <twhoami>
 130:	00aa0823          	sb	a0,16(s4)
}
 134:	70a2                	ld	ra,40(sp)
 136:	7402                	ld	s0,32(sp)
 138:	64e2                	ld	s1,24(sp)
 13a:	6942                	ld	s2,16(sp)
 13c:	69a2                	ld	s3,8(sp)
 13e:	6a02                	ld	s4,0(sp)
 140:	6145                	addi	sp,sp,48
 142:	8082                	ret

0000000000000144 <release>:

void release(struct lock *lk)
{
 144:	1101                	addi	sp,sp,-32
 146:	ec06                	sd	ra,24(sp)
 148:	e822                	sd	s0,16(sp)
 14a:	e426                	sd	s1,8(sp)
 14c:	1000                	addi	s0,sp,32
 14e:	84aa                	mv	s1,a0
    if (!holding(lk))
 150:	00000097          	auipc	ra,0x0
 154:	f40080e7          	jalr	-192(ra) # 90 <holding>
 158:	c11d                	beqz	a0,17e <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 15a:	57fd                	li	a5,-1
 15c:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 160:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 164:	0ff0000f          	fence
 168:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 16c:	00000097          	auipc	ra,0x0
 170:	052080e7          	jalr	82(ra) # 1be <tyield>
}
 174:	60e2                	ld	ra,24(sp)
 176:	6442                	ld	s0,16(sp)
 178:	64a2                	ld	s1,8(sp)
 17a:	6105                	addi	sp,sp,32
 17c:	8082                	ret
        printf("releasing lock we are not holding");
 17e:	00001517          	auipc	a0,0x1
 182:	8e250513          	addi	a0,a0,-1822 # a60 <malloc+0x150>
 186:	00000097          	auipc	ra,0x0
 18a:	6d2080e7          	jalr	1746(ra) # 858 <printf>
        exit(-1);
 18e:	557d                	li	a0,-1
 190:	00000097          	auipc	ra,0x0
 194:	336080e7          	jalr	822(ra) # 4c6 <exit>

0000000000000198 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret

00000000000001b0 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 1b6:	4501                	li	a0,0
 1b8:	6422                	ld	s0,8(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <tyield>:

void tyield()
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e422                	sd	s0,8(sp)
 1c2:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <twhoami>:

uint8 twhoami()
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 1d0:	4501                	li	a0,0
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <tswtch>:
 1d8:	00153023          	sd	ra,0(a0)
 1dc:	00253423          	sd	sp,8(a0)
 1e0:	e900                	sd	s0,16(a0)
 1e2:	ed04                	sd	s1,24(a0)
 1e4:	03253023          	sd	s2,32(a0)
 1e8:	03353423          	sd	s3,40(a0)
 1ec:	03453823          	sd	s4,48(a0)
 1f0:	03553c23          	sd	s5,56(a0)
 1f4:	05653023          	sd	s6,64(a0)
 1f8:	05753423          	sd	s7,72(a0)
 1fc:	05853823          	sd	s8,80(a0)
 200:	05953c23          	sd	s9,88(a0)
 204:	07a53023          	sd	s10,96(a0)
 208:	07b53423          	sd	s11,104(a0)
 20c:	0005b083          	ld	ra,0(a1)
 210:	0085b103          	ld	sp,8(a1)
 214:	6980                	ld	s0,16(a1)
 216:	6d84                	ld	s1,24(a1)
 218:	0205b903          	ld	s2,32(a1)
 21c:	0285b983          	ld	s3,40(a1)
 220:	0305ba03          	ld	s4,48(a1)
 224:	0385ba83          	ld	s5,56(a1)
 228:	0405bb03          	ld	s6,64(a1)
 22c:	0485bb83          	ld	s7,72(a1)
 230:	0505bc03          	ld	s8,80(a1)
 234:	0585bc83          	ld	s9,88(a1)
 238:	0605bd03          	ld	s10,96(a1)
 23c:	0685bd83          	ld	s11,104(a1)
 240:	8082                	ret

0000000000000242 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 242:	1141                	addi	sp,sp,-16
 244:	e406                	sd	ra,8(sp)
 246:	e022                	sd	s0,0(sp)
 248:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 24a:	00000097          	auipc	ra,0x0
 24e:	db6080e7          	jalr	-586(ra) # 0 <main>
    exit(res);
 252:	00000097          	auipc	ra,0x0
 256:	274080e7          	jalr	628(ra) # 4c6 <exit>

000000000000025a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e422                	sd	s0,8(sp)
 25e:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 260:	87aa                	mv	a5,a0
 262:	0585                	addi	a1,a1,1
 264:	0785                	addi	a5,a5,1
 266:	fff5c703          	lbu	a4,-1(a1)
 26a:	fee78fa3          	sb	a4,-1(a5)
 26e:	fb75                	bnez	a4,262 <strcpy+0x8>
        ;
    return os;
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret

0000000000000276 <strcmp>:

int strcmp(const char *p, const char *q)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 27c:	00054783          	lbu	a5,0(a0)
 280:	cb91                	beqz	a5,294 <strcmp+0x1e>
 282:	0005c703          	lbu	a4,0(a1)
 286:	00f71763          	bne	a4,a5,294 <strcmp+0x1e>
        p++, q++;
 28a:	0505                	addi	a0,a0,1
 28c:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 28e:	00054783          	lbu	a5,0(a0)
 292:	fbe5                	bnez	a5,282 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 294:	0005c503          	lbu	a0,0(a1)
}
 298:	40a7853b          	subw	a0,a5,a0
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <strlen>:

uint strlen(const char *s)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	cf91                	beqz	a5,2c8 <strlen+0x26>
 2ae:	0505                	addi	a0,a0,1
 2b0:	87aa                	mv	a5,a0
 2b2:	4685                	li	a3,1
 2b4:	9e89                	subw	a3,a3,a0
 2b6:	00f6853b          	addw	a0,a3,a5
 2ba:	0785                	addi	a5,a5,1
 2bc:	fff7c703          	lbu	a4,-1(a5)
 2c0:	fb7d                	bnez	a4,2b6 <strlen+0x14>
        ;
    return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
    for (n = 0; s[n]; n++)
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <strlen+0x20>

00000000000002cc <memset>:

void *
memset(void *dst, int c, uint n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 2d2:	ca19                	beqz	a2,2e8 <memset+0x1c>
 2d4:	87aa                	mv	a5,a0
 2d6:	1602                	slli	a2,a2,0x20
 2d8:	9201                	srli	a2,a2,0x20
 2da:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 2de:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 2e2:	0785                	addi	a5,a5,1
 2e4:	fee79de3          	bne	a5,a4,2de <memset+0x12>
    }
    return dst;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <strchr>:

char *
strchr(const char *s, char c)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
    for (; *s; s++)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	cb99                	beqz	a5,30e <strchr+0x20>
        if (*s == c)
 2fa:	00f58763          	beq	a1,a5,308 <strchr+0x1a>
    for (; *s; s++)
 2fe:	0505                	addi	a0,a0,1
 300:	00054783          	lbu	a5,0(a0)
 304:	fbfd                	bnez	a5,2fa <strchr+0xc>
            return (char *)s;
    return 0;
 306:	4501                	li	a0,0
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    return 0;
 30e:	4501                	li	a0,0
 310:	bfe5                	j	308 <strchr+0x1a>

0000000000000312 <gets>:

char *
gets(char *buf, int max)
{
 312:	711d                	addi	sp,sp,-96
 314:	ec86                	sd	ra,88(sp)
 316:	e8a2                	sd	s0,80(sp)
 318:	e4a6                	sd	s1,72(sp)
 31a:	e0ca                	sd	s2,64(sp)
 31c:	fc4e                	sd	s3,56(sp)
 31e:	f852                	sd	s4,48(sp)
 320:	f456                	sd	s5,40(sp)
 322:	f05a                	sd	s6,32(sp)
 324:	ec5e                	sd	s7,24(sp)
 326:	1080                	addi	s0,sp,96
 328:	8baa                	mv	s7,a0
 32a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 32c:	892a                	mv	s2,a0
 32e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 330:	4aa9                	li	s5,10
 332:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 334:	89a6                	mv	s3,s1
 336:	2485                	addiw	s1,s1,1
 338:	0344d863          	bge	s1,s4,368 <gets+0x56>
        cc = read(0, &c, 1);
 33c:	4605                	li	a2,1
 33e:	faf40593          	addi	a1,s0,-81
 342:	4501                	li	a0,0
 344:	00000097          	auipc	ra,0x0
 348:	19a080e7          	jalr	410(ra) # 4de <read>
        if (cc < 1)
 34c:	00a05e63          	blez	a0,368 <gets+0x56>
        buf[i++] = c;
 350:	faf44783          	lbu	a5,-81(s0)
 354:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 358:	01578763          	beq	a5,s5,366 <gets+0x54>
 35c:	0905                	addi	s2,s2,1
 35e:	fd679be3          	bne	a5,s6,334 <gets+0x22>
    for (i = 0; i + 1 < max;)
 362:	89a6                	mv	s3,s1
 364:	a011                	j	368 <gets+0x56>
 366:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 368:	99de                	add	s3,s3,s7
 36a:	00098023          	sb	zero,0(s3)
    return buf;
}
 36e:	855e                	mv	a0,s7
 370:	60e6                	ld	ra,88(sp)
 372:	6446                	ld	s0,80(sp)
 374:	64a6                	ld	s1,72(sp)
 376:	6906                	ld	s2,64(sp)
 378:	79e2                	ld	s3,56(sp)
 37a:	7a42                	ld	s4,48(sp)
 37c:	7aa2                	ld	s5,40(sp)
 37e:	7b02                	ld	s6,32(sp)
 380:	6be2                	ld	s7,24(sp)
 382:	6125                	addi	sp,sp,96
 384:	8082                	ret

0000000000000386 <stat>:

int stat(const char *n, struct stat *st)
{
 386:	1101                	addi	sp,sp,-32
 388:	ec06                	sd	ra,24(sp)
 38a:	e822                	sd	s0,16(sp)
 38c:	e426                	sd	s1,8(sp)
 38e:	e04a                	sd	s2,0(sp)
 390:	1000                	addi	s0,sp,32
 392:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 394:	4581                	li	a1,0
 396:	00000097          	auipc	ra,0x0
 39a:	170080e7          	jalr	368(ra) # 506 <open>
    if (fd < 0)
 39e:	02054563          	bltz	a0,3c8 <stat+0x42>
 3a2:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 3a4:	85ca                	mv	a1,s2
 3a6:	00000097          	auipc	ra,0x0
 3aa:	178080e7          	jalr	376(ra) # 51e <fstat>
 3ae:	892a                	mv	s2,a0
    close(fd);
 3b0:	8526                	mv	a0,s1
 3b2:	00000097          	auipc	ra,0x0
 3b6:	13c080e7          	jalr	316(ra) # 4ee <close>
    return r;
}
 3ba:	854a                	mv	a0,s2
 3bc:	60e2                	ld	ra,24(sp)
 3be:	6442                	ld	s0,16(sp)
 3c0:	64a2                	ld	s1,8(sp)
 3c2:	6902                	ld	s2,0(sp)
 3c4:	6105                	addi	sp,sp,32
 3c6:	8082                	ret
        return -1;
 3c8:	597d                	li	s2,-1
 3ca:	bfc5                	j	3ba <stat+0x34>

00000000000003cc <atoi>:

int atoi(const char *s)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 3d2:	00054683          	lbu	a3,0(a0)
 3d6:	fd06879b          	addiw	a5,a3,-48
 3da:	0ff7f793          	zext.b	a5,a5
 3de:	4625                	li	a2,9
 3e0:	02f66863          	bltu	a2,a5,410 <atoi+0x44>
 3e4:	872a                	mv	a4,a0
    n = 0;
 3e6:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 3e8:	0705                	addi	a4,a4,1
 3ea:	0025179b          	slliw	a5,a0,0x2
 3ee:	9fa9                	addw	a5,a5,a0
 3f0:	0017979b          	slliw	a5,a5,0x1
 3f4:	9fb5                	addw	a5,a5,a3
 3f6:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 3fa:	00074683          	lbu	a3,0(a4)
 3fe:	fd06879b          	addiw	a5,a3,-48
 402:	0ff7f793          	zext.b	a5,a5
 406:	fef671e3          	bgeu	a2,a5,3e8 <atoi+0x1c>
    return n;
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	addi	sp,sp,16
 40e:	8082                	ret
    n = 0;
 410:	4501                	li	a0,0
 412:	bfe5                	j	40a <atoi+0x3e>

0000000000000414 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 41a:	02b57463          	bgeu	a0,a1,442 <memmove+0x2e>
    {
        while (n-- > 0)
 41e:	00c05f63          	blez	a2,43c <memmove+0x28>
 422:	1602                	slli	a2,a2,0x20
 424:	9201                	srli	a2,a2,0x20
 426:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 42a:	872a                	mv	a4,a0
            *dst++ = *src++;
 42c:	0585                	addi	a1,a1,1
 42e:	0705                	addi	a4,a4,1
 430:	fff5c683          	lbu	a3,-1(a1)
 434:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 438:	fee79ae3          	bne	a5,a4,42c <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret
        dst += n;
 442:	00c50733          	add	a4,a0,a2
        src += n;
 446:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 448:	fec05ae3          	blez	a2,43c <memmove+0x28>
 44c:	fff6079b          	addiw	a5,a2,-1
 450:	1782                	slli	a5,a5,0x20
 452:	9381                	srli	a5,a5,0x20
 454:	fff7c793          	not	a5,a5
 458:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 45a:	15fd                	addi	a1,a1,-1
 45c:	177d                	addi	a4,a4,-1
 45e:	0005c683          	lbu	a3,0(a1)
 462:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 466:	fee79ae3          	bne	a5,a4,45a <memmove+0x46>
 46a:	bfc9                	j	43c <memmove+0x28>

000000000000046c <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 472:	ca05                	beqz	a2,4a2 <memcmp+0x36>
 474:	fff6069b          	addiw	a3,a2,-1
 478:	1682                	slli	a3,a3,0x20
 47a:	9281                	srli	a3,a3,0x20
 47c:	0685                	addi	a3,a3,1
 47e:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 480:	00054783          	lbu	a5,0(a0)
 484:	0005c703          	lbu	a4,0(a1)
 488:	00e79863          	bne	a5,a4,498 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 48c:	0505                	addi	a0,a0,1
        p2++;
 48e:	0585                	addi	a1,a1,1
    while (n-- > 0)
 490:	fed518e3          	bne	a0,a3,480 <memcmp+0x14>
    }
    return 0;
 494:	4501                	li	a0,0
 496:	a019                	j	49c <memcmp+0x30>
            return *p1 - *p2;
 498:	40e7853b          	subw	a0,a5,a4
}
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
    return 0;
 4a2:	4501                	li	a0,0
 4a4:	bfe5                	j	49c <memcmp+0x30>

00000000000004a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f66080e7          	jalr	-154(ra) # 414 <memmove>
}
 4b6:	60a2                	ld	ra,8(sp)
 4b8:	6402                	ld	s0,0(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret

00000000000004be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4be:	4885                	li	a7,1
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c6:	4889                	li	a7,2
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ce:	488d                	li	a7,3
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d6:	4891                	li	a7,4
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <read>:
.global read
read:
 li a7, SYS_read
 4de:	4895                	li	a7,5
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <write>:
.global write
write:
 li a7, SYS_write
 4e6:	48c1                	li	a7,16
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <close>:
.global close
close:
 li a7, SYS_close
 4ee:	48d5                	li	a7,21
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f6:	4899                	li	a7,6
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 4fe:	489d                	li	a7,7
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <open>:
.global open
open:
 li a7, SYS_open
 506:	48bd                	li	a7,15
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 50e:	48c5                	li	a7,17
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 516:	48c9                	li	a7,18
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 51e:	48a1                	li	a7,8
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <link>:
.global link
link:
 li a7, SYS_link
 526:	48cd                	li	a7,19
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 52e:	48d1                	li	a7,20
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 536:	48a5                	li	a7,9
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <dup>:
.global dup
dup:
 li a7, SYS_dup
 53e:	48a9                	li	a7,10
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 546:	48ad                	li	a7,11
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 54e:	48b1                	li	a7,12
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 556:	48b5                	li	a7,13
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 55e:	48b9                	li	a7,14
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <ps>:
.global ps
ps:
 li a7, SYS_ps
 566:	48d9                	li	a7,22
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 56e:	48dd                	li	a7,23
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 576:	48e1                	li	a7,24
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57e:	1101                	addi	sp,sp,-32
 580:	ec06                	sd	ra,24(sp)
 582:	e822                	sd	s0,16(sp)
 584:	1000                	addi	s0,sp,32
 586:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 58a:	4605                	li	a2,1
 58c:	fef40593          	addi	a1,s0,-17
 590:	00000097          	auipc	ra,0x0
 594:	f56080e7          	jalr	-170(ra) # 4e6 <write>
}
 598:	60e2                	ld	ra,24(sp)
 59a:	6442                	ld	s0,16(sp)
 59c:	6105                	addi	sp,sp,32
 59e:	8082                	ret

00000000000005a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	7139                	addi	sp,sp,-64
 5a2:	fc06                	sd	ra,56(sp)
 5a4:	f822                	sd	s0,48(sp)
 5a6:	f426                	sd	s1,40(sp)
 5a8:	f04a                	sd	s2,32(sp)
 5aa:	ec4e                	sd	s3,24(sp)
 5ac:	0080                	addi	s0,sp,64
 5ae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b0:	c299                	beqz	a3,5b6 <printint+0x16>
 5b2:	0805c963          	bltz	a1,644 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b6:	2581                	sext.w	a1,a1
  neg = 0;
 5b8:	4881                	li	a7,0
 5ba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5be:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5c0:	2601                	sext.w	a2,a2
 5c2:	00000517          	auipc	a0,0x0
 5c6:	52650513          	addi	a0,a0,1318 # ae8 <digits>
 5ca:	883a                	mv	a6,a4
 5cc:	2705                	addiw	a4,a4,1
 5ce:	02c5f7bb          	remuw	a5,a1,a2
 5d2:	1782                	slli	a5,a5,0x20
 5d4:	9381                	srli	a5,a5,0x20
 5d6:	97aa                	add	a5,a5,a0
 5d8:	0007c783          	lbu	a5,0(a5)
 5dc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5e0:	0005879b          	sext.w	a5,a1
 5e4:	02c5d5bb          	divuw	a1,a1,a2
 5e8:	0685                	addi	a3,a3,1
 5ea:	fec7f0e3          	bgeu	a5,a2,5ca <printint+0x2a>
  if(neg)
 5ee:	00088c63          	beqz	a7,606 <printint+0x66>
    buf[i++] = '-';
 5f2:	fd070793          	addi	a5,a4,-48
 5f6:	00878733          	add	a4,a5,s0
 5fa:	02d00793          	li	a5,45
 5fe:	fef70823          	sb	a5,-16(a4)
 602:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 606:	02e05863          	blez	a4,636 <printint+0x96>
 60a:	fc040793          	addi	a5,s0,-64
 60e:	00e78933          	add	s2,a5,a4
 612:	fff78993          	addi	s3,a5,-1
 616:	99ba                	add	s3,s3,a4
 618:	377d                	addiw	a4,a4,-1
 61a:	1702                	slli	a4,a4,0x20
 61c:	9301                	srli	a4,a4,0x20
 61e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 622:	fff94583          	lbu	a1,-1(s2)
 626:	8526                	mv	a0,s1
 628:	00000097          	auipc	ra,0x0
 62c:	f56080e7          	jalr	-170(ra) # 57e <putc>
  while(--i >= 0)
 630:	197d                	addi	s2,s2,-1
 632:	ff3918e3          	bne	s2,s3,622 <printint+0x82>
}
 636:	70e2                	ld	ra,56(sp)
 638:	7442                	ld	s0,48(sp)
 63a:	74a2                	ld	s1,40(sp)
 63c:	7902                	ld	s2,32(sp)
 63e:	69e2                	ld	s3,24(sp)
 640:	6121                	addi	sp,sp,64
 642:	8082                	ret
    x = -xx;
 644:	40b005bb          	negw	a1,a1
    neg = 1;
 648:	4885                	li	a7,1
    x = -xx;
 64a:	bf85                	j	5ba <printint+0x1a>

000000000000064c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 64c:	7119                	addi	sp,sp,-128
 64e:	fc86                	sd	ra,120(sp)
 650:	f8a2                	sd	s0,112(sp)
 652:	f4a6                	sd	s1,104(sp)
 654:	f0ca                	sd	s2,96(sp)
 656:	ecce                	sd	s3,88(sp)
 658:	e8d2                	sd	s4,80(sp)
 65a:	e4d6                	sd	s5,72(sp)
 65c:	e0da                	sd	s6,64(sp)
 65e:	fc5e                	sd	s7,56(sp)
 660:	f862                	sd	s8,48(sp)
 662:	f466                	sd	s9,40(sp)
 664:	f06a                	sd	s10,32(sp)
 666:	ec6e                	sd	s11,24(sp)
 668:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 66a:	0005c903          	lbu	s2,0(a1)
 66e:	18090f63          	beqz	s2,80c <vprintf+0x1c0>
 672:	8aaa                	mv	s5,a0
 674:	8b32                	mv	s6,a2
 676:	00158493          	addi	s1,a1,1
  state = 0;
 67a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 67c:	02500a13          	li	s4,37
 680:	4c55                	li	s8,21
 682:	00000c97          	auipc	s9,0x0
 686:	40ec8c93          	addi	s9,s9,1038 # a90 <malloc+0x180>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 68a:	02800d93          	li	s11,40
  putc(fd, 'x');
 68e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 690:	00000b97          	auipc	s7,0x0
 694:	458b8b93          	addi	s7,s7,1112 # ae8 <digits>
 698:	a839                	j	6b6 <vprintf+0x6a>
        putc(fd, c);
 69a:	85ca                	mv	a1,s2
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	ee0080e7          	jalr	-288(ra) # 57e <putc>
 6a6:	a019                	j	6ac <vprintf+0x60>
    } else if(state == '%'){
 6a8:	01498d63          	beq	s3,s4,6c2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6ac:	0485                	addi	s1,s1,1
 6ae:	fff4c903          	lbu	s2,-1(s1)
 6b2:	14090d63          	beqz	s2,80c <vprintf+0x1c0>
    if(state == 0){
 6b6:	fe0999e3          	bnez	s3,6a8 <vprintf+0x5c>
      if(c == '%'){
 6ba:	ff4910e3          	bne	s2,s4,69a <vprintf+0x4e>
        state = '%';
 6be:	89d2                	mv	s3,s4
 6c0:	b7f5                	j	6ac <vprintf+0x60>
      if(c == 'd'){
 6c2:	11490c63          	beq	s2,s4,7da <vprintf+0x18e>
 6c6:	f9d9079b          	addiw	a5,s2,-99
 6ca:	0ff7f793          	zext.b	a5,a5
 6ce:	10fc6e63          	bltu	s8,a5,7ea <vprintf+0x19e>
 6d2:	f9d9079b          	addiw	a5,s2,-99
 6d6:	0ff7f713          	zext.b	a4,a5
 6da:	10ec6863          	bltu	s8,a4,7ea <vprintf+0x19e>
 6de:	00271793          	slli	a5,a4,0x2
 6e2:	97e6                	add	a5,a5,s9
 6e4:	439c                	lw	a5,0(a5)
 6e6:	97e6                	add	a5,a5,s9
 6e8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ea:	008b0913          	addi	s2,s6,8
 6ee:	4685                	li	a3,1
 6f0:	4629                	li	a2,10
 6f2:	000b2583          	lw	a1,0(s6)
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	ea8080e7          	jalr	-344(ra) # 5a0 <printint>
 700:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 702:	4981                	li	s3,0
 704:	b765                	j	6ac <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 706:	008b0913          	addi	s2,s6,8
 70a:	4681                	li	a3,0
 70c:	4629                	li	a2,10
 70e:	000b2583          	lw	a1,0(s6)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	e8c080e7          	jalr	-372(ra) # 5a0 <printint>
 71c:	8b4a                	mv	s6,s2
      state = 0;
 71e:	4981                	li	s3,0
 720:	b771                	j	6ac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 722:	008b0913          	addi	s2,s6,8
 726:	4681                	li	a3,0
 728:	866a                	mv	a2,s10
 72a:	000b2583          	lw	a1,0(s6)
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	e70080e7          	jalr	-400(ra) # 5a0 <printint>
 738:	8b4a                	mv	s6,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bf85                	j	6ac <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 73e:	008b0793          	addi	a5,s6,8
 742:	f8f43423          	sd	a5,-120(s0)
 746:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 74a:	03000593          	li	a1,48
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e2e080e7          	jalr	-466(ra) # 57e <putc>
  putc(fd, 'x');
 758:	07800593          	li	a1,120
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e20080e7          	jalr	-480(ra) # 57e <putc>
 766:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 768:	03c9d793          	srli	a5,s3,0x3c
 76c:	97de                	add	a5,a5,s7
 76e:	0007c583          	lbu	a1,0(a5)
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	e0a080e7          	jalr	-502(ra) # 57e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77c:	0992                	slli	s3,s3,0x4
 77e:	397d                	addiw	s2,s2,-1
 780:	fe0914e3          	bnez	s2,768 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 784:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 788:	4981                	li	s3,0
 78a:	b70d                	j	6ac <vprintf+0x60>
        s = va_arg(ap, char*);
 78c:	008b0913          	addi	s2,s6,8
 790:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 794:	02098163          	beqz	s3,7b6 <vprintf+0x16a>
        while(*s != 0){
 798:	0009c583          	lbu	a1,0(s3)
 79c:	c5ad                	beqz	a1,806 <vprintf+0x1ba>
          putc(fd, *s);
 79e:	8556                	mv	a0,s5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	dde080e7          	jalr	-546(ra) # 57e <putc>
          s++;
 7a8:	0985                	addi	s3,s3,1
        while(*s != 0){
 7aa:	0009c583          	lbu	a1,0(s3)
 7ae:	f9e5                	bnez	a1,79e <vprintf+0x152>
        s = va_arg(ap, char*);
 7b0:	8b4a                	mv	s6,s2
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bde5                	j	6ac <vprintf+0x60>
          s = "(null)";
 7b6:	00000997          	auipc	s3,0x0
 7ba:	2d298993          	addi	s3,s3,722 # a88 <malloc+0x178>
        while(*s != 0){
 7be:	85ee                	mv	a1,s11
 7c0:	bff9                	j	79e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7c2:	008b0913          	addi	s2,s6,8
 7c6:	000b4583          	lbu	a1,0(s6)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	db2080e7          	jalr	-590(ra) # 57e <putc>
 7d4:	8b4a                	mv	s6,s2
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	bdd1                	j	6ac <vprintf+0x60>
        putc(fd, c);
 7da:	85d2                	mv	a1,s4
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	da0080e7          	jalr	-608(ra) # 57e <putc>
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	b5d1                	j	6ac <vprintf+0x60>
        putc(fd, '%');
 7ea:	85d2                	mv	a1,s4
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	d90080e7          	jalr	-624(ra) # 57e <putc>
        putc(fd, c);
 7f6:	85ca                	mv	a1,s2
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	d84080e7          	jalr	-636(ra) # 57e <putc>
      state = 0;
 802:	4981                	li	s3,0
 804:	b565                	j	6ac <vprintf+0x60>
        s = va_arg(ap, char*);
 806:	8b4a                	mv	s6,s2
      state = 0;
 808:	4981                	li	s3,0
 80a:	b54d                	j	6ac <vprintf+0x60>
    }
  }
}
 80c:	70e6                	ld	ra,120(sp)
 80e:	7446                	ld	s0,112(sp)
 810:	74a6                	ld	s1,104(sp)
 812:	7906                	ld	s2,96(sp)
 814:	69e6                	ld	s3,88(sp)
 816:	6a46                	ld	s4,80(sp)
 818:	6aa6                	ld	s5,72(sp)
 81a:	6b06                	ld	s6,64(sp)
 81c:	7be2                	ld	s7,56(sp)
 81e:	7c42                	ld	s8,48(sp)
 820:	7ca2                	ld	s9,40(sp)
 822:	7d02                	ld	s10,32(sp)
 824:	6de2                	ld	s11,24(sp)
 826:	6109                	addi	sp,sp,128
 828:	8082                	ret

000000000000082a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 82a:	715d                	addi	sp,sp,-80
 82c:	ec06                	sd	ra,24(sp)
 82e:	e822                	sd	s0,16(sp)
 830:	1000                	addi	s0,sp,32
 832:	e010                	sd	a2,0(s0)
 834:	e414                	sd	a3,8(s0)
 836:	e818                	sd	a4,16(s0)
 838:	ec1c                	sd	a5,24(s0)
 83a:	03043023          	sd	a6,32(s0)
 83e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 842:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 846:	8622                	mv	a2,s0
 848:	00000097          	auipc	ra,0x0
 84c:	e04080e7          	jalr	-508(ra) # 64c <vprintf>
}
 850:	60e2                	ld	ra,24(sp)
 852:	6442                	ld	s0,16(sp)
 854:	6161                	addi	sp,sp,80
 856:	8082                	ret

0000000000000858 <printf>:

void
printf(const char *fmt, ...)
{
 858:	711d                	addi	sp,sp,-96
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	1000                	addi	s0,sp,32
 860:	e40c                	sd	a1,8(s0)
 862:	e810                	sd	a2,16(s0)
 864:	ec14                	sd	a3,24(s0)
 866:	f018                	sd	a4,32(s0)
 868:	f41c                	sd	a5,40(s0)
 86a:	03043823          	sd	a6,48(s0)
 86e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 872:	00840613          	addi	a2,s0,8
 876:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 87a:	85aa                	mv	a1,a0
 87c:	4505                	li	a0,1
 87e:	00000097          	auipc	ra,0x0
 882:	dce080e7          	jalr	-562(ra) # 64c <vprintf>
}
 886:	60e2                	ld	ra,24(sp)
 888:	6442                	ld	s0,16(sp)
 88a:	6125                	addi	sp,sp,96
 88c:	8082                	ret

000000000000088e <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 88e:	1141                	addi	sp,sp,-16
 890:	e422                	sd	s0,8(sp)
 892:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 894:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 898:	00000797          	auipc	a5,0x0
 89c:	7687b783          	ld	a5,1896(a5) # 1000 <freep>
 8a0:	a02d                	j	8ca <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 8a2:	4618                	lw	a4,8(a2)
 8a4:	9f2d                	addw	a4,a4,a1
 8a6:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	6310                	ld	a2,0(a4)
 8ae:	a83d                	j	8ec <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 8b0:	ff852703          	lw	a4,-8(a0)
 8b4:	9f31                	addw	a4,a4,a2
 8b6:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 8b8:	ff053683          	ld	a3,-16(a0)
 8bc:	a091                	j	900 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	6398                	ld	a4,0(a5)
 8c0:	00e7e463          	bltu	a5,a4,8c8 <free+0x3a>
 8c4:	00e6ea63          	bltu	a3,a4,8d8 <free+0x4a>
{
 8c8:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ca:	fed7fae3          	bgeu	a5,a3,8be <free+0x30>
 8ce:	6398                	ld	a4,0(a5)
 8d0:	00e6e463          	bltu	a3,a4,8d8 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	fee7eae3          	bltu	a5,a4,8c8 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 8d8:	ff852583          	lw	a1,-8(a0)
 8dc:	6390                	ld	a2,0(a5)
 8de:	02059813          	slli	a6,a1,0x20
 8e2:	01c85713          	srli	a4,a6,0x1c
 8e6:	9736                	add	a4,a4,a3
 8e8:	fae60de3          	beq	a2,a4,8a2 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 8ec:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 8f0:	4790                	lw	a2,8(a5)
 8f2:	02061593          	slli	a1,a2,0x20
 8f6:	01c5d713          	srli	a4,a1,0x1c
 8fa:	973e                	add	a4,a4,a5
 8fc:	fae68ae3          	beq	a3,a4,8b0 <free+0x22>
        p->s.ptr = bp->s.ptr;
 900:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 902:	00000717          	auipc	a4,0x0
 906:	6ef73f23          	sd	a5,1790(a4) # 1000 <freep>
}
 90a:	6422                	ld	s0,8(sp)
 90c:	0141                	addi	sp,sp,16
 90e:	8082                	ret

0000000000000910 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 910:	7139                	addi	sp,sp,-64
 912:	fc06                	sd	ra,56(sp)
 914:	f822                	sd	s0,48(sp)
 916:	f426                	sd	s1,40(sp)
 918:	f04a                	sd	s2,32(sp)
 91a:	ec4e                	sd	s3,24(sp)
 91c:	e852                	sd	s4,16(sp)
 91e:	e456                	sd	s5,8(sp)
 920:	e05a                	sd	s6,0(sp)
 922:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 924:	02051493          	slli	s1,a0,0x20
 928:	9081                	srli	s1,s1,0x20
 92a:	04bd                	addi	s1,s1,15
 92c:	8091                	srli	s1,s1,0x4
 92e:	0014899b          	addiw	s3,s1,1
 932:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 934:	00000517          	auipc	a0,0x0
 938:	6cc53503          	ld	a0,1740(a0) # 1000 <freep>
 93c:	c515                	beqz	a0,968 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 93e:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 940:	4798                	lw	a4,8(a5)
 942:	02977f63          	bgeu	a4,s1,980 <malloc+0x70>
 946:	8a4e                	mv	s4,s3
 948:	0009871b          	sext.w	a4,s3
 94c:	6685                	lui	a3,0x1
 94e:	00d77363          	bgeu	a4,a3,954 <malloc+0x44>
 952:	6a05                	lui	s4,0x1
 954:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 958:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 95c:	00000917          	auipc	s2,0x0
 960:	6a490913          	addi	s2,s2,1700 # 1000 <freep>
    if (p == (char *)-1)
 964:	5afd                	li	s5,-1
 966:	a895                	j	9da <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 968:	00000797          	auipc	a5,0x0
 96c:	6a878793          	addi	a5,a5,1704 # 1010 <base>
 970:	00000717          	auipc	a4,0x0
 974:	68f73823          	sd	a5,1680(a4) # 1000 <freep>
 978:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 97a:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 97e:	b7e1                	j	946 <malloc+0x36>
            if (p->s.size == nunits)
 980:	02e48c63          	beq	s1,a4,9b8 <malloc+0xa8>
                p->s.size -= nunits;
 984:	4137073b          	subw	a4,a4,s3
 988:	c798                	sw	a4,8(a5)
                p += p->s.size;
 98a:	02071693          	slli	a3,a4,0x20
 98e:	01c6d713          	srli	a4,a3,0x1c
 992:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 994:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 998:	00000717          	auipc	a4,0x0
 99c:	66a73423          	sd	a0,1640(a4) # 1000 <freep>
            return (void *)(p + 1);
 9a0:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 9a4:	70e2                	ld	ra,56(sp)
 9a6:	7442                	ld	s0,48(sp)
 9a8:	74a2                	ld	s1,40(sp)
 9aa:	7902                	ld	s2,32(sp)
 9ac:	69e2                	ld	s3,24(sp)
 9ae:	6a42                	ld	s4,16(sp)
 9b0:	6aa2                	ld	s5,8(sp)
 9b2:	6b02                	ld	s6,0(sp)
 9b4:	6121                	addi	sp,sp,64
 9b6:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 9b8:	6398                	ld	a4,0(a5)
 9ba:	e118                	sd	a4,0(a0)
 9bc:	bff1                	j	998 <malloc+0x88>
    hp->s.size = nu;
 9be:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 9c2:	0541                	addi	a0,a0,16
 9c4:	00000097          	auipc	ra,0x0
 9c8:	eca080e7          	jalr	-310(ra) # 88e <free>
    return freep;
 9cc:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 9d0:	d971                	beqz	a0,9a4 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9d2:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 9d4:	4798                	lw	a4,8(a5)
 9d6:	fa9775e3          	bgeu	a4,s1,980 <malloc+0x70>
        if (p == freep)
 9da:	00093703          	ld	a4,0(s2)
 9de:	853e                	mv	a0,a5
 9e0:	fef719e3          	bne	a4,a5,9d2 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 9e4:	8552                	mv	a0,s4
 9e6:	00000097          	auipc	ra,0x0
 9ea:	b68080e7          	jalr	-1176(ra) # 54e <sbrk>
    if (p == (char *)-1)
 9ee:	fd5518e3          	bne	a0,s5,9be <malloc+0xae>
                return 0;
 9f2:	4501                	li	a0,0
 9f4:	bf45                	j	9a4 <malloc+0x94>
