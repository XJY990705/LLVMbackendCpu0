; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.11.0 -passes=slp-vectorizer -S -mattr=+sse2 | FileCheck %s --check-prefix=SSE
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.11.0 -passes=slp-vectorizer -S -mattr=+avx  | FileCheck %s --check-prefix=AVX
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.11.0 -passes=slp-vectorizer -S -mattr=+avx2 | FileCheck %s --check-prefix=AVX

; Verify that the SLP vectorizer is able to figure out that commutativity
; offers the possibility to splat/broadcast %c and thus make it profitable
; to vectorize this case

@cle = external unnamed_addr global [32 x i8], align 16
@cle32 = external unnamed_addr global [32 x i32], align 16


; Check that we correctly detect a splat/broadcast by leveraging the
; commutativity property of `xor`.

define void @splat(i8 %a, i8 %b, i8 %c) {
; SSE-LABEL: @splat(
; SSE-NEXT:    [[TMP1:%.*]] = insertelement <16 x i8> poison, i8 [[A:%.*]], i32 0
; SSE-NEXT:    [[TMP2:%.*]] = insertelement <16 x i8> [[TMP1]], i8 [[B:%.*]], i32 1
; SSE-NEXT:    [[SHUFFLE:%.*]] = shufflevector <16 x i8> [[TMP2]], <16 x i8> poison, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
; SSE-NEXT:    [[TMP3:%.*]] = insertelement <16 x i8> poison, i8 [[C:%.*]], i32 0
; SSE-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <16 x i8> [[TMP3]], <16 x i8> poison, <16 x i32> zeroinitializer
; SSE-NEXT:    [[TMP4:%.*]] = xor <16 x i8> [[SHUFFLE]], [[SHUFFLE1]]
; SSE-NEXT:    store <16 x i8> [[TMP4]], <16 x i8>* bitcast ([32 x i8]* @cle to <16 x i8>*), align 16
; SSE-NEXT:    ret void
;
; AVX-LABEL: @splat(
; AVX-NEXT:    [[TMP1:%.*]] = insertelement <16 x i8> poison, i8 [[A:%.*]], i32 0
; AVX-NEXT:    [[TMP2:%.*]] = insertelement <16 x i8> [[TMP1]], i8 [[B:%.*]], i32 1
; AVX-NEXT:    [[SHUFFLE:%.*]] = shufflevector <16 x i8> [[TMP2]], <16 x i8> poison, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
; AVX-NEXT:    [[TMP3:%.*]] = insertelement <16 x i8> poison, i8 [[C:%.*]], i32 0
; AVX-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <16 x i8> [[TMP3]], <16 x i8> poison, <16 x i32> zeroinitializer
; AVX-NEXT:    [[TMP4:%.*]] = xor <16 x i8> [[SHUFFLE]], [[SHUFFLE1]]
; AVX-NEXT:    store <16 x i8> [[TMP4]], <16 x i8>* bitcast ([32 x i8]* @cle to <16 x i8>*), align 16
; AVX-NEXT:    ret void
;
  %1 = xor i8 %c, %a
  store i8 %1, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 0), align 16
  %2 = xor i8 %a, %c
  store i8 %2, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 1)
  %3 = xor i8 %a, %c
  store i8 %3, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 2)
  %4 = xor i8 %a, %c
  store i8 %4, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 3)
  %5 = xor i8 %c, %a
  store i8 %5, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 4)
  %6 = xor i8 %c, %b
  store i8 %6, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 5)
  %7 = xor i8 %c, %a
  store i8 %7, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 6)
  %8 = xor i8 %c, %b
  store i8 %8, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 7)
  %9 = xor i8 %a, %c
  store i8 %9, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 8)
  %10 = xor i8 %a, %c
  store i8 %10, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 9)
  %11 = xor i8 %a, %c
  store i8 %11, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 10)
  %12 = xor i8 %a, %c
  store i8 %12, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 11)
  %13 = xor i8 %a, %c
  store i8 %13, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 12)
  %14 = xor i8 %a, %c
  store i8 %14, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 13)
  %15 = xor i8 %a, %c
  store i8 %15, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 14)
  %16 = xor i8 %a, %c
  store i8 %16, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @cle, i64 0, i64 15)
  ret void
}

