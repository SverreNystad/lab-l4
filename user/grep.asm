
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	0880                	addi	s0,sp,80
 130:	89aa                	mv	s3,a0
 132:	8b2e                	mv	s6,a1
  m = 0;
 134:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 136:	3ff00b93          	li	s7,1023
 13a:	00001a97          	auipc	s5,0x1
 13e:	ed6a8a93          	addi	s5,s5,-298 # 1010 <buf>
 142:	a0a1                	j	18a <grep+0x70>
      p = q+1;
 144:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 148:	45a9                	li	a1,10
 14a:	854a                	mv	a0,s2
 14c:	00000097          	auipc	ra,0x0
 150:	3c8080e7          	jalr	968(ra) # 514 <strchr>
 154:	84aa                	mv	s1,a0
 156:	c905                	beqz	a0,186 <grep+0x6c>
      *q = 0;
 158:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15c:	85ca                	mv	a1,s2
 15e:	854e                	mv	a0,s3
 160:	00000097          	auipc	ra,0x0
 164:	f6c080e7          	jalr	-148(ra) # cc <match>
 168:	dd71                	beqz	a0,144 <grep+0x2a>
        *q = '\n';
 16a:	47a9                	li	a5,10
 16c:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 170:	00148613          	addi	a2,s1,1
 174:	4126063b          	subw	a2,a2,s2
 178:	85ca                	mv	a1,s2
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	590080e7          	jalr	1424(ra) # 70c <write>
 184:	b7c1                	j	144 <grep+0x2a>
    if(m > 0){
 186:	03404563          	bgtz	s4,1b0 <grep+0x96>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18a:	414b863b          	subw	a2,s7,s4
 18e:	014a85b3          	add	a1,s5,s4
 192:	855a                	mv	a0,s6
 194:	00000097          	auipc	ra,0x0
 198:	570080e7          	jalr	1392(ra) # 704 <read>
 19c:	02a05663          	blez	a0,1c8 <grep+0xae>
    m += n;
 1a0:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1a4:	014a87b3          	add	a5,s5,s4
 1a8:	00078023          	sb	zero,0(a5)
    p = buf;
 1ac:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1ae:	bf69                	j	148 <grep+0x2e>
      m -= p - buf;
 1b0:	415907b3          	sub	a5,s2,s5
 1b4:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1b8:	8652                	mv	a2,s4
 1ba:	85ca                	mv	a1,s2
 1bc:	8556                	mv	a0,s5
 1be:	00000097          	auipc	ra,0x0
 1c2:	47c080e7          	jalr	1148(ra) # 63a <memmove>
 1c6:	b7d1                	j	18a <grep+0x70>
}
 1c8:	60a6                	ld	ra,72(sp)
 1ca:	6406                	ld	s0,64(sp)
 1cc:	74e2                	ld	s1,56(sp)
 1ce:	7942                	ld	s2,48(sp)
 1d0:	79a2                	ld	s3,40(sp)
 1d2:	7a02                	ld	s4,32(sp)
 1d4:	6ae2                	ld	s5,24(sp)
 1d6:	6b42                	ld	s6,16(sp)
 1d8:	6ba2                	ld	s7,8(sp)
 1da:	6161                	addi	sp,sp,80
 1dc:	8082                	ret

