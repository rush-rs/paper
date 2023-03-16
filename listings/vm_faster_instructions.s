0: (prelude)
        setmp 0
        call 1
1: (main)
        setmp 0
        push 1000
        call 2
        exit
2: (rec)
        setmp 1
        svari *rel[0]
        push *rel[0]
        gvar
        push 0
        eq
        jmpfalse 9
        push 0
        jmp 14
        push *rel[0]
        gvar
        push 1
        sub
        call 2
        setmp -1
        ret
