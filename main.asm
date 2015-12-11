extern printf
extern scanf

%include 'func/welcome.asm'
%include 'func/sudoku_solver.asm'
%include 'func/check_cell.asm'
%include 'func/set_get_cell_value.asm'
%include 'func/next_cell.asm'
%include 'func/print_result.asm'
%include 'func/color.asm'

section .data
	opening_text1		db			"Selamat Datang di Sudoku Solver 9x9", 10
	opening_text2		db			"Silahkan masukkan persoalan Sudoku : ", 10
						db			"(Cell yang kosong diisi dengan angka 0)", 10, 0
	closing_text		db			"Terima kasih sudah menggunakan aplikasi Soduko Solver.", 10, 0
	try_again			db			"Ulangi ?", 10
						db			"1. Ya",10
						db			"2. Tidak", 10, 0
	format				db			"%d", 0
		.space			db			" ", 0
		.newline		db			10, 0
	n					dd			9
	n_box				dd			3
	n_box_index			dd			2				
	N					dd			81
	x					dd			0
	y					dd			0
	msg_solved			db			"Solusi dapat ditemukan", 10, 0
	msg_not_solved		db			"Solusi tidak dapat ditemukan", 10, 0
	normal_color		db			1Bh, '[37;40m', 0
		.len			equ			$-normal_color
	red_color			db			1Bh, '[31;47m', 0
		.len			equ			$-red_color
	green_color			db			1Bh, '[32;47m', 0
		.len			equ			$-green_color
	blue_color			db			1Bh, '[34;47m', 0
		.len			equ			$-blue_color
	black_color			db			1Bh, '[30;47m', 0
		.len			equ			$-black_color
	seterasescreen		db			1Bh, '[2J'
		.len			equ			$ - seterasescreen
	setscroll			db			1Bh, '[r'
		.len			equ			$ - setscroll
	
section .bss
	sudoku				resd		81
		.temp			resd		1
	is_solved			resd		1
	cell_value			resd		1
	check_value_var		resd		1
	is_again			resd		1
	
section .text
	global main
	
main:
	mov dword[x], 0
	mov dword[y], 0
	call scrolling
	call print_black_color
	call erasescreen
	call welcome1
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
	call print_blue_color
	push msg_solved
	call printf
	add esp, 4
	mov ebx, 1
	jmp print_result
	
; Mencetak pesan ketika solusi tidak ditemukan
print_not_solved:
	call print_red_color
	push msg_not_solved
	call printf
	add esp, 4
	mov ebx, 1
	jmp print_result
	
exit:
	push format.newline
	call printf
	add esp, 4
	
	push try_again
	call printf
	add esp, 4
	
	push is_again
	push format
	call scanf
	add esp, 8
	
	cmp dword[is_again], 1
	je main

	call scrolling
	call print_normal_color
	call erasescreen
	push closing_text
	call printf
	add esp, 4
