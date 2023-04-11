
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
    }
    exit(0);
}

int getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
    write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	58e58593          	addi	a1,a1,1422 # 15a0 <malloc+0xe6>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	074080e7          	jalr	116(ra) # 1090 <write>
    memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	e4c080e7          	jalr	-436(ra) # e76 <memset>
    gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	e86080e7          	jalr	-378(ra) # ebc <gets>
    if (buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
        return -1;
    return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
    }
    exit(0);
}

void panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
    fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	54858593          	addi	a1,a1,1352 # 15a8 <malloc+0xee>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	36a080e7          	jalr	874(ra) # 13d4 <fprintf>
    exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	ffc080e7          	jalr	-4(ra) # 1070 <exit>

000000000000007c <fork1>:
}

int fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
    int pid;

    pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	fe4080e7          	jalr	-28(ra) # 1068 <fork>
    if (pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
        panic("fork");
    return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
        panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	51650513          	addi	a0,a0,1302 # 15b0 <malloc+0xf6>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	addi	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	ec26                	sd	s1,24(sp)
      b2:	1800                	addi	s0,sp,48
    if (cmd == 0)
      b4:	c10d                	beqz	a0,d6 <runcmd+0x2c>
      b6:	84aa                	mv	s1,a0
    switch (cmd->type)
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e263          	bltu	a5,a4,e0 <runcmd+0x36>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	slli	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	5fe70713          	addi	a4,a4,1534 # 16c4 <malloc+0x20a>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
        exit(1);
      d6:	4505                	li	a0,1
      d8:	00001097          	auipc	ra,0x1
      dc:	f98080e7          	jalr	-104(ra) # 1070 <exit>
        panic("runcmd");
      e0:	00001517          	auipc	a0,0x1
      e4:	4d850513          	addi	a0,a0,1240 # 15b8 <malloc+0xfe>
      e8:	00000097          	auipc	ra,0x0
      ec:	f6e080e7          	jalr	-146(ra) # 56 <panic>
        if (ecmd->argv[0] == 0)
      f0:	6508                	ld	a0,8(a0)
      f2:	c515                	beqz	a0,11e <runcmd+0x74>
        exec(ecmd->argv[0], ecmd->argv);
      f4:	00848593          	addi	a1,s1,8
      f8:	00001097          	auipc	ra,0x1
      fc:	fb0080e7          	jalr	-80(ra) # 10a8 <exec>
        fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     100:	6490                	ld	a2,8(s1)
     102:	00001597          	auipc	a1,0x1
     106:	4be58593          	addi	a1,a1,1214 # 15c0 <malloc+0x106>
     10a:	4509                	li	a0,2
     10c:	00001097          	auipc	ra,0x1
     110:	2c8080e7          	jalr	712(ra) # 13d4 <fprintf>
    exit(0);
     114:	4501                	li	a0,0
     116:	00001097          	auipc	ra,0x1
     11a:	f5a080e7          	jalr	-166(ra) # 1070 <exit>
            exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	f50080e7          	jalr	-176(ra) # 1070 <exit>
        close(rcmd->fd);
     128:	5148                	lw	a0,36(a0)
     12a:	00001097          	auipc	ra,0x1
     12e:	f6e080e7          	jalr	-146(ra) # 1098 <close>
        if (open(rcmd->file, rcmd->mode) < 0)
     132:	508c                	lw	a1,32(s1)
     134:	6888                	ld	a0,16(s1)
     136:	00001097          	auipc	ra,0x1
     13a:	f7a080e7          	jalr	-134(ra) # 10b0 <open>
     13e:	00054763          	bltz	a0,14c <runcmd+0xa2>
        runcmd(rcmd->cmd);
     142:	6488                	ld	a0,8(s1)
     144:	00000097          	auipc	ra,0x0
     148:	f66080e7          	jalr	-154(ra) # aa <runcmd>
            fprintf(2, "open %s failed\n", rcmd->file);
     14c:	6890                	ld	a2,16(s1)
     14e:	00001597          	auipc	a1,0x1
     152:	48258593          	addi	a1,a1,1154 # 15d0 <malloc+0x116>
     156:	4509                	li	a0,2
     158:	00001097          	auipc	ra,0x1
     15c:	27c080e7          	jalr	636(ra) # 13d4 <fprintf>
            exit(1);
     160:	4505                	li	a0,1
     162:	00001097          	auipc	ra,0x1
     166:	f0e080e7          	jalr	-242(ra) # 1070 <exit>
        if (fork1() == 0)
     16a:	00000097          	auipc	ra,0x0
     16e:	f12080e7          	jalr	-238(ra) # 7c <fork1>
     172:	e511                	bnez	a0,17e <runcmd+0xd4>
            runcmd(lcmd->left);
     174:	6488                	ld	a0,8(s1)
     176:	00000097          	auipc	ra,0x0
     17a:	f34080e7          	jalr	-204(ra) # aa <runcmd>
        wait(0);
     17e:	4501                	li	a0,0
     180:	00001097          	auipc	ra,0x1
     184:	ef8080e7          	jalr	-264(ra) # 1078 <wait>
        runcmd(lcmd->right);
     188:	6888                	ld	a0,16(s1)
     18a:	00000097          	auipc	ra,0x0
     18e:	f20080e7          	jalr	-224(ra) # aa <runcmd>
        if (pipe(p) < 0)
     192:	fd840513          	addi	a0,s0,-40
     196:	00001097          	auipc	ra,0x1
     19a:	eea080e7          	jalr	-278(ra) # 1080 <pipe>
     19e:	04054363          	bltz	a0,1e4 <runcmd+0x13a>
        if (fork1() == 0)
     1a2:	00000097          	auipc	ra,0x0
     1a6:	eda080e7          	jalr	-294(ra) # 7c <fork1>
     1aa:	e529                	bnez	a0,1f4 <runcmd+0x14a>
            close(1);
     1ac:	4505                	li	a0,1
     1ae:	00001097          	auipc	ra,0x1
     1b2:	eea080e7          	jalr	-278(ra) # 1098 <close>
            dup(p[1]);
     1b6:	fdc42503          	lw	a0,-36(s0)
     1ba:	00001097          	auipc	ra,0x1
     1be:	f2e080e7          	jalr	-210(ra) # 10e8 <dup>
            close(p[0]);
     1c2:	fd842503          	lw	a0,-40(s0)
     1c6:	00001097          	auipc	ra,0x1
     1ca:	ed2080e7          	jalr	-302(ra) # 1098 <close>
            close(p[1]);
     1ce:	fdc42503          	lw	a0,-36(s0)
     1d2:	00001097          	auipc	ra,0x1
     1d6:	ec6080e7          	jalr	-314(ra) # 1098 <close>
            runcmd(pcmd->left);
     1da:	6488                	ld	a0,8(s1)
     1dc:	00000097          	auipc	ra,0x0
     1e0:	ece080e7          	jalr	-306(ra) # aa <runcmd>
            panic("pipe");
     1e4:	00001517          	auipc	a0,0x1
     1e8:	3fc50513          	addi	a0,a0,1020 # 15e0 <malloc+0x126>
     1ec:	00000097          	auipc	ra,0x0
     1f0:	e6a080e7          	jalr	-406(ra) # 56 <panic>
        if (fork1() == 0)
     1f4:	00000097          	auipc	ra,0x0
     1f8:	e88080e7          	jalr	-376(ra) # 7c <fork1>
     1fc:	ed05                	bnez	a0,234 <runcmd+0x18a>
            close(0);
     1fe:	00001097          	auipc	ra,0x1
     202:	e9a080e7          	jalr	-358(ra) # 1098 <close>
            dup(p[0]);
     206:	fd842503          	lw	a0,-40(s0)
     20a:	00001097          	auipc	ra,0x1
     20e:	ede080e7          	jalr	-290(ra) # 10e8 <dup>
            close(p[0]);
     212:	fd842503          	lw	a0,-40(s0)
     216:	00001097          	auipc	ra,0x1
     21a:	e82080e7          	jalr	-382(ra) # 1098 <close>
            close(p[1]);
     21e:	fdc42503          	lw	a0,-36(s0)
     222:	00001097          	auipc	ra,0x1
     226:	e76080e7          	jalr	-394(ra) # 1098 <close>
            runcmd(pcmd->right);
     22a:	6888                	ld	a0,16(s1)
     22c:	00000097          	auipc	ra,0x0
     230:	e7e080e7          	jalr	-386(ra) # aa <runcmd>
        close(p[0]);
     234:	fd842503          	lw	a0,-40(s0)
     238:	00001097          	auipc	ra,0x1
     23c:	e60080e7          	jalr	-416(ra) # 1098 <close>
        close(p[1]);
     240:	fdc42503          	lw	a0,-36(s0)
     244:	00001097          	auipc	ra,0x1
     248:	e54080e7          	jalr	-428(ra) # 1098 <close>
        wait(0);
     24c:	4501                	li	a0,0
     24e:	00001097          	auipc	ra,0x1
     252:	e2a080e7          	jalr	-470(ra) # 1078 <wait>
        wait(0);
     256:	4501                	li	a0,0
     258:	00001097          	auipc	ra,0x1
     25c:	e20080e7          	jalr	-480(ra) # 1078 <wait>
        break;
     260:	bd55                	j	114 <runcmd+0x6a>
        if (fork1() == 0)
     262:	00000097          	auipc	ra,0x0
     266:	e1a080e7          	jalr	-486(ra) # 7c <fork1>
     26a:	ea0515e3          	bnez	a0,114 <runcmd+0x6a>
            runcmd(bcmd->cmd);
     26e:	6488                	ld	a0,8(s1)
     270:	00000097          	auipc	ra,0x0
     274:	e3a080e7          	jalr	-454(ra) # aa <runcmd>

0000000000000278 <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     278:	1101                	addi	sp,sp,-32
     27a:	ec06                	sd	ra,24(sp)
     27c:	e822                	sd	s0,16(sp)
     27e:	e426                	sd	s1,8(sp)
     280:	1000                	addi	s0,sp,32
    struct execcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     282:	0a800513          	li	a0,168
     286:	00001097          	auipc	ra,0x1
     28a:	234080e7          	jalr	564(ra) # 14ba <malloc>
     28e:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     290:	0a800613          	li	a2,168
     294:	4581                	li	a1,0
     296:	00001097          	auipc	ra,0x1
     29a:	be0080e7          	jalr	-1056(ra) # e76 <memset>
    cmd->type = EXEC;
     29e:	4785                	li	a5,1
     2a0:	c09c                	sw	a5,0(s1)
    return (struct cmd *)cmd;
}
     2a2:	8526                	mv	a0,s1
     2a4:	60e2                	ld	ra,24(sp)
     2a6:	6442                	ld	s0,16(sp)
     2a8:	64a2                	ld	s1,8(sp)
     2aa:	6105                	addi	sp,sp,32
     2ac:	8082                	ret

00000000000002ae <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ae:	7139                	addi	sp,sp,-64
     2b0:	fc06                	sd	ra,56(sp)
     2b2:	f822                	sd	s0,48(sp)
     2b4:	f426                	sd	s1,40(sp)
     2b6:	f04a                	sd	s2,32(sp)
     2b8:	ec4e                	sd	s3,24(sp)
     2ba:	e852                	sd	s4,16(sp)
     2bc:	e456                	sd	s5,8(sp)
     2be:	e05a                	sd	s6,0(sp)
     2c0:	0080                	addi	s0,sp,64
     2c2:	8b2a                	mv	s6,a0
     2c4:	8aae                	mv	s5,a1
     2c6:	8a32                	mv	s4,a2
     2c8:	89b6                	mv	s3,a3
     2ca:	893a                	mv	s2,a4
    struct redircmd *cmd;

    cmd = malloc(sizeof(*cmd));
     2cc:	02800513          	li	a0,40
     2d0:	00001097          	auipc	ra,0x1
     2d4:	1ea080e7          	jalr	490(ra) # 14ba <malloc>
     2d8:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     2da:	02800613          	li	a2,40
     2de:	4581                	li	a1,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	b96080e7          	jalr	-1130(ra) # e76 <memset>
    cmd->type = REDIR;
     2e8:	4789                	li	a5,2
     2ea:	c09c                	sw	a5,0(s1)
    cmd->cmd = subcmd;
     2ec:	0164b423          	sd	s6,8(s1)
    cmd->file = file;
     2f0:	0154b823          	sd	s5,16(s1)
    cmd->efile = efile;
     2f4:	0144bc23          	sd	s4,24(s1)
    cmd->mode = mode;
     2f8:	0334a023          	sw	s3,32(s1)
    cmd->fd = fd;
     2fc:	0324a223          	sw	s2,36(s1)
    return (struct cmd *)cmd;
}
     300:	8526                	mv	a0,s1
     302:	70e2                	ld	ra,56(sp)
     304:	7442                	ld	s0,48(sp)
     306:	74a2                	ld	s1,40(sp)
     308:	7902                	ld	s2,32(sp)
     30a:	69e2                	ld	s3,24(sp)
     30c:	6a42                	ld	s4,16(sp)
     30e:	6aa2                	ld	s5,8(sp)
     310:	6b02                	ld	s6,0(sp)
     312:	6121                	addi	sp,sp,64
     314:	8082                	ret

0000000000000316 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     316:	7179                	addi	sp,sp,-48
     318:	f406                	sd	ra,40(sp)
     31a:	f022                	sd	s0,32(sp)
     31c:	ec26                	sd	s1,24(sp)
     31e:	e84a                	sd	s2,16(sp)
     320:	e44e                	sd	s3,8(sp)
     322:	1800                	addi	s0,sp,48
     324:	89aa                	mv	s3,a0
     326:	892e                	mv	s2,a1
    struct pipecmd *cmd;

    cmd = malloc(sizeof(*cmd));
     328:	4561                	li	a0,24
     32a:	00001097          	auipc	ra,0x1
     32e:	190080e7          	jalr	400(ra) # 14ba <malloc>
     332:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     334:	4661                	li	a2,24
     336:	4581                	li	a1,0
     338:	00001097          	auipc	ra,0x1
     33c:	b3e080e7          	jalr	-1218(ra) # e76 <memset>
    cmd->type = PIPE;
     340:	478d                	li	a5,3
     342:	c09c                	sw	a5,0(s1)
    cmd->left = left;
     344:	0134b423          	sd	s3,8(s1)
    cmd->right = right;
     348:	0124b823          	sd	s2,16(s1)
    return (struct cmd *)cmd;
}
     34c:	8526                	mv	a0,s1
     34e:	70a2                	ld	ra,40(sp)
     350:	7402                	ld	s0,32(sp)
     352:	64e2                	ld	s1,24(sp)
     354:	6942                	ld	s2,16(sp)
     356:	69a2                	ld	s3,8(sp)
     358:	6145                	addi	sp,sp,48
     35a:	8082                	ret

