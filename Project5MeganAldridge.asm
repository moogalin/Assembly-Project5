
TITLE Program 5    (program5MeganAldridge.asm)

; Author: Megan Aldridge
; OSU Email : aldridme@oregonstate.edu
; Class & Section: CS271 - 400
; Assignment Number : 5
; Due Date : 2 / 28 / 2016
; Description: This program will allow the user to choose between 
;		10 and 200 random integers. The random integers will be generated
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
						;BYTE	"**EC: Program numbers the line of each user input", 0dh, 0ah, 0
userInstructString		BYTE	"How many numbers should be generated? [10 ... 200]: ", 0
invalidInputString		BYTE	"Invalid input", 0dh, 0ah, 0
unsortedString			BYTE	"The unsorted random numbers:", 0dh, 0ah, 0
medianString			BYTE	"The median is ", 0
sortedString			BYTE	"The sorted random numbers:", 0dh, 0ah, 0
arrayRand				DWORD	200 DUP(?)
;arrayCount				DWORD	0
userRequest				DWORD	?
;randInt				DWORD	?
endString				BYTE	" Made it back", 0dh, 0ah, 0



.code
main PROC
		call	Randomize

		push	OFFSET	introString				; pass introString by reference
		call	intro

		push	OFFSET	invalidInputString
		push	OFFSET	userRequest				; 
		push	OFFSET	userInstructString	
		call	getData


		push	userRequest
		push	OFFSET arrayRand
		call	fillArray

		push	userRequest
		push	OFFSET arrayRand
		push	OFFSET unsortedString
		call	displayList				; before sorting

		call	sortList
		call	displayMedian

		push	userRequest
		push	OFFSET arrayRand
		push	OFFSET sortedString
		call	displayList				; after sorting 

		mov		edx, OFFSET endString
		call	WriteString
		exit							; exit to operating system
main ENDP

;Procedure to display introductory statement to user. 
;receives:			OFFSET of intro string
;returns:			none
;preconditions:		none
;registers changed: edx used but push/popad preserved register value

intro PROC
		push	ebp
		mov		ebp, esp
		pushad

		mov		edx, [ebp+8]
		call	WriteString
		call	Crlf

		popad
		mov		esp, ebp
		pop		ebp
		ret		4
intro ENDP



;Procedure to receive and validate userRequest integer. 
;receives:			OFFSET for the following strings: invalid userInstruct and invalidInput.
;					OFFSET for integer data userRequest
;returns:			user input in variable userRequest 
;preconditions:		none
;registers changed: eax, edx, and ebx used but push/popad preserved register values

getData PROC
		push	ebp
		mov		ebp, esp
		pushad

	beginGetData:
		mov		edx, [ebp+8]
		call	WriteString
		call	ReadInt
		cmp		eax, user_MIN
		jl		invalidMessage
		cmp		eax, user_MAX
		jg		invalidMessage
		jmp		endGetData

	invalidMessage:
		mov		edx, [ebp+16]
		call	WriteString
		jmp		beginGetData

	endGetData:
		mov		ebx, [ebp+12]
		mov		[ebx], eax

		popad
		mov		esp, ebp
		pop		ebp
		ret		12
getData ENDP



;Procedure to fill an array with user defined set of random integers. 
;receives:			OFFSET for the array and the number of integers chosen by the user (userRequest)
;					OFFSET for the string indicating whether the array is sorted or unsorted
;returns:			An array filled with #userRequest elements (random integers between 100 and 999) 
;preconditions:		none
;registers changed: ecx, edi, and eax used but push/popad preserved register values

fillArray PROC
		push	ebp
		mov		ebp, esp
		pushad

		mov		ecx, [ebp+12]
		mov		edi, [ebp+8]
	
	fillArrayLoop:

		mov		eax, rand_HIGH				;cite slides
		sub		eax, rand_LO
		inc		eax
		call	RandomRange
		add		eax, rand_LO
		;push	eax
		;call	WriteDec
		;mov		al, ' '
		;call	WriteChar
		;pop		eax
		mov		[edi], eax
		add		edi, 4
		mov		eax, 0

		loop	fillArrayLoop
	

		popad
		mov		esp, ebp
		pop		ebp
		ret		8
fillArray ENDP



sortList PROC
ret
sortList ENDP



;Procedure to display an array with user defined set of random integers. 
;receives:			OFFSET for the array and the number of integers chosen by the user (userRequest)
;returns:			Random integers between 100 and 999 fill the array in #userRequest elements
;preconditions:		none
;registers changed: ecx, edi, and eax used but push/popad preserved register values
displayList PROC
		push	ebp
		mov		ebp, esp
		pushad
		
		call	Crlf
		mov		edx, [ebp+8]
		call	WriteString
		call	Crlf

		mov		esi, [ebp+12]		;Array offset
		mov		ecx, [ebp+16]		;
		mov		ebx, 0				;counter variable

	beginDisplay:
		mov		eax, [esi]
		call	WriteDec
		mov		al, ' '
		call	WriteChar
		inc		ebx
		cmp		ebx, 10
		jne		loopAgain
	newRow:
		call	Crlf
		mov		ebx, 0
	loopAgain:
		add		esi, 4
		loop	beginDisplay



		popad
		mov		esp, ebp
		pop		ebp
		ret		12
displayList ENDP

displayMedian PROC
ret
displayMedian ENDP


END main
