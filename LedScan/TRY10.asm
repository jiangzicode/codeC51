TL2 EQU 0CCH								;自己加上去的

TH2 EQU 0CDH								;自己加上去的

RCAP2L EQU 0CAH							;自己加上去的

RCAP2H EQU 0CBH							;自己加上去的

ET2 EQU 0ADH								;自己加上去的

T2CON EQU 0C8H							;自己加上去的

TF2	EQU 0CFH



LEDBUF1		EQU		70H				;数码显示缓冲区（为了调试方便，高位存放在低地址中）

LEDBUF2		EQU		78H				;笔段代码缓冲区（采用双缓冲区结构）

LEDSP			DATA		6FH				;LED位扫描指针

NDHZ			BIT			08H				;灭零标志

ORG 0000H

	LJMP MAIN
	
ORG 002BH

	LJMP CTC2									;定时器2中断入口地址

ORG 100H

MAIN:
        MOV SP,#7FH

        MOV SP,#5FH									;对于只有前128字节的内部ram芯片来说，将60H~70H,共计32字节作为堆栈区

		MOV R0,#01H									;复位后，将01H~0FFH内部RAM单元清零

LOOP1:

MOV @R0,#0

INC R0

CJNE R0,#0,LOOP1


;初始化定时器


MOV TH2,#00H

MOV TL2,#00H

MOV RCAP2H,#00H

MOV RCAP2L,#00H

MOV T2CON,#00000100B

;初始化中断控制器

SETB ET2

SETB EA


[�
DISPTAB:

DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H,88H,83H,0C6H,0A1H,86H,8EH

;把显示缓冲区内待显示数码转换为笔段码,并存放在笔段码缓冲区（检查高位是否为零，若是要灭零）

		
DISPC:
		
		MOV R0,#LEDBUF1				;数码缓冲区首地止送R0
		
		MOV R1,#LEDBUF2				;笔段码缓冲区首地止送R1
		
		MOV R2,#7							;记录转移位
		
		MOV DPTR,#DISPTAB			;把共阳极数码管笔段码表首地止装入DPTR指针
		
		SETB NDHZ							;灭零标志置1
		
		LOOP11:

		MOV A,@R0							;取显示数码
		
		JNB NDHZ,NEXT11
		
		;灭零标志有效，说明高位为零，要检查数码是否为零
		
		CJNE A,#0,NEXT22
		
		;本位数码为零，不显示
		
		MOV @R1,#0FFH					;直接送FF吗
		
		LJMP NEXT33
		
		NEXT22:

		CLR NDHZ							;高位为零，但本位不是零，要清灭零标志
		
		NEXT11:

		MOVC A,@A+DPTR
		
		MOV @R1,A							;笔端数码送笔端数码显示缓冲区
		
		NEXT33:

		INC R0
		
		INC R1
		
		DJNZ R2,LOOP11					;循环直到十位
		
		MOV A,@R0							;取显示数码
		
		MOVC A,@A+DPTR
		
                                                		MOV @R1,A							;笔端数码送笔码显示缓冲区
                                                		
                                                		RET
		
;定时器T2作显示定时器（溢出时间2.5毫秒，自动重装初值方式）

CTC2:

		PUSH PSW
		
		PUSH ACC
		
		SETB RS1
		
		SETB RS0
		
		MOV P0,#0FFH
		
		MOV P2,#0FFH
		
		MOV A,LEDSP						;取位扫描指针
		
		ANL A,#07H						;仅保留低三位
				

		
		ADD A,#LEDBUF2				;与笔段码缓冲区首地止相加，以便获得笔段码地址
		
		MOV R0,A							;相应位笔端地址保存在R0中�
		
		MOV P2,@R0								;笔段码送P2口

		;送扫描码

		MOV A,LEDSP

		ANL A,#07H								;仅保留低三位

		CJNE A,#7,NEXT1

		MOV P0,#01111111B					;输出位扫描吗（P0.7位亮）

		SJMP EXIT

NEXT1:

     CJNE A,#6,NEXT2
		 
		 MOV P0,#10111111B		;输出位扫描吗（P0.6位亮）
		 
		 SJMP EXIT
		 
NEXT2:

		 CJNE A,#5,NEXT3
		 
		 MOV P0,#11011111B		;输出扫描码（P0.5位亮）
		 
		 SJMP EXIT
		 
NEXT3:

		 CJNE A,#4,NEXT4
		 
		 MOV P0,#11101111B		;()P0.4亮
		 
		 SJMP EXIT
		 
NEXT4:

     CJNE A,#3,NEXT5
		 
		 MOV P0,#11110111B		;p0.3亮
		 
		 SJMP EXIT
		 
NEXT5:

     CJNE A,#2,NEXT6
		 
		 MOV P0,#11111011B		;p0.2亮
		 
		 SJMP EXIT
		 
NEXT6:

     CJNE A,#1,NEXT7
		 
		 MOV P0,#11111101B		;p0.1亮
		 
		 SJMP EXIT
		 
NEXT7:

     MOV P0,#11111110B		;p0.0亮
		 
EXIT:

		 INC LEDSP						;指针加一
		 
		 CLR TF2
		 
		 POP ACC
		 
		 POP PSW
		 
		 RETI
END
		 






