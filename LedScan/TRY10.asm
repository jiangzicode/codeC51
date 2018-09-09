TL2 EQU 0CCH								;×Ô¼º¼ÓÉÏÈ¥µÄ

TH2 EQU 0CDH								;×Ô¼º¼ÓÉÏÈ¥µÄ

RCAP2L EQU 0CAH							;×Ô¼º¼ÓÉÏÈ¥µÄ

RCAP2H EQU 0CBH							;×Ô¼º¼ÓÉÏÈ¥µÄ

ET2 EQU 0ADH								;×Ô¼º¼ÓÉÏÈ¥µÄ

T2CON EQU 0C8H							;×Ô¼º¼ÓÉÏÈ¥µÄ

TF2	EQU 0CFH



LEDBUF1		EQU		70H				;ÊýÂëÏÔÊ¾»º³åÇø£¨ÎªÁËµ÷ÊÔ·½±ã£¬¸ßÎ»´æ·ÅÔÚµÍµØÖ·ÖÐ£©

LEDBUF2		EQU		78H				;±Ê¶Î´úÂë»º³åÇø£¨²ÉÓÃË«»º³åÇø½á¹¹£©

LEDSP			DATA		6FH				;LEDÎ»É¨ÃèÖ¸Õë

NDHZ			BIT			08H				;ÃðÁã±êÖ¾

ORG 0000H

LJMP MAIN

ORG 002BH

LJMP CTC2

ORG 100H

MAIN:

MOV SP,#7FH

MOV SP,#5FH									;¶ÔÓÚÖ»ÓÐÇ°128×Ö½ÚµÄÄÚ²¿ramÐ¾Æ¬À´Ëµ£¬½«60H~70H,¹²¼Æ32×Ö½Ú×÷Îª¶ÑÕ»Çø

MOV R0,#01H									;¸´Î»ºó£¬½«01H~0FFHÄÚ²¿RAMµ¥ÔªÇåÁã

LOOP1:

		MOV @R0,#0
		
		INC R0
		
		CJNE R0,#0,LOOP1
	
		
		;³õÊ¼»¯¶¨Ê±Æ÷
		
		
		MOV TH2,#00H
		
		MOV TL2,#00H
		
		MOV RCAP2H,#00H
		
		MOV RCAP2L,#00H
		
		MOV T2CON,#00000100B
		
		;³õÊ¼»¯ÖÐ¶Ï¿ØÖÆÆ÷
		
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

;°ÑÏÔÊ¾»º³åÇøÄÚ´ýÏÔÊ¾ÊýÂë×ª»»Îª±Ê¶ÎÂë,²¢´æ·ÅÔÚ±Ê¶ÎÂë»º³åÇø£¨¼ì²é¸ßÎ»ÊÇ·ñÎªÁã£¬ÈôÊÇÒªÃðÁã£©

		
DISPC:
		
		MOV R0,#LEDBUF1				;ÊýÂë»º³åÇøÊ×µØÖ¹ËÍR0
		
		MOV R1,#LEDBUF2				;±Ê¶ÎÂë»º³åÇøÊ×µØÖ¹ËÍR1
		
		MOV R2,#7							;¼ÇÂ¼×ªÒÆÎ»
		
		MOV DPTR,#DISPTAB			;°Ñ¹²Ñô¼«ÊýÂë¹Ü±Ê¶ÎÂë±íÊ×µØÖ¹×°ÈëDPTRÖ¸Õë
		
		SETB NDHZ							;ÃðÁã±êÖ¾ÖÃ1
		
		LOOP11:

		MOV A,@R0							;È¡ÏÔÊ¾ÊýÂë
		
		JNB NDHZ,NEXT11
		
		;ÃðÁã±êÖ¾ÓÐÐ§£¬ËµÃ÷¸ßÎ»ÎªÁã£¬Òª¼ì²éÊýÂëÊÇ·ñÎªÁã
		
		CJNE A,#0,NEXT22
		
		;±¾Î»ÊýÂëÎªÁã£¬²»ÏÔÊ¾
		
		MOV @R1,#0FFH					;Ö±½ÓËÍFFÂð
		
		LJMP NEXT33
		
		NEXT22:

		CLR NDHZ							;¸ßÎ»ÎªÁã£¬µ«±¾Î»²»ÊÇÁã£¬ÒªÇåÃðÁã±êÖ¾
		
		NEXT11:

		MOVC A,@A+DPTR
		
		MOV @R1,A							;±Ê¶ËÊýÂëËÍ±Ê¶ËÊýÂëÏÔÊ¾»º³åÇø
		
		NEXT33:

		INC R0
		
		INC R1
		
		DJNZ R2,LOOP11					;Ñ­»·Ö±µ½Ê®Î»
		
		MOV A,@R0							;È¡ÏÔÊ¾ÊýÂë
		
		MOVC A,@A+DPTR
		
		MOV @R1,A							;±Ê¶ËÊýÂëËÍ±ÊÂëÏÔÊ¾»º³åÇø
		
		RET
		
