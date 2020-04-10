import 'package:flutter/foundation.dart';

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
  DateTime _dateTime;
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
    _dateTime = null;
    notifyListeners();
  }

  set dateTime(DateTime dateTime) {
    if (dateTime == _dateTime) return;
    _dateTime = dateTime;
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
  DateTime get dateTime => _dateTime;
  FishSize get fishSize => _fishSize;
  Donate get donate => _donate;
}
