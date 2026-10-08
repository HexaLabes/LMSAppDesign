import 'package:flutter/material.dart';

class CurveChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final bool isDark;

  CurveChartPainter({
    required this.dataPoints,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final width = size.width;
    final height = size.height;

    // Draw horizontal grid lines and percentage labels
    final gridPaint = Paint()
      ..color = isDark ? const Color(0xFF28303D) : const Color(0xFFF0ECE4)
      ..strokeWidth = 1.0;

    final labelStyle = TextStyle(
      color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final levels = [1.0, 0.75, 0.50, 0.25, 0.0];
    for (var level in levels) {
      final y = height * (1 - level);
      canvas.drawLine(Offset(32, y), Offset(width, y), gridPaint);

      final label = '${(level * 100).toInt()}%';
      textPainter.text = TextSpan(text: label, style: labelStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    // Chart plotting area
    final chartLeft = 40.0;
    final chartWidth = width - chartLeft;
    final dx = chartWidth / (dataPoints.length - 1);

    final points = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final x = chartLeft + (i * dx);
      final y = height * (1 - dataPoints[i]);
      points.add(Offset(x, y));
    }

    // Draw smooth curved filled area
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, height);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      fillPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    fillPath.lineTo(points.last.dx, height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFE95D34).withAlpha(45),
          const Color(0xFFE95D34).withAlpha(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw smooth line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      linePath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    final linePaint = Paint()
      ..color = const Color(0xFFE95D34)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(linePath, linePaint);

    // Draw circular dots
    final dotOuterPaint = Paint()
      ..color = isDark ? const Color(0xFF181C23) : Colors.white
      ..style = PaintingStyle.fill;

    final dotInnerPaint = Paint()
      ..color = const Color(0xFFE95D34)
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 5, dotOuterPaint);
      canvas.drawCircle(point, 3.5, dotInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CurveChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints || oldDelegate.isDark != isDark;
  }
}
