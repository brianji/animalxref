import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'donate.dart';
import 'fish.dart';

class FishTile extends StatelessWidget {
  final Fish fish;

  const FishTile({Key key, @required this.fish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fish.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.room, size: 18),
              SizedBox(width: 4),
              Text(fish.location),
              SizedBox(width: 8),
              Icon(Icons.search, size: 18),
              SizedBox(width: 4),
              Text(fish.size),
            ],
          ),
          Row(
            children: [
              Icon(Icons.date_range, size: 18),
              SizedBox(width: 4),
              Text(fish.north),
              SizedBox(width: 8),
              Icon(Icons.schedule, size: 18),
              SizedBox(width: 4),
              Flexible(child: FittedBox(child: Text(fish.time))),
            ],
          ),
        ],
      ),
      leading: Consumer<DonateNotifier>(
        builder: (context, notifier, _) => Switch(
          key: ValueKey(fish.name),
          value: notifier.isDonated(fish.name),
          onChanged: (v) {
            notifier.setDonated(fish.name, v);
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('${fish.name} ${v ? 'donated' : 'not donated'}'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => notifier.setDonated(fish.name, !v),
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
          Text(NumberFormat().format(fish.price)),
        ],
      ),
      isThreeLine: true,
    );
  }
}
