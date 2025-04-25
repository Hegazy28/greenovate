import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'dart:math' as math;

import 'package:greenovate/core/constants/app_styles.dart';


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
        setState(() {});
      });

    animController
      ..reset()
      ..forward();
    previousProgress = newProgress;
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
                const Color.fromARGB(255, 0, 255, 21),
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
                color: Colors.white
              ),
            ),
            Text(
              "${(animation.value / math.pi * 100).round()}$unit",
              style: AppStyles.sairaCondensed24white.copyWith(color: AppColors.black,fontSize: 30.sp)
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
  final double progress; // Receive progress value

  DashedArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final outerRadius = size.width / 2 + 15; // Increase radius for outer arc
    final rect = Rect.fromLTWH(size.width / 2 - outerRadius,
        size.height / 2 - outerRadius, outerRadius * 2, outerRadius * 2);
    final startAngle = -math.pi; // Start at the left
    final sweepAngle = progress + 0.1; // Arc covers the same angle as main arc

    final paint = Paint()
      ..color = Colors.green.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4; // Adjust thickness if needed

    final dashWidth = 3; // Length of each dash
    final dashSpace = 1; // Space between dashes

    // Total number of dashes
    final totalDashes = (sweepAngle /
            (dashWidth / outerRadius * 2 * math.pi +
                dashSpace / outerRadius * 2 * math.pi))
        .floor();

    for (int i = 0; i < totalDashes; i++) {
      // Calculate the start and end angles for each dash
      final dashStartAngle =
          startAngle + i * (dashWidth + dashSpace) / outerRadius * 2 * math.pi;
      final dashEndAngle =
          dashStartAngle + dashWidth / outerRadius * 2 * math.pi;

      // Draw each dash
      canvas.drawArc(
          rect, dashStartAngle, dashEndAngle - dashStartAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
