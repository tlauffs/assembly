section .data
	newline: db 0x0a
	num: db 'num'
	g1000: db 'M'
	g900: db 'CM'
	g500: db 'D'
	g400: db 'CD'
	g100: db 'C'
	g90: db 'XC'
	g50: db 'L'
	g40: db 'XL'
	g10: db 'X'
	g9: db 'IX'
	g5: db 'V'
	g4: db 'IV'
	g1: db 'I'
	errorMsg: db "error: inkorrektes zeichen"
	errorLen: equ $-errorMsg
	errorMsg2: db "error: decimal Nummer zu Gross"
	error2Len: equ $-errorMsg2	

section .bss

section .text
	global _start:

_start:

	pop ecx
	pop ecx
	pop ecx ; Arabische Zahl wird in ecx getan
	jmp toInt

toInt: ; wandelt die Eingabe in ein Integer um
	cmp [ecx], byte 0 ; prueft ob das ende der Zahl erreicht ist
	je toRoman
	cmp [ecx], byte 30h ; ueberprueft ob die Ziffer zwischen 0-9 liegt
	jl error
	cmp [ecx], byte 39h  ; ueberprueft ob die Ziffer zwischen 0-9 liegt
	jg error
	movzx ebx, byte[ecx]
	inc ecx
	sub ebx, '0' 
	imul edi, 10
	add edi, ebx
	jmp toInt

error: ; error falls inkorrektes Zeichen eingegeben wurden ist
	mov eax, 4
	mov ebx, 1
	mov ecx, errorMsg
	mov edx, errorLen
	int 0x80	
	jmp exit

toRoman: 
	cmp edi, 3999 ; prueft ob Zahl kleiner als 3999 ist
	jg dectobig
	jmp greater1000

dectobig: ; error falls Zahl zu gross ist
	mov eax, 4
	mov ebx, 1
	mov ecx, errorMsg2
	mov edx, error2Len
	int 0x80	
	jmp exit

;wandelt arabische Zahl in romische um 
greater1000:
	cmp edi, 1000
	jl greater900
	mov eax, 4
	mov ebx, 1
	mov ecx, g1000
	mov edx, 1
	int 0x80
	mov ebx, 1000
	sub edi, ebx
 	jmp greater1000
greater900:
	cmp edi, 900
	jl greater500
	mov eax, 4
	mov ebx, 1
	mov ecx, g900
	mov edx, 2
	int 0x80
	mov ebx, 900
	sub edi, ebx
 	jmp greater900
greater500:
	cmp edi, 500
	jl greater400
	mov eax, 4
	mov ebx, 1
	mov ecx, g500
	mov edx, 1
	int 0x80
	mov ebx, 500
	sub edi, ebx
 	jmp greater500
greater400:
	cmp edi, 400
	jl greater100
	mov eax, 4
	mov ebx, 1
	mov ecx, g400
	mov edx, 2
	int 0x80
	mov ebx, 400
	sub edi, ebx
 	jmp greater400
greater100:
	cmp edi, 100
	jl greater90
	mov eax, 4
	mov ebx, 1
	mov ecx, g100
	mov edx, 1
	int 0x80
	mov ebx, 100
	sub edi, ebx
 	jmp greater100
greater90:
	cmp edi, 90
	jl greater50
	mov eax, 4
	mov ebx, 1
	mov ecx, g90
	mov edx, 2
	int 0x80
	mov ebx, 90
	sub edi, ebx
 	jmp greater90
greater50:
	cmp edi, 50
	jl greater40
	mov eax, 4
	mov ebx, 1
	mov ecx, g50
	mov edx, 1
	int 0x80
	mov ebx, 50
	sub edi, ebx
 	jmp greater50
greater40:
	cmp edi, 40
	jl greater10
	mov eax, 4
	mov ebx, 1
	mov ecx, g40
	mov edx, 2
	int 0x80
	mov ebx, 40
	sub edi, ebx
 	jmp greater40
greater10:
	cmp edi, 10
	jl greater9
	mov eax, 4
	mov ebx, 1
	mov ecx, g10
	mov edx, 1
	int 0x80
	mov ebx, 10
	sub edi, ebx
 	jmp greater10
greater9:
	cmp edi, 9
	jl greater5
	mov eax, 4
	mov ebx, 1
	mov ecx, g9
	mov edx, 2
	int 0x80
	mov ebx, 9
	sub edi, ebx
 	jmp greater9
greater5:
	cmp edi, 5
	jl greater4
	mov eax, 4
	mov ebx, 1
	mov ecx, g5
	mov edx, 1
	int 0x80
	mov ebx, 5
	sub edi, ebx
 	jmp greater5
greater4:
	cmp edi, 4
	jl greater1
	mov eax, 4
	mov ebx, 1
	mov ecx, g4
	mov edx, 2
	int 0x80
	mov ebx, 4
	sub edi, ebx
 	jmp greater4
greater1:
	cmp edi, 1
	jl exit
	mov eax, 4
	mov ebx, 1
	mov ecx, g1
	mov edx, 1
	int 0x80
	mov ebx, 1
	sub edi, ebx
 	jmp greater1

exit: ; beendet das Programm
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80
	
	mov eax, 1
	mov ebx, 0
	int 0x80
	
