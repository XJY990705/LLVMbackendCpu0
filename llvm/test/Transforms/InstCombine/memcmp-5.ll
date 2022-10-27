; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
;
; Exercise folding of memcmp calls with constant arrays and nonconstant
; sizes.

declare i32 @memcmp(i8*, i8*, i64)

@ax = external constant [8 x i8]
@a01230123 = constant [8 x i8] c"01230123"
@b01230123 = constant [8 x i8] c"01230123"
@c01230129 = constant [8 x i8] c"01230129"
@d9123012  = constant [7 x i8] c"9123012"


; Exercise memcmp(A, B, N) folding of arrays with the same bytes.

define void @fold_memcmp_a_b_n(i32* %pcmp, i64 %n) {
; CHECK-LABEL: @fold_memcmp_a_b_n(
; CHECK-NEXT:    store i32 0, i32* [[PCMP:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i64 [[N:%.*]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = sext i1 [[TMP1]] to i32
; CHECK-NEXT:    [[S0_1:%.*]] = getelementptr i32, i32* [[PCMP]], i64 1
; CHECK-NEXT:    store i32 [[TMP2]], i32* [[S0_1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = sext i1 [[TMP3]] to i32
; CHECK-NEXT:    [[S0_2:%.*]] = getelementptr i32, i32* [[PCMP]], i64 2
; CHECK-NEXT:    store i32 [[TMP4]], i32* [[S0_2]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[S0_3:%.*]] = getelementptr i32, i32* [[PCMP]], i64 3
; CHECK-NEXT:    store i32 [[TMP6]], i32* [[S0_3]], align 4
; CHECK-NEXT:    [[S0_4:%.*]] = getelementptr i32, i32* [[PCMP]], i64 4
; CHECK-NEXT:    store i32 0, i32* [[S0_4]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[TMP8:%.*]] = sext i1 [[TMP7]] to i32
; CHECK-NEXT:    [[S0_5:%.*]] = getelementptr i32, i32* [[PCMP]], i64 5
; CHECK-NEXT:    store i32 [[TMP8]], i32* [[S0_5]], align 4
; CHECK-NEXT:    ret void
;

  %p0 = getelementptr [8 x i8], [8 x i8]* @a01230123, i64 0, i64 0

  %q0 = getelementptr [8 x i8], [8 x i8]* @b01230123, i64 0, i64 0
  %q1 = getelementptr [8 x i8], [8 x i8]* @b01230123, i64 0, i64 1
  %q2 = getelementptr [8 x i8], [8 x i8]* @b01230123, i64 0, i64 2
  %q3 = getelementptr [8 x i8], [8 x i8]* @b01230123, i64 0, i64 3
  %q4 = getelementptr [8 x i8], [8 x i8]* @b01230123, i64 0, i64 4
  %q5 = getelementptr [8 x i8], [8 x i8]* @b01230123, i64 0, i64 5

  ; Fold memcmp(a, b, n) to 0.
  %c0_0 = call i32 @memcmp(i8* %p0, i8* %q0, i64 %n)
  %s0_0 = getelementptr i32, i32* %pcmp, i64 0
  store i32 %c0_0, i32* %s0_0

  ; Fold memcmp(a, b + 1, n) to N != 0 ? -1 : 0.
  %c0_1 = call i32 @memcmp(i8* %p0, i8* %q1, i64 %n)
  %s0_1 = getelementptr i32, i32* %pcmp, i64 1
  store i32 %c0_1, i32* %s0_1

  ; Fold memcmp(a, b + 2, n) to N != 0 ? -1 : 0.
  %c0_2 = call i32 @memcmp(i8* %p0, i8* %q2, i64 %n)
  %s0_2 = getelementptr i32, i32* %pcmp, i64 2
  store i32 %c0_2, i32* %s0_2

  ; Fold memcmp(a, b + 3, n) to N != 0 ? -1 : 0.
  %c0_3 = call i32 @memcmp(i8* %p0, i8* %q3, i64 %n)
  %s0_3 = getelementptr i32, i32* %pcmp, i64 3
  store i32 %c0_3, i32* %s0_3

  ; Fold memcmp(a, b + 4, n) to 0.
  %c0_4 = call i32 @memcmp(i8* %p0, i8* %q4, i64 %n)
  %s0_4 = getelementptr i32, i32* %pcmp, i64 4
  store i32 %c0_4, i32* %s0_4

  ; Fold memcmp(a, b + 5, n) to N != 0 ? -1 : 0.
  %c0_5 = call i32 @memcmp(i8* %p0, i8* %q5, i64 %n)
  %s0_5 = getelementptr i32, i32* %pcmp, i64 5
  store i32 %c0_5, i32* %s0_5

  ret void
}

; Vefify that a memcmp() call involving a constant array with unknown
; contents is not folded.

define void @call_memcmp_a_ax_n(i32* %pcmp, i64 %n) {
; CHECK-LABEL: @call_memcmp_a_ax_n(
; CHECK-NEXT:    [[C0_0:%.*]] = call i32 @memcmp(i8* nonnull getelementptr inbounds ([8 x i8], [8 x i8]* @a01230123, i64 0, i64 0), i8* nonnull getelementptr inbounds ([8 x i8], [8 x i8]* @ax, i64 0, i64 0), i64 [[N:%.*]])
; CHECK-NEXT:    store i32 [[C0_0]], i32* [[PCMP:%.*]], align 4
; CHECK-NEXT:    ret void
;

  %p0 = getelementptr [8 x i8], [8 x i8]* @a01230123, i64 0, i64 0
  %q0 = getelementptr [8 x i8], [8 x i8]* @ax, i64 0, i64 0

  ; Do not fold memcmp(a, ax, n).
  %c0_0 = call i32 @memcmp(i8* %p0, i8* %q0, i64 %n)
  %s0_0 = getelementptr i32, i32* %pcmp, i64 0
  store i32 %c0_0, i32* %s0_0

  ret void
}


; Exercise memcmp(A, C, N) folding of arrays with the same leading bytes
; but a difference in the trailing byte.

define void @fold_memcmp_a_c_n(i32* %pcmp, i64 %n) {
; CHECK-LABEL: @fold_memcmp_a_c_n(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i64 [[N:%.*]], 7
; CHECK-NEXT:    [[TMP2:%.*]] = sext i1 [[TMP1]] to i32
; CHECK-NEXT:    store i32 [[TMP2]], i32* [[PCMP:%.*]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = sext i1 [[TMP3]] to i32
; CHECK-NEXT:    [[S0_1:%.*]] = getelementptr i32, i32* [[PCMP]], i64 1
; CHECK-NEXT:    store i32 [[TMP4]], i32* [[S0_1]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[S0_2:%.*]] = getelementptr i32, i32* [[PCMP]], i64 2
; CHECK-NEXT:    store i32 [[TMP6]], i32* [[S0_2]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[TMP8:%.*]] = sext i1 [[TMP7]] to i32
; CHECK-NEXT:    [[S0_3:%.*]] = getelementptr i32, i32* [[PCMP]], i64 3
; CHECK-NEXT:    store i32 [[TMP8]], i32* [[S0_3]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = icmp ugt i64 [[N]], 3
; CHECK-NEXT:    [[TMP10:%.*]] = sext i1 [[TMP9]] to i32
; CHECK-NEXT:    [[S0_4:%.*]] = getelementptr i32, i32* [[PCMP]], i64 4
; CHECK-NEXT:    store i32 [[TMP10]], i32* [[S0_4]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ugt i64 [[N]], 3
; CHECK-NEXT:    [[TMP12:%.*]] = sext i1 [[TMP11]] to i32
; CHECK-NEXT:    [[S0_5:%.*]] = getelementptr i32, i32* [[PCMP]], i64 5
; CHECK-NEXT:    store i32 [[TMP12]], i32* [[S0_5]], align 4
; CHECK-NEXT:    ret void
;

  %p0 = getelementptr [8 x i8], [8 x i8]* @a01230123, i64 0, i64 0

  %q0 = getelementptr [8 x i8], [8 x i8]* @c01230129, i64 0, i64 0
  %q1 = getelementptr [8 x i8], [8 x i8]* @c01230129, i64 0, i64 1
  %q2 = getelementptr [8 x i8], [8 x i8]* @c01230129, i64 0, i64 2
  %q3 = getelementptr [8 x i8], [8 x i8]* @c01230129, i64 0, i64 3
  %q4 = getelementptr [8 x i8], [8 x i8]* @c01230129, i64 0, i64 4
  %q5 = getelementptr [8 x i8], [8 x i8]* @c01230129, i64 0, i64 5

  ; Fold memcmp(a, c, n) to N > 7 ? -1 : 0.
  %c0_0 = call i32 @memcmp(i8* %p0, i8* %q0, i64 %n)
  %s0_0 = getelementptr i32, i32* %pcmp, i64 0
  store i32 %c0_0, i32* %s0_0

  ; Fold memcmp(a, c + 1, n) to N != 0 ? -1 : 0.
  %c0_1 = call i32 @memcmp(i8* %p0, i8* %q1, i64 %n)
  %s0_1 = getelementptr i32, i32* %pcmp, i64 1
  store i32 %c0_1, i32* %s0_1

  ; Fold memcmp(a, c + 2, n) to N != 0 ? -1 : 0.
  %c0_2 = call i32 @memcmp(i8* %p0, i8* %q2, i64 %n)
  %s0_2 = getelementptr i32, i32* %pcmp, i64 2
  store i32 %c0_2, i32* %s0_2

  ; Fold memcmp(a, c + 3, n) to N != 0 ? -1 : 0.
  %c0_3 = call i32 @memcmp(i8* %p0, i8* %q3, i64 %n)
  %s0_3 = getelementptr i32, i32* %pcmp, i64 3
  store i32 %c0_3, i32* %s0_3

  ; Fold memcmp(a, c + 4, n) to N > 3 ? -1 : 0.
  %c0_4 = call i32 @memcmp(i8* %p0, i8* %q4, i64 %n)
  %s0_4 = getelementptr i32, i32* %pcmp, i64 4
  store i32 %c0_4, i32* %s0_4

  ; Fold memcmp(a, c + 5, n) to N != 0 ? -1 : 0.
  %c0_5 = call i32 @memcmp(i8* %p0, i8* %q4, i64 %n)
  %s0_5 = getelementptr i32, i32* %pcmp, i64 5
  store i32 %c0_5, i32* %s0_5

  ret void
}


; Exercise memcmp(A, D, N) folding of arrays of different sizes and
; a difference in the leading byte.

define void @fold_memcmp_a_d_n(i32* %pcmp, i64 %n) {
; CHECK-LABEL: @fold_memcmp_a_d_n(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i64 [[N:%.*]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = sext i1 [[TMP1]] to i32
; CHECK-NEXT:    store i32 [[TMP2]], i32* [[PCMP:%.*]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = sext i1 [[TMP3]] to i32
; CHECK-NEXT:    [[S0_1:%.*]] = getelementptr i32, i32* [[PCMP]], i64 1
; CHECK-NEXT:    store i32 [[TMP4]], i32* [[S0_1]], align 4
; CHECK-NEXT:    [[S1_1:%.*]] = getelementptr i32, i32* [[PCMP]], i64 2
; CHECK-NEXT:    store i32 0, i32* [[S1_1]], align 4
; CHECK-NEXT:    [[S6_6:%.*]] = getelementptr i32, i32* [[PCMP]], i64 3
; CHECK-NEXT:    store i32 0, i32* [[S6_6]], align 4
; CHECK-NEXT:    ret void
;

  %p0 = getelementptr [8 x i8], [8 x i8]* @a01230123, i64 0, i64 0
  %p1 = getelementptr [8 x i8], [8 x i8]* @a01230123, i64 0, i64 1
  %p6 = getelementptr [8 x i8], [8 x i8]* @a01230123, i64 0, i64 6

  %q0 = getelementptr [7 x i8], [7 x i8]* @d9123012, i64 0, i64 0
  %q1 = getelementptr [7 x i8], [7 x i8]* @d9123012, i64 0, i64 1
  %q6 = getelementptr [7 x i8], [7 x i8]* @d9123012, i64 0, i64 6

  ; Fold memcmp(a, d, n) to N != 0 ? -1 : 0.
  %c0_0 = call i32 @memcmp(i8* %p0, i8* %q0, i64 %n)
  %s0_0 = getelementptr i32, i32* %pcmp, i64 0
  store i32 %c0_0, i32* %s0_0

  ; Fold memcmp(a, d + 1, n) to N != 0 -1 : 0.
  %c0_1 = call i32 @memcmp(i8* %p0, i8* %q1, i64 %n)
  %s0_1 = getelementptr i32, i32* %pcmp, i64 1
  store i32 %c0_1, i32* %s0_1

  ; Fold memcmp(a + 1, d + 1, n) to 0.
  %c1_1 = call i32 @memcmp(i8* %p1, i8* %q1, i64 %n)
  %s1_1 = getelementptr i32, i32* %pcmp, i64 2
  store i32 %c1_1, i32* %s1_1

  ; Fold memcmp(a + 6, d + 6, n) to 0.
  %c6_6 = call i32 @memcmp(i8* %p6, i8* %q6, i64 %n)
  %s6_6 = getelementptr i32, i32* %pcmp, i64 3
  store i32 %c6_6, i32* %s6_6

  ret void
}


; Exercise memcmp(A, D, N) folding of arrays with the same bytes and
; a nonzero size.

define void @fold_memcmp_a_d_nz(i32* %pcmp, i64 %n) {
; CHECK-LABEL: @fold_memcmp_a_d_nz(
; CHECK-NEXT:    store i32 -1, i32* [[PCMP:%.*]], align 4
; CHECK-NEXT:    ret void
;

  %p0 = getelementptr [8 x i8], [8 x i8]* @a01230123, i64 0, i64 0
  %q0 = getelementptr [7 x i8], [7 x i8]* @d9123012, i64 0, i64 0
  %nz = or i64 %n, 1

  %c0_0 = call i32 @memcmp(i8* %p0, i8* %q0, i64 %nz)
  %s0_0 = getelementptr i32, i32* %pcmp, i64 0
  store i32 %c0_0, i32* %s0_0

  ret void
}