; ModuleID = 'main'
source_filename = "main"
target triple = "x86_64-pc-linux-gnu"

define internal i64 @fib(i64 %0) {
entry:
  %i_lt = icmp slt i64 %0, 2
  br i1 %i_lt, label %merge, label %else

merge:                                            ; preds = %entry, %else
  %if_res = phi i64 [ %i_sum3, %else ], [ %0, %entry ]
  ret i64 %if_res

else:                                             ; preds = %entry
  %i_sum = add i64 %0, -2
  %ret_fib = call i64 @fib(i64 %i_sum)
  %i_sum1 = add i64 %0, -1
  %ret_fib2 = call i64 @fib(i64 %i_sum1)
  %i_sum3 = add i64 %ret_fib2, %ret_fib
  br label %merge
}

define i32 @main() {
entry:
  %ret_fib = call i64 @fib(i64 10)
  call void @exit(i64 %ret_fib)
  unreachable
}

declare void @exit(i64)
