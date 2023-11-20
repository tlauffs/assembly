
section .data
	newline: db 0x0a
	printnum: dd 'printnum'
	decNum: db "decinal number = "
	decLen: equ $-decNum
	hexNum: db "hexadecimal number = 0x"
	hexLen: equ $-hexNum
	errorMsg: db "error: inkorrektes zeichen"
	errorLen: equ $-errorMsg
	errorMsg2: db "error: Wertebereich von 32-bit Ueberschritten"
	error2Len: equ $-errorMsg2
	dec15: db 'F'
	dec14: db 'E'
	dec13: db 'D'
	dec12: db 'C'
	dec11: db 'B'
	dec10: db 'A'

section .bss

section .text
	global _start:

_start:
	mov eax, 4 ; "decinal number = " wird ausgegeben
	mov ebx, 1
	mov ecx, decNum
	mov edx, decLen
	int 0x80

	pop ecx
	pop ecx
	pop ecx ; decimal Zahl wird in ecx getan

	mov eax, 4
	mov ebx, 1
	mov edx, 0
	push ecx ; decimal Zahl wird im Stack gespeichert
	jmp lenDecNum

lenDecNum: ; durchlauft ecx (eingegebene Zahl) und speichert ihre laenge in edx
	cmp [ecx], byte 0 ; wenn die Zahl komplett durchlaufen ist geh zu printHexnum 
	je printDecNum
	cmp [ecx], byte 30h ; ueberprueft ob die Ziffer zwischen 0-9 liegt
	jl error
	cmp [ecx], byte 39h  ; ueberprueft ob die Ziffer zwischen 0-9 liegt
	jg error
	inc edx
	inc ecx
	jmp lenDecNum

error: ; gibt eine error aus falls ein inkorrektes Zeichen eingeben wurden ist
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, errorMsg
	mov edx, errorLen
	int 0x80	
	jmp exit

printDecNum:
	pop ecx ; gibt decimal Zahl aus
	int 0x80


	push ecx
	mov eax, 4 ; geht in eine newline
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80
	
	mov eax, 4 ; "hexadecimal number = 0x" wird ausgegeben
	mov ebx, 1
	mov ecx, hexNum
	mov edx, hexLen
	int 0x80

	pop ecx
	mov eax, 0 
toInt: ; wandlet eingabe in ein Integer um und speichert sie in eax
	cmp [ecx], byte 0 
	je startconvertNum
	movzx ebx, byte[ecx]
	inc ecx
	sub ebx, '0' ; wandlet jede ziffer in ein Int um
	imul eax, 10 ; multipiziert die Zahl mit 10
	add eax, ebx ; haengt die naechste Ziffer hinten dran
	cmp eax, 0 ;prueft das die zahl nicht 32-bit ueberschreitet
	jl overflowError
	jmp toInt

overflowError: ;error msg falls die Zahl 32-bit ueberschreitet
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, errorMsg2
	mov edx, error2Len
	int 0x80
	jmp exit

startconvertNum:
	mov esi, 0 ; Zaehler (Anhahl der Ziffern der Hexadecimal Zahl)
convertNum: ; Decimal Zahl wind in Hexadecimal umgewandelt
	mov edx, 0
	mov ecx, 16
	div ecx ; eax (hexadecimal Zahl) wird durch 16 geteilt
	push edx ; Rest von der Division wird in den Stack gepushed 
	inc esi
	cmp eax, 0 ; prueft ob eax 0 ist (jede Ziffer der hexadecimal Zahl ist auf den Stack)
	jne convertNum

printHexNum: ; gibt die Hexadecimal Zahl aus
	pop eax ; Ziffern werden in eax getan
	cmp eax, 9 ; prueft ob die Ziffer zwischen 0-9 ist
	jg print15
	add eax, '0' ; falls sie Zwischen 0-9 ist wird sie in Ascii umgewandket und ausgegeben
	mov [printnum], eax
	mov eax, 4
	mov ebx, 1
	mov ecx, printnum
	mov edx, 1
	int 0x80
continue:
	dec esi
	cmp esi, 0 ; prueft ob die Hexadecimal Zahl ertig gedruckt ist
	jne printHexNum	
	jmp exit 

; falls die Ziffer zwischen A-F ist wird sie mit jeden Wert zwischen 10-15 vergliechen
; und der entsprechende Buchstabe ausgegeben
print15:
	cmp eax, 15
	jne print14
	mov eax, 4
	mov ebx, 1
	mov ecx, dec15
	mov edx, 1
	int 0x80
	jmp continue
print14:
	cmp eax, 14
	jne print13
	mov eax, 4
	mov ebx, 1
	mov ecx, dec14
	mov edx, 1
	int 0x80
	jmp continue
print13:
	cmp eax, 13
	jne print12
	mov eax, 4
	mov ebx, 1
	mov ecx, dec13
	mov edx, 1
	int 0x80
	jmp continue
print12:
	cmp eax, 12
	jne print11
	mov eax, 4
	mov ebx, 1
	mov ecx, dec12
	mov edx, 1
	int 0x80
	jmp continue
print11:
	cmp eax, 11
	jne print10
	mov eax, 4
	mov ebx, 1
	mov ecx, dec11
	mov edx, 1
	int 0x80
	jmp continue
print10:
	mov eax, 4
	mov ebx, 1
	mov ecx, dec10
	mov edx, 1
	int 0x80
	jmp continue

exit: ; beendet das programm
	push ecx
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80

	mov eax, 1
	mov ebx, 0
	int 80h	
	
	


