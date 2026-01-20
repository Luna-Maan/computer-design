; ModuleID = '/home/coco/mnt/assign2/benchmarks/simple/loop-0.c.ll.pre-mem2reg.ll'
source_filename = "/home/coco/mnt/assign2/benchmarks/simple/loop-0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%x\0A\00", align 1
@g7 = internal global i32 2, align 4
@g9 = internal global i32 6, align 4
@g1 = internal global i32 1, align 4
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @funct5() #0 {
  %1 = load i32, i32* @g7, align 4
  %2 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %1)
  %3 = or i32 10, 8
  store i32 10, i32* @g9, align 4
  ret i32 %3
}

declare i32 @printf(i8* noundef, ...) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @funct3() #0 {
  %1 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 5)
  %2 = call i32 @funct5()
  %3 = add i32 20, %2
  ret i32 %3
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @funct2() #0 {
  %1 = call i32 @funct3()
  %2 = shl i32 %1, 0
  ret i32 %2
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 {
  %1 = load i32, i32* @g1, align 4
  %2 = add i32 20, %1
  %3 = load i32, i32* @g1, align 4
  %4 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %3)
  %5 = call i32 @funct2()
  %6 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 6)
  %7 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 5)
  %8 = call i32 @funct5()
  %9 = mul i32 %8, 1
  %10 = load i32, i32* @g1, align 4
  %11 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %10)
  %12 = call i32 @funct3()
  %13 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 4)
  br label %14

14:                                               ; preds = %34, %0
  %.0 = phi i32 [ 0, %0 ], [ %35, %34 ]
  %15 = icmp ult i32 %.0, %2
  br i1 %15, label %16, label %36

16:                                               ; preds = %14
  %17 = load i32, i32* @g1, align 4
  %18 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 5)
  %19 = load i32, i32* @g7, align 4
  %20 = add i32 %17, %19
  %21 = load i32, i32* @g7, align 4
  %22 = load i32, i32* @g7, align 4
  %23 = udiv i32 %22, %21
  store i32 %23, i32* @g7, align 4
  %24 = mul i32 %9, %.0
  %25 = mul i32 %20, %20
  %26 = add i32 %24, %25
  %27 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %26)
  %28 = call i32 @funct2()
  %29 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %28)
  %30 = mul i32 %17, %12
  %31 = add i32 %30, %20
  %32 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %31)
  %33 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef -2)
  br label %34

34:                                               ; preds = %16
  %35 = add i32 %.0, 1
  br label %14, !llvm.loop !6

36:                                               ; preds = %14
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
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
