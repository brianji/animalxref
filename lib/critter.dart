import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Critter {
  static final _monthFormat = DateFormat.MMM();
  static final _timeFormat = DateFormat('ha');

  final String name;
  final String location;
  final String size;
  final int price;
  final String time;
  final String north;
  final String south;

  const Critter({
    @required this.name,
    @required this.location,
    @required this.price,
    @required this.time,
    @required this.north,
    @required this.south,
    this.size,
  });

  bool isAvailable(DateTime dateTime, bool isSouthern) {
    final month = dateTime.month;
    final hour = dateTime.hour;
    final months = (isSouthern ? south : north).split(', ');
    final times = time.split(', ');

    return months.any((m) {
          if (m == 'Any') return true;
          final range = m.split('-');
          final start = _monthFormat.parse(range.first).month;
          final end = _monthFormat.parse(range.last).month;
          return (start <= end && month >= start && month <= end) ||
              (start > end && (month <= end || month >= start));
        }) &&
        times.any((t) {
          if (t == 'Any') return true;
          final range = t.split('-');
          final start = _timeFormat.parse(range.first).hour;
          final end = _timeFormat.parse(range.last).hour;
          return (start <= end && hour >= start && hour < end) ||
              (start > end && (hour < end || hour >= start));
        });
  }

  @override
  bool operator ==(other) {
    return other is Critter &&
        other.name == name &&
        other.location == location &&
        other.price == price &&
        other.time == time &&
        other.north == north &&
        other.south == south &&
        other.size == size;
  }

  @override
  int get hashCode {
    return hashValues(name, location, price, time, north, south, size);
  }
}
