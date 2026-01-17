import 'dart:math';

import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';

class TubeProgressIndicator extends StatefulWidget {
  final double percentage;
  final String amount;
  final String taskName;

  const TubeProgressIndicator({
    super.key,
    required this.percentage,
    required this.amount,
    required this.taskName,
  });

  @override
  _TubeProgressIndicatorState createState() => _TubeProgressIndicatorState();
}

class _TubeProgressIndicatorState extends State<TubeProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: 120,
        height: 120,
        child: CustomPaint(
          painter: TubePainter(percentage: _animation.value),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.taskName,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.amount,
                    style:const  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.accentColor, // Use your MyColor.primaryColor here
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TubePainter extends CustomPainter {
  final double percentage;

  TubePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2 - 10;
    Offset center = Offset(centerX, centerY);

    // Draw the outer tube
    canvas.drawCircle(center, radius, paint);

    // Draw the progress indicator
    paint.color = AppColors.accentColor; // Use your AppColors.accentColor here
    double angle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      paint,
    );

    // Draw the moving circle
    double circleX = centerX + radius * cos(-pi / 2 + angle);
    double circleY = centerY + radius * sin(-pi / 2 + angle);

    canvas.drawCircle(Offset(circleX, circleY), 6.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
