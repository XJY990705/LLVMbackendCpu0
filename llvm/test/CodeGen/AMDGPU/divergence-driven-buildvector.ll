; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn < %s | FileCheck -check-prefix=GCN %s
; RUN: llc -march=amdgcn -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -march=amdgcn -mcpu=gfx906 < %s | FileCheck -check-prefix=GFX906 %s

define amdgpu_kernel void @uniform_vec_0_i16(i32 addrspace(1)* %out, i16 %a) {
; GCN-LABEL: uniform_vec_0_i16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dword s2, s[0:1], 0xb
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshl_b32 s4, s2, 16
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GCN-NEXT:    s_endpgm
;
; GFX9-LABEL: uniform_vec_0_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_lshl_b32 s0, s4, 16
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX9-NEXT:    s_endpgm
;
; GFX906-LABEL: uniform_vec_0_i16:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX906-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX906-NEXT:    v_mov_b32_e32 v0, 0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_lshl_b32 s0, s4, 16
; GFX906-NEXT:    v_mov_b32_e32 v1, s0
; GFX906-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX906-NEXT:    s_endpgm
  %tmp = insertelement <2 x i16> undef, i16 0, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 %a, i32 1
  %val = bitcast <2 x i16> %vec to i32
  store i32 %val, i32 addrspace(1)* %out, align 4
  ret void
}

define i32 @divergent_vec_0_i16(i16 %a) {
; GCN-LABEL: divergent_vec_0_i16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: divergent_vec_0_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: divergent_vec_0_i16:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; GFX906-NEXT:    s_setpc_b64 s[30:31]
  %tmp = insertelement <2 x i16> undef, i16 0, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 %a, i32 1
  %val = bitcast <2 x i16> %vec to i32
  ret i32 %val
}

define amdgpu_kernel void @uniform_vec_i16_0(i32 addrspace(1)* %out, i16 %a) {
; GCN-LABEL: uniform_vec_i16_0:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dword s2, s[0:1], 0xb
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_and_b32 s4, s2, 0xffff
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GCN-NEXT:    s_endpgm
;
; GFX9-LABEL: uniform_vec_i16_0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_and_b32 s0, 0xffff, s4
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX9-NEXT:    s_endpgm
;
; GFX906-LABEL: uniform_vec_i16_0:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX906-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX906-NEXT:    v_mov_b32_e32 v0, 0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_and_b32 s0, 0xffff, s4
; GFX906-NEXT:    v_mov_b32_e32 v1, s0
; GFX906-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX906-NEXT:    s_endpgm
  %tmp = insertelement <2 x i16> undef, i16 %a, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 0, i32 1
  %val = bitcast <2 x i16> %vec to i32
  store i32 %val, i32 addrspace(1)* %out, align 4
  ret void
}

define i32 @divergent_vec_i16_0(i16 %a) {
; GCN-LABEL: divergent_vec_i16_0:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: divergent_vec_i16_0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: divergent_vec_i16_0:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX906-NEXT:    s_setpc_b64 s[30:31]
  %tmp = insertelement <2 x i16> undef, i16 %a, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 0, i32 1
  %val = bitcast <2 x i16> %vec to i32
  ret i32 %val
}

