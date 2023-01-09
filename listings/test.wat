(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func (param i32 i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32 i32) (result i32)))
  (type (;4;) (func))
  (type (;15;) (func (param i32 i64) (result i32)))
  (func $_ZN10serde_json2de10from_slice17h26f10d690c1c8d8aE (type 6) (param i32 i32 i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 80
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    local.get 3
    local.get 1
    local.get 2
    call $_ZN10serde_json4read9SliceRead3new17h2ed47422df290ec5E
    local.get 3
    i32.const 16
    i32.add
    i32.const 8
    i32.add
    local.get 3
    i32.const 8
    i32.add
    i32.load
    i32.store
    local.get 3
    i32.const 36
    i32.add
    i32.const 0
    i32.store
    local.get 3))
