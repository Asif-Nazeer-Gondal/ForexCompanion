import 'package:flutter/material.dart';
import '../../agents/presentation/portfolio_metrics.dart';

class OpenPositionsPainter extends CustomPainter {
  final List<OpenPosition> positions;
  final double minPrice;
  final double maxPrice;
  final double chartLeftPadding;

  OpenPositionsPainter({
    required this.positions,
    required this.minPrice,
    required this.maxPrice,
    this.chartLeftPadding = 50.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final range = maxPrice - minPrice;
    if (range <= 0) return;

    // Calculate the drawing area width (excluding left titles)
    final drawWidth = size.width - chartLeftPadding;

    double priceToY(double price) {
      // Invert Y because canvas 0 is top
      // Map price to 0..height
      return size.height - ((price - minPrice) / range * size.height);
    }

    final entryPaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final slPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final tpPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    void drawLine(double price, Paint paint, String label) {
      if (price < minPrice || price > maxPrice) return;
      
      final y = priceToY(price);
      
      // Draw line starting after the left padding
      canvas.drawLine(
        Offset(chartLeftPadding, y),
        Offset(size.width, y),
        paint,
      );
      
      // Draw Label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$label ${price.toStringAsFixed(5)}',
          style: TextStyle(
            color: paint.color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.black54,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width - textPainter.width - 5, y - textPainter.height - 2));
    }

    for (var pos in positions) {
      drawLine(pos.entryPrice, entryPaint, "ENTRY");
      if (pos.stopLoss != null) drawLine(pos.stopLoss!, slPaint, "SL");
      if (pos.takeProfit != null) drawLine(pos.takeProfit!, tpPaint, "TP");
    }
  }

  @override
  bool shouldRepaint(covariant OpenPositionsPainter oldDelegate) => true;
}