define amdgpu_kernel void @uniform_vec_f16_0(float addrspace(1)* %out, half %a) {
; GCN-LABEL: uniform_vec_f16_0:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dword s2, s[0:1], 0xb
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_and_b32 s4, s2, 0xffff
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GCN-NEXT:    s_endpgm
;
; GFX9-LABEL: uniform_vec_f16_0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_and_b32 s0, 0xffff, s4
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX9-NEXT:    s_endpgm
;
; GFX906-LABEL: uniform_vec_f16_0:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX906-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX906-NEXT:    v_mov_b32_e32 v0, 0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_and_b32 s0, 0xffff, s4
; GFX906-NEXT:    v_mov_b32_e32 v1, s0
; GFX906-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX906-NEXT:    s_endpgm
  %tmp = insertelement <2 x half> undef, half %a, i32 0
  %vec = insertelement <2 x half> %tmp, half 0.0, i32 1
  %val = bitcast <2 x half> %vec to float
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

define float @divergent_vec_f16_0(half %a) {
; GCN-LABEL: divergent_vec_f16_0:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: divergent_vec_f16_0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: divergent_vec_f16_0:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX906-NEXT:    s_setpc_b64 s[30:31]
  %tmp = insertelement <2 x half> undef, half %a, i32 0
  %vec = insertelement <2 x half> %tmp, half 0.0, i32 1
  %val = bitcast <2 x half> %vec to float
  ret float %val
}

define amdgpu_kernel void @uniform_vec_i16_LL(i32 addrspace(4)* %in0, i32 addrspace(4)* %in1) {
; GCN-LABEL: uniform_vec_i16_LL:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_load_dword s0, s[0:1], 0x0
; GCN-NEXT:    s_load_dword s1, s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_and_b32 s0, s0, 0xffff
; GCN-NEXT:    s_lshl_b32 s1, s1, 16
; GCN-NEXT:    s_or_b32 s0, s0, s1
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s0
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    s_endpgm
;
; GFX9-LABEL: uniform_vec_i16_LL:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX9-NEXT:    s_load_dword s5, s[2:3], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_pack_ll_b32_b16 s0, s4, s5
; GFX9-NEXT:    ;;#ASMSTART
; GFX9-NEXT:    ; use s0
; GFX9-NEXT:    ;;#ASMEND
; GFX9-NEXT:    s_endpgm
;
; GFX906-LABEL: uniform_vec_i16_LL:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX906-NEXT:    s_load_dword s5, s[2:3], 0x0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_pack_ll_b32_b16 s0, s4, s5
; GFX906-NEXT:    ;;#ASMSTART
; GFX906-NEXT:    ; use s0
; GFX906-NEXT:    ;;#ASMEND
; GFX906-NEXT:    s_endpgm
  %val0 = load volatile i32, i32 addrspace(4)* %in0
  %val1 = load volatile i32, i32 addrspace(4)* %in1
  %lo = trunc i32 %val0 to i16
  %hi = trunc i32 %val1 to i16
  %vec.0 = insertelement <2 x i16> undef, i16 %lo, i32 0
  %vec.1 = insertelement <2 x i16> %vec.0, i16 %hi, i32 1
  %vec.i32 = bitcast <2 x i16> %vec.1 to i32
  call void asm sideeffect "; use $0", "s"(i32 %vec.i32) #0
  ret void
}

define i32 @divergent_vec_i16_LL(i16 %a, i16 %b) {
; GCN-LABEL: divergent_vec_i16_LL:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GCN-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GCN-NEXT:    v_or_b32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: divergent_vec_i16_LL:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x5040100
; GFX9-NEXT:    v_perm_b32 v0, v1, v0, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: divergent_vec_i16_LL:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    s_mov_b32 s4, 0x5040100
; GFX906-NEXT:    v_perm_b32 v0, v1, v0, s4
; GFX906-NEXT:    s_setpc_b64 s[30:31]
  %tmp = insertelement <2 x i16> undef, i16 %a, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 %b, i32 1
  %val = bitcast <2 x i16> %vec to i32
  ret i32 %val
}

define amdgpu_kernel void @uniform_vec_i16_LH(i32 addrspace(1)* %out, i16 %a, i32 %b) {
; GCN-LABEL: uniform_vec_i16_LH:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GCN-NEXT:    s_mov_b32 s7, 0xf000
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_and_b32 s3, s3, 0xffff0000
; GCN-NEXT:    s_and_b32 s2, s2, 0xffff
; GCN-NEXT:    s_or_b32 s2, s2, s3
; GCN-NEXT:    s_mov_b32 s6, -1
; GCN-NEXT:    s_mov_b32 s4, s0
; GCN-NEXT:    s_mov_b32 s5, s1
; GCN-NEXT:    v_mov_b32_e32 v0, s2
; GCN-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GCN-NEXT:    s_endpgm
;
; GFX9-LABEL: uniform_vec_i16_LH:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_pack_lh_b32_b16 s2, s2, s3
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX906-LABEL: uniform_vec_i16_LH:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX906-NEXT:    v_mov_b32_e32 v0, 0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_pack_lh_b32_b16 s2, s2, s3
; GFX906-NEXT:    v_mov_b32_e32 v1, s2
; GFX906-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX906-NEXT:    s_endpgm
  %shift = lshr i32 %b, 16
  %tr = trunc i32 %shift to i16
  %tmp = insertelement <2 x i16> undef, i16 %a, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 %tr, i32 1
  %val = bitcast <2 x i16> %vec to i32
  store i32 %val, i32 addrspace(1)* %out, align 4
  ret void
}

define i32 @divergent_vec_i16_LH(i16 %a, i32 %b) {
; GCN-LABEL: divergent_vec_i16_LH:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s4, 0xffff
; GCN-NEXT:    v_bfi_b32 v0, s4, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: divergent_vec_i16_LH:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0xffff
; GFX9-NEXT:    v_bfi_b32 v0, s4, v0, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: divergent_vec_i16_LH:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    s_mov_b32 s4, 0xffff
; GFX906-NEXT:    v_bfi_b32 v0, s4, v0, v1
; GFX906-NEXT:    s_setpc_b64 s[30:31]
  %shift = lshr i32 %b, 16
  %tr = trunc i32 %shift to i16
  %tmp = insertelement <2 x i16> undef, i16 %a, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 %tr, i32 1
  %val = bitcast <2 x i16> %vec to i32
  ret i32 %val
}

define amdgpu_kernel void @uniform_vec_i16_HH(i32 addrspace(1)* %out, i32 %a, i32 %b) {
; GCN-LABEL: uniform_vec_i16_HH:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GCN-NEXT:    s_mov_b32 s7, 0xf000
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshr_b32 s2, s2, 16
; GCN-NEXT:    s_and_b32 s3, s3, 0xffff0000
; GCN-NEXT:    s_or_b32 s2, s2, s3
; GCN-NEXT:    s_mov_b32 s6, -1
; GCN-NEXT:    s_mov_b32 s4, s0
; GCN-NEXT:    s_mov_b32 s5, s1
; GCN-NEXT:    v_mov_b32_e32 v0, s2
; GCN-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GCN-NEXT:    s_endpgm
;
; GFX9-LABEL: uniform_vec_i16_HH:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_pack_hh_b32_b16 s2, s2, s3
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX906-LABEL: uniform_vec_i16_HH:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX906-NEXT:    v_mov_b32_e32 v0, 0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_pack_hh_b32_b16 s2, s2, s3
; GFX906-NEXT:    v_mov_b32_e32 v1, s2
; GFX906-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX906-NEXT:    s_endpgm
  %shift_a = lshr i32 %a, 16
  %tr_a = trunc i32 %shift_a to i16
  %shift_b = lshr i32 %b, 16
  %tr_b = trunc i32 %shift_b to i16
  %tmp = insertelement <2 x i16> undef, i16 %tr_a, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 %tr_b, i32 1
  %val = bitcast <2 x i16> %vec to i32
  store i32 %val, i32 addrspace(1)* %out, align 4
  ret void
}

define i32 @divergent_vec_i16_HH(i32 %a, i32 %b) {
; GCN-LABEL: divergent_vec_i16_HH:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GCN-NEXT:    v_and_b32_e32 v1, 0xffff0000, v1
; GCN-NEXT:    v_or_b32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: divergent_vec_i16_HH:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x7060302
; GFX9-NEXT:    v_perm_b32 v0, v1, v0, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: divergent_vec_i16_HH:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    s_mov_b32 s4, 0x7060302
; GFX906-NEXT:    v_perm_b32 v0, v1, v0, s4
; GFX906-NEXT:    s_setpc_b64 s[30:31]
  %shift_a = lshr i32 %a, 16
  %tr_a = trunc i32 %shift_a to i16
  %shift_b = lshr i32 %b, 16
  %tr_b = trunc i32 %shift_b to i16
  %tmp = insertelement <2 x i16> undef, i16 %tr_a, i32 0
  %vec = insertelement <2 x i16> %tmp, i16 %tr_b, i32 1
  %val = bitcast <2 x i16> %vec to i32
  ret i32 %val
}

define amdgpu_kernel void @uniform_vec_f16_LL(i32 addrspace(4)* %in0, i32 addrspace(4)* %in1) {
; GCN-LABEL: uniform_vec_f16_LL:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_load_dword s0, s[0:1], 0x0
; GCN-NEXT:    s_load_dword s1, s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_and_b32 s0, s0, 0xffff
; GCN-NEXT:    s_lshl_b32 s1, s1, 16
; GCN-NEXT:    s_or_b32 s0, s0, s1
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s0
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    s_endpgm
;
; GFX9-LABEL: uniform_vec_f16_LL:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX9-NEXT:    s_load_dword s5, s[2:3], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_pack_ll_b32_b16 s0, s4, s5
; GFX9-NEXT:    ;;#ASMSTART
; GFX9-NEXT:    ; use s0
; GFX9-NEXT:    ;;#ASMEND
; GFX9-NEXT:    s_endpgm
;
; GFX906-LABEL: uniform_vec_f16_LL:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX906-NEXT:    s_load_dword s5, s[2:3], 0x0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_pack_ll_b32_b16 s0, s4, s5
; GFX906-NEXT:    ;;#ASMSTART
; GFX906-NEXT:    ; use s0
; GFX906-NEXT:    ;;#ASMEND
; GFX906-NEXT:    s_endpgm
  %val0 = load volatile i32, i32 addrspace(4)* %in0
  %val1 = load volatile i32, i32 addrspace(4)* %in1
  %lo.i = trunc i32 %val0 to i16
  %hi.i = trunc i32 %val1 to i16
  %lo = bitcast i16 %lo.i to half
  %hi = bitcast i16 %hi.i to half
  %vec.0 = insertelement <2 x half> undef, half %lo, i32 0
  %vec.1 = insertelement <2 x half> %vec.0, half %hi, i32 1
  %vec.i32 = bitcast <2 x half> %vec.1 to i32

  call void asm sideeffect "; use $0", "s"(i32 %vec.i32) #0
  ret void
}

define float @divergent_vec_f16_LL(half %a, half %b) {
; GCN-LABEL: divergent_vec_f16_LL:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GCN-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GCN-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GCN-NEXT:    v_or_b32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: divergent_vec_f16_LL:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x5040100
; GFX9-NEXT:    v_perm_b32 v0, v1, v0, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: divergent_vec_f16_LL:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    s_mov_b32 s4, 0x5040100
; GFX906-NEXT:    v_perm_b32 v0, v1, v0, s4
; GFX906-NEXT:    s_setpc_b64 s[30:31]
  %tmp = insertelement <2 x half> undef, half %a, i32 0
  %vec = insertelement <2 x half> %tmp, half %b, i32 1
  %val = bitcast <2 x half> %vec to float
  ret float %val
}

define <2 x i16> @build_vec_v2i16_undeflo_divergent(i16 addrspace(3)* %in) #0 {
; GCN-LABEL: build_vec_v2i16_undeflo_divergent:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 m0, -1
; GCN-NEXT:    ds_read_u16 v0, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: build_vec_v2i16_undeflo_divergent:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_read_u16_d16 v0, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: build_vec_v2i16_undeflo_divergent:
; GFX906:       ; %bb.0: ; %entry
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    ds_read_u16 v0, v0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    s_setpc_b64 s[30:31]
entry:
  %load = load i16, i16 addrspace(3)* %in
  %build = insertelement <2 x i16> undef, i16 %load, i32 0
  ret <2 x i16> %build
}

