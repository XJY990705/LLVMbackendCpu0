; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes="loop-mssa(indvars,simple-loop-unswitch<nontrivial>)" -verify-scev -S %s | FileCheck %s
target datalayout = "n16:32"

@glob = external global i16, align 1

; Test case for PR58136.
define void @test_pr58136(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @test_pr58136(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SRC1:%.*]] = alloca i16, align 2
; CHECK-NEXT:    [[L_3:%.*]] = load i16, ptr [[SRC1]], align 2
; CHECK-NEXT:    [[GLOB_PROMOTED:%.*]] = load i16, ptr @glob, align 2
; CHECK-NEXT:    [[C_1_FR:%.*]] = freeze i1 [[C_1:%.*]]
; CHECK-NEXT:    br i1 [[C_1_FR]], label [[ENTRY_SPLIT_US:%.*]], label [[ENTRY_SPLIT:%.*]]
; CHECK:       entry.split.us:
; CHECK-NEXT:    [[C_2_FR:%.*]] = freeze i1 [[C_2:%.*]]
; CHECK-NEXT:    br i1 [[C_2_FR]], label [[ENTRY_SPLIT_US_SPLIT_US:%.*]], label [[ENTRY_SPLIT_US_SPLIT:%.*]]
; CHECK:       entry.split.us.split.us:
; CHECK-NEXT:    br label [[LOOP_HEADER_US_US:%.*]]
; CHECK:       loop.header.us.us:
; CHECK-NEXT:    [[MUL1_US_US:%.*]] = phi i16 [ [[MUL_US_US:%.*]], [[LOOP_LATCH_US_US:%.*]] ], [ [[GLOB_PROMOTED]], [[ENTRY_SPLIT_US_SPLIT_US]] ]
; CHECK-NEXT:    [[CALL2_US_US:%.*]] = call i16 @foo()
; CHECK-NEXT:    br label [[THEN_BB_US_US:%.*]]
; CHECK:       then.bb.us.us:
; CHECK-NEXT:    br label [[LOOP_LATCH_US_US]]
; CHECK:       loop.latch.us.us:
; CHECK-NEXT:    [[MUL_US_US]] = mul nsw i16 [[MUL1_US_US]], [[L_3]]
; CHECK-NEXT:    store i16 [[MUL_US_US]], ptr @glob, align 2
; CHECK-NEXT:    br label [[LOOP_HEADER_US_US]]
; CHECK:       entry.split.us.split:
; CHECK-NEXT:    br label [[LOOP_HEADER_US:%.*]]
; CHECK:       loop.header.us:
; CHECK-NEXT:    [[CALL2_US:%.*]] = call i16 @foo()
; CHECK-NEXT:    br label [[THEN_BB_US:%.*]]
; CHECK:       then.bb.us:
; CHECK-NEXT:    br label [[EXIT_SPLIT_US:%.*]]
; CHECK:       exit.split.us:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[CALL2:%.*]] = call i16 @foo()
; CHECK-NEXT:    br label [[EXIT_SPLIT:%.*]]
; CHECK:       exit.split:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %src1 = alloca i16, align 2
  %l.3 = load i16, ptr %src1, align 2
  %glob.promoted = load i16, ptr @glob, align 2
  br label %loop.header

loop.header:                                      ; preds = %loop.latch, %entry
  %mul1 = phi i16 [ %mul, %loop.latch ], [ %glob.promoted, %entry ]
  %call2 = call i16 @foo()
  br i1 %c.1, label %then.bb, label %exit

then.bb:                                          ; preds = %loop.header
  br i1 %c.2, label %loop.latch, label %exit

loop.latch:                                       ; preds = %then.bb
  %mul = mul nsw i16 %mul1, %l.3
  store i16 %mul, ptr @glob, align 2
  br label %loop.header

exit:                                             ; preds = %then.bb, %loop.header
  ret void
}

declare i16 @foo() nounwind readnone

define void @test_pr58158(i1 %c.1) {
; CHECK-LABEL: @test_pr58158(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call i16 @bar()
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[ENTRY_SPLIT_US:%.*]], label [[ENTRY_SPLIT:%.*]]
; CHECK:       entry.split.us:
; CHECK-NEXT:    br label [[OUTER_US:%.*]]
; CHECK:       outer.us:
; CHECK-NEXT:    br label [[INNER_PREHEADER_US:%.*]]
; CHECK:       inner.us:
; CHECK-NEXT:    [[C_2_US:%.*]] = icmp eq i16 0, [[CALL]]
; CHECK-NEXT:    br i1 [[C_2_US]], label [[OUTER_LOOPEXIT_US:%.*]], label [[INNER_US:%.*]]
; CHECK:       inner.preheader.us:
; CHECK-NEXT:    br label [[INNER_US]]
; CHECK:       outer.loopexit.us:
; CHECK-NEXT:    br label [[OUTER_BACKEDGE_US:%.*]]
; CHECK:       outer.backedge.us:
; CHECK-NEXT:    br label [[OUTER_US]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[OUTER:%.*]]
; CHECK:       outer:
; CHECK-NEXT:    br label [[OUTER_BACKEDGE:%.*]]
; CHECK:       outer.backedge:
; CHECK-NEXT:    br label [[OUTER]]
;
entry:
  %call = tail call i16 @bar()
  br label %outer

outer:
  br i1 %c.1, label %inner, label %outer

inner:
  %c.2 = icmp eq i16 0, %call
  br i1 %c.2, label %outer, label %inner
}

declare i16 @bar()
