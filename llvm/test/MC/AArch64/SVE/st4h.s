// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:   | llvm-objdump -d --mattr=-sve - | FileCheck %s --check-prefix=CHECK-UNKNOWN

st4h    { z0.h, z1.h, z2.h, z3.h }, p0, [x0, x0, lsl #1]
// CHECK-INST: st4h    { z0.h - z3.h }, p0, [x0, x0, lsl #1]
// CHECK-ENCODING: [0x00,0x60,0xe0,0xe4]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: e4e06000 <unknown>

st4h    { z5.h, z6.h, z7.h, z8.h }, p3, [x17, x16, lsl #1]
// CHECK-INST: st4h    { z5.h - z8.h }, p3, [x17, x16, lsl #1]
// CHECK-ENCODING: [0x25,0x6e,0xf0,0xe4]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: e4f06e25 <unknown>

st4h    { z0.h, z1.h, z2.h, z3.h }, p0, [x0]
// CHECK-INST: st4h    { z0.h - z3.h }, p0, [x0]
// CHECK-ENCODING: [0x00,0xe0,0xf0,0xe4]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: e4f0e000 <unknown>

st4h    { z23.h, z24.h, z25.h, z26.h }, p3, [x13, #-32, mul vl]
// CHECK-INST: st4h    { z23.h - z26.h }, p3, [x13, #-32, mul vl]
// CHECK-ENCODING: [0xb7,0xed,0xf8,0xe4]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: e4f8edb7 <unknown>

st4h    { z21.h, z22.h, z23.h, z24.h }, p5, [x10, #20, mul vl]
// CHECK-INST: st4h    { z21.h - z24.h }, p5, [x10, #20, mul vl]
// CHECK-ENCODING: [0x55,0xf5,0xf5,0xe4]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: e4f5f555 <unknown>

st4h    { z29.h, z30.h, z31.h, z0.h }, p5, [x10, #20, mul vl]
// CHECK-INST: st4h    { z29.h, z30.h, z31.h, z0.h }, p5, [x10, #20, mul vl]
// CHECK-ENCODING: [0x5d,0xf5,0xf5,0xe4]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: e4f5f55d <unknown>