define amdgpu_kernel void @build_vec_v2i16_undeflo_uniform(i16 addrspace(3)* %in, i32 addrspace(1)* %out) #0 {
; GCN-LABEL: build_vec_v2i16_undeflo_uniform:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dword s2, s[0:1], 0x9
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s2
; GCN-NEXT:    s_mov_b32 m0, -1
; GCN-NEXT:    ds_read_u16 v0, v0
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GCN-NEXT:    s_endpgm
;
; GFX9-LABEL: build_vec_v2i16_undeflo_uniform:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dword s4, s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s4
; GFX9-NEXT:    ds_read_u16_d16 v0, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_store_dword v1, v0, s[2:3]
; GFX9-NEXT:    s_endpgm
;
; GFX906-LABEL: build_vec_v2i16_undeflo_uniform:
; GFX906:       ; %bb.0: ; %entry
; GFX906-NEXT:    s_load_dword s4, s[0:1], 0x24
; GFX906-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX906-NEXT:    v_mov_b32_e32 v1, 0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    v_mov_b32_e32 v0, s4
; GFX906-NEXT:    ds_read_u16 v0, v0
; GFX906-NEXT:    s_waitcnt lgkmcnt(0)
; GFX906-NEXT:    global_store_dword v1, v0, s[2:3]
; GFX906-NEXT:    s_endpgm
entry:
  %load = load i16, i16 addrspace(3)* %in
  %build = insertelement <2 x i16> undef, i16 %load, i32 0
  %result = bitcast <2 x i16> %build to i32
  store i32 %result, i32 addrspace(1)* %out
  ret void
}