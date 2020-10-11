import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'critter.dart';
import 'filter.dart';

const _sortKey = Key('sort');
const _nowKey = Key('now');
const _timeKey = Key('time');
const _lastKey = Key('last');
const _donateKey = Key('donate');
const _fishLocationKey = Key('fishLocation');
const _fishSizeKey = Key('fishSize');
const _bugLocationKey = Key('bugLocation');
const _resetKey = Key('reset');

final _keyToChip = {
  _sortKey: _SortChip(),
  _nowKey: _NowChip(),
  _timeKey: _TimeChip(),
  _lastKey: _LastChip(),
  _donateKey: _DonateChip(),
  _fishLocationKey: _FishLocationChip(),
  _fishSizeKey: _FishSizeChip(),
  _bugLocationKey: _BugLocationChip(),
};

class Chips extends StatefulWidget {
  final EdgeInsets padding;

  const Chips({Key key, this.padding}) : super(key: key);

  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ScrollController()),
          ChangeNotifierProvider(
            create: (_) => ValueNotifier([
              _sortKey,
              _nowKey,
              _timeKey,
              _lastKey,
              _donateKey,
              _fishLocationKey,
              _fishSizeKey,
              _bugLocationKey,
            ]),
          ),
        ],
        builder: (context, _) {
          final scrollController =
              context.select<ScrollController, ScrollController>((v) => v);
          final orderNotifier = context.watch<ValueNotifier<List<Key>>>();
          final order = List.of(orderNotifier.value);

          return ReorderableListView(
            scrollController: scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12) + widget.padding,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex == order.length) return;
              newIndex = newIndex.clamp(0, order.length - 1);
              final removed = order.removeAt(oldIndex);
              if (newIndex > oldIndex) newIndex--;
              order.insert(newIndex, removed);
              orderNotifier.value = order;
            },
            children: [...order.map((k) => _keyToChip[k]), _ResetButton()],
          );
        },
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip() : super(key: _sortKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    final sortLabel = filter.sort == Sort.name
        ? 'Name'
        : filter.sort == Sort.bells
            ? 'Bells'
            : 'Size';
    final type = context.watch<ValueNotifier<CritterType>>().value;

    return _Item(
      child: InputChip(
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
        onDeleted:
            filter.sort == Sort.name ? null : () => filter.sort = Sort.name,
      ),
    );
  }
}

class _NowChip extends StatelessWidget {
  const _NowChip() : super(key: _nowKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    return _Item(
      child: FilterChip(
        label: Text('Now'),
        avatar: Icon(Icons.schedule, size: 18),
        onSelected: (v) => filter.time = v ? Time.now : Time.any,
        selected: filter.time == Time.now,
        showCheckmark: false,
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip() : super(key: _timeKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    if (filter.time == Time.now) return SizedBox.shrink();
    return _Item(
      child: InputChip(
        label: Text(
          filter.time == Time.any ? 'Any' : filter.monthHour.toString(),
        ),
        avatar: Icon(Icons.event, size: 18),
        onPressed: () async {
          final notifier = ValueNotifier(context.read<MonthHour>() ??
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
        onDeleted:
            filter.time == Time.any ? null : () => filter.time = Time.any,
        selected: filter.time != Time.any,
        showCheckmark: false,
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
}

class _LastChip extends StatelessWidget {
  const _LastChip() : super(key: _lastKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    return _Item(
      child: FilterChip(
        label: Text('Last'),
        avatar: Icon(Icons.timer, size: 18),
        onSelected: (v) {
          filter.lastMonth = v ? LastMonth.yes : LastMonth.no;
        },
        selected: filter.lastMonth == LastMonth.yes,
        showCheckmark: false,
      ),
    );
  }
}

class _DonateChip extends StatelessWidget {
  const _DonateChip() : super(key: _donateKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    return _Item(
      child: FilterChip(
        label: Text('Donate'),
        avatar: Icon(Icons.home, size: 18),
        onSelected: (v) => filter.donate = v ? Donate.no : Donate.any,
        selected: filter.donate == Donate.no,
        showCheckmark: false,
      ),
    );
  }
}

class _FishLocationChip extends StatelessWidget {
  const _FishLocationChip() : super(key: _fishLocationKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    final type = context.watch<ValueNotifier<CritterType>>().value;
    if (type != CritterType.fish) return SizedBox.shrink();
    return _Item(
      child: InputChip(
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
    );
  }
}

class _FishSizeChip extends StatelessWidget {
  const _FishSizeChip() : super(key: _fishSizeKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    final type = context.watch<ValueNotifier<CritterType>>().value;
    if (type != CritterType.fish) return SizedBox.shrink();
    return _Item(
      child: InputChip(
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
    );
  }
}

class _BugLocationChip extends StatelessWidget {
  const _BugLocationChip() : super(key: _bugLocationKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    final type = context.watch<ValueNotifier<CritterType>>().value;
    if (type != CritterType.bug) return SizedBox.shrink();
    return _Item(
      child: InputChip(
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
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton() : super(key: _resetKey);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterNotifier>();
    final type = context.watch<ValueNotifier<CritterType>>().value;
    if (filter.sort == Sort.name &&
        (type != CritterType.fish || filter.fishLocation == FishLocation.any) &&
        (type != CritterType.bug || filter.bugLocation == BugLocation.any) &&
        filter.time == Time.any &&
        (type != CritterType.fish || filter.fishSize == FishSize.any) &&
        filter.donate == Donate.any) return SizedBox.shrink();

    return _Item(
      child: ButtonTheme(
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
    );
  }
}

class _Item extends StatelessWidget {
  final Widget child;

  const _Item({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: child,
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
    final notifier = context.watch<ValueNotifier<MonthHour>>();
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

RelativeRect _getMenuPosition(BuildContext context) {
  final button = context.findRenderObject() as RenderBox;
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  return RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(
        Offset(0, 56),
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
