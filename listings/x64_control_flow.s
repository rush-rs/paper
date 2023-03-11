.intel_syntax
.global _start

.section .text

_start:
    call        main..main
    mov         %rdi, 0
    call        exit

main..main:
    mov         %rdi, 1
    call        main..bar
main..main.return:
    ret

main..bar:
    push        %rbp
    mov         %rbp, %rsp
    sub         %rsp, 32
    mov         byte ptr [%rbp-1], %dil                  # param a = %dil
    test        byte ptr [%rbp-1], 1
    je          .block_0                                 # if a {
    movsd       %xmm0, qword ptr [%rip+.quad_constant_0] #   42f
    jmp         .block_1
.block_0:                                                # } else {
    movsd       %xmm0, qword ptr [%rip+.quad_constant_1] #   3.14
.block_1:                                                # }
    movsd       qword ptr [%rbp-16], %xmm0               # let b = %xmm0
    movsd       %xmm0, qword ptr [%rbp-16]
    ucomisd     %xmm0, qword ptr [%rip+.quad_constant_0]
    jp          .block_2
    jne         .block_2                                 # if b == 42f {
    mov         %rax, 11                                 #   11
    jmp         .block_3
.block_2:                                                # } else {
    mov         %rax, 3                                  #   3
.block_3:                                                # }
    mov         qword ptr [%rbp-24], %rax                # let c = %rax
.block_4:                                                # loop {
    jmp         .block_5                                 #   break;
    jmp         .block_4                                 #   continue;
    mov         %rax, 3
    cqo
    idiv        qword ptr [%rbp-24]                      #   3 / c;
    jmp         .block_4                                 #   continue;
.block_5:                                                # }
main..bar.return:
    leave
    ret

.section .rodata
.quad_constant_0:
    .quad       0x4045000000000000  # = 42.0
.quad_constant_1:
    .quad       0x40091eb851eb851f  # = 3.14