000000000000035c <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     35c:	7179                	addi	sp,sp,-48
     35e:	f406                	sd	ra,40(sp)
     360:	f022                	sd	s0,32(sp)
     362:	ec26                	sd	s1,24(sp)
     364:	e84a                	sd	s2,16(sp)
     366:	e44e                	sd	s3,8(sp)
     368:	1800                	addi	s0,sp,48
     36a:	89aa                	mv	s3,a0
     36c:	892e                	mv	s2,a1
    struct listcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     36e:	4561                	li	a0,24
     370:	00001097          	auipc	ra,0x1
     374:	14a080e7          	jalr	330(ra) # 14ba <malloc>
     378:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     37a:	4661                	li	a2,24
     37c:	4581                	li	a1,0
     37e:	00001097          	auipc	ra,0x1
     382:	af8080e7          	jalr	-1288(ra) # e76 <memset>
    cmd->type = LIST;
     386:	4791                	li	a5,4
     388:	c09c                	sw	a5,0(s1)
    cmd->left = left;
     38a:	0134b423          	sd	s3,8(s1)
    cmd->right = right;
     38e:	0124b823          	sd	s2,16(s1)
    return (struct cmd *)cmd;
}
     392:	8526                	mv	a0,s1
     394:	70a2                	ld	ra,40(sp)
     396:	7402                	ld	s0,32(sp)
     398:	64e2                	ld	s1,24(sp)
     39a:	6942                	ld	s2,16(sp)
     39c:	69a2                	ld	s3,8(sp)
     39e:	6145                	addi	sp,sp,48
     3a0:	8082                	ret

00000000000003a2 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     3a2:	1101                	addi	sp,sp,-32
     3a4:	ec06                	sd	ra,24(sp)
     3a6:	e822                	sd	s0,16(sp)
     3a8:	e426                	sd	s1,8(sp)
     3aa:	e04a                	sd	s2,0(sp)
     3ac:	1000                	addi	s0,sp,32
     3ae:	892a                	mv	s2,a0
    struct backcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     3b0:	4541                	li	a0,16
     3b2:	00001097          	auipc	ra,0x1
     3b6:	108080e7          	jalr	264(ra) # 14ba <malloc>
     3ba:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     3bc:	4641                	li	a2,16
     3be:	4581                	li	a1,0
     3c0:	00001097          	auipc	ra,0x1
     3c4:	ab6080e7          	jalr	-1354(ra) # e76 <memset>
    cmd->type = BACK;
     3c8:	4795                	li	a5,5
     3ca:	c09c                	sw	a5,0(s1)
    cmd->cmd = subcmd;
     3cc:	0124b423          	sd	s2,8(s1)
    return (struct cmd *)cmd;
}
     3d0:	8526                	mv	a0,s1
     3d2:	60e2                	ld	ra,24(sp)
     3d4:	6442                	ld	s0,16(sp)
     3d6:	64a2                	ld	s1,8(sp)
     3d8:	6902                	ld	s2,0(sp)
     3da:	6105                	addi	sp,sp,32
     3dc:	8082                	ret

00000000000003de <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     3de:	7139                	addi	sp,sp,-64
     3e0:	fc06                	sd	ra,56(sp)
     3e2:	f822                	sd	s0,48(sp)
     3e4:	f426                	sd	s1,40(sp)
     3e6:	f04a                	sd	s2,32(sp)
     3e8:	ec4e                	sd	s3,24(sp)
     3ea:	e852                	sd	s4,16(sp)
     3ec:	e456                	sd	s5,8(sp)
     3ee:	e05a                	sd	s6,0(sp)
     3f0:	0080                	addi	s0,sp,64
     3f2:	8a2a                	mv	s4,a0
     3f4:	892e                	mv	s2,a1
     3f6:	8ab2                	mv	s5,a2
     3f8:	8b36                	mv	s6,a3
    char *s;
    int ret;

    s = *ps;
     3fa:	6104                	ld	s1,0(a0)
    while (s < es && strchr(whitespace, *s))
     3fc:	00002997          	auipc	s3,0x2
     400:	c0c98993          	addi	s3,s3,-1012 # 2008 <whitespace>
     404:	00b4fe63          	bgeu	s1,a1,420 <gettoken+0x42>
     408:	0004c583          	lbu	a1,0(s1)
     40c:	854e                	mv	a0,s3
     40e:	00001097          	auipc	ra,0x1
     412:	a8a080e7          	jalr	-1398(ra) # e98 <strchr>
     416:	c509                	beqz	a0,420 <gettoken+0x42>
        s++;
     418:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     41a:	fe9917e3          	bne	s2,s1,408 <gettoken+0x2a>
        s++;
     41e:	84ca                	mv	s1,s2
    if (q)
     420:	000a8463          	beqz	s5,428 <gettoken+0x4a>
        *q = s;
     424:	009ab023          	sd	s1,0(s5)
    ret = *s;
     428:	0004c783          	lbu	a5,0(s1)
     42c:	00078a9b          	sext.w	s5,a5
    switch (*s)
     430:	03c00713          	li	a4,60
     434:	06f76663          	bltu	a4,a5,4a0 <gettoken+0xc2>
     438:	03a00713          	li	a4,58
     43c:	00f76e63          	bltu	a4,a5,458 <gettoken+0x7a>
     440:	cf89                	beqz	a5,45a <gettoken+0x7c>
     442:	02600713          	li	a4,38
     446:	00e78963          	beq	a5,a4,458 <gettoken+0x7a>
     44a:	fd87879b          	addiw	a5,a5,-40
     44e:	0ff7f793          	zext.b	a5,a5
     452:	4705                	li	a4,1
     454:	06f76d63          	bltu	a4,a5,4ce <gettoken+0xf0>
    case '(':
    case ')':
    case ';':
    case '&':
    case '<':
        s++;
     458:	0485                	addi	s1,s1,1
        ret = 'a';
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
            s++;
        break;
    }
    if (eq)
     45a:	000b0463          	beqz	s6,462 <gettoken+0x84>
        *eq = s;
     45e:	009b3023          	sd	s1,0(s6)

    while (s < es && strchr(whitespace, *s))
     462:	00002997          	auipc	s3,0x2
     466:	ba698993          	addi	s3,s3,-1114 # 2008 <whitespace>
     46a:	0124fe63          	bgeu	s1,s2,486 <gettoken+0xa8>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	00001097          	auipc	ra,0x1
     478:	a24080e7          	jalr	-1500(ra) # e98 <strchr>
     47c:	c509                	beqz	a0,486 <gettoken+0xa8>
        s++;
     47e:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     480:	fe9917e3          	bne	s2,s1,46e <gettoken+0x90>
        s++;
     484:	84ca                	mv	s1,s2
    *ps = s;
     486:	009a3023          	sd	s1,0(s4)
    return ret;
}
     48a:	8556                	mv	a0,s5
     48c:	70e2                	ld	ra,56(sp)
     48e:	7442                	ld	s0,48(sp)
     490:	74a2                	ld	s1,40(sp)
     492:	7902                	ld	s2,32(sp)
     494:	69e2                	ld	s3,24(sp)
     496:	6a42                	ld	s4,16(sp)
     498:	6aa2                	ld	s5,8(sp)
     49a:	6b02                	ld	s6,0(sp)
     49c:	6121                	addi	sp,sp,64
     49e:	8082                	ret
    switch (*s)
     4a0:	03e00713          	li	a4,62
     4a4:	02e79163          	bne	a5,a4,4c6 <gettoken+0xe8>
        s++;
     4a8:	00148693          	addi	a3,s1,1
        if (*s == '>')
     4ac:	0014c703          	lbu	a4,1(s1)
     4b0:	03e00793          	li	a5,62
            s++;
     4b4:	0489                	addi	s1,s1,2
            ret = '+';
     4b6:	02b00a93          	li	s5,43
        if (*s == '>')
     4ba:	faf700e3          	beq	a4,a5,45a <gettoken+0x7c>
        s++;
     4be:	84b6                	mv	s1,a3
    ret = *s;
     4c0:	03e00a93          	li	s5,62
     4c4:	bf59                	j	45a <gettoken+0x7c>
    switch (*s)
     4c6:	07c00713          	li	a4,124
     4ca:	f8e787e3          	beq	a5,a4,458 <gettoken+0x7a>
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4ce:	00002997          	auipc	s3,0x2
     4d2:	b3a98993          	addi	s3,s3,-1222 # 2008 <whitespace>
     4d6:	00002a97          	auipc	s5,0x2
     4da:	b2aa8a93          	addi	s5,s5,-1238 # 2000 <symbols>
     4de:	0324f663          	bgeu	s1,s2,50a <gettoken+0x12c>
     4e2:	0004c583          	lbu	a1,0(s1)
     4e6:	854e                	mv	a0,s3
     4e8:	00001097          	auipc	ra,0x1
     4ec:	9b0080e7          	jalr	-1616(ra) # e98 <strchr>
     4f0:	e50d                	bnez	a0,51a <gettoken+0x13c>
     4f2:	0004c583          	lbu	a1,0(s1)
     4f6:	8556                	mv	a0,s5
     4f8:	00001097          	auipc	ra,0x1
     4fc:	9a0080e7          	jalr	-1632(ra) # e98 <strchr>
     500:	e911                	bnez	a0,514 <gettoken+0x136>
            s++;
     502:	0485                	addi	s1,s1,1
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     504:	fc991fe3          	bne	s2,s1,4e2 <gettoken+0x104>
            s++;
     508:	84ca                	mv	s1,s2
    if (eq)
     50a:	06100a93          	li	s5,97
     50e:	f40b18e3          	bnez	s6,45e <gettoken+0x80>
     512:	bf95                	j	486 <gettoken+0xa8>
        ret = 'a';
     514:	06100a93          	li	s5,97
     518:	b789                	j	45a <gettoken+0x7c>
     51a:	06100a93          	li	s5,97
     51e:	bf35                	j	45a <gettoken+0x7c>

0000000000000520 <peek>:

int peek(char **ps, char *es, char *toks)
{
     520:	7139                	addi	sp,sp,-64
     522:	fc06                	sd	ra,56(sp)
     524:	f822                	sd	s0,48(sp)
     526:	f426                	sd	s1,40(sp)
     528:	f04a                	sd	s2,32(sp)
     52a:	ec4e                	sd	s3,24(sp)
     52c:	e852                	sd	s4,16(sp)
     52e:	e456                	sd	s5,8(sp)
     530:	0080                	addi	s0,sp,64
     532:	8a2a                	mv	s4,a0
     534:	892e                	mv	s2,a1
     536:	8ab2                	mv	s5,a2
    char *s;

    s = *ps;
     538:	6104                	ld	s1,0(a0)
    while (s < es && strchr(whitespace, *s))
     53a:	00002997          	auipc	s3,0x2
     53e:	ace98993          	addi	s3,s3,-1330 # 2008 <whitespace>
     542:	00b4fe63          	bgeu	s1,a1,55e <peek+0x3e>
     546:	0004c583          	lbu	a1,0(s1)
     54a:	854e                	mv	a0,s3
     54c:	00001097          	auipc	ra,0x1
     550:	94c080e7          	jalr	-1716(ra) # e98 <strchr>
     554:	c509                	beqz	a0,55e <peek+0x3e>
        s++;
     556:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     558:	fe9917e3          	bne	s2,s1,546 <peek+0x26>
        s++;
     55c:	84ca                	mv	s1,s2
    *ps = s;
     55e:	009a3023          	sd	s1,0(s4)
    return *s && strchr(toks, *s);
     562:	0004c583          	lbu	a1,0(s1)
     566:	4501                	li	a0,0
     568:	e991                	bnez	a1,57c <peek+0x5c>
}
     56a:	70e2                	ld	ra,56(sp)
     56c:	7442                	ld	s0,48(sp)
     56e:	74a2                	ld	s1,40(sp)
     570:	7902                	ld	s2,32(sp)
     572:	69e2                	ld	s3,24(sp)
     574:	6a42                	ld	s4,16(sp)
     576:	6aa2                	ld	s5,8(sp)
     578:	6121                	addi	sp,sp,64
     57a:	8082                	ret
    return *s && strchr(toks, *s);
     57c:	8556                	mv	a0,s5
     57e:	00001097          	auipc	ra,0x1
     582:	91a080e7          	jalr	-1766(ra) # e98 <strchr>
     586:	00a03533          	snez	a0,a0
     58a:	b7c5                	j	56a <peek+0x4a>

