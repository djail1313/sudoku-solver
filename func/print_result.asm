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