00000000000001de <main>:
{
 1de:	7139                	addi	sp,sp,-64
 1e0:	fc06                	sd	ra,56(sp)
 1e2:	f822                	sd	s0,48(sp)
 1e4:	f426                	sd	s1,40(sp)
 1e6:	f04a                	sd	s2,32(sp)
 1e8:	ec4e                	sd	s3,24(sp)
 1ea:	e852                	sd	s4,16(sp)
 1ec:	e456                	sd	s5,8(sp)
 1ee:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1f0:	4785                	li	a5,1
 1f2:	04a7de63          	bge	a5,a0,24e <main+0x70>
  pattern = argv[1];
 1f6:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1fa:	4789                	li	a5,2
 1fc:	06a7d763          	bge	a5,a0,26a <main+0x8c>
 200:	01058913          	addi	s2,a1,16
 204:	ffd5099b          	addiw	s3,a0,-3
 208:	02099793          	slli	a5,s3,0x20
 20c:	01d7d993          	srli	s3,a5,0x1d
 210:	05e1                	addi	a1,a1,24
 212:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 214:	4581                	li	a1,0
 216:	00093503          	ld	a0,0(s2)
 21a:	00000097          	auipc	ra,0x0
 21e:	512080e7          	jalr	1298(ra) # 72c <open>
 222:	84aa                	mv	s1,a0
 224:	04054e63          	bltz	a0,280 <main+0xa2>
    grep(pattern, fd);
 228:	85aa                	mv	a1,a0
 22a:	8552                	mv	a0,s4
 22c:	00000097          	auipc	ra,0x0
 230:	eee080e7          	jalr	-274(ra) # 11a <grep>
    close(fd);
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	4de080e7          	jalr	1246(ra) # 714 <close>
  for(i = 2; i < argc; i++){
 23e:	0921                	addi	s2,s2,8
 240:	fd391ae3          	bne	s2,s3,214 <main+0x36>
  exit(0);
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	4a6080e7          	jalr	1190(ra) # 6ec <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 24e:	00001597          	auipc	a1,0x1
 252:	9d258593          	addi	a1,a1,-1582 # c20 <malloc+0xea>
 256:	4509                	li	a0,2
 258:	00000097          	auipc	ra,0x0
 25c:	7f8080e7          	jalr	2040(ra) # a50 <fprintf>
    exit(1);
 260:	4505                	li	a0,1
 262:	00000097          	auipc	ra,0x0
 266:	48a080e7          	jalr	1162(ra) # 6ec <exit>
    grep(pattern, 0);
 26a:	4581                	li	a1,0
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	eac080e7          	jalr	-340(ra) # 11a <grep>
    exit(0);
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	474080e7          	jalr	1140(ra) # 6ec <exit>
      printf("grep: cannot open %s\n", argv[i]);
 280:	00093583          	ld	a1,0(s2)
 284:	00001517          	auipc	a0,0x1
 288:	9bc50513          	addi	a0,a0,-1604 # c40 <malloc+0x10a>
 28c:	00000097          	auipc	ra,0x0
 290:	7f2080e7          	jalr	2034(ra) # a7e <printf>
      exit(1);
 294:	4505                	li	a0,1
 296:	00000097          	auipc	ra,0x0
 29a:	456080e7          	jalr	1110(ra) # 6ec <exit>

000000000000029e <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
    lk->name = name;
 2a4:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
 2a6:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
 2aa:	57fd                	li	a5,-1
 2ac:	00f50823          	sb	a5,16(a0)
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	e399                	bnez	a5,2c0 <holding+0xa>
 2bc:	4501                	li	a0,0
}
 2be:	8082                	ret
{
 2c0:	1101                	addi	sp,sp,-32
 2c2:	ec06                	sd	ra,24(sp)
 2c4:	e822                	sd	s0,16(sp)
 2c6:	e426                	sd	s1,8(sp)
 2c8:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
 2ca:	01054483          	lbu	s1,16(a0)
 2ce:	00000097          	auipc	ra,0x0
 2d2:	122080e7          	jalr	290(ra) # 3f0 <twhoami>
 2d6:	2501                	sext.w	a0,a0
 2d8:	40a48533          	sub	a0,s1,a0
 2dc:	00153513          	seqz	a0,a0
}
 2e0:	60e2                	ld	ra,24(sp)
 2e2:	6442                	ld	s0,16(sp)
 2e4:	64a2                	ld	s1,8(sp)
 2e6:	6105                	addi	sp,sp,32
 2e8:	8082                	ret

00000000000002ea <acquire>:

void acquire(struct lock *lk)
{
 2ea:	7179                	addi	sp,sp,-48
 2ec:	f406                	sd	ra,40(sp)
 2ee:	f022                	sd	s0,32(sp)
 2f0:	ec26                	sd	s1,24(sp)
 2f2:	e84a                	sd	s2,16(sp)
 2f4:	e44e                	sd	s3,8(sp)
 2f6:	e052                	sd	s4,0(sp)
 2f8:	1800                	addi	s0,sp,48
 2fa:	8a2a                	mv	s4,a0
    if (holding(lk))
 2fc:	00000097          	auipc	ra,0x0
 300:	fba080e7          	jalr	-70(ra) # 2b6 <holding>
 304:	e919                	bnez	a0,31a <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 306:	ffca7493          	andi	s1,s4,-4
 30a:	003a7913          	andi	s2,s4,3
 30e:	0039191b          	slliw	s2,s2,0x3
 312:	4985                	li	s3,1
 314:	012999bb          	sllw	s3,s3,s2
 318:	a015                	j	33c <acquire+0x52>
        printf("re-acquiring lock we already hold");
 31a:	00001517          	auipc	a0,0x1
 31e:	93e50513          	addi	a0,a0,-1730 # c58 <malloc+0x122>
 322:	00000097          	auipc	ra,0x0
 326:	75c080e7          	jalr	1884(ra) # a7e <printf>
        exit(-1);
 32a:	557d                	li	a0,-1
 32c:	00000097          	auipc	ra,0x0
 330:	3c0080e7          	jalr	960(ra) # 6ec <exit>
    {
        // give up the cpu for other threads
        tyield();
 334:	00000097          	auipc	ra,0x0
 338:	0b0080e7          	jalr	176(ra) # 3e4 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 33c:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 340:	0127d7bb          	srlw	a5,a5,s2
 344:	0ff7f793          	zext.b	a5,a5
 348:	f7f5                	bnez	a5,334 <acquire+0x4a>
    }

    __sync_synchronize();
 34a:	0ff0000f          	fence

    lk->tid = twhoami();
 34e:	00000097          	auipc	ra,0x0
 352:	0a2080e7          	jalr	162(ra) # 3f0 <twhoami>
 356:	00aa0823          	sb	a0,16(s4)
}
 35a:	70a2                	ld	ra,40(sp)
 35c:	7402                	ld	s0,32(sp)
 35e:	64e2                	ld	s1,24(sp)
 360:	6942                	ld	s2,16(sp)
 362:	69a2                	ld	s3,8(sp)
 364:	6a02                	ld	s4,0(sp)
 366:	6145                	addi	sp,sp,48
 368:	8082                	ret

000000000000036a <release>:

void release(struct lock *lk)
{
 36a:	1101                	addi	sp,sp,-32
 36c:	ec06                	sd	ra,24(sp)
 36e:	e822                	sd	s0,16(sp)
 370:	e426                	sd	s1,8(sp)
 372:	1000                	addi	s0,sp,32
 374:	84aa                	mv	s1,a0
    if (!holding(lk))
 376:	00000097          	auipc	ra,0x0
 37a:	f40080e7          	jalr	-192(ra) # 2b6 <holding>
 37e:	c11d                	beqz	a0,3a4 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 380:	57fd                	li	a5,-1
 382:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 386:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 38a:	0ff0000f          	fence
 38e:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 392:	00000097          	auipc	ra,0x0
 396:	052080e7          	jalr	82(ra) # 3e4 <tyield>
}
 39a:	60e2                	ld	ra,24(sp)
 39c:	6442                	ld	s0,16(sp)
 39e:	64a2                	ld	s1,8(sp)
 3a0:	6105                	addi	sp,sp,32
 3a2:	8082                	ret
        printf("releasing lock we are not holding");
 3a4:	00001517          	auipc	a0,0x1
 3a8:	8dc50513          	addi	a0,a0,-1828 # c80 <malloc+0x14a>
 3ac:	00000097          	auipc	ra,0x0
 3b0:	6d2080e7          	jalr	1746(ra) # a7e <printf>
        exit(-1);
 3b4:	557d                	li	a0,-1
 3b6:	00000097          	auipc	ra,0x0
 3ba:	336080e7          	jalr	822(ra) # 6ec <exit>

00000000000003be <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 3c4:	6422                	ld	s0,8(sp)
 3c6:	0141                	addi	sp,sp,16
 3c8:	8082                	ret

00000000000003ca <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e422                	sd	s0,8(sp)
 3ce:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 3d0:	6422                	ld	s0,8(sp)
 3d2:	0141                	addi	sp,sp,16
 3d4:	8082                	ret

00000000000003d6 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 3d6:	1141                	addi	sp,sp,-16
 3d8:	e422                	sd	s0,8(sp)
 3da:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 3dc:	4501                	li	a0,0
 3de:	6422                	ld	s0,8(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret

00000000000003e4 <tyield>:

void tyield()
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e422                	sd	s0,8(sp)
 3e8:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 3ea:	6422                	ld	s0,8(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret

00000000000003f0 <twhoami>:

uint8 twhoami()
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e422                	sd	s0,8(sp)
 3f4:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 3f6:	4501                	li	a0,0
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret

00000000000003fe <tswtch>:
 3fe:	00153023          	sd	ra,0(a0)
 402:	00253423          	sd	sp,8(a0)
 406:	e900                	sd	s0,16(a0)
 408:	ed04                	sd	s1,24(a0)
 40a:	03253023          	sd	s2,32(a0)
 40e:	03353423          	sd	s3,40(a0)
 412:	03453823          	sd	s4,48(a0)
 416:	03553c23          	sd	s5,56(a0)
 41a:	05653023          	sd	s6,64(a0)
 41e:	05753423          	sd	s7,72(a0)
 422:	05853823          	sd	s8,80(a0)
 426:	05953c23          	sd	s9,88(a0)
 42a:	07a53023          	sd	s10,96(a0)
 42e:	07b53423          	sd	s11,104(a0)
 432:	0005b083          	ld	ra,0(a1)
 436:	0085b103          	ld	sp,8(a1)
 43a:	6980                	ld	s0,16(a1)
 43c:	6d84                	ld	s1,24(a1)
 43e:	0205b903          	ld	s2,32(a1)
 442:	0285b983          	ld	s3,40(a1)
 446:	0305ba03          	ld	s4,48(a1)
 44a:	0385ba83          	ld	s5,56(a1)
 44e:	0405bb03          	ld	s6,64(a1)
 452:	0485bb83          	ld	s7,72(a1)
 456:	0505bc03          	ld	s8,80(a1)
 45a:	0585bc83          	ld	s9,88(a1)
 45e:	0605bd03          	ld	s10,96(a1)
 462:	0685bd83          	ld	s11,104(a1)
 466:	8082                	ret

0000000000000468 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 468:	1141                	addi	sp,sp,-16
 46a:	e406                	sd	ra,8(sp)
 46c:	e022                	sd	s0,0(sp)
 46e:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 470:	00000097          	auipc	ra,0x0
 474:	d6e080e7          	jalr	-658(ra) # 1de <main>
    exit(res);
 478:	00000097          	auipc	ra,0x0
 47c:	274080e7          	jalr	628(ra) # 6ec <exit>

0000000000000480 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 480:	1141                	addi	sp,sp,-16
 482:	e422                	sd	s0,8(sp)
 484:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 486:	87aa                	mv	a5,a0
 488:	0585                	addi	a1,a1,1
 48a:	0785                	addi	a5,a5,1
 48c:	fff5c703          	lbu	a4,-1(a1)
 490:	fee78fa3          	sb	a4,-1(a5)
 494:	fb75                	bnez	a4,488 <strcpy+0x8>
        ;
    return os;
}
 496:	6422                	ld	s0,8(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret

000000000000049c <strcmp>:

int strcmp(const char *p, const char *q)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e422                	sd	s0,8(sp)
 4a0:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	cb91                	beqz	a5,4ba <strcmp+0x1e>
 4a8:	0005c703          	lbu	a4,0(a1)
 4ac:	00f71763          	bne	a4,a5,4ba <strcmp+0x1e>
        p++, q++;
 4b0:	0505                	addi	a0,a0,1
 4b2:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 4b4:	00054783          	lbu	a5,0(a0)
 4b8:	fbe5                	bnez	a5,4a8 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 4ba:	0005c503          	lbu	a0,0(a1)
}
 4be:	40a7853b          	subw	a0,a5,a0
 4c2:	6422                	ld	s0,8(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret

00000000000004c8 <strlen>:

uint strlen(const char *s)
{
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e422                	sd	s0,8(sp)
 4cc:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 4ce:	00054783          	lbu	a5,0(a0)
 4d2:	cf91                	beqz	a5,4ee <strlen+0x26>
 4d4:	0505                	addi	a0,a0,1
 4d6:	87aa                	mv	a5,a0
 4d8:	4685                	li	a3,1
 4da:	9e89                	subw	a3,a3,a0
 4dc:	00f6853b          	addw	a0,a3,a5
 4e0:	0785                	addi	a5,a5,1
 4e2:	fff7c703          	lbu	a4,-1(a5)
 4e6:	fb7d                	bnez	a4,4dc <strlen+0x14>
        ;
    return n;
}
 4e8:	6422                	ld	s0,8(sp)
 4ea:	0141                	addi	sp,sp,16
 4ec:	8082                	ret
    for (n = 0; s[n]; n++)
 4ee:	4501                	li	a0,0
 4f0:	bfe5                	j	4e8 <strlen+0x20>

00000000000004f2 <memset>:

void *
memset(void *dst, int c, uint n)
{
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e422                	sd	s0,8(sp)
 4f6:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 4f8:	ca19                	beqz	a2,50e <memset+0x1c>
 4fa:	87aa                	mv	a5,a0
 4fc:	1602                	slli	a2,a2,0x20
 4fe:	9201                	srli	a2,a2,0x20
 500:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 504:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 508:	0785                	addi	a5,a5,1
 50a:	fee79de3          	bne	a5,a4,504 <memset+0x12>
    }
    return dst;
}
 50e:	6422                	ld	s0,8(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret

0000000000000514 <strchr>:

char *
strchr(const char *s, char c)
{
 514:	1141                	addi	sp,sp,-16
 516:	e422                	sd	s0,8(sp)
 518:	0800                	addi	s0,sp,16
    for (; *s; s++)
 51a:	00054783          	lbu	a5,0(a0)
 51e:	cb99                	beqz	a5,534 <strchr+0x20>
        if (*s == c)
 520:	00f58763          	beq	a1,a5,52e <strchr+0x1a>
    for (; *s; s++)
 524:	0505                	addi	a0,a0,1
 526:	00054783          	lbu	a5,0(a0)
 52a:	fbfd                	bnez	a5,520 <strchr+0xc>
            return (char *)s;
    return 0;
 52c:	4501                	li	a0,0
}
 52e:	6422                	ld	s0,8(sp)
 530:	0141                	addi	sp,sp,16
 532:	8082                	ret
    return 0;
 534:	4501                	li	a0,0
 536:	bfe5                	j	52e <strchr+0x1a>

0000000000000538 <gets>:

char *
gets(char *buf, int max)
{
 538:	711d                	addi	sp,sp,-96
 53a:	ec86                	sd	ra,88(sp)
 53c:	e8a2                	sd	s0,80(sp)
 53e:	e4a6                	sd	s1,72(sp)
 540:	e0ca                	sd	s2,64(sp)
 542:	fc4e                	sd	s3,56(sp)
 544:	f852                	sd	s4,48(sp)
 546:	f456                	sd	s5,40(sp)
 548:	f05a                	sd	s6,32(sp)
 54a:	ec5e                	sd	s7,24(sp)
 54c:	1080                	addi	s0,sp,96
 54e:	8baa                	mv	s7,a0
 550:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 552:	892a                	mv	s2,a0
 554:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 556:	4aa9                	li	s5,10
 558:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 55a:	89a6                	mv	s3,s1
 55c:	2485                	addiw	s1,s1,1
 55e:	0344d863          	bge	s1,s4,58e <gets+0x56>
        cc = read(0, &c, 1);
 562:	4605                	li	a2,1
 564:	faf40593          	addi	a1,s0,-81
 568:	4501                	li	a0,0
 56a:	00000097          	auipc	ra,0x0
 56e:	19a080e7          	jalr	410(ra) # 704 <read>
        if (cc < 1)
 572:	00a05e63          	blez	a0,58e <gets+0x56>
        buf[i++] = c;
 576:	faf44783          	lbu	a5,-81(s0)
 57a:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 57e:	01578763          	beq	a5,s5,58c <gets+0x54>
 582:	0905                	addi	s2,s2,1
 584:	fd679be3          	bne	a5,s6,55a <gets+0x22>
    for (i = 0; i + 1 < max;)
 588:	89a6                	mv	s3,s1
 58a:	a011                	j	58e <gets+0x56>
 58c:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 58e:	99de                	add	s3,s3,s7
 590:	00098023          	sb	zero,0(s3)
    return buf;
}
 594:	855e                	mv	a0,s7
 596:	60e6                	ld	ra,88(sp)
 598:	6446                	ld	s0,80(sp)
 59a:	64a6                	ld	s1,72(sp)
 59c:	6906                	ld	s2,64(sp)
 59e:	79e2                	ld	s3,56(sp)
 5a0:	7a42                	ld	s4,48(sp)
 5a2:	7aa2                	ld	s5,40(sp)
 5a4:	7b02                	ld	s6,32(sp)
 5a6:	6be2                	ld	s7,24(sp)
 5a8:	6125                	addi	sp,sp,96
 5aa:	8082                	ret

00000000000005ac <stat>:

int stat(const char *n, struct stat *st)
{
 5ac:	1101                	addi	sp,sp,-32
 5ae:	ec06                	sd	ra,24(sp)
 5b0:	e822                	sd	s0,16(sp)
 5b2:	e426                	sd	s1,8(sp)
 5b4:	e04a                	sd	s2,0(sp)
 5b6:	1000                	addi	s0,sp,32
 5b8:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 5ba:	4581                	li	a1,0
 5bc:	00000097          	auipc	ra,0x0
 5c0:	170080e7          	jalr	368(ra) # 72c <open>
    if (fd < 0)
 5c4:	02054563          	bltz	a0,5ee <stat+0x42>
 5c8:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 5ca:	85ca                	mv	a1,s2
 5cc:	00000097          	auipc	ra,0x0
 5d0:	178080e7          	jalr	376(ra) # 744 <fstat>
 5d4:	892a                	mv	s2,a0
    close(fd);
 5d6:	8526                	mv	a0,s1
 5d8:	00000097          	auipc	ra,0x0
 5dc:	13c080e7          	jalr	316(ra) # 714 <close>
    return r;
}
 5e0:	854a                	mv	a0,s2
 5e2:	60e2                	ld	ra,24(sp)
 5e4:	6442                	ld	s0,16(sp)
 5e6:	64a2                	ld	s1,8(sp)
 5e8:	6902                	ld	s2,0(sp)
 5ea:	6105                	addi	sp,sp,32
 5ec:	8082                	ret
        return -1;
 5ee:	597d                	li	s2,-1
 5f0:	bfc5                	j	5e0 <stat+0x34>

00000000000005f2 <atoi>:

int atoi(const char *s)
{
 5f2:	1141                	addi	sp,sp,-16
 5f4:	e422                	sd	s0,8(sp)
 5f6:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 5f8:	00054683          	lbu	a3,0(a0)
 5fc:	fd06879b          	addiw	a5,a3,-48
 600:	0ff7f793          	zext.b	a5,a5
 604:	4625                	li	a2,9
 606:	02f66863          	bltu	a2,a5,636 <atoi+0x44>
 60a:	872a                	mv	a4,a0
    n = 0;
 60c:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 60e:	0705                	addi	a4,a4,1
 610:	0025179b          	slliw	a5,a0,0x2
 614:	9fa9                	addw	a5,a5,a0
 616:	0017979b          	slliw	a5,a5,0x1
 61a:	9fb5                	addw	a5,a5,a3
 61c:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 620:	00074683          	lbu	a3,0(a4)
 624:	fd06879b          	addiw	a5,a3,-48
 628:	0ff7f793          	zext.b	a5,a5
 62c:	fef671e3          	bgeu	a2,a5,60e <atoi+0x1c>
    return n;
}
 630:	6422                	ld	s0,8(sp)
 632:	0141                	addi	sp,sp,16
 634:	8082                	ret
    n = 0;
 636:	4501                	li	a0,0
 638:	bfe5                	j	630 <atoi+0x3e>

000000000000063a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 63a:	1141                	addi	sp,sp,-16
 63c:	e422                	sd	s0,8(sp)
 63e:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 640:	02b57463          	bgeu	a0,a1,668 <memmove+0x2e>
    {
        while (n-- > 0)
 644:	00c05f63          	blez	a2,662 <memmove+0x28>
 648:	1602                	slli	a2,a2,0x20
 64a:	9201                	srli	a2,a2,0x20
 64c:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 650:	872a                	mv	a4,a0
            *dst++ = *src++;
 652:	0585                	addi	a1,a1,1
 654:	0705                	addi	a4,a4,1
 656:	fff5c683          	lbu	a3,-1(a1)
 65a:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 65e:	fee79ae3          	bne	a5,a4,652 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 662:	6422                	ld	s0,8(sp)
 664:	0141                	addi	sp,sp,16
 666:	8082                	ret
        dst += n;
 668:	00c50733          	add	a4,a0,a2
        src += n;
 66c:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 66e:	fec05ae3          	blez	a2,662 <memmove+0x28>
 672:	fff6079b          	addiw	a5,a2,-1
 676:	1782                	slli	a5,a5,0x20
 678:	9381                	srli	a5,a5,0x20
 67a:	fff7c793          	not	a5,a5
 67e:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 680:	15fd                	addi	a1,a1,-1
 682:	177d                	addi	a4,a4,-1
 684:	0005c683          	lbu	a3,0(a1)
 688:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 68c:	fee79ae3          	bne	a5,a4,680 <memmove+0x46>
 690:	bfc9                	j	662 <memmove+0x28>

0000000000000692 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 692:	1141                	addi	sp,sp,-16
 694:	e422                	sd	s0,8(sp)
 696:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 698:	ca05                	beqz	a2,6c8 <memcmp+0x36>
 69a:	fff6069b          	addiw	a3,a2,-1
 69e:	1682                	slli	a3,a3,0x20
 6a0:	9281                	srli	a3,a3,0x20
 6a2:	0685                	addi	a3,a3,1
 6a4:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 6a6:	00054783          	lbu	a5,0(a0)
 6aa:	0005c703          	lbu	a4,0(a1)
 6ae:	00e79863          	bne	a5,a4,6be <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 6b2:	0505                	addi	a0,a0,1
        p2++;
 6b4:	0585                	addi	a1,a1,1
    while (n-- > 0)
 6b6:	fed518e3          	bne	a0,a3,6a6 <memcmp+0x14>
    }
    return 0;
 6ba:	4501                	li	a0,0
 6bc:	a019                	j	6c2 <memcmp+0x30>
            return *p1 - *p2;
 6be:	40e7853b          	subw	a0,a5,a4
}
 6c2:	6422                	ld	s0,8(sp)
 6c4:	0141                	addi	sp,sp,16
 6c6:	8082                	ret
    return 0;
 6c8:	4501                	li	a0,0
 6ca:	bfe5                	j	6c2 <memcmp+0x30>

00000000000006cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6cc:	1141                	addi	sp,sp,-16
 6ce:	e406                	sd	ra,8(sp)
 6d0:	e022                	sd	s0,0(sp)
 6d2:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 6d4:	00000097          	auipc	ra,0x0
 6d8:	f66080e7          	jalr	-154(ra) # 63a <memmove>
}
 6dc:	60a2                	ld	ra,8(sp)
 6de:	6402                	ld	s0,0(sp)
 6e0:	0141                	addi	sp,sp,16
 6e2:	8082                	ret

00000000000006e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6e4:	4885                	li	a7,1
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 6ec:	4889                	li	a7,2
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6f4:	488d                	li	a7,3
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6fc:	4891                	li	a7,4
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <read>:
.global read
read:
 li a7, SYS_read
 704:	4895                	li	a7,5
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <write>:
.global write
write:
 li a7, SYS_write
 70c:	48c1                	li	a7,16
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <close>:
.global close
close:
 li a7, SYS_close
 714:	48d5                	li	a7,21
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <kill>:
.global kill
kill:
 li a7, SYS_kill
 71c:	4899                	li	a7,6
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <exec>:
.global exec
exec:
 li a7, SYS_exec
 724:	489d                	li	a7,7
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <open>:
.global open
open:
 li a7, SYS_open
 72c:	48bd                	li	a7,15
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 734:	48c5                	li	a7,17
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 73c:	48c9                	li	a7,18
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 744:	48a1                	li	a7,8
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <link>:
.global link
link:
 li a7, SYS_link
 74c:	48cd                	li	a7,19
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 754:	48d1                	li	a7,20
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 75c:	48a5                	li	a7,9
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <dup>:
.global dup
dup:
 li a7, SYS_dup
 764:	48a9                	li	a7,10
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 76c:	48ad                	li	a7,11
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 774:	48b1                	li	a7,12
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 77c:	48b5                	li	a7,13
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 784:	48b9                	li	a7,14
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <ps>:
.global ps
ps:
 li a7, SYS_ps
 78c:	48d9                	li	a7,22
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 794:	48dd                	li	a7,23
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 79c:	48e1                	li	a7,24
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7a4:	1101                	addi	sp,sp,-32
 7a6:	ec06                	sd	ra,24(sp)
 7a8:	e822                	sd	s0,16(sp)
 7aa:	1000                	addi	s0,sp,32
 7ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7b0:	4605                	li	a2,1
 7b2:	fef40593          	addi	a1,s0,-17
 7b6:	00000097          	auipc	ra,0x0
 7ba:	f56080e7          	jalr	-170(ra) # 70c <write>
}
 7be:	60e2                	ld	ra,24(sp)
 7c0:	6442                	ld	s0,16(sp)
 7c2:	6105                	addi	sp,sp,32
 7c4:	8082                	ret

