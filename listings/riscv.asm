.global _start

.section .text

_start:
    call main..main
    li a0, 0
    call exit

main..main:
    # begin prologue
    addi sp, sp, -16
    sd fp, 8(sp)
    sd ra, 0(sp)
    addi fp, sp, 16
    # end prologue
    # begin body
    li a0, 10
    call main..fib
    call exit
    # end body

epilogue:
    ld fp, 8(sp)
    ld ra, 0(sp)
    addi sp, sp, 16
    ret

main..fib:
    # begin prologue
    addi sp, sp, -32
    sd fp, 24(sp)
    sd ra, 16(sp)
    addi fp, sp, 32
    # end prologue
    # save params on stack
    sd a0, -24(fp)                   # param n = a0
    # begin body
    ld a0, -24(fp)
    li a1, 2
    slt a2, a0, a1
    bne a2, zero, then
    j else

then:
    ld a0, -24(fp)

    j merge

merge:

    # end body
    j epilogue_1

else:
    ld a0, -24(fp)
    li a1, 1
    sub a2, a0, a1
    mv a0, a2                        # a2 not expected a0
    call main..fib
    sd a0, -32(fp)                   # 8 byte spill: a0
    ld a0, -24(fp)
    li a1, 2
    sub a2, a0, a1
    mv a0, a2                        # a2 not expected a0
    call main..fib
    mv a1, a0
    ld a0, -32(fp)                   # 8 byte reload: a0
    add a2, a0, a1
    mv a0, a2
    j merge

epilogue_1:
    ld fp, 24(sp)
    ld ra, 16(sp)
    addi sp, sp, 32
    ret
