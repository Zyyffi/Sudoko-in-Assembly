include irvine32.inc
Include macros.inc
buffer_size = 2000
.data

 str1 BYTE 0C9h
      BYTE  2 dup(2 dup(0CDh,0D1h),0CDh,0CBh)
      BYTE  2 dup(0CDh,0D1h),0CDh,0BBh,0

 str2 BYTE 0BAh,2 dup(2 dup(' ',0B3h),' ',0BAh),2 dup(' ',0B3h),' ',0BAh,0

 str3 BYTE 0C7h
      BYTE  2 dup(2 dup(0C4h,0C5h),0C4h,0D7h)
      BYTE        2 dup(0C4h,0C5h),0C4h,0B6h,0

 str4 BYTE 0CCh
      BYTE  2 dup(2 dup(0CDh,0D8h),0CDh,0CEh)
      BYTE        2 dup(0CDh,0D8h),0CDh,0B9h,0

 str5 BYTE 0C8h
      BYTE  2 dup(2 dup(0CDh,0CFh),0CDh,0CAh)
      BYTE  2 dup(0CDh,0CFh),0CDh,0BCh,0

str6 byte "PRESS a: TO MOVE CURSOR LEFT",0
str7 byte "PRESS s: TO MOVE CURSOR DOWNWARD",0 
str8 byte "PRESS d: TO MOVE CURSOR RIGHT",0
str9 byte "PRESS w: TO MOVE CURSOR UPWARD",0
cur_col byte 1
cur_row byte 6
row_counter byte 1
col_counter Dword 0
scan_col_count byte 1
error1 byte "Invlid input       ",0
valid byte  "                   ",0
range byte "Can't move further",0

.code
main proc
call crlf
call level1
call draw_board
call user_input
call mov_cur
exit
main endp

level1 proc
.data
row1 byte 3 dup(' '),'2','9',4 dup(' ')

ori_row1 byte 3 dup(' '),'2','9',4 dup(' ')
row2 byte '7',6 dup(' '),'3',' '
ori_row2 byte '7',6 dup(' '),'3',' '
row3 byte '1','4','8','7','3','5',3 dup(' ')
ori_row3 byte '1','4','8','7','3','5',3 dup(' ')
row4 byte '5',' ','4',' ','7',' ','6','8',' '
ori_row4 byte '5',' ','4',' ','7',' ','6','8',' '
row5 byte ' ','3',5 dup(' '),'4',' '
ori_row5 byte ' ','3',5 dup(' '),'4',' '
row6 byte ' ','7','9',' ','8',' ','2',' ','3'
ori_row6 byte ' ','7','9',' ','8',' ','2',' ','3'
row7 byte 3 dup(' '),'5','1','4','8','2','7'
ori_row7 byte 3 dup(' '),'5','1','4','8','2','7'
row8 byte ' ','1',6 dup(' '),'6'
ori_row8 byte ' ','1',6 dup(' '),'6'
row9 byte 4 dup(' '),'6','9',3 dup(' ')
ori_row9 byte 4 dup(' '),'6','9',3 dup(' ')
.code 
ret
level1 endp


mov_cur proc
mGotoxy cur_col,cur_row
cmp al,'a'
je left
cmp al,'s'
je down
cmp al,'d'
je right
cmp al,'w'
je up
mgotoxy 30,5
mov edx,offset error1
call writestring
jmp next

left:
	cmp cur_col,1
	jbe out_of_range
	sub cur_col,2
	dec col_counter
	jmp next
right:
	cmp cur_col,17
	jae out_of_range
	add cur_col,2
	inc col_counter
	jmp next
down:
	cmp cur_row,21
	jae out_of_range
	inc row_counter
	add cur_row,2
	jmp next
up:
	cmp cur_row,6
	jbe out_of_range
	dec row_counter
	sub cur_row,2
	jmp next
out_of_range:
	mgotoxy 30,5
	mov edx,offset range
	call writestring
next:
mov_cur endp

