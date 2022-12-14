; RUN: llc -verify-machineinstrs -mcpu=pwr7 < %s | FileCheck %s
target datalayout = "E-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-f128:128:128-v128:128:128-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

declare <4 x i32> @llvm.ppc.altivec.lvx(ptr) #1

define <4 x i32> @test1(ptr %h) #0 {
entry:
  %h1 = getelementptr <4 x i32>, ptr %h, i64 1
  %vl = call <4 x i32> @llvm.ppc.altivec.lvx(ptr %h1)

  %v0 = load <4 x i32>, ptr %h, align 8

  %a = add <4 x i32> %v0, %vl
  ret <4 x i32> %a

; CHECK-LABEL: @test1
; CHECK: li [[REG:[0-9]+]], 16
; CHECK-NOT: li {{[0-9]+}}, 15
; CHECK-DAG: lvx {{[0-9]+}}, 0, 3
; CHECK-DAG: lvx {{[0-9]+}}, 3, [[REG]]
; CHECK: blr
}

declare void @llvm.ppc.altivec.stvx(<4 x i32>, ptr) #0

define <4 x i32> @test2(ptr %h, <4 x i32> %d) #0 {
entry:
  %h1 = getelementptr <4 x i32>, ptr %h, i64 1
  call void @llvm.ppc.altivec.stvx(<4 x i32> %d, ptr %h1)

  %v0 = load <4 x i32>, ptr %h, align 8

  ret <4 x i32> %v0

; CHECK-LABEL: @test2
; CHECK: li [[REG:[0-9]+]], 16
; CHECK-NOT: li {{[0-9]+}}, 15
; CHECK-DAG: lvx {{[0-9]+}}, 0, 3
; CHECK-DAG: lvx {{[0-9]+}}, 3, [[REG]]
; CHECK: blr
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }

