import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fish.dart';
import 'fish_list.dart';
import 'search.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: FishList(fishes: Provider.of<List<Fish>>(context)),
    );
  }
}
