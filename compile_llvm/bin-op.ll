; ModuleID = '/home/coco/mnt/assign2/benchmarks/simple/bin-op-0.c.ll.pre-mem2reg.ll'
source_filename = "/home/coco/mnt/assign2/benchmarks/simple/bin-op-0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@g4 = internal global i32 -2, align 4
@g8 = internal global i32 20, align 4
@g12 = internal global i32 -8, align 4
@.str = private unnamed_addr constant [4 x i8] c"%x\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"%x %x %x %x\0A\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @funct13() #0 {
  %1 = load i32, i32* @g4, align 4
  store i32 4, i32* @g4, align 4
  %2 = sub nsw i32 %1, 4
  %3 = load i32, i32* @g8, align 4
  %4 = shl i32 %3, 20
  store i32 %4, i32* @g8, align 4
  ret i32 %2
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @funct10() #0 {
  %1 = call i32 @funct13()
  store i32 %1, i32* @g12, align 4
  %2 = load i32, i32* @g4, align 4
  %3 = xor i32 %2, 20
  store i32 %3, i32* @g4, align 4
  %4 = load i32, i32* @g8, align 4
  %5 = or i32 1, %4
  %6 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 2)
  ret i32 %5
}

declare i32 @printf(i8* noundef, ...) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @funct9() #0 {
  %1 = call i32 @funct10()
  %2 = call i32 @funct10()
  %3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %2)
  %4 = add i32 %1, 3
  store i32 20, i32* @g8, align 4
  ret i32 %4
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 {
  %1 = load i32, i32* @g4, align 4
  %2 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %1)
  %3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 20)
  %4 = shl i32 1, 20
  %5 = xor i32 3, %4
  %6 = shl i32 1, 0
  %7 = add i32 0, %6
  %8 = or i32 1, %7
  %9 = udiv i32 0, %8
  %10 = udiv i32 %5, 8202
  %11 = sub i32 %10, 122
  %12 = ashr i32 1, %11
  %13 = sub i32 20, %12
  %14 = udiv i32 %5, 1
  %15 = mul i32 %13, %14
  %16 = udiv i32 %7, 200
  %17 = lshr i32 %9, %16
  %18 = mul i32 %17, 1
  %19 = mul i32 %7, %18
  %20 = add i32 %15, 0
  %21 = xor i32 %5, %20
  %22 = udiv i32 1, %15
  %23 = add i32 %21, %22
  %24 = add i32 %17, 1
  %25 = urem i32 1, %24
  %26 = xor i32 %19, %25
  %27 = add i32 1, %26
  %28 = sub i32 %17, %27
  %29 = udiv i32 %23, %23
  %30 = urem i32 %15, %29
  %31 = lshr i32 %23, 1
  %32 = xor i32 %30, %31
  %33 = add i32 %26, 1
  %34 = mul i32 %28, %33
  %35 = urem i32 %34, 1
  %36 = sub i32 %26, %35
  %37 = udiv i32 %32, %34
  %38 = and i32 %23, %37
  %39 = call i32 @funct9()
  store i32 %39, i32* @g8, align 4
  %40 = load i32, i32* @g12, align 4
  store i32 %40, i32* @g12, align 4
  %41 = call i32 @funct10()
  %42 = load i32, i32* @g8, align 4
  %43 = xor i32 %42, %41
  store i32 %43, i32* @g8, align 4
  %44 = load i32, i32* @g8, align 4
  %45 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i32 noundef %38, i32 noundef %36, i32 noundef %34, i32 noundef %44)
  ret i32 0
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.6"}