user_input proc
	mGotoxy cur_col,cur_row
	call readchar
	cmp al,'9'
	ja move
	cmp al,'1'
	jb invalid_input
	mov bl,row_counter
	cmp bl,1
	je r1
	cmp bl,2
	je r2
	cmp bl,3
	je r3
	cmp bl,4
	je r4
	cmp bl,5
	je r5
	cmp bl,6
	je r6
	cmp bl,7
	je r7
	cmp bl,8
	je r8
	cmp bl,9
	je r9
	r1:
		mov edi,offset row1
		mov esi,offset ori_row1
		jmp label1
	r2:
		mov edi,offset row2
		mov esi,offset ori_row2
		jmp label1
	r3:
		mov edi,offset row3
		mov esi,offset ori_row3
		jmp label1
	r4:
		mov edi,offset row4
		mov esi,offset ori_row4
		jmp label1
	r5:
		mov edi,offset row5
		mov esi,offset ori_row5
		jmp label1
	r6:
		mov edi,offset row6
		mov esi,offset ori_row6
		jmp label1
	r7:
		mov edi,offset row7
		mov esi,offset ori_row7
		jmp label1
	r8:
		mov edi,offset row8
		mov esi,offset ori_row8
		jmp label1
	r9:
		mov edi,offset row9
		mov esi,offset ori_row9
		jmp label1
	label1:
		mov bl,al
		add esi,col_counter
		mov al,[esi]
		call IsDigit
		mov al,bl
		jz invalid_input

		mov esi,0
		mov ecx,9

		scanRow:
			mov bl,[edi+esi]
			cmp [edi+esi],al
			je invalid_input
			inc esi
		loop scanRow

		mov bl,1
		mov ecx,5
		mov esi,col_counter
		scanCol:
			cmp bl,1
			je sel_row1
			cmp bl,2
			je sel_row2
			cmp bl,3
			je sel_row3
			cmp bl,4
			je sel_row4
			cmp bl,5
			je sel_row5
			sel_row1:
				mov edi,offset row1
				jmp label2
			sel_row2:
				mov edi,offset row2
				jmp label2
			sel_row3:
				mov edi,offset row3
				jmp label2
			sel_row4:
				mov edi,offset row4
				jmp label2
			sel_row5:
				mov edi,offset row5
				jmp label2
			label2:
				cmp [edi+esi],al
				je invalid_input
				inc bl
		loop scanCol

		mov ecx,4
		scanCol1:
			cmp bl,6
			je sel_row6
			cmp bl,7
			je sel_row7
			cmp bl,8
			je sel_row8
			cmp bl,9
			je sel_row9

			sel_row6:
				mov edi,offset row6
				jmp label4
			sel_row7:
				mov edi,offset row7
				jmp label4
			sel_row8:
				mov edi,offset row8
				jmp label4
			sel_row9:
				mov edi,offset row9
			label4:
				cmp [edi+esi],al
				je invalid_input
				inc bl
		loop scanCol1

		mov ebx,col_counter
		mov ah,row_counter

		cmp ah,6
		ja check_box7
		cmp ah,3
		ja check_box4

		check_box1:
			cmp ebx,5
			ja box3
			cmp ebx,2
			ja box2
			jmp box1
		check_box4:
			cmp ebx,5
			ja box6
			cmp ebx,2
			ja box5
			jmp box4
		check_box7:
			cmp ebx,5
			ja box9
			cmp ebx,2
			ja box8
			jmp box7

		box1:
			mov ecx,3
			mov esi,0
			l1a:
				cmp [row1+esi],al
				je invalid_input
				inc esi
			loop l1a
			mov ecx,3
			mov esi,0
			l1b:
				cmp [row2+esi],al
				je invalid_input
				inc esi
			loop l1b
			mov ecx,3
			mov esi,0
			l1c:
				cmp [row3+esi],al
				je invalid_input
				inc esi
			loop l1c
			jmp label3
		box2:
			mov ecx,3
			mov esi,3
			l2a:
				cmp [row1+esi],al
				je invalid_input
				inc esi
			loop l2a
			mov ecx,3
			mov esi,3
			l2b:
				cmp [row2+esi],al
				je invalid_input
				inc esi
			loop l2b
			mov ecx,3
			mov esi,3
			l2c:
				cmp [row3+esi],al
				je invalid_input
				inc esi
			loop l2c
			jmp label3
		box3:
			mov ecx,3
			mov esi,6
			l3a:
				cmp [row1+esi],al
				je invalid_input
				inc esi
			loop l3a
			mov ecx,3
			mov esi,6
			l3b:
				cmp [row2+esi],al
				je invalid_input
				inc esi
			loop l3b
			mov ecx,3
			mov esi,6
			l3c:
				cmp [row3+esi],al
				je invalid_input
				inc esi
			loop l3c
			jmp label3
		box4:
			mov ecx,3
			mov esi,0
			l4a:
				cmp [row4+esi],al
				je invalid_input
				inc esi
			loop l4a
			mov ecx,3
			mov esi,0
			l4b:
				cmp [row5+esi],al
				je invalid_input
				inc esi
			loop l4b
			mov ecx,3
			mov esi,0
			l4c:
				cmp [row6+esi],al
				je invalid_input
				inc esi
			loop l4c
			jmp label3
		box5:
			mov ecx,3
			mov esi,3
			l5a:
				cmp [row4+esi],al
				je invalid_input
				inc esi
			loop l5a
			mov ecx,3
			mov esi,3
			l5b:
				cmp [row5+esi],al
				je invalid_input
				inc esi
			loop l5b
			mov ecx,3
			mov esi,3
			l5c:
				cmp [row6+esi],al
				je invalid_input
				inc esi
			loop l5c
			jmp label3
		box6:
			mov ecx,3
			mov esi,6
			l6a:
				cmp [row4+esi],al
				je invalid_input
				inc esi
			loop l6a
			mov ecx,3
			mov esi,6
			l6b:
				cmp [row5+esi],al
				je invalid_input
				inc esi
			loop l6b
			mov ecx,3
			mov esi,6
			l6c:
				cmp [row6+esi],al
				je invalid_input
				inc esi
			loop l6c
			jmp label3
		box7:
			mov ecx,3
			mov esi,0
			l7a:
				cmp [row7+esi],al
				je invalid_input
				inc esi
			loop l7a
			mov ecx,3
			mov esi,0
			l7b:
				cmp [row8+esi],al
				je invalid_input
				inc esi
			loop l7b
			mov ecx,3
			mov esi,0
			l7c:
				cmp [row9+esi],al
				je invalid_input
				inc esi
			loop l7c
			jmp label3
		box8:
			mov ecx,3
			mov esi,3
			l8a:
				cmp [row7+esi],al
				je invalid_input
				inc esi
			loop l8a
			mov ecx,3
			mov esi,3
			l8b:
				cmp [row8+esi],al
				je invalid_input
				inc esi
			loop l8b
			mov ecx,3
			mov esi,3
			l8c:
				cmp [row9+esi],al
				je invalid_input
				inc esi
			loop l8c
			jmp label3
		box9:
			mov ecx,3
			mov esi,6
			l9a:
				cmp [row7+esi],al
				je invalid_input
				inc esi
			loop l9a
			mov ecx,3
			mov esi,6
			l9b:
				cmp [row8+esi],al
				je invalid_input
				inc esi
			loop l9b
			mov ecx,3
			mov esi,6
			l9c:
				cmp [row9+esi],al
				je invalid_input
				inc esi
			loop l9c
			jmp label3
	label3:
		mov esi,col_counter
		mov [edi+esi],al
		mov bl,[edi+esi]
		call writechar
		mgotoxy 30,5
		mov edx,offset valid
		call writestring
		jmp Next