000000000000058c <parseredirs>:
    return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     58c:	7159                	addi	sp,sp,-112
     58e:	f486                	sd	ra,104(sp)
     590:	f0a2                	sd	s0,96(sp)
     592:	eca6                	sd	s1,88(sp)
     594:	e8ca                	sd	s2,80(sp)
     596:	e4ce                	sd	s3,72(sp)
     598:	e0d2                	sd	s4,64(sp)
     59a:	fc56                	sd	s5,56(sp)
     59c:	f85a                	sd	s6,48(sp)
     59e:	f45e                	sd	s7,40(sp)
     5a0:	f062                	sd	s8,32(sp)
     5a2:	ec66                	sd	s9,24(sp)
     5a4:	1880                	addi	s0,sp,112
     5a6:	8a2a                	mv	s4,a0
     5a8:	89ae                	mv	s3,a1
     5aa:	8932                	mv	s2,a2
    int tok;
    char *q, *eq;

    while (peek(ps, es, "<>"))
     5ac:	00001b97          	auipc	s7,0x1
     5b0:	05cb8b93          	addi	s7,s7,92 # 1608 <malloc+0x14e>
    {
        tok = gettoken(ps, es, 0, 0);
        if (gettoken(ps, es, &q, &eq) != 'a')
     5b4:	06100c13          	li	s8,97
            panic("missing file for redirection");
        switch (tok)
     5b8:	03c00c93          	li	s9,60
    while (peek(ps, es, "<>"))
     5bc:	a02d                	j	5e6 <parseredirs+0x5a>
            panic("missing file for redirection");
     5be:	00001517          	auipc	a0,0x1
     5c2:	02a50513          	addi	a0,a0,42 # 15e8 <malloc+0x12e>
     5c6:	00000097          	auipc	ra,0x0
     5ca:	a90080e7          	jalr	-1392(ra) # 56 <panic>
        {
        case '<':
            cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5ce:	4701                	li	a4,0
     5d0:	4681                	li	a3,0
     5d2:	f9043603          	ld	a2,-112(s0)
     5d6:	f9843583          	ld	a1,-104(s0)
     5da:	8552                	mv	a0,s4
     5dc:	00000097          	auipc	ra,0x0
     5e0:	cd2080e7          	jalr	-814(ra) # 2ae <redircmd>
     5e4:	8a2a                	mv	s4,a0
        switch (tok)
     5e6:	03e00b13          	li	s6,62
     5ea:	02b00a93          	li	s5,43
    while (peek(ps, es, "<>"))
     5ee:	865e                	mv	a2,s7
     5f0:	85ca                	mv	a1,s2
     5f2:	854e                	mv	a0,s3
     5f4:	00000097          	auipc	ra,0x0
     5f8:	f2c080e7          	jalr	-212(ra) # 520 <peek>
     5fc:	c925                	beqz	a0,66c <parseredirs+0xe0>
        tok = gettoken(ps, es, 0, 0);
     5fe:	4681                	li	a3,0
     600:	4601                	li	a2,0
     602:	85ca                	mv	a1,s2
     604:	854e                	mv	a0,s3
     606:	00000097          	auipc	ra,0x0
     60a:	dd8080e7          	jalr	-552(ra) # 3de <gettoken>
     60e:	84aa                	mv	s1,a0
        if (gettoken(ps, es, &q, &eq) != 'a')
     610:	f9040693          	addi	a3,s0,-112
     614:	f9840613          	addi	a2,s0,-104
     618:	85ca                	mv	a1,s2
     61a:	854e                	mv	a0,s3
     61c:	00000097          	auipc	ra,0x0
     620:	dc2080e7          	jalr	-574(ra) # 3de <gettoken>
     624:	f9851de3          	bne	a0,s8,5be <parseredirs+0x32>
        switch (tok)
     628:	fb9483e3          	beq	s1,s9,5ce <parseredirs+0x42>
     62c:	03648263          	beq	s1,s6,650 <parseredirs+0xc4>
     630:	fb549fe3          	bne	s1,s5,5ee <parseredirs+0x62>
            break;
        case '>':
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
            break;
        case '+': // >>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     634:	4705                	li	a4,1
     636:	20100693          	li	a3,513
     63a:	f9043603          	ld	a2,-112(s0)
     63e:	f9843583          	ld	a1,-104(s0)
     642:	8552                	mv	a0,s4
     644:	00000097          	auipc	ra,0x0
     648:	c6a080e7          	jalr	-918(ra) # 2ae <redircmd>
     64c:	8a2a                	mv	s4,a0
            break;
     64e:	bf61                	j	5e6 <parseredirs+0x5a>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     650:	4705                	li	a4,1
     652:	60100693          	li	a3,1537
     656:	f9043603          	ld	a2,-112(s0)
     65a:	f9843583          	ld	a1,-104(s0)
     65e:	8552                	mv	a0,s4
     660:	00000097          	auipc	ra,0x0
     664:	c4e080e7          	jalr	-946(ra) # 2ae <redircmd>
     668:	8a2a                	mv	s4,a0
            break;
     66a:	bfb5                	j	5e6 <parseredirs+0x5a>
        }
    }
    return cmd;
}
     66c:	8552                	mv	a0,s4
     66e:	70a6                	ld	ra,104(sp)
     670:	7406                	ld	s0,96(sp)
     672:	64e6                	ld	s1,88(sp)
     674:	6946                	ld	s2,80(sp)
     676:	69a6                	ld	s3,72(sp)
     678:	6a06                	ld	s4,64(sp)
     67a:	7ae2                	ld	s5,56(sp)
     67c:	7b42                	ld	s6,48(sp)
     67e:	7ba2                	ld	s7,40(sp)
     680:	7c02                	ld	s8,32(sp)
     682:	6ce2                	ld	s9,24(sp)
     684:	6165                	addi	sp,sp,112
     686:	8082                	ret

0000000000000688 <parseexec>:
    return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     688:	7159                	addi	sp,sp,-112
     68a:	f486                	sd	ra,104(sp)
     68c:	f0a2                	sd	s0,96(sp)
     68e:	eca6                	sd	s1,88(sp)
     690:	e8ca                	sd	s2,80(sp)
     692:	e4ce                	sd	s3,72(sp)
     694:	e0d2                	sd	s4,64(sp)
     696:	fc56                	sd	s5,56(sp)
     698:	f85a                	sd	s6,48(sp)
     69a:	f45e                	sd	s7,40(sp)
     69c:	f062                	sd	s8,32(sp)
     69e:	ec66                	sd	s9,24(sp)
     6a0:	1880                	addi	s0,sp,112
     6a2:	8a2a                	mv	s4,a0
     6a4:	8aae                	mv	s5,a1
    char *q, *eq;
    int tok, argc;
    struct execcmd *cmd;
    struct cmd *ret;

    if (peek(ps, es, "("))
     6a6:	00001617          	auipc	a2,0x1
     6aa:	f6a60613          	addi	a2,a2,-150 # 1610 <malloc+0x156>
     6ae:	00000097          	auipc	ra,0x0
     6b2:	e72080e7          	jalr	-398(ra) # 520 <peek>
     6b6:	e905                	bnez	a0,6e6 <parseexec+0x5e>
     6b8:	89aa                	mv	s3,a0
        return parseblock(ps, es);

    ret = execcmd();
     6ba:	00000097          	auipc	ra,0x0
     6be:	bbe080e7          	jalr	-1090(ra) # 278 <execcmd>
     6c2:	8c2a                	mv	s8,a0
    cmd = (struct execcmd *)ret;

    argc = 0;
    ret = parseredirs(ret, ps, es);
     6c4:	8656                	mv	a2,s5
     6c6:	85d2                	mv	a1,s4
     6c8:	00000097          	auipc	ra,0x0
     6cc:	ec4080e7          	jalr	-316(ra) # 58c <parseredirs>
     6d0:	84aa                	mv	s1,a0
    while (!peek(ps, es, "|)&;"))
     6d2:	008c0913          	addi	s2,s8,8
     6d6:	00001b17          	auipc	s6,0x1
     6da:	f5ab0b13          	addi	s6,s6,-166 # 1630 <malloc+0x176>
    {
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
            break;
        if (tok != 'a')
     6de:	06100c93          	li	s9,97
            panic("syntax");
        cmd->argv[argc] = q;
        cmd->eargv[argc] = eq;
        argc++;
        if (argc >= MAXARGS)
     6e2:	4ba9                	li	s7,10
    while (!peek(ps, es, "|)&;"))
     6e4:	a0b1                	j	730 <parseexec+0xa8>
        return parseblock(ps, es);
     6e6:	85d6                	mv	a1,s5
     6e8:	8552                	mv	a0,s4
     6ea:	00000097          	auipc	ra,0x0
     6ee:	1bc080e7          	jalr	444(ra) # 8a6 <parseblock>
     6f2:	84aa                	mv	s1,a0
        ret = parseredirs(ret, ps, es);
    }
    cmd->argv[argc] = 0;
    cmd->eargv[argc] = 0;
    return ret;
}
     6f4:	8526                	mv	a0,s1
     6f6:	70a6                	ld	ra,104(sp)
     6f8:	7406                	ld	s0,96(sp)
     6fa:	64e6                	ld	s1,88(sp)
     6fc:	6946                	ld	s2,80(sp)
     6fe:	69a6                	ld	s3,72(sp)
     700:	6a06                	ld	s4,64(sp)
     702:	7ae2                	ld	s5,56(sp)
     704:	7b42                	ld	s6,48(sp)
     706:	7ba2                	ld	s7,40(sp)
     708:	7c02                	ld	s8,32(sp)
     70a:	6ce2                	ld	s9,24(sp)
     70c:	6165                	addi	sp,sp,112
     70e:	8082                	ret
            panic("syntax");
     710:	00001517          	auipc	a0,0x1
     714:	f0850513          	addi	a0,a0,-248 # 1618 <malloc+0x15e>
     718:	00000097          	auipc	ra,0x0
     71c:	93e080e7          	jalr	-1730(ra) # 56 <panic>
        ret = parseredirs(ret, ps, es);
     720:	8656                	mv	a2,s5
     722:	85d2                	mv	a1,s4
     724:	8526                	mv	a0,s1
     726:	00000097          	auipc	ra,0x0
     72a:	e66080e7          	jalr	-410(ra) # 58c <parseredirs>
     72e:	84aa                	mv	s1,a0
    while (!peek(ps, es, "|)&;"))
     730:	865a                	mv	a2,s6
     732:	85d6                	mv	a1,s5
     734:	8552                	mv	a0,s4
     736:	00000097          	auipc	ra,0x0
     73a:	dea080e7          	jalr	-534(ra) # 520 <peek>
     73e:	e131                	bnez	a0,782 <parseexec+0xfa>
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     740:	f9040693          	addi	a3,s0,-112
     744:	f9840613          	addi	a2,s0,-104
     748:	85d6                	mv	a1,s5
     74a:	8552                	mv	a0,s4
     74c:	00000097          	auipc	ra,0x0
     750:	c92080e7          	jalr	-878(ra) # 3de <gettoken>
     754:	c51d                	beqz	a0,782 <parseexec+0xfa>
        if (tok != 'a')
     756:	fb951de3          	bne	a0,s9,710 <parseexec+0x88>
        cmd->argv[argc] = q;
     75a:	f9843783          	ld	a5,-104(s0)
     75e:	00f93023          	sd	a5,0(s2)
        cmd->eargv[argc] = eq;
     762:	f9043783          	ld	a5,-112(s0)
     766:	04f93823          	sd	a5,80(s2)
        argc++;
     76a:	2985                	addiw	s3,s3,1
        if (argc >= MAXARGS)
     76c:	0921                	addi	s2,s2,8
     76e:	fb7999e3          	bne	s3,s7,720 <parseexec+0x98>
            panic("too many args");
     772:	00001517          	auipc	a0,0x1
     776:	eae50513          	addi	a0,a0,-338 # 1620 <malloc+0x166>
     77a:	00000097          	auipc	ra,0x0
     77e:	8dc080e7          	jalr	-1828(ra) # 56 <panic>
    cmd->argv[argc] = 0;
     782:	098e                	slli	s3,s3,0x3
     784:	9c4e                	add	s8,s8,s3
     786:	000c3423          	sd	zero,8(s8)
    cmd->eargv[argc] = 0;
     78a:	040c3c23          	sd	zero,88(s8)
    return ret;
     78e:	b79d                	j	6f4 <parseexec+0x6c>

0000000000000790 <parsepipe>:
{
     790:	7179                	addi	sp,sp,-48
     792:	f406                	sd	ra,40(sp)
     794:	f022                	sd	s0,32(sp)
     796:	ec26                	sd	s1,24(sp)
     798:	e84a                	sd	s2,16(sp)
     79a:	e44e                	sd	s3,8(sp)
     79c:	1800                	addi	s0,sp,48
     79e:	892a                	mv	s2,a0
     7a0:	89ae                	mv	s3,a1
    cmd = parseexec(ps, es);
     7a2:	00000097          	auipc	ra,0x0
     7a6:	ee6080e7          	jalr	-282(ra) # 688 <parseexec>
     7aa:	84aa                	mv	s1,a0
    if (peek(ps, es, "|"))
     7ac:	00001617          	auipc	a2,0x1
     7b0:	e8c60613          	addi	a2,a2,-372 # 1638 <malloc+0x17e>
     7b4:	85ce                	mv	a1,s3
     7b6:	854a                	mv	a0,s2
     7b8:	00000097          	auipc	ra,0x0
     7bc:	d68080e7          	jalr	-664(ra) # 520 <peek>
     7c0:	e909                	bnez	a0,7d2 <parsepipe+0x42>
}
     7c2:	8526                	mv	a0,s1
     7c4:	70a2                	ld	ra,40(sp)
     7c6:	7402                	ld	s0,32(sp)
     7c8:	64e2                	ld	s1,24(sp)
     7ca:	6942                	ld	s2,16(sp)
     7cc:	69a2                	ld	s3,8(sp)
     7ce:	6145                	addi	sp,sp,48
     7d0:	8082                	ret
        gettoken(ps, es, 0, 0);
     7d2:	4681                	li	a3,0
     7d4:	4601                	li	a2,0
     7d6:	85ce                	mv	a1,s3
     7d8:	854a                	mv	a0,s2
     7da:	00000097          	auipc	ra,0x0
     7de:	c04080e7          	jalr	-1020(ra) # 3de <gettoken>
        cmd = pipecmd(cmd, parsepipe(ps, es));
     7e2:	85ce                	mv	a1,s3
     7e4:	854a                	mv	a0,s2
     7e6:	00000097          	auipc	ra,0x0
     7ea:	faa080e7          	jalr	-86(ra) # 790 <parsepipe>
     7ee:	85aa                	mv	a1,a0
     7f0:	8526                	mv	a0,s1
     7f2:	00000097          	auipc	ra,0x0
     7f6:	b24080e7          	jalr	-1244(ra) # 316 <pipecmd>
     7fa:	84aa                	mv	s1,a0
    return cmd;
     7fc:	b7d9                	j	7c2 <parsepipe+0x32>

