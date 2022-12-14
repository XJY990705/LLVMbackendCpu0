; RUN: opt -licm -mtriple=amdgcn -S -o - %s | FileCheck %s

; CHECK-LABEL: foo
; CHECK: ret
define void @foo(ptr %d, ptr %s, i32 %idx) {
entry:
  br label %for.body

for.body:
  %v0 = load <1 x i32>, ptr %s
  %v1 = bitcast <1 x i32> %v0 to <4 x i8>
  br label %for.cond

for.cond:
  %e0 = extractelement <4 x i8> %v1, i32 %idx
  store i8 %e0, ptr %d
  br i1 false, label %for.exit, label %for.body

for.exit:
  ret void
}
