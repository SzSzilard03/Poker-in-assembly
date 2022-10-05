.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Exemplu proiect desenare",0
area_width EQU 640
area_height EQU 480
picture_height EQU 50
picture_width EQU 40
area DD 0
bt_start dd ?
n dd 10
counter DD 0 ; numara evenimentele de tip timer
fullhouse dd 0
carti_afisate_tr dd 0
carti_afisate_flp dd 1
carti_afisate_riv dd 2
neg_2 dd 0
tref_2 dd 0
inim_2 dd 0
romb_2 dd 0
neg_3 dd 0
tref_3 dd 0
inim_3 dd 0
romb_3 dd 0
neg_4 dd 0
tref_4 dd 0
inim_4 dd 0
romb_4 dd 0
neg_5 dd 0
tref_5 dd 0
inim_5 dd 0
romb_5 dd 0
neg_6 dd 0
tref_6 dd 0
inim_6 dd 0
romb_6 dd 0
neg_7 dd 0
tref_7 dd 0
inim_7 dd 0
romb_7 dd 0
neg_8 dd 0
tref_8 dd 0
inim_8 dd 0
romb_8 dd 0
neg_9 dd 0
tref_9 dd 0
inim_9 dd 0
romb_9 dd 0
neg_10 dd 0
tref_10 dd 0
inim_10 dd 0
romb_10 dd 0
neg_j dd 0
tref_j dd 0
inim_j dd 0
romb_j dd 0
neg_q dd 0
tref_q dd 0
inim_q dd 0
romb_q dd 0
neg_k dd 0
tref_k dd 0
inim_k dd 0
romb_k dd 0
neg_a dd 0
tref_a dd 0
inim_a dd 0
romb_a dd 0

negru dd 0
rosu dd 0
tref dd 0
romb dd 0
doi dd 0
trei dd 0
patru dd 0
cinci dd 0
sase dd 0
sapte dd 0
opt dd 0
noua dd 0
zece dd 0
bub dd 0
dama dd 0
kapa dd 0
as dd 0

pair_1 dd 0
pair_2 dd 0
tree dd 0
fullh dd 0
straight dd 0
flush dd 0
chinta dd 0
win dd 0
pereche dd 0


carte_1 dd 100
carte_2 dd 100

car_mas_1 dd 100
car_mas_2 dd 100
car_mas_3 dd 100
car_mas_4 dd 100
car_mas_5 dd 100

carti_masa dd 0

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc
include picture.inc
counter_b dd 0
counter_p dd 0
button_x EQU 300
button_y EQU 350
button_size EQU 70
bani dd 500
bet dd 0
bet_check dd 20
bet_raise dd 40
culoare_pic dd ?
nr_carte dd ?

buton_apasat dd 0
bt_start_x EQU 450 
bt_start_y EQU 300
button_1_x EQU 400
button_2_x EQU 500
balance_x EQU 400
balance_y EQU 280
format_int db "%d", 13, 10, 0


.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

make_carte proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	lea esi, picture
	
draw_text:
	mov ebx, picture_width
	 ; shl ebx ,2
	mul ebx
	mov ebx, picture_height
	 ; shl ebx ,2
	mul ebx
	shl eax ,2
	add esi, eax
	shr eax , 2
	mov ecx, picture_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, picture_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, picture_width
bucla_simbol_coloane:
	push eax
	mov eax, dword ptr [esi]
	mov dword ptr [edi], eax
	pop eax
	add esi, 4
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_carte endp

print macro a
pusha
push a
push offset format_int
call printf
add esp, 8
popa
endm

random macro 
push eax
push edx
rdtsc ; put a random value in EAX
mov ebx , 51
mov edx , 0
div ebx
mov ebx ,edx
pop edx
pop eax
endm

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

make_picture_macro macro symbol1, drawArea1, x1, y1
	push y1
	push x1
	push drawArea1
	push symbol1
	call make_carte
	add esp, 16
endm

line_horizontal macro x, y, len, color
local bucla_line
	mov eax ,y
	mov ebx, area_width
	mul ebx
	add eax , x
	shl eax , 2
	add eax ,area
	mov ecx ,len
	
bucla_line:
	mov dword ptr[eax] , color
	add eax , 4
	loop bucla_line
endm

line_vertical macro x, y, len, color
local bucla_line
mov eax ,y
	mov ebx, area_width
	mul ebx
	add eax , x
	shl eax , 2
	add eax ,area
	mov ecx ,len
	
bucla_line:
	mov dword ptr[eax] , color
	add eax , 4* area_width
	loop bucla_line
endm
check_btn_pressed macro x,y,w,h
local btn_fail
	xor edx,edx
	mov eax, [ebp+arg2]
	cmp eax,x
	jl btn_fail
	cmp eax,x+w
	jg btn_fail
	mov eax, [ebp+arg3]
	cmp eax,y
	jl btn_fail
	cmp eax,y+h
	jg btn_fail
	mov edx,1
	btn_fail:
	
