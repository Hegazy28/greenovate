import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_styles.dart';

// Placeholder for your custom imports (replace with actual imports)
const Color black = Colors.black; // Placeholder for AppColors.black
final TextStyle sairaCondensed24white = TextStyle(fontFamily: 'Saira Condensed', fontSize: 24); // Placeholder for AppStyles.sairaCondensed24white

class CircularArc extends StatefulWidget {
  final double progress;
  final String unit;

  const CircularArc({
    super.key,
    required this.progress,
    required this.unit,
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
    animController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _setupAnimation(widget.progress);
  }

  @override
  void didUpdateWidget(CircularArc oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _setupAnimation(widget.progress);
    }
  }

  void _setupAnimation(double newProgress) {
    final startProgress = previousProgress / 100 * math.pi;
    final endProgress = newProgress / 100 * math.pi;
    final curvedAnimation =
        CurvedAnimation(parent: animController, curve: Curves.easeInOutCubic);

    animation = Tween<double>(begin: startProgress, end: endProgress)
        .animate(curvedAnimation)
      ..addListener(() {
        if (mounted) { // Check if the widget is still mounted
          setState(() {});
        }
      });

    animController
      ..reset()
      ..forward();
    previousProgress = newProgress;
  }

  @override
  void dispose() {
    animController.stop(); // Stop the animation
    animController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String unit = widget.unit;

    return Center(
      child: SizedBox(
        width: 280.w,
        height: 280.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(260.w, 260.w),
              painter: ProgressArc(
                math.pi,
                Colors.black54,
                true,
              ),
            ),
            CustomPaint(
              size: Size(260.w, 260.w),
              painter: ProgressArc(
                animation.value,
                AppColors.arcDash,
                false,
              ),
            ),
            CustomPaint(
              size: Size(260.w, 260.w),
              painter: DashedArcPainter(
                animation.value,
              ),
            ),
            Container(
              width: 240.w,
              height: 240.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            Text(
              "${(animation.value / math.pi * 100).round()}$unit",
              style: AppStyles.sairaCondensed24white  .copyWith(
                  color: black, fontSize: 36.sp),
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

  ProgressArc(this.arc, this.progressColor, this.isBackground);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = -math.pi;
    final sweepAngle = arc;
    final userCenter = false;

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawArc(rect, startAngle, sweepAngle, userCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DashedArcPainter extends CustomPainter {
  final double progress;

  DashedArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final outerRadius = size.width / 2 + 15;
    final rect = Rect.fromLTWH(size.width / 2 - outerRadius,
        size.height / 2 - outerRadius, outerRadius * 2, outerRadius * 2);
    final startAngle = -math.pi;
    final sweepAngle = progress + 0.1;

    final paint = Paint()
      ..color = AppColors.arcSolid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const dashWidth = 3;
    const dashSpace = 1;

    final totalDashes = (sweepAngle /
            (dashWidth / outerRadius * 2 * math.pi +
                dashSpace / outerRadius * 2 * math.pi))
        .floor();

    for (int i = 0; i < totalDashes; i++) {
      final dashStartAngle =
          startAngle + i * (dashWidth + dashSpace) / outerRadius * 2 * math.pi;
      final dashEndAngle =
          dashStartAngle + dashWidth / outerRadius * 2 * math.pi;

      canvas.drawArc(
          rect, dashStartAngle, dashEndAngle - dashStartAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}