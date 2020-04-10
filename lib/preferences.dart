import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _southernKey = 'southern';

class PreferencesNotifier extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;
  final Set<String> _donated;
  bool _isSouthern;

  PreferencesNotifier(this._sharedPreferences)
      : _donated = _sharedPreferences
            .getKeys()
            .where((k) => _sharedPreferences.getBool(k) ?? false)
            .toSet(),
        _isSouthern = _sharedPreferences.getBool(_southernKey);

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

  bool get isSouthern => _isSouthern;

  set isSouthern(bool isSouthern) {
    if (isSouthern == _isSouthern) return;
    _isSouthern = isSouthern;
    _sharedPreferences.setBool(_southernKey, isSouthern);
    notifyListeners();
  }
}
