
;CodeVisionAVR C Compiler V3.10 Evaluation
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64A
;Program type           : Application
;Clock frequency        : 7,372800 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64A
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _CurrentMenu=R4
	.DEF _CurrentMenu_msb=R5
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_compc_isr
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M1_1),HIGH(_M1_1),LOW(_M2),HIGH(_M2)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x4:
	.DB  LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M1),HIGH(_M1),LOW(_M2_1),HIGH(_M2_1),LOW(_M3),HIGH(_M3)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x5:
	.DB  LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M2),HIGH(_M2),LOW(_M3_1),HIGH(_M3_1),LOW(_Null_Menu),HIGH(_Null_Menu)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x6:
	.DB  LOW(_M1),HIGH(_M1),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M1_2),HIGH(_M1_2)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x7:
	.DB  LOW(_M1),HIGH(_M1),LOW(_M1_1),HIGH(_M1_1),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M1_3),HIGH(_M1_3)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x8:
	.DB  LOW(_M3),HIGH(_M3),LOW(_M1_1),HIGH(_M1_1),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x9:
	.DB  LOW(_M2),HIGH(_M2),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M2_1_1),HIGH(_M2_1_1),LOW(_M2_2),HIGH(_M2_2)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0xA:
	.DB  LOW(_M2),HIGH(_M2),LOW(_M2_1),HIGH(_M2_1),LOW(_M2_2_1),HIGH(_M2_2_1),LOW(_M2_3),HIGH(_M2_3)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0xB:
	.DB  LOW(_M2),HIGH(_M2),LOW(_M2_2),HIGH(_M2_2),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0xC:
	.DB  LOW(_M3),HIGH(_M3),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M3_2),HIGH(_M3_2)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0xD:
	.DB  LOW(_M3),HIGH(_M3),LOW(_M3_1),HIGH(_M3_1),LOW(_M3_2_1),HIGH(_M3_2_1),LOW(_Null_Menu),HIGH(_Null_Menu)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0xE:
	.DB  LOW(_M2_1),HIGH(_M2_1),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M2_1_2),HIGH(_M2_1_2)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0xF:
	.DB  LOW(_M2_1),HIGH(_M2_1),LOW(_M2_1_1),HIGH(_M2_1_1),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x10:
	.DB  LOW(_M2_2),HIGH(_M2_2),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu)
	.DB  LOW(_DefaultMenuHandler),HIGH(_DefaultMenuHandler),0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x11:
	.DB  LOW(_M3_2),HIGH(_M3_2),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M3_2_2),HIGH(_M3_2_2)
	.DB  0x0,0x0,0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x12:
	.DB  LOW(_M3_2),HIGH(_M3_2),LOW(_M3_2_1),HIGH(_M3_2_1),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_M3_2_3),HIGH(_M3_2_3)
	.DB  0x0,0x0,0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x13:
	.DB  LOW(_M3_2),HIGH(_M3_2),LOW(_M3_2_2),HIGH(_M3_2_2),LOW(_Null_Menu),HIGH(_Null_Menu),LOW(_Null_Menu),HIGH(_Null_Menu)
	.DB  0x0,0x0,0x54,0x6F,0x70,0x4C,0x65,0x66
	.DB  0x74
_0x14:
	.DB  0x3A,0x0,0x22,0x0,0x3B,0x0,0x23,0x0
	.DB  0x39,0x0,0x21,0x0
_0x64:
	.DB  0x2,0x0,0x2,0x0,0x2,0x0,0x2,0x0
	.DB  0x2,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x11
	.DW  _M1
	.DW  _0x3*2

	.DW  0x11
	.DW  _M2
	.DW  _0x4*2

	.DW  0x11
	.DW  _M3
	.DW  _0x5*2

	.DW  0x11
	.DW  _M1_1
	.DW  _0x6*2

	.DW  0x11
	.DW  _M1_2
	.DW  _0x7*2

	.DW  0x11
	.DW  _M1_3
	.DW  _0x8*2

	.DW  0x11
	.DW  _M2_1
	.DW  _0x9*2

	.DW  0x11
	.DW  _M2_2
	.DW  _0xA*2

	.DW  0x11
	.DW  _M2_3
	.DW  _0xB*2

	.DW  0x11
	.DW  _M3_1
	.DW  _0xC*2

	.DW  0x11
	.DW  _M3_2
	.DW  _0xD*2

	.DW  0x11
	.DW  _M2_1_1
	.DW  _0xE*2

	.DW  0x11
	.DW  _M2_1_2
	.DW  _0xF*2

	.DW  0x11
	.DW  _M2_2_1
	.DW  _0x10*2

	.DW  0x11
	.DW  _M3_2_1
	.DW  _0x11*2

	.DW  0x11
	.DW  _M3_2_2
	.DW  _0x12*2

	.DW  0x11
	.DW  _M3_2_3
	.DW  _0x13*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.08 Evaluation
;Automatic Program Generator
;© Copyright 1998-2013 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 24.02.2014
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega64A
;Program type            : Application
;AVR Core Clock frequency: 7,372800 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include <mega64a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <math.h>
;#include <stdlib.h>
;
;#define SENSOR_UP      PINA.1
;#define SENSOR_RIGHT   PINE.0
;#define SENSOR_DOWN    PINE.7
;#define SENSOR_LEFT    PINA.2
;#define SENSOR_SELECT  PINA.3
;
;#define SENS_IN_UP     PORTA.2
;#define SENS_IN_RIGHT  PORTE.0
;#define SENS_IN_DOWN   PORTE.7
;#define SENS_IN_LEFT   PORTA.1
;#define SENS_IN_SELECT PORTA.3
;
;#define SENS_PIN_UP      DDRA.2
;#define SENS_PIN_RIGHT   DDRE.0
;#define SENS_PIN_DOWN    DDRE.7
;#define SENS_PIN_LEFT    DDRA.1
;#define SENS_PIN_SELECT  DDRA.3
;
;#define KeyCount 5
;
;#define NULL_ENTRU Null_Menu
;
;void DefaultMenuHandler(){ }
; 0000 0034 void DefaultMenuHandler(){ }

	.CSEG
_DefaultMenuHandler:
; .FSTART _DefaultMenuHandler
	RET
; .FEND
;unsigned int* Sensor_Read();
;float TimeConst[KeyCount];
;typedef struct MenuItemNode
;    {
;    struct MenuItemNode* Left;
;    struct MenuItemNode* Up;
;    struct MenuItemNode* Right;
;    struct MenuItemNode* Down;
;    void(*Select) ();
;    const char Text[8];
;    } MenuItem;
;
;typedef enum KeyAction
;{
;    None,
;    MoveLeft,
;    MoveUp,
;    MoveRight,
;    MoveDown,
;    Select
;} KeyAction;
;
;void MoveIfNotNullMenuEntry(MenuItem*);
;
;#define MAKE_MENU(Name, Left, Up, Right, Down, Select, Text)\
;        extern MenuItem Left;                         \
;        extern MenuItem Up;                           \
;        extern MenuItem Right;                        \
;        extern MenuItem Down;                         \
;        MenuItem Name =  { (MenuItem*)&Left, (MenuItem*)&Up, (MenuItem*)&Right, (MenuItem*)&Down, Select, {Text} }
;
;
;
;
;MenuItem Null_Menu = {0, 0, 0, 0, 0, {0}};
;
;MenuItem* CurrentMenu;
;
;//                  Left            Up              Right           Down            Command
;MAKE_MENU(M1,       NULL_ENTRU,     NULL_ENTRU,     M1_1,           M2,             DefaultMenuHandler,      "TopLeft");

	.DSEG
