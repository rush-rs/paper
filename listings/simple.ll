; ModuleID = 'main'
source_filename = "main"
target triple = "x86_64-pc-linux-gnu"

define internal i1 @foo(i64 %0) {
entry:
  %i_sum = add i64 %0, 3
  call void @exit(i64 %i_sum)
  unreachable
}

declare void @exit(i64)

define i32 @main() {
entry:
  %ret_foo = call i1 @foo(i64 2)
  ret i32 0
}
