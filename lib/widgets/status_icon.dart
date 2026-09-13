import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  final bool selected;

  const StatusIcon({
    super.key,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        painter: _StatusIconPainter(),
      ),
    );
  }
}

class _StatusIconPainter extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final outerRadius =
        size.width * 0.40;

    final outerRect = Rect.fromCircle(
      center: center,
      radius: outerRadius,
    );

    canvas.drawArc(
      outerRect,
      -2.75,
      1.35,
      false,
      paint,
    );

    canvas.drawArc(
      outerRect,
      -1.05,
      1.30,
      false,
      paint,
    );

    canvas.drawArc(
      outerRect,
      0.65,
      1.35,
      false,
      paint,
    );

    canvas.drawArc(
      outerRect,
      2.35,
      1.20,
      false,
      paint,
    );

    final innerRadius =
        size.width * 0.19;

    canvas.drawCircle(
      center,
      innerRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _StatusIconPainter oldDelegate,
      ) {
    return false;
  }
}