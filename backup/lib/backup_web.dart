import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class BackupWeb {
  static void registerWith(Registrar registrar) {
    MethodChannel(
      'backup',
      StandardMethodCodec(),
      registrar.messenger,
    ).setMethodCallHandler(BackupWeb().handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'import':
        return _import();
      case 'export':
        _export(call.arguments);
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'backup for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  Future<String> _import() async {
    try {
      final uploadInput = FileUploadInputElement()..click();
      await uploadInput.onChange.first;

      final file = uploadInput.files.first;
      final reader = FileReader()..readAsText(file);
      await reader.onLoadEnd.first;

      return reader.result;
    } catch (_) {
      return null;
    }
  }

  void _export(String contents) {
    final uri = Uri.encodeComponent(contents);
    AnchorElement(href: 'data:text/plain;charset=utf-8,$uri')
      ..setAttribute('download', 'settings.txt')
      ..click();
  }
}