endm
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	; mov eax , [ebp+arg3]
	; mov ebx ,area_width
	; mul ebx
	; add eax , [ebp+arg2]
	; shl eax,2
	; add eax ,area
	; mov dword ptr[eax],0FF0000h
	; mov dword ptr[eax +4],0FF0000h
	; mov dword ptr[eax-4],0FF0000h
	; mov dword ptr[eax+4*area_width],0FF0000h
	; mov dword ptr[eax-4*area_width],0FF0000h
	;line_horizontal [ebp+arg2], [ebp+arg3], 30, 0FFh
	cmp counter_p ,5
	jne prev
	line_horizontal bt_start_x, bt_start_y ,button_size, 0
	line_horizontal bt_start_x, bt_start_y + button_size ,button_size, 0
	line_vertical bt_start_x, bt_start_y, button_size, 0
	line_vertical bt_start_x + button_size, bt_start_y, button_size, 0 
	
	make_text_macro 'S' ,area , bt_start_x+button_size/2 - 25,bt_start_y + button_size - 30
	make_text_macro 'T' ,area , bt_start_x+button_size/2 - 15,bt_start_y + button_size - 30
	make_text_macro 'A' ,area , bt_start_x+button_size/2 - 5,bt_start_y + button_size - 30
	make_text_macro 'R' ,area , bt_start_x+button_size/2 + 5,bt_start_y + button_size - 30
	make_text_macro 'T' ,area , bt_start_x+button_size/2 + 15,bt_start_y + button_size - 30
	prev:
	cmp bt_start,1
	je joc
	mov eax , [ebp+arg2]
	cmp eax ,bt_start_x
	jb button_fail
	cmp eax, bt_start_x+ button_size
	ja button_fail
	mov eax, [ebp+arg3]
	cmp eax , bt_start_y
	jb button_fail
	cmp eax , bt_start_y + button_size
	ja button_fail
	mov bt_start,1
	line_horizontal bt_start_x, bt_start_y ,button_size, 0ffffffh
	line_horizontal bt_start_x, bt_start_y + button_size ,button_size, 0ffffffh
	line_vertical bt_start_x, bt_start_y, button_size, 0ffffffh
	line_vertical bt_start_x + button_size, bt_start_y, button_size, 0ffffffh
	make_text_macro ' ' ,area , bt_start_x+button_size/2 - 25,bt_start_y + button_size - 30
	make_text_macro ' ' ,area , bt_start_x+button_size/2 - 15,bt_start_y + button_size - 30
	make_text_macro ' ' ,area , bt_start_x+button_size/2 - 5,bt_start_y + button_size - 30
	make_text_macro ' ' ,area , bt_start_x+button_size/2 + 5,bt_start_y + button_size - 30
	make_text_macro ' ' ,area , bt_start_x+button_size/2 + 15,bt_start_y + button_size - 30
	cmp bt_start ,1
	jne button_fail
	
	joc:

	line_horizontal button_x, button_y ,button_size, 0
	line_horizontal button_x, button_y + button_size ,button_size, 0
	line_vertical button_x, button_y, button_size, 0
	line_vertical button_x + button_size, button_y, button_size, 0
	make_text_macro 'C' ,area , button_x+button_size/2 - 25,button_y + button_size - 30
	make_text_macro 'H' ,area , button_x+button_size/2 - 15,button_y + button_size - 30
	make_text_macro 'E' ,area , button_x+button_size/2 - 5,button_y + button_size - 30
	make_text_macro 'C' ,area , button_x+button_size/2 + 5,button_y + button_size - 30
	make_text_macro 'K' ,area , button_x+button_size/2 + 15,button_y + button_size - 30
	line_horizontal button_1_x, button_y ,button_size, 0
	line_horizontal button_1_x, button_y + button_size ,button_size, 0
	line_vertical button_1_x, button_y, button_size, 0
	line_vertical button_1_x + button_size, button_y, button_size, 0
	make_text_macro 'R' ,area , button_1_x+button_size/2 - 25,button_y + button_size - 30
	make_text_macro 'A' ,area , button_1_x+button_size/2 - 15,button_y + button_size - 30
	make_text_macro 'I' ,area , button_1_x+button_size/2 - 5,button_y + button_size - 30
	make_text_macro 'S' ,area , button_1_x+button_size/2 + 5,button_y + button_size - 30
	make_text_macro 'E' ,area , button_1_x+button_size/2 + 15,button_y + button_size - 30
	line_horizontal button_2_x, button_y ,button_size, 0
	line_horizontal button_2_x, button_y + button_size ,button_size, 0
	line_vertical button_2_x, button_y, button_size, 0
	line_vertical button_2_x + button_size, button_y, button_size, 0
	make_text_macro 'F' ,area , button_2_x+button_size/2 - 20,button_y + button_size - 30
	make_text_macro 'O' ,area , button_2_x+button_size/2 - 10,button_y + button_size - 30
	make_text_macro 'L' ,area , button_2_x+button_size/2 ,button_y + button_size - 30
	make_text_macro 'D' ,area , button_2_x+button_size/2 + 10,button_y + button_size - 30
	
	
	make_text_macro 'B' ,area , balance_x+button_size/2 - 40,balance_y + button_size - 30
	make_text_macro 'A' ,area , balance_x+button_size/2 - 30,balance_y + button_size - 30
	make_text_macro 'L' ,area , balance_x+button_size/2 - 20,balance_y + button_size - 30
	make_text_macro 'A' ,area , balance_x+button_size/2 - 10,balance_y + button_size - 30
	make_text_macro 'N' ,area , balance_x+button_size/2 ,balance_y + button_size - 30
	make_text_macro 'C' ,area , balance_x+button_size/2 +10,balance_y + button_size - 30
	make_text_macro 'E' ,area , balance_x+button_size/2 +20,balance_y + button_size - 30
	
	make_text_macro ' ', area,balance_x+button_size/2 +60, balance_y + button_size - 30
	make_text_macro ' ', area,balance_x+button_size/2 +50, balance_y + button_size - 30
	make_text_macro ' ', area,balance_x+button_size/2 +40, balance_y + button_size - 30
	mov ebx, 10
	mov eax, bani
	mov bani,eax
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area,balance_x+button_size/2 +60, balance_y + button_size - 30
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area,balance_x+button_size/2 +50, balance_y + button_size - 30
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area,balance_x+button_size/2 +40, balance_y + button_size - 30
	
	make_text_macro 'M' ,area , balance_x+button_size/2 - 40,balance_y + button_size - 330
	make_text_macro 'I' ,area , balance_x+button_size/2 - 30,balance_y + button_size - 330
	make_text_macro 'Z' ,area , balance_x+button_size/2 - 20,balance_y + button_size - 330
	make_text_macro 'A' ,area , balance_x+button_size/2 - 10,balance_y + button_size - 330
	
	make_text_macro ' ', area,balance_x+button_size/2 +60, balance_y + button_size - 330
	make_text_macro ' ', area,balance_x+button_size/2 +50, balance_y + button_size - 330
	make_text_macro ' ', area,balance_x+button_size/2 +40, balance_y + button_size - 330
	
	mov ebx, 10
	mov eax, bet
	mov bet,eax
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area,balance_x+button_size/2 +60, balance_y + button_size - 330
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area,balance_x+button_size/2 +50, balance_y + button_size - 330
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area,balance_x+button_size/2 +40, balance_y + button_size - 330
	
	;intr carti
	cmp carte_1 , 0
	jne um0
	mov inim_q , 1
	um0 :
	cmp carte_1 , 1
	jne um2
	mov tref_3 , 1
	um2 :
	cmp carte_1 , 2
	jne um3
	mov romb_7,1
	um3 :
	cmp carte_1 ,3 
	jne um4
	mov inim_4,1
	um4 :
	cmp carte_1 , 5
	jne um5
	mov tref_k ,1
	um5 :
	cmp carte_1 , 6
	jne um6
	mov tref_q,1
	um6 :
	cmp carte_1 , 7
	jne um7
	mov romb_q,1
	um7 :
	cmp carte_1 ,8 
	jne um8
	mov tref_2,1
	um8 :
	cmp carte_1 , 9
	jne um9
	mov romb_k ,1
	um9 :
	cmp carte_1 , 10
	jne um10
	mov romb_5,1
	um10 :
	cmp carte_1 , 11
	jne um11
	mov neg_5,1
	um11 :
	cmp carte_1 , 12
	jne um12
	mov neg_k,1
	um12 :
	cmp carte_1 , 13
	jne um13
	mov tref_6,1
	um13 : 
	cmp carte_1 , 14
	jne um14
	mov tref_10 , 1
	um14 :
	cmp carte_1 , 15
	jne um15
	mov neg_10,1
	um15 :
	cmp carte_1 , 16
	jne um16
	mov romb_9,1
	um16 :
	cmp carte_1 , 17
	jne um17
	mov neg_6,1
	um17 :
	cmp carte_1 , 18
	jne um18
	mov romb_10 , 1
	um18 :
	cmp carte_1 , 19
	jne um19
	mov neg_j,1
	um19 :
	cmp carte_1 , 20
	jne um20
	mov romb_j,1
	um20 :
	cmp carte_1 , 21
	jne um21
	mov tref_4,1
	um21 :
	cmp carte_1 , 22
	jne um22
	mov tref_j,1
	um22 :
	cmp carte_1 , 23
	jne um23
	mov romb_8,1
	um23 :
	cmp carte_1 , 24
	jne um24
	mov romb_2,1
	um24 :
	cmp carte_1 , 25
	jne um25
	mov neg_3,1
	um25 :
	cmp carte_1 , 26
	jne um26
	mov romb_3,1
	um26 :
	cmp carte_1 , 27
	jne um27
	mov inim_a,1
	um27 :
	cmp carte_1 , 28
	jne um28
	mov neg_a,1
	um28 :
	cmp carte_1 , 29
	jne um29
	mov romb_a,1
	um29 :
	cmp carte_1 , 30
	jne um30
	mov neg_7,1
	um30 :
	cmp carte_1 , 31
	jne um31
	mov inim_5,1
	um31 :
	cmp carte_1 , 32
	jne um32
	mov tref_9,1
	um32 :
	cmp carte_1 , 33
	jne um33
	mov neg_8,1
	um33 :
	cmp carte_1 , 34
	jne um34
	mov neg_2,1
	um34 :
	cmp carte_1 , 35
	jne um35
	mov inim_j,1
	um35 :
	cmp carte_1 , 36
	jne um36
	mov inim_2 ,1
	um36 :
	cmp carte_1 , 37
	jne um37
	mov romb_6,1
	um37 :
	cmp carte_1 , 38
	jne um38
	mov inim_8,1
	um38 :
	cmp carte_1 , 39
	jne um39
	mov inim_7,1
	um39 :
	cmp carte_1 , 40
	jne um40
	mov tref_8,1
	um40 :
	cmp carte_1 , 41
	jne um41
	mov inim_q,1
	um41 :
	cmp carte_1 , 42
	jne um42
	mov inim_6,1
	um42 :
	cmp carte_1 , 43
	jne um43
	mov neg_4,1
	um43 :
	cmp carte_1 , 44
	jne um44
	mov inim_3,1
	um44 :
	cmp carte_1 , 45
	jne um45
	mov romb_4,1
	um45 :
	cmp carte_1 , 46
	jne um46
	mov inim_9 ,1
	um46 :
	cmp carte_1 , 1
	jne um47
	mov tref_5,1
	um47 :
	cmp carte_1 , 48
	jne um48
	mov inim_10,1
	um48 :
	cmp carte_1 , 49
	jne um49
	mov inim_k,1
	um49 :
	cmp carte_1 , 50
	jne um50
	mov tref_a,1
	um50 :
	cmp carte_1 , 51
	jne um51
	mov neg_9,1
	um51 :
	
	
	cmp carte_2 , 0
	jne umz0
	mov inim_q , 1
	umz0 :
	cmp carte_2 , 1
	jne umz2
	mov tref_3 , 1
	umz2 :
	cmp carte_2 , 2
	jne umz3
	mov romb_7,1
	umz3 :
	cmp carte_2 ,3 
	jne umz4
	mov inim_4,1
	umz4 :
	cmp carte_2 , 5
	jne umz5
	mov tref_k ,1
	umz5 :
	cmp carte_2 , 6
	jne umz6
	mov tref_q,1
	umz6 :
	cmp carte_2 , 7
	jne umz7
	mov romb_q,1
	umz7 :
	cmp carte_2 ,8 
	jne umz8
	mov tref_2,1
	umz8 :
	cmp carte_2 , 9
	jne umz9
	mov romb_k ,1
	umz9 :
	cmp carte_2 , 10
	jne umz10
	mov romb_5,1
	umz10 :
	cmp carte_2 , 11
	jne umz11
	mov neg_5,1
	umz11 :
	cmp carte_2 , 12
	jne umz12
	mov neg_k,1
	umz12 :
	cmp carte_2 , 13
	jne umz13
	mov tref_6,1
	umz13 : 
	cmp carte_2 , 14
	jne umz14
	mov tref_10 , 1
	umz14 :
	cmp carte_2 , 15
	jne umz15
	mov neg_10,1
	umz15 :
	cmp carte_2 , 16
	jne umz16
	mov romb_9,1
	umz16 :
	cmp carte_2 , 17
	jne umz17
	mov neg_6,1
	umz17 :
	cmp carte_2 , 18
	jne umz18
	mov romb_10 , 1
	umz18 :
	cmp carte_2 , 19
	jne umz19
	mov neg_j,1
	umz19 :
	cmp carte_2 , 20
	jne umz20
	mov romb_j,1
	umz20 :
	cmp carte_2 , 21
	jne umz21
	mov tref_4,1
	umz21 :
	cmp carte_2 , 22
	jne umz22
	mov tref_j,1
	umz22 :
	cmp carte_2 , 23
	jne umz23
	mov romb_8,1
	umz23 :
	cmp carte_2 , 24
	jne umz24
	mov romb_2,1
	umz24 :
	cmp carte_2 , 25
	jne umz25
	mov neg_3,1
	umz25 :
	cmp carte_2 , 26
	jne umz26
	mov romb_3,1
	umz26 :
	cmp carte_2 , 27
	jne umz27
	mov inim_a,1
	umz27 :
	cmp carte_2 , 28
	jne umz28
	mov neg_a,1
	umz28 :
	cmp carte_2 , 29
	jne umz29
	mov romb_a,1
	umz29 :
	cmp carte_2 , 30
	jne umz30
	mov neg_7,1
	umz30 :
	cmp carte_2 , 31
	jne umz31
	mov inim_5,1
	umz31 :
	cmp carte_2 , 32
	jne umz32
	mov tref_9,1
	umz32 :
	cmp carte_2 , 33
	jne umz33
	mov neg_8,1
	umz33 :
	cmp carte_2 , 34
	jne umz34
	mov neg_2,1
	umz34 :
	cmp carte_2 , 35
	jne umz35
	mov inim_j,1
	umz35 :
	cmp carte_2 , 36
	jne umz36
	mov inim_2 ,1
	umz36 :
	cmp carte_2 , 37
	jne umz37
	mov romb_6,1
	umz37 :
	cmp carte_2 , 38
	jne umz38
	mov inim_8,1
	umz38 :
	cmp carte_2 , 39
	jne umz39
	mov inim_7,1
	umz39 :
	cmp carte_2 , 40
	jne umz40
	mov tref_8,1
	umz40 :
	cmp carte_2 , 41
	jne umz41
	mov inim_q,1
	umz41 :
	cmp carte_2 , 42
	jne umz42
	mov inim_6,1
	umz42 :
	cmp carte_2 , 43
	jne umz43
	mov neg_4,1
	umz43 :
	cmp carte_2 , 44
	jne umz44
	mov inim_3,1
	umz44 :
	cmp carte_2 , 45
	jne umz45
	mov romb_4,1
	umz45 :
	cmp carte_2 , 46
	jne umz46
	mov inim_9 ,1
	umz46 :
	cmp carte_2 , 1
	jne umz47
	mov tref_5,1
	umz47 :
	cmp carte_2  , 48
	jne umz48
	mov inim_10,1
	umz48 :
	cmp carte_2  , 49
	jne umz49
	mov inim_k,1
	umz49 :
	cmp carte_2  , 50
	jne umz50
	mov tref_a,1
	umz50 :
	cmp carte_2 , 51
	jne umz51
	mov neg_9,1
	umz51 :
	
	cmp car_mas_1 , 0
	jne pas_10
	mov inim_q , 1
	pas_10 :
	cmp car_mas_1 , 1
	jne pas_12
	mov tref_3 , 1
	pas_12 :
	cmp car_mas_1 , 2
	jne pas_13
	mov romb_7,1
	pas_13 :
	cmp car_mas_1 ,3 
	jne pas_14
	mov inim_4,1
	pas_14 :
	cmp car_mas_1 , 5
	jne pas_15
	mov tref_k ,1
	pas_15 :
	cmp car_mas_1 , 6
	jne pas_16
	mov tref_q,1
	pas_16 :
	cmp car_mas_1 , 7
	jne pas_17
	mov romb_q,1
	pas_17 :
	cmp car_mas_1 ,8 
	jne pas_18
	mov tref_2,1
	pas_18 :
	cmp car_mas_1 , 9
	jne pas_19
	mov romb_k ,1
	pas_19 :
	cmp car_mas_1 , 10
	jne pas_110
	mov romb_5,1
	pas_110 :
	cmp car_mas_1 , 11
	jne pas_111
	mov neg_5,1
	pas_111 :
	cmp car_mas_1 , 12
	jne pas_112
	mov neg_k,1
	pas_112 :
	cmp car_mas_1 , 13
	jne pas_113
	mov tref_6,1
	pas_113 : 
	cmp car_mas_1 , 14
	jne pas_114
	mov tref_10 , 1
	pas_114 :
	cmp car_mas_1 , 15
	jne pas_115
	mov neg_10,1
	pas_115 :
	cmp car_mas_1 , 16
	jne pas_116
	mov romb_9,1
	pas_116 :
	cmp car_mas_1 , 17
	jne pas_117
	mov neg_6,1
	pas_117 :
	cmp car_mas_1 , 18
	jne pas_118
	mov romb_10 , 1
	pas_118 :
	cmp car_mas_1 , 19
	jne pas_119
	mov neg_j,1
	pas_119 :
	cmp car_mas_1 , 20
	jne pas_120
	mov romb_j,1
	pas_120 :
	cmp car_mas_1 , 21
	jne pas_121
	mov tref_4,1
	pas_121 :
	cmp car_mas_1 , 22
	jne pas_122
	mov tref_j,1
	pas_122 :
	cmp car_mas_1 , 23
	jne pas_123
	mov romb_8,1
	pas_123 :
	cmp car_mas_1 , 24
	jne pas_124
	mov romb_2,1
	pas_124 :
	cmp car_mas_1 , 25
	jne pas_125
	mov neg_3,1
	pas_125 :
	cmp car_mas_1 , 26
	jne pas_126
	mov romb_3,1
	pas_126 :
	cmp car_mas_1 , 27
	jne pas_127
	mov inim_a,1
	pas_127 :
	cmp car_mas_1 , 28
	jne pas_128
	mov neg_a,1
	pas_128 :
	cmp car_mas_1 , 29
	jne pas_129
	mov romb_a,1
	pas_129 :
	cmp car_mas_1 , 30
	jne pas_130
	mov neg_7,1
	pas_130 :
	cmp car_mas_1 , 31
	jne pas_131
	mov inim_5,1
	pas_131 :
	cmp car_mas_1 , 32
	jne pas_132
	mov tref_9,1
	pas_132 :
	cmp car_mas_1 , 33
	jne pas_133
	mov neg_8,1
	pas_133 :
	cmp car_mas_1 , 34
	jne pas_134
	mov neg_2,1
	pas_134 :
	cmp car_mas_1 , 35
	jne pas_135
	mov inim_j,1
	pas_135 :
	cmp car_mas_1 , 36
	jne pas_136
	mov inim_2 ,1
	pas_136 :
	cmp car_mas_1 , 37
	jne pas_137
	mov romb_6,1
	pas_137 :
	cmp car_mas_1 , 38
	jne pas_138
	mov inim_8,1
	pas_138 :
	cmp car_mas_1 , 39
	jne pas_139
	mov inim_7,1
	pas_139 :
	cmp car_mas_1 , 40
	jne pas_140
	mov tref_8,1
	pas_140 :
	cmp car_mas_1 , 41
	jne pas_141
	mov inim_q,1
	pas_141 :
	cmp car_mas_1 , 42
	jne pas_142
	mov inim_6,1
	pas_142 :
	cmp car_mas_1 , 43
	jne pas_143
	mov neg_4,1
	pas_143 :
	cmp car_mas_1 , 44
	jne pas_144
	mov inim_3,1
	pas_144 :
	cmp car_mas_1 , 45
	jne pas_145
	mov romb_4,1
	pas_145 :
	cmp car_mas_1 , 46
	jne pas_146
	mov inim_9 ,1
	pas_146 :
	cmp car_mas_1 , 1
	jne pas_147
	mov tref_5,1
	pas_147 :
	cmp car_mas_1  , 48
	jne pas_148
	mov inim_10,1
	pas_148 :
	cmp car_mas_1  , 49
	jne pas_149
	mov inim_k,1
	pas_149 :
	cmp car_mas_1  , 50
	jne pas_150
	mov tref_a,1
	pas_150 :
	cmp car_mas_1 , 51
	jne pas_151
	mov neg_9,1
	pas_151 :

	cmp car_mas_2 , 0
	jne pas_20
	mov inim_q , 1
	pas_20 :
	cmp car_mas_2 , 1
	jne pas_22
	mov tref_3 , 1
	pas_22 :
	cmp car_mas_2 , 2
	jne pas_23
	mov romb_7,1
	pas_23 :
	cmp car_mas_2 ,3 
	jne pas_24
	mov inim_4,1
	pas_24 :
	cmp car_mas_2 , 5
	jne pas_25
	mov tref_k ,1
	pas_25 :
	cmp car_mas_2 , 6
	jne pas_26
	mov tref_q,1
	pas_26 :
	cmp car_mas_2 , 7
	jne pas_27
	mov romb_q,1
	pas_27 :
	cmp car_mas_2 ,8 
	jne pas_28
	mov tref_2,1
	pas_28 :
	cmp car_mas_2 , 9
	jne pas_29
	mov romb_k ,1
	pas_29 :
	cmp car_mas_2 , 10
	jne pas_210
	mov romb_5,1
	pas_210 :
	cmp car_mas_2 , 11
	jne pas_211
	mov neg_5,1
	pas_211 :
	cmp car_mas_2 , 12
	jne pas_212
	mov neg_k,1
	pas_212 :
	cmp car_mas_2 , 13
	jne pas_213
	mov tref_6,1
	pas_213 : 
	cmp car_mas_2 , 14
	jne pas_214
	mov tref_10 , 1
	pas_214 :
	cmp car_mas_2 , 15
	jne pas_215
	mov neg_10,1
	pas_215 :
	cmp car_mas_2 , 16
	jne pas_216
	mov romb_9,1
	pas_216 :
	cmp car_mas_2 , 17
	jne pas_217
	mov neg_6,1
	pas_217 :
	cmp car_mas_2 , 18
	jne pas_218
	mov romb_10 , 1
	pas_218 :
	cmp car_mas_2 , 19
	jne pas_219
	mov neg_j,1
	pas_219 :
	cmp car_mas_2 , 20
	jne pas_220
	mov romb_j,1
	pas_220 :
	cmp car_mas_2 , 21
	jne pas_221
	mov tref_4,1
	pas_221 :
	cmp car_mas_2 , 22
	jne pas_222
	mov tref_j,1
	pas_222 :
	cmp car_mas_2 , 23
	jne pas_223
	mov romb_8,1
	pas_223 :
	cmp car_mas_2 , 24
	jne pas_224
	mov romb_2,1
	pas_224 :
	cmp car_mas_2 , 25
	jne pas_225
	mov neg_3,1
	pas_225 :
	cmp car_mas_2 , 26
	jne pas_226
	mov romb_3,1
	pas_226 :
	cmp car_mas_2 , 27
	jne pas_227
	mov inim_a,1
	pas_227 :
	cmp car_mas_2 , 28
	jne pas_228
	mov neg_a,1
	pas_228 :
	cmp car_mas_2 , 29
	jne pas_229
	mov romb_a,1
	pas_229 :
	cmp car_mas_2 , 30
	jne pas_230
	mov neg_7,1
	pas_230 :
	cmp car_mas_2 , 31
	jne pas_231
	mov inim_5,1
	pas_231 :
	cmp car_mas_2 , 32
	jne pas_232
	mov tref_9,1
	pas_232 :
	cmp car_mas_2 , 33
	jne pas_233
	mov neg_8,1
	pas_233 :
	cmp car_mas_2 , 34
	jne pas_234
	mov neg_2,1
	pas_234 :
	cmp car_mas_2 , 35
	jne pas_235
	mov inim_j,1
	pas_235 :
	cmp car_mas_2 , 36
	jne pas_236
	mov inim_2 ,1
	pas_236 :
	cmp car_mas_2 , 37
	jne pas_237
	mov romb_6,1
	pas_237 :
	cmp car_mas_2 , 38
	jne pas_238
	mov inim_8,1
	pas_238 :
	cmp car_mas_2 , 39
	jne pas_239
	mov inim_7,1
	pas_239 :
	cmp car_mas_2 , 40
	jne pas_240
	mov tref_8,1
	pas_240 :
	cmp car_mas_2 , 41
	jne pas_241
	mov inim_q,1
	pas_241 :
	cmp car_mas_2 , 42
	jne pas_242
	mov inim_6,1
	pas_242 :
	cmp car_mas_2 , 43
	jne pas_243
	mov neg_4,1
	pas_243 :
	cmp car_mas_2 , 44
	jne pas_244
	mov inim_3,1
	pas_244 :
	cmp car_mas_2 , 45
	jne pas_245
	mov romb_4,1
	pas_245 :
	cmp car_mas_2 , 46
	jne pas_246
	mov inim_9 ,1
	pas_246 :
	cmp car_mas_2 , 1
	jne pas_247
	mov tref_5,1
	pas_247 :
	cmp car_mas_2  , 48
	jne pas_248
	mov inim_10,1
	pas_248 :
	cmp car_mas_2  , 49
	jne pas_249
	mov inim_k,1
	pas_249 :
	cmp car_mas_2  , 50
	jne pas_250
	mov tref_a,1
	pas_250 :
	cmp car_mas_2 , 51
	jne pas_251
	mov neg_9,1
	pas_251 :

	cmp car_mas_3 , 0
	jne pas_30
	mov inim_q , 1
	pas_30 :
	cmp car_mas_3 , 1
	jne pas_32
	mov tref_3 , 1
	pas_32 :
	cmp car_mas_3 , 2
	jne pas_33
	mov romb_7,1
	pas_33 :
	cmp car_mas_3 ,3 
	jne pas_34
	mov inim_4,1
	pas_34 :
	cmp car_mas_3 , 5
	jne pas_35
	mov tref_k ,1
	pas_35 :
	cmp car_mas_3 , 6
	jne pas_36
	mov tref_q,1
	pas_36 :
	cmp car_mas_3 , 7
	jne pas_37
	mov romb_q,1
	pas_37 :
	cmp car_mas_3 ,8 
	jne pas_38
	mov tref_2,1
	pas_38 :
	cmp car_mas_3 , 9
	jne pas_39
	mov romb_k ,1
	pas_39 :
	cmp car_mas_3 , 10
	jne pas_310
	mov romb_5,1
	pas_310 :
	cmp car_mas_3 , 11
	jne pas_311
	mov neg_5,1
	pas_311 :
	cmp car_mas_3 , 12
	jne pas_312
	mov neg_k,1
	pas_312 :
	cmp car_mas_3 , 13
	jne pas_313
	mov tref_6,1
	pas_313 : 
	cmp car_mas_3 , 14
	jne pas_314
	mov tref_10 , 1
	pas_314 :
	cmp car_mas_3 , 15
	jne pas_315
	mov neg_10,1
	pas_315 :
	cmp car_mas_3 , 16
	jne pas_316
	mov romb_9,1
	pas_316 :
	cmp car_mas_3 , 17
	jne pas_317
	mov neg_6,1
	pas_317 :
	cmp car_mas_3 , 18
	jne pas_318
	mov romb_10 , 1
	pas_318 :
	cmp car_mas_3 , 19
	jne pas_319
	mov neg_j,1
	pas_319 :
	cmp car_mas_3 , 20
	jne pas_320
	mov romb_j,1
	pas_320 :
	cmp car_mas_3 , 21
	jne pas_321
	mov tref_4,1
	pas_321 :
	cmp car_mas_3 , 22
	jne pas_322
	mov tref_j,1
	pas_322 :
	cmp car_mas_3 , 23
	jne pas_323
	mov romb_8,1
	pas_323 :
	cmp car_mas_3 , 24
	jne pas_324
	mov romb_2,1
	pas_324 :
	cmp car_mas_3 , 25
	jne pas_325
	mov neg_3,1
	pas_325 :
	cmp car_mas_3 , 26
	jne pas_326
	mov romb_3,1
	pas_326 :
	cmp car_mas_3 , 27
	jne pas_327
	mov inim_a,1
	pas_327 :
	cmp car_mas_3 , 28
	jne pas_328
	mov neg_a,1
	pas_328 :
	cmp car_mas_3 , 29
	jne pas_329
	mov romb_a,1
	pas_329 :
	cmp car_mas_3 , 30
	jne pas_330
	mov neg_7,1
	pas_330 :
	cmp car_mas_3 , 31
	jne pas_331
	mov inim_5,1
	pas_331 :
	cmp car_mas_3 , 32
	jne pas_332
	mov tref_9,1
	pas_332 :
	cmp car_mas_3 , 33
	jne pas_333
	mov neg_8,1
	pas_333 :
	cmp car_mas_3 , 34
	jne pas_334
	mov neg_2,1
	pas_334 :
	cmp car_mas_3 , 35
	jne pas_335
	mov inim_j,1
	pas_335 :
	cmp car_mas_3 , 36
	jne pas_336
	mov inim_2 ,1
	pas_336 :
	cmp car_mas_3 , 37
	jne pas_337
	mov romb_6,1
	pas_337 :
	cmp car_mas_3 , 38
	jne pas_338
	mov inim_8,1
	pas_338 :
	cmp car_mas_3 , 39
	jne pas_339
	mov inim_7,1
	pas_339 :
	cmp car_mas_3 , 40
	jne pas_340
	mov tref_8,1
	pas_340 :
	cmp car_mas_3 , 41
	jne pas_341
	mov inim_q,1
	pas_341 :
	cmp car_mas_3 , 42
	jne pas_342
	mov inim_6,1
	pas_342 :
	cmp car_mas_3 , 43
	jne pas_343
	mov neg_4,1
	pas_343 :
	cmp car_mas_3 , 44
	jne pas_344
	mov inim_3,1
	pas_344 :
	cmp car_mas_3 , 45
	jne pas_345
	mov romb_4,1
	pas_345 :
	cmp car_mas_3 , 46
	jne pas_346
	mov inim_9 ,1
	pas_346 :
	cmp car_mas_3 , 1
	jne pas_347
	mov tref_5,1
	pas_347 :
	cmp car_mas_3  , 48
	jne pas_348
	mov inim_10,1
	pas_348 :
	cmp car_mas_3  , 49
	jne pas_349
	mov inim_k,1
	pas_349 :
	cmp car_mas_3  , 50
	jne pas_350
	mov tref_a,1
	pas_350 :
	cmp car_mas_3 , 51
	jne pas_351
	mov neg_9,1
	pas_351 :
	cmp car_mas_4 , 100
	je here
	cmp car_mas_4 , 0
	jne pas_40
	mov inim_q , 1
	pas_40 :
	cmp car_mas_4 , 1
	jne pas_42
	mov tref_3 , 1
	pas_42 :
	cmp car_mas_4 , 2
	jne pas_43
	mov romb_7,1
	pas_43 :
	cmp car_mas_4 ,3 
	jne pas_44
	mov inim_4,1
	pas_44 :
	cmp car_mas_4 , 5
	jne pas_45
	mov tref_k ,1
	pas_45 :
	cmp car_mas_4 , 6
	jne pas_46
	mov tref_q,1
	pas_46 :
	cmp car_mas_4 , 7
	jne pas_47
	mov romb_q,1
	pas_47 :
	cmp car_mas_4 ,8 
	jne pas_48
	mov tref_2,1
	pas_48 :
	cmp car_mas_4 , 9
	jne pas_49
	mov romb_k ,1
	pas_49 :
	cmp car_mas_4 , 10
	jne pas_410
	mov romb_5,1
	pas_410 :
	cmp car_mas_4 , 11
	jne pas_411
	mov neg_5,1
	pas_411 :
	cmp car_mas_4 , 12
	jne pas_412
	mov neg_k,1
	pas_412 :
	cmp car_mas_4 , 13
	jne pas_413
	mov tref_6,1
	pas_413 : 
	cmp car_mas_4 , 14
	jne pas_414
	mov tref_10 , 1
	pas_414 :
	cmp car_mas_4 , 15
	jne pas_415
	mov neg_10,1
	pas_415 :
	cmp car_mas_4 , 16
	jne pas_416
	mov romb_9,1
	pas_416 :
	cmp car_mas_4 , 17
	jne pas_417
	mov neg_6,1
	pas_417 :
	cmp car_mas_4 , 18
	jne pas_418
	mov romb_10 , 1
	pas_418 :
	cmp car_mas_4 , 19
	jne pas_419
	mov neg_j,1
	pas_419 :
	cmp car_mas_4 , 20
	jne pas_420
	mov romb_j,1
	pas_420 :
	cmp car_mas_4 , 21
	jne pas_421
	mov tref_4,1
	pas_421 :
	cmp car_mas_4 , 22
	jne pas_422
	mov tref_j,1
	pas_422 :
	cmp car_mas_4 , 23
	jne pas_423
	mov romb_8,1
	pas_423 :
	cmp car_mas_4 , 24
	jne pas_424
	mov romb_2,1
	pas_424 :
	cmp car_mas_4 , 25
	jne pas_425
	mov neg_3,1
	pas_425 :
	cmp car_mas_4 , 26
	jne pas_426
	mov romb_3,1
	pas_426 :
	cmp car_mas_4 , 27
	jne pas_427
	mov inim_a,1
	pas_427 :
	cmp car_mas_4 , 28
	jne pas_428
	mov neg_a,1
	pas_428 :
	cmp car_mas_4 , 29
	jne pas_429
	mov romb_a,1
	pas_429 :
	cmp car_mas_4 , 30
	jne pas_430
	mov neg_7,1
	pas_430 :
	cmp car_mas_4 , 31
	jne pas_431
	mov inim_5,1
	pas_431 :
	cmp car_mas_4 , 32
	jne pas_432
	mov tref_9,1
	pas_432 :
	cmp car_mas_4 , 33
	jne pas_433
	mov neg_8,1
	pas_433 :
	cmp car_mas_4 , 34
	jne pas_434
	mov neg_2,1
	pas_434 :
	cmp car_mas_4 , 35
	jne pas_435
	mov inim_j,1
	pas_435 :
	cmp car_mas_4 , 36
	jne pas_436
	mov inim_2 ,1
	pas_436 :
	cmp car_mas_4 , 37
	jne pas_437
	mov romb_6,1
	pas_437 :
	cmp car_mas_4 , 38
	jne pas_438
	mov inim_8,1
	pas_438 :
	cmp car_mas_4 , 39
	jne pas_439
	mov inim_7,1
	pas_439 :
	cmp car_mas_4 , 40
	jne pas_440
	mov tref_8,1
	pas_440 :
	cmp car_mas_4 , 41
	jne pas_441
	mov inim_q,1
	pas_441 :
	cmp car_mas_4 , 42
	jne pas_442
	mov inim_6,1
	pas_442 :
	cmp car_mas_4 , 43
	jne pas_443
	mov neg_4,1
	pas_443 :
	cmp car_mas_4 , 44
	jne pas_444
	mov inim_3,1
	pas_444 :
	cmp car_mas_4 , 45
	jne pas_445
	mov romb_4,1
	pas_445 :
	cmp car_mas_4 , 46
	jne pas_446
	mov inim_9 ,1
	pas_446 :
	cmp car_mas_4 , 1
	jne pas_447
	mov tref_5,1
	pas_447 :
	cmp car_mas_4  , 48
	jne pas_448
	mov inim_10,1
	pas_448 :
	cmp car_mas_4  , 49
	jne pas_449
	mov inim_k,1
	pas_449 :
	cmp car_mas_4  , 50
	jne pas_450
	mov tref_a,1
	pas_450 :
	cmp car_mas_4 , 51
	jne pas_451
	mov neg_9,1
	pas_451 :

	cmp car_mas_5 , 100
	je here
	cmp car_mas_5 , 0
	jne pas_50
	mov inim_q , 1
	pas_50 :
	cmp car_mas_5 , 1
	jne pas_52
	mov tref_3 , 1
	pas_52 :
	cmp car_mas_5 , 2
	jne pas_53
	mov romb_7,1
	pas_53 :
	cmp car_mas_5 ,3 
	jne pas_54
	mov inim_4,1
	pas_54 :
	cmp car_mas_5 , 5
	jne pas_55
	mov tref_k ,1
	pas_55 :
	cmp car_mas_5 , 6
	jne pas_56
	mov tref_q,1
	pas_56 :
	cmp car_mas_5 , 7
	jne pas_57
	mov romb_q,1
	pas_57 :
	cmp car_mas_5 ,8 
	jne pas_58
	mov tref_2,1
	pas_58 :
	cmp car_mas_5 , 9
	jne pas_59
	mov romb_k ,1
	pas_59 :
	cmp car_mas_5 , 10
	jne pas_510
	mov romb_5,1
	pas_510 :
	cmp car_mas_5 , 11
	jne pas_511
	mov neg_5,1
	pas_511 :
	cmp car_mas_5 , 12
	jne pas_512
	mov neg_k,1
	pas_512 :
	cmp car_mas_5 , 13
	jne pas_513
	mov tref_6,1
	pas_513 : 
	cmp car_mas_5 , 14
	jne pas_514
	mov tref_10 , 1
	pas_514 :
	cmp car_mas_5 , 15
	jne pas_515
	mov neg_10,1
	pas_515 :
	cmp car_mas_5 , 16
	jne pas_516
	mov romb_9,1
	pas_516 :
	cmp car_mas_5 , 17
	jne pas_517
	mov neg_6,1
	pas_517 :
	cmp car_mas_5 , 18
	jne pas_518
	mov romb_10 , 1
	pas_518 :
	cmp car_mas_5 , 19
	jne pas_519
	mov neg_j,1
	pas_519 :
	cmp car_mas_5 , 20
	jne pas_520
	mov romb_j,1
	pas_520 :
	cmp car_mas_5 , 21
	jne pas_521
	mov tref_4,1
	pas_521 :
	cmp car_mas_5 , 22
	jne pas_522
	mov tref_j,1
	pas_522 :
	cmp car_mas_5 , 23
	jne pas_523
	mov romb_8,1
	pas_523 :
	cmp car_mas_5 , 24
	jne pas_524
	mov romb_2,1
	pas_524 :
	cmp car_mas_5 , 25
	jne pas_525
	mov neg_3,1
	pas_525 :
	cmp car_mas_5 , 26
	jne pas_526
	mov romb_3,1
	pas_526 :
	cmp car_mas_5 , 27
	jne pas_527
	mov inim_a,1
	pas_527 :
	cmp car_mas_5 , 28
	jne pas_528
	mov neg_a,1
	pas_528 :
	cmp car_mas_5 , 29
	jne pas_529
	mov romb_a,1
	pas_529 :
	cmp car_mas_5 , 30
	jne pas_530
	mov neg_7,1
	pas_530 :
	cmp car_mas_5 , 31
	jne pas_531
	mov inim_5,1
	pas_531 :
	cmp car_mas_5 , 32
	jne pas_532
	mov tref_9,1
	pas_532 :
	cmp car_mas_5 , 33
	jne pas_533
	mov neg_8,1
	pas_533 :
	cmp car_mas_5 , 34
	jne pas_534
	mov neg_2,1
	pas_534 :
	cmp car_mas_5 , 35
	jne pas_535
	mov inim_j,1
	pas_535 :
	cmp car_mas_5 , 36
	jne pas_536
	mov inim_2 ,1
	pas_536 :
	cmp car_mas_5 , 37
	jne pas_537
	mov romb_6,1
	pas_537 :
	cmp car_mas_5 , 38
	jne pas_538
	mov inim_8,1
	pas_538 :
	cmp car_mas_5 , 39
	jne pas_539
	mov inim_7,1
	pas_539 :
	cmp car_mas_5 , 40
	jne pas_540
	mov tref_8,1
	pas_540 :
	cmp car_mas_5 , 41
	jne pas_541
	mov inim_q,1
	pas_541 :
	cmp car_mas_5 , 42
	jne pas_542
	mov inim_6,1
	pas_542 :
	cmp car_mas_5 , 43
	jne pas_543
	mov neg_4,1
	pas_543 :
	cmp car_mas_5 , 44
	jne pas_544
	mov inim_3,1
	pas_544 :
	cmp car_mas_5 , 45
	jne pas_545
	mov romb_4,1
	pas_545 :
	cmp car_mas_5 , 46
	jne pas_546
	mov inim_9 ,1
	pas_546 :
	cmp car_mas_5 , 1
	jne pas_547
	mov tref_5,1
	pas_547 :
	cmp car_mas_5  , 48
	jne pas_548
	mov inim_10,1
	pas_548 :
	cmp car_mas_5  , 49
	jne pas_549
	mov inim_k,1
	pas_549 :
	cmp car_mas_5  , 50
	jne pas_550
	mov tref_a,1
	pas_550 :
	cmp car_mas_5 , 51
	jne pas_551
	mov neg_9,1
	pas_551 :

	;verif comb
	here:
	cmp neg_2 , 1
	jne urm1
	add doi , 1
	add negru,1
	mov neg_2 ,0
	urm1:
	cmp inim_2,1
	jne urm2
	add doi ,1
	add rosu,1
	mov inim_2 ,0
	urm2:
	cmp tref_2,1
	jne urm3
	add doi ,1
	add tref,1
	mov tref_2 ,0
	urm3:
	cmp romb_2,1
	jne urm4
	add doi ,1
	add romb,1
	mov romb_2 ,0
	urm4:
	cmp neg_3 , 1
	jne urm5
	add trei , 1
	add negru,1
	mov neg_3 ,0
	urm5:
	cmp inim_3,1
	jne urm6
	add trei ,1
	add rosu,1
	mov inim_3 ,0
	urm6:
	cmp tref_3,1
	jne urm7
	add trei ,1
	add tref,1
	mov tref_3 ,0
	urm7:
	cmp romb_3,1
	jne urm8
	add trei ,1
	add romb,1
	mov romb_3 ,0
	urm8:
	cmp neg_4 , 1
	jne urm9
	add patru, 1
	add negru,1
	mov neg_4 ,0
	urm9:
	cmp inim_4,1
	jne urm10
	add patru ,1
	add rosu,1
	mov inim_4 ,0
	urm10:
	cmp tref_4,1
	jne urm11
	add patru,1
	add tref,1
	mov tref_4 ,0
	urm11:
	cmp romb_4,1
	jne urm12
	add patru ,1
	add romb,1
	mov romb_4 ,0
	urm12:
	cmp neg_5 , 1
	jne urm13
	add cinci , 1
	add negru,1
	mov neg_5 ,0
	urm13:
	cmp inim_5,1
	jne urm14
	add cinci ,1
	add rosu,1
	mov inim_5 ,0
	urm14:
	cmp tref_5,1
	jne urm15
	add cinci ,1
	add tref,1
	mov tref_5 ,0
	urm15:
	cmp romb_5,1
	jne urm16
	add cinci ,1
	add romb,1
	mov romb_5 ,0
	urm16:
	cmp neg_6 , 1
	jne urm17
	add sase , 1
	add negru,1
	mov neg_6 ,0
	urm17:
	cmp inim_6,1
	jne urm18
	add sase ,1
	add rosu,1
	mov inim_6 ,0
	urm18:
	cmp tref_6,1
	jne urm19
	add sase ,1
	add tref,1
	mov tref_6 ,0
	urm19:
	cmp romb_6,1
	jne urm20
	add sase ,1
	add romb,1
	mov romb_6 ,0
	urm20:
		cmp neg_7 , 1
	jne urm21
	add sapte , 1
	add negru,1
	mov neg_7 ,0
	urm21:
	cmp inim_7,1
	jne urm22
	add sapte ,1
	add rosu,1
	mov inim_7 ,0
	urm22:
	cmp tref_7,1
	jne urm23
	add sapte ,1
	add tref,1
	mov tref_7 ,0
	urm23:
	cmp romb_7,1
	jne urm24
	add sapte ,1
	add romb,1
	mov romb_7 ,0
	urm24:
	cmp neg_8 , 1
	jne urm25
	add opt , 1
	add negru,1
	mov neg_8 ,0
	urm25:
	cmp inim_8,1
	jne urm26
	add opt ,1
	add rosu,1
	mov inim_8 ,0
	urm26:
	cmp tref_8,1
	jne urm27
	add opt ,1
	add tref,1
	mov tref_8 ,0
	urm27:
	cmp romb_8,1
	jne urm28
	add opt ,1
	add romb,1
	mov romb_8 ,0
	urm28:
	cmp neg_9 , 1
	jne urm29
	add noua , 1
	add negru,1
	mov neg_9 ,0
	urm29:
	cmp inim_9,1
	jne urm30
	add noua ,1
	add rosu,1
	mov inim_9 ,0
	urm30:
	cmp tref_9,1
	jne urm31
	add noua ,1
	add tref,1
	mov tref_9 ,0
	urm31:
	cmp romb_9,1
	jne urm32
	add noua,1
	add romb,1
	mov romb_9,0
	urm32:
	cmp neg_10 , 1
	jne urm33
	add zece , 1
	add negru,1
	mov neg_10 ,0
	urm33:
	cmp inim_10,1
	jne urm34
	add zece ,1
	add rosu,1
	mov inim_10 ,0
	urm34:
	cmp tref_10,1
	jne urm35
	add zece ,1
	add tref,1
	mov tref_10 ,0
	urm35:
	cmp romb_10,1
	jne urm36
	add zece,1
	add romb,1
	mov romb_10,0
	urm36:
	cmp neg_j , 1
	jne urm37
	add bub , 1
	add negru,1
	mov neg_j,0
	urm37:
	cmp inim_j,1
	jne urm38
	add bub ,1
	add rosu,1
	mov inim_j ,0
	urm38:
	cmp tref_j,1
	jne urm39
	add bub ,1
	add tref,1
	mov tref_j ,0
	urm39:
	cmp romb_j,1
	jne urm40
	add bub,1
	add romb,1
	mov romb_j,0
	urm40:
	cmp neg_q , 1
	jne urm41
	add dama , 1
	add negru,1
	mov neg_q,0
	urm41:
	cmp inim_q,1
	jne urm42
	add dama ,1
	add rosu,1
	mov inim_q ,0
	urm42:
	cmp tref_q,1
	jne urm43
	add dama ,1
	add tref,1
	mov tref_q ,0
	urm43:
	cmp romb_q,1
	jne urm44
	add dama,1
	add romb,1
	mov romb_q,0
	urm44:
	cmp neg_k , 1
	jne urm45
	add kapa , 1
	add negru,1
	mov neg_k,0
	urm45:
	cmp inim_k,1
	jne urm46
	add kapa ,1
	add rosu,1
	mov inim_k ,0
	urm46:
	cmp tref_k,1
	jne urm47
	add kapa ,1
	add tref,1
	mov tref_k ,0
	urm47:
	cmp romb_k,1
	jne urm48
	add kapa,1
	add romb,1
	mov romb_k,0
	urm48:
	cmp neg_a, 1
	jne urm49
	add as , 1
	add negru,1
	mov neg_a,0
	urm49:
	cmp inim_a,1
	jne urm50
	add as ,1
	add rosu,1
	mov inim_a ,0
	urm50:
	cmp tref_a,1
	jne urm51
	add as ,1
	add tref,1
	mov tref_a ,0
	urm51:
	cmp romb_a,1
	jne urm52
	add as,1
	add romb,1
	mov romb_a,0
	urm52:
	
	cmp doi , 2
	jne u1
	mov pair_1,1
	u1 :
	cmp doi , 3
	jne u2
	mov tree , 1
	u2:
	cmp doi , 4
	jne u3
	mov win,1
	u3:
	cmp trei , 2
	jne u4
	add pair_1,1
	u4 :
	cmp  trei, 3
	jne u5
	add tree , 1
	u5:
	cmp trei , 4
	jne u6
	mov win,1
	u6:
	cmp patru , 2
	jne u7
	add pair_1,1
	u7 :
	cmp  patru, 3
	jne u8
	add tree , 1
	u8:
	cmp patru , 4
	jne u9
	mov win,1
	u9:
	cmp cinci , 2
	jne u10
	add pair_1,1
	u10 :
	cmp  cinci, 3
	jne u11
	add tree , 1
	u11:
	cmp cinci , 4
	jne u12
	mov win,1
	u12:
	cmp sase , 2
	jne u13
	add pair_1,1
	u13 :
	cmp  sase, 3
	jne u14
	add tree , 1
	u14:
	cmp sase , 4
	jne u15
	mov win,1
	u15:
	cmp sapte , 2
	jne u16
	add pair_1,1
	u16 :
	cmp  sapte, 3
	jne u17
	add tree , 1
	u17:
	cmp sapte , 4
	jne u18
	mov win,1
	u18:
	cmp opt , 2
	jne u19
	add pair_1,1
	u19 :
	cmp opt, 3
	jne u20
	add tree , 1
	u20:
	cmp opt , 4
	jne u22
	mov win,1
	u22:
	cmp noua , 2
	jne u23
	add pair_1,1
	u23 :
	cmp noua, 3
	jne u24
	add tree , 1
	u24:
	cmp noua , 4
	jne u25
	mov win,1
	u25:
	cmp zece , 2
	jne u26
	add pair_1,1
	u26 :
	cmp zece, 3
	jne u27
	add tree , 1
	u27:
	cmp zece , 4
	jne u28
	mov win,1
	u28:
	cmp bub , 2
	jne u29
	add pair_1,1
	u29 :
	cmp bub, 3
	jne u30
	add tree , 1
	u30:
	cmp bub , 4
	jne u31
	mov win,1
	u31:
	cmp dama , 2
	jne u32
	add pair_1,1
	u32 :
	cmp dama, 3
	jne u33
	add tree , 1
	u33:
	cmp dama , 4
	jne u34
	mov win,1
	u34:
	cmp kapa , 2
	jne u35
	add pair_1,1
	u35 :
	cmp kapa, 3
	jne u36
	add tree , 1
	u36:
	cmp kapa , 4
	jne u37
	mov win,1
	u37:
	cmp as, 2
	jne u38
	add pair_1,1
	u38 :
	cmp as, 3
	jne u39
	add tree , 1
	u39:
	cmp as , 4
	jne u40
	mov win,1
	u40:
	
	
	
	
	;verif butoane
	bt_0:
	mov eax , [ebp+arg2]
	cmp eax ,button_x
	jb btn_1
	cmp eax, button_x+ button_size
	ja btn_1
	mov eax, [ebp+arg3]
	cmp eax , button_y
	jb btn_1
	cmp eax , button_y + button_size
	ja btn_1
	
	mov eax,bani
	sub eax , 20
	mov bani ,eax
	mov eax , bet
	add eax, bet_check
	mov bet ,eax
	jmp afis_carte_noua
	
	btn_1:
	mov eax , [ebp+arg2]
	cmp eax ,button_1_x
	jb btn_2
	cmp eax, button_1_x+ button_size
	ja btn_2
	mov eax, [ebp+arg3]
	cmp eax , button_y
	jb btn_2
	cmp eax , button_y + button_size
	ja btn_2
	
	mov eax , bani
	sub eax, 40
	mov bani , eax
	mov eax, bet
	add eax,bet_raise
	mov bet , eax
	mov buton_apasat,2
	cmp buton_apasat,2
	je afis_carte_noua
	
	btn_2:
	mov eax , [ebp+arg2]
	cmp eax ,button_2_x
	jb button_fail
	cmp eax, button_2_x + button_size
	ja button_fail
	mov eax, [ebp+arg3]
	cmp eax , button_y
	jb button_fail
	cmp eax , button_y + button_size
	ja button_fail
	push 0
	call exit
	
	afis_carte_noua:
	add carti_masa , 1
	button_fail:

	jmp afisare_litere
	