00000000000007fe <parseline>:
{
     7fe:	7179                	addi	sp,sp,-48
     800:	f406                	sd	ra,40(sp)
     802:	f022                	sd	s0,32(sp)
     804:	ec26                	sd	s1,24(sp)
     806:	e84a                	sd	s2,16(sp)
     808:	e44e                	sd	s3,8(sp)
     80a:	e052                	sd	s4,0(sp)
     80c:	1800                	addi	s0,sp,48
     80e:	892a                	mv	s2,a0
     810:	89ae                	mv	s3,a1
    cmd = parsepipe(ps, es);
     812:	00000097          	auipc	ra,0x0
     816:	f7e080e7          	jalr	-130(ra) # 790 <parsepipe>
     81a:	84aa                	mv	s1,a0
    while (peek(ps, es, "&"))
     81c:	00001a17          	auipc	s4,0x1
     820:	e24a0a13          	addi	s4,s4,-476 # 1640 <malloc+0x186>
     824:	a839                	j	842 <parseline+0x44>
        gettoken(ps, es, 0, 0);
     826:	4681                	li	a3,0
     828:	4601                	li	a2,0
     82a:	85ce                	mv	a1,s3
     82c:	854a                	mv	a0,s2
     82e:	00000097          	auipc	ra,0x0
     832:	bb0080e7          	jalr	-1104(ra) # 3de <gettoken>
        cmd = backcmd(cmd);
     836:	8526                	mv	a0,s1
     838:	00000097          	auipc	ra,0x0
     83c:	b6a080e7          	jalr	-1174(ra) # 3a2 <backcmd>
     840:	84aa                	mv	s1,a0
    while (peek(ps, es, "&"))
     842:	8652                	mv	a2,s4
     844:	85ce                	mv	a1,s3
     846:	854a                	mv	a0,s2
     848:	00000097          	auipc	ra,0x0
     84c:	cd8080e7          	jalr	-808(ra) # 520 <peek>
     850:	f979                	bnez	a0,826 <parseline+0x28>
    if (peek(ps, es, ";"))
     852:	00001617          	auipc	a2,0x1
     856:	df660613          	addi	a2,a2,-522 # 1648 <malloc+0x18e>
     85a:	85ce                	mv	a1,s3
     85c:	854a                	mv	a0,s2
     85e:	00000097          	auipc	ra,0x0
     862:	cc2080e7          	jalr	-830(ra) # 520 <peek>
     866:	e911                	bnez	a0,87a <parseline+0x7c>
}
     868:	8526                	mv	a0,s1
     86a:	70a2                	ld	ra,40(sp)
     86c:	7402                	ld	s0,32(sp)
     86e:	64e2                	ld	s1,24(sp)
     870:	6942                	ld	s2,16(sp)
     872:	69a2                	ld	s3,8(sp)
     874:	6a02                	ld	s4,0(sp)
     876:	6145                	addi	sp,sp,48
     878:	8082                	ret
        gettoken(ps, es, 0, 0);
     87a:	4681                	li	a3,0
     87c:	4601                	li	a2,0
     87e:	85ce                	mv	a1,s3
     880:	854a                	mv	a0,s2
     882:	00000097          	auipc	ra,0x0
     886:	b5c080e7          	jalr	-1188(ra) # 3de <gettoken>
        cmd = listcmd(cmd, parseline(ps, es));
     88a:	85ce                	mv	a1,s3
     88c:	854a                	mv	a0,s2
     88e:	00000097          	auipc	ra,0x0
     892:	f70080e7          	jalr	-144(ra) # 7fe <parseline>
     896:	85aa                	mv	a1,a0
     898:	8526                	mv	a0,s1
     89a:	00000097          	auipc	ra,0x0
     89e:	ac2080e7          	jalr	-1342(ra) # 35c <listcmd>
     8a2:	84aa                	mv	s1,a0
    return cmd;
     8a4:	b7d1                	j	868 <parseline+0x6a>

00000000000008a6 <parseblock>:
{
     8a6:	7179                	addi	sp,sp,-48
     8a8:	f406                	sd	ra,40(sp)
     8aa:	f022                	sd	s0,32(sp)
     8ac:	ec26                	sd	s1,24(sp)
     8ae:	e84a                	sd	s2,16(sp)
     8b0:	e44e                	sd	s3,8(sp)
     8b2:	1800                	addi	s0,sp,48
     8b4:	84aa                	mv	s1,a0
     8b6:	892e                	mv	s2,a1
    if (!peek(ps, es, "("))
     8b8:	00001617          	auipc	a2,0x1
     8bc:	d5860613          	addi	a2,a2,-680 # 1610 <malloc+0x156>
     8c0:	00000097          	auipc	ra,0x0
     8c4:	c60080e7          	jalr	-928(ra) # 520 <peek>
     8c8:	c12d                	beqz	a0,92a <parseblock+0x84>
    gettoken(ps, es, 0, 0);
     8ca:	4681                	li	a3,0
     8cc:	4601                	li	a2,0
     8ce:	85ca                	mv	a1,s2
     8d0:	8526                	mv	a0,s1
     8d2:	00000097          	auipc	ra,0x0
     8d6:	b0c080e7          	jalr	-1268(ra) # 3de <gettoken>
    cmd = parseline(ps, es);
     8da:	85ca                	mv	a1,s2
     8dc:	8526                	mv	a0,s1
     8de:	00000097          	auipc	ra,0x0
     8e2:	f20080e7          	jalr	-224(ra) # 7fe <parseline>
     8e6:	89aa                	mv	s3,a0
    if (!peek(ps, es, ")"))
     8e8:	00001617          	auipc	a2,0x1
     8ec:	d7860613          	addi	a2,a2,-648 # 1660 <malloc+0x1a6>
     8f0:	85ca                	mv	a1,s2
     8f2:	8526                	mv	a0,s1
     8f4:	00000097          	auipc	ra,0x0
     8f8:	c2c080e7          	jalr	-980(ra) # 520 <peek>
     8fc:	cd1d                	beqz	a0,93a <parseblock+0x94>
    gettoken(ps, es, 0, 0);
     8fe:	4681                	li	a3,0
     900:	4601                	li	a2,0
     902:	85ca                	mv	a1,s2
     904:	8526                	mv	a0,s1
     906:	00000097          	auipc	ra,0x0
     90a:	ad8080e7          	jalr	-1320(ra) # 3de <gettoken>
    cmd = parseredirs(cmd, ps, es);
     90e:	864a                	mv	a2,s2
     910:	85a6                	mv	a1,s1
     912:	854e                	mv	a0,s3
     914:	00000097          	auipc	ra,0x0
     918:	c78080e7          	jalr	-904(ra) # 58c <parseredirs>
}
     91c:	70a2                	ld	ra,40(sp)
     91e:	7402                	ld	s0,32(sp)
     920:	64e2                	ld	s1,24(sp)
     922:	6942                	ld	s2,16(sp)
     924:	69a2                	ld	s3,8(sp)
     926:	6145                	addi	sp,sp,48
     928:	8082                	ret
        panic("parseblock");
     92a:	00001517          	auipc	a0,0x1
     92e:	d2650513          	addi	a0,a0,-730 # 1650 <malloc+0x196>
     932:	fffff097          	auipc	ra,0xfffff
     936:	724080e7          	jalr	1828(ra) # 56 <panic>
        panic("syntax - missing )");
     93a:	00001517          	auipc	a0,0x1
     93e:	d2e50513          	addi	a0,a0,-722 # 1668 <malloc+0x1ae>
     942:	fffff097          	auipc	ra,0xfffff
     946:	714080e7          	jalr	1812(ra) # 56 <panic>

000000000000094a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     94a:	1101                	addi	sp,sp,-32
     94c:	ec06                	sd	ra,24(sp)
     94e:	e822                	sd	s0,16(sp)
     950:	e426                	sd	s1,8(sp)
     952:	1000                	addi	s0,sp,32
     954:	84aa                	mv	s1,a0
    struct execcmd *ecmd;
    struct listcmd *lcmd;
    struct pipecmd *pcmd;
    struct redircmd *rcmd;

    if (cmd == 0)
     956:	c521                	beqz	a0,99e <nulterminate+0x54>
        return 0;

    switch (cmd->type)
     958:	4118                	lw	a4,0(a0)
     95a:	4795                	li	a5,5
     95c:	04e7e163          	bltu	a5,a4,99e <nulterminate+0x54>
     960:	00056783          	lwu	a5,0(a0)
     964:	078a                	slli	a5,a5,0x2
     966:	00001717          	auipc	a4,0x1
     96a:	d7670713          	addi	a4,a4,-650 # 16dc <malloc+0x222>
     96e:	97ba                	add	a5,a5,a4
     970:	439c                	lw	a5,0(a5)
     972:	97ba                	add	a5,a5,a4
     974:	8782                	jr	a5
    {
    case EXEC:
        ecmd = (struct execcmd *)cmd;
        for (i = 0; ecmd->argv[i]; i++)
     976:	651c                	ld	a5,8(a0)
     978:	c39d                	beqz	a5,99e <nulterminate+0x54>
     97a:	01050793          	addi	a5,a0,16
            *ecmd->eargv[i] = 0;
     97e:	67b8                	ld	a4,72(a5)
     980:	00070023          	sb	zero,0(a4)
        for (i = 0; ecmd->argv[i]; i++)
     984:	07a1                	addi	a5,a5,8
     986:	ff87b703          	ld	a4,-8(a5)
     98a:	fb75                	bnez	a4,97e <nulterminate+0x34>
     98c:	a809                	j	99e <nulterminate+0x54>
        break;

    case REDIR:
        rcmd = (struct redircmd *)cmd;
        nulterminate(rcmd->cmd);
     98e:	6508                	ld	a0,8(a0)
     990:	00000097          	auipc	ra,0x0
     994:	fba080e7          	jalr	-70(ra) # 94a <nulterminate>
        *rcmd->efile = 0;
     998:	6c9c                	ld	a5,24(s1)
     99a:	00078023          	sb	zero,0(a5)
        bcmd = (struct backcmd *)cmd;
        nulterminate(bcmd->cmd);
        break;
    }
    return cmd;
}
     99e:	8526                	mv	a0,s1
     9a0:	60e2                	ld	ra,24(sp)
     9a2:	6442                	ld	s0,16(sp)
     9a4:	64a2                	ld	s1,8(sp)
     9a6:	6105                	addi	sp,sp,32
     9a8:	8082                	ret
        nulterminate(pcmd->left);
     9aa:	6508                	ld	a0,8(a0)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	f9e080e7          	jalr	-98(ra) # 94a <nulterminate>
        nulterminate(pcmd->right);
     9b4:	6888                	ld	a0,16(s1)
     9b6:	00000097          	auipc	ra,0x0
     9ba:	f94080e7          	jalr	-108(ra) # 94a <nulterminate>
        break;
     9be:	b7c5                	j	99e <nulterminate+0x54>
        nulterminate(lcmd->left);
     9c0:	6508                	ld	a0,8(a0)
     9c2:	00000097          	auipc	ra,0x0
     9c6:	f88080e7          	jalr	-120(ra) # 94a <nulterminate>
        nulterminate(lcmd->right);
     9ca:	6888                	ld	a0,16(s1)
     9cc:	00000097          	auipc	ra,0x0
     9d0:	f7e080e7          	jalr	-130(ra) # 94a <nulterminate>
        break;
     9d4:	b7e9                	j	99e <nulterminate+0x54>
        nulterminate(bcmd->cmd);
     9d6:	6508                	ld	a0,8(a0)
     9d8:	00000097          	auipc	ra,0x0
     9dc:	f72080e7          	jalr	-142(ra) # 94a <nulterminate>
        break;
     9e0:	bf7d                	j	99e <nulterminate+0x54>

00000000000009e2 <parsecmd>:
{
     9e2:	7179                	addi	sp,sp,-48
     9e4:	f406                	sd	ra,40(sp)
     9e6:	f022                	sd	s0,32(sp)
     9e8:	ec26                	sd	s1,24(sp)
     9ea:	e84a                	sd	s2,16(sp)
     9ec:	1800                	addi	s0,sp,48
     9ee:	fca43c23          	sd	a0,-40(s0)
    es = s + strlen(s);
     9f2:	84aa                	mv	s1,a0
     9f4:	00000097          	auipc	ra,0x0
     9f8:	458080e7          	jalr	1112(ra) # e4c <strlen>
     9fc:	1502                	slli	a0,a0,0x20
     9fe:	9101                	srli	a0,a0,0x20
     a00:	94aa                	add	s1,s1,a0
    cmd = parseline(&s, es);
     a02:	85a6                	mv	a1,s1
     a04:	fd840513          	addi	a0,s0,-40
     a08:	00000097          	auipc	ra,0x0
     a0c:	df6080e7          	jalr	-522(ra) # 7fe <parseline>
     a10:	892a                	mv	s2,a0
    peek(&s, es, "");
     a12:	00001617          	auipc	a2,0x1
     a16:	c6e60613          	addi	a2,a2,-914 # 1680 <malloc+0x1c6>
     a1a:	85a6                	mv	a1,s1
     a1c:	fd840513          	addi	a0,s0,-40
     a20:	00000097          	auipc	ra,0x0
     a24:	b00080e7          	jalr	-1280(ra) # 520 <peek>
    if (s != es)
     a28:	fd843603          	ld	a2,-40(s0)
     a2c:	00961e63          	bne	a2,s1,a48 <parsecmd+0x66>
    nulterminate(cmd);
     a30:	854a                	mv	a0,s2
     a32:	00000097          	auipc	ra,0x0
     a36:	f18080e7          	jalr	-232(ra) # 94a <nulterminate>
}
     a3a:	854a                	mv	a0,s2
     a3c:	70a2                	ld	ra,40(sp)
     a3e:	7402                	ld	s0,32(sp)
     a40:	64e2                	ld	s1,24(sp)
     a42:	6942                	ld	s2,16(sp)
     a44:	6145                	addi	sp,sp,48
     a46:	8082                	ret
        fprintf(2, "leftovers: %s\n", s);
     a48:	00001597          	auipc	a1,0x1
     a4c:	c4058593          	addi	a1,a1,-960 # 1688 <malloc+0x1ce>
     a50:	4509                	li	a0,2
     a52:	00001097          	auipc	ra,0x1
     a56:	982080e7          	jalr	-1662(ra) # 13d4 <fprintf>
        panic("syntax");
     a5a:	00001517          	auipc	a0,0x1
     a5e:	bbe50513          	addi	a0,a0,-1090 # 1618 <malloc+0x15e>
     a62:	fffff097          	auipc	ra,0xfffff
     a66:	5f4080e7          	jalr	1524(ra) # 56 <panic>

