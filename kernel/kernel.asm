
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9a013103          	ld	sp,-1632(sp) # 800089a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	9b070713          	addi	a4,a4,-1616 # 80008a00 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	0de78793          	addi	a5,a5,222 # 80006140 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc78f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e1278793          	addi	a5,a5,-494 # 80000ebe <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
    int i;

    for (i = 0; i < n; i++)
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    {
        char c;
        if (either_copyin(&c, user_src, src + i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	760080e7          	jalr	1888(ra) # 8000288a <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
            break;
        uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7ca080e7          	jalr	1994(ra) # 80000904 <uartputc>
    for (i = 0; i < n; i++)
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    }

    return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
    for (i = 0; i < n; i++)
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
    uint target;
    int c;
    char cbuf;

    target = n;
    80000186:	00060b1b          	sext.w	s6,a2
    acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	9b650513          	addi	a0,a0,-1610 # 80010b40 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a8a080e7          	jalr	-1398(ra) # 80000c1c <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	9a648493          	addi	s1,s1,-1626 # 80010b40 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	a3690913          	addi	s2,s2,-1482 # 80010bd8 <cons+0x98>
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

        if (c == C('D'))
    800001aa:	4b91                	li	s7,4
            break;
        }

        // copy the input byte to the user-space buffer.
        cbuf = c;
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
            break;

        dst++;
        --n;

        if (c == '\n')
    800001ae:	4ca9                	li	s9,10
    while (n > 0)
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
        while (cons.r == cons.w)
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
            if (killed(myproc()))
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	aa6080e7          	jalr	-1370(ra) # 80001c66 <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	50c080e7          	jalr	1292(ra) # 800026d4 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
            sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	256080e7          	jalr	598(ra) # 8000242c <sleep>
        while (cons.r == cons.w)
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
        if (c == C('D'))
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
        cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	622080e7          	jalr	1570(ra) # 80002834 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
        dst++;
    8000021e:	0a05                	addi	s4,s4,1
        --n;
    80000220:	39fd                	addiw	s3,s3,-1
        if (c == '\n')
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
            // a whole line has arrived, return to
            // the user-level read().
            break;
        }
    }
    release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	91a50513          	addi	a0,a0,-1766 # 80010b40 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	aa2080e7          	jalr	-1374(ra) # 80000cd0 <release>

    return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
                release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	90450513          	addi	a0,a0,-1788 # 80010b40 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	a8c080e7          	jalr	-1396(ra) # 80000cd0 <release>
                return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
            if (n < target)
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
                cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	96f72323          	sw	a5,-1690(a4) # 80010bd8 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
    if (c == BACKSPACE)
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
        uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	5a6080e7          	jalr	1446(ra) # 80000832 <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
        uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	594080e7          	jalr	1428(ra) # 80000832 <uartputc_sync>
        uartputc_sync(' ');
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	588080e7          	jalr	1416(ra) # 80000832 <uartputc_sync>
        uartputc_sync('\b');
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	57e080e7          	jalr	1406(ra) # 80000832 <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
    acquire(&cons.lock);
    800002cc:	00011517          	auipc	a0,0x11
    800002d0:	87450513          	addi	a0,a0,-1932 # 80010b40 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	948080e7          	jalr	-1720(ra) # 80000c1c <acquire>

    switch (c)
    800002dc:	47c1                	li	a5,16
    800002de:	08f48e63          	beq	s1,a5,8000037a <consoleintr+0xbc>
    800002e2:	0297ce63          	blt	a5,s1,8000031e <consoleintr+0x60>
    800002e6:	478d                	li	a5,3
    800002e8:	0af48b63          	beq	s1,a5,8000039e <consoleintr+0xe0>
    800002ec:	47a1                	li	a5,8
    800002ee:	0ef49963          	bne	s1,a5,800003e0 <consoleintr+0x122>
            setkilled(current_proc);
    }
    break;
    case C('H'): // Backspace
    case '\x7f': // Delete key
        if (cons.e != cons.w)
    800002f2:	00011717          	auipc	a4,0x11
    800002f6:	84e70713          	addi	a4,a4,-1970 # 80010b40 <cons>
    800002fa:	0a072783          	lw	a5,160(a4)
    800002fe:	09c72703          	lw	a4,156(a4)
    80000302:	08f70063          	beq	a4,a5,80000382 <consoleintr+0xc4>
        {
            cons.e--;
    80000306:	37fd                	addiw	a5,a5,-1
    80000308:	00011717          	auipc	a4,0x11
    8000030c:	8cf72c23          	sw	a5,-1832(a4) # 80010be0 <cons+0xa0>
            consputc(BACKSPACE);
    80000310:	10000513          	li	a0,256
    80000314:	00000097          	auipc	ra,0x0
    80000318:	f68080e7          	jalr	-152(ra) # 8000027c <consputc>
    8000031c:	a09d                	j	80000382 <consoleintr+0xc4>
    switch (c)
    8000031e:	47d5                	li	a5,21
    80000320:	00f48763          	beq	s1,a5,8000032e <consoleintr+0x70>
    80000324:	07f00793          	li	a5,127
    80000328:	fcf485e3          	beq	s1,a5,800002f2 <consoleintr+0x34>
    8000032c:	a85d                	j	800003e2 <consoleintr+0x124>
        while (cons.e != cons.w &&
    8000032e:	00011717          	auipc	a4,0x11
    80000332:	81270713          	addi	a4,a4,-2030 # 80010b40 <cons>
    80000336:	0a072783          	lw	a5,160(a4)
    8000033a:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    8000033e:	00011497          	auipc	s1,0x11
    80000342:	80248493          	addi	s1,s1,-2046 # 80010b40 <cons>
        while (cons.e != cons.w &&
    80000346:	4929                	li	s2,10
    80000348:	02f70d63          	beq	a4,a5,80000382 <consoleintr+0xc4>
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    8000034c:	37fd                	addiw	a5,a5,-1
    8000034e:	07f7f713          	andi	a4,a5,127
    80000352:	9726                	add	a4,a4,s1
        while (cons.e != cons.w &&
    80000354:	01874703          	lbu	a4,24(a4)
    80000358:	03270563          	beq	a4,s2,80000382 <consoleintr+0xc4>
            cons.e--;
    8000035c:	0af4a023          	sw	a5,160(s1)
            consputc(BACKSPACE);
    80000360:	10000513          	li	a0,256
    80000364:	00000097          	auipc	ra,0x0
    80000368:	f18080e7          	jalr	-232(ra) # 8000027c <consputc>
        while (cons.e != cons.w &&
    8000036c:	0a04a783          	lw	a5,160(s1)
    80000370:	09c4a703          	lw	a4,156(s1)
    80000374:	fcf71ce3          	bne	a4,a5,8000034c <consoleintr+0x8e>
    80000378:	a029                	j	80000382 <consoleintr+0xc4>
        procdump();
    8000037a:	00002097          	auipc	ra,0x2
    8000037e:	566080e7          	jalr	1382(ra) # 800028e0 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000382:	00010517          	auipc	a0,0x10
    80000386:	7be50513          	addi	a0,a0,1982 # 80010b40 <cons>
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	946080e7          	jalr	-1722(ra) # 80000cd0 <release>
}
    80000392:	60e2                	ld	ra,24(sp)
    80000394:	6442                	ld	s0,16(sp)
    80000396:	64a2                	ld	s1,8(sp)
    80000398:	6902                	ld	s2,0(sp)
    8000039a:	6105                	addi	sp,sp,32
    8000039c:	8082                	ret
        struct proc *p = proc;
    8000039e:	00011797          	auipc	a5,0x11
    800003a2:	cf278793          	addi	a5,a5,-782 # 80011090 <proc>
        struct proc *current_proc = proc;
    800003a6:	853e                	mv	a0,a5
        for (; p < &proc[NPROC]; ++p)
    800003a8:	00017697          	auipc	a3,0x17
    800003ac:	8e868693          	addi	a3,a3,-1816 # 80016c90 <tickslock>
    800003b0:	a029                	j	800003ba <consoleintr+0xfc>
    800003b2:	17078793          	addi	a5,a5,368
    800003b6:	00d78a63          	beq	a5,a3,800003ca <consoleintr+0x10c>
            if (p->state != UNUSED && p->pid > current_proc->pid)
    800003ba:	4f98                	lw	a4,24(a5)
    800003bc:	db7d                	beqz	a4,800003b2 <consoleintr+0xf4>
    800003be:	5b90                	lw	a2,48(a5)
    800003c0:	5918                	lw	a4,48(a0)
    800003c2:	fec758e3          	bge	a4,a2,800003b2 <consoleintr+0xf4>
    800003c6:	853e                	mv	a0,a5
    800003c8:	b7ed                	j	800003b2 <consoleintr+0xf4>
        if (!current_proc)
    800003ca:	dd45                	beqz	a0,80000382 <consoleintr+0xc4>
        if (current_proc->parent->pid != 1)
    800003cc:	613c                	ld	a5,64(a0)
    800003ce:	5b98                	lw	a4,48(a5)
    800003d0:	4785                	li	a5,1
    800003d2:	faf708e3          	beq	a4,a5,80000382 <consoleintr+0xc4>
            setkilled(current_proc);
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	2d2080e7          	jalr	722(ra) # 800026a8 <setkilled>
    800003de:	b755                	j	80000382 <consoleintr+0xc4>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    800003e0:	d0cd                	beqz	s1,80000382 <consoleintr+0xc4>
    800003e2:	00010717          	auipc	a4,0x10
    800003e6:	75e70713          	addi	a4,a4,1886 # 80010b40 <cons>
    800003ea:	0a072783          	lw	a5,160(a4)
    800003ee:	09872703          	lw	a4,152(a4)
    800003f2:	9f99                	subw	a5,a5,a4
    800003f4:	07f00713          	li	a4,127
    800003f8:	f8f765e3          	bltu	a4,a5,80000382 <consoleintr+0xc4>
            c = (c == '\r') ? '\n' : c;
    800003fc:	47b5                	li	a5,13
    800003fe:	04f48863          	beq	s1,a5,8000044e <consoleintr+0x190>
            consputc(c);
    80000402:	8526                	mv	a0,s1
    80000404:	00000097          	auipc	ra,0x0
    80000408:	e78080e7          	jalr	-392(ra) # 8000027c <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000040c:	00010797          	auipc	a5,0x10
    80000410:	73478793          	addi	a5,a5,1844 # 80010b40 <cons>
    80000414:	0a07a683          	lw	a3,160(a5)
    80000418:	0016871b          	addiw	a4,a3,1
    8000041c:	0007061b          	sext.w	a2,a4
    80000420:	0ae7a023          	sw	a4,160(a5)
    80000424:	07f6f693          	andi	a3,a3,127
    80000428:	97b6                	add	a5,a5,a3
    8000042a:	00978c23          	sb	s1,24(a5)
            if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE)
    8000042e:	47a9                	li	a5,10
    80000430:	04f48663          	beq	s1,a5,8000047c <consoleintr+0x1be>
    80000434:	4791                	li	a5,4
    80000436:	04f48363          	beq	s1,a5,8000047c <consoleintr+0x1be>
    8000043a:	00010797          	auipc	a5,0x10
    8000043e:	79e7a783          	lw	a5,1950(a5) # 80010bd8 <cons+0x98>
    80000442:	9f1d                	subw	a4,a4,a5
    80000444:	08000793          	li	a5,128
    80000448:	f2f71de3          	bne	a4,a5,80000382 <consoleintr+0xc4>
    8000044c:	a805                	j	8000047c <consoleintr+0x1be>
            consputc(c);
    8000044e:	4529                	li	a0,10
    80000450:	00000097          	auipc	ra,0x0
    80000454:	e2c080e7          	jalr	-468(ra) # 8000027c <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000458:	00010797          	auipc	a5,0x10
    8000045c:	6e878793          	addi	a5,a5,1768 # 80010b40 <cons>
    80000460:	0a07a703          	lw	a4,160(a5)
    80000464:	0017069b          	addiw	a3,a4,1
    80000468:	0006861b          	sext.w	a2,a3
    8000046c:	0ad7a023          	sw	a3,160(a5)
    80000470:	07f77713          	andi	a4,a4,127
    80000474:	97ba                	add	a5,a5,a4
    80000476:	4729                	li	a4,10
    80000478:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    8000047c:	00010797          	auipc	a5,0x10
    80000480:	76c7a023          	sw	a2,1888(a5) # 80010bdc <cons+0x9c>
                wakeup(&cons.r);
    80000484:	00010517          	auipc	a0,0x10
    80000488:	75450513          	addi	a0,a0,1876 # 80010bd8 <cons+0x98>
    8000048c:	00002097          	auipc	ra,0x2
    80000490:	004080e7          	jalr	4(ra) # 80002490 <wakeup>
    80000494:	b5fd                	j	80000382 <consoleintr+0xc4>

0000000080000496 <consoleinit>:

void consoleinit(void)
{
    80000496:	1141                	addi	sp,sp,-16
    80000498:	e406                	sd	ra,8(sp)
    8000049a:	e022                	sd	s0,0(sp)
    8000049c:	0800                	addi	s0,sp,16
    initlock(&cons.lock, "cons");
    8000049e:	00008597          	auipc	a1,0x8
    800004a2:	b7258593          	addi	a1,a1,-1166 # 80008010 <etext+0x10>
    800004a6:	00010517          	auipc	a0,0x10
    800004aa:	69a50513          	addi	a0,a0,1690 # 80010b40 <cons>
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	6de080e7          	jalr	1758(ra) # 80000b8c <initlock>

    uartinit();
    800004b6:	00000097          	auipc	ra,0x0
    800004ba:	32c080e7          	jalr	812(ra) # 800007e2 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    800004be:	00021797          	auipc	a5,0x21
    800004c2:	a1a78793          	addi	a5,a5,-1510 # 80020ed8 <devsw>
    800004c6:	00000717          	auipc	a4,0x0
    800004ca:	c9e70713          	addi	a4,a4,-866 # 80000164 <consoleread>
    800004ce:	eb98                	sd	a4,16(a5)
    devsw[CONSOLE].write = consolewrite;
    800004d0:	00000717          	auipc	a4,0x0
    800004d4:	c3070713          	addi	a4,a4,-976 # 80000100 <consolewrite>
    800004d8:	ef98                	sd	a4,24(a5)
}
    800004da:	60a2                	ld	ra,8(sp)
    800004dc:	6402                	ld	s0,0(sp)
    800004de:	0141                	addi	sp,sp,16
    800004e0:	8082                	ret

00000000800004e2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004e2:	7179                	addi	sp,sp,-48
    800004e4:	f406                	sd	ra,40(sp)
    800004e6:	f022                	sd	s0,32(sp)
    800004e8:	ec26                	sd	s1,24(sp)
    800004ea:	e84a                	sd	s2,16(sp)
    800004ec:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004ee:	c219                	beqz	a2,800004f4 <printint+0x12>
    800004f0:	08054763          	bltz	a0,8000057e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004f4:	2501                	sext.w	a0,a0
    800004f6:	4881                	li	a7,0
    800004f8:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004fc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004fe:	2581                	sext.w	a1,a1
    80000500:	00008617          	auipc	a2,0x8
    80000504:	b4060613          	addi	a2,a2,-1216 # 80008040 <digits>
    80000508:	883a                	mv	a6,a4
    8000050a:	2705                	addiw	a4,a4,1
    8000050c:	02b577bb          	remuw	a5,a0,a1
    80000510:	1782                	slli	a5,a5,0x20
    80000512:	9381                	srli	a5,a5,0x20
    80000514:	97b2                	add	a5,a5,a2
    80000516:	0007c783          	lbu	a5,0(a5)
    8000051a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000051e:	0005079b          	sext.w	a5,a0
    80000522:	02b5553b          	divuw	a0,a0,a1
    80000526:	0685                	addi	a3,a3,1
    80000528:	feb7f0e3          	bgeu	a5,a1,80000508 <printint+0x26>

  if(sign)
    8000052c:	00088c63          	beqz	a7,80000544 <printint+0x62>
    buf[i++] = '-';
    80000530:	fe070793          	addi	a5,a4,-32
    80000534:	00878733          	add	a4,a5,s0
    80000538:	02d00793          	li	a5,45
    8000053c:	fef70823          	sb	a5,-16(a4)
    80000540:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000544:	02e05763          	blez	a4,80000572 <printint+0x90>
    80000548:	fd040793          	addi	a5,s0,-48
    8000054c:	00e784b3          	add	s1,a5,a4
    80000550:	fff78913          	addi	s2,a5,-1
    80000554:	993a                	add	s2,s2,a4
    80000556:	377d                	addiw	a4,a4,-1
    80000558:	1702                	slli	a4,a4,0x20
    8000055a:	9301                	srli	a4,a4,0x20
    8000055c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000560:	fff4c503          	lbu	a0,-1(s1)
    80000564:	00000097          	auipc	ra,0x0
    80000568:	d18080e7          	jalr	-744(ra) # 8000027c <consputc>
  while(--i >= 0)
    8000056c:	14fd                	addi	s1,s1,-1
    8000056e:	ff2499e3          	bne	s1,s2,80000560 <printint+0x7e>
}
    80000572:	70a2                	ld	ra,40(sp)
    80000574:	7402                	ld	s0,32(sp)
    80000576:	64e2                	ld	s1,24(sp)
    80000578:	6942                	ld	s2,16(sp)
    8000057a:	6145                	addi	sp,sp,48
    8000057c:	8082                	ret
    x = -xx;
    8000057e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000582:	4885                	li	a7,1
    x = -xx;
    80000584:	bf95                	j	800004f8 <printint+0x16>

0000000080000586 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000586:	1101                	addi	sp,sp,-32
    80000588:	ec06                	sd	ra,24(sp)
    8000058a:	e822                	sd	s0,16(sp)
    8000058c:	e426                	sd	s1,8(sp)
    8000058e:	1000                	addi	s0,sp,32
    80000590:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000592:	00010797          	auipc	a5,0x10
    80000596:	6607a723          	sw	zero,1646(a5) # 80010c00 <pr+0x18>
  printf("panic: ");
    8000059a:	00008517          	auipc	a0,0x8
    8000059e:	a7e50513          	addi	a0,a0,-1410 # 80008018 <etext+0x18>
    800005a2:	00000097          	auipc	ra,0x0
    800005a6:	02e080e7          	jalr	46(ra) # 800005d0 <printf>
  printf(s);
    800005aa:	8526                	mv	a0,s1
    800005ac:	00000097          	auipc	ra,0x0
    800005b0:	024080e7          	jalr	36(ra) # 800005d0 <printf>
  printf("\n");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	b1450513          	addi	a0,a0,-1260 # 800080c8 <digits+0x88>
    800005bc:	00000097          	auipc	ra,0x0
    800005c0:	014080e7          	jalr	20(ra) # 800005d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800005c4:	4785                	li	a5,1
    800005c6:	00008717          	auipc	a4,0x8
    800005ca:	3ef72d23          	sw	a5,1018(a4) # 800089c0 <panicked>
  for(;;)
    800005ce:	a001                	j	800005ce <panic+0x48>

00000000800005d0 <printf>:
{
    800005d0:	7131                	addi	sp,sp,-192
    800005d2:	fc86                	sd	ra,120(sp)
    800005d4:	f8a2                	sd	s0,112(sp)
    800005d6:	f4a6                	sd	s1,104(sp)
    800005d8:	f0ca                	sd	s2,96(sp)
    800005da:	ecce                	sd	s3,88(sp)
    800005dc:	e8d2                	sd	s4,80(sp)
    800005de:	e4d6                	sd	s5,72(sp)
    800005e0:	e0da                	sd	s6,64(sp)
    800005e2:	fc5e                	sd	s7,56(sp)
    800005e4:	f862                	sd	s8,48(sp)
    800005e6:	f466                	sd	s9,40(sp)
    800005e8:	f06a                	sd	s10,32(sp)
    800005ea:	ec6e                	sd	s11,24(sp)
    800005ec:	0100                	addi	s0,sp,128
    800005ee:	8a2a                	mv	s4,a0
    800005f0:	e40c                	sd	a1,8(s0)
    800005f2:	e810                	sd	a2,16(s0)
    800005f4:	ec14                	sd	a3,24(s0)
    800005f6:	f018                	sd	a4,32(s0)
    800005f8:	f41c                	sd	a5,40(s0)
    800005fa:	03043823          	sd	a6,48(s0)
    800005fe:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000602:	00010d97          	auipc	s11,0x10
    80000606:	5fedad83          	lw	s11,1534(s11) # 80010c00 <pr+0x18>
  if(locking)
    8000060a:	020d9b63          	bnez	s11,80000640 <printf+0x70>
  if (fmt == 0)
    8000060e:	040a0263          	beqz	s4,80000652 <printf+0x82>
  va_start(ap, fmt);
    80000612:	00840793          	addi	a5,s0,8
    80000616:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000061a:	000a4503          	lbu	a0,0(s4)
    8000061e:	14050f63          	beqz	a0,8000077c <printf+0x1ac>
    80000622:	4981                	li	s3,0
    if(c != '%'){
    80000624:	02500a93          	li	s5,37
    switch(c){
    80000628:	07000b93          	li	s7,112
  consputc('x');
    8000062c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000062e:	00008b17          	auipc	s6,0x8
    80000632:	a12b0b13          	addi	s6,s6,-1518 # 80008040 <digits>
    switch(c){
    80000636:	07300c93          	li	s9,115
    8000063a:	06400c13          	li	s8,100
    8000063e:	a82d                	j	80000678 <printf+0xa8>
    acquire(&pr.lock);
    80000640:	00010517          	auipc	a0,0x10
    80000644:	5a850513          	addi	a0,a0,1448 # 80010be8 <pr>
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	5d4080e7          	jalr	1492(ra) # 80000c1c <acquire>
    80000650:	bf7d                	j	8000060e <printf+0x3e>
    panic("null fmt");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	9d650513          	addi	a0,a0,-1578 # 80008028 <etext+0x28>
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f2c080e7          	jalr	-212(ra) # 80000586 <panic>
      consputc(c);
    80000662:	00000097          	auipc	ra,0x0
    80000666:	c1a080e7          	jalr	-998(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000066a:	2985                	addiw	s3,s3,1
    8000066c:	013a07b3          	add	a5,s4,s3
    80000670:	0007c503          	lbu	a0,0(a5)
    80000674:	10050463          	beqz	a0,8000077c <printf+0x1ac>
    if(c != '%'){
    80000678:	ff5515e3          	bne	a0,s5,80000662 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000067c:	2985                	addiw	s3,s3,1
    8000067e:	013a07b3          	add	a5,s4,s3
    80000682:	0007c783          	lbu	a5,0(a5)
    80000686:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000068a:	cbed                	beqz	a5,8000077c <printf+0x1ac>
    switch(c){
    8000068c:	05778a63          	beq	a5,s7,800006e0 <printf+0x110>
    80000690:	02fbf663          	bgeu	s7,a5,800006bc <printf+0xec>
    80000694:	09978863          	beq	a5,s9,80000724 <printf+0x154>
    80000698:	07800713          	li	a4,120
    8000069c:	0ce79563          	bne	a5,a4,80000766 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    800006a0:	f8843783          	ld	a5,-120(s0)
    800006a4:	00878713          	addi	a4,a5,8
    800006a8:	f8e43423          	sd	a4,-120(s0)
    800006ac:	4605                	li	a2,1
    800006ae:	85ea                	mv	a1,s10
    800006b0:	4388                	lw	a0,0(a5)
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	e30080e7          	jalr	-464(ra) # 800004e2 <printint>
      break;
    800006ba:	bf45                	j	8000066a <printf+0x9a>
    switch(c){
    800006bc:	09578f63          	beq	a5,s5,8000075a <printf+0x18a>
    800006c0:	0b879363          	bne	a5,s8,80000766 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    800006c4:	f8843783          	ld	a5,-120(s0)
    800006c8:	00878713          	addi	a4,a5,8
    800006cc:	f8e43423          	sd	a4,-120(s0)
    800006d0:	4605                	li	a2,1
    800006d2:	45a9                	li	a1,10
    800006d4:	4388                	lw	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	e0c080e7          	jalr	-500(ra) # 800004e2 <printint>
      break;
    800006de:	b771                	j	8000066a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006e0:	f8843783          	ld	a5,-120(s0)
    800006e4:	00878713          	addi	a4,a5,8
    800006e8:	f8e43423          	sd	a4,-120(s0)
    800006ec:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006f0:	03000513          	li	a0,48
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b88080e7          	jalr	-1144(ra) # 8000027c <consputc>
  consputc('x');
    800006fc:	07800513          	li	a0,120
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b7c080e7          	jalr	-1156(ra) # 8000027c <consputc>
    80000708:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000070a:	03c95793          	srli	a5,s2,0x3c
    8000070e:	97da                	add	a5,a5,s6
    80000710:	0007c503          	lbu	a0,0(a5)
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000071c:	0912                	slli	s2,s2,0x4
    8000071e:	34fd                	addiw	s1,s1,-1
    80000720:	f4ed                	bnez	s1,8000070a <printf+0x13a>
    80000722:	b7a1                	j	8000066a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80000724:	f8843783          	ld	a5,-120(s0)
    80000728:	00878713          	addi	a4,a5,8
    8000072c:	f8e43423          	sd	a4,-120(s0)
    80000730:	6384                	ld	s1,0(a5)
    80000732:	cc89                	beqz	s1,8000074c <printf+0x17c>
      for(; *s; s++)
    80000734:	0004c503          	lbu	a0,0(s1)
    80000738:	d90d                	beqz	a0,8000066a <printf+0x9a>
        consputc(*s);
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	b42080e7          	jalr	-1214(ra) # 8000027c <consputc>
      for(; *s; s++)
    80000742:	0485                	addi	s1,s1,1
    80000744:	0004c503          	lbu	a0,0(s1)
    80000748:	f96d                	bnez	a0,8000073a <printf+0x16a>
    8000074a:	b705                	j	8000066a <printf+0x9a>
        s = "(null)";
    8000074c:	00008497          	auipc	s1,0x8
    80000750:	8d448493          	addi	s1,s1,-1836 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000754:	02800513          	li	a0,40
    80000758:	b7cd                	j	8000073a <printf+0x16a>
      consputc('%');
    8000075a:	8556                	mv	a0,s5
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	b20080e7          	jalr	-1248(ra) # 8000027c <consputc>
      break;
    80000764:	b719                	j	8000066a <printf+0x9a>
      consputc('%');
    80000766:	8556                	mv	a0,s5
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	b14080e7          	jalr	-1260(ra) # 8000027c <consputc>
      consputc(c);
    80000770:	8526                	mv	a0,s1
    80000772:	00000097          	auipc	ra,0x0
    80000776:	b0a080e7          	jalr	-1270(ra) # 8000027c <consputc>
      break;
    8000077a:	bdc5                	j	8000066a <printf+0x9a>
  if(locking)
    8000077c:	020d9163          	bnez	s11,8000079e <printf+0x1ce>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	74a6                	ld	s1,104(sp)
    80000786:	7906                	ld	s2,96(sp)
    80000788:	69e6                	ld	s3,88(sp)
    8000078a:	6a46                	ld	s4,80(sp)
    8000078c:	6aa6                	ld	s5,72(sp)
    8000078e:	6b06                	ld	s6,64(sp)
    80000790:	7be2                	ld	s7,56(sp)
    80000792:	7c42                	ld	s8,48(sp)
    80000794:	7ca2                	ld	s9,40(sp)
    80000796:	7d02                	ld	s10,32(sp)
    80000798:	6de2                	ld	s11,24(sp)
    8000079a:	6129                	addi	sp,sp,192
    8000079c:	8082                	ret
    release(&pr.lock);
    8000079e:	00010517          	auipc	a0,0x10
    800007a2:	44a50513          	addi	a0,a0,1098 # 80010be8 <pr>
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	52a080e7          	jalr	1322(ra) # 80000cd0 <release>
}
    800007ae:	bfc9                	j	80000780 <printf+0x1b0>

00000000800007b0 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b0:	1101                	addi	sp,sp,-32
    800007b2:	ec06                	sd	ra,24(sp)
    800007b4:	e822                	sd	s0,16(sp)
    800007b6:	e426                	sd	s1,8(sp)
    800007b8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007ba:	00010497          	auipc	s1,0x10
    800007be:	42e48493          	addi	s1,s1,1070 # 80010be8 <pr>
    800007c2:	00008597          	auipc	a1,0x8
    800007c6:	87658593          	addi	a1,a1,-1930 # 80008038 <etext+0x38>
    800007ca:	8526                	mv	a0,s1
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	3c0080e7          	jalr	960(ra) # 80000b8c <initlock>
  pr.locking = 1;
    800007d4:	4785                	li	a5,1
    800007d6:	cc9c                	sw	a5,24(s1)
}
    800007d8:	60e2                	ld	ra,24(sp)
    800007da:	6442                	ld	s0,16(sp)
    800007dc:	64a2                	ld	s1,8(sp)
    800007de:	6105                	addi	sp,sp,32
    800007e0:	8082                	ret

00000000800007e2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e2:	1141                	addi	sp,sp,-16
    800007e4:	e406                	sd	ra,8(sp)
    800007e6:	e022                	sd	s0,0(sp)
    800007e8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ea:	100007b7          	lui	a5,0x10000
    800007ee:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f2:	f8000713          	li	a4,-128
    800007f6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007fa:	470d                	li	a4,3
    800007fc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000800:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000804:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000808:	469d                	li	a3,7
    8000080a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000080e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000812:	00008597          	auipc	a1,0x8
    80000816:	84658593          	addi	a1,a1,-1978 # 80008058 <digits+0x18>
    8000081a:	00010517          	auipc	a0,0x10
    8000081e:	3ee50513          	addi	a0,a0,1006 # 80010c08 <uart_tx_lock>
    80000822:	00000097          	auipc	ra,0x0
    80000826:	36a080e7          	jalr	874(ra) # 80000b8c <initlock>
}
    8000082a:	60a2                	ld	ra,8(sp)
    8000082c:	6402                	ld	s0,0(sp)
    8000082e:	0141                	addi	sp,sp,16
    80000830:	8082                	ret

0000000080000832 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000832:	1101                	addi	sp,sp,-32
    80000834:	ec06                	sd	ra,24(sp)
    80000836:	e822                	sd	s0,16(sp)
    80000838:	e426                	sd	s1,8(sp)
    8000083a:	1000                	addi	s0,sp,32
    8000083c:	84aa                	mv	s1,a0
  push_off();
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	392080e7          	jalr	914(ra) # 80000bd0 <push_off>

  if(panicked){
    80000846:	00008797          	auipc	a5,0x8
    8000084a:	17a7a783          	lw	a5,378(a5) # 800089c0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000084e:	10000737          	lui	a4,0x10000
  if(panicked){
    80000852:	c391                	beqz	a5,80000856 <uartputc_sync+0x24>
    for(;;)
    80000854:	a001                	j	80000854 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000856:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000085a:	0207f793          	andi	a5,a5,32
    8000085e:	dfe5                	beqz	a5,80000856 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000860:	0ff4f513          	zext.b	a0,s1
    80000864:	100007b7          	lui	a5,0x10000
    80000868:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	404080e7          	jalr	1028(ra) # 80000c70 <pop_off>
}
    80000874:	60e2                	ld	ra,24(sp)
    80000876:	6442                	ld	s0,16(sp)
    80000878:	64a2                	ld	s1,8(sp)
    8000087a:	6105                	addi	sp,sp,32
    8000087c:	8082                	ret

000000008000087e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000087e:	00008797          	auipc	a5,0x8
    80000882:	14a7b783          	ld	a5,330(a5) # 800089c8 <uart_tx_r>
    80000886:	00008717          	auipc	a4,0x8
    8000088a:	14a73703          	ld	a4,330(a4) # 800089d0 <uart_tx_w>
    8000088e:	06f70a63          	beq	a4,a5,80000902 <uartstart+0x84>
{
    80000892:	7139                	addi	sp,sp,-64
    80000894:	fc06                	sd	ra,56(sp)
    80000896:	f822                	sd	s0,48(sp)
    80000898:	f426                	sd	s1,40(sp)
    8000089a:	f04a                	sd	s2,32(sp)
    8000089c:	ec4e                	sd	s3,24(sp)
    8000089e:	e852                	sd	s4,16(sp)
    800008a0:	e456                	sd	s5,8(sp)
    800008a2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008a4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008a8:	00010a17          	auipc	s4,0x10
    800008ac:	360a0a13          	addi	s4,s4,864 # 80010c08 <uart_tx_lock>
    uart_tx_r += 1;
    800008b0:	00008497          	auipc	s1,0x8
    800008b4:	11848493          	addi	s1,s1,280 # 800089c8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800008b8:	00008997          	auipc	s3,0x8
    800008bc:	11898993          	addi	s3,s3,280 # 800089d0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800008c4:	02077713          	andi	a4,a4,32
    800008c8:	c705                	beqz	a4,800008f0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ca:	01f7f713          	andi	a4,a5,31
    800008ce:	9752                	add	a4,a4,s4
    800008d0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008d4:	0785                	addi	a5,a5,1
    800008d6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008d8:	8526                	mv	a0,s1
    800008da:	00002097          	auipc	ra,0x2
    800008de:	bb6080e7          	jalr	-1098(ra) # 80002490 <wakeup>
    
    WriteReg(THR, c);
    800008e2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008e6:	609c                	ld	a5,0(s1)
    800008e8:	0009b703          	ld	a4,0(s3)
    800008ec:	fcf71ae3          	bne	a4,a5,800008c0 <uartstart+0x42>
  }
}
    800008f0:	70e2                	ld	ra,56(sp)
    800008f2:	7442                	ld	s0,48(sp)
    800008f4:	74a2                	ld	s1,40(sp)
    800008f6:	7902                	ld	s2,32(sp)
    800008f8:	69e2                	ld	s3,24(sp)
    800008fa:	6a42                	ld	s4,16(sp)
    800008fc:	6aa2                	ld	s5,8(sp)
    800008fe:	6121                	addi	sp,sp,64
    80000900:	8082                	ret
    80000902:	8082                	ret

0000000080000904 <uartputc>:
{
    80000904:	7179                	addi	sp,sp,-48
    80000906:	f406                	sd	ra,40(sp)
    80000908:	f022                	sd	s0,32(sp)
    8000090a:	ec26                	sd	s1,24(sp)
    8000090c:	e84a                	sd	s2,16(sp)
    8000090e:	e44e                	sd	s3,8(sp)
    80000910:	e052                	sd	s4,0(sp)
    80000912:	1800                	addi	s0,sp,48
    80000914:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000916:	00010517          	auipc	a0,0x10
    8000091a:	2f250513          	addi	a0,a0,754 # 80010c08 <uart_tx_lock>
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	2fe080e7          	jalr	766(ra) # 80000c1c <acquire>
  if(panicked){
    80000926:	00008797          	auipc	a5,0x8
    8000092a:	09a7a783          	lw	a5,154(a5) # 800089c0 <panicked>
    8000092e:	e7c9                	bnez	a5,800009b8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000930:	00008717          	auipc	a4,0x8
    80000934:	0a073703          	ld	a4,160(a4) # 800089d0 <uart_tx_w>
    80000938:	00008797          	auipc	a5,0x8
    8000093c:	0907b783          	ld	a5,144(a5) # 800089c8 <uart_tx_r>
    80000940:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000944:	00010997          	auipc	s3,0x10
    80000948:	2c498993          	addi	s3,s3,708 # 80010c08 <uart_tx_lock>
    8000094c:	00008497          	auipc	s1,0x8
    80000950:	07c48493          	addi	s1,s1,124 # 800089c8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000954:	00008917          	auipc	s2,0x8
    80000958:	07c90913          	addi	s2,s2,124 # 800089d0 <uart_tx_w>
    8000095c:	00e79f63          	bne	a5,a4,8000097a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000960:	85ce                	mv	a1,s3
    80000962:	8526                	mv	a0,s1
    80000964:	00002097          	auipc	ra,0x2
    80000968:	ac8080e7          	jalr	-1336(ra) # 8000242c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096c:	00093703          	ld	a4,0(s2)
    80000970:	609c                	ld	a5,0(s1)
    80000972:	02078793          	addi	a5,a5,32
    80000976:	fee785e3          	beq	a5,a4,80000960 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000097a:	00010497          	auipc	s1,0x10
    8000097e:	28e48493          	addi	s1,s1,654 # 80010c08 <uart_tx_lock>
    80000982:	01f77793          	andi	a5,a4,31
    80000986:	97a6                	add	a5,a5,s1
    80000988:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000098c:	0705                	addi	a4,a4,1
    8000098e:	00008797          	auipc	a5,0x8
    80000992:	04e7b123          	sd	a4,66(a5) # 800089d0 <uart_tx_w>
  uartstart();
    80000996:	00000097          	auipc	ra,0x0
    8000099a:	ee8080e7          	jalr	-280(ra) # 8000087e <uartstart>
  release(&uart_tx_lock);
    8000099e:	8526                	mv	a0,s1
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	330080e7          	jalr	816(ra) # 80000cd0 <release>
}
    800009a8:	70a2                	ld	ra,40(sp)
    800009aa:	7402                	ld	s0,32(sp)
    800009ac:	64e2                	ld	s1,24(sp)
    800009ae:	6942                	ld	s2,16(sp)
    800009b0:	69a2                	ld	s3,8(sp)
    800009b2:	6a02                	ld	s4,0(sp)
    800009b4:	6145                	addi	sp,sp,48
    800009b6:	8082                	ret
    for(;;)
    800009b8:	a001                	j	800009b8 <uartputc+0xb4>

00000000800009ba <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ba:	1141                	addi	sp,sp,-16
    800009bc:	e422                	sd	s0,8(sp)
    800009be:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009c0:	100007b7          	lui	a5,0x10000
    800009c4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009c8:	8b85                	andi	a5,a5,1
    800009ca:	cb81                	beqz	a5,800009da <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800009cc:	100007b7          	lui	a5,0x10000
    800009d0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009d4:	6422                	ld	s0,8(sp)
    800009d6:	0141                	addi	sp,sp,16
    800009d8:	8082                	ret
    return -1;
    800009da:	557d                	li	a0,-1
    800009dc:	bfe5                	j	800009d4 <uartgetc+0x1a>

00000000800009de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009de:	1101                	addi	sp,sp,-32
    800009e0:	ec06                	sd	ra,24(sp)
    800009e2:	e822                	sd	s0,16(sp)
    800009e4:	e426                	sd	s1,8(sp)
    800009e6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009e8:	54fd                	li	s1,-1
    800009ea:	a029                	j	800009f4 <uartintr+0x16>
      break;
    consoleintr(c);
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	8d2080e7          	jalr	-1838(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	fc6080e7          	jalr	-58(ra) # 800009ba <uartgetc>
    if(c == -1)
    800009fc:	fe9518e3          	bne	a0,s1,800009ec <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a00:	00010497          	auipc	s1,0x10
    80000a04:	20848493          	addi	s1,s1,520 # 80010c08 <uart_tx_lock>
    80000a08:	8526                	mv	a0,s1
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	212080e7          	jalr	530(ra) # 80000c1c <acquire>
  uartstart();
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	e6c080e7          	jalr	-404(ra) # 8000087e <uartstart>
  release(&uart_tx_lock);
    80000a1a:	8526                	mv	a0,s1
    80000a1c:	00000097          	auipc	ra,0x0
    80000a20:	2b4080e7          	jalr	692(ra) # 80000cd0 <release>
}
    80000a24:	60e2                	ld	ra,24(sp)
    80000a26:	6442                	ld	s0,16(sp)
    80000a28:	64a2                	ld	s1,8(sp)
    80000a2a:	6105                	addi	sp,sp,32
    80000a2c:	8082                	ret

0000000080000a2e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a2e:	1101                	addi	sp,sp,-32
    80000a30:	ec06                	sd	ra,24(sp)
    80000a32:	e822                	sd	s0,16(sp)
    80000a34:	e426                	sd	s1,8(sp)
    80000a36:	e04a                	sd	s2,0(sp)
    80000a38:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a3a:	03451793          	slli	a5,a0,0x34
    80000a3e:	ebb9                	bnez	a5,80000a94 <kfree+0x66>
    80000a40:	84aa                	mv	s1,a0
    80000a42:	00021797          	auipc	a5,0x21
    80000a46:	62e78793          	addi	a5,a5,1582 # 80022070 <end>
    80000a4a:	04f56563          	bltu	a0,a5,80000a94 <kfree+0x66>
    80000a4e:	47c5                	li	a5,17
    80000a50:	07ee                	slli	a5,a5,0x1b
    80000a52:	04f57163          	bgeu	a0,a5,80000a94 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	4585                	li	a1,1
    80000a5a:	00000097          	auipc	ra,0x0
    80000a5e:	2be080e7          	jalr	702(ra) # 80000d18 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a62:	00010917          	auipc	s2,0x10
    80000a66:	1de90913          	addi	s2,s2,478 # 80010c40 <kmem>
    80000a6a:	854a                	mv	a0,s2
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	1b0080e7          	jalr	432(ra) # 80000c1c <acquire>
  r->next = kmem.freelist;
    80000a74:	01893783          	ld	a5,24(s2)
    80000a78:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a7a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a7e:	854a                	mv	a0,s2
    80000a80:	00000097          	auipc	ra,0x0
    80000a84:	250080e7          	jalr	592(ra) # 80000cd0 <release>
}
    80000a88:	60e2                	ld	ra,24(sp)
    80000a8a:	6442                	ld	s0,16(sp)
    80000a8c:	64a2                	ld	s1,8(sp)
    80000a8e:	6902                	ld	s2,0(sp)
    80000a90:	6105                	addi	sp,sp,32
    80000a92:	8082                	ret
    panic("kfree");
    80000a94:	00007517          	auipc	a0,0x7
    80000a98:	5cc50513          	addi	a0,a0,1484 # 80008060 <digits+0x20>
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	aea080e7          	jalr	-1302(ra) # 80000586 <panic>

0000000080000aa4 <freerange>:
{
    80000aa4:	7179                	addi	sp,sp,-48
    80000aa6:	f406                	sd	ra,40(sp)
    80000aa8:	f022                	sd	s0,32(sp)
    80000aaa:	ec26                	sd	s1,24(sp)
    80000aac:	e84a                	sd	s2,16(sp)
    80000aae:	e44e                	sd	s3,8(sp)
    80000ab0:	e052                	sd	s4,0(sp)
    80000ab2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab4:	6785                	lui	a5,0x1
    80000ab6:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000aba:	00e504b3          	add	s1,a0,a4
    80000abe:	777d                	lui	a4,0xfffff
    80000ac0:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac2:	94be                	add	s1,s1,a5
    80000ac4:	0095ee63          	bltu	a1,s1,80000ae0 <freerange+0x3c>
    80000ac8:	892e                	mv	s2,a1
    kfree(p);
    80000aca:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000acc:	6985                	lui	s3,0x1
    kfree(p);
    80000ace:	01448533          	add	a0,s1,s4
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	f5c080e7          	jalr	-164(ra) # 80000a2e <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe9979e3          	bgeu	s2,s1,80000ace <freerange+0x2a>
}
    80000ae0:	70a2                	ld	ra,40(sp)
    80000ae2:	7402                	ld	s0,32(sp)
    80000ae4:	64e2                	ld	s1,24(sp)
    80000ae6:	6942                	ld	s2,16(sp)
    80000ae8:	69a2                	ld	s3,8(sp)
    80000aea:	6a02                	ld	s4,0(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00007597          	auipc	a1,0x7
    80000afc:	57058593          	addi	a1,a1,1392 # 80008068 <digits+0x28>
    80000b00:	00010517          	auipc	a0,0x10
    80000b04:	14050513          	addi	a0,a0,320 # 80010c40 <kmem>
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	084080e7          	jalr	132(ra) # 80000b8c <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b10:	45c5                	li	a1,17
    80000b12:	05ee                	slli	a1,a1,0x1b
    80000b14:	00021517          	auipc	a0,0x21
    80000b18:	55c50513          	addi	a0,a0,1372 # 80022070 <end>
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	f88080e7          	jalr	-120(ra) # 80000aa4 <freerange>
}
    80000b24:	60a2                	ld	ra,8(sp)
    80000b26:	6402                	ld	s0,0(sp)
    80000b28:	0141                	addi	sp,sp,16
    80000b2a:	8082                	ret

0000000080000b2c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b2c:	1101                	addi	sp,sp,-32
    80000b2e:	ec06                	sd	ra,24(sp)
    80000b30:	e822                	sd	s0,16(sp)
    80000b32:	e426                	sd	s1,8(sp)
    80000b34:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b36:	00010497          	auipc	s1,0x10
    80000b3a:	10a48493          	addi	s1,s1,266 # 80010c40 <kmem>
    80000b3e:	8526                	mv	a0,s1
    80000b40:	00000097          	auipc	ra,0x0
    80000b44:	0dc080e7          	jalr	220(ra) # 80000c1c <acquire>
  r = kmem.freelist;
    80000b48:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4a:	c885                	beqz	s1,80000b7a <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b4c:	609c                	ld	a5,0(s1)
    80000b4e:	00010517          	auipc	a0,0x10
    80000b52:	0f250513          	addi	a0,a0,242 # 80010c40 <kmem>
    80000b56:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b58:	00000097          	auipc	ra,0x0
    80000b5c:	178080e7          	jalr	376(ra) # 80000cd0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b60:	6605                	lui	a2,0x1
    80000b62:	4595                	li	a1,5
    80000b64:	8526                	mv	a0,s1
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	1b2080e7          	jalr	434(ra) # 80000d18 <memset>
  return (void*)r;
}
    80000b6e:	8526                	mv	a0,s1
    80000b70:	60e2                	ld	ra,24(sp)
    80000b72:	6442                	ld	s0,16(sp)
    80000b74:	64a2                	ld	s1,8(sp)
    80000b76:	6105                	addi	sp,sp,32
    80000b78:	8082                	ret
  release(&kmem.lock);
    80000b7a:	00010517          	auipc	a0,0x10
    80000b7e:	0c650513          	addi	a0,a0,198 # 80010c40 <kmem>
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	14e080e7          	jalr	334(ra) # 80000cd0 <release>
  if(r)
    80000b8a:	b7d5                	j	80000b6e <kalloc+0x42>

0000000080000b8c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b8c:	1141                	addi	sp,sp,-16
    80000b8e:	e422                	sd	s0,8(sp)
    80000b90:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b92:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b94:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b98:	00053823          	sd	zero,16(a0)
}
    80000b9c:	6422                	ld	s0,8(sp)
    80000b9e:	0141                	addi	sp,sp,16
    80000ba0:	8082                	ret

0000000080000ba2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000ba2:	411c                	lw	a5,0(a0)
    80000ba4:	e399                	bnez	a5,80000baa <holding+0x8>
    80000ba6:	4501                	li	a0,0
  return r;
}
    80000ba8:	8082                	ret
{
    80000baa:	1101                	addi	sp,sp,-32
    80000bac:	ec06                	sd	ra,24(sp)
    80000bae:	e822                	sd	s0,16(sp)
    80000bb0:	e426                	sd	s1,8(sp)
    80000bb2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bb4:	6904                	ld	s1,16(a0)
    80000bb6:	00001097          	auipc	ra,0x1
    80000bba:	094080e7          	jalr	148(ra) # 80001c4a <mycpu>
    80000bbe:	40a48533          	sub	a0,s1,a0
    80000bc2:	00153513          	seqz	a0,a0
}
    80000bc6:	60e2                	ld	ra,24(sp)
    80000bc8:	6442                	ld	s0,16(sp)
    80000bca:	64a2                	ld	s1,8(sp)
    80000bcc:	6105                	addi	sp,sp,32
    80000bce:	8082                	ret

0000000080000bd0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bd0:	1101                	addi	sp,sp,-32
    80000bd2:	ec06                	sd	ra,24(sp)
    80000bd4:	e822                	sd	s0,16(sp)
    80000bd6:	e426                	sd	s1,8(sp)
    80000bd8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bda:	100024f3          	csrr	s1,sstatus
    80000bde:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000be2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000be4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000be8:	00001097          	auipc	ra,0x1
    80000bec:	062080e7          	jalr	98(ra) # 80001c4a <mycpu>
    80000bf0:	5d3c                	lw	a5,120(a0)
    80000bf2:	cf89                	beqz	a5,80000c0c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bf4:	00001097          	auipc	ra,0x1
    80000bf8:	056080e7          	jalr	86(ra) # 80001c4a <mycpu>
    80000bfc:	5d3c                	lw	a5,120(a0)
    80000bfe:	2785                	addiw	a5,a5,1
    80000c00:	dd3c                	sw	a5,120(a0)
}
    80000c02:	60e2                	ld	ra,24(sp)
    80000c04:	6442                	ld	s0,16(sp)
    80000c06:	64a2                	ld	s1,8(sp)
    80000c08:	6105                	addi	sp,sp,32
    80000c0a:	8082                	ret
    mycpu()->intena = old;
    80000c0c:	00001097          	auipc	ra,0x1
    80000c10:	03e080e7          	jalr	62(ra) # 80001c4a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c14:	8085                	srli	s1,s1,0x1
    80000c16:	8885                	andi	s1,s1,1
    80000c18:	dd64                	sw	s1,124(a0)
    80000c1a:	bfe9                	j	80000bf4 <push_off+0x24>

0000000080000c1c <acquire>:
{
    80000c1c:	1101                	addi	sp,sp,-32
    80000c1e:	ec06                	sd	ra,24(sp)
    80000c20:	e822                	sd	s0,16(sp)
    80000c22:	e426                	sd	s1,8(sp)
    80000c24:	1000                	addi	s0,sp,32
    80000c26:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c28:	00000097          	auipc	ra,0x0
    80000c2c:	fa8080e7          	jalr	-88(ra) # 80000bd0 <push_off>
  if(holding(lk))
    80000c30:	8526                	mv	a0,s1
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	f70080e7          	jalr	-144(ra) # 80000ba2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3a:	4705                	li	a4,1
  if(holding(lk))
    80000c3c:	e115                	bnez	a0,80000c60 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3e:	87ba                	mv	a5,a4
    80000c40:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c44:	2781                	sext.w	a5,a5
    80000c46:	ffe5                	bnez	a5,80000c3e <acquire+0x22>
  __sync_synchronize();
    80000c48:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c4c:	00001097          	auipc	ra,0x1
    80000c50:	ffe080e7          	jalr	-2(ra) # 80001c4a <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00007517          	auipc	a0,0x7
    80000c64:	41050513          	addi	a0,a0,1040 # 80008070 <digits+0x30>
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	91e080e7          	jalr	-1762(ra) # 80000586 <panic>

0000000080000c70 <pop_off>:

void
pop_off(void)
{
    80000c70:	1141                	addi	sp,sp,-16
    80000c72:	e406                	sd	ra,8(sp)
    80000c74:	e022                	sd	s0,0(sp)
    80000c76:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c78:	00001097          	auipc	ra,0x1
    80000c7c:	fd2080e7          	jalr	-46(ra) # 80001c4a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c80:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c84:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c86:	e78d                	bnez	a5,80000cb0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c88:	5d3c                	lw	a5,120(a0)
    80000c8a:	02f05b63          	blez	a5,80000cc0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c8e:	37fd                	addiw	a5,a5,-1
    80000c90:	0007871b          	sext.w	a4,a5
    80000c94:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c96:	eb09                	bnez	a4,80000ca8 <pop_off+0x38>
    80000c98:	5d7c                	lw	a5,124(a0)
    80000c9a:	c799                	beqz	a5,80000ca8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000ca0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ca4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000ca8:	60a2                	ld	ra,8(sp)
    80000caa:	6402                	ld	s0,0(sp)
    80000cac:	0141                	addi	sp,sp,16
    80000cae:	8082                	ret
    panic("pop_off - interruptible");
    80000cb0:	00007517          	auipc	a0,0x7
    80000cb4:	3c850513          	addi	a0,a0,968 # 80008078 <digits+0x38>
    80000cb8:	00000097          	auipc	ra,0x0
    80000cbc:	8ce080e7          	jalr	-1842(ra) # 80000586 <panic>
    panic("pop_off");
    80000cc0:	00007517          	auipc	a0,0x7
    80000cc4:	3d050513          	addi	a0,a0,976 # 80008090 <digits+0x50>
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	8be080e7          	jalr	-1858(ra) # 80000586 <panic>

0000000080000cd0 <release>:
{
    80000cd0:	1101                	addi	sp,sp,-32
    80000cd2:	ec06                	sd	ra,24(sp)
    80000cd4:	e822                	sd	s0,16(sp)
    80000cd6:	e426                	sd	s1,8(sp)
    80000cd8:	1000                	addi	s0,sp,32
    80000cda:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cdc:	00000097          	auipc	ra,0x0
    80000ce0:	ec6080e7          	jalr	-314(ra) # 80000ba2 <holding>
    80000ce4:	c115                	beqz	a0,80000d08 <release+0x38>
  lk->cpu = 0;
    80000ce6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cea:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cee:	0f50000f          	fence	iorw,ow
    80000cf2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cf6:	00000097          	auipc	ra,0x0
    80000cfa:	f7a080e7          	jalr	-134(ra) # 80000c70 <pop_off>
}
    80000cfe:	60e2                	ld	ra,24(sp)
    80000d00:	6442                	ld	s0,16(sp)
    80000d02:	64a2                	ld	s1,8(sp)
    80000d04:	6105                	addi	sp,sp,32
    80000d06:	8082                	ret
    panic("release");
    80000d08:	00007517          	auipc	a0,0x7
    80000d0c:	39050513          	addi	a0,a0,912 # 80008098 <digits+0x58>
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	876080e7          	jalr	-1930(ra) # 80000586 <panic>

0000000080000d18 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d18:	1141                	addi	sp,sp,-16
    80000d1a:	e422                	sd	s0,8(sp)
    80000d1c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d1e:	ca19                	beqz	a2,80000d34 <memset+0x1c>
    80000d20:	87aa                	mv	a5,a0
    80000d22:	1602                	slli	a2,a2,0x20
    80000d24:	9201                	srli	a2,a2,0x20
    80000d26:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d2a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d2e:	0785                	addi	a5,a5,1
    80000d30:	fee79de3          	bne	a5,a4,80000d2a <memset+0x12>
  }
  return dst;
}
    80000d34:	6422                	ld	s0,8(sp)
    80000d36:	0141                	addi	sp,sp,16
    80000d38:	8082                	ret

0000000080000d3a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d40:	ca05                	beqz	a2,80000d70 <memcmp+0x36>
    80000d42:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d46:	1682                	slli	a3,a3,0x20
    80000d48:	9281                	srli	a3,a3,0x20
    80000d4a:	0685                	addi	a3,a3,1
    80000d4c:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d4e:	00054783          	lbu	a5,0(a0)
    80000d52:	0005c703          	lbu	a4,0(a1)
    80000d56:	00e79863          	bne	a5,a4,80000d66 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d5a:	0505                	addi	a0,a0,1
    80000d5c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d5e:	fed518e3          	bne	a0,a3,80000d4e <memcmp+0x14>
  }

  return 0;
    80000d62:	4501                	li	a0,0
    80000d64:	a019                	j	80000d6a <memcmp+0x30>
      return *s1 - *s2;
    80000d66:	40e7853b          	subw	a0,a5,a4
}
    80000d6a:	6422                	ld	s0,8(sp)
    80000d6c:	0141                	addi	sp,sp,16
    80000d6e:	8082                	ret
  return 0;
    80000d70:	4501                	li	a0,0
    80000d72:	bfe5                	j	80000d6a <memcmp+0x30>

0000000080000d74 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d74:	1141                	addi	sp,sp,-16
    80000d76:	e422                	sd	s0,8(sp)
    80000d78:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d7a:	c205                	beqz	a2,80000d9a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d7c:	02a5e263          	bltu	a1,a0,80000da0 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d80:	1602                	slli	a2,a2,0x20
    80000d82:	9201                	srli	a2,a2,0x20
    80000d84:	00c587b3          	add	a5,a1,a2
{
    80000d88:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d8a:	0585                	addi	a1,a1,1
    80000d8c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdcf91>
    80000d8e:	fff5c683          	lbu	a3,-1(a1)
    80000d92:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d96:	fef59ae3          	bne	a1,a5,80000d8a <memmove+0x16>

  return dst;
}
    80000d9a:	6422                	ld	s0,8(sp)
    80000d9c:	0141                	addi	sp,sp,16
    80000d9e:	8082                	ret
  if(s < d && s + n > d){
    80000da0:	02061693          	slli	a3,a2,0x20
    80000da4:	9281                	srli	a3,a3,0x20
    80000da6:	00d58733          	add	a4,a1,a3
    80000daa:	fce57be3          	bgeu	a0,a4,80000d80 <memmove+0xc>
    d += n;
    80000dae:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000db0:	fff6079b          	addiw	a5,a2,-1
    80000db4:	1782                	slli	a5,a5,0x20
    80000db6:	9381                	srli	a5,a5,0x20
    80000db8:	fff7c793          	not	a5,a5
    80000dbc:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dbe:	177d                	addi	a4,a4,-1
    80000dc0:	16fd                	addi	a3,a3,-1
    80000dc2:	00074603          	lbu	a2,0(a4)
    80000dc6:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000dca:	fee79ae3          	bne	a5,a4,80000dbe <memmove+0x4a>
    80000dce:	b7f1                	j	80000d9a <memmove+0x26>

0000000080000dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dd0:	1141                	addi	sp,sp,-16
    80000dd2:	e406                	sd	ra,8(sp)
    80000dd4:	e022                	sd	s0,0(sp)
    80000dd6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dd8:	00000097          	auipc	ra,0x0
    80000ddc:	f9c080e7          	jalr	-100(ra) # 80000d74 <memmove>
}
    80000de0:	60a2                	ld	ra,8(sp)
    80000de2:	6402                	ld	s0,0(sp)
    80000de4:	0141                	addi	sp,sp,16
    80000de6:	8082                	ret

0000000080000de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000de8:	1141                	addi	sp,sp,-16
    80000dea:	e422                	sd	s0,8(sp)
    80000dec:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dee:	ce11                	beqz	a2,80000e0a <strncmp+0x22>
    80000df0:	00054783          	lbu	a5,0(a0)
    80000df4:	cf89                	beqz	a5,80000e0e <strncmp+0x26>
    80000df6:	0005c703          	lbu	a4,0(a1)
    80000dfa:	00f71a63          	bne	a4,a5,80000e0e <strncmp+0x26>
    n--, p++, q++;
    80000dfe:	367d                	addiw	a2,a2,-1
    80000e00:	0505                	addi	a0,a0,1
    80000e02:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e04:	f675                	bnez	a2,80000df0 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e06:	4501                	li	a0,0
    80000e08:	a809                	j	80000e1a <strncmp+0x32>
    80000e0a:	4501                	li	a0,0
    80000e0c:	a039                	j	80000e1a <strncmp+0x32>
  if(n == 0)
    80000e0e:	ca09                	beqz	a2,80000e20 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e10:	00054503          	lbu	a0,0(a0)
    80000e14:	0005c783          	lbu	a5,0(a1)
    80000e18:	9d1d                	subw	a0,a0,a5
}
    80000e1a:	6422                	ld	s0,8(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret
    return 0;
    80000e20:	4501                	li	a0,0
    80000e22:	bfe5                	j	80000e1a <strncmp+0x32>

0000000080000e24 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e24:	1141                	addi	sp,sp,-16
    80000e26:	e422                	sd	s0,8(sp)
    80000e28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e2a:	872a                	mv	a4,a0
    80000e2c:	8832                	mv	a6,a2
    80000e2e:	367d                	addiw	a2,a2,-1
    80000e30:	01005963          	blez	a6,80000e42 <strncpy+0x1e>
    80000e34:	0705                	addi	a4,a4,1
    80000e36:	0005c783          	lbu	a5,0(a1)
    80000e3a:	fef70fa3          	sb	a5,-1(a4)
    80000e3e:	0585                	addi	a1,a1,1
    80000e40:	f7f5                	bnez	a5,80000e2c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e42:	86ba                	mv	a3,a4
    80000e44:	00c05c63          	blez	a2,80000e5c <strncpy+0x38>
    *s++ = 0;
    80000e48:	0685                	addi	a3,a3,1
    80000e4a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e4e:	40d707bb          	subw	a5,a4,a3
    80000e52:	37fd                	addiw	a5,a5,-1
    80000e54:	010787bb          	addw	a5,a5,a6
    80000e58:	fef048e3          	bgtz	a5,80000e48 <strncpy+0x24>
  return os;
}
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	addi	sp,sp,16
    80000e60:	8082                	ret

0000000080000e62 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e68:	02c05363          	blez	a2,80000e8e <safestrcpy+0x2c>
    80000e6c:	fff6069b          	addiw	a3,a2,-1
    80000e70:	1682                	slli	a3,a3,0x20
    80000e72:	9281                	srli	a3,a3,0x20
    80000e74:	96ae                	add	a3,a3,a1
    80000e76:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e78:	00d58963          	beq	a1,a3,80000e8a <safestrcpy+0x28>
    80000e7c:	0585                	addi	a1,a1,1
    80000e7e:	0785                	addi	a5,a5,1
    80000e80:	fff5c703          	lbu	a4,-1(a1)
    80000e84:	fee78fa3          	sb	a4,-1(a5)
    80000e88:	fb65                	bnez	a4,80000e78 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e8a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret

0000000080000e94 <strlen>:

int
strlen(const char *s)
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e422                	sd	s0,8(sp)
    80000e98:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e9a:	00054783          	lbu	a5,0(a0)
    80000e9e:	cf91                	beqz	a5,80000eba <strlen+0x26>
    80000ea0:	0505                	addi	a0,a0,1
    80000ea2:	87aa                	mv	a5,a0
    80000ea4:	4685                	li	a3,1
    80000ea6:	9e89                	subw	a3,a3,a0
    80000ea8:	00f6853b          	addw	a0,a3,a5
    80000eac:	0785                	addi	a5,a5,1
    80000eae:	fff7c703          	lbu	a4,-1(a5)
    80000eb2:	fb7d                	bnez	a4,80000ea8 <strlen+0x14>
    ;
  return n;
}
    80000eb4:	6422                	ld	s0,8(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eba:	4501                	li	a0,0
    80000ebc:	bfe5                	j	80000eb4 <strlen+0x20>

0000000080000ebe <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ebe:	1141                	addi	sp,sp,-16
    80000ec0:	e406                	sd	ra,8(sp)
    80000ec2:	e022                	sd	s0,0(sp)
    80000ec4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ec6:	00001097          	auipc	ra,0x1
    80000eca:	d74080e7          	jalr	-652(ra) # 80001c3a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ece:	00008717          	auipc	a4,0x8
    80000ed2:	b0a70713          	addi	a4,a4,-1270 # 800089d8 <started>
  if(cpuid() == 0){
    80000ed6:	c139                	beqz	a0,80000f1c <main+0x5e>
    while(started == 0)
    80000ed8:	431c                	lw	a5,0(a4)
    80000eda:	2781                	sext.w	a5,a5
    80000edc:	dff5                	beqz	a5,80000ed8 <main+0x1a>
      ;
    __sync_synchronize();
    80000ede:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ee2:	00001097          	auipc	ra,0x1
    80000ee6:	d58080e7          	jalr	-680(ra) # 80001c3a <cpuid>
    80000eea:	85aa                	mv	a1,a0
    80000eec:	00007517          	auipc	a0,0x7
    80000ef0:	1cc50513          	addi	a0,a0,460 # 800080b8 <digits+0x78>
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	6dc080e7          	jalr	1756(ra) # 800005d0 <printf>
    kvminithart();    // turn on paging
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	0d8080e7          	jalr	216(ra) # 80000fd4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f04:	00002097          	auipc	ra,0x2
    80000f08:	c4c080e7          	jalr	-948(ra) # 80002b50 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	274080e7          	jalr	628(ra) # 80006180 <plicinithart>
  }

  scheduler();        
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	3a0080e7          	jalr	928(ra) # 800022b4 <scheduler>
    consoleinit();
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	57a080e7          	jalr	1402(ra) # 80000496 <consoleinit>
    printfinit();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	88c080e7          	jalr	-1908(ra) # 800007b0 <printfinit>
    printf("\n");
    80000f2c:	00007517          	auipc	a0,0x7
    80000f30:	19c50513          	addi	a0,a0,412 # 800080c8 <digits+0x88>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	69c080e7          	jalr	1692(ra) # 800005d0 <printf>
    printf("xv6 kernel is booting\n");
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	16450513          	addi	a0,a0,356 # 800080a0 <digits+0x60>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	68c080e7          	jalr	1676(ra) # 800005d0 <printf>
    printf("\n");
    80000f4c:	00007517          	auipc	a0,0x7
    80000f50:	17c50513          	addi	a0,a0,380 # 800080c8 <digits+0x88>
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	67c080e7          	jalr	1660(ra) # 800005d0 <printf>
    kinit();         // physical page allocator
    80000f5c:	00000097          	auipc	ra,0x0
    80000f60:	b94080e7          	jalr	-1132(ra) # 80000af0 <kinit>
    kvminit();       // create kernel page table
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	326080e7          	jalr	806(ra) # 8000128a <kvminit>
    kvminithart();   // turn on paging
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	068080e7          	jalr	104(ra) # 80000fd4 <kvminithart>
    procinit();      // process table
    80000f74:	00001097          	auipc	ra,0x1
    80000f78:	be4080e7          	jalr	-1052(ra) # 80001b58 <procinit>
    trapinit();      // trap vectors
    80000f7c:	00002097          	auipc	ra,0x2
    80000f80:	bac080e7          	jalr	-1108(ra) # 80002b28 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f84:	00002097          	auipc	ra,0x2
    80000f88:	bcc080e7          	jalr	-1076(ra) # 80002b50 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f8c:	00005097          	auipc	ra,0x5
    80000f90:	1de080e7          	jalr	478(ra) # 8000616a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f94:	00005097          	auipc	ra,0x5
    80000f98:	1ec080e7          	jalr	492(ra) # 80006180 <plicinithart>
    binit();         // buffer cache
    80000f9c:	00002097          	auipc	ra,0x2
    80000fa0:	382080e7          	jalr	898(ra) # 8000331e <binit>
    iinit();         // inode table
    80000fa4:	00003097          	auipc	ra,0x3
    80000fa8:	a22080e7          	jalr	-1502(ra) # 800039c6 <iinit>
    fileinit();      // file table
    80000fac:	00004097          	auipc	ra,0x4
    80000fb0:	9c8080e7          	jalr	-1592(ra) # 80004974 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fb4:	00005097          	auipc	ra,0x5
    80000fb8:	2d4080e7          	jalr	724(ra) # 80006288 <virtio_disk_init>
    userinit();      // first user process
    80000fbc:	00001097          	auipc	ra,0x1
    80000fc0:	f8a080e7          	jalr	-118(ra) # 80001f46 <userinit>
    __sync_synchronize();
    80000fc4:	0ff0000f          	fence
    started = 1;
    80000fc8:	4785                	li	a5,1
    80000fca:	00008717          	auipc	a4,0x8
    80000fce:	a0f72723          	sw	a5,-1522(a4) # 800089d8 <started>
    80000fd2:	b789                	j	80000f14 <main+0x56>

0000000080000fd4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fd4:	1141                	addi	sp,sp,-16
    80000fd6:	e422                	sd	s0,8(sp)
    80000fd8:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fda:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000fde:	00008797          	auipc	a5,0x8
    80000fe2:	a027b783          	ld	a5,-1534(a5) # 800089e0 <kernel_pagetable>
    80000fe6:	83b1                	srli	a5,a5,0xc
    80000fe8:	577d                	li	a4,-1
    80000fea:	177e                	slli	a4,a4,0x3f
    80000fec:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fee:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ff2:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ff6:	6422                	ld	s0,8(sp)
    80000ff8:	0141                	addi	sp,sp,16
    80000ffa:	8082                	ret

0000000080000ffc <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000ffc:	7139                	addi	sp,sp,-64
    80000ffe:	fc06                	sd	ra,56(sp)
    80001000:	f822                	sd	s0,48(sp)
    80001002:	f426                	sd	s1,40(sp)
    80001004:	f04a                	sd	s2,32(sp)
    80001006:	ec4e                	sd	s3,24(sp)
    80001008:	e852                	sd	s4,16(sp)
    8000100a:	e456                	sd	s5,8(sp)
    8000100c:	e05a                	sd	s6,0(sp)
    8000100e:	0080                	addi	s0,sp,64
    80001010:	84aa                	mv	s1,a0
    80001012:	89ae                	mv	s3,a1
    80001014:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001016:	57fd                	li	a5,-1
    80001018:	83e9                	srli	a5,a5,0x1a
    8000101a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000101c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000101e:	04b7f263          	bgeu	a5,a1,80001062 <walk+0x66>
    panic("walk");
    80001022:	00007517          	auipc	a0,0x7
    80001026:	0ae50513          	addi	a0,a0,174 # 800080d0 <digits+0x90>
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	55c080e7          	jalr	1372(ra) # 80000586 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001032:	060a8663          	beqz	s5,8000109e <walk+0xa2>
    80001036:	00000097          	auipc	ra,0x0
    8000103a:	af6080e7          	jalr	-1290(ra) # 80000b2c <kalloc>
    8000103e:	84aa                	mv	s1,a0
    80001040:	c529                	beqz	a0,8000108a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001042:	6605                	lui	a2,0x1
    80001044:	4581                	li	a1,0
    80001046:	00000097          	auipc	ra,0x0
    8000104a:	cd2080e7          	jalr	-814(ra) # 80000d18 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000104e:	00c4d793          	srli	a5,s1,0xc
    80001052:	07aa                	slli	a5,a5,0xa
    80001054:	0017e793          	ori	a5,a5,1
    80001058:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000105c:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcf87>
    8000105e:	036a0063          	beq	s4,s6,8000107e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001062:	0149d933          	srl	s2,s3,s4
    80001066:	1ff97913          	andi	s2,s2,511
    8000106a:	090e                	slli	s2,s2,0x3
    8000106c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000106e:	00093483          	ld	s1,0(s2)
    80001072:	0014f793          	andi	a5,s1,1
    80001076:	dfd5                	beqz	a5,80001032 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001078:	80a9                	srli	s1,s1,0xa
    8000107a:	04b2                	slli	s1,s1,0xc
    8000107c:	b7c5                	j	8000105c <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000107e:	00c9d513          	srli	a0,s3,0xc
    80001082:	1ff57513          	andi	a0,a0,511
    80001086:	050e                	slli	a0,a0,0x3
    80001088:	9526                	add	a0,a0,s1
}
    8000108a:	70e2                	ld	ra,56(sp)
    8000108c:	7442                	ld	s0,48(sp)
    8000108e:	74a2                	ld	s1,40(sp)
    80001090:	7902                	ld	s2,32(sp)
    80001092:	69e2                	ld	s3,24(sp)
    80001094:	6a42                	ld	s4,16(sp)
    80001096:	6aa2                	ld	s5,8(sp)
    80001098:	6b02                	ld	s6,0(sp)
    8000109a:	6121                	addi	sp,sp,64
    8000109c:	8082                	ret
        return 0;
    8000109e:	4501                	li	a0,0
    800010a0:	b7ed                	j	8000108a <walk+0x8e>

00000000800010a2 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010a2:	57fd                	li	a5,-1
    800010a4:	83e9                	srli	a5,a5,0x1a
    800010a6:	00b7f463          	bgeu	a5,a1,800010ae <walkaddr+0xc>
    return 0;
    800010aa:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010ac:	8082                	ret
{
    800010ae:	1141                	addi	sp,sp,-16
    800010b0:	e406                	sd	ra,8(sp)
    800010b2:	e022                	sd	s0,0(sp)
    800010b4:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010b6:	4601                	li	a2,0
    800010b8:	00000097          	auipc	ra,0x0
    800010bc:	f44080e7          	jalr	-188(ra) # 80000ffc <walk>
  if(pte == 0)
    800010c0:	c105                	beqz	a0,800010e0 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010c2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010c4:	0117f693          	andi	a3,a5,17
    800010c8:	4745                	li	a4,17
    return 0;
    800010ca:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010cc:	00e68663          	beq	a3,a4,800010d8 <walkaddr+0x36>
}
    800010d0:	60a2                	ld	ra,8(sp)
    800010d2:	6402                	ld	s0,0(sp)
    800010d4:	0141                	addi	sp,sp,16
    800010d6:	8082                	ret
  pa = PTE2PA(*pte);
    800010d8:	83a9                	srli	a5,a5,0xa
    800010da:	00c79513          	slli	a0,a5,0xc
  return pa;
    800010de:	bfcd                	j	800010d0 <walkaddr+0x2e>
    return 0;
    800010e0:	4501                	li	a0,0
    800010e2:	b7fd                	j	800010d0 <walkaddr+0x2e>

00000000800010e4 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010e4:	715d                	addi	sp,sp,-80
    800010e6:	e486                	sd	ra,72(sp)
    800010e8:	e0a2                	sd	s0,64(sp)
    800010ea:	fc26                	sd	s1,56(sp)
    800010ec:	f84a                	sd	s2,48(sp)
    800010ee:	f44e                	sd	s3,40(sp)
    800010f0:	f052                	sd	s4,32(sp)
    800010f2:	ec56                	sd	s5,24(sp)
    800010f4:	e85a                	sd	s6,16(sp)
    800010f6:	e45e                	sd	s7,8(sp)
    800010f8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010fa:	c639                	beqz	a2,80001148 <mappages+0x64>
    800010fc:	8aaa                	mv	s5,a0
    800010fe:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001100:	777d                	lui	a4,0xfffff
    80001102:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001106:	fff58993          	addi	s3,a1,-1
    8000110a:	99b2                	add	s3,s3,a2
    8000110c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001110:	893e                	mv	s2,a5
    80001112:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001116:	6b85                	lui	s7,0x1
    80001118:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000111c:	4605                	li	a2,1
    8000111e:	85ca                	mv	a1,s2
    80001120:	8556                	mv	a0,s5
    80001122:	00000097          	auipc	ra,0x0
    80001126:	eda080e7          	jalr	-294(ra) # 80000ffc <walk>
    8000112a:	cd1d                	beqz	a0,80001168 <mappages+0x84>
    if(*pte & PTE_V)
    8000112c:	611c                	ld	a5,0(a0)
    8000112e:	8b85                	andi	a5,a5,1
    80001130:	e785                	bnez	a5,80001158 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001132:	80b1                	srli	s1,s1,0xc
    80001134:	04aa                	slli	s1,s1,0xa
    80001136:	0164e4b3          	or	s1,s1,s6
    8000113a:	0014e493          	ori	s1,s1,1
    8000113e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001140:	05390063          	beq	s2,s3,80001180 <mappages+0x9c>
    a += PGSIZE;
    80001144:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001146:	bfc9                	j	80001118 <mappages+0x34>
    panic("mappages: size");
    80001148:	00007517          	auipc	a0,0x7
    8000114c:	f9050513          	addi	a0,a0,-112 # 800080d8 <digits+0x98>
    80001150:	fffff097          	auipc	ra,0xfffff
    80001154:	436080e7          	jalr	1078(ra) # 80000586 <panic>
      panic("mappages: remap");
    80001158:	00007517          	auipc	a0,0x7
    8000115c:	f9050513          	addi	a0,a0,-112 # 800080e8 <digits+0xa8>
    80001160:	fffff097          	auipc	ra,0xfffff
    80001164:	426080e7          	jalr	1062(ra) # 80000586 <panic>
      return -1;
    80001168:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000116a:	60a6                	ld	ra,72(sp)
    8000116c:	6406                	ld	s0,64(sp)
    8000116e:	74e2                	ld	s1,56(sp)
    80001170:	7942                	ld	s2,48(sp)
    80001172:	79a2                	ld	s3,40(sp)
    80001174:	7a02                	ld	s4,32(sp)
    80001176:	6ae2                	ld	s5,24(sp)
    80001178:	6b42                	ld	s6,16(sp)
    8000117a:	6ba2                	ld	s7,8(sp)
    8000117c:	6161                	addi	sp,sp,80
    8000117e:	8082                	ret
  return 0;
    80001180:	4501                	li	a0,0
    80001182:	b7e5                	j	8000116a <mappages+0x86>

0000000080001184 <kvmmap>:
{
    80001184:	1141                	addi	sp,sp,-16
    80001186:	e406                	sd	ra,8(sp)
    80001188:	e022                	sd	s0,0(sp)
    8000118a:	0800                	addi	s0,sp,16
    8000118c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000118e:	86b2                	mv	a3,a2
    80001190:	863e                	mv	a2,a5
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f52080e7          	jalr	-174(ra) # 800010e4 <mappages>
    8000119a:	e509                	bnez	a0,800011a4 <kvmmap+0x20>
}
    8000119c:	60a2                	ld	ra,8(sp)
    8000119e:	6402                	ld	s0,0(sp)
    800011a0:	0141                	addi	sp,sp,16
    800011a2:	8082                	ret
    panic("kvmmap");
    800011a4:	00007517          	auipc	a0,0x7
    800011a8:	f5450513          	addi	a0,a0,-172 # 800080f8 <digits+0xb8>
    800011ac:	fffff097          	auipc	ra,0xfffff
    800011b0:	3da080e7          	jalr	986(ra) # 80000586 <panic>

00000000800011b4 <kvmmake>:
{
    800011b4:	1101                	addi	sp,sp,-32
    800011b6:	ec06                	sd	ra,24(sp)
    800011b8:	e822                	sd	s0,16(sp)
    800011ba:	e426                	sd	s1,8(sp)
    800011bc:	e04a                	sd	s2,0(sp)
    800011be:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	96c080e7          	jalr	-1684(ra) # 80000b2c <kalloc>
    800011c8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011ca:	6605                	lui	a2,0x1
    800011cc:	4581                	li	a1,0
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	b4a080e7          	jalr	-1206(ra) # 80000d18 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011d6:	4719                	li	a4,6
    800011d8:	6685                	lui	a3,0x1
    800011da:	10000637          	lui	a2,0x10000
    800011de:	100005b7          	lui	a1,0x10000
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	fa0080e7          	jalr	-96(ra) # 80001184 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011ec:	4719                	li	a4,6
    800011ee:	6685                	lui	a3,0x1
    800011f0:	10001637          	lui	a2,0x10001
    800011f4:	100015b7          	lui	a1,0x10001
    800011f8:	8526                	mv	a0,s1
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	f8a080e7          	jalr	-118(ra) # 80001184 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001202:	4719                	li	a4,6
    80001204:	004006b7          	lui	a3,0x400
    80001208:	0c000637          	lui	a2,0xc000
    8000120c:	0c0005b7          	lui	a1,0xc000
    80001210:	8526                	mv	a0,s1
    80001212:	00000097          	auipc	ra,0x0
    80001216:	f72080e7          	jalr	-142(ra) # 80001184 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000121a:	00007917          	auipc	s2,0x7
    8000121e:	de690913          	addi	s2,s2,-538 # 80008000 <etext>
    80001222:	4729                	li	a4,10
    80001224:	80007697          	auipc	a3,0x80007
    80001228:	ddc68693          	addi	a3,a3,-548 # 8000 <_entry-0x7fff8000>
    8000122c:	4605                	li	a2,1
    8000122e:	067e                	slli	a2,a2,0x1f
    80001230:	85b2                	mv	a1,a2
    80001232:	8526                	mv	a0,s1
    80001234:	00000097          	auipc	ra,0x0
    80001238:	f50080e7          	jalr	-176(ra) # 80001184 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000123c:	4719                	li	a4,6
    8000123e:	46c5                	li	a3,17
    80001240:	06ee                	slli	a3,a3,0x1b
    80001242:	412686b3          	sub	a3,a3,s2
    80001246:	864a                	mv	a2,s2
    80001248:	85ca                	mv	a1,s2
    8000124a:	8526                	mv	a0,s1
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f38080e7          	jalr	-200(ra) # 80001184 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001254:	4729                	li	a4,10
    80001256:	6685                	lui	a3,0x1
    80001258:	00006617          	auipc	a2,0x6
    8000125c:	da860613          	addi	a2,a2,-600 # 80007000 <_trampoline>
    80001260:	040005b7          	lui	a1,0x4000
    80001264:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001266:	05b2                	slli	a1,a1,0xc
    80001268:	8526                	mv	a0,s1
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	f1a080e7          	jalr	-230(ra) # 80001184 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001272:	8526                	mv	a0,s1
    80001274:	00001097          	auipc	ra,0x1
    80001278:	84e080e7          	jalr	-1970(ra) # 80001ac2 <proc_mapstacks>
}
    8000127c:	8526                	mv	a0,s1
    8000127e:	60e2                	ld	ra,24(sp)
    80001280:	6442                	ld	s0,16(sp)
    80001282:	64a2                	ld	s1,8(sp)
    80001284:	6902                	ld	s2,0(sp)
    80001286:	6105                	addi	sp,sp,32
    80001288:	8082                	ret

000000008000128a <kvminit>:
{
    8000128a:	1141                	addi	sp,sp,-16
    8000128c:	e406                	sd	ra,8(sp)
    8000128e:	e022                	sd	s0,0(sp)
    80001290:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001292:	00000097          	auipc	ra,0x0
    80001296:	f22080e7          	jalr	-222(ra) # 800011b4 <kvmmake>
    8000129a:	00007797          	auipc	a5,0x7
    8000129e:	74a7b323          	sd	a0,1862(a5) # 800089e0 <kernel_pagetable>
}
    800012a2:	60a2                	ld	ra,8(sp)
    800012a4:	6402                	ld	s0,0(sp)
    800012a6:	0141                	addi	sp,sp,16
    800012a8:	8082                	ret

00000000800012aa <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012aa:	715d                	addi	sp,sp,-80
    800012ac:	e486                	sd	ra,72(sp)
    800012ae:	e0a2                	sd	s0,64(sp)
    800012b0:	fc26                	sd	s1,56(sp)
    800012b2:	f84a                	sd	s2,48(sp)
    800012b4:	f44e                	sd	s3,40(sp)
    800012b6:	f052                	sd	s4,32(sp)
    800012b8:	ec56                	sd	s5,24(sp)
    800012ba:	e85a                	sd	s6,16(sp)
    800012bc:	e45e                	sd	s7,8(sp)
    800012be:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012c0:	03459793          	slli	a5,a1,0x34
    800012c4:	e795                	bnez	a5,800012f0 <uvmunmap+0x46>
    800012c6:	8a2a                	mv	s4,a0
    800012c8:	892e                	mv	s2,a1
    800012ca:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012cc:	0632                	slli	a2,a2,0xc
    800012ce:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012d2:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012d4:	6b05                	lui	s6,0x1
    800012d6:	0735e263          	bltu	a1,s3,8000133a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012da:	60a6                	ld	ra,72(sp)
    800012dc:	6406                	ld	s0,64(sp)
    800012de:	74e2                	ld	s1,56(sp)
    800012e0:	7942                	ld	s2,48(sp)
    800012e2:	79a2                	ld	s3,40(sp)
    800012e4:	7a02                	ld	s4,32(sp)
    800012e6:	6ae2                	ld	s5,24(sp)
    800012e8:	6b42                	ld	s6,16(sp)
    800012ea:	6ba2                	ld	s7,8(sp)
    800012ec:	6161                	addi	sp,sp,80
    800012ee:	8082                	ret
    panic("uvmunmap: not aligned");
    800012f0:	00007517          	auipc	a0,0x7
    800012f4:	e1050513          	addi	a0,a0,-496 # 80008100 <digits+0xc0>
    800012f8:	fffff097          	auipc	ra,0xfffff
    800012fc:	28e080e7          	jalr	654(ra) # 80000586 <panic>
      panic("uvmunmap: walk");
    80001300:	00007517          	auipc	a0,0x7
    80001304:	e1850513          	addi	a0,a0,-488 # 80008118 <digits+0xd8>
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	27e080e7          	jalr	638(ra) # 80000586 <panic>
      panic("uvmunmap: not mapped");
    80001310:	00007517          	auipc	a0,0x7
    80001314:	e1850513          	addi	a0,a0,-488 # 80008128 <digits+0xe8>
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	26e080e7          	jalr	622(ra) # 80000586 <panic>
      panic("uvmunmap: not a leaf");
    80001320:	00007517          	auipc	a0,0x7
    80001324:	e2050513          	addi	a0,a0,-480 # 80008140 <digits+0x100>
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	25e080e7          	jalr	606(ra) # 80000586 <panic>
    *pte = 0;
    80001330:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001334:	995a                	add	s2,s2,s6
    80001336:	fb3972e3          	bgeu	s2,s3,800012da <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000133a:	4601                	li	a2,0
    8000133c:	85ca                	mv	a1,s2
    8000133e:	8552                	mv	a0,s4
    80001340:	00000097          	auipc	ra,0x0
    80001344:	cbc080e7          	jalr	-836(ra) # 80000ffc <walk>
    80001348:	84aa                	mv	s1,a0
    8000134a:	d95d                	beqz	a0,80001300 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000134c:	6108                	ld	a0,0(a0)
    8000134e:	00157793          	andi	a5,a0,1
    80001352:	dfdd                	beqz	a5,80001310 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001354:	3ff57793          	andi	a5,a0,1023
    80001358:	fd7784e3          	beq	a5,s7,80001320 <uvmunmap+0x76>
    if(do_free){
    8000135c:	fc0a8ae3          	beqz	s5,80001330 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001360:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001362:	0532                	slli	a0,a0,0xc
    80001364:	fffff097          	auipc	ra,0xfffff
    80001368:	6ca080e7          	jalr	1738(ra) # 80000a2e <kfree>
    8000136c:	b7d1                	j	80001330 <uvmunmap+0x86>

000000008000136e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000136e:	1101                	addi	sp,sp,-32
    80001370:	ec06                	sd	ra,24(sp)
    80001372:	e822                	sd	s0,16(sp)
    80001374:	e426                	sd	s1,8(sp)
    80001376:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	7b4080e7          	jalr	1972(ra) # 80000b2c <kalloc>
    80001380:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001382:	c519                	beqz	a0,80001390 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001384:	6605                	lui	a2,0x1
    80001386:	4581                	li	a1,0
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	990080e7          	jalr	-1648(ra) # 80000d18 <memset>
  return pagetable;
}
    80001390:	8526                	mv	a0,s1
    80001392:	60e2                	ld	ra,24(sp)
    80001394:	6442                	ld	s0,16(sp)
    80001396:	64a2                	ld	s1,8(sp)
    80001398:	6105                	addi	sp,sp,32
    8000139a:	8082                	ret

000000008000139c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000139c:	7179                	addi	sp,sp,-48
    8000139e:	f406                	sd	ra,40(sp)
    800013a0:	f022                	sd	s0,32(sp)
    800013a2:	ec26                	sd	s1,24(sp)
    800013a4:	e84a                	sd	s2,16(sp)
    800013a6:	e44e                	sd	s3,8(sp)
    800013a8:	e052                	sd	s4,0(sp)
    800013aa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013ac:	6785                	lui	a5,0x1
    800013ae:	04f67863          	bgeu	a2,a5,800013fe <uvmfirst+0x62>
    800013b2:	8a2a                	mv	s4,a0
    800013b4:	89ae                	mv	s3,a1
    800013b6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013b8:	fffff097          	auipc	ra,0xfffff
    800013bc:	774080e7          	jalr	1908(ra) # 80000b2c <kalloc>
    800013c0:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013c2:	6605                	lui	a2,0x1
    800013c4:	4581                	li	a1,0
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	952080e7          	jalr	-1710(ra) # 80000d18 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013ce:	4779                	li	a4,30
    800013d0:	86ca                	mv	a3,s2
    800013d2:	6605                	lui	a2,0x1
    800013d4:	4581                	li	a1,0
    800013d6:	8552                	mv	a0,s4
    800013d8:	00000097          	auipc	ra,0x0
    800013dc:	d0c080e7          	jalr	-756(ra) # 800010e4 <mappages>
  memmove(mem, src, sz);
    800013e0:	8626                	mv	a2,s1
    800013e2:	85ce                	mv	a1,s3
    800013e4:	854a                	mv	a0,s2
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	98e080e7          	jalr	-1650(ra) # 80000d74 <memmove>
}
    800013ee:	70a2                	ld	ra,40(sp)
    800013f0:	7402                	ld	s0,32(sp)
    800013f2:	64e2                	ld	s1,24(sp)
    800013f4:	6942                	ld	s2,16(sp)
    800013f6:	69a2                	ld	s3,8(sp)
    800013f8:	6a02                	ld	s4,0(sp)
    800013fa:	6145                	addi	sp,sp,48
    800013fc:	8082                	ret
    panic("uvmfirst: more than a page");
    800013fe:	00007517          	auipc	a0,0x7
    80001402:	d5a50513          	addi	a0,a0,-678 # 80008158 <digits+0x118>
    80001406:	fffff097          	auipc	ra,0xfffff
    8000140a:	180080e7          	jalr	384(ra) # 80000586 <panic>

000000008000140e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000140e:	1101                	addi	sp,sp,-32
    80001410:	ec06                	sd	ra,24(sp)
    80001412:	e822                	sd	s0,16(sp)
    80001414:	e426                	sd	s1,8(sp)
    80001416:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001418:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000141a:	00b67d63          	bgeu	a2,a1,80001434 <uvmdealloc+0x26>
    8000141e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001420:	6785                	lui	a5,0x1
    80001422:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001424:	00f60733          	add	a4,a2,a5
    80001428:	76fd                	lui	a3,0xfffff
    8000142a:	8f75                	and	a4,a4,a3
    8000142c:	97ae                	add	a5,a5,a1
    8000142e:	8ff5                	and	a5,a5,a3
    80001430:	00f76863          	bltu	a4,a5,80001440 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001434:	8526                	mv	a0,s1
    80001436:	60e2                	ld	ra,24(sp)
    80001438:	6442                	ld	s0,16(sp)
    8000143a:	64a2                	ld	s1,8(sp)
    8000143c:	6105                	addi	sp,sp,32
    8000143e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001440:	8f99                	sub	a5,a5,a4
    80001442:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001444:	4685                	li	a3,1
    80001446:	0007861b          	sext.w	a2,a5
    8000144a:	85ba                	mv	a1,a4
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	e5e080e7          	jalr	-418(ra) # 800012aa <uvmunmap>
    80001454:	b7c5                	j	80001434 <uvmdealloc+0x26>

0000000080001456 <uvmalloc>:
  if(newsz < oldsz)
    80001456:	0ab66563          	bltu	a2,a1,80001500 <uvmalloc+0xaa>
{
    8000145a:	7139                	addi	sp,sp,-64
    8000145c:	fc06                	sd	ra,56(sp)
    8000145e:	f822                	sd	s0,48(sp)
    80001460:	f426                	sd	s1,40(sp)
    80001462:	f04a                	sd	s2,32(sp)
    80001464:	ec4e                	sd	s3,24(sp)
    80001466:	e852                	sd	s4,16(sp)
    80001468:	e456                	sd	s5,8(sp)
    8000146a:	e05a                	sd	s6,0(sp)
    8000146c:	0080                	addi	s0,sp,64
    8000146e:	8aaa                	mv	s5,a0
    80001470:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001472:	6785                	lui	a5,0x1
    80001474:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001476:	95be                	add	a1,a1,a5
    80001478:	77fd                	lui	a5,0xfffff
    8000147a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000147e:	08c9f363          	bgeu	s3,a2,80001504 <uvmalloc+0xae>
    80001482:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001484:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001488:	fffff097          	auipc	ra,0xfffff
    8000148c:	6a4080e7          	jalr	1700(ra) # 80000b2c <kalloc>
    80001490:	84aa                	mv	s1,a0
    if(mem == 0){
    80001492:	c51d                	beqz	a0,800014c0 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001494:	6605                	lui	a2,0x1
    80001496:	4581                	li	a1,0
    80001498:	00000097          	auipc	ra,0x0
    8000149c:	880080e7          	jalr	-1920(ra) # 80000d18 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014a0:	875a                	mv	a4,s6
    800014a2:	86a6                	mv	a3,s1
    800014a4:	6605                	lui	a2,0x1
    800014a6:	85ca                	mv	a1,s2
    800014a8:	8556                	mv	a0,s5
    800014aa:	00000097          	auipc	ra,0x0
    800014ae:	c3a080e7          	jalr	-966(ra) # 800010e4 <mappages>
    800014b2:	e90d                	bnez	a0,800014e4 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014b4:	6785                	lui	a5,0x1
    800014b6:	993e                	add	s2,s2,a5
    800014b8:	fd4968e3          	bltu	s2,s4,80001488 <uvmalloc+0x32>
  return newsz;
    800014bc:	8552                	mv	a0,s4
    800014be:	a809                	j	800014d0 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    800014c0:	864e                	mv	a2,s3
    800014c2:	85ca                	mv	a1,s2
    800014c4:	8556                	mv	a0,s5
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	f48080e7          	jalr	-184(ra) # 8000140e <uvmdealloc>
      return 0;
    800014ce:	4501                	li	a0,0
}
    800014d0:	70e2                	ld	ra,56(sp)
    800014d2:	7442                	ld	s0,48(sp)
    800014d4:	74a2                	ld	s1,40(sp)
    800014d6:	7902                	ld	s2,32(sp)
    800014d8:	69e2                	ld	s3,24(sp)
    800014da:	6a42                	ld	s4,16(sp)
    800014dc:	6aa2                	ld	s5,8(sp)
    800014de:	6b02                	ld	s6,0(sp)
    800014e0:	6121                	addi	sp,sp,64
    800014e2:	8082                	ret
      kfree(mem);
    800014e4:	8526                	mv	a0,s1
    800014e6:	fffff097          	auipc	ra,0xfffff
    800014ea:	548080e7          	jalr	1352(ra) # 80000a2e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014ee:	864e                	mv	a2,s3
    800014f0:	85ca                	mv	a1,s2
    800014f2:	8556                	mv	a0,s5
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	f1a080e7          	jalr	-230(ra) # 8000140e <uvmdealloc>
      return 0;
    800014fc:	4501                	li	a0,0
    800014fe:	bfc9                	j	800014d0 <uvmalloc+0x7a>
    return oldsz;
    80001500:	852e                	mv	a0,a1
}
    80001502:	8082                	ret
  return newsz;
    80001504:	8532                	mv	a0,a2
    80001506:	b7e9                	j	800014d0 <uvmalloc+0x7a>

0000000080001508 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001508:	7179                	addi	sp,sp,-48
    8000150a:	f406                	sd	ra,40(sp)
    8000150c:	f022                	sd	s0,32(sp)
    8000150e:	ec26                	sd	s1,24(sp)
    80001510:	e84a                	sd	s2,16(sp)
    80001512:	e44e                	sd	s3,8(sp)
    80001514:	e052                	sd	s4,0(sp)
    80001516:	1800                	addi	s0,sp,48
    80001518:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000151a:	84aa                	mv	s1,a0
    8000151c:	6905                	lui	s2,0x1
    8000151e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001520:	4985                	li	s3,1
    80001522:	a829                	j	8000153c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001524:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001526:	00c79513          	slli	a0,a5,0xc
    8000152a:	00000097          	auipc	ra,0x0
    8000152e:	fde080e7          	jalr	-34(ra) # 80001508 <freewalk>
      pagetable[i] = 0;
    80001532:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001536:	04a1                	addi	s1,s1,8
    80001538:	03248163          	beq	s1,s2,8000155a <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000153c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000153e:	00f7f713          	andi	a4,a5,15
    80001542:	ff3701e3          	beq	a4,s3,80001524 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001546:	8b85                	andi	a5,a5,1
    80001548:	d7fd                	beqz	a5,80001536 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000154a:	00007517          	auipc	a0,0x7
    8000154e:	c2e50513          	addi	a0,a0,-978 # 80008178 <digits+0x138>
    80001552:	fffff097          	auipc	ra,0xfffff
    80001556:	034080e7          	jalr	52(ra) # 80000586 <panic>
    }
  }
  kfree((void*)pagetable);
    8000155a:	8552                	mv	a0,s4
    8000155c:	fffff097          	auipc	ra,0xfffff
    80001560:	4d2080e7          	jalr	1234(ra) # 80000a2e <kfree>
}
    80001564:	70a2                	ld	ra,40(sp)
    80001566:	7402                	ld	s0,32(sp)
    80001568:	64e2                	ld	s1,24(sp)
    8000156a:	6942                	ld	s2,16(sp)
    8000156c:	69a2                	ld	s3,8(sp)
    8000156e:	6a02                	ld	s4,0(sp)
    80001570:	6145                	addi	sp,sp,48
    80001572:	8082                	ret

0000000080001574 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001574:	1101                	addi	sp,sp,-32
    80001576:	ec06                	sd	ra,24(sp)
    80001578:	e822                	sd	s0,16(sp)
    8000157a:	e426                	sd	s1,8(sp)
    8000157c:	1000                	addi	s0,sp,32
    8000157e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001580:	e999                	bnez	a1,80001596 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001582:	8526                	mv	a0,s1
    80001584:	00000097          	auipc	ra,0x0
    80001588:	f84080e7          	jalr	-124(ra) # 80001508 <freewalk>
}
    8000158c:	60e2                	ld	ra,24(sp)
    8000158e:	6442                	ld	s0,16(sp)
    80001590:	64a2                	ld	s1,8(sp)
    80001592:	6105                	addi	sp,sp,32
    80001594:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001596:	6785                	lui	a5,0x1
    80001598:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000159a:	95be                	add	a1,a1,a5
    8000159c:	4685                	li	a3,1
    8000159e:	00c5d613          	srli	a2,a1,0xc
    800015a2:	4581                	li	a1,0
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	d06080e7          	jalr	-762(ra) # 800012aa <uvmunmap>
    800015ac:	bfd9                	j	80001582 <uvmfree+0xe>

00000000800015ae <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015ae:	c679                	beqz	a2,8000167c <uvmcopy+0xce>
{
    800015b0:	715d                	addi	sp,sp,-80
    800015b2:	e486                	sd	ra,72(sp)
    800015b4:	e0a2                	sd	s0,64(sp)
    800015b6:	fc26                	sd	s1,56(sp)
    800015b8:	f84a                	sd	s2,48(sp)
    800015ba:	f44e                	sd	s3,40(sp)
    800015bc:	f052                	sd	s4,32(sp)
    800015be:	ec56                	sd	s5,24(sp)
    800015c0:	e85a                	sd	s6,16(sp)
    800015c2:	e45e                	sd	s7,8(sp)
    800015c4:	0880                	addi	s0,sp,80
    800015c6:	8b2a                	mv	s6,a0
    800015c8:	8aae                	mv	s5,a1
    800015ca:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015cc:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015ce:	4601                	li	a2,0
    800015d0:	85ce                	mv	a1,s3
    800015d2:	855a                	mv	a0,s6
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	a28080e7          	jalr	-1496(ra) # 80000ffc <walk>
    800015dc:	c531                	beqz	a0,80001628 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015de:	6118                	ld	a4,0(a0)
    800015e0:	00177793          	andi	a5,a4,1
    800015e4:	cbb1                	beqz	a5,80001638 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015e6:	00a75593          	srli	a1,a4,0xa
    800015ea:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015ee:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015f2:	fffff097          	auipc	ra,0xfffff
    800015f6:	53a080e7          	jalr	1338(ra) # 80000b2c <kalloc>
    800015fa:	892a                	mv	s2,a0
    800015fc:	c939                	beqz	a0,80001652 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015fe:	6605                	lui	a2,0x1
    80001600:	85de                	mv	a1,s7
    80001602:	fffff097          	auipc	ra,0xfffff
    80001606:	772080e7          	jalr	1906(ra) # 80000d74 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000160a:	8726                	mv	a4,s1
    8000160c:	86ca                	mv	a3,s2
    8000160e:	6605                	lui	a2,0x1
    80001610:	85ce                	mv	a1,s3
    80001612:	8556                	mv	a0,s5
    80001614:	00000097          	auipc	ra,0x0
    80001618:	ad0080e7          	jalr	-1328(ra) # 800010e4 <mappages>
    8000161c:	e515                	bnez	a0,80001648 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000161e:	6785                	lui	a5,0x1
    80001620:	99be                	add	s3,s3,a5
    80001622:	fb49e6e3          	bltu	s3,s4,800015ce <uvmcopy+0x20>
    80001626:	a081                	j	80001666 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001628:	00007517          	auipc	a0,0x7
    8000162c:	b6050513          	addi	a0,a0,-1184 # 80008188 <digits+0x148>
    80001630:	fffff097          	auipc	ra,0xfffff
    80001634:	f56080e7          	jalr	-170(ra) # 80000586 <panic>
      panic("uvmcopy: page not present");
    80001638:	00007517          	auipc	a0,0x7
    8000163c:	b7050513          	addi	a0,a0,-1168 # 800081a8 <digits+0x168>
    80001640:	fffff097          	auipc	ra,0xfffff
    80001644:	f46080e7          	jalr	-186(ra) # 80000586 <panic>
      kfree(mem);
    80001648:	854a                	mv	a0,s2
    8000164a:	fffff097          	auipc	ra,0xfffff
    8000164e:	3e4080e7          	jalr	996(ra) # 80000a2e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001652:	4685                	li	a3,1
    80001654:	00c9d613          	srli	a2,s3,0xc
    80001658:	4581                	li	a1,0
    8000165a:	8556                	mv	a0,s5
    8000165c:	00000097          	auipc	ra,0x0
    80001660:	c4e080e7          	jalr	-946(ra) # 800012aa <uvmunmap>
  return -1;
    80001664:	557d                	li	a0,-1
}
    80001666:	60a6                	ld	ra,72(sp)
    80001668:	6406                	ld	s0,64(sp)
    8000166a:	74e2                	ld	s1,56(sp)
    8000166c:	7942                	ld	s2,48(sp)
    8000166e:	79a2                	ld	s3,40(sp)
    80001670:	7a02                	ld	s4,32(sp)
    80001672:	6ae2                	ld	s5,24(sp)
    80001674:	6b42                	ld	s6,16(sp)
    80001676:	6ba2                	ld	s7,8(sp)
    80001678:	6161                	addi	sp,sp,80
    8000167a:	8082                	ret
  return 0;
    8000167c:	4501                	li	a0,0
}
    8000167e:	8082                	ret

0000000080001680 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001680:	1141                	addi	sp,sp,-16
    80001682:	e406                	sd	ra,8(sp)
    80001684:	e022                	sd	s0,0(sp)
    80001686:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001688:	4601                	li	a2,0
    8000168a:	00000097          	auipc	ra,0x0
    8000168e:	972080e7          	jalr	-1678(ra) # 80000ffc <walk>
  if(pte == 0)
    80001692:	c901                	beqz	a0,800016a2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001694:	611c                	ld	a5,0(a0)
    80001696:	9bbd                	andi	a5,a5,-17
    80001698:	e11c                	sd	a5,0(a0)
}
    8000169a:	60a2                	ld	ra,8(sp)
    8000169c:	6402                	ld	s0,0(sp)
    8000169e:	0141                	addi	sp,sp,16
    800016a0:	8082                	ret
    panic("uvmclear");
    800016a2:	00007517          	auipc	a0,0x7
    800016a6:	b2650513          	addi	a0,a0,-1242 # 800081c8 <digits+0x188>
    800016aa:	fffff097          	auipc	ra,0xfffff
    800016ae:	edc080e7          	jalr	-292(ra) # 80000586 <panic>

00000000800016b2 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016b2:	c6bd                	beqz	a3,80001720 <copyout+0x6e>
{
    800016b4:	715d                	addi	sp,sp,-80
    800016b6:	e486                	sd	ra,72(sp)
    800016b8:	e0a2                	sd	s0,64(sp)
    800016ba:	fc26                	sd	s1,56(sp)
    800016bc:	f84a                	sd	s2,48(sp)
    800016be:	f44e                	sd	s3,40(sp)
    800016c0:	f052                	sd	s4,32(sp)
    800016c2:	ec56                	sd	s5,24(sp)
    800016c4:	e85a                	sd	s6,16(sp)
    800016c6:	e45e                	sd	s7,8(sp)
    800016c8:	e062                	sd	s8,0(sp)
    800016ca:	0880                	addi	s0,sp,80
    800016cc:	8b2a                	mv	s6,a0
    800016ce:	8c2e                	mv	s8,a1
    800016d0:	8a32                	mv	s4,a2
    800016d2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016d4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016d6:	6a85                	lui	s5,0x1
    800016d8:	a015                	j	800016fc <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016da:	9562                	add	a0,a0,s8
    800016dc:	0004861b          	sext.w	a2,s1
    800016e0:	85d2                	mv	a1,s4
    800016e2:	41250533          	sub	a0,a0,s2
    800016e6:	fffff097          	auipc	ra,0xfffff
    800016ea:	68e080e7          	jalr	1678(ra) # 80000d74 <memmove>

    len -= n;
    800016ee:	409989b3          	sub	s3,s3,s1
    src += n;
    800016f2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016f4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016f8:	02098263          	beqz	s3,8000171c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016fc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001700:	85ca                	mv	a1,s2
    80001702:	855a                	mv	a0,s6
    80001704:	00000097          	auipc	ra,0x0
    80001708:	99e080e7          	jalr	-1634(ra) # 800010a2 <walkaddr>
    if(pa0 == 0)
    8000170c:	cd01                	beqz	a0,80001724 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000170e:	418904b3          	sub	s1,s2,s8
    80001712:	94d6                	add	s1,s1,s5
    80001714:	fc99f3e3          	bgeu	s3,s1,800016da <copyout+0x28>
    80001718:	84ce                	mv	s1,s3
    8000171a:	b7c1                	j	800016da <copyout+0x28>
  }
  return 0;
    8000171c:	4501                	li	a0,0
    8000171e:	a021                	j	80001726 <copyout+0x74>
    80001720:	4501                	li	a0,0
}
    80001722:	8082                	ret
      return -1;
    80001724:	557d                	li	a0,-1
}
    80001726:	60a6                	ld	ra,72(sp)
    80001728:	6406                	ld	s0,64(sp)
    8000172a:	74e2                	ld	s1,56(sp)
    8000172c:	7942                	ld	s2,48(sp)
    8000172e:	79a2                	ld	s3,40(sp)
    80001730:	7a02                	ld	s4,32(sp)
    80001732:	6ae2                	ld	s5,24(sp)
    80001734:	6b42                	ld	s6,16(sp)
    80001736:	6ba2                	ld	s7,8(sp)
    80001738:	6c02                	ld	s8,0(sp)
    8000173a:	6161                	addi	sp,sp,80
    8000173c:	8082                	ret

000000008000173e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000173e:	caa5                	beqz	a3,800017ae <copyin+0x70>
{
    80001740:	715d                	addi	sp,sp,-80
    80001742:	e486                	sd	ra,72(sp)
    80001744:	e0a2                	sd	s0,64(sp)
    80001746:	fc26                	sd	s1,56(sp)
    80001748:	f84a                	sd	s2,48(sp)
    8000174a:	f44e                	sd	s3,40(sp)
    8000174c:	f052                	sd	s4,32(sp)
    8000174e:	ec56                	sd	s5,24(sp)
    80001750:	e85a                	sd	s6,16(sp)
    80001752:	e45e                	sd	s7,8(sp)
    80001754:	e062                	sd	s8,0(sp)
    80001756:	0880                	addi	s0,sp,80
    80001758:	8b2a                	mv	s6,a0
    8000175a:	8a2e                	mv	s4,a1
    8000175c:	8c32                	mv	s8,a2
    8000175e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001760:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001762:	6a85                	lui	s5,0x1
    80001764:	a01d                	j	8000178a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001766:	018505b3          	add	a1,a0,s8
    8000176a:	0004861b          	sext.w	a2,s1
    8000176e:	412585b3          	sub	a1,a1,s2
    80001772:	8552                	mv	a0,s4
    80001774:	fffff097          	auipc	ra,0xfffff
    80001778:	600080e7          	jalr	1536(ra) # 80000d74 <memmove>

    len -= n;
    8000177c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001780:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001782:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001786:	02098263          	beqz	s3,800017aa <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000178a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000178e:	85ca                	mv	a1,s2
    80001790:	855a                	mv	a0,s6
    80001792:	00000097          	auipc	ra,0x0
    80001796:	910080e7          	jalr	-1776(ra) # 800010a2 <walkaddr>
    if(pa0 == 0)
    8000179a:	cd01                	beqz	a0,800017b2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000179c:	418904b3          	sub	s1,s2,s8
    800017a0:	94d6                	add	s1,s1,s5
    800017a2:	fc99f2e3          	bgeu	s3,s1,80001766 <copyin+0x28>
    800017a6:	84ce                	mv	s1,s3
    800017a8:	bf7d                	j	80001766 <copyin+0x28>
  }
  return 0;
    800017aa:	4501                	li	a0,0
    800017ac:	a021                	j	800017b4 <copyin+0x76>
    800017ae:	4501                	li	a0,0
}
    800017b0:	8082                	ret
      return -1;
    800017b2:	557d                	li	a0,-1
}
    800017b4:	60a6                	ld	ra,72(sp)
    800017b6:	6406                	ld	s0,64(sp)
    800017b8:	74e2                	ld	s1,56(sp)
    800017ba:	7942                	ld	s2,48(sp)
    800017bc:	79a2                	ld	s3,40(sp)
    800017be:	7a02                	ld	s4,32(sp)
    800017c0:	6ae2                	ld	s5,24(sp)
    800017c2:	6b42                	ld	s6,16(sp)
    800017c4:	6ba2                	ld	s7,8(sp)
    800017c6:	6c02                	ld	s8,0(sp)
    800017c8:	6161                	addi	sp,sp,80
    800017ca:	8082                	ret

00000000800017cc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017cc:	c2dd                	beqz	a3,80001872 <copyinstr+0xa6>
{
    800017ce:	715d                	addi	sp,sp,-80
    800017d0:	e486                	sd	ra,72(sp)
    800017d2:	e0a2                	sd	s0,64(sp)
    800017d4:	fc26                	sd	s1,56(sp)
    800017d6:	f84a                	sd	s2,48(sp)
    800017d8:	f44e                	sd	s3,40(sp)
    800017da:	f052                	sd	s4,32(sp)
    800017dc:	ec56                	sd	s5,24(sp)
    800017de:	e85a                	sd	s6,16(sp)
    800017e0:	e45e                	sd	s7,8(sp)
    800017e2:	0880                	addi	s0,sp,80
    800017e4:	8a2a                	mv	s4,a0
    800017e6:	8b2e                	mv	s6,a1
    800017e8:	8bb2                	mv	s7,a2
    800017ea:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017ec:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017ee:	6985                	lui	s3,0x1
    800017f0:	a02d                	j	8000181a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017f2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017f6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017f8:	37fd                	addiw	a5,a5,-1
    800017fa:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017fe:	60a6                	ld	ra,72(sp)
    80001800:	6406                	ld	s0,64(sp)
    80001802:	74e2                	ld	s1,56(sp)
    80001804:	7942                	ld	s2,48(sp)
    80001806:	79a2                	ld	s3,40(sp)
    80001808:	7a02                	ld	s4,32(sp)
    8000180a:	6ae2                	ld	s5,24(sp)
    8000180c:	6b42                	ld	s6,16(sp)
    8000180e:	6ba2                	ld	s7,8(sp)
    80001810:	6161                	addi	sp,sp,80
    80001812:	8082                	ret
    srcva = va0 + PGSIZE;
    80001814:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001818:	c8a9                	beqz	s1,8000186a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    8000181a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000181e:	85ca                	mv	a1,s2
    80001820:	8552                	mv	a0,s4
    80001822:	00000097          	auipc	ra,0x0
    80001826:	880080e7          	jalr	-1920(ra) # 800010a2 <walkaddr>
    if(pa0 == 0)
    8000182a:	c131                	beqz	a0,8000186e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000182c:	417906b3          	sub	a3,s2,s7
    80001830:	96ce                	add	a3,a3,s3
    80001832:	00d4f363          	bgeu	s1,a3,80001838 <copyinstr+0x6c>
    80001836:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001838:	955e                	add	a0,a0,s7
    8000183a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000183e:	daf9                	beqz	a3,80001814 <copyinstr+0x48>
    80001840:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001842:	41650633          	sub	a2,a0,s6
    80001846:	fff48593          	addi	a1,s1,-1
    8000184a:	95da                	add	a1,a1,s6
    while(n > 0){
    8000184c:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    8000184e:	00f60733          	add	a4,a2,a5
    80001852:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcf90>
    80001856:	df51                	beqz	a4,800017f2 <copyinstr+0x26>
        *dst = *p;
    80001858:	00e78023          	sb	a4,0(a5)
      --max;
    8000185c:	40f584b3          	sub	s1,a1,a5
      dst++;
    80001860:	0785                	addi	a5,a5,1
    while(n > 0){
    80001862:	fed796e3          	bne	a5,a3,8000184e <copyinstr+0x82>
      dst++;
    80001866:	8b3e                	mv	s6,a5
    80001868:	b775                	j	80001814 <copyinstr+0x48>
    8000186a:	4781                	li	a5,0
    8000186c:	b771                	j	800017f8 <copyinstr+0x2c>
      return -1;
    8000186e:	557d                	li	a0,-1
    80001870:	b779                	j	800017fe <copyinstr+0x32>
  int got_null = 0;
    80001872:	4781                	li	a5,0
  if(got_null){
    80001874:	37fd                	addiw	a5,a5,-1
    80001876:	0007851b          	sext.w	a0,a5
}
    8000187a:	8082                	ret

000000008000187c <rr_scheduler>:
        (*sched_pointer)();
    }
}

void rr_scheduler(void)
{
    8000187c:	7139                	addi	sp,sp,-64
    8000187e:	fc06                	sd	ra,56(sp)
    80001880:	f822                	sd	s0,48(sp)
    80001882:	f426                	sd	s1,40(sp)
    80001884:	f04a                	sd	s2,32(sp)
    80001886:	ec4e                	sd	s3,24(sp)
    80001888:	e852                	sd	s4,16(sp)
    8000188a:	e456                	sd	s5,8(sp)
    8000188c:	e05a                	sd	s6,0(sp)
    8000188e:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    80001890:	8792                	mv	a5,tp
    int id = r_tp();
    80001892:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    80001894:	0000fa97          	auipc	s5,0xf
    80001898:	3cca8a93          	addi	s5,s5,972 # 80010c60 <cpus>
    8000189c:	00779713          	slli	a4,a5,0x7
    800018a0:	00ea86b3          	add	a3,s5,a4
    800018a4:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffdcf90>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018a8:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800018ac:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018b0:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    800018b4:	0721                	addi	a4,a4,8
    800018b6:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    800018b8:	0000f497          	auipc	s1,0xf
    800018bc:	7d848493          	addi	s1,s1,2008 # 80011090 <proc>
        if (p->state == RUNNABLE)
    800018c0:	498d                	li	s3,3
            p->state = RUNNING;
    800018c2:	4b11                	li	s6,4
            c->proc = p;
    800018c4:	079e                	slli	a5,a5,0x7
    800018c6:	0000fa17          	auipc	s4,0xf
    800018ca:	39aa0a13          	addi	s4,s4,922 # 80010c60 <cpus>
    800018ce:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800018d0:	00015917          	auipc	s2,0x15
    800018d4:	3c090913          	addi	s2,s2,960 # 80016c90 <tickslock>
    800018d8:	a811                	j	800018ec <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	fffff097          	auipc	ra,0xfffff
    800018e0:	3f4080e7          	jalr	1012(ra) # 80000cd0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800018e4:	17048493          	addi	s1,s1,368
    800018e8:	03248863          	beq	s1,s2,80001918 <rr_scheduler+0x9c>
        acquire(&p->lock);
    800018ec:	8526                	mv	a0,s1
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	32e080e7          	jalr	814(ra) # 80000c1c <acquire>
        if (p->state == RUNNABLE)
    800018f6:	4c9c                	lw	a5,24(s1)
    800018f8:	ff3791e3          	bne	a5,s3,800018da <rr_scheduler+0x5e>
            p->state = RUNNING;
    800018fc:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    80001900:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    80001904:	06848593          	addi	a1,s1,104
    80001908:	8556                	mv	a0,s5
    8000190a:	00001097          	auipc	ra,0x1
    8000190e:	1b4080e7          	jalr	436(ra) # 80002abe <swtch>
            c->proc = 0;
    80001912:	000a3023          	sd	zero,0(s4)
    80001916:	b7d1                	j	800018da <rr_scheduler+0x5e>
    }
}
    80001918:	70e2                	ld	ra,56(sp)
    8000191a:	7442                	ld	s0,48(sp)
    8000191c:	74a2                	ld	s1,40(sp)
    8000191e:	7902                	ld	s2,32(sp)
    80001920:	69e2                	ld	s3,24(sp)
    80001922:	6a42                	ld	s4,16(sp)
    80001924:	6aa2                	ld	s5,8(sp)
    80001926:	6b02                	ld	s6,0(sp)
    80001928:	6121                	addi	sp,sp,64
    8000192a:	8082                	ret

000000008000192c <mlfq_scheduler>:

void mlfq_scheduler(void)
{
    8000192c:	7159                	addi	sp,sp,-112
    8000192e:	f486                	sd	ra,104(sp)
    80001930:	f0a2                	sd	s0,96(sp)
    80001932:	eca6                	sd	s1,88(sp)
    80001934:	e8ca                	sd	s2,80(sp)
    80001936:	e4ce                	sd	s3,72(sp)
    80001938:	e0d2                	sd	s4,64(sp)
    8000193a:	fc56                	sd	s5,56(sp)
    8000193c:	f85a                	sd	s6,48(sp)
    8000193e:	f45e                	sd	s7,40(sp)
    80001940:	f062                	sd	s8,32(sp)
    80001942:	ec66                	sd	s9,24(sp)
    80001944:	e86a                	sd	s10,16(sp)
    80001946:	e46e                	sd	s11,8(sp)
    80001948:	1880                	addi	s0,sp,112
  asm volatile("mv %0, tp" : "=r" (x) );
    8000194a:	8d92                	mv	s11,tp
    int id = r_tp();
    8000194c:	2d81                	sext.w	s11,s11
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    8000194e:	0000fb17          	auipc	s6,0xf
    80001952:	312b0b13          	addi	s6,s6,786 # 80010c60 <cpus>
    80001956:	007d9793          	slli	a5,s11,0x7
    8000195a:	00fb0733          	add	a4,s6,a5
    8000195e:	00073023          	sd	zero,0(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001962:	10002773          	csrr	a4,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001966:	00276713          	ori	a4,a4,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000196a:	10071073          	csrw	sstatus,a4
                // Switch to chosen process.  It is the process's job
                // to release its lock and then reacquire it
                // before jumping back to us.
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    8000196e:	07a1                	addi	a5,a5,8
    80001970:	9b3e                	add	s6,s6,a5
                c->proc = p;
    80001972:	007d9793          	slli	a5,s11,0x7
    80001976:	0000fa97          	auipc	s5,0xf
    8000197a:	2eaa8a93          	addi	s5,s5,746 # 80010c60 <cpus>
    8000197e:	9abe                	add	s5,s5,a5
                // check if we are still the right scheduler
                if (sched_pointer != &mlfq_scheduler)
    80001980:	00007d17          	auipc	s10,0x7
    80001984:	f88d0d13          	addi	s10,s10,-120 # 80008908 <sched_pointer>
    80001988:	00000c97          	auipc	s9,0x0
    8000198c:	fa4c8c93          	addi	s9,s9,-92 # 8000192c <mlfq_scheduler>
        high_avail = 0;
    80001990:	4b81                	li	s7,0
        for (p = proc; p < &proc[NPROC]; p++)
    80001992:	0000f497          	auipc	s1,0xf
    80001996:	6fe48493          	addi	s1,s1,1790 # 80011090 <proc>
            if (p->state == RUNNABLE)
    8000199a:	4a0d                	li	s4,3
                p->state = RUNNING;
    8000199c:	4c11                	li	s8,4
        for (p = proc; p < &proc[NPROC]; p++)
    8000199e:	00015997          	auipc	s3,0x15
    800019a2:	2f298993          	addi	s3,s3,754 # 80016c90 <tickslock>
    800019a6:	a01d                	j	800019cc <mlfq_scheduler+0xa0>
                release(&p->lock);
    800019a8:	8526                	mv	a0,s1
    800019aa:	fffff097          	auipc	ra,0xfffff
    800019ae:	326080e7          	jalr	806(ra) # 80000cd0 <release>
                continue;
    800019b2:	a809                	j	800019c4 <mlfq_scheduler+0x98>
                    return;
                }

                // Process is done running for now.
                // It should have changed its p->state before coming back.
                c->proc = 0;
    800019b4:	000ab023          	sd	zero,0(s5)
                high_avail = 1;
    800019b8:	4b85                	li	s7,1
            }
            release(&p->lock);
    800019ba:	8526                	mv	a0,s1
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	314080e7          	jalr	788(ra) # 80000cd0 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    800019c4:	17048493          	addi	s1,s1,368
    800019c8:	05348f63          	beq	s1,s3,80001a26 <mlfq_scheduler+0xfa>
            acquire(&p->lock);
    800019cc:	8526                	mv	a0,s1
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	24e080e7          	jalr	590(ra) # 80000c1c <acquire>
            if (p->priority > 0)
    800019d6:	58dc                	lw	a5,52(s1)
    800019d8:	fbe1                	bnez	a5,800019a8 <mlfq_scheduler+0x7c>
            if (p->state == RUNNABLE)
    800019da:	4c9c                	lw	a5,24(s1)
    800019dc:	fd479fe3          	bne	a5,s4,800019ba <mlfq_scheduler+0x8e>
                p->state = RUNNING;
    800019e0:	0184ac23          	sw	s8,24(s1)
                c->proc = p;
    800019e4:	009ab023          	sd	s1,0(s5)
                swtch(&c->context, &p->context);
    800019e8:	06848593          	addi	a1,s1,104
    800019ec:	855a                	mv	a0,s6
    800019ee:	00001097          	auipc	ra,0x1
    800019f2:	0d0080e7          	jalr	208(ra) # 80002abe <swtch>
                if (sched_pointer != &mlfq_scheduler)
    800019f6:	000d3783          	ld	a5,0(s10)
    800019fa:	fb978de3          	beq	a5,s9,800019b4 <mlfq_scheduler+0x88>
                    release(&p->lock);
    800019fe:	8526                	mv	a0,s1
    80001a00:	fffff097          	auipc	ra,0xfffff
    80001a04:	2d0080e7          	jalr	720(ra) # 80000cd0 <release>
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    }
}
    80001a08:	70a6                	ld	ra,104(sp)
    80001a0a:	7406                	ld	s0,96(sp)
    80001a0c:	64e6                	ld	s1,88(sp)
    80001a0e:	6946                	ld	s2,80(sp)
    80001a10:	69a6                	ld	s3,72(sp)
    80001a12:	6a06                	ld	s4,64(sp)
    80001a14:	7ae2                	ld	s5,56(sp)
    80001a16:	7b42                	ld	s6,48(sp)
    80001a18:	7ba2                	ld	s7,40(sp)
    80001a1a:	7c02                	ld	s8,32(sp)
    80001a1c:	6ce2                	ld	s9,24(sp)
    80001a1e:	6d42                	ld	s10,16(sp)
    80001a20:	6da2                	ld	s11,8(sp)
    80001a22:	6165                	addi	sp,sp,112
    80001a24:	8082                	ret
    } while (high_avail);
    80001a26:	f60b95e3          	bnez	s7,80001990 <mlfq_scheduler+0x64>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a2a:	0000f497          	auipc	s1,0xf
    80001a2e:	66648493          	addi	s1,s1,1638 # 80011090 <proc>
        if (p->state == RUNNABLE)
    80001a32:	498d                	li	s3,3
            p->state = RUNNING;
    80001a34:	4c11                	li	s8,4
            c->proc = p;
    80001a36:	0d9e                	slli	s11,s11,0x7
    80001a38:	0000fa97          	auipc	s5,0xf
    80001a3c:	228a8a93          	addi	s5,s5,552 # 80010c60 <cpus>
    80001a40:	9aee                	add	s5,s5,s11
            if (sched_pointer != &mlfq_scheduler)
    80001a42:	00007c97          	auipc	s9,0x7
    80001a46:	ec6c8c93          	addi	s9,s9,-314 # 80008908 <sched_pointer>
    80001a4a:	00000b97          	auipc	s7,0x0
    80001a4e:	ee2b8b93          	addi	s7,s7,-286 # 8000192c <mlfq_scheduler>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a52:	00015a17          	auipc	s4,0x15
    80001a56:	23ea0a13          	addi	s4,s4,574 # 80016c90 <tickslock>
    80001a5a:	a835                	j	80001a96 <mlfq_scheduler+0x16a>
        if (p->state == RUNNABLE)
    80001a5c:	4c9c                	lw	a5,24(s1)
    80001a5e:	03379363          	bne	a5,s3,80001a84 <mlfq_scheduler+0x158>
            p->state = RUNNING;
    80001a62:	0184ac23          	sw	s8,24(s1)
            c->proc = p;
    80001a66:	009ab023          	sd	s1,0(s5)
            swtch(&c->context, &p->context);
    80001a6a:	06848593          	addi	a1,s1,104
    80001a6e:	855a                	mv	a0,s6
    80001a70:	00001097          	auipc	ra,0x1
    80001a74:	04e080e7          	jalr	78(ra) # 80002abe <swtch>
            if (sched_pointer != &mlfq_scheduler)
    80001a78:	000cb783          	ld	a5,0(s9)
    80001a7c:	03779d63          	bne	a5,s7,80001ab6 <mlfq_scheduler+0x18a>
            c->proc = 0;
    80001a80:	000ab023          	sd	zero,0(s5)
        release(&p->lock);
    80001a84:	8526                	mv	a0,s1
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	24a080e7          	jalr	586(ra) # 80000cd0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a8e:	17048493          	addi	s1,s1,368
    80001a92:	f7448be3          	beq	s1,s4,80001a08 <mlfq_scheduler+0xdc>
        acquire(&p->lock);
    80001a96:	8526                	mv	a0,s1
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	184080e7          	jalr	388(ra) # 80000c1c <acquire>
        if (p->priority == 0 && p->state == RUNNABLE)
    80001aa0:	58dc                	lw	a5,52(s1)
    80001aa2:	ffcd                	bnez	a5,80001a5c <mlfq_scheduler+0x130>
    80001aa4:	4c9c                	lw	a5,24(s1)
    80001aa6:	fd379fe3          	bne	a5,s3,80001a84 <mlfq_scheduler+0x158>
            release(&p->lock);
    80001aaa:	8526                	mv	a0,s1
    80001aac:	fffff097          	auipc	ra,0xfffff
    80001ab0:	224080e7          	jalr	548(ra) # 80000cd0 <release>
            break;
    80001ab4:	bf91                	j	80001a08 <mlfq_scheduler+0xdc>
                release(&p->lock);
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	fffff097          	auipc	ra,0xfffff
    80001abc:	218080e7          	jalr	536(ra) # 80000cd0 <release>
                return;
    80001ac0:	b7a1                	j	80001a08 <mlfq_scheduler+0xdc>

0000000080001ac2 <proc_mapstacks>:
{
    80001ac2:	7139                	addi	sp,sp,-64
    80001ac4:	fc06                	sd	ra,56(sp)
    80001ac6:	f822                	sd	s0,48(sp)
    80001ac8:	f426                	sd	s1,40(sp)
    80001aca:	f04a                	sd	s2,32(sp)
    80001acc:	ec4e                	sd	s3,24(sp)
    80001ace:	e852                	sd	s4,16(sp)
    80001ad0:	e456                	sd	s5,8(sp)
    80001ad2:	e05a                	sd	s6,0(sp)
    80001ad4:	0080                	addi	s0,sp,64
    80001ad6:	89aa                	mv	s3,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001ad8:	0000f497          	auipc	s1,0xf
    80001adc:	5b848493          	addi	s1,s1,1464 # 80011090 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001ae0:	8b26                	mv	s6,s1
    80001ae2:	00006a97          	auipc	s5,0x6
    80001ae6:	51ea8a93          	addi	s5,s5,1310 # 80008000 <etext>
    80001aea:	04000937          	lui	s2,0x4000
    80001aee:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001af0:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001af2:	00015a17          	auipc	s4,0x15
    80001af6:	19ea0a13          	addi	s4,s4,414 # 80016c90 <tickslock>
        char *pa = kalloc();
    80001afa:	fffff097          	auipc	ra,0xfffff
    80001afe:	032080e7          	jalr	50(ra) # 80000b2c <kalloc>
    80001b02:	862a                	mv	a2,a0
        if (pa == 0)
    80001b04:	c131                	beqz	a0,80001b48 <proc_mapstacks+0x86>
        uint64 va = KSTACK((int)(p - proc));
    80001b06:	416485b3          	sub	a1,s1,s6
    80001b0a:	8591                	srai	a1,a1,0x4
    80001b0c:	000ab783          	ld	a5,0(s5)
    80001b10:	02f585b3          	mul	a1,a1,a5
    80001b14:	2585                	addiw	a1,a1,1
    80001b16:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b1a:	4719                	li	a4,6
    80001b1c:	6685                	lui	a3,0x1
    80001b1e:	40b905b3          	sub	a1,s2,a1
    80001b22:	854e                	mv	a0,s3
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	660080e7          	jalr	1632(ra) # 80001184 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b2c:	17048493          	addi	s1,s1,368
    80001b30:	fd4495e3          	bne	s1,s4,80001afa <proc_mapstacks+0x38>
}
    80001b34:	70e2                	ld	ra,56(sp)
    80001b36:	7442                	ld	s0,48(sp)
    80001b38:	74a2                	ld	s1,40(sp)
    80001b3a:	7902                	ld	s2,32(sp)
    80001b3c:	69e2                	ld	s3,24(sp)
    80001b3e:	6a42                	ld	s4,16(sp)
    80001b40:	6aa2                	ld	s5,8(sp)
    80001b42:	6b02                	ld	s6,0(sp)
    80001b44:	6121                	addi	sp,sp,64
    80001b46:	8082                	ret
            panic("kalloc");
    80001b48:	00006517          	auipc	a0,0x6
    80001b4c:	69050513          	addi	a0,a0,1680 # 800081d8 <digits+0x198>
    80001b50:	fffff097          	auipc	ra,0xfffff
    80001b54:	a36080e7          	jalr	-1482(ra) # 80000586 <panic>

0000000080001b58 <procinit>:
{
    80001b58:	7139                	addi	sp,sp,-64
    80001b5a:	fc06                	sd	ra,56(sp)
    80001b5c:	f822                	sd	s0,48(sp)
    80001b5e:	f426                	sd	s1,40(sp)
    80001b60:	f04a                	sd	s2,32(sp)
    80001b62:	ec4e                	sd	s3,24(sp)
    80001b64:	e852                	sd	s4,16(sp)
    80001b66:	e456                	sd	s5,8(sp)
    80001b68:	e05a                	sd	s6,0(sp)
    80001b6a:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001b6c:	00006597          	auipc	a1,0x6
    80001b70:	67458593          	addi	a1,a1,1652 # 800081e0 <digits+0x1a0>
    80001b74:	0000f517          	auipc	a0,0xf
    80001b78:	4ec50513          	addi	a0,a0,1260 # 80011060 <pid_lock>
    80001b7c:	fffff097          	auipc	ra,0xfffff
    80001b80:	010080e7          	jalr	16(ra) # 80000b8c <initlock>
    initlock(&wait_lock, "wait_lock");
    80001b84:	00006597          	auipc	a1,0x6
    80001b88:	66458593          	addi	a1,a1,1636 # 800081e8 <digits+0x1a8>
    80001b8c:	0000f517          	auipc	a0,0xf
    80001b90:	4ec50513          	addi	a0,a0,1260 # 80011078 <wait_lock>
    80001b94:	fffff097          	auipc	ra,0xfffff
    80001b98:	ff8080e7          	jalr	-8(ra) # 80000b8c <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b9c:	0000f497          	auipc	s1,0xf
    80001ba0:	4f448493          	addi	s1,s1,1268 # 80011090 <proc>
        initlock(&p->lock, "proc");
    80001ba4:	00006b17          	auipc	s6,0x6
    80001ba8:	654b0b13          	addi	s6,s6,1620 # 800081f8 <digits+0x1b8>
        p->kstack = KSTACK((int)(p - proc));
    80001bac:	8aa6                	mv	s5,s1
    80001bae:	00006a17          	auipc	s4,0x6
    80001bb2:	452a0a13          	addi	s4,s4,1106 # 80008000 <etext>
    80001bb6:	04000937          	lui	s2,0x4000
    80001bba:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001bbc:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001bbe:	00015997          	auipc	s3,0x15
    80001bc2:	0d298993          	addi	s3,s3,210 # 80016c90 <tickslock>
        initlock(&p->lock, "proc");
    80001bc6:	85da                	mv	a1,s6
    80001bc8:	8526                	mv	a0,s1
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	fc2080e7          	jalr	-62(ra) # 80000b8c <initlock>
        p->state = UNUSED;
    80001bd2:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001bd6:	415487b3          	sub	a5,s1,s5
    80001bda:	8791                	srai	a5,a5,0x4
    80001bdc:	000a3703          	ld	a4,0(s4)
    80001be0:	02e787b3          	mul	a5,a5,a4
    80001be4:	2785                	addiw	a5,a5,1
    80001be6:	00d7979b          	slliw	a5,a5,0xd
    80001bea:	40f907b3          	sub	a5,s2,a5
    80001bee:	e4bc                	sd	a5,72(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001bf0:	17048493          	addi	s1,s1,368
    80001bf4:	fd3499e3          	bne	s1,s3,80001bc6 <procinit+0x6e>
}
    80001bf8:	70e2                	ld	ra,56(sp)
    80001bfa:	7442                	ld	s0,48(sp)
    80001bfc:	74a2                	ld	s1,40(sp)
    80001bfe:	7902                	ld	s2,32(sp)
    80001c00:	69e2                	ld	s3,24(sp)
    80001c02:	6a42                	ld	s4,16(sp)
    80001c04:	6aa2                	ld	s5,8(sp)
    80001c06:	6b02                	ld	s6,0(sp)
    80001c08:	6121                	addi	sp,sp,64
    80001c0a:	8082                	ret

0000000080001c0c <copy_array>:
{
    80001c0c:	1141                	addi	sp,sp,-16
    80001c0e:	e422                	sd	s0,8(sp)
    80001c10:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001c12:	02c05163          	blez	a2,80001c34 <copy_array+0x28>
    80001c16:	87aa                	mv	a5,a0
    80001c18:	0505                	addi	a0,a0,1
    80001c1a:	367d                	addiw	a2,a2,-1 # fff <_entry-0x7ffff001>
    80001c1c:	1602                	slli	a2,a2,0x20
    80001c1e:	9201                	srli	a2,a2,0x20
    80001c20:	00c506b3          	add	a3,a0,a2
        dst[i] = src[i];
    80001c24:	0007c703          	lbu	a4,0(a5)
    80001c28:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001c2c:	0785                	addi	a5,a5,1
    80001c2e:	0585                	addi	a1,a1,1
    80001c30:	fed79ae3          	bne	a5,a3,80001c24 <copy_array+0x18>
}
    80001c34:	6422                	ld	s0,8(sp)
    80001c36:	0141                	addi	sp,sp,16
    80001c38:	8082                	ret

0000000080001c3a <cpuid>:
{
    80001c3a:	1141                	addi	sp,sp,-16
    80001c3c:	e422                	sd	s0,8(sp)
    80001c3e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c40:	8512                	mv	a0,tp
}
    80001c42:	2501                	sext.w	a0,a0
    80001c44:	6422                	ld	s0,8(sp)
    80001c46:	0141                	addi	sp,sp,16
    80001c48:	8082                	ret

0000000080001c4a <mycpu>:
{
    80001c4a:	1141                	addi	sp,sp,-16
    80001c4c:	e422                	sd	s0,8(sp)
    80001c4e:	0800                	addi	s0,sp,16
    80001c50:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001c52:	2781                	sext.w	a5,a5
    80001c54:	079e                	slli	a5,a5,0x7
}
    80001c56:	0000f517          	auipc	a0,0xf
    80001c5a:	00a50513          	addi	a0,a0,10 # 80010c60 <cpus>
    80001c5e:	953e                	add	a0,a0,a5
    80001c60:	6422                	ld	s0,8(sp)
    80001c62:	0141                	addi	sp,sp,16
    80001c64:	8082                	ret

0000000080001c66 <myproc>:
{
    80001c66:	1101                	addi	sp,sp,-32
    80001c68:	ec06                	sd	ra,24(sp)
    80001c6a:	e822                	sd	s0,16(sp)
    80001c6c:	e426                	sd	s1,8(sp)
    80001c6e:	1000                	addi	s0,sp,32
    push_off();
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	f60080e7          	jalr	-160(ra) # 80000bd0 <push_off>
    80001c78:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001c7a:	2781                	sext.w	a5,a5
    80001c7c:	079e                	slli	a5,a5,0x7
    80001c7e:	0000f717          	auipc	a4,0xf
    80001c82:	fe270713          	addi	a4,a4,-30 # 80010c60 <cpus>
    80001c86:	97ba                	add	a5,a5,a4
    80001c88:	6384                	ld	s1,0(a5)
    pop_off();
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	fe6080e7          	jalr	-26(ra) # 80000c70 <pop_off>
}
    80001c92:	8526                	mv	a0,s1
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	addi	sp,sp,32
    80001c9c:	8082                	ret

0000000080001c9e <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001c9e:	1141                	addi	sp,sp,-16
    80001ca0:	e406                	sd	ra,8(sp)
    80001ca2:	e022                	sd	s0,0(sp)
    80001ca4:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001ca6:	00000097          	auipc	ra,0x0
    80001caa:	fc0080e7          	jalr	-64(ra) # 80001c66 <myproc>
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	022080e7          	jalr	34(ra) # 80000cd0 <release>

    if (first)
    80001cb6:	00007797          	auipc	a5,0x7
    80001cba:	c4a7a783          	lw	a5,-950(a5) # 80008900 <first.1>
    80001cbe:	eb89                	bnez	a5,80001cd0 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001cc0:	00001097          	auipc	ra,0x1
    80001cc4:	ea8080e7          	jalr	-344(ra) # 80002b68 <usertrapret>
}
    80001cc8:	60a2                	ld	ra,8(sp)
    80001cca:	6402                	ld	s0,0(sp)
    80001ccc:	0141                	addi	sp,sp,16
    80001cce:	8082                	ret
        first = 0;
    80001cd0:	00007797          	auipc	a5,0x7
    80001cd4:	c207a823          	sw	zero,-976(a5) # 80008900 <first.1>
        fsinit(ROOTDEV);
    80001cd8:	4505                	li	a0,1
    80001cda:	00002097          	auipc	ra,0x2
    80001cde:	c6c080e7          	jalr	-916(ra) # 80003946 <fsinit>
    80001ce2:	bff9                	j	80001cc0 <forkret+0x22>

0000000080001ce4 <allocpid>:
{
    80001ce4:	1101                	addi	sp,sp,-32
    80001ce6:	ec06                	sd	ra,24(sp)
    80001ce8:	e822                	sd	s0,16(sp)
    80001cea:	e426                	sd	s1,8(sp)
    80001cec:	e04a                	sd	s2,0(sp)
    80001cee:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001cf0:	0000f917          	auipc	s2,0xf
    80001cf4:	37090913          	addi	s2,s2,880 # 80011060 <pid_lock>
    80001cf8:	854a                	mv	a0,s2
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	f22080e7          	jalr	-222(ra) # 80000c1c <acquire>
    pid = nextpid;
    80001d02:	00007797          	auipc	a5,0x7
    80001d06:	c0e78793          	addi	a5,a5,-1010 # 80008910 <nextpid>
    80001d0a:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001d0c:	0014871b          	addiw	a4,s1,1
    80001d10:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001d12:	854a                	mv	a0,s2
    80001d14:	fffff097          	auipc	ra,0xfffff
    80001d18:	fbc080e7          	jalr	-68(ra) # 80000cd0 <release>
}
    80001d1c:	8526                	mv	a0,s1
    80001d1e:	60e2                	ld	ra,24(sp)
    80001d20:	6442                	ld	s0,16(sp)
    80001d22:	64a2                	ld	s1,8(sp)
    80001d24:	6902                	ld	s2,0(sp)
    80001d26:	6105                	addi	sp,sp,32
    80001d28:	8082                	ret

0000000080001d2a <proc_pagetable>:
{
    80001d2a:	1101                	addi	sp,sp,-32
    80001d2c:	ec06                	sd	ra,24(sp)
    80001d2e:	e822                	sd	s0,16(sp)
    80001d30:	e426                	sd	s1,8(sp)
    80001d32:	e04a                	sd	s2,0(sp)
    80001d34:	1000                	addi	s0,sp,32
    80001d36:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001d38:	fffff097          	auipc	ra,0xfffff
    80001d3c:	636080e7          	jalr	1590(ra) # 8000136e <uvmcreate>
    80001d40:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001d42:	c121                	beqz	a0,80001d82 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001d44:	4729                	li	a4,10
    80001d46:	00005697          	auipc	a3,0x5
    80001d4a:	2ba68693          	addi	a3,a3,698 # 80007000 <_trampoline>
    80001d4e:	6605                	lui	a2,0x1
    80001d50:	040005b7          	lui	a1,0x4000
    80001d54:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d56:	05b2                	slli	a1,a1,0xc
    80001d58:	fffff097          	auipc	ra,0xfffff
    80001d5c:	38c080e7          	jalr	908(ra) # 800010e4 <mappages>
    80001d60:	02054863          	bltz	a0,80001d90 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d64:	4719                	li	a4,6
    80001d66:	06093683          	ld	a3,96(s2)
    80001d6a:	6605                	lui	a2,0x1
    80001d6c:	020005b7          	lui	a1,0x2000
    80001d70:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d72:	05b6                	slli	a1,a1,0xd
    80001d74:	8526                	mv	a0,s1
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	36e080e7          	jalr	878(ra) # 800010e4 <mappages>
    80001d7e:	02054163          	bltz	a0,80001da0 <proc_pagetable+0x76>
}
    80001d82:	8526                	mv	a0,s1
    80001d84:	60e2                	ld	ra,24(sp)
    80001d86:	6442                	ld	s0,16(sp)
    80001d88:	64a2                	ld	s1,8(sp)
    80001d8a:	6902                	ld	s2,0(sp)
    80001d8c:	6105                	addi	sp,sp,32
    80001d8e:	8082                	ret
        uvmfree(pagetable, 0);
    80001d90:	4581                	li	a1,0
    80001d92:	8526                	mv	a0,s1
    80001d94:	fffff097          	auipc	ra,0xfffff
    80001d98:	7e0080e7          	jalr	2016(ra) # 80001574 <uvmfree>
        return 0;
    80001d9c:	4481                	li	s1,0
    80001d9e:	b7d5                	j	80001d82 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001da0:	4681                	li	a3,0
    80001da2:	4605                	li	a2,1
    80001da4:	040005b7          	lui	a1,0x4000
    80001da8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001daa:	05b2                	slli	a1,a1,0xc
    80001dac:	8526                	mv	a0,s1
    80001dae:	fffff097          	auipc	ra,0xfffff
    80001db2:	4fc080e7          	jalr	1276(ra) # 800012aa <uvmunmap>
        uvmfree(pagetable, 0);
    80001db6:	4581                	li	a1,0
    80001db8:	8526                	mv	a0,s1
    80001dba:	fffff097          	auipc	ra,0xfffff
    80001dbe:	7ba080e7          	jalr	1978(ra) # 80001574 <uvmfree>
        return 0;
    80001dc2:	4481                	li	s1,0
    80001dc4:	bf7d                	j	80001d82 <proc_pagetable+0x58>

0000000080001dc6 <proc_freepagetable>:
{
    80001dc6:	1101                	addi	sp,sp,-32
    80001dc8:	ec06                	sd	ra,24(sp)
    80001dca:	e822                	sd	s0,16(sp)
    80001dcc:	e426                	sd	s1,8(sp)
    80001dce:	e04a                	sd	s2,0(sp)
    80001dd0:	1000                	addi	s0,sp,32
    80001dd2:	84aa                	mv	s1,a0
    80001dd4:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001dd6:	4681                	li	a3,0
    80001dd8:	4605                	li	a2,1
    80001dda:	040005b7          	lui	a1,0x4000
    80001dde:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001de0:	05b2                	slli	a1,a1,0xc
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	4c8080e7          	jalr	1224(ra) # 800012aa <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001dea:	4681                	li	a3,0
    80001dec:	4605                	li	a2,1
    80001dee:	020005b7          	lui	a1,0x2000
    80001df2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001df4:	05b6                	slli	a1,a1,0xd
    80001df6:	8526                	mv	a0,s1
    80001df8:	fffff097          	auipc	ra,0xfffff
    80001dfc:	4b2080e7          	jalr	1202(ra) # 800012aa <uvmunmap>
    uvmfree(pagetable, sz);
    80001e00:	85ca                	mv	a1,s2
    80001e02:	8526                	mv	a0,s1
    80001e04:	fffff097          	auipc	ra,0xfffff
    80001e08:	770080e7          	jalr	1904(ra) # 80001574 <uvmfree>
}
    80001e0c:	60e2                	ld	ra,24(sp)
    80001e0e:	6442                	ld	s0,16(sp)
    80001e10:	64a2                	ld	s1,8(sp)
    80001e12:	6902                	ld	s2,0(sp)
    80001e14:	6105                	addi	sp,sp,32
    80001e16:	8082                	ret

0000000080001e18 <freeproc>:
{
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	e426                	sd	s1,8(sp)
    80001e20:	1000                	addi	s0,sp,32
    80001e22:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001e24:	7128                	ld	a0,96(a0)
    80001e26:	c509                	beqz	a0,80001e30 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	c06080e7          	jalr	-1018(ra) # 80000a2e <kfree>
    p->trapframe = 0;
    80001e30:	0604b023          	sd	zero,96(s1)
    if (p->pagetable)
    80001e34:	6ca8                	ld	a0,88(s1)
    80001e36:	c511                	beqz	a0,80001e42 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001e38:	68ac                	ld	a1,80(s1)
    80001e3a:	00000097          	auipc	ra,0x0
    80001e3e:	f8c080e7          	jalr	-116(ra) # 80001dc6 <proc_freepagetable>
    p->pagetable = 0;
    80001e42:	0404bc23          	sd	zero,88(s1)
    p->sz = 0;
    80001e46:	0404b823          	sd	zero,80(s1)
    p->pid = 0;
    80001e4a:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001e4e:	0404b023          	sd	zero,64(s1)
    p->name[0] = 0;
    80001e52:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80001e56:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001e5a:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001e5e:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001e62:	0004ac23          	sw	zero,24(s1)
}
    80001e66:	60e2                	ld	ra,24(sp)
    80001e68:	6442                	ld	s0,16(sp)
    80001e6a:	64a2                	ld	s1,8(sp)
    80001e6c:	6105                	addi	sp,sp,32
    80001e6e:	8082                	ret

0000000080001e70 <allocproc>:
{
    80001e70:	1101                	addi	sp,sp,-32
    80001e72:	ec06                	sd	ra,24(sp)
    80001e74:	e822                	sd	s0,16(sp)
    80001e76:	e426                	sd	s1,8(sp)
    80001e78:	e04a                	sd	s2,0(sp)
    80001e7a:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001e7c:	0000f497          	auipc	s1,0xf
    80001e80:	21448493          	addi	s1,s1,532 # 80011090 <proc>
    80001e84:	00015917          	auipc	s2,0x15
    80001e88:	e0c90913          	addi	s2,s2,-500 # 80016c90 <tickslock>
        acquire(&p->lock);
    80001e8c:	8526                	mv	a0,s1
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	d8e080e7          	jalr	-626(ra) # 80000c1c <acquire>
        if (p->state == UNUSED)
    80001e96:	4c9c                	lw	a5,24(s1)
    80001e98:	cf81                	beqz	a5,80001eb0 <allocproc+0x40>
            release(&p->lock);
    80001e9a:	8526                	mv	a0,s1
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	e34080e7          	jalr	-460(ra) # 80000cd0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001ea4:	17048493          	addi	s1,s1,368
    80001ea8:	ff2492e3          	bne	s1,s2,80001e8c <allocproc+0x1c>
    return 0;
    80001eac:	4481                	li	s1,0
    80001eae:	a8a9                	j	80001f08 <allocproc+0x98>
    p->pid = allocpid();
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	e34080e7          	jalr	-460(ra) # 80001ce4 <allocpid>
    80001eb8:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001eba:	4785                	li	a5,1
    80001ebc:	cc9c                	sw	a5,24(s1)
    p->priority = 0;
    80001ebe:	0204aa23          	sw	zero,52(s1)
    p->promotion_timer = 0;
    80001ec2:	0204ac23          	sw	zero,56(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	c66080e7          	jalr	-922(ra) # 80000b2c <kalloc>
    80001ece:	892a                	mv	s2,a0
    80001ed0:	f0a8                	sd	a0,96(s1)
    80001ed2:	c131                	beqz	a0,80001f16 <allocproc+0xa6>
    p->pagetable = proc_pagetable(p);
    80001ed4:	8526                	mv	a0,s1
    80001ed6:	00000097          	auipc	ra,0x0
    80001eda:	e54080e7          	jalr	-428(ra) # 80001d2a <proc_pagetable>
    80001ede:	892a                	mv	s2,a0
    80001ee0:	eca8                	sd	a0,88(s1)
    if (p->pagetable == 0)
    80001ee2:	c531                	beqz	a0,80001f2e <allocproc+0xbe>
    memset(&p->context, 0, sizeof(p->context));
    80001ee4:	07000613          	li	a2,112
    80001ee8:	4581                	li	a1,0
    80001eea:	06848513          	addi	a0,s1,104
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	e2a080e7          	jalr	-470(ra) # 80000d18 <memset>
    p->context.ra = (uint64)forkret;
    80001ef6:	00000797          	auipc	a5,0x0
    80001efa:	da878793          	addi	a5,a5,-600 # 80001c9e <forkret>
    80001efe:	f4bc                	sd	a5,104(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001f00:	64bc                	ld	a5,72(s1)
    80001f02:	6705                	lui	a4,0x1
    80001f04:	97ba                	add	a5,a5,a4
    80001f06:	f8bc                	sd	a5,112(s1)
}
    80001f08:	8526                	mv	a0,s1
    80001f0a:	60e2                	ld	ra,24(sp)
    80001f0c:	6442                	ld	s0,16(sp)
    80001f0e:	64a2                	ld	s1,8(sp)
    80001f10:	6902                	ld	s2,0(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret
        freeproc(p);
    80001f16:	8526                	mv	a0,s1
    80001f18:	00000097          	auipc	ra,0x0
    80001f1c:	f00080e7          	jalr	-256(ra) # 80001e18 <freeproc>
        release(&p->lock);
    80001f20:	8526                	mv	a0,s1
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	dae080e7          	jalr	-594(ra) # 80000cd0 <release>
        return 0;
    80001f2a:	84ca                	mv	s1,s2
    80001f2c:	bff1                	j	80001f08 <allocproc+0x98>
        freeproc(p);
    80001f2e:	8526                	mv	a0,s1
    80001f30:	00000097          	auipc	ra,0x0
    80001f34:	ee8080e7          	jalr	-280(ra) # 80001e18 <freeproc>
        release(&p->lock);
    80001f38:	8526                	mv	a0,s1
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	d96080e7          	jalr	-618(ra) # 80000cd0 <release>
        return 0;
    80001f42:	84ca                	mv	s1,s2
    80001f44:	b7d1                	j	80001f08 <allocproc+0x98>

0000000080001f46 <userinit>:
{
    80001f46:	1101                	addi	sp,sp,-32
    80001f48:	ec06                	sd	ra,24(sp)
    80001f4a:	e822                	sd	s0,16(sp)
    80001f4c:	e426                	sd	s1,8(sp)
    80001f4e:	1000                	addi	s0,sp,32
    p = allocproc();
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	f20080e7          	jalr	-224(ra) # 80001e70 <allocproc>
    80001f58:	84aa                	mv	s1,a0
    initproc = p;
    80001f5a:	00007797          	auipc	a5,0x7
    80001f5e:	a8a7b723          	sd	a0,-1394(a5) # 800089e8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f62:	03400613          	li	a2,52
    80001f66:	00007597          	auipc	a1,0x7
    80001f6a:	9ba58593          	addi	a1,a1,-1606 # 80008920 <initcode>
    80001f6e:	6d28                	ld	a0,88(a0)
    80001f70:	fffff097          	auipc	ra,0xfffff
    80001f74:	42c080e7          	jalr	1068(ra) # 8000139c <uvmfirst>
    p->sz = PGSIZE;
    80001f78:	6785                	lui	a5,0x1
    80001f7a:	e8bc                	sd	a5,80(s1)
    p->trapframe->epc = 0;     // user program counter
    80001f7c:	70b8                	ld	a4,96(s1)
    80001f7e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001f82:	70b8                	ld	a4,96(s1)
    80001f84:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f86:	4641                	li	a2,16
    80001f88:	00006597          	auipc	a1,0x6
    80001f8c:	27858593          	addi	a1,a1,632 # 80008200 <digits+0x1c0>
    80001f90:	16048513          	addi	a0,s1,352
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	ece080e7          	jalr	-306(ra) # 80000e62 <safestrcpy>
    p->cwd = namei("/");
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	27450513          	addi	a0,a0,628 # 80008210 <digits+0x1d0>
    80001fa4:	00002097          	auipc	ra,0x2
    80001fa8:	3cc080e7          	jalr	972(ra) # 80004370 <namei>
    80001fac:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    80001fb0:	478d                	li	a5,3
    80001fb2:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	d1a080e7          	jalr	-742(ra) # 80000cd0 <release>
}
    80001fbe:	60e2                	ld	ra,24(sp)
    80001fc0:	6442                	ld	s0,16(sp)
    80001fc2:	64a2                	ld	s1,8(sp)
    80001fc4:	6105                	addi	sp,sp,32
    80001fc6:	8082                	ret

0000000080001fc8 <growproc>:
{
    80001fc8:	1101                	addi	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	e426                	sd	s1,8(sp)
    80001fd0:	e04a                	sd	s2,0(sp)
    80001fd2:	1000                	addi	s0,sp,32
    80001fd4:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	c90080e7          	jalr	-880(ra) # 80001c66 <myproc>
    80001fde:	84aa                	mv	s1,a0
    sz = p->sz;
    80001fe0:	692c                	ld	a1,80(a0)
    if (n > 0)
    80001fe2:	01204c63          	bgtz	s2,80001ffa <growproc+0x32>
    else if (n < 0)
    80001fe6:	02094663          	bltz	s2,80002012 <growproc+0x4a>
    p->sz = sz;
    80001fea:	e8ac                	sd	a1,80(s1)
    return 0;
    80001fec:	4501                	li	a0,0
}
    80001fee:	60e2                	ld	ra,24(sp)
    80001ff0:	6442                	ld	s0,16(sp)
    80001ff2:	64a2                	ld	s1,8(sp)
    80001ff4:	6902                	ld	s2,0(sp)
    80001ff6:	6105                	addi	sp,sp,32
    80001ff8:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001ffa:	4691                	li	a3,4
    80001ffc:	00b90633          	add	a2,s2,a1
    80002000:	6d28                	ld	a0,88(a0)
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	454080e7          	jalr	1108(ra) # 80001456 <uvmalloc>
    8000200a:	85aa                	mv	a1,a0
    8000200c:	fd79                	bnez	a0,80001fea <growproc+0x22>
            return -1;
    8000200e:	557d                	li	a0,-1
    80002010:	bff9                	j	80001fee <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002012:	00b90633          	add	a2,s2,a1
    80002016:	6d28                	ld	a0,88(a0)
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	3f6080e7          	jalr	1014(ra) # 8000140e <uvmdealloc>
    80002020:	85aa                	mv	a1,a0
    80002022:	b7e1                	j	80001fea <growproc+0x22>

0000000080002024 <ps>:
{
    80002024:	715d                	addi	sp,sp,-80
    80002026:	e486                	sd	ra,72(sp)
    80002028:	e0a2                	sd	s0,64(sp)
    8000202a:	fc26                	sd	s1,56(sp)
    8000202c:	f84a                	sd	s2,48(sp)
    8000202e:	f44e                	sd	s3,40(sp)
    80002030:	f052                	sd	s4,32(sp)
    80002032:	ec56                	sd	s5,24(sp)
    80002034:	e85a                	sd	s6,16(sp)
    80002036:	e45e                	sd	s7,8(sp)
    80002038:	e062                	sd	s8,0(sp)
    8000203a:	0880                	addi	s0,sp,80
    8000203c:	84aa                	mv	s1,a0
    8000203e:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    80002040:	00000097          	auipc	ra,0x0
    80002044:	c26080e7          	jalr	-986(ra) # 80001c66 <myproc>
    if (count == 0)
    80002048:	120b8063          	beqz	s7,80002168 <ps+0x144>
    void *result = (void *)myproc()->sz;
    8000204c:	05053b03          	ld	s6,80(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80002050:	003b951b          	slliw	a0,s7,0x3
    80002054:	0175053b          	addw	a0,a0,s7
    80002058:	0025151b          	slliw	a0,a0,0x2
    8000205c:	00000097          	auipc	ra,0x0
    80002060:	f6c080e7          	jalr	-148(ra) # 80001fc8 <growproc>
    80002064:	10054463          	bltz	a0,8000216c <ps+0x148>
    struct user_proc loc_result[count];
    80002068:	003b9a13          	slli	s4,s7,0x3
    8000206c:	9a5e                	add	s4,s4,s7
    8000206e:	0a0a                	slli	s4,s4,0x2
    80002070:	00fa0793          	addi	a5,s4,15
    80002074:	8391                	srli	a5,a5,0x4
    80002076:	0792                	slli	a5,a5,0x4
    80002078:	40f10133          	sub	sp,sp,a5
    8000207c:	8a8a                	mv	s5,sp
    struct proc *p = proc + (start * sizeof(proc));
    8000207e:	008447b7          	lui	a5,0x844
    80002082:	02f484b3          	mul	s1,s1,a5
    80002086:	0000f797          	auipc	a5,0xf
    8000208a:	00a78793          	addi	a5,a5,10 # 80011090 <proc>
    8000208e:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80002090:	00015797          	auipc	a5,0x15
    80002094:	c0078793          	addi	a5,a5,-1024 # 80016c90 <tickslock>
    80002098:	0cf4fc63          	bgeu	s1,a5,80002170 <ps+0x14c>
    8000209c:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    800020a0:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    800020a2:	8c3e                	mv	s8,a5
    800020a4:	a069                	j	8000212e <ps+0x10a>
            loc_result[localCount].state = UNUSED;
    800020a6:	00399793          	slli	a5,s3,0x3
    800020aa:	97ce                	add	a5,a5,s3
    800020ac:	078a                	slli	a5,a5,0x2
    800020ae:	97d6                	add	a5,a5,s5
    800020b0:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    800020b4:	8526                	mv	a0,s1
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	c1a080e7          	jalr	-998(ra) # 80000cd0 <release>
    if (localCount < count)
    800020be:	0179f963          	bgeu	s3,s7,800020d0 <ps+0xac>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    800020c2:	00399793          	slli	a5,s3,0x3
    800020c6:	97ce                	add	a5,a5,s3
    800020c8:	078a                	slli	a5,a5,0x2
    800020ca:	97d6                	add	a5,a5,s5
    800020cc:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    800020d0:	84da                	mv	s1,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    800020d2:	00000097          	auipc	ra,0x0
    800020d6:	b94080e7          	jalr	-1132(ra) # 80001c66 <myproc>
    800020da:	86d2                	mv	a3,s4
    800020dc:	8656                	mv	a2,s5
    800020de:	85da                	mv	a1,s6
    800020e0:	6d28                	ld	a0,88(a0)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	5d0080e7          	jalr	1488(ra) # 800016b2 <copyout>
}
    800020ea:	8526                	mv	a0,s1
    800020ec:	fb040113          	addi	sp,s0,-80
    800020f0:	60a6                	ld	ra,72(sp)
    800020f2:	6406                	ld	s0,64(sp)
    800020f4:	74e2                	ld	s1,56(sp)
    800020f6:	7942                	ld	s2,48(sp)
    800020f8:	79a2                	ld	s3,40(sp)
    800020fa:	7a02                	ld	s4,32(sp)
    800020fc:	6ae2                	ld	s5,24(sp)
    800020fe:	6b42                	ld	s6,16(sp)
    80002100:	6ba2                	ld	s7,8(sp)
    80002102:	6c02                	ld	s8,0(sp)
    80002104:	6161                	addi	sp,sp,80
    80002106:	8082                	ret
            loc_result[localCount].parent_id = p->parent->pid;
    80002108:	5b9c                	lw	a5,48(a5)
    8000210a:	fef92e23          	sw	a5,-4(s2)
        release(&p->lock);
    8000210e:	8526                	mv	a0,s1
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	bc0080e7          	jalr	-1088(ra) # 80000cd0 <release>
        localCount++;
    80002118:	2985                	addiw	s3,s3,1
    8000211a:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    8000211e:	17048493          	addi	s1,s1,368
    80002122:	f984fee3          	bgeu	s1,s8,800020be <ps+0x9a>
        if (localCount == count)
    80002126:	02490913          	addi	s2,s2,36
    8000212a:	fb3b83e3          	beq	s7,s3,800020d0 <ps+0xac>
        acquire(&p->lock);
    8000212e:	8526                	mv	a0,s1
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	aec080e7          	jalr	-1300(ra) # 80000c1c <acquire>
        if (p->state == UNUSED)
    80002138:	4c9c                	lw	a5,24(s1)
    8000213a:	d7b5                	beqz	a5,800020a6 <ps+0x82>
        loc_result[localCount].state = p->state;
    8000213c:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002140:	549c                	lw	a5,40(s1)
    80002142:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002146:	54dc                	lw	a5,44(s1)
    80002148:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    8000214c:	589c                	lw	a5,48(s1)
    8000214e:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002152:	4641                	li	a2,16
    80002154:	85ca                	mv	a1,s2
    80002156:	16048513          	addi	a0,s1,352
    8000215a:	00000097          	auipc	ra,0x0
    8000215e:	ab2080e7          	jalr	-1358(ra) # 80001c0c <copy_array>
        if (p->parent != 0) // init
    80002162:	60bc                	ld	a5,64(s1)
    80002164:	f3d5                	bnez	a5,80002108 <ps+0xe4>
    80002166:	b765                	j	8000210e <ps+0xea>
        return 0;
    80002168:	4481                	li	s1,0
    8000216a:	b741                	j	800020ea <ps+0xc6>
        return 0;
    8000216c:	4481                	li	s1,0
    8000216e:	bfb5                	j	800020ea <ps+0xc6>
        return result;
    80002170:	4481                	li	s1,0
    80002172:	bfa5                	j	800020ea <ps+0xc6>

0000000080002174 <fork>:
{
    80002174:	7139                	addi	sp,sp,-64
    80002176:	fc06                	sd	ra,56(sp)
    80002178:	f822                	sd	s0,48(sp)
    8000217a:	f426                	sd	s1,40(sp)
    8000217c:	f04a                	sd	s2,32(sp)
    8000217e:	ec4e                	sd	s3,24(sp)
    80002180:	e852                	sd	s4,16(sp)
    80002182:	e456                	sd	s5,8(sp)
    80002184:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	ae0080e7          	jalr	-1312(ra) # 80001c66 <myproc>
    8000218e:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    80002190:	00000097          	auipc	ra,0x0
    80002194:	ce0080e7          	jalr	-800(ra) # 80001e70 <allocproc>
    80002198:	10050c63          	beqz	a0,800022b0 <fork+0x13c>
    8000219c:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000219e:	050ab603          	ld	a2,80(s5)
    800021a2:	6d2c                	ld	a1,88(a0)
    800021a4:	058ab503          	ld	a0,88(s5)
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	406080e7          	jalr	1030(ra) # 800015ae <uvmcopy>
    800021b0:	04054863          	bltz	a0,80002200 <fork+0x8c>
    np->sz = p->sz;
    800021b4:	050ab783          	ld	a5,80(s5)
    800021b8:	04fa3823          	sd	a5,80(s4)
    *(np->trapframe) = *(p->trapframe);
    800021bc:	060ab683          	ld	a3,96(s5)
    800021c0:	87b6                	mv	a5,a3
    800021c2:	060a3703          	ld	a4,96(s4)
    800021c6:	12068693          	addi	a3,a3,288
    800021ca:	0007b803          	ld	a6,0(a5)
    800021ce:	6788                	ld	a0,8(a5)
    800021d0:	6b8c                	ld	a1,16(a5)
    800021d2:	6f90                	ld	a2,24(a5)
    800021d4:	01073023          	sd	a6,0(a4)
    800021d8:	e708                	sd	a0,8(a4)
    800021da:	eb0c                	sd	a1,16(a4)
    800021dc:	ef10                	sd	a2,24(a4)
    800021de:	02078793          	addi	a5,a5,32
    800021e2:	02070713          	addi	a4,a4,32
    800021e6:	fed792e3          	bne	a5,a3,800021ca <fork+0x56>
    np->trapframe->a0 = 0;
    800021ea:	060a3783          	ld	a5,96(s4)
    800021ee:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800021f2:	0d8a8493          	addi	s1,s5,216
    800021f6:	0d8a0913          	addi	s2,s4,216
    800021fa:	158a8993          	addi	s3,s5,344
    800021fe:	a00d                	j	80002220 <fork+0xac>
        freeproc(np);
    80002200:	8552                	mv	a0,s4
    80002202:	00000097          	auipc	ra,0x0
    80002206:	c16080e7          	jalr	-1002(ra) # 80001e18 <freeproc>
        release(&np->lock);
    8000220a:	8552                	mv	a0,s4
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	ac4080e7          	jalr	-1340(ra) # 80000cd0 <release>
        return -1;
    80002214:	597d                	li	s2,-1
    80002216:	a059                	j	8000229c <fork+0x128>
    for (i = 0; i < NOFILE; i++)
    80002218:	04a1                	addi	s1,s1,8
    8000221a:	0921                	addi	s2,s2,8
    8000221c:	01348b63          	beq	s1,s3,80002232 <fork+0xbe>
        if (p->ofile[i])
    80002220:	6088                	ld	a0,0(s1)
    80002222:	d97d                	beqz	a0,80002218 <fork+0xa4>
            np->ofile[i] = filedup(p->ofile[i]);
    80002224:	00002097          	auipc	ra,0x2
    80002228:	7e2080e7          	jalr	2018(ra) # 80004a06 <filedup>
    8000222c:	00a93023          	sd	a0,0(s2)
    80002230:	b7e5                	j	80002218 <fork+0xa4>
    np->cwd = idup(p->cwd);
    80002232:	158ab503          	ld	a0,344(s5)
    80002236:	00002097          	auipc	ra,0x2
    8000223a:	950080e7          	jalr	-1712(ra) # 80003b86 <idup>
    8000223e:	14aa3c23          	sd	a0,344(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002242:	4641                	li	a2,16
    80002244:	160a8593          	addi	a1,s5,352
    80002248:	160a0513          	addi	a0,s4,352
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	c16080e7          	jalr	-1002(ra) # 80000e62 <safestrcpy>
    pid = np->pid;
    80002254:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80002258:	8552                	mv	a0,s4
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	a76080e7          	jalr	-1418(ra) # 80000cd0 <release>
    acquire(&wait_lock);
    80002262:	0000f497          	auipc	s1,0xf
    80002266:	e1648493          	addi	s1,s1,-490 # 80011078 <wait_lock>
    8000226a:	8526                	mv	a0,s1
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	9b0080e7          	jalr	-1616(ra) # 80000c1c <acquire>
    np->parent = p;
    80002274:	055a3023          	sd	s5,64(s4)
    release(&wait_lock);
    80002278:	8526                	mv	a0,s1
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	a56080e7          	jalr	-1450(ra) # 80000cd0 <release>
    acquire(&np->lock);
    80002282:	8552                	mv	a0,s4
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	998080e7          	jalr	-1640(ra) # 80000c1c <acquire>
    np->state = RUNNABLE;
    8000228c:	478d                	li	a5,3
    8000228e:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80002292:	8552                	mv	a0,s4
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	a3c080e7          	jalr	-1476(ra) # 80000cd0 <release>
}
    8000229c:	854a                	mv	a0,s2
    8000229e:	70e2                	ld	ra,56(sp)
    800022a0:	7442                	ld	s0,48(sp)
    800022a2:	74a2                	ld	s1,40(sp)
    800022a4:	7902                	ld	s2,32(sp)
    800022a6:	69e2                	ld	s3,24(sp)
    800022a8:	6a42                	ld	s4,16(sp)
    800022aa:	6aa2                	ld	s5,8(sp)
    800022ac:	6121                	addi	sp,sp,64
    800022ae:	8082                	ret
        return -1;
    800022b0:	597d                	li	s2,-1
    800022b2:	b7ed                	j	8000229c <fork+0x128>

00000000800022b4 <scheduler>:
{
    800022b4:	1101                	addi	sp,sp,-32
    800022b6:	ec06                	sd	ra,24(sp)
    800022b8:	e822                	sd	s0,16(sp)
    800022ba:	e426                	sd	s1,8(sp)
    800022bc:	1000                	addi	s0,sp,32
        (*sched_pointer)();
    800022be:	00006497          	auipc	s1,0x6
    800022c2:	64a48493          	addi	s1,s1,1610 # 80008908 <sched_pointer>
    800022c6:	609c                	ld	a5,0(s1)
    800022c8:	9782                	jalr	a5
    while (1)
    800022ca:	bff5                	j	800022c6 <scheduler+0x12>

00000000800022cc <sched>:
{
    800022cc:	7179                	addi	sp,sp,-48
    800022ce:	f406                	sd	ra,40(sp)
    800022d0:	f022                	sd	s0,32(sp)
    800022d2:	ec26                	sd	s1,24(sp)
    800022d4:	e84a                	sd	s2,16(sp)
    800022d6:	e44e                	sd	s3,8(sp)
    800022d8:	1800                	addi	s0,sp,48
    for (p = proc; p < &proc[NPROC]; p++)
    800022da:	0000f797          	auipc	a5,0xf
    800022de:	db678793          	addi	a5,a5,-586 # 80011090 <proc>
    800022e2:	00015697          	auipc	a3,0x15
    800022e6:	9ae68693          	addi	a3,a3,-1618 # 80016c90 <tickslock>
    800022ea:	a029                	j	800022f4 <sched+0x28>
    800022ec:	17078793          	addi	a5,a5,368
    800022f0:	00d78d63          	beq	a5,a3,8000230a <sched+0x3e>
        if (p->priority > 0 && --p->promotion_timer == 0) // using short-ciruit evaluation
    800022f4:	5bd8                	lw	a4,52(a5)
    800022f6:	db7d                	beqz	a4,800022ec <sched+0x20>
    800022f8:	5f98                	lw	a4,56(a5)
    800022fa:	377d                	addiw	a4,a4,-1
    800022fc:	0007061b          	sext.w	a2,a4
    80002300:	df98                	sw	a4,56(a5)
    80002302:	f66d                	bnez	a2,800022ec <sched+0x20>
            p->priority = 0; // we only have two priorities in our scheduler
    80002304:	0207aa23          	sw	zero,52(a5)
    80002308:	b7d5                	j	800022ec <sched+0x20>
    p = myproc();
    8000230a:	00000097          	auipc	ra,0x0
    8000230e:	95c080e7          	jalr	-1700(ra) # 80001c66 <myproc>
    80002312:	892a                	mv	s2,a0
    if (!holding(&p->lock))
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	88e080e7          	jalr	-1906(ra) # 80000ba2 <holding>
    8000231c:	c925                	beqz	a0,8000238c <sched+0xc0>
    8000231e:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002320:	2781                	sext.w	a5,a5
    80002322:	079e                	slli	a5,a5,0x7
    80002324:	0000f717          	auipc	a4,0xf
    80002328:	93c70713          	addi	a4,a4,-1732 # 80010c60 <cpus>
    8000232c:	97ba                	add	a5,a5,a4
    8000232e:	5fb8                	lw	a4,120(a5)
    80002330:	4785                	li	a5,1
    80002332:	06f71563          	bne	a4,a5,8000239c <sched+0xd0>
    if (p->state == RUNNING)
    80002336:	01892703          	lw	a4,24(s2)
    8000233a:	4791                	li	a5,4
    8000233c:	06f70863          	beq	a4,a5,800023ac <sched+0xe0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002340:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002344:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002346:	ebbd                	bnez	a5,800023bc <sched+0xf0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002348:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    8000234a:	0000f497          	auipc	s1,0xf
    8000234e:	91648493          	addi	s1,s1,-1770 # 80010c60 <cpus>
    80002352:	2781                	sext.w	a5,a5
    80002354:	079e                	slli	a5,a5,0x7
    80002356:	97a6                	add	a5,a5,s1
    80002358:	07c7a983          	lw	s3,124(a5)
    8000235c:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000235e:	2581                	sext.w	a1,a1
    80002360:	059e                	slli	a1,a1,0x7
    80002362:	05a1                	addi	a1,a1,8
    80002364:	95a6                	add	a1,a1,s1
    80002366:	06890513          	addi	a0,s2,104
    8000236a:	00000097          	auipc	ra,0x0
    8000236e:	754080e7          	jalr	1876(ra) # 80002abe <swtch>
    80002372:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002374:	2781                	sext.w	a5,a5
    80002376:	079e                	slli	a5,a5,0x7
    80002378:	94be                	add	s1,s1,a5
    8000237a:	0734ae23          	sw	s3,124(s1)
}
    8000237e:	70a2                	ld	ra,40(sp)
    80002380:	7402                	ld	s0,32(sp)
    80002382:	64e2                	ld	s1,24(sp)
    80002384:	6942                	ld	s2,16(sp)
    80002386:	69a2                	ld	s3,8(sp)
    80002388:	6145                	addi	sp,sp,48
    8000238a:	8082                	ret
        panic("sched p->lock");
    8000238c:	00006517          	auipc	a0,0x6
    80002390:	e8c50513          	addi	a0,a0,-372 # 80008218 <digits+0x1d8>
    80002394:	ffffe097          	auipc	ra,0xffffe
    80002398:	1f2080e7          	jalr	498(ra) # 80000586 <panic>
        panic("sched locks");
    8000239c:	00006517          	auipc	a0,0x6
    800023a0:	e8c50513          	addi	a0,a0,-372 # 80008228 <digits+0x1e8>
    800023a4:	ffffe097          	auipc	ra,0xffffe
    800023a8:	1e2080e7          	jalr	482(ra) # 80000586 <panic>
        panic("sched running");
    800023ac:	00006517          	auipc	a0,0x6
    800023b0:	e8c50513          	addi	a0,a0,-372 # 80008238 <digits+0x1f8>
    800023b4:	ffffe097          	auipc	ra,0xffffe
    800023b8:	1d2080e7          	jalr	466(ra) # 80000586 <panic>
        panic("sched interruptible");
    800023bc:	00006517          	auipc	a0,0x6
    800023c0:	e8c50513          	addi	a0,a0,-372 # 80008248 <digits+0x208>
    800023c4:	ffffe097          	auipc	ra,0xffffe
    800023c8:	1c2080e7          	jalr	450(ra) # 80000586 <panic>

00000000800023cc <yield>:
{
    800023cc:	1101                	addi	sp,sp,-32
    800023ce:	ec06                	sd	ra,24(sp)
    800023d0:	e822                	sd	s0,16(sp)
    800023d2:	e426                	sd	s1,8(sp)
    800023d4:	e04a                	sd	s2,0(sp)
    800023d6:	1000                	addi	s0,sp,32
    800023d8:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800023da:	00000097          	auipc	ra,0x0
    800023de:	88c080e7          	jalr	-1908(ra) # 80001c66 <myproc>
    800023e2:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	838080e7          	jalr	-1992(ra) # 80000c1c <acquire>
    p->state = RUNNABLE;
    800023ec:	478d                	li	a5,3
    800023ee:	cc9c                	sw	a5,24(s1)
    if (reason == YIELD_TIMER)
    800023f0:	4785                	li	a5,1
    800023f2:	02f90163          	beq	s2,a5,80002414 <yield+0x48>
    sched();
    800023f6:	00000097          	auipc	ra,0x0
    800023fa:	ed6080e7          	jalr	-298(ra) # 800022cc <sched>
    release(&p->lock);
    800023fe:	8526                	mv	a0,s1
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	8d0080e7          	jalr	-1840(ra) # 80000cd0 <release>
}
    80002408:	60e2                	ld	ra,24(sp)
    8000240a:	6442                	ld	s0,16(sp)
    8000240c:	64a2                	ld	s1,8(sp)
    8000240e:	6902                	ld	s2,0(sp)
    80002410:	6105                	addi	sp,sp,32
    80002412:	8082                	ret
        p->priority = (p->priority + 1 > MAX_PRIO ? p->priority : (p->priority + 1));
    80002414:	58dc                	lw	a5,52(s1)
    80002416:	0017871b          	addiw	a4,a5,1
    8000241a:	4685                	li	a3,1
    8000241c:	00e6f663          	bgeu	a3,a4,80002428 <yield+0x5c>
    80002420:	d8dc                	sw	a5,52(s1)
        p->promotion_timer = PROM_TIME;
    80002422:	4795                	li	a5,5
    80002424:	dc9c                	sw	a5,56(s1)
    80002426:	bfc1                	j	800023f6 <yield+0x2a>
        p->priority = (p->priority + 1 > MAX_PRIO ? p->priority : (p->priority + 1));
    80002428:	87ba                	mv	a5,a4
    8000242a:	bfdd                	j	80002420 <yield+0x54>

000000008000242c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000242c:	7179                	addi	sp,sp,-48
    8000242e:	f406                	sd	ra,40(sp)
    80002430:	f022                	sd	s0,32(sp)
    80002432:	ec26                	sd	s1,24(sp)
    80002434:	e84a                	sd	s2,16(sp)
    80002436:	e44e                	sd	s3,8(sp)
    80002438:	1800                	addi	s0,sp,48
    8000243a:	89aa                	mv	s3,a0
    8000243c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000243e:	00000097          	auipc	ra,0x0
    80002442:	828080e7          	jalr	-2008(ra) # 80001c66 <myproc>
    80002446:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002448:	ffffe097          	auipc	ra,0xffffe
    8000244c:	7d4080e7          	jalr	2004(ra) # 80000c1c <acquire>
    release(lk);
    80002450:	854a                	mv	a0,s2
    80002452:	fffff097          	auipc	ra,0xfffff
    80002456:	87e080e7          	jalr	-1922(ra) # 80000cd0 <release>

    // Go to sleep.
    p->chan = chan;
    8000245a:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000245e:	4789                	li	a5,2
    80002460:	cc9c                	sw	a5,24(s1)

    sched();
    80002462:	00000097          	auipc	ra,0x0
    80002466:	e6a080e7          	jalr	-406(ra) # 800022cc <sched>

    // Tidy up.
    p->chan = 0;
    8000246a:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000246e:	8526                	mv	a0,s1
    80002470:	fffff097          	auipc	ra,0xfffff
    80002474:	860080e7          	jalr	-1952(ra) # 80000cd0 <release>
    acquire(lk);
    80002478:	854a                	mv	a0,s2
    8000247a:	ffffe097          	auipc	ra,0xffffe
    8000247e:	7a2080e7          	jalr	1954(ra) # 80000c1c <acquire>
}
    80002482:	70a2                	ld	ra,40(sp)
    80002484:	7402                	ld	s0,32(sp)
    80002486:	64e2                	ld	s1,24(sp)
    80002488:	6942                	ld	s2,16(sp)
    8000248a:	69a2                	ld	s3,8(sp)
    8000248c:	6145                	addi	sp,sp,48
    8000248e:	8082                	ret

0000000080002490 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002490:	7139                	addi	sp,sp,-64
    80002492:	fc06                	sd	ra,56(sp)
    80002494:	f822                	sd	s0,48(sp)
    80002496:	f426                	sd	s1,40(sp)
    80002498:	f04a                	sd	s2,32(sp)
    8000249a:	ec4e                	sd	s3,24(sp)
    8000249c:	e852                	sd	s4,16(sp)
    8000249e:	e456                	sd	s5,8(sp)
    800024a0:	0080                	addi	s0,sp,64
    800024a2:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800024a4:	0000f497          	auipc	s1,0xf
    800024a8:	bec48493          	addi	s1,s1,-1044 # 80011090 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800024ac:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800024ae:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800024b0:	00014917          	auipc	s2,0x14
    800024b4:	7e090913          	addi	s2,s2,2016 # 80016c90 <tickslock>
    800024b8:	a811                	j	800024cc <wakeup+0x3c>
            }
            release(&p->lock);
    800024ba:	8526                	mv	a0,s1
    800024bc:	fffff097          	auipc	ra,0xfffff
    800024c0:	814080e7          	jalr	-2028(ra) # 80000cd0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800024c4:	17048493          	addi	s1,s1,368
    800024c8:	03248663          	beq	s1,s2,800024f4 <wakeup+0x64>
        if (p != myproc())
    800024cc:	fffff097          	auipc	ra,0xfffff
    800024d0:	79a080e7          	jalr	1946(ra) # 80001c66 <myproc>
    800024d4:	fea488e3          	beq	s1,a0,800024c4 <wakeup+0x34>
            acquire(&p->lock);
    800024d8:	8526                	mv	a0,s1
    800024da:	ffffe097          	auipc	ra,0xffffe
    800024de:	742080e7          	jalr	1858(ra) # 80000c1c <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800024e2:	4c9c                	lw	a5,24(s1)
    800024e4:	fd379be3          	bne	a5,s3,800024ba <wakeup+0x2a>
    800024e8:	709c                	ld	a5,32(s1)
    800024ea:	fd4798e3          	bne	a5,s4,800024ba <wakeup+0x2a>
                p->state = RUNNABLE;
    800024ee:	0154ac23          	sw	s5,24(s1)
    800024f2:	b7e1                	j	800024ba <wakeup+0x2a>
        }
    }
}
    800024f4:	70e2                	ld	ra,56(sp)
    800024f6:	7442                	ld	s0,48(sp)
    800024f8:	74a2                	ld	s1,40(sp)
    800024fa:	7902                	ld	s2,32(sp)
    800024fc:	69e2                	ld	s3,24(sp)
    800024fe:	6a42                	ld	s4,16(sp)
    80002500:	6aa2                	ld	s5,8(sp)
    80002502:	6121                	addi	sp,sp,64
    80002504:	8082                	ret

0000000080002506 <reparent>:
{
    80002506:	7179                	addi	sp,sp,-48
    80002508:	f406                	sd	ra,40(sp)
    8000250a:	f022                	sd	s0,32(sp)
    8000250c:	ec26                	sd	s1,24(sp)
    8000250e:	e84a                	sd	s2,16(sp)
    80002510:	e44e                	sd	s3,8(sp)
    80002512:	e052                	sd	s4,0(sp)
    80002514:	1800                	addi	s0,sp,48
    80002516:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002518:	0000f497          	auipc	s1,0xf
    8000251c:	b7848493          	addi	s1,s1,-1160 # 80011090 <proc>
            pp->parent = initproc;
    80002520:	00006a17          	auipc	s4,0x6
    80002524:	4c8a0a13          	addi	s4,s4,1224 # 800089e8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002528:	00014997          	auipc	s3,0x14
    8000252c:	76898993          	addi	s3,s3,1896 # 80016c90 <tickslock>
    80002530:	a029                	j	8000253a <reparent+0x34>
    80002532:	17048493          	addi	s1,s1,368
    80002536:	01348d63          	beq	s1,s3,80002550 <reparent+0x4a>
        if (pp->parent == p)
    8000253a:	60bc                	ld	a5,64(s1)
    8000253c:	ff279be3          	bne	a5,s2,80002532 <reparent+0x2c>
            pp->parent = initproc;
    80002540:	000a3503          	ld	a0,0(s4)
    80002544:	e0a8                	sd	a0,64(s1)
            wakeup(initproc);
    80002546:	00000097          	auipc	ra,0x0
    8000254a:	f4a080e7          	jalr	-182(ra) # 80002490 <wakeup>
    8000254e:	b7d5                	j	80002532 <reparent+0x2c>
}
    80002550:	70a2                	ld	ra,40(sp)
    80002552:	7402                	ld	s0,32(sp)
    80002554:	64e2                	ld	s1,24(sp)
    80002556:	6942                	ld	s2,16(sp)
    80002558:	69a2                	ld	s3,8(sp)
    8000255a:	6a02                	ld	s4,0(sp)
    8000255c:	6145                	addi	sp,sp,48
    8000255e:	8082                	ret

0000000080002560 <exit>:
{
    80002560:	7179                	addi	sp,sp,-48
    80002562:	f406                	sd	ra,40(sp)
    80002564:	f022                	sd	s0,32(sp)
    80002566:	ec26                	sd	s1,24(sp)
    80002568:	e84a                	sd	s2,16(sp)
    8000256a:	e44e                	sd	s3,8(sp)
    8000256c:	e052                	sd	s4,0(sp)
    8000256e:	1800                	addi	s0,sp,48
    80002570:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80002572:	fffff097          	auipc	ra,0xfffff
    80002576:	6f4080e7          	jalr	1780(ra) # 80001c66 <myproc>
    8000257a:	89aa                	mv	s3,a0
    if (p == initproc)
    8000257c:	00006797          	auipc	a5,0x6
    80002580:	46c7b783          	ld	a5,1132(a5) # 800089e8 <initproc>
    80002584:	0d850493          	addi	s1,a0,216
    80002588:	15850913          	addi	s2,a0,344
    8000258c:	02a79363          	bne	a5,a0,800025b2 <exit+0x52>
        panic("init exiting");
    80002590:	00006517          	auipc	a0,0x6
    80002594:	cd050513          	addi	a0,a0,-816 # 80008260 <digits+0x220>
    80002598:	ffffe097          	auipc	ra,0xffffe
    8000259c:	fee080e7          	jalr	-18(ra) # 80000586 <panic>
            fileclose(f);
    800025a0:	00002097          	auipc	ra,0x2
    800025a4:	4b8080e7          	jalr	1208(ra) # 80004a58 <fileclose>
            p->ofile[fd] = 0;
    800025a8:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    800025ac:	04a1                	addi	s1,s1,8
    800025ae:	01248563          	beq	s1,s2,800025b8 <exit+0x58>
        if (p->ofile[fd])
    800025b2:	6088                	ld	a0,0(s1)
    800025b4:	f575                	bnez	a0,800025a0 <exit+0x40>
    800025b6:	bfdd                	j	800025ac <exit+0x4c>
    begin_op();
    800025b8:	00002097          	auipc	ra,0x2
    800025bc:	fd8080e7          	jalr	-40(ra) # 80004590 <begin_op>
    iput(p->cwd);
    800025c0:	1589b503          	ld	a0,344(s3)
    800025c4:	00001097          	auipc	ra,0x1
    800025c8:	7ba080e7          	jalr	1978(ra) # 80003d7e <iput>
    end_op();
    800025cc:	00002097          	auipc	ra,0x2
    800025d0:	042080e7          	jalr	66(ra) # 8000460e <end_op>
    p->cwd = 0;
    800025d4:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    800025d8:	0000f497          	auipc	s1,0xf
    800025dc:	aa048493          	addi	s1,s1,-1376 # 80011078 <wait_lock>
    800025e0:	8526                	mv	a0,s1
    800025e2:	ffffe097          	auipc	ra,0xffffe
    800025e6:	63a080e7          	jalr	1594(ra) # 80000c1c <acquire>
    reparent(p);
    800025ea:	854e                	mv	a0,s3
    800025ec:	00000097          	auipc	ra,0x0
    800025f0:	f1a080e7          	jalr	-230(ra) # 80002506 <reparent>
    wakeup(p->parent);
    800025f4:	0409b503          	ld	a0,64(s3)
    800025f8:	00000097          	auipc	ra,0x0
    800025fc:	e98080e7          	jalr	-360(ra) # 80002490 <wakeup>
    acquire(&p->lock);
    80002600:	854e                	mv	a0,s3
    80002602:	ffffe097          	auipc	ra,0xffffe
    80002606:	61a080e7          	jalr	1562(ra) # 80000c1c <acquire>
    p->xstate = status;
    8000260a:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    8000260e:	4795                	li	a5,5
    80002610:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80002614:	8526                	mv	a0,s1
    80002616:	ffffe097          	auipc	ra,0xffffe
    8000261a:	6ba080e7          	jalr	1722(ra) # 80000cd0 <release>
    sched();
    8000261e:	00000097          	auipc	ra,0x0
    80002622:	cae080e7          	jalr	-850(ra) # 800022cc <sched>
    panic("zombie exit");
    80002626:	00006517          	auipc	a0,0x6
    8000262a:	c4a50513          	addi	a0,a0,-950 # 80008270 <digits+0x230>
    8000262e:	ffffe097          	auipc	ra,0xffffe
    80002632:	f58080e7          	jalr	-168(ra) # 80000586 <panic>

0000000080002636 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002636:	7179                	addi	sp,sp,-48
    80002638:	f406                	sd	ra,40(sp)
    8000263a:	f022                	sd	s0,32(sp)
    8000263c:	ec26                	sd	s1,24(sp)
    8000263e:	e84a                	sd	s2,16(sp)
    80002640:	e44e                	sd	s3,8(sp)
    80002642:	1800                	addi	s0,sp,48
    80002644:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002646:	0000f497          	auipc	s1,0xf
    8000264a:	a4a48493          	addi	s1,s1,-1462 # 80011090 <proc>
    8000264e:	00014997          	auipc	s3,0x14
    80002652:	64298993          	addi	s3,s3,1602 # 80016c90 <tickslock>
    {
        acquire(&p->lock);
    80002656:	8526                	mv	a0,s1
    80002658:	ffffe097          	auipc	ra,0xffffe
    8000265c:	5c4080e7          	jalr	1476(ra) # 80000c1c <acquire>
        if (p->pid == pid)
    80002660:	589c                	lw	a5,48(s1)
    80002662:	01278d63          	beq	a5,s2,8000267c <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002666:	8526                	mv	a0,s1
    80002668:	ffffe097          	auipc	ra,0xffffe
    8000266c:	668080e7          	jalr	1640(ra) # 80000cd0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002670:	17048493          	addi	s1,s1,368
    80002674:	ff3491e3          	bne	s1,s3,80002656 <kill+0x20>
    }
    return -1;
    80002678:	557d                	li	a0,-1
    8000267a:	a829                	j	80002694 <kill+0x5e>
            p->killed = 1;
    8000267c:	4785                	li	a5,1
    8000267e:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80002680:	4c98                	lw	a4,24(s1)
    80002682:	4789                	li	a5,2
    80002684:	00f70f63          	beq	a4,a5,800026a2 <kill+0x6c>
            release(&p->lock);
    80002688:	8526                	mv	a0,s1
    8000268a:	ffffe097          	auipc	ra,0xffffe
    8000268e:	646080e7          	jalr	1606(ra) # 80000cd0 <release>
            return 0;
    80002692:	4501                	li	a0,0
}
    80002694:	70a2                	ld	ra,40(sp)
    80002696:	7402                	ld	s0,32(sp)
    80002698:	64e2                	ld	s1,24(sp)
    8000269a:	6942                	ld	s2,16(sp)
    8000269c:	69a2                	ld	s3,8(sp)
    8000269e:	6145                	addi	sp,sp,48
    800026a0:	8082                	ret
                p->state = RUNNABLE;
    800026a2:	478d                	li	a5,3
    800026a4:	cc9c                	sw	a5,24(s1)
    800026a6:	b7cd                	j	80002688 <kill+0x52>

00000000800026a8 <setkilled>:

void setkilled(struct proc *p)
{
    800026a8:	1101                	addi	sp,sp,-32
    800026aa:	ec06                	sd	ra,24(sp)
    800026ac:	e822                	sd	s0,16(sp)
    800026ae:	e426                	sd	s1,8(sp)
    800026b0:	1000                	addi	s0,sp,32
    800026b2:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800026b4:	ffffe097          	auipc	ra,0xffffe
    800026b8:	568080e7          	jalr	1384(ra) # 80000c1c <acquire>
    p->killed = 1;
    800026bc:	4785                	li	a5,1
    800026be:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800026c0:	8526                	mv	a0,s1
    800026c2:	ffffe097          	auipc	ra,0xffffe
    800026c6:	60e080e7          	jalr	1550(ra) # 80000cd0 <release>
}
    800026ca:	60e2                	ld	ra,24(sp)
    800026cc:	6442                	ld	s0,16(sp)
    800026ce:	64a2                	ld	s1,8(sp)
    800026d0:	6105                	addi	sp,sp,32
    800026d2:	8082                	ret

00000000800026d4 <killed>:

int killed(struct proc *p)
{
    800026d4:	1101                	addi	sp,sp,-32
    800026d6:	ec06                	sd	ra,24(sp)
    800026d8:	e822                	sd	s0,16(sp)
    800026da:	e426                	sd	s1,8(sp)
    800026dc:	e04a                	sd	s2,0(sp)
    800026de:	1000                	addi	s0,sp,32
    800026e0:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800026e2:	ffffe097          	auipc	ra,0xffffe
    800026e6:	53a080e7          	jalr	1338(ra) # 80000c1c <acquire>
    k = p->killed;
    800026ea:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800026ee:	8526                	mv	a0,s1
    800026f0:	ffffe097          	auipc	ra,0xffffe
    800026f4:	5e0080e7          	jalr	1504(ra) # 80000cd0 <release>
    return k;
}
    800026f8:	854a                	mv	a0,s2
    800026fa:	60e2                	ld	ra,24(sp)
    800026fc:	6442                	ld	s0,16(sp)
    800026fe:	64a2                	ld	s1,8(sp)
    80002700:	6902                	ld	s2,0(sp)
    80002702:	6105                	addi	sp,sp,32
    80002704:	8082                	ret

0000000080002706 <wait>:
{
    80002706:	715d                	addi	sp,sp,-80
    80002708:	e486                	sd	ra,72(sp)
    8000270a:	e0a2                	sd	s0,64(sp)
    8000270c:	fc26                	sd	s1,56(sp)
    8000270e:	f84a                	sd	s2,48(sp)
    80002710:	f44e                	sd	s3,40(sp)
    80002712:	f052                	sd	s4,32(sp)
    80002714:	ec56                	sd	s5,24(sp)
    80002716:	e85a                	sd	s6,16(sp)
    80002718:	e45e                	sd	s7,8(sp)
    8000271a:	e062                	sd	s8,0(sp)
    8000271c:	0880                	addi	s0,sp,80
    8000271e:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80002720:	fffff097          	auipc	ra,0xfffff
    80002724:	546080e7          	jalr	1350(ra) # 80001c66 <myproc>
    80002728:	892a                	mv	s2,a0
    acquire(&wait_lock);
    8000272a:	0000f517          	auipc	a0,0xf
    8000272e:	94e50513          	addi	a0,a0,-1714 # 80011078 <wait_lock>
    80002732:	ffffe097          	auipc	ra,0xffffe
    80002736:	4ea080e7          	jalr	1258(ra) # 80000c1c <acquire>
        havekids = 0;
    8000273a:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    8000273c:	4a15                	li	s4,5
                havekids = 1;
    8000273e:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002740:	00014997          	auipc	s3,0x14
    80002744:	55098993          	addi	s3,s3,1360 # 80016c90 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002748:	0000fc17          	auipc	s8,0xf
    8000274c:	930c0c13          	addi	s8,s8,-1744 # 80011078 <wait_lock>
        havekids = 0;
    80002750:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002752:	0000f497          	auipc	s1,0xf
    80002756:	93e48493          	addi	s1,s1,-1730 # 80011090 <proc>
    8000275a:	a0bd                	j	800027c8 <wait+0xc2>
                    pid = pp->pid;
    8000275c:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002760:	000b0e63          	beqz	s6,8000277c <wait+0x76>
    80002764:	4691                	li	a3,4
    80002766:	02c48613          	addi	a2,s1,44
    8000276a:	85da                	mv	a1,s6
    8000276c:	05893503          	ld	a0,88(s2)
    80002770:	fffff097          	auipc	ra,0xfffff
    80002774:	f42080e7          	jalr	-190(ra) # 800016b2 <copyout>
    80002778:	02054563          	bltz	a0,800027a2 <wait+0x9c>
                    freeproc(pp);
    8000277c:	8526                	mv	a0,s1
    8000277e:	fffff097          	auipc	ra,0xfffff
    80002782:	69a080e7          	jalr	1690(ra) # 80001e18 <freeproc>
                    release(&pp->lock);
    80002786:	8526                	mv	a0,s1
    80002788:	ffffe097          	auipc	ra,0xffffe
    8000278c:	548080e7          	jalr	1352(ra) # 80000cd0 <release>
                    release(&wait_lock);
    80002790:	0000f517          	auipc	a0,0xf
    80002794:	8e850513          	addi	a0,a0,-1816 # 80011078 <wait_lock>
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	538080e7          	jalr	1336(ra) # 80000cd0 <release>
                    return pid;
    800027a0:	a0b5                	j	8000280c <wait+0x106>
                        release(&pp->lock);
    800027a2:	8526                	mv	a0,s1
    800027a4:	ffffe097          	auipc	ra,0xffffe
    800027a8:	52c080e7          	jalr	1324(ra) # 80000cd0 <release>
                        release(&wait_lock);
    800027ac:	0000f517          	auipc	a0,0xf
    800027b0:	8cc50513          	addi	a0,a0,-1844 # 80011078 <wait_lock>
    800027b4:	ffffe097          	auipc	ra,0xffffe
    800027b8:	51c080e7          	jalr	1308(ra) # 80000cd0 <release>
                        return -1;
    800027bc:	59fd                	li	s3,-1
    800027be:	a0b9                	j	8000280c <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027c0:	17048493          	addi	s1,s1,368
    800027c4:	03348463          	beq	s1,s3,800027ec <wait+0xe6>
            if (pp->parent == p)
    800027c8:	60bc                	ld	a5,64(s1)
    800027ca:	ff279be3          	bne	a5,s2,800027c0 <wait+0xba>
                acquire(&pp->lock);
    800027ce:	8526                	mv	a0,s1
    800027d0:	ffffe097          	auipc	ra,0xffffe
    800027d4:	44c080e7          	jalr	1100(ra) # 80000c1c <acquire>
                if (pp->state == ZOMBIE)
    800027d8:	4c9c                	lw	a5,24(s1)
    800027da:	f94781e3          	beq	a5,s4,8000275c <wait+0x56>
                release(&pp->lock);
    800027de:	8526                	mv	a0,s1
    800027e0:	ffffe097          	auipc	ra,0xffffe
    800027e4:	4f0080e7          	jalr	1264(ra) # 80000cd0 <release>
                havekids = 1;
    800027e8:	8756                	mv	a4,s5
    800027ea:	bfd9                	j	800027c0 <wait+0xba>
        if (!havekids || killed(p))
    800027ec:	c719                	beqz	a4,800027fa <wait+0xf4>
    800027ee:	854a                	mv	a0,s2
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	ee4080e7          	jalr	-284(ra) # 800026d4 <killed>
    800027f8:	c51d                	beqz	a0,80002826 <wait+0x120>
            release(&wait_lock);
    800027fa:	0000f517          	auipc	a0,0xf
    800027fe:	87e50513          	addi	a0,a0,-1922 # 80011078 <wait_lock>
    80002802:	ffffe097          	auipc	ra,0xffffe
    80002806:	4ce080e7          	jalr	1230(ra) # 80000cd0 <release>
            return -1;
    8000280a:	59fd                	li	s3,-1
}
    8000280c:	854e                	mv	a0,s3
    8000280e:	60a6                	ld	ra,72(sp)
    80002810:	6406                	ld	s0,64(sp)
    80002812:	74e2                	ld	s1,56(sp)
    80002814:	7942                	ld	s2,48(sp)
    80002816:	79a2                	ld	s3,40(sp)
    80002818:	7a02                	ld	s4,32(sp)
    8000281a:	6ae2                	ld	s5,24(sp)
    8000281c:	6b42                	ld	s6,16(sp)
    8000281e:	6ba2                	ld	s7,8(sp)
    80002820:	6c02                	ld	s8,0(sp)
    80002822:	6161                	addi	sp,sp,80
    80002824:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002826:	85e2                	mv	a1,s8
    80002828:	854a                	mv	a0,s2
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	c02080e7          	jalr	-1022(ra) # 8000242c <sleep>
        havekids = 0;
    80002832:	bf39                	j	80002750 <wait+0x4a>

0000000080002834 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002834:	7179                	addi	sp,sp,-48
    80002836:	f406                	sd	ra,40(sp)
    80002838:	f022                	sd	s0,32(sp)
    8000283a:	ec26                	sd	s1,24(sp)
    8000283c:	e84a                	sd	s2,16(sp)
    8000283e:	e44e                	sd	s3,8(sp)
    80002840:	e052                	sd	s4,0(sp)
    80002842:	1800                	addi	s0,sp,48
    80002844:	84aa                	mv	s1,a0
    80002846:	892e                	mv	s2,a1
    80002848:	89b2                	mv	s3,a2
    8000284a:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000284c:	fffff097          	auipc	ra,0xfffff
    80002850:	41a080e7          	jalr	1050(ra) # 80001c66 <myproc>
    if (user_dst)
    80002854:	c08d                	beqz	s1,80002876 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002856:	86d2                	mv	a3,s4
    80002858:	864e                	mv	a2,s3
    8000285a:	85ca                	mv	a1,s2
    8000285c:	6d28                	ld	a0,88(a0)
    8000285e:	fffff097          	auipc	ra,0xfffff
    80002862:	e54080e7          	jalr	-428(ra) # 800016b2 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002866:	70a2                	ld	ra,40(sp)
    80002868:	7402                	ld	s0,32(sp)
    8000286a:	64e2                	ld	s1,24(sp)
    8000286c:	6942                	ld	s2,16(sp)
    8000286e:	69a2                	ld	s3,8(sp)
    80002870:	6a02                	ld	s4,0(sp)
    80002872:	6145                	addi	sp,sp,48
    80002874:	8082                	ret
        memmove((char *)dst, src, len);
    80002876:	000a061b          	sext.w	a2,s4
    8000287a:	85ce                	mv	a1,s3
    8000287c:	854a                	mv	a0,s2
    8000287e:	ffffe097          	auipc	ra,0xffffe
    80002882:	4f6080e7          	jalr	1270(ra) # 80000d74 <memmove>
        return 0;
    80002886:	8526                	mv	a0,s1
    80002888:	bff9                	j	80002866 <either_copyout+0x32>

000000008000288a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000288a:	7179                	addi	sp,sp,-48
    8000288c:	f406                	sd	ra,40(sp)
    8000288e:	f022                	sd	s0,32(sp)
    80002890:	ec26                	sd	s1,24(sp)
    80002892:	e84a                	sd	s2,16(sp)
    80002894:	e44e                	sd	s3,8(sp)
    80002896:	e052                	sd	s4,0(sp)
    80002898:	1800                	addi	s0,sp,48
    8000289a:	892a                	mv	s2,a0
    8000289c:	84ae                	mv	s1,a1
    8000289e:	89b2                	mv	s3,a2
    800028a0:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800028a2:	fffff097          	auipc	ra,0xfffff
    800028a6:	3c4080e7          	jalr	964(ra) # 80001c66 <myproc>
    if (user_src)
    800028aa:	c08d                	beqz	s1,800028cc <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800028ac:	86d2                	mv	a3,s4
    800028ae:	864e                	mv	a2,s3
    800028b0:	85ca                	mv	a1,s2
    800028b2:	6d28                	ld	a0,88(a0)
    800028b4:	fffff097          	auipc	ra,0xfffff
    800028b8:	e8a080e7          	jalr	-374(ra) # 8000173e <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800028bc:	70a2                	ld	ra,40(sp)
    800028be:	7402                	ld	s0,32(sp)
    800028c0:	64e2                	ld	s1,24(sp)
    800028c2:	6942                	ld	s2,16(sp)
    800028c4:	69a2                	ld	s3,8(sp)
    800028c6:	6a02                	ld	s4,0(sp)
    800028c8:	6145                	addi	sp,sp,48
    800028ca:	8082                	ret
        memmove(dst, (char *)src, len);
    800028cc:	000a061b          	sext.w	a2,s4
    800028d0:	85ce                	mv	a1,s3
    800028d2:	854a                	mv	a0,s2
    800028d4:	ffffe097          	auipc	ra,0xffffe
    800028d8:	4a0080e7          	jalr	1184(ra) # 80000d74 <memmove>
        return 0;
    800028dc:	8526                	mv	a0,s1
    800028de:	bff9                	j	800028bc <either_copyin+0x32>

00000000800028e0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800028e0:	715d                	addi	sp,sp,-80
    800028e2:	e486                	sd	ra,72(sp)
    800028e4:	e0a2                	sd	s0,64(sp)
    800028e6:	fc26                	sd	s1,56(sp)
    800028e8:	f84a                	sd	s2,48(sp)
    800028ea:	f44e                	sd	s3,40(sp)
    800028ec:	f052                	sd	s4,32(sp)
    800028ee:	ec56                	sd	s5,24(sp)
    800028f0:	e85a                	sd	s6,16(sp)
    800028f2:	e45e                	sd	s7,8(sp)
    800028f4:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800028f6:	00005517          	auipc	a0,0x5
    800028fa:	7d250513          	addi	a0,a0,2002 # 800080c8 <digits+0x88>
    800028fe:	ffffe097          	auipc	ra,0xffffe
    80002902:	cd2080e7          	jalr	-814(ra) # 800005d0 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002906:	0000f497          	auipc	s1,0xf
    8000290a:	8ea48493          	addi	s1,s1,-1814 # 800111f0 <proc+0x160>
    8000290e:	00014917          	auipc	s2,0x14
    80002912:	4e290913          	addi	s2,s2,1250 # 80016df0 <bcache+0x148>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002916:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002918:	00006997          	auipc	s3,0x6
    8000291c:	96898993          	addi	s3,s3,-1688 # 80008280 <digits+0x240>
        printf("%d <%s %s", p->pid, state, p->name);
    80002920:	00006a97          	auipc	s5,0x6
    80002924:	968a8a93          	addi	s5,s5,-1688 # 80008288 <digits+0x248>
        printf("\n");
    80002928:	00005a17          	auipc	s4,0x5
    8000292c:	7a0a0a13          	addi	s4,s4,1952 # 800080c8 <digits+0x88>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002930:	00006b97          	auipc	s7,0x6
    80002934:	a40b8b93          	addi	s7,s7,-1472 # 80008370 <states.0>
    80002938:	a00d                	j	8000295a <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    8000293a:	ed06a583          	lw	a1,-304(a3)
    8000293e:	8556                	mv	a0,s5
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	c90080e7          	jalr	-880(ra) # 800005d0 <printf>
        printf("\n");
    80002948:	8552                	mv	a0,s4
    8000294a:	ffffe097          	auipc	ra,0xffffe
    8000294e:	c86080e7          	jalr	-890(ra) # 800005d0 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002952:	17048493          	addi	s1,s1,368
    80002956:	03248263          	beq	s1,s2,8000297a <procdump+0x9a>
        if (p->state == UNUSED)
    8000295a:	86a6                	mv	a3,s1
    8000295c:	eb84a783          	lw	a5,-328(s1)
    80002960:	dbed                	beqz	a5,80002952 <procdump+0x72>
            state = "???";
    80002962:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002964:	fcfb6be3          	bltu	s6,a5,8000293a <procdump+0x5a>
    80002968:	02079713          	slli	a4,a5,0x20
    8000296c:	01d75793          	srli	a5,a4,0x1d
    80002970:	97de                	add	a5,a5,s7
    80002972:	6390                	ld	a2,0(a5)
    80002974:	f279                	bnez	a2,8000293a <procdump+0x5a>
            state = "???";
    80002976:	864e                	mv	a2,s3
    80002978:	b7c9                	j	8000293a <procdump+0x5a>
    }
}
    8000297a:	60a6                	ld	ra,72(sp)
    8000297c:	6406                	ld	s0,64(sp)
    8000297e:	74e2                	ld	s1,56(sp)
    80002980:	7942                	ld	s2,48(sp)
    80002982:	79a2                	ld	s3,40(sp)
    80002984:	7a02                	ld	s4,32(sp)
    80002986:	6ae2                	ld	s5,24(sp)
    80002988:	6b42                	ld	s6,16(sp)
    8000298a:	6ba2                	ld	s7,8(sp)
    8000298c:	6161                	addi	sp,sp,80
    8000298e:	8082                	ret

0000000080002990 <schedls>:

void schedls()
{
    80002990:	1101                	addi	sp,sp,-32
    80002992:	ec06                	sd	ra,24(sp)
    80002994:	e822                	sd	s0,16(sp)
    80002996:	e426                	sd	s1,8(sp)
    80002998:	1000                	addi	s0,sp,32
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    8000299a:	00006517          	auipc	a0,0x6
    8000299e:	8fe50513          	addi	a0,a0,-1794 # 80008298 <digits+0x258>
    800029a2:	ffffe097          	auipc	ra,0xffffe
    800029a6:	c2e080e7          	jalr	-978(ra) # 800005d0 <printf>
    printf("====================================\n");
    800029aa:	00006517          	auipc	a0,0x6
    800029ae:	91650513          	addi	a0,a0,-1770 # 800082c0 <digits+0x280>
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	c1e080e7          	jalr	-994(ra) # 800005d0 <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    800029ba:	00006717          	auipc	a4,0x6
    800029be:	fae73703          	ld	a4,-82(a4) # 80008968 <available_schedulers+0x10>
    800029c2:	00006797          	auipc	a5,0x6
    800029c6:	f467b783          	ld	a5,-186(a5) # 80008908 <sched_pointer>
    800029ca:	08f70763          	beq	a4,a5,80002a58 <schedls+0xc8>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    800029ce:	00006517          	auipc	a0,0x6
    800029d2:	91a50513          	addi	a0,a0,-1766 # 800082e8 <digits+0x2a8>
    800029d6:	ffffe097          	auipc	ra,0xffffe
    800029da:	bfa080e7          	jalr	-1030(ra) # 800005d0 <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    800029de:	00006497          	auipc	s1,0x6
    800029e2:	f4248493          	addi	s1,s1,-190 # 80008920 <initcode>
    800029e6:	48b0                	lw	a2,80(s1)
    800029e8:	00006597          	auipc	a1,0x6
    800029ec:	f7058593          	addi	a1,a1,-144 # 80008958 <available_schedulers>
    800029f0:	00006517          	auipc	a0,0x6
    800029f4:	90850513          	addi	a0,a0,-1784 # 800082f8 <digits+0x2b8>
    800029f8:	ffffe097          	auipc	ra,0xffffe
    800029fc:	bd8080e7          	jalr	-1064(ra) # 800005d0 <printf>
        if (available_schedulers[i].impl == sched_pointer)
    80002a00:	74b8                	ld	a4,104(s1)
    80002a02:	00006797          	auipc	a5,0x6
    80002a06:	f067b783          	ld	a5,-250(a5) # 80008908 <sched_pointer>
    80002a0a:	06f70063          	beq	a4,a5,80002a6a <schedls+0xda>
            printf("   \t");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	8da50513          	addi	a0,a0,-1830 # 800082e8 <digits+0x2a8>
    80002a16:	ffffe097          	auipc	ra,0xffffe
    80002a1a:	bba080e7          	jalr	-1094(ra) # 800005d0 <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002a1e:	00006617          	auipc	a2,0x6
    80002a22:	f7262603          	lw	a2,-142(a2) # 80008990 <available_schedulers+0x38>
    80002a26:	00006597          	auipc	a1,0x6
    80002a2a:	f5258593          	addi	a1,a1,-174 # 80008978 <available_schedulers+0x20>
    80002a2e:	00006517          	auipc	a0,0x6
    80002a32:	8ca50513          	addi	a0,a0,-1846 # 800082f8 <digits+0x2b8>
    80002a36:	ffffe097          	auipc	ra,0xffffe
    80002a3a:	b9a080e7          	jalr	-1126(ra) # 800005d0 <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002a3e:	00006517          	auipc	a0,0x6
    80002a42:	8c250513          	addi	a0,a0,-1854 # 80008300 <digits+0x2c0>
    80002a46:	ffffe097          	auipc	ra,0xffffe
    80002a4a:	b8a080e7          	jalr	-1142(ra) # 800005d0 <printf>
}
    80002a4e:	60e2                	ld	ra,24(sp)
    80002a50:	6442                	ld	s0,16(sp)
    80002a52:	64a2                	ld	s1,8(sp)
    80002a54:	6105                	addi	sp,sp,32
    80002a56:	8082                	ret
            printf("[*]\t");
    80002a58:	00006517          	auipc	a0,0x6
    80002a5c:	89850513          	addi	a0,a0,-1896 # 800082f0 <digits+0x2b0>
    80002a60:	ffffe097          	auipc	ra,0xffffe
    80002a64:	b70080e7          	jalr	-1168(ra) # 800005d0 <printf>
    80002a68:	bf9d                	j	800029de <schedls+0x4e>
    80002a6a:	00006517          	auipc	a0,0x6
    80002a6e:	88650513          	addi	a0,a0,-1914 # 800082f0 <digits+0x2b0>
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	b5e080e7          	jalr	-1186(ra) # 800005d0 <printf>
    80002a7a:	b755                	j	80002a1e <schedls+0x8e>

0000000080002a7c <schedset>:

void schedset(int id)
{
    80002a7c:	1141                	addi	sp,sp,-16
    80002a7e:	e406                	sd	ra,8(sp)
    80002a80:	e022                	sd	s0,0(sp)
    80002a82:	0800                	addi	s0,sp,16
    sched_pointer = available_schedulers[id - 1].impl;
    80002a84:	357d                	addiw	a0,a0,-1
    80002a86:	0516                	slli	a0,a0,0x5
    80002a88:	00006797          	auipc	a5,0x6
    80002a8c:	e9878793          	addi	a5,a5,-360 # 80008920 <initcode>
    80002a90:	97aa                	add	a5,a5,a0
    80002a92:	67bc                	ld	a5,72(a5)
    80002a94:	00006717          	auipc	a4,0x6
    80002a98:	e6f73a23          	sd	a5,-396(a4) # 80008908 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id - 1].name);
    80002a9c:	00006597          	auipc	a1,0x6
    80002aa0:	ebc58593          	addi	a1,a1,-324 # 80008958 <available_schedulers>
    80002aa4:	95aa                	add	a1,a1,a0
    80002aa6:	00006517          	auipc	a0,0x6
    80002aaa:	87250513          	addi	a0,a0,-1934 # 80008318 <digits+0x2d8>
    80002aae:	ffffe097          	auipc	ra,0xffffe
    80002ab2:	b22080e7          	jalr	-1246(ra) # 800005d0 <printf>
    80002ab6:	60a2                	ld	ra,8(sp)
    80002ab8:	6402                	ld	s0,0(sp)
    80002aba:	0141                	addi	sp,sp,16
    80002abc:	8082                	ret

0000000080002abe <swtch>:
    80002abe:	00153023          	sd	ra,0(a0)
    80002ac2:	00253423          	sd	sp,8(a0)
    80002ac6:	e900                	sd	s0,16(a0)
    80002ac8:	ed04                	sd	s1,24(a0)
    80002aca:	03253023          	sd	s2,32(a0)
    80002ace:	03353423          	sd	s3,40(a0)
    80002ad2:	03453823          	sd	s4,48(a0)
    80002ad6:	03553c23          	sd	s5,56(a0)
    80002ada:	05653023          	sd	s6,64(a0)
    80002ade:	05753423          	sd	s7,72(a0)
    80002ae2:	05853823          	sd	s8,80(a0)
    80002ae6:	05953c23          	sd	s9,88(a0)
    80002aea:	07a53023          	sd	s10,96(a0)
    80002aee:	07b53423          	sd	s11,104(a0)
    80002af2:	0005b083          	ld	ra,0(a1)
    80002af6:	0085b103          	ld	sp,8(a1)
    80002afa:	6980                	ld	s0,16(a1)
    80002afc:	6d84                	ld	s1,24(a1)
    80002afe:	0205b903          	ld	s2,32(a1)
    80002b02:	0285b983          	ld	s3,40(a1)
    80002b06:	0305ba03          	ld	s4,48(a1)
    80002b0a:	0385ba83          	ld	s5,56(a1)
    80002b0e:	0405bb03          	ld	s6,64(a1)
    80002b12:	0485bb83          	ld	s7,72(a1)
    80002b16:	0505bc03          	ld	s8,80(a1)
    80002b1a:	0585bc83          	ld	s9,88(a1)
    80002b1e:	0605bd03          	ld	s10,96(a1)
    80002b22:	0685bd83          	ld	s11,104(a1)
    80002b26:	8082                	ret

0000000080002b28 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002b28:	1141                	addi	sp,sp,-16
    80002b2a:	e406                	sd	ra,8(sp)
    80002b2c:	e022                	sd	s0,0(sp)
    80002b2e:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002b30:	00006597          	auipc	a1,0x6
    80002b34:	87058593          	addi	a1,a1,-1936 # 800083a0 <states.0+0x30>
    80002b38:	00014517          	auipc	a0,0x14
    80002b3c:	15850513          	addi	a0,a0,344 # 80016c90 <tickslock>
    80002b40:	ffffe097          	auipc	ra,0xffffe
    80002b44:	04c080e7          	jalr	76(ra) # 80000b8c <initlock>
}
    80002b48:	60a2                	ld	ra,8(sp)
    80002b4a:	6402                	ld	s0,0(sp)
    80002b4c:	0141                	addi	sp,sp,16
    80002b4e:	8082                	ret

0000000080002b50 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002b50:	1141                	addi	sp,sp,-16
    80002b52:	e422                	sd	s0,8(sp)
    80002b54:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b56:	00003797          	auipc	a5,0x3
    80002b5a:	55a78793          	addi	a5,a5,1370 # 800060b0 <kernelvec>
    80002b5e:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002b62:	6422                	ld	s0,8(sp)
    80002b64:	0141                	addi	sp,sp,16
    80002b66:	8082                	ret

0000000080002b68 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002b68:	1141                	addi	sp,sp,-16
    80002b6a:	e406                	sd	ra,8(sp)
    80002b6c:	e022                	sd	s0,0(sp)
    80002b6e:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002b70:	fffff097          	auipc	ra,0xfffff
    80002b74:	0f6080e7          	jalr	246(ra) # 80001c66 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b78:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b7e:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002b82:	00004697          	auipc	a3,0x4
    80002b86:	47e68693          	addi	a3,a3,1150 # 80007000 <_trampoline>
    80002b8a:	00004717          	auipc	a4,0x4
    80002b8e:	47670713          	addi	a4,a4,1142 # 80007000 <_trampoline>
    80002b92:	8f15                	sub	a4,a4,a3
    80002b94:	040007b7          	lui	a5,0x4000
    80002b98:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b9a:	07b2                	slli	a5,a5,0xc
    80002b9c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b9e:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ba2:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ba4:	18002673          	csrr	a2,satp
    80002ba8:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002baa:	7130                	ld	a2,96(a0)
    80002bac:	6538                	ld	a4,72(a0)
    80002bae:	6585                	lui	a1,0x1
    80002bb0:	972e                	add	a4,a4,a1
    80002bb2:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002bb4:	7138                	ld	a4,96(a0)
    80002bb6:	00000617          	auipc	a2,0x0
    80002bba:	13060613          	addi	a2,a2,304 # 80002ce6 <usertrap>
    80002bbe:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002bc0:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bc2:	8612                	mv	a2,tp
    80002bc4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bc6:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002bca:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bce:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bd2:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002bd6:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bd8:	6f18                	ld	a4,24(a4)
    80002bda:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002bde:	6d28                	ld	a0,88(a0)
    80002be0:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002be2:	00004717          	auipc	a4,0x4
    80002be6:	4ba70713          	addi	a4,a4,1210 # 8000709c <userret>
    80002bea:	8f15                	sub	a4,a4,a3
    80002bec:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002bee:	577d                	li	a4,-1
    80002bf0:	177e                	slli	a4,a4,0x3f
    80002bf2:	8d59                	or	a0,a0,a4
    80002bf4:	9782                	jalr	a5
}
    80002bf6:	60a2                	ld	ra,8(sp)
    80002bf8:	6402                	ld	s0,0(sp)
    80002bfa:	0141                	addi	sp,sp,16
    80002bfc:	8082                	ret

0000000080002bfe <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002bfe:	1101                	addi	sp,sp,-32
    80002c00:	ec06                	sd	ra,24(sp)
    80002c02:	e822                	sd	s0,16(sp)
    80002c04:	e426                	sd	s1,8(sp)
    80002c06:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002c08:	00014497          	auipc	s1,0x14
    80002c0c:	08848493          	addi	s1,s1,136 # 80016c90 <tickslock>
    80002c10:	8526                	mv	a0,s1
    80002c12:	ffffe097          	auipc	ra,0xffffe
    80002c16:	00a080e7          	jalr	10(ra) # 80000c1c <acquire>
    ticks++;
    80002c1a:	00006517          	auipc	a0,0x6
    80002c1e:	dd650513          	addi	a0,a0,-554 # 800089f0 <ticks>
    80002c22:	411c                	lw	a5,0(a0)
    80002c24:	2785                	addiw	a5,a5,1
    80002c26:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002c28:	00000097          	auipc	ra,0x0
    80002c2c:	868080e7          	jalr	-1944(ra) # 80002490 <wakeup>
    release(&tickslock);
    80002c30:	8526                	mv	a0,s1
    80002c32:	ffffe097          	auipc	ra,0xffffe
    80002c36:	09e080e7          	jalr	158(ra) # 80000cd0 <release>
}
    80002c3a:	60e2                	ld	ra,24(sp)
    80002c3c:	6442                	ld	s0,16(sp)
    80002c3e:	64a2                	ld	s1,8(sp)
    80002c40:	6105                	addi	sp,sp,32
    80002c42:	8082                	ret

0000000080002c44 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80002c44:	1101                	addi	sp,sp,-32
    80002c46:	ec06                	sd	ra,24(sp)
    80002c48:	e822                	sd	s0,16(sp)
    80002c4a:	e426                	sd	s1,8(sp)
    80002c4c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c4e:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) &&
    80002c52:	00074d63          	bltz	a4,80002c6c <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L)
    80002c56:	57fd                	li	a5,-1
    80002c58:	17fe                	slli	a5,a5,0x3f
    80002c5a:	0785                	addi	a5,a5,1

        return 2;
    }
    else
    {
        return 0;
    80002c5c:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002c5e:	06f70363          	beq	a4,a5,80002cc4 <devintr+0x80>
    }
}
    80002c62:	60e2                	ld	ra,24(sp)
    80002c64:	6442                	ld	s0,16(sp)
    80002c66:	64a2                	ld	s1,8(sp)
    80002c68:	6105                	addi	sp,sp,32
    80002c6a:	8082                	ret
        (scause & 0xff) == 9)
    80002c6c:	0ff77793          	zext.b	a5,a4
    if ((scause & 0x8000000000000000L) &&
    80002c70:	46a5                	li	a3,9
    80002c72:	fed792e3          	bne	a5,a3,80002c56 <devintr+0x12>
        int irq = plic_claim();
    80002c76:	00003097          	auipc	ra,0x3
    80002c7a:	542080e7          	jalr	1346(ra) # 800061b8 <plic_claim>
    80002c7e:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002c80:	47a9                	li	a5,10
    80002c82:	02f50763          	beq	a0,a5,80002cb0 <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ)
    80002c86:	4785                	li	a5,1
    80002c88:	02f50963          	beq	a0,a5,80002cba <devintr+0x76>
        return 1;
    80002c8c:	4505                	li	a0,1
        else if (irq)
    80002c8e:	d8f1                	beqz	s1,80002c62 <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80002c90:	85a6                	mv	a1,s1
    80002c92:	00005517          	auipc	a0,0x5
    80002c96:	71650513          	addi	a0,a0,1814 # 800083a8 <states.0+0x38>
    80002c9a:	ffffe097          	auipc	ra,0xffffe
    80002c9e:	936080e7          	jalr	-1738(ra) # 800005d0 <printf>
            plic_complete(irq);
    80002ca2:	8526                	mv	a0,s1
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	538080e7          	jalr	1336(ra) # 800061dc <plic_complete>
        return 1;
    80002cac:	4505                	li	a0,1
    80002cae:	bf55                	j	80002c62 <devintr+0x1e>
            uartintr();
    80002cb0:	ffffe097          	auipc	ra,0xffffe
    80002cb4:	d2e080e7          	jalr	-722(ra) # 800009de <uartintr>
    80002cb8:	b7ed                	j	80002ca2 <devintr+0x5e>
            virtio_disk_intr();
    80002cba:	00004097          	auipc	ra,0x4
    80002cbe:	9ea080e7          	jalr	-1558(ra) # 800066a4 <virtio_disk_intr>
    80002cc2:	b7c5                	j	80002ca2 <devintr+0x5e>
        if (cpuid() == 0)
    80002cc4:	fffff097          	auipc	ra,0xfffff
    80002cc8:	f76080e7          	jalr	-138(ra) # 80001c3a <cpuid>
    80002ccc:	c901                	beqz	a0,80002cdc <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002cce:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002cd2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002cd4:	14479073          	csrw	sip,a5
        return 2;
    80002cd8:	4509                	li	a0,2
    80002cda:	b761                	j	80002c62 <devintr+0x1e>
            clockintr();
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	f22080e7          	jalr	-222(ra) # 80002bfe <clockintr>
    80002ce4:	b7ed                	j	80002cce <devintr+0x8a>

0000000080002ce6 <usertrap>:
{
    80002ce6:	1101                	addi	sp,sp,-32
    80002ce8:	ec06                	sd	ra,24(sp)
    80002cea:	e822                	sd	s0,16(sp)
    80002cec:	e426                	sd	s1,8(sp)
    80002cee:	e04a                	sd	s2,0(sp)
    80002cf0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cf2:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002cf6:	1007f793          	andi	a5,a5,256
    80002cfa:	e3b1                	bnez	a5,80002d3e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002cfc:	00003797          	auipc	a5,0x3
    80002d00:	3b478793          	addi	a5,a5,948 # 800060b0 <kernelvec>
    80002d04:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002d08:	fffff097          	auipc	ra,0xfffff
    80002d0c:	f5e080e7          	jalr	-162(ra) # 80001c66 <myproc>
    80002d10:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002d12:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d14:	14102773          	csrr	a4,sepc
    80002d18:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d1a:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002d1e:	47a1                	li	a5,8
    80002d20:	02f70763          	beq	a4,a5,80002d4e <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	f20080e7          	jalr	-224(ra) # 80002c44 <devintr>
    80002d2c:	892a                	mv	s2,a0
    80002d2e:	c151                	beqz	a0,80002db2 <usertrap+0xcc>
    if (killed(p))
    80002d30:	8526                	mv	a0,s1
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	9a2080e7          	jalr	-1630(ra) # 800026d4 <killed>
    80002d3a:	c929                	beqz	a0,80002d8c <usertrap+0xa6>
    80002d3c:	a099                	j	80002d82 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002d3e:	00005517          	auipc	a0,0x5
    80002d42:	68a50513          	addi	a0,a0,1674 # 800083c8 <states.0+0x58>
    80002d46:	ffffe097          	auipc	ra,0xffffe
    80002d4a:	840080e7          	jalr	-1984(ra) # 80000586 <panic>
        if (killed(p))
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	986080e7          	jalr	-1658(ra) # 800026d4 <killed>
    80002d56:	e921                	bnez	a0,80002da6 <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002d58:	70b8                	ld	a4,96(s1)
    80002d5a:	6f1c                	ld	a5,24(a4)
    80002d5c:	0791                	addi	a5,a5,4
    80002d5e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d68:	10079073          	csrw	sstatus,a5
        syscall();
    80002d6c:	00000097          	auipc	ra,0x0
    80002d70:	2d8080e7          	jalr	728(ra) # 80003044 <syscall>
    if (killed(p))
    80002d74:	8526                	mv	a0,s1
    80002d76:	00000097          	auipc	ra,0x0
    80002d7a:	95e080e7          	jalr	-1698(ra) # 800026d4 <killed>
    80002d7e:	c911                	beqz	a0,80002d92 <usertrap+0xac>
    80002d80:	4901                	li	s2,0
        exit(-1);
    80002d82:	557d                	li	a0,-1
    80002d84:	fffff097          	auipc	ra,0xfffff
    80002d88:	7dc080e7          	jalr	2012(ra) # 80002560 <exit>
    if (which_dev == 2)
    80002d8c:	4789                	li	a5,2
    80002d8e:	04f90f63          	beq	s2,a5,80002dec <usertrap+0x106>
    usertrapret();
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	dd6080e7          	jalr	-554(ra) # 80002b68 <usertrapret>
}
    80002d9a:	60e2                	ld	ra,24(sp)
    80002d9c:	6442                	ld	s0,16(sp)
    80002d9e:	64a2                	ld	s1,8(sp)
    80002da0:	6902                	ld	s2,0(sp)
    80002da2:	6105                	addi	sp,sp,32
    80002da4:	8082                	ret
            exit(-1);
    80002da6:	557d                	li	a0,-1
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	7b8080e7          	jalr	1976(ra) # 80002560 <exit>
    80002db0:	b765                	j	80002d58 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002db2:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002db6:	5890                	lw	a2,48(s1)
    80002db8:	00005517          	auipc	a0,0x5
    80002dbc:	63050513          	addi	a0,a0,1584 # 800083e8 <states.0+0x78>
    80002dc0:	ffffe097          	auipc	ra,0xffffe
    80002dc4:	810080e7          	jalr	-2032(ra) # 800005d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dc8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dcc:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dd0:	00005517          	auipc	a0,0x5
    80002dd4:	64850513          	addi	a0,a0,1608 # 80008418 <states.0+0xa8>
    80002dd8:	ffffd097          	auipc	ra,0xffffd
    80002ddc:	7f8080e7          	jalr	2040(ra) # 800005d0 <printf>
        setkilled(p);
    80002de0:	8526                	mv	a0,s1
    80002de2:	00000097          	auipc	ra,0x0
    80002de6:	8c6080e7          	jalr	-1850(ra) # 800026a8 <setkilled>
    80002dea:	b769                	j	80002d74 <usertrap+0x8e>
        yield(YIELD_TIMER);
    80002dec:	4505                	li	a0,1
    80002dee:	fffff097          	auipc	ra,0xfffff
    80002df2:	5de080e7          	jalr	1502(ra) # 800023cc <yield>
    80002df6:	bf71                	j	80002d92 <usertrap+0xac>

0000000080002df8 <kerneltrap>:
{
    80002df8:	7179                	addi	sp,sp,-48
    80002dfa:	f406                	sd	ra,40(sp)
    80002dfc:	f022                	sd	s0,32(sp)
    80002dfe:	ec26                	sd	s1,24(sp)
    80002e00:	e84a                	sd	s2,16(sp)
    80002e02:	e44e                	sd	s3,8(sp)
    80002e04:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e06:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e0a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e0e:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002e12:	1004f793          	andi	a5,s1,256
    80002e16:	cb85                	beqz	a5,80002e46 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e18:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e1c:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002e1e:	ef85                	bnez	a5,80002e56 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	e24080e7          	jalr	-476(ra) # 80002c44 <devintr>
    80002e28:	cd1d                	beqz	a0,80002e66 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e2a:	4789                	li	a5,2
    80002e2c:	06f50a63          	beq	a0,a5,80002ea0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e30:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e34:	10049073          	csrw	sstatus,s1
}
    80002e38:	70a2                	ld	ra,40(sp)
    80002e3a:	7402                	ld	s0,32(sp)
    80002e3c:	64e2                	ld	s1,24(sp)
    80002e3e:	6942                	ld	s2,16(sp)
    80002e40:	69a2                	ld	s3,8(sp)
    80002e42:	6145                	addi	sp,sp,48
    80002e44:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002e46:	00005517          	auipc	a0,0x5
    80002e4a:	5f250513          	addi	a0,a0,1522 # 80008438 <states.0+0xc8>
    80002e4e:	ffffd097          	auipc	ra,0xffffd
    80002e52:	738080e7          	jalr	1848(ra) # 80000586 <panic>
        panic("kerneltrap: interrupts enabled");
    80002e56:	00005517          	auipc	a0,0x5
    80002e5a:	60a50513          	addi	a0,a0,1546 # 80008460 <states.0+0xf0>
    80002e5e:	ffffd097          	auipc	ra,0xffffd
    80002e62:	728080e7          	jalr	1832(ra) # 80000586 <panic>
        printf("scause %p\n", scause);
    80002e66:	85ce                	mv	a1,s3
    80002e68:	00005517          	auipc	a0,0x5
    80002e6c:	61850513          	addi	a0,a0,1560 # 80008480 <states.0+0x110>
    80002e70:	ffffd097          	auipc	ra,0xffffd
    80002e74:	760080e7          	jalr	1888(ra) # 800005d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e78:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e7c:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e80:	00005517          	auipc	a0,0x5
    80002e84:	61050513          	addi	a0,a0,1552 # 80008490 <states.0+0x120>
    80002e88:	ffffd097          	auipc	ra,0xffffd
    80002e8c:	748080e7          	jalr	1864(ra) # 800005d0 <printf>
        panic("kerneltrap");
    80002e90:	00005517          	auipc	a0,0x5
    80002e94:	61850513          	addi	a0,a0,1560 # 800084a8 <states.0+0x138>
    80002e98:	ffffd097          	auipc	ra,0xffffd
    80002e9c:	6ee080e7          	jalr	1774(ra) # 80000586 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	dc6080e7          	jalr	-570(ra) # 80001c66 <myproc>
    80002ea8:	d541                	beqz	a0,80002e30 <kerneltrap+0x38>
    80002eaa:	fffff097          	auipc	ra,0xfffff
    80002eae:	dbc080e7          	jalr	-580(ra) # 80001c66 <myproc>
    80002eb2:	4d18                	lw	a4,24(a0)
    80002eb4:	4791                	li	a5,4
    80002eb6:	f6f71de3          	bne	a4,a5,80002e30 <kerneltrap+0x38>
        yield(YIELD_OTHER); // we are in the kernel already - not the user proc to blame for
    80002eba:	4509                	li	a0,2
    80002ebc:	fffff097          	auipc	ra,0xfffff
    80002ec0:	510080e7          	jalr	1296(ra) # 800023cc <yield>
    80002ec4:	b7b5                	j	80002e30 <kerneltrap+0x38>

0000000080002ec6 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002ec6:	1101                	addi	sp,sp,-32
    80002ec8:	ec06                	sd	ra,24(sp)
    80002eca:	e822                	sd	s0,16(sp)
    80002ecc:	e426                	sd	s1,8(sp)
    80002ece:	1000                	addi	s0,sp,32
    80002ed0:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002ed2:	fffff097          	auipc	ra,0xfffff
    80002ed6:	d94080e7          	jalr	-620(ra) # 80001c66 <myproc>
    switch (n)
    80002eda:	4795                	li	a5,5
    80002edc:	0497e163          	bltu	a5,s1,80002f1e <argraw+0x58>
    80002ee0:	048a                	slli	s1,s1,0x2
    80002ee2:	00005717          	auipc	a4,0x5
    80002ee6:	5fe70713          	addi	a4,a4,1534 # 800084e0 <states.0+0x170>
    80002eea:	94ba                	add	s1,s1,a4
    80002eec:	409c                	lw	a5,0(s1)
    80002eee:	97ba                	add	a5,a5,a4
    80002ef0:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002ef2:	713c                	ld	a5,96(a0)
    80002ef4:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002ef6:	60e2                	ld	ra,24(sp)
    80002ef8:	6442                	ld	s0,16(sp)
    80002efa:	64a2                	ld	s1,8(sp)
    80002efc:	6105                	addi	sp,sp,32
    80002efe:	8082                	ret
        return p->trapframe->a1;
    80002f00:	713c                	ld	a5,96(a0)
    80002f02:	7fa8                	ld	a0,120(a5)
    80002f04:	bfcd                	j	80002ef6 <argraw+0x30>
        return p->trapframe->a2;
    80002f06:	713c                	ld	a5,96(a0)
    80002f08:	63c8                	ld	a0,128(a5)
    80002f0a:	b7f5                	j	80002ef6 <argraw+0x30>
        return p->trapframe->a3;
    80002f0c:	713c                	ld	a5,96(a0)
    80002f0e:	67c8                	ld	a0,136(a5)
    80002f10:	b7dd                	j	80002ef6 <argraw+0x30>
        return p->trapframe->a4;
    80002f12:	713c                	ld	a5,96(a0)
    80002f14:	6bc8                	ld	a0,144(a5)
    80002f16:	b7c5                	j	80002ef6 <argraw+0x30>
        return p->trapframe->a5;
    80002f18:	713c                	ld	a5,96(a0)
    80002f1a:	6fc8                	ld	a0,152(a5)
    80002f1c:	bfe9                	j	80002ef6 <argraw+0x30>
    panic("argraw");
    80002f1e:	00005517          	auipc	a0,0x5
    80002f22:	59a50513          	addi	a0,a0,1434 # 800084b8 <states.0+0x148>
    80002f26:	ffffd097          	auipc	ra,0xffffd
    80002f2a:	660080e7          	jalr	1632(ra) # 80000586 <panic>

0000000080002f2e <fetchaddr>:
{
    80002f2e:	1101                	addi	sp,sp,-32
    80002f30:	ec06                	sd	ra,24(sp)
    80002f32:	e822                	sd	s0,16(sp)
    80002f34:	e426                	sd	s1,8(sp)
    80002f36:	e04a                	sd	s2,0(sp)
    80002f38:	1000                	addi	s0,sp,32
    80002f3a:	84aa                	mv	s1,a0
    80002f3c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	d28080e7          	jalr	-728(ra) # 80001c66 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002f46:	693c                	ld	a5,80(a0)
    80002f48:	02f4f863          	bgeu	s1,a5,80002f78 <fetchaddr+0x4a>
    80002f4c:	00848713          	addi	a4,s1,8
    80002f50:	02e7e663          	bltu	a5,a4,80002f7c <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002f54:	46a1                	li	a3,8
    80002f56:	8626                	mv	a2,s1
    80002f58:	85ca                	mv	a1,s2
    80002f5a:	6d28                	ld	a0,88(a0)
    80002f5c:	ffffe097          	auipc	ra,0xffffe
    80002f60:	7e2080e7          	jalr	2018(ra) # 8000173e <copyin>
    80002f64:	00a03533          	snez	a0,a0
    80002f68:	40a00533          	neg	a0,a0
}
    80002f6c:	60e2                	ld	ra,24(sp)
    80002f6e:	6442                	ld	s0,16(sp)
    80002f70:	64a2                	ld	s1,8(sp)
    80002f72:	6902                	ld	s2,0(sp)
    80002f74:	6105                	addi	sp,sp,32
    80002f76:	8082                	ret
        return -1;
    80002f78:	557d                	li	a0,-1
    80002f7a:	bfcd                	j	80002f6c <fetchaddr+0x3e>
    80002f7c:	557d                	li	a0,-1
    80002f7e:	b7fd                	j	80002f6c <fetchaddr+0x3e>

0000000080002f80 <fetchstr>:
{
    80002f80:	7179                	addi	sp,sp,-48
    80002f82:	f406                	sd	ra,40(sp)
    80002f84:	f022                	sd	s0,32(sp)
    80002f86:	ec26                	sd	s1,24(sp)
    80002f88:	e84a                	sd	s2,16(sp)
    80002f8a:	e44e                	sd	s3,8(sp)
    80002f8c:	1800                	addi	s0,sp,48
    80002f8e:	892a                	mv	s2,a0
    80002f90:	84ae                	mv	s1,a1
    80002f92:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	cd2080e7          	jalr	-814(ra) # 80001c66 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002f9c:	86ce                	mv	a3,s3
    80002f9e:	864a                	mv	a2,s2
    80002fa0:	85a6                	mv	a1,s1
    80002fa2:	6d28                	ld	a0,88(a0)
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	828080e7          	jalr	-2008(ra) # 800017cc <copyinstr>
    80002fac:	00054e63          	bltz	a0,80002fc8 <fetchstr+0x48>
    return strlen(buf);
    80002fb0:	8526                	mv	a0,s1
    80002fb2:	ffffe097          	auipc	ra,0xffffe
    80002fb6:	ee2080e7          	jalr	-286(ra) # 80000e94 <strlen>
}
    80002fba:	70a2                	ld	ra,40(sp)
    80002fbc:	7402                	ld	s0,32(sp)
    80002fbe:	64e2                	ld	s1,24(sp)
    80002fc0:	6942                	ld	s2,16(sp)
    80002fc2:	69a2                	ld	s3,8(sp)
    80002fc4:	6145                	addi	sp,sp,48
    80002fc6:	8082                	ret
        return -1;
    80002fc8:	557d                	li	a0,-1
    80002fca:	bfc5                	j	80002fba <fetchstr+0x3a>

0000000080002fcc <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002fcc:	1101                	addi	sp,sp,-32
    80002fce:	ec06                	sd	ra,24(sp)
    80002fd0:	e822                	sd	s0,16(sp)
    80002fd2:	e426                	sd	s1,8(sp)
    80002fd4:	1000                	addi	s0,sp,32
    80002fd6:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	eee080e7          	jalr	-274(ra) # 80002ec6 <argraw>
    80002fe0:	c088                	sw	a0,0(s1)
}
    80002fe2:	60e2                	ld	ra,24(sp)
    80002fe4:	6442                	ld	s0,16(sp)
    80002fe6:	64a2                	ld	s1,8(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret

0000000080002fec <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002fec:	1101                	addi	sp,sp,-32
    80002fee:	ec06                	sd	ra,24(sp)
    80002ff0:	e822                	sd	s0,16(sp)
    80002ff2:	e426                	sd	s1,8(sp)
    80002ff4:	1000                	addi	s0,sp,32
    80002ff6:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002ff8:	00000097          	auipc	ra,0x0
    80002ffc:	ece080e7          	jalr	-306(ra) # 80002ec6 <argraw>
    80003000:	e088                	sd	a0,0(s1)
}
    80003002:	60e2                	ld	ra,24(sp)
    80003004:	6442                	ld	s0,16(sp)
    80003006:	64a2                	ld	s1,8(sp)
    80003008:	6105                	addi	sp,sp,32
    8000300a:	8082                	ret

000000008000300c <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    8000300c:	7179                	addi	sp,sp,-48
    8000300e:	f406                	sd	ra,40(sp)
    80003010:	f022                	sd	s0,32(sp)
    80003012:	ec26                	sd	s1,24(sp)
    80003014:	e84a                	sd	s2,16(sp)
    80003016:	1800                	addi	s0,sp,48
    80003018:	84ae                	mv	s1,a1
    8000301a:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    8000301c:	fd840593          	addi	a1,s0,-40
    80003020:	00000097          	auipc	ra,0x0
    80003024:	fcc080e7          	jalr	-52(ra) # 80002fec <argaddr>
    return fetchstr(addr, buf, max);
    80003028:	864a                	mv	a2,s2
    8000302a:	85a6                	mv	a1,s1
    8000302c:	fd843503          	ld	a0,-40(s0)
    80003030:	00000097          	auipc	ra,0x0
    80003034:	f50080e7          	jalr	-176(ra) # 80002f80 <fetchstr>
}
    80003038:	70a2                	ld	ra,40(sp)
    8000303a:	7402                	ld	s0,32(sp)
    8000303c:	64e2                	ld	s1,24(sp)
    8000303e:	6942                	ld	s2,16(sp)
    80003040:	6145                	addi	sp,sp,48
    80003042:	8082                	ret

0000000080003044 <syscall>:
    [SYS_schedls] sys_schedls,
    [SYS_schedset] sys_schedset,
};

void syscall(void)
{
    80003044:	1101                	addi	sp,sp,-32
    80003046:	ec06                	sd	ra,24(sp)
    80003048:	e822                	sd	s0,16(sp)
    8000304a:	e426                	sd	s1,8(sp)
    8000304c:	e04a                	sd	s2,0(sp)
    8000304e:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80003050:	fffff097          	auipc	ra,0xfffff
    80003054:	c16080e7          	jalr	-1002(ra) # 80001c66 <myproc>
    80003058:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    8000305a:	06053903          	ld	s2,96(a0)
    8000305e:	0a893783          	ld	a5,168(s2)
    80003062:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80003066:	37fd                	addiw	a5,a5,-1
    80003068:	475d                	li	a4,23
    8000306a:	00f76f63          	bltu	a4,a5,80003088 <syscall+0x44>
    8000306e:	00369713          	slli	a4,a3,0x3
    80003072:	00005797          	auipc	a5,0x5
    80003076:	48678793          	addi	a5,a5,1158 # 800084f8 <syscalls>
    8000307a:	97ba                	add	a5,a5,a4
    8000307c:	639c                	ld	a5,0(a5)
    8000307e:	c789                	beqz	a5,80003088 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003080:	9782                	jalr	a5
    80003082:	06a93823          	sd	a0,112(s2)
    80003086:	a839                	j	800030a4 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80003088:	16048613          	addi	a2,s1,352
    8000308c:	588c                	lw	a1,48(s1)
    8000308e:	00005517          	auipc	a0,0x5
    80003092:	43250513          	addi	a0,a0,1074 # 800084c0 <states.0+0x150>
    80003096:	ffffd097          	auipc	ra,0xffffd
    8000309a:	53a080e7          	jalr	1338(ra) # 800005d0 <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    8000309e:	70bc                	ld	a5,96(s1)
    800030a0:	577d                	li	a4,-1
    800030a2:	fbb8                	sd	a4,112(a5)
    }
}
    800030a4:	60e2                	ld	ra,24(sp)
    800030a6:	6442                	ld	s0,16(sp)
    800030a8:	64a2                	ld	s1,8(sp)
    800030aa:	6902                	ld	s2,0(sp)
    800030ac:	6105                	addi	sp,sp,32
    800030ae:	8082                	ret

00000000800030b0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800030b0:	1101                	addi	sp,sp,-32
    800030b2:	ec06                	sd	ra,24(sp)
    800030b4:	e822                	sd	s0,16(sp)
    800030b6:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    800030b8:	fec40593          	addi	a1,s0,-20
    800030bc:	4501                	li	a0,0
    800030be:	00000097          	auipc	ra,0x0
    800030c2:	f0e080e7          	jalr	-242(ra) # 80002fcc <argint>
    exit(n);
    800030c6:	fec42503          	lw	a0,-20(s0)
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	496080e7          	jalr	1174(ra) # 80002560 <exit>
    return 0; // not reached
}
    800030d2:	4501                	li	a0,0
    800030d4:	60e2                	ld	ra,24(sp)
    800030d6:	6442                	ld	s0,16(sp)
    800030d8:	6105                	addi	sp,sp,32
    800030da:	8082                	ret

00000000800030dc <sys_getpid>:

uint64
sys_getpid(void)
{
    800030dc:	1141                	addi	sp,sp,-16
    800030de:	e406                	sd	ra,8(sp)
    800030e0:	e022                	sd	s0,0(sp)
    800030e2:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800030e4:	fffff097          	auipc	ra,0xfffff
    800030e8:	b82080e7          	jalr	-1150(ra) # 80001c66 <myproc>
}
    800030ec:	5908                	lw	a0,48(a0)
    800030ee:	60a2                	ld	ra,8(sp)
    800030f0:	6402                	ld	s0,0(sp)
    800030f2:	0141                	addi	sp,sp,16
    800030f4:	8082                	ret

00000000800030f6 <sys_fork>:

uint64
sys_fork(void)
{
    800030f6:	1141                	addi	sp,sp,-16
    800030f8:	e406                	sd	ra,8(sp)
    800030fa:	e022                	sd	s0,0(sp)
    800030fc:	0800                	addi	s0,sp,16
    return fork();
    800030fe:	fffff097          	auipc	ra,0xfffff
    80003102:	076080e7          	jalr	118(ra) # 80002174 <fork>
}
    80003106:	60a2                	ld	ra,8(sp)
    80003108:	6402                	ld	s0,0(sp)
    8000310a:	0141                	addi	sp,sp,16
    8000310c:	8082                	ret

000000008000310e <sys_wait>:

uint64
sys_wait(void)
{
    8000310e:	1101                	addi	sp,sp,-32
    80003110:	ec06                	sd	ra,24(sp)
    80003112:	e822                	sd	s0,16(sp)
    80003114:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80003116:	fe840593          	addi	a1,s0,-24
    8000311a:	4501                	li	a0,0
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	ed0080e7          	jalr	-304(ra) # 80002fec <argaddr>
    return wait(p);
    80003124:	fe843503          	ld	a0,-24(s0)
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	5de080e7          	jalr	1502(ra) # 80002706 <wait>
}
    80003130:	60e2                	ld	ra,24(sp)
    80003132:	6442                	ld	s0,16(sp)
    80003134:	6105                	addi	sp,sp,32
    80003136:	8082                	ret

0000000080003138 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003138:	7179                	addi	sp,sp,-48
    8000313a:	f406                	sd	ra,40(sp)
    8000313c:	f022                	sd	s0,32(sp)
    8000313e:	ec26                	sd	s1,24(sp)
    80003140:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80003142:	fdc40593          	addi	a1,s0,-36
    80003146:	4501                	li	a0,0
    80003148:	00000097          	auipc	ra,0x0
    8000314c:	e84080e7          	jalr	-380(ra) # 80002fcc <argint>
    addr = myproc()->sz;
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	b16080e7          	jalr	-1258(ra) # 80001c66 <myproc>
    80003158:	6924                	ld	s1,80(a0)
    if (growproc(n) < 0)
    8000315a:	fdc42503          	lw	a0,-36(s0)
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	e6a080e7          	jalr	-406(ra) # 80001fc8 <growproc>
    80003166:	00054863          	bltz	a0,80003176 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    8000316a:	8526                	mv	a0,s1
    8000316c:	70a2                	ld	ra,40(sp)
    8000316e:	7402                	ld	s0,32(sp)
    80003170:	64e2                	ld	s1,24(sp)
    80003172:	6145                	addi	sp,sp,48
    80003174:	8082                	ret
        return -1;
    80003176:	54fd                	li	s1,-1
    80003178:	bfcd                	j	8000316a <sys_sbrk+0x32>

000000008000317a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000317a:	7139                	addi	sp,sp,-64
    8000317c:	fc06                	sd	ra,56(sp)
    8000317e:	f822                	sd	s0,48(sp)
    80003180:	f426                	sd	s1,40(sp)
    80003182:	f04a                	sd	s2,32(sp)
    80003184:	ec4e                	sd	s3,24(sp)
    80003186:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80003188:	fcc40593          	addi	a1,s0,-52
    8000318c:	4501                	li	a0,0
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	e3e080e7          	jalr	-450(ra) # 80002fcc <argint>
    acquire(&tickslock);
    80003196:	00014517          	auipc	a0,0x14
    8000319a:	afa50513          	addi	a0,a0,-1286 # 80016c90 <tickslock>
    8000319e:	ffffe097          	auipc	ra,0xffffe
    800031a2:	a7e080e7          	jalr	-1410(ra) # 80000c1c <acquire>
    ticks0 = ticks;
    800031a6:	00006917          	auipc	s2,0x6
    800031aa:	84a92903          	lw	s2,-1974(s2) # 800089f0 <ticks>
    while (ticks - ticks0 < n)
    800031ae:	fcc42783          	lw	a5,-52(s0)
    800031b2:	cf9d                	beqz	a5,800031f0 <sys_sleep+0x76>
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800031b4:	00014997          	auipc	s3,0x14
    800031b8:	adc98993          	addi	s3,s3,-1316 # 80016c90 <tickslock>
    800031bc:	00006497          	auipc	s1,0x6
    800031c0:	83448493          	addi	s1,s1,-1996 # 800089f0 <ticks>
        if (killed(myproc()))
    800031c4:	fffff097          	auipc	ra,0xfffff
    800031c8:	aa2080e7          	jalr	-1374(ra) # 80001c66 <myproc>
    800031cc:	fffff097          	auipc	ra,0xfffff
    800031d0:	508080e7          	jalr	1288(ra) # 800026d4 <killed>
    800031d4:	ed15                	bnez	a0,80003210 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    800031d6:	85ce                	mv	a1,s3
    800031d8:	8526                	mv	a0,s1
    800031da:	fffff097          	auipc	ra,0xfffff
    800031de:	252080e7          	jalr	594(ra) # 8000242c <sleep>
    while (ticks - ticks0 < n)
    800031e2:	409c                	lw	a5,0(s1)
    800031e4:	412787bb          	subw	a5,a5,s2
    800031e8:	fcc42703          	lw	a4,-52(s0)
    800031ec:	fce7ece3          	bltu	a5,a4,800031c4 <sys_sleep+0x4a>
    }
    release(&tickslock);
    800031f0:	00014517          	auipc	a0,0x14
    800031f4:	aa050513          	addi	a0,a0,-1376 # 80016c90 <tickslock>
    800031f8:	ffffe097          	auipc	ra,0xffffe
    800031fc:	ad8080e7          	jalr	-1320(ra) # 80000cd0 <release>
    return 0;
    80003200:	4501                	li	a0,0
}
    80003202:	70e2                	ld	ra,56(sp)
    80003204:	7442                	ld	s0,48(sp)
    80003206:	74a2                	ld	s1,40(sp)
    80003208:	7902                	ld	s2,32(sp)
    8000320a:	69e2                	ld	s3,24(sp)
    8000320c:	6121                	addi	sp,sp,64
    8000320e:	8082                	ret
            release(&tickslock);
    80003210:	00014517          	auipc	a0,0x14
    80003214:	a8050513          	addi	a0,a0,-1408 # 80016c90 <tickslock>
    80003218:	ffffe097          	auipc	ra,0xffffe
    8000321c:	ab8080e7          	jalr	-1352(ra) # 80000cd0 <release>
            return -1;
    80003220:	557d                	li	a0,-1
    80003222:	b7c5                	j	80003202 <sys_sleep+0x88>

0000000080003224 <sys_kill>:

uint64
sys_kill(void)
{
    80003224:	1101                	addi	sp,sp,-32
    80003226:	ec06                	sd	ra,24(sp)
    80003228:	e822                	sd	s0,16(sp)
    8000322a:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    8000322c:	fec40593          	addi	a1,s0,-20
    80003230:	4501                	li	a0,0
    80003232:	00000097          	auipc	ra,0x0
    80003236:	d9a080e7          	jalr	-614(ra) # 80002fcc <argint>
    return kill(pid);
    8000323a:	fec42503          	lw	a0,-20(s0)
    8000323e:	fffff097          	auipc	ra,0xfffff
    80003242:	3f8080e7          	jalr	1016(ra) # 80002636 <kill>
}
    80003246:	60e2                	ld	ra,24(sp)
    80003248:	6442                	ld	s0,16(sp)
    8000324a:	6105                	addi	sp,sp,32
    8000324c:	8082                	ret

000000008000324e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000324e:	1101                	addi	sp,sp,-32
    80003250:	ec06                	sd	ra,24(sp)
    80003252:	e822                	sd	s0,16(sp)
    80003254:	e426                	sd	s1,8(sp)
    80003256:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    80003258:	00014517          	auipc	a0,0x14
    8000325c:	a3850513          	addi	a0,a0,-1480 # 80016c90 <tickslock>
    80003260:	ffffe097          	auipc	ra,0xffffe
    80003264:	9bc080e7          	jalr	-1604(ra) # 80000c1c <acquire>
    xticks = ticks;
    80003268:	00005497          	auipc	s1,0x5
    8000326c:	7884a483          	lw	s1,1928(s1) # 800089f0 <ticks>
    release(&tickslock);
    80003270:	00014517          	auipc	a0,0x14
    80003274:	a2050513          	addi	a0,a0,-1504 # 80016c90 <tickslock>
    80003278:	ffffe097          	auipc	ra,0xffffe
    8000327c:	a58080e7          	jalr	-1448(ra) # 80000cd0 <release>
    return xticks;
}
    80003280:	02049513          	slli	a0,s1,0x20
    80003284:	9101                	srli	a0,a0,0x20
    80003286:	60e2                	ld	ra,24(sp)
    80003288:	6442                	ld	s0,16(sp)
    8000328a:	64a2                	ld	s1,8(sp)
    8000328c:	6105                	addi	sp,sp,32
    8000328e:	8082                	ret

0000000080003290 <sys_ps>:

void *
sys_ps(void)
{
    80003290:	1101                	addi	sp,sp,-32
    80003292:	ec06                	sd	ra,24(sp)
    80003294:	e822                	sd	s0,16(sp)
    80003296:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003298:	fe042623          	sw	zero,-20(s0)
    8000329c:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    800032a0:	fec40593          	addi	a1,s0,-20
    800032a4:	4501                	li	a0,0
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	d26080e7          	jalr	-730(ra) # 80002fcc <argint>
    argint(1, &count);
    800032ae:	fe840593          	addi	a1,s0,-24
    800032b2:	4505                	li	a0,1
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	d18080e7          	jalr	-744(ra) # 80002fcc <argint>
    return ps((uint8)start, (uint8)count);
    800032bc:	fe844583          	lbu	a1,-24(s0)
    800032c0:	fec44503          	lbu	a0,-20(s0)
    800032c4:	fffff097          	auipc	ra,0xfffff
    800032c8:	d60080e7          	jalr	-672(ra) # 80002024 <ps>
}
    800032cc:	60e2                	ld	ra,24(sp)
    800032ce:	6442                	ld	s0,16(sp)
    800032d0:	6105                	addi	sp,sp,32
    800032d2:	8082                	ret

00000000800032d4 <sys_schedls>:

uint64 sys_schedls(void)
{
    800032d4:	1141                	addi	sp,sp,-16
    800032d6:	e406                	sd	ra,8(sp)
    800032d8:	e022                	sd	s0,0(sp)
    800032da:	0800                	addi	s0,sp,16
    schedls();
    800032dc:	fffff097          	auipc	ra,0xfffff
    800032e0:	6b4080e7          	jalr	1716(ra) # 80002990 <schedls>
    return 0;
}
    800032e4:	4501                	li	a0,0
    800032e6:	60a2                	ld	ra,8(sp)
    800032e8:	6402                	ld	s0,0(sp)
    800032ea:	0141                	addi	sp,sp,16
    800032ec:	8082                	ret

00000000800032ee <sys_schedset>:

uint64 sys_schedset(void)
{
    800032ee:	1101                	addi	sp,sp,-32
    800032f0:	ec06                	sd	ra,24(sp)
    800032f2:	e822                	sd	s0,16(sp)
    800032f4:	1000                	addi	s0,sp,32
    int id = 0;
    800032f6:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    800032fa:	fec40593          	addi	a1,s0,-20
    800032fe:	4501                	li	a0,0
    80003300:	00000097          	auipc	ra,0x0
    80003304:	ccc080e7          	jalr	-820(ra) # 80002fcc <argint>
    schedset(id);
    80003308:	fec42503          	lw	a0,-20(s0)
    8000330c:	fffff097          	auipc	ra,0xfffff
    80003310:	770080e7          	jalr	1904(ra) # 80002a7c <schedset>
    return 0;
    80003314:	4501                	li	a0,0
    80003316:	60e2                	ld	ra,24(sp)
    80003318:	6442                	ld	s0,16(sp)
    8000331a:	6105                	addi	sp,sp,32
    8000331c:	8082                	ret

000000008000331e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000331e:	7179                	addi	sp,sp,-48
    80003320:	f406                	sd	ra,40(sp)
    80003322:	f022                	sd	s0,32(sp)
    80003324:	ec26                	sd	s1,24(sp)
    80003326:	e84a                	sd	s2,16(sp)
    80003328:	e44e                	sd	s3,8(sp)
    8000332a:	e052                	sd	s4,0(sp)
    8000332c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000332e:	00005597          	auipc	a1,0x5
    80003332:	29258593          	addi	a1,a1,658 # 800085c0 <syscalls+0xc8>
    80003336:	00014517          	auipc	a0,0x14
    8000333a:	97250513          	addi	a0,a0,-1678 # 80016ca8 <bcache>
    8000333e:	ffffe097          	auipc	ra,0xffffe
    80003342:	84e080e7          	jalr	-1970(ra) # 80000b8c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003346:	0001c797          	auipc	a5,0x1c
    8000334a:	96278793          	addi	a5,a5,-1694 # 8001eca8 <bcache+0x8000>
    8000334e:	0001c717          	auipc	a4,0x1c
    80003352:	bc270713          	addi	a4,a4,-1086 # 8001ef10 <bcache+0x8268>
    80003356:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000335a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000335e:	00014497          	auipc	s1,0x14
    80003362:	96248493          	addi	s1,s1,-1694 # 80016cc0 <bcache+0x18>
    b->next = bcache.head.next;
    80003366:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003368:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000336a:	00005a17          	auipc	s4,0x5
    8000336e:	25ea0a13          	addi	s4,s4,606 # 800085c8 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003372:	2b893783          	ld	a5,696(s2)
    80003376:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003378:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000337c:	85d2                	mv	a1,s4
    8000337e:	01048513          	addi	a0,s1,16
    80003382:	00001097          	auipc	ra,0x1
    80003386:	4c8080e7          	jalr	1224(ra) # 8000484a <initsleeplock>
    bcache.head.next->prev = b;
    8000338a:	2b893783          	ld	a5,696(s2)
    8000338e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003390:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003394:	45848493          	addi	s1,s1,1112
    80003398:	fd349de3          	bne	s1,s3,80003372 <binit+0x54>
  }
}
    8000339c:	70a2                	ld	ra,40(sp)
    8000339e:	7402                	ld	s0,32(sp)
    800033a0:	64e2                	ld	s1,24(sp)
    800033a2:	6942                	ld	s2,16(sp)
    800033a4:	69a2                	ld	s3,8(sp)
    800033a6:	6a02                	ld	s4,0(sp)
    800033a8:	6145                	addi	sp,sp,48
    800033aa:	8082                	ret

00000000800033ac <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800033ac:	7179                	addi	sp,sp,-48
    800033ae:	f406                	sd	ra,40(sp)
    800033b0:	f022                	sd	s0,32(sp)
    800033b2:	ec26                	sd	s1,24(sp)
    800033b4:	e84a                	sd	s2,16(sp)
    800033b6:	e44e                	sd	s3,8(sp)
    800033b8:	1800                	addi	s0,sp,48
    800033ba:	892a                	mv	s2,a0
    800033bc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800033be:	00014517          	auipc	a0,0x14
    800033c2:	8ea50513          	addi	a0,a0,-1814 # 80016ca8 <bcache>
    800033c6:	ffffe097          	auipc	ra,0xffffe
    800033ca:	856080e7          	jalr	-1962(ra) # 80000c1c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800033ce:	0001c497          	auipc	s1,0x1c
    800033d2:	b924b483          	ld	s1,-1134(s1) # 8001ef60 <bcache+0x82b8>
    800033d6:	0001c797          	auipc	a5,0x1c
    800033da:	b3a78793          	addi	a5,a5,-1222 # 8001ef10 <bcache+0x8268>
    800033de:	02f48f63          	beq	s1,a5,8000341c <bread+0x70>
    800033e2:	873e                	mv	a4,a5
    800033e4:	a021                	j	800033ec <bread+0x40>
    800033e6:	68a4                	ld	s1,80(s1)
    800033e8:	02e48a63          	beq	s1,a4,8000341c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800033ec:	449c                	lw	a5,8(s1)
    800033ee:	ff279ce3          	bne	a5,s2,800033e6 <bread+0x3a>
    800033f2:	44dc                	lw	a5,12(s1)
    800033f4:	ff3799e3          	bne	a5,s3,800033e6 <bread+0x3a>
      b->refcnt++;
    800033f8:	40bc                	lw	a5,64(s1)
    800033fa:	2785                	addiw	a5,a5,1
    800033fc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800033fe:	00014517          	auipc	a0,0x14
    80003402:	8aa50513          	addi	a0,a0,-1878 # 80016ca8 <bcache>
    80003406:	ffffe097          	auipc	ra,0xffffe
    8000340a:	8ca080e7          	jalr	-1846(ra) # 80000cd0 <release>
      acquiresleep(&b->lock);
    8000340e:	01048513          	addi	a0,s1,16
    80003412:	00001097          	auipc	ra,0x1
    80003416:	472080e7          	jalr	1138(ra) # 80004884 <acquiresleep>
      return b;
    8000341a:	a8b9                	j	80003478 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000341c:	0001c497          	auipc	s1,0x1c
    80003420:	b3c4b483          	ld	s1,-1220(s1) # 8001ef58 <bcache+0x82b0>
    80003424:	0001c797          	auipc	a5,0x1c
    80003428:	aec78793          	addi	a5,a5,-1300 # 8001ef10 <bcache+0x8268>
    8000342c:	00f48863          	beq	s1,a5,8000343c <bread+0x90>
    80003430:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003432:	40bc                	lw	a5,64(s1)
    80003434:	cf81                	beqz	a5,8000344c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003436:	64a4                	ld	s1,72(s1)
    80003438:	fee49de3          	bne	s1,a4,80003432 <bread+0x86>
  panic("bget: no buffers");
    8000343c:	00005517          	auipc	a0,0x5
    80003440:	19450513          	addi	a0,a0,404 # 800085d0 <syscalls+0xd8>
    80003444:	ffffd097          	auipc	ra,0xffffd
    80003448:	142080e7          	jalr	322(ra) # 80000586 <panic>
      b->dev = dev;
    8000344c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003450:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003454:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003458:	4785                	li	a5,1
    8000345a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000345c:	00014517          	auipc	a0,0x14
    80003460:	84c50513          	addi	a0,a0,-1972 # 80016ca8 <bcache>
    80003464:	ffffe097          	auipc	ra,0xffffe
    80003468:	86c080e7          	jalr	-1940(ra) # 80000cd0 <release>
      acquiresleep(&b->lock);
    8000346c:	01048513          	addi	a0,s1,16
    80003470:	00001097          	auipc	ra,0x1
    80003474:	414080e7          	jalr	1044(ra) # 80004884 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003478:	409c                	lw	a5,0(s1)
    8000347a:	cb89                	beqz	a5,8000348c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000347c:	8526                	mv	a0,s1
    8000347e:	70a2                	ld	ra,40(sp)
    80003480:	7402                	ld	s0,32(sp)
    80003482:	64e2                	ld	s1,24(sp)
    80003484:	6942                	ld	s2,16(sp)
    80003486:	69a2                	ld	s3,8(sp)
    80003488:	6145                	addi	sp,sp,48
    8000348a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000348c:	4581                	li	a1,0
    8000348e:	8526                	mv	a0,s1
    80003490:	00003097          	auipc	ra,0x3
    80003494:	fe2080e7          	jalr	-30(ra) # 80006472 <virtio_disk_rw>
    b->valid = 1;
    80003498:	4785                	li	a5,1
    8000349a:	c09c                	sw	a5,0(s1)
  return b;
    8000349c:	b7c5                	j	8000347c <bread+0xd0>

000000008000349e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000349e:	1101                	addi	sp,sp,-32
    800034a0:	ec06                	sd	ra,24(sp)
    800034a2:	e822                	sd	s0,16(sp)
    800034a4:	e426                	sd	s1,8(sp)
    800034a6:	1000                	addi	s0,sp,32
    800034a8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034aa:	0541                	addi	a0,a0,16
    800034ac:	00001097          	auipc	ra,0x1
    800034b0:	472080e7          	jalr	1138(ra) # 8000491e <holdingsleep>
    800034b4:	cd01                	beqz	a0,800034cc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034b6:	4585                	li	a1,1
    800034b8:	8526                	mv	a0,s1
    800034ba:	00003097          	auipc	ra,0x3
    800034be:	fb8080e7          	jalr	-72(ra) # 80006472 <virtio_disk_rw>
}
    800034c2:	60e2                	ld	ra,24(sp)
    800034c4:	6442                	ld	s0,16(sp)
    800034c6:	64a2                	ld	s1,8(sp)
    800034c8:	6105                	addi	sp,sp,32
    800034ca:	8082                	ret
    panic("bwrite");
    800034cc:	00005517          	auipc	a0,0x5
    800034d0:	11c50513          	addi	a0,a0,284 # 800085e8 <syscalls+0xf0>
    800034d4:	ffffd097          	auipc	ra,0xffffd
    800034d8:	0b2080e7          	jalr	178(ra) # 80000586 <panic>

00000000800034dc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800034dc:	1101                	addi	sp,sp,-32
    800034de:	ec06                	sd	ra,24(sp)
    800034e0:	e822                	sd	s0,16(sp)
    800034e2:	e426                	sd	s1,8(sp)
    800034e4:	e04a                	sd	s2,0(sp)
    800034e6:	1000                	addi	s0,sp,32
    800034e8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034ea:	01050913          	addi	s2,a0,16
    800034ee:	854a                	mv	a0,s2
    800034f0:	00001097          	auipc	ra,0x1
    800034f4:	42e080e7          	jalr	1070(ra) # 8000491e <holdingsleep>
    800034f8:	c92d                	beqz	a0,8000356a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800034fa:	854a                	mv	a0,s2
    800034fc:	00001097          	auipc	ra,0x1
    80003500:	3de080e7          	jalr	990(ra) # 800048da <releasesleep>

  acquire(&bcache.lock);
    80003504:	00013517          	auipc	a0,0x13
    80003508:	7a450513          	addi	a0,a0,1956 # 80016ca8 <bcache>
    8000350c:	ffffd097          	auipc	ra,0xffffd
    80003510:	710080e7          	jalr	1808(ra) # 80000c1c <acquire>
  b->refcnt--;
    80003514:	40bc                	lw	a5,64(s1)
    80003516:	37fd                	addiw	a5,a5,-1
    80003518:	0007871b          	sext.w	a4,a5
    8000351c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000351e:	eb05                	bnez	a4,8000354e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003520:	68bc                	ld	a5,80(s1)
    80003522:	64b8                	ld	a4,72(s1)
    80003524:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003526:	64bc                	ld	a5,72(s1)
    80003528:	68b8                	ld	a4,80(s1)
    8000352a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000352c:	0001b797          	auipc	a5,0x1b
    80003530:	77c78793          	addi	a5,a5,1916 # 8001eca8 <bcache+0x8000>
    80003534:	2b87b703          	ld	a4,696(a5)
    80003538:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000353a:	0001c717          	auipc	a4,0x1c
    8000353e:	9d670713          	addi	a4,a4,-1578 # 8001ef10 <bcache+0x8268>
    80003542:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003544:	2b87b703          	ld	a4,696(a5)
    80003548:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000354a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000354e:	00013517          	auipc	a0,0x13
    80003552:	75a50513          	addi	a0,a0,1882 # 80016ca8 <bcache>
    80003556:	ffffd097          	auipc	ra,0xffffd
    8000355a:	77a080e7          	jalr	1914(ra) # 80000cd0 <release>
}
    8000355e:	60e2                	ld	ra,24(sp)
    80003560:	6442                	ld	s0,16(sp)
    80003562:	64a2                	ld	s1,8(sp)
    80003564:	6902                	ld	s2,0(sp)
    80003566:	6105                	addi	sp,sp,32
    80003568:	8082                	ret
    panic("brelse");
    8000356a:	00005517          	auipc	a0,0x5
    8000356e:	08650513          	addi	a0,a0,134 # 800085f0 <syscalls+0xf8>
    80003572:	ffffd097          	auipc	ra,0xffffd
    80003576:	014080e7          	jalr	20(ra) # 80000586 <panic>

000000008000357a <bpin>:

void
bpin(struct buf *b) {
    8000357a:	1101                	addi	sp,sp,-32
    8000357c:	ec06                	sd	ra,24(sp)
    8000357e:	e822                	sd	s0,16(sp)
    80003580:	e426                	sd	s1,8(sp)
    80003582:	1000                	addi	s0,sp,32
    80003584:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003586:	00013517          	auipc	a0,0x13
    8000358a:	72250513          	addi	a0,a0,1826 # 80016ca8 <bcache>
    8000358e:	ffffd097          	auipc	ra,0xffffd
    80003592:	68e080e7          	jalr	1678(ra) # 80000c1c <acquire>
  b->refcnt++;
    80003596:	40bc                	lw	a5,64(s1)
    80003598:	2785                	addiw	a5,a5,1
    8000359a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000359c:	00013517          	auipc	a0,0x13
    800035a0:	70c50513          	addi	a0,a0,1804 # 80016ca8 <bcache>
    800035a4:	ffffd097          	auipc	ra,0xffffd
    800035a8:	72c080e7          	jalr	1836(ra) # 80000cd0 <release>
}
    800035ac:	60e2                	ld	ra,24(sp)
    800035ae:	6442                	ld	s0,16(sp)
    800035b0:	64a2                	ld	s1,8(sp)
    800035b2:	6105                	addi	sp,sp,32
    800035b4:	8082                	ret

00000000800035b6 <bunpin>:

void
bunpin(struct buf *b) {
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	e426                	sd	s1,8(sp)
    800035be:	1000                	addi	s0,sp,32
    800035c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035c2:	00013517          	auipc	a0,0x13
    800035c6:	6e650513          	addi	a0,a0,1766 # 80016ca8 <bcache>
    800035ca:	ffffd097          	auipc	ra,0xffffd
    800035ce:	652080e7          	jalr	1618(ra) # 80000c1c <acquire>
  b->refcnt--;
    800035d2:	40bc                	lw	a5,64(s1)
    800035d4:	37fd                	addiw	a5,a5,-1
    800035d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035d8:	00013517          	auipc	a0,0x13
    800035dc:	6d050513          	addi	a0,a0,1744 # 80016ca8 <bcache>
    800035e0:	ffffd097          	auipc	ra,0xffffd
    800035e4:	6f0080e7          	jalr	1776(ra) # 80000cd0 <release>
}
    800035e8:	60e2                	ld	ra,24(sp)
    800035ea:	6442                	ld	s0,16(sp)
    800035ec:	64a2                	ld	s1,8(sp)
    800035ee:	6105                	addi	sp,sp,32
    800035f0:	8082                	ret

00000000800035f2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800035f2:	1101                	addi	sp,sp,-32
    800035f4:	ec06                	sd	ra,24(sp)
    800035f6:	e822                	sd	s0,16(sp)
    800035f8:	e426                	sd	s1,8(sp)
    800035fa:	e04a                	sd	s2,0(sp)
    800035fc:	1000                	addi	s0,sp,32
    800035fe:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003600:	00d5d59b          	srliw	a1,a1,0xd
    80003604:	0001c797          	auipc	a5,0x1c
    80003608:	d807a783          	lw	a5,-640(a5) # 8001f384 <sb+0x1c>
    8000360c:	9dbd                	addw	a1,a1,a5
    8000360e:	00000097          	auipc	ra,0x0
    80003612:	d9e080e7          	jalr	-610(ra) # 800033ac <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003616:	0074f713          	andi	a4,s1,7
    8000361a:	4785                	li	a5,1
    8000361c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003620:	14ce                	slli	s1,s1,0x33
    80003622:	90d9                	srli	s1,s1,0x36
    80003624:	00950733          	add	a4,a0,s1
    80003628:	05874703          	lbu	a4,88(a4)
    8000362c:	00e7f6b3          	and	a3,a5,a4
    80003630:	c69d                	beqz	a3,8000365e <bfree+0x6c>
    80003632:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003634:	94aa                	add	s1,s1,a0
    80003636:	fff7c793          	not	a5,a5
    8000363a:	8f7d                	and	a4,a4,a5
    8000363c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003640:	00001097          	auipc	ra,0x1
    80003644:	126080e7          	jalr	294(ra) # 80004766 <log_write>
  brelse(bp);
    80003648:	854a                	mv	a0,s2
    8000364a:	00000097          	auipc	ra,0x0
    8000364e:	e92080e7          	jalr	-366(ra) # 800034dc <brelse>
}
    80003652:	60e2                	ld	ra,24(sp)
    80003654:	6442                	ld	s0,16(sp)
    80003656:	64a2                	ld	s1,8(sp)
    80003658:	6902                	ld	s2,0(sp)
    8000365a:	6105                	addi	sp,sp,32
    8000365c:	8082                	ret
    panic("freeing free block");
    8000365e:	00005517          	auipc	a0,0x5
    80003662:	f9a50513          	addi	a0,a0,-102 # 800085f8 <syscalls+0x100>
    80003666:	ffffd097          	auipc	ra,0xffffd
    8000366a:	f20080e7          	jalr	-224(ra) # 80000586 <panic>

000000008000366e <balloc>:
{
    8000366e:	711d                	addi	sp,sp,-96
    80003670:	ec86                	sd	ra,88(sp)
    80003672:	e8a2                	sd	s0,80(sp)
    80003674:	e4a6                	sd	s1,72(sp)
    80003676:	e0ca                	sd	s2,64(sp)
    80003678:	fc4e                	sd	s3,56(sp)
    8000367a:	f852                	sd	s4,48(sp)
    8000367c:	f456                	sd	s5,40(sp)
    8000367e:	f05a                	sd	s6,32(sp)
    80003680:	ec5e                	sd	s7,24(sp)
    80003682:	e862                	sd	s8,16(sp)
    80003684:	e466                	sd	s9,8(sp)
    80003686:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003688:	0001c797          	auipc	a5,0x1c
    8000368c:	ce47a783          	lw	a5,-796(a5) # 8001f36c <sb+0x4>
    80003690:	cff5                	beqz	a5,8000378c <balloc+0x11e>
    80003692:	8baa                	mv	s7,a0
    80003694:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003696:	0001cb17          	auipc	s6,0x1c
    8000369a:	cd2b0b13          	addi	s6,s6,-814 # 8001f368 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000369e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800036a0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036a2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800036a4:	6c89                	lui	s9,0x2
    800036a6:	a061                	j	8000372e <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800036a8:	97ca                	add	a5,a5,s2
    800036aa:	8e55                	or	a2,a2,a3
    800036ac:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800036b0:	854a                	mv	a0,s2
    800036b2:	00001097          	auipc	ra,0x1
    800036b6:	0b4080e7          	jalr	180(ra) # 80004766 <log_write>
        brelse(bp);
    800036ba:	854a                	mv	a0,s2
    800036bc:	00000097          	auipc	ra,0x0
    800036c0:	e20080e7          	jalr	-480(ra) # 800034dc <brelse>
  bp = bread(dev, bno);
    800036c4:	85a6                	mv	a1,s1
    800036c6:	855e                	mv	a0,s7
    800036c8:	00000097          	auipc	ra,0x0
    800036cc:	ce4080e7          	jalr	-796(ra) # 800033ac <bread>
    800036d0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800036d2:	40000613          	li	a2,1024
    800036d6:	4581                	li	a1,0
    800036d8:	05850513          	addi	a0,a0,88
    800036dc:	ffffd097          	auipc	ra,0xffffd
    800036e0:	63c080e7          	jalr	1596(ra) # 80000d18 <memset>
  log_write(bp);
    800036e4:	854a                	mv	a0,s2
    800036e6:	00001097          	auipc	ra,0x1
    800036ea:	080080e7          	jalr	128(ra) # 80004766 <log_write>
  brelse(bp);
    800036ee:	854a                	mv	a0,s2
    800036f0:	00000097          	auipc	ra,0x0
    800036f4:	dec080e7          	jalr	-532(ra) # 800034dc <brelse>
}
    800036f8:	8526                	mv	a0,s1
    800036fa:	60e6                	ld	ra,88(sp)
    800036fc:	6446                	ld	s0,80(sp)
    800036fe:	64a6                	ld	s1,72(sp)
    80003700:	6906                	ld	s2,64(sp)
    80003702:	79e2                	ld	s3,56(sp)
    80003704:	7a42                	ld	s4,48(sp)
    80003706:	7aa2                	ld	s5,40(sp)
    80003708:	7b02                	ld	s6,32(sp)
    8000370a:	6be2                	ld	s7,24(sp)
    8000370c:	6c42                	ld	s8,16(sp)
    8000370e:	6ca2                	ld	s9,8(sp)
    80003710:	6125                	addi	sp,sp,96
    80003712:	8082                	ret
    brelse(bp);
    80003714:	854a                	mv	a0,s2
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	dc6080e7          	jalr	-570(ra) # 800034dc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000371e:	015c87bb          	addw	a5,s9,s5
    80003722:	00078a9b          	sext.w	s5,a5
    80003726:	004b2703          	lw	a4,4(s6)
    8000372a:	06eaf163          	bgeu	s5,a4,8000378c <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000372e:	41fad79b          	sraiw	a5,s5,0x1f
    80003732:	0137d79b          	srliw	a5,a5,0x13
    80003736:	015787bb          	addw	a5,a5,s5
    8000373a:	40d7d79b          	sraiw	a5,a5,0xd
    8000373e:	01cb2583          	lw	a1,28(s6)
    80003742:	9dbd                	addw	a1,a1,a5
    80003744:	855e                	mv	a0,s7
    80003746:	00000097          	auipc	ra,0x0
    8000374a:	c66080e7          	jalr	-922(ra) # 800033ac <bread>
    8000374e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003750:	004b2503          	lw	a0,4(s6)
    80003754:	000a849b          	sext.w	s1,s5
    80003758:	8762                	mv	a4,s8
    8000375a:	faa4fde3          	bgeu	s1,a0,80003714 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000375e:	00777693          	andi	a3,a4,7
    80003762:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003766:	41f7579b          	sraiw	a5,a4,0x1f
    8000376a:	01d7d79b          	srliw	a5,a5,0x1d
    8000376e:	9fb9                	addw	a5,a5,a4
    80003770:	4037d79b          	sraiw	a5,a5,0x3
    80003774:	00f90633          	add	a2,s2,a5
    80003778:	05864603          	lbu	a2,88(a2)
    8000377c:	00c6f5b3          	and	a1,a3,a2
    80003780:	d585                	beqz	a1,800036a8 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003782:	2705                	addiw	a4,a4,1
    80003784:	2485                	addiw	s1,s1,1
    80003786:	fd471ae3          	bne	a4,s4,8000375a <balloc+0xec>
    8000378a:	b769                	j	80003714 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000378c:	00005517          	auipc	a0,0x5
    80003790:	e8450513          	addi	a0,a0,-380 # 80008610 <syscalls+0x118>
    80003794:	ffffd097          	auipc	ra,0xffffd
    80003798:	e3c080e7          	jalr	-452(ra) # 800005d0 <printf>
  return 0;
    8000379c:	4481                	li	s1,0
    8000379e:	bfa9                	j	800036f8 <balloc+0x8a>

00000000800037a0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800037a0:	7179                	addi	sp,sp,-48
    800037a2:	f406                	sd	ra,40(sp)
    800037a4:	f022                	sd	s0,32(sp)
    800037a6:	ec26                	sd	s1,24(sp)
    800037a8:	e84a                	sd	s2,16(sp)
    800037aa:	e44e                	sd	s3,8(sp)
    800037ac:	e052                	sd	s4,0(sp)
    800037ae:	1800                	addi	s0,sp,48
    800037b0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800037b2:	47ad                	li	a5,11
    800037b4:	02b7e863          	bltu	a5,a1,800037e4 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800037b8:	02059793          	slli	a5,a1,0x20
    800037bc:	01e7d593          	srli	a1,a5,0x1e
    800037c0:	00b504b3          	add	s1,a0,a1
    800037c4:	0504a903          	lw	s2,80(s1)
    800037c8:	06091e63          	bnez	s2,80003844 <bmap+0xa4>
      addr = balloc(ip->dev);
    800037cc:	4108                	lw	a0,0(a0)
    800037ce:	00000097          	auipc	ra,0x0
    800037d2:	ea0080e7          	jalr	-352(ra) # 8000366e <balloc>
    800037d6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800037da:	06090563          	beqz	s2,80003844 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800037de:	0524a823          	sw	s2,80(s1)
    800037e2:	a08d                	j	80003844 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800037e4:	ff45849b          	addiw	s1,a1,-12
    800037e8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800037ec:	0ff00793          	li	a5,255
    800037f0:	08e7e563          	bltu	a5,a4,8000387a <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800037f4:	08052903          	lw	s2,128(a0)
    800037f8:	00091d63          	bnez	s2,80003812 <bmap+0x72>
      addr = balloc(ip->dev);
    800037fc:	4108                	lw	a0,0(a0)
    800037fe:	00000097          	auipc	ra,0x0
    80003802:	e70080e7          	jalr	-400(ra) # 8000366e <balloc>
    80003806:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000380a:	02090d63          	beqz	s2,80003844 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000380e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003812:	85ca                	mv	a1,s2
    80003814:	0009a503          	lw	a0,0(s3)
    80003818:	00000097          	auipc	ra,0x0
    8000381c:	b94080e7          	jalr	-1132(ra) # 800033ac <bread>
    80003820:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003822:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003826:	02049713          	slli	a4,s1,0x20
    8000382a:	01e75593          	srli	a1,a4,0x1e
    8000382e:	00b784b3          	add	s1,a5,a1
    80003832:	0004a903          	lw	s2,0(s1)
    80003836:	02090063          	beqz	s2,80003856 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000383a:	8552                	mv	a0,s4
    8000383c:	00000097          	auipc	ra,0x0
    80003840:	ca0080e7          	jalr	-864(ra) # 800034dc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003844:	854a                	mv	a0,s2
    80003846:	70a2                	ld	ra,40(sp)
    80003848:	7402                	ld	s0,32(sp)
    8000384a:	64e2                	ld	s1,24(sp)
    8000384c:	6942                	ld	s2,16(sp)
    8000384e:	69a2                	ld	s3,8(sp)
    80003850:	6a02                	ld	s4,0(sp)
    80003852:	6145                	addi	sp,sp,48
    80003854:	8082                	ret
      addr = balloc(ip->dev);
    80003856:	0009a503          	lw	a0,0(s3)
    8000385a:	00000097          	auipc	ra,0x0
    8000385e:	e14080e7          	jalr	-492(ra) # 8000366e <balloc>
    80003862:	0005091b          	sext.w	s2,a0
      if(addr){
    80003866:	fc090ae3          	beqz	s2,8000383a <bmap+0x9a>
        a[bn] = addr;
    8000386a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000386e:	8552                	mv	a0,s4
    80003870:	00001097          	auipc	ra,0x1
    80003874:	ef6080e7          	jalr	-266(ra) # 80004766 <log_write>
    80003878:	b7c9                	j	8000383a <bmap+0x9a>
  panic("bmap: out of range");
    8000387a:	00005517          	auipc	a0,0x5
    8000387e:	dae50513          	addi	a0,a0,-594 # 80008628 <syscalls+0x130>
    80003882:	ffffd097          	auipc	ra,0xffffd
    80003886:	d04080e7          	jalr	-764(ra) # 80000586 <panic>

000000008000388a <iget>:
{
    8000388a:	7179                	addi	sp,sp,-48
    8000388c:	f406                	sd	ra,40(sp)
    8000388e:	f022                	sd	s0,32(sp)
    80003890:	ec26                	sd	s1,24(sp)
    80003892:	e84a                	sd	s2,16(sp)
    80003894:	e44e                	sd	s3,8(sp)
    80003896:	e052                	sd	s4,0(sp)
    80003898:	1800                	addi	s0,sp,48
    8000389a:	89aa                	mv	s3,a0
    8000389c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000389e:	0001c517          	auipc	a0,0x1c
    800038a2:	aea50513          	addi	a0,a0,-1302 # 8001f388 <itable>
    800038a6:	ffffd097          	auipc	ra,0xffffd
    800038aa:	376080e7          	jalr	886(ra) # 80000c1c <acquire>
  empty = 0;
    800038ae:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038b0:	0001c497          	auipc	s1,0x1c
    800038b4:	af048493          	addi	s1,s1,-1296 # 8001f3a0 <itable+0x18>
    800038b8:	0001d697          	auipc	a3,0x1d
    800038bc:	57868693          	addi	a3,a3,1400 # 80020e30 <log>
    800038c0:	a039                	j	800038ce <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800038c2:	02090b63          	beqz	s2,800038f8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038c6:	08848493          	addi	s1,s1,136
    800038ca:	02d48a63          	beq	s1,a3,800038fe <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800038ce:	449c                	lw	a5,8(s1)
    800038d0:	fef059e3          	blez	a5,800038c2 <iget+0x38>
    800038d4:	4098                	lw	a4,0(s1)
    800038d6:	ff3716e3          	bne	a4,s3,800038c2 <iget+0x38>
    800038da:	40d8                	lw	a4,4(s1)
    800038dc:	ff4713e3          	bne	a4,s4,800038c2 <iget+0x38>
      ip->ref++;
    800038e0:	2785                	addiw	a5,a5,1
    800038e2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800038e4:	0001c517          	auipc	a0,0x1c
    800038e8:	aa450513          	addi	a0,a0,-1372 # 8001f388 <itable>
    800038ec:	ffffd097          	auipc	ra,0xffffd
    800038f0:	3e4080e7          	jalr	996(ra) # 80000cd0 <release>
      return ip;
    800038f4:	8926                	mv	s2,s1
    800038f6:	a03d                	j	80003924 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800038f8:	f7f9                	bnez	a5,800038c6 <iget+0x3c>
    800038fa:	8926                	mv	s2,s1
    800038fc:	b7e9                	j	800038c6 <iget+0x3c>
  if(empty == 0)
    800038fe:	02090c63          	beqz	s2,80003936 <iget+0xac>
  ip->dev = dev;
    80003902:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003906:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000390a:	4785                	li	a5,1
    8000390c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003910:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003914:	0001c517          	auipc	a0,0x1c
    80003918:	a7450513          	addi	a0,a0,-1420 # 8001f388 <itable>
    8000391c:	ffffd097          	auipc	ra,0xffffd
    80003920:	3b4080e7          	jalr	948(ra) # 80000cd0 <release>
}
    80003924:	854a                	mv	a0,s2
    80003926:	70a2                	ld	ra,40(sp)
    80003928:	7402                	ld	s0,32(sp)
    8000392a:	64e2                	ld	s1,24(sp)
    8000392c:	6942                	ld	s2,16(sp)
    8000392e:	69a2                	ld	s3,8(sp)
    80003930:	6a02                	ld	s4,0(sp)
    80003932:	6145                	addi	sp,sp,48
    80003934:	8082                	ret
    panic("iget: no inodes");
    80003936:	00005517          	auipc	a0,0x5
    8000393a:	d0a50513          	addi	a0,a0,-758 # 80008640 <syscalls+0x148>
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	c48080e7          	jalr	-952(ra) # 80000586 <panic>

0000000080003946 <fsinit>:
fsinit(int dev) {
    80003946:	7179                	addi	sp,sp,-48
    80003948:	f406                	sd	ra,40(sp)
    8000394a:	f022                	sd	s0,32(sp)
    8000394c:	ec26                	sd	s1,24(sp)
    8000394e:	e84a                	sd	s2,16(sp)
    80003950:	e44e                	sd	s3,8(sp)
    80003952:	1800                	addi	s0,sp,48
    80003954:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003956:	4585                	li	a1,1
    80003958:	00000097          	auipc	ra,0x0
    8000395c:	a54080e7          	jalr	-1452(ra) # 800033ac <bread>
    80003960:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003962:	0001c997          	auipc	s3,0x1c
    80003966:	a0698993          	addi	s3,s3,-1530 # 8001f368 <sb>
    8000396a:	02000613          	li	a2,32
    8000396e:	05850593          	addi	a1,a0,88
    80003972:	854e                	mv	a0,s3
    80003974:	ffffd097          	auipc	ra,0xffffd
    80003978:	400080e7          	jalr	1024(ra) # 80000d74 <memmove>
  brelse(bp);
    8000397c:	8526                	mv	a0,s1
    8000397e:	00000097          	auipc	ra,0x0
    80003982:	b5e080e7          	jalr	-1186(ra) # 800034dc <brelse>
  if(sb.magic != FSMAGIC)
    80003986:	0009a703          	lw	a4,0(s3)
    8000398a:	102037b7          	lui	a5,0x10203
    8000398e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003992:	02f71263          	bne	a4,a5,800039b6 <fsinit+0x70>
  initlog(dev, &sb);
    80003996:	0001c597          	auipc	a1,0x1c
    8000399a:	9d258593          	addi	a1,a1,-1582 # 8001f368 <sb>
    8000399e:	854a                	mv	a0,s2
    800039a0:	00001097          	auipc	ra,0x1
    800039a4:	b4a080e7          	jalr	-1206(ra) # 800044ea <initlog>
}
    800039a8:	70a2                	ld	ra,40(sp)
    800039aa:	7402                	ld	s0,32(sp)
    800039ac:	64e2                	ld	s1,24(sp)
    800039ae:	6942                	ld	s2,16(sp)
    800039b0:	69a2                	ld	s3,8(sp)
    800039b2:	6145                	addi	sp,sp,48
    800039b4:	8082                	ret
    panic("invalid file system");
    800039b6:	00005517          	auipc	a0,0x5
    800039ba:	c9a50513          	addi	a0,a0,-870 # 80008650 <syscalls+0x158>
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	bc8080e7          	jalr	-1080(ra) # 80000586 <panic>

00000000800039c6 <iinit>:
{
    800039c6:	7179                	addi	sp,sp,-48
    800039c8:	f406                	sd	ra,40(sp)
    800039ca:	f022                	sd	s0,32(sp)
    800039cc:	ec26                	sd	s1,24(sp)
    800039ce:	e84a                	sd	s2,16(sp)
    800039d0:	e44e                	sd	s3,8(sp)
    800039d2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800039d4:	00005597          	auipc	a1,0x5
    800039d8:	c9458593          	addi	a1,a1,-876 # 80008668 <syscalls+0x170>
    800039dc:	0001c517          	auipc	a0,0x1c
    800039e0:	9ac50513          	addi	a0,a0,-1620 # 8001f388 <itable>
    800039e4:	ffffd097          	auipc	ra,0xffffd
    800039e8:	1a8080e7          	jalr	424(ra) # 80000b8c <initlock>
  for(i = 0; i < NINODE; i++) {
    800039ec:	0001c497          	auipc	s1,0x1c
    800039f0:	9c448493          	addi	s1,s1,-1596 # 8001f3b0 <itable+0x28>
    800039f4:	0001d997          	auipc	s3,0x1d
    800039f8:	44c98993          	addi	s3,s3,1100 # 80020e40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800039fc:	00005917          	auipc	s2,0x5
    80003a00:	c7490913          	addi	s2,s2,-908 # 80008670 <syscalls+0x178>
    80003a04:	85ca                	mv	a1,s2
    80003a06:	8526                	mv	a0,s1
    80003a08:	00001097          	auipc	ra,0x1
    80003a0c:	e42080e7          	jalr	-446(ra) # 8000484a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a10:	08848493          	addi	s1,s1,136
    80003a14:	ff3498e3          	bne	s1,s3,80003a04 <iinit+0x3e>
}
    80003a18:	70a2                	ld	ra,40(sp)
    80003a1a:	7402                	ld	s0,32(sp)
    80003a1c:	64e2                	ld	s1,24(sp)
    80003a1e:	6942                	ld	s2,16(sp)
    80003a20:	69a2                	ld	s3,8(sp)
    80003a22:	6145                	addi	sp,sp,48
    80003a24:	8082                	ret

0000000080003a26 <ialloc>:
{
    80003a26:	715d                	addi	sp,sp,-80
    80003a28:	e486                	sd	ra,72(sp)
    80003a2a:	e0a2                	sd	s0,64(sp)
    80003a2c:	fc26                	sd	s1,56(sp)
    80003a2e:	f84a                	sd	s2,48(sp)
    80003a30:	f44e                	sd	s3,40(sp)
    80003a32:	f052                	sd	s4,32(sp)
    80003a34:	ec56                	sd	s5,24(sp)
    80003a36:	e85a                	sd	s6,16(sp)
    80003a38:	e45e                	sd	s7,8(sp)
    80003a3a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a3c:	0001c717          	auipc	a4,0x1c
    80003a40:	93872703          	lw	a4,-1736(a4) # 8001f374 <sb+0xc>
    80003a44:	4785                	li	a5,1
    80003a46:	04e7fa63          	bgeu	a5,a4,80003a9a <ialloc+0x74>
    80003a4a:	8aaa                	mv	s5,a0
    80003a4c:	8bae                	mv	s7,a1
    80003a4e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a50:	0001ca17          	auipc	s4,0x1c
    80003a54:	918a0a13          	addi	s4,s4,-1768 # 8001f368 <sb>
    80003a58:	00048b1b          	sext.w	s6,s1
    80003a5c:	0044d593          	srli	a1,s1,0x4
    80003a60:	018a2783          	lw	a5,24(s4)
    80003a64:	9dbd                	addw	a1,a1,a5
    80003a66:	8556                	mv	a0,s5
    80003a68:	00000097          	auipc	ra,0x0
    80003a6c:	944080e7          	jalr	-1724(ra) # 800033ac <bread>
    80003a70:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003a72:	05850993          	addi	s3,a0,88
    80003a76:	00f4f793          	andi	a5,s1,15
    80003a7a:	079a                	slli	a5,a5,0x6
    80003a7c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003a7e:	00099783          	lh	a5,0(s3)
    80003a82:	c3a1                	beqz	a5,80003ac2 <ialloc+0x9c>
    brelse(bp);
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	a58080e7          	jalr	-1448(ra) # 800034dc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a8c:	0485                	addi	s1,s1,1
    80003a8e:	00ca2703          	lw	a4,12(s4)
    80003a92:	0004879b          	sext.w	a5,s1
    80003a96:	fce7e1e3          	bltu	a5,a4,80003a58 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003a9a:	00005517          	auipc	a0,0x5
    80003a9e:	bde50513          	addi	a0,a0,-1058 # 80008678 <syscalls+0x180>
    80003aa2:	ffffd097          	auipc	ra,0xffffd
    80003aa6:	b2e080e7          	jalr	-1234(ra) # 800005d0 <printf>
  return 0;
    80003aaa:	4501                	li	a0,0
}
    80003aac:	60a6                	ld	ra,72(sp)
    80003aae:	6406                	ld	s0,64(sp)
    80003ab0:	74e2                	ld	s1,56(sp)
    80003ab2:	7942                	ld	s2,48(sp)
    80003ab4:	79a2                	ld	s3,40(sp)
    80003ab6:	7a02                	ld	s4,32(sp)
    80003ab8:	6ae2                	ld	s5,24(sp)
    80003aba:	6b42                	ld	s6,16(sp)
    80003abc:	6ba2                	ld	s7,8(sp)
    80003abe:	6161                	addi	sp,sp,80
    80003ac0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003ac2:	04000613          	li	a2,64
    80003ac6:	4581                	li	a1,0
    80003ac8:	854e                	mv	a0,s3
    80003aca:	ffffd097          	auipc	ra,0xffffd
    80003ace:	24e080e7          	jalr	590(ra) # 80000d18 <memset>
      dip->type = type;
    80003ad2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003ad6:	854a                	mv	a0,s2
    80003ad8:	00001097          	auipc	ra,0x1
    80003adc:	c8e080e7          	jalr	-882(ra) # 80004766 <log_write>
      brelse(bp);
    80003ae0:	854a                	mv	a0,s2
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	9fa080e7          	jalr	-1542(ra) # 800034dc <brelse>
      return iget(dev, inum);
    80003aea:	85da                	mv	a1,s6
    80003aec:	8556                	mv	a0,s5
    80003aee:	00000097          	auipc	ra,0x0
    80003af2:	d9c080e7          	jalr	-612(ra) # 8000388a <iget>
    80003af6:	bf5d                	j	80003aac <ialloc+0x86>

0000000080003af8 <iupdate>:
{
    80003af8:	1101                	addi	sp,sp,-32
    80003afa:	ec06                	sd	ra,24(sp)
    80003afc:	e822                	sd	s0,16(sp)
    80003afe:	e426                	sd	s1,8(sp)
    80003b00:	e04a                	sd	s2,0(sp)
    80003b02:	1000                	addi	s0,sp,32
    80003b04:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b06:	415c                	lw	a5,4(a0)
    80003b08:	0047d79b          	srliw	a5,a5,0x4
    80003b0c:	0001c597          	auipc	a1,0x1c
    80003b10:	8745a583          	lw	a1,-1932(a1) # 8001f380 <sb+0x18>
    80003b14:	9dbd                	addw	a1,a1,a5
    80003b16:	4108                	lw	a0,0(a0)
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	894080e7          	jalr	-1900(ra) # 800033ac <bread>
    80003b20:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b22:	05850793          	addi	a5,a0,88
    80003b26:	40d8                	lw	a4,4(s1)
    80003b28:	8b3d                	andi	a4,a4,15
    80003b2a:	071a                	slli	a4,a4,0x6
    80003b2c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003b2e:	04449703          	lh	a4,68(s1)
    80003b32:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003b36:	04649703          	lh	a4,70(s1)
    80003b3a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003b3e:	04849703          	lh	a4,72(s1)
    80003b42:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003b46:	04a49703          	lh	a4,74(s1)
    80003b4a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003b4e:	44f8                	lw	a4,76(s1)
    80003b50:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003b52:	03400613          	li	a2,52
    80003b56:	05048593          	addi	a1,s1,80
    80003b5a:	00c78513          	addi	a0,a5,12
    80003b5e:	ffffd097          	auipc	ra,0xffffd
    80003b62:	216080e7          	jalr	534(ra) # 80000d74 <memmove>
  log_write(bp);
    80003b66:	854a                	mv	a0,s2
    80003b68:	00001097          	auipc	ra,0x1
    80003b6c:	bfe080e7          	jalr	-1026(ra) # 80004766 <log_write>
  brelse(bp);
    80003b70:	854a                	mv	a0,s2
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	96a080e7          	jalr	-1686(ra) # 800034dc <brelse>
}
    80003b7a:	60e2                	ld	ra,24(sp)
    80003b7c:	6442                	ld	s0,16(sp)
    80003b7e:	64a2                	ld	s1,8(sp)
    80003b80:	6902                	ld	s2,0(sp)
    80003b82:	6105                	addi	sp,sp,32
    80003b84:	8082                	ret

0000000080003b86 <idup>:
{
    80003b86:	1101                	addi	sp,sp,-32
    80003b88:	ec06                	sd	ra,24(sp)
    80003b8a:	e822                	sd	s0,16(sp)
    80003b8c:	e426                	sd	s1,8(sp)
    80003b8e:	1000                	addi	s0,sp,32
    80003b90:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b92:	0001b517          	auipc	a0,0x1b
    80003b96:	7f650513          	addi	a0,a0,2038 # 8001f388 <itable>
    80003b9a:	ffffd097          	auipc	ra,0xffffd
    80003b9e:	082080e7          	jalr	130(ra) # 80000c1c <acquire>
  ip->ref++;
    80003ba2:	449c                	lw	a5,8(s1)
    80003ba4:	2785                	addiw	a5,a5,1
    80003ba6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ba8:	0001b517          	auipc	a0,0x1b
    80003bac:	7e050513          	addi	a0,a0,2016 # 8001f388 <itable>
    80003bb0:	ffffd097          	auipc	ra,0xffffd
    80003bb4:	120080e7          	jalr	288(ra) # 80000cd0 <release>
}
    80003bb8:	8526                	mv	a0,s1
    80003bba:	60e2                	ld	ra,24(sp)
    80003bbc:	6442                	ld	s0,16(sp)
    80003bbe:	64a2                	ld	s1,8(sp)
    80003bc0:	6105                	addi	sp,sp,32
    80003bc2:	8082                	ret

0000000080003bc4 <ilock>:
{
    80003bc4:	1101                	addi	sp,sp,-32
    80003bc6:	ec06                	sd	ra,24(sp)
    80003bc8:	e822                	sd	s0,16(sp)
    80003bca:	e426                	sd	s1,8(sp)
    80003bcc:	e04a                	sd	s2,0(sp)
    80003bce:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003bd0:	c115                	beqz	a0,80003bf4 <ilock+0x30>
    80003bd2:	84aa                	mv	s1,a0
    80003bd4:	451c                	lw	a5,8(a0)
    80003bd6:	00f05f63          	blez	a5,80003bf4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003bda:	0541                	addi	a0,a0,16
    80003bdc:	00001097          	auipc	ra,0x1
    80003be0:	ca8080e7          	jalr	-856(ra) # 80004884 <acquiresleep>
  if(ip->valid == 0){
    80003be4:	40bc                	lw	a5,64(s1)
    80003be6:	cf99                	beqz	a5,80003c04 <ilock+0x40>
}
    80003be8:	60e2                	ld	ra,24(sp)
    80003bea:	6442                	ld	s0,16(sp)
    80003bec:	64a2                	ld	s1,8(sp)
    80003bee:	6902                	ld	s2,0(sp)
    80003bf0:	6105                	addi	sp,sp,32
    80003bf2:	8082                	ret
    panic("ilock");
    80003bf4:	00005517          	auipc	a0,0x5
    80003bf8:	a9c50513          	addi	a0,a0,-1380 # 80008690 <syscalls+0x198>
    80003bfc:	ffffd097          	auipc	ra,0xffffd
    80003c00:	98a080e7          	jalr	-1654(ra) # 80000586 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c04:	40dc                	lw	a5,4(s1)
    80003c06:	0047d79b          	srliw	a5,a5,0x4
    80003c0a:	0001b597          	auipc	a1,0x1b
    80003c0e:	7765a583          	lw	a1,1910(a1) # 8001f380 <sb+0x18>
    80003c12:	9dbd                	addw	a1,a1,a5
    80003c14:	4088                	lw	a0,0(s1)
    80003c16:	fffff097          	auipc	ra,0xfffff
    80003c1a:	796080e7          	jalr	1942(ra) # 800033ac <bread>
    80003c1e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c20:	05850593          	addi	a1,a0,88
    80003c24:	40dc                	lw	a5,4(s1)
    80003c26:	8bbd                	andi	a5,a5,15
    80003c28:	079a                	slli	a5,a5,0x6
    80003c2a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c2c:	00059783          	lh	a5,0(a1)
    80003c30:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c34:	00259783          	lh	a5,2(a1)
    80003c38:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003c3c:	00459783          	lh	a5,4(a1)
    80003c40:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003c44:	00659783          	lh	a5,6(a1)
    80003c48:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003c4c:	459c                	lw	a5,8(a1)
    80003c4e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003c50:	03400613          	li	a2,52
    80003c54:	05b1                	addi	a1,a1,12
    80003c56:	05048513          	addi	a0,s1,80
    80003c5a:	ffffd097          	auipc	ra,0xffffd
    80003c5e:	11a080e7          	jalr	282(ra) # 80000d74 <memmove>
    brelse(bp);
    80003c62:	854a                	mv	a0,s2
    80003c64:	00000097          	auipc	ra,0x0
    80003c68:	878080e7          	jalr	-1928(ra) # 800034dc <brelse>
    ip->valid = 1;
    80003c6c:	4785                	li	a5,1
    80003c6e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003c70:	04449783          	lh	a5,68(s1)
    80003c74:	fbb5                	bnez	a5,80003be8 <ilock+0x24>
      panic("ilock: no type");
    80003c76:	00005517          	auipc	a0,0x5
    80003c7a:	a2250513          	addi	a0,a0,-1502 # 80008698 <syscalls+0x1a0>
    80003c7e:	ffffd097          	auipc	ra,0xffffd
    80003c82:	908080e7          	jalr	-1784(ra) # 80000586 <panic>

0000000080003c86 <iunlock>:
{
    80003c86:	1101                	addi	sp,sp,-32
    80003c88:	ec06                	sd	ra,24(sp)
    80003c8a:	e822                	sd	s0,16(sp)
    80003c8c:	e426                	sd	s1,8(sp)
    80003c8e:	e04a                	sd	s2,0(sp)
    80003c90:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c92:	c905                	beqz	a0,80003cc2 <iunlock+0x3c>
    80003c94:	84aa                	mv	s1,a0
    80003c96:	01050913          	addi	s2,a0,16
    80003c9a:	854a                	mv	a0,s2
    80003c9c:	00001097          	auipc	ra,0x1
    80003ca0:	c82080e7          	jalr	-894(ra) # 8000491e <holdingsleep>
    80003ca4:	cd19                	beqz	a0,80003cc2 <iunlock+0x3c>
    80003ca6:	449c                	lw	a5,8(s1)
    80003ca8:	00f05d63          	blez	a5,80003cc2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003cac:	854a                	mv	a0,s2
    80003cae:	00001097          	auipc	ra,0x1
    80003cb2:	c2c080e7          	jalr	-980(ra) # 800048da <releasesleep>
}
    80003cb6:	60e2                	ld	ra,24(sp)
    80003cb8:	6442                	ld	s0,16(sp)
    80003cba:	64a2                	ld	s1,8(sp)
    80003cbc:	6902                	ld	s2,0(sp)
    80003cbe:	6105                	addi	sp,sp,32
    80003cc0:	8082                	ret
    panic("iunlock");
    80003cc2:	00005517          	auipc	a0,0x5
    80003cc6:	9e650513          	addi	a0,a0,-1562 # 800086a8 <syscalls+0x1b0>
    80003cca:	ffffd097          	auipc	ra,0xffffd
    80003cce:	8bc080e7          	jalr	-1860(ra) # 80000586 <panic>

0000000080003cd2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003cd2:	7179                	addi	sp,sp,-48
    80003cd4:	f406                	sd	ra,40(sp)
    80003cd6:	f022                	sd	s0,32(sp)
    80003cd8:	ec26                	sd	s1,24(sp)
    80003cda:	e84a                	sd	s2,16(sp)
    80003cdc:	e44e                	sd	s3,8(sp)
    80003cde:	e052                	sd	s4,0(sp)
    80003ce0:	1800                	addi	s0,sp,48
    80003ce2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003ce4:	05050493          	addi	s1,a0,80
    80003ce8:	08050913          	addi	s2,a0,128
    80003cec:	a021                	j	80003cf4 <itrunc+0x22>
    80003cee:	0491                	addi	s1,s1,4
    80003cf0:	01248d63          	beq	s1,s2,80003d0a <itrunc+0x38>
    if(ip->addrs[i]){
    80003cf4:	408c                	lw	a1,0(s1)
    80003cf6:	dde5                	beqz	a1,80003cee <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003cf8:	0009a503          	lw	a0,0(s3)
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	8f6080e7          	jalr	-1802(ra) # 800035f2 <bfree>
      ip->addrs[i] = 0;
    80003d04:	0004a023          	sw	zero,0(s1)
    80003d08:	b7dd                	j	80003cee <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d0a:	0809a583          	lw	a1,128(s3)
    80003d0e:	e185                	bnez	a1,80003d2e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d10:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d14:	854e                	mv	a0,s3
    80003d16:	00000097          	auipc	ra,0x0
    80003d1a:	de2080e7          	jalr	-542(ra) # 80003af8 <iupdate>
}
    80003d1e:	70a2                	ld	ra,40(sp)
    80003d20:	7402                	ld	s0,32(sp)
    80003d22:	64e2                	ld	s1,24(sp)
    80003d24:	6942                	ld	s2,16(sp)
    80003d26:	69a2                	ld	s3,8(sp)
    80003d28:	6a02                	ld	s4,0(sp)
    80003d2a:	6145                	addi	sp,sp,48
    80003d2c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d2e:	0009a503          	lw	a0,0(s3)
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	67a080e7          	jalr	1658(ra) # 800033ac <bread>
    80003d3a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d3c:	05850493          	addi	s1,a0,88
    80003d40:	45850913          	addi	s2,a0,1112
    80003d44:	a021                	j	80003d4c <itrunc+0x7a>
    80003d46:	0491                	addi	s1,s1,4
    80003d48:	01248b63          	beq	s1,s2,80003d5e <itrunc+0x8c>
      if(a[j])
    80003d4c:	408c                	lw	a1,0(s1)
    80003d4e:	dde5                	beqz	a1,80003d46 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003d50:	0009a503          	lw	a0,0(s3)
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	89e080e7          	jalr	-1890(ra) # 800035f2 <bfree>
    80003d5c:	b7ed                	j	80003d46 <itrunc+0x74>
    brelse(bp);
    80003d5e:	8552                	mv	a0,s4
    80003d60:	fffff097          	auipc	ra,0xfffff
    80003d64:	77c080e7          	jalr	1916(ra) # 800034dc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003d68:	0809a583          	lw	a1,128(s3)
    80003d6c:	0009a503          	lw	a0,0(s3)
    80003d70:	00000097          	auipc	ra,0x0
    80003d74:	882080e7          	jalr	-1918(ra) # 800035f2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003d78:	0809a023          	sw	zero,128(s3)
    80003d7c:	bf51                	j	80003d10 <itrunc+0x3e>

0000000080003d7e <iput>:
{
    80003d7e:	1101                	addi	sp,sp,-32
    80003d80:	ec06                	sd	ra,24(sp)
    80003d82:	e822                	sd	s0,16(sp)
    80003d84:	e426                	sd	s1,8(sp)
    80003d86:	e04a                	sd	s2,0(sp)
    80003d88:	1000                	addi	s0,sp,32
    80003d8a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d8c:	0001b517          	auipc	a0,0x1b
    80003d90:	5fc50513          	addi	a0,a0,1532 # 8001f388 <itable>
    80003d94:	ffffd097          	auipc	ra,0xffffd
    80003d98:	e88080e7          	jalr	-376(ra) # 80000c1c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d9c:	4498                	lw	a4,8(s1)
    80003d9e:	4785                	li	a5,1
    80003da0:	02f70363          	beq	a4,a5,80003dc6 <iput+0x48>
  ip->ref--;
    80003da4:	449c                	lw	a5,8(s1)
    80003da6:	37fd                	addiw	a5,a5,-1
    80003da8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003daa:	0001b517          	auipc	a0,0x1b
    80003dae:	5de50513          	addi	a0,a0,1502 # 8001f388 <itable>
    80003db2:	ffffd097          	auipc	ra,0xffffd
    80003db6:	f1e080e7          	jalr	-226(ra) # 80000cd0 <release>
}
    80003dba:	60e2                	ld	ra,24(sp)
    80003dbc:	6442                	ld	s0,16(sp)
    80003dbe:	64a2                	ld	s1,8(sp)
    80003dc0:	6902                	ld	s2,0(sp)
    80003dc2:	6105                	addi	sp,sp,32
    80003dc4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003dc6:	40bc                	lw	a5,64(s1)
    80003dc8:	dff1                	beqz	a5,80003da4 <iput+0x26>
    80003dca:	04a49783          	lh	a5,74(s1)
    80003dce:	fbf9                	bnez	a5,80003da4 <iput+0x26>
    acquiresleep(&ip->lock);
    80003dd0:	01048913          	addi	s2,s1,16
    80003dd4:	854a                	mv	a0,s2
    80003dd6:	00001097          	auipc	ra,0x1
    80003dda:	aae080e7          	jalr	-1362(ra) # 80004884 <acquiresleep>
    release(&itable.lock);
    80003dde:	0001b517          	auipc	a0,0x1b
    80003de2:	5aa50513          	addi	a0,a0,1450 # 8001f388 <itable>
    80003de6:	ffffd097          	auipc	ra,0xffffd
    80003dea:	eea080e7          	jalr	-278(ra) # 80000cd0 <release>
    itrunc(ip);
    80003dee:	8526                	mv	a0,s1
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	ee2080e7          	jalr	-286(ra) # 80003cd2 <itrunc>
    ip->type = 0;
    80003df8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003dfc:	8526                	mv	a0,s1
    80003dfe:	00000097          	auipc	ra,0x0
    80003e02:	cfa080e7          	jalr	-774(ra) # 80003af8 <iupdate>
    ip->valid = 0;
    80003e06:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e0a:	854a                	mv	a0,s2
    80003e0c:	00001097          	auipc	ra,0x1
    80003e10:	ace080e7          	jalr	-1330(ra) # 800048da <releasesleep>
    acquire(&itable.lock);
    80003e14:	0001b517          	auipc	a0,0x1b
    80003e18:	57450513          	addi	a0,a0,1396 # 8001f388 <itable>
    80003e1c:	ffffd097          	auipc	ra,0xffffd
    80003e20:	e00080e7          	jalr	-512(ra) # 80000c1c <acquire>
    80003e24:	b741                	j	80003da4 <iput+0x26>

0000000080003e26 <iunlockput>:
{
    80003e26:	1101                	addi	sp,sp,-32
    80003e28:	ec06                	sd	ra,24(sp)
    80003e2a:	e822                	sd	s0,16(sp)
    80003e2c:	e426                	sd	s1,8(sp)
    80003e2e:	1000                	addi	s0,sp,32
    80003e30:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	e54080e7          	jalr	-428(ra) # 80003c86 <iunlock>
  iput(ip);
    80003e3a:	8526                	mv	a0,s1
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	f42080e7          	jalr	-190(ra) # 80003d7e <iput>
}
    80003e44:	60e2                	ld	ra,24(sp)
    80003e46:	6442                	ld	s0,16(sp)
    80003e48:	64a2                	ld	s1,8(sp)
    80003e4a:	6105                	addi	sp,sp,32
    80003e4c:	8082                	ret

0000000080003e4e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003e4e:	1141                	addi	sp,sp,-16
    80003e50:	e422                	sd	s0,8(sp)
    80003e52:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003e54:	411c                	lw	a5,0(a0)
    80003e56:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003e58:	415c                	lw	a5,4(a0)
    80003e5a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003e5c:	04451783          	lh	a5,68(a0)
    80003e60:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003e64:	04a51783          	lh	a5,74(a0)
    80003e68:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003e6c:	04c56783          	lwu	a5,76(a0)
    80003e70:	e99c                	sd	a5,16(a1)
}
    80003e72:	6422                	ld	s0,8(sp)
    80003e74:	0141                	addi	sp,sp,16
    80003e76:	8082                	ret

0000000080003e78 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e78:	457c                	lw	a5,76(a0)
    80003e7a:	0ed7e963          	bltu	a5,a3,80003f6c <readi+0xf4>
{
    80003e7e:	7159                	addi	sp,sp,-112
    80003e80:	f486                	sd	ra,104(sp)
    80003e82:	f0a2                	sd	s0,96(sp)
    80003e84:	eca6                	sd	s1,88(sp)
    80003e86:	e8ca                	sd	s2,80(sp)
    80003e88:	e4ce                	sd	s3,72(sp)
    80003e8a:	e0d2                	sd	s4,64(sp)
    80003e8c:	fc56                	sd	s5,56(sp)
    80003e8e:	f85a                	sd	s6,48(sp)
    80003e90:	f45e                	sd	s7,40(sp)
    80003e92:	f062                	sd	s8,32(sp)
    80003e94:	ec66                	sd	s9,24(sp)
    80003e96:	e86a                	sd	s10,16(sp)
    80003e98:	e46e                	sd	s11,8(sp)
    80003e9a:	1880                	addi	s0,sp,112
    80003e9c:	8b2a                	mv	s6,a0
    80003e9e:	8bae                	mv	s7,a1
    80003ea0:	8a32                	mv	s4,a2
    80003ea2:	84b6                	mv	s1,a3
    80003ea4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003ea6:	9f35                	addw	a4,a4,a3
    return 0;
    80003ea8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003eaa:	0ad76063          	bltu	a4,a3,80003f4a <readi+0xd2>
  if(off + n > ip->size)
    80003eae:	00e7f463          	bgeu	a5,a4,80003eb6 <readi+0x3e>
    n = ip->size - off;
    80003eb2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003eb6:	0a0a8963          	beqz	s5,80003f68 <readi+0xf0>
    80003eba:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ebc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ec0:	5c7d                	li	s8,-1
    80003ec2:	a82d                	j	80003efc <readi+0x84>
    80003ec4:	020d1d93          	slli	s11,s10,0x20
    80003ec8:	020ddd93          	srli	s11,s11,0x20
    80003ecc:	05890613          	addi	a2,s2,88
    80003ed0:	86ee                	mv	a3,s11
    80003ed2:	963a                	add	a2,a2,a4
    80003ed4:	85d2                	mv	a1,s4
    80003ed6:	855e                	mv	a0,s7
    80003ed8:	fffff097          	auipc	ra,0xfffff
    80003edc:	95c080e7          	jalr	-1700(ra) # 80002834 <either_copyout>
    80003ee0:	05850d63          	beq	a0,s8,80003f3a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ee4:	854a                	mv	a0,s2
    80003ee6:	fffff097          	auipc	ra,0xfffff
    80003eea:	5f6080e7          	jalr	1526(ra) # 800034dc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003eee:	013d09bb          	addw	s3,s10,s3
    80003ef2:	009d04bb          	addw	s1,s10,s1
    80003ef6:	9a6e                	add	s4,s4,s11
    80003ef8:	0559f763          	bgeu	s3,s5,80003f46 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003efc:	00a4d59b          	srliw	a1,s1,0xa
    80003f00:	855a                	mv	a0,s6
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	89e080e7          	jalr	-1890(ra) # 800037a0 <bmap>
    80003f0a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003f0e:	cd85                	beqz	a1,80003f46 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003f10:	000b2503          	lw	a0,0(s6)
    80003f14:	fffff097          	auipc	ra,0xfffff
    80003f18:	498080e7          	jalr	1176(ra) # 800033ac <bread>
    80003f1c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f1e:	3ff4f713          	andi	a4,s1,1023
    80003f22:	40ec87bb          	subw	a5,s9,a4
    80003f26:	413a86bb          	subw	a3,s5,s3
    80003f2a:	8d3e                	mv	s10,a5
    80003f2c:	2781                	sext.w	a5,a5
    80003f2e:	0006861b          	sext.w	a2,a3
    80003f32:	f8f679e3          	bgeu	a2,a5,80003ec4 <readi+0x4c>
    80003f36:	8d36                	mv	s10,a3
    80003f38:	b771                	j	80003ec4 <readi+0x4c>
      brelse(bp);
    80003f3a:	854a                	mv	a0,s2
    80003f3c:	fffff097          	auipc	ra,0xfffff
    80003f40:	5a0080e7          	jalr	1440(ra) # 800034dc <brelse>
      tot = -1;
    80003f44:	59fd                	li	s3,-1
  }
  return tot;
    80003f46:	0009851b          	sext.w	a0,s3
}
    80003f4a:	70a6                	ld	ra,104(sp)
    80003f4c:	7406                	ld	s0,96(sp)
    80003f4e:	64e6                	ld	s1,88(sp)
    80003f50:	6946                	ld	s2,80(sp)
    80003f52:	69a6                	ld	s3,72(sp)
    80003f54:	6a06                	ld	s4,64(sp)
    80003f56:	7ae2                	ld	s5,56(sp)
    80003f58:	7b42                	ld	s6,48(sp)
    80003f5a:	7ba2                	ld	s7,40(sp)
    80003f5c:	7c02                	ld	s8,32(sp)
    80003f5e:	6ce2                	ld	s9,24(sp)
    80003f60:	6d42                	ld	s10,16(sp)
    80003f62:	6da2                	ld	s11,8(sp)
    80003f64:	6165                	addi	sp,sp,112
    80003f66:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f68:	89d6                	mv	s3,s5
    80003f6a:	bff1                	j	80003f46 <readi+0xce>
    return 0;
    80003f6c:	4501                	li	a0,0
}
    80003f6e:	8082                	ret

0000000080003f70 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f70:	457c                	lw	a5,76(a0)
    80003f72:	10d7e863          	bltu	a5,a3,80004082 <writei+0x112>
{
    80003f76:	7159                	addi	sp,sp,-112
    80003f78:	f486                	sd	ra,104(sp)
    80003f7a:	f0a2                	sd	s0,96(sp)
    80003f7c:	eca6                	sd	s1,88(sp)
    80003f7e:	e8ca                	sd	s2,80(sp)
    80003f80:	e4ce                	sd	s3,72(sp)
    80003f82:	e0d2                	sd	s4,64(sp)
    80003f84:	fc56                	sd	s5,56(sp)
    80003f86:	f85a                	sd	s6,48(sp)
    80003f88:	f45e                	sd	s7,40(sp)
    80003f8a:	f062                	sd	s8,32(sp)
    80003f8c:	ec66                	sd	s9,24(sp)
    80003f8e:	e86a                	sd	s10,16(sp)
    80003f90:	e46e                	sd	s11,8(sp)
    80003f92:	1880                	addi	s0,sp,112
    80003f94:	8aaa                	mv	s5,a0
    80003f96:	8bae                	mv	s7,a1
    80003f98:	8a32                	mv	s4,a2
    80003f9a:	8936                	mv	s2,a3
    80003f9c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f9e:	00e687bb          	addw	a5,a3,a4
    80003fa2:	0ed7e263          	bltu	a5,a3,80004086 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003fa6:	00043737          	lui	a4,0x43
    80003faa:	0ef76063          	bltu	a4,a5,8000408a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fae:	0c0b0863          	beqz	s6,8000407e <writei+0x10e>
    80003fb2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fb4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003fb8:	5c7d                	li	s8,-1
    80003fba:	a091                	j	80003ffe <writei+0x8e>
    80003fbc:	020d1d93          	slli	s11,s10,0x20
    80003fc0:	020ddd93          	srli	s11,s11,0x20
    80003fc4:	05848513          	addi	a0,s1,88
    80003fc8:	86ee                	mv	a3,s11
    80003fca:	8652                	mv	a2,s4
    80003fcc:	85de                	mv	a1,s7
    80003fce:	953a                	add	a0,a0,a4
    80003fd0:	fffff097          	auipc	ra,0xfffff
    80003fd4:	8ba080e7          	jalr	-1862(ra) # 8000288a <either_copyin>
    80003fd8:	07850263          	beq	a0,s8,8000403c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003fdc:	8526                	mv	a0,s1
    80003fde:	00000097          	auipc	ra,0x0
    80003fe2:	788080e7          	jalr	1928(ra) # 80004766 <log_write>
    brelse(bp);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	fffff097          	auipc	ra,0xfffff
    80003fec:	4f4080e7          	jalr	1268(ra) # 800034dc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ff0:	013d09bb          	addw	s3,s10,s3
    80003ff4:	012d093b          	addw	s2,s10,s2
    80003ff8:	9a6e                	add	s4,s4,s11
    80003ffa:	0569f663          	bgeu	s3,s6,80004046 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003ffe:	00a9559b          	srliw	a1,s2,0xa
    80004002:	8556                	mv	a0,s5
    80004004:	fffff097          	auipc	ra,0xfffff
    80004008:	79c080e7          	jalr	1948(ra) # 800037a0 <bmap>
    8000400c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004010:	c99d                	beqz	a1,80004046 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004012:	000aa503          	lw	a0,0(s5)
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	396080e7          	jalr	918(ra) # 800033ac <bread>
    8000401e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004020:	3ff97713          	andi	a4,s2,1023
    80004024:	40ec87bb          	subw	a5,s9,a4
    80004028:	413b06bb          	subw	a3,s6,s3
    8000402c:	8d3e                	mv	s10,a5
    8000402e:	2781                	sext.w	a5,a5
    80004030:	0006861b          	sext.w	a2,a3
    80004034:	f8f674e3          	bgeu	a2,a5,80003fbc <writei+0x4c>
    80004038:	8d36                	mv	s10,a3
    8000403a:	b749                	j	80003fbc <writei+0x4c>
      brelse(bp);
    8000403c:	8526                	mv	a0,s1
    8000403e:	fffff097          	auipc	ra,0xfffff
    80004042:	49e080e7          	jalr	1182(ra) # 800034dc <brelse>
  }

  if(off > ip->size)
    80004046:	04caa783          	lw	a5,76(s5)
    8000404a:	0127f463          	bgeu	a5,s2,80004052 <writei+0xe2>
    ip->size = off;
    8000404e:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004052:	8556                	mv	a0,s5
    80004054:	00000097          	auipc	ra,0x0
    80004058:	aa4080e7          	jalr	-1372(ra) # 80003af8 <iupdate>

  return tot;
    8000405c:	0009851b          	sext.w	a0,s3
}
    80004060:	70a6                	ld	ra,104(sp)
    80004062:	7406                	ld	s0,96(sp)
    80004064:	64e6                	ld	s1,88(sp)
    80004066:	6946                	ld	s2,80(sp)
    80004068:	69a6                	ld	s3,72(sp)
    8000406a:	6a06                	ld	s4,64(sp)
    8000406c:	7ae2                	ld	s5,56(sp)
    8000406e:	7b42                	ld	s6,48(sp)
    80004070:	7ba2                	ld	s7,40(sp)
    80004072:	7c02                	ld	s8,32(sp)
    80004074:	6ce2                	ld	s9,24(sp)
    80004076:	6d42                	ld	s10,16(sp)
    80004078:	6da2                	ld	s11,8(sp)
    8000407a:	6165                	addi	sp,sp,112
    8000407c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000407e:	89da                	mv	s3,s6
    80004080:	bfc9                	j	80004052 <writei+0xe2>
    return -1;
    80004082:	557d                	li	a0,-1
}
    80004084:	8082                	ret
    return -1;
    80004086:	557d                	li	a0,-1
    80004088:	bfe1                	j	80004060 <writei+0xf0>
    return -1;
    8000408a:	557d                	li	a0,-1
    8000408c:	bfd1                	j	80004060 <writei+0xf0>

000000008000408e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000408e:	1141                	addi	sp,sp,-16
    80004090:	e406                	sd	ra,8(sp)
    80004092:	e022                	sd	s0,0(sp)
    80004094:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004096:	4639                	li	a2,14
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	d50080e7          	jalr	-688(ra) # 80000de8 <strncmp>
}
    800040a0:	60a2                	ld	ra,8(sp)
    800040a2:	6402                	ld	s0,0(sp)
    800040a4:	0141                	addi	sp,sp,16
    800040a6:	8082                	ret

00000000800040a8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800040a8:	7139                	addi	sp,sp,-64
    800040aa:	fc06                	sd	ra,56(sp)
    800040ac:	f822                	sd	s0,48(sp)
    800040ae:	f426                	sd	s1,40(sp)
    800040b0:	f04a                	sd	s2,32(sp)
    800040b2:	ec4e                	sd	s3,24(sp)
    800040b4:	e852                	sd	s4,16(sp)
    800040b6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800040b8:	04451703          	lh	a4,68(a0)
    800040bc:	4785                	li	a5,1
    800040be:	00f71a63          	bne	a4,a5,800040d2 <dirlookup+0x2a>
    800040c2:	892a                	mv	s2,a0
    800040c4:	89ae                	mv	s3,a1
    800040c6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800040c8:	457c                	lw	a5,76(a0)
    800040ca:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800040cc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040ce:	e79d                	bnez	a5,800040fc <dirlookup+0x54>
    800040d0:	a8a5                	j	80004148 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800040d2:	00004517          	auipc	a0,0x4
    800040d6:	5de50513          	addi	a0,a0,1502 # 800086b0 <syscalls+0x1b8>
    800040da:	ffffc097          	auipc	ra,0xffffc
    800040de:	4ac080e7          	jalr	1196(ra) # 80000586 <panic>
      panic("dirlookup read");
    800040e2:	00004517          	auipc	a0,0x4
    800040e6:	5e650513          	addi	a0,a0,1510 # 800086c8 <syscalls+0x1d0>
    800040ea:	ffffc097          	auipc	ra,0xffffc
    800040ee:	49c080e7          	jalr	1180(ra) # 80000586 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040f2:	24c1                	addiw	s1,s1,16
    800040f4:	04c92783          	lw	a5,76(s2)
    800040f8:	04f4f763          	bgeu	s1,a5,80004146 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040fc:	4741                	li	a4,16
    800040fe:	86a6                	mv	a3,s1
    80004100:	fc040613          	addi	a2,s0,-64
    80004104:	4581                	li	a1,0
    80004106:	854a                	mv	a0,s2
    80004108:	00000097          	auipc	ra,0x0
    8000410c:	d70080e7          	jalr	-656(ra) # 80003e78 <readi>
    80004110:	47c1                	li	a5,16
    80004112:	fcf518e3          	bne	a0,a5,800040e2 <dirlookup+0x3a>
    if(de.inum == 0)
    80004116:	fc045783          	lhu	a5,-64(s0)
    8000411a:	dfe1                	beqz	a5,800040f2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000411c:	fc240593          	addi	a1,s0,-62
    80004120:	854e                	mv	a0,s3
    80004122:	00000097          	auipc	ra,0x0
    80004126:	f6c080e7          	jalr	-148(ra) # 8000408e <namecmp>
    8000412a:	f561                	bnez	a0,800040f2 <dirlookup+0x4a>
      if(poff)
    8000412c:	000a0463          	beqz	s4,80004134 <dirlookup+0x8c>
        *poff = off;
    80004130:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004134:	fc045583          	lhu	a1,-64(s0)
    80004138:	00092503          	lw	a0,0(s2)
    8000413c:	fffff097          	auipc	ra,0xfffff
    80004140:	74e080e7          	jalr	1870(ra) # 8000388a <iget>
    80004144:	a011                	j	80004148 <dirlookup+0xa0>
  return 0;
    80004146:	4501                	li	a0,0
}
    80004148:	70e2                	ld	ra,56(sp)
    8000414a:	7442                	ld	s0,48(sp)
    8000414c:	74a2                	ld	s1,40(sp)
    8000414e:	7902                	ld	s2,32(sp)
    80004150:	69e2                	ld	s3,24(sp)
    80004152:	6a42                	ld	s4,16(sp)
    80004154:	6121                	addi	sp,sp,64
    80004156:	8082                	ret

0000000080004158 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004158:	711d                	addi	sp,sp,-96
    8000415a:	ec86                	sd	ra,88(sp)
    8000415c:	e8a2                	sd	s0,80(sp)
    8000415e:	e4a6                	sd	s1,72(sp)
    80004160:	e0ca                	sd	s2,64(sp)
    80004162:	fc4e                	sd	s3,56(sp)
    80004164:	f852                	sd	s4,48(sp)
    80004166:	f456                	sd	s5,40(sp)
    80004168:	f05a                	sd	s6,32(sp)
    8000416a:	ec5e                	sd	s7,24(sp)
    8000416c:	e862                	sd	s8,16(sp)
    8000416e:	e466                	sd	s9,8(sp)
    80004170:	e06a                	sd	s10,0(sp)
    80004172:	1080                	addi	s0,sp,96
    80004174:	84aa                	mv	s1,a0
    80004176:	8b2e                	mv	s6,a1
    80004178:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000417a:	00054703          	lbu	a4,0(a0)
    8000417e:	02f00793          	li	a5,47
    80004182:	02f70363          	beq	a4,a5,800041a8 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004186:	ffffe097          	auipc	ra,0xffffe
    8000418a:	ae0080e7          	jalr	-1312(ra) # 80001c66 <myproc>
    8000418e:	15853503          	ld	a0,344(a0)
    80004192:	00000097          	auipc	ra,0x0
    80004196:	9f4080e7          	jalr	-1548(ra) # 80003b86 <idup>
    8000419a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000419c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800041a0:	4cb5                	li	s9,13
  len = path - s;
    800041a2:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800041a4:	4c05                	li	s8,1
    800041a6:	a87d                	j	80004264 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800041a8:	4585                	li	a1,1
    800041aa:	4505                	li	a0,1
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	6de080e7          	jalr	1758(ra) # 8000388a <iget>
    800041b4:	8a2a                	mv	s4,a0
    800041b6:	b7dd                	j	8000419c <namex+0x44>
      iunlockput(ip);
    800041b8:	8552                	mv	a0,s4
    800041ba:	00000097          	auipc	ra,0x0
    800041be:	c6c080e7          	jalr	-916(ra) # 80003e26 <iunlockput>
      return 0;
    800041c2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800041c4:	8552                	mv	a0,s4
    800041c6:	60e6                	ld	ra,88(sp)
    800041c8:	6446                	ld	s0,80(sp)
    800041ca:	64a6                	ld	s1,72(sp)
    800041cc:	6906                	ld	s2,64(sp)
    800041ce:	79e2                	ld	s3,56(sp)
    800041d0:	7a42                	ld	s4,48(sp)
    800041d2:	7aa2                	ld	s5,40(sp)
    800041d4:	7b02                	ld	s6,32(sp)
    800041d6:	6be2                	ld	s7,24(sp)
    800041d8:	6c42                	ld	s8,16(sp)
    800041da:	6ca2                	ld	s9,8(sp)
    800041dc:	6d02                	ld	s10,0(sp)
    800041de:	6125                	addi	sp,sp,96
    800041e0:	8082                	ret
      iunlock(ip);
    800041e2:	8552                	mv	a0,s4
    800041e4:	00000097          	auipc	ra,0x0
    800041e8:	aa2080e7          	jalr	-1374(ra) # 80003c86 <iunlock>
      return ip;
    800041ec:	bfe1                	j	800041c4 <namex+0x6c>
      iunlockput(ip);
    800041ee:	8552                	mv	a0,s4
    800041f0:	00000097          	auipc	ra,0x0
    800041f4:	c36080e7          	jalr	-970(ra) # 80003e26 <iunlockput>
      return 0;
    800041f8:	8a4e                	mv	s4,s3
    800041fa:	b7e9                	j	800041c4 <namex+0x6c>
  len = path - s;
    800041fc:	40998633          	sub	a2,s3,s1
    80004200:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004204:	09acd863          	bge	s9,s10,80004294 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80004208:	4639                	li	a2,14
    8000420a:	85a6                	mv	a1,s1
    8000420c:	8556                	mv	a0,s5
    8000420e:	ffffd097          	auipc	ra,0xffffd
    80004212:	b66080e7          	jalr	-1178(ra) # 80000d74 <memmove>
    80004216:	84ce                	mv	s1,s3
  while(*path == '/')
    80004218:	0004c783          	lbu	a5,0(s1)
    8000421c:	01279763          	bne	a5,s2,8000422a <namex+0xd2>
    path++;
    80004220:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004222:	0004c783          	lbu	a5,0(s1)
    80004226:	ff278de3          	beq	a5,s2,80004220 <namex+0xc8>
    ilock(ip);
    8000422a:	8552                	mv	a0,s4
    8000422c:	00000097          	auipc	ra,0x0
    80004230:	998080e7          	jalr	-1640(ra) # 80003bc4 <ilock>
    if(ip->type != T_DIR){
    80004234:	044a1783          	lh	a5,68(s4)
    80004238:	f98790e3          	bne	a5,s8,800041b8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000423c:	000b0563          	beqz	s6,80004246 <namex+0xee>
    80004240:	0004c783          	lbu	a5,0(s1)
    80004244:	dfd9                	beqz	a5,800041e2 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004246:	865e                	mv	a2,s7
    80004248:	85d6                	mv	a1,s5
    8000424a:	8552                	mv	a0,s4
    8000424c:	00000097          	auipc	ra,0x0
    80004250:	e5c080e7          	jalr	-420(ra) # 800040a8 <dirlookup>
    80004254:	89aa                	mv	s3,a0
    80004256:	dd41                	beqz	a0,800041ee <namex+0x96>
    iunlockput(ip);
    80004258:	8552                	mv	a0,s4
    8000425a:	00000097          	auipc	ra,0x0
    8000425e:	bcc080e7          	jalr	-1076(ra) # 80003e26 <iunlockput>
    ip = next;
    80004262:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004264:	0004c783          	lbu	a5,0(s1)
    80004268:	01279763          	bne	a5,s2,80004276 <namex+0x11e>
    path++;
    8000426c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000426e:	0004c783          	lbu	a5,0(s1)
    80004272:	ff278de3          	beq	a5,s2,8000426c <namex+0x114>
  if(*path == 0)
    80004276:	cb9d                	beqz	a5,800042ac <namex+0x154>
  while(*path != '/' && *path != 0)
    80004278:	0004c783          	lbu	a5,0(s1)
    8000427c:	89a6                	mv	s3,s1
  len = path - s;
    8000427e:	8d5e                	mv	s10,s7
    80004280:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80004282:	01278963          	beq	a5,s2,80004294 <namex+0x13c>
    80004286:	dbbd                	beqz	a5,800041fc <namex+0xa4>
    path++;
    80004288:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000428a:	0009c783          	lbu	a5,0(s3)
    8000428e:	ff279ce3          	bne	a5,s2,80004286 <namex+0x12e>
    80004292:	b7ad                	j	800041fc <namex+0xa4>
    memmove(name, s, len);
    80004294:	2601                	sext.w	a2,a2
    80004296:	85a6                	mv	a1,s1
    80004298:	8556                	mv	a0,s5
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	ada080e7          	jalr	-1318(ra) # 80000d74 <memmove>
    name[len] = 0;
    800042a2:	9d56                	add	s10,s10,s5
    800042a4:	000d0023          	sb	zero,0(s10)
    800042a8:	84ce                	mv	s1,s3
    800042aa:	b7bd                	j	80004218 <namex+0xc0>
  if(nameiparent){
    800042ac:	f00b0ce3          	beqz	s6,800041c4 <namex+0x6c>
    iput(ip);
    800042b0:	8552                	mv	a0,s4
    800042b2:	00000097          	auipc	ra,0x0
    800042b6:	acc080e7          	jalr	-1332(ra) # 80003d7e <iput>
    return 0;
    800042ba:	4a01                	li	s4,0
    800042bc:	b721                	j	800041c4 <namex+0x6c>

00000000800042be <dirlink>:
{
    800042be:	7139                	addi	sp,sp,-64
    800042c0:	fc06                	sd	ra,56(sp)
    800042c2:	f822                	sd	s0,48(sp)
    800042c4:	f426                	sd	s1,40(sp)
    800042c6:	f04a                	sd	s2,32(sp)
    800042c8:	ec4e                	sd	s3,24(sp)
    800042ca:	e852                	sd	s4,16(sp)
    800042cc:	0080                	addi	s0,sp,64
    800042ce:	892a                	mv	s2,a0
    800042d0:	8a2e                	mv	s4,a1
    800042d2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800042d4:	4601                	li	a2,0
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	dd2080e7          	jalr	-558(ra) # 800040a8 <dirlookup>
    800042de:	e93d                	bnez	a0,80004354 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042e0:	04c92483          	lw	s1,76(s2)
    800042e4:	c49d                	beqz	s1,80004312 <dirlink+0x54>
    800042e6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042e8:	4741                	li	a4,16
    800042ea:	86a6                	mv	a3,s1
    800042ec:	fc040613          	addi	a2,s0,-64
    800042f0:	4581                	li	a1,0
    800042f2:	854a                	mv	a0,s2
    800042f4:	00000097          	auipc	ra,0x0
    800042f8:	b84080e7          	jalr	-1148(ra) # 80003e78 <readi>
    800042fc:	47c1                	li	a5,16
    800042fe:	06f51163          	bne	a0,a5,80004360 <dirlink+0xa2>
    if(de.inum == 0)
    80004302:	fc045783          	lhu	a5,-64(s0)
    80004306:	c791                	beqz	a5,80004312 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004308:	24c1                	addiw	s1,s1,16
    8000430a:	04c92783          	lw	a5,76(s2)
    8000430e:	fcf4ede3          	bltu	s1,a5,800042e8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004312:	4639                	li	a2,14
    80004314:	85d2                	mv	a1,s4
    80004316:	fc240513          	addi	a0,s0,-62
    8000431a:	ffffd097          	auipc	ra,0xffffd
    8000431e:	b0a080e7          	jalr	-1270(ra) # 80000e24 <strncpy>
  de.inum = inum;
    80004322:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004326:	4741                	li	a4,16
    80004328:	86a6                	mv	a3,s1
    8000432a:	fc040613          	addi	a2,s0,-64
    8000432e:	4581                	li	a1,0
    80004330:	854a                	mv	a0,s2
    80004332:	00000097          	auipc	ra,0x0
    80004336:	c3e080e7          	jalr	-962(ra) # 80003f70 <writei>
    8000433a:	1541                	addi	a0,a0,-16
    8000433c:	00a03533          	snez	a0,a0
    80004340:	40a00533          	neg	a0,a0
}
    80004344:	70e2                	ld	ra,56(sp)
    80004346:	7442                	ld	s0,48(sp)
    80004348:	74a2                	ld	s1,40(sp)
    8000434a:	7902                	ld	s2,32(sp)
    8000434c:	69e2                	ld	s3,24(sp)
    8000434e:	6a42                	ld	s4,16(sp)
    80004350:	6121                	addi	sp,sp,64
    80004352:	8082                	ret
    iput(ip);
    80004354:	00000097          	auipc	ra,0x0
    80004358:	a2a080e7          	jalr	-1494(ra) # 80003d7e <iput>
    return -1;
    8000435c:	557d                	li	a0,-1
    8000435e:	b7dd                	j	80004344 <dirlink+0x86>
      panic("dirlink read");
    80004360:	00004517          	auipc	a0,0x4
    80004364:	37850513          	addi	a0,a0,888 # 800086d8 <syscalls+0x1e0>
    80004368:	ffffc097          	auipc	ra,0xffffc
    8000436c:	21e080e7          	jalr	542(ra) # 80000586 <panic>

0000000080004370 <namei>:

struct inode*
namei(char *path)
{
    80004370:	1101                	addi	sp,sp,-32
    80004372:	ec06                	sd	ra,24(sp)
    80004374:	e822                	sd	s0,16(sp)
    80004376:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004378:	fe040613          	addi	a2,s0,-32
    8000437c:	4581                	li	a1,0
    8000437e:	00000097          	auipc	ra,0x0
    80004382:	dda080e7          	jalr	-550(ra) # 80004158 <namex>
}
    80004386:	60e2                	ld	ra,24(sp)
    80004388:	6442                	ld	s0,16(sp)
    8000438a:	6105                	addi	sp,sp,32
    8000438c:	8082                	ret

000000008000438e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000438e:	1141                	addi	sp,sp,-16
    80004390:	e406                	sd	ra,8(sp)
    80004392:	e022                	sd	s0,0(sp)
    80004394:	0800                	addi	s0,sp,16
    80004396:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004398:	4585                	li	a1,1
    8000439a:	00000097          	auipc	ra,0x0
    8000439e:	dbe080e7          	jalr	-578(ra) # 80004158 <namex>
}
    800043a2:	60a2                	ld	ra,8(sp)
    800043a4:	6402                	ld	s0,0(sp)
    800043a6:	0141                	addi	sp,sp,16
    800043a8:	8082                	ret

00000000800043aa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800043aa:	1101                	addi	sp,sp,-32
    800043ac:	ec06                	sd	ra,24(sp)
    800043ae:	e822                	sd	s0,16(sp)
    800043b0:	e426                	sd	s1,8(sp)
    800043b2:	e04a                	sd	s2,0(sp)
    800043b4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800043b6:	0001d917          	auipc	s2,0x1d
    800043ba:	a7a90913          	addi	s2,s2,-1414 # 80020e30 <log>
    800043be:	01892583          	lw	a1,24(s2)
    800043c2:	02892503          	lw	a0,40(s2)
    800043c6:	fffff097          	auipc	ra,0xfffff
    800043ca:	fe6080e7          	jalr	-26(ra) # 800033ac <bread>
    800043ce:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800043d0:	02c92683          	lw	a3,44(s2)
    800043d4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800043d6:	02d05863          	blez	a3,80004406 <write_head+0x5c>
    800043da:	0001d797          	auipc	a5,0x1d
    800043de:	a8678793          	addi	a5,a5,-1402 # 80020e60 <log+0x30>
    800043e2:	05c50713          	addi	a4,a0,92
    800043e6:	36fd                	addiw	a3,a3,-1
    800043e8:	02069613          	slli	a2,a3,0x20
    800043ec:	01e65693          	srli	a3,a2,0x1e
    800043f0:	0001d617          	auipc	a2,0x1d
    800043f4:	a7460613          	addi	a2,a2,-1420 # 80020e64 <log+0x34>
    800043f8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800043fa:	4390                	lw	a2,0(a5)
    800043fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800043fe:	0791                	addi	a5,a5,4
    80004400:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80004402:	fed79ce3          	bne	a5,a3,800043fa <write_head+0x50>
  }
  bwrite(buf);
    80004406:	8526                	mv	a0,s1
    80004408:	fffff097          	auipc	ra,0xfffff
    8000440c:	096080e7          	jalr	150(ra) # 8000349e <bwrite>
  brelse(buf);
    80004410:	8526                	mv	a0,s1
    80004412:	fffff097          	auipc	ra,0xfffff
    80004416:	0ca080e7          	jalr	202(ra) # 800034dc <brelse>
}
    8000441a:	60e2                	ld	ra,24(sp)
    8000441c:	6442                	ld	s0,16(sp)
    8000441e:	64a2                	ld	s1,8(sp)
    80004420:	6902                	ld	s2,0(sp)
    80004422:	6105                	addi	sp,sp,32
    80004424:	8082                	ret

0000000080004426 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004426:	0001d797          	auipc	a5,0x1d
    8000442a:	a367a783          	lw	a5,-1482(a5) # 80020e5c <log+0x2c>
    8000442e:	0af05d63          	blez	a5,800044e8 <install_trans+0xc2>
{
    80004432:	7139                	addi	sp,sp,-64
    80004434:	fc06                	sd	ra,56(sp)
    80004436:	f822                	sd	s0,48(sp)
    80004438:	f426                	sd	s1,40(sp)
    8000443a:	f04a                	sd	s2,32(sp)
    8000443c:	ec4e                	sd	s3,24(sp)
    8000443e:	e852                	sd	s4,16(sp)
    80004440:	e456                	sd	s5,8(sp)
    80004442:	e05a                	sd	s6,0(sp)
    80004444:	0080                	addi	s0,sp,64
    80004446:	8b2a                	mv	s6,a0
    80004448:	0001da97          	auipc	s5,0x1d
    8000444c:	a18a8a93          	addi	s5,s5,-1512 # 80020e60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004450:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004452:	0001d997          	auipc	s3,0x1d
    80004456:	9de98993          	addi	s3,s3,-1570 # 80020e30 <log>
    8000445a:	a00d                	j	8000447c <install_trans+0x56>
    brelse(lbuf);
    8000445c:	854a                	mv	a0,s2
    8000445e:	fffff097          	auipc	ra,0xfffff
    80004462:	07e080e7          	jalr	126(ra) # 800034dc <brelse>
    brelse(dbuf);
    80004466:	8526                	mv	a0,s1
    80004468:	fffff097          	auipc	ra,0xfffff
    8000446c:	074080e7          	jalr	116(ra) # 800034dc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004470:	2a05                	addiw	s4,s4,1
    80004472:	0a91                	addi	s5,s5,4
    80004474:	02c9a783          	lw	a5,44(s3)
    80004478:	04fa5e63          	bge	s4,a5,800044d4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000447c:	0189a583          	lw	a1,24(s3)
    80004480:	014585bb          	addw	a1,a1,s4
    80004484:	2585                	addiw	a1,a1,1
    80004486:	0289a503          	lw	a0,40(s3)
    8000448a:	fffff097          	auipc	ra,0xfffff
    8000448e:	f22080e7          	jalr	-222(ra) # 800033ac <bread>
    80004492:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004494:	000aa583          	lw	a1,0(s5)
    80004498:	0289a503          	lw	a0,40(s3)
    8000449c:	fffff097          	auipc	ra,0xfffff
    800044a0:	f10080e7          	jalr	-240(ra) # 800033ac <bread>
    800044a4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800044a6:	40000613          	li	a2,1024
    800044aa:	05890593          	addi	a1,s2,88
    800044ae:	05850513          	addi	a0,a0,88
    800044b2:	ffffd097          	auipc	ra,0xffffd
    800044b6:	8c2080e7          	jalr	-1854(ra) # 80000d74 <memmove>
    bwrite(dbuf);  // write dst to disk
    800044ba:	8526                	mv	a0,s1
    800044bc:	fffff097          	auipc	ra,0xfffff
    800044c0:	fe2080e7          	jalr	-30(ra) # 8000349e <bwrite>
    if(recovering == 0)
    800044c4:	f80b1ce3          	bnez	s6,8000445c <install_trans+0x36>
      bunpin(dbuf);
    800044c8:	8526                	mv	a0,s1
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	0ec080e7          	jalr	236(ra) # 800035b6 <bunpin>
    800044d2:	b769                	j	8000445c <install_trans+0x36>
}
    800044d4:	70e2                	ld	ra,56(sp)
    800044d6:	7442                	ld	s0,48(sp)
    800044d8:	74a2                	ld	s1,40(sp)
    800044da:	7902                	ld	s2,32(sp)
    800044dc:	69e2                	ld	s3,24(sp)
    800044de:	6a42                	ld	s4,16(sp)
    800044e0:	6aa2                	ld	s5,8(sp)
    800044e2:	6b02                	ld	s6,0(sp)
    800044e4:	6121                	addi	sp,sp,64
    800044e6:	8082                	ret
    800044e8:	8082                	ret

00000000800044ea <initlog>:
{
    800044ea:	7179                	addi	sp,sp,-48
    800044ec:	f406                	sd	ra,40(sp)
    800044ee:	f022                	sd	s0,32(sp)
    800044f0:	ec26                	sd	s1,24(sp)
    800044f2:	e84a                	sd	s2,16(sp)
    800044f4:	e44e                	sd	s3,8(sp)
    800044f6:	1800                	addi	s0,sp,48
    800044f8:	892a                	mv	s2,a0
    800044fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800044fc:	0001d497          	auipc	s1,0x1d
    80004500:	93448493          	addi	s1,s1,-1740 # 80020e30 <log>
    80004504:	00004597          	auipc	a1,0x4
    80004508:	1e458593          	addi	a1,a1,484 # 800086e8 <syscalls+0x1f0>
    8000450c:	8526                	mv	a0,s1
    8000450e:	ffffc097          	auipc	ra,0xffffc
    80004512:	67e080e7          	jalr	1662(ra) # 80000b8c <initlock>
  log.start = sb->logstart;
    80004516:	0149a583          	lw	a1,20(s3)
    8000451a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000451c:	0109a783          	lw	a5,16(s3)
    80004520:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004522:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004526:	854a                	mv	a0,s2
    80004528:	fffff097          	auipc	ra,0xfffff
    8000452c:	e84080e7          	jalr	-380(ra) # 800033ac <bread>
  log.lh.n = lh->n;
    80004530:	4d34                	lw	a3,88(a0)
    80004532:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004534:	02d05663          	blez	a3,80004560 <initlog+0x76>
    80004538:	05c50793          	addi	a5,a0,92
    8000453c:	0001d717          	auipc	a4,0x1d
    80004540:	92470713          	addi	a4,a4,-1756 # 80020e60 <log+0x30>
    80004544:	36fd                	addiw	a3,a3,-1
    80004546:	02069613          	slli	a2,a3,0x20
    8000454a:	01e65693          	srli	a3,a2,0x1e
    8000454e:	06050613          	addi	a2,a0,96
    80004552:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004554:	4390                	lw	a2,0(a5)
    80004556:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004558:	0791                	addi	a5,a5,4
    8000455a:	0711                	addi	a4,a4,4
    8000455c:	fed79ce3          	bne	a5,a3,80004554 <initlog+0x6a>
  brelse(buf);
    80004560:	fffff097          	auipc	ra,0xfffff
    80004564:	f7c080e7          	jalr	-132(ra) # 800034dc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004568:	4505                	li	a0,1
    8000456a:	00000097          	auipc	ra,0x0
    8000456e:	ebc080e7          	jalr	-324(ra) # 80004426 <install_trans>
  log.lh.n = 0;
    80004572:	0001d797          	auipc	a5,0x1d
    80004576:	8e07a523          	sw	zero,-1814(a5) # 80020e5c <log+0x2c>
  write_head(); // clear the log
    8000457a:	00000097          	auipc	ra,0x0
    8000457e:	e30080e7          	jalr	-464(ra) # 800043aa <write_head>
}
    80004582:	70a2                	ld	ra,40(sp)
    80004584:	7402                	ld	s0,32(sp)
    80004586:	64e2                	ld	s1,24(sp)
    80004588:	6942                	ld	s2,16(sp)
    8000458a:	69a2                	ld	s3,8(sp)
    8000458c:	6145                	addi	sp,sp,48
    8000458e:	8082                	ret

0000000080004590 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004590:	1101                	addi	sp,sp,-32
    80004592:	ec06                	sd	ra,24(sp)
    80004594:	e822                	sd	s0,16(sp)
    80004596:	e426                	sd	s1,8(sp)
    80004598:	e04a                	sd	s2,0(sp)
    8000459a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000459c:	0001d517          	auipc	a0,0x1d
    800045a0:	89450513          	addi	a0,a0,-1900 # 80020e30 <log>
    800045a4:	ffffc097          	auipc	ra,0xffffc
    800045a8:	678080e7          	jalr	1656(ra) # 80000c1c <acquire>
  while(1){
    if(log.committing){
    800045ac:	0001d497          	auipc	s1,0x1d
    800045b0:	88448493          	addi	s1,s1,-1916 # 80020e30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045b4:	4979                	li	s2,30
    800045b6:	a039                	j	800045c4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800045b8:	85a6                	mv	a1,s1
    800045ba:	8526                	mv	a0,s1
    800045bc:	ffffe097          	auipc	ra,0xffffe
    800045c0:	e70080e7          	jalr	-400(ra) # 8000242c <sleep>
    if(log.committing){
    800045c4:	50dc                	lw	a5,36(s1)
    800045c6:	fbed                	bnez	a5,800045b8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045c8:	5098                	lw	a4,32(s1)
    800045ca:	2705                	addiw	a4,a4,1
    800045cc:	0007069b          	sext.w	a3,a4
    800045d0:	0027179b          	slliw	a5,a4,0x2
    800045d4:	9fb9                	addw	a5,a5,a4
    800045d6:	0017979b          	slliw	a5,a5,0x1
    800045da:	54d8                	lw	a4,44(s1)
    800045dc:	9fb9                	addw	a5,a5,a4
    800045de:	00f95963          	bge	s2,a5,800045f0 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800045e2:	85a6                	mv	a1,s1
    800045e4:	8526                	mv	a0,s1
    800045e6:	ffffe097          	auipc	ra,0xffffe
    800045ea:	e46080e7          	jalr	-442(ra) # 8000242c <sleep>
    800045ee:	bfd9                	j	800045c4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800045f0:	0001d517          	auipc	a0,0x1d
    800045f4:	84050513          	addi	a0,a0,-1984 # 80020e30 <log>
    800045f8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800045fa:	ffffc097          	auipc	ra,0xffffc
    800045fe:	6d6080e7          	jalr	1750(ra) # 80000cd0 <release>
      break;
    }
  }
}
    80004602:	60e2                	ld	ra,24(sp)
    80004604:	6442                	ld	s0,16(sp)
    80004606:	64a2                	ld	s1,8(sp)
    80004608:	6902                	ld	s2,0(sp)
    8000460a:	6105                	addi	sp,sp,32
    8000460c:	8082                	ret

000000008000460e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000460e:	7139                	addi	sp,sp,-64
    80004610:	fc06                	sd	ra,56(sp)
    80004612:	f822                	sd	s0,48(sp)
    80004614:	f426                	sd	s1,40(sp)
    80004616:	f04a                	sd	s2,32(sp)
    80004618:	ec4e                	sd	s3,24(sp)
    8000461a:	e852                	sd	s4,16(sp)
    8000461c:	e456                	sd	s5,8(sp)
    8000461e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004620:	0001d497          	auipc	s1,0x1d
    80004624:	81048493          	addi	s1,s1,-2032 # 80020e30 <log>
    80004628:	8526                	mv	a0,s1
    8000462a:	ffffc097          	auipc	ra,0xffffc
    8000462e:	5f2080e7          	jalr	1522(ra) # 80000c1c <acquire>
  log.outstanding -= 1;
    80004632:	509c                	lw	a5,32(s1)
    80004634:	37fd                	addiw	a5,a5,-1
    80004636:	0007891b          	sext.w	s2,a5
    8000463a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000463c:	50dc                	lw	a5,36(s1)
    8000463e:	e7b9                	bnez	a5,8000468c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004640:	04091e63          	bnez	s2,8000469c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004644:	0001c497          	auipc	s1,0x1c
    80004648:	7ec48493          	addi	s1,s1,2028 # 80020e30 <log>
    8000464c:	4785                	li	a5,1
    8000464e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004650:	8526                	mv	a0,s1
    80004652:	ffffc097          	auipc	ra,0xffffc
    80004656:	67e080e7          	jalr	1662(ra) # 80000cd0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000465a:	54dc                	lw	a5,44(s1)
    8000465c:	06f04763          	bgtz	a5,800046ca <end_op+0xbc>
    acquire(&log.lock);
    80004660:	0001c497          	auipc	s1,0x1c
    80004664:	7d048493          	addi	s1,s1,2000 # 80020e30 <log>
    80004668:	8526                	mv	a0,s1
    8000466a:	ffffc097          	auipc	ra,0xffffc
    8000466e:	5b2080e7          	jalr	1458(ra) # 80000c1c <acquire>
    log.committing = 0;
    80004672:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004676:	8526                	mv	a0,s1
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	e18080e7          	jalr	-488(ra) # 80002490 <wakeup>
    release(&log.lock);
    80004680:	8526                	mv	a0,s1
    80004682:	ffffc097          	auipc	ra,0xffffc
    80004686:	64e080e7          	jalr	1614(ra) # 80000cd0 <release>
}
    8000468a:	a03d                	j	800046b8 <end_op+0xaa>
    panic("log.committing");
    8000468c:	00004517          	auipc	a0,0x4
    80004690:	06450513          	addi	a0,a0,100 # 800086f0 <syscalls+0x1f8>
    80004694:	ffffc097          	auipc	ra,0xffffc
    80004698:	ef2080e7          	jalr	-270(ra) # 80000586 <panic>
    wakeup(&log);
    8000469c:	0001c497          	auipc	s1,0x1c
    800046a0:	79448493          	addi	s1,s1,1940 # 80020e30 <log>
    800046a4:	8526                	mv	a0,s1
    800046a6:	ffffe097          	auipc	ra,0xffffe
    800046aa:	dea080e7          	jalr	-534(ra) # 80002490 <wakeup>
  release(&log.lock);
    800046ae:	8526                	mv	a0,s1
    800046b0:	ffffc097          	auipc	ra,0xffffc
    800046b4:	620080e7          	jalr	1568(ra) # 80000cd0 <release>
}
    800046b8:	70e2                	ld	ra,56(sp)
    800046ba:	7442                	ld	s0,48(sp)
    800046bc:	74a2                	ld	s1,40(sp)
    800046be:	7902                	ld	s2,32(sp)
    800046c0:	69e2                	ld	s3,24(sp)
    800046c2:	6a42                	ld	s4,16(sp)
    800046c4:	6aa2                	ld	s5,8(sp)
    800046c6:	6121                	addi	sp,sp,64
    800046c8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800046ca:	0001ca97          	auipc	s5,0x1c
    800046ce:	796a8a93          	addi	s5,s5,1942 # 80020e60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800046d2:	0001ca17          	auipc	s4,0x1c
    800046d6:	75ea0a13          	addi	s4,s4,1886 # 80020e30 <log>
    800046da:	018a2583          	lw	a1,24(s4)
    800046de:	012585bb          	addw	a1,a1,s2
    800046e2:	2585                	addiw	a1,a1,1
    800046e4:	028a2503          	lw	a0,40(s4)
    800046e8:	fffff097          	auipc	ra,0xfffff
    800046ec:	cc4080e7          	jalr	-828(ra) # 800033ac <bread>
    800046f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800046f2:	000aa583          	lw	a1,0(s5)
    800046f6:	028a2503          	lw	a0,40(s4)
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	cb2080e7          	jalr	-846(ra) # 800033ac <bread>
    80004702:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004704:	40000613          	li	a2,1024
    80004708:	05850593          	addi	a1,a0,88
    8000470c:	05848513          	addi	a0,s1,88
    80004710:	ffffc097          	auipc	ra,0xffffc
    80004714:	664080e7          	jalr	1636(ra) # 80000d74 <memmove>
    bwrite(to);  // write the log
    80004718:	8526                	mv	a0,s1
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	d84080e7          	jalr	-636(ra) # 8000349e <bwrite>
    brelse(from);
    80004722:	854e                	mv	a0,s3
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	db8080e7          	jalr	-584(ra) # 800034dc <brelse>
    brelse(to);
    8000472c:	8526                	mv	a0,s1
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	dae080e7          	jalr	-594(ra) # 800034dc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004736:	2905                	addiw	s2,s2,1
    80004738:	0a91                	addi	s5,s5,4
    8000473a:	02ca2783          	lw	a5,44(s4)
    8000473e:	f8f94ee3          	blt	s2,a5,800046da <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004742:	00000097          	auipc	ra,0x0
    80004746:	c68080e7          	jalr	-920(ra) # 800043aa <write_head>
    install_trans(0); // Now install writes to home locations
    8000474a:	4501                	li	a0,0
    8000474c:	00000097          	auipc	ra,0x0
    80004750:	cda080e7          	jalr	-806(ra) # 80004426 <install_trans>
    log.lh.n = 0;
    80004754:	0001c797          	auipc	a5,0x1c
    80004758:	7007a423          	sw	zero,1800(a5) # 80020e5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000475c:	00000097          	auipc	ra,0x0
    80004760:	c4e080e7          	jalr	-946(ra) # 800043aa <write_head>
    80004764:	bdf5                	j	80004660 <end_op+0x52>

0000000080004766 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004766:	1101                	addi	sp,sp,-32
    80004768:	ec06                	sd	ra,24(sp)
    8000476a:	e822                	sd	s0,16(sp)
    8000476c:	e426                	sd	s1,8(sp)
    8000476e:	e04a                	sd	s2,0(sp)
    80004770:	1000                	addi	s0,sp,32
    80004772:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004774:	0001c917          	auipc	s2,0x1c
    80004778:	6bc90913          	addi	s2,s2,1724 # 80020e30 <log>
    8000477c:	854a                	mv	a0,s2
    8000477e:	ffffc097          	auipc	ra,0xffffc
    80004782:	49e080e7          	jalr	1182(ra) # 80000c1c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004786:	02c92603          	lw	a2,44(s2)
    8000478a:	47f5                	li	a5,29
    8000478c:	06c7c563          	blt	a5,a2,800047f6 <log_write+0x90>
    80004790:	0001c797          	auipc	a5,0x1c
    80004794:	6bc7a783          	lw	a5,1724(a5) # 80020e4c <log+0x1c>
    80004798:	37fd                	addiw	a5,a5,-1
    8000479a:	04f65e63          	bge	a2,a5,800047f6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000479e:	0001c797          	auipc	a5,0x1c
    800047a2:	6b27a783          	lw	a5,1714(a5) # 80020e50 <log+0x20>
    800047a6:	06f05063          	blez	a5,80004806 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800047aa:	4781                	li	a5,0
    800047ac:	06c05563          	blez	a2,80004816 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800047b0:	44cc                	lw	a1,12(s1)
    800047b2:	0001c717          	auipc	a4,0x1c
    800047b6:	6ae70713          	addi	a4,a4,1710 # 80020e60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800047ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800047bc:	4314                	lw	a3,0(a4)
    800047be:	04b68c63          	beq	a3,a1,80004816 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800047c2:	2785                	addiw	a5,a5,1
    800047c4:	0711                	addi	a4,a4,4
    800047c6:	fef61be3          	bne	a2,a5,800047bc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800047ca:	0621                	addi	a2,a2,8
    800047cc:	060a                	slli	a2,a2,0x2
    800047ce:	0001c797          	auipc	a5,0x1c
    800047d2:	66278793          	addi	a5,a5,1634 # 80020e30 <log>
    800047d6:	97b2                	add	a5,a5,a2
    800047d8:	44d8                	lw	a4,12(s1)
    800047da:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800047dc:	8526                	mv	a0,s1
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	d9c080e7          	jalr	-612(ra) # 8000357a <bpin>
    log.lh.n++;
    800047e6:	0001c717          	auipc	a4,0x1c
    800047ea:	64a70713          	addi	a4,a4,1610 # 80020e30 <log>
    800047ee:	575c                	lw	a5,44(a4)
    800047f0:	2785                	addiw	a5,a5,1
    800047f2:	d75c                	sw	a5,44(a4)
    800047f4:	a82d                	j	8000482e <log_write+0xc8>
    panic("too big a transaction");
    800047f6:	00004517          	auipc	a0,0x4
    800047fa:	f0a50513          	addi	a0,a0,-246 # 80008700 <syscalls+0x208>
    800047fe:	ffffc097          	auipc	ra,0xffffc
    80004802:	d88080e7          	jalr	-632(ra) # 80000586 <panic>
    panic("log_write outside of trans");
    80004806:	00004517          	auipc	a0,0x4
    8000480a:	f1250513          	addi	a0,a0,-238 # 80008718 <syscalls+0x220>
    8000480e:	ffffc097          	auipc	ra,0xffffc
    80004812:	d78080e7          	jalr	-648(ra) # 80000586 <panic>
  log.lh.block[i] = b->blockno;
    80004816:	00878693          	addi	a3,a5,8
    8000481a:	068a                	slli	a3,a3,0x2
    8000481c:	0001c717          	auipc	a4,0x1c
    80004820:	61470713          	addi	a4,a4,1556 # 80020e30 <log>
    80004824:	9736                	add	a4,a4,a3
    80004826:	44d4                	lw	a3,12(s1)
    80004828:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000482a:	faf609e3          	beq	a2,a5,800047dc <log_write+0x76>
  }
  release(&log.lock);
    8000482e:	0001c517          	auipc	a0,0x1c
    80004832:	60250513          	addi	a0,a0,1538 # 80020e30 <log>
    80004836:	ffffc097          	auipc	ra,0xffffc
    8000483a:	49a080e7          	jalr	1178(ra) # 80000cd0 <release>
}
    8000483e:	60e2                	ld	ra,24(sp)
    80004840:	6442                	ld	s0,16(sp)
    80004842:	64a2                	ld	s1,8(sp)
    80004844:	6902                	ld	s2,0(sp)
    80004846:	6105                	addi	sp,sp,32
    80004848:	8082                	ret

000000008000484a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000484a:	1101                	addi	sp,sp,-32
    8000484c:	ec06                	sd	ra,24(sp)
    8000484e:	e822                	sd	s0,16(sp)
    80004850:	e426                	sd	s1,8(sp)
    80004852:	e04a                	sd	s2,0(sp)
    80004854:	1000                	addi	s0,sp,32
    80004856:	84aa                	mv	s1,a0
    80004858:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000485a:	00004597          	auipc	a1,0x4
    8000485e:	ede58593          	addi	a1,a1,-290 # 80008738 <syscalls+0x240>
    80004862:	0521                	addi	a0,a0,8
    80004864:	ffffc097          	auipc	ra,0xffffc
    80004868:	328080e7          	jalr	808(ra) # 80000b8c <initlock>
  lk->name = name;
    8000486c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004870:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004874:	0204a423          	sw	zero,40(s1)
}
    80004878:	60e2                	ld	ra,24(sp)
    8000487a:	6442                	ld	s0,16(sp)
    8000487c:	64a2                	ld	s1,8(sp)
    8000487e:	6902                	ld	s2,0(sp)
    80004880:	6105                	addi	sp,sp,32
    80004882:	8082                	ret

0000000080004884 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004884:	1101                	addi	sp,sp,-32
    80004886:	ec06                	sd	ra,24(sp)
    80004888:	e822                	sd	s0,16(sp)
    8000488a:	e426                	sd	s1,8(sp)
    8000488c:	e04a                	sd	s2,0(sp)
    8000488e:	1000                	addi	s0,sp,32
    80004890:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004892:	00850913          	addi	s2,a0,8
    80004896:	854a                	mv	a0,s2
    80004898:	ffffc097          	auipc	ra,0xffffc
    8000489c:	384080e7          	jalr	900(ra) # 80000c1c <acquire>
  while (lk->locked) {
    800048a0:	409c                	lw	a5,0(s1)
    800048a2:	cb89                	beqz	a5,800048b4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800048a4:	85ca                	mv	a1,s2
    800048a6:	8526                	mv	a0,s1
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	b84080e7          	jalr	-1148(ra) # 8000242c <sleep>
  while (lk->locked) {
    800048b0:	409c                	lw	a5,0(s1)
    800048b2:	fbed                	bnez	a5,800048a4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800048b4:	4785                	li	a5,1
    800048b6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800048b8:	ffffd097          	auipc	ra,0xffffd
    800048bc:	3ae080e7          	jalr	942(ra) # 80001c66 <myproc>
    800048c0:	591c                	lw	a5,48(a0)
    800048c2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800048c4:	854a                	mv	a0,s2
    800048c6:	ffffc097          	auipc	ra,0xffffc
    800048ca:	40a080e7          	jalr	1034(ra) # 80000cd0 <release>
}
    800048ce:	60e2                	ld	ra,24(sp)
    800048d0:	6442                	ld	s0,16(sp)
    800048d2:	64a2                	ld	s1,8(sp)
    800048d4:	6902                	ld	s2,0(sp)
    800048d6:	6105                	addi	sp,sp,32
    800048d8:	8082                	ret

00000000800048da <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800048da:	1101                	addi	sp,sp,-32
    800048dc:	ec06                	sd	ra,24(sp)
    800048de:	e822                	sd	s0,16(sp)
    800048e0:	e426                	sd	s1,8(sp)
    800048e2:	e04a                	sd	s2,0(sp)
    800048e4:	1000                	addi	s0,sp,32
    800048e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048e8:	00850913          	addi	s2,a0,8
    800048ec:	854a                	mv	a0,s2
    800048ee:	ffffc097          	auipc	ra,0xffffc
    800048f2:	32e080e7          	jalr	814(ra) # 80000c1c <acquire>
  lk->locked = 0;
    800048f6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048fa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800048fe:	8526                	mv	a0,s1
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	b90080e7          	jalr	-1136(ra) # 80002490 <wakeup>
  release(&lk->lk);
    80004908:	854a                	mv	a0,s2
    8000490a:	ffffc097          	auipc	ra,0xffffc
    8000490e:	3c6080e7          	jalr	966(ra) # 80000cd0 <release>
}
    80004912:	60e2                	ld	ra,24(sp)
    80004914:	6442                	ld	s0,16(sp)
    80004916:	64a2                	ld	s1,8(sp)
    80004918:	6902                	ld	s2,0(sp)
    8000491a:	6105                	addi	sp,sp,32
    8000491c:	8082                	ret

000000008000491e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000491e:	7179                	addi	sp,sp,-48
    80004920:	f406                	sd	ra,40(sp)
    80004922:	f022                	sd	s0,32(sp)
    80004924:	ec26                	sd	s1,24(sp)
    80004926:	e84a                	sd	s2,16(sp)
    80004928:	e44e                	sd	s3,8(sp)
    8000492a:	1800                	addi	s0,sp,48
    8000492c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000492e:	00850913          	addi	s2,a0,8
    80004932:	854a                	mv	a0,s2
    80004934:	ffffc097          	auipc	ra,0xffffc
    80004938:	2e8080e7          	jalr	744(ra) # 80000c1c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000493c:	409c                	lw	a5,0(s1)
    8000493e:	ef99                	bnez	a5,8000495c <holdingsleep+0x3e>
    80004940:	4481                	li	s1,0
  release(&lk->lk);
    80004942:	854a                	mv	a0,s2
    80004944:	ffffc097          	auipc	ra,0xffffc
    80004948:	38c080e7          	jalr	908(ra) # 80000cd0 <release>
  return r;
}
    8000494c:	8526                	mv	a0,s1
    8000494e:	70a2                	ld	ra,40(sp)
    80004950:	7402                	ld	s0,32(sp)
    80004952:	64e2                	ld	s1,24(sp)
    80004954:	6942                	ld	s2,16(sp)
    80004956:	69a2                	ld	s3,8(sp)
    80004958:	6145                	addi	sp,sp,48
    8000495a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000495c:	0284a983          	lw	s3,40(s1)
    80004960:	ffffd097          	auipc	ra,0xffffd
    80004964:	306080e7          	jalr	774(ra) # 80001c66 <myproc>
    80004968:	5904                	lw	s1,48(a0)
    8000496a:	413484b3          	sub	s1,s1,s3
    8000496e:	0014b493          	seqz	s1,s1
    80004972:	bfc1                	j	80004942 <holdingsleep+0x24>

0000000080004974 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004974:	1141                	addi	sp,sp,-16
    80004976:	e406                	sd	ra,8(sp)
    80004978:	e022                	sd	s0,0(sp)
    8000497a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000497c:	00004597          	auipc	a1,0x4
    80004980:	dcc58593          	addi	a1,a1,-564 # 80008748 <syscalls+0x250>
    80004984:	0001c517          	auipc	a0,0x1c
    80004988:	5f450513          	addi	a0,a0,1524 # 80020f78 <ftable>
    8000498c:	ffffc097          	auipc	ra,0xffffc
    80004990:	200080e7          	jalr	512(ra) # 80000b8c <initlock>
}
    80004994:	60a2                	ld	ra,8(sp)
    80004996:	6402                	ld	s0,0(sp)
    80004998:	0141                	addi	sp,sp,16
    8000499a:	8082                	ret

000000008000499c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000499c:	1101                	addi	sp,sp,-32
    8000499e:	ec06                	sd	ra,24(sp)
    800049a0:	e822                	sd	s0,16(sp)
    800049a2:	e426                	sd	s1,8(sp)
    800049a4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800049a6:	0001c517          	auipc	a0,0x1c
    800049aa:	5d250513          	addi	a0,a0,1490 # 80020f78 <ftable>
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	26e080e7          	jalr	622(ra) # 80000c1c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049b6:	0001c497          	auipc	s1,0x1c
    800049ba:	5da48493          	addi	s1,s1,1498 # 80020f90 <ftable+0x18>
    800049be:	0001d717          	auipc	a4,0x1d
    800049c2:	57270713          	addi	a4,a4,1394 # 80021f30 <disk>
    if(f->ref == 0){
    800049c6:	40dc                	lw	a5,4(s1)
    800049c8:	cf99                	beqz	a5,800049e6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049ca:	02848493          	addi	s1,s1,40
    800049ce:	fee49ce3          	bne	s1,a4,800049c6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800049d2:	0001c517          	auipc	a0,0x1c
    800049d6:	5a650513          	addi	a0,a0,1446 # 80020f78 <ftable>
    800049da:	ffffc097          	auipc	ra,0xffffc
    800049de:	2f6080e7          	jalr	758(ra) # 80000cd0 <release>
  return 0;
    800049e2:	4481                	li	s1,0
    800049e4:	a819                	j	800049fa <filealloc+0x5e>
      f->ref = 1;
    800049e6:	4785                	li	a5,1
    800049e8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800049ea:	0001c517          	auipc	a0,0x1c
    800049ee:	58e50513          	addi	a0,a0,1422 # 80020f78 <ftable>
    800049f2:	ffffc097          	auipc	ra,0xffffc
    800049f6:	2de080e7          	jalr	734(ra) # 80000cd0 <release>
}
    800049fa:	8526                	mv	a0,s1
    800049fc:	60e2                	ld	ra,24(sp)
    800049fe:	6442                	ld	s0,16(sp)
    80004a00:	64a2                	ld	s1,8(sp)
    80004a02:	6105                	addi	sp,sp,32
    80004a04:	8082                	ret

0000000080004a06 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a06:	1101                	addi	sp,sp,-32
    80004a08:	ec06                	sd	ra,24(sp)
    80004a0a:	e822                	sd	s0,16(sp)
    80004a0c:	e426                	sd	s1,8(sp)
    80004a0e:	1000                	addi	s0,sp,32
    80004a10:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a12:	0001c517          	auipc	a0,0x1c
    80004a16:	56650513          	addi	a0,a0,1382 # 80020f78 <ftable>
    80004a1a:	ffffc097          	auipc	ra,0xffffc
    80004a1e:	202080e7          	jalr	514(ra) # 80000c1c <acquire>
  if(f->ref < 1)
    80004a22:	40dc                	lw	a5,4(s1)
    80004a24:	02f05263          	blez	a5,80004a48 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004a28:	2785                	addiw	a5,a5,1
    80004a2a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a2c:	0001c517          	auipc	a0,0x1c
    80004a30:	54c50513          	addi	a0,a0,1356 # 80020f78 <ftable>
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	29c080e7          	jalr	668(ra) # 80000cd0 <release>
  return f;
}
    80004a3c:	8526                	mv	a0,s1
    80004a3e:	60e2                	ld	ra,24(sp)
    80004a40:	6442                	ld	s0,16(sp)
    80004a42:	64a2                	ld	s1,8(sp)
    80004a44:	6105                	addi	sp,sp,32
    80004a46:	8082                	ret
    panic("filedup");
    80004a48:	00004517          	auipc	a0,0x4
    80004a4c:	d0850513          	addi	a0,a0,-760 # 80008750 <syscalls+0x258>
    80004a50:	ffffc097          	auipc	ra,0xffffc
    80004a54:	b36080e7          	jalr	-1226(ra) # 80000586 <panic>

0000000080004a58 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a58:	7139                	addi	sp,sp,-64
    80004a5a:	fc06                	sd	ra,56(sp)
    80004a5c:	f822                	sd	s0,48(sp)
    80004a5e:	f426                	sd	s1,40(sp)
    80004a60:	f04a                	sd	s2,32(sp)
    80004a62:	ec4e                	sd	s3,24(sp)
    80004a64:	e852                	sd	s4,16(sp)
    80004a66:	e456                	sd	s5,8(sp)
    80004a68:	0080                	addi	s0,sp,64
    80004a6a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a6c:	0001c517          	auipc	a0,0x1c
    80004a70:	50c50513          	addi	a0,a0,1292 # 80020f78 <ftable>
    80004a74:	ffffc097          	auipc	ra,0xffffc
    80004a78:	1a8080e7          	jalr	424(ra) # 80000c1c <acquire>
  if(f->ref < 1)
    80004a7c:	40dc                	lw	a5,4(s1)
    80004a7e:	06f05163          	blez	a5,80004ae0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004a82:	37fd                	addiw	a5,a5,-1
    80004a84:	0007871b          	sext.w	a4,a5
    80004a88:	c0dc                	sw	a5,4(s1)
    80004a8a:	06e04363          	bgtz	a4,80004af0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a8e:	0004a903          	lw	s2,0(s1)
    80004a92:	0094ca83          	lbu	s5,9(s1)
    80004a96:	0104ba03          	ld	s4,16(s1)
    80004a9a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004a9e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004aa2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004aa6:	0001c517          	auipc	a0,0x1c
    80004aaa:	4d250513          	addi	a0,a0,1234 # 80020f78 <ftable>
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	222080e7          	jalr	546(ra) # 80000cd0 <release>

  if(ff.type == FD_PIPE){
    80004ab6:	4785                	li	a5,1
    80004ab8:	04f90d63          	beq	s2,a5,80004b12 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004abc:	3979                	addiw	s2,s2,-2
    80004abe:	4785                	li	a5,1
    80004ac0:	0527e063          	bltu	a5,s2,80004b00 <fileclose+0xa8>
    begin_op();
    80004ac4:	00000097          	auipc	ra,0x0
    80004ac8:	acc080e7          	jalr	-1332(ra) # 80004590 <begin_op>
    iput(ff.ip);
    80004acc:	854e                	mv	a0,s3
    80004ace:	fffff097          	auipc	ra,0xfffff
    80004ad2:	2b0080e7          	jalr	688(ra) # 80003d7e <iput>
    end_op();
    80004ad6:	00000097          	auipc	ra,0x0
    80004ada:	b38080e7          	jalr	-1224(ra) # 8000460e <end_op>
    80004ade:	a00d                	j	80004b00 <fileclose+0xa8>
    panic("fileclose");
    80004ae0:	00004517          	auipc	a0,0x4
    80004ae4:	c7850513          	addi	a0,a0,-904 # 80008758 <syscalls+0x260>
    80004ae8:	ffffc097          	auipc	ra,0xffffc
    80004aec:	a9e080e7          	jalr	-1378(ra) # 80000586 <panic>
    release(&ftable.lock);
    80004af0:	0001c517          	auipc	a0,0x1c
    80004af4:	48850513          	addi	a0,a0,1160 # 80020f78 <ftable>
    80004af8:	ffffc097          	auipc	ra,0xffffc
    80004afc:	1d8080e7          	jalr	472(ra) # 80000cd0 <release>
  }
}
    80004b00:	70e2                	ld	ra,56(sp)
    80004b02:	7442                	ld	s0,48(sp)
    80004b04:	74a2                	ld	s1,40(sp)
    80004b06:	7902                	ld	s2,32(sp)
    80004b08:	69e2                	ld	s3,24(sp)
    80004b0a:	6a42                	ld	s4,16(sp)
    80004b0c:	6aa2                	ld	s5,8(sp)
    80004b0e:	6121                	addi	sp,sp,64
    80004b10:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b12:	85d6                	mv	a1,s5
    80004b14:	8552                	mv	a0,s4
    80004b16:	00000097          	auipc	ra,0x0
    80004b1a:	34c080e7          	jalr	844(ra) # 80004e62 <pipeclose>
    80004b1e:	b7cd                	j	80004b00 <fileclose+0xa8>

0000000080004b20 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b20:	715d                	addi	sp,sp,-80
    80004b22:	e486                	sd	ra,72(sp)
    80004b24:	e0a2                	sd	s0,64(sp)
    80004b26:	fc26                	sd	s1,56(sp)
    80004b28:	f84a                	sd	s2,48(sp)
    80004b2a:	f44e                	sd	s3,40(sp)
    80004b2c:	0880                	addi	s0,sp,80
    80004b2e:	84aa                	mv	s1,a0
    80004b30:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b32:	ffffd097          	auipc	ra,0xffffd
    80004b36:	134080e7          	jalr	308(ra) # 80001c66 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004b3a:	409c                	lw	a5,0(s1)
    80004b3c:	37f9                	addiw	a5,a5,-2
    80004b3e:	4705                	li	a4,1
    80004b40:	04f76763          	bltu	a4,a5,80004b8e <filestat+0x6e>
    80004b44:	892a                	mv	s2,a0
    ilock(f->ip);
    80004b46:	6c88                	ld	a0,24(s1)
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	07c080e7          	jalr	124(ra) # 80003bc4 <ilock>
    stati(f->ip, &st);
    80004b50:	fb840593          	addi	a1,s0,-72
    80004b54:	6c88                	ld	a0,24(s1)
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	2f8080e7          	jalr	760(ra) # 80003e4e <stati>
    iunlock(f->ip);
    80004b5e:	6c88                	ld	a0,24(s1)
    80004b60:	fffff097          	auipc	ra,0xfffff
    80004b64:	126080e7          	jalr	294(ra) # 80003c86 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004b68:	46e1                	li	a3,24
    80004b6a:	fb840613          	addi	a2,s0,-72
    80004b6e:	85ce                	mv	a1,s3
    80004b70:	05893503          	ld	a0,88(s2)
    80004b74:	ffffd097          	auipc	ra,0xffffd
    80004b78:	b3e080e7          	jalr	-1218(ra) # 800016b2 <copyout>
    80004b7c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004b80:	60a6                	ld	ra,72(sp)
    80004b82:	6406                	ld	s0,64(sp)
    80004b84:	74e2                	ld	s1,56(sp)
    80004b86:	7942                	ld	s2,48(sp)
    80004b88:	79a2                	ld	s3,40(sp)
    80004b8a:	6161                	addi	sp,sp,80
    80004b8c:	8082                	ret
  return -1;
    80004b8e:	557d                	li	a0,-1
    80004b90:	bfc5                	j	80004b80 <filestat+0x60>

0000000080004b92 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b92:	7179                	addi	sp,sp,-48
    80004b94:	f406                	sd	ra,40(sp)
    80004b96:	f022                	sd	s0,32(sp)
    80004b98:	ec26                	sd	s1,24(sp)
    80004b9a:	e84a                	sd	s2,16(sp)
    80004b9c:	e44e                	sd	s3,8(sp)
    80004b9e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ba0:	00854783          	lbu	a5,8(a0)
    80004ba4:	c3d5                	beqz	a5,80004c48 <fileread+0xb6>
    80004ba6:	84aa                	mv	s1,a0
    80004ba8:	89ae                	mv	s3,a1
    80004baa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004bac:	411c                	lw	a5,0(a0)
    80004bae:	4705                	li	a4,1
    80004bb0:	04e78963          	beq	a5,a4,80004c02 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004bb4:	470d                	li	a4,3
    80004bb6:	04e78d63          	beq	a5,a4,80004c10 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004bba:	4709                	li	a4,2
    80004bbc:	06e79e63          	bne	a5,a4,80004c38 <fileread+0xa6>
    ilock(f->ip);
    80004bc0:	6d08                	ld	a0,24(a0)
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	002080e7          	jalr	2(ra) # 80003bc4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004bca:	874a                	mv	a4,s2
    80004bcc:	5094                	lw	a3,32(s1)
    80004bce:	864e                	mv	a2,s3
    80004bd0:	4585                	li	a1,1
    80004bd2:	6c88                	ld	a0,24(s1)
    80004bd4:	fffff097          	auipc	ra,0xfffff
    80004bd8:	2a4080e7          	jalr	676(ra) # 80003e78 <readi>
    80004bdc:	892a                	mv	s2,a0
    80004bde:	00a05563          	blez	a0,80004be8 <fileread+0x56>
      f->off += r;
    80004be2:	509c                	lw	a5,32(s1)
    80004be4:	9fa9                	addw	a5,a5,a0
    80004be6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004be8:	6c88                	ld	a0,24(s1)
    80004bea:	fffff097          	auipc	ra,0xfffff
    80004bee:	09c080e7          	jalr	156(ra) # 80003c86 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004bf2:	854a                	mv	a0,s2
    80004bf4:	70a2                	ld	ra,40(sp)
    80004bf6:	7402                	ld	s0,32(sp)
    80004bf8:	64e2                	ld	s1,24(sp)
    80004bfa:	6942                	ld	s2,16(sp)
    80004bfc:	69a2                	ld	s3,8(sp)
    80004bfe:	6145                	addi	sp,sp,48
    80004c00:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c02:	6908                	ld	a0,16(a0)
    80004c04:	00000097          	auipc	ra,0x0
    80004c08:	3c6080e7          	jalr	966(ra) # 80004fca <piperead>
    80004c0c:	892a                	mv	s2,a0
    80004c0e:	b7d5                	j	80004bf2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c10:	02451783          	lh	a5,36(a0)
    80004c14:	03079693          	slli	a3,a5,0x30
    80004c18:	92c1                	srli	a3,a3,0x30
    80004c1a:	4725                	li	a4,9
    80004c1c:	02d76863          	bltu	a4,a3,80004c4c <fileread+0xba>
    80004c20:	0792                	slli	a5,a5,0x4
    80004c22:	0001c717          	auipc	a4,0x1c
    80004c26:	2b670713          	addi	a4,a4,694 # 80020ed8 <devsw>
    80004c2a:	97ba                	add	a5,a5,a4
    80004c2c:	639c                	ld	a5,0(a5)
    80004c2e:	c38d                	beqz	a5,80004c50 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004c30:	4505                	li	a0,1
    80004c32:	9782                	jalr	a5
    80004c34:	892a                	mv	s2,a0
    80004c36:	bf75                	j	80004bf2 <fileread+0x60>
    panic("fileread");
    80004c38:	00004517          	auipc	a0,0x4
    80004c3c:	b3050513          	addi	a0,a0,-1232 # 80008768 <syscalls+0x270>
    80004c40:	ffffc097          	auipc	ra,0xffffc
    80004c44:	946080e7          	jalr	-1722(ra) # 80000586 <panic>
    return -1;
    80004c48:	597d                	li	s2,-1
    80004c4a:	b765                	j	80004bf2 <fileread+0x60>
      return -1;
    80004c4c:	597d                	li	s2,-1
    80004c4e:	b755                	j	80004bf2 <fileread+0x60>
    80004c50:	597d                	li	s2,-1
    80004c52:	b745                	j	80004bf2 <fileread+0x60>

0000000080004c54 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004c54:	715d                	addi	sp,sp,-80
    80004c56:	e486                	sd	ra,72(sp)
    80004c58:	e0a2                	sd	s0,64(sp)
    80004c5a:	fc26                	sd	s1,56(sp)
    80004c5c:	f84a                	sd	s2,48(sp)
    80004c5e:	f44e                	sd	s3,40(sp)
    80004c60:	f052                	sd	s4,32(sp)
    80004c62:	ec56                	sd	s5,24(sp)
    80004c64:	e85a                	sd	s6,16(sp)
    80004c66:	e45e                	sd	s7,8(sp)
    80004c68:	e062                	sd	s8,0(sp)
    80004c6a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004c6c:	00954783          	lbu	a5,9(a0)
    80004c70:	10078663          	beqz	a5,80004d7c <filewrite+0x128>
    80004c74:	892a                	mv	s2,a0
    80004c76:	8b2e                	mv	s6,a1
    80004c78:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c7a:	411c                	lw	a5,0(a0)
    80004c7c:	4705                	li	a4,1
    80004c7e:	02e78263          	beq	a5,a4,80004ca2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c82:	470d                	li	a4,3
    80004c84:	02e78663          	beq	a5,a4,80004cb0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c88:	4709                	li	a4,2
    80004c8a:	0ee79163          	bne	a5,a4,80004d6c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c8e:	0ac05d63          	blez	a2,80004d48 <filewrite+0xf4>
    int i = 0;
    80004c92:	4981                	li	s3,0
    80004c94:	6b85                	lui	s7,0x1
    80004c96:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004c9a:	6c05                	lui	s8,0x1
    80004c9c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004ca0:	a861                	j	80004d38 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004ca2:	6908                	ld	a0,16(a0)
    80004ca4:	00000097          	auipc	ra,0x0
    80004ca8:	22e080e7          	jalr	558(ra) # 80004ed2 <pipewrite>
    80004cac:	8a2a                	mv	s4,a0
    80004cae:	a045                	j	80004d4e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004cb0:	02451783          	lh	a5,36(a0)
    80004cb4:	03079693          	slli	a3,a5,0x30
    80004cb8:	92c1                	srli	a3,a3,0x30
    80004cba:	4725                	li	a4,9
    80004cbc:	0cd76263          	bltu	a4,a3,80004d80 <filewrite+0x12c>
    80004cc0:	0792                	slli	a5,a5,0x4
    80004cc2:	0001c717          	auipc	a4,0x1c
    80004cc6:	21670713          	addi	a4,a4,534 # 80020ed8 <devsw>
    80004cca:	97ba                	add	a5,a5,a4
    80004ccc:	679c                	ld	a5,8(a5)
    80004cce:	cbdd                	beqz	a5,80004d84 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004cd0:	4505                	li	a0,1
    80004cd2:	9782                	jalr	a5
    80004cd4:	8a2a                	mv	s4,a0
    80004cd6:	a8a5                	j	80004d4e <filewrite+0xfa>
    80004cd8:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004cdc:	00000097          	auipc	ra,0x0
    80004ce0:	8b4080e7          	jalr	-1868(ra) # 80004590 <begin_op>
      ilock(f->ip);
    80004ce4:	01893503          	ld	a0,24(s2)
    80004ce8:	fffff097          	auipc	ra,0xfffff
    80004cec:	edc080e7          	jalr	-292(ra) # 80003bc4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004cf0:	8756                	mv	a4,s5
    80004cf2:	02092683          	lw	a3,32(s2)
    80004cf6:	01698633          	add	a2,s3,s6
    80004cfa:	4585                	li	a1,1
    80004cfc:	01893503          	ld	a0,24(s2)
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	270080e7          	jalr	624(ra) # 80003f70 <writei>
    80004d08:	84aa                	mv	s1,a0
    80004d0a:	00a05763          	blez	a0,80004d18 <filewrite+0xc4>
        f->off += r;
    80004d0e:	02092783          	lw	a5,32(s2)
    80004d12:	9fa9                	addw	a5,a5,a0
    80004d14:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d18:	01893503          	ld	a0,24(s2)
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	f6a080e7          	jalr	-150(ra) # 80003c86 <iunlock>
      end_op();
    80004d24:	00000097          	auipc	ra,0x0
    80004d28:	8ea080e7          	jalr	-1814(ra) # 8000460e <end_op>

      if(r != n1){
    80004d2c:	009a9f63          	bne	s5,s1,80004d4a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004d30:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004d34:	0149db63          	bge	s3,s4,80004d4a <filewrite+0xf6>
      int n1 = n - i;
    80004d38:	413a04bb          	subw	s1,s4,s3
    80004d3c:	0004879b          	sext.w	a5,s1
    80004d40:	f8fbdce3          	bge	s7,a5,80004cd8 <filewrite+0x84>
    80004d44:	84e2                	mv	s1,s8
    80004d46:	bf49                	j	80004cd8 <filewrite+0x84>
    int i = 0;
    80004d48:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004d4a:	013a1f63          	bne	s4,s3,80004d68 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d4e:	8552                	mv	a0,s4
    80004d50:	60a6                	ld	ra,72(sp)
    80004d52:	6406                	ld	s0,64(sp)
    80004d54:	74e2                	ld	s1,56(sp)
    80004d56:	7942                	ld	s2,48(sp)
    80004d58:	79a2                	ld	s3,40(sp)
    80004d5a:	7a02                	ld	s4,32(sp)
    80004d5c:	6ae2                	ld	s5,24(sp)
    80004d5e:	6b42                	ld	s6,16(sp)
    80004d60:	6ba2                	ld	s7,8(sp)
    80004d62:	6c02                	ld	s8,0(sp)
    80004d64:	6161                	addi	sp,sp,80
    80004d66:	8082                	ret
    ret = (i == n ? n : -1);
    80004d68:	5a7d                	li	s4,-1
    80004d6a:	b7d5                	j	80004d4e <filewrite+0xfa>
    panic("filewrite");
    80004d6c:	00004517          	auipc	a0,0x4
    80004d70:	a0c50513          	addi	a0,a0,-1524 # 80008778 <syscalls+0x280>
    80004d74:	ffffc097          	auipc	ra,0xffffc
    80004d78:	812080e7          	jalr	-2030(ra) # 80000586 <panic>
    return -1;
    80004d7c:	5a7d                	li	s4,-1
    80004d7e:	bfc1                	j	80004d4e <filewrite+0xfa>
      return -1;
    80004d80:	5a7d                	li	s4,-1
    80004d82:	b7f1                	j	80004d4e <filewrite+0xfa>
    80004d84:	5a7d                	li	s4,-1
    80004d86:	b7e1                	j	80004d4e <filewrite+0xfa>

0000000080004d88 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d88:	7179                	addi	sp,sp,-48
    80004d8a:	f406                	sd	ra,40(sp)
    80004d8c:	f022                	sd	s0,32(sp)
    80004d8e:	ec26                	sd	s1,24(sp)
    80004d90:	e84a                	sd	s2,16(sp)
    80004d92:	e44e                	sd	s3,8(sp)
    80004d94:	e052                	sd	s4,0(sp)
    80004d96:	1800                	addi	s0,sp,48
    80004d98:	84aa                	mv	s1,a0
    80004d9a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004d9c:	0005b023          	sd	zero,0(a1)
    80004da0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004da4:	00000097          	auipc	ra,0x0
    80004da8:	bf8080e7          	jalr	-1032(ra) # 8000499c <filealloc>
    80004dac:	e088                	sd	a0,0(s1)
    80004dae:	c551                	beqz	a0,80004e3a <pipealloc+0xb2>
    80004db0:	00000097          	auipc	ra,0x0
    80004db4:	bec080e7          	jalr	-1044(ra) # 8000499c <filealloc>
    80004db8:	00aa3023          	sd	a0,0(s4)
    80004dbc:	c92d                	beqz	a0,80004e2e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004dbe:	ffffc097          	auipc	ra,0xffffc
    80004dc2:	d6e080e7          	jalr	-658(ra) # 80000b2c <kalloc>
    80004dc6:	892a                	mv	s2,a0
    80004dc8:	c125                	beqz	a0,80004e28 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004dca:	4985                	li	s3,1
    80004dcc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004dd0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004dd4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004dd8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004ddc:	00004597          	auipc	a1,0x4
    80004de0:	9ac58593          	addi	a1,a1,-1620 # 80008788 <syscalls+0x290>
    80004de4:	ffffc097          	auipc	ra,0xffffc
    80004de8:	da8080e7          	jalr	-600(ra) # 80000b8c <initlock>
  (*f0)->type = FD_PIPE;
    80004dec:	609c                	ld	a5,0(s1)
    80004dee:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004df2:	609c                	ld	a5,0(s1)
    80004df4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004df8:	609c                	ld	a5,0(s1)
    80004dfa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004dfe:	609c                	ld	a5,0(s1)
    80004e00:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e04:	000a3783          	ld	a5,0(s4)
    80004e08:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e0c:	000a3783          	ld	a5,0(s4)
    80004e10:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004e14:	000a3783          	ld	a5,0(s4)
    80004e18:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004e1c:	000a3783          	ld	a5,0(s4)
    80004e20:	0127b823          	sd	s2,16(a5)
  return 0;
    80004e24:	4501                	li	a0,0
    80004e26:	a025                	j	80004e4e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004e28:	6088                	ld	a0,0(s1)
    80004e2a:	e501                	bnez	a0,80004e32 <pipealloc+0xaa>
    80004e2c:	a039                	j	80004e3a <pipealloc+0xb2>
    80004e2e:	6088                	ld	a0,0(s1)
    80004e30:	c51d                	beqz	a0,80004e5e <pipealloc+0xd6>
    fileclose(*f0);
    80004e32:	00000097          	auipc	ra,0x0
    80004e36:	c26080e7          	jalr	-986(ra) # 80004a58 <fileclose>
  if(*f1)
    80004e3a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004e3e:	557d                	li	a0,-1
  if(*f1)
    80004e40:	c799                	beqz	a5,80004e4e <pipealloc+0xc6>
    fileclose(*f1);
    80004e42:	853e                	mv	a0,a5
    80004e44:	00000097          	auipc	ra,0x0
    80004e48:	c14080e7          	jalr	-1004(ra) # 80004a58 <fileclose>
  return -1;
    80004e4c:	557d                	li	a0,-1
}
    80004e4e:	70a2                	ld	ra,40(sp)
    80004e50:	7402                	ld	s0,32(sp)
    80004e52:	64e2                	ld	s1,24(sp)
    80004e54:	6942                	ld	s2,16(sp)
    80004e56:	69a2                	ld	s3,8(sp)
    80004e58:	6a02                	ld	s4,0(sp)
    80004e5a:	6145                	addi	sp,sp,48
    80004e5c:	8082                	ret
  return -1;
    80004e5e:	557d                	li	a0,-1
    80004e60:	b7fd                	j	80004e4e <pipealloc+0xc6>

0000000080004e62 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e62:	1101                	addi	sp,sp,-32
    80004e64:	ec06                	sd	ra,24(sp)
    80004e66:	e822                	sd	s0,16(sp)
    80004e68:	e426                	sd	s1,8(sp)
    80004e6a:	e04a                	sd	s2,0(sp)
    80004e6c:	1000                	addi	s0,sp,32
    80004e6e:	84aa                	mv	s1,a0
    80004e70:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e72:	ffffc097          	auipc	ra,0xffffc
    80004e76:	daa080e7          	jalr	-598(ra) # 80000c1c <acquire>
  if(writable){
    80004e7a:	02090d63          	beqz	s2,80004eb4 <pipeclose+0x52>
    pi->writeopen = 0;
    80004e7e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e82:	21848513          	addi	a0,s1,536
    80004e86:	ffffd097          	auipc	ra,0xffffd
    80004e8a:	60a080e7          	jalr	1546(ra) # 80002490 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e8e:	2204b783          	ld	a5,544(s1)
    80004e92:	eb95                	bnez	a5,80004ec6 <pipeclose+0x64>
    release(&pi->lock);
    80004e94:	8526                	mv	a0,s1
    80004e96:	ffffc097          	auipc	ra,0xffffc
    80004e9a:	e3a080e7          	jalr	-454(ra) # 80000cd0 <release>
    kfree((char*)pi);
    80004e9e:	8526                	mv	a0,s1
    80004ea0:	ffffc097          	auipc	ra,0xffffc
    80004ea4:	b8e080e7          	jalr	-1138(ra) # 80000a2e <kfree>
  } else
    release(&pi->lock);
}
    80004ea8:	60e2                	ld	ra,24(sp)
    80004eaa:	6442                	ld	s0,16(sp)
    80004eac:	64a2                	ld	s1,8(sp)
    80004eae:	6902                	ld	s2,0(sp)
    80004eb0:	6105                	addi	sp,sp,32
    80004eb2:	8082                	ret
    pi->readopen = 0;
    80004eb4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004eb8:	21c48513          	addi	a0,s1,540
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	5d4080e7          	jalr	1492(ra) # 80002490 <wakeup>
    80004ec4:	b7e9                	j	80004e8e <pipeclose+0x2c>
    release(&pi->lock);
    80004ec6:	8526                	mv	a0,s1
    80004ec8:	ffffc097          	auipc	ra,0xffffc
    80004ecc:	e08080e7          	jalr	-504(ra) # 80000cd0 <release>
}
    80004ed0:	bfe1                	j	80004ea8 <pipeclose+0x46>

0000000080004ed2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004ed2:	711d                	addi	sp,sp,-96
    80004ed4:	ec86                	sd	ra,88(sp)
    80004ed6:	e8a2                	sd	s0,80(sp)
    80004ed8:	e4a6                	sd	s1,72(sp)
    80004eda:	e0ca                	sd	s2,64(sp)
    80004edc:	fc4e                	sd	s3,56(sp)
    80004ede:	f852                	sd	s4,48(sp)
    80004ee0:	f456                	sd	s5,40(sp)
    80004ee2:	f05a                	sd	s6,32(sp)
    80004ee4:	ec5e                	sd	s7,24(sp)
    80004ee6:	e862                	sd	s8,16(sp)
    80004ee8:	1080                	addi	s0,sp,96
    80004eea:	84aa                	mv	s1,a0
    80004eec:	8aae                	mv	s5,a1
    80004eee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004ef0:	ffffd097          	auipc	ra,0xffffd
    80004ef4:	d76080e7          	jalr	-650(ra) # 80001c66 <myproc>
    80004ef8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004efa:	8526                	mv	a0,s1
    80004efc:	ffffc097          	auipc	ra,0xffffc
    80004f00:	d20080e7          	jalr	-736(ra) # 80000c1c <acquire>
  while(i < n){
    80004f04:	0b405663          	blez	s4,80004fb0 <pipewrite+0xde>
  int i = 0;
    80004f08:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f0a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004f0c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004f10:	21c48b93          	addi	s7,s1,540
    80004f14:	a089                	j	80004f56 <pipewrite+0x84>
      release(&pi->lock);
    80004f16:	8526                	mv	a0,s1
    80004f18:	ffffc097          	auipc	ra,0xffffc
    80004f1c:	db8080e7          	jalr	-584(ra) # 80000cd0 <release>
      return -1;
    80004f20:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004f22:	854a                	mv	a0,s2
    80004f24:	60e6                	ld	ra,88(sp)
    80004f26:	6446                	ld	s0,80(sp)
    80004f28:	64a6                	ld	s1,72(sp)
    80004f2a:	6906                	ld	s2,64(sp)
    80004f2c:	79e2                	ld	s3,56(sp)
    80004f2e:	7a42                	ld	s4,48(sp)
    80004f30:	7aa2                	ld	s5,40(sp)
    80004f32:	7b02                	ld	s6,32(sp)
    80004f34:	6be2                	ld	s7,24(sp)
    80004f36:	6c42                	ld	s8,16(sp)
    80004f38:	6125                	addi	sp,sp,96
    80004f3a:	8082                	ret
      wakeup(&pi->nread);
    80004f3c:	8562                	mv	a0,s8
    80004f3e:	ffffd097          	auipc	ra,0xffffd
    80004f42:	552080e7          	jalr	1362(ra) # 80002490 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004f46:	85a6                	mv	a1,s1
    80004f48:	855e                	mv	a0,s7
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	4e2080e7          	jalr	1250(ra) # 8000242c <sleep>
  while(i < n){
    80004f52:	07495063          	bge	s2,s4,80004fb2 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004f56:	2204a783          	lw	a5,544(s1)
    80004f5a:	dfd5                	beqz	a5,80004f16 <pipewrite+0x44>
    80004f5c:	854e                	mv	a0,s3
    80004f5e:	ffffd097          	auipc	ra,0xffffd
    80004f62:	776080e7          	jalr	1910(ra) # 800026d4 <killed>
    80004f66:	f945                	bnez	a0,80004f16 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004f68:	2184a783          	lw	a5,536(s1)
    80004f6c:	21c4a703          	lw	a4,540(s1)
    80004f70:	2007879b          	addiw	a5,a5,512
    80004f74:	fcf704e3          	beq	a4,a5,80004f3c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f78:	4685                	li	a3,1
    80004f7a:	01590633          	add	a2,s2,s5
    80004f7e:	faf40593          	addi	a1,s0,-81
    80004f82:	0589b503          	ld	a0,88(s3)
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	7b8080e7          	jalr	1976(ra) # 8000173e <copyin>
    80004f8e:	03650263          	beq	a0,s6,80004fb2 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f92:	21c4a783          	lw	a5,540(s1)
    80004f96:	0017871b          	addiw	a4,a5,1
    80004f9a:	20e4ae23          	sw	a4,540(s1)
    80004f9e:	1ff7f793          	andi	a5,a5,511
    80004fa2:	97a6                	add	a5,a5,s1
    80004fa4:	faf44703          	lbu	a4,-81(s0)
    80004fa8:	00e78c23          	sb	a4,24(a5)
      i++;
    80004fac:	2905                	addiw	s2,s2,1
    80004fae:	b755                	j	80004f52 <pipewrite+0x80>
  int i = 0;
    80004fb0:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004fb2:	21848513          	addi	a0,s1,536
    80004fb6:	ffffd097          	auipc	ra,0xffffd
    80004fba:	4da080e7          	jalr	1242(ra) # 80002490 <wakeup>
  release(&pi->lock);
    80004fbe:	8526                	mv	a0,s1
    80004fc0:	ffffc097          	auipc	ra,0xffffc
    80004fc4:	d10080e7          	jalr	-752(ra) # 80000cd0 <release>
  return i;
    80004fc8:	bfa9                	j	80004f22 <pipewrite+0x50>

0000000080004fca <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004fca:	715d                	addi	sp,sp,-80
    80004fcc:	e486                	sd	ra,72(sp)
    80004fce:	e0a2                	sd	s0,64(sp)
    80004fd0:	fc26                	sd	s1,56(sp)
    80004fd2:	f84a                	sd	s2,48(sp)
    80004fd4:	f44e                	sd	s3,40(sp)
    80004fd6:	f052                	sd	s4,32(sp)
    80004fd8:	ec56                	sd	s5,24(sp)
    80004fda:	e85a                	sd	s6,16(sp)
    80004fdc:	0880                	addi	s0,sp,80
    80004fde:	84aa                	mv	s1,a0
    80004fe0:	892e                	mv	s2,a1
    80004fe2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004fe4:	ffffd097          	auipc	ra,0xffffd
    80004fe8:	c82080e7          	jalr	-894(ra) # 80001c66 <myproc>
    80004fec:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004fee:	8526                	mv	a0,s1
    80004ff0:	ffffc097          	auipc	ra,0xffffc
    80004ff4:	c2c080e7          	jalr	-980(ra) # 80000c1c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ff8:	2184a703          	lw	a4,536(s1)
    80004ffc:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005000:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005004:	02f71763          	bne	a4,a5,80005032 <piperead+0x68>
    80005008:	2244a783          	lw	a5,548(s1)
    8000500c:	c39d                	beqz	a5,80005032 <piperead+0x68>
    if(killed(pr)){
    8000500e:	8552                	mv	a0,s4
    80005010:	ffffd097          	auipc	ra,0xffffd
    80005014:	6c4080e7          	jalr	1732(ra) # 800026d4 <killed>
    80005018:	e949                	bnez	a0,800050aa <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000501a:	85a6                	mv	a1,s1
    8000501c:	854e                	mv	a0,s3
    8000501e:	ffffd097          	auipc	ra,0xffffd
    80005022:	40e080e7          	jalr	1038(ra) # 8000242c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005026:	2184a703          	lw	a4,536(s1)
    8000502a:	21c4a783          	lw	a5,540(s1)
    8000502e:	fcf70de3          	beq	a4,a5,80005008 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005032:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005034:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005036:	05505463          	blez	s5,8000507e <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000503a:	2184a783          	lw	a5,536(s1)
    8000503e:	21c4a703          	lw	a4,540(s1)
    80005042:	02f70e63          	beq	a4,a5,8000507e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005046:	0017871b          	addiw	a4,a5,1
    8000504a:	20e4ac23          	sw	a4,536(s1)
    8000504e:	1ff7f793          	andi	a5,a5,511
    80005052:	97a6                	add	a5,a5,s1
    80005054:	0187c783          	lbu	a5,24(a5)
    80005058:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000505c:	4685                	li	a3,1
    8000505e:	fbf40613          	addi	a2,s0,-65
    80005062:	85ca                	mv	a1,s2
    80005064:	058a3503          	ld	a0,88(s4)
    80005068:	ffffc097          	auipc	ra,0xffffc
    8000506c:	64a080e7          	jalr	1610(ra) # 800016b2 <copyout>
    80005070:	01650763          	beq	a0,s6,8000507e <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005074:	2985                	addiw	s3,s3,1
    80005076:	0905                	addi	s2,s2,1
    80005078:	fd3a91e3          	bne	s5,s3,8000503a <piperead+0x70>
    8000507c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000507e:	21c48513          	addi	a0,s1,540
    80005082:	ffffd097          	auipc	ra,0xffffd
    80005086:	40e080e7          	jalr	1038(ra) # 80002490 <wakeup>
  release(&pi->lock);
    8000508a:	8526                	mv	a0,s1
    8000508c:	ffffc097          	auipc	ra,0xffffc
    80005090:	c44080e7          	jalr	-956(ra) # 80000cd0 <release>
  return i;
}
    80005094:	854e                	mv	a0,s3
    80005096:	60a6                	ld	ra,72(sp)
    80005098:	6406                	ld	s0,64(sp)
    8000509a:	74e2                	ld	s1,56(sp)
    8000509c:	7942                	ld	s2,48(sp)
    8000509e:	79a2                	ld	s3,40(sp)
    800050a0:	7a02                	ld	s4,32(sp)
    800050a2:	6ae2                	ld	s5,24(sp)
    800050a4:	6b42                	ld	s6,16(sp)
    800050a6:	6161                	addi	sp,sp,80
    800050a8:	8082                	ret
      release(&pi->lock);
    800050aa:	8526                	mv	a0,s1
    800050ac:	ffffc097          	auipc	ra,0xffffc
    800050b0:	c24080e7          	jalr	-988(ra) # 80000cd0 <release>
      return -1;
    800050b4:	59fd                	li	s3,-1
    800050b6:	bff9                	j	80005094 <piperead+0xca>

00000000800050b8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800050b8:	1141                	addi	sp,sp,-16
    800050ba:	e422                	sd	s0,8(sp)
    800050bc:	0800                	addi	s0,sp,16
    800050be:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800050c0:	8905                	andi	a0,a0,1
    800050c2:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800050c4:	8b89                	andi	a5,a5,2
    800050c6:	c399                	beqz	a5,800050cc <flags2perm+0x14>
      perm |= PTE_W;
    800050c8:	00456513          	ori	a0,a0,4
    return perm;
}
    800050cc:	6422                	ld	s0,8(sp)
    800050ce:	0141                	addi	sp,sp,16
    800050d0:	8082                	ret

00000000800050d2 <exec>:

int
exec(char *path, char **argv)
{
    800050d2:	de010113          	addi	sp,sp,-544
    800050d6:	20113c23          	sd	ra,536(sp)
    800050da:	20813823          	sd	s0,528(sp)
    800050de:	20913423          	sd	s1,520(sp)
    800050e2:	21213023          	sd	s2,512(sp)
    800050e6:	ffce                	sd	s3,504(sp)
    800050e8:	fbd2                	sd	s4,496(sp)
    800050ea:	f7d6                	sd	s5,488(sp)
    800050ec:	f3da                	sd	s6,480(sp)
    800050ee:	efde                	sd	s7,472(sp)
    800050f0:	ebe2                	sd	s8,464(sp)
    800050f2:	e7e6                	sd	s9,456(sp)
    800050f4:	e3ea                	sd	s10,448(sp)
    800050f6:	ff6e                	sd	s11,440(sp)
    800050f8:	1400                	addi	s0,sp,544
    800050fa:	892a                	mv	s2,a0
    800050fc:	dea43423          	sd	a0,-536(s0)
    80005100:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	b62080e7          	jalr	-1182(ra) # 80001c66 <myproc>
    8000510c:	84aa                	mv	s1,a0

  begin_op();
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	482080e7          	jalr	1154(ra) # 80004590 <begin_op>

  if((ip = namei(path)) == 0){
    80005116:	854a                	mv	a0,s2
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	258080e7          	jalr	600(ra) # 80004370 <namei>
    80005120:	c93d                	beqz	a0,80005196 <exec+0xc4>
    80005122:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005124:	fffff097          	auipc	ra,0xfffff
    80005128:	aa0080e7          	jalr	-1376(ra) # 80003bc4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000512c:	04000713          	li	a4,64
    80005130:	4681                	li	a3,0
    80005132:	e5040613          	addi	a2,s0,-432
    80005136:	4581                	li	a1,0
    80005138:	8556                	mv	a0,s5
    8000513a:	fffff097          	auipc	ra,0xfffff
    8000513e:	d3e080e7          	jalr	-706(ra) # 80003e78 <readi>
    80005142:	04000793          	li	a5,64
    80005146:	00f51a63          	bne	a0,a5,8000515a <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000514a:	e5042703          	lw	a4,-432(s0)
    8000514e:	464c47b7          	lui	a5,0x464c4
    80005152:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005156:	04f70663          	beq	a4,a5,800051a2 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000515a:	8556                	mv	a0,s5
    8000515c:	fffff097          	auipc	ra,0xfffff
    80005160:	cca080e7          	jalr	-822(ra) # 80003e26 <iunlockput>
    end_op();
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	4aa080e7          	jalr	1194(ra) # 8000460e <end_op>
  }
  return -1;
    8000516c:	557d                	li	a0,-1
}
    8000516e:	21813083          	ld	ra,536(sp)
    80005172:	21013403          	ld	s0,528(sp)
    80005176:	20813483          	ld	s1,520(sp)
    8000517a:	20013903          	ld	s2,512(sp)
    8000517e:	79fe                	ld	s3,504(sp)
    80005180:	7a5e                	ld	s4,496(sp)
    80005182:	7abe                	ld	s5,488(sp)
    80005184:	7b1e                	ld	s6,480(sp)
    80005186:	6bfe                	ld	s7,472(sp)
    80005188:	6c5e                	ld	s8,464(sp)
    8000518a:	6cbe                	ld	s9,456(sp)
    8000518c:	6d1e                	ld	s10,448(sp)
    8000518e:	7dfa                	ld	s11,440(sp)
    80005190:	22010113          	addi	sp,sp,544
    80005194:	8082                	ret
    end_op();
    80005196:	fffff097          	auipc	ra,0xfffff
    8000519a:	478080e7          	jalr	1144(ra) # 8000460e <end_op>
    return -1;
    8000519e:	557d                	li	a0,-1
    800051a0:	b7f9                	j	8000516e <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800051a2:	8526                	mv	a0,s1
    800051a4:	ffffd097          	auipc	ra,0xffffd
    800051a8:	b86080e7          	jalr	-1146(ra) # 80001d2a <proc_pagetable>
    800051ac:	8b2a                	mv	s6,a0
    800051ae:	d555                	beqz	a0,8000515a <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051b0:	e7042783          	lw	a5,-400(s0)
    800051b4:	e8845703          	lhu	a4,-376(s0)
    800051b8:	c735                	beqz	a4,80005224 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800051ba:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051bc:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800051c0:	6a05                	lui	s4,0x1
    800051c2:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800051c6:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800051ca:	6d85                	lui	s11,0x1
    800051cc:	7d7d                	lui	s10,0xfffff
    800051ce:	ac3d                	j	8000540c <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800051d0:	00003517          	auipc	a0,0x3
    800051d4:	5c050513          	addi	a0,a0,1472 # 80008790 <syscalls+0x298>
    800051d8:	ffffb097          	auipc	ra,0xffffb
    800051dc:	3ae080e7          	jalr	942(ra) # 80000586 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800051e0:	874a                	mv	a4,s2
    800051e2:	009c86bb          	addw	a3,s9,s1
    800051e6:	4581                	li	a1,0
    800051e8:	8556                	mv	a0,s5
    800051ea:	fffff097          	auipc	ra,0xfffff
    800051ee:	c8e080e7          	jalr	-882(ra) # 80003e78 <readi>
    800051f2:	2501                	sext.w	a0,a0
    800051f4:	1aa91963          	bne	s2,a0,800053a6 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800051f8:	009d84bb          	addw	s1,s11,s1
    800051fc:	013d09bb          	addw	s3,s10,s3
    80005200:	1f74f663          	bgeu	s1,s7,800053ec <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80005204:	02049593          	slli	a1,s1,0x20
    80005208:	9181                	srli	a1,a1,0x20
    8000520a:	95e2                	add	a1,a1,s8
    8000520c:	855a                	mv	a0,s6
    8000520e:	ffffc097          	auipc	ra,0xffffc
    80005212:	e94080e7          	jalr	-364(ra) # 800010a2 <walkaddr>
    80005216:	862a                	mv	a2,a0
    if(pa == 0)
    80005218:	dd45                	beqz	a0,800051d0 <exec+0xfe>
      n = PGSIZE;
    8000521a:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000521c:	fd49f2e3          	bgeu	s3,s4,800051e0 <exec+0x10e>
      n = sz - i;
    80005220:	894e                	mv	s2,s3
    80005222:	bf7d                	j	800051e0 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005224:	4901                	li	s2,0
  iunlockput(ip);
    80005226:	8556                	mv	a0,s5
    80005228:	fffff097          	auipc	ra,0xfffff
    8000522c:	bfe080e7          	jalr	-1026(ra) # 80003e26 <iunlockput>
  end_op();
    80005230:	fffff097          	auipc	ra,0xfffff
    80005234:	3de080e7          	jalr	990(ra) # 8000460e <end_op>
  p = myproc();
    80005238:	ffffd097          	auipc	ra,0xffffd
    8000523c:	a2e080e7          	jalr	-1490(ra) # 80001c66 <myproc>
    80005240:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005242:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80005246:	6785                	lui	a5,0x1
    80005248:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000524a:	97ca                	add	a5,a5,s2
    8000524c:	777d                	lui	a4,0xfffff
    8000524e:	8ff9                	and	a5,a5,a4
    80005250:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005254:	4691                	li	a3,4
    80005256:	6609                	lui	a2,0x2
    80005258:	963e                	add	a2,a2,a5
    8000525a:	85be                	mv	a1,a5
    8000525c:	855a                	mv	a0,s6
    8000525e:	ffffc097          	auipc	ra,0xffffc
    80005262:	1f8080e7          	jalr	504(ra) # 80001456 <uvmalloc>
    80005266:	8c2a                	mv	s8,a0
  ip = 0;
    80005268:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000526a:	12050e63          	beqz	a0,800053a6 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000526e:	75f9                	lui	a1,0xffffe
    80005270:	95aa                	add	a1,a1,a0
    80005272:	855a                	mv	a0,s6
    80005274:	ffffc097          	auipc	ra,0xffffc
    80005278:	40c080e7          	jalr	1036(ra) # 80001680 <uvmclear>
  stackbase = sp - PGSIZE;
    8000527c:	7afd                	lui	s5,0xfffff
    8000527e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005280:	df043783          	ld	a5,-528(s0)
    80005284:	6388                	ld	a0,0(a5)
    80005286:	c925                	beqz	a0,800052f6 <exec+0x224>
    80005288:	e9040993          	addi	s3,s0,-368
    8000528c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80005290:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005292:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005294:	ffffc097          	auipc	ra,0xffffc
    80005298:	c00080e7          	jalr	-1024(ra) # 80000e94 <strlen>
    8000529c:	0015079b          	addiw	a5,a0,1
    800052a0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800052a4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800052a8:	13596663          	bltu	s2,s5,800053d4 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800052ac:	df043d83          	ld	s11,-528(s0)
    800052b0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800052b4:	8552                	mv	a0,s4
    800052b6:	ffffc097          	auipc	ra,0xffffc
    800052ba:	bde080e7          	jalr	-1058(ra) # 80000e94 <strlen>
    800052be:	0015069b          	addiw	a3,a0,1
    800052c2:	8652                	mv	a2,s4
    800052c4:	85ca                	mv	a1,s2
    800052c6:	855a                	mv	a0,s6
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	3ea080e7          	jalr	1002(ra) # 800016b2 <copyout>
    800052d0:	10054663          	bltz	a0,800053dc <exec+0x30a>
    ustack[argc] = sp;
    800052d4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800052d8:	0485                	addi	s1,s1,1
    800052da:	008d8793          	addi	a5,s11,8
    800052de:	def43823          	sd	a5,-528(s0)
    800052e2:	008db503          	ld	a0,8(s11)
    800052e6:	c911                	beqz	a0,800052fa <exec+0x228>
    if(argc >= MAXARG)
    800052e8:	09a1                	addi	s3,s3,8
    800052ea:	fb3c95e3          	bne	s9,s3,80005294 <exec+0x1c2>
  sz = sz1;
    800052ee:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052f2:	4a81                	li	s5,0
    800052f4:	a84d                	j	800053a6 <exec+0x2d4>
  sp = sz;
    800052f6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800052f8:	4481                	li	s1,0
  ustack[argc] = 0;
    800052fa:	00349793          	slli	a5,s1,0x3
    800052fe:	f9078793          	addi	a5,a5,-112
    80005302:	97a2                	add	a5,a5,s0
    80005304:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005308:	00148693          	addi	a3,s1,1
    8000530c:	068e                	slli	a3,a3,0x3
    8000530e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005312:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005316:	01597663          	bgeu	s2,s5,80005322 <exec+0x250>
  sz = sz1;
    8000531a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000531e:	4a81                	li	s5,0
    80005320:	a059                	j	800053a6 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005322:	e9040613          	addi	a2,s0,-368
    80005326:	85ca                	mv	a1,s2
    80005328:	855a                	mv	a0,s6
    8000532a:	ffffc097          	auipc	ra,0xffffc
    8000532e:	388080e7          	jalr	904(ra) # 800016b2 <copyout>
    80005332:	0a054963          	bltz	a0,800053e4 <exec+0x312>
  p->trapframe->a1 = sp;
    80005336:	060bb783          	ld	a5,96(s7)
    8000533a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000533e:	de843783          	ld	a5,-536(s0)
    80005342:	0007c703          	lbu	a4,0(a5)
    80005346:	cf11                	beqz	a4,80005362 <exec+0x290>
    80005348:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000534a:	02f00693          	li	a3,47
    8000534e:	a039                	j	8000535c <exec+0x28a>
      last = s+1;
    80005350:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005354:	0785                	addi	a5,a5,1
    80005356:	fff7c703          	lbu	a4,-1(a5)
    8000535a:	c701                	beqz	a4,80005362 <exec+0x290>
    if(*s == '/')
    8000535c:	fed71ce3          	bne	a4,a3,80005354 <exec+0x282>
    80005360:	bfc5                	j	80005350 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80005362:	4641                	li	a2,16
    80005364:	de843583          	ld	a1,-536(s0)
    80005368:	160b8513          	addi	a0,s7,352
    8000536c:	ffffc097          	auipc	ra,0xffffc
    80005370:	af6080e7          	jalr	-1290(ra) # 80000e62 <safestrcpy>
  oldpagetable = p->pagetable;
    80005374:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    80005378:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    8000537c:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005380:	060bb783          	ld	a5,96(s7)
    80005384:	e6843703          	ld	a4,-408(s0)
    80005388:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000538a:	060bb783          	ld	a5,96(s7)
    8000538e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005392:	85ea                	mv	a1,s10
    80005394:	ffffd097          	auipc	ra,0xffffd
    80005398:	a32080e7          	jalr	-1486(ra) # 80001dc6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000539c:	0004851b          	sext.w	a0,s1
    800053a0:	b3f9                	j	8000516e <exec+0x9c>
    800053a2:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800053a6:	df843583          	ld	a1,-520(s0)
    800053aa:	855a                	mv	a0,s6
    800053ac:	ffffd097          	auipc	ra,0xffffd
    800053b0:	a1a080e7          	jalr	-1510(ra) # 80001dc6 <proc_freepagetable>
  if(ip){
    800053b4:	da0a93e3          	bnez	s5,8000515a <exec+0x88>
  return -1;
    800053b8:	557d                	li	a0,-1
    800053ba:	bb55                	j	8000516e <exec+0x9c>
    800053bc:	df243c23          	sd	s2,-520(s0)
    800053c0:	b7dd                	j	800053a6 <exec+0x2d4>
    800053c2:	df243c23          	sd	s2,-520(s0)
    800053c6:	b7c5                	j	800053a6 <exec+0x2d4>
    800053c8:	df243c23          	sd	s2,-520(s0)
    800053cc:	bfe9                	j	800053a6 <exec+0x2d4>
    800053ce:	df243c23          	sd	s2,-520(s0)
    800053d2:	bfd1                	j	800053a6 <exec+0x2d4>
  sz = sz1;
    800053d4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053d8:	4a81                	li	s5,0
    800053da:	b7f1                	j	800053a6 <exec+0x2d4>
  sz = sz1;
    800053dc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053e0:	4a81                	li	s5,0
    800053e2:	b7d1                	j	800053a6 <exec+0x2d4>
  sz = sz1;
    800053e4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053e8:	4a81                	li	s5,0
    800053ea:	bf75                	j	800053a6 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800053ec:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053f0:	e0843783          	ld	a5,-504(s0)
    800053f4:	0017869b          	addiw	a3,a5,1
    800053f8:	e0d43423          	sd	a3,-504(s0)
    800053fc:	e0043783          	ld	a5,-512(s0)
    80005400:	0387879b          	addiw	a5,a5,56
    80005404:	e8845703          	lhu	a4,-376(s0)
    80005408:	e0e6dfe3          	bge	a3,a4,80005226 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000540c:	2781                	sext.w	a5,a5
    8000540e:	e0f43023          	sd	a5,-512(s0)
    80005412:	03800713          	li	a4,56
    80005416:	86be                	mv	a3,a5
    80005418:	e1840613          	addi	a2,s0,-488
    8000541c:	4581                	li	a1,0
    8000541e:	8556                	mv	a0,s5
    80005420:	fffff097          	auipc	ra,0xfffff
    80005424:	a58080e7          	jalr	-1448(ra) # 80003e78 <readi>
    80005428:	03800793          	li	a5,56
    8000542c:	f6f51be3          	bne	a0,a5,800053a2 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80005430:	e1842783          	lw	a5,-488(s0)
    80005434:	4705                	li	a4,1
    80005436:	fae79de3          	bne	a5,a4,800053f0 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    8000543a:	e4043483          	ld	s1,-448(s0)
    8000543e:	e3843783          	ld	a5,-456(s0)
    80005442:	f6f4ede3          	bltu	s1,a5,800053bc <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005446:	e2843783          	ld	a5,-472(s0)
    8000544a:	94be                	add	s1,s1,a5
    8000544c:	f6f4ebe3          	bltu	s1,a5,800053c2 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80005450:	de043703          	ld	a4,-544(s0)
    80005454:	8ff9                	and	a5,a5,a4
    80005456:	fbad                	bnez	a5,800053c8 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005458:	e1c42503          	lw	a0,-484(s0)
    8000545c:	00000097          	auipc	ra,0x0
    80005460:	c5c080e7          	jalr	-932(ra) # 800050b8 <flags2perm>
    80005464:	86aa                	mv	a3,a0
    80005466:	8626                	mv	a2,s1
    80005468:	85ca                	mv	a1,s2
    8000546a:	855a                	mv	a0,s6
    8000546c:	ffffc097          	auipc	ra,0xffffc
    80005470:	fea080e7          	jalr	-22(ra) # 80001456 <uvmalloc>
    80005474:	dea43c23          	sd	a0,-520(s0)
    80005478:	d939                	beqz	a0,800053ce <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000547a:	e2843c03          	ld	s8,-472(s0)
    8000547e:	e2042c83          	lw	s9,-480(s0)
    80005482:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005486:	f60b83e3          	beqz	s7,800053ec <exec+0x31a>
    8000548a:	89de                	mv	s3,s7
    8000548c:	4481                	li	s1,0
    8000548e:	bb9d                	j	80005204 <exec+0x132>

0000000080005490 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005490:	7179                	addi	sp,sp,-48
    80005492:	f406                	sd	ra,40(sp)
    80005494:	f022                	sd	s0,32(sp)
    80005496:	ec26                	sd	s1,24(sp)
    80005498:	e84a                	sd	s2,16(sp)
    8000549a:	1800                	addi	s0,sp,48
    8000549c:	892e                	mv	s2,a1
    8000549e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800054a0:	fdc40593          	addi	a1,s0,-36
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	b28080e7          	jalr	-1240(ra) # 80002fcc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800054ac:	fdc42703          	lw	a4,-36(s0)
    800054b0:	47bd                	li	a5,15
    800054b2:	02e7eb63          	bltu	a5,a4,800054e8 <argfd+0x58>
    800054b6:	ffffc097          	auipc	ra,0xffffc
    800054ba:	7b0080e7          	jalr	1968(ra) # 80001c66 <myproc>
    800054be:	fdc42703          	lw	a4,-36(s0)
    800054c2:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdcfaa>
    800054c6:	078e                	slli	a5,a5,0x3
    800054c8:	953e                	add	a0,a0,a5
    800054ca:	651c                	ld	a5,8(a0)
    800054cc:	c385                	beqz	a5,800054ec <argfd+0x5c>
    return -1;
  if(pfd)
    800054ce:	00090463          	beqz	s2,800054d6 <argfd+0x46>
    *pfd = fd;
    800054d2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800054d6:	4501                	li	a0,0
  if(pf)
    800054d8:	c091                	beqz	s1,800054dc <argfd+0x4c>
    *pf = f;
    800054da:	e09c                	sd	a5,0(s1)
}
    800054dc:	70a2                	ld	ra,40(sp)
    800054de:	7402                	ld	s0,32(sp)
    800054e0:	64e2                	ld	s1,24(sp)
    800054e2:	6942                	ld	s2,16(sp)
    800054e4:	6145                	addi	sp,sp,48
    800054e6:	8082                	ret
    return -1;
    800054e8:	557d                	li	a0,-1
    800054ea:	bfcd                	j	800054dc <argfd+0x4c>
    800054ec:	557d                	li	a0,-1
    800054ee:	b7fd                	j	800054dc <argfd+0x4c>

00000000800054f0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800054f0:	1101                	addi	sp,sp,-32
    800054f2:	ec06                	sd	ra,24(sp)
    800054f4:	e822                	sd	s0,16(sp)
    800054f6:	e426                	sd	s1,8(sp)
    800054f8:	1000                	addi	s0,sp,32
    800054fa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800054fc:	ffffc097          	auipc	ra,0xffffc
    80005500:	76a080e7          	jalr	1898(ra) # 80001c66 <myproc>
    80005504:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005506:	0d850793          	addi	a5,a0,216
    8000550a:	4501                	li	a0,0
    8000550c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000550e:	6398                	ld	a4,0(a5)
    80005510:	cb19                	beqz	a4,80005526 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005512:	2505                	addiw	a0,a0,1
    80005514:	07a1                	addi	a5,a5,8
    80005516:	fed51ce3          	bne	a0,a3,8000550e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000551a:	557d                	li	a0,-1
}
    8000551c:	60e2                	ld	ra,24(sp)
    8000551e:	6442                	ld	s0,16(sp)
    80005520:	64a2                	ld	s1,8(sp)
    80005522:	6105                	addi	sp,sp,32
    80005524:	8082                	ret
      p->ofile[fd] = f;
    80005526:	01a50793          	addi	a5,a0,26
    8000552a:	078e                	slli	a5,a5,0x3
    8000552c:	963e                	add	a2,a2,a5
    8000552e:	e604                	sd	s1,8(a2)
      return fd;
    80005530:	b7f5                	j	8000551c <fdalloc+0x2c>

0000000080005532 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005532:	715d                	addi	sp,sp,-80
    80005534:	e486                	sd	ra,72(sp)
    80005536:	e0a2                	sd	s0,64(sp)
    80005538:	fc26                	sd	s1,56(sp)
    8000553a:	f84a                	sd	s2,48(sp)
    8000553c:	f44e                	sd	s3,40(sp)
    8000553e:	f052                	sd	s4,32(sp)
    80005540:	ec56                	sd	s5,24(sp)
    80005542:	e85a                	sd	s6,16(sp)
    80005544:	0880                	addi	s0,sp,80
    80005546:	8b2e                	mv	s6,a1
    80005548:	89b2                	mv	s3,a2
    8000554a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000554c:	fb040593          	addi	a1,s0,-80
    80005550:	fffff097          	auipc	ra,0xfffff
    80005554:	e3e080e7          	jalr	-450(ra) # 8000438e <nameiparent>
    80005558:	84aa                	mv	s1,a0
    8000555a:	14050f63          	beqz	a0,800056b8 <create+0x186>
    return 0;

  ilock(dp);
    8000555e:	ffffe097          	auipc	ra,0xffffe
    80005562:	666080e7          	jalr	1638(ra) # 80003bc4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005566:	4601                	li	a2,0
    80005568:	fb040593          	addi	a1,s0,-80
    8000556c:	8526                	mv	a0,s1
    8000556e:	fffff097          	auipc	ra,0xfffff
    80005572:	b3a080e7          	jalr	-1222(ra) # 800040a8 <dirlookup>
    80005576:	8aaa                	mv	s5,a0
    80005578:	c931                	beqz	a0,800055cc <create+0x9a>
    iunlockput(dp);
    8000557a:	8526                	mv	a0,s1
    8000557c:	fffff097          	auipc	ra,0xfffff
    80005580:	8aa080e7          	jalr	-1878(ra) # 80003e26 <iunlockput>
    ilock(ip);
    80005584:	8556                	mv	a0,s5
    80005586:	ffffe097          	auipc	ra,0xffffe
    8000558a:	63e080e7          	jalr	1598(ra) # 80003bc4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000558e:	000b059b          	sext.w	a1,s6
    80005592:	4789                	li	a5,2
    80005594:	02f59563          	bne	a1,a5,800055be <create+0x8c>
    80005598:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdcfd4>
    8000559c:	37f9                	addiw	a5,a5,-2
    8000559e:	17c2                	slli	a5,a5,0x30
    800055a0:	93c1                	srli	a5,a5,0x30
    800055a2:	4705                	li	a4,1
    800055a4:	00f76d63          	bltu	a4,a5,800055be <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800055a8:	8556                	mv	a0,s5
    800055aa:	60a6                	ld	ra,72(sp)
    800055ac:	6406                	ld	s0,64(sp)
    800055ae:	74e2                	ld	s1,56(sp)
    800055b0:	7942                	ld	s2,48(sp)
    800055b2:	79a2                	ld	s3,40(sp)
    800055b4:	7a02                	ld	s4,32(sp)
    800055b6:	6ae2                	ld	s5,24(sp)
    800055b8:	6b42                	ld	s6,16(sp)
    800055ba:	6161                	addi	sp,sp,80
    800055bc:	8082                	ret
    iunlockput(ip);
    800055be:	8556                	mv	a0,s5
    800055c0:	fffff097          	auipc	ra,0xfffff
    800055c4:	866080e7          	jalr	-1946(ra) # 80003e26 <iunlockput>
    return 0;
    800055c8:	4a81                	li	s5,0
    800055ca:	bff9                	j	800055a8 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800055cc:	85da                	mv	a1,s6
    800055ce:	4088                	lw	a0,0(s1)
    800055d0:	ffffe097          	auipc	ra,0xffffe
    800055d4:	456080e7          	jalr	1110(ra) # 80003a26 <ialloc>
    800055d8:	8a2a                	mv	s4,a0
    800055da:	c539                	beqz	a0,80005628 <create+0xf6>
  ilock(ip);
    800055dc:	ffffe097          	auipc	ra,0xffffe
    800055e0:	5e8080e7          	jalr	1512(ra) # 80003bc4 <ilock>
  ip->major = major;
    800055e4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800055e8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800055ec:	4905                	li	s2,1
    800055ee:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800055f2:	8552                	mv	a0,s4
    800055f4:	ffffe097          	auipc	ra,0xffffe
    800055f8:	504080e7          	jalr	1284(ra) # 80003af8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800055fc:	000b059b          	sext.w	a1,s6
    80005600:	03258b63          	beq	a1,s2,80005636 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005604:	004a2603          	lw	a2,4(s4)
    80005608:	fb040593          	addi	a1,s0,-80
    8000560c:	8526                	mv	a0,s1
    8000560e:	fffff097          	auipc	ra,0xfffff
    80005612:	cb0080e7          	jalr	-848(ra) # 800042be <dirlink>
    80005616:	06054f63          	bltz	a0,80005694 <create+0x162>
  iunlockput(dp);
    8000561a:	8526                	mv	a0,s1
    8000561c:	fffff097          	auipc	ra,0xfffff
    80005620:	80a080e7          	jalr	-2038(ra) # 80003e26 <iunlockput>
  return ip;
    80005624:	8ad2                	mv	s5,s4
    80005626:	b749                	j	800055a8 <create+0x76>
    iunlockput(dp);
    80005628:	8526                	mv	a0,s1
    8000562a:	ffffe097          	auipc	ra,0xffffe
    8000562e:	7fc080e7          	jalr	2044(ra) # 80003e26 <iunlockput>
    return 0;
    80005632:	8ad2                	mv	s5,s4
    80005634:	bf95                	j	800055a8 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005636:	004a2603          	lw	a2,4(s4)
    8000563a:	00003597          	auipc	a1,0x3
    8000563e:	17658593          	addi	a1,a1,374 # 800087b0 <syscalls+0x2b8>
    80005642:	8552                	mv	a0,s4
    80005644:	fffff097          	auipc	ra,0xfffff
    80005648:	c7a080e7          	jalr	-902(ra) # 800042be <dirlink>
    8000564c:	04054463          	bltz	a0,80005694 <create+0x162>
    80005650:	40d0                	lw	a2,4(s1)
    80005652:	00003597          	auipc	a1,0x3
    80005656:	16658593          	addi	a1,a1,358 # 800087b8 <syscalls+0x2c0>
    8000565a:	8552                	mv	a0,s4
    8000565c:	fffff097          	auipc	ra,0xfffff
    80005660:	c62080e7          	jalr	-926(ra) # 800042be <dirlink>
    80005664:	02054863          	bltz	a0,80005694 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005668:	004a2603          	lw	a2,4(s4)
    8000566c:	fb040593          	addi	a1,s0,-80
    80005670:	8526                	mv	a0,s1
    80005672:	fffff097          	auipc	ra,0xfffff
    80005676:	c4c080e7          	jalr	-948(ra) # 800042be <dirlink>
    8000567a:	00054d63          	bltz	a0,80005694 <create+0x162>
    dp->nlink++;  // for ".."
    8000567e:	04a4d783          	lhu	a5,74(s1)
    80005682:	2785                	addiw	a5,a5,1
    80005684:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005688:	8526                	mv	a0,s1
    8000568a:	ffffe097          	auipc	ra,0xffffe
    8000568e:	46e080e7          	jalr	1134(ra) # 80003af8 <iupdate>
    80005692:	b761                	j	8000561a <create+0xe8>
  ip->nlink = 0;
    80005694:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005698:	8552                	mv	a0,s4
    8000569a:	ffffe097          	auipc	ra,0xffffe
    8000569e:	45e080e7          	jalr	1118(ra) # 80003af8 <iupdate>
  iunlockput(ip);
    800056a2:	8552                	mv	a0,s4
    800056a4:	ffffe097          	auipc	ra,0xffffe
    800056a8:	782080e7          	jalr	1922(ra) # 80003e26 <iunlockput>
  iunlockput(dp);
    800056ac:	8526                	mv	a0,s1
    800056ae:	ffffe097          	auipc	ra,0xffffe
    800056b2:	778080e7          	jalr	1912(ra) # 80003e26 <iunlockput>
  return 0;
    800056b6:	bdcd                	j	800055a8 <create+0x76>
    return 0;
    800056b8:	8aaa                	mv	s5,a0
    800056ba:	b5fd                	j	800055a8 <create+0x76>

00000000800056bc <sys_dup>:
{
    800056bc:	7179                	addi	sp,sp,-48
    800056be:	f406                	sd	ra,40(sp)
    800056c0:	f022                	sd	s0,32(sp)
    800056c2:	ec26                	sd	s1,24(sp)
    800056c4:	e84a                	sd	s2,16(sp)
    800056c6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800056c8:	fd840613          	addi	a2,s0,-40
    800056cc:	4581                	li	a1,0
    800056ce:	4501                	li	a0,0
    800056d0:	00000097          	auipc	ra,0x0
    800056d4:	dc0080e7          	jalr	-576(ra) # 80005490 <argfd>
    return -1;
    800056d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800056da:	02054363          	bltz	a0,80005700 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800056de:	fd843903          	ld	s2,-40(s0)
    800056e2:	854a                	mv	a0,s2
    800056e4:	00000097          	auipc	ra,0x0
    800056e8:	e0c080e7          	jalr	-500(ra) # 800054f0 <fdalloc>
    800056ec:	84aa                	mv	s1,a0
    return -1;
    800056ee:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800056f0:	00054863          	bltz	a0,80005700 <sys_dup+0x44>
  filedup(f);
    800056f4:	854a                	mv	a0,s2
    800056f6:	fffff097          	auipc	ra,0xfffff
    800056fa:	310080e7          	jalr	784(ra) # 80004a06 <filedup>
  return fd;
    800056fe:	87a6                	mv	a5,s1
}
    80005700:	853e                	mv	a0,a5
    80005702:	70a2                	ld	ra,40(sp)
    80005704:	7402                	ld	s0,32(sp)
    80005706:	64e2                	ld	s1,24(sp)
    80005708:	6942                	ld	s2,16(sp)
    8000570a:	6145                	addi	sp,sp,48
    8000570c:	8082                	ret

000000008000570e <sys_read>:
{
    8000570e:	7179                	addi	sp,sp,-48
    80005710:	f406                	sd	ra,40(sp)
    80005712:	f022                	sd	s0,32(sp)
    80005714:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005716:	fd840593          	addi	a1,s0,-40
    8000571a:	4505                	li	a0,1
    8000571c:	ffffe097          	auipc	ra,0xffffe
    80005720:	8d0080e7          	jalr	-1840(ra) # 80002fec <argaddr>
  argint(2, &n);
    80005724:	fe440593          	addi	a1,s0,-28
    80005728:	4509                	li	a0,2
    8000572a:	ffffe097          	auipc	ra,0xffffe
    8000572e:	8a2080e7          	jalr	-1886(ra) # 80002fcc <argint>
  if(argfd(0, 0, &f) < 0)
    80005732:	fe840613          	addi	a2,s0,-24
    80005736:	4581                	li	a1,0
    80005738:	4501                	li	a0,0
    8000573a:	00000097          	auipc	ra,0x0
    8000573e:	d56080e7          	jalr	-682(ra) # 80005490 <argfd>
    80005742:	87aa                	mv	a5,a0
    return -1;
    80005744:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005746:	0007cc63          	bltz	a5,8000575e <sys_read+0x50>
  return fileread(f, p, n);
    8000574a:	fe442603          	lw	a2,-28(s0)
    8000574e:	fd843583          	ld	a1,-40(s0)
    80005752:	fe843503          	ld	a0,-24(s0)
    80005756:	fffff097          	auipc	ra,0xfffff
    8000575a:	43c080e7          	jalr	1084(ra) # 80004b92 <fileread>
}
    8000575e:	70a2                	ld	ra,40(sp)
    80005760:	7402                	ld	s0,32(sp)
    80005762:	6145                	addi	sp,sp,48
    80005764:	8082                	ret

0000000080005766 <sys_write>:
{
    80005766:	7179                	addi	sp,sp,-48
    80005768:	f406                	sd	ra,40(sp)
    8000576a:	f022                	sd	s0,32(sp)
    8000576c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000576e:	fd840593          	addi	a1,s0,-40
    80005772:	4505                	li	a0,1
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	878080e7          	jalr	-1928(ra) # 80002fec <argaddr>
  argint(2, &n);
    8000577c:	fe440593          	addi	a1,s0,-28
    80005780:	4509                	li	a0,2
    80005782:	ffffe097          	auipc	ra,0xffffe
    80005786:	84a080e7          	jalr	-1974(ra) # 80002fcc <argint>
  if(argfd(0, 0, &f) < 0)
    8000578a:	fe840613          	addi	a2,s0,-24
    8000578e:	4581                	li	a1,0
    80005790:	4501                	li	a0,0
    80005792:	00000097          	auipc	ra,0x0
    80005796:	cfe080e7          	jalr	-770(ra) # 80005490 <argfd>
    8000579a:	87aa                	mv	a5,a0
    return -1;
    8000579c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000579e:	0007cc63          	bltz	a5,800057b6 <sys_write+0x50>
  return filewrite(f, p, n);
    800057a2:	fe442603          	lw	a2,-28(s0)
    800057a6:	fd843583          	ld	a1,-40(s0)
    800057aa:	fe843503          	ld	a0,-24(s0)
    800057ae:	fffff097          	auipc	ra,0xfffff
    800057b2:	4a6080e7          	jalr	1190(ra) # 80004c54 <filewrite>
}
    800057b6:	70a2                	ld	ra,40(sp)
    800057b8:	7402                	ld	s0,32(sp)
    800057ba:	6145                	addi	sp,sp,48
    800057bc:	8082                	ret

00000000800057be <sys_close>:
{
    800057be:	1101                	addi	sp,sp,-32
    800057c0:	ec06                	sd	ra,24(sp)
    800057c2:	e822                	sd	s0,16(sp)
    800057c4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800057c6:	fe040613          	addi	a2,s0,-32
    800057ca:	fec40593          	addi	a1,s0,-20
    800057ce:	4501                	li	a0,0
    800057d0:	00000097          	auipc	ra,0x0
    800057d4:	cc0080e7          	jalr	-832(ra) # 80005490 <argfd>
    return -1;
    800057d8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800057da:	02054463          	bltz	a0,80005802 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800057de:	ffffc097          	auipc	ra,0xffffc
    800057e2:	488080e7          	jalr	1160(ra) # 80001c66 <myproc>
    800057e6:	fec42783          	lw	a5,-20(s0)
    800057ea:	07e9                	addi	a5,a5,26
    800057ec:	078e                	slli	a5,a5,0x3
    800057ee:	953e                	add	a0,a0,a5
    800057f0:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800057f4:	fe043503          	ld	a0,-32(s0)
    800057f8:	fffff097          	auipc	ra,0xfffff
    800057fc:	260080e7          	jalr	608(ra) # 80004a58 <fileclose>
  return 0;
    80005800:	4781                	li	a5,0
}
    80005802:	853e                	mv	a0,a5
    80005804:	60e2                	ld	ra,24(sp)
    80005806:	6442                	ld	s0,16(sp)
    80005808:	6105                	addi	sp,sp,32
    8000580a:	8082                	ret

000000008000580c <sys_fstat>:
{
    8000580c:	1101                	addi	sp,sp,-32
    8000580e:	ec06                	sd	ra,24(sp)
    80005810:	e822                	sd	s0,16(sp)
    80005812:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005814:	fe040593          	addi	a1,s0,-32
    80005818:	4505                	li	a0,1
    8000581a:	ffffd097          	auipc	ra,0xffffd
    8000581e:	7d2080e7          	jalr	2002(ra) # 80002fec <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005822:	fe840613          	addi	a2,s0,-24
    80005826:	4581                	li	a1,0
    80005828:	4501                	li	a0,0
    8000582a:	00000097          	auipc	ra,0x0
    8000582e:	c66080e7          	jalr	-922(ra) # 80005490 <argfd>
    80005832:	87aa                	mv	a5,a0
    return -1;
    80005834:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005836:	0007ca63          	bltz	a5,8000584a <sys_fstat+0x3e>
  return filestat(f, st);
    8000583a:	fe043583          	ld	a1,-32(s0)
    8000583e:	fe843503          	ld	a0,-24(s0)
    80005842:	fffff097          	auipc	ra,0xfffff
    80005846:	2de080e7          	jalr	734(ra) # 80004b20 <filestat>
}
    8000584a:	60e2                	ld	ra,24(sp)
    8000584c:	6442                	ld	s0,16(sp)
    8000584e:	6105                	addi	sp,sp,32
    80005850:	8082                	ret

0000000080005852 <sys_link>:
{
    80005852:	7169                	addi	sp,sp,-304
    80005854:	f606                	sd	ra,296(sp)
    80005856:	f222                	sd	s0,288(sp)
    80005858:	ee26                	sd	s1,280(sp)
    8000585a:	ea4a                	sd	s2,272(sp)
    8000585c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000585e:	08000613          	li	a2,128
    80005862:	ed040593          	addi	a1,s0,-304
    80005866:	4501                	li	a0,0
    80005868:	ffffd097          	auipc	ra,0xffffd
    8000586c:	7a4080e7          	jalr	1956(ra) # 8000300c <argstr>
    return -1;
    80005870:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005872:	10054e63          	bltz	a0,8000598e <sys_link+0x13c>
    80005876:	08000613          	li	a2,128
    8000587a:	f5040593          	addi	a1,s0,-176
    8000587e:	4505                	li	a0,1
    80005880:	ffffd097          	auipc	ra,0xffffd
    80005884:	78c080e7          	jalr	1932(ra) # 8000300c <argstr>
    return -1;
    80005888:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000588a:	10054263          	bltz	a0,8000598e <sys_link+0x13c>
  begin_op();
    8000588e:	fffff097          	auipc	ra,0xfffff
    80005892:	d02080e7          	jalr	-766(ra) # 80004590 <begin_op>
  if((ip = namei(old)) == 0){
    80005896:	ed040513          	addi	a0,s0,-304
    8000589a:	fffff097          	auipc	ra,0xfffff
    8000589e:	ad6080e7          	jalr	-1322(ra) # 80004370 <namei>
    800058a2:	84aa                	mv	s1,a0
    800058a4:	c551                	beqz	a0,80005930 <sys_link+0xde>
  ilock(ip);
    800058a6:	ffffe097          	auipc	ra,0xffffe
    800058aa:	31e080e7          	jalr	798(ra) # 80003bc4 <ilock>
  if(ip->type == T_DIR){
    800058ae:	04449703          	lh	a4,68(s1)
    800058b2:	4785                	li	a5,1
    800058b4:	08f70463          	beq	a4,a5,8000593c <sys_link+0xea>
  ip->nlink++;
    800058b8:	04a4d783          	lhu	a5,74(s1)
    800058bc:	2785                	addiw	a5,a5,1
    800058be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800058c2:	8526                	mv	a0,s1
    800058c4:	ffffe097          	auipc	ra,0xffffe
    800058c8:	234080e7          	jalr	564(ra) # 80003af8 <iupdate>
  iunlock(ip);
    800058cc:	8526                	mv	a0,s1
    800058ce:	ffffe097          	auipc	ra,0xffffe
    800058d2:	3b8080e7          	jalr	952(ra) # 80003c86 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800058d6:	fd040593          	addi	a1,s0,-48
    800058da:	f5040513          	addi	a0,s0,-176
    800058de:	fffff097          	auipc	ra,0xfffff
    800058e2:	ab0080e7          	jalr	-1360(ra) # 8000438e <nameiparent>
    800058e6:	892a                	mv	s2,a0
    800058e8:	c935                	beqz	a0,8000595c <sys_link+0x10a>
  ilock(dp);
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	2da080e7          	jalr	730(ra) # 80003bc4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800058f2:	00092703          	lw	a4,0(s2)
    800058f6:	409c                	lw	a5,0(s1)
    800058f8:	04f71d63          	bne	a4,a5,80005952 <sys_link+0x100>
    800058fc:	40d0                	lw	a2,4(s1)
    800058fe:	fd040593          	addi	a1,s0,-48
    80005902:	854a                	mv	a0,s2
    80005904:	fffff097          	auipc	ra,0xfffff
    80005908:	9ba080e7          	jalr	-1606(ra) # 800042be <dirlink>
    8000590c:	04054363          	bltz	a0,80005952 <sys_link+0x100>
  iunlockput(dp);
    80005910:	854a                	mv	a0,s2
    80005912:	ffffe097          	auipc	ra,0xffffe
    80005916:	514080e7          	jalr	1300(ra) # 80003e26 <iunlockput>
  iput(ip);
    8000591a:	8526                	mv	a0,s1
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	462080e7          	jalr	1122(ra) # 80003d7e <iput>
  end_op();
    80005924:	fffff097          	auipc	ra,0xfffff
    80005928:	cea080e7          	jalr	-790(ra) # 8000460e <end_op>
  return 0;
    8000592c:	4781                	li	a5,0
    8000592e:	a085                	j	8000598e <sys_link+0x13c>
    end_op();
    80005930:	fffff097          	auipc	ra,0xfffff
    80005934:	cde080e7          	jalr	-802(ra) # 8000460e <end_op>
    return -1;
    80005938:	57fd                	li	a5,-1
    8000593a:	a891                	j	8000598e <sys_link+0x13c>
    iunlockput(ip);
    8000593c:	8526                	mv	a0,s1
    8000593e:	ffffe097          	auipc	ra,0xffffe
    80005942:	4e8080e7          	jalr	1256(ra) # 80003e26 <iunlockput>
    end_op();
    80005946:	fffff097          	auipc	ra,0xfffff
    8000594a:	cc8080e7          	jalr	-824(ra) # 8000460e <end_op>
    return -1;
    8000594e:	57fd                	li	a5,-1
    80005950:	a83d                	j	8000598e <sys_link+0x13c>
    iunlockput(dp);
    80005952:	854a                	mv	a0,s2
    80005954:	ffffe097          	auipc	ra,0xffffe
    80005958:	4d2080e7          	jalr	1234(ra) # 80003e26 <iunlockput>
  ilock(ip);
    8000595c:	8526                	mv	a0,s1
    8000595e:	ffffe097          	auipc	ra,0xffffe
    80005962:	266080e7          	jalr	614(ra) # 80003bc4 <ilock>
  ip->nlink--;
    80005966:	04a4d783          	lhu	a5,74(s1)
    8000596a:	37fd                	addiw	a5,a5,-1
    8000596c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005970:	8526                	mv	a0,s1
    80005972:	ffffe097          	auipc	ra,0xffffe
    80005976:	186080e7          	jalr	390(ra) # 80003af8 <iupdate>
  iunlockput(ip);
    8000597a:	8526                	mv	a0,s1
    8000597c:	ffffe097          	auipc	ra,0xffffe
    80005980:	4aa080e7          	jalr	1194(ra) # 80003e26 <iunlockput>
  end_op();
    80005984:	fffff097          	auipc	ra,0xfffff
    80005988:	c8a080e7          	jalr	-886(ra) # 8000460e <end_op>
  return -1;
    8000598c:	57fd                	li	a5,-1
}
    8000598e:	853e                	mv	a0,a5
    80005990:	70b2                	ld	ra,296(sp)
    80005992:	7412                	ld	s0,288(sp)
    80005994:	64f2                	ld	s1,280(sp)
    80005996:	6952                	ld	s2,272(sp)
    80005998:	6155                	addi	sp,sp,304
    8000599a:	8082                	ret

000000008000599c <sys_unlink>:
{
    8000599c:	7151                	addi	sp,sp,-240
    8000599e:	f586                	sd	ra,232(sp)
    800059a0:	f1a2                	sd	s0,224(sp)
    800059a2:	eda6                	sd	s1,216(sp)
    800059a4:	e9ca                	sd	s2,208(sp)
    800059a6:	e5ce                	sd	s3,200(sp)
    800059a8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800059aa:	08000613          	li	a2,128
    800059ae:	f3040593          	addi	a1,s0,-208
    800059b2:	4501                	li	a0,0
    800059b4:	ffffd097          	auipc	ra,0xffffd
    800059b8:	658080e7          	jalr	1624(ra) # 8000300c <argstr>
    800059bc:	18054163          	bltz	a0,80005b3e <sys_unlink+0x1a2>
  begin_op();
    800059c0:	fffff097          	auipc	ra,0xfffff
    800059c4:	bd0080e7          	jalr	-1072(ra) # 80004590 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800059c8:	fb040593          	addi	a1,s0,-80
    800059cc:	f3040513          	addi	a0,s0,-208
    800059d0:	fffff097          	auipc	ra,0xfffff
    800059d4:	9be080e7          	jalr	-1602(ra) # 8000438e <nameiparent>
    800059d8:	84aa                	mv	s1,a0
    800059da:	c979                	beqz	a0,80005ab0 <sys_unlink+0x114>
  ilock(dp);
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	1e8080e7          	jalr	488(ra) # 80003bc4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800059e4:	00003597          	auipc	a1,0x3
    800059e8:	dcc58593          	addi	a1,a1,-564 # 800087b0 <syscalls+0x2b8>
    800059ec:	fb040513          	addi	a0,s0,-80
    800059f0:	ffffe097          	auipc	ra,0xffffe
    800059f4:	69e080e7          	jalr	1694(ra) # 8000408e <namecmp>
    800059f8:	14050a63          	beqz	a0,80005b4c <sys_unlink+0x1b0>
    800059fc:	00003597          	auipc	a1,0x3
    80005a00:	dbc58593          	addi	a1,a1,-580 # 800087b8 <syscalls+0x2c0>
    80005a04:	fb040513          	addi	a0,s0,-80
    80005a08:	ffffe097          	auipc	ra,0xffffe
    80005a0c:	686080e7          	jalr	1670(ra) # 8000408e <namecmp>
    80005a10:	12050e63          	beqz	a0,80005b4c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005a14:	f2c40613          	addi	a2,s0,-212
    80005a18:	fb040593          	addi	a1,s0,-80
    80005a1c:	8526                	mv	a0,s1
    80005a1e:	ffffe097          	auipc	ra,0xffffe
    80005a22:	68a080e7          	jalr	1674(ra) # 800040a8 <dirlookup>
    80005a26:	892a                	mv	s2,a0
    80005a28:	12050263          	beqz	a0,80005b4c <sys_unlink+0x1b0>
  ilock(ip);
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	198080e7          	jalr	408(ra) # 80003bc4 <ilock>
  if(ip->nlink < 1)
    80005a34:	04a91783          	lh	a5,74(s2)
    80005a38:	08f05263          	blez	a5,80005abc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005a3c:	04491703          	lh	a4,68(s2)
    80005a40:	4785                	li	a5,1
    80005a42:	08f70563          	beq	a4,a5,80005acc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005a46:	4641                	li	a2,16
    80005a48:	4581                	li	a1,0
    80005a4a:	fc040513          	addi	a0,s0,-64
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	2ca080e7          	jalr	714(ra) # 80000d18 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a56:	4741                	li	a4,16
    80005a58:	f2c42683          	lw	a3,-212(s0)
    80005a5c:	fc040613          	addi	a2,s0,-64
    80005a60:	4581                	li	a1,0
    80005a62:	8526                	mv	a0,s1
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	50c080e7          	jalr	1292(ra) # 80003f70 <writei>
    80005a6c:	47c1                	li	a5,16
    80005a6e:	0af51563          	bne	a0,a5,80005b18 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005a72:	04491703          	lh	a4,68(s2)
    80005a76:	4785                	li	a5,1
    80005a78:	0af70863          	beq	a4,a5,80005b28 <sys_unlink+0x18c>
  iunlockput(dp);
    80005a7c:	8526                	mv	a0,s1
    80005a7e:	ffffe097          	auipc	ra,0xffffe
    80005a82:	3a8080e7          	jalr	936(ra) # 80003e26 <iunlockput>
  ip->nlink--;
    80005a86:	04a95783          	lhu	a5,74(s2)
    80005a8a:	37fd                	addiw	a5,a5,-1
    80005a8c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a90:	854a                	mv	a0,s2
    80005a92:	ffffe097          	auipc	ra,0xffffe
    80005a96:	066080e7          	jalr	102(ra) # 80003af8 <iupdate>
  iunlockput(ip);
    80005a9a:	854a                	mv	a0,s2
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	38a080e7          	jalr	906(ra) # 80003e26 <iunlockput>
  end_op();
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	b6a080e7          	jalr	-1174(ra) # 8000460e <end_op>
  return 0;
    80005aac:	4501                	li	a0,0
    80005aae:	a84d                	j	80005b60 <sys_unlink+0x1c4>
    end_op();
    80005ab0:	fffff097          	auipc	ra,0xfffff
    80005ab4:	b5e080e7          	jalr	-1186(ra) # 8000460e <end_op>
    return -1;
    80005ab8:	557d                	li	a0,-1
    80005aba:	a05d                	j	80005b60 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005abc:	00003517          	auipc	a0,0x3
    80005ac0:	d0450513          	addi	a0,a0,-764 # 800087c0 <syscalls+0x2c8>
    80005ac4:	ffffb097          	auipc	ra,0xffffb
    80005ac8:	ac2080e7          	jalr	-1342(ra) # 80000586 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005acc:	04c92703          	lw	a4,76(s2)
    80005ad0:	02000793          	li	a5,32
    80005ad4:	f6e7f9e3          	bgeu	a5,a4,80005a46 <sys_unlink+0xaa>
    80005ad8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005adc:	4741                	li	a4,16
    80005ade:	86ce                	mv	a3,s3
    80005ae0:	f1840613          	addi	a2,s0,-232
    80005ae4:	4581                	li	a1,0
    80005ae6:	854a                	mv	a0,s2
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	390080e7          	jalr	912(ra) # 80003e78 <readi>
    80005af0:	47c1                	li	a5,16
    80005af2:	00f51b63          	bne	a0,a5,80005b08 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005af6:	f1845783          	lhu	a5,-232(s0)
    80005afa:	e7a1                	bnez	a5,80005b42 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005afc:	29c1                	addiw	s3,s3,16
    80005afe:	04c92783          	lw	a5,76(s2)
    80005b02:	fcf9ede3          	bltu	s3,a5,80005adc <sys_unlink+0x140>
    80005b06:	b781                	j	80005a46 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005b08:	00003517          	auipc	a0,0x3
    80005b0c:	cd050513          	addi	a0,a0,-816 # 800087d8 <syscalls+0x2e0>
    80005b10:	ffffb097          	auipc	ra,0xffffb
    80005b14:	a76080e7          	jalr	-1418(ra) # 80000586 <panic>
    panic("unlink: writei");
    80005b18:	00003517          	auipc	a0,0x3
    80005b1c:	cd850513          	addi	a0,a0,-808 # 800087f0 <syscalls+0x2f8>
    80005b20:	ffffb097          	auipc	ra,0xffffb
    80005b24:	a66080e7          	jalr	-1434(ra) # 80000586 <panic>
    dp->nlink--;
    80005b28:	04a4d783          	lhu	a5,74(s1)
    80005b2c:	37fd                	addiw	a5,a5,-1
    80005b2e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b32:	8526                	mv	a0,s1
    80005b34:	ffffe097          	auipc	ra,0xffffe
    80005b38:	fc4080e7          	jalr	-60(ra) # 80003af8 <iupdate>
    80005b3c:	b781                	j	80005a7c <sys_unlink+0xe0>
    return -1;
    80005b3e:	557d                	li	a0,-1
    80005b40:	a005                	j	80005b60 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005b42:	854a                	mv	a0,s2
    80005b44:	ffffe097          	auipc	ra,0xffffe
    80005b48:	2e2080e7          	jalr	738(ra) # 80003e26 <iunlockput>
  iunlockput(dp);
    80005b4c:	8526                	mv	a0,s1
    80005b4e:	ffffe097          	auipc	ra,0xffffe
    80005b52:	2d8080e7          	jalr	728(ra) # 80003e26 <iunlockput>
  end_op();
    80005b56:	fffff097          	auipc	ra,0xfffff
    80005b5a:	ab8080e7          	jalr	-1352(ra) # 8000460e <end_op>
  return -1;
    80005b5e:	557d                	li	a0,-1
}
    80005b60:	70ae                	ld	ra,232(sp)
    80005b62:	740e                	ld	s0,224(sp)
    80005b64:	64ee                	ld	s1,216(sp)
    80005b66:	694e                	ld	s2,208(sp)
    80005b68:	69ae                	ld	s3,200(sp)
    80005b6a:	616d                	addi	sp,sp,240
    80005b6c:	8082                	ret

0000000080005b6e <sys_open>:

uint64
sys_open(void)
{
    80005b6e:	7131                	addi	sp,sp,-192
    80005b70:	fd06                	sd	ra,184(sp)
    80005b72:	f922                	sd	s0,176(sp)
    80005b74:	f526                	sd	s1,168(sp)
    80005b76:	f14a                	sd	s2,160(sp)
    80005b78:	ed4e                	sd	s3,152(sp)
    80005b7a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005b7c:	f4c40593          	addi	a1,s0,-180
    80005b80:	4505                	li	a0,1
    80005b82:	ffffd097          	auipc	ra,0xffffd
    80005b86:	44a080e7          	jalr	1098(ra) # 80002fcc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b8a:	08000613          	li	a2,128
    80005b8e:	f5040593          	addi	a1,s0,-176
    80005b92:	4501                	li	a0,0
    80005b94:	ffffd097          	auipc	ra,0xffffd
    80005b98:	478080e7          	jalr	1144(ra) # 8000300c <argstr>
    80005b9c:	87aa                	mv	a5,a0
    return -1;
    80005b9e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005ba0:	0a07c963          	bltz	a5,80005c52 <sys_open+0xe4>

  begin_op();
    80005ba4:	fffff097          	auipc	ra,0xfffff
    80005ba8:	9ec080e7          	jalr	-1556(ra) # 80004590 <begin_op>

  if(omode & O_CREATE){
    80005bac:	f4c42783          	lw	a5,-180(s0)
    80005bb0:	2007f793          	andi	a5,a5,512
    80005bb4:	cfc5                	beqz	a5,80005c6c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005bb6:	4681                	li	a3,0
    80005bb8:	4601                	li	a2,0
    80005bba:	4589                	li	a1,2
    80005bbc:	f5040513          	addi	a0,s0,-176
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	972080e7          	jalr	-1678(ra) # 80005532 <create>
    80005bc8:	84aa                	mv	s1,a0
    if(ip == 0){
    80005bca:	c959                	beqz	a0,80005c60 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005bcc:	04449703          	lh	a4,68(s1)
    80005bd0:	478d                	li	a5,3
    80005bd2:	00f71763          	bne	a4,a5,80005be0 <sys_open+0x72>
    80005bd6:	0464d703          	lhu	a4,70(s1)
    80005bda:	47a5                	li	a5,9
    80005bdc:	0ce7ed63          	bltu	a5,a4,80005cb6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005be0:	fffff097          	auipc	ra,0xfffff
    80005be4:	dbc080e7          	jalr	-580(ra) # 8000499c <filealloc>
    80005be8:	89aa                	mv	s3,a0
    80005bea:	10050363          	beqz	a0,80005cf0 <sys_open+0x182>
    80005bee:	00000097          	auipc	ra,0x0
    80005bf2:	902080e7          	jalr	-1790(ra) # 800054f0 <fdalloc>
    80005bf6:	892a                	mv	s2,a0
    80005bf8:	0e054763          	bltz	a0,80005ce6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005bfc:	04449703          	lh	a4,68(s1)
    80005c00:	478d                	li	a5,3
    80005c02:	0cf70563          	beq	a4,a5,80005ccc <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005c06:	4789                	li	a5,2
    80005c08:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005c0c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005c10:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005c14:	f4c42783          	lw	a5,-180(s0)
    80005c18:	0017c713          	xori	a4,a5,1
    80005c1c:	8b05                	andi	a4,a4,1
    80005c1e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005c22:	0037f713          	andi	a4,a5,3
    80005c26:	00e03733          	snez	a4,a4
    80005c2a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005c2e:	4007f793          	andi	a5,a5,1024
    80005c32:	c791                	beqz	a5,80005c3e <sys_open+0xd0>
    80005c34:	04449703          	lh	a4,68(s1)
    80005c38:	4789                	li	a5,2
    80005c3a:	0af70063          	beq	a4,a5,80005cda <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005c3e:	8526                	mv	a0,s1
    80005c40:	ffffe097          	auipc	ra,0xffffe
    80005c44:	046080e7          	jalr	70(ra) # 80003c86 <iunlock>
  end_op();
    80005c48:	fffff097          	auipc	ra,0xfffff
    80005c4c:	9c6080e7          	jalr	-1594(ra) # 8000460e <end_op>

  return fd;
    80005c50:	854a                	mv	a0,s2
}
    80005c52:	70ea                	ld	ra,184(sp)
    80005c54:	744a                	ld	s0,176(sp)
    80005c56:	74aa                	ld	s1,168(sp)
    80005c58:	790a                	ld	s2,160(sp)
    80005c5a:	69ea                	ld	s3,152(sp)
    80005c5c:	6129                	addi	sp,sp,192
    80005c5e:	8082                	ret
      end_op();
    80005c60:	fffff097          	auipc	ra,0xfffff
    80005c64:	9ae080e7          	jalr	-1618(ra) # 8000460e <end_op>
      return -1;
    80005c68:	557d                	li	a0,-1
    80005c6a:	b7e5                	j	80005c52 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005c6c:	f5040513          	addi	a0,s0,-176
    80005c70:	ffffe097          	auipc	ra,0xffffe
    80005c74:	700080e7          	jalr	1792(ra) # 80004370 <namei>
    80005c78:	84aa                	mv	s1,a0
    80005c7a:	c905                	beqz	a0,80005caa <sys_open+0x13c>
    ilock(ip);
    80005c7c:	ffffe097          	auipc	ra,0xffffe
    80005c80:	f48080e7          	jalr	-184(ra) # 80003bc4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c84:	04449703          	lh	a4,68(s1)
    80005c88:	4785                	li	a5,1
    80005c8a:	f4f711e3          	bne	a4,a5,80005bcc <sys_open+0x5e>
    80005c8e:	f4c42783          	lw	a5,-180(s0)
    80005c92:	d7b9                	beqz	a5,80005be0 <sys_open+0x72>
      iunlockput(ip);
    80005c94:	8526                	mv	a0,s1
    80005c96:	ffffe097          	auipc	ra,0xffffe
    80005c9a:	190080e7          	jalr	400(ra) # 80003e26 <iunlockput>
      end_op();
    80005c9e:	fffff097          	auipc	ra,0xfffff
    80005ca2:	970080e7          	jalr	-1680(ra) # 8000460e <end_op>
      return -1;
    80005ca6:	557d                	li	a0,-1
    80005ca8:	b76d                	j	80005c52 <sys_open+0xe4>
      end_op();
    80005caa:	fffff097          	auipc	ra,0xfffff
    80005cae:	964080e7          	jalr	-1692(ra) # 8000460e <end_op>
      return -1;
    80005cb2:	557d                	li	a0,-1
    80005cb4:	bf79                	j	80005c52 <sys_open+0xe4>
    iunlockput(ip);
    80005cb6:	8526                	mv	a0,s1
    80005cb8:	ffffe097          	auipc	ra,0xffffe
    80005cbc:	16e080e7          	jalr	366(ra) # 80003e26 <iunlockput>
    end_op();
    80005cc0:	fffff097          	auipc	ra,0xfffff
    80005cc4:	94e080e7          	jalr	-1714(ra) # 8000460e <end_op>
    return -1;
    80005cc8:	557d                	li	a0,-1
    80005cca:	b761                	j	80005c52 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005ccc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005cd0:	04649783          	lh	a5,70(s1)
    80005cd4:	02f99223          	sh	a5,36(s3)
    80005cd8:	bf25                	j	80005c10 <sys_open+0xa2>
    itrunc(ip);
    80005cda:	8526                	mv	a0,s1
    80005cdc:	ffffe097          	auipc	ra,0xffffe
    80005ce0:	ff6080e7          	jalr	-10(ra) # 80003cd2 <itrunc>
    80005ce4:	bfa9                	j	80005c3e <sys_open+0xd0>
      fileclose(f);
    80005ce6:	854e                	mv	a0,s3
    80005ce8:	fffff097          	auipc	ra,0xfffff
    80005cec:	d70080e7          	jalr	-656(ra) # 80004a58 <fileclose>
    iunlockput(ip);
    80005cf0:	8526                	mv	a0,s1
    80005cf2:	ffffe097          	auipc	ra,0xffffe
    80005cf6:	134080e7          	jalr	308(ra) # 80003e26 <iunlockput>
    end_op();
    80005cfa:	fffff097          	auipc	ra,0xfffff
    80005cfe:	914080e7          	jalr	-1772(ra) # 8000460e <end_op>
    return -1;
    80005d02:	557d                	li	a0,-1
    80005d04:	b7b9                	j	80005c52 <sys_open+0xe4>

0000000080005d06 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005d06:	7175                	addi	sp,sp,-144
    80005d08:	e506                	sd	ra,136(sp)
    80005d0a:	e122                	sd	s0,128(sp)
    80005d0c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005d0e:	fffff097          	auipc	ra,0xfffff
    80005d12:	882080e7          	jalr	-1918(ra) # 80004590 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005d16:	08000613          	li	a2,128
    80005d1a:	f7040593          	addi	a1,s0,-144
    80005d1e:	4501                	li	a0,0
    80005d20:	ffffd097          	auipc	ra,0xffffd
    80005d24:	2ec080e7          	jalr	748(ra) # 8000300c <argstr>
    80005d28:	02054963          	bltz	a0,80005d5a <sys_mkdir+0x54>
    80005d2c:	4681                	li	a3,0
    80005d2e:	4601                	li	a2,0
    80005d30:	4585                	li	a1,1
    80005d32:	f7040513          	addi	a0,s0,-144
    80005d36:	fffff097          	auipc	ra,0xfffff
    80005d3a:	7fc080e7          	jalr	2044(ra) # 80005532 <create>
    80005d3e:	cd11                	beqz	a0,80005d5a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d40:	ffffe097          	auipc	ra,0xffffe
    80005d44:	0e6080e7          	jalr	230(ra) # 80003e26 <iunlockput>
  end_op();
    80005d48:	fffff097          	auipc	ra,0xfffff
    80005d4c:	8c6080e7          	jalr	-1850(ra) # 8000460e <end_op>
  return 0;
    80005d50:	4501                	li	a0,0
}
    80005d52:	60aa                	ld	ra,136(sp)
    80005d54:	640a                	ld	s0,128(sp)
    80005d56:	6149                	addi	sp,sp,144
    80005d58:	8082                	ret
    end_op();
    80005d5a:	fffff097          	auipc	ra,0xfffff
    80005d5e:	8b4080e7          	jalr	-1868(ra) # 8000460e <end_op>
    return -1;
    80005d62:	557d                	li	a0,-1
    80005d64:	b7fd                	j	80005d52 <sys_mkdir+0x4c>

0000000080005d66 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005d66:	7135                	addi	sp,sp,-160
    80005d68:	ed06                	sd	ra,152(sp)
    80005d6a:	e922                	sd	s0,144(sp)
    80005d6c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d6e:	fffff097          	auipc	ra,0xfffff
    80005d72:	822080e7          	jalr	-2014(ra) # 80004590 <begin_op>
  argint(1, &major);
    80005d76:	f6c40593          	addi	a1,s0,-148
    80005d7a:	4505                	li	a0,1
    80005d7c:	ffffd097          	auipc	ra,0xffffd
    80005d80:	250080e7          	jalr	592(ra) # 80002fcc <argint>
  argint(2, &minor);
    80005d84:	f6840593          	addi	a1,s0,-152
    80005d88:	4509                	li	a0,2
    80005d8a:	ffffd097          	auipc	ra,0xffffd
    80005d8e:	242080e7          	jalr	578(ra) # 80002fcc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d92:	08000613          	li	a2,128
    80005d96:	f7040593          	addi	a1,s0,-144
    80005d9a:	4501                	li	a0,0
    80005d9c:	ffffd097          	auipc	ra,0xffffd
    80005da0:	270080e7          	jalr	624(ra) # 8000300c <argstr>
    80005da4:	02054b63          	bltz	a0,80005dda <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005da8:	f6841683          	lh	a3,-152(s0)
    80005dac:	f6c41603          	lh	a2,-148(s0)
    80005db0:	458d                	li	a1,3
    80005db2:	f7040513          	addi	a0,s0,-144
    80005db6:	fffff097          	auipc	ra,0xfffff
    80005dba:	77c080e7          	jalr	1916(ra) # 80005532 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005dbe:	cd11                	beqz	a0,80005dda <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005dc0:	ffffe097          	auipc	ra,0xffffe
    80005dc4:	066080e7          	jalr	102(ra) # 80003e26 <iunlockput>
  end_op();
    80005dc8:	fffff097          	auipc	ra,0xfffff
    80005dcc:	846080e7          	jalr	-1978(ra) # 8000460e <end_op>
  return 0;
    80005dd0:	4501                	li	a0,0
}
    80005dd2:	60ea                	ld	ra,152(sp)
    80005dd4:	644a                	ld	s0,144(sp)
    80005dd6:	610d                	addi	sp,sp,160
    80005dd8:	8082                	ret
    end_op();
    80005dda:	fffff097          	auipc	ra,0xfffff
    80005dde:	834080e7          	jalr	-1996(ra) # 8000460e <end_op>
    return -1;
    80005de2:	557d                	li	a0,-1
    80005de4:	b7fd                	j	80005dd2 <sys_mknod+0x6c>

0000000080005de6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005de6:	7135                	addi	sp,sp,-160
    80005de8:	ed06                	sd	ra,152(sp)
    80005dea:	e922                	sd	s0,144(sp)
    80005dec:	e526                	sd	s1,136(sp)
    80005dee:	e14a                	sd	s2,128(sp)
    80005df0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005df2:	ffffc097          	auipc	ra,0xffffc
    80005df6:	e74080e7          	jalr	-396(ra) # 80001c66 <myproc>
    80005dfa:	892a                	mv	s2,a0
  
  begin_op();
    80005dfc:	ffffe097          	auipc	ra,0xffffe
    80005e00:	794080e7          	jalr	1940(ra) # 80004590 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005e04:	08000613          	li	a2,128
    80005e08:	f6040593          	addi	a1,s0,-160
    80005e0c:	4501                	li	a0,0
    80005e0e:	ffffd097          	auipc	ra,0xffffd
    80005e12:	1fe080e7          	jalr	510(ra) # 8000300c <argstr>
    80005e16:	04054b63          	bltz	a0,80005e6c <sys_chdir+0x86>
    80005e1a:	f6040513          	addi	a0,s0,-160
    80005e1e:	ffffe097          	auipc	ra,0xffffe
    80005e22:	552080e7          	jalr	1362(ra) # 80004370 <namei>
    80005e26:	84aa                	mv	s1,a0
    80005e28:	c131                	beqz	a0,80005e6c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005e2a:	ffffe097          	auipc	ra,0xffffe
    80005e2e:	d9a080e7          	jalr	-614(ra) # 80003bc4 <ilock>
  if(ip->type != T_DIR){
    80005e32:	04449703          	lh	a4,68(s1)
    80005e36:	4785                	li	a5,1
    80005e38:	04f71063          	bne	a4,a5,80005e78 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005e3c:	8526                	mv	a0,s1
    80005e3e:	ffffe097          	auipc	ra,0xffffe
    80005e42:	e48080e7          	jalr	-440(ra) # 80003c86 <iunlock>
  iput(p->cwd);
    80005e46:	15893503          	ld	a0,344(s2)
    80005e4a:	ffffe097          	auipc	ra,0xffffe
    80005e4e:	f34080e7          	jalr	-204(ra) # 80003d7e <iput>
  end_op();
    80005e52:	ffffe097          	auipc	ra,0xffffe
    80005e56:	7bc080e7          	jalr	1980(ra) # 8000460e <end_op>
  p->cwd = ip;
    80005e5a:	14993c23          	sd	s1,344(s2)
  return 0;
    80005e5e:	4501                	li	a0,0
}
    80005e60:	60ea                	ld	ra,152(sp)
    80005e62:	644a                	ld	s0,144(sp)
    80005e64:	64aa                	ld	s1,136(sp)
    80005e66:	690a                	ld	s2,128(sp)
    80005e68:	610d                	addi	sp,sp,160
    80005e6a:	8082                	ret
    end_op();
    80005e6c:	ffffe097          	auipc	ra,0xffffe
    80005e70:	7a2080e7          	jalr	1954(ra) # 8000460e <end_op>
    return -1;
    80005e74:	557d                	li	a0,-1
    80005e76:	b7ed                	j	80005e60 <sys_chdir+0x7a>
    iunlockput(ip);
    80005e78:	8526                	mv	a0,s1
    80005e7a:	ffffe097          	auipc	ra,0xffffe
    80005e7e:	fac080e7          	jalr	-84(ra) # 80003e26 <iunlockput>
    end_op();
    80005e82:	ffffe097          	auipc	ra,0xffffe
    80005e86:	78c080e7          	jalr	1932(ra) # 8000460e <end_op>
    return -1;
    80005e8a:	557d                	li	a0,-1
    80005e8c:	bfd1                	j	80005e60 <sys_chdir+0x7a>

0000000080005e8e <sys_exec>:

uint64
sys_exec(void)
{
    80005e8e:	7145                	addi	sp,sp,-464
    80005e90:	e786                	sd	ra,456(sp)
    80005e92:	e3a2                	sd	s0,448(sp)
    80005e94:	ff26                	sd	s1,440(sp)
    80005e96:	fb4a                	sd	s2,432(sp)
    80005e98:	f74e                	sd	s3,424(sp)
    80005e9a:	f352                	sd	s4,416(sp)
    80005e9c:	ef56                	sd	s5,408(sp)
    80005e9e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005ea0:	e3840593          	addi	a1,s0,-456
    80005ea4:	4505                	li	a0,1
    80005ea6:	ffffd097          	auipc	ra,0xffffd
    80005eaa:	146080e7          	jalr	326(ra) # 80002fec <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005eae:	08000613          	li	a2,128
    80005eb2:	f4040593          	addi	a1,s0,-192
    80005eb6:	4501                	li	a0,0
    80005eb8:	ffffd097          	auipc	ra,0xffffd
    80005ebc:	154080e7          	jalr	340(ra) # 8000300c <argstr>
    80005ec0:	87aa                	mv	a5,a0
    return -1;
    80005ec2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005ec4:	0c07c363          	bltz	a5,80005f8a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005ec8:	10000613          	li	a2,256
    80005ecc:	4581                	li	a1,0
    80005ece:	e4040513          	addi	a0,s0,-448
    80005ed2:	ffffb097          	auipc	ra,0xffffb
    80005ed6:	e46080e7          	jalr	-442(ra) # 80000d18 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005eda:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005ede:	89a6                	mv	s3,s1
    80005ee0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005ee2:	02000a13          	li	s4,32
    80005ee6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005eea:	00391513          	slli	a0,s2,0x3
    80005eee:	e3040593          	addi	a1,s0,-464
    80005ef2:	e3843783          	ld	a5,-456(s0)
    80005ef6:	953e                	add	a0,a0,a5
    80005ef8:	ffffd097          	auipc	ra,0xffffd
    80005efc:	036080e7          	jalr	54(ra) # 80002f2e <fetchaddr>
    80005f00:	02054a63          	bltz	a0,80005f34 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005f04:	e3043783          	ld	a5,-464(s0)
    80005f08:	c3b9                	beqz	a5,80005f4e <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005f0a:	ffffb097          	auipc	ra,0xffffb
    80005f0e:	c22080e7          	jalr	-990(ra) # 80000b2c <kalloc>
    80005f12:	85aa                	mv	a1,a0
    80005f14:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005f18:	cd11                	beqz	a0,80005f34 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005f1a:	6605                	lui	a2,0x1
    80005f1c:	e3043503          	ld	a0,-464(s0)
    80005f20:	ffffd097          	auipc	ra,0xffffd
    80005f24:	060080e7          	jalr	96(ra) # 80002f80 <fetchstr>
    80005f28:	00054663          	bltz	a0,80005f34 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005f2c:	0905                	addi	s2,s2,1
    80005f2e:	09a1                	addi	s3,s3,8
    80005f30:	fb491be3          	bne	s2,s4,80005ee6 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f34:	f4040913          	addi	s2,s0,-192
    80005f38:	6088                	ld	a0,0(s1)
    80005f3a:	c539                	beqz	a0,80005f88 <sys_exec+0xfa>
    kfree(argv[i]);
    80005f3c:	ffffb097          	auipc	ra,0xffffb
    80005f40:	af2080e7          	jalr	-1294(ra) # 80000a2e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f44:	04a1                	addi	s1,s1,8
    80005f46:	ff2499e3          	bne	s1,s2,80005f38 <sys_exec+0xaa>
  return -1;
    80005f4a:	557d                	li	a0,-1
    80005f4c:	a83d                	j	80005f8a <sys_exec+0xfc>
      argv[i] = 0;
    80005f4e:	0a8e                	slli	s5,s5,0x3
    80005f50:	fc0a8793          	addi	a5,s5,-64
    80005f54:	00878ab3          	add	s5,a5,s0
    80005f58:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005f5c:	e4040593          	addi	a1,s0,-448
    80005f60:	f4040513          	addi	a0,s0,-192
    80005f64:	fffff097          	auipc	ra,0xfffff
    80005f68:	16e080e7          	jalr	366(ra) # 800050d2 <exec>
    80005f6c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f6e:	f4040993          	addi	s3,s0,-192
    80005f72:	6088                	ld	a0,0(s1)
    80005f74:	c901                	beqz	a0,80005f84 <sys_exec+0xf6>
    kfree(argv[i]);
    80005f76:	ffffb097          	auipc	ra,0xffffb
    80005f7a:	ab8080e7          	jalr	-1352(ra) # 80000a2e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f7e:	04a1                	addi	s1,s1,8
    80005f80:	ff3499e3          	bne	s1,s3,80005f72 <sys_exec+0xe4>
  return ret;
    80005f84:	854a                	mv	a0,s2
    80005f86:	a011                	j	80005f8a <sys_exec+0xfc>
  return -1;
    80005f88:	557d                	li	a0,-1
}
    80005f8a:	60be                	ld	ra,456(sp)
    80005f8c:	641e                	ld	s0,448(sp)
    80005f8e:	74fa                	ld	s1,440(sp)
    80005f90:	795a                	ld	s2,432(sp)
    80005f92:	79ba                	ld	s3,424(sp)
    80005f94:	7a1a                	ld	s4,416(sp)
    80005f96:	6afa                	ld	s5,408(sp)
    80005f98:	6179                	addi	sp,sp,464
    80005f9a:	8082                	ret

0000000080005f9c <sys_pipe>:

uint64
sys_pipe(void)
{
    80005f9c:	7139                	addi	sp,sp,-64
    80005f9e:	fc06                	sd	ra,56(sp)
    80005fa0:	f822                	sd	s0,48(sp)
    80005fa2:	f426                	sd	s1,40(sp)
    80005fa4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005fa6:	ffffc097          	auipc	ra,0xffffc
    80005faa:	cc0080e7          	jalr	-832(ra) # 80001c66 <myproc>
    80005fae:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005fb0:	fd840593          	addi	a1,s0,-40
    80005fb4:	4501                	li	a0,0
    80005fb6:	ffffd097          	auipc	ra,0xffffd
    80005fba:	036080e7          	jalr	54(ra) # 80002fec <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005fbe:	fc840593          	addi	a1,s0,-56
    80005fc2:	fd040513          	addi	a0,s0,-48
    80005fc6:	fffff097          	auipc	ra,0xfffff
    80005fca:	dc2080e7          	jalr	-574(ra) # 80004d88 <pipealloc>
    return -1;
    80005fce:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005fd0:	0c054463          	bltz	a0,80006098 <sys_pipe+0xfc>
  fd0 = -1;
    80005fd4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005fd8:	fd043503          	ld	a0,-48(s0)
    80005fdc:	fffff097          	auipc	ra,0xfffff
    80005fe0:	514080e7          	jalr	1300(ra) # 800054f0 <fdalloc>
    80005fe4:	fca42223          	sw	a0,-60(s0)
    80005fe8:	08054b63          	bltz	a0,8000607e <sys_pipe+0xe2>
    80005fec:	fc843503          	ld	a0,-56(s0)
    80005ff0:	fffff097          	auipc	ra,0xfffff
    80005ff4:	500080e7          	jalr	1280(ra) # 800054f0 <fdalloc>
    80005ff8:	fca42023          	sw	a0,-64(s0)
    80005ffc:	06054863          	bltz	a0,8000606c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006000:	4691                	li	a3,4
    80006002:	fc440613          	addi	a2,s0,-60
    80006006:	fd843583          	ld	a1,-40(s0)
    8000600a:	6ca8                	ld	a0,88(s1)
    8000600c:	ffffb097          	auipc	ra,0xffffb
    80006010:	6a6080e7          	jalr	1702(ra) # 800016b2 <copyout>
    80006014:	02054063          	bltz	a0,80006034 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006018:	4691                	li	a3,4
    8000601a:	fc040613          	addi	a2,s0,-64
    8000601e:	fd843583          	ld	a1,-40(s0)
    80006022:	0591                	addi	a1,a1,4
    80006024:	6ca8                	ld	a0,88(s1)
    80006026:	ffffb097          	auipc	ra,0xffffb
    8000602a:	68c080e7          	jalr	1676(ra) # 800016b2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000602e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006030:	06055463          	bgez	a0,80006098 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006034:	fc442783          	lw	a5,-60(s0)
    80006038:	07e9                	addi	a5,a5,26
    8000603a:	078e                	slli	a5,a5,0x3
    8000603c:	97a6                	add	a5,a5,s1
    8000603e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80006042:	fc042783          	lw	a5,-64(s0)
    80006046:	07e9                	addi	a5,a5,26
    80006048:	078e                	slli	a5,a5,0x3
    8000604a:	94be                	add	s1,s1,a5
    8000604c:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80006050:	fd043503          	ld	a0,-48(s0)
    80006054:	fffff097          	auipc	ra,0xfffff
    80006058:	a04080e7          	jalr	-1532(ra) # 80004a58 <fileclose>
    fileclose(wf);
    8000605c:	fc843503          	ld	a0,-56(s0)
    80006060:	fffff097          	auipc	ra,0xfffff
    80006064:	9f8080e7          	jalr	-1544(ra) # 80004a58 <fileclose>
    return -1;
    80006068:	57fd                	li	a5,-1
    8000606a:	a03d                	j	80006098 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000606c:	fc442783          	lw	a5,-60(s0)
    80006070:	0007c763          	bltz	a5,8000607e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006074:	07e9                	addi	a5,a5,26
    80006076:	078e                	slli	a5,a5,0x3
    80006078:	97a6                	add	a5,a5,s1
    8000607a:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000607e:	fd043503          	ld	a0,-48(s0)
    80006082:	fffff097          	auipc	ra,0xfffff
    80006086:	9d6080e7          	jalr	-1578(ra) # 80004a58 <fileclose>
    fileclose(wf);
    8000608a:	fc843503          	ld	a0,-56(s0)
    8000608e:	fffff097          	auipc	ra,0xfffff
    80006092:	9ca080e7          	jalr	-1590(ra) # 80004a58 <fileclose>
    return -1;
    80006096:	57fd                	li	a5,-1
}
    80006098:	853e                	mv	a0,a5
    8000609a:	70e2                	ld	ra,56(sp)
    8000609c:	7442                	ld	s0,48(sp)
    8000609e:	74a2                	ld	s1,40(sp)
    800060a0:	6121                	addi	sp,sp,64
    800060a2:	8082                	ret
	...

00000000800060b0 <kernelvec>:
    800060b0:	7111                	addi	sp,sp,-256
    800060b2:	e006                	sd	ra,0(sp)
    800060b4:	e40a                	sd	sp,8(sp)
    800060b6:	e80e                	sd	gp,16(sp)
    800060b8:	ec12                	sd	tp,24(sp)
    800060ba:	f016                	sd	t0,32(sp)
    800060bc:	f41a                	sd	t1,40(sp)
    800060be:	f81e                	sd	t2,48(sp)
    800060c0:	fc22                	sd	s0,56(sp)
    800060c2:	e0a6                	sd	s1,64(sp)
    800060c4:	e4aa                	sd	a0,72(sp)
    800060c6:	e8ae                	sd	a1,80(sp)
    800060c8:	ecb2                	sd	a2,88(sp)
    800060ca:	f0b6                	sd	a3,96(sp)
    800060cc:	f4ba                	sd	a4,104(sp)
    800060ce:	f8be                	sd	a5,112(sp)
    800060d0:	fcc2                	sd	a6,120(sp)
    800060d2:	e146                	sd	a7,128(sp)
    800060d4:	e54a                	sd	s2,136(sp)
    800060d6:	e94e                	sd	s3,144(sp)
    800060d8:	ed52                	sd	s4,152(sp)
    800060da:	f156                	sd	s5,160(sp)
    800060dc:	f55a                	sd	s6,168(sp)
    800060de:	f95e                	sd	s7,176(sp)
    800060e0:	fd62                	sd	s8,184(sp)
    800060e2:	e1e6                	sd	s9,192(sp)
    800060e4:	e5ea                	sd	s10,200(sp)
    800060e6:	e9ee                	sd	s11,208(sp)
    800060e8:	edf2                	sd	t3,216(sp)
    800060ea:	f1f6                	sd	t4,224(sp)
    800060ec:	f5fa                	sd	t5,232(sp)
    800060ee:	f9fe                	sd	t6,240(sp)
    800060f0:	d09fc0ef          	jal	ra,80002df8 <kerneltrap>
    800060f4:	6082                	ld	ra,0(sp)
    800060f6:	6122                	ld	sp,8(sp)
    800060f8:	61c2                	ld	gp,16(sp)
    800060fa:	7282                	ld	t0,32(sp)
    800060fc:	7322                	ld	t1,40(sp)
    800060fe:	73c2                	ld	t2,48(sp)
    80006100:	7462                	ld	s0,56(sp)
    80006102:	6486                	ld	s1,64(sp)
    80006104:	6526                	ld	a0,72(sp)
    80006106:	65c6                	ld	a1,80(sp)
    80006108:	6666                	ld	a2,88(sp)
    8000610a:	7686                	ld	a3,96(sp)
    8000610c:	7726                	ld	a4,104(sp)
    8000610e:	77c6                	ld	a5,112(sp)
    80006110:	7866                	ld	a6,120(sp)
    80006112:	688a                	ld	a7,128(sp)
    80006114:	692a                	ld	s2,136(sp)
    80006116:	69ca                	ld	s3,144(sp)
    80006118:	6a6a                	ld	s4,152(sp)
    8000611a:	7a8a                	ld	s5,160(sp)
    8000611c:	7b2a                	ld	s6,168(sp)
    8000611e:	7bca                	ld	s7,176(sp)
    80006120:	7c6a                	ld	s8,184(sp)
    80006122:	6c8e                	ld	s9,192(sp)
    80006124:	6d2e                	ld	s10,200(sp)
    80006126:	6dce                	ld	s11,208(sp)
    80006128:	6e6e                	ld	t3,216(sp)
    8000612a:	7e8e                	ld	t4,224(sp)
    8000612c:	7f2e                	ld	t5,232(sp)
    8000612e:	7fce                	ld	t6,240(sp)
    80006130:	6111                	addi	sp,sp,256
    80006132:	10200073          	sret
    80006136:	00000013          	nop
    8000613a:	00000013          	nop
    8000613e:	0001                	nop

0000000080006140 <timervec>:
    80006140:	34051573          	csrrw	a0,mscratch,a0
    80006144:	e10c                	sd	a1,0(a0)
    80006146:	e510                	sd	a2,8(a0)
    80006148:	e914                	sd	a3,16(a0)
    8000614a:	6d0c                	ld	a1,24(a0)
    8000614c:	7110                	ld	a2,32(a0)
    8000614e:	6194                	ld	a3,0(a1)
    80006150:	96b2                	add	a3,a3,a2
    80006152:	e194                	sd	a3,0(a1)
    80006154:	4589                	li	a1,2
    80006156:	14459073          	csrw	sip,a1
    8000615a:	6914                	ld	a3,16(a0)
    8000615c:	6510                	ld	a2,8(a0)
    8000615e:	610c                	ld	a1,0(a0)
    80006160:	34051573          	csrrw	a0,mscratch,a0
    80006164:	30200073          	mret
	...

000000008000616a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000616a:	1141                	addi	sp,sp,-16
    8000616c:	e422                	sd	s0,8(sp)
    8000616e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006170:	0c0007b7          	lui	a5,0xc000
    80006174:	4705                	li	a4,1
    80006176:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006178:	c3d8                	sw	a4,4(a5)
}
    8000617a:	6422                	ld	s0,8(sp)
    8000617c:	0141                	addi	sp,sp,16
    8000617e:	8082                	ret

0000000080006180 <plicinithart>:

void
plicinithart(void)
{
    80006180:	1141                	addi	sp,sp,-16
    80006182:	e406                	sd	ra,8(sp)
    80006184:	e022                	sd	s0,0(sp)
    80006186:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006188:	ffffc097          	auipc	ra,0xffffc
    8000618c:	ab2080e7          	jalr	-1358(ra) # 80001c3a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006190:	0085171b          	slliw	a4,a0,0x8
    80006194:	0c0027b7          	lui	a5,0xc002
    80006198:	97ba                	add	a5,a5,a4
    8000619a:	40200713          	li	a4,1026
    8000619e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800061a2:	00d5151b          	slliw	a0,a0,0xd
    800061a6:	0c2017b7          	lui	a5,0xc201
    800061aa:	97aa                	add	a5,a5,a0
    800061ac:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800061b0:	60a2                	ld	ra,8(sp)
    800061b2:	6402                	ld	s0,0(sp)
    800061b4:	0141                	addi	sp,sp,16
    800061b6:	8082                	ret

00000000800061b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800061b8:	1141                	addi	sp,sp,-16
    800061ba:	e406                	sd	ra,8(sp)
    800061bc:	e022                	sd	s0,0(sp)
    800061be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800061c0:	ffffc097          	auipc	ra,0xffffc
    800061c4:	a7a080e7          	jalr	-1414(ra) # 80001c3a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800061c8:	00d5151b          	slliw	a0,a0,0xd
    800061cc:	0c2017b7          	lui	a5,0xc201
    800061d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800061d2:	43c8                	lw	a0,4(a5)
    800061d4:	60a2                	ld	ra,8(sp)
    800061d6:	6402                	ld	s0,0(sp)
    800061d8:	0141                	addi	sp,sp,16
    800061da:	8082                	ret

00000000800061dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800061dc:	1101                	addi	sp,sp,-32
    800061de:	ec06                	sd	ra,24(sp)
    800061e0:	e822                	sd	s0,16(sp)
    800061e2:	e426                	sd	s1,8(sp)
    800061e4:	1000                	addi	s0,sp,32
    800061e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800061e8:	ffffc097          	auipc	ra,0xffffc
    800061ec:	a52080e7          	jalr	-1454(ra) # 80001c3a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800061f0:	00d5151b          	slliw	a0,a0,0xd
    800061f4:	0c2017b7          	lui	a5,0xc201
    800061f8:	97aa                	add	a5,a5,a0
    800061fa:	c3c4                	sw	s1,4(a5)
}
    800061fc:	60e2                	ld	ra,24(sp)
    800061fe:	6442                	ld	s0,16(sp)
    80006200:	64a2                	ld	s1,8(sp)
    80006202:	6105                	addi	sp,sp,32
    80006204:	8082                	ret

0000000080006206 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006206:	1141                	addi	sp,sp,-16
    80006208:	e406                	sd	ra,8(sp)
    8000620a:	e022                	sd	s0,0(sp)
    8000620c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000620e:	479d                	li	a5,7
    80006210:	04a7cc63          	blt	a5,a0,80006268 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006214:	0001c797          	auipc	a5,0x1c
    80006218:	d1c78793          	addi	a5,a5,-740 # 80021f30 <disk>
    8000621c:	97aa                	add	a5,a5,a0
    8000621e:	0187c783          	lbu	a5,24(a5)
    80006222:	ebb9                	bnez	a5,80006278 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006224:	00451693          	slli	a3,a0,0x4
    80006228:	0001c797          	auipc	a5,0x1c
    8000622c:	d0878793          	addi	a5,a5,-760 # 80021f30 <disk>
    80006230:	6398                	ld	a4,0(a5)
    80006232:	9736                	add	a4,a4,a3
    80006234:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006238:	6398                	ld	a4,0(a5)
    8000623a:	9736                	add	a4,a4,a3
    8000623c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006240:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006244:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006248:	97aa                	add	a5,a5,a0
    8000624a:	4705                	li	a4,1
    8000624c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006250:	0001c517          	auipc	a0,0x1c
    80006254:	cf850513          	addi	a0,a0,-776 # 80021f48 <disk+0x18>
    80006258:	ffffc097          	auipc	ra,0xffffc
    8000625c:	238080e7          	jalr	568(ra) # 80002490 <wakeup>
}
    80006260:	60a2                	ld	ra,8(sp)
    80006262:	6402                	ld	s0,0(sp)
    80006264:	0141                	addi	sp,sp,16
    80006266:	8082                	ret
    panic("free_desc 1");
    80006268:	00002517          	auipc	a0,0x2
    8000626c:	59850513          	addi	a0,a0,1432 # 80008800 <syscalls+0x308>
    80006270:	ffffa097          	auipc	ra,0xffffa
    80006274:	316080e7          	jalr	790(ra) # 80000586 <panic>
    panic("free_desc 2");
    80006278:	00002517          	auipc	a0,0x2
    8000627c:	59850513          	addi	a0,a0,1432 # 80008810 <syscalls+0x318>
    80006280:	ffffa097          	auipc	ra,0xffffa
    80006284:	306080e7          	jalr	774(ra) # 80000586 <panic>

0000000080006288 <virtio_disk_init>:
{
    80006288:	1101                	addi	sp,sp,-32
    8000628a:	ec06                	sd	ra,24(sp)
    8000628c:	e822                	sd	s0,16(sp)
    8000628e:	e426                	sd	s1,8(sp)
    80006290:	e04a                	sd	s2,0(sp)
    80006292:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006294:	00002597          	auipc	a1,0x2
    80006298:	58c58593          	addi	a1,a1,1420 # 80008820 <syscalls+0x328>
    8000629c:	0001c517          	auipc	a0,0x1c
    800062a0:	dbc50513          	addi	a0,a0,-580 # 80022058 <disk+0x128>
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	8e8080e7          	jalr	-1816(ra) # 80000b8c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062ac:	100017b7          	lui	a5,0x10001
    800062b0:	4398                	lw	a4,0(a5)
    800062b2:	2701                	sext.w	a4,a4
    800062b4:	747277b7          	lui	a5,0x74727
    800062b8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800062bc:	14f71b63          	bne	a4,a5,80006412 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800062c0:	100017b7          	lui	a5,0x10001
    800062c4:	43dc                	lw	a5,4(a5)
    800062c6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062c8:	4709                	li	a4,2
    800062ca:	14e79463          	bne	a5,a4,80006412 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062ce:	100017b7          	lui	a5,0x10001
    800062d2:	479c                	lw	a5,8(a5)
    800062d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800062d6:	12e79e63          	bne	a5,a4,80006412 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800062da:	100017b7          	lui	a5,0x10001
    800062de:	47d8                	lw	a4,12(a5)
    800062e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062e2:	554d47b7          	lui	a5,0x554d4
    800062e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800062ea:	12f71463          	bne	a4,a5,80006412 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062ee:	100017b7          	lui	a5,0x10001
    800062f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062f6:	4705                	li	a4,1
    800062f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062fa:	470d                	li	a4,3
    800062fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800062fe:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006300:	c7ffe6b7          	lui	a3,0xc7ffe
    80006304:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc6ef>
    80006308:	8f75                	and	a4,a4,a3
    8000630a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000630c:	472d                	li	a4,11
    8000630e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006310:	5bbc                	lw	a5,112(a5)
    80006312:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006316:	8ba1                	andi	a5,a5,8
    80006318:	10078563          	beqz	a5,80006422 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000631c:	100017b7          	lui	a5,0x10001
    80006320:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006324:	43fc                	lw	a5,68(a5)
    80006326:	2781                	sext.w	a5,a5
    80006328:	10079563          	bnez	a5,80006432 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000632c:	100017b7          	lui	a5,0x10001
    80006330:	5bdc                	lw	a5,52(a5)
    80006332:	2781                	sext.w	a5,a5
  if(max == 0)
    80006334:	10078763          	beqz	a5,80006442 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80006338:	471d                	li	a4,7
    8000633a:	10f77c63          	bgeu	a4,a5,80006452 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000633e:	ffffa097          	auipc	ra,0xffffa
    80006342:	7ee080e7          	jalr	2030(ra) # 80000b2c <kalloc>
    80006346:	0001c497          	auipc	s1,0x1c
    8000634a:	bea48493          	addi	s1,s1,-1046 # 80021f30 <disk>
    8000634e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006350:	ffffa097          	auipc	ra,0xffffa
    80006354:	7dc080e7          	jalr	2012(ra) # 80000b2c <kalloc>
    80006358:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000635a:	ffffa097          	auipc	ra,0xffffa
    8000635e:	7d2080e7          	jalr	2002(ra) # 80000b2c <kalloc>
    80006362:	87aa                	mv	a5,a0
    80006364:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006366:	6088                	ld	a0,0(s1)
    80006368:	cd6d                	beqz	a0,80006462 <virtio_disk_init+0x1da>
    8000636a:	0001c717          	auipc	a4,0x1c
    8000636e:	bce73703          	ld	a4,-1074(a4) # 80021f38 <disk+0x8>
    80006372:	cb65                	beqz	a4,80006462 <virtio_disk_init+0x1da>
    80006374:	c7fd                	beqz	a5,80006462 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006376:	6605                	lui	a2,0x1
    80006378:	4581                	li	a1,0
    8000637a:	ffffb097          	auipc	ra,0xffffb
    8000637e:	99e080e7          	jalr	-1634(ra) # 80000d18 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006382:	0001c497          	auipc	s1,0x1c
    80006386:	bae48493          	addi	s1,s1,-1106 # 80021f30 <disk>
    8000638a:	6605                	lui	a2,0x1
    8000638c:	4581                	li	a1,0
    8000638e:	6488                	ld	a0,8(s1)
    80006390:	ffffb097          	auipc	ra,0xffffb
    80006394:	988080e7          	jalr	-1656(ra) # 80000d18 <memset>
  memset(disk.used, 0, PGSIZE);
    80006398:	6605                	lui	a2,0x1
    8000639a:	4581                	li	a1,0
    8000639c:	6888                	ld	a0,16(s1)
    8000639e:	ffffb097          	auipc	ra,0xffffb
    800063a2:	97a080e7          	jalr	-1670(ra) # 80000d18 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800063a6:	100017b7          	lui	a5,0x10001
    800063aa:	4721                	li	a4,8
    800063ac:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800063ae:	4098                	lw	a4,0(s1)
    800063b0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800063b4:	40d8                	lw	a4,4(s1)
    800063b6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800063ba:	6498                	ld	a4,8(s1)
    800063bc:	0007069b          	sext.w	a3,a4
    800063c0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800063c4:	9701                	srai	a4,a4,0x20
    800063c6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800063ca:	6898                	ld	a4,16(s1)
    800063cc:	0007069b          	sext.w	a3,a4
    800063d0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800063d4:	9701                	srai	a4,a4,0x20
    800063d6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800063da:	4705                	li	a4,1
    800063dc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800063de:	00e48c23          	sb	a4,24(s1)
    800063e2:	00e48ca3          	sb	a4,25(s1)
    800063e6:	00e48d23          	sb	a4,26(s1)
    800063ea:	00e48da3          	sb	a4,27(s1)
    800063ee:	00e48e23          	sb	a4,28(s1)
    800063f2:	00e48ea3          	sb	a4,29(s1)
    800063f6:	00e48f23          	sb	a4,30(s1)
    800063fa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800063fe:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006402:	0727a823          	sw	s2,112(a5)
}
    80006406:	60e2                	ld	ra,24(sp)
    80006408:	6442                	ld	s0,16(sp)
    8000640a:	64a2                	ld	s1,8(sp)
    8000640c:	6902                	ld	s2,0(sp)
    8000640e:	6105                	addi	sp,sp,32
    80006410:	8082                	ret
    panic("could not find virtio disk");
    80006412:	00002517          	auipc	a0,0x2
    80006416:	41e50513          	addi	a0,a0,1054 # 80008830 <syscalls+0x338>
    8000641a:	ffffa097          	auipc	ra,0xffffa
    8000641e:	16c080e7          	jalr	364(ra) # 80000586 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006422:	00002517          	auipc	a0,0x2
    80006426:	42e50513          	addi	a0,a0,1070 # 80008850 <syscalls+0x358>
    8000642a:	ffffa097          	auipc	ra,0xffffa
    8000642e:	15c080e7          	jalr	348(ra) # 80000586 <panic>
    panic("virtio disk should not be ready");
    80006432:	00002517          	auipc	a0,0x2
    80006436:	43e50513          	addi	a0,a0,1086 # 80008870 <syscalls+0x378>
    8000643a:	ffffa097          	auipc	ra,0xffffa
    8000643e:	14c080e7          	jalr	332(ra) # 80000586 <panic>
    panic("virtio disk has no queue 0");
    80006442:	00002517          	auipc	a0,0x2
    80006446:	44e50513          	addi	a0,a0,1102 # 80008890 <syscalls+0x398>
    8000644a:	ffffa097          	auipc	ra,0xffffa
    8000644e:	13c080e7          	jalr	316(ra) # 80000586 <panic>
    panic("virtio disk max queue too short");
    80006452:	00002517          	auipc	a0,0x2
    80006456:	45e50513          	addi	a0,a0,1118 # 800088b0 <syscalls+0x3b8>
    8000645a:	ffffa097          	auipc	ra,0xffffa
    8000645e:	12c080e7          	jalr	300(ra) # 80000586 <panic>
    panic("virtio disk kalloc");
    80006462:	00002517          	auipc	a0,0x2
    80006466:	46e50513          	addi	a0,a0,1134 # 800088d0 <syscalls+0x3d8>
    8000646a:	ffffa097          	auipc	ra,0xffffa
    8000646e:	11c080e7          	jalr	284(ra) # 80000586 <panic>

0000000080006472 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006472:	7119                	addi	sp,sp,-128
    80006474:	fc86                	sd	ra,120(sp)
    80006476:	f8a2                	sd	s0,112(sp)
    80006478:	f4a6                	sd	s1,104(sp)
    8000647a:	f0ca                	sd	s2,96(sp)
    8000647c:	ecce                	sd	s3,88(sp)
    8000647e:	e8d2                	sd	s4,80(sp)
    80006480:	e4d6                	sd	s5,72(sp)
    80006482:	e0da                	sd	s6,64(sp)
    80006484:	fc5e                	sd	s7,56(sp)
    80006486:	f862                	sd	s8,48(sp)
    80006488:	f466                	sd	s9,40(sp)
    8000648a:	f06a                	sd	s10,32(sp)
    8000648c:	ec6e                	sd	s11,24(sp)
    8000648e:	0100                	addi	s0,sp,128
    80006490:	8aaa                	mv	s5,a0
    80006492:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006494:	00c52d03          	lw	s10,12(a0)
    80006498:	001d1d1b          	slliw	s10,s10,0x1
    8000649c:	1d02                	slli	s10,s10,0x20
    8000649e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800064a2:	0001c517          	auipc	a0,0x1c
    800064a6:	bb650513          	addi	a0,a0,-1098 # 80022058 <disk+0x128>
    800064aa:	ffffa097          	auipc	ra,0xffffa
    800064ae:	772080e7          	jalr	1906(ra) # 80000c1c <acquire>
  for(int i = 0; i < 3; i++){
    800064b2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800064b4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800064b6:	0001cb97          	auipc	s7,0x1c
    800064ba:	a7ab8b93          	addi	s7,s7,-1414 # 80021f30 <disk>
  for(int i = 0; i < 3; i++){
    800064be:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800064c0:	0001cc97          	auipc	s9,0x1c
    800064c4:	b98c8c93          	addi	s9,s9,-1128 # 80022058 <disk+0x128>
    800064c8:	a08d                	j	8000652a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800064ca:	00fb8733          	add	a4,s7,a5
    800064ce:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800064d2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800064d4:	0207c563          	bltz	a5,800064fe <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800064d8:	2905                	addiw	s2,s2,1
    800064da:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800064dc:	05690c63          	beq	s2,s6,80006534 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800064e0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800064e2:	0001c717          	auipc	a4,0x1c
    800064e6:	a4e70713          	addi	a4,a4,-1458 # 80021f30 <disk>
    800064ea:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800064ec:	01874683          	lbu	a3,24(a4)
    800064f0:	fee9                	bnez	a3,800064ca <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800064f2:	2785                	addiw	a5,a5,1
    800064f4:	0705                	addi	a4,a4,1
    800064f6:	fe979be3          	bne	a5,s1,800064ec <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800064fa:	57fd                	li	a5,-1
    800064fc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800064fe:	01205d63          	blez	s2,80006518 <virtio_disk_rw+0xa6>
    80006502:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006504:	000a2503          	lw	a0,0(s4)
    80006508:	00000097          	auipc	ra,0x0
    8000650c:	cfe080e7          	jalr	-770(ra) # 80006206 <free_desc>
      for(int j = 0; j < i; j++)
    80006510:	2d85                	addiw	s11,s11,1
    80006512:	0a11                	addi	s4,s4,4
    80006514:	ff2d98e3          	bne	s11,s2,80006504 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006518:	85e6                	mv	a1,s9
    8000651a:	0001c517          	auipc	a0,0x1c
    8000651e:	a2e50513          	addi	a0,a0,-1490 # 80021f48 <disk+0x18>
    80006522:	ffffc097          	auipc	ra,0xffffc
    80006526:	f0a080e7          	jalr	-246(ra) # 8000242c <sleep>
  for(int i = 0; i < 3; i++){
    8000652a:	f8040a13          	addi	s4,s0,-128
{
    8000652e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006530:	894e                	mv	s2,s3
    80006532:	b77d                	j	800064e0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006534:	f8042503          	lw	a0,-128(s0)
    80006538:	00a50713          	addi	a4,a0,10
    8000653c:	0712                	slli	a4,a4,0x4

  if(write)
    8000653e:	0001c797          	auipc	a5,0x1c
    80006542:	9f278793          	addi	a5,a5,-1550 # 80021f30 <disk>
    80006546:	00e786b3          	add	a3,a5,a4
    8000654a:	01803633          	snez	a2,s8
    8000654e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006550:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006554:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006558:	f6070613          	addi	a2,a4,-160
    8000655c:	6394                	ld	a3,0(a5)
    8000655e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006560:	00870593          	addi	a1,a4,8
    80006564:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006566:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006568:	0007b803          	ld	a6,0(a5)
    8000656c:	9642                	add	a2,a2,a6
    8000656e:	46c1                	li	a3,16
    80006570:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006572:	4585                	li	a1,1
    80006574:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006578:	f8442683          	lw	a3,-124(s0)
    8000657c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006580:	0692                	slli	a3,a3,0x4
    80006582:	9836                	add	a6,a6,a3
    80006584:	058a8613          	addi	a2,s5,88
    80006588:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000658c:	0007b803          	ld	a6,0(a5)
    80006590:	96c2                	add	a3,a3,a6
    80006592:	40000613          	li	a2,1024
    80006596:	c690                	sw	a2,8(a3)
  if(write)
    80006598:	001c3613          	seqz	a2,s8
    8000659c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800065a0:	00166613          	ori	a2,a2,1
    800065a4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800065a8:	f8842603          	lw	a2,-120(s0)
    800065ac:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800065b0:	00250693          	addi	a3,a0,2
    800065b4:	0692                	slli	a3,a3,0x4
    800065b6:	96be                	add	a3,a3,a5
    800065b8:	58fd                	li	a7,-1
    800065ba:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800065be:	0612                	slli	a2,a2,0x4
    800065c0:	9832                	add	a6,a6,a2
    800065c2:	f9070713          	addi	a4,a4,-112
    800065c6:	973e                	add	a4,a4,a5
    800065c8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800065cc:	6398                	ld	a4,0(a5)
    800065ce:	9732                	add	a4,a4,a2
    800065d0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800065d2:	4609                	li	a2,2
    800065d4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800065d8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800065dc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800065e0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800065e4:	6794                	ld	a3,8(a5)
    800065e6:	0026d703          	lhu	a4,2(a3)
    800065ea:	8b1d                	andi	a4,a4,7
    800065ec:	0706                	slli	a4,a4,0x1
    800065ee:	96ba                	add	a3,a3,a4
    800065f0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800065f4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800065f8:	6798                	ld	a4,8(a5)
    800065fa:	00275783          	lhu	a5,2(a4)
    800065fe:	2785                	addiw	a5,a5,1
    80006600:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006604:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006608:	100017b7          	lui	a5,0x10001
    8000660c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006610:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80006614:	0001c917          	auipc	s2,0x1c
    80006618:	a4490913          	addi	s2,s2,-1468 # 80022058 <disk+0x128>
  while(b->disk == 1) {
    8000661c:	4485                	li	s1,1
    8000661e:	00b79c63          	bne	a5,a1,80006636 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006622:	85ca                	mv	a1,s2
    80006624:	8556                	mv	a0,s5
    80006626:	ffffc097          	auipc	ra,0xffffc
    8000662a:	e06080e7          	jalr	-506(ra) # 8000242c <sleep>
  while(b->disk == 1) {
    8000662e:	004aa783          	lw	a5,4(s5)
    80006632:	fe9788e3          	beq	a5,s1,80006622 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006636:	f8042903          	lw	s2,-128(s0)
    8000663a:	00290713          	addi	a4,s2,2
    8000663e:	0712                	slli	a4,a4,0x4
    80006640:	0001c797          	auipc	a5,0x1c
    80006644:	8f078793          	addi	a5,a5,-1808 # 80021f30 <disk>
    80006648:	97ba                	add	a5,a5,a4
    8000664a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000664e:	0001c997          	auipc	s3,0x1c
    80006652:	8e298993          	addi	s3,s3,-1822 # 80021f30 <disk>
    80006656:	00491713          	slli	a4,s2,0x4
    8000665a:	0009b783          	ld	a5,0(s3)
    8000665e:	97ba                	add	a5,a5,a4
    80006660:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006664:	854a                	mv	a0,s2
    80006666:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000666a:	00000097          	auipc	ra,0x0
    8000666e:	b9c080e7          	jalr	-1124(ra) # 80006206 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006672:	8885                	andi	s1,s1,1
    80006674:	f0ed                	bnez	s1,80006656 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006676:	0001c517          	auipc	a0,0x1c
    8000667a:	9e250513          	addi	a0,a0,-1566 # 80022058 <disk+0x128>
    8000667e:	ffffa097          	auipc	ra,0xffffa
    80006682:	652080e7          	jalr	1618(ra) # 80000cd0 <release>
}
    80006686:	70e6                	ld	ra,120(sp)
    80006688:	7446                	ld	s0,112(sp)
    8000668a:	74a6                	ld	s1,104(sp)
    8000668c:	7906                	ld	s2,96(sp)
    8000668e:	69e6                	ld	s3,88(sp)
    80006690:	6a46                	ld	s4,80(sp)
    80006692:	6aa6                	ld	s5,72(sp)
    80006694:	6b06                	ld	s6,64(sp)
    80006696:	7be2                	ld	s7,56(sp)
    80006698:	7c42                	ld	s8,48(sp)
    8000669a:	7ca2                	ld	s9,40(sp)
    8000669c:	7d02                	ld	s10,32(sp)
    8000669e:	6de2                	ld	s11,24(sp)
    800066a0:	6109                	addi	sp,sp,128
    800066a2:	8082                	ret

00000000800066a4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800066a4:	1101                	addi	sp,sp,-32
    800066a6:	ec06                	sd	ra,24(sp)
    800066a8:	e822                	sd	s0,16(sp)
    800066aa:	e426                	sd	s1,8(sp)
    800066ac:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800066ae:	0001c497          	auipc	s1,0x1c
    800066b2:	88248493          	addi	s1,s1,-1918 # 80021f30 <disk>
    800066b6:	0001c517          	auipc	a0,0x1c
    800066ba:	9a250513          	addi	a0,a0,-1630 # 80022058 <disk+0x128>
    800066be:	ffffa097          	auipc	ra,0xffffa
    800066c2:	55e080e7          	jalr	1374(ra) # 80000c1c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800066c6:	10001737          	lui	a4,0x10001
    800066ca:	533c                	lw	a5,96(a4)
    800066cc:	8b8d                	andi	a5,a5,3
    800066ce:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800066d0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800066d4:	689c                	ld	a5,16(s1)
    800066d6:	0204d703          	lhu	a4,32(s1)
    800066da:	0027d783          	lhu	a5,2(a5)
    800066de:	04f70863          	beq	a4,a5,8000672e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800066e2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800066e6:	6898                	ld	a4,16(s1)
    800066e8:	0204d783          	lhu	a5,32(s1)
    800066ec:	8b9d                	andi	a5,a5,7
    800066ee:	078e                	slli	a5,a5,0x3
    800066f0:	97ba                	add	a5,a5,a4
    800066f2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800066f4:	00278713          	addi	a4,a5,2
    800066f8:	0712                	slli	a4,a4,0x4
    800066fa:	9726                	add	a4,a4,s1
    800066fc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006700:	e721                	bnez	a4,80006748 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006702:	0789                	addi	a5,a5,2
    80006704:	0792                	slli	a5,a5,0x4
    80006706:	97a6                	add	a5,a5,s1
    80006708:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000670a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000670e:	ffffc097          	auipc	ra,0xffffc
    80006712:	d82080e7          	jalr	-638(ra) # 80002490 <wakeup>

    disk.used_idx += 1;
    80006716:	0204d783          	lhu	a5,32(s1)
    8000671a:	2785                	addiw	a5,a5,1
    8000671c:	17c2                	slli	a5,a5,0x30
    8000671e:	93c1                	srli	a5,a5,0x30
    80006720:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006724:	6898                	ld	a4,16(s1)
    80006726:	00275703          	lhu	a4,2(a4)
    8000672a:	faf71ce3          	bne	a4,a5,800066e2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000672e:	0001c517          	auipc	a0,0x1c
    80006732:	92a50513          	addi	a0,a0,-1750 # 80022058 <disk+0x128>
    80006736:	ffffa097          	auipc	ra,0xffffa
    8000673a:	59a080e7          	jalr	1434(ra) # 80000cd0 <release>
}
    8000673e:	60e2                	ld	ra,24(sp)
    80006740:	6442                	ld	s0,16(sp)
    80006742:	64a2                	ld	s1,8(sp)
    80006744:	6105                	addi	sp,sp,32
    80006746:	8082                	ret
      panic("virtio_disk_intr status");
    80006748:	00002517          	auipc	a0,0x2
    8000674c:	1a050513          	addi	a0,a0,416 # 800088e8 <syscalls+0x3f0>
    80006750:	ffffa097          	auipc	ra,0xffffa
    80006754:	e36080e7          	jalr	-458(ra) # 80000586 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
