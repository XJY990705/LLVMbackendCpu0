; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

define <2 x i1> @test1(<2 x i1> %a) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %b = and <2 x i1> %a, <i1 true, i1 false>
  %res = mul <2 x i1> %b, <i1 false, i1 true>
  ret <2 x i1> %res
}

define i32 @mul_by_1(i32 %A) {
; CHECK-LABEL: @mul_by_1(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = mul i32 %A, 1
  ret i32 %B
}

define i32 @mul_by_0(i32 %A) {
; CHECK-LABEL: @mul_by_0(
; CHECK-NEXT:    ret i32 0
;
  %B = mul i32 %A, 0
  ret i32 %B
}

define <16 x i8> @mul_by_0_vec(<16 x i8> %a) {
; CHECK-LABEL: @mul_by_0_vec(
; CHECK-NEXT:    ret <16 x i8> zeroinitializer
;
  %b = mul <16 x i8> %a, zeroinitializer
  ret <16 x i8> %b
}

define <2 x i8> @mul_by_0_vec_undef_elt(<2 x i8> %a) {
; CHECK-LABEL: @mul_by_0_vec_undef_elt(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %b = mul <2 x i8> %a, <i8 undef, i8 0>
  ret <2 x i8> %b
}

define i32 @poison(i32 %x) {
; CHECK-LABEL: @poison(
; CHECK-NEXT:    ret i32 poison
;
  %v = mul i32 %x, poison
  ret i32 %v
}