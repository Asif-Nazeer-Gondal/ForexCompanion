import 'dart:math' as math;
import 'package:flutter/material.dart';

class MacdData {
  final double macd;
  final double signal;
  final double histogram;

  const MacdData({
    required this.macd,
    required this.signal,
    required this.histogram,
  });
}

class TechnicalIndicatorsWidget extends StatelessWidget {
  final List<double> rsiData;
  final List<MacdData> macdData;
  final double height;

  const TechnicalIndicatorsWidget({
    super.key,
    required this.rsiData,
    required this.macdData,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rsiData.isNotEmpty) ...[
          _buildHeader('RSI (14)'),
          SizedBox(
            height: height,
            child: CustomPaint(
              painter: _RsiPainter(rsiData),
              child: Container(),
            ),
          ),
        ],
        if (macdData.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildHeader('MACD (12, 26, 9)'),
          SizedBox(
            height: height,
            child: CustomPaint(
              painter: _MacdPainter(macdData),
              child: Container(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _RsiPainter extends CustomPainter {
  final List<double> data;

  _RsiPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.purpleAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.0;

    // Draw 30/70 lines
    final y70 = size.height * (1 - 0.7);
    final y30 = size.height * (1 - 0.3);

    canvas.drawLine(Offset(0, y70), Offset(size.width, y70), gridPaint);
    canvas.drawLine(Offset(0, y30), Offset(size.width, y30), gridPaint);

    final path = Path();
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final value = data[i].clamp(0.0, 100.0);
      final x = i * stepX;
      final y = size.height * (1 - (value / 100));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _MacdPainter extends CustomPainter {
  final List<MacdData> data;

  _MacdPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Calculate min/max for scaling
    double minVal = double.infinity;
    double maxVal = double.negativeInfinity;

    for (var d in data) {
      minVal = math.min(minVal, math.min(d.macd, math.min(d.signal, d.histogram)));
      maxVal = math.max(maxVal, math.max(d.macd, math.max(d.signal, d.histogram)));
    }

    // Add some padding
    final range = maxVal - minVal;
    if (range == 0) return;
    
    // Normalize to canvas height
    double normalize(double val) {
      return size.height - ((val - minVal) / range * size.height);
    }

    final stepX = size.width / (data.length - 1);
    final zeroY = normalize(0);

    // Draw Zero Line
    final zeroLinePaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), zeroLinePaint);

    // Draw Histogram
    final histPaint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = normalize(data[i].histogram);
      
      histPaint.color = data[i].histogram >= 0 ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5);
      
      // Draw bar from zero line to value
      canvas.drawRect(
        Rect.fromPoints(Offset(x - (stepX / 2) * 0.8, zeroY), Offset(x + (stepX / 2) * 0.8, y)),
        histPaint,
      );
    }

    // Draw MACD Line
    final macdPath = Path();
    final macdPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = normalize(data[i].macd);
      if (i == 0) macdPath.moveTo(x, y);
      else macdPath.lineTo(x, y);
    }
    canvas.drawPath(macdPath, macdPaint);

    // Draw Signal Line
    final signalPath = Path();
    final signalPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = normalize(data[i].signal);
      if (i == 0) signalPath.moveTo(x, y);
      else signalPath.lineTo(x, y);
    }
    canvas.drawPath(signalPath, signalPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}