move:
	call mov_cur
	jmp next
invalid_input:
	mov  eax,black+(lightred*16)
	call SetTextColor
	mgotoxy 30,5
	mov edx,offset error1
	call writestring
next:
	call user_input 

user_input endp



draw_board PROC
;call play_out
mov  eax,black+(yellow*16)
call SetTextColor
mov ecx,18
mov al,' '
call crlf
call crlf
call crlf
call crlf
 mov edx,OFFSET str1
    call WriteString
    call Crlf
    mov edi,OFFSET str2
	mov esi,offset row1
	l1:
	cmp [edi],al
	jne next1
	mov bl,[esi]
	mov [edi],bl
	inc esi
	next1:
	inc edi
	loop l1

	mov edx,OFFSET str2
    call WriteString
    call Crlf

    mov edx,OFFSET str3
    call WriteString
    call Crlf

	mov edi,OFFSET str2
	mov esi,offset row2
	mov ecx,19
	l2:
	cmp [edi],al
	jne next2
	mov bl,[esi]
	mov [edi],bl
	inc esi
	jmp quit2
	next2:
	mov ah,'9'
	cmp [edi],ah
	ja quit2
	mov ah,'1'
	cmp [edi],ah
	jb quit2
	mov bl,[esi]
	mov [edi],bl
	inc esi
	quit2:
	inc edi
	loop l2
    mov edx,OFFSET str2
    call WriteString
    call Crlf

    mov edx,OFFSET str3
    call WriteString
    call Crlf
	mov edi,OFFSET str2
	mov esi,offset row3
	mov ecx,18
