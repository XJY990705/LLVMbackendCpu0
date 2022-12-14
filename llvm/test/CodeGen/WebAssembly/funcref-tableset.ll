; RUN: llc --mtriple=wasm32-unknown-unknown -asm-verbose=false -mattr=+reference-types < %s | FileCheck %s

%funcref = type ptr addrspace(20) ;; addrspace 20 is nonintegral

@funcref_table = local_unnamed_addr addrspace(1) global [0 x %funcref] undef

declare void @llvm.wasm.table.set.funcref(ptr addrspace(1), i32, %funcref) nounwind

define void @set_funcref_table(%funcref %g, i32 %i) {
; CHECK-LABEL: set_funcref_table:
; CHECK-NEXT: .functype       set_funcref_table (funcref, i32) -> ()
; CHECK-NEXT: local.get      1
; CHECK-NEXT: local.get      0
; CHECK-NEXT: table.set     funcref_table
; CHECK-NEXT: end_function

;; this generates a table.set of @funcref_table
  call void @llvm.wasm.table.set.funcref(ptr addrspace(1) @funcref_table, i32 %i, %funcref %g)
  ret void
}

define void @set_funcref_table_const(%funcref %g) {
; CHECK-LABEL: set_funcref_table_const:
; CHECK-NEXT:  .functype      set_funcref_table_const (funcref) -> ()
; CHECK-NEXT:  i32.const      0
; CHECK-NEXT:  local.get      0
; CHECK-NEXT:  table.set      funcref_table
; CHECK-NEXT:  end_function
  call void @llvm.wasm.table.set.funcref(ptr addrspace(1) @funcref_table, i32 0, %funcref %g)
  ret void
}

define void @set_funcref_table_with_offset(%funcref %g, i32 %i) {
; CHECK-LABEL: set_funcref_table_with_offset:
; CHECK-NEXT:  .functype       set_funcref_table_with_offset (funcref, i32) -> ()
; CHECK-NEXT:  local.get       1
; CHECK-NEXT:  i32.const       2
; CHECK-NEXT:  i32.add
; CHECK-NEXT:  local.get       0
; CHECK-NEXT:  table.set       funcref_table
; CHECK-NEXT:  end_function
  %off = add nsw i32 %i, 2
  call void @llvm.wasm.table.set.funcref(ptr addrspace(1) @funcref_table, i32 %off, %funcref %g)
  ret void
}

define void @set_funcref_table_with_var_offset(%funcref %g, i32 %i, i32 %j) {
; CHECK-LABEL: set_funcref_table_with_var_offset:
; CHECK-NEXT:  .functype       set_funcref_table_with_var_offset (funcref, i32, i32) -> ()
; CHECK-NEXT:  local.get       1
; CHECK-NEXT:  local.get       2
; CHECK-NEXT:  i32.add
; CHECK-NEXT:  local.get       0
; CHECK-NEXT:  table.set       funcref_table
; CHECK-NEXT:  end_function
  %off = add nsw i32 %i, %j
  call void @llvm.wasm.table.set.funcref(ptr addrspace(1) @funcref_table, i32 %off, %funcref %g)
  ret void
}

declare i32 @set_offset()

define void @set_funcref_table_with_var_offset2(%funcref %g, i32 %i) {
; CHECK-LABEL: set_funcref_table_with_var_offset2:
; CHECK-NEXT:  .functype       set_funcref_table_with_var_offset2 (funcref, i32) -> ()
; CHECK-NEXT:  local.get       1
; CHECK-NEXT:  call    set_offset
; CHECK-NEXT:  i32.add
; CHECK-NEXT:  local.get       0
; CHECK-NEXT:  table.set       funcref_table
; CHECK-NEXT:  end_function
  %j = call i32 @set_offset()
  %off = add nsw i32 %i, %j
  call void @llvm.wasm.table.set.funcref(ptr addrspace(1) @funcref_table, i32 %off, %funcref %g)
  ret void
}

;       CHECK: .tabletype funcref_table, funcref
; CHECK-LABEL: funcref_table:
