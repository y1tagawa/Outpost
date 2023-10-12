// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

const _kPi2 = 2.0 * math.pi;

class AnalogClock extends StatefulWidget {
  final Size size;
  final ValueNotifier<DateTime> dateTimeNotifier;
  final Color? faceColor;
  final Color? tickColor;
  final Color? hourColor;
  final Color? minuteColor;
  final Color? secondColor;
  final Color? pivotColor;
  final Widget? child;

  const AnalogClock({
    // ignore: unused_element
    super.key,
    required this.size,
    required this.dateTimeNotifier,
    // ignore: unused_element
    this.faceColor,
    // ignore: unused_element
    this.tickColor,
    // ignore: unused_element
    this.hourColor,
    // ignore: unused_element
    this.minuteColor,
    // ignore: unused_element
    this.secondColor,
    // ignore: unused_element
    this.pivotColor,
    // ignore: unused_element
    this.child,
  });

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _ClockFacePainter extends CustomPainter {
  // ignore: unused_field
  static final _logger = Logger((_ClockFacePainter).toString());

  final _AnalogClockState state;
  final DateTime dateTime;

  const _ClockFacePainter({
    required this.state,
    required this.dateTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //_logger.fine('[i] paint');
    canvas.save();
    try {
      canvas.translate(size.width * 0.5, size.height * 0.5);
      final radius = math.min(size.width, size.height) * 0.5;
      final paint_ = Paint();
      // face
      paint_.style = PaintingStyle.fill;
      paint_.color = state.faceColor;
      canvas.drawCircle(Offset.zero, radius, paint_);
    } finally {
      canvas.restore();
    }
    //_logger.fine('[o] paint');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _ClockFacePainter) {
      return oldDelegate.state != state;
    }
    return false;
  }
}

class _ClockHandsPainter extends CustomPainter {
  // ignore: unused_field
  static final _logger = Logger((_ClockHandsPainter).toString());

  final _AnalogClockState state;
  final DateTime dateTime;

  const _ClockHandsPainter({
    required this.state,
    required this.dateTime,
  });

  Offset _hand(double angle, double radius) =>
      Offset(math.sin(angle) * radius, -math.cos(angle) * radius);

  @override
  void paint(Canvas canvas, Size size) {
    //_logger.fine('[i] paint');
    canvas.save();
    try {
      canvas.translate(size.width * 0.5, size.height * 0.5);
      final radius = math.min(size.width, size.height) * 0.5;
      final paint_ = Paint();
      // ticks
      paint_.style = PaintingStyle.fill;
      paint_.color = state.tickColor;
      for (int i = 0; i < 12; ++i) {
        final p = _hand(i * (_kPi2 / 12.0), radius);
        canvas.drawCircle(p * 0.9, 4.0, paint_);
      }
      // hour hand
      paint_.style = PaintingStyle.stroke;
      paint_.strokeCap = StrokeCap.round;
      paint_.color = state.hourColor;
      paint_.strokeWidth = 8.0;
      final hour = (dateTime.hour * 60 + dateTime.minute) / 60.0;
      final h = _hand(hour * (_kPi2 / 12.0), radius);
      canvas.drawLine(h * -0.05, h * 0.5, paint_);
      // minute hand
      paint_.color = state.minuteColor;
      paint_.strokeWidth = 6.0;
      final minute = (dateTime.minute * 60 + dateTime.second) / 60.0;
      final m = _hand(minute * (_kPi2 / 60.0), radius);
      canvas.drawLine(m * -0.05, m * 0.75, paint_);
      // second hand
      paint_.strokeWidth = 3.0;
      paint_.color = state.secondColor;
      final s = _hand(dateTime.second * (_kPi2 / 60.0), radius);
      canvas.drawLine(s * -0.15, s * 0.65, paint_);
      // pivot
      paint_.style = PaintingStyle.fill;
      paint_.color = state.secondColor;
      canvas.drawCircle(Offset.zero, 3.5, paint_);
      paint_.color = state.pivotColor;
      canvas.drawCircle(Offset.zero, 2.0, paint_);
    } finally {
      canvas.restore();
    }
    //_logger.fine('[o] paint');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _ClockHandsPainter) {
      return oldDelegate.state != state ||
          oldDelegate.dateTime.second != dateTime.second ||
          oldDelegate.dateTime.minute != dateTime.minute ||
          oldDelegate.dateTime.hour != dateTime.hour;
    }
    return false;
  }
}

class _AnalogClockState extends State<AnalogClock> {
  // ignore: unused_field
  static final _logger = Logger((_AnalogClockState).toString());

  late Color faceColor;
  late Color tickColor;
  late Color hourColor;
  late Color minuteColor;
  late Color secondColor;
  late Color pivotColor;

  void _onUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.dateTimeNotifier.addListener(_onUpdate);
  }

  @override
  void dispose() {
    widget.dateTimeNotifier.removeListener(_onUpdate);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      oldWidget.dateTimeNotifier.removeListener(_onUpdate);
      widget.dateTimeNotifier.addListener(_onUpdate);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = widget.dateTimeNotifier.value;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = isDark ? theme.colorScheme.secondary : theme.primaryColor;

    faceColor = widget.faceColor ?? theme.colorScheme.surface;
    tickColor = widget.tickColor ?? color.withOpacity(0.5);
    hourColor = widget.hourColor ?? color.withOpacity(0.9);
    minuteColor = widget.minuteColor ?? tickColor;
    secondColor = widget.secondColor ?? color.withOpacity(0.75);
    pivotColor = widget.pivotColor ?? (isDark ? Colors.white70 : faceColor);

    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: CustomPaint(
        painter: _ClockFacePainter(
          state: this,
          dateTime: dateTime,
        ),
        foregroundPainter: _ClockHandsPainter(
          state: this,
          dateTime: dateTime,
        ),
        child: widget.child,
      ),
    );
  }
}
