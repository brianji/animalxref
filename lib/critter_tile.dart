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
    return ListTile(
      title: Text(critter.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.room, size: 18),
              SizedBox(width: 4),
              Text(critter.location),
              SizedBox(width: 8),
              if (critter.size != null) ...[
                Icon(Icons.search, size: 18),
                SizedBox(width: 4),
                Text(critter.size),
              ],
            ],
          ),
          Row(
            children: [
              Icon(Icons.date_range, size: 18),
              SizedBox(width: 4),
              Selector<PreferencesNotifier, bool>(
                selector: (_, notifier) => notifier.isSouthern,
                builder: (_, v, __) => Text(v ? critter.south : critter.north),
              ),
              SizedBox(width: 8),
              Icon(Icons.schedule, size: 18),
              SizedBox(width: 4),
              Flexible(child: FittedBox(child: Text(critter.time))),
            ],
          ),
        ],
      ),
      leading: Consumer<PreferencesNotifier>(
        builder: (context, notifier, _) => Switch(
          key: ValueKey(critter.name),
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, size: 18),
          SizedBox(width: 4),
          Text(NumberFormat().format(critter.price)),
        ],
      ),
      isThreeLine: true,
    );
  }
}
