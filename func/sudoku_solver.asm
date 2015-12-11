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
	