0000000000000a6a <parse_buffer>:
{
     a6a:	1101                	addi	sp,sp,-32
     a6c:	ec06                	sd	ra,24(sp)
     a6e:	e822                	sd	s0,16(sp)
     a70:	e426                	sd	s1,8(sp)
     a72:	1000                	addi	s0,sp,32
     a74:	84aa                	mv	s1,a0
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     a76:	00054783          	lbu	a5,0(a0)
     a7a:	06300713          	li	a4,99
     a7e:	02e78b63          	beq	a5,a4,ab4 <parse_buffer+0x4a>
    if (buf[0] == 'e' &&
     a82:	06500713          	li	a4,101
     a86:	00e79863          	bne	a5,a4,a96 <parse_buffer+0x2c>
     a8a:	00154703          	lbu	a4,1(a0)
     a8e:	07800793          	li	a5,120
     a92:	06f70b63          	beq	a4,a5,b08 <parse_buffer+0x9e>
    if (fork1() == 0)
     a96:	fffff097          	auipc	ra,0xfffff
     a9a:	5e6080e7          	jalr	1510(ra) # 7c <fork1>
     a9e:	c551                	beqz	a0,b2a <parse_buffer+0xc0>
    wait(0);
     aa0:	4501                	li	a0,0
     aa2:	00000097          	auipc	ra,0x0
     aa6:	5d6080e7          	jalr	1494(ra) # 1078 <wait>
}
     aaa:	60e2                	ld	ra,24(sp)
     aac:	6442                	ld	s0,16(sp)
     aae:	64a2                	ld	s1,8(sp)
     ab0:	6105                	addi	sp,sp,32
     ab2:	8082                	ret
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     ab4:	00154703          	lbu	a4,1(a0)
     ab8:	06400793          	li	a5,100
     abc:	fcf71de3          	bne	a4,a5,a96 <parse_buffer+0x2c>
     ac0:	00254703          	lbu	a4,2(a0)
     ac4:	02000793          	li	a5,32
     ac8:	fcf717e3          	bne	a4,a5,a96 <parse_buffer+0x2c>
        buf[strlen(buf) - 1] = 0; // chop \n
     acc:	00000097          	auipc	ra,0x0
     ad0:	380080e7          	jalr	896(ra) # e4c <strlen>
     ad4:	fff5079b          	addiw	a5,a0,-1
     ad8:	1782                	slli	a5,a5,0x20
     ada:	9381                	srli	a5,a5,0x20
     adc:	97a6                	add	a5,a5,s1
     ade:	00078023          	sb	zero,0(a5)
        if (chdir(buf + 3) < 0)
     ae2:	048d                	addi	s1,s1,3
     ae4:	8526                	mv	a0,s1
     ae6:	00000097          	auipc	ra,0x0
     aea:	5fa080e7          	jalr	1530(ra) # 10e0 <chdir>
     aee:	fa055ee3          	bgez	a0,aaa <parse_buffer+0x40>
            fprintf(2, "cannot cd %s\n", buf + 3);
     af2:	8626                	mv	a2,s1
     af4:	00001597          	auipc	a1,0x1
     af8:	ba458593          	addi	a1,a1,-1116 # 1698 <malloc+0x1de>
     afc:	4509                	li	a0,2
     afe:	00001097          	auipc	ra,0x1
     b02:	8d6080e7          	jalr	-1834(ra) # 13d4 <fprintf>
     b06:	b755                	j	aaa <parse_buffer+0x40>
        buf[1] == 'x' &&
     b08:	00254703          	lbu	a4,2(a0)
     b0c:	06900793          	li	a5,105
     b10:	f8f713e3          	bne	a4,a5,a96 <parse_buffer+0x2c>
        buf[2] == 'i' &&
     b14:	00354703          	lbu	a4,3(a0)
     b18:	07400793          	li	a5,116
     b1c:	f6f71de3          	bne	a4,a5,a96 <parse_buffer+0x2c>
        exit(0);
     b20:	4501                	li	a0,0
     b22:	00000097          	auipc	ra,0x0
     b26:	54e080e7          	jalr	1358(ra) # 1070 <exit>
        runcmd(parsecmd(buf));
     b2a:	8526                	mv	a0,s1
     b2c:	00000097          	auipc	ra,0x0
     b30:	eb6080e7          	jalr	-330(ra) # 9e2 <parsecmd>
     b34:	fffff097          	auipc	ra,0xfffff
     b38:	576080e7          	jalr	1398(ra) # aa <runcmd>

0000000000000b3c <main>:
{
     b3c:	7179                	addi	sp,sp,-48
     b3e:	f406                	sd	ra,40(sp)
     b40:	f022                	sd	s0,32(sp)
     b42:	ec26                	sd	s1,24(sp)
     b44:	e84a                	sd	s2,16(sp)
     b46:	e44e                	sd	s3,8(sp)
     b48:	1800                	addi	s0,sp,48
     b4a:	892a                	mv	s2,a0
     b4c:	89ae                	mv	s3,a1
    while ((fd = open("console", O_RDWR)) >= 0)
     b4e:	00001497          	auipc	s1,0x1
     b52:	b5a48493          	addi	s1,s1,-1190 # 16a8 <malloc+0x1ee>
     b56:	4589                	li	a1,2
     b58:	8526                	mv	a0,s1
     b5a:	00000097          	auipc	ra,0x0
     b5e:	556080e7          	jalr	1366(ra) # 10b0 <open>
     b62:	00054963          	bltz	a0,b74 <main+0x38>
        if (fd >= 3)
     b66:	4789                	li	a5,2
     b68:	fea7d7e3          	bge	a5,a0,b56 <main+0x1a>
            close(fd);
     b6c:	00000097          	auipc	ra,0x0
     b70:	52c080e7          	jalr	1324(ra) # 1098 <close>
    if (argc == 2)
     b74:	4789                	li	a5,2
    while (getcmd(buf, sizeof(buf)) >= 0)
     b76:	00001497          	auipc	s1,0x1
     b7a:	4aa48493          	addi	s1,s1,1194 # 2020 <buf.0>
    if (argc == 2)
     b7e:	08f91463          	bne	s2,a5,c06 <main+0xca>
        char *shell_script_file = argv[1];
     b82:	0089b483          	ld	s1,8(s3)
        int shfd = open(shell_script_file, O_RDWR);
     b86:	4589                	li	a1,2
     b88:	8526                	mv	a0,s1
     b8a:	00000097          	auipc	ra,0x0
     b8e:	526080e7          	jalr	1318(ra) # 10b0 <open>
     b92:	892a                	mv	s2,a0
        if (shfd < 0)
     b94:	04054663          	bltz	a0,be0 <main+0xa4>
        read(shfd, buf, sizeof(buf));
     b98:	07800613          	li	a2,120
     b9c:	00001597          	auipc	a1,0x1
     ba0:	48458593          	addi	a1,a1,1156 # 2020 <buf.0>
     ba4:	00000097          	auipc	ra,0x0
     ba8:	4e4080e7          	jalr	1252(ra) # 1088 <read>
            parse_buffer(buf);
     bac:	00001497          	auipc	s1,0x1
     bb0:	47448493          	addi	s1,s1,1140 # 2020 <buf.0>
     bb4:	8526                	mv	a0,s1
     bb6:	00000097          	auipc	ra,0x0
     bba:	eb4080e7          	jalr	-332(ra) # a6a <parse_buffer>
        } while (read(shfd, buf, sizeof(buf)) == sizeof(buf));
     bbe:	07800613          	li	a2,120
     bc2:	85a6                	mv	a1,s1
     bc4:	854a                	mv	a0,s2
     bc6:	00000097          	auipc	ra,0x0
     bca:	4c2080e7          	jalr	1218(ra) # 1088 <read>
     bce:	07800793          	li	a5,120
     bd2:	fef501e3          	beq	a0,a5,bb4 <main+0x78>
        exit(0);
     bd6:	4501                	li	a0,0
     bd8:	00000097          	auipc	ra,0x0
     bdc:	498080e7          	jalr	1176(ra) # 1070 <exit>
            printf("Failed to open %s\n", shell_script_file);
     be0:	85a6                	mv	a1,s1
     be2:	00001517          	auipc	a0,0x1
     be6:	ace50513          	addi	a0,a0,-1330 # 16b0 <malloc+0x1f6>
     bea:	00001097          	auipc	ra,0x1
     bee:	818080e7          	jalr	-2024(ra) # 1402 <printf>
            exit(1);
     bf2:	4505                	li	a0,1
     bf4:	00000097          	auipc	ra,0x0
     bf8:	47c080e7          	jalr	1148(ra) # 1070 <exit>
        parse_buffer(buf);
     bfc:	8526                	mv	a0,s1
     bfe:	00000097          	auipc	ra,0x0
     c02:	e6c080e7          	jalr	-404(ra) # a6a <parse_buffer>
    while (getcmd(buf, sizeof(buf)) >= 0)
     c06:	07800593          	li	a1,120
     c0a:	8526                	mv	a0,s1
     c0c:	fffff097          	auipc	ra,0xfffff
     c10:	3f4080e7          	jalr	1012(ra) # 0 <getcmd>
     c14:	fe0554e3          	bgez	a0,bfc <main+0xc0>
    exit(0);
     c18:	4501                	li	a0,0
     c1a:	00000097          	auipc	ra,0x0
     c1e:	456080e7          	jalr	1110(ra) # 1070 <exit>

0000000000000c22 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     c22:	1141                	addi	sp,sp,-16
     c24:	e422                	sd	s0,8(sp)
     c26:	0800                	addi	s0,sp,16
    lk->name = name;
     c28:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     c2a:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     c2e:	57fd                	li	a5,-1
     c30:	00f50823          	sb	a5,16(a0)
}
     c34:	6422                	ld	s0,8(sp)
     c36:	0141                	addi	sp,sp,16
     c38:	8082                	ret

0000000000000c3a <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     c3a:	00054783          	lbu	a5,0(a0)
     c3e:	e399                	bnez	a5,c44 <holding+0xa>
     c40:	4501                	li	a0,0
}
     c42:	8082                	ret
{
     c44:	1101                	addi	sp,sp,-32
     c46:	ec06                	sd	ra,24(sp)
     c48:	e822                	sd	s0,16(sp)
     c4a:	e426                	sd	s1,8(sp)
     c4c:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     c4e:	01054483          	lbu	s1,16(a0)
     c52:	00000097          	auipc	ra,0x0
     c56:	122080e7          	jalr	290(ra) # d74 <twhoami>
     c5a:	2501                	sext.w	a0,a0
     c5c:	40a48533          	sub	a0,s1,a0
     c60:	00153513          	seqz	a0,a0
}
     c64:	60e2                	ld	ra,24(sp)
     c66:	6442                	ld	s0,16(sp)
     c68:	64a2                	ld	s1,8(sp)
     c6a:	6105                	addi	sp,sp,32
     c6c:	8082                	ret

0000000000000c6e <acquire>:

void acquire(struct lock *lk)
{
     c6e:	7179                	addi	sp,sp,-48
     c70:	f406                	sd	ra,40(sp)
     c72:	f022                	sd	s0,32(sp)
     c74:	ec26                	sd	s1,24(sp)
     c76:	e84a                	sd	s2,16(sp)
     c78:	e44e                	sd	s3,8(sp)
     c7a:	e052                	sd	s4,0(sp)
     c7c:	1800                	addi	s0,sp,48
     c7e:	8a2a                	mv	s4,a0
    if (holding(lk))
     c80:	00000097          	auipc	ra,0x0
     c84:	fba080e7          	jalr	-70(ra) # c3a <holding>
     c88:	e919                	bnez	a0,c9e <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     c8a:	ffca7493          	andi	s1,s4,-4
     c8e:	003a7913          	andi	s2,s4,3
     c92:	0039191b          	slliw	s2,s2,0x3
     c96:	4985                	li	s3,1
     c98:	012999bb          	sllw	s3,s3,s2
     c9c:	a015                	j	cc0 <acquire+0x52>
        printf("re-acquiring lock we already hold");
     c9e:	00001517          	auipc	a0,0x1
     ca2:	a5a50513          	addi	a0,a0,-1446 # 16f8 <malloc+0x23e>
     ca6:	00000097          	auipc	ra,0x0
     caa:	75c080e7          	jalr	1884(ra) # 1402 <printf>
        exit(-1);
     cae:	557d                	li	a0,-1
     cb0:	00000097          	auipc	ra,0x0
     cb4:	3c0080e7          	jalr	960(ra) # 1070 <exit>
    {
        // give up the cpu for other threads
        tyield();
     cb8:	00000097          	auipc	ra,0x0
     cbc:	0b0080e7          	jalr	176(ra) # d68 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     cc0:	4534a7af          	amoor.w.aq	a5,s3,(s1)
     cc4:	0127d7bb          	srlw	a5,a5,s2
     cc8:	0ff7f793          	zext.b	a5,a5
     ccc:	f7f5                	bnez	a5,cb8 <acquire+0x4a>
    }

    __sync_synchronize();
     cce:	0ff0000f          	fence

    lk->tid = twhoami();
     cd2:	00000097          	auipc	ra,0x0
     cd6:	0a2080e7          	jalr	162(ra) # d74 <twhoami>
     cda:	00aa0823          	sb	a0,16(s4)
}
     cde:	70a2                	ld	ra,40(sp)
     ce0:	7402                	ld	s0,32(sp)
     ce2:	64e2                	ld	s1,24(sp)
     ce4:	6942                	ld	s2,16(sp)
     ce6:	69a2                	ld	s3,8(sp)
     ce8:	6a02                	ld	s4,0(sp)
     cea:	6145                	addi	sp,sp,48
     cec:	8082                	ret

0000000000000cee <release>:

void release(struct lock *lk)
{
     cee:	1101                	addi	sp,sp,-32
     cf0:	ec06                	sd	ra,24(sp)
     cf2:	e822                	sd	s0,16(sp)
     cf4:	e426                	sd	s1,8(sp)
     cf6:	1000                	addi	s0,sp,32
     cf8:	84aa                	mv	s1,a0
    if (!holding(lk))
     cfa:	00000097          	auipc	ra,0x0
     cfe:	f40080e7          	jalr	-192(ra) # c3a <holding>
     d02:	c11d                	beqz	a0,d28 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     d04:	57fd                	li	a5,-1
     d06:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     d0a:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
     d0e:	0ff0000f          	fence
     d12:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     d16:	00000097          	auipc	ra,0x0
     d1a:	052080e7          	jalr	82(ra) # d68 <tyield>
}
     d1e:	60e2                	ld	ra,24(sp)
     d20:	6442                	ld	s0,16(sp)
     d22:	64a2                	ld	s1,8(sp)
     d24:	6105                	addi	sp,sp,32
     d26:	8082                	ret
        printf("releasing lock we are not holding");
     d28:	00001517          	auipc	a0,0x1
     d2c:	9f850513          	addi	a0,a0,-1544 # 1720 <malloc+0x266>
     d30:	00000097          	auipc	ra,0x0
     d34:	6d2080e7          	jalr	1746(ra) # 1402 <printf>
        exit(-1);
     d38:	557d                	li	a0,-1
     d3a:	00000097          	auipc	ra,0x0
     d3e:	336080e7          	jalr	822(ra) # 1070 <exit>

0000000000000d42 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
     d42:	1141                	addi	sp,sp,-16
     d44:	e422                	sd	s0,8(sp)
     d46:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
     d48:	6422                	ld	s0,8(sp)
     d4a:	0141                	addi	sp,sp,16
     d4c:	8082                	ret

