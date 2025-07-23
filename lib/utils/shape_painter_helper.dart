import 'dart:ui';

class ShapePainterHelper {
  static void drawCircle({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required Color fillColor,
    required Color borderColor,
  }) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawOval(rect, fillPaint);
    canvas.drawOval(rect, borderPaint);
  }

  static void drawRoundedRect({
    required Canvas canvas,
    required Rect rect,
    required double borderRadius,
    required Color fillColor,
    required Color borderColor,
  }) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, borderPaint);
  }
}
