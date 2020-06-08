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
    final type = context.watch<ValueNotifier<CritterType>>();
    final critters = context.watch<List<Critter>>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 48),
        child: Material(
          color: Theme.of(context).canvasColor,
          elevation: 1,
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
        transitionBuilder: (child, a1, a2) => FadeThroughTransition(
          animation: a1,
          secondaryAnimation: a2,
          child: child,
        ),
        child: Builder(
          key: _CrittersKey(type.value, critters),
          builder: (context) {
            if (critters == null) return SizedBox.shrink();

            if (critters.isEmpty) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: Text(
                  'No ${type.value == CritterType.fish ? '🎣' : '🐛'}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8) + padding,
              itemCount: critters.length + 1,
              separatorBuilder: (_, __) => Divider(
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, i) {
                if (i-- == 0) {
                  final text = '${critters.length} '
                      '${critters.length == 1 ? 'critter' : 'critters'}';
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      text.toUpperCase(),
                      style: Theme.of(context).textTheme.overline,
                    ),
                  );
                }
                return CritterTile(critter: critters[i]);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
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
  final CritterType _type;
  final List<Critter> _critters;

  const _CrittersKey(this._type, this._critters);

  @override
  bool operator ==(other) {
    return other is _CrittersKey &&
        _type == other._type &&
        listEquals(_critters, other._critters);
  }

  @override
  int get hashCode => hashValues(_type, _critters);
}