evt_timer:
	inc counter
	inc counter_p
	inc counter_b
	cmp counter_p ,5
	jne previ
	line_horizontal bt_start_x, bt_start_y ,button_size, 0
	line_horizontal bt_start_x, bt_start_y + button_size ,button_size, 0
	line_vertical bt_start_x, bt_start_y, button_size, 0
	line_vertical bt_start_x + button_size, bt_start_y, button_size, 0 
	make_text_macro 'S' ,area , bt_start_x+button_size/2 - 25,bt_start_y + button_size - 30
	make_text_macro 'T' ,area , bt_start_x+button_size/2 - 15,bt_start_y + button_size - 30
	make_text_macro 'A' ,area , bt_start_x+button_size/2 - 5,bt_start_y + button_size - 30
	make_text_macro 'R' ,area , bt_start_x+button_size/2 + 5,bt_start_y + button_size - 30
	make_text_macro 'T' ,area , bt_start_x+button_size/2 + 15,bt_start_y + button_size - 30
	previ:
	
	
afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
	
	;scriem un mesaj
	make_text_macro 'P', area, 10, 40
	make_text_macro 'R', area, 20, 40
	make_text_macro 'O', area, 30, 40
	make_text_macro 'I', area, 40, 40
	make_text_macro 'E', area, 50, 40
	make_text_macro 'C', area, 60, 40
	make_text_macro 'T', area, 70, 40
	
	make_text_macro 'L', area, 30, 60
	make_text_macro 'A', area, 40, 60
	
	make_text_macro 'A', area, 0, 80
	make_text_macro 'S', area, 10, 80
	make_text_macro 'A', area, 20, 80
	make_text_macro 'M', area, 30, 80
	make_text_macro 'B', area, 40, 80
	make_text_macro 'L', area, 50, 80
	make_text_macro 'A', area, 60, 80
	make_text_macro 'R', area, 70, 80
	make_text_macro 'E', area, 80, 80

	make_text_macro ' ', area, 300, 40
	make_text_macro ' ', area, 310, 40
	make_text_macro ' ', area, 320, 40
	make_text_macro ' ', area, 330, 40
	make_text_macro ' ', area, 340, 40
	make_text_macro ' ', area, 350, 40
	make_text_macro ' ', area, 360, 40
	make_text_macro ' ', area, 370, 40
	make_text_macro ' ', area, 380, 40
	make_text_macro ' ', area, 390, 40
	make_text_macro ' ', area, 400, 40
	make_text_macro ' ', area, 410, 40
	
	cmp counter , 4
	jne carte1
	 random
	make_picture_macro ebx ,area, 100 , 330
	mov carte_1 ,ebx
	random
	make_picture_macro ebx ,area, 150 , 330
	mov carte_2 ,ebx
	carte1:
	
	cmp carti_afisate_tr,1
	je flop
	 random
	make_picture_macro ebx ,area, 100 , 150
	mov car_mas_1 ,ebx
	 random
	make_picture_macro ebx ,area, 150 , 150
	mov car_mas_2 ,ebx
	
	 random
	make_picture_macro ebx ,area, 200 , 150
	mov car_mas_3,ebx
	mov carti_afisate_tr,1
	jmp fin

	flop :
	cmp carti_afisate_flp,2
	je river
	cmp carti_masa,1
	jne fin
	 random
	make_picture_macro ebx ,area, 250 , 150
	mov car_mas_4 ,ebx
	mov carti_afisate_flp,2
	jmp fin
	
	river:
	cmp carti_afisate_riv,3
	je fin
	cmp carti_masa ,2
	jne fin
	 random
	make_picture_macro ebx ,area, 300 , 150
	mov car_mas_5 ,ebx
	mov carti_afisate_riv,3
	fin:
	cmp rosu ,5
	jne cul1
	mov flush,1
	cul1 :
	cmp negru,5
	jne cul2
	mov flush ,1
	cul2:
	cmp romb, 5
	jne cul3
	mov flush ,1
	cul3:
	cmp tref,5
	jne cul4
	mov flush ,1
	
	cul4:
	cmp pair_1,1
	jb tok1
	cmp tree, 1
	jb tok1
	mov fullhouse,1
	tok1:
	flh:
	cmp fullhouse,1
	jb cr
	make_text_macro 'F', area, 300, 40
	make_text_macro 'U', area, 310, 40
	make_text_macro 'L', area, 320, 40
	make_text_macro 'L', area, 330, 40
	make_text_macro ' ', area, 340, 40
	make_text_macro 'H', area, 350, 40
	make_text_macro 'O', area, 360, 40
	make_text_macro 'U', area, 370, 40
	make_text_macro 'S', area, 380, 40
	make_text_macro 'E', area, 390, 40
	jmp final_prog
	cr:
	cmp flush,1
	jne strait
	make_text_macro 'F', area, 300, 40
	make_text_macro 'L', area, 310, 40
	make_text_macro 'U', area, 320, 40
	make_text_macro 'S', area, 330, 40
	make_text_macro 'H', area, 340, 40
	jmp final_prog
	strait:
	cmp straight,1
	jne tok3
	make_text_macro 'S', area, 300, 40
	make_text_macro 'T', area, 310, 40
	make_text_macro 'R', area, 320, 40
	make_text_macro 'A', area, 330, 40
	make_text_macro 'I', area, 340, 40
	make_text_macro 'G', area, 350, 40
	make_text_macro 'H', area, 360, 40
	make_text_macro 'T', area, 370, 40
	jmp final_prog
	tok3:
	cmp tree, 1
	jb par
	make_text_macro 'T', area, 300, 40
	make_text_macro 'R', area, 310, 40
	make_text_macro 'E', area, 320, 40
	make_text_macro 'I', area, 330, 40
	jmp final_prog
	par:
	cmp pair_1,2
	jb par_1
	make_text_macro 'D', area, 300, 40
	make_text_macro 'O', area, 310, 40
	make_text_macro 'U', area, 320, 40
	make_text_macro 'A', area, 330, 40
	make_text_macro ' ', area, 340, 40
	make_text_macro 'P', area, 350, 40
	make_text_macro 'E', area, 360, 40
	make_text_macro 'R', area, 370, 40
	make_text_macro 'E', area, 380, 40
	make_text_macro 'C', area, 390, 40
	make_text_macro 'H', area, 400, 40
	make_text_macro 'I', area, 410, 40
	jmp final_prog
	par_1:
	cmp pair_1,1
	jne final_prog
	make_text_macro 'O', area, 300, 40
	make_text_macro ' ', area, 310, 40
	make_text_macro 'P', area, 320, 40
	make_text_macro 'E', area, 330, 40
	make_text_macro 'R', area, 340, 40
	make_text_macro 'E', area, 350, 40
	make_text_macro 'C', area, 360, 40
	make_text_macro 'H', area, 370, 40
	make_text_macro 'E', area, 380, 40
	jmp final_prog
	final_prog:
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
