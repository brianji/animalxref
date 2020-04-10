import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chips.dart';
import 'critter.dart';
import 'critter_tile.dart';
import 'search.dart';

const _maxWidth = 700;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final inset = max(0, (width - _maxWidth) / 2);
    final padding = EdgeInsets.symmetric(horizontal: inset);
    final type = Provider.of<ValueNotifier<CritterType>>(context);
    final critters = Provider.of<List<Critter>>(context);
    final count =
        1 + (critters?.length ?? 0) + (critters?.isEmpty == true ? 1 : 0);

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
          if (critters?.isEmpty == true) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Text(
                'No 🎣',
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }
          return Padding(
            padding: padding,
            child: CritterTile(critter: critters[i]),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: type.value == CritterType.fish ? 0 : 1,
        onTap: (i) => type.value = i == 0 ? CritterType.fish : CritterType.bug,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.invert_colors),
            title: Text('Fish'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bug_report),
            title: Text('Bugs'),
          ),
        ],
      ),
    );
  }
}
