import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonateNotifier extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;
  final Set<String> _donated;

  DonateNotifier(this._sharedPreferences)
      : _donated = _sharedPreferences
            .getKeys()
            .where((k) => _sharedPreferences.getBool(k) ?? false)
            .toSet();

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
}
