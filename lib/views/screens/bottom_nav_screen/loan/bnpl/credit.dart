import 'package:flutter/material.dart';
import 'dart:math' as math;
class CreditScoreIndicator extends StatelessWidget {
  final int score;

  const CreditScoreIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomPaint(
          size: const Size(200, 100), // You can change this to the size you want
          painter: ArcPainter(score: score),
        ),
        const SizedBox(height: 20),
        Text(
          '$score',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'Excellent',
          style: TextStyle(
            fontSize: 24,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'You are in a good shape. Better score can help you get credit at attractive loans',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ArcPainter extends CustomPainter {
  final int score;

  ArcPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    // Draw the background arc
    paint.color = Colors.black12;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width / 2, size.height), width: size.width, height: size.height * 2),
     _radians(-120),
     _radians(240),
      false,
      paint,
    );

    // Draw the colored segments
    double startAngle =_radians(-120);
    double sweepAngle =_radians(240 * (score / 900));
    paint.shader = const LinearGradient(
      colors: [Colors.red, Colors.yellow, Colors.green],
      stops: [0.0, 0.5, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width / 2, size.height), width: size.width, height: size.height * 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

double _radians(double degrees) => degrees * (math.pi / 180.0);

// extension on math {
//   static double radians(double degrees) => degrees * (math.pi / 180.0);
// }
