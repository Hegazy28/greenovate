import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_styles.dart';

class CircularArc extends StatefulWidget {
  final double progress;
  final String unit;
  final Duration animationDuration;
  final Color? progressColor;
  final Color? backgroundColor;
  final double? strokeWidth;
  final int decimalPlaces;

  const CircularArc({
    super.key,
    required this.progress,
    required this.unit,
    this.animationDuration = const Duration(seconds: 2),
    this.progressColor,
    this.backgroundColor,
    this.strokeWidth = 20,
    this.decimalPlaces = 1,
  });

  @override
  State<CircularArc> createState() => _CircularArcState();
}

class _CircularArcState extends State<CircularArc>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animController;
  double previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _setupAnimation(widget.progress);
  }

  @override
  void didUpdateWidget(CircularArc oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _setupAnimation(widget.progress);
    }
    if (widget.animationDuration != oldWidget.animationDuration) {
      animController.duration = widget.animationDuration;
    }
  }

  void _setupAnimation(double newProgress) {
    // Clamp progress between 0 and 100
    final clampedProgress = newProgress.clamp(0.0, 100.0);
    
    final startProgress = previousProgress / 100.0 * math.pi;
    final endProgress = clampedProgress / 100.0 * math.pi;
    
    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOutCubic,
    );

    animation = Tween<double>(
      begin: startProgress,
      end: endProgress,
    ).animate(curvedAnimation)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    animController
      ..reset()
      ..forward();
    
    previousProgress = clampedProgress;
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = (animation.value / math.pi * 100.0);
    final displayValue = progressValue.toStringAsFixed(widget.decimalPlaces);
    
    return Center(
      child: SizedBox(
        width: 280.w,
        height: 280.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Background arc
            CustomPaint(
              size: Size(260.w, 260.w),
              painter: ProgressArc(
                math.pi,
                widget.backgroundColor ?? Colors.black26,
                widget.strokeWidth ?? 20,
                true,
              ),
            ),
            // Progress arc
            CustomPaint(
              size: Size(260.w, 260.w),
              painter: ProgressArc(
                animation.value,
                widget.progressColor ?? AppColors.arcDash,
                widget.strokeWidth ?? 20,
                false,
              ),
            ),
            // Dashed outer ring
            CustomPaint(
              size: Size(260.w, 260.w),
              painter: DashedArcPainter(
                animation.value,
              ),
            ),
            // Inner circle
            Container(
              width: 240.w,
              height: 240.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            // Progress text
            Text(
              "$displayValue${widget.unit}",
              style: AppStyles.sairaCondensed24white.copyWith(
                color: Colors.black,
                fontSize: 36.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressArc extends CustomPainter {
  final bool isBackground;
  final double arc;
  final Color progressColor;
  final double strokeWidth;

  const ProgressArc(
    this.arc,
    this.progressColor,
    this.strokeWidth,
    this.isBackground,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const startAngle = -math.pi;
    final sweepAngle = arc;

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ProgressArc &&
        (oldDelegate.arc != arc ||
            oldDelegate.progressColor != progressColor ||
            oldDelegate.strokeWidth != strokeWidth);
  }
}

class DashedArcPainter extends CustomPainter {
  final double progress;
  final Color dashColor;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const DashedArcPainter(
    this.progress, {
    this.dashColor = Colors.green, // Default color, replace with AppColors.arcSolid
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outerRadius = size.width / 2 + 15;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: outerRadius);
    
    const startAngle = -math.pi;
    final sweepAngle = progress + 0.06;

    final paint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Calculate dash parameters
    final circumference = 2 * math.pi * outerRadius;
    final dashLengthInRadians = dashWidth / circumference * 2 * math.pi;
    final dashSpaceInRadians = dashSpace / circumference * 2 * math.pi;
    final dashStepInRadians = dashLengthInRadians + dashSpaceInRadians;

    // Draw dashes
    double currentAngle = startAngle;
    while (currentAngle < startAngle + sweepAngle) {
      final dashEndAngle = math.min(
        currentAngle + dashLengthInRadians,
        startAngle + sweepAngle,
      );
      
      canvas.drawArc(
        rect,
        currentAngle,
        dashEndAngle - currentAngle,
        false,
        paint,
      );
      
      currentAngle += dashStepInRadians;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is DashedArcPainter && oldDelegate.progress != progress;
  }
}