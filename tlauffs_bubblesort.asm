
section .data
	newline: db 0x0a
	arr: dd 8,15,53,2564,456,7,6,3563,2,45,4,34 ; Array was sortiert werden soll
	arr1: db 'arr'
	komma: db ',,'
	kommaLen: equ $-komma

section .bss

section	.text
	global _start:
	

_start:
	mov esi, 12 ; esi ist die Laenge des Arrays arr
	mov edx, 1 ; edx ueberprueft ob bei letzten durchlauf ein Element geswapt wuerde

firstloop: ; aussere Schleife durchlauft das Array bis es sortiert ist
	cmp edx, 0 ; falls edx 0 ist ist das Array sortiert
	je printArr 
	mov edx, 0 ; setzt edx und edi auf 0 fuer den naechsten durchlauf
	mov edi, 0
	dec esi ; rechte grenze werd verringert 
	jz printArr ; falls recht grenze 0 ist jump zu printArr um das sortiert Array auszugeben

secondloop: ; noch nicht sortierte teil werd durchlaufen 
	mov eax, [arr + edi*4] 
	mov ebx, [arr + edi*4 + 4]
	cmp eax, ebx 
	jg swap ; falls eax grosser ist als ebx werden die element vertauscht
	inc edi ; an die nachste stelle das arrays gehen
	cmp edi, esi ; pruefen ob der nicht sortierte teil komplett durchlaufen ist
	jge firstloop
	jmp secondloop
swap: ; vertauscht elemente
	mov [arr + edi*4 + 4], eax ; eax wird an die stelle vom Array wo ebx war gemoved 
	mov [arr + edi*4], ebx ; ebx wird an die stelle vom Array wo eax war gemoved
	mov edx, 1 ; edx wird auf 1 gesetzt weil ein swap stattgefunden hat
	inc edi ; an die nachste stelle das arrays gehen
	cmp edi, esi ; pruefen ob der nicht sortierte teil komplett durchlaufen ist
	jge firstloop
	jmp secondloop

printArr: ; gibt das sortierte Array aus
	mov esi, 12 ; laenge des Arrays
	mov edi, 0 ; Zaehler 

loopArr: ;gesamte Array wird durchlaufen
	mov eax, [arr + edi*4] ; Enthaelt das array element an der Stelle edi*4
	inc edi ; edi wird increased duer den nachsten durchlauf
	cmp eax, 9 ; falls  eax groesser 9 ist muss sie mit convertgreater ausgegeben werden
	jg convertgreater
	add eax, '0' ; eax wird in ascii umgewandelt (eax ist kleine 9)
	mov [arr1], eax 
	mov eax, 4 ; eax wird ausgegeben
	mov ebx, 1
	mov ecx, arr1
	mov edx, 1
	int 0x80
continue:
	dec esi ; falls esi 0 ist das sortierte Array komplett ausgegeben 
	jz exit
	mov eax, 4 ; ein komma wird zwischen den array elementen gedruckt 
	mov ebx, 1
	mov ecx, komma
	mov edx, kommaLen
	int 0x80
	jnz loopArr

convertgreater: ; gebt zahlen die grosser sind als 9 aus
	push esi ; esi wird gespeichert im stack
	mov esi, 0 ; Zaehler (zahler wie viele ziffern die Zahl hat)

dividegreater: ; die zahl wird durch 10 geteilt und der restwird auf den Stack gepushed
	mov edx, 0
	mov ecx, 10
	div ecx
	push edx
	inc esi
	cmp eax, 0 ; prueft ob eax 0 ist (alle ziffern von eax sind auf den stack)  
	jne dividegreater

printgreater: ; gibt Zahlen die grosser als 9 sind aus
	pop eax ; pop die erste Ziffer der Zahl von Stack
	add eax, '0' ;umwandlung in ascii
	mov [arr1], eax ; ziffer wird ausgegeben
	mov eax, 4
	mov ebx, 1
	mov ecx, arr1
	mov edx, 1
	int 0x80
	dec esi ; durchlauft alle ziffern
	jnz printgreater
	pop esi
	jmp continue ; durchlauft den rest von sortierten Array

exit: ; programm wird beendet
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80

	mov eax, 1
	mov ebx, 0
	int 80h	

