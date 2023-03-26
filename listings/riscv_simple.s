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
    li a0, 1
    ld a1, m          # m
    add a2, a1, a0
    sd a2, m, t6
    ld a0, m          # m
    call main..foo
    j epilogue_0      # return
    # end body
epilogue_0:
    ld fp, 8(sp)
    ld ra, 0(sp)
    addi sp, sp, 16
    ret

main..foo:
    # begin prologue
    addi sp, sp, -32
    sd fp, 24(sp)
    sd ra, 16(sp)
    addi fp, sp, 32
    # end prologue
    # save params on stack
    sd a0, -24(fp)    # param n = a0
    # begin body
    ld a0, -24(fp)    # n
    call exit
    # end body
epilogue_1:
    ld fp, 24(sp)
    ld ra, 16(sp)
    addi sp, sp, 32
    ret

.section .data
m:
    .dword 0x000000000000002a  # = 42
