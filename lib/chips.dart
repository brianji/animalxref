import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'critter.dart';
import 'filter.dart';

class Chips extends StatelessWidget {
  final EdgeInsets padding;

  const Chips({Key key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<FilterNotifier>(context);
    final sortLabel = filter.sort == Sort.name
        ? 'Name'
        : filter.sort == Sort.bells ? 'Bells' : 'Size';
    final type = Provider.of<ValueNotifier<CritterType>>(context).value;

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
                    if (type == CritterType.fish)
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
              onDeleted: filter.sort == Sort.name
                  ? null
                  : () => filter.sort = Sort.name,
            ),
          ),
          FilterChip(
            label: Text('Now'),
            avatar: Icon(Icons.schedule, size: 18),
            onSelected: (v) => filter.time = v ? Time.now : Time.any,
            selected: filter.time == Time.now,
            showCheckmark: false,
          ),
          if (filter.time != Time.now)
            Builder(
              builder: (context) => InputChip(
                label: Text(filter.time == Time.any
                    ? 'Any'
                    : filter.monthHour.toString()),
                avatar: Icon(Icons.event, size: 18),
                onPressed: () async {
                  final notifier = ValueNotifier(
                      Provider.of<MonthHour>(context, listen: false) ??
                          MonthHour.fromDateTime(DateTime.now().toLocal()));
                  var addTime = false;

                  final month = await showModal<MonthHour>(
                    context: context,
                    configuration: FadeScaleTransitionConfiguration(),
                    builder: (context) => AlertDialog(
                      title: Text('Choose a month'),
                      content: ChangeNotifierProvider.value(
                        value: notifier,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _MonthButton(text: 'Jan', value: 1),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Feb', value: 2),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Mar', value: 3),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Apr', value: 4),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _MonthButton(text: 'May', value: 5),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Jun', value: 6),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Jul', value: 7),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Aug', value: 8),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _MonthButton(text: 'Sept', value: 9),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Oct', value: 10),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Nov', value: 11),
                                SizedBox(width: 8),
                                _MonthButton(text: 'Dec', value: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: Navigator.of(context).pop,
                        ),
                        FlatButton(
                          child: Text('Add time'),
                          onPressed: () async {
                            addTime = true;
                            Navigator.of(context).pop(notifier.value);
                          },
                        ),
                        FlatButton(
                          child: Text('Apply'),
                          onPressed: () {
                            Navigator.of(context).pop(notifier.value);
                          },
                        ),
                      ],
                    ),
                  );
                  if (month == null) return;

                  TimeOfDay time;
                  if (addTime) {
                    time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: notifier.value?.hour ?? 0,
                        minute: 0,
                      ),
                      builder: _buildPicker,
                    );
                  }

                  filter.monthHour = MonthHour(
                    notifier.value.month,
                    time?.hour,
                  );
                },
                onDeleted: filter.time == Time.any
                    ? null
                    : () => filter.time = Time.any,
                selected: filter.time != Time.any,
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
          if (type == CritterType.fish) ...[
            Builder(
              builder: (context) => InputChip(
                avatar: Icon(Icons.place, size: 18),
                label: Text(fishLocationText[filter.fishLocation]),
                selected: filter.fishLocation != FishLocation.any,
                showCheckmark: false,
                onPressed: () async {
                  final value = await showMenu<FishLocation>(
                    context: context,
                    position: _getMenuPosition(context),
                    items: fishLocationText.keys.map((l) {
                      return PopupMenuItem(
                        value: l,
                        child: Text(fishLocationText[l]),
                      );
                    }).toList(),
                  );
                  if (value == null) return;
                  filter.fishLocation = value;
                },
                onDeleted: filter.fishLocation == FishLocation.any
                    ? null
                    : () => filter.fishLocation = FishLocation.any,
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
                onDeleted: filter.fishSize == FishSize.any
                    ? null
                    : () => filter.fishSize = FishSize.any,
              ),
            ),
          ] else
            Builder(
              builder: (context) => InputChip(
                avatar: Icon(Icons.place, size: 18),
                label: Text(bugLocationText[filter.bugLocation]),
                selected: filter.bugLocation != BugLocation.any,
                showCheckmark: false,
                onPressed: () async {
                  final value = await showMenu<BugLocation>(
                    context: context,
                    position: _getMenuPosition(context),
                    items: bugLocationText.keys.map((l) {
                      return PopupMenuItem(
                        value: l,
                        child: Text(bugLocationText[l]),
                      );
                    }).toList(),
                  );
                  if (value == null) return;
                  filter.bugLocation = value;
                },
                onDeleted: filter.bugLocation == BugLocation.any
                    ? null
                    : () => filter.bugLocation = BugLocation.any,
              ),
            ),
          if (filter.sort != Sort.name ||
              (type == CritterType.fish &&
                  filter.fishLocation != FishLocation.any) ||
              (type == CritterType.bug &&
                  filter.bugLocation != BugLocation.any) ||
              filter.time != Time.any ||
              (type == CritterType.fish && filter.fishSize != FishSize.any) ||
              filter.donate != Donate.any)
            ButtonTheme(
              minWidth: 56,
              child: FlatButton(
                onPressed: () {
                  filter.sort = Sort.name;
                  filter.fishLocation = FishLocation.any;
                  filter.bugLocation = BugLocation.any;
                  filter.time = Time.any;
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

  static Widget _buildPicker(BuildContext context, Widget child) {
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

  static RelativeRect _getMenuPosition(BuildContext context) {
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    return RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset(0, 8),
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

class _MonthButton extends StatelessWidget {
  static const _size = 48.0;

  final String text;
  final int value;

  const _MonthButton({Key key, this.text, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ValueNotifier<MonthHour>>(context);
    final theme = ChipTheme.of(context);
    final month = notifier.value.month;
    return Material(
      borderRadius: BorderRadius.circular(_size / 2),
      color: month == value ? theme.selectedColor : theme.backgroundColor,
      child: InkWell(
        onTap: () => notifier.value = MonthHour(value),
        child: Container(
          width: _size,
          height: _size,
          alignment: Alignment.center,
          child: Text(text),
        ),
      ),
    );
  }
}
