
user/_echo:     file format elf64-littleriscv


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
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	02099793          	slli	a5,s3,0x20
  22:	01d7d993          	srli	s3,a5,0x1d
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	9e6a0a13          	addi	s4,s4,-1562 # a10 <malloc+0xf4>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	276080e7          	jalr	630(ra) # 2ae <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	4aa080e7          	jalr	1194(ra) # 4f2 <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	496080e7          	jalr	1174(ra) # 4f2 <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	9b058593          	addi	a1,a1,-1616 # a18 <malloc+0xfc>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	480080e7          	jalr	1152(ra) # 4f2 <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	456080e7          	jalr	1110(ra) # 4d2 <exit>

0000000000000084 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
    lk->name = name;
  8a:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  8c:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  90:	57fd                	li	a5,-1
  92:	00f50823          	sb	a5,16(a0)
}
  96:	6422                	ld	s0,8(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  9c:	00054783          	lbu	a5,0(a0)
  a0:	e399                	bnez	a5,a6 <holding+0xa>
  a2:	4501                	li	a0,0
}
  a4:	8082                	ret
{
  a6:	1101                	addi	sp,sp,-32
  a8:	ec06                	sd	ra,24(sp)
  aa:	e822                	sd	s0,16(sp)
  ac:	e426                	sd	s1,8(sp)
  ae:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  b0:	01054483          	lbu	s1,16(a0)
  b4:	00000097          	auipc	ra,0x0
  b8:	122080e7          	jalr	290(ra) # 1d6 <twhoami>
  bc:	2501                	sext.w	a0,a0
  be:	40a48533          	sub	a0,s1,a0
  c2:	00153513          	seqz	a0,a0
}
  c6:	60e2                	ld	ra,24(sp)
  c8:	6442                	ld	s0,16(sp)
  ca:	64a2                	ld	s1,8(sp)
  cc:	6105                	addi	sp,sp,32
  ce:	8082                	ret

00000000000000d0 <acquire>:

void acquire(struct lock *lk)
{
  d0:	7179                	addi	sp,sp,-48
  d2:	f406                	sd	ra,40(sp)
  d4:	f022                	sd	s0,32(sp)
  d6:	ec26                	sd	s1,24(sp)
  d8:	e84a                	sd	s2,16(sp)
  da:	e44e                	sd	s3,8(sp)
  dc:	e052                	sd	s4,0(sp)
  de:	1800                	addi	s0,sp,48
  e0:	8a2a                	mv	s4,a0
    if (holding(lk))
  e2:	00000097          	auipc	ra,0x0
  e6:	fba080e7          	jalr	-70(ra) # 9c <holding>
  ea:	e919                	bnez	a0,100 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  ec:	ffca7493          	andi	s1,s4,-4
  f0:	003a7913          	andi	s2,s4,3
  f4:	0039191b          	slliw	s2,s2,0x3
  f8:	4985                	li	s3,1
  fa:	012999bb          	sllw	s3,s3,s2
  fe:	a015                	j	122 <acquire+0x52>
        printf("re-acquiring lock we already hold");
 100:	00001517          	auipc	a0,0x1
 104:	92050513          	addi	a0,a0,-1760 # a20 <malloc+0x104>
 108:	00000097          	auipc	ra,0x0
 10c:	75c080e7          	jalr	1884(ra) # 864 <printf>
        exit(-1);
 110:	557d                	li	a0,-1
 112:	00000097          	auipc	ra,0x0
 116:	3c0080e7          	jalr	960(ra) # 4d2 <exit>
    {
        // give up the cpu for other threads
        tyield();
 11a:	00000097          	auipc	ra,0x0
 11e:	0b0080e7          	jalr	176(ra) # 1ca <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 122:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 126:	0127d7bb          	srlw	a5,a5,s2
 12a:	0ff7f793          	zext.b	a5,a5
 12e:	f7f5                	bnez	a5,11a <acquire+0x4a>
    }

    __sync_synchronize();
 130:	0ff0000f          	fence

    lk->tid = twhoami();
 134:	00000097          	auipc	ra,0x0
 138:	0a2080e7          	jalr	162(ra) # 1d6 <twhoami>
 13c:	00aa0823          	sb	a0,16(s4)
}
 140:	70a2                	ld	ra,40(sp)
 142:	7402                	ld	s0,32(sp)
 144:	64e2                	ld	s1,24(sp)
 146:	6942                	ld	s2,16(sp)
 148:	69a2                	ld	s3,8(sp)
 14a:	6a02                	ld	s4,0(sp)
 14c:	6145                	addi	sp,sp,48
 14e:	8082                	ret

0000000000000150 <release>:

