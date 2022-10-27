; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; RUN: opt < %s -passes='require<profile-summary>,function(loop-mssa(simple-loop-unswitch<nontrivial>))' -S | FileCheck %s

declare i32 @a()
declare i32 @b()

; Check loops will be applied non-trivial loop unswitch in a non-cold function,
; even loop headers are cold

define void @f1(i32 %i, i1 %cond, i1 %hot_cond, i1 %cold_cond, i1* %ptr) !prof !14 {
; CHECK-LABEL: @f1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[ENTRY_COLD_LOOP:%.*]]
; CHECK:       entry_cold_loop:
; CHECK-NEXT:    br i1 [[COLD_COND:%.*]], label [[COLD_LOOP_BEGIN_PREHEADER:%.*]], label [[COLD_LOOP_EXIT:%.*]], !prof [[PROF15:![0-9]+]]
; CHECK:       cold_loop_begin.preheader:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[COLD_LOOP_BEGIN_PREHEADER_SPLIT_US:%.*]], label [[COLD_LOOP_BEGIN_PREHEADER_SPLIT:%.*]]
; CHECK:       cold_loop_begin.preheader.split.us:
; CHECK-NEXT:    br label [[COLD_LOOP_BEGIN_US:%.*]]
; CHECK:       cold_loop_begin.us:
; CHECK-NEXT:    br label [[COLD_LOOP_A_US:%.*]]
; CHECK:       cold_loop_a.us:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @a()
; CHECK-NEXT:    br label [[COLD_LOOP_LATCH_US:%.*]]
; CHECK:       cold_loop_latch.us:
; CHECK-NEXT:    [[V2_US:%.*]] = load i1, i1* [[PTR:%.*]], align 1
; CHECK-NEXT:    br i1 [[V2_US]], label [[COLD_LOOP_BEGIN_US]], label [[COLD_LOOP_EXIT_LOOPEXIT_SPLIT_US:%.*]]
; CHECK:       cold_loop_exit.loopexit.split.us:
; CHECK-NEXT:    br label [[COLD_LOOP_EXIT_LOOPEXIT:%.*]]
; CHECK:       cold_loop_begin.preheader.split:
; CHECK-NEXT:    br label [[COLD_LOOP_BEGIN:%.*]]
; CHECK:       cold_loop_begin:
; CHECK-NEXT:    br label [[COLD_LOOP_B:%.*]]
; CHECK:       cold_loop_b:
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @b()
; CHECK-NEXT:    br label [[COLD_LOOP_LATCH:%.*]]
; CHECK:       cold_loop_latch:
; CHECK-NEXT:    [[V2:%.*]] = load i1, i1* [[PTR]], align 1
; CHECK-NEXT:    br i1 [[V2]], label [[COLD_LOOP_BEGIN]], label [[COLD_LOOP_EXIT_LOOPEXIT_SPLIT:%.*]]
; CHECK:       cold_loop_exit.loopexit.split:
; CHECK-NEXT:    br label [[COLD_LOOP_EXIT_LOOPEXIT]]
; CHECK:       cold_loop_exit.loopexit:
; CHECK-NEXT:    br label [[COLD_LOOP_EXIT]]
; CHECK:       cold_loop_exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %entry_cold_loop

entry_cold_loop:
  br i1 %cold_cond, label %cold_loop_begin, label %cold_loop_exit, !prof !15

cold_loop_begin:
  br i1 %cond, label %cold_loop_a, label %cold_loop_b

cold_loop_a:
  %0 = call i32 @a()
  br label %cold_loop_latch

cold_loop_b:
  %1 = call i32 @b()
  br label %cold_loop_latch

cold_loop_latch:
  %v2 = load i1, i1* %ptr
  br i1 %v2, label %cold_loop_begin, label %cold_loop_exit

cold_loop_exit:
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 1, !"ProfileSummary", !1}
!1 = !{!2, !3, !4, !5, !6, !7, !8, !9}
!2 = !{!"ProfileFormat", !"InstrProf"}
!3 = !{!"TotalCount", i64 10000}
!4 = !{!"MaxCount", i64 10}
!5 = !{!"MaxInternalCount", i64 1}
!6 = !{!"MaxFunctionCount", i64 1000}
!7 = !{!"NumCounts", i64 3}
!8 = !{!"NumFunctions", i64 3}
!9 = !{!"DetailedSummary", !10}
!10 = !{!11, !12, !13}
!11 = !{i32 10000, i64 100, i32 1}
!12 = !{i32 999000, i64 100, i32 1}
!13 = !{i32 999999, i64 1, i32 2}
!14 = !{!"function_entry_count", i64 400}
!15 = !{!"branch_weights", i32 0, i32 100}