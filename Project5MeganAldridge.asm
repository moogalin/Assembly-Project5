
TITLE Program 5    (program5MeganAldridge.asm)

; Author: Megan Aldridge
; OSU Email : aldridme@oregonstate.edu
; Class & Section: CS271 - 400
; Assignment Number : 5
; Due Date : 2 / 28 / 2016
; Description: This program will allow the user to choose between 
;		10 and 200 random integers. The random integers will be generated,
;		input into an array, displayed, sorted, and displayed again. 
INCLUDE Irvine32.inc

; constants
user_MIN = 10
user_MAX = 200

rand_LO = 100
rand_HIGH = 999

.data

introString				BYTE	"Sorting Random Integers         Programmed by Megan Aldridge", 0dh, 0ah 
						BYTE	"This program generates random numbers in the range [100 ... 999], ", 0dh, 0ah
						BYTE	"displays the original list, sorts the list, and calculates the, ", 0dh, 0ah
						BYTE	"median value. Finally, it displays the list sorted in descending order. " , 0dh, 0ah, 0
userInstructString		BYTE	"How many numbers should be generated? [10 ... 200]: ", 0
invalidInputString		BYTE	"Invalid input", 0dh, 0ah, 0
unsortedString			BYTE	"The unsorted random numbers:", 0dh, 0ah, 0
medianString			BYTE	"The median is ", 0
sortedString			BYTE	"The sorted random numbers:", 0dh, 0ah, 0
arrayRand				DWORD	200 DUP(?)
userRequest				DWORD	?
;endString				BYTE	" Made it back", 0dh, 0ah, 0



.code
main PROC
		call	Randomize				; seed Randomize procedure

		push	OFFSET	introString		
		call	intro

		push	OFFSET	invalidInputString
		push	OFFSET	userRequest				
		push	OFFSET	userInstructString	
		call	getData


		push	userRequest
		push	OFFSET arrayRand
		call	fillArray

		push	userRequest
		push	OFFSET arrayRand
		push	OFFSET unsortedString
		call	displayList				; before sorting

		push	userRequest
		push	OFFSET arrayRand
		call	sortList

		push	OFFSET medianString
		push	userRequest
		push	OFFSET arrayRand
		call	displayMedian

		push	userRequest
		push	OFFSET arrayRand
		push	OFFSET sortedString
		call	displayList				; after sorting 

		;mov		edx, OFFSET endString
		;call	WriteString
		exit							; exit to operating system
main ENDP

;*******************************************************************
;Procedure to display introductory statement to user. 
;receives:			OFFSET of intro string
;returns:			none
;preconditions:		none
;registers changed: edx used but push/popad preserved register value
;*******************************************************************

intro PROC
		push	ebp
		mov		ebp, esp
		pushad

		mov		edx, [ebp+8]			; introString offset
		call	WriteString
		call	Crlf

		popad
		mov		esp, ebp
		pop		ebp
		ret		4
intro ENDP


;*******************************************************************
;Procedure to receive and validate userRequest integer. 
;receives:			OFFSET for the following strings: invalid userInstruct and invalidInput.
;					OFFSET for integer data userRequest
;returns:			user input in variable userRequest 
;preconditions:		none
;registers changed: eax, edx, and ebx used but push/popad preserved register values
;*******************************************************************
getData PROC
		push	ebp
		mov		ebp, esp
		pushad

	COMMENT	!***************************************************************************
	While user data is less than user_MIN or greater than user_MAX, program jumps to invalidMessage label. 
	After the invalidMessage label is triggered, program jumps to beginGetData label.
	If the invalidMessage label is not triggered, program jumps to endGetData where user data is stored in the
	address of userRequest.
	***********************************************************************************!
	beginGetData:
		mov		edx, [ebp+8]			; userInstructString offset
		call	WriteString
		call	ReadInt
		cmp		eax, user_MIN
		jl		invalidMessage
		cmp		eax, user_MAX
		jg		invalidMessage
		jmp		endGetData

	invalidMessage:
		mov		edx, [ebp+16]			; invalidInputString offset
		call	WriteString
		jmp		beginGetData

	endGetData:
		mov		ebx, [ebp+12]			; userRequest offset
		mov		[ebx], eax
		

		popad
		mov		esp, ebp
		pop		ebp
		ret		12
getData ENDP


;*******************************************************************
;Procedure to fill an array with user defined set of random integers. 
;receives:			OFFSET for the array
;					Received by value: The number of integers chosen by the user (userRequest)
;					OFFSET for the string indicating whether the array is sorted or unsorted
;returns:			An array filled with #userRequest elements (random integers between 100 and 999) 
;preconditions:		none
;registers changed: ecx, edi, and eax used but push/popad preserved register values
;*******************************************************************
fillArray PROC
		push	ebp
		mov		ebp, esp
		pushad

		mov		ecx, [ebp+12]			; Value for user request saved as loop counter				
		mov		edi, [ebp+8]			; OFFSET of first value in array of random integers


	COMMENT	!***************************************************************************
	fillArrayLoop genereates a random number in the range rand_LO <= number <= rand_HIGH. 
	The address OFFSET of the array is incremented to the next element of the array after
	each assignment of one random integer to an array element. 
	REFERENCE: Week 8 Lecture 20 Slide 7
	***********************************************************************************!	
	fillArrayLoop:

		mov		eax, rand_HIGH				
		sub		eax, rand_LO				
		inc		eax							
		call	RandomRange				
		add		eax, rand_LO				
		mov		[edi], eax				; Assign random integer to array element
		add		edi, 4					; Point to next array element
		mov		eax, 0					; Reset random integer

		loop	fillArrayLoop
	

		popad
		pop		ebp
		ret		8
fillArray ENDP


;*******************************************************************
;Procedure to sort (ascending order) an array with user defined set of random integers. 
;receives:			OFFSET for the array and the number of integers chosen by the user (userRequest)
;returns:			Random integers between 100 and 999 fill the array (in ascending order) in #userRequest elements
;preconditions:		none
;registers changed: ecx, edi, and eax used but push/popad preserved register values
;*******************************************************************
sortList PROC
		push	ebp
		mov		ebp, esp
		pushad

		mov		ecx, [ebp+12]			; Value for user request saved as loop counter 
		dec		ecx

	COMMENT	!***************************************************************************
	Implementing the Bubble Sort Algorithm:
	The outer loop resets edi to point to the first element in the array and protects the
	value of ecx, the loop counter, from changes inside the inner loop. 
	Inside the inner loop,  two consecutive array elements are compared. If the second 
	element is less than the first, edi is incremented to point to the next pair of array 
	elements. If not, the value of the two array elements are exchanged. This comparison
	continues until the end of the innerLoop. Then, the outerloop decrements the loop counter
	and one less comparison occurs insid the innersortLoop. This is because with each 
	complete iteration of the innerSortLoop, the last value in the array is the new 
	smallest random integer. 
	REFERENCE: Assembly Language Textbook, page 375
	***********************************************************************************!	
	outerSortLoop:
		push	ecx						; Protect loop counter
		mov		edi, [ebp+8]			; Point to first element in array

	innerSortLoop:
		mov		eax, [edi]
		cmp		[edi+4], eax			; Compare consecutive array elements
		jl		endInnerSortLoop
		xchg	eax, [edi+4]			; Swap elements if first element is less than second
		mov		[edi], eax

	endInnerSortLoop:
		add		edi, 4					; Point to next element in array
		loop	innerSortLoop

		pop		ecx
		loop	outerSortLoop

	endOuterSortLoop:
		popad
		pop		ebp
		ret		8

sortList ENDP


