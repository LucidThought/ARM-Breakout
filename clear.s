.global clearScreen
clearScreen:

push	{lr}

x	.req	r0
y	.req	r1
width	.req	r2
height	.req r3

mov	x,	#0
mov	y,	#0
ldr	width,	=1024
ldr	height,	=724
sub	height,	#1
sub r4,	width, #1
mpv	r6,	#0

rowLoop:
cmp	x,	height
bhi	done

columnLoop:
cmp	y, height
bhi	doneRow
ldr	r5,	=FrameBufferPointer
ldr	r5,	[r5]

mula	x,	y, width, x
add	r5,	x,	lsl #1
stbh	r6,	[r5]
add	y,	#1

doneRow:
add	x,	#1

done:


pop	{pc}
