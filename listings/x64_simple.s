.intel_syntax
.global _start

.section .text

_start:
    call        main..main
    mov         %rdi, 0
    call        exit

main..main:
    push        %rbp
    mov         %rbp, %rsp
    sub         %rsp, 16
    inc         qword ptr [%rip+main..a]
    mov         byte ptr [%rbp-1], 1  # let b = 1
    mov         %rdi, qword ptr [%rip+main..a]
    mov         %sil, byte ptr [%rbp-1]
    and         %rsi, 255
    add         %rdi, %rsi
    call        exit
main..main.return:
    leave
    ret

.section .data
main..a:
    .quad       0x0000000000000002  # = 2
