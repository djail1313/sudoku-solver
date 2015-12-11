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
