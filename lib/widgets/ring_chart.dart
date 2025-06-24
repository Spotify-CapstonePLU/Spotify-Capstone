import 'package:flutter/material.dart';
import 'dart:math';

class RingChart extends StatelessWidget {
  RingChart({
    super.key,
    required this.votes,
    required this.size,
  });

  final double size;
  final List<int> votes;
  final List<Color> colors = [
    Colors.green,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomPaint(
          size: Size(size, size),
          painter: RingChartPainter(votes, colors),
        ),
        Text(
            "votes: ${votes.reduce((a, b) => a + b)} ",
            style: TextStyle(fontSize: size * 0.3),),
      ]),
    );
  }
}

class RingChartPainter extends CustomPainter {
  final List<int> values;
  final List<Color> colors;

  RingChartPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    int total = values.reduce((a, b) => a + b);

    if (total == 0) {
      // Draw an empty ring or placeholder message
      final paint = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.1;
      final center = Offset(size.width / 2, size.height/2);
      final radius = min(size.width / 2, size.height / 2) * 0.7;

      // Draw a placeholder empty circle
      canvas.drawCircle(center, radius, paint);
      return;
    }

    double startAngle = -pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1; // Defines ring thickness

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) * 0.7;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * pi;
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}