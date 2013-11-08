// r0= x starting point, r1=y r2=height of box
. global drawBox
drawBox:

push	{}
xOffset		.req	r0
yOffset		.req	r1
length	.req	r2
mov	r3,	xOffset
mov	r4, 	yOffset
mov	r5,	length
ldr	r6,	=width
ldr	r6,	[r6]
sub	xOffset,		r6,	r3
sub	r6,	xoffset
mov	length,	r6
bl	drawHorizontal	Line
add	r1,	r1,	r5
mov	r0,	r3
bl	drawHorizontalLine
add	r0,	r3,	#1024
mov	yOffset,		r4
mov	length,	r5
bl	drawVerticalLine
mov	yOffset,		r4
mov	xOffset,		r3
bl	drawVerticalLine

.unreq	xOffset
.unreq	yOffset
.unreq	length
pop	{}

//r0=x, r1=y, 
. global drawGrid
drawGrid:

push{}

x	.req	r0
y	.req	r1
length	.req	r2
ldr	r6,	=GridNum
ldr	r6,	[r4, #0]
ldr	r5,	=BlockSize
ldr	r5,	[r5, #0]

maxY	req.	r3
maxX	req.	r4


mul	maxY, r6,r5

ldr	r6,	=GridNum
ldr	r6,	[r4, #4]
ldr	r5,	=BlockSize
ldr	r5,	[r5, #4]

mul	maxX,	r6,r5
ldr	y
ldr	r6,	=BlockSize
ldr	r6,	[r5, #0]
mov	length,	maxX


rows:
	cmp	y,maxY
	bhi	rowFin
	bl	drawHorizontalLine
	add	y,	r6
	b	rows	
rowFin:

mov	length,	maxY
mov	y,	r5
ldr	r6,	=BlockSize
ldr	r6,	[r5, #4]
columns:
	cmp	x,maxX
	bhi	columnFin
	bl	drawVerticalLine
	add	x,	r6
	b	columns	

.unreq	x
.unreq	y
.unreq	length
.unreq	maxX
.unreq	maxY

pop{}

.data

GridNum:
	.int	6, 30	//rows,columns
blockSize:
	.int	3	//h
	.int	5	//w
