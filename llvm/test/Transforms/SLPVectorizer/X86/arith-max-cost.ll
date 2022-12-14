; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer -mcpu=corei7-avx -mtriple=x86_64-unknown-linux -S | FileCheck %s

; This test checks whether the cost of the vector max intrinsic is calculated
; correctly. A max vector intrinsic combines the select and icmp instructions.
; This maps to a single PMAX instruction in x86.
define void @smax_intrinsic_cost(i64 %arg0, i64 %arg1) {
; CHECK-LABEL: @smax_intrinsic_cost(
; CHECK-NEXT:    [[ICMP0:%.*]] = icmp sgt i64 [[ARG0:%.*]], 123
; CHECK-NEXT:    [[ICMP1:%.*]] = icmp sgt i64 [[ARG1:%.*]], 456
; CHECK-NEXT:    [[SELECT0:%.*]] = select i1 [[ICMP0]], i64 [[ARG0]], i64 123
; CHECK-NEXT:    [[SELECT1:%.*]] = select i1 [[ICMP1]], i64 [[ARG1]], i64 456
; CHECK-NEXT:    [[ROOT:%.*]] = icmp sle i64 [[SELECT0]], [[SELECT1]]
; CHECK-NEXT:    ret void
;
  %icmp0 = icmp sgt i64 %arg0, 123
  %icmp1 = icmp sgt i64 %arg1, 456
  %select0 = select i1 %icmp0, i64 %arg0, i64 123
  %select1 = select i1 %icmp1, i64 %arg1, i64 456
  %root = icmp sle i64 %select0, %select1
  ret void
}


define void @umax_intrinsic_cost(i64 %arg0, i64 %arg1) {
; CHECK-LABEL: @umax_intrinsic_cost(
; CHECK-NEXT:    [[ICMP0:%.*]] = icmp ugt i64 [[ARG0:%.*]], 123
; CHECK-NEXT:    [[ICMP1:%.*]] = icmp ugt i64 [[ARG1:%.*]], 456
; CHECK-NEXT:    [[SELECT0:%.*]] = select i1 [[ICMP0]], i64 [[ARG0]], i64 123
; CHECK-NEXT:    [[SELECT1:%.*]] = select i1 [[ICMP1]], i64 [[ARG1]], i64 456
; CHECK-NEXT:    [[ROOT:%.*]] = icmp sle i64 [[SELECT0]], [[SELECT1]]
; CHECK-NEXT:    ret void
;
  %icmp0 = icmp ugt i64 %arg0, 123
  %icmp1 = icmp ugt i64 %arg1, 456
  %select0 = select i1 %icmp0, i64 %arg0, i64 123
  %select1 = select i1 %icmp1, i64 %arg1, i64 456
  %root = icmp sle i64 %select0, %select1
  ret void
}
