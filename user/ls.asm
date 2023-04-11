
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	4f0080e7          	jalr	1264(ra) # 500 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	4c4080e7          	jalr	1220(ra) # 500 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	4a2080e7          	jalr	1186(ra) # 500 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	5fc080e7          	jalr	1532(ra) # 672 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	480080e7          	jalr	1152(ra) # 500 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	472080e7          	jalr	1138(ra) # 500 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	482080e7          	jalr	1154(ra) # 52a <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	68a080e7          	jalr	1674(ra) # 764 <open>
  e2:	08054163          	bltz	a0,164 <ls+0xb0>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	690080e7          	jalr	1680(ra) # 77c <fstat>
  f4:	08054363          	bltz	a0,17a <ls+0xc6>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68c63          	beq	a3,a4,19a <ls+0xe6>
 106:	37f9                	addiw	a5,a5,-2
 108:	17c2                	slli	a5,a5,0x30
 10a:	93c1                	srli	a5,a5,0x30
 10c:	02f76663          	bltu	a4,a5,138 <ls+0x84>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 110:	854a                	mv	a0,s2
 112:	00000097          	auipc	ra,0x0
 116:	eee080e7          	jalr	-274(ra) # 0 <fmtname>
 11a:	85aa                	mv	a1,a0
 11c:	da843703          	ld	a4,-600(s0)
 120:	d9c42683          	lw	a3,-612(s0)
 124:	da041603          	lh	a2,-608(s0)
 128:	00001517          	auipc	a0,0x1
 12c:	b6850513          	addi	a0,a0,-1176 # c90 <malloc+0x122>
 130:	00001097          	auipc	ra,0x1
 134:	986080e7          	jalr	-1658(ra) # ab6 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 138:	8526                	mv	a0,s1
 13a:	00000097          	auipc	ra,0x0
 13e:	612080e7          	jalr	1554(ra) # 74c <close>
}
 142:	26813083          	ld	ra,616(sp)
 146:	26013403          	ld	s0,608(sp)
 14a:	25813483          	ld	s1,600(sp)
 14e:	25013903          	ld	s2,592(sp)
 152:	24813983          	ld	s3,584(sp)
 156:	24013a03          	ld	s4,576(sp)
 15a:	23813a83          	ld	s5,568(sp)
 15e:	27010113          	addi	sp,sp,624
 162:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 164:	864a                	mv	a2,s2
 166:	00001597          	auipc	a1,0x1
 16a:	afa58593          	addi	a1,a1,-1286 # c60 <malloc+0xf2>
 16e:	4509                	li	a0,2
 170:	00001097          	auipc	ra,0x1
 174:	918080e7          	jalr	-1768(ra) # a88 <fprintf>
    return;
 178:	b7e9                	j	142 <ls+0x8e>
    fprintf(2, "ls: cannot stat %s\n", path);
 17a:	864a                	mv	a2,s2
 17c:	00001597          	auipc	a1,0x1
 180:	afc58593          	addi	a1,a1,-1284 # c78 <malloc+0x10a>
 184:	4509                	li	a0,2
 186:	00001097          	auipc	ra,0x1
 18a:	902080e7          	jalr	-1790(ra) # a88 <fprintf>
    close(fd);
 18e:	8526                	mv	a0,s1
 190:	00000097          	auipc	ra,0x0
 194:	5bc080e7          	jalr	1468(ra) # 74c <close>
    return;
 198:	b76d                	j	142 <ls+0x8e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19a:	854a                	mv	a0,s2
 19c:	00000097          	auipc	ra,0x0
 1a0:	364080e7          	jalr	868(ra) # 500 <strlen>
 1a4:	2541                	addiw	a0,a0,16
 1a6:	20000793          	li	a5,512
 1aa:	00a7fb63          	bgeu	a5,a0,1c0 <ls+0x10c>
      printf("ls: path too long\n");
 1ae:	00001517          	auipc	a0,0x1
 1b2:	af250513          	addi	a0,a0,-1294 # ca0 <malloc+0x132>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	900080e7          	jalr	-1792(ra) # ab6 <printf>
      break;
 1be:	bfad                	j	138 <ls+0x84>
    strcpy(buf, path);
 1c0:	85ca                	mv	a1,s2
 1c2:	dc040513          	addi	a0,s0,-576
 1c6:	00000097          	auipc	ra,0x0
 1ca:	2f2080e7          	jalr	754(ra) # 4b8 <strcpy>
    p = buf+strlen(buf);
 1ce:	dc040513          	addi	a0,s0,-576
 1d2:	00000097          	auipc	ra,0x0
 1d6:	32e080e7          	jalr	814(ra) # 500 <strlen>
 1da:	1502                	slli	a0,a0,0x20
 1dc:	9101                	srli	a0,a0,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1e6:	00190993          	addi	s3,s2,1
 1ea:	02f00793          	li	a5,47
 1ee:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f2:	00001a17          	auipc	s4,0x1
 1f6:	ac6a0a13          	addi	s4,s4,-1338 # cb8 <malloc+0x14a>
        printf("ls: cannot stat %s\n", buf);
 1fa:	00001a97          	auipc	s5,0x1
 1fe:	a7ea8a93          	addi	s5,s5,-1410 # c78 <malloc+0x10a>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	a801                	j	212 <ls+0x15e>
        printf("ls: cannot stat %s\n", buf);
 204:	dc040593          	addi	a1,s0,-576
 208:	8556                	mv	a0,s5
 20a:	00001097          	auipc	ra,0x1
 20e:	8ac080e7          	jalr	-1876(ra) # ab6 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 212:	4641                	li	a2,16
 214:	db040593          	addi	a1,s0,-592
 218:	8526                	mv	a0,s1
 21a:	00000097          	auipc	ra,0x0
 21e:	522080e7          	jalr	1314(ra) # 73c <read>
 222:	47c1                	li	a5,16
 224:	f0f51ae3          	bne	a0,a5,138 <ls+0x84>
      if(de.inum == 0)
 228:	db045783          	lhu	a5,-592(s0)
 22c:	d3fd                	beqz	a5,212 <ls+0x15e>
      memmove(p, de.name, DIRSIZ);
 22e:	4639                	li	a2,14
 230:	db240593          	addi	a1,s0,-590
 234:	854e                	mv	a0,s3
 236:	00000097          	auipc	ra,0x0
 23a:	43c080e7          	jalr	1084(ra) # 672 <memmove>
      p[DIRSIZ] = 0;
 23e:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 242:	d9840593          	addi	a1,s0,-616
 246:	dc040513          	addi	a0,s0,-576
 24a:	00000097          	auipc	ra,0x0
 24e:	39a080e7          	jalr	922(ra) # 5e4 <stat>
 252:	fa0549e3          	bltz	a0,204 <ls+0x150>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 256:	dc040513          	addi	a0,s0,-576
 25a:	00000097          	auipc	ra,0x0
 25e:	da6080e7          	jalr	-602(ra) # 0 <fmtname>
 262:	85aa                	mv	a1,a0
 264:	da843703          	ld	a4,-600(s0)
 268:	d9c42683          	lw	a3,-612(s0)
 26c:	da041603          	lh	a2,-608(s0)
 270:	8552                	mv	a0,s4
 272:	00001097          	auipc	ra,0x1
 276:	844080e7          	jalr	-1980(ra) # ab6 <printf>
 27a:	bf61                	j	212 <ls+0x15e>

