; ModuleID = 'main'
source_filename = "main"
target triple = "x86_64-pc-linux-gnu"

define internal i64 @fib(i64 %0) {
entry:
  br label %body

body:                                             ; preds = %entry
  %i_lt = icmp slt i64 %0, 2
  br i1 %i_lt, label %then, label %else

then:                                             ; preds = %body
  br label %merge

merge:                                            ; preds = %else, %then
  %if_res = phi i64 [ %0, %then ], [ %i_sum3, %else ]
  ret i64 %if_res

else:                                             ; preds = %body
  %i_sum = sub i64 %0, 2
  %ret_fib = call i64 @fib(i64 %i_sum)
  %i_sum1 = sub i64 %0, 1
  %ret_fib2 = call i64 @fib(i64 %i_sum1)
  %i_sum3 = add i64 %ret_fib, %ret_fib2
  br label %merge
}

define i32 @main() {
entry:
  br label %body

body:                                             ; preds = %entry
  %ret_fib = call i64 @fib(i64 10)
  call void @exit(i64 %ret_fib)
  unreachable
}

declare void @exit(i64)
