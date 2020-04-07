import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chips.dart';
import 'fish.dart';
import 'fish_tile.dart';
import 'search.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fishes = Provider.of<List<Fish>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Cross-reference'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: FishSearchDelegate(),
            ),
            tooltip: 'Search',
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: fishes.length + 1,
        separatorBuilder: (_, i) {
          return i == 0
              ? SizedBox.shrink()
              : Divider(thickness: 1, indent: 16, endIndent: 16);
        },
        itemBuilder: (_, i) {
          if (i-- == 0) return Chips();
          return FishTile(fish: fishes[i]);
        },
      ),
    );
  }
}
