import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chips.dart';
import 'fish.dart';
import 'fish_tile.dart';
import 'search.dart';

const _maxWidth = 700;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final inset = max(0, (width - _maxWidth) / 2);
    final padding = EdgeInsets.symmetric(horizontal: inset);
    final fishes = Provider.of<List<Fish>>(context);
    final count = 1 + (fishes?.length ?? 0) + (fishes?.isEmpty == true ? 1 : 0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 8),
        child: Padding(
          padding: padding,
          child: SizedBox.expand(
            child: SearchBar(),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: count,
        separatorBuilder: (_, i) {
          if (i == 0) return SizedBox.shrink();
          return Divider(
            thickness: 1,
            indent: 16 + inset,
            endIndent: 16 + inset,
          );
        },
        itemBuilder: (context, i) {
          if (i-- == 0) return Chips(padding: padding);
          if (fishes?.isEmpty == true) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Text(
                'No 🎣',
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }
          return Padding(padding: padding, child: FishTile(fish: fishes[i]));
        },
      ),
    );
  }
}
