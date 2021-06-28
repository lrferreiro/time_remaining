extension ExtensionNum on num {
  String get twoDigits => this.toString().padLeft(2, "0");
}

extension ExtensionDuration on Duration {
  humanize() {
    return "${this.inDays > 0 ? '${this.inDays}d ' : ''}${this.inHours.remainder(24).twoDigits}h:${this.inMinutes.remainder(60).twoDigits}m:${this.inSeconds.remainder(60).twoDigits}s";
  }
}
