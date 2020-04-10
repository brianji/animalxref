import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'animal.dart';
import 'preferences.dart';

class AnimalTile extends StatelessWidget {
  final Animal animal;

  const AnimalTile({Key key, @required this.animal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(animal.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.room, size: 18),
              SizedBox(width: 4),
              Text(animal.location),
              SizedBox(width: 8),
              Icon(Icons.search, size: 18),
              SizedBox(width: 4),
              Text(animal.size),
            ],
          ),
          Row(
            children: [
              Icon(Icons.date_range, size: 18),
              SizedBox(width: 4),
              Selector<PreferencesNotifier, bool>(
                selector: (_, notifier) => notifier.isSouthern,
                builder: (_, v, __) => Text(v ? animal.south : animal.north),
              ),
              SizedBox(width: 8),
              Icon(Icons.schedule, size: 18),
              SizedBox(width: 4),
              Flexible(child: FittedBox(child: Text(animal.time))),
            ],
          ),
        ],
      ),
      leading: Consumer<PreferencesNotifier>(
        builder: (context, notifier, _) => Switch(
          key: ValueKey(animal.name),
          value: notifier.isDonated(animal.name),
          onChanged: (v) {
            notifier.setDonated(animal.name, v);
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content:
                    Text('${animal.name} ${v ? 'donated' : 'not donated'}'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => notifier.setDonated(animal.name, !v),
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
          Text(NumberFormat().format(animal.price)),
        ],
      ),
      isThreeLine: true,
    );
  }
}
