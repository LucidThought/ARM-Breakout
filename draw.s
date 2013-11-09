
.section .text
.global drawHorizontalLine
/*r4 =start point(x), r5 = start point(y) , r7= length*/
drawHorizontalLine:
	push	{r4, r5, r6, r7, lr}
	x 	.req 	r0	
	y 	.req	r1	
	length	.req	r3	
	mov	x,	r4
	mov	y,	r5
	mov	length,	r7
	/*Check if the x and y values are in with in the range of the Frame Buffer*/
	
	mov	r4,	#1
	//draws the line
	hDrawLoop:
	cmp	r4,	length
	bhi	doneH
	mov	r2,	r6
	bl	drawPixel
	add	x,	x, #1
	
	doneH:
	.unreq	x
	.unreq	y
	.unreq	length
	pop {r4, r5, r6, r7, pc}

.global	drawVerticalLine
drawVerticalLine:
	push	{r4, r5, r6, r7, lr}
	x 	.req 	r0	
	y 	.req	r1	
	length	.req	r3	
	mov	x,	r4
	mov	y,	r5
	mov	length,	r7	
	/*Check if the x and y values are in with in the range of the Frame Buffer*/
	cmp	x,	#1024
	bhi	doneV
	cmp	y,	#724
	bhi	doneV
	mov	r3,	#0
	/*Draws vertical line*/
	vDrawLoop:
	add	r3,	#1
	bl	drawPixel
	add	x,	#1024
	cmp	r3,	length
	bhi	vDrawLoop
	doneV:
	.unreq	x
	.unreq	y
	.unreq	length
	pop {r4, r5, r6, r7, pc}


.section	.data
colour:
	.int	0xffffff	
width:
	.int	1024
height:
	.int	724
	
