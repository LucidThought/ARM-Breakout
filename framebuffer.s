.section .data
.align 12

FrameBufferInfo:
	.int	1024		// 0 - Width
	.int	768			// 4 - Height
	.int	1024		// 8 - vWidth
	.int	768			// 12 - vHeight
	.int	0			// 16 - Pitch (set by GPU)
	.int	16			// 20 - Bit Depth (bpp)
	.int	0			// 24 - X virtual offset
	.int	0			// 28 - Y virtual offset
	.int	0			// 32 - Framebuffer Pointer (set by GPU)
	.int	0			// 36 - Framebuffer Size (set by GPU)

.align 4
.globl FrameBufferPointer
FrameBufferPointer:
	.int	0

.section .text

/* Initialize the FrameBuffer
 * Return:
 *	r0 - message
 */

.globl InitFrameBuffer
InitFrameBuffer:
	push	{r4, lr}
	infoAdr	.req	r4
	result	.req	r0	

	ldr		infoAdr, =FrameBufferInfo

	mov		r0, infoAdr
	mov		r1, #1
	bl		MailboxWrite			// write FrameBufferInfo address to channel 1 (FrameBuffer) on the mailbox interface

	mov		r0, #1
	bl		MailboxRead				// read from channel 1 (FrameBuffer) on the mailbox interface

	teq		result, #0
	movne	result, #0
	popne	{r4, pc}

pointerWait$:
	ldr		result, [infoAdr, #32]	// load the value of the framebuffer pointer
	teq		result, #0
	beq		pointerWait$			// loop while the pointer is still 0

	ldr		r1,		=FrameBufferPointer
	str		result, [r1]			// store the framebuffer pointer

	mov		result, infoAdr
	pop		{r4, pc}

	.unreq	result
	.unreq	infoAdr


//r0 = x
//r1 = y
//r2 = colour
.global drawPixel

drawPixel:
	/* r0 is x, r1 is y and r3 is addr*/
	
	
	/* r0 is x, r1 is y and r3 is addr*/
	x	.req	r0
	y	.req	r1
	addr	.req	r3

	ldr	addr,	=FrameBufferInfo
	ldr	addr,	[addr]
	
	height	.req	r4
	ldr	height,	[addr, #4]
	sub	height,	#1
	cmp	y,	height
	movhi	pc,	lr
	.unreq	height
	width	.req	r4
	ldr	width,	[addr,	#0]
	cmp	x,	width
	sub	width,	#1
	movhi	pc,	lr
	
	ldr	addr,	=FrameBufferPointer
	ldr	addr,	[addr]
	
	mla	x,	width,y, x
	.unreq	width
	.unreq	y

	add	addr,	x, lsl #1
	.unreq	x
	
	strh	r2,	[addr]
	.unreq	addr	

	mov	pc,	lr
