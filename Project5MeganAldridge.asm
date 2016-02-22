
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
lowerLimitUser = 10
upperLimitUser = 200

lowerLimitRand = 100
upperLimitRand = 999

.data

introString				BYTE	"Sorting Random Integers         Programmed by Megan Aldridge" 
						BYTE	"This program generates random numbers in the range [100 ... 999], ", 0dh, 0ah
						BYTE	"displays the original list, sorts the list, and calculates the, ", 0dh, 0ah
						BYTE	"median value. Finally, it displays the list sorted in descending order. " , 0
						;BYTE	"**EC: Program numbers the line of each user input", 0dh, 0ah, 0
userInstructString		BYTE	"How many numbers should be generated? [10 ... 200]: ", 0dh, 0ah, 0
invalidInputString		BYTE	"Invalid input", 0dh, 0ah, 0
unsortedString			BYTE	"The unsorted random numbers:", 0dh, 0ah, 0
medianString			BYTE	"The median is ", 0
sortedString			BYTE	"The sorted random numbers:", 0dh, 0ah, 0


.code
main PROC
	
	call intro
	call getData
	call fillArray
	call sortList
	call displayList		; before sorting
	call displayMedian
	call displayList		; after sorting 

	exit	; exit to operating system
main ENDP

intro PROC
ret
intro ENDP


;Procedure to get values for userData. This Procedure calls another 
;	procedure to perform validation. 
;receives:			none
;returns:			none
;preconditions:		none
;registers changed: edx, eax 
getData PROC
ret
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
