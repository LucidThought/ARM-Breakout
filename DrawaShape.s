.section .text
    
.global drawBox
/* r0 is x, r1 is y, r2=lengthX,r3=lenghtY */
drawBox:
    
    push    {lr}

    x     .req     r0    
    y     .req    r1
    colour    .req    r2    
    length    .req    r3

    
    mov    r9,    r3

    mov    length,    r2

    ldr    colour,    =colourInt
    ldr    colour,    [colour, #4]
    ldr    r6,    =tempVar
    str    x,    [r6, #0]
    str    y,    [r6, #4]
    
    bl    drawHLine

    mov    r5,    r9
    ldr    x,    =tempVar
    ldr    x,    [x, #0]
    add    y,    r5

    bl    drawHLine


    mov    length,    r5
    mov    length, r9
    mov    r9,    r5
    
    ldr    colour,    =colourInt
    ldr    colour,    [colour, #0]

    ldr    x,    =tempVar
    ldr    x,    [x, #0]

    ldr    y,    =tempVar
    ldr    y,    [y, #4]


    bl    drawVLine

    ldr    x,    =tempVar
    ldr    x,    [x, #0]

    ldr    y,    =tempVar
    ldr    y,    [y, #4]

    add    x,    r9
    
    bl    drawVLine



    pop    {pc}

.global drawRect
/* r0 is x, r1 is y, r2=lengthX,r3=lenghtY */
drawRect:
    
    push    {lr}

    x     .req     r0    
    y     .req    r1
    colour    .req    r2    
    length    .req    r3

    mov    r9,    r3
    add    r9,    y
    mov    length,    r2
    fillLoop:
    cmp    y,    r9
    bhi    fDone
    
    ldr    colour,    =colourInt
    ldr    colour,    [colour, #0]
    ldr    r6,    =tempVar
    str    x,    [r6, #0]
    str    y,    [r6, #4]
    
    bl    drawHLine

    ldr    x,    =tempVar
    ldr    x,    [x, #0]
    add    y,    #1

    b    fillLoop

    fDone:

    .unreq    x
    .unreq    y
    .unreq    colour
    .unreq    length    

    pop    {pc}
        

/*r0=x, r1=y*/    
.global drawGrid
drawGrid:
    push    {lr}

    x     .req     r0    
    y     .req    r1
    colour    .req    r2
    length    .req    r3
    ldr    r6,    =tempVar
    str    x,    [x, #0]
    
    ldr    r6,    =tempVar
    str    y,    [y, #4]

    ldr    colour,    =colourInt
    ldr    colour,    [colour, #4]
    
    ldr    r6,    =blockInfo
    ldr    r4,    [r6, #0]
    ldr    r5,    [r6, #8]
    
    mul    length,    r4,r5

    ldr    r10,    [r6, #4]

    
    rows:
    cmp    r10,    #0
    bls    rowsE
    
    bl    drawHLine
    
    ldr    x,    =tempVar
    ldr    x,    [x, #0]

    ldr    y,    =tempVar
    ldr    y,    [y, #4]

    ldr    r6,    =blockInfo
    ldr    r6,    [r6, #8]

    add    y,    r6

    ldr    r6,    =tempVar
    str    y,    [r6, #4]
    
    sub    r10, #1
    
    b    rows

    rowsE:

    ldr    r6,    =blockInfo
    ldr    r4,    [r6, #4]
    ldr    r5,    [r6, #12]

    mul    length,    r4,r5        
    
    ldr    r10,    [r6, #0]

    columns:
    cmp    r10,    #0
    bls    columnsE
    
    bl    drawVLine
    
    ldr    x,    =tempVar
    ldr    x,    [x, #0]

    ldr    y,    =tempVar
    ldr    y,    [y, #4]
    
    ldr    r6,    [r6, #12]
    add    x,    r6

    ldr    r6,    =tempVar
    str    x,    [r6, #0]
    
    sub    r10, #1
    
    b    columns
    
    columnsE:

    pop    {pc}
    

.section .data
.align 4

colourInt:
    .int    0xffCCff
    .int    0xffffff
LTemp:
    .int

tempVar:
    .int    //x
    .int    //y

blockInfo:
    .int    10    //number x
    .int    5    //number y
    .int    5    //w
    .int    10    //l