void release(struct lock *lk)
{
 150:	1101                	addi	sp,sp,-32
 152:	ec06                	sd	ra,24(sp)
 154:	e822                	sd	s0,16(sp)
 156:	e426                	sd	s1,8(sp)
 158:	1000                	addi	s0,sp,32
 15a:	84aa                	mv	s1,a0
    if (!holding(lk))
 15c:	00000097          	auipc	ra,0x0
 160:	f40080e7          	jalr	-192(ra) # 9c <holding>
 164:	c11d                	beqz	a0,18a <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 166:	57fd                	li	a5,-1
 168:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 16c:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 170:	0ff0000f          	fence
 174:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 178:	00000097          	auipc	ra,0x0
 17c:	052080e7          	jalr	82(ra) # 1ca <tyield>
}
 180:	60e2                	ld	ra,24(sp)
 182:	6442                	ld	s0,16(sp)
 184:	64a2                	ld	s1,8(sp)
 186:	6105                	addi	sp,sp,32
 188:	8082                	ret
        printf("releasing lock we are not holding");
 18a:	00001517          	auipc	a0,0x1
 18e:	8be50513          	addi	a0,a0,-1858 # a48 <malloc+0x12c>
 192:	00000097          	auipc	ra,0x0
 196:	6d2080e7          	jalr	1746(ra) # 864 <printf>
        exit(-1);
 19a:	557d                	li	a0,-1
 19c:	00000097          	auipc	ra,0x0
 1a0:	336080e7          	jalr	822(ra) # 4d2 <exit>

00000000000001a4 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret

00000000000001b0 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 1c2:	4501                	li	a0,0
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <tyield>:

void tyield()
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret

00000000000001d6 <twhoami>:

uint8 twhoami()
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 1dc:	4501                	li	a0,0
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret

00000000000001e4 <tswtch>:
 1e4:	00153023          	sd	ra,0(a0)
 1e8:	00253423          	sd	sp,8(a0)
 1ec:	e900                	sd	s0,16(a0)
 1ee:	ed04                	sd	s1,24(a0)
 1f0:	03253023          	sd	s2,32(a0)
 1f4:	03353423          	sd	s3,40(a0)
 1f8:	03453823          	sd	s4,48(a0)
 1fc:	03553c23          	sd	s5,56(a0)
 200:	05653023          	sd	s6,64(a0)
 204:	05753423          	sd	s7,72(a0)
 208:	05853823          	sd	s8,80(a0)
 20c:	05953c23          	sd	s9,88(a0)
 210:	07a53023          	sd	s10,96(a0)
 214:	07b53423          	sd	s11,104(a0)
 218:	0005b083          	ld	ra,0(a1)
 21c:	0085b103          	ld	sp,8(a1)
 220:	6980                	ld	s0,16(a1)
 222:	6d84                	ld	s1,24(a1)
 224:	0205b903          	ld	s2,32(a1)
 228:	0285b983          	ld	s3,40(a1)
 22c:	0305ba03          	ld	s4,48(a1)
 230:	0385ba83          	ld	s5,56(a1)
 234:	0405bb03          	ld	s6,64(a1)
 238:	0485bb83          	ld	s7,72(a1)
 23c:	0505bc03          	ld	s8,80(a1)
 240:	0585bc83          	ld	s9,88(a1)
 244:	0605bd03          	ld	s10,96(a1)
 248:	0685bd83          	ld	s11,104(a1)
 24c:	8082                	ret

000000000000024e <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 256:	00000097          	auipc	ra,0x0
 25a:	daa080e7          	jalr	-598(ra) # 0 <main>
    exit(res);
 25e:	00000097          	auipc	ra,0x0
 262:	274080e7          	jalr	628(ra) # 4d2 <exit>

0000000000000266 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 26c:	87aa                	mv	a5,a0
 26e:	0585                	addi	a1,a1,1
 270:	0785                	addi	a5,a5,1
 272:	fff5c703          	lbu	a4,-1(a1)
 276:	fee78fa3          	sb	a4,-1(a5)
 27a:	fb75                	bnez	a4,26e <strcpy+0x8>
        ;
    return os;
}
 27c:	6422                	ld	s0,8(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret

0000000000000282 <strcmp>:

int strcmp(const char *p, const char *q)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 288:	00054783          	lbu	a5,0(a0)
 28c:	cb91                	beqz	a5,2a0 <strcmp+0x1e>
 28e:	0005c703          	lbu	a4,0(a1)
 292:	00f71763          	bne	a4,a5,2a0 <strcmp+0x1e>
        p++, q++;
 296:	0505                	addi	a0,a0,1
 298:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 29a:	00054783          	lbu	a5,0(a0)
 29e:	fbe5                	bnez	a5,28e <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 2a0:	0005c503          	lbu	a0,0(a1)
}
 2a4:	40a7853b          	subw	a0,a5,a0
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret

00000000000002ae <strlen>:

uint strlen(const char *s)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 2b4:	00054783          	lbu	a5,0(a0)
 2b8:	cf91                	beqz	a5,2d4 <strlen+0x26>
 2ba:	0505                	addi	a0,a0,1
 2bc:	87aa                	mv	a5,a0
 2be:	4685                	li	a3,1
 2c0:	9e89                	subw	a3,a3,a0
 2c2:	00f6853b          	addw	a0,a3,a5
 2c6:	0785                	addi	a5,a5,1
 2c8:	fff7c703          	lbu	a4,-1(a5)
 2cc:	fb7d                	bnez	a4,2c2 <strlen+0x14>
        ;
    return n;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
    for (n = 0; s[n]; n++)
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <strlen+0x20>

