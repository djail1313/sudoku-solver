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

