; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=x86_64-linux -codegenprepare -S < %s | FileCheck %s

declare { i64, i1 } @llvm.uadd.with.overflow.i64(i64, i64)

define i32 @test_01(ptr %p, i64 %len, i32 %x) {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[MATH:%.*]], [[BACKEDGE:%.*]] ], [ [[LEN:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 [[IV]], i64 1)
; CHECK-NEXT:    [[MATH]] = extractvalue { i64, i1 } [[TMP0]], 0
; CHECK-NEXT:    [[OV:%.*]] = extractvalue { i64, i1 } [[TMP0]], 1
; CHECK-NEXT:    br i1 [[OV]], label [[EXIT:%.*]], label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[SUNKADDR3:%.*]] = mul i64 [[MATH]], 4
; CHECK-NEXT:    [[SUNKADDR4:%.*]] = getelementptr i8, ptr [[P:%.*]], i64 [[SUNKADDR3]]
; CHECK-NEXT:    [[LOADED:%.*]] = load atomic i32, ptr [[SUNKADDR4]] unordered, align 4
; CHECK-NEXT:    [[COND_2:%.*]] = icmp eq i32 [[LOADED]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[COND_2]], label [[FAILURE:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 -1
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %math, %backedge ], [ %len, %entry ]
  %0 = call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %iv, i64 1)
  %math = extractvalue { i64, i1 } %0, 0
  %ov = extractvalue { i64, i1 } %0, 1
  br i1 %ov, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %sunkaddr = mul i64 %iv, 4
  %sunkaddr1 = getelementptr i8, ptr %p, i64 %sunkaddr
  %sunkaddr2 = getelementptr i8, ptr %sunkaddr1, i64 4
  %loaded = load atomic i32, ptr %sunkaddr2 unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}