00000000000002d8 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 2de:	ca19                	beqz	a2,2f4 <memset+0x1c>
 2e0:	87aa                	mv	a5,a0
 2e2:	1602                	slli	a2,a2,0x20
 2e4:	9201                	srli	a2,a2,0x20
 2e6:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 2ea:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 2ee:	0785                	addi	a5,a5,1
 2f0:	fee79de3          	bne	a5,a4,2ea <memset+0x12>
    }
    return dst;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <strchr>:

char *
strchr(const char *s, char c)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
    for (; *s; s++)
 300:	00054783          	lbu	a5,0(a0)
 304:	cb99                	beqz	a5,31a <strchr+0x20>
        if (*s == c)
 306:	00f58763          	beq	a1,a5,314 <strchr+0x1a>
    for (; *s; s++)
 30a:	0505                	addi	a0,a0,1
 30c:	00054783          	lbu	a5,0(a0)
 310:	fbfd                	bnez	a5,306 <strchr+0xc>
            return (char *)s;
    return 0;
 312:	4501                	li	a0,0
}
 314:	6422                	ld	s0,8(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
    return 0;
 31a:	4501                	li	a0,0
 31c:	bfe5                	j	314 <strchr+0x1a>

000000000000031e <gets>:

char *
gets(char *buf, int max)
{
 31e:	711d                	addi	sp,sp,-96
 320:	ec86                	sd	ra,88(sp)
 322:	e8a2                	sd	s0,80(sp)
 324:	e4a6                	sd	s1,72(sp)
 326:	e0ca                	sd	s2,64(sp)
 328:	fc4e                	sd	s3,56(sp)
 32a:	f852                	sd	s4,48(sp)
 32c:	f456                	sd	s5,40(sp)
 32e:	f05a                	sd	s6,32(sp)
 330:	ec5e                	sd	s7,24(sp)
 332:	1080                	addi	s0,sp,96
 334:	8baa                	mv	s7,a0
 336:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 338:	892a                	mv	s2,a0
 33a:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 33c:	4aa9                	li	s5,10
 33e:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 340:	89a6                	mv	s3,s1
 342:	2485                	addiw	s1,s1,1
 344:	0344d863          	bge	s1,s4,374 <gets+0x56>
        cc = read(0, &c, 1);
 348:	4605                	li	a2,1
 34a:	faf40593          	addi	a1,s0,-81
 34e:	4501                	li	a0,0
 350:	00000097          	auipc	ra,0x0
 354:	19a080e7          	jalr	410(ra) # 4ea <read>
        if (cc < 1)
 358:	00a05e63          	blez	a0,374 <gets+0x56>
        buf[i++] = c;
 35c:	faf44783          	lbu	a5,-81(s0)
 360:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 364:	01578763          	beq	a5,s5,372 <gets+0x54>
 368:	0905                	addi	s2,s2,1
 36a:	fd679be3          	bne	a5,s6,340 <gets+0x22>
    for (i = 0; i + 1 < max;)
 36e:	89a6                	mv	s3,s1
 370:	a011                	j	374 <gets+0x56>
 372:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 374:	99de                	add	s3,s3,s7
 376:	00098023          	sb	zero,0(s3)
    return buf;
}
 37a:	855e                	mv	a0,s7
 37c:	60e6                	ld	ra,88(sp)
 37e:	6446                	ld	s0,80(sp)
 380:	64a6                	ld	s1,72(sp)
 382:	6906                	ld	s2,64(sp)
 384:	79e2                	ld	s3,56(sp)
 386:	7a42                	ld	s4,48(sp)
 388:	7aa2                	ld	s5,40(sp)
 38a:	7b02                	ld	s6,32(sp)
 38c:	6be2                	ld	s7,24(sp)
 38e:	6125                	addi	sp,sp,96
 390:	8082                	ret

0000000000000392 <stat>:

int stat(const char *n, struct stat *st)
{
 392:	1101                	addi	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	e426                	sd	s1,8(sp)
 39a:	e04a                	sd	s2,0(sp)
 39c:	1000                	addi	s0,sp,32
 39e:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 3a0:	4581                	li	a1,0
 3a2:	00000097          	auipc	ra,0x0
 3a6:	170080e7          	jalr	368(ra) # 512 <open>
    if (fd < 0)
 3aa:	02054563          	bltz	a0,3d4 <stat+0x42>
 3ae:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 3b0:	85ca                	mv	a1,s2
 3b2:	00000097          	auipc	ra,0x0
 3b6:	178080e7          	jalr	376(ra) # 52a <fstat>
 3ba:	892a                	mv	s2,a0
    close(fd);
 3bc:	8526                	mv	a0,s1
 3be:	00000097          	auipc	ra,0x0
 3c2:	13c080e7          	jalr	316(ra) # 4fa <close>
    return r;
}
 3c6:	854a                	mv	a0,s2
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	64a2                	ld	s1,8(sp)
 3ce:	6902                	ld	s2,0(sp)
 3d0:	6105                	addi	sp,sp,32
 3d2:	8082                	ret
        return -1;
 3d4:	597d                	li	s2,-1
 3d6:	bfc5                	j	3c6 <stat+0x34>

00000000000003d8 <atoi>:

int atoi(const char *s)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 3de:	00054683          	lbu	a3,0(a0)
 3e2:	fd06879b          	addiw	a5,a3,-48
 3e6:	0ff7f793          	zext.b	a5,a5
 3ea:	4625                	li	a2,9
 3ec:	02f66863          	bltu	a2,a5,41c <atoi+0x44>
 3f0:	872a                	mv	a4,a0
    n = 0;
 3f2:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 3f4:	0705                	addi	a4,a4,1
 3f6:	0025179b          	slliw	a5,a0,0x2
 3fa:	9fa9                	addw	a5,a5,a0
 3fc:	0017979b          	slliw	a5,a5,0x1
 400:	9fb5                	addw	a5,a5,a3
 402:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 406:	00074683          	lbu	a3,0(a4)
 40a:	fd06879b          	addiw	a5,a3,-48
 40e:	0ff7f793          	zext.b	a5,a5
 412:	fef671e3          	bgeu	a2,a5,3f4 <atoi+0x1c>
    return n;
}
 416:	6422                	ld	s0,8(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret
    n = 0;
 41c:	4501                	li	a0,0
 41e:	bfe5                	j	416 <atoi+0x3e>

0000000000000420 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 426:	02b57463          	bgeu	a0,a1,44e <memmove+0x2e>
    {
        while (n-- > 0)
 42a:	00c05f63          	blez	a2,448 <memmove+0x28>
 42e:	1602                	slli	a2,a2,0x20
 430:	9201                	srli	a2,a2,0x20
 432:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 436:	872a                	mv	a4,a0
            *dst++ = *src++;
 438:	0585                	addi	a1,a1,1
 43a:	0705                	addi	a4,a4,1
 43c:	fff5c683          	lbu	a3,-1(a1)
 440:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 444:	fee79ae3          	bne	a5,a4,438 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 448:	6422                	ld	s0,8(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret
        dst += n;
 44e:	00c50733          	add	a4,a0,a2
        src += n;
 452:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 454:	fec05ae3          	blez	a2,448 <memmove+0x28>
 458:	fff6079b          	addiw	a5,a2,-1
 45c:	1782                	slli	a5,a5,0x20
 45e:	9381                	srli	a5,a5,0x20
 460:	fff7c793          	not	a5,a5
 464:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 466:	15fd                	addi	a1,a1,-1
 468:	177d                	addi	a4,a4,-1
 46a:	0005c683          	lbu	a3,0(a1)
 46e:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 472:	fee79ae3          	bne	a5,a4,466 <memmove+0x46>
 476:	bfc9                	j	448 <memmove+0x28>

0000000000000478 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 478:	1141                	addi	sp,sp,-16
 47a:	e422                	sd	s0,8(sp)
 47c:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 47e:	ca05                	beqz	a2,4ae <memcmp+0x36>
 480:	fff6069b          	addiw	a3,a2,-1
 484:	1682                	slli	a3,a3,0x20
 486:	9281                	srli	a3,a3,0x20
 488:	0685                	addi	a3,a3,1
 48a:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 48c:	00054783          	lbu	a5,0(a0)
 490:	0005c703          	lbu	a4,0(a1)
 494:	00e79863          	bne	a5,a4,4a4 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 498:	0505                	addi	a0,a0,1
        p2++;
 49a:	0585                	addi	a1,a1,1
    while (n-- > 0)
 49c:	fed518e3          	bne	a0,a3,48c <memcmp+0x14>
    }
    return 0;
 4a0:	4501                	li	a0,0
 4a2:	a019                	j	4a8 <memcmp+0x30>
            return *p1 - *p2;
 4a4:	40e7853b          	subw	a0,a5,a4
}
 4a8:	6422                	ld	s0,8(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret
    return 0;
 4ae:	4501                	li	a0,0
 4b0:	bfe5                	j	4a8 <memcmp+0x30>

00000000000004b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e406                	sd	ra,8(sp)
 4b6:	e022                	sd	s0,0(sp)
 4b8:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 4ba:	00000097          	auipc	ra,0x0
 4be:	f66080e7          	jalr	-154(ra) # 420 <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ca:	4885                	li	a7,1
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d2:	4889                	li	a7,2
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <wait>:
.global wait
wait:
 li a7, SYS_wait
 4da:	488d                	li	a7,3
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e2:	4891                	li	a7,4
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <read>:
.global read
read:
 li a7, SYS_read
 4ea:	4895                	li	a7,5
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <write>:
.global write
write:
 li a7, SYS_write
 4f2:	48c1                	li	a7,16
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <close>:
.global close
close:
 li a7, SYS_close
 4fa:	48d5                	li	a7,21
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <kill>:
.global kill
kill:
 li a7, SYS_kill
 502:	4899                	li	a7,6
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exec>:
.global exec
exec:
 li a7, SYS_exec
 50a:	489d                	li	a7,7
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <open>:
.global open
open:
 li a7, SYS_open
 512:	48bd                	li	a7,15
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51a:	48c5                	li	a7,17
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 522:	48c9                	li	a7,18
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52a:	48a1                	li	a7,8
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <link>:
.global link
link:
 li a7, SYS_link
 532:	48cd                	li	a7,19
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53a:	48d1                	li	a7,20
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 542:	48a5                	li	a7,9
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <dup>:
.global dup
dup:
 li a7, SYS_dup
 54a:	48a9                	li	a7,10
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 552:	48ad                	li	a7,11
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55a:	48b1                	li	a7,12
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 562:	48b5                	li	a7,13
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56a:	48b9                	li	a7,14
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <ps>:
.global ps
ps:
 li a7, SYS_ps
 572:	48d9                	li	a7,22
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 57a:	48dd                	li	a7,23
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 582:	48e1                	li	a7,24
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 58a:	1101                	addi	sp,sp,-32
 58c:	ec06                	sd	ra,24(sp)
 58e:	e822                	sd	s0,16(sp)
 590:	1000                	addi	s0,sp,32
 592:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 596:	4605                	li	a2,1
 598:	fef40593          	addi	a1,s0,-17
 59c:	00000097          	auipc	ra,0x0
 5a0:	f56080e7          	jalr	-170(ra) # 4f2 <write>
}
 5a4:	60e2                	ld	ra,24(sp)
 5a6:	6442                	ld	s0,16(sp)
 5a8:	6105                	addi	sp,sp,32
 5aa:	8082                	ret

00000000000005ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ac:	7139                	addi	sp,sp,-64
 5ae:	fc06                	sd	ra,56(sp)
 5b0:	f822                	sd	s0,48(sp)
 5b2:	f426                	sd	s1,40(sp)
 5b4:	f04a                	sd	s2,32(sp)
 5b6:	ec4e                	sd	s3,24(sp)
 5b8:	0080                	addi	s0,sp,64
 5ba:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5bc:	c299                	beqz	a3,5c2 <printint+0x16>
 5be:	0805c963          	bltz	a1,650 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5c2:	2581                	sext.w	a1,a1
  neg = 0;
 5c4:	4881                	li	a7,0
 5c6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5cc:	2601                	sext.w	a2,a2
 5ce:	00000517          	auipc	a0,0x0
 5d2:	50250513          	addi	a0,a0,1282 # ad0 <digits>
 5d6:	883a                	mv	a6,a4
 5d8:	2705                	addiw	a4,a4,1
 5da:	02c5f7bb          	remuw	a5,a1,a2
 5de:	1782                	slli	a5,a5,0x20
 5e0:	9381                	srli	a5,a5,0x20
 5e2:	97aa                	add	a5,a5,a0
 5e4:	0007c783          	lbu	a5,0(a5)
 5e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ec:	0005879b          	sext.w	a5,a1
 5f0:	02c5d5bb          	divuw	a1,a1,a2
 5f4:	0685                	addi	a3,a3,1
 5f6:	fec7f0e3          	bgeu	a5,a2,5d6 <printint+0x2a>
  if(neg)
 5fa:	00088c63          	beqz	a7,612 <printint+0x66>
    buf[i++] = '-';
 5fe:	fd070793          	addi	a5,a4,-48
 602:	00878733          	add	a4,a5,s0
 606:	02d00793          	li	a5,45
 60a:	fef70823          	sb	a5,-16(a4)
 60e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 612:	02e05863          	blez	a4,642 <printint+0x96>
 616:	fc040793          	addi	a5,s0,-64
 61a:	00e78933          	add	s2,a5,a4
 61e:	fff78993          	addi	s3,a5,-1
 622:	99ba                	add	s3,s3,a4
 624:	377d                	addiw	a4,a4,-1
 626:	1702                	slli	a4,a4,0x20
 628:	9301                	srli	a4,a4,0x20
 62a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 62e:	fff94583          	lbu	a1,-1(s2)
 632:	8526                	mv	a0,s1
 634:	00000097          	auipc	ra,0x0
 638:	f56080e7          	jalr	-170(ra) # 58a <putc>
  while(--i >= 0)
 63c:	197d                	addi	s2,s2,-1
 63e:	ff3918e3          	bne	s2,s3,62e <printint+0x82>
}
 642:	70e2                	ld	ra,56(sp)
 644:	7442                	ld	s0,48(sp)
 646:	74a2                	ld	s1,40(sp)
 648:	7902                	ld	s2,32(sp)
 64a:	69e2                	ld	s3,24(sp)
 64c:	6121                	addi	sp,sp,64
 64e:	8082                	ret
    x = -xx;
 650:	40b005bb          	negw	a1,a1
    neg = 1;
 654:	4885                	li	a7,1
    x = -xx;
 656:	bf85                	j	5c6 <printint+0x1a>

