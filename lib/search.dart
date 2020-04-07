import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fish.dart';
import 'fish_list.dart';

class FishSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
          tooltip: 'Clear',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) => BackButton();

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final fishes = Provider.of<List<Fish>>(context).where((f) {
      return f.name.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();

    return FishList(fishes: fishes);
  }
}
