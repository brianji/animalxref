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
        itemCount: fishes.length + 1,
        separatorBuilder: (_, i) {
          if (i == 0) return SizedBox.shrink();
          return Divider(
            thickness: 1,
            indent: 16 + inset,
            endIndent: 16 + inset,
          );
        },
        itemBuilder: (_, i) {
          if (i-- == 0) return Chips(padding: padding);
          return Padding(padding: padding, child: FishTile(fish: fishes[i]));
        },
      ),
    );
  }
}
