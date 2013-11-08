.equ	GPPUD,			0x20200094
.equ	GPPUDCLK0,		0x20200098

.equ	AUX_ENABLES,	0x20215004
.equ	AUX_MU_IO_REG,	0x20215040
.equ	AUX_MU_IER_REG,	0x20215044
.equ	AUX_MU_IIR_REG,	0x20215048
.equ	AUX_MU_LCR_REG,	0x2021504C
.equ	AUX_MU_MCR_REG,	0x20215050
.equ	AUX_MU_LSR_REG,	0x20215054
.equ	AUX_MU_MSR_REG,	0x20215058
.equ	AUX_MU_SCRATCH,	0x2021505C
.equ	AUX_MU_CNTL_REG,0x20215060
.equ	AUX_MU_STAT_REG,0x20215064
.equ	AUX_MU_BAUD_REG,0x20215068

.section .text


/*A function to Set any GPIO given a certain pin# */
.globl setGPIOFunction     
setGPIOFunction:
	push	{lr}
	mov	r2, r0 
	ldr	r3,	=GPIOAddress
	ldr	r0,	[r3]

	GpioLoop$:
	// compute offset from GPIO address
	cmp	r2, #9		//compare r2 with 9
	//if it is less than 9 subtract 10 from pin number, and add 4 to the Gpio address
	subhi	r2, #10 
	addhi	r0, #4

	bhi	GpioLoop$ 	
	
	add	r2, r2, lsl #1
	lsl	r1, r2 
	mov	r3, #7
	lsl	r3, r2
	
	//load a word from address
	ldr	r2, [r0] 
	//clear the bits and store the value in the address
	bic	r2, r3
	orr	r1, r2
	str	r1, [r0]
	pop	{pc}

/**/
.globl UART
UART:
	push	{lr}
	//Enabling ENB, by storing 1 in the ENB register
	ldr	r0,	=AUX_ENABLES
	mov	r1,	#0x00000001
	str	r1,	[r0]					

	//Clearing the Interupt Enable register by set 0 in the register
	ldr	r0,	=AUX_MU_IER_REG
	and	r1,	#0
	str	r1,	[r0]					
	
	//enabling the control register
	ldr	r0,	=AUX_MU_CNTL_REG
	and	r1,	#0
	str	r1,	[r0]						
	
	//setting Line Control register
	ldr	r0,	=AUX_MU_LCR_REG
	mov	r1,	#0x00000003
	str	r1,	[r0]					
	
	//clearing MCR register
	ldr	r0,	=AUX_MU_MCR_REG
	and	r1,	#0
	str	r1,	[r0]					
	
	//Setting IIR status registers
	ldr	r0,	=AUX_MU_IIR_REG
	mov	r1,	#0x000000C6
	str	r1,	[r0]					
	
	//Set baud rate to 270
	ldr	r0,	=AUX_MU_BAUD_REG
	ldr	r2,	=Baud
	ldr	r1,	[r2]
	str	r1,	[r0]					
	//set Gpio 14 and 15
	mov	r0,	#14
	mov	r1,	#2
	bl	setGPIOFunction					
	
	mov	r0,	#15
	mov	r1,	#2
	bl	setGPIOFunction			
	
	// clear GPIO Pull-up/down register
	ldr	r0,	=GPPUD
	and	r1,	#0
	str	r1,	[r0]	
	//wait 150 cycles
	mov	r0,	#150
	bl	wait					
	//assert clock lines 14 & 15
	ldr	r0,	=GPPUDCLK0
	mov	r1,	#0x0000C000
	str	r1,	[r0]					
	
	// wait for 150 cycles
	mov	r0,	#150
	bl	wait						
	
	//clear GPIO Pull-up/down Clock register 0
	ldr	r0,	=GPPUDCLK0
	and	r1,	#0
	str	r1,	[r0]					
	
	// set Control register
	ldr	r0,	=AUX_MU_CNTL_REG
	mov	r1,	#3
	str	r1,	[r0]					
	
	pop		{pc}

//A delay loop, take r0 as the amount of cycles
wait:
	sub	r0,		#1
	cmp	r0,		#0
	bge	wait
	mov	pc,		lr
.section .data

GPIOAddress:	.int	0x20200000
Baud:	.int 	270