0000000000000d4e <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     d4e:	1141                	addi	sp,sp,-16
     d50:	e422                	sd	s0,8(sp)
     d52:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
     d54:	6422                	ld	s0,8(sp)
     d56:	0141                	addi	sp,sp,16
     d58:	8082                	ret

0000000000000d5a <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     d5a:	1141                	addi	sp,sp,-16
     d5c:	e422                	sd	s0,8(sp)
     d5e:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
     d60:	4501                	li	a0,0
     d62:	6422                	ld	s0,8(sp)
     d64:	0141                	addi	sp,sp,16
     d66:	8082                	ret

0000000000000d68 <tyield>:

void tyield()
{
     d68:	1141                	addi	sp,sp,-16
     d6a:	e422                	sd	s0,8(sp)
     d6c:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
     d6e:	6422                	ld	s0,8(sp)
     d70:	0141                	addi	sp,sp,16
     d72:	8082                	ret

0000000000000d74 <twhoami>:

uint8 twhoami()
{
     d74:	1141                	addi	sp,sp,-16
     d76:	e422                	sd	s0,8(sp)
     d78:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
     d7a:	4501                	li	a0,0
     d7c:	6422                	ld	s0,8(sp)
     d7e:	0141                	addi	sp,sp,16
     d80:	8082                	ret

0000000000000d82 <tswtch>:
     d82:	00153023          	sd	ra,0(a0)
     d86:	00253423          	sd	sp,8(a0)
     d8a:	e900                	sd	s0,16(a0)
     d8c:	ed04                	sd	s1,24(a0)
     d8e:	03253023          	sd	s2,32(a0)
     d92:	03353423          	sd	s3,40(a0)
     d96:	03453823          	sd	s4,48(a0)
     d9a:	03553c23          	sd	s5,56(a0)
     d9e:	05653023          	sd	s6,64(a0)
     da2:	05753423          	sd	s7,72(a0)
     da6:	05853823          	sd	s8,80(a0)
     daa:	05953c23          	sd	s9,88(a0)
     dae:	07a53023          	sd	s10,96(a0)
     db2:	07b53423          	sd	s11,104(a0)
     db6:	0005b083          	ld	ra,0(a1)
     dba:	0085b103          	ld	sp,8(a1)
     dbe:	6980                	ld	s0,16(a1)
     dc0:	6d84                	ld	s1,24(a1)
     dc2:	0205b903          	ld	s2,32(a1)
     dc6:	0285b983          	ld	s3,40(a1)
     dca:	0305ba03          	ld	s4,48(a1)
     dce:	0385ba83          	ld	s5,56(a1)
     dd2:	0405bb03          	ld	s6,64(a1)
     dd6:	0485bb83          	ld	s7,72(a1)
     dda:	0505bc03          	ld	s8,80(a1)
     dde:	0585bc83          	ld	s9,88(a1)
     de2:	0605bd03          	ld	s10,96(a1)
     de6:	0685bd83          	ld	s11,104(a1)
     dea:	8082                	ret

0000000000000dec <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     dec:	1141                	addi	sp,sp,-16
     dee:	e406                	sd	ra,8(sp)
     df0:	e022                	sd	s0,0(sp)
     df2:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
     df4:	00000097          	auipc	ra,0x0
     df8:	d48080e7          	jalr	-696(ra) # b3c <main>
    exit(res);
     dfc:	00000097          	auipc	ra,0x0
     e00:	274080e7          	jalr	628(ra) # 1070 <exit>

0000000000000e04 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     e04:	1141                	addi	sp,sp,-16
     e06:	e422                	sd	s0,8(sp)
     e08:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     e0a:	87aa                	mv	a5,a0
     e0c:	0585                	addi	a1,a1,1
     e0e:	0785                	addi	a5,a5,1
     e10:	fff5c703          	lbu	a4,-1(a1)
     e14:	fee78fa3          	sb	a4,-1(a5)
     e18:	fb75                	bnez	a4,e0c <strcpy+0x8>
        ;
    return os;
}
     e1a:	6422                	ld	s0,8(sp)
     e1c:	0141                	addi	sp,sp,16
     e1e:	8082                	ret

0000000000000e20 <strcmp>:

int strcmp(const char *p, const char *q)
{
     e20:	1141                	addi	sp,sp,-16
     e22:	e422                	sd	s0,8(sp)
     e24:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     e26:	00054783          	lbu	a5,0(a0)
     e2a:	cb91                	beqz	a5,e3e <strcmp+0x1e>
     e2c:	0005c703          	lbu	a4,0(a1)
     e30:	00f71763          	bne	a4,a5,e3e <strcmp+0x1e>
        p++, q++;
     e34:	0505                	addi	a0,a0,1
     e36:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     e38:	00054783          	lbu	a5,0(a0)
     e3c:	fbe5                	bnez	a5,e2c <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
     e3e:	0005c503          	lbu	a0,0(a1)
}
     e42:	40a7853b          	subw	a0,a5,a0
     e46:	6422                	ld	s0,8(sp)
     e48:	0141                	addi	sp,sp,16
     e4a:	8082                	ret

0000000000000e4c <strlen>:

uint strlen(const char *s)
{
     e4c:	1141                	addi	sp,sp,-16
     e4e:	e422                	sd	s0,8(sp)
     e50:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     e52:	00054783          	lbu	a5,0(a0)
     e56:	cf91                	beqz	a5,e72 <strlen+0x26>
     e58:	0505                	addi	a0,a0,1
     e5a:	87aa                	mv	a5,a0
     e5c:	4685                	li	a3,1
     e5e:	9e89                	subw	a3,a3,a0
     e60:	00f6853b          	addw	a0,a3,a5
     e64:	0785                	addi	a5,a5,1
     e66:	fff7c703          	lbu	a4,-1(a5)
     e6a:	fb7d                	bnez	a4,e60 <strlen+0x14>
        ;
    return n;
}
     e6c:	6422                	ld	s0,8(sp)
     e6e:	0141                	addi	sp,sp,16
     e70:	8082                	ret
    for (n = 0; s[n]; n++)
     e72:	4501                	li	a0,0
     e74:	bfe5                	j	e6c <strlen+0x20>

0000000000000e76 <memset>:

void *
memset(void *dst, int c, uint n)
{
     e76:	1141                	addi	sp,sp,-16
     e78:	e422                	sd	s0,8(sp)
     e7a:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     e7c:	ca19                	beqz	a2,e92 <memset+0x1c>
     e7e:	87aa                	mv	a5,a0
     e80:	1602                	slli	a2,a2,0x20
     e82:	9201                	srli	a2,a2,0x20
     e84:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     e88:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     e8c:	0785                	addi	a5,a5,1
     e8e:	fee79de3          	bne	a5,a4,e88 <memset+0x12>
    }
    return dst;
}
     e92:	6422                	ld	s0,8(sp)
     e94:	0141                	addi	sp,sp,16
     e96:	8082                	ret

0000000000000e98 <strchr>:

char *
strchr(const char *s, char c)
{
     e98:	1141                	addi	sp,sp,-16
     e9a:	e422                	sd	s0,8(sp)
     e9c:	0800                	addi	s0,sp,16
    for (; *s; s++)
     e9e:	00054783          	lbu	a5,0(a0)
     ea2:	cb99                	beqz	a5,eb8 <strchr+0x20>
        if (*s == c)
     ea4:	00f58763          	beq	a1,a5,eb2 <strchr+0x1a>
    for (; *s; s++)
     ea8:	0505                	addi	a0,a0,1
     eaa:	00054783          	lbu	a5,0(a0)
     eae:	fbfd                	bnez	a5,ea4 <strchr+0xc>
            return (char *)s;
    return 0;
     eb0:	4501                	li	a0,0
}
     eb2:	6422                	ld	s0,8(sp)
     eb4:	0141                	addi	sp,sp,16
     eb6:	8082                	ret
    return 0;
     eb8:	4501                	li	a0,0
     eba:	bfe5                	j	eb2 <strchr+0x1a>

0000000000000ebc <gets>:

char *
gets(char *buf, int max)
{
     ebc:	711d                	addi	sp,sp,-96
     ebe:	ec86                	sd	ra,88(sp)
     ec0:	e8a2                	sd	s0,80(sp)
     ec2:	e4a6                	sd	s1,72(sp)
     ec4:	e0ca                	sd	s2,64(sp)
     ec6:	fc4e                	sd	s3,56(sp)
     ec8:	f852                	sd	s4,48(sp)
     eca:	f456                	sd	s5,40(sp)
     ecc:	f05a                	sd	s6,32(sp)
     ece:	ec5e                	sd	s7,24(sp)
     ed0:	1080                	addi	s0,sp,96
     ed2:	8baa                	mv	s7,a0
     ed4:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     ed6:	892a                	mv	s2,a0
     ed8:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
     eda:	4aa9                	li	s5,10
     edc:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
     ede:	89a6                	mv	s3,s1
     ee0:	2485                	addiw	s1,s1,1
     ee2:	0344d863          	bge	s1,s4,f12 <gets+0x56>
        cc = read(0, &c, 1);
     ee6:	4605                	li	a2,1
     ee8:	faf40593          	addi	a1,s0,-81
     eec:	4501                	li	a0,0
     eee:	00000097          	auipc	ra,0x0
     ef2:	19a080e7          	jalr	410(ra) # 1088 <read>
        if (cc < 1)
     ef6:	00a05e63          	blez	a0,f12 <gets+0x56>
        buf[i++] = c;
     efa:	faf44783          	lbu	a5,-81(s0)
     efe:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     f02:	01578763          	beq	a5,s5,f10 <gets+0x54>
     f06:	0905                	addi	s2,s2,1
     f08:	fd679be3          	bne	a5,s6,ede <gets+0x22>
    for (i = 0; i + 1 < max;)
     f0c:	89a6                	mv	s3,s1
     f0e:	a011                	j	f12 <gets+0x56>
     f10:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
     f12:	99de                	add	s3,s3,s7
     f14:	00098023          	sb	zero,0(s3)
    return buf;
}
     f18:	855e                	mv	a0,s7
     f1a:	60e6                	ld	ra,88(sp)
     f1c:	6446                	ld	s0,80(sp)
     f1e:	64a6                	ld	s1,72(sp)
     f20:	6906                	ld	s2,64(sp)
     f22:	79e2                	ld	s3,56(sp)
     f24:	7a42                	ld	s4,48(sp)
     f26:	7aa2                	ld	s5,40(sp)
     f28:	7b02                	ld	s6,32(sp)
     f2a:	6be2                	ld	s7,24(sp)
     f2c:	6125                	addi	sp,sp,96
     f2e:	8082                	ret

0000000000000f30 <stat>:

int stat(const char *n, struct stat *st)
{
     f30:	1101                	addi	sp,sp,-32
     f32:	ec06                	sd	ra,24(sp)
     f34:	e822                	sd	s0,16(sp)
     f36:	e426                	sd	s1,8(sp)
     f38:	e04a                	sd	s2,0(sp)
     f3a:	1000                	addi	s0,sp,32
     f3c:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     f3e:	4581                	li	a1,0
     f40:	00000097          	auipc	ra,0x0
     f44:	170080e7          	jalr	368(ra) # 10b0 <open>
    if (fd < 0)
     f48:	02054563          	bltz	a0,f72 <stat+0x42>
     f4c:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     f4e:	85ca                	mv	a1,s2
     f50:	00000097          	auipc	ra,0x0
     f54:	178080e7          	jalr	376(ra) # 10c8 <fstat>
     f58:	892a                	mv	s2,a0
    close(fd);
     f5a:	8526                	mv	a0,s1
     f5c:	00000097          	auipc	ra,0x0
     f60:	13c080e7          	jalr	316(ra) # 1098 <close>
    return r;
}
     f64:	854a                	mv	a0,s2
     f66:	60e2                	ld	ra,24(sp)
     f68:	6442                	ld	s0,16(sp)
     f6a:	64a2                	ld	s1,8(sp)
     f6c:	6902                	ld	s2,0(sp)
     f6e:	6105                	addi	sp,sp,32
     f70:	8082                	ret
        return -1;
     f72:	597d                	li	s2,-1
     f74:	bfc5                	j	f64 <stat+0x34>

0000000000000f76 <atoi>:

int atoi(const char *s)
{
     f76:	1141                	addi	sp,sp,-16
     f78:	e422                	sd	s0,8(sp)
     f7a:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     f7c:	00054683          	lbu	a3,0(a0)
     f80:	fd06879b          	addiw	a5,a3,-48
     f84:	0ff7f793          	zext.b	a5,a5
     f88:	4625                	li	a2,9
     f8a:	02f66863          	bltu	a2,a5,fba <atoi+0x44>
     f8e:	872a                	mv	a4,a0
    n = 0;
     f90:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     f92:	0705                	addi	a4,a4,1
     f94:	0025179b          	slliw	a5,a0,0x2
     f98:	9fa9                	addw	a5,a5,a0
     f9a:	0017979b          	slliw	a5,a5,0x1
     f9e:	9fb5                	addw	a5,a5,a3
     fa0:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     fa4:	00074683          	lbu	a3,0(a4)
     fa8:	fd06879b          	addiw	a5,a3,-48
     fac:	0ff7f793          	zext.b	a5,a5
     fb0:	fef671e3          	bgeu	a2,a5,f92 <atoi+0x1c>
    return n;
}
     fb4:	6422                	ld	s0,8(sp)
     fb6:	0141                	addi	sp,sp,16
     fb8:	8082                	ret
    n = 0;
     fba:	4501                	li	a0,0
     fbc:	bfe5                	j	fb4 <atoi+0x3e>

