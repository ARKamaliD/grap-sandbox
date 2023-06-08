.intel_syntax noprefix
.global grasm_interpreter

grasm_interpreter:
    # Save registers
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    # Initialize variables
    xor rbx, rbx      # rbx = 0 						(error code)
    mov r12, rdi      # r12 = struct grasm_state* state	(base address of struct)
    mov r13, rdx      # r13 = uint8_t prog[len]			(base address of bytecode)
    mov r14, rsi      # r14 = size_t len				(length of bytecode)
    xor r15, r15      # r15 = tmp						(temporary register)

	# Start executing instructions

execute_loop:
    mov rdi, qword ptr [r12]    # rdi = state->ip
    cmp rdi, r14                # Check for out-of-bounds access
    jl dispatch					# if ip <  length of bytecode: dispatch opcode
    jmp error_out_of_bound		# if ip => length of bytecode: out-of-bound error

dispatch:
    # Read the opcode from bytecode and increment the instruction pointer
    movzx eax, byte ptr [r13 + rdi]
    add rdi, 1

    # Dispatch to the appropriate instruction handler
    cmp al, 0x01      # stop		- 0x01				- Beendet die Ausführung
    je stop
    cmp al, 0x0f      # nop			- 0x0f				- Keine Funktion
    je nop
    cmp al, 0x10      # set			- 0x10 <imm>		- ac = imm uint64_t
    je set_ac_imm
    cmp al, 0x18      # set rX		- 0x18 <0X> <imm>	- rX = imm uint64_t
    je set_rX_imm
    cmp al, 0x11      # cpy rX		- 0x11 <0X>			- ac = rX
    je cpy_ac_rX
    cmp al, 0x19      # cpy rX rY	- 0x19 <XY>			- rX = rY
    je cpy_rX_rY
    cmp al, 0x20      # add			- 0x20 <imm>		- ac += imm uint64_t
    je add_ac_imm
    cmp al, 0x28      # add rX		- 0x28 <0X> <imm>	- rX += imm uint64_t
    je add_rX_imm
    cmp al, 0x21      # add rX		- 0x21 <0X>			- ac += rX
    je add_ac_rX
    cmp al, 0x29      # add rX rY	- 0x29 <XY>			- rX += rY
    je add_rX_rY
    cmp al, 0x22      # sub			- 0x22 <imm>		- ac -= imm uint64_t
    je sub_ac_imm
    cmp al, 0x2a      # sub rX		- 0x2a <0X> <imm>	- rX -= imm uint64_t
    je sub_rX_imm
    cmp al, 0x23      # sub rX		- 0x23 <0X>			- ac -= rX
    je sub_ac_rX
    cmp al, 0x2b      # sub rX rY	- 0x2b <XY>			- rX -= rY
    je sub_rX_rY
    cmp al, 0x24      # mul			- 0x24 <imm>		- ac *= imm uint64_t
    je mul_ac_imm
    cmp al, 0x2c      # mul rX		- 0x2c <0X> <imm>	- rX *= imm uint64_t
    je mul_rX_imm
    cmp al, 0x25      # mul rX		- 0x25 <0X>			- ac *= rX
    je mul_ac_rX
    cmp al, 0x2d      # mul rX rY	- 0x2d <XY>			- rX *= rY
    je mul_rX_rY
    cmp al, 0x26      # xchg rX		- 0x26 <0X>			- tmp = ac; ac = rX; rX = tmp
    je xchg_ac_rX
    cmp al, 0x2e      # xchg rX rY	- 0x2e <XY>			- tmp = rX; rX = rY; rY = tmp
    je xchg_rX_rY
    cmp al, 0x30      # and			- 0x30 <imm>		- ac &= imm uint64_t
    je and_ac_imm
    cmp al, 0x31      # and rX		- 0x31 <0X> <imm>	- rX &= imm	uint64_t
    je and_rX_imm
    cmp al, 0x32      # and rX		- 0x32 <0X>			- ac &= rX
    je and_ac_rX
    cmp al, 0x33      # and rX rY	- 0x33 <XY>			- rX &= rY
    je and_rX_rY
    cmp al, 0x34      # or			- 0x34 <imm>		- ac |= imm uint64_t
    je or_ac_imm
    cmp al, 0x35      # or rX		- 0x35 <0X> <imm>	- rX |= imm uint64_t
    je or_rX_imm
    cmp al, 0x36      # or rX		- 0x36 <0X>			- ac |= rX
    je or_ac_rX
    cmp al, 0x37      # or rX rY	- 0x37 <XY>			- rX |= rY
    je or_rX_rY
    cmp al, 0x38      # xor			- 0x38 <imm>		- ac ^= imm uint64_t
    je xor_ac_imm
    cmp al, 0x39      # xor rX		- 0x39 <0X> <imm>	- rX ^= imm uint64_t
    je xor_rX_imm
    cmp al, 0x3a      # xor rX		- 0x3a <0X>			- ac ^= rX
    je xor_ac_rX
    cmp al, 0x3b      # xor rX rY	- 0x3b <XY>			- rX ^= rY
    je xor_rX_rY
    cmp al, 0x3c      # not			- 0x3c				- ac = ~ac
    je not_ac
    cmp al, 0x3d      # not rX		- 0x3d <0X>			- ac = ~rX
    je not_ac_rX
    cmp al, 0x3e      # not rX rY	- 0x3e <XY>			- rX = ~rY
    je not_rX_rY
    cmp al, 0x40      # cmp rX		- 0x40 <0X> <imm>	- ac = rX - imm uint64_t
    je cmp_ac_rX_imm
    cmp al, 0x41      # cmp rX rY	- 0x41 <XY>			- ac = rX - rY
    je cmp_ac_rX_rY
    cmp al, 0x42      # tst rX		- 0x42 <0X> <imm>	- ac = rX & imm uint64_t
    je tst_ac_rX_imm
    cmp al, 0x43      # tst rX rY	- 0x43 <XY>			- ac = rX & rY
    je tst_ac_rX_rY
    cmp al, 0x50      # shr			- 0x50 <imm>		- ac >>= imm uint8_t
    je shr_ac_imm
    cmp al, 0x51      # shr rX		- 0x51 <0X> <imm>	- rX >>= imm uint8_t
    je shr_rX_imm
    cmp al, 0x52      # shr rX		- 0x52 <0X>			- ac >>= rX
    je shr_ac_rX
    cmp al, 0x53      # shr rX rY	- 0x53 <XY>			- rX >>= rY
    je shr_rX_rY
    cmp al, 0x54      # shl			- 0x54 <imm>		- ac <<= imm uint8_t
    je shl_ac_imm
    cmp al, 0x55      # shl rX		- 0x55 <0X> <imm>	- rX <<= imm uint8_t
    je shl_rX_imm
    cmp al, 0x56      # shl rX		- 0x56 <0X>			- ac <<= rX
    je shl_ac_rX
    cmp al, 0x57      # shl rX rY	- 0x57 <XY>			- rX <<= rY
    je shl_rX_rY
    cmp al, 0x60      # ld			- 0x60 <imm>		- ac = [imm uintptr_t]
    je ld_ac_imm
    cmp al, 0x61      # ld rX		- 0x61 <0X> <imm>	- rX = [imm uintptr_t]
    je ld_rx_imm
    cmp al, 0x62      # ld rX		- 0x62 <0X>			- ac = [rX]
    je ld_ac_rx
    cmp al, 0x63      # ld rX rY	- 0x63 <XY>			- rX = [rY]
    je ld_rX_rY
    cmp al, 0x64      # st			- 0x64 <imm>		- [imm uintptr_t] = ac
    je st_imm_ac
    cmp al, 0x65      # st rX		- 0x65 <0X> <imm>	- [imm uintptr_t] = rX
    je st_imm_rX
    cmp al, 0x66      # st rX		- 0x66 <0X>			- [rX] = ac
    je st_rx_ac
    cmp al, 0x67      # st rX rY	- 0x67 <XY>			- [rX] = rY
    je st_rX_rY
    cmp al, 0x70      # go			- 0x70 <imm>		- ip = <imm uintptr_t>
    je go_imm
    cmp al, 0x71      # go rX		- 0x71 <0X>			- ip = rX
    je go_rX
    cmp al, 0x72      # gr			- 0x72 <imm>		- ip = ip + <imm int16_t>
    je gr_imm
    cmp al, 0x73      # jz			- 0x73 <imm>		- ip = ac == 0 ? <imm uintptr_t> : ip + sizeof(jz)
    je jz_ac_imm
    cmp al, 0x74      # jz rX		- 0x74 <0X>			- ip = ac == 0 ? rX : ip + sizeof(jz)
    je jz_ac_rX
    cmp al, 0x75      # jrz			- 0x75 <imm>		- ip = ac == 0 ? ip + <imm int16_t> : ip + sizeof(jrz)
    je jrz_imm
    cmp al, 0x80      # ecall		- 0x80 <imm>		- ac = <imm uintptr_t>(r0, .., r5)
    je ecall_imm
    cmp al, 0x81      # ecall rX	- 0x81 <0X>			- ac = rX(r0, .., r5)
    je ecall_rX

    # No Opcode matched - error -1
    mov rbx, -1
	jmp error

