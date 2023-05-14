fold_left:
push r12
push r13
push r14
push r15
sub rsp,8

mov r12, rdi
mov r13, rdx
mov r14, rcx

mov eax, esi

xor r15, r15
.Loop:
cmp r15, r13
je .End

mov edi,eax
mov esi, [r14 + r15*4]

call r12

inc r15
jmp .Loop

.End:
add rsp,8
pop r15
pop r14
pop r13
pop r12
ret