0000000000000fbe <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     fbe:	1141                	addi	sp,sp,-16
     fc0:	e422                	sd	s0,8(sp)
     fc2:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     fc4:	02b57463          	bgeu	a0,a1,fec <memmove+0x2e>
    {
        while (n-- > 0)
     fc8:	00c05f63          	blez	a2,fe6 <memmove+0x28>
     fcc:	1602                	slli	a2,a2,0x20
     fce:	9201                	srli	a2,a2,0x20
     fd0:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     fd4:	872a                	mv	a4,a0
            *dst++ = *src++;
     fd6:	0585                	addi	a1,a1,1
     fd8:	0705                	addi	a4,a4,1
     fda:	fff5c683          	lbu	a3,-1(a1)
     fde:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     fe2:	fee79ae3          	bne	a5,a4,fd6 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     fe6:	6422                	ld	s0,8(sp)
     fe8:	0141                	addi	sp,sp,16
     fea:	8082                	ret
        dst += n;
     fec:	00c50733          	add	a4,a0,a2
        src += n;
     ff0:	95b2                	add	a1,a1,a2
        while (n-- > 0)
     ff2:	fec05ae3          	blez	a2,fe6 <memmove+0x28>
     ff6:	fff6079b          	addiw	a5,a2,-1
     ffa:	1782                	slli	a5,a5,0x20
     ffc:	9381                	srli	a5,a5,0x20
     ffe:	fff7c793          	not	a5,a5
    1002:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    1004:	15fd                	addi	a1,a1,-1
    1006:	177d                	addi	a4,a4,-1
    1008:	0005c683          	lbu	a3,0(a1)
    100c:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    1010:	fee79ae3          	bne	a5,a4,1004 <memmove+0x46>
    1014:	bfc9                	j	fe6 <memmove+0x28>

0000000000001016 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
    1016:	1141                	addi	sp,sp,-16
    1018:	e422                	sd	s0,8(sp)
    101a:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
    101c:	ca05                	beqz	a2,104c <memcmp+0x36>
    101e:	fff6069b          	addiw	a3,a2,-1
    1022:	1682                	slli	a3,a3,0x20
    1024:	9281                	srli	a3,a3,0x20
    1026:	0685                	addi	a3,a3,1
    1028:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
    102a:	00054783          	lbu	a5,0(a0)
    102e:	0005c703          	lbu	a4,0(a1)
    1032:	00e79863          	bne	a5,a4,1042 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
    1036:	0505                	addi	a0,a0,1
        p2++;
    1038:	0585                	addi	a1,a1,1
    while (n-- > 0)
    103a:	fed518e3          	bne	a0,a3,102a <memcmp+0x14>
    }
    return 0;
    103e:	4501                	li	a0,0
    1040:	a019                	j	1046 <memcmp+0x30>
            return *p1 - *p2;
    1042:	40e7853b          	subw	a0,a5,a4
}
    1046:	6422                	ld	s0,8(sp)
    1048:	0141                	addi	sp,sp,16
    104a:	8082                	ret
    return 0;
    104c:	4501                	li	a0,0
    104e:	bfe5                	j	1046 <memcmp+0x30>

0000000000001050 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1050:	1141                	addi	sp,sp,-16
    1052:	e406                	sd	ra,8(sp)
    1054:	e022                	sd	s0,0(sp)
    1056:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    1058:	00000097          	auipc	ra,0x0
    105c:	f66080e7          	jalr	-154(ra) # fbe <memmove>
}
    1060:	60a2                	ld	ra,8(sp)
    1062:	6402                	ld	s0,0(sp)
    1064:	0141                	addi	sp,sp,16
    1066:	8082                	ret

0000000000001068 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1068:	4885                	li	a7,1
 ecall
    106a:	00000073          	ecall
 ret
    106e:	8082                	ret

0000000000001070 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1070:	4889                	li	a7,2
 ecall
    1072:	00000073          	ecall
 ret
    1076:	8082                	ret

0000000000001078 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1078:	488d                	li	a7,3
 ecall
    107a:	00000073          	ecall
 ret
    107e:	8082                	ret

0000000000001080 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1080:	4891                	li	a7,4
 ecall
    1082:	00000073          	ecall
 ret
    1086:	8082                	ret

0000000000001088 <read>:
.global read
read:
 li a7, SYS_read
    1088:	4895                	li	a7,5
 ecall
    108a:	00000073          	ecall
 ret
    108e:	8082                	ret

0000000000001090 <write>:
.global write
write:
 li a7, SYS_write
    1090:	48c1                	li	a7,16
 ecall
    1092:	00000073          	ecall
 ret
    1096:	8082                	ret

0000000000001098 <close>:
.global close
close:
 li a7, SYS_close
    1098:	48d5                	li	a7,21
 ecall
    109a:	00000073          	ecall
 ret
    109e:	8082                	ret

00000000000010a0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    10a0:	4899                	li	a7,6
 ecall
    10a2:	00000073          	ecall
 ret
    10a6:	8082                	ret

00000000000010a8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    10a8:	489d                	li	a7,7
 ecall
    10aa:	00000073          	ecall
 ret
    10ae:	8082                	ret

00000000000010b0 <open>:
.global open
open:
 li a7, SYS_open
    10b0:	48bd                	li	a7,15
 ecall
    10b2:	00000073          	ecall
 ret
    10b6:	8082                	ret

00000000000010b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    10b8:	48c5                	li	a7,17
 ecall
    10ba:	00000073          	ecall
 ret
    10be:	8082                	ret

00000000000010c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    10c0:	48c9                	li	a7,18
 ecall
    10c2:	00000073          	ecall
 ret
    10c6:	8082                	ret

00000000000010c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    10c8:	48a1                	li	a7,8
 ecall
    10ca:	00000073          	ecall
 ret
    10ce:	8082                	ret

00000000000010d0 <link>:
.global link
link:
 li a7, SYS_link
    10d0:	48cd                	li	a7,19
 ecall
    10d2:	00000073          	ecall
 ret
    10d6:	8082                	ret

00000000000010d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    10d8:	48d1                	li	a7,20
 ecall
    10da:	00000073          	ecall
 ret
    10de:	8082                	ret

00000000000010e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    10e0:	48a5                	li	a7,9
 ecall
    10e2:	00000073          	ecall
 ret
    10e6:	8082                	ret

00000000000010e8 <dup>:
.global dup
dup:
 li a7, SYS_dup
    10e8:	48a9                	li	a7,10
 ecall
    10ea:	00000073          	ecall
 ret
    10ee:	8082                	ret

00000000000010f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    10f0:	48ad                	li	a7,11
 ecall
    10f2:	00000073          	ecall
 ret
    10f6:	8082                	ret

00000000000010f8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    10f8:	48b1                	li	a7,12
 ecall
    10fa:	00000073          	ecall
 ret
    10fe:	8082                	ret

0000000000001100 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1100:	48b5                	li	a7,13
 ecall
    1102:	00000073          	ecall
 ret
    1106:	8082                	ret

0000000000001108 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1108:	48b9                	li	a7,14
 ecall
    110a:	00000073          	ecall
 ret
    110e:	8082                	ret

0000000000001110 <ps>:
.global ps
ps:
 li a7, SYS_ps
    1110:	48d9                	li	a7,22
 ecall
    1112:	00000073          	ecall
 ret
    1116:	8082                	ret

0000000000001118 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
    1118:	48dd                	li	a7,23
 ecall
    111a:	00000073          	ecall
 ret
    111e:	8082                	ret

0000000000001120 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
    1120:	48e1                	li	a7,24
 ecall
    1122:	00000073          	ecall
 ret
    1126:	8082                	ret

0000000000001128 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1128:	1101                	addi	sp,sp,-32
    112a:	ec06                	sd	ra,24(sp)
    112c:	e822                	sd	s0,16(sp)
    112e:	1000                	addi	s0,sp,32
    1130:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1134:	4605                	li	a2,1
    1136:	fef40593          	addi	a1,s0,-17
    113a:	00000097          	auipc	ra,0x0
    113e:	f56080e7          	jalr	-170(ra) # 1090 <write>
}
    1142:	60e2                	ld	ra,24(sp)
    1144:	6442                	ld	s0,16(sp)
    1146:	6105                	addi	sp,sp,32
    1148:	8082                	ret

000000000000114a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    114a:	7139                	addi	sp,sp,-64
    114c:	fc06                	sd	ra,56(sp)
    114e:	f822                	sd	s0,48(sp)
    1150:	f426                	sd	s1,40(sp)
    1152:	f04a                	sd	s2,32(sp)
    1154:	ec4e                	sd	s3,24(sp)
    1156:	0080                	addi	s0,sp,64
    1158:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    115a:	c299                	beqz	a3,1160 <printint+0x16>
    115c:	0805c963          	bltz	a1,11ee <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1160:	2581                	sext.w	a1,a1
  neg = 0;
    1162:	4881                	li	a7,0
    1164:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1168:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    116a:	2601                	sext.w	a2,a2
    116c:	00000517          	auipc	a0,0x0
    1170:	63c50513          	addi	a0,a0,1596 # 17a8 <digits>
    1174:	883a                	mv	a6,a4
    1176:	2705                	addiw	a4,a4,1
    1178:	02c5f7bb          	remuw	a5,a1,a2
    117c:	1782                	slli	a5,a5,0x20
    117e:	9381                	srli	a5,a5,0x20
    1180:	97aa                	add	a5,a5,a0
    1182:	0007c783          	lbu	a5,0(a5)
    1186:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    118a:	0005879b          	sext.w	a5,a1
    118e:	02c5d5bb          	divuw	a1,a1,a2
    1192:	0685                	addi	a3,a3,1
    1194:	fec7f0e3          	bgeu	a5,a2,1174 <printint+0x2a>
  if(neg)
    1198:	00088c63          	beqz	a7,11b0 <printint+0x66>
    buf[i++] = '-';
    119c:	fd070793          	addi	a5,a4,-48
    11a0:	00878733          	add	a4,a5,s0
    11a4:	02d00793          	li	a5,45
    11a8:	fef70823          	sb	a5,-16(a4)
    11ac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    11b0:	02e05863          	blez	a4,11e0 <printint+0x96>
    11b4:	fc040793          	addi	a5,s0,-64
    11b8:	00e78933          	add	s2,a5,a4
    11bc:	fff78993          	addi	s3,a5,-1
    11c0:	99ba                	add	s3,s3,a4
    11c2:	377d                	addiw	a4,a4,-1
    11c4:	1702                	slli	a4,a4,0x20
    11c6:	9301                	srli	a4,a4,0x20
    11c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    11cc:	fff94583          	lbu	a1,-1(s2)
    11d0:	8526                	mv	a0,s1
    11d2:	00000097          	auipc	ra,0x0
    11d6:	f56080e7          	jalr	-170(ra) # 1128 <putc>
  while(--i >= 0)
    11da:	197d                	addi	s2,s2,-1
    11dc:	ff3918e3          	bne	s2,s3,11cc <printint+0x82>
}
    11e0:	70e2                	ld	ra,56(sp)
    11e2:	7442                	ld	s0,48(sp)
    11e4:	74a2                	ld	s1,40(sp)
    11e6:	7902                	ld	s2,32(sp)
    11e8:	69e2                	ld	s3,24(sp)
    11ea:	6121                	addi	sp,sp,64
    11ec:	8082                	ret
    x = -xx;
    11ee:	40b005bb          	negw	a1,a1
    neg = 1;
    11f2:	4885                	li	a7,1
    x = -xx;
    11f4:	bf85                	j	1164 <printint+0x1a>