nop:
    # No operation, move to the next instruction
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

set_ac_imm:
    # ac = imm
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
    add rdi, 8
    mov qword ptr [r12 + 8], rax  # state->ac = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

set_rX_imm:
	# rX = imm
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
	add rdi, 8
    mov qword ptr [r12 + 16 + r15*8], rax  # state->rX = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

cpy_ac_rX:
	# ac = rX
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    mov qword ptr [r12 + 8], rax  # state->ac = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

cpy_rX_rY:
    # rX = rY
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r12 + 16 + rax*8]  # rax = state->rY
    mov qword ptr [r12 + 16 + r15*8], rax  # state->rX = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

add_ac_imm:
    # ac += imm
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
    add rdi, 8
    add qword ptr [r12 + 8], rax  # state->ac += rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

add_rX_imm:
    # rX += imm
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
	add rdi, 8
    add qword ptr [r12 + 16 + r15*8], rax  # state->rX += rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

add_ac_rX:
    # ac += rX
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    add qword ptr [r12 + 8], rax  # state->ac += rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

add_rX_rY:
    # rX += rY
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r12 + 16 + rax*8]  # rax = state->rY
    add qword ptr [r12 + 16 + r15*8], rax  # state->rX += rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

sub_ac_imm:
    # ac -= imm
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
    add rdi, 8
    sub qword ptr [r12 + 8], rax  # state->ac -= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