l3:
	cmp [edi],al
	jne next3
	mov bl,[esi]
	mov [edi],bl
	inc esi
	jmp quit3
	next3:
	mov ah,'9'
	cmp [edi],ah
	ja quit3
	mov ah,'1'
	cmp [edi],ah
	jb quit3
	mov bl,[esi]
	mov [edi],bl
	inc esi
	quit3:
	inc edi
loop l3
    mov edx,OFFSET str2
    call WriteString
    call Crlf
    mov edx,OFFSET str4
    call WriteString
    call Crlf
	mov edi,OFFSET str2
	mov esi,offset row4
	mov ecx,18
	l4:
	cmp [edi],al
	jne next4
	mov bl,[esi]
	mov [edi],bl
	inc esi
	jmp quit4
	next4:
	mov ah,'9'
	cmp [edi],ah
	ja quit4
	mov ah,'1'
	cmp [edi],ah
	jb quit4
	mov bl,[esi]
	mov [edi],bl
	inc esi
	quit4:
	inc edi
	loop l4
    mov edx,OFFSET str2
    call WriteString
    call Crlf
    mov edx,OFFSET str3
    call WriteString
    call Crlf
	mov edi,OFFSET str2
	mov esi,offset row5
	mov ecx,18
	l5:
	cmp [edi],al
	jne next5
	mov bl,[esi]
	mov [edi],bl
	inc esi
	jmp quit5
	next5:
	mov ah,'9'
	cmp [edi],ah
	ja quit5
	mov ah,'1'
	cmp [edi],ah
	jb quit5
	mov bl,[esi]
	mov [edi],bl
	inc esi
	quit5:
	inc edi
	loop l5
    mov edx,OFFSET str2
    call WriteString
    call Crlf
    mov edx,OFFSET str3
    call WriteString
    call Crlf
	mov edi,OFFSET str2
	mov esi,offset row6
	mov ecx,18
	l6:
	cmp [edi],al
	jne next6
	mov bl,[esi]
	mov [edi],bl
	inc esi
	jmp quit6
	next6:
	mov ah,'9'
	cmp [edi],ah
	ja quit6
	mov ah,'1'
	cmp [edi],ah
	jb quit6
	mov bl,[esi]
	mov [edi],bl
	inc esi
	quit6:
	inc edi
	loop l6
    mov edx,OFFSET str2
    call WriteString
    call Crlf
    mov edx,OFFSET str4
    call WriteString
    call Crlf
	mov edi,OFFSET str2
	mov esi,offset row7
	mov ecx,18
l7:
	cmp [edi],al
	jne next7
	mov bl,[esi]
	mov [edi],bl
	inc esi
	jmp quit7
	next7:
	mov ah,'9'
	cmp [edi],ah
	ja quit7
	mov ah,'1'
	cmp [edi],ah
	jb quit7
	mov bl,[esi]
	mov [edi],bl
	inc esi
	quit7:
	inc edi
	loop l7
    mov edx,OFFSET str2
    call WriteString
    call Crlf
    mov edx,OFFSET str3
    call WriteString
    call Crlf
	mov edi,OFFSET str2
	mov esi,offset row8
	mov ecx,18
l8:
	cmp [edi],al
	jne next8
	mov bl,[esi]
	mov [edi],bl
	inc esi
	jmp quit8
	next8:
	mov ah,'9'
	cmp [edi],ah
	ja quit8
	mov ah,'1'
	cmp [edi],ah
	jb quit8
	mov bl,[esi]
	mov [edi],bl
	inc esi
	quit8:
	inc edi
	loop l8
    mov edx,OFFSET str2
    call WriteString
    call Crlf
    mov edx,OFFSET str3
    call WriteString
    call Crlf
	mov edi,OFFSET str2
	mov esi,offset row9
	mov ecx,18
	l9:
	cmp [edi],al
	jne next9
	mov bl,[esi]
	mov [edi],bl
	inc esi
	jmp quit9
	next9:
	mov ah,'9'
	cmp [edi],ah
	ja quit9
	mov ah,'1'
	cmp [edi],ah
	jb quit9
	mov bl,[esi]
	mov [edi],bl
	inc esi
	quit9:
	inc edi
	loop l9
    mov edx,OFFSET str2
    call WriteString
    call Crlf
    mov edx,OFFSET str5
    call WriteString
    call Crlf
	mov edx,offset str6
call crlf
call crlf
call writestring
call crlf
mov edx,offset str7
call writestring
call crlf
mov edx,offset str8
call writestring
call crlf
mov edx,offset str9
call writestring
call crlf
    ret
draw_board endp

end main