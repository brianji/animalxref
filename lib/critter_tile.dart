import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'critter.dart';
import 'preferences.dart';

class CritterTile extends StatelessWidget {
  final Critter critter;

  const CritterTile({Key key, @required this.critter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 8),
        Consumer<PreferencesNotifier>(
          builder: (context, notifier, _) => Switch(
            key: ValueKey(critter.name),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: notifier.isDonated(critter.name),
            onChanged: (v) {
              notifier.setDonated(critter.name, v);
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content:
                      Text('${critter.name} ${v ? 'donated' : 'not donated'}'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => notifier.setDonated(critter.name, !v),
                  ),
                ));
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                critter.name,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 2),
              if (critter.location != null || critter.size != null) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  children: [
                    if (critter.location != null)
                      _MetaData(icon: Icons.room, text: critter.location),
                    if (critter.size != null)
                      _MetaData(icon: Icons.search, text: critter.size),
                  ],
                ),
                SizedBox(height: 2),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 2,
                children: [
                  Selector<PreferencesNotifier, bool>(
                    selector: (_, notifier) => notifier.isSouthern,
                    builder: (_, v, __) => _MetaData(
                      icon: Icons.date_range,
                      text: v ? critter.south : critter.north,
                    ),
                  ),
                  _MetaData(icon: Icons.schedule, text: critter.time),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        _MetaData(
          icon: Icons.local_offer,
          text: NumberFormat().format(critter.price),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}

class _MetaData extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaData({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
