import 'dart:convert';
import 'dart:ui';

import 'package:backup/backup.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _orderKey = 'order';
const _southernKey = 'southern';

const sort = 'sort';
const now = 'now';
const time = 'time';
const last = 'last';
const donate = 'donate';
const fishLocation = 'fishLocation';
const fishSize = 'fishSize';
const bugLocation = 'bugLocation';
const reset = 'reset';

const _defaultOrder = [
  sort,
  now,
  time,
  last,
  donate,
  fishLocation,
  fishSize,
  bugLocation,
];

class PreferencesNotifier extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;
  final Set<String> _donated;
  List<String> _order;
  bool _isSouthern;

  PreferencesNotifier(this._sharedPreferences)
      : _donated = _sharedPreferences
            .getKeys()
            .where((k) => k != _southernKey && k != _orderKey)
            .where((k) => _sharedPreferences.getBool(k) ?? false)
            .toSet(),
        _order = _sharedPreferences.getStringList(_orderKey) ?? _defaultOrder,
        _isSouthern = _sharedPreferences.getBool(_southernKey) ?? false;

  bool isDonated(String name) => _donated.contains(name);

  void setDonated(String name, bool donated) {
    if (donated == isDonated(name)) return;

    if (donated) {
      _donated.add(name);
    } else {
      _donated.remove(name);
    }

    _sharedPreferences.setBool(name, donated);
    notifyListeners();
  }

  List<String> get order => _order;

  set order(List<String> order) {
    if (listEquals(order, _order)) return;
    _order = order;
    _sharedPreferences.setStringList(_orderKey, order);
    notifyListeners();
  }

  void resetOrder() => order = _defaultOrder;

  bool get isSouthern => _isSouthern;

  set isSouthern(bool isSouthern) {
    if (isSouthern == _isSouthern) return;
    _isSouthern = isSouthern;
    _sharedPreferences.setBool(_southernKey, isSouthern);
    notifyListeners();
  }

  Future<void> import({VoidCallback onSuccess, VoidCallback onError}) async {
    try {
      final json = await Backup.import();
      if (json == null) return onError();
      final settings = jsonDecode(json);

      _donated.clear();
      await _sharedPreferences.clear();
      settings.keys.forEach((k) => setDonated(k, true));
      notifyListeners();
      onSuccess();
    } catch (_) {
      onError();
    }
  }

  void export() {
    final contents = jsonEncode(Map.fromIterable(_donated, value: (_) => true));
    Backup.export(contents);
  }
}
