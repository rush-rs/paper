ld -dynamic-linker /lib/ld-linux-x86-64.so.2 \
    -lc /usr/lib/crt1.o \
    -lc /usr/lib/crti.o \
    -lc /usr/lib/crtn.o \
    input.o \
    -o output