sub_rX_imm:
    # rX -= imm
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
	add rdi, 8
    sub qword ptr [r12 + 16 + r15*8], rax  # state->rX -= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

sub_ac_rX:
    # ac -= rX
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    sub qword ptr [r12 + 8], rax  # state->ac -= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

sub_rX_rY:
    # rX -= rY
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r12 + 16 + rax*8]  # rax = state->rY
    sub qword ptr [r12 + 16 + r15*8], rax  # state->rX -= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

mul_ac_imm:
    # ac *= imm
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
    add rdi, 8
    mul qword ptr [r12 + 8] # rdx:rax = rax * state->ac
    mov qword ptr [r12 + 8], rax  # state->ac = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

mul_rX_imm:
    # rX *= imm
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
	add rdi, 8
    mul qword ptr [r12 + 16 + r15*8] # rdx:rax = rax * state->rX
    mov qword ptr [r12 + 16 + r15*8], rax  # state->rX = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

mul_ac_rX:
    # ac *= rX
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    mul qword ptr [r12 + 8] # rdx:rax = rax * state->ac
    mov qword ptr [r12 + 8], rax  # state->ac = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

mul_rX_rY:
    # rX *= rY
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r12 + 16 + rax*8]  # rax = state->rY
    mul qword ptr [r12 + 16 + r15*8] # rdx:rax = rax * state->rX
    mov qword ptr [r12 + 16 + r15*8], rax  # state->rX = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

xchg_ac_rX:
    # tmp = ac; ac = rX; rX = tmp
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    mov rdx, qword ptr [r12 + 8] # rdx = state->ac
    mov qword ptr [r12 + 8], rax  # state->ac = rax
    mov qword ptr [r12 + 16 + r15*8], rdx  # state->rX = rdx
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

xchg_rX_rY:
    # tmp = rX; rX = rY; rY = tmp
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov rdx, qword ptr [r12 + 16 + r15*8]  # rdx = state->rX
    xchg rdx, qword ptr [r12 + 16 + rax*8]  # rdx <=> state->rY
    mov qword ptr [r12 + 16 + r15*8], rdx  # state->rX = rdx
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

and_ac_imm:
    # ac &= imm
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
    add rdi, 8
    and qword ptr [r12 + 8], rax  # state->ac &= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

and_rX_imm:
    # rX &= imm
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
	add rdi, 8
    and qword ptr [r12 + 16 + r15*8], rax  # state->rX &= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

and_ac_rX:
    # ac &= rX
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    and qword ptr [r12 + 8], rax  # state->ac &= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

and_rX_rY:
    # rX &= rY
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r12 + 16 + rax*8]  # rax = state->rY
    and qword ptr [r12 + 16 + r15*8], rax  # state->rX &= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

or_ac_imm:
    # ac |= imm
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
    add rdi, 8
    or qword ptr [r12 + 8], rax  # state->ac |= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

or_rX_imm:
    # rX |= imm
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
	add rdi, 8
    or qword ptr [r12 + 16 + r15*8], rax  # state->rX |= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

