; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Test cases designed for the nosync function attribute.
; FIXME's are used to indicate problems and missing attributes.

; struct RT {
;   char A;
;   int B[10][20];
;   char C;
; };
; struct ST {
;   int X;
;   double Y;
;   struct RT Z;
; };
;
; int *foo(struct ST *s) {
;   return &s[1].Z.B[5][13];
; }

; TEST 1
; non-convergent and readnone implies nosync
%struct.RT = type { i8, [10 x [20 x i32]], i8 }
%struct.ST = type { i32, double, %struct.RT }

;.
; CHECK: @[[A:[a-zA-Z0-9_$"\\.-]+]] = common global i32 0, align 4
;.
define i32* @foo(%struct.ST* %s) nounwind uwtable readnone optsize ssp {
; CHECK: Function Attrs: nofree norecurse nosync nounwind optsize readnone ssp willreturn uwtable
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (%struct.ST* nofree readnone "no-capture-maybe-returned" [[S:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [[STRUCT_ST:%.*]], %struct.ST* [[S]], i64 1, i32 2, i32 1, i64 5, i64 13
; CHECK-NEXT:    ret i32* [[ARRAYIDX]]
;
entry:
  %arrayidx = getelementptr inbounds %struct.ST, %struct.ST* %s, i64 1, i32 2, i32 1, i64 5, i64 13
  ret i32* %arrayidx
}

; TEST 2
; atomic load with monotonic ordering
; int load_monotonic(_Atomic int *num) {
;   int n = atomic_load_explicit(num, memory_order_relaxed);
;   return n;
; }

define i32 @load_monotonic(i32* nocapture readonly %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn uwtable
; CHECK-LABEL: define {{[^@]+}}@load_monotonic
; CHECK-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[TMP0:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    [[TMP2:%.*]] = load atomic i32, i32* [[TMP0]] monotonic, align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %2 = load atomic i32, i32* %0 monotonic, align 4
  ret i32 %2
}


; TEST 3
; atomic store with monotonic ordering.
; void store_monotonic(_Atomic int *num) {
;   atomic_load_explicit(num, memory_order_relaxed);
; }

define void @store_monotonic(i32* nocapture %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn uwtable
; CHECK-LABEL: define {{[^@]+}}@store_monotonic
; CHECK-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP0:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    store atomic i32 10, i32* [[TMP0]] monotonic, align 4
; CHECK-NEXT:    ret void
;
  store atomic i32 10, i32* %0 monotonic, align 4
  ret void
}

; TEST 4 - negative, should not deduce nosync
; atomic load with acquire ordering.
; int load_acquire(_Atomic int *num) {
;   int n = atomic_load_explicit(num, memory_order_acquire);
;   return n;
; }

define i32 @load_acquire(i32* nocapture readonly %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: argmemonly nofree norecurse nounwind willreturn uwtable
; CHECK-LABEL: define {{[^@]+}}@load_acquire
; CHECK-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[TMP0:%.*]]) #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:    [[TMP2:%.*]] = load atomic i32, i32* [[TMP0]] acquire, align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %2 = load atomic i32, i32* %0 acquire, align 4
  ret i32 %2
}

; TEST 5 - negative, should not deduce nosync
; atomic load with release ordering
; void load_release(_Atomic int *num) {
;   atomic_store_explicit(num, 10, memory_order_release);
; }

define void @load_release(i32* nocapture %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: argmemonly nofree norecurse nounwind willreturn uwtable
; CHECK-LABEL: define {{[^@]+}}@load_release
; CHECK-SAME: (i32* nocapture nofree noundef writeonly align 4 [[TMP0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    store atomic volatile i32 10, i32* [[TMP0]] release, align 4
; CHECK-NEXT:    ret void
;
  store atomic volatile i32 10, i32* %0 release, align 4
  ret void
}

; TEST 6 - negative volatile, relaxed atomic

define void @load_volatile_release(i32* nocapture %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: argmemonly nofree norecurse nounwind willreturn uwtable
; CHECK-LABEL: define {{[^@]+}}@load_volatile_release
; CHECK-SAME: (i32* nocapture nofree noundef writeonly align 4 [[TMP0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    store atomic volatile i32 10, i32* [[TMP0]] release, align 4
; CHECK-NEXT:    ret void
;
  store atomic volatile i32 10, i32* %0 release, align 4
  ret void
}

; TEST 7 - negative, should not deduce nosync
; volatile store.
; void volatile_store(volatile int *num) {
;   *num = 14;
; }

define void @volatile_store(i32* %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: argmemonly nofree norecurse nounwind willreturn uwtable
; CHECK-LABEL: define {{[^@]+}}@volatile_store
; CHECK-SAME: (i32* nofree noundef align 4 [[TMP0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    store volatile i32 14, i32* [[TMP0]], align 4
; CHECK-NEXT:    ret void
;
  store volatile i32 14, i32* %0, align 4
  ret void
}

; TEST 8 - negative, should not deduce nosync
; volatile load.
; int volatile_load(volatile int *num) {
;   int n = *num;
;   return n;
; }

define i32 @volatile_load(i32* %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: argmemonly nofree norecurse nounwind willreturn uwtable
; CHECK-LABEL: define {{[^@]+}}@volatile_load
; CHECK-SAME: (i32* nofree noundef align 4 [[TMP0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[TMP2:%.*]] = load volatile i32, i32* [[TMP0]], align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %2 = load volatile i32, i32* %0, align 4
  ret i32 %2
}

; TEST 9

; CHECK: Function Attrs: noinline nosync nounwind uwtable
; CHECK-NEXT: declare void @nosync_function()
declare void @nosync_function() noinline nounwind uwtable nosync

define void @call_nosync_function() nounwind uwtable noinline {
; CHECK: Function Attrs: noinline nosync nounwind uwtable
; CHECK-LABEL: define {{[^@]+}}@call_nosync_function
; CHECK-SAME: () #[[ATTR3:[0-9]+]] {
; CHECK-NEXT:    tail call void @nosync_function() #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    ret void
;
  tail call void @nosync_function() noinline nounwind uwtable
  ret void
}

; TEST 10 - negative, should not deduce nosync

; CHECK: Function Attrs: noinline nounwind uwtable
; CHECK-NEXT: declare void @might_sync()
declare void @might_sync() noinline nounwind uwtable

define void @call_might_sync() nounwind uwtable noinline {
; CHECK: Function Attrs: noinline nounwind uwtable
; CHECK-LABEL: define {{[^@]+}}@call_might_sync
; CHECK-SAME: () #[[ATTR4]] {
; CHECK-NEXT:    tail call void @might_sync() #[[ATTR4]]
; CHECK-NEXT:    ret void
;
  tail call void @might_sync() noinline nounwind uwtable
  ret void
}

; TEST 11 - positive, should deduce nosync
; volatile operation in same scc but dead. Call volatile_load defined in TEST 8.

define i32 @scc1(i32* %0) noinline nounwind uwtable {
; TUNIT: Function Attrs: argmemonly nofree noinline nounwind uwtable
; TUNIT-LABEL: define {{[^@]+}}@scc1
; TUNIT-SAME: (i32* nofree [[TMP0:%.*]]) #[[ATTR5:[0-9]+]] {
; TUNIT-NEXT:    tail call void @scc2(i32* nofree [[TMP0]]) #[[ATTR19:[0-9]+]]
; TUNIT-NEXT:    [[VAL:%.*]] = tail call i32 @volatile_load(i32* nofree align 4 [[TMP0]]) #[[ATTR19]]
; TUNIT-NEXT:    ret i32 [[VAL]]
;
; CGSCC: Function Attrs: argmemonly nofree noinline nounwind uwtable
; CGSCC-LABEL: define {{[^@]+}}@scc1
; CGSCC-SAME: (i32* nofree [[TMP0:%.*]]) #[[ATTR5:[0-9]+]] {
; CGSCC-NEXT:    tail call void @scc2(i32* nofree [[TMP0]]) #[[ATTR19:[0-9]+]]
; CGSCC-NEXT:    [[VAL:%.*]] = tail call i32 @volatile_load(i32* nofree noundef align 4 [[TMP0]]) #[[ATTR14:[0-9]+]]
; CGSCC-NEXT:    ret i32 [[VAL]]
;
  tail call void @scc2(i32* %0);
  %val = tail call i32 @volatile_load(i32* %0);
  ret i32 %val;
}

define void @scc2(i32* %0) noinline nounwind uwtable {
; CHECK: Function Attrs: argmemonly nofree noinline nounwind uwtable
; CHECK-LABEL: define {{[^@]+}}@scc2
; CHECK-SAME: (i32* nofree [[TMP0:%.*]]) #[[ATTR5:[0-9]+]] {
; CHECK-NEXT:    [[TMP2:%.*]] = tail call i32 @scc1(i32* nofree [[TMP0]]) #[[ATTR19:[0-9]+]]
; CHECK-NEXT:    ret void
;
  tail call i32 @scc1(i32* %0);
  ret void;
}

; TEST 12 - fences, negative
;
; void foo1(int *a, std::atomic<bool> flag){
;   *a = 100;
;   atomic_thread_fence(std::memory_order_release);
;   flag.store(true, std::memory_order_relaxed);
; }
;
; void bar(int *a, std::atomic<bool> flag){
;   while(!flag.load(std::memory_order_relaxed))
;     ;
;
;   atomic_thread_fence(std::memory_order_acquire);
;   int b = *a;
; }

%"struct.std::atomic" = type { %"struct.std::__atomic_base" }
%"struct.std::__atomic_base" = type { i8 }

define void @foo1(i32* %0, %"struct.std::atomic"* %1) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn
; CHECK-LABEL: define {{[^@]+}}@foo1
; CHECK-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP0:%.*]], %"struct.std::atomic"* nocapture nofree nonnull writeonly dereferenceable(1) [[TMP1:%.*]]) #[[ATTR6:[0-9]+]] {
; CHECK-NEXT:    store i32 100, i32* [[TMP0]], align 4
; CHECK-NEXT:    fence release
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* [[TMP1]], i64 0, i32 0, i32 0
; CHECK-NEXT:    store atomic i8 1, i8* [[TMP3]] monotonic, align 1
; CHECK-NEXT:    ret void
;
  store i32 100, i32* %0, align 4
  fence release
  %3 = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* %1, i64 0, i32 0, i32 0
  store atomic i8 1, i8* %3 monotonic, align 1
  ret void
}

define void @bar(i32* %0, %"struct.std::atomic"* %1) {
; CHECK: Function Attrs: nofree norecurse nounwind
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: (i32* nocapture nofree readnone [[TMP0:%.*]], %"struct.std::atomic"* nocapture nofree nonnull readonly dereferenceable(1) [[TMP1:%.*]]) #[[ATTR7:[0-9]+]] {
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* [[TMP1]], i64 0, i32 0, i32 0
; CHECK-NEXT:    br label [[TMP4:%.*]]
; CHECK:       4:
; CHECK-NEXT:    [[TMP5:%.*]] = load atomic i8, i8* [[TMP3]] monotonic, align 1
; CHECK-NEXT:    [[TMP6:%.*]] = and i8 [[TMP5]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i8 [[TMP6]], 0
; CHECK-NEXT:    br i1 [[TMP7]], label [[TMP4]], label [[TMP8:%.*]]
; CHECK:       8:
; CHECK-NEXT:    fence acquire
; CHECK-NEXT:    ret void
;
  %3 = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* %1, i64 0, i32 0, i32 0
  br label %4

4:                                                ; preds = %4, %2
  %5 = load atomic i8, i8* %3  monotonic, align 1
  %6 = and i8 %5, 1
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %4, label %8

8:                                                ; preds = %4
  fence acquire
  ret void
}

; TEST 13 - Fence syncscope("singlethread") seq_cst
define void @foo1_singlethread(i32* %0, %"struct.std::atomic"* %1) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind willreturn
; CHECK-LABEL: define {{[^@]+}}@foo1_singlethread
; CHECK-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP0:%.*]], %"struct.std::atomic"* nocapture nofree nonnull writeonly dereferenceable(1) [[TMP1:%.*]]) #[[ATTR8:[0-9]+]] {
; CHECK-NEXT:    store i32 100, i32* [[TMP0]], align 4
; CHECK-NEXT:    fence syncscope("singlethread") release
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* [[TMP1]], i64 0, i32 0, i32 0
; CHECK-NEXT:    store atomic i8 1, i8* [[TMP3]] monotonic, align 1
; CHECK-NEXT:    ret void
;
  store i32 100, i32* %0, align 4
  fence syncscope("singlethread") release
  %3 = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* %1, i64 0, i32 0, i32 0
  store atomic i8 1, i8* %3 monotonic, align 1
  ret void
}

define void @bar_singlethread(i32* %0, %"struct.std::atomic"* %1) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind
; CHECK-LABEL: define {{[^@]+}}@bar_singlethread
; CHECK-SAME: (i32* nocapture nofree readnone [[TMP0:%.*]], %"struct.std::atomic"* nocapture nofree nonnull readonly dereferenceable(1) [[TMP1:%.*]]) #[[ATTR9:[0-9]+]] {
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* [[TMP1]], i64 0, i32 0, i32 0
; CHECK-NEXT:    br label [[TMP4:%.*]]
; CHECK:       4:
; CHECK-NEXT:    [[TMP5:%.*]] = load atomic i8, i8* [[TMP3]] monotonic, align 1
; CHECK-NEXT:    [[TMP6:%.*]] = and i8 [[TMP5]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i8 [[TMP6]], 0
; CHECK-NEXT:    br i1 [[TMP7]], label [[TMP4]], label [[TMP8:%.*]]
; CHECK:       8:
; CHECK-NEXT:    fence syncscope("singlethread") acquire
; CHECK-NEXT:    ret void
;
  %3 = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* %1, i64 0, i32 0, i32 0
  br label %4

4:                                                ; preds = %4, %2
  %5 = load atomic i8, i8* %3  monotonic, align 1
  %6 = and i8 %5, 1
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %4, label %8

8:                                                ; preds = %4
  fence syncscope("singlethread") acquire
  ret void
}

declare void @llvm.memcpy(i8* %dest, i8* %src, i32 %len, i1 %isvolatile)
declare void @llvm.memset(i8* %dest, i8 %val, i32 %len, i1 %isvolatile)

; TEST 14 - negative, checking volatile intrinsics.

; It is odd to add nocapture but a result of the llvm.memcpy nocapture.
;
define i32 @memcpy_volatile(i8* %ptr1, i8* %ptr2) {
; CHECK: Function Attrs: argmemonly nofree norecurse nounwind willreturn
; CHECK-LABEL: define {{[^@]+}}@memcpy_volatile
; CHECK-SAME: (i8* nocapture nofree writeonly [[PTR1:%.*]], i8* nocapture nofree readonly [[PTR2:%.*]]) #[[ATTR10:[0-9]+]] {
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture nofree writeonly [[PTR1]], i8* noalias nocapture nofree readonly [[PTR2]], i32 noundef 8, i1 noundef true) #[[ATTR20:[0-9]+]]
; CHECK-NEXT:    ret i32 4
;
  call void @llvm.memcpy(i8* %ptr1, i8* %ptr2, i32 8, i1 1)
  ret i32 4
}

; TEST 15 - positive, non-volatile intrinsic.

; It is odd to add nocapture but a result of the llvm.memset nocapture.
;
define i32 @memset_non_volatile(i8* %ptr1, i8 %val) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; CHECK-LABEL: define {{[^@]+}}@memset_non_volatile
; CHECK-SAME: (i8* nocapture nofree writeonly [[PTR1:%.*]], i8 [[VAL:%.*]]) #[[ATTR11:[0-9]+]] {
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* nocapture nofree writeonly [[PTR1]], i8 [[VAL]], i32 noundef 8, i1 noundef false) #[[ATTR21:[0-9]+]]
; CHECK-NEXT:    ret i32 4
;
  call void @llvm.memset(i8* %ptr1, i8 %val, i32 8, i1 0)
  ret i32 4
}

; TEST 16 - negative, inline assembly.

define i32 @inline_asm_test(i32 %x) {
; CHECK-LABEL: define {{[^@]+}}@inline_asm_test
; CHECK-SAME: (i32 [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 asm "bswap $0", "=r,r"(i32 [[X]])
; CHECK-NEXT:    ret i32 4
;
  call i32 asm "bswap $0", "=r,r"(i32 %x)
  ret i32 4
}

declare void @readnone_test() convergent readnone

; TEST 17 - negative. Convergent
define void @convergent_readnone(){
; CHECK: Function Attrs: readnone
; CHECK-LABEL: define {{[^@]+}}@convergent_readnone
; CHECK-SAME: () #[[ATTR13:[0-9]+]] {
; CHECK-NEXT:    call void @readnone_test()
; CHECK-NEXT:    ret void
;
  call void @readnone_test()
  ret void
}

; CHECK: Function Attrs: nounwind
; CHECK-NEXT: declare void @llvm.x86.sse2.clflush(i8*)
declare void @llvm.x86.sse2.clflush(i8*)
@a = common global i32 0, align 4

; TEST 18 - negative. Synchronizing intrinsic

define void @i_totally_sync() {
; CHECK: Function Attrs: nounwind
; CHECK-LABEL: define {{[^@]+}}@i_totally_sync
; CHECK-SAME: () #[[ATTR14:[0-9]+]] {
; CHECK-NEXT:    tail call void @llvm.x86.sse2.clflush(i8* noundef nonnull align 4 dereferenceable(4) bitcast (i32* @a to i8*))
; CHECK-NEXT:    ret void
;
  tail call void @llvm.x86.sse2.clflush(i8* bitcast (i32* @a to i8*))
  ret void
}

declare float @llvm.cos(float %val) readnone

; TEST 19 - positive, readnone & non-convergent intrinsic.

define i32 @cos_test(float %x) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@cos_test
; CHECK-SAME: (float [[X:%.*]]) #[[ATTR15:[0-9]+]] {
; CHECK-NEXT:    ret i32 4
;
  call float @llvm.cos(float %x)
  ret i32 4
}

define float @cos_test2(float %x) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@cos_test2
; CHECK-SAME: (float [[X:%.*]]) #[[ATTR15]] {
; CHECK-NEXT:    [[C:%.*]] = call float @llvm.cos.f32(float [[X]]) #[[ATTR22:[0-9]+]]
; CHECK-NEXT:    ret float [[C]]
;
  %c = call float @llvm.cos(float %x)
  ret float %c
}
;.
; CHECK: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind optsize readnone ssp willreturn uwtable }
; CHECK: attributes #[[ATTR1]] = { argmemonly nofree norecurse nosync nounwind willreturn uwtable }
; CHECK: attributes #[[ATTR2]] = { argmemonly nofree norecurse nounwind willreturn uwtable }
; CHECK: attributes #[[ATTR3]] = { noinline nosync nounwind uwtable }
; CHECK: attributes #[[ATTR4]] = { noinline nounwind uwtable }
; CHECK: attributes #[[ATTR5]] = { argmemonly nofree noinline nounwind uwtable }
; CHECK: attributes #[[ATTR6]] = { nofree norecurse nounwind willreturn }
; CHECK: attributes #[[ATTR7]] = { nofree norecurse nounwind }
; CHECK: attributes #[[ATTR8]] = { nofree norecurse nosync nounwind willreturn }
; CHECK: attributes #[[ATTR9]] = { nofree norecurse nosync nounwind }
; CHECK: attributes #[[ATTR10]] = { argmemonly nofree norecurse nounwind willreturn }
; CHECK: attributes #[[ATTR11]] = { argmemonly nofree norecurse nosync nounwind willreturn writeonly }
; CHECK: attributes #[[ATTR12:[0-9]+]] = { convergent readnone }
; CHECK: attributes #[[ATTR13]] = { readnone }
; CHECK: attributes #[[ATTR14]] = { nounwind }
; CHECK: attributes #[[ATTR15]] = { nofree norecurse nosync nounwind readnone willreturn }
; CHECK: attributes #[[ATTR16:[0-9]+]] = { argmemonly nocallback nofree nounwind willreturn }
; CHECK: attributes #[[ATTR17:[0-9]+]] = { argmemonly nocallback nofree nounwind willreturn writeonly }
; CHECK: attributes #[[ATTR18:[0-9]+]] = { nocallback nofree nosync nounwind readnone speculatable willreturn }
; CHECK: attributes #[[ATTR19]] = { nofree nounwind }
; CHECK: attributes #[[ATTR20]] = { willreturn }
; CHECK: attributes #[[ATTR21]] = { willreturn writeonly }
; CHECK: attributes #[[ATTR22]] = { readnone willreturn }
;.