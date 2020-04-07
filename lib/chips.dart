import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16) + padding,
      child: Wrap(
        spacing: 8,
        children: [
          Builder(
            builder: (context) {
              return InputChip(
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
                        child: ListTile(
                          leading: Icon(Icons.sort_by_alpha),
                          title: Text('Name'),
                          dense: true,
                        ),
                      ),
                      PopupMenuItem(
                        value: Sort.bells,
                        child: ListTile(
                          leading: Icon(Icons.local_offer),
                          title: Text('Bells'),
                          dense: true,
                        ),
                      ),
                      PopupMenuItem(
                        value: Sort.size,
                        child: ListTile(
                          leading: Icon(Icons.search),
                          title: Text('Size'),
                          dense: true,
                        ),
                      ),
                    ],
                  );
                  if (value == null) return;
                  filter.sort = value;
                },
              );
            },
          ),
          FilterChip(
            label: Text('Now'),
            avatar: Icon(Icons.schedule, size: 18),
            onSelected: (v) => filter.time = v ? Time.now : Time.any,
            selected: filter.time == Time.now,
            showCheckmark: false,
          ),
          FilterChip(
            label: Text('Donate'),
            avatar: Icon(Icons.home, size: 18),
            onSelected: (v) => filter.donate = v ? Donate.no : Donate.any,
            selected: filter.donate == Donate.no,
            showCheckmark: false,
          ),
          Builder(
            builder: (context) {
              return InputChip(
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
              );
            },
          ),
          Builder(
            builder: (context) {
              return InputChip(
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
              );
            },
          ),
          if (filter.sort != Sort.name ||
              filter.location != Location.any ||
              filter.time != Time.any ||
              filter.fishSize != FishSize.any ||
              filter.donate != Donate.any)
            ButtonTheme(
              minWidth: 56,
              child: FlatButton(
                onPressed: () {
                  filter.sort = Sort.name;
                  filter.location = Location.any;
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