;¶¨Ê±Æ÷T2×÷ÏÔÊ¾¶¨Ê±Æ÷£¨Òç³öÊ±¼ä2.5ºÁÃë£¬×Ô¶¯ÖØ×°³õÖµ·½Ê½£©

CTC2:

		PUSH PSW
		
		PUSH ACC
		
		SETB RS1
		
		SETB RS0
		
		MOV P0,#0FFH
		
		MOV P2,#0FFH
		
		MOV A,LEDSP						;È¡Î»É¨ÃèÖ¸Õë
		
		ANL A,#07H						;½ö±£ÁôµÍÈýÎ»
				

		
		ADD A,#LEDBUF2				;Óë±Ê¶ÎÂë»º³åÇøÊ×µØÖ¹Ïà¼Ó£¬ÒÔ±ã»ñµÃ±Ê¶ÎÂëµØÖ·
		
				MOV R0,A							;ÏàÓ¦Î»±Ê¶ËµØÖ·±£´æÔÚR0ÖÐë
MOV P2,@R0								;±Ê¶ÎÂëËÍP2¿Ú

;ËÍÉ¨ÃèÂë

MOV A,LEDSP

ANL A,#07H								;½ö±£ÁôµÍÈýÎ»

CJNE A,#7,NEXT1

MOV P0,#01111111B					;Êä³öÎ»É¨ÃèÂð£¨P0.7Î»ÁÁ£©

SJMP EXIT

NEXT1:

     CJNE A,#6,NEXT2
		 
		 MOV P0,#10111111B		;Êä³öÎ»É¨ÃèÂð£¨P0.6Î»ÁÁ£©
		 
		 SJMP EXIT
		 
NEXT2:

		 CJNE A,#5,NEXT3
		 
		 MOV P0,#11011111B		;Êä³öÉ¨ÃèÂë£¨P0.5Î»ÁÁ£©
		 
		 SJMP EXIT
		 
NEXT3:

		 CJNE A,#4,NEXT4
		 
		 MOV P0,#11101111B		;()P0.4ÁÁ
		 
		 SJMP EXIT
		 
NEXT4:

     CJNE A,#3,NEXT5
		 
		 MOV P0,#11110111B		;p0.3ÁÁ
		 
		 SJMP EXIT
		 
NEXT5:

     CJNE A,#2,NEXT6
		 
		 MOV P0,#11111011B		;p0.2ÁÁ
		 
		 SJMP EXIT
		 
NEXT6:

     CJNE A,#1,NEXT7
		 
		 MOV P0,#11111101B		;p0.1ÁÁ
		 
		 SJMP EXIT
		 
NEXT7:

     MOV P0,#11111110B		;p0.0ÁÁ
		 
EXIT:

		 INC LEDSP						;Ö¸Õë¼ÓÒ»
		 
		 CLR TF2
		 
		 POP ACC
		 
		 POP PSW
		 
		 RETI
END
		 






