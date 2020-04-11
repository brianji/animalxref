import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 48),
        child: Material(
          color: Theme.of(context).canvasColor.withOpacity(0.95),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: padding, child: SearchBar()),
              Chips(padding: padding),
            ],
          ),
        ),
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, a1, a2) {
          return FadeThroughTransition(
            animation: a1,
            secondaryAnimation: a2,
            child: child,
          );
        },
        child: Builder(
          key: _CrittersKey(critters),
          builder: (context) {
            if (critters == null) return SizedBox.shrink();

            if (critters.isEmpty) {
              return Container(
                alignment: Alignment.center,
                padding: MediaQuery.of(context).padding + EdgeInsets.all(16),
                child: Text(
                  'No ${type.value == CritterType.fish ? '🎣' : '🐛'}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              );
            }

            return ListView.separated(
              padding: MediaQuery.of(context).padding +
                  EdgeInsets.symmetric(vertical: 8) +
                  padding,
              itemCount: critters.length,
              separatorBuilder: (_, __) => Divider(
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (_, i) => CritterTile(critter: critters[i]),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarColor.withOpacity(0.95),
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

class _CrittersKey extends LocalKey {
  final List<Critter> _critters;

  const _CrittersKey(this._critters);

  @override
  bool operator ==(other) {
    return other is _CrittersKey && listEquals(_critters, other._critters);
  }

  @override
  int get hashCode => hashList(_critters);
}
