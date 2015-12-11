; Fungsi untuk mengecek apakah nilai tersebut dapat disimpan ke dalam cell sudoku. Penerimaan parameter menggunakan stack
; Sebelum memanggil proc ini harus push ke stack dulu value yang akan di cek
check_value:
	mov ebx, 0
	
;Cek apakah nilai sudah ada digaris horizontal nya
check_value_horizontal:	
	push ebx
	push dword[x]
	push ebx
	call get_cell_value
	add esp, 8
	pop ebx
	mov edx, [esp+3*4]
	cmp dword[cell_value], edx
	je check_value_ret0
	inc ebx
	cmp ebx, [n]
	jl check_value_horizontal
	mov ebx, 0
	
;Cek apakah nilai sudah ada digaris vertikal nya
check_value_vertical:
	push ebx
	push dword[y]
	call get_cell_value
	add esp, 4
	pop ebx
	mov edx, [esp+3*4]
	cmp dword[cell_value], edx
	je check_value_ret0
	inc ebx
	cmp ebx, [n]
	jl check_value_vertical
	
	;menghitung x_min
	mov edx, 0
	mov eax, dword[x]
	div dword[n_box]
	mul dword[n_box]
	push eax
	;menghitung y_min
	mov edx, 0
	mov eax, dword[y]
	div dword[n_box]
	mul dword[n_box]
	push eax
	;menghitung x_max
	mov eax, [esp+1*4]
	add eax, [n_box_index]
	push eax
	;menghitung y_max
	mov eax, [esp+1*4]
	add eax, [n_box_index]
	push eax
	
; Nested Loop. Cek apakah nilai dikotak 3x3 nya sudah ada
check_value_box1:
	push dword[esp+2*4]
	check_value_box2:
		push dword[esp+4*4]
		push dword[esp+1*4]
		call get_cell_value
		add esp, 8
		mov edx, [esp+8*4]
		cmp dword[cell_value], edx
		je check_value_ret02
		mov eax, [esp+1*4]
		inc dword[esp+0*4]
		cmp dword[esp+0*4], eax
	jle check_value_box2
	add esp, 4
	mov eax, [esp+1*4]
	inc dword[esp+3*4]
	cmp dword[esp+3*4], eax
jle check_value_box1

	jmp check_value_ret1

check_value_ret02:
	add esp, 20

check_value_ret0:
	mov dword[check_value_var], 0
	ret

check_value_ret1:
	add esp, 16
	mov dword[check_value_var], 1
	ret