0000000000000658 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 658:	7119                	addi	sp,sp,-128
 65a:	fc86                	sd	ra,120(sp)
 65c:	f8a2                	sd	s0,112(sp)
 65e:	f4a6                	sd	s1,104(sp)
 660:	f0ca                	sd	s2,96(sp)
 662:	ecce                	sd	s3,88(sp)
 664:	e8d2                	sd	s4,80(sp)
 666:	e4d6                	sd	s5,72(sp)
 668:	e0da                	sd	s6,64(sp)
 66a:	fc5e                	sd	s7,56(sp)
 66c:	f862                	sd	s8,48(sp)
 66e:	f466                	sd	s9,40(sp)
 670:	f06a                	sd	s10,32(sp)
 672:	ec6e                	sd	s11,24(sp)
 674:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 676:	0005c903          	lbu	s2,0(a1)
 67a:	18090f63          	beqz	s2,818 <vprintf+0x1c0>
 67e:	8aaa                	mv	s5,a0
 680:	8b32                	mv	s6,a2
 682:	00158493          	addi	s1,a1,1
  state = 0;
 686:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 688:	02500a13          	li	s4,37
 68c:	4c55                	li	s8,21
 68e:	00000c97          	auipc	s9,0x0
 692:	3eac8c93          	addi	s9,s9,1002 # a78 <malloc+0x15c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 696:	02800d93          	li	s11,40
  putc(fd, 'x');
 69a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69c:	00000b97          	auipc	s7,0x0
 6a0:	434b8b93          	addi	s7,s7,1076 # ad0 <digits>
 6a4:	a839                	j	6c2 <vprintf+0x6a>
        putc(fd, c);
 6a6:	85ca                	mv	a1,s2
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	ee0080e7          	jalr	-288(ra) # 58a <putc>
 6b2:	a019                	j	6b8 <vprintf+0x60>
    } else if(state == '%'){
 6b4:	01498d63          	beq	s3,s4,6ce <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6b8:	0485                	addi	s1,s1,1
 6ba:	fff4c903          	lbu	s2,-1(s1)
 6be:	14090d63          	beqz	s2,818 <vprintf+0x1c0>
    if(state == 0){
 6c2:	fe0999e3          	bnez	s3,6b4 <vprintf+0x5c>
      if(c == '%'){
 6c6:	ff4910e3          	bne	s2,s4,6a6 <vprintf+0x4e>
        state = '%';
 6ca:	89d2                	mv	s3,s4
 6cc:	b7f5                	j	6b8 <vprintf+0x60>
      if(c == 'd'){
 6ce:	11490c63          	beq	s2,s4,7e6 <vprintf+0x18e>
 6d2:	f9d9079b          	addiw	a5,s2,-99
 6d6:	0ff7f793          	zext.b	a5,a5
 6da:	10fc6e63          	bltu	s8,a5,7f6 <vprintf+0x19e>
 6de:	f9d9079b          	addiw	a5,s2,-99
 6e2:	0ff7f713          	zext.b	a4,a5
 6e6:	10ec6863          	bltu	s8,a4,7f6 <vprintf+0x19e>
 6ea:	00271793          	slli	a5,a4,0x2
 6ee:	97e6                	add	a5,a5,s9
 6f0:	439c                	lw	a5,0(a5)
 6f2:	97e6                	add	a5,a5,s9
 6f4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6f6:	008b0913          	addi	s2,s6,8
 6fa:	4685                	li	a3,1
 6fc:	4629                	li	a2,10
 6fe:	000b2583          	lw	a1,0(s6)
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	ea8080e7          	jalr	-344(ra) # 5ac <printint>
 70c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 70e:	4981                	li	s3,0
 710:	b765                	j	6b8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	008b0913          	addi	s2,s6,8
 716:	4681                	li	a3,0
 718:	4629                	li	a2,10
 71a:	000b2583          	lw	a1,0(s6)
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	e8c080e7          	jalr	-372(ra) # 5ac <printint>
 728:	8b4a                	mv	s6,s2
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b771                	j	6b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 72e:	008b0913          	addi	s2,s6,8
 732:	4681                	li	a3,0
 734:	866a                	mv	a2,s10
 736:	000b2583          	lw	a1,0(s6)
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	e70080e7          	jalr	-400(ra) # 5ac <printint>
 744:	8b4a                	mv	s6,s2
      state = 0;
 746:	4981                	li	s3,0
 748:	bf85                	j	6b8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 74a:	008b0793          	addi	a5,s6,8
 74e:	f8f43423          	sd	a5,-120(s0)
 752:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 756:	03000593          	li	a1,48
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	e2e080e7          	jalr	-466(ra) # 58a <putc>
  putc(fd, 'x');
 764:	07800593          	li	a1,120
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e20080e7          	jalr	-480(ra) # 58a <putc>
 772:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 774:	03c9d793          	srli	a5,s3,0x3c
 778:	97de                	add	a5,a5,s7
 77a:	0007c583          	lbu	a1,0(a5)
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	e0a080e7          	jalr	-502(ra) # 58a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 788:	0992                	slli	s3,s3,0x4
 78a:	397d                	addiw	s2,s2,-1
 78c:	fe0914e3          	bnez	s2,774 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 790:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 794:	4981                	li	s3,0
 796:	b70d                	j	6b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 798:	008b0913          	addi	s2,s6,8
 79c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7a0:	02098163          	beqz	s3,7c2 <vprintf+0x16a>
        while(*s != 0){
 7a4:	0009c583          	lbu	a1,0(s3)
 7a8:	c5ad                	beqz	a1,812 <vprintf+0x1ba>
          putc(fd, *s);
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	dde080e7          	jalr	-546(ra) # 58a <putc>
          s++;
 7b4:	0985                	addi	s3,s3,1
        while(*s != 0){
 7b6:	0009c583          	lbu	a1,0(s3)
 7ba:	f9e5                	bnez	a1,7aa <vprintf+0x152>
        s = va_arg(ap, char*);
 7bc:	8b4a                	mv	s6,s2
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bde5                	j	6b8 <vprintf+0x60>
          s = "(null)";
 7c2:	00000997          	auipc	s3,0x0
 7c6:	2ae98993          	addi	s3,s3,686 # a70 <malloc+0x154>
        while(*s != 0){
 7ca:	85ee                	mv	a1,s11
 7cc:	bff9                	j	7aa <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7ce:	008b0913          	addi	s2,s6,8
 7d2:	000b4583          	lbu	a1,0(s6)
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	db2080e7          	jalr	-590(ra) # 58a <putc>
 7e0:	8b4a                	mv	s6,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bdd1                	j	6b8 <vprintf+0x60>
        putc(fd, c);
 7e6:	85d2                	mv	a1,s4
 7e8:	8556                	mv	a0,s5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	da0080e7          	jalr	-608(ra) # 58a <putc>
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b5d1                	j	6b8 <vprintf+0x60>
        putc(fd, '%');
 7f6:	85d2                	mv	a1,s4
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	d90080e7          	jalr	-624(ra) # 58a <putc>
        putc(fd, c);
 802:	85ca                	mv	a1,s2
 804:	8556                	mv	a0,s5
 806:	00000097          	auipc	ra,0x0
 80a:	d84080e7          	jalr	-636(ra) # 58a <putc>
      state = 0;
 80e:	4981                	li	s3,0
 810:	b565                	j	6b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 812:	8b4a                	mv	s6,s2
      state = 0;
 814:	4981                	li	s3,0
 816:	b54d                	j	6b8 <vprintf+0x60>
    }
  }
}
 818:	70e6                	ld	ra,120(sp)
 81a:	7446                	ld	s0,112(sp)
 81c:	74a6                	ld	s1,104(sp)
 81e:	7906                	ld	s2,96(sp)
 820:	69e6                	ld	s3,88(sp)
 822:	6a46                	ld	s4,80(sp)
 824:	6aa6                	ld	s5,72(sp)
 826:	6b06                	ld	s6,64(sp)
 828:	7be2                	ld	s7,56(sp)
 82a:	7c42                	ld	s8,48(sp)
 82c:	7ca2                	ld	s9,40(sp)
 82e:	7d02                	ld	s10,32(sp)
 830:	6de2                	ld	s11,24(sp)
 832:	6109                	addi	sp,sp,128
 834:	8082                	ret

0000000000000836 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 836:	715d                	addi	sp,sp,-80
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	1000                	addi	s0,sp,32
 83e:	e010                	sd	a2,0(s0)
 840:	e414                	sd	a3,8(s0)
 842:	e818                	sd	a4,16(s0)
 844:	ec1c                	sd	a5,24(s0)
 846:	03043023          	sd	a6,32(s0)
 84a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 852:	8622                	mv	a2,s0
 854:	00000097          	auipc	ra,0x0
 858:	e04080e7          	jalr	-508(ra) # 658 <vprintf>
}
 85c:	60e2                	ld	ra,24(sp)
 85e:	6442                	ld	s0,16(sp)
 860:	6161                	addi	sp,sp,80
 862:	8082                	ret

0000000000000864 <printf>:

void
printf(const char *fmt, ...)
{
 864:	711d                	addi	sp,sp,-96
 866:	ec06                	sd	ra,24(sp)
 868:	e822                	sd	s0,16(sp)
 86a:	1000                	addi	s0,sp,32
 86c:	e40c                	sd	a1,8(s0)
 86e:	e810                	sd	a2,16(s0)
 870:	ec14                	sd	a3,24(s0)
 872:	f018                	sd	a4,32(s0)
 874:	f41c                	sd	a5,40(s0)
 876:	03043823          	sd	a6,48(s0)
 87a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87e:	00840613          	addi	a2,s0,8
 882:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 886:	85aa                	mv	a1,a0
 888:	4505                	li	a0,1
 88a:	00000097          	auipc	ra,0x0
 88e:	dce080e7          	jalr	-562(ra) # 658 <vprintf>
}
 892:	60e2                	ld	ra,24(sp)
 894:	6442                	ld	s0,16(sp)
 896:	6125                	addi	sp,sp,96
 898:	8082                	ret

000000000000089a <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 89a:	1141                	addi	sp,sp,-16
 89c:	e422                	sd	s0,8(sp)
 89e:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 8a0:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	00000797          	auipc	a5,0x0
 8a8:	75c7b783          	ld	a5,1884(a5) # 1000 <freep>
 8ac:	a02d                	j	8d6 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 8ae:	4618                	lw	a4,8(a2)
 8b0:	9f2d                	addw	a4,a4,a1
 8b2:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	6398                	ld	a4,0(a5)
 8b8:	6310                	ld	a2,0(a4)
 8ba:	a83d                	j	8f8 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 8bc:	ff852703          	lw	a4,-8(a0)
 8c0:	9f31                	addw	a4,a4,a2
 8c2:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 8c4:	ff053683          	ld	a3,-16(a0)
 8c8:	a091                	j	90c <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ca:	6398                	ld	a4,0(a5)
 8cc:	00e7e463          	bltu	a5,a4,8d4 <free+0x3a>
 8d0:	00e6ea63          	bltu	a3,a4,8e4 <free+0x4a>
{
 8d4:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	fed7fae3          	bgeu	a5,a3,8ca <free+0x30>
 8da:	6398                	ld	a4,0(a5)
 8dc:	00e6e463          	bltu	a3,a4,8e4 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	fee7eae3          	bltu	a5,a4,8d4 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 8e4:	ff852583          	lw	a1,-8(a0)
 8e8:	6390                	ld	a2,0(a5)
 8ea:	02059813          	slli	a6,a1,0x20
 8ee:	01c85713          	srli	a4,a6,0x1c
 8f2:	9736                	add	a4,a4,a3
 8f4:	fae60de3          	beq	a2,a4,8ae <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 8f8:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 8fc:	4790                	lw	a2,8(a5)
 8fe:	02061593          	slli	a1,a2,0x20
 902:	01c5d713          	srli	a4,a1,0x1c
 906:	973e                	add	a4,a4,a5
 908:	fae68ae3          	beq	a3,a4,8bc <free+0x22>
        p->s.ptr = bp->s.ptr;
 90c:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 90e:	00000717          	auipc	a4,0x0
 912:	6ef73923          	sd	a5,1778(a4) # 1000 <freep>
}
 916:	6422                	ld	s0,8(sp)
 918:	0141                	addi	sp,sp,16
 91a:	8082                	ret

000000000000091c <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 91c:	7139                	addi	sp,sp,-64
 91e:	fc06                	sd	ra,56(sp)
 920:	f822                	sd	s0,48(sp)
 922:	f426                	sd	s1,40(sp)
 924:	f04a                	sd	s2,32(sp)
 926:	ec4e                	sd	s3,24(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
 92e:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 930:	02051493          	slli	s1,a0,0x20
 934:	9081                	srli	s1,s1,0x20
 936:	04bd                	addi	s1,s1,15
 938:	8091                	srli	s1,s1,0x4
 93a:	0014899b          	addiw	s3,s1,1
 93e:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 940:	00000517          	auipc	a0,0x0
 944:	6c053503          	ld	a0,1728(a0) # 1000 <freep>
 948:	c515                	beqz	a0,974 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 94a:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 94c:	4798                	lw	a4,8(a5)
 94e:	02977f63          	bgeu	a4,s1,98c <malloc+0x70>
 952:	8a4e                	mv	s4,s3
 954:	0009871b          	sext.w	a4,s3
 958:	6685                	lui	a3,0x1
 95a:	00d77363          	bgeu	a4,a3,960 <malloc+0x44>
 95e:	6a05                	lui	s4,0x1
 960:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 964:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 968:	00000917          	auipc	s2,0x0
 96c:	69890913          	addi	s2,s2,1688 # 1000 <freep>
    if (p == (char *)-1)
 970:	5afd                	li	s5,-1
 972:	a895                	j	9e6 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 974:	00000797          	auipc	a5,0x0
 978:	69c78793          	addi	a5,a5,1692 # 1010 <base>
 97c:	00000717          	auipc	a4,0x0
 980:	68f73223          	sd	a5,1668(a4) # 1000 <freep>
 984:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 986:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 98a:	b7e1                	j	952 <malloc+0x36>
            if (p->s.size == nunits)
 98c:	02e48c63          	beq	s1,a4,9c4 <malloc+0xa8>
                p->s.size -= nunits;
 990:	4137073b          	subw	a4,a4,s3
 994:	c798                	sw	a4,8(a5)
                p += p->s.size;
 996:	02071693          	slli	a3,a4,0x20
 99a:	01c6d713          	srli	a4,a3,0x1c
 99e:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 9a0:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 9a4:	00000717          	auipc	a4,0x0
 9a8:	64a73e23          	sd	a0,1628(a4) # 1000 <freep>
            return (void *)(p + 1);
 9ac:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 9b0:	70e2                	ld	ra,56(sp)
 9b2:	7442                	ld	s0,48(sp)
 9b4:	74a2                	ld	s1,40(sp)
 9b6:	7902                	ld	s2,32(sp)
 9b8:	69e2                	ld	s3,24(sp)
 9ba:	6a42                	ld	s4,16(sp)
 9bc:	6aa2                	ld	s5,8(sp)
 9be:	6b02                	ld	s6,0(sp)
 9c0:	6121                	addi	sp,sp,64
 9c2:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 9c4:	6398                	ld	a4,0(a5)
 9c6:	e118                	sd	a4,0(a0)
 9c8:	bff1                	j	9a4 <malloc+0x88>
    hp->s.size = nu;
 9ca:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 9ce:	0541                	addi	a0,a0,16
 9d0:	00000097          	auipc	ra,0x0
 9d4:	eca080e7          	jalr	-310(ra) # 89a <free>
    return freep;
 9d8:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 9dc:	d971                	beqz	a0,9b0 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9de:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 9e0:	4798                	lw	a4,8(a5)
 9e2:	fa9775e3          	bgeu	a4,s1,98c <malloc+0x70>
        if (p == freep)
 9e6:	00093703          	ld	a4,0(s2)
 9ea:	853e                	mv	a0,a5
 9ec:	fef719e3          	bne	a4,a5,9de <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 9f0:	8552                	mv	a0,s4
 9f2:	00000097          	auipc	ra,0x0
 9f6:	b68080e7          	jalr	-1176(ra) # 55a <sbrk>
    if (p == (char *)-1)
 9fa:	fd5518e3          	bne	a0,s5,9ca <malloc+0xae>
                return 0;
 9fe:	4501                	li	a0,0
 a00:	bf45                	j	9b0 <malloc+0x94>
