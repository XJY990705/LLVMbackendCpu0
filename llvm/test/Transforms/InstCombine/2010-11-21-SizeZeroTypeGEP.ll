; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128"

define ptr @foo(ptr %x, i32 %n) {
; CHECK-LABEL: @foo(
; CHECK-NOT: getelementptr
  %p = getelementptr {}, ptr %x, i32 %n
  ret ptr %p
}

define ptr @bar(i64 %n, ptr %p) {
; CHECK-LABEL: @bar(
  %g = getelementptr {{}, [0 x {[0 x i8]}]}, ptr %p, i64 %n, i32 1, i64 %n, i32 0, i64 %n
; CHECK: %p, i64 0, i32 1, i64 0, i32 0, i64 %n
  ret ptr %g
}
