import 'dart:async';
import 'package:flutter/material.dart';
import 'extensions.dart';

typedef DurationFormatter = String Function(Duration duration);

class TimeRemaining extends StatefulWidget {
  /// Duration time, it is the remaining time for the counter to reach 0
  final Duration duration;

  /// Warning duration time, when the danger time is approaching
  final Duration? warningDuration;

  /// Danger duration time, when there is little time left to finish
  final Duration? dangerDuration;

  /// Style of the text that is applied to the duration time
  final TextStyle? style;

  /// The style of the text that is applied to the duration time of the warning and merges with the style of the duration text
  final TextStyle? warningsStyle;

  /// The style of the text that is applied to the duration time of the hazard and merged with the style of the duration text.
  final TextStyle? dangerStyle;

  /// It is called when the counter reaches 0
  final VoidCallback? onTimeOver;

  /// Allows you to format the output text to the desired style
  final DurationFormatter? formatter;

  const TimeRemaining({
    Key? key,
    required this.duration,
    this.warningDuration,
    this.dangerDuration,
    this.style,
    this.warningsStyle,
    this.dangerStyle,
    this.onTimeOver,
    this.formatter,
  }) : super(key: key);

  @override
  State<TimeRemaining> createState() => _TimeRemainingState();
}

class _TimeRemainingState extends State<TimeRemaining> {
  late Timer timer;
  late DateTime datetime;
  late String text;
  late TextStyle style;

  @override
  void initState() {
    _initTimer();
    super.initState();
  }

  /// Initialize the timer
  void _initTimer() {
    datetime = DateTime.now().add(widget.duration);
    if (widget.formatter != null) {
      text = widget.formatter!.call(Duration.zero);
    } else {
      text = Duration.zero.humanize;
    }
    style = widget.style ?? const TextStyle();

    if (mounted) {
      timer = Timer.periodic(const Duration(milliseconds: 200), (Timer timer) {
        if (DateTime.now().isBefore(datetime)) {
          Duration difference = datetime.difference(DateTime.now());
          if (mounted) {
            setState(() {
              if (widget.dangerDuration != null &&
                  widget.dangerDuration!.inSeconds >= difference.inSeconds) {
                style = style.merge(widget.dangerStyle);
              } else if (widget.warningDuration != null &&
                  widget.warningDuration!.inSeconds >= difference.inSeconds) {
                style = style.merge(widget.warningsStyle);
              } else {
                style = style;
              }

              if (widget.formatter != null) {
                text = widget.formatter!.call(difference);
              } else {
                text = difference.humanize;
              }
            });
          }
        } else {
          if (mounted) {
            setState(() {
              style = style;
              if (widget.formatter != null) {
                text = widget.formatter!.call(Duration.zero);
              } else {
                text = Duration.zero.humanize;
              }
            });
          }
          timer.cancel();
          widget.onTimeOver?.call();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant TimeRemaining oldWidget) {
    if (oldWidget.duration != widget.duration) {
      try {
        if (timer.isActive) {
          timer.cancel();
        }
      } catch (_) {}

      _initTimer();
    } else {
      if (oldWidget.formatter != widget.formatter) {
        if (widget.formatter != null) {
          text = widget.formatter!.call(Duration.zero);
        } else {
          text = Duration.zero.humanize;
        }
      }

      if (oldWidget.style != widget.style) {
        style = widget.style ?? const TextStyle();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