00000000000007c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7c6:	7139                	addi	sp,sp,-64
 7c8:	fc06                	sd	ra,56(sp)
 7ca:	f822                	sd	s0,48(sp)
 7cc:	f426                	sd	s1,40(sp)
 7ce:	f04a                	sd	s2,32(sp)
 7d0:	ec4e                	sd	s3,24(sp)
 7d2:	0080                	addi	s0,sp,64
 7d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7d6:	c299                	beqz	a3,7dc <printint+0x16>
 7d8:	0805c963          	bltz	a1,86a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7dc:	2581                	sext.w	a1,a1
  neg = 0;
 7de:	4881                	li	a7,0
 7e0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7e6:	2601                	sext.w	a2,a2
 7e8:	00000517          	auipc	a0,0x0
 7ec:	52050513          	addi	a0,a0,1312 # d08 <digits>
 7f0:	883a                	mv	a6,a4
 7f2:	2705                	addiw	a4,a4,1
 7f4:	02c5f7bb          	remuw	a5,a1,a2
 7f8:	1782                	slli	a5,a5,0x20
 7fa:	9381                	srli	a5,a5,0x20
 7fc:	97aa                	add	a5,a5,a0
 7fe:	0007c783          	lbu	a5,0(a5)
 802:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 806:	0005879b          	sext.w	a5,a1
 80a:	02c5d5bb          	divuw	a1,a1,a2
 80e:	0685                	addi	a3,a3,1
 810:	fec7f0e3          	bgeu	a5,a2,7f0 <printint+0x2a>
  if(neg)
 814:	00088c63          	beqz	a7,82c <printint+0x66>
    buf[i++] = '-';
 818:	fd070793          	addi	a5,a4,-48
 81c:	00878733          	add	a4,a5,s0
 820:	02d00793          	li	a5,45
 824:	fef70823          	sb	a5,-16(a4)
 828:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 82c:	02e05863          	blez	a4,85c <printint+0x96>
 830:	fc040793          	addi	a5,s0,-64
 834:	00e78933          	add	s2,a5,a4
 838:	fff78993          	addi	s3,a5,-1
 83c:	99ba                	add	s3,s3,a4
 83e:	377d                	addiw	a4,a4,-1
 840:	1702                	slli	a4,a4,0x20
 842:	9301                	srli	a4,a4,0x20
 844:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 848:	fff94583          	lbu	a1,-1(s2)
 84c:	8526                	mv	a0,s1
 84e:	00000097          	auipc	ra,0x0
 852:	f56080e7          	jalr	-170(ra) # 7a4 <putc>
  while(--i >= 0)
 856:	197d                	addi	s2,s2,-1
 858:	ff3918e3          	bne	s2,s3,848 <printint+0x82>
}
 85c:	70e2                	ld	ra,56(sp)
 85e:	7442                	ld	s0,48(sp)
 860:	74a2                	ld	s1,40(sp)
 862:	7902                	ld	s2,32(sp)
 864:	69e2                	ld	s3,24(sp)
 866:	6121                	addi	sp,sp,64
 868:	8082                	ret
    x = -xx;
 86a:	40b005bb          	negw	a1,a1
    neg = 1;
 86e:	4885                	li	a7,1
    x = -xx;
 870:	bf85                	j	7e0 <printint+0x1a>

