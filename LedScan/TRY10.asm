TL2 EQU 0CCH								;�Լ�����ȥ��

TH2 EQU 0CDH								;�Լ�����ȥ��

RCAP2L EQU 0CAH							;�Լ�����ȥ��

RCAP2H EQU 0CBH							;�Լ�����ȥ��

ET2 EQU 0ADH								;�Լ�����ȥ��

T2CON EQU 0C8H							;�Լ�����ȥ��

TF2	EQU 0CFH



LEDBUF1		EQU		70H				;������ʾ��������Ϊ�˵��Է��㣬��λ����ڵ͵�ַ�У�

LEDBUF2		EQU		78H				;�ʶδ��뻺����������˫�������ṹ��

LEDSP			DATA		6FH				;LEDλɨ��ָ��

NDHZ			BIT			08H				;�����־

ORG 0000H

LJMP MAIN

ORG 002BH

LJMP CTC2

ORG 100H

MAIN:

MOV SP,#7FH

MOV SP,#5FH									;����ֻ��ǰ128�ֽڵ��ڲ�ramоƬ��˵����60H~70H,����32�ֽ���Ϊ��ջ��

MOV R0,#01H									;��λ�󣬽�01H~0FFH�ڲ�RAM��Ԫ����

LOOP1:

		MOV @R0,#0
		
		INC R0
		
		CJNE R0,#0,LOOP1
	
		
		;��ʼ����ʱ��
		
		
		MOV TH2,#00H
		
		MOV TL2,#00H
		
		MOV RCAP2H,#00H
		
		MOV RCAP2L,#00H
		
		MOV T2CON,#00000100B
		
		;��ʼ���жϿ�����
		
		SETB ET2
		
		SETB EA
		

		
		HERE: 
		MOV 70H,#6
		MOV 71H,#6
		MOV 72H,#0
		MOV 73H,#6
		MOV 74H,#1
		MOV 75H,#6
		MOV 76H,#6
		MOV 77H,#6
		
		LCALL DISPC
		SJMP HERE
		
DISPTAB:

DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H,88H,83H,0C6H,0A1H,86H,8EH

;����ʾ�������ڴ���ʾ����ת��Ϊ�ʶ���,������ڱʶ��뻺����������λ�Ƿ�Ϊ�㣬����Ҫ���㣩

		
DISPC:
		
		MOV R0,#LEDBUF1				;���뻺�����׵�ֹ��R0
		
		MOV R1,#LEDBUF2				;�ʶ��뻺�����׵�ֹ��R1
		
		MOV R2,#7							;��¼ת��λ
		
		MOV DPTR,#DISPTAB			;�ѹ���������ܱʶ�����׵�ֹװ��DPTRָ��
		
		SETB NDHZ							;�����־��1
		
		LOOP11:

		MOV A,@R0							;ȡ��ʾ����
		
		JNB NDHZ,NEXT11
		
		;�����־��Ч��˵����λΪ�㣬Ҫ��������Ƿ�Ϊ��
		
		CJNE A,#0,NEXT22
		
		;��λ����Ϊ�㣬����ʾ
		
		MOV @R1,#0FFH					;ֱ����FF��
		
		LJMP NEXT33
		
		NEXT22:

		CLR NDHZ							;��λΪ�㣬����λ�����㣬Ҫ�������־
		
		NEXT11:

		MOVC A,@A+DPTR
		
		MOV @R1,A							;�ʶ������ͱʶ�������ʾ������
		
		NEXT33:

		INC R0
		
		INC R1
		
		DJNZ R2,LOOP11					;ѭ��ֱ��ʮλ
		
		MOV A,@R0							;ȡ��ʾ����
		
		MOVC A,@A+DPTR
		
		MOV @R1,A							;�ʶ������ͱ�����ʾ������
		
		RET
		
;��ʱ��T2����ʾ��ʱ�������ʱ��2.5���룬�Զ���װ��ֵ��ʽ��

CTC2:

		PUSH PSW
		
		PUSH ACC
		
		SETB RS1
		
		SETB RS0
		
		MOV P0,#0FFH
		
		MOV P2,#0FFH
		
		MOV A,LEDSP						;ȡλɨ��ָ��
		
		ANL A,#07H						;����������λ
				

		
		ADD A,#LEDBUF2				;��ʶ��뻺�����׵�ֹ��ӣ��Ա��ñʶ����ַ
		
				MOV R0,A							;��Ӧλ�ʶ˵�ַ������R0���
MOV P2,@R0								;�ʶ�����P2��

;��ɨ����

MOV A,LEDSP

ANL A,#07H								;����������λ

CJNE A,#7,NEXT1

MOV P0,#01111111B					;���λɨ����P0.7λ����

SJMP EXIT

NEXT1:

     CJNE A,#6,NEXT2
		 
		 MOV P0,#10111111B		;���λɨ����P0.6λ����
		 
		 SJMP EXIT
		 
NEXT2:

		 CJNE A,#5,NEXT3
		 
		 MOV P0,#11011111B		;���ɨ���루P0.5λ����
		 
		 SJMP EXIT
		 
NEXT3:

		 CJNE A,#4,NEXT4
		 
		 MOV P0,#11101111B		;()P0.4��
		 
		 SJMP EXIT
		 
NEXT4:

     CJNE A,#3,NEXT5
		 
		 MOV P0,#11110111B		;p0.3��
		 
		 SJMP EXIT
		 
NEXT5:

     CJNE A,#2,NEXT6
		 
		 MOV P0,#11111011B		;p0.2��
		 
		 SJMP EXIT
		 
NEXT6:

     CJNE A,#1,NEXT7
		 
		 MOV P0,#11111101B		;p0.1��
		 
		 SJMP EXIT
		 
NEXT7:

     MOV P0,#11111110B		;p0.0��
		 
EXIT:

		 INC LEDSP						;ָ���һ
		 
		 CLR TF2
		 
		 POP ACC
		 
		 POP PSW
		 
		 RETI
END
		 






