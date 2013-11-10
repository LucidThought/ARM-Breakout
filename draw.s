
.global drawHLine
/*r4 =start point(x), r5 = start point(y) , r7= length*/
drawHLine:
    push    {lr}
    x     .req     r0    
    y     .req    r1
    colour    .req    r2    
    length    .req    r3    
    
    /*Check if the x and y values are in with in the range of the Frame Buffer*/
    
    mov    r8,    #0
    mov    r5,    length
    //draws the line
    hDrawLoop:
    mov    r7,    x
    

    cmp    r8,    length
    bhi    doneH
    
    bl    drawPixel
    mov    x,    r7
    add    x,    #1
    mov    length,    r5
    add    r8,    #1
    
    b hDrawLoop
    doneH:
    .unreq    x
    .unreq    y
    .unreq    length
    pop    {pc}

.global drawVLine
/*r4 =start point(x), r5 = start point(y) , r7= length*/
drawVLine:
    push    {lr}
    x     .req     r0    
    y     .req    r1
    colour    .req    r2    
    length    .req    r3    
    
    /*Check if the x and y values are in with in the range of the Frame Buffer*/
    
    mov    r8,    #0
    mov    r5,    length
    //draws the line
    VDrawLoop:
    mov    r7,    x
    

    cmp    r8,    length
    bhi    doneV
    
    bl    drawPixel
    mov    x,    r7
    add    y,    #1
    mov    length,    r5
    add    r8,    #1
    
    b VDrawLoop
    doneV:
    .unreq    x
    .unreq    y
    .unreq    length
    pop    {pc}

