import 'dart:convert';
import 'dart:html' hide VoidCallback;
import 'dart:ui';

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
            .where((k) => k != _southernKey)
            .where((k) => _sharedPreferences.getBool(k) ?? false)
            .toSet(),
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

  bool get isSouthern => _isSouthern;

  set isSouthern(bool isSouthern) {
    if (isSouthern == _isSouthern) return;
    _isSouthern = isSouthern;
    _sharedPreferences.setBool(_southernKey, isSouthern);
    notifyListeners();
  }

  Future<void> import({VoidCallback onSuccess, VoidCallback onError}) async {
    try {
      final uploadInput = FileUploadInputElement()..click();
      await uploadInput.onChange.first;

      final file = uploadInput.files.first;
      final reader = FileReader()..readAsText(file);
      await reader.onLoadEnd.first;

      final settings = jsonDecode(reader.result);
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
    final contents = Uri.encodeComponent(
      jsonEncode(Map.fromIterable(_donated, value: (_) => true)),
    );
    AnchorElement(href: 'data:text/plain;charset=utf-8,$contents')
      ..setAttribute('download', 'settings.txt')
      ..click();
  }
}
