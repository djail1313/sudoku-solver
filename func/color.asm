print_black_color:
	mov eax, 4
	mov ebx, 1
	mov ecx, black_color
	mov edx, black_color.len
	int 80h
	ret

print_red_color:
	mov eax, 4
	mov ebx, 1
	mov ecx, red_color
	mov edx, red_color.len
	int 80h
	ret

print_green_color:
	mov eax, 4
	mov ebx, 1
	mov ecx, green_color
	mov edx, green_color.len
	int 80h
	ret

print_blue_color:
	mov eax, 4
	mov ebx, 1
	mov ecx, blue_color
	mov edx, blue_color.len
	int 80h
	ret

print_normal_color:
	mov eax, 4
	mov ebx, 1
	mov ecx, normal_color
	mov edx, normal_color.len
	int 80h
	ret

erasescreen:
	mov eax, 4
	mov ebx, 1
	mov ecx, seterasescreen
	mov edx, seterasescreen.len
	int 80h
	ret

scrolling:
	mov eax, 4
	mov ebx, 1
	mov ecx, setscroll
	mov edx, setscroll.len
	int 80h
	ret
