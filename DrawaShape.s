// r0= x starting point, r1=y r2=height of box
. global drawBox
drawBox:

push	{lr}
xOffset		.req	r0
yOffset		.req	r1
length	.req	r2
mov	r3,	xOffset
mov	r4,   yOffset
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
pop	{pc}

//r4=x, r5=y
. global drawGrid
drawGrid:

push{r4,r5, r6, lr}

x	.req	r4
y	.req	r5
colour .req r6
mov  x, r4
mov  y, r5

//gets the number of blocks in the grid and the size of each block
ldr	r0,	=GridNum
ldr	r0,	[r0, #0]
ldr	r1,	=BlockSize
ldr	r1,	[r1, #0]

maxY	req.	r2
maxX	req.	r3

//get length y axis of the grid
mul	maxY, r0,r1

ldr	r0,	=GridNum
ldr	r0,	[r0, #4]
ldr	r1,	=BlockSize
ldr	r1,	[r1, #4]

//gets length of the x axis of the grid
mul	maxX,	r0,r1

ldr	r0,	=BlockSize
ldr	r0,	[r0, #0]

mov  r1, y
//draws the rows
rows:
	cmp	y,maxY
	bhi	rowFin
	bl	drawHorizontalLine
	add	y,	r0
	b	rows	
rowFin:


mov	y,	r1


ldr	r0,	=BlockSize
ldr	r0,	[r0, #4]
//draws the colunms
mov r1, x
columns:
	cmp	x,maxX
	bhi	columnFin
	bl	drawVerticalLine
	add	x,	r0
	b	columns	

.unreq	x
.unreq	y

.unreq	maxX
.unreq	maxY

pop{r4,r5, r6, pc}

.data

GridNum:
	.int	6, 30	//rows,columns
blockSize:
	.int	3	//h
	.int	5	//w