000000000000027c <main>:

int
main(int argc, char *argv[])
{
 27c:	1101                	addi	sp,sp,-32
 27e:	ec06                	sd	ra,24(sp)
 280:	e822                	sd	s0,16(sp)
 282:	e426                	sd	s1,8(sp)
 284:	e04a                	sd	s2,0(sp)
 286:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 288:	4785                	li	a5,1
 28a:	02a7d963          	bge	a5,a0,2bc <main+0x40>
 28e:	00858493          	addi	s1,a1,8
 292:	ffe5091b          	addiw	s2,a0,-2
 296:	02091793          	slli	a5,s2,0x20
 29a:	01d7d913          	srli	s2,a5,0x1d
 29e:	05c1                	addi	a1,a1,16
 2a0:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a2:	6088                	ld	a0,0(s1)
 2a4:	00000097          	auipc	ra,0x0
 2a8:	e10080e7          	jalr	-496(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2ac:	04a1                	addi	s1,s1,8
 2ae:	ff249ae3          	bne	s1,s2,2a2 <main+0x26>
  exit(0);
 2b2:	4501                	li	a0,0
 2b4:	00000097          	auipc	ra,0x0
 2b8:	470080e7          	jalr	1136(ra) # 724 <exit>
    ls(".");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	a0c50513          	addi	a0,a0,-1524 # cc8 <malloc+0x15a>
 2c4:	00000097          	auipc	ra,0x0
 2c8:	df0080e7          	jalr	-528(ra) # b4 <ls>
    exit(0);
 2cc:	4501                	li	a0,0
 2ce:	00000097          	auipc	ra,0x0
 2d2:	456080e7          	jalr	1110(ra) # 724 <exit>

00000000000002d6 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
    lk->name = name;
 2dc:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
 2de:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
 2e2:	57fd                	li	a5,-1
 2e4:	00f50823          	sb	a5,16(a0)
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	e399                	bnez	a5,2f8 <holding+0xa>
 2f4:	4501                	li	a0,0
}
 2f6:	8082                	ret
{
 2f8:	1101                	addi	sp,sp,-32
 2fa:	ec06                	sd	ra,24(sp)
 2fc:	e822                	sd	s0,16(sp)
 2fe:	e426                	sd	s1,8(sp)
 300:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
 302:	01054483          	lbu	s1,16(a0)
 306:	00000097          	auipc	ra,0x0
 30a:	122080e7          	jalr	290(ra) # 428 <twhoami>
 30e:	2501                	sext.w	a0,a0
 310:	40a48533          	sub	a0,s1,a0
 314:	00153513          	seqz	a0,a0
}
 318:	60e2                	ld	ra,24(sp)
 31a:	6442                	ld	s0,16(sp)
 31c:	64a2                	ld	s1,8(sp)
 31e:	6105                	addi	sp,sp,32
 320:	8082                	ret

0000000000000322 <acquire>:

void acquire(struct lock *lk)
{
 322:	7179                	addi	sp,sp,-48
 324:	f406                	sd	ra,40(sp)
 326:	f022                	sd	s0,32(sp)
 328:	ec26                	sd	s1,24(sp)
 32a:	e84a                	sd	s2,16(sp)
 32c:	e44e                	sd	s3,8(sp)
 32e:	e052                	sd	s4,0(sp)
 330:	1800                	addi	s0,sp,48
 332:	8a2a                	mv	s4,a0
    if (holding(lk))
 334:	00000097          	auipc	ra,0x0
 338:	fba080e7          	jalr	-70(ra) # 2ee <holding>
 33c:	e919                	bnez	a0,352 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 33e:	ffca7493          	andi	s1,s4,-4
 342:	003a7913          	andi	s2,s4,3
 346:	0039191b          	slliw	s2,s2,0x3
 34a:	4985                	li	s3,1
 34c:	012999bb          	sllw	s3,s3,s2
 350:	a015                	j	374 <acquire+0x52>
        printf("re-acquiring lock we already hold");
 352:	00001517          	auipc	a0,0x1
 356:	97e50513          	addi	a0,a0,-1666 # cd0 <malloc+0x162>
 35a:	00000097          	auipc	ra,0x0
 35e:	75c080e7          	jalr	1884(ra) # ab6 <printf>
        exit(-1);
 362:	557d                	li	a0,-1
 364:	00000097          	auipc	ra,0x0
 368:	3c0080e7          	jalr	960(ra) # 724 <exit>
    {
        // give up the cpu for other threads
        tyield();
 36c:	00000097          	auipc	ra,0x0
 370:	0b0080e7          	jalr	176(ra) # 41c <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 374:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 378:	0127d7bb          	srlw	a5,a5,s2
 37c:	0ff7f793          	zext.b	a5,a5
 380:	f7f5                	bnez	a5,36c <acquire+0x4a>
    }

    __sync_synchronize();
 382:	0ff0000f          	fence

    lk->tid = twhoami();
 386:	00000097          	auipc	ra,0x0
 38a:	0a2080e7          	jalr	162(ra) # 428 <twhoami>
 38e:	00aa0823          	sb	a0,16(s4)
}
 392:	70a2                	ld	ra,40(sp)
 394:	7402                	ld	s0,32(sp)
 396:	64e2                	ld	s1,24(sp)
 398:	6942                	ld	s2,16(sp)
 39a:	69a2                	ld	s3,8(sp)
 39c:	6a02                	ld	s4,0(sp)
 39e:	6145                	addi	sp,sp,48
 3a0:	8082                	ret

00000000000003a2 <release>:

void release(struct lock *lk)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	e426                	sd	s1,8(sp)
 3aa:	1000                	addi	s0,sp,32
 3ac:	84aa                	mv	s1,a0
    if (!holding(lk))
 3ae:	00000097          	auipc	ra,0x0
 3b2:	f40080e7          	jalr	-192(ra) # 2ee <holding>
 3b6:	c11d                	beqz	a0,3dc <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 3b8:	57fd                	li	a5,-1
 3ba:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 3be:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 3c2:	0ff0000f          	fence
 3c6:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 3ca:	00000097          	auipc	ra,0x0
 3ce:	052080e7          	jalr	82(ra) # 41c <tyield>
}
 3d2:	60e2                	ld	ra,24(sp)
 3d4:	6442                	ld	s0,16(sp)
 3d6:	64a2                	ld	s1,8(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret
        printf("releasing lock we are not holding");
 3dc:	00001517          	auipc	a0,0x1
 3e0:	91c50513          	addi	a0,a0,-1764 # cf8 <malloc+0x18a>
 3e4:	00000097          	auipc	ra,0x0
 3e8:	6d2080e7          	jalr	1746(ra) # ab6 <printf>
        exit(-1);
 3ec:	557d                	li	a0,-1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	336080e7          	jalr	822(ra) # 724 <exit>

00000000000003f6 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e422                	sd	s0,8(sp)
 3fa:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 3fc:	6422                	ld	s0,8(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret

0000000000000402 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 414:	4501                	li	a0,0
 416:	6422                	ld	s0,8(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret

000000000000041c <tyield>:

void tyield()
{
 41c:	1141                	addi	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret

0000000000000428 <twhoami>:

uint8 twhoami()
{
 428:	1141                	addi	sp,sp,-16
 42a:	e422                	sd	s0,8(sp)
 42c:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 42e:	4501                	li	a0,0
 430:	6422                	ld	s0,8(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret

0000000000000436 <tswtch>:
 436:	00153023          	sd	ra,0(a0)
 43a:	00253423          	sd	sp,8(a0)
 43e:	e900                	sd	s0,16(a0)
 440:	ed04                	sd	s1,24(a0)
 442:	03253023          	sd	s2,32(a0)
 446:	03353423          	sd	s3,40(a0)
 44a:	03453823          	sd	s4,48(a0)
 44e:	03553c23          	sd	s5,56(a0)
 452:	05653023          	sd	s6,64(a0)
 456:	05753423          	sd	s7,72(a0)
 45a:	05853823          	sd	s8,80(a0)
 45e:	05953c23          	sd	s9,88(a0)
 462:	07a53023          	sd	s10,96(a0)
 466:	07b53423          	sd	s11,104(a0)
 46a:	0005b083          	ld	ra,0(a1)
 46e:	0085b103          	ld	sp,8(a1)
 472:	6980                	ld	s0,16(a1)
 474:	6d84                	ld	s1,24(a1)
 476:	0205b903          	ld	s2,32(a1)
 47a:	0285b983          	ld	s3,40(a1)
 47e:	0305ba03          	ld	s4,48(a1)
 482:	0385ba83          	ld	s5,56(a1)
 486:	0405bb03          	ld	s6,64(a1)
 48a:	0485bb83          	ld	s7,72(a1)
 48e:	0505bc03          	ld	s8,80(a1)
 492:	0585bc83          	ld	s9,88(a1)
 496:	0605bd03          	ld	s10,96(a1)
 49a:	0685bd83          	ld	s11,104(a1)
 49e:	8082                	ret

00000000000004a0 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 4a0:	1141                	addi	sp,sp,-16
 4a2:	e406                	sd	ra,8(sp)
 4a4:	e022                	sd	s0,0(sp)
 4a6:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 4a8:	00000097          	auipc	ra,0x0
 4ac:	dd4080e7          	jalr	-556(ra) # 27c <main>
    exit(res);
 4b0:	00000097          	auipc	ra,0x0
 4b4:	274080e7          	jalr	628(ra) # 724 <exit>

00000000000004b8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e422                	sd	s0,8(sp)
 4bc:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 4be:	87aa                	mv	a5,a0
 4c0:	0585                	addi	a1,a1,1
 4c2:	0785                	addi	a5,a5,1
 4c4:	fff5c703          	lbu	a4,-1(a1)
 4c8:	fee78fa3          	sb	a4,-1(a5)
 4cc:	fb75                	bnez	a4,4c0 <strcpy+0x8>
        ;
    return os;
}
 4ce:	6422                	ld	s0,8(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret

00000000000004d4 <strcmp>:

int strcmp(const char *p, const char *q)
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e422                	sd	s0,8(sp)
 4d8:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 4da:	00054783          	lbu	a5,0(a0)
 4de:	cb91                	beqz	a5,4f2 <strcmp+0x1e>
 4e0:	0005c703          	lbu	a4,0(a1)
 4e4:	00f71763          	bne	a4,a5,4f2 <strcmp+0x1e>
        p++, q++;
 4e8:	0505                	addi	a0,a0,1
 4ea:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 4ec:	00054783          	lbu	a5,0(a0)
 4f0:	fbe5                	bnez	a5,4e0 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 4f2:	0005c503          	lbu	a0,0(a1)
}
 4f6:	40a7853b          	subw	a0,a5,a0
 4fa:	6422                	ld	s0,8(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret

0000000000000500 <strlen>:

uint strlen(const char *s)
{
 500:	1141                	addi	sp,sp,-16
 502:	e422                	sd	s0,8(sp)
 504:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 506:	00054783          	lbu	a5,0(a0)
 50a:	cf91                	beqz	a5,526 <strlen+0x26>
 50c:	0505                	addi	a0,a0,1
 50e:	87aa                	mv	a5,a0
 510:	4685                	li	a3,1
 512:	9e89                	subw	a3,a3,a0
 514:	00f6853b          	addw	a0,a3,a5
 518:	0785                	addi	a5,a5,1
 51a:	fff7c703          	lbu	a4,-1(a5)
 51e:	fb7d                	bnez	a4,514 <strlen+0x14>
        ;
    return n;
}
 520:	6422                	ld	s0,8(sp)
 522:	0141                	addi	sp,sp,16
 524:	8082                	ret
    for (n = 0; s[n]; n++)
 526:	4501                	li	a0,0
 528:	bfe5                	j	520 <strlen+0x20>

000000000000052a <memset>:

void *
memset(void *dst, int c, uint n)
{
 52a:	1141                	addi	sp,sp,-16
 52c:	e422                	sd	s0,8(sp)
 52e:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 530:	ca19                	beqz	a2,546 <memset+0x1c>
 532:	87aa                	mv	a5,a0
 534:	1602                	slli	a2,a2,0x20
 536:	9201                	srli	a2,a2,0x20
 538:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 53c:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 540:	0785                	addi	a5,a5,1
 542:	fee79de3          	bne	a5,a4,53c <memset+0x12>
    }
    return dst;
}
 546:	6422                	ld	s0,8(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret

000000000000054c <strchr>:

char *
strchr(const char *s, char c)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e422                	sd	s0,8(sp)
 550:	0800                	addi	s0,sp,16
    for (; *s; s++)
 552:	00054783          	lbu	a5,0(a0)
 556:	cb99                	beqz	a5,56c <strchr+0x20>
        if (*s == c)
 558:	00f58763          	beq	a1,a5,566 <strchr+0x1a>
    for (; *s; s++)
 55c:	0505                	addi	a0,a0,1
 55e:	00054783          	lbu	a5,0(a0)
 562:	fbfd                	bnez	a5,558 <strchr+0xc>
            return (char *)s;
    return 0;
 564:	4501                	li	a0,0
}
 566:	6422                	ld	s0,8(sp)
 568:	0141                	addi	sp,sp,16
 56a:	8082                	ret
    return 0;
 56c:	4501                	li	a0,0
 56e:	bfe5                	j	566 <strchr+0x1a>

0000000000000570 <gets>:

char *
gets(char *buf, int max)
{
 570:	711d                	addi	sp,sp,-96
 572:	ec86                	sd	ra,88(sp)
 574:	e8a2                	sd	s0,80(sp)
 576:	e4a6                	sd	s1,72(sp)
 578:	e0ca                	sd	s2,64(sp)
 57a:	fc4e                	sd	s3,56(sp)
 57c:	f852                	sd	s4,48(sp)
 57e:	f456                	sd	s5,40(sp)
 580:	f05a                	sd	s6,32(sp)
 582:	ec5e                	sd	s7,24(sp)
 584:	1080                	addi	s0,sp,96
 586:	8baa                	mv	s7,a0
 588:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 58a:	892a                	mv	s2,a0
 58c:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 58e:	4aa9                	li	s5,10
 590:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 592:	89a6                	mv	s3,s1
 594:	2485                	addiw	s1,s1,1
 596:	0344d863          	bge	s1,s4,5c6 <gets+0x56>
        cc = read(0, &c, 1);
 59a:	4605                	li	a2,1
 59c:	faf40593          	addi	a1,s0,-81
 5a0:	4501                	li	a0,0
 5a2:	00000097          	auipc	ra,0x0
 5a6:	19a080e7          	jalr	410(ra) # 73c <read>
        if (cc < 1)
 5aa:	00a05e63          	blez	a0,5c6 <gets+0x56>
        buf[i++] = c;
 5ae:	faf44783          	lbu	a5,-81(s0)
 5b2:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 5b6:	01578763          	beq	a5,s5,5c4 <gets+0x54>
 5ba:	0905                	addi	s2,s2,1
 5bc:	fd679be3          	bne	a5,s6,592 <gets+0x22>
    for (i = 0; i + 1 < max;)
 5c0:	89a6                	mv	s3,s1
 5c2:	a011                	j	5c6 <gets+0x56>
 5c4:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 5c6:	99de                	add	s3,s3,s7
 5c8:	00098023          	sb	zero,0(s3)
    return buf;
}
 5cc:	855e                	mv	a0,s7
 5ce:	60e6                	ld	ra,88(sp)
 5d0:	6446                	ld	s0,80(sp)
 5d2:	64a6                	ld	s1,72(sp)
 5d4:	6906                	ld	s2,64(sp)
 5d6:	79e2                	ld	s3,56(sp)
 5d8:	7a42                	ld	s4,48(sp)
 5da:	7aa2                	ld	s5,40(sp)
 5dc:	7b02                	ld	s6,32(sp)
 5de:	6be2                	ld	s7,24(sp)
 5e0:	6125                	addi	sp,sp,96
 5e2:	8082                	ret

00000000000005e4 <stat>:

int stat(const char *n, struct stat *st)
{
 5e4:	1101                	addi	sp,sp,-32
 5e6:	ec06                	sd	ra,24(sp)
 5e8:	e822                	sd	s0,16(sp)
 5ea:	e426                	sd	s1,8(sp)
 5ec:	e04a                	sd	s2,0(sp)
 5ee:	1000                	addi	s0,sp,32
 5f0:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 5f2:	4581                	li	a1,0
 5f4:	00000097          	auipc	ra,0x0
 5f8:	170080e7          	jalr	368(ra) # 764 <open>
    if (fd < 0)
 5fc:	02054563          	bltz	a0,626 <stat+0x42>
 600:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 602:	85ca                	mv	a1,s2
 604:	00000097          	auipc	ra,0x0
 608:	178080e7          	jalr	376(ra) # 77c <fstat>
 60c:	892a                	mv	s2,a0
    close(fd);
 60e:	8526                	mv	a0,s1
 610:	00000097          	auipc	ra,0x0
 614:	13c080e7          	jalr	316(ra) # 74c <close>
    return r;
}
 618:	854a                	mv	a0,s2
 61a:	60e2                	ld	ra,24(sp)
 61c:	6442                	ld	s0,16(sp)
 61e:	64a2                	ld	s1,8(sp)
 620:	6902                	ld	s2,0(sp)
 622:	6105                	addi	sp,sp,32
 624:	8082                	ret
        return -1;
 626:	597d                	li	s2,-1
 628:	bfc5                	j	618 <stat+0x34>

000000000000062a <atoi>:

int atoi(const char *s)
{
 62a:	1141                	addi	sp,sp,-16
 62c:	e422                	sd	s0,8(sp)
 62e:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 630:	00054683          	lbu	a3,0(a0)
 634:	fd06879b          	addiw	a5,a3,-48
 638:	0ff7f793          	zext.b	a5,a5
 63c:	4625                	li	a2,9
 63e:	02f66863          	bltu	a2,a5,66e <atoi+0x44>
 642:	872a                	mv	a4,a0
    n = 0;
 644:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 646:	0705                	addi	a4,a4,1
 648:	0025179b          	slliw	a5,a0,0x2
 64c:	9fa9                	addw	a5,a5,a0
 64e:	0017979b          	slliw	a5,a5,0x1
 652:	9fb5                	addw	a5,a5,a3
 654:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 658:	00074683          	lbu	a3,0(a4)
 65c:	fd06879b          	addiw	a5,a3,-48
 660:	0ff7f793          	zext.b	a5,a5
 664:	fef671e3          	bgeu	a2,a5,646 <atoi+0x1c>
    return n;
}
 668:	6422                	ld	s0,8(sp)
 66a:	0141                	addi	sp,sp,16
 66c:	8082                	ret
    n = 0;
 66e:	4501                	li	a0,0
 670:	bfe5                	j	668 <atoi+0x3e>

0000000000000672 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 672:	1141                	addi	sp,sp,-16
 674:	e422                	sd	s0,8(sp)
 676:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 678:	02b57463          	bgeu	a0,a1,6a0 <memmove+0x2e>
    {
        while (n-- > 0)
 67c:	00c05f63          	blez	a2,69a <memmove+0x28>
 680:	1602                	slli	a2,a2,0x20
 682:	9201                	srli	a2,a2,0x20
 684:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 688:	872a                	mv	a4,a0
            *dst++ = *src++;
 68a:	0585                	addi	a1,a1,1
 68c:	0705                	addi	a4,a4,1
 68e:	fff5c683          	lbu	a3,-1(a1)
 692:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 696:	fee79ae3          	bne	a5,a4,68a <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 69a:	6422                	ld	s0,8(sp)
 69c:	0141                	addi	sp,sp,16
 69e:	8082                	ret
        dst += n;
 6a0:	00c50733          	add	a4,a0,a2
        src += n;
 6a4:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 6a6:	fec05ae3          	blez	a2,69a <memmove+0x28>
 6aa:	fff6079b          	addiw	a5,a2,-1
 6ae:	1782                	slli	a5,a5,0x20
 6b0:	9381                	srli	a5,a5,0x20
 6b2:	fff7c793          	not	a5,a5
 6b6:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 6b8:	15fd                	addi	a1,a1,-1
 6ba:	177d                	addi	a4,a4,-1
 6bc:	0005c683          	lbu	a3,0(a1)
 6c0:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 6c4:	fee79ae3          	bne	a5,a4,6b8 <memmove+0x46>
 6c8:	bfc9                	j	69a <memmove+0x28>

00000000000006ca <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 6ca:	1141                	addi	sp,sp,-16
 6cc:	e422                	sd	s0,8(sp)
 6ce:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 6d0:	ca05                	beqz	a2,700 <memcmp+0x36>
 6d2:	fff6069b          	addiw	a3,a2,-1
 6d6:	1682                	slli	a3,a3,0x20
 6d8:	9281                	srli	a3,a3,0x20
 6da:	0685                	addi	a3,a3,1
 6dc:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 6de:	00054783          	lbu	a5,0(a0)
 6e2:	0005c703          	lbu	a4,0(a1)
 6e6:	00e79863          	bne	a5,a4,6f6 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 6ea:	0505                	addi	a0,a0,1
        p2++;
 6ec:	0585                	addi	a1,a1,1
    while (n-- > 0)
 6ee:	fed518e3          	bne	a0,a3,6de <memcmp+0x14>
    }
    return 0;
 6f2:	4501                	li	a0,0
 6f4:	a019                	j	6fa <memcmp+0x30>
            return *p1 - *p2;
 6f6:	40e7853b          	subw	a0,a5,a4
}
 6fa:	6422                	ld	s0,8(sp)
 6fc:	0141                	addi	sp,sp,16
 6fe:	8082                	ret
    return 0;
 700:	4501                	li	a0,0
 702:	bfe5                	j	6fa <memcmp+0x30>

0000000000000704 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 704:	1141                	addi	sp,sp,-16
 706:	e406                	sd	ra,8(sp)
 708:	e022                	sd	s0,0(sp)
 70a:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 70c:	00000097          	auipc	ra,0x0
 710:	f66080e7          	jalr	-154(ra) # 672 <memmove>
}
 714:	60a2                	ld	ra,8(sp)
 716:	6402                	ld	s0,0(sp)
 718:	0141                	addi	sp,sp,16
 71a:	8082                	ret

000000000000071c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 71c:	4885                	li	a7,1
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <exit>:
.global exit
exit:
 li a7, SYS_exit
 724:	4889                	li	a7,2
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <wait>:
.global wait
wait:
 li a7, SYS_wait
 72c:	488d                	li	a7,3
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 734:	4891                	li	a7,4
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <read>:
.global read
read:
 li a7, SYS_read
 73c:	4895                	li	a7,5
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <write>:
.global write
write:
 li a7, SYS_write
 744:	48c1                	li	a7,16
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <close>:
.global close
close:
 li a7, SYS_close
 74c:	48d5                	li	a7,21
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <kill>:
.global kill
kill:
 li a7, SYS_kill
 754:	4899                	li	a7,6
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <exec>:
.global exec
exec:
 li a7, SYS_exec
 75c:	489d                	li	a7,7
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <open>:
.global open
open:
 li a7, SYS_open
 764:	48bd                	li	a7,15
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 76c:	48c5                	li	a7,17
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 774:	48c9                	li	a7,18
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 77c:	48a1                	li	a7,8
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <link>:
.global link
link:
 li a7, SYS_link
 784:	48cd                	li	a7,19
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 78c:	48d1                	li	a7,20
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 794:	48a5                	li	a7,9
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <dup>:
.global dup
dup:
 li a7, SYS_dup
 79c:	48a9                	li	a7,10
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7a4:	48ad                	li	a7,11
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7ac:	48b1                	li	a7,12
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7b4:	48b5                	li	a7,13
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7bc:	48b9                	li	a7,14
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <ps>:
.global ps
ps:
 li a7, SYS_ps
 7c4:	48d9                	li	a7,22
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 7cc:	48dd                	li	a7,23
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 7d4:	48e1                	li	a7,24
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7dc:	1101                	addi	sp,sp,-32
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7e8:	4605                	li	a2,1
 7ea:	fef40593          	addi	a1,s0,-17
 7ee:	00000097          	auipc	ra,0x0
 7f2:	f56080e7          	jalr	-170(ra) # 744 <write>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6105                	addi	sp,sp,32
 7fc:	8082                	ret

00000000000007fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7fe:	7139                	addi	sp,sp,-64
 800:	fc06                	sd	ra,56(sp)
 802:	f822                	sd	s0,48(sp)
 804:	f426                	sd	s1,40(sp)
 806:	f04a                	sd	s2,32(sp)
 808:	ec4e                	sd	s3,24(sp)
 80a:	0080                	addi	s0,sp,64
 80c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 80e:	c299                	beqz	a3,814 <printint+0x16>
 810:	0805c963          	bltz	a1,8a2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 814:	2581                	sext.w	a1,a1
  neg = 0;
 816:	4881                	li	a7,0
 818:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 81c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 81e:	2601                	sext.w	a2,a2
 820:	00000517          	auipc	a0,0x0
 824:	56050513          	addi	a0,a0,1376 # d80 <digits>
 828:	883a                	mv	a6,a4
 82a:	2705                	addiw	a4,a4,1
 82c:	02c5f7bb          	remuw	a5,a1,a2
 830:	1782                	slli	a5,a5,0x20
 832:	9381                	srli	a5,a5,0x20
 834:	97aa                	add	a5,a5,a0
 836:	0007c783          	lbu	a5,0(a5)
 83a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 83e:	0005879b          	sext.w	a5,a1
 842:	02c5d5bb          	divuw	a1,a1,a2
 846:	0685                	addi	a3,a3,1
 848:	fec7f0e3          	bgeu	a5,a2,828 <printint+0x2a>
  if(neg)
 84c:	00088c63          	beqz	a7,864 <printint+0x66>
    buf[i++] = '-';
 850:	fd070793          	addi	a5,a4,-48
 854:	00878733          	add	a4,a5,s0
 858:	02d00793          	li	a5,45
 85c:	fef70823          	sb	a5,-16(a4)
 860:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 864:	02e05863          	blez	a4,894 <printint+0x96>
 868:	fc040793          	addi	a5,s0,-64
 86c:	00e78933          	add	s2,a5,a4
 870:	fff78993          	addi	s3,a5,-1
 874:	99ba                	add	s3,s3,a4
 876:	377d                	addiw	a4,a4,-1
 878:	1702                	slli	a4,a4,0x20
 87a:	9301                	srli	a4,a4,0x20
 87c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 880:	fff94583          	lbu	a1,-1(s2)
 884:	8526                	mv	a0,s1
 886:	00000097          	auipc	ra,0x0
 88a:	f56080e7          	jalr	-170(ra) # 7dc <putc>
  while(--i >= 0)
 88e:	197d                	addi	s2,s2,-1
 890:	ff3918e3          	bne	s2,s3,880 <printint+0x82>
}
 894:	70e2                	ld	ra,56(sp)
 896:	7442                	ld	s0,48(sp)
 898:	74a2                	ld	s1,40(sp)
 89a:	7902                	ld	s2,32(sp)
 89c:	69e2                	ld	s3,24(sp)
 89e:	6121                	addi	sp,sp,64
 8a0:	8082                	ret
    x = -xx;
 8a2:	40b005bb          	negw	a1,a1
    neg = 1;
 8a6:	4885                	li	a7,1
    x = -xx;
 8a8:	bf85                	j	818 <printint+0x1a>

00000000000008aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8aa:	7119                	addi	sp,sp,-128
 8ac:	fc86                	sd	ra,120(sp)
 8ae:	f8a2                	sd	s0,112(sp)
 8b0:	f4a6                	sd	s1,104(sp)
 8b2:	f0ca                	sd	s2,96(sp)
 8b4:	ecce                	sd	s3,88(sp)
 8b6:	e8d2                	sd	s4,80(sp)
 8b8:	e4d6                	sd	s5,72(sp)
 8ba:	e0da                	sd	s6,64(sp)
 8bc:	fc5e                	sd	s7,56(sp)
 8be:	f862                	sd	s8,48(sp)
 8c0:	f466                	sd	s9,40(sp)
 8c2:	f06a                	sd	s10,32(sp)
 8c4:	ec6e                	sd	s11,24(sp)
 8c6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8c8:	0005c903          	lbu	s2,0(a1)
 8cc:	18090f63          	beqz	s2,a6a <vprintf+0x1c0>
 8d0:	8aaa                	mv	s5,a0
 8d2:	8b32                	mv	s6,a2
 8d4:	00158493          	addi	s1,a1,1
  state = 0;
 8d8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8da:	02500a13          	li	s4,37
 8de:	4c55                	li	s8,21
 8e0:	00000c97          	auipc	s9,0x0
 8e4:	448c8c93          	addi	s9,s9,1096 # d28 <malloc+0x1ba>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8e8:	02800d93          	li	s11,40
  putc(fd, 'x');
 8ec:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ee:	00000b97          	auipc	s7,0x0
 8f2:	492b8b93          	addi	s7,s7,1170 # d80 <digits>
 8f6:	a839                	j	914 <vprintf+0x6a>
        putc(fd, c);
 8f8:	85ca                	mv	a1,s2
 8fa:	8556                	mv	a0,s5
 8fc:	00000097          	auipc	ra,0x0
 900:	ee0080e7          	jalr	-288(ra) # 7dc <putc>
 904:	a019                	j	90a <vprintf+0x60>
    } else if(state == '%'){
 906:	01498d63          	beq	s3,s4,920 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 90a:	0485                	addi	s1,s1,1
 90c:	fff4c903          	lbu	s2,-1(s1)
 910:	14090d63          	beqz	s2,a6a <vprintf+0x1c0>
    if(state == 0){
 914:	fe0999e3          	bnez	s3,906 <vprintf+0x5c>
      if(c == '%'){
 918:	ff4910e3          	bne	s2,s4,8f8 <vprintf+0x4e>
        state = '%';
 91c:	89d2                	mv	s3,s4
 91e:	b7f5                	j	90a <vprintf+0x60>
      if(c == 'd'){
 920:	11490c63          	beq	s2,s4,a38 <vprintf+0x18e>
 924:	f9d9079b          	addiw	a5,s2,-99
 928:	0ff7f793          	zext.b	a5,a5
 92c:	10fc6e63          	bltu	s8,a5,a48 <vprintf+0x19e>
 930:	f9d9079b          	addiw	a5,s2,-99
 934:	0ff7f713          	zext.b	a4,a5
 938:	10ec6863          	bltu	s8,a4,a48 <vprintf+0x19e>
 93c:	00271793          	slli	a5,a4,0x2
 940:	97e6                	add	a5,a5,s9
 942:	439c                	lw	a5,0(a5)
 944:	97e6                	add	a5,a5,s9
 946:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 948:	008b0913          	addi	s2,s6,8
 94c:	4685                	li	a3,1
 94e:	4629                	li	a2,10
 950:	000b2583          	lw	a1,0(s6)
 954:	8556                	mv	a0,s5
 956:	00000097          	auipc	ra,0x0
 95a:	ea8080e7          	jalr	-344(ra) # 7fe <printint>
 95e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 960:	4981                	li	s3,0
 962:	b765                	j	90a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 964:	008b0913          	addi	s2,s6,8
 968:	4681                	li	a3,0
 96a:	4629                	li	a2,10
 96c:	000b2583          	lw	a1,0(s6)
 970:	8556                	mv	a0,s5
 972:	00000097          	auipc	ra,0x0
 976:	e8c080e7          	jalr	-372(ra) # 7fe <printint>
 97a:	8b4a                	mv	s6,s2
      state = 0;
 97c:	4981                	li	s3,0
 97e:	b771                	j	90a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 980:	008b0913          	addi	s2,s6,8
 984:	4681                	li	a3,0
 986:	866a                	mv	a2,s10
 988:	000b2583          	lw	a1,0(s6)
 98c:	8556                	mv	a0,s5
 98e:	00000097          	auipc	ra,0x0
 992:	e70080e7          	jalr	-400(ra) # 7fe <printint>
 996:	8b4a                	mv	s6,s2
      state = 0;
 998:	4981                	li	s3,0
 99a:	bf85                	j	90a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 99c:	008b0793          	addi	a5,s6,8
 9a0:	f8f43423          	sd	a5,-120(s0)
 9a4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9a8:	03000593          	li	a1,48
 9ac:	8556                	mv	a0,s5
 9ae:	00000097          	auipc	ra,0x0
 9b2:	e2e080e7          	jalr	-466(ra) # 7dc <putc>
  putc(fd, 'x');
 9b6:	07800593          	li	a1,120
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	e20080e7          	jalr	-480(ra) # 7dc <putc>
 9c4:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9c6:	03c9d793          	srli	a5,s3,0x3c
 9ca:	97de                	add	a5,a5,s7
 9cc:	0007c583          	lbu	a1,0(a5)
 9d0:	8556                	mv	a0,s5
 9d2:	00000097          	auipc	ra,0x0
 9d6:	e0a080e7          	jalr	-502(ra) # 7dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9da:	0992                	slli	s3,s3,0x4
 9dc:	397d                	addiw	s2,s2,-1
 9de:	fe0914e3          	bnez	s2,9c6 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 9e2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9e6:	4981                	li	s3,0
 9e8:	b70d                	j	90a <vprintf+0x60>
        s = va_arg(ap, char*);
 9ea:	008b0913          	addi	s2,s6,8
 9ee:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 9f2:	02098163          	beqz	s3,a14 <vprintf+0x16a>
        while(*s != 0){
 9f6:	0009c583          	lbu	a1,0(s3)
 9fa:	c5ad                	beqz	a1,a64 <vprintf+0x1ba>
          putc(fd, *s);
 9fc:	8556                	mv	a0,s5
 9fe:	00000097          	auipc	ra,0x0
 a02:	dde080e7          	jalr	-546(ra) # 7dc <putc>
          s++;
 a06:	0985                	addi	s3,s3,1
        while(*s != 0){
 a08:	0009c583          	lbu	a1,0(s3)
 a0c:	f9e5                	bnez	a1,9fc <vprintf+0x152>
        s = va_arg(ap, char*);
 a0e:	8b4a                	mv	s6,s2
      state = 0;
 a10:	4981                	li	s3,0
 a12:	bde5                	j	90a <vprintf+0x60>
          s = "(null)";
 a14:	00000997          	auipc	s3,0x0
 a18:	30c98993          	addi	s3,s3,780 # d20 <malloc+0x1b2>
        while(*s != 0){
 a1c:	85ee                	mv	a1,s11
 a1e:	bff9                	j	9fc <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 a20:	008b0913          	addi	s2,s6,8
 a24:	000b4583          	lbu	a1,0(s6)
 a28:	8556                	mv	a0,s5
 a2a:	00000097          	auipc	ra,0x0
 a2e:	db2080e7          	jalr	-590(ra) # 7dc <putc>
 a32:	8b4a                	mv	s6,s2
      state = 0;
 a34:	4981                	li	s3,0
 a36:	bdd1                	j	90a <vprintf+0x60>
        putc(fd, c);
 a38:	85d2                	mv	a1,s4
 a3a:	8556                	mv	a0,s5
 a3c:	00000097          	auipc	ra,0x0
 a40:	da0080e7          	jalr	-608(ra) # 7dc <putc>
      state = 0;
 a44:	4981                	li	s3,0
 a46:	b5d1                	j	90a <vprintf+0x60>
        putc(fd, '%');
 a48:	85d2                	mv	a1,s4
 a4a:	8556                	mv	a0,s5
 a4c:	00000097          	auipc	ra,0x0
 a50:	d90080e7          	jalr	-624(ra) # 7dc <putc>
        putc(fd, c);
 a54:	85ca                	mv	a1,s2
 a56:	8556                	mv	a0,s5
 a58:	00000097          	auipc	ra,0x0
 a5c:	d84080e7          	jalr	-636(ra) # 7dc <putc>
      state = 0;
 a60:	4981                	li	s3,0
 a62:	b565                	j	90a <vprintf+0x60>
        s = va_arg(ap, char*);
 a64:	8b4a                	mv	s6,s2
      state = 0;
 a66:	4981                	li	s3,0
 a68:	b54d                	j	90a <vprintf+0x60>
    }
  }
}
 a6a:	70e6                	ld	ra,120(sp)
 a6c:	7446                	ld	s0,112(sp)
 a6e:	74a6                	ld	s1,104(sp)
 a70:	7906                	ld	s2,96(sp)
 a72:	69e6                	ld	s3,88(sp)
 a74:	6a46                	ld	s4,80(sp)
 a76:	6aa6                	ld	s5,72(sp)
 a78:	6b06                	ld	s6,64(sp)
 a7a:	7be2                	ld	s7,56(sp)
 a7c:	7c42                	ld	s8,48(sp)
 a7e:	7ca2                	ld	s9,40(sp)
 a80:	7d02                	ld	s10,32(sp)
 a82:	6de2                	ld	s11,24(sp)
 a84:	6109                	addi	sp,sp,128
 a86:	8082                	ret

0000000000000a88 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a88:	715d                	addi	sp,sp,-80
 a8a:	ec06                	sd	ra,24(sp)
 a8c:	e822                	sd	s0,16(sp)
 a8e:	1000                	addi	s0,sp,32
 a90:	e010                	sd	a2,0(s0)
 a92:	e414                	sd	a3,8(s0)
 a94:	e818                	sd	a4,16(s0)
 a96:	ec1c                	sd	a5,24(s0)
 a98:	03043023          	sd	a6,32(s0)
 a9c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 aa0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 aa4:	8622                	mv	a2,s0
 aa6:	00000097          	auipc	ra,0x0
 aaa:	e04080e7          	jalr	-508(ra) # 8aa <vprintf>
}
 aae:	60e2                	ld	ra,24(sp)
 ab0:	6442                	ld	s0,16(sp)
 ab2:	6161                	addi	sp,sp,80
 ab4:	8082                	ret

0000000000000ab6 <printf>:

void
printf(const char *fmt, ...)
{
 ab6:	711d                	addi	sp,sp,-96
 ab8:	ec06                	sd	ra,24(sp)
 aba:	e822                	sd	s0,16(sp)
 abc:	1000                	addi	s0,sp,32
 abe:	e40c                	sd	a1,8(s0)
 ac0:	e810                	sd	a2,16(s0)
 ac2:	ec14                	sd	a3,24(s0)
 ac4:	f018                	sd	a4,32(s0)
 ac6:	f41c                	sd	a5,40(s0)
 ac8:	03043823          	sd	a6,48(s0)
 acc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ad0:	00840613          	addi	a2,s0,8
 ad4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ad8:	85aa                	mv	a1,a0
 ada:	4505                	li	a0,1
 adc:	00000097          	auipc	ra,0x0
 ae0:	dce080e7          	jalr	-562(ra) # 8aa <vprintf>
}
 ae4:	60e2                	ld	ra,24(sp)
 ae6:	6442                	ld	s0,16(sp)
 ae8:	6125                	addi	sp,sp,96
 aea:	8082                	ret

0000000000000aec <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 aec:	1141                	addi	sp,sp,-16
 aee:	e422                	sd	s0,8(sp)
 af0:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 af2:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af6:	00000797          	auipc	a5,0x0
 afa:	50a7b783          	ld	a5,1290(a5) # 1000 <freep>
 afe:	a02d                	j	b28 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 b00:	4618                	lw	a4,8(a2)
 b02:	9f2d                	addw	a4,a4,a1
 b04:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 b08:	6398                	ld	a4,0(a5)
 b0a:	6310                	ld	a2,0(a4)
 b0c:	a83d                	j	b4a <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 b0e:	ff852703          	lw	a4,-8(a0)
 b12:	9f31                	addw	a4,a4,a2
 b14:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 b16:	ff053683          	ld	a3,-16(a0)
 b1a:	a091                	j	b5e <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b1c:	6398                	ld	a4,0(a5)
 b1e:	00e7e463          	bltu	a5,a4,b26 <free+0x3a>
 b22:	00e6ea63          	bltu	a3,a4,b36 <free+0x4a>
{
 b26:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b28:	fed7fae3          	bgeu	a5,a3,b1c <free+0x30>
 b2c:	6398                	ld	a4,0(a5)
 b2e:	00e6e463          	bltu	a3,a4,b36 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b32:	fee7eae3          	bltu	a5,a4,b26 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 b36:	ff852583          	lw	a1,-8(a0)
 b3a:	6390                	ld	a2,0(a5)
 b3c:	02059813          	slli	a6,a1,0x20
 b40:	01c85713          	srli	a4,a6,0x1c
 b44:	9736                	add	a4,a4,a3
 b46:	fae60de3          	beq	a2,a4,b00 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 b4a:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 b4e:	4790                	lw	a2,8(a5)
 b50:	02061593          	slli	a1,a2,0x20
 b54:	01c5d713          	srli	a4,a1,0x1c
 b58:	973e                	add	a4,a4,a5
 b5a:	fae68ae3          	beq	a3,a4,b0e <free+0x22>
        p->s.ptr = bp->s.ptr;
 b5e:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 b60:	00000717          	auipc	a4,0x0
 b64:	4af73023          	sd	a5,1184(a4) # 1000 <freep>
}
 b68:	6422                	ld	s0,8(sp)
 b6a:	0141                	addi	sp,sp,16
 b6c:	8082                	ret

0000000000000b6e <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 b6e:	7139                	addi	sp,sp,-64
 b70:	fc06                	sd	ra,56(sp)
 b72:	f822                	sd	s0,48(sp)
 b74:	f426                	sd	s1,40(sp)
 b76:	f04a                	sd	s2,32(sp)
 b78:	ec4e                	sd	s3,24(sp)
 b7a:	e852                	sd	s4,16(sp)
 b7c:	e456                	sd	s5,8(sp)
 b7e:	e05a                	sd	s6,0(sp)
 b80:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 b82:	02051493          	slli	s1,a0,0x20
 b86:	9081                	srli	s1,s1,0x20
 b88:	04bd                	addi	s1,s1,15
 b8a:	8091                	srli	s1,s1,0x4
 b8c:	0014899b          	addiw	s3,s1,1
 b90:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 b92:	00000517          	auipc	a0,0x0
 b96:	46e53503          	ld	a0,1134(a0) # 1000 <freep>
 b9a:	c515                	beqz	a0,bc6 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 b9c:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 b9e:	4798                	lw	a4,8(a5)
 ba0:	02977f63          	bgeu	a4,s1,bde <malloc+0x70>
 ba4:	8a4e                	mv	s4,s3
 ba6:	0009871b          	sext.w	a4,s3
 baa:	6685                	lui	a3,0x1
 bac:	00d77363          	bgeu	a4,a3,bb2 <malloc+0x44>
 bb0:	6a05                	lui	s4,0x1
 bb2:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 bb6:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 bba:	00000917          	auipc	s2,0x0
 bbe:	44690913          	addi	s2,s2,1094 # 1000 <freep>
    if (p == (char *)-1)
 bc2:	5afd                	li	s5,-1
 bc4:	a895                	j	c38 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 bc6:	00000797          	auipc	a5,0x0
 bca:	45a78793          	addi	a5,a5,1114 # 1020 <base>
 bce:	00000717          	auipc	a4,0x0
 bd2:	42f73923          	sd	a5,1074(a4) # 1000 <freep>
 bd6:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 bd8:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 bdc:	b7e1                	j	ba4 <malloc+0x36>
            if (p->s.size == nunits)
 bde:	02e48c63          	beq	s1,a4,c16 <malloc+0xa8>
                p->s.size -= nunits;
 be2:	4137073b          	subw	a4,a4,s3
 be6:	c798                	sw	a4,8(a5)
                p += p->s.size;
 be8:	02071693          	slli	a3,a4,0x20
 bec:	01c6d713          	srli	a4,a3,0x1c
 bf0:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 bf2:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 bf6:	00000717          	auipc	a4,0x0
 bfa:	40a73523          	sd	a0,1034(a4) # 1000 <freep>
            return (void *)(p + 1);
 bfe:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 c02:	70e2                	ld	ra,56(sp)
 c04:	7442                	ld	s0,48(sp)
 c06:	74a2                	ld	s1,40(sp)
 c08:	7902                	ld	s2,32(sp)
 c0a:	69e2                	ld	s3,24(sp)
 c0c:	6a42                	ld	s4,16(sp)
 c0e:	6aa2                	ld	s5,8(sp)
 c10:	6b02                	ld	s6,0(sp)
 c12:	6121                	addi	sp,sp,64
 c14:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 c16:	6398                	ld	a4,0(a5)
 c18:	e118                	sd	a4,0(a0)
 c1a:	bff1                	j	bf6 <malloc+0x88>
    hp->s.size = nu;
 c1c:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 c20:	0541                	addi	a0,a0,16
 c22:	00000097          	auipc	ra,0x0
 c26:	eca080e7          	jalr	-310(ra) # aec <free>
    return freep;
 c2a:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 c2e:	d971                	beqz	a0,c02 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 c30:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 c32:	4798                	lw	a4,8(a5)
 c34:	fa9775e3          	bgeu	a4,s1,bde <malloc+0x70>
        if (p == freep)
 c38:	00093703          	ld	a4,0(s2)
 c3c:	853e                	mv	a0,a5
 c3e:	fef719e3          	bne	a4,a5,c30 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 c42:	8552                	mv	a0,s4
 c44:	00000097          	auipc	ra,0x0
 c48:	b68080e7          	jalr	-1176(ra) # 7ac <sbrk>
    if (p == (char *)-1)
 c4c:	fd5518e3          	bne	a0,s5,c1c <malloc+0xae>
                return 0;
 c50:	4501                	li	a0,0
 c52:	bf45                	j	c02 <malloc+0x94>