0000000000000872 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 872:	7119                	addi	sp,sp,-128
 874:	fc86                	sd	ra,120(sp)
 876:	f8a2                	sd	s0,112(sp)
 878:	f4a6                	sd	s1,104(sp)
 87a:	f0ca                	sd	s2,96(sp)
 87c:	ecce                	sd	s3,88(sp)
 87e:	e8d2                	sd	s4,80(sp)
 880:	e4d6                	sd	s5,72(sp)
 882:	e0da                	sd	s6,64(sp)
 884:	fc5e                	sd	s7,56(sp)
 886:	f862                	sd	s8,48(sp)
 888:	f466                	sd	s9,40(sp)
 88a:	f06a                	sd	s10,32(sp)
 88c:	ec6e                	sd	s11,24(sp)
 88e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 890:	0005c903          	lbu	s2,0(a1)
 894:	18090f63          	beqz	s2,a32 <vprintf+0x1c0>
 898:	8aaa                	mv	s5,a0
 89a:	8b32                	mv	s6,a2
 89c:	00158493          	addi	s1,a1,1
  state = 0;
 8a0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8a2:	02500a13          	li	s4,37
 8a6:	4c55                	li	s8,21
 8a8:	00000c97          	auipc	s9,0x0
 8ac:	408c8c93          	addi	s9,s9,1032 # cb0 <malloc+0x17a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8b0:	02800d93          	li	s11,40
  putc(fd, 'x');
 8b4:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b6:	00000b97          	auipc	s7,0x0
 8ba:	452b8b93          	addi	s7,s7,1106 # d08 <digits>
 8be:	a839                	j	8dc <vprintf+0x6a>
        putc(fd, c);
 8c0:	85ca                	mv	a1,s2
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	ee0080e7          	jalr	-288(ra) # 7a4 <putc>
 8cc:	a019                	j	8d2 <vprintf+0x60>
    } else if(state == '%'){
 8ce:	01498d63          	beq	s3,s4,8e8 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 8d2:	0485                	addi	s1,s1,1
 8d4:	fff4c903          	lbu	s2,-1(s1)
 8d8:	14090d63          	beqz	s2,a32 <vprintf+0x1c0>
    if(state == 0){
 8dc:	fe0999e3          	bnez	s3,8ce <vprintf+0x5c>
      if(c == '%'){
 8e0:	ff4910e3          	bne	s2,s4,8c0 <vprintf+0x4e>
        state = '%';
 8e4:	89d2                	mv	s3,s4
 8e6:	b7f5                	j	8d2 <vprintf+0x60>
      if(c == 'd'){
 8e8:	11490c63          	beq	s2,s4,a00 <vprintf+0x18e>
 8ec:	f9d9079b          	addiw	a5,s2,-99
 8f0:	0ff7f793          	zext.b	a5,a5
 8f4:	10fc6e63          	bltu	s8,a5,a10 <vprintf+0x19e>
 8f8:	f9d9079b          	addiw	a5,s2,-99
 8fc:	0ff7f713          	zext.b	a4,a5
 900:	10ec6863          	bltu	s8,a4,a10 <vprintf+0x19e>
 904:	00271793          	slli	a5,a4,0x2
 908:	97e6                	add	a5,a5,s9
 90a:	439c                	lw	a5,0(a5)
 90c:	97e6                	add	a5,a5,s9
 90e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 910:	008b0913          	addi	s2,s6,8
 914:	4685                	li	a3,1
 916:	4629                	li	a2,10
 918:	000b2583          	lw	a1,0(s6)
 91c:	8556                	mv	a0,s5
 91e:	00000097          	auipc	ra,0x0
 922:	ea8080e7          	jalr	-344(ra) # 7c6 <printint>
 926:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 928:	4981                	li	s3,0
 92a:	b765                	j	8d2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 92c:	008b0913          	addi	s2,s6,8
 930:	4681                	li	a3,0
 932:	4629                	li	a2,10
 934:	000b2583          	lw	a1,0(s6)
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	e8c080e7          	jalr	-372(ra) # 7c6 <printint>
 942:	8b4a                	mv	s6,s2
      state = 0;
 944:	4981                	li	s3,0
 946:	b771                	j	8d2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 948:	008b0913          	addi	s2,s6,8
 94c:	4681                	li	a3,0
 94e:	866a                	mv	a2,s10
 950:	000b2583          	lw	a1,0(s6)
 954:	8556                	mv	a0,s5
 956:	00000097          	auipc	ra,0x0
 95a:	e70080e7          	jalr	-400(ra) # 7c6 <printint>
 95e:	8b4a                	mv	s6,s2
      state = 0;
 960:	4981                	li	s3,0
 962:	bf85                	j	8d2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 964:	008b0793          	addi	a5,s6,8
 968:	f8f43423          	sd	a5,-120(s0)
 96c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 970:	03000593          	li	a1,48
 974:	8556                	mv	a0,s5
 976:	00000097          	auipc	ra,0x0
 97a:	e2e080e7          	jalr	-466(ra) # 7a4 <putc>
  putc(fd, 'x');
 97e:	07800593          	li	a1,120
 982:	8556                	mv	a0,s5
 984:	00000097          	auipc	ra,0x0
 988:	e20080e7          	jalr	-480(ra) # 7a4 <putc>
 98c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 98e:	03c9d793          	srli	a5,s3,0x3c
 992:	97de                	add	a5,a5,s7
 994:	0007c583          	lbu	a1,0(a5)
 998:	8556                	mv	a0,s5
 99a:	00000097          	auipc	ra,0x0
 99e:	e0a080e7          	jalr	-502(ra) # 7a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9a2:	0992                	slli	s3,s3,0x4
 9a4:	397d                	addiw	s2,s2,-1
 9a6:	fe0914e3          	bnez	s2,98e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 9aa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9ae:	4981                	li	s3,0
 9b0:	b70d                	j	8d2 <vprintf+0x60>
        s = va_arg(ap, char*);
 9b2:	008b0913          	addi	s2,s6,8
 9b6:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 9ba:	02098163          	beqz	s3,9dc <vprintf+0x16a>
        while(*s != 0){
 9be:	0009c583          	lbu	a1,0(s3)
 9c2:	c5ad                	beqz	a1,a2c <vprintf+0x1ba>
          putc(fd, *s);
 9c4:	8556                	mv	a0,s5
 9c6:	00000097          	auipc	ra,0x0
 9ca:	dde080e7          	jalr	-546(ra) # 7a4 <putc>
          s++;
 9ce:	0985                	addi	s3,s3,1
        while(*s != 0){
 9d0:	0009c583          	lbu	a1,0(s3)
 9d4:	f9e5                	bnez	a1,9c4 <vprintf+0x152>
        s = va_arg(ap, char*);
 9d6:	8b4a                	mv	s6,s2
      state = 0;
 9d8:	4981                	li	s3,0
 9da:	bde5                	j	8d2 <vprintf+0x60>
          s = "(null)";
 9dc:	00000997          	auipc	s3,0x0
 9e0:	2cc98993          	addi	s3,s3,716 # ca8 <malloc+0x172>
        while(*s != 0){
 9e4:	85ee                	mv	a1,s11
 9e6:	bff9                	j	9c4 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 9e8:	008b0913          	addi	s2,s6,8
 9ec:	000b4583          	lbu	a1,0(s6)
 9f0:	8556                	mv	a0,s5
 9f2:	00000097          	auipc	ra,0x0
 9f6:	db2080e7          	jalr	-590(ra) # 7a4 <putc>
 9fa:	8b4a                	mv	s6,s2
      state = 0;
 9fc:	4981                	li	s3,0
 9fe:	bdd1                	j	8d2 <vprintf+0x60>
        putc(fd, c);
 a00:	85d2                	mv	a1,s4
 a02:	8556                	mv	a0,s5
 a04:	00000097          	auipc	ra,0x0
 a08:	da0080e7          	jalr	-608(ra) # 7a4 <putc>
      state = 0;
 a0c:	4981                	li	s3,0
 a0e:	b5d1                	j	8d2 <vprintf+0x60>
        putc(fd, '%');
 a10:	85d2                	mv	a1,s4
 a12:	8556                	mv	a0,s5
 a14:	00000097          	auipc	ra,0x0
 a18:	d90080e7          	jalr	-624(ra) # 7a4 <putc>
        putc(fd, c);
 a1c:	85ca                	mv	a1,s2
 a1e:	8556                	mv	a0,s5
 a20:	00000097          	auipc	ra,0x0
 a24:	d84080e7          	jalr	-636(ra) # 7a4 <putc>
      state = 0;
 a28:	4981                	li	s3,0
 a2a:	b565                	j	8d2 <vprintf+0x60>
        s = va_arg(ap, char*);
 a2c:	8b4a                	mv	s6,s2
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	b54d                	j	8d2 <vprintf+0x60>
    }
  }
}
 a32:	70e6                	ld	ra,120(sp)
 a34:	7446                	ld	s0,112(sp)
 a36:	74a6                	ld	s1,104(sp)
 a38:	7906                	ld	s2,96(sp)
 a3a:	69e6                	ld	s3,88(sp)
 a3c:	6a46                	ld	s4,80(sp)
 a3e:	6aa6                	ld	s5,72(sp)
 a40:	6b06                	ld	s6,64(sp)
 a42:	7be2                	ld	s7,56(sp)
 a44:	7c42                	ld	s8,48(sp)
 a46:	7ca2                	ld	s9,40(sp)
 a48:	7d02                	ld	s10,32(sp)
 a4a:	6de2                	ld	s11,24(sp)
 a4c:	6109                	addi	sp,sp,128
 a4e:	8082                	ret

0000000000000a50 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a50:	715d                	addi	sp,sp,-80
 a52:	ec06                	sd	ra,24(sp)
 a54:	e822                	sd	s0,16(sp)
 a56:	1000                	addi	s0,sp,32
 a58:	e010                	sd	a2,0(s0)
 a5a:	e414                	sd	a3,8(s0)
 a5c:	e818                	sd	a4,16(s0)
 a5e:	ec1c                	sd	a5,24(s0)
 a60:	03043023          	sd	a6,32(s0)
 a64:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a68:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a6c:	8622                	mv	a2,s0
 a6e:	00000097          	auipc	ra,0x0
 a72:	e04080e7          	jalr	-508(ra) # 872 <vprintf>
}
 a76:	60e2                	ld	ra,24(sp)
 a78:	6442                	ld	s0,16(sp)
 a7a:	6161                	addi	sp,sp,80
 a7c:	8082                	ret

0000000000000a7e <printf>:

void
printf(const char *fmt, ...)
{
 a7e:	711d                	addi	sp,sp,-96
 a80:	ec06                	sd	ra,24(sp)
 a82:	e822                	sd	s0,16(sp)
 a84:	1000                	addi	s0,sp,32
 a86:	e40c                	sd	a1,8(s0)
 a88:	e810                	sd	a2,16(s0)
 a8a:	ec14                	sd	a3,24(s0)
 a8c:	f018                	sd	a4,32(s0)
 a8e:	f41c                	sd	a5,40(s0)
 a90:	03043823          	sd	a6,48(s0)
 a94:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a98:	00840613          	addi	a2,s0,8
 a9c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 aa0:	85aa                	mv	a1,a0
 aa2:	4505                	li	a0,1
 aa4:	00000097          	auipc	ra,0x0
 aa8:	dce080e7          	jalr	-562(ra) # 872 <vprintf>
}
 aac:	60e2                	ld	ra,24(sp)
 aae:	6442                	ld	s0,16(sp)
 ab0:	6125                	addi	sp,sp,96
 ab2:	8082                	ret

0000000000000ab4 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 ab4:	1141                	addi	sp,sp,-16
 ab6:	e422                	sd	s0,8(sp)
 ab8:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 aba:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 abe:	00000797          	auipc	a5,0x0
 ac2:	5427b783          	ld	a5,1346(a5) # 1000 <freep>
 ac6:	a02d                	j	af0 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 ac8:	4618                	lw	a4,8(a2)
 aca:	9f2d                	addw	a4,a4,a1
 acc:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 ad0:	6398                	ld	a4,0(a5)
 ad2:	6310                	ld	a2,0(a4)
 ad4:	a83d                	j	b12 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 ad6:	ff852703          	lw	a4,-8(a0)
 ada:	9f31                	addw	a4,a4,a2
 adc:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 ade:	ff053683          	ld	a3,-16(a0)
 ae2:	a091                	j	b26 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae4:	6398                	ld	a4,0(a5)
 ae6:	00e7e463          	bltu	a5,a4,aee <free+0x3a>
 aea:	00e6ea63          	bltu	a3,a4,afe <free+0x4a>
{
 aee:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af0:	fed7fae3          	bgeu	a5,a3,ae4 <free+0x30>
 af4:	6398                	ld	a4,0(a5)
 af6:	00e6e463          	bltu	a3,a4,afe <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 afa:	fee7eae3          	bltu	a5,a4,aee <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 afe:	ff852583          	lw	a1,-8(a0)
 b02:	6390                	ld	a2,0(a5)
 b04:	02059813          	slli	a6,a1,0x20
 b08:	01c85713          	srli	a4,a6,0x1c
 b0c:	9736                	add	a4,a4,a3
 b0e:	fae60de3          	beq	a2,a4,ac8 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 b12:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 b16:	4790                	lw	a2,8(a5)
 b18:	02061593          	slli	a1,a2,0x20
 b1c:	01c5d713          	srli	a4,a1,0x1c
 b20:	973e                	add	a4,a4,a5
 b22:	fae68ae3          	beq	a3,a4,ad6 <free+0x22>
        p->s.ptr = bp->s.ptr;
 b26:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 b28:	00000717          	auipc	a4,0x0
 b2c:	4cf73c23          	sd	a5,1240(a4) # 1000 <freep>
}
 b30:	6422                	ld	s0,8(sp)
 b32:	0141                	addi	sp,sp,16
 b34:	8082                	ret

0000000000000b36 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 b36:	7139                	addi	sp,sp,-64
 b38:	fc06                	sd	ra,56(sp)
 b3a:	f822                	sd	s0,48(sp)
 b3c:	f426                	sd	s1,40(sp)
 b3e:	f04a                	sd	s2,32(sp)
 b40:	ec4e                	sd	s3,24(sp)
 b42:	e852                	sd	s4,16(sp)
 b44:	e456                	sd	s5,8(sp)
 b46:	e05a                	sd	s6,0(sp)
 b48:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 b4a:	02051493          	slli	s1,a0,0x20
 b4e:	9081                	srli	s1,s1,0x20
 b50:	04bd                	addi	s1,s1,15
 b52:	8091                	srli	s1,s1,0x4
 b54:	0014899b          	addiw	s3,s1,1
 b58:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 b5a:	00000517          	auipc	a0,0x0
 b5e:	4a653503          	ld	a0,1190(a0) # 1000 <freep>
 b62:	c515                	beqz	a0,b8e <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 b64:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 b66:	4798                	lw	a4,8(a5)
 b68:	02977f63          	bgeu	a4,s1,ba6 <malloc+0x70>
 b6c:	8a4e                	mv	s4,s3
 b6e:	0009871b          	sext.w	a4,s3
 b72:	6685                	lui	a3,0x1
 b74:	00d77363          	bgeu	a4,a3,b7a <malloc+0x44>
 b78:	6a05                	lui	s4,0x1
 b7a:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 b7e:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 b82:	00000917          	auipc	s2,0x0
 b86:	47e90913          	addi	s2,s2,1150 # 1000 <freep>
    if (p == (char *)-1)
 b8a:	5afd                	li	s5,-1
 b8c:	a895                	j	c00 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 b8e:	00001797          	auipc	a5,0x1
 b92:	88278793          	addi	a5,a5,-1918 # 1410 <base>
 b96:	00000717          	auipc	a4,0x0
 b9a:	46f73523          	sd	a5,1130(a4) # 1000 <freep>
 b9e:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 ba0:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 ba4:	b7e1                	j	b6c <malloc+0x36>
            if (p->s.size == nunits)
 ba6:	02e48c63          	beq	s1,a4,bde <malloc+0xa8>
                p->s.size -= nunits;
 baa:	4137073b          	subw	a4,a4,s3
 bae:	c798                	sw	a4,8(a5)
                p += p->s.size;
 bb0:	02071693          	slli	a3,a4,0x20
 bb4:	01c6d713          	srli	a4,a3,0x1c
 bb8:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 bba:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 bbe:	00000717          	auipc	a4,0x0
 bc2:	44a73123          	sd	a0,1090(a4) # 1000 <freep>
            return (void *)(p + 1);
 bc6:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 bca:	70e2                	ld	ra,56(sp)
 bcc:	7442                	ld	s0,48(sp)
 bce:	74a2                	ld	s1,40(sp)
 bd0:	7902                	ld	s2,32(sp)
 bd2:	69e2                	ld	s3,24(sp)
 bd4:	6a42                	ld	s4,16(sp)
 bd6:	6aa2                	ld	s5,8(sp)
 bd8:	6b02                	ld	s6,0(sp)
 bda:	6121                	addi	sp,sp,64
 bdc:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 bde:	6398                	ld	a4,0(a5)
 be0:	e118                	sd	a4,0(a0)
 be2:	bff1                	j	bbe <malloc+0x88>
    hp->s.size = nu;
 be4:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 be8:	0541                	addi	a0,a0,16
 bea:	00000097          	auipc	ra,0x0
 bee:	eca080e7          	jalr	-310(ra) # ab4 <free>
    return freep;
 bf2:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 bf6:	d971                	beqz	a0,bca <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 bf8:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 bfa:	4798                	lw	a4,8(a5)
 bfc:	fa9775e3          	bgeu	a4,s1,ba6 <malloc+0x70>
        if (p == freep)
 c00:	00093703          	ld	a4,0(s2)
 c04:	853e                	mv	a0,a5
 c06:	fef719e3          	bne	a4,a5,bf8 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 c0a:	8552                	mv	a0,s4
 c0c:	00000097          	auipc	ra,0x0
 c10:	b68080e7          	jalr	-1176(ra) # 774 <sbrk>
    if (p == (char *)-1)
 c14:	fd5518e3          	bne	a0,s5,be4 <malloc+0xae>
                return 0;
 c18:	4501                	li	a0,0
 c1a:	bf45                	j	bca <malloc+0x94>