; Check that we correctly detect that we can have the same opcode on one side by
; leveraging the commutativity property of `xor`.

define void @same_opcode_on_one_side(i32 %a, i32 %b, i32 %c) {
; SSE-LABEL: @same_opcode_on_one_side(
; SSE-NEXT:    [[ADD1:%.*]] = add i32 [[C:%.*]], [[A:%.*]]
; SSE-NEXT:    [[ADD2:%.*]] = add i32 [[C]], [[A]]
; SSE-NEXT:    [[ADD3:%.*]] = add i32 [[A]], [[C]]
; SSE-NEXT:    [[ADD4:%.*]] = add i32 [[C]], [[A]]
; SSE-NEXT:    [[TMP1:%.*]] = xor i32 [[ADD1]], [[A]]
; SSE-NEXT:    store i32 [[TMP1]], i32* getelementptr inbounds ([32 x i32], [32 x i32]* @cle32, i64 0, i64 0), align 16
; SSE-NEXT:    [[TMP2:%.*]] = xor i32 [[B:%.*]], [[ADD2]]
; SSE-NEXT:    store i32 [[TMP2]], i32* getelementptr inbounds ([32 x i32], [32 x i32]* @cle32, i64 0, i64 1), align 4
; SSE-NEXT:    [[TMP3:%.*]] = xor i32 [[C]], [[ADD3]]
; SSE-NEXT:    store i32 [[TMP3]], i32* getelementptr inbounds ([32 x i32], [32 x i32]* @cle32, i64 0, i64 2), align 4
; SSE-NEXT:    [[TMP4:%.*]] = xor i32 [[A]], [[ADD4]]
; SSE-NEXT:    store i32 [[TMP4]], i32* getelementptr inbounds ([32 x i32], [32 x i32]* @cle32, i64 0, i64 3), align 4
; SSE-NEXT:    ret void
;
; AVX-LABEL: @same_opcode_on_one_side(
; AVX-NEXT:    [[TMP1:%.*]] = insertelement <4 x i32> poison, i32 [[C:%.*]], i32 0
; AVX-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> poison, <4 x i32> zeroinitializer
; AVX-NEXT:    [[TMP2:%.*]] = insertelement <4 x i32> poison, i32 [[A:%.*]], i32 0
; AVX-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <4 x i32> [[TMP2]], <4 x i32> poison, <4 x i32> zeroinitializer
; AVX-NEXT:    [[TMP3:%.*]] = add <4 x i32> [[SHUFFLE]], [[SHUFFLE1]]
; AVX-NEXT:    [[TMP4:%.*]] = insertelement <4 x i32> [[TMP2]], i32 [[B:%.*]], i32 1
; AVX-NEXT:    [[TMP5:%.*]] = insertelement <4 x i32> [[TMP4]], i32 [[C]], i32 2
; AVX-NEXT:    [[TMP6:%.*]] = insertelement <4 x i32> [[TMP5]], i32 [[A]], i32 3
; AVX-NEXT:    [[TMP7:%.*]] = xor <4 x i32> [[TMP3]], [[TMP6]]
; AVX-NEXT:    store <4 x i32> [[TMP7]], <4 x i32>* bitcast ([32 x i32]* @cle32 to <4 x i32>*), align 16
; AVX-NEXT:    ret void
;
  %add1 = add i32 %c, %a
  %add2 = add i32 %c, %a
  %add3 = add i32 %a, %c
  %add4 = add i32 %c, %a
  %1 = xor i32 %add1, %a
  store i32 %1, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @cle32, i64 0, i64 0), align 16
  %2 = xor i32 %b, %add2
  store i32 %2, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @cle32, i64 0, i64 1)
  %3 = xor i32 %c, %add3
  store i32 %3, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @cle32, i64 0, i64 2)
  %4 = xor i32 %a, %add4
  store i32 %4, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @cle32, i64 0, i64 3)
  ret void
}