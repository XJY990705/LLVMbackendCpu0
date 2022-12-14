// REQUIRES: powerpc-registered-target
// RUN: %clang_cc1 -triple powerpc64-unknown-linux-gnu \
// RUN:   -emit-llvm %s -o - -target-cpu pwr7 | FileCheck %s
// RUN: %clang_cc1 -triple powerpc64le-unknown-linux-gnu \
// RUN:   -emit-llvm %s -o - -target-cpu pwr8 | FileCheck %s
// RUN: %clang_cc1 -triple powerpc-unknown-aix \
// RUN:   -emit-llvm %s -o - -target-cpu pwr7 | FileCheck %s --check-prefixes=CHECK-32B
// RUN: %clang_cc1 -triple powerpc64-unknown-aix \
// RUN:   -emit-llvm %s -o - -target-cpu pwr7 | FileCheck %s

extern unsigned short us;
extern unsigned int ui;
extern unsigned short *us_addr;
extern unsigned int *ui_addr;

// CHECK-LABEL: @test_builtin_ppc_store2r(
// CHECK:         [[TMP0:%.*]] = load i16, ptr @us, align 2
// CHECK-NEXT:    [[CONV:%.*]] = zext i16 [[TMP0]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr @us_addr, align 8
// CHECK-NEXT:    call void @llvm.ppc.store2r(i32 [[CONV]], ptr [[TMP1]])
// CHECK-NEXT:    ret void
//
// CHECK-32B-LABEL: @test_builtin_ppc_store2r(
// CHECK-32B:         [[TMP0:%.*]] = load i16, ptr @us, align 2
// CHECK-32B-NEXT:    [[CONV:%.*]] = zext i16 [[TMP0]] to i32
// CHECK-32B-NEXT:    [[TMP1:%.*]] = load ptr, ptr @us_addr, align 4
// CHECK-32B-NEXT:    call void @llvm.ppc.store2r(i32 [[CONV]], ptr [[TMP1]])
// CHECK-32B-NEXT:    ret void
//
void test_builtin_ppc_store2r() {
  __builtin_ppc_store2r(us, us_addr);
}

// CHECK-LABEL: @test_builtin_ppc_store4r(
// CHECK:         [[TMP0:%.*]] = load i32, ptr @ui, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr @ui_addr, align 8
// CHECK-NEXT:    call void @llvm.ppc.store4r(i32 [[TMP0]], ptr [[TMP1]])
// CHECK-NEXT:    ret void
//
// CHECK-32B-LABEL: @test_builtin_ppc_store4r(
// CHECK-32B:         [[TMP0:%.*]] = load i32, ptr @ui, align 4
// CHECK-32B-NEXT:    [[TMP1:%.*]] = load ptr, ptr @ui_addr, align 4
// CHECK-32B-NEXT:    call void @llvm.ppc.store4r(i32 [[TMP0]], ptr [[TMP1]])
// CHECK-32B-NEXT:    ret void
//
void test_builtin_ppc_store4r() {
  __builtin_ppc_store4r(ui, ui_addr);
}

// CHECK-LABEL: @test_builtin_ppc_load2r(
// CHECK:         [[TMP0:%.*]] = load ptr, ptr @us_addr, align 8
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.ppc.load2r(ptr [[TMP0]])
// CHECK-NEXT:    [[CONV:%.*]] = trunc i32 [[TMP2]] to i16
// CHECK-NEXT:    ret i16 [[CONV]]
//
// CHECK-32B-LABEL: @test_builtin_ppc_load2r(
// CHECK-32B:         [[TMP0:%.*]] = load ptr, ptr @us_addr, align 4
// CHECK-32B-NEXT:    [[TMP2:%.*]] = call i32 @llvm.ppc.load2r(ptr [[TMP0]])
// CHECK-32B-NEXT:    [[CONV:%.*]] = trunc i32 [[TMP2]] to i16
// CHECK-32B-NEXT:    ret i16 [[CONV]]
//
unsigned short test_builtin_ppc_load2r() {
  return __builtin_ppc_load2r(us_addr);
}

// CHECK-LABEL: @test_builtin_ppc_load4r(
// CHECK:         [[TMP0:%.*]] = load ptr, ptr @ui_addr, align 8
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.ppc.load4r(ptr [[TMP0]])
// CHECK-NEXT:    ret i32 [[TMP2]]
//
// CHECK-32B-LABEL: @test_builtin_ppc_load4r(
// CHECK-32B:         [[TMP0:%.*]] = load ptr, ptr @ui_addr, align 4
// CHECK-32B-NEXT:    [[TMP2:%.*]] = call i32 @llvm.ppc.load4r(ptr [[TMP0]])
// CHECK-32B-NEXT:    ret i32 [[TMP2]]
//
unsigned int test_builtin_ppc_load4r() {
  return __builtin_ppc_load4r(ui_addr);
}
