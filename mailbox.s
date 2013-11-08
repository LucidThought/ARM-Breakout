/* Mailbox Write
 * Args:
 *	r0 - value (4 LSB must be 0)
 *  r1 - channel (only 4 LSB)
 */

.globl MailboxWrite
MailboxWrite:
	tst		r0, #0b1111			// if lower 4 bits of r0 != 0, return
	movne	pc, lr

	cmp		r1, #15				// if channel > 15, return
	movhi	pc, lr

	channel	.req	r1
	value	.req	r0

	mailbox	.req	r2
	ldr		mailbox,=0x2000B880		// load the base address of mailbox

wait1$:
	status	.req	r3
	ldr		status,	[mailbox, #0x18]	// read in the status register

	tst		status, #0x80000000			// test bit 31 (Full)
	.unreq	status
	bne		wait1$						// wait until mailbox not full

	orr		value, channel				// combine channel with value
	.unreq	channel

	str		value, [mailbox, #0x20]		// write value to the mailbox write register

	.unreq	value
	.unreq	mailbox

	mov		pc, lr						// return from the function

/* Mailbox Read
 * Args:
 *	r0 - channel
 * Return:
 * 	r0 - message
 */

.globl MailboxRead
MailboxRead:
	cmp		r0, #15						// return if channel > 15
	movhi	pc, lr

	channel	.req	r0
	mailbox	.req	r1

	ldr		mailbox,=0x2000B880			// load the mailbox address

wait2$:
	status	.req	r2
	ldr		status, [mailbox, #0x18]	// load the mailbox status

	tst		status, #0x40000000			// test bit 30 (Empty)

	bne		wait2$						// loop until mailbox not empty

	mail	.req	r2
	ldr		mail,	[mailbox, #0x00]	// load the message from the mailbox read register

	inchan	.req	r3
	and		inchan,	mail, #0b1111		// mask out the channel (4 LSB) from the message

	teq		inchan, channel
	.unreq	inchan
	bne		wait2$						// loop while channel of message is not the channel we want

	.unreq	mailbox
	.unreq	channel

	and		r0, mail, #0xfffffff0		// mask out message value (remove channel), store in return register

	.unreq	mail
	
	mov		pc, lr						// return

