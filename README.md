# time_remaining

[![pub package](https://img.shields.io/pub/v/time_remaining.svg)](https://pub.dev/packages/time_remaining)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

time_remaining tells you in the form of a countdown the exact time remaining until the time you want is fulfilled.

## Getting Started

### Adding package

```yaml
time_remaining: ^1.0.0
```

### Importing package

```dart
import 'package:time_remaining/time_remaining.dart';
```

## Example

```dart
TimeRemaining(
  duration: Duration(hours: 1),
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  warningDuration: Duration(minutes: 30),
  warningsStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: ColorsApp.warning,
  ),
  dangerDuration: Duration(minutes: 10),
  dangerStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ColorsApp.error,
  ),
)
```