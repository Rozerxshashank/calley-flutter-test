import 'dart:math' as math;
import 'package:flutter/material.dart';

class DonutChartWidget extends StatefulWidget {
  final int pending;
  final int called;
  final int scheduled;
  final double size;

  const DonutChartWidget({
    super.key,
    required this.pending,
    required this.called,
    required this.scheduled,
    this.size = 190,
  });

  @override
  State<DonutChartWidget> createState() => _DonutChartWidgetState();
}

class _DonutChartWidgetState extends State<DonutChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant DonutChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pending != widget.pending ||
        oldWidget.called != widget.called ||
        oldWidget.scheduled != widget.scheduled) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _DonutChartPainter(
              pending: widget.pending,
              called: widget.called,
              scheduled: widget.scheduled,
              progress: _animation.value,
            ),
          ),
        );
      },
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final int pending;
  final int called;
  final int scheduled;
  final double progress;

  _DonutChartPainter({
    required this.pending,
    required this.called,
    required this.scheduled,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = (pending + called + scheduled).clamp(1, 999999);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.40;
    final strokeWidth = size.width * 0.17;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final values = [called, scheduled, pending];
    final colors = [
      const Color(0xFF2563EB), // Blue for Done (top-right arc)
      const Color(0xFF8B5CF6), // Purple for Schedule (bottom arc)
      const Color(0xFFF59E0B), // Orange/Amber for Pending (left arc)
    ];

    double startAngle = -math.pi / 2;
    const double gapAngle = 0.05; // Gap between arcs matching Figma

    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      if (value <= 0) continue;

      final sweepFraction = value / total;
      final sweepAngle = (sweepFraction * 2 * math.pi - gapAngle) * progress;

      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        startAngle + (gapAngle / 2),
        sweepAngle,
        false,
        paint,
      );

      startAngle += (sweepFraction * 2 * math.pi) * progress;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.pending != pending ||
        oldDelegate.called != called ||
        oldDelegate.scheduled != scheduled ||
        oldDelegate.progress != progress;
  }
}

