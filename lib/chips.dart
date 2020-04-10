import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'filter.dart';

class Chips extends StatelessWidget {
  static final _dateFormat = DateFormat.Md().add_jm();

  final EdgeInsets padding;

  const Chips({Key key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<FilterNotifier>(context);
    final sortLabel = filter.sort == Sort.name
        ? 'Name'
        : filter.sort == Sort.bells ? 'Bells' : 'Size';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16) + padding,
      child: Wrap(
        spacing: 8,
        children: [
          Builder(
            builder: (context) => InputChip(
              avatar: Icon(Icons.sort, size: 18),
              label: Text(sortLabel),
              selected: filter.sort != Sort.name,
              showCheckmark: false,
              onPressed: () async {
                final value = await showMenu<Sort>(
                  context: context,
                  position: _getMenuPosition(context),
                  items: [
                    PopupMenuItem(
                      value: Sort.name,
                      child: Row(
                        children: [
                          Icon(Icons.sort_by_alpha),
                          SizedBox(width: 16),
                          Text('Name'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: Sort.bells,
                      child: Row(
                        children: [
                          Icon(Icons.local_offer),
                          SizedBox(width: 16),
                          Text('Bells'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: Sort.size,
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 16),
                          Text('Size'),
                        ],
                      ),
                    ),
                  ],
                );
                if (value == null) return;
                filter.sort = value;
              },
            ),
          ),
          Builder(
            builder: (context) => InputChip(
              label: Text(filter.dateTime == null
                  ? 'Any'
                  : _dateFormat.format(filter.dateTime)),
              avatar: Icon(Icons.schedule, size: 18),
              onPressed: () async {
                final now = DateTime.now().toLocal();

                final date = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 1, now.month, now.day),
                  builder: _buildPicker,
                );
                if (date == null) return;

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: _buildPicker,
                );
                if (time == null) return;

                filter.dateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              },
              onDeleted:
                  filter.dateTime == null ? null : () => filter.dateTime = null,
              selected: filter.dateTime != null,
              showCheckmark: false,
            ),
          ),
          FilterChip(
            label: Text('Donate'),
            avatar: Icon(Icons.home, size: 18),
            onSelected: (v) => filter.donate = v ? Donate.no : Donate.any,
            selected: filter.donate == Donate.no,
            showCheckmark: false,
          ),
          Builder(
            builder: (context) => InputChip(
              avatar: Icon(Icons.place, size: 18),
              label: Text(locationText[filter.location]),
              selected: filter.location != Location.any,
              showCheckmark: false,
              onPressed: () async {
                final value = await showMenu<Location>(
                  context: context,
                  position: _getMenuPosition(context),
                  items: locationText.keys.map((l) {
                    return PopupMenuItem(
                      value: l,
                      child: Text(locationText[l]),
                    );
                  }).toList(),
                );
                if (value == null) return;
                filter.location = value;
              },
            ),
          ),
          Builder(
            builder: (context) => InputChip(
              avatar: Icon(Icons.search, size: 18),
              label: Text(fishSizeText[filter.fishSize]),
              selected: filter.fishSize != FishSize.any,
              showCheckmark: false,
              onPressed: () async {
                final value = await showMenu<FishSize>(
                  context: context,
                  position: _getMenuPosition(context),
                  items: fishSizeText.keys.map((f) {
                    return PopupMenuItem(
                      value: f,
                      child: Text(fishSizeText[f]),
                    );
                  }).toList(),
                );
                if (value == null) return;
                filter.fishSize = value;
              },
            ),
          ),
          if (filter.sort != Sort.name ||
              filter.location != Location.any ||
              filter.dateTime != null ||
              filter.fishSize != FishSize.any ||
              filter.donate != Donate.any)
            ButtonTheme(
              minWidth: 56,
              child: FlatButton(
                onPressed: () {
                  filter.sort = Sort.name;
                  filter.location = Location.any;
                  filter.dateTime = null;
                  filter.fishSize = FishSize.any;
                  filter.donate = Donate.any;
                },
                child: Text('Reset'),
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPicker(BuildContext context, Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: 500,
        ),
        child: child,
      ),
    );
  }

  RelativeRect _getMenuPosition(BuildContext context) {
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    return RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset.zero,
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
  }
}
