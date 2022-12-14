; Test that lib call simplification doesn't simplify __strncpy_chk calls
; with the wrong prototype.
;
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@a = common global [60 x i16] zeroinitializer, align 1
@b = common global [60 x i8] zeroinitializer, align 1

define void @test_no_simplify() {
; CHECK-LABEL: @test_no_simplify(

; CHECK-NEXT: call i16 @__strncpy_chk
  call i16 @__strncpy_chk(ptr @a, ptr @b, i32 60, i32 60)
  ret void
}

declare i16 @__strncpy_chk(ptr, ptr, i32, i32)
