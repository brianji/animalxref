import 'dart:async';

import 'package:flutter/services.dart';

class Backup {
  static const MethodChannel _channel = MethodChannel('backup');

  static Future<String> import() => _channel.invokeMethod('import');

  static void export(String contents) {
    _channel.invokeMethod('export', contents);
  }
}
