extern printf
extern scanf

section .data
	format				dd			"%d", 0
		.space			dd			" ", 0
		.newline		dd			10, 0
	n					dd			9
	n_box				dd			3
	n_box_index			dd			2				
	N					dd			81
	x					dd			0
	y					dd			0
	msg_solved			db			"Solusi dapat ditemukan", 10, 0
	msg_not_solved		db			"Solusi tidak dapat ditemukan", 10, 0
	format_debug_push	db			"PUSH %d %d", 10, 0
	format_debug_pop	db			"POP %d %d", 10, 0
	
section .bss
	sudoku				resd		81
		.temp			resd		1
	is_solved			resd		1
	cell_value			resd		1
	check_value_var		resd		1
	
section .text
	global main
	
main:
	mov ecx, [N]
	mov ebx, 0
	
; Looping input user
loop_scanf:
	push ecx
	push sudoku.temp
	push format
	call scanf
	add esp, 8
	mov eax, [sudoku.temp]
	mov dword[sudoku+4*ebx], eax
	inc ebx
	pop ecx
	cmp ecx, 0
	loopne loop_scanf

; Memanggil fungsi soduko solver, untuk mencari solusi sudoku
	call sudoku_solver
	cmp dword[is_solved], 1
	je print_solved
	jmp print_not_solved
	
; Mencetak pesan ketika solusi ditemukan
print_solved:
	push msg_solved
	call printf
	add esp, 4
	mov ebx, 1
	jmp print_result
	
; Mencetak pesan ketika solusi tidak ditemukan
print_not_solved:
	push msg_not_solved
	call printf
	add esp, 4
	mov ebx, 1
	jmp print_result

; Procedure untuk mencari solusi sudoku. Stack terakhirnya merupakan hasil penentuan apakah solve atau tidak.
sudoku_solver:
	push 1
	push dword[x]
	push dword[y]
	cmp dword[x], -1
	je sudoku_solver_ret1
	call get_cell_value
	cmp dword[cell_value], 0
	jne value_not_0

sudoku_solver_loop:
	call check_value	
	cmp dword[check_value_var], 0
	jne sudoku_solver_loop_cond1_else
	mov eax, [n]
	inc dword[esp+2*4]	
	cmp [esp+2*4], eax
	jle sudoku_solver_loop
	jmp sudoku_solver_ret0
	
sudoku_solver_loop_cond1_else:
	mov eax, [esp+2*4]
	mov dword[cell_value], eax
	push dword[x]
	push dword[y] 
	call set_cell_value
	add esp, 8
	call next_value
	call sudoku_solver
	cmp dword[is_solved], 1
	je sudoku_solver_ret1
	call sudoku_solver_loop_cond_else
	mov eax, [n]
	inc dword[esp+2*4]
	cmp [esp+2*4], eax
	jle sudoku_solver_loop
	
	jmp sudoku_solver_ret0
	
sudoku_solver_loop_cond_else:
	mov eax, [esp+2*4]
	mov ebx, [esp+1*4]
	mov dword[x], eax
	mov dword[y], ebx
	mov dword[cell_value], 0
	push eax
	push ebx
	call set_cell_value
	add esp, 8
	ret
	
sudoku_solver_ret1:
	add esp, 12
	mov dword[is_solved], 1
	ret
	
sudoku_solver_ret0:
	add esp, 12
	mov dword[is_solved], 0
	ret
	
value_not_0:
	add esp, 12
	call next_value
	call sudoku_solver
	ret
	

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
	
; Fungsi untuk mendapatkan isi cell sudoku index yang diinginkan. Sebelum memanggil proc ini, harus push dulu dua index nya
get_cell_value:
	mov edx, 0
	mov eax, [esp+2*4]
	mov ecx, [esp+1*4]
	mov ebx, [n]
	mul ebx
	add eax, ecx
	mov eax, [sudoku+(eax*4)]
	mov dword[cell_value], eax
	ret

; Fungsi untuk mengisi cell value berdasarkan index yang diinginkan. Sebelum memanggil proc ini, harus push dulu dua index nya
set_cell_value:
	mov ecx, [esp+1*4]
	mov eax, [esp+2*4]
	mov ebx, [n]
	mov edx, 0
	mul ebx
	add eax, ecx
	mov edx, [cell_value]
	mov dword[sudoku+(eax*4)], edx
	ret

; Mengubah x dan y. untuk index array selanjutnya
next_value:
	inc dword[y]
	mov eax, [n]
	cmp dword[y], eax
	jge next_value_y

next_value_cmp_x:
	mov eax, [n]
	cmp dword[x], eax
	jge next_value_x
	
	ret
	
next_value_y:
	mov dword[y], 0
	inc dword[x]
	jmp next_value_cmp_x
	
next_value_x:
	mov dword[x], -1
	ret

; Bagian Mencetak keluaran. Dipanggil hanya terakhir. Sebelum menggunakan fungsi ini, ebx harus di set 1
print_result:
	push dword[sudoku+4*(ebx-1)]
	push format
	call printf
	add esp, 8
	mov edx, 0
	mov eax, ebx
	div dword[n]
	cmp edx, 0
	jg print_result_cond1
	jmp print_result_cond2
back_print_result:
	inc ebx
	cmp ebx, [N]
	jle print_result
	jmp exit

print_result_cond1:
	push format.space
	call printf
	add esp, 4
	jmp back_print_result
	
print_result_cond2:
	push format.newline
	call printf
	add esp, 4
	jmp back_print_result
	
exit:
	push format.newline
	call printf
	add esp, 4
