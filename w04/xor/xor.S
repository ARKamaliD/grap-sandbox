// instead of default AT&T syntax we wan to use it without $ symbols before immediate values and registers
.intel_syntax noprefix

//.global exports symbol, doesn't have anything with functions explicitly to do
.global xor_cipher

.text

// DONE: Correct name
xor_cipher:
    // DONE: Your code :)
    cmp byte ptr [rdi],0
    je .Lend

.Lloopstart:
    mov rax,rdi
    //sil ist Teil von rsi becuase it gives the size we don't need "byte ptr" before [rdi]
    xor byte ptr [rdi],sil
    inc rdi
    cmp byte ptr [rdi],0
    jne .Lloopstart

.Lend:
    ret
