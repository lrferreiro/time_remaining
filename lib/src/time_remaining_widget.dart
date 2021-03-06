import 'dart:async';
import 'package:flutter/material.dart';
import 'extensions.dart';

typedef DurationFormatter = String Function(Duration duration);

class TimeRemaining extends StatefulWidget {
  final Duration duration;
  final Duration? warningDuration;
  final Duration? dangerDuration;
  final TextStyle? style;
  final TextStyle? warningsStyle;
  final TextStyle? dangerStyle;
  final VoidCallback? onTimeOver;
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
  _TimeRemainingState createState() => _TimeRemainingState();
}

class _TimeRemainingState extends State<TimeRemaining> {
  late Timer timer;
  late DateTime datetime;
  late String text;
  late TextStyle style;

  @override
  void initState() {
    super.initState();

    datetime = DateTime.now().add(widget.duration);
    text = Duration.zero.humanize();
    style = widget.style ?? TextStyle();

    if (mounted) {
      timer = Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
        if (DateTime.now().isBefore(datetime)) {
          Duration difference = datetime.difference(DateTime.now());
          if (mounted) {
            setState(() {
              if (widget.dangerDuration != null &&
                  widget.dangerDuration!.inSeconds >= difference.inSeconds) {
                style = widget.dangerStyle ?? style;
              } else if (widget.warningDuration != null &&
                  widget.warningDuration!.inSeconds >= difference.inSeconds) {
                style = widget.warningsStyle ?? style;
              } else {
                style = style;
              }

              if (widget.formatter != null) {
                text = widget.formatter!.call(difference);
              } else {
                text = difference.humanize();
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
                text = Duration.zero.humanize();
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