00000000000011f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    11f6:	7119                	addi	sp,sp,-128
    11f8:	fc86                	sd	ra,120(sp)
    11fa:	f8a2                	sd	s0,112(sp)
    11fc:	f4a6                	sd	s1,104(sp)
    11fe:	f0ca                	sd	s2,96(sp)
    1200:	ecce                	sd	s3,88(sp)
    1202:	e8d2                	sd	s4,80(sp)
    1204:	e4d6                	sd	s5,72(sp)
    1206:	e0da                	sd	s6,64(sp)
    1208:	fc5e                	sd	s7,56(sp)
    120a:	f862                	sd	s8,48(sp)
    120c:	f466                	sd	s9,40(sp)
    120e:	f06a                	sd	s10,32(sp)
    1210:	ec6e                	sd	s11,24(sp)
    1212:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1214:	0005c903          	lbu	s2,0(a1)
    1218:	18090f63          	beqz	s2,13b6 <vprintf+0x1c0>
    121c:	8aaa                	mv	s5,a0
    121e:	8b32                	mv	s6,a2
    1220:	00158493          	addi	s1,a1,1
  state = 0;
    1224:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1226:	02500a13          	li	s4,37
    122a:	4c55                	li	s8,21
    122c:	00000c97          	auipc	s9,0x0
    1230:	524c8c93          	addi	s9,s9,1316 # 1750 <malloc+0x296>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1234:	02800d93          	li	s11,40
  putc(fd, 'x');
    1238:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    123a:	00000b97          	auipc	s7,0x0
    123e:	56eb8b93          	addi	s7,s7,1390 # 17a8 <digits>
    1242:	a839                	j	1260 <vprintf+0x6a>
        putc(fd, c);
    1244:	85ca                	mv	a1,s2
    1246:	8556                	mv	a0,s5
    1248:	00000097          	auipc	ra,0x0
    124c:	ee0080e7          	jalr	-288(ra) # 1128 <putc>
    1250:	a019                	j	1256 <vprintf+0x60>
    } else if(state == '%'){
    1252:	01498d63          	beq	s3,s4,126c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    1256:	0485                	addi	s1,s1,1
    1258:	fff4c903          	lbu	s2,-1(s1)
    125c:	14090d63          	beqz	s2,13b6 <vprintf+0x1c0>
    if(state == 0){
    1260:	fe0999e3          	bnez	s3,1252 <vprintf+0x5c>
      if(c == '%'){
    1264:	ff4910e3          	bne	s2,s4,1244 <vprintf+0x4e>
        state = '%';
    1268:	89d2                	mv	s3,s4
    126a:	b7f5                	j	1256 <vprintf+0x60>
      if(c == 'd'){
    126c:	11490c63          	beq	s2,s4,1384 <vprintf+0x18e>
    1270:	f9d9079b          	addiw	a5,s2,-99
    1274:	0ff7f793          	zext.b	a5,a5
    1278:	10fc6e63          	bltu	s8,a5,1394 <vprintf+0x19e>
    127c:	f9d9079b          	addiw	a5,s2,-99
    1280:	0ff7f713          	zext.b	a4,a5
    1284:	10ec6863          	bltu	s8,a4,1394 <vprintf+0x19e>
    1288:	00271793          	slli	a5,a4,0x2
    128c:	97e6                	add	a5,a5,s9
    128e:	439c                	lw	a5,0(a5)
    1290:	97e6                	add	a5,a5,s9
    1292:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1294:	008b0913          	addi	s2,s6,8
    1298:	4685                	li	a3,1
    129a:	4629                	li	a2,10
    129c:	000b2583          	lw	a1,0(s6)
    12a0:	8556                	mv	a0,s5
    12a2:	00000097          	auipc	ra,0x0
    12a6:	ea8080e7          	jalr	-344(ra) # 114a <printint>
    12aa:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    12ac:	4981                	li	s3,0
    12ae:	b765                	j	1256 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    12b0:	008b0913          	addi	s2,s6,8
    12b4:	4681                	li	a3,0
    12b6:	4629                	li	a2,10
    12b8:	000b2583          	lw	a1,0(s6)
    12bc:	8556                	mv	a0,s5
    12be:	00000097          	auipc	ra,0x0
    12c2:	e8c080e7          	jalr	-372(ra) # 114a <printint>
    12c6:	8b4a                	mv	s6,s2
      state = 0;
    12c8:	4981                	li	s3,0
    12ca:	b771                	j	1256 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    12cc:	008b0913          	addi	s2,s6,8
    12d0:	4681                	li	a3,0
    12d2:	866a                	mv	a2,s10
    12d4:	000b2583          	lw	a1,0(s6)
    12d8:	8556                	mv	a0,s5
    12da:	00000097          	auipc	ra,0x0
    12de:	e70080e7          	jalr	-400(ra) # 114a <printint>
    12e2:	8b4a                	mv	s6,s2
      state = 0;
    12e4:	4981                	li	s3,0
    12e6:	bf85                	j	1256 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    12e8:	008b0793          	addi	a5,s6,8
    12ec:	f8f43423          	sd	a5,-120(s0)
    12f0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    12f4:	03000593          	li	a1,48
    12f8:	8556                	mv	a0,s5
    12fa:	00000097          	auipc	ra,0x0
    12fe:	e2e080e7          	jalr	-466(ra) # 1128 <putc>
  putc(fd, 'x');
    1302:	07800593          	li	a1,120
    1306:	8556                	mv	a0,s5
    1308:	00000097          	auipc	ra,0x0
    130c:	e20080e7          	jalr	-480(ra) # 1128 <putc>
    1310:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1312:	03c9d793          	srli	a5,s3,0x3c
    1316:	97de                	add	a5,a5,s7
    1318:	0007c583          	lbu	a1,0(a5)
    131c:	8556                	mv	a0,s5
    131e:	00000097          	auipc	ra,0x0
    1322:	e0a080e7          	jalr	-502(ra) # 1128 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1326:	0992                	slli	s3,s3,0x4
    1328:	397d                	addiw	s2,s2,-1
    132a:	fe0914e3          	bnez	s2,1312 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    132e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1332:	4981                	li	s3,0
    1334:	b70d                	j	1256 <vprintf+0x60>
        s = va_arg(ap, char*);
    1336:	008b0913          	addi	s2,s6,8
    133a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    133e:	02098163          	beqz	s3,1360 <vprintf+0x16a>
        while(*s != 0){
    1342:	0009c583          	lbu	a1,0(s3)
    1346:	c5ad                	beqz	a1,13b0 <vprintf+0x1ba>
          putc(fd, *s);
    1348:	8556                	mv	a0,s5
    134a:	00000097          	auipc	ra,0x0
    134e:	dde080e7          	jalr	-546(ra) # 1128 <putc>
          s++;
    1352:	0985                	addi	s3,s3,1
        while(*s != 0){
    1354:	0009c583          	lbu	a1,0(s3)
    1358:	f9e5                	bnez	a1,1348 <vprintf+0x152>
        s = va_arg(ap, char*);
    135a:	8b4a                	mv	s6,s2
      state = 0;
    135c:	4981                	li	s3,0
    135e:	bde5                	j	1256 <vprintf+0x60>
          s = "(null)";
    1360:	00000997          	auipc	s3,0x0
    1364:	3e898993          	addi	s3,s3,1000 # 1748 <malloc+0x28e>
        while(*s != 0){
    1368:	85ee                	mv	a1,s11
    136a:	bff9                	j	1348 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    136c:	008b0913          	addi	s2,s6,8
    1370:	000b4583          	lbu	a1,0(s6)
    1374:	8556                	mv	a0,s5
    1376:	00000097          	auipc	ra,0x0
    137a:	db2080e7          	jalr	-590(ra) # 1128 <putc>
    137e:	8b4a                	mv	s6,s2
      state = 0;
    1380:	4981                	li	s3,0
    1382:	bdd1                	j	1256 <vprintf+0x60>
        putc(fd, c);
    1384:	85d2                	mv	a1,s4
    1386:	8556                	mv	a0,s5
    1388:	00000097          	auipc	ra,0x0
    138c:	da0080e7          	jalr	-608(ra) # 1128 <putc>
      state = 0;
    1390:	4981                	li	s3,0
    1392:	b5d1                	j	1256 <vprintf+0x60>
        putc(fd, '%');
    1394:	85d2                	mv	a1,s4
    1396:	8556                	mv	a0,s5
    1398:	00000097          	auipc	ra,0x0
    139c:	d90080e7          	jalr	-624(ra) # 1128 <putc>
        putc(fd, c);
    13a0:	85ca                	mv	a1,s2
    13a2:	8556                	mv	a0,s5
    13a4:	00000097          	auipc	ra,0x0
    13a8:	d84080e7          	jalr	-636(ra) # 1128 <putc>
      state = 0;
    13ac:	4981                	li	s3,0
    13ae:	b565                	j	1256 <vprintf+0x60>
        s = va_arg(ap, char*);
    13b0:	8b4a                	mv	s6,s2
      state = 0;
    13b2:	4981                	li	s3,0
    13b4:	b54d                	j	1256 <vprintf+0x60>
    }
  }
}
    13b6:	70e6                	ld	ra,120(sp)
    13b8:	7446                	ld	s0,112(sp)
    13ba:	74a6                	ld	s1,104(sp)
    13bc:	7906                	ld	s2,96(sp)
    13be:	69e6                	ld	s3,88(sp)
    13c0:	6a46                	ld	s4,80(sp)
    13c2:	6aa6                	ld	s5,72(sp)
    13c4:	6b06                	ld	s6,64(sp)
    13c6:	7be2                	ld	s7,56(sp)
    13c8:	7c42                	ld	s8,48(sp)
    13ca:	7ca2                	ld	s9,40(sp)
    13cc:	7d02                	ld	s10,32(sp)
    13ce:	6de2                	ld	s11,24(sp)
    13d0:	6109                	addi	sp,sp,128
    13d2:	8082                	ret

00000000000013d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    13d4:	715d                	addi	sp,sp,-80
    13d6:	ec06                	sd	ra,24(sp)
    13d8:	e822                	sd	s0,16(sp)
    13da:	1000                	addi	s0,sp,32
    13dc:	e010                	sd	a2,0(s0)
    13de:	e414                	sd	a3,8(s0)
    13e0:	e818                	sd	a4,16(s0)
    13e2:	ec1c                	sd	a5,24(s0)
    13e4:	03043023          	sd	a6,32(s0)
    13e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    13ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    13f0:	8622                	mv	a2,s0
    13f2:	00000097          	auipc	ra,0x0
    13f6:	e04080e7          	jalr	-508(ra) # 11f6 <vprintf>
}
    13fa:	60e2                	ld	ra,24(sp)
    13fc:	6442                	ld	s0,16(sp)
    13fe:	6161                	addi	sp,sp,80
    1400:	8082                	ret

0000000000001402 <printf>:

void
printf(const char *fmt, ...)
{
    1402:	711d                	addi	sp,sp,-96
    1404:	ec06                	sd	ra,24(sp)
    1406:	e822                	sd	s0,16(sp)
    1408:	1000                	addi	s0,sp,32
    140a:	e40c                	sd	a1,8(s0)
    140c:	e810                	sd	a2,16(s0)
    140e:	ec14                	sd	a3,24(s0)
    1410:	f018                	sd	a4,32(s0)
    1412:	f41c                	sd	a5,40(s0)
    1414:	03043823          	sd	a6,48(s0)
    1418:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    141c:	00840613          	addi	a2,s0,8
    1420:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1424:	85aa                	mv	a1,a0
    1426:	4505                	li	a0,1
    1428:	00000097          	auipc	ra,0x0
    142c:	dce080e7          	jalr	-562(ra) # 11f6 <vprintf>
}
    1430:	60e2                	ld	ra,24(sp)
    1432:	6442                	ld	s0,16(sp)
    1434:	6125                	addi	sp,sp,96
    1436:	8082                	ret

0000000000001438 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    1438:	1141                	addi	sp,sp,-16
    143a:	e422                	sd	s0,8(sp)
    143c:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    143e:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1442:	00001797          	auipc	a5,0x1
    1446:	bce7b783          	ld	a5,-1074(a5) # 2010 <freep>
    144a:	a02d                	j	1474 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
    144c:	4618                	lw	a4,8(a2)
    144e:	9f2d                	addw	a4,a4,a1
    1450:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    1454:	6398                	ld	a4,0(a5)
    1456:	6310                	ld	a2,0(a4)
    1458:	a83d                	j	1496 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
    145a:	ff852703          	lw	a4,-8(a0)
    145e:	9f31                	addw	a4,a4,a2
    1460:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    1462:	ff053683          	ld	a3,-16(a0)
    1466:	a091                	j	14aa <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1468:	6398                	ld	a4,0(a5)
    146a:	00e7e463          	bltu	a5,a4,1472 <free+0x3a>
    146e:	00e6ea63          	bltu	a3,a4,1482 <free+0x4a>
{
    1472:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1474:	fed7fae3          	bgeu	a5,a3,1468 <free+0x30>
    1478:	6398                	ld	a4,0(a5)
    147a:	00e6e463          	bltu	a3,a4,1482 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    147e:	fee7eae3          	bltu	a5,a4,1472 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
    1482:	ff852583          	lw	a1,-8(a0)
    1486:	6390                	ld	a2,0(a5)
    1488:	02059813          	slli	a6,a1,0x20
    148c:	01c85713          	srli	a4,a6,0x1c
    1490:	9736                	add	a4,a4,a3
    1492:	fae60de3          	beq	a2,a4,144c <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
    1496:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
    149a:	4790                	lw	a2,8(a5)
    149c:	02061593          	slli	a1,a2,0x20
    14a0:	01c5d713          	srli	a4,a1,0x1c
    14a4:	973e                	add	a4,a4,a5
    14a6:	fae68ae3          	beq	a3,a4,145a <free+0x22>
        p->s.ptr = bp->s.ptr;
    14aa:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    14ac:	00001717          	auipc	a4,0x1
    14b0:	b6f73223          	sd	a5,-1180(a4) # 2010 <freep>
}
    14b4:	6422                	ld	s0,8(sp)
    14b6:	0141                	addi	sp,sp,16
    14b8:	8082                	ret

00000000000014ba <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    14ba:	7139                	addi	sp,sp,-64
    14bc:	fc06                	sd	ra,56(sp)
    14be:	f822                	sd	s0,48(sp)
    14c0:	f426                	sd	s1,40(sp)
    14c2:	f04a                	sd	s2,32(sp)
    14c4:	ec4e                	sd	s3,24(sp)
    14c6:	e852                	sd	s4,16(sp)
    14c8:	e456                	sd	s5,8(sp)
    14ca:	e05a                	sd	s6,0(sp)
    14cc:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    14ce:	02051493          	slli	s1,a0,0x20
    14d2:	9081                	srli	s1,s1,0x20
    14d4:	04bd                	addi	s1,s1,15
    14d6:	8091                	srli	s1,s1,0x4
    14d8:	0014899b          	addiw	s3,s1,1
    14dc:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
    14de:	00001517          	auipc	a0,0x1
    14e2:	b3253503          	ld	a0,-1230(a0) # 2010 <freep>
    14e6:	c515                	beqz	a0,1512 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    14e8:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    14ea:	4798                	lw	a4,8(a5)
    14ec:	02977f63          	bgeu	a4,s1,152a <malloc+0x70>
    14f0:	8a4e                	mv	s4,s3
    14f2:	0009871b          	sext.w	a4,s3
    14f6:	6685                	lui	a3,0x1
    14f8:	00d77363          	bgeu	a4,a3,14fe <malloc+0x44>
    14fc:	6a05                	lui	s4,0x1
    14fe:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    1502:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    1506:	00001917          	auipc	s2,0x1
    150a:	b0a90913          	addi	s2,s2,-1270 # 2010 <freep>
    if (p == (char *)-1)
    150e:	5afd                	li	s5,-1
    1510:	a895                	j	1584 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
    1512:	00001797          	auipc	a5,0x1
    1516:	b8678793          	addi	a5,a5,-1146 # 2098 <base>
    151a:	00001717          	auipc	a4,0x1
    151e:	aef73b23          	sd	a5,-1290(a4) # 2010 <freep>
    1522:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    1524:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    1528:	b7e1                	j	14f0 <malloc+0x36>
            if (p->s.size == nunits)
    152a:	02e48c63          	beq	s1,a4,1562 <malloc+0xa8>
                p->s.size -= nunits;
    152e:	4137073b          	subw	a4,a4,s3
    1532:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1534:	02071693          	slli	a3,a4,0x20
    1538:	01c6d713          	srli	a4,a3,0x1c
    153c:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    153e:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1542:	00001717          	auipc	a4,0x1
    1546:	aca73723          	sd	a0,-1330(a4) # 2010 <freep>
            return (void *)(p + 1);
    154a:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
    154e:	70e2                	ld	ra,56(sp)
    1550:	7442                	ld	s0,48(sp)
    1552:	74a2                	ld	s1,40(sp)
    1554:	7902                	ld	s2,32(sp)
    1556:	69e2                	ld	s3,24(sp)
    1558:	6a42                	ld	s4,16(sp)
    155a:	6aa2                	ld	s5,8(sp)
    155c:	6b02                	ld	s6,0(sp)
    155e:	6121                	addi	sp,sp,64
    1560:	8082                	ret
                prevp->s.ptr = p->s.ptr;
    1562:	6398                	ld	a4,0(a5)
    1564:	e118                	sd	a4,0(a0)
    1566:	bff1                	j	1542 <malloc+0x88>
    hp->s.size = nu;
    1568:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    156c:	0541                	addi	a0,a0,16
    156e:	00000097          	auipc	ra,0x0
    1572:	eca080e7          	jalr	-310(ra) # 1438 <free>
    return freep;
    1576:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
    157a:	d971                	beqz	a0,154e <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    157c:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    157e:	4798                	lw	a4,8(a5)
    1580:	fa9775e3          	bgeu	a4,s1,152a <malloc+0x70>
        if (p == freep)
    1584:	00093703          	ld	a4,0(s2)
    1588:	853e                	mv	a0,a5
    158a:	fef719e3          	bne	a4,a5,157c <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
    158e:	8552                	mv	a0,s4
    1590:	00000097          	auipc	ra,0x0
    1594:	b68080e7          	jalr	-1176(ra) # 10f8 <sbrk>
    if (p == (char *)-1)
    1598:	fd5518e3          	bne	a0,s5,1568 <malloc+0xae>
                return 0;
    159c:	4501                	li	a0,0
    159e:	bf45                	j	154e <malloc+0x94>
