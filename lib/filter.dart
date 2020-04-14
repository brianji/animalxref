import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum Sort {
  name,
  bells,
  size,
}

enum FishLocation {
  any,
  river,
  pond,
  clifftop,
  mouth,
  sea,
  pier,
  rain,
}

const fishLocationText = {
  FishLocation.any: 'Any',
  FishLocation.river: 'River',
  FishLocation.pond: 'Pond',
  FishLocation.clifftop: 'Clifftop',
  FishLocation.mouth: 'Mouth',
  FishLocation.sea: 'Sea',
  FishLocation.pier: 'Pier',
  FishLocation.rain: 'Rain',
};

enum BugLocation {
  any,
  beach,
  flowers,
  flying,
  freshWater,
  ground,
  rocks,
  rottenFood,
  snowballs,
  stumps,
  trash,
  trees,
  underground,
  villagers,
}

const bugLocationText = {
  BugLocation.any: 'Any',
  BugLocation.beach: 'Beach',
  BugLocation.flowers: 'Flowers',
  BugLocation.flying: 'Flying',
  BugLocation.freshWater: 'Fresh water',
  BugLocation.ground: 'Ground',
  BugLocation.rocks: 'Rocks',
  BugLocation.rottenFood: 'Rotten food',
  BugLocation.snowballs: 'Snowballs',
  BugLocation.stumps: 'Stumps',
  BugLocation.trash: 'Trash',
  BugLocation.trees: 'Trees',
  BugLocation.underground: 'Underground',
  BugLocation.villagers: 'Villagers',
};

enum Time {
  any,
  now,
  custom,
}

class MonthHour {
  static final _monthFormat = DateFormat.MMM();
  static final _monthHourFormat = DateFormat('MMM h a');

  final int month;
  final int hour;

  const MonthHour(this.month, [this.hour]);

  MonthHour.fromDateTime(DateTime dateTime)
      : this(dateTime.month, dateTime.hour);

  @override
  String toString() {
    final dateTime = DateTime(0, month, 1, hour ?? 0);
    final format = hour == null ? _monthFormat : _monthHourFormat;
    return format.format(dateTime);
  }

  @override
  bool operator ==(other) {
    return other is MonthHour && month == other.month && hour == other.hour;
  }

  @override
  int get hashCode => hashValues(month, hour);
}

enum FishSize {
  any,
  smallest,
  small,
  medium,
  large,
  xLarge,
  largest,
  fin,
  narrow,
}

const fishSizeText = {
  FishSize.any: 'Any',
  FishSize.smallest: 'Smallest',
  FishSize.small: 'Small',
  FishSize.medium: 'Medium',
  FishSize.large: 'Large',
  FishSize.xLarge: 'X Large',
  FishSize.largest: 'Largest',
  FishSize.fin: 'Fin',
  FishSize.narrow: 'Narrow',
};

const fishSizeIndex = {
  'Any': 0,
  'Smallest': 1,
  'Small': 2,
  'Medium': 3,
  'Large': 4,
  'X Large': 5,
  'Largest': 6,
  'Fin': 7,
  'Narrow': 8,
};

enum Donate {
  any,
  no,
}

class FilterNotifier extends ChangeNotifier {
  FishLocation _fishLocation;
  BugLocation _bugLocation;
  Sort _sort;
  Time _time;
  MonthHour _monthHour;
  FishSize _fishSize;
  Donate _donate;

  FilterNotifier() {
    _fishLocation = FishLocation.any;
    _bugLocation = BugLocation.any;
    _sort = Sort.name;
    _time = Time.any;
    _fishSize = FishSize.any;
    _donate = Donate.any;
  }

  set fishLocation(FishLocation fishLocation) {
    if (fishLocation == _fishLocation) return;
    _fishLocation = fishLocation;
    notifyListeners();
  }

  set bugLocation(BugLocation bugLocation) {
    if (bugLocation == _bugLocation) return;
    _bugLocation = bugLocation;
    notifyListeners();
  }

  set sort(Sort sort) {
    if (sort == _sort) return;
    _sort = sort;
    notifyListeners();
  }

  set time(Time time) {
    if (time == _time) return;
    _time = time;
    _monthHour = null;
    notifyListeners();
  }

  set monthHour(MonthHour monthHour) {
    if (monthHour == _monthHour) return;
    _monthHour = monthHour;
    _time = Time.custom;
    notifyListeners();
  }

  set fishSize(FishSize fishSize) {
    if (fishSize == _fishSize) return;
    _fishSize = fishSize;
    notifyListeners();
  }

  set donate(Donate donate) {
    if (donate == _donate) return;
    _donate = donate;
    notifyListeners();
  }

  FishLocation get fishLocation => _fishLocation;
  BugLocation get bugLocation => _bugLocation;
  Sort get sort => _sort;
  Time get time => _time;
  MonthHour get monthHour => _monthHour;
  FishSize get fishSize => _fishSize;
  Donate get donate => _donate;
}
