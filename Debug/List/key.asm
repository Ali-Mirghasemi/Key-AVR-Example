
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	JMP  _timer1_compa_isr
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

_0x3:
	.DB  LOW(_Key_initPin),HIGH(_Key_initPin),LOW(_Key_readPin),HIGH(_Key_readPin)
_0x4:
	.DB  0x30,0x0,0x1
_0x5:
	.DB  0x30,0x0,0x2
_0x6:
	.DB  0x30,0x0,0x4
_0x40003:
	.DB  LOW(_Key_initPin),HIGH(_Key_initPin),LOW(_Key_readPin),HIGH(_Key_readPin)

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _keyDriver_G000
	.DW  _0x3*2

	.DW  0x03
	.DW  _keyConfig1
	.DW  _0x4*2

	.DW  0x03
	.DW  _keyConfig2
	.DW  _0x5*2

	.DW  0x03
	.DW  _keyConfig3
	.DW  _0x6*2

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x160

	.CSEG
;/*
; * main.c
; *
; * Created: 6/28/2021 5:08:43 AM
; * Author: MrCrazy
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "Key.h"
;#include "KeyPort.h"

	.DSEG
;
;#define LED         DDRA
;#define LED0        PORTA.0
;#define LED1        PORTA.1
;#define LED2        PORTA.2
;
;const Key_PinConfig keyConfig1 = {
;    GPIOD, GPIO_PIN_0
;};
;const Key_PinConfig keyConfig2 = {
;    GPIOD, GPIO_PIN_1
;};
;const Key_PinConfig keyConfig3 = {
;    GPIOD, GPIO_PIN_2
;};
;
;
;// Callbacks
;#if KEY_MULTI_CALLBACK
;    Key_HandleStatus Key1_onPressed(Key* key, Key_State state);
;
;    Key_HandleStatus Key2_onPressed(Key* key, Key_State state);
;    Key_HandleStatus Key2_onReleased(Key* key, Key_State state);
;
;    Key_HandleStatus Key3_onPressed(Key* key, Key_State state);
;    Key_HandleStatus Key3_onReleased(Key* key, Key_State state);
;    Key_HandleStatus Key3_onHold(Key* key, Key_State state);
;#else
;    Key_HandleStatus Key1_onChange(Key* key, Key_State state);
;    Key_HandleStatus Key2_onChange(Key* key, Key_State state);
;    Key_HandleStatus Key3_onChange(Key* key, Key_State state);
;#endif
;
;static Key key1;
;static Key key2;
;static Key key3;
;
;void main(void)
; 0000 0031 {

	.CSEG
_main:
; .FSTART _main
; 0000 0032 
; 0000 0033     LED = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0034     LED0 = 0;
	CBI  0x1B,0
; 0000 0035     LED1 = 0;
	CBI  0x1B,1
; 0000 0036     LED2 = 0;
	CBI  0x1B,2
; 0000 0037 
; 0000 0038     // Timer/Counter 1 initialization
; 0000 0039     // Clock source: System Clock
; 0000 003A     // Clock value: 1000.000 kHz
; 0000 003B     // Mode: CTC top=OCR1A
; 0000 003C     // OC1A output: Disconnected
; 0000 003D     // OC1B output: Disconnected
; 0000 003E     // Noise Canceler: Off
; 0000 003F     // Input Capture on Falling Edge
; 0000 0040     // Timer Period: 50 ms
; 0000 0041     // Timer1 Overflow Interrupt: Off
; 0000 0042     // Input Capture Interrupt: Off
; 0000 0043     // Compare A Match Interrupt: On
; 0000 0044     // Compare B Match Interrupt: Off
; 0000 0045     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0046     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 0047     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0048     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0049     ICR1H=0x00;
	OUT  0x27,R30
; 0000 004A     ICR1L=0x00;
	OUT  0x26,R30
; 0000 004B     OCR1AH=0xC3;
	LDI  R30,LOW(195)
	OUT  0x2B,R30
; 0000 004C     OCR1AL=0x4F;
	LDI  R30,LOW(79)
	OUT  0x2A,R30
; 0000 004D     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 004E     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 004F 
; 0000 0050     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0051     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 0052 
; 0000 0053 
; 0000 0054     Key_init(&keyDriver);
	LDI  R26,LOW(_keyDriver_G000)
	LDI  R27,HIGH(_keyDriver_G000)
	CALL _Key_init
; 0000 0055     Key_add(&key1, &keyConfig1);
	LDI  R30,LOW(_key1_G000)
	LDI  R31,HIGH(_key1_G000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_keyConfig1)
	LDI  R27,HIGH(_keyConfig1)
	CALL _Key_add
; 0000 0056     Key_add(&key2, &keyConfig2);
	LDI  R30,LOW(_key2_G000)
	LDI  R31,HIGH(_key2_G000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_keyConfig2)
	LDI  R27,HIGH(_keyConfig2)
	CALL _Key_add
; 0000 0057     Key_add(&key3, &keyConfig3);
	LDI  R30,LOW(_key3_G000)
	LDI  R31,HIGH(_key3_G000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_keyConfig3)
	LDI  R27,HIGH(_keyConfig3)
	CALL _Key_add
; 0000 0058 #if KEY_MULTI_CALLBACK
; 0000 0059     Key_onPressed(&key1, Key1_onPressed);
; 0000 005A 
; 0000 005B     Key_onPressed(&key2, Key2_onPressed);
; 0000 005C     Key_onReleased(&key2, Key2_onReleased);
; 0000 005D 
; 0000 005E     Key_onPressed(&key3, Key3_onPressed);
; 0000 005F     Key_onReleased(&key3, Key3_onReleased);
; 0000 0060     Key_onHold(&key3, Key3_onHold);
; 0000 0061 #else
; 0000 0062     Key_onChange(&key1, Key1_onChange);
	LDI  R30,LOW(_key1_G000)
	LDI  R31,HIGH(_key1_G000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Key1_onChange)
	LDI  R27,HIGH(_Key1_onChange)
	CALL _Key_onChange
; 0000 0063     Key_onChange(&key2, Key2_onChange);
	LDI  R30,LOW(_key2_G000)
	LDI  R31,HIGH(_key2_G000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Key2_onChange)
	LDI  R27,HIGH(_Key2_onChange)
	CALL _Key_onChange
; 0000 0064     Key_onChange(&key3, Key3_onChange);
	LDI  R30,LOW(_key3_G000)
	LDI  R31,HIGH(_key3_G000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Key3_onChange)
	LDI  R27,HIGH(_Key3_onChange)
	CALL _Key_onChange
; 0000 0065 #endif
; 0000 0066 
; 0000 0067     // Global enable interrupts
; 0000 0068     #asm("sei")
	sei
; 0000 0069 
; 0000 006A while (1)
_0xD:
; 0000 006B     {
; 0000 006C     // Please write your application code here
; 0000 006D 
; 0000 006E     }
	RJMP _0xD
_0xF:
; 0000 006F }
_0x10:
	RJMP _0x10
; .FEND
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0072 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
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
; 0000 0073     Key_irq();
	CALL _Key_irq
; 0000 0074 }
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
;// Callbacks
;#if KEY_MULTI_CALLBACK
;Key_HandleStatus Key1_onPressed(Key* key, Key_State state) {
;    LED0 = !LED0;
;    return Key_Handled;
;}
;
;Key_HandleStatus Key2_onPressed(Key* key, Key_State state) {
;    LED1 = 1;
;    return Key_NotHandled;
;}
;Key_HandleStatus Key2_onReleased(Key* key, Key_State state) {
;    LED1 = 0;
;    return Key_Handled;
;}
;
;Key_HandleStatus Key3_onPressed(Key* key, Key_State state) {
;    LED2 = 1;
;    return Key_NotHandled;
;}
;Key_HandleStatus Key3_onReleased(Key* key, Key_State state) {
;    LED2 = 0;
;    return Key_NotHandled;
;}
;Key_HandleStatus Key3_onHold(Key* key, Key_State state) {
;    LED2 = !LED2;
;    return Key_NotHandled;
;}
;#else
;Key_HandleStatus Key1_onChange(Key* key, Key_State state) {
; 0000 0093 Key_HandleStatus Key1_onChange(Key* key, Key_State state) {
_Key1_onChange:
; .FSTART _Key1_onChange
; 0000 0094     if (Key_State_Pressed == state) {
	ST   -Y,R26
;	*key -> Y+1
;	state -> Y+0
	LD   R30,Y
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0x11
; 0000 0095         LED0 = !LED0;
	SBIS 0x1B,0
	RJMP _0x12
	CBI  0x1B,0
	RJMP _0x13
_0x12:
	SBI  0x1B,0
_0x13:
; 0000 0096         return Key_Handled;
	LDI  R30,LOW(1)
	ADIW R28,3
	RET
; 0000 0097     }
; 0000 0098     return Key_NotHandled;
_0x11:
	LDI  R30,LOW(0)
	ADIW R28,3
	RET
; 0000 0099 }
; .FEND
;Key_HandleStatus Key2_onChange(Key* key, Key_State state) {
; 0000 009A Key_HandleStatus Key2_onChange(Key* key, Key_State state) {
_Key2_onChange:
; .FSTART _Key2_onChange
; 0000 009B     switch (state) {
	ST   -Y,R26
;	*key -> Y+1
;	state -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 009C         case Key_State_Pressed:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x17
; 0000 009D             LED1 = 1;
	SBI  0x1B,1
; 0000 009E             return Key_NotHandled;
	LDI  R30,LOW(0)
	ADIW R28,3
	RET
; 0000 009F         case Key_State_Released:
_0x17:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1D
; 0000 00A0             LED1 = 0;
	CBI  0x1B,1
; 0000 00A1             return Key_Handled;
	LDI  R30,LOW(1)
	ADIW R28,3
	RET
; 0000 00A2         default:
_0x1D:
; 0000 00A3             return Key_NotHandled;
	LDI  R30,LOW(0)
	ADIW R28,3
	RET
; 0000 00A4     }
_0x16:
; 0000 00A5 }
	ADIW R28,3
	RET
; .FEND
;Key_HandleStatus Key3_onChange(Key* key, Key_State state) {
; 0000 00A6 Key_HandleStatus Key3_onChange(Key* key, Key_State state) {
_Key3_onChange:
; .FSTART _Key3_onChange
; 0000 00A7     switch (state) {
	ST   -Y,R26
;	*key -> Y+1
;	state -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 00A8         case Key_State_Pressed:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x21
; 0000 00A9             LED2 = 1;
	SBI  0x1B,2
; 0000 00AA             break;
	RJMP _0x20
; 0000 00AB         case Key_State_Released:
_0x21:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x24
; 0000 00AC             LED2 = 0;
	CBI  0x1B,2
; 0000 00AD             break;
	RJMP _0x20
; 0000 00AE         case Key_State_Hold:
_0x24:
	SBIW R30,0
	BREQ PC+3
	JMP _0x20
; 0000 00AF             LED2 = !LED2;
	SBIS 0x1B,2
	RJMP _0x28
	CBI  0x1B,2
	RJMP _0x29
_0x28:
	SBI  0x1B,2
_0x29:
; 0000 00B0             break;
; 0000 00B1     }
_0x20:
; 0000 00B2     return Key_NotHandled;
	LDI  R30,LOW(0)
	ADIW R28,3
	RET
; 0000 00B3 }
; .FEND
;#endif
;
;#include "Key.h"
;
;/* private macros */
;#define KEY_NULL            ((Key*) 0)
;
;#if KEY_MAX_NUM == -1
;    #define Key_ptr(KEY)    KEY
;#else
;    #define Key_ptr(KEY)    (*KEY)
;#endif // KEY_MAX_NUM == -1
;
;/* private variables */
;static const Key_Driver* keyDriver;
;#if KEY_MAX_NUM == -1
;    static Key* lastKey = KEY_NULL;
;#else
;    static Key* keys[KEY_MAX_NUM] = {0};
;#endif // KEY_MAX_NUM == -1
;
;/**
; * @brief use for initialize
; *
; * @param driver
; */
;void Key_init(const Key_Driver* driver) {
; 0001 0019 void Key_init(const Key_Driver* driver) {

	.CSEG
_Key_init:
; .FSTART _Key_init
; 0001 001A     keyDriver = driver;
	ST   -Y,R27
	ST   -Y,R26
;	*driver -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	STS  _keyDriver_G001,R30
	STS  _keyDriver_G001+1,R31
; 0001 001B }
	ADIW R28,2
	RET
; .FEND
;/**
; * @brief user must place it in timer with 20ms ~ 50ms
; * all of callbacks handle and fire in this function
; */
;void Key_irq(void) {
; 0001 0020 void Key_irq(void) {
_Key_irq:
; .FSTART _Key_irq
; 0001 0021     Key_State state;
; 0001 0022 #if KEY_MAX_NUM == -1
; 0001 0023     Key* pKey = lastKey;
; 0001 0024     while (KEY_NULL != Key_ptr(pKey)) {
; 0001 0025 #else
; 0001 0026     Key** pKey = keys;
; 0001 0027     uint8_t len = KEY_MAX_NUM;
; 0001 0028     while (len--) {
	CALL __SAVELOCR4
;	state -> R17
;	*pKey -> R18,R19
;	len -> R16
	__POINTWRM 18,19,_keys_G001
	LDI  R16,3
_0x20003:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x20005
; 0001 0029 #endif
; 0001 002A         // update current state
; 0001 002B         state = Key_ptr(pKey)->State;
	MOVW R26,R18
	CALL __GETW1P
	LDD  R30,Z+4
	ANDI R30,LOW(0x3)
	MOV  R17,R30
; 0001 002C     #if KEY_ACTIVE_STATE
; 0001 002D         state = ((state << 1) | (keyDriver->readPin(Key_ptr(pKey)->Config) ^ Key_ptr(pKey)->ActiveState)) & 0x03;
; 0001 002E     #else
; 0001 002F         state = ((state << 1) | keyDriver->readPin(Key_ptr(pKey)->Config)) & 0x03;
	LSL  R30
	PUSH R30
	LDS  R30,_keyDriver_G001
	LDS  R31,_keyDriver_G001+1
	__GETWRZ 0,1,2
	CALL __GETW1P
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	MOVW R30,R0
	ICALL
	POP  R26
	OR   R30,R26
	ANDI R30,LOW(0x3)
	MOV  R17,R30
; 0001 0030     #endif // KEY_ACTIVE_STATE
; 0001 0031         Key_ptr(pKey)->State = state;
	MOVW R26,R18
	CALL __GETW1P
	ADIW R30,4
	MOVW R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0x3)
	MOV  R0,R30
	LD   R30,X
	ANDI R30,LOW(0xFC)
	OR   R30,R0
	ST   X,R30
; 0001 0032         // call callback on new state
; 0001 0033 		if (Key_ptr(pKey)->NotActive == Key_NotHandled
; 0001 0034         #if !KEY_NONE_CALLBACK
; 0001 0035             && Key_State_None != state
; 0001 0036         #endif
; 0001 0037             ) {
	MOVW R26,R18
	CALL __GETW1P
	LDD  R30,Z+4
	ANDI R30,LOW(0x4)
	BREQ PC+3
	JMP _0x20007
	CPI  R17,3
	BRNE PC+3
	JMP _0x20007
	RJMP _0x20008
_0x20007:
	RJMP _0x20006
_0x20008:
; 0001 0038         #if KEY_MULTI_CALLBACK
; 0001 0039             if (Key_ptr(pKey)->Callbacks.callbacks[state]) {
; 0001 003A                 Key_ptr(pKey)->NotActive = Key_ptr(pKey)->Callbacks.callbacks[state](Key_ptr(pKey), state);
; 0001 003B             }
; 0001 003C         #else
; 0001 003D             if (Key_ptr(pKey)->Callbacks.onChange) {
	MOVW R26,R18
	CALL __GETW1P
	ADIW R30,2
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BRNE PC+3
	JMP _0x20009
; 0001 003E                 Key_ptr(pKey)->NotActive = Key_ptr(pKey)->Callbacks.onChange(Key_ptr(pKey), state);
	MOVW R26,R18
	CALL __GETW1P
	ADIW R30,4
	PUSH R31
	PUSH R30
	CALL __GETW1P
	ADIW R30,2
	MOVW R26,R30
	CALL __GETW1P
	PUSH R31
	PUSH R30
	MOVW R26,R18
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	POP  R30
	POP  R31
	ICALL
	POP  R26
	POP  R27
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LD   R30,X
	ANDI R30,0xFB
	OR   R30,R0
	ST   X,R30
; 0001 003F             }
; 0001 0040         #endif /* KEY_MULTI_CALLBACK_ENABLE */
; 0001 0041         }
_0x20009:
; 0001 0042         else if (Key_State_None == state && Key_ptr(pKey)->NotActive != Key_NotHandled) {
	RJMP _0x2000A
_0x20006:
	CPI  R17,3
	BREQ PC+3
	JMP _0x2000C
	MOVW R26,R18
	CALL __GETW1P
	LDD  R30,Z+4
	ANDI R30,LOW(0x4)
	BRNE PC+3
	JMP _0x2000C
	RJMP _0x2000D
_0x2000C:
	RJMP _0x2000B
_0x2000D:
; 0001 0043             Key_ptr(pKey)->NotActive = Key_NotHandled;
	MOVW R26,R18
	CALL __GETW1P
	ADIW R30,4
	MOVW R26,R30
	LD   R30,X
	ANDI R30,0xFB
	ST   X,R30
; 0001 0044         }
; 0001 0045     #if KEY_MAX_NUM == -1
; 0001 0046         // switch to previous key
; 0001 0047         pKey = pKey->Previous;
; 0001 0048     #else
; 0001 0049         pKey++;
_0x2000B:
_0x2000A:
	__ADDWRN 18,19,2
; 0001 004A     #endif // KEY_MAX_NUM == -1
; 0001 004B     }
	RJMP _0x20003
_0x20005:
; 0001 004C }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;/**
; * @brief set new pin configuration for key
; *
; * @param key address of key instance
; * @param config new pin configuration
; * @return uint8_t return 1 if key added, 0 if there is no space
; */
;void Key_setConfig(Key* key, const Key_PinConfig* config) {
; 0001 0055 void Key_setConfig(Key* key, const Key_PinConfig* config) {
_Key_setConfig:
; .FSTART _Key_setConfig
; 0001 0056     key->Config = config;
	ST   -Y,R27
	ST   -Y,R26
;	*key -> Y+2
;	*config -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X+,R30
	ST   X,R31
; 0001 0057 }
	ADIW R28,4
	RET
; .FEND
;/**
; * @brief get key pin config
; *
; * @param key
; * @return const Key_PinConfig*
; */
;const Key_PinConfig* Key_getConfig(Key* key) {
; 0001 005E const Key_PinConfig* Key_getConfig(Key* key) {
; 0001 005F     return key->Config;
;	*key -> Y+0
; 0001 0060 }
;
;/**
; * @brief add key into list for process
; *
; * @param key address of key
; * @param config key pin configuration
; */
;uint8_t Key_add(Key* key, const Key_PinConfig* config) {
; 0001 0068 uint8_t Key_add(Key* key, const Key_PinConfig* config) {
_Key_add:
; .FSTART _Key_add
; 0001 0069     // add new key to list
; 0001 006A     key->State = Key_State_None;
	ST   -Y,R27
	ST   -Y,R26
;	*key -> Y+2
;	*config -> Y+0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,LOW(0x3)
	ST   X,R30
; 0001 006B     key->NotActive = Key_NotHandled;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xFB
	ST   X,R30
; 0001 006C     Key_setConfig(key, config);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _Key_setConfig
; 0001 006D     // init IOs
; 0001 006E     keyDriver->initPin(config);
	LDS  R26,_keyDriver_G001
	LDS  R27,_keyDriver_G001+1
	CALL __GETW1P
	PUSH R31
	PUSH R30
	LD   R26,Y
	LDD  R27,Y+1
	POP  R30
	POP  R31
	ICALL
; 0001 006F #if KEY_MAX_NUM == -1
; 0001 0070     // add key to linked list
; 0001 0071     key->Previous = lastKey;
; 0001 0072     lastKey = key;
; 0001 0073     return 1;
; 0001 0074 #else
; 0001 0075     // find empty space for new key
; 0001 0076     {
; 0001 0077         uint8_t len = KEY_MAX_NUM;
; 0001 0078         Key** pKey = keys;
; 0001 0079         while (len--) {
	SBIW R28,3
	LDI  R30,LOW(_keys_G001)
	LDI  R31,HIGH(_keys_G001)
	ST   Y,R30
	STD  Y+1,R31
	LDI  R30,LOW(3)
	STD  Y+2,R30
;	*key -> Y+5
;	*config -> Y+3
;	len -> Y+2
;	*pKey -> Y+0
_0x2000E:
	LDD  R30,Y+2
	SUBI R30,LOW(1)
	STD  Y+2,R30
	SUBI R30,-LOW(1)
	BRNE PC+3
	JMP _0x20010
; 0001 007A             if (KEY_NULL == *pKey) {
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	SBIW R30,0
	BREQ PC+3
	JMP _0x20011
; 0001 007B                 *pKey = key;
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   X+,R30
	ST   X,R31
; 0001 007C                 return 1;
	LDI  R30,LOW(1)
	ADIW R28,3
	ADIW R28,4
	RET
; 0001 007D             }
; 0001 007E             pKey++;
_0x20011:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,2
	ST   Y,R30
	STD  Y+1,R31
; 0001 007F         }
	RJMP _0x2000E
_0x20010:
; 0001 0080     }
	ADIW R28,3
; 0001 0081     return 0;
	LDI  R30,LOW(0)
	ADIW R28,4
	RET
; 0001 0082 #endif // KEY_MAX_NUM == -1
; 0001 0083 }
; .FEND
;/**
; * @brief remove key from list
; *
; * @param remove address of key
; * @return uint8_t return 1 if key found, 0 if not found
; */
;uint8_t Key_remove(Key* remove) {
; 0001 008A uint8_t Key_remove(Key* remove) {
; 0001 008B #if KEY_MAX_NUM == -1
; 0001 008C     Key* pKey = lastKey;
; 0001 008D #else
; 0001 008E     Key** pKey = keys;
; 0001 008F #endif // KEY_MAX_NUM == -1
; 0001 0090     // find key
; 0001 0091     while (KEY_NULL != Key_ptr(pKey)) {
;	*remove -> Y+2
;	*pKey -> R16,R17
; 0001 0092     #if KEY_MAX_NUM == -1
; 0001 0093         // check key with remove key
; 0001 0094         if (remove == pKey->Previous) {
; 0001 0095             // deinit IO
; 0001 0096 					#if KEY_USE_DEINIT
; 0001 0097             if (keyDriver->deinitPin) {
; 0001 0098                 keyDriver->deinitPin(remove->Config);
; 0001 0099             }
; 0001 009A 					#endif
; 0001 009B             // remove key dropped from link list
; 0001 009C             pKey->Previous = remove->Previous;
; 0001 009D             remove->Previous = KEY_NULL;
; 0001 009E             return 1;
; 0001 009F         }
; 0001 00A0         pKey = pKey->Previous;
; 0001 00A1     #else
; 0001 00A2         if (remove == *pKey) {
; 0001 00A3             *pKey = KEY_NULL;
; 0001 00A4             return 1;
; 0001 00A5         }
; 0001 00A6         pKey++;
; 0001 00A7     #endif // KEY_MAX_NUM == -1
; 0001 00A8     }
; 0001 00A9     return 0;
; 0001 00AA }
;
;#if KEY_MULTI_CALLBACK
;void Key_onHold(Key* key, Key_Callback cb) {
;    key->Callbacks.onHold = cb;
;}
;void Key_onReleased(Key* key, Key_Callback cb) {
;    key->Callbacks.onReleased = cb;
;}
;void Key_onPressed(Key* key, Key_Callback cb) {
;    key->Callbacks.onPressed = cb;
;}
;#if KEY_NONE_CALLBACK
;void Key_onNone(Key* key, Key_Callback cb) {
;    key->Callbacks.onNone = cb;
;}
;#endif // KEY_NONE_CALLBACK
;#else
;void Key_onChange(Key* key, Key_Callback cb) {
; 0001 00BC void Key_onChange(Key* key, Key_Callback cb) {
_Key_onChange:
; .FSTART _Key_onChange
; 0001 00BD     key->Callbacks.onChange = cb;
	ST   -Y,R27
	ST   -Y,R26
;	*key -> Y+2
;	*cb -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	__PUTW1SNS 2,2
; 0001 00BE }
	ADIW R28,4
	RET
; .FEND
;#endif // KEY_MULTI_CALLBACK
;
;#if KEY_ACTIVE_STATE
;void Key_setActiveState(Key* key, Key_ActiveState state) {
;    key->ActiveState = (uint8_t) state;
;}
;Key_ActiveState Key_getActiveState(Key* key) {
;    return (Key_ActiveState) key->ActiveState;
;}
;#endif /* KEY_ACTIVE_STATE_ENABLE */
;
;#if KEY_ARGS
;void Key_setArgs(Key*, void* args) {
;    key->Args = args;
;}
;void* Key_getArgs(Key* key) {
;    return key->Args;
;}
;#endif
;#include "KeyPort.h"

	.DSEG
;#include "KeyIO.h"
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;#if KEY_HW == KEY_HW_AVR
;
;void Key_initPin(const Key_PinConfig* config) {
; 0002 0009 void Key_initPin(const Key_PinConfig* config) {

	.CSEG
_Key_initPin:
; .FSTART _Key_initPin
; 0002 000A     config->IO->Direction.Value &= ~config->Pin;
	ST   -Y,R27
	ST   -Y,R26
;	*config -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	ADIW R30,1
	MOVW R0,R30
	LD   R26,Z
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+2
	COM  R30
	AND  R30,R26
	MOVW R26,R0
	ST   X,R30
; 0002 000B     config->IO->OutputData.Value |= config->Pin;
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	ADIW R30,2
	MOVW R0,R30
	LD   R26,Z
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+2
	OR   R30,R26
	MOVW R26,R0
	ST   X,R30
; 0002 000C }
	ADIW R28,2
	RET
; .FEND
;uint8_t Key_readPin(const Key_PinConfig* config) {
; 0002 000D uint8_t Key_readPin(const Key_PinConfig* config) {
_Key_readPin:
; .FSTART _Key_readPin
; 0002 000E     return (config->IO->InputData.Value & config->Pin) != 0;
	ST   -Y,R27
	ST   -Y,R26
;	*config -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	LD   R26,Z
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+2
	AND  R30,R26
	LDI  R26,LOW(0)
	CALL __NEB12
	ADIW R28,2
	RET
; 0002 000F }
; .FEND
;#if KEY_USE_DEINIT
;void Key_deInitPin(const Key_PinConfig* config) {
;    config->IO->OutputData.Value &= ~config->Pin;
;}
;#endif
;
;#endif // KEY_HW
;
;
;

	.DSEG
_keyDriver_G000:
	.BYTE 0x4
_keyConfig1:
	.BYTE 0x3
_keyConfig2:
	.BYTE 0x3
_keyConfig3:
	.BYTE 0x3
_key1_G000:
	.BYTE 0x5
_key2_G000:
	.BYTE 0x5
_key3_G000:
	.BYTE 0x5
_keyDriver_G001:
	.BYTE 0x2
_keys_G001:
	.BYTE 0x6

	.CSEG

	.CSEG
__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
