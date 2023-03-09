.intel_syntax
.global _start

.section .text

_start:
    call        main..main
    mov         %rdi, 0
    call        exit

main..main:
    mov         %rdi, 21
    call        main..foo
    mov         %rdi, %rax
    call        exit
main..main.return:
    ret

main..foo:
    push        %rbp
    mov         %rbp, %rsp
    sub         %rsp, 16
    mov         qword ptr [%rbp-8], %rdi  # param n = %rdi
    mov         %rax, qword ptr [%rbp-8]
    imul        %rax, 2
    jmp         main..foo.return          # return %rax;
    mov         %rax, qword ptr [%rbp-8]
    mov         qword ptr [%rbp-16], %rax # let b = %rax
main..foo.return:
    leave
    ret