;*******************************************************************
;Procedure to display an array with user defined set of random integers. 
;receives:			OFFSET for the array and the number of integers chosen by the user (userRequest)
;returns:			Random integers between 100 and 999 fill the array in #userRequest elements
;preconditions:		none
;registers changed: ecx, edi, and eax used but push/popad preserved register values
;*******************************************************************
displayList PROC
		push	ebp
		mov		ebp, esp
		pushad
		
		call	Crlf
		mov		edx, [ebp+8]		; sorted/unsorted String offset
		call	WriteString
		call	Crlf

		mov		esi, [ebp+12]		; Array offset
		mov		ecx, [ebp+16]		; loop counter (# of array elements)
		mov		ebx, 0				; counter variable for number of row elements

	beginDisplay:
		mov		eax, [esi]
		call	WriteDec
		mov		al, ' '				; insert space between integers
		call	WriteChar
		inc		ebx
		cmp		ebx, 10				; if 10 elements in row, create new Row
		jne		loopAgain
	newRow:
		call	Crlf
		mov		ebx, 0
	loopAgain:
		add		esi, 4
		loop	beginDisplay
		call	Crlf



		popad
		pop		ebp
		ret		12
displayList ENDP

;*******************************************************************
;Procedure to compute and display Median value in the array of random integers
;receives:			OFFSET for the array and the number of integers chosen by the user (userRequest)
;returns:			Random integers between 100 and 999 fill the array in #userRequest elements
;preconditions:		none
;registers changed: ecx, edi, edx, ebx, and eax used but push/popad preserved register values
;*******************************************************************
displayMedian PROC
		push	ebp
		mov		ebp, esp
		pushad

		mov		edi, [ebp+8]		; OFFSET array
		mov		ecx, [ebp+12]		 ;userRequest (# of array elements)

		mov		eax, ecx			
		mov		ebx, 2
		xor		edx, edx			; clear edx
		div		ebx					; eax contains userRequest divided by 2, edx contains remainder
		cmp		edx, 0				; divide userRequest by 2 to determine if even or odd
		je		evenInt
		
COMMENT	!***************************************************************************
Compute Median in Odd List:
Since the median is the the middle array element in an array with an odd number of 
elements, we only need to adjust the base-index address to the middle array element. 
The middle array element is TYPE * element number. In this case, TYPE is 4 (DWORD).
The element number of the middle element in an odd array is (# of elements in Array) / 2
(since division rounds down). For example, in a 9 element array, the middle element is
9/2 = 4. 
***********************************************************************************!		
	oddInt:
										
		mov		ebx, 4				; eax contains userRequest divided by 2
		mul		ebx					; multiply eax by 4 (DWORD = 4 BYTES)
		mov		eax, [edi+eax]		; eax contains integer at middle array element
		jmp		endDisplayMedian

COMMENT	!***************************************************************************
Compute Median in Even List:
Computing the median in an even list begins just like an odd list. We reference one 
of the two middle integers by base-index addressing as before. Now, we save that 
first middle integer in register edx. Next, we subtract 4 from our base-index 
address to generate the next middle integer. Then, we add together our median integers
and divide by two to compute their average (the median). Since integer division 
rounds 0.5 down to 0, we increment our median if there is a remainder. 
***********************************************************************************!	
	evenInt:
		mov		ebx, 4				; eax contains userRequest divided by 2
		mul		ebx					; multiply eax by 4 (DWORD = 4 BYTES)
		mov		edx, [edi+eax]		; save base-index address of first middle value
		sub		eax, 4				; find second middle value
		add		edx, [edi+eax]		; add middle values
		mov		eax, edx
		mov		ebx, 2
		xor		edx, edx			; clear edx
		div		ebx					; divide by 2 to compute average (median)
		cmp		edx, 1
		jne		endDisplayMedian
		inc		eax					; round 0.5 up to 1.0 
		jmp		endDisplayMedian

	endDisplayMedian:
		mov		edx, [ebp+16]		; OFFSET medianString
		call	Crlf
		call	WriteString	
		call	WriteDec			; display middle array element (or average)
		call	Crlf

		popad
		pop		ebp
		ret		12
displayMedian ENDP


END main