or_ac_rX:
    # ac |= rX
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    or qword ptr [r12 + 8], rax  # state->ac |= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

or_rX_rY:
    # rX |= rY
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r12 + 16 + rax*8]  # rax = state->rY
    or qword ptr [r12 + 16 + r15*8], rax  # state->rX |= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

xor_ac_imm:
    # ac ^= imm
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
    add rdi, 8
    xor qword ptr [r12 + 8], rax  # state->ac ^= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

xor_rX_imm:
    # rX ^= imm
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r13 + rdi] # rax = imm uint64_t
	add rdi, 8
    xor qword ptr [r12 + 16 + r15*8], rax  # state->rX ^= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

xor_ac_rX:
    # ac ^= rX
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    xor qword ptr [r12 + 8], rax  # state->ac ^= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

xor_rX_rY:
    # rX ^= rY
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov rax, qword ptr [r12 + 16 + rax*8]  # rax = state->rY
    xor qword ptr [r12 + 16 + r15*8], rax  # state->rX ^= rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

not_ac:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

not_ac_rX:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

not_rX_rY:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

cmp_ac_rX_imm:
    # ac = rX - imm
    movzx r15, byte ptr [r13 + rdi] # r15 = 0X
    add rdi, 1
    and r15, 0x0F # r15 = X
    cmp r15b, 0x07
    jg error_out_of_bound
	mov rax, qword ptr [r12 + 16 + r15*8]  # rax = state->rX
    sub rax, qword ptr [r13 + rdi] # rax = rax - imm uint64_t
	add rdi, 8
    mov qword ptr [r12 + 8], rax  # state->ac = rax
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

cmp_ac_rX_rY:
    # ac = rX - rY
    movzx r15, byte ptr [r13 + rdi] # r15 = XY
    add rdi, 1
	mov rax, r15 # rax = XY
    and r15, 0xF0 # r15 = X0
    shr r15, 4 #r15 = 0X
    cmp r15b, 0x07
    jg error_out_of_bound
    and rax, 0x0F #rax = 0Y
    cmp rax, 0x07
    jg error_out_of_bound
    mov r15, qword ptr [r12 + 16 + r15*8]  # r15 = state->rX
    sub r15, qword ptr [r12 + 16 + rax*8]  # r15 = r15 - state->rY
    mov qword ptr [r12 + 8], r15  # state->ac = r15
    mov qword ptr [r12], rdi    # state->ip = rdi
    jmp execute_loop

tst_ac_rX_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

tst_ac_rX_rY:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

shr_ac_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

shr_rX_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

shr_ac_rX:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

shr_rX_rY:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

shl_ac_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

shl_rX_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

shl_ac_rX:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

shl_rX_rY:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

ld_ac_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

ld_rx_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

ld_ac_rx:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

ld_rX_rY:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

st_imm_ac:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

st_imm_rX:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

st_rx_ac:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

st_rX_rY:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

go_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

go_rX:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

gr_imm:
    # ip = ip + <imm int16_t>, imm int16_t
    mov ax, word ptr [r13 + rdi] # ax = imm int16_t
    add rdi, 2
    adc word ptr [r12], ax    # state->ip = ip + ax
    jmp execute_loop

jz_ac_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

jz_ac_rX:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

jrz_imm:
    # ip = ac == 0 ? ip + <imm> : ip + sizeof(jrz), imm int16_t
    mov rax, qword ptr [r12 + 8] # rax = state->ac
	cmp rax, 0
    jne jrz_imm_skip
    mov ax, word ptr [r13 + rdi] # ax = imm int16_t
    add rdi, 2
    adc word ptr [r12], ax    # state->ip = ip + ax
    jmp execute_loop
jrz_imm_skip:
    add qword ptr [r12], 0x3    # state->ip = ip + sizeof(jrz)
    jmp execute_loop

ecall_imm:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

ecall_rX:
    # TODO: implement
    mov qword ptr [r12], rdi    # state->ip = rdi
    movzx rbx, byte ptr [r13 + rdi - 1]
    jmp error

error_out_of_bound:
	mov rax, -2
    jmp error

error:
    # Set error code to rbx and end
    cmp rbx, -1
    je error_skip_rax
    mov rbx, rax
error_skip_rax:
	#mov qword ptr [r12], rdi    # state->ip = rdi
	jmp end

stop:
	mov qword ptr [r12], rdi      # r12 = struct grasm_state* state	(base address of struct) = ip
    jmp end

end:
    # Clean up and return
    mov rax, rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
