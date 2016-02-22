
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
randInt					DWORD	?
endString				BYTE	"Made it back", 0dh, 0ah, 0



.code
main PROC
		call	Randomize

		push	OFFSET	introString				; pass introString by reference
		call	intro

		push	OFFSET	invalidInputString
		push	OFFSET	userRequest				; 
		push	OFFSET	userInstructString	
		call	getData

		mov		eax, userRequest
		call	WriteDec
		call	fillArray
		call	sortList
		call	displayList				; before sorting
		call	displayMedian
		call	displayList				; after sorting 

		mov		edx, OFFSET endString
		call	WriteString
		exit							; exit to operating system
main ENDP

;Procedure to display introductory statement to user. 
;receives:			OFFSET of intro string
;returns:			none
;preconditions:		none
;registers changed: none

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
;returns:			user input in global userRequest 
;preconditions:		none
;registers changed: none
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


fillArray PROC
ret
fillArray ENDP


sortList PROC
ret
sortList ENDP


displayList PROC
ret
displayList ENDP

displayMedian PROC
ret
displayMedian ENDP


END main
