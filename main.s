.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
	bl EnableJTAG
	
	bl	UART
	
	bl	InitFrameBuffer
	mov	r0,	#10
	mov	r1,	#10
	mov	r2,	#0x000000
	bl	drawPixel
	    
Done:
	b Done

.section .data
.align 4