;MAKE_MENU(M2,       NULL_ENTRU,     M1,             M2_1,           M3,             DefaultMenuHandler,      "TopLeft");
;MAKE_MENU(M3,       NULL_ENTRU,     M2,             M3_1,           NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
;// Підменю М1
;MAKE_MENU(M1_1,     M1,             NULL_ENTRU,     NULL_ENTRU,     M1_2,           DefaultMenuHandler,      "TopLeft");
;MAKE_MENU(M1_2,     M1,             M1_1,           NULL_ENTRU,     M1_3,           DefaultMenuHandler,      "TopLeft");
;MAKE_MENU(M1_3,     M3,             M1_1,           NULL_ENTRU,     NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
;// Мідменю М2
;MAKE_MENU(M2_1,     M2,             NULL_ENTRU,     M2_1_1,         M2_2,           DefaultMenuHandler,      "TopLeft");
;MAKE_MENU(M2_2,     M2,             M2_1,           M2_2_1,         M2_3,           DefaultMenuHandler,      "TopLeft");
;MAKE_MENU(M2_3,     M2,             M2_2,           NULL_ENTRU,     NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
;//Підменю М3
;MAKE_MENU(M3_1,     M3,             NULL_ENTRU,     NULL_ENTRU,     M3_2,           DefaultMenuHandler,      "TopLeft");
;MAKE_MENU(M3_2,     M3,             M3_1,           M3_2_1,         NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
;// Підменю М2.1
;MAKE_MENU(M2_1_1,   M2_1,           NULL_ENTRU,     NULL_ENTRU,     M2_1_2,         DefaultMenuHandler,      "TopLeft");
;MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
;//Підменю М2.2
;MAKE_MENU(M2_2_1,   M2_2,           NULL_ENTRU,     NULL_ENTRU,     NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
;// GПідменю М2.3
;/*
;MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
;MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
;MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
;MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
;*/
;// Підменю М3.2
;MAKE_MENU(M3_2_1,   M3_2,           NULL_ENTRU,     NULL_ENTRU,     M3_2_2,         0,      "TopLeft");
;MAKE_MENU(M3_2_2,   M3_2,           M3_2_1,         NULL_ENTRU,     M3_2_3,         0,      "TopLeft");
;MAKE_MENU(M3_2_3,   M3_2,           M3_2_2,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
;
;unsigned int* SensorRead()
; 0000 007C {

	.CSEG
; 0000 007D     unsigned int* Time_Value = (unsigned int*) malloc(5 * sizeof(unsigned int));
; 0000 007E     void* portsValue[] = {&SENSOR_UP, &SENSOR_DOWN};
; 0000 007F     void* ports[] = {&SENS_IN_UP, &SENS_IN_DOWN};
; 0000 0080     void* portsDirection[] = {&SENS_PIN_UP, &SENS_PIN_DOWN};
; 0000 0081     int i, j;
; 0000 0082     i = 0;
;	*Time_Value -> R16,R17
;	portsValue -> Y+14
;	ports -> Y+10
;	portsDirection -> Y+6
;	i -> R18,R19
;	j -> R20,R21
; 0000 0083     for (i = 0; i< 5; i++)
; 0000 0084     {
; 0000 0085         unsigned long int time, sum = 0;
; 0000 0086         for (j = 0; j< 32; j++)
;	portsValue -> Y+22
;	ports -> Y+18
;	portsDirection -> Y+14
;	time -> Y+4
;	sum -> Y+0
; 0000 0087         {
; 0000 0088             time = 0;
; 0000 0089             *((int*)portsDirection[i]) = 1;
; 0000 008A             ports[i] = 0;
; 0000 008B             delay_us(100);
; 0000 008C             *((int*)portsDirection[i]) = 0;
; 0000 008D             while (portsValue[i] == 0)
; 0000 008E             {
; 0000 008F                 time++;
; 0000 0090             }
; 0000 0091             sum += time;
; 0000 0092             *((int*)portsDirection[i]) = 1;
; 0000 0093         }
; 0000 0094         Time_Value[i] = sum;
; 0000 0095     }
; 0000 0096     return Time_Value;
; 0000 0097 }
;
;unsigned int* Sensor_Read() //функція для зчитування значення часу заряду конденсатора
; 0000 009A {
_Sensor_Read:
; .FSTART _Sensor_Read
; 0000 009B     int i, j;
; 0000 009C     // число, яке буде сумаю значнь часу зарядки кожного конденсатора,
; 0000 009D                                   //використовується в подальшому для перевірки чи не натиснута кнопка
; 0000 009E     unsigned long int time, sum; //змінна, яка буде мати поточне значення часу заряду кожного конденсатора
; 0000 009F     unsigned int* Time_Value = (unsigned int*) malloc(5 * sizeof(unsigned int));
; 0000 00A0     sum=0;
	SBIW R28,8
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	time -> Y+10
;	sum -> Y+6
;	*Time_Value -> R20,R21
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _malloc
	MOVW R20,R30
	RCALL SUBOPT_0x0
; 0000 00A1     j = 0;
	__GETWRN 18,19,0
; 0000 00A2     for (i = 0; i< 32; i++)
	__GETWRN 16,17,0
_0x1F:
	__CPWRN 16,17,32
	BRGE _0x20
; 0000 00A3     {
; 0000 00A4         time = 0;
	RCALL SUBOPT_0x1
; 0000 00A5         SENS_PIN_UP = 1;
	SBI  0x1A,2
; 0000 00A6         SENS_IN_UP = 0;
	CBI  0x1B,2
; 0000 00A7         delay_us(100);
	__DELAY_USB 246
; 0000 00A8         SENS_PIN_UP = 0;
	CBI  0x1A,2
; 0000 00A9         while (SENSOR_UP == 0)
_0x27:
	SBIC 0x19,1
	RJMP _0x29
; 0000 00AA         {
; 0000 00AB             time++;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00AC         }
	RJMP _0x27
_0x29:
; 0000 00AD         sum += time;
	RCALL SUBOPT_0x4
; 0000 00AE         SENS_PIN_UP = 1;
	SBI  0x1A,2
; 0000 00AF     }
	__ADDWRN 16,17,1
	RJMP _0x1F
_0x20:
; 0000 00B0            Time_Value[j]=sum;
	RCALL SUBOPT_0x5
; 0000 00B1            j++;
; 0000 00B2      for (i=0; i<=31; i++)
_0x2D:
	__CPWRN 16,17,32
	BRGE _0x2E
; 0000 00B3        {
; 0000 00B4          time=0;
	RCALL SUBOPT_0x1
; 0000 00B5          sum=0;
	RCALL SUBOPT_0x0
; 0000 00B6          SENS_PIN_RIGHT=1;
	SBI  0x2,0
; 0000 00B7          SENS_IN_RIGHT=0;
	CBI  0x3,0
; 0000 00B8          delay_us(100);
	__DELAY_USB 246
; 0000 00B9          SENS_PIN_RIGHT=0;
	CBI  0x2,0
; 0000 00BA          while (SENSOR_RIGHT==0)
_0x35:
	SBIC 0x1,0
	RJMP _0x37
; 0000 00BB            {
; 0000 00BC            time++;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00BD            }
	RJMP _0x35
_0x37:
; 0000 00BE          sum += time;
	RCALL SUBOPT_0x4
; 0000 00BF          SENS_PIN_RIGHT=1;
	SBI  0x2,0
; 0000 00C0        }
	__ADDWRN 16,17,1
	RJMP _0x2D
_0x2E:
; 0000 00C1         Time_Value[j]=sum;
	RCALL SUBOPT_0x5
; 0000 00C2         j++;
; 0000 00C3      for (i=0; i<=31; i++)
_0x3B:
	__CPWRN 16,17,32
	BRGE _0x3C
; 0000 00C4        {
; 0000 00C5      time=0;
	RCALL SUBOPT_0x1
; 0000 00C6      sum=0;
	RCALL SUBOPT_0x0
; 0000 00C7      SENS_PIN_DOWN=1;
	SBI  0x2,7
; 0000 00C8      SENS_IN_DOWN=0;
	CBI  0x3,7
; 0000 00C9      delay_us(100);
	__DELAY_USB 246
; 0000 00CA      SENS_PIN_DOWN=0;
	CBI  0x2,7
; 0000 00CB      while (SENSOR_DOWN==0)
_0x43:
	SBIC 0x1,7
	RJMP _0x45
; 0000 00CC       {
; 0000 00CD        time++;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00CE       }
	RJMP _0x43
_0x45:
; 0000 00CF      sum += time;
	RCALL SUBOPT_0x4
; 0000 00D0      SENS_PIN_DOWN=1;
	SBI  0x2,7
; 0000 00D1      }
	__ADDWRN 16,17,1
	RJMP _0x3B
_0x3C:
; 0000 00D2         Time_Value[j]=sum;
	RCALL SUBOPT_0x5
; 0000 00D3         j++;
; 0000 00D4      for (i=0; i<=31; i++)
_0x49:
	__CPWRN 16,17,32
	BRGE _0x4A
; 0000 00D5        {
; 0000 00D6      time=0;
	RCALL SUBOPT_0x1
; 0000 00D7      sum=0;
	RCALL SUBOPT_0x0
; 0000 00D8      SENS_PIN_LEFT=1;
	SBI  0x1A,1
; 0000 00D9      SENS_IN_LEFT=0;
	CBI  0x1B,1
; 0000 00DA      delay_us(100);
	__DELAY_USB 246
; 0000 00DB      SENS_PIN_LEFT=0;
	CBI  0x1A,1
; 0000 00DC      while (SENSOR_LEFT==0)
_0x51:
	SBIC 0x19,2
	RJMP _0x53
; 0000 00DD       {
; 0000 00DE        time++;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00DF       }
	RJMP _0x51
_0x53:
; 0000 00E0      sum += time;
	RCALL SUBOPT_0x4
; 0000 00E1      SENS_PIN_LEFT=1;
	SBI  0x1A,1
; 0000 00E2     }
	__ADDWRN 16,17,1
	RJMP _0x49
_0x4A:
; 0000 00E3         Time_Value[j]=sum;
	RCALL SUBOPT_0x5
; 0000 00E4         j++;
; 0000 00E5      for (i=0; i<=31; i++)
_0x57:
	__CPWRN 16,17,32
	BRGE _0x58
; 0000 00E6        {
; 0000 00E7      time=0;
	RCALL SUBOPT_0x1
; 0000 00E8      sum=0;
	RCALL SUBOPT_0x0
; 0000 00E9      SENS_PIN_SELECT=1;
	SBI  0x1A,3
; 0000 00EA      SENS_IN_SELECT=0;
	CBI  0x1B,3
; 0000 00EB      delay_us(100);
	__DELAY_USB 246
; 0000 00EC      SENS_PIN_SELECT=0;
	CBI  0x1A,3
; 0000 00ED      while (SENSOR_SELECT==0)
_0x5F:
	SBIC 0x19,3
	RJMP _0x61
; 0000 00EE       {
; 0000 00EF        time++;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00F0       }
	RJMP _0x5F
_0x61:
; 0000 00F1      sum += time;
	RCALL SUBOPT_0x4
; 0000 00F2      SENS_PIN_SELECT=1;
	SBI  0x1A,3
; 0000 00F3     }
	__ADDWRN 16,17,1
	RJMP _0x57
_0x58:
; 0000 00F4             Time_Value[j]=sum;
	MOVW R30,R18
	MOVW R26,R20
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00F5             j++;
	__ADDWRN 18,19,1
; 0000 00F6          return Time_Value;
	MOVW R30,R20
	RCALL __LOADLOCR6
	ADIW R28,14
	RET
; 0000 00F7 }
; .FEND
;
;KeyAction Key_Press()     // Функція для перевірки чи натиснута кнопка, повертає натиснуту кнопку
; 0000 00FA {
_Key_Press:
; .FSTART _Key_Press
; 0000 00FB     unsigned int* currentValue = Sensor_Read();
; 0000 00FC     int pressedKeyCount = 0;
; 0000 00FD     int keyCoeffs[] = {2,2,2,2,2};
; 0000 00FE     int pressedKeyIndex;
; 0000 00FF     int i;
; 0000 0100     for (i = 0; i < 5; i++)
	SBIW R28,12
	LDI  R24,10
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	LDI  R30,LOW(_0x64*2)
	LDI  R31,HIGH(_0x64*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR6
;	*currentValue -> R16,R17
;	pressedKeyCount -> R18,R19
;	keyCoeffs -> Y+8
;	pressedKeyIndex -> R20,R21
;	i -> Y+6
	RCALL SUBOPT_0x6
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x66:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BRGE _0x67
; 0000 0101     {
; 0000 0102         if (currentValue[i] >= keyCoeffs[i]*TimeConst[i])
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R28
	ADIW R26,8
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDI  R26,LOW(_TimeConst)
	LDI  R27,HIGH(_TimeConst)
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __CWD2
	RCALL __CDF2
	RCALL __MULF12
	POP  R26
	POP  R27
	CLR  R24
	CLR  R25
	RCALL __CDF2
	RCALL __CMPF12
	BRLO _0x68
; 0000 0103         {
; 0000 0104             pressedKeyIndex = i;
	__GETWRS 20,21,6
; 0000 0105             pressedKeyCount++;
	__ADDWRN 18,19,1
; 0000 0106         }
; 0000 0107     }
_0x68:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x66
_0x67:
; 0000 0108 
; 0000 0109     // Тут може бути програма для виконання спеціальний програм, виклик яких здійснюється одночасним
; 0000 010A     // натисканням кількох кномпок на певний час
; 0000 010B 
; 0000 010C     if(pressedKeyCount > 1) return None;   //якщо натиснуто більше як 1 кнопка, тоді нічого не робити
	__CPWRN 18,19,2
	BRLT _0x69
	LDI  R30,LOW(0)
	RJMP _0x20A0004
; 0000 010D     switch(pressedKeyIndex)
_0x69:
	MOVW R30,R20
; 0000 010E     {
; 0000 010F         case 0: return MoveLeft;
	SBIW R30,0
	BRNE _0x6D
	LDI  R30,LOW(1)
	RJMP _0x20A0004
; 0000 0110         case 1: return MoveUp;
_0x6D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6E
	LDI  R30,LOW(2)
	RJMP _0x20A0004
; 0000 0111         case 2: return MoveRight;
_0x6E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6F
	LDI  R30,LOW(3)
	RJMP _0x20A0004
; 0000 0112         case 3: return MoveDown;
_0x6F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x70
	LDI  R30,LOW(4)
	RJMP _0x20A0004
; 0000 0113         case 4: return Select;
_0x70:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6C
	LDI  R30,LOW(5)
; 0000 0114     }
_0x6C:
; 0000 0115 }
_0x20A0004:
	RCALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
;
;void Sensor_Calibration() // Функція для калібрування сенсорів
; 0000 0118 {
_Sensor_Calibration:
; .FSTART _Sensor_Calibration
; 0000 0119     unsigned int* currentValue = Sensor_Read();
; 0000 011A     int j=0;
; 0000 011B     for (j = 0; j < KeyCount; j++)
	RCALL __SAVELOCR4
;	*currentValue -> R16,R17
;	j -> R18,R19
	RCALL SUBOPT_0x6
	__GETWRN 18,19,0
_0x73:
	__CPWRN 18,19,5
	BRGE _0x74
; 0000 011C     {
; 0000 011D         TimeConst[j]=floor((currentValue[j] >> 5) + 0.5);
	MOVW R30,R18
	LDI  R26,LOW(_TimeConst)
	LDI  R27,HIGH(_TimeConst)
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R30,R18
	RCALL SUBOPT_0x7
	LSR  R31
	ROR  R30
	RCALL __LSRW4
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x3F000000
	RCALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 011E     }
	__ADDWRN 18,19,1
	RJMP _0x73
_0x74:
; 0000 011F }
	RCALL __LOADLOCR4
	JMP  _0x20A0002
; .FEND
;
;void MoveMenu(KeyAction action)
; 0000 0122 {
_MoveMenu:
; .FSTART _MoveMenu
; 0000 0123     switch(action)
	ST   -Y,R26
;	action -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 0124     {
; 0000 0125         case MoveLeft:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x78
; 0000 0126         MoveIfNotNullMenuEntry(CurrentMenu->Left);
	MOVW R26,R4
	RCALL __GETW1P
	MOVW R26,R30
	RJMP _0x87
; 0000 0127         break;
; 0000 0128         case MoveUp:
_0x78:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x79
; 0000 0129         MoveIfNotNullMenuEntry(CurrentMenu->Up);
	MOVW R30,R4
	LDD  R26,Z+2
	LDD  R27,Z+3
	RJMP _0x87
; 0000 012A         break;
; 0000 012B         case MoveRight:
_0x79:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7A
; 0000 012C         MoveIfNotNullMenuEntry(CurrentMenu->Right);
	MOVW R30,R4
	LDD  R26,Z+4
	LDD  R27,Z+5
	RJMP _0x87
; 0000 012D         break;
; 0000 012E         case MoveDown:
_0x7A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x77
; 0000 012F         MoveIfNotNullMenuEntry(CurrentMenu->Down);
	MOVW R30,R4
	LDD  R26,Z+6
	LDD  R27,Z+7
_0x87:
	RCALL _MoveIfNotNullMenuEntry
; 0000 0130         break;
; 0000 0131     }
_0x77:
; 0000 0132 }
	JMP  _0x20A0003
; .FEND
;
;void MoveIfNotNullMenuEntry(MenuItem* menu)
; 0000 0135 {
_MoveIfNotNullMenuEntry:
; .FSTART _MoveIfNotNullMenuEntry
; 0000 0136     if(menu != &NULL_ENTRU)
	ST   -Y,R27
	ST   -Y,R26
;	*menu -> Y+0
	LDI  R30,LOW(_Null_Menu)
	LDI  R31,HIGH(_Null_Menu)
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x7C
; 0000 0137         CurrentMenu = menu;
	__GETWRS 4,5,0
; 0000 0138 }
_0x7C:
	JMP  _0x20A0001
; .FEND
;
;void LCD_MENU_OUT(char* text)   //функція для виводу інформації на дисплей
; 0000 013B {
_LCD_MENU_OUT:
; .FSTART _LCD_MENU_OUT
; 0000 013C     lcd_clear();
	ST   -Y,R27
	ST   -Y,R26
;	*text -> Y+0
	RCALL _lcd_clear
; 0000 013D     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 013E     lcd_puts(text);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _lcd_puts
; 0000 013F }
	JMP  _0x20A0001
; .FEND
;
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)// Timer3 overflow interrupt service routine
; 0000 0142 {
_timer3_ovf_isr:
; .FSTART _timer3_ovf_isr
; 0000 0143 
; 0000 0144 
; 0000 0145 }
	RETI
; .FEND
;
;interrupt [TIM3_COMPC] void timer3_compc_isr(void)// Timer3 output compare C interrupt service routine
; 0000 0148 {
_timer3_compc_isr:
; .FSTART _timer3_compc_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0149     KeyAction action = Key_Press();
; 0000 014A     switch(action)
	ST   -Y,R17
;	action -> R17
	RCALL _Key_Press
	MOV  R17,R30
	LDI  R31,0
; 0000 014B     {
; 0000 014C         case None: return;
	SBIW R30,0
	BREQ _0x88
; 0000 014D         case Select:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x82
; 0000 014E         {
; 0000 014F             CurrentMenu->Select();
	MOVW R30,R4
	__GETWRZ 0,1,8
	MOVW R30,R0
	ICALL
; 0000 0150             return;
	RJMP _0x88
; 0000 0151         }
; 0000 0152         default:
_0x82:
; 0000 0153         {
; 0000 0154             MoveMenu(action);
	MOV  R26,R17
	RCALL _MoveMenu
; 0000 0155             LCD_MENU_OUT(CurrentMenu->Text);
	MOVW R26,R4
	ADIW R26,10
	RCALL _LCD_MENU_OUT
; 0000 0156         }
; 0000 0157     }
; 0000 0158 }
_0x88:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 015B {
_main:
; .FSTART _main
; 0000 015C 
; 0000 015D DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 015E PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 015F 
; 0000 0160 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0161 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0162 
; 0000 0163 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0164 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0165 
; 0000 0166 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0167 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0168 
; 0000 0169 DDRE=(1<<DDE7) | (1<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (1<<DDE1) | (1<<DDE0);
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 016A PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 016B 
; 0000 016C DDRF=(1<<DDF7) | (1<<DDF6) | (1<<DDF5) | (1<<DDF4) | (1<<DDF3) | (1<<DDF2) | (1<<DDF1) | (1<<DDF0);
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 016D PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 016E 
; 0000 016F DDRG=(1<<DDG4) | (1<<DDG3) | (1<<DDG2) | (1<<DDG1) | (1<<DDG0);
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 0170 PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 0171 
; 0000 0172 // Timer/Counter 0 initialization
; 0000 0173 // Clock source: System Clock
; 0000 0174 // Clock value: Timer 0 Stopped
; 0000 0175 // Mode: Normal top=0xFF
; 0000 0176 // OC0 output: Disconnected
; 0000 0177 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 0178 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0179 TCNT0=0x00;
	OUT  0x32,R30
; 0000 017A OCR0=0x00;
	OUT  0x31,R30
; 0000 017B 
; 0000 017C // Timer/Counter 1 initialization
; 0000 017D // Clock source: System Clock
; 0000 017E // Clock value: 7372,800 kHz
; 0000 017F // Mode: Fast PWM top=ICR1
; 0000 0180 // OC1A output: Non-Inverted PWM
; 0000 0181 // OC1B output: Non-Inverted PWM
; 0000 0182 // OC1C output: Non-Inverted PWM
; 0000 0183 // Noise Canceler: Off
; 0000 0184 // Input Capture on Falling Edge
; 0000 0185 // Timer Period: 0,13563 us
; 0000 0186 // Output Pulse(s):
; 0000 0187 // OC1A Period: 0,13563 us// OC1B Period: 0,13563 us// OC1C Period: 0,13563 us
; 0000 0188 // Timer1 Overflow Interrupt: Off
; 0000 0189 // Input Capture Interrupt: Off
; 0000 018A // Compare A Match Interrupt: Off
; 0000 018B // Compare B Match Interrupt: Off
; 0000 018C // Compare C Match Interrupt: Off
; 0000 018D TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<COM1C1) | (0<<COM1C0) | (1<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(170)
	OUT  0x2F,R30
; 0000 018E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 018F TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0190 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0191 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0192 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0193 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0194 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0195 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0196 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0197 OCR1CH=0x00;
	STS  121,R30
; 0000 0198 OCR1CL=0x00;
	STS  120,R30
; 0000 0199 
; 0000 019A // Timer/Counter 2 initialization
; 0000 019B // Clock source: System Clock
; 0000 019C // Clock value: Timer2 Stopped
; 0000 019D // Mode: Normal top=0xFF
; 0000 019E // OC2 output: Disconnected
; 0000 019F TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 01A0 TCNT2=0x00;
	OUT  0x24,R30
; 0000 01A1 OCR2=0x00;
	OUT  0x23,R30
; 0000 01A2 
; 0000 01A3 // Timer/Counter 3 initialization
; 0000 01A4 // Clock source: System Clock
; 0000 01A5 // Clock value: 7,200 kHz
; 0000 01A6 // Mode: Fast PWM top=ICR3
; 0000 01A7 // OC3A output: Disconnected
; 0000 01A8 // OC3B output: Disconnected
; 0000 01A9 // OC3C output: Disconnected
; 0000 01AA // Noise Canceler: Off
; 0000 01AB // Input Capture on Falling Edge
; 0000 01AC // Timer Period: 0,13889 ms
; 0000 01AD // Timer3 Overflow Interrupt: On
; 0000 01AE // Input Capture Interrupt: Off
; 0000 01AF // Compare A Match Interrupt: Off
; 0000 01B0 // Compare B Match Interrupt: Off
; 0000 01B1 // Compare C Match Interrupt: On
; 0000 01B2 TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (1<<WGM31) | (0<<WGM30);
	LDI  R30,LOW(2)
	STS  139,R30
; 0000 01B3 TCCR3B=(0<<ICNC3) | (0<<ICES3) | (1<<WGM33) | (1<<WGM32) | (1<<CS32) | (0<<CS31) | (1<<CS30);
	LDI  R30,LOW(29)
	STS  138,R30
; 0000 01B4 TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 01B5 TCNT3L=0x00;
	STS  136,R30
; 0000 01B6 ICR3H=0x00;
	STS  129,R30
; 0000 01B7 ICR3L=0x00;
	STS  128,R30
; 0000 01B8 OCR3AH=0x00;
	STS  135,R30
; 0000 01B9 OCR3AL=0x00;
	STS  134,R30
; 0000 01BA OCR3BH=0x00;
	STS  133,R30
; 0000 01BB OCR3BL=0x00;
	STS  132,R30
; 0000 01BC OCR3CH=0x00;
	STS  131,R30
; 0000 01BD OCR3CL=0x00;
	STS  130,R30
; 0000 01BE 
; 0000 01BF // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01C0 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 01C1 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (1<<TOIE3) | (1<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(6)
	STS  125,R30
; 0000 01C2 
; 0000 01C3 
; 0000 01C4 EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	STS  106,R30
; 0000 01C5 EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 01C6 EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 01C7 
; 0000 01C8 
; 0000 01C9 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	OUT  0xA,R30
; 0000 01CA 
; 0000 01CB 
; 0000 01CC UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  154,R30
; 0000 01CD 
; 0000 01CE ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01CF SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01D0 
; 0000 01D1 
; 0000 01D2 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 01D3 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 01D4 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 01D5 
; 0000 01D6 
; 0000 01D7 
; 0000 01D8 
; 0000 01D9 // Alphanumeric LCD initialization
; 0000 01DA // Connections are specified in the
; 0000 01DB // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 01DC // RS - PORTD Bit 5
; 0000 01DD // RD - PORTD Bit 1
; 0000 01DE // EN - PORTD Bit 4
; 0000 01DF // D4 - PORTA Bit 6
; 0000 01E0 // D5 - PORTA Bit 3
; 0000 01E1 // D6 - PORTA Bit 5
; 0000 01E2 // D7 - PORTA Bit 4
; 0000 01E3 // Characters/line: 8
; 0000 01E4 lcd_init(8);
	LDI  R26,LOW(8)
	RCALL _lcd_init
; 0000 01E5 
; 0000 01E6 
; 0000 01E7 //  автоматична настройка кожного сенсора
; 0000 01E8    delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01E9    Sensor_Calibration();
	RCALL _Sensor_Calibration
; 0000 01EA 
; 0000 01EB #asm("sei")
	sei
; 0000 01EC 
; 0000 01ED while (1)
_0x83:
; 0000 01EE       {
; 0000 01EF       // lcd_init() – инициализация дисплея
; 0000 01F0     //  lcd_clear() – очистка экрана
; 0000 01F1     //  lcd_gotoxy(0,0) – перемещение по координатам х,у, где х-столбец, у-строка
; 0000 01F2     ///  lcd_putsf, lcd_putchar – вывод текста
; 0000 01F3     ///  lcd_puts – вывод текста с переменными
; 0000 01F4       }
	RJMP _0x83
; 0000 01F5 }
_0x86:
	RJMP _0x86
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x1B,6
	RJMP _0x2000005
_0x2000004:
	CBI  0x1B,6
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x1B,3
	RJMP _0x2000007
_0x2000006:
	CBI  0x1B,3
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x1B,5
	RJMP _0x2000009
_0x2000008:
	CBI  0x1B,5
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x1B,4
	RJMP _0x200000B
_0x200000A:
	CBI  0x1B,4
_0x200000B:
	__DELAY_USB 12
	SBI  0x12,4
	__DELAY_USB 12
	CBI  0x12,4
	__DELAY_USB 12
	RJMP _0x20A0003
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 123
	RJMP _0x20A0003
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R7,Y+1
	LDD  R6,Y+0
	JMP  _0x20A0001
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x8
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x8
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R7,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R7,R9
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R6
	MOV  R26,R6
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20A0003
_0x2000013:
_0x2000010:
	INC  R7
	SBI  0x12,5
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,5
	RJMP _0x20A0003
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x1A,6
	SBI  0x1A,3
	SBI  0x1A,5
	SBI  0x1A,4
	SBI  0x11,4
	SBI  0x11,5
	SBI  0x11,1
	CBI  0x12,4
	CBI  0x12,5
	CBI  0x12,1
	LDD  R9,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 246
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0003:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0xA
	RJMP _0x20A0002
__floor1:
    brtc __floor0
	RCALL SUBOPT_0xA
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20A0002:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG
_malloc:
; .FSTART _malloc
	ST   -Y,R27
	ST   -Y,R26
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x20A0001:
	ADIW R28,2
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_TimeConst:
	.BYTE 0x14
_Null_Menu:
	.BYTE 0x12
_M1_1:
	.BYTE 0x12
_M2:
	.BYTE 0x12
_M1:
	.BYTE 0x12
_M2_1:
	.BYTE 0x12
_M3:
	.BYTE 0x12
_M3_1:
	.BYTE 0x12
_M1_2:
	.BYTE 0x12
_M1_3:
	.BYTE 0x12
_M2_1_1:
	.BYTE 0x12
_M2_2:
	.BYTE 0x12
_M2_2_1:
	.BYTE 0x12
_M2_3:
	.BYTE 0x12
_M3_2:
	.BYTE 0x12
_M3_2_1:
	.BYTE 0x12
_M2_1_2:
	.BYTE 0x12
_M3_2_2:
	.BYTE 0x12
_M3_2_3:
	.BYTE 0x12
__base_y_G100:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	__CLRD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	__CLRD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x3:
	__SUBD1N -1
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x2
	__GETD2S 6
	RCALL __ADDD12
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x5:
	MOVW R30,R18
	MOVW R26,R20
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	STD  Z+0,R26
	STD  Z+1,R27
	__ADDWRN 18,19,1
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL _Sensor_Read
	MOVW R16,R30
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	MOVW R26,R16
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 246
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	RCALL __GETD1S0
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x733
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
