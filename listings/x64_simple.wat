(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func))
  (import "wasi_snapshot_preview1" "proc_exit" (func $__wasi_exit (type 0)))
  (func $main (type 1)
    (local $b i32)
    ;; a += 1;
    global.get $a          ;; push the current value of `a`
    i64.const 1            ;; push `1`
    i64.add                ;; add those two
    global.set $a          ;; pop and set `a` to the result
    ;; let b = true;
    i32.const 1            ;; push `true`
    local.set $b           ;; pop and set `b`
    ;; exit(a + b as int);
    global.get $a          ;; push `a`
    local.get $b           ;; push `b`
    i64.extend_i32_u       ;; cast bool to int
    i64.add                ;; add those two
    i32.wrap_i64           ;; convert i64 to i32 (for `__wasi_exit`)
    call $__wasi_exit      ;; call `__wasi_exit`
    unreachable)
  (memory (;0;) 0)
  (global $a (mut i64) (i64.const 2))
  (export "_start" (func $main))
  (export "memory" (memory 0))
  (start $main))
