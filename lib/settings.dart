import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'preferences.dart';

const _maxWidth = 700.0;

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _maxWidth),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 16),
            children: [
              ListTile(
                title: Text('Hemisphere'),
                subtitle: Consumer<PreferencesNotifier>(
                  builder: (_, notifier, __) => Row(
                    children: [
                      FilterChip(
                        showCheckmark: false,
                        selected: !notifier.isSouthern,
                        label: Text('Northern'),
                        onSelected: (_) => notifier.isSouthern = false,
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        showCheckmark: false,
                        selected: notifier.isSouthern,
                        label: Text('Southern'),
                        onSelected: (_) => notifier.isSouthern = true,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Donation data'),
                subtitle: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) => FlatButton(
                        onPressed: () {
                          context.read<PreferencesNotifier>().import(
                            onSuccess: () {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Import succeeded')),
                              );
                            },
                            onError: () {
                              return Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Import failed')),
                              );
                            },
                          );
                        },
                        child: Text('Import'),
                      ),
                    ),
                    FlatButton(
                      onPressed: context.watch<PreferencesNotifier>().export,
                      child: Text('Export'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
