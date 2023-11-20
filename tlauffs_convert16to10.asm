section .data
	newline: db 0x0a 
	num: db 'num'
	printnum: dd 'printnum'
	komma: db ','
	kommaLen: equ $-komma
	decNum: db "decinal number = " 
	decLen: equ $-decNum
	hexNum: db "hexadecimal number = 0x"
	hexLen: equ $-hexNum
	errorMsg: db "error: inkorrektes zeichen"
	errorLen: equ $-errorMsg
	errorMsg2: db "error: Zahl ist laenger als 8 Stellen"
	error2Len: equ $-errorMsg2

section .bss

section .text
	global _start:

_start:
	mov eax, 4 ; "hexadecimal number = 0x" wird ausgegeben
	mov ebx, 1
	mov ecx, hexNum
	mov edx, hexLen
	int 0x80

	pop ecx 
	pop ecx
	pop ecx	; Hexadecimal Zahl wird von Stack in ecx getan	
	push ecx ; Hexadecimal Zahl wird im stack gespeichert


	mov eax, 4 
	mov ebx, 1
	mov edx, 0
	mov esi, 0 ; Zaehler der prueft ob eingabe weniger als 8 Ziffern hat
lenHexNum: ; durchlauft ecx (eingegebene Zahl) und speichert ihre laenge in edx
	cmp [ecx], byte 0 ; wenn die Zahl komplett durchlaufen ist gehe zu printHexnum
	je printHexNum
	cmp [ecx], byte 30h ; ueberprueft ob die Ziffer zwischen 0-F liegt
	jl error
	cmp [ecx], byte 46h ; ueberprueft ob die Ziffer zwischen 0-F liegt
	jg error
	inc esi
	cmp esi, 8 ; prueft ob eingabe weniger als 8 Ziffern hat
	jge overflowError
	inc edx
	inc ecx ; geht zur naechste stelle von ecx
	jmp lenHexNum


overflowError:
	mov eax, 4 ; geht in eine newline
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80

	mov eax, 4 ; gibt overflow Error aus 
	mov ebx, 1
	mov ecx, errorMsg2
	mov edx, error2Len
	int 0x80
	jmp exit ; beendet das Program

error:
	mov eax, 4 ; geht in eine newline
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80

	mov eax, 4 ; gibt inkorrektes Zeichen error aus
	mov ebx, 1
	mov ecx, errorMsg
	mov edx, errorLen
	int 0x80	
	jmp exit ;beendet das Program

printHexNum: 
	pop ecx ; Hexadecimalzahl wird in ecx getan
	int 0x80 ; Zahl wird geprinted
	
	push ecx ; ecx im stack speichert
	mov eax, 4 ;newline
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80
	
	mov eax, 4 ; "decimal number = " wird ausgegeben
	mov ebx, 1
	mov ecx, decNum
	mov edx, decLen
	int 0x80

	pop ecx ; Hexadecimalzahl wird in ecx getan
	mov edi, 0 ; Zaehler (Anzahl der Ziffern)
pushloop: ; pushed jede Ziffer der Hexadecimal zahl in den Stack 
	cmp [ecx], byte 0
	je startconvert
	movzx eax, byte[ecx]
	push eax
	inc ecx
	inc edi
	jmp pushloop

startconvert: ; wandelt die hexadecimal Zahl in Decimal um
	mov ecx, 0
	mov eax, 0 ; eax ist die decimal Zahl
	mov edx, 1 ; edx ist der multipikator
convert:	
	pop ecx ; Ziffern werden in ecx getan
	sub ecx, '0' ; in integer umeandeln

greater9:
	cmp ecx, 9 ; prueft ob die Ziffern zwischen A-F liegt
	jg isnotdec
	jmp continue
isnotdec: ; wandelt zeiffern zwischen A-F in 10-15 um
	add ecx, '0'
	sub ecx, 55
	jmp continue

continue:
	imul ecx, edx ; ziffer wird mit edx multipiziert
	add eax, ecx ; ecx wird zu eax addiert
	imul edx, 16 ; edx wird mit 16 multipiziert
	dec edi ; prueft ob edi 0 ist (algorithmus ist fertig)
	jz print
	jmp convert

print: ; gibt die decimala Zahl aus
	mov [num], eax
	cmp [num], byte 9 ; prueft ob decimal Zahl grosser als 9 ist 
	jg convertgreater 
	add eax, '0' ; druckt die Zahl falls sie keiner 9 sit
	mov [num], eax
	mov eax, 4
	mov ebx, 1
	mov ecx, num
	mov edx, 1
	int 0x80
	jmp exit ; beendet das Program

convertgreater: ; druckt Zahlen die grosser 9 sind
	mov esi, 0 ; Zaehler (Anzahl ziffern)
dividegreater: ; teillt die Zahl durch 10 und pusht den Rest in den Stack
	mov edx, 0
	mov ecx, 10
	div ecx
	push edx
	inc esi
	mov [num], eax
	cmp [num], byte 0 ; prueft ob die alle Ziffern der Zahl in den Stack liegen
	jne dividegreater

printgreater: ; nimmt die einzelnen Ziffern aus den Stack und gibt sie aus
	pop eax
	add eax, '0'
	mov [num], eax
	mov eax, 4
	mov ebx, 1
	mov ecx, num
	mov edx, 1
	int 0x80
	dec esi ; prueft ob esi 0 ist (alle ziffern ausgegebn wurden sind)
	jnz printgreater

exit: ; beendet das program
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80
	
	mov eax, 1
	mov ebx, 0
	int 80h	
	
