.org 0
lar r2,MYVGA ; r2 holds the frame buffer base address
la r29,BTN ; r29 holds the button module address


la r1,1 ; "Shake" the screen
la r31,LOOP1
la r24,LOOP2
lar r4,2097152
la r6, LEFT
la r7, UP
la r8, DOWN
la r9, RIGHT
lar r30,MYVGA ; Use the base address
lar r26,MYVGA ; third cursor
add r11,r2,r2
la r17,10000 ;10K clk ticks
la r18,SHAKE
la r23,0
la r27,DELAY
la r28,TOP

LOOP1: 

	st r1,0(r30) ; Write a pixel
	addi r30,r30,4 ; Point to the next pixel
	and r3,r30,r2 ; Check for the end of the framestore
	brnz r31,r3 ; Repeat until r30 points past the framestore
	brnz r24,r22 ; Branch to Loop2 if r22 is a nonzero
	lar r30,MYVGA ; Write upper left pixel black
	la r1,0 ; Set r1 to black
	st r1,0(r26) ; Write upper left pixel black
	br r27

LOOP2: 

	la r30,0(r22) ; Start in final cursor position
	la r1,0 ; Set r1 to black
	st r1,0(r30) ; Start in final cursor position
	br r27

	DELAY: 
		addi r17,r17,-1 ;deducts 1 from 10K
		brnz r27,r17 ;branch back to DELAY if nonzero, when
		la r17,10000
		br r28

	TOP:
		ld r5,0(r29) ; load the memory from address r29 to r5
		andi r20,r5,31 
		brzr r28,r20
		br r9

	RIGHT:
		andi r13,r5,1 ;right
		brzr r6,r13 ; branch to left; in binary, the code will either return a 1 or 0 when ANDed
		;sub r21,r30,r11
		;brzr r6,r21
		addi r26,r26,4 ; Point to the rightmost pixel
		st r23,0(r26) ; Write a pixel
		;la r22,0(r26)

	LEFT:
		andi r14,r5,2 ;left
		brzr r7,r14 ; branch to UP
		;sub r21,r30,r4
		;brzr r7,r21
		;addi r21,r30,-1
		;brmi r7,r21
		addi r26,r26,-4 ; Point to the leftmost pixel
		st r23,0(r26) ; Write a pixel
		;la r22,0(r26)

	UP:
		andi r15,r5,4 ;up
		brzr r8,r15 ; branch to DOWN
		;addi r21,r30,-4096
		;brmi r8,r21
		;addi r17,r17,-1
		;brnz r7,r17
		addi r26,r26,-4096 ; Point to the next pixel
		st r23,0(r26) ; Write a pixel
		;la r22,0(r26)

	DOWN:
		andi r16,r5,8 ;down
		brzr r18,r16 ; branch back to Loop 2 if the button is not pressed
		;addi r21,r30,4096
		;sub r21,r21,r11
		;brnz r25,r21 ;if r22 is a nonzero, branch back to Loop 2
		;addi r17,r17,-1
		;brnz r8,r17
		addi r26,r26,4096 ; Point to the next pixel
		st r23,0(r26) ; Write a pixel
		;la r22,0(r26)

	SHAKE:
		andi r19,r5,16
		brzr r27,r19 ; branch back to Loop 2 if the button is not pressed
		la r1,1 ; change the color back to white
		brnz r31,r19;


stop

.org 2097152
MYVGA: .dw 524288
;END: nop
.org -4
BTN: .dw 1
