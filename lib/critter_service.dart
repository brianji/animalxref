import 'dart:convert';

import 'package:flutter/services.dart';

import 'critter.dart';

const _fishFile = 'assets/fish.json';

class CritterService {
  Future<List<Critter>> get fish async {
    final contents = await rootBundle.loadString(_fishFile);
    final List json = jsonDecode(contents);
    return json.map((j) {
      return Critter(
        name: j['Name'],
        location: j['Location'],
        size: j['Size'],
        price: j['Price'],
        time: j['Time'],
        north: j['North'],
        south: j['South'],
      );
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}
