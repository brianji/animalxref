import 'dart:convert';

import 'package:flutter/services.dart';

import 'critter.dart';

const _fishFile = 'assets/fish.json';
const _bugsFile = 'assets/bugs.json';

class CritterService {
  Future<Map<CritterType, List<Critter>>> get critters async {
    return {
      CritterType.fish: await _loadCritters(_fishFile),
      CritterType.bug: await _loadCritters(_bugsFile),
    };
  }
}

Future<List<Critter>> _loadCritters(String file) async {
  final contents = await rootBundle.loadString(file);
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
