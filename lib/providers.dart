import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'critter.dart';
import 'critter_service.dart';
import 'filter.dart';
import 'preferences.dart';

class Providers extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Widget child;

  const Providers({
    Key key,
    this.sharedPreferences,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: sharedPreferences),
        FutureProvider<Map<CritterType, List<Critter>>>(
          create: (_) => CritterService().critters,
        ),
        ChangeNotifierProvider<ValueNotifier<CritterType>>(
          create: (_) => ValueNotifier(CritterType.fish),
        ),
        StreamProvider<MonthHour>(
          initialData: _getNow(),
          create: (_) => Stream.periodic(
            Duration(minutes: 1),
            (_) => _getNow(),
          ),
        ),
        ChangeNotifierProvider<FilterNotifier>(
          create: (_) => FilterNotifier(),
        ),
        ProxyProvider2<MonthHour, FilterNotifier, MonthHour>(
          update: (_, now, filter, __) {
            return filter.time == Time.now ? now : filter.monthHour;
          },
        ),
        ChangeNotifierProvider<PreferencesNotifier>(
          create: (_) => PreferencesNotifier(sharedPreferences),
        ),
        ChangeNotifierProvider<TextEditingController>(
          create: (_) => TextEditingController(),
        ),
        ProxyProvider<TextEditingController, String>(
          update: (_, query, __) => query.text.trim(),
        ),
        ProxyProvider6<
            MonthHour,
            ValueNotifier<CritterType>,
            FilterNotifier,
            PreferencesNotifier,
            String,
            Map<CritterType, List<Critter>>,
            List<Critter>>(
          updateShouldNotify: (a, b) => !listEquals(a, b),
          update: (
            _,
            monthHour,
            type,
            filter,
            preferences,
            query,
            critters,
            __,
          ) {
            if (critters == null) return null;
            var filtered = List<Critter>.from(critters[type.value]);

            if (query.isNotEmpty) {
              filtered = filtered.where((f) {
                return f.name.toLowerCase().contains(query.toLowerCase());
              }).toList();
            }

            if (filter.time != Time.any && monthHour != null) {
              filtered = filtered.where((f) {
                return f.isAvailable(monthHour, preferences.isSouthern);
              }).toList();
            }

            if (type.value == CritterType.fish &&
                filter.fishLocation != FishLocation.any) {
              filtered = filtered.where((f) {
                return f.location.contains(
                  fishLocationText[filter.fishLocation],
                );
              }).toList();
            }

            if (type.value == CritterType.bug &&
                filter.bugLocation != BugLocation.any) {
              filtered = filtered.where((f) {
                return f.location.toLowerCase().contains(
                    bugLocationText[filter.bugLocation].toLowerCase());
              }).toList();
            }

            if (type.value == CritterType.fish &&
                filter.fishSize != FishSize.any) {
              filtered = filtered.where((f) {
                return f.size == fishSizeText[filter.fishSize];
              }).toList();
            }

            if (filter.donate != Donate.any) {
              filtered = filtered.where((f) {
                return !preferences.isDonated(f.name);
              }).toList();
            }

            if (filter.lastMonth == LastMonth.yes) {
              filtered = filtered.where((f) {
                return f.lastMonth(monthHour.month, preferences.isSouthern);
              }).toList();
            }

            if (filter.sort == Sort.bells) {
              filtered.sort((a, b) => b.price.compareTo(a.price));
            } else if (type.value == CritterType.fish &&
                filter.sort == Sort.size) {
              filtered.sort((a, b) {
                return fishSizeIndex[b.size].compareTo(fishSizeIndex[a.size]);
              });
            }

            return filtered;
          },
        ),
      ],
      child: child,
    );
  }

  static MonthHour _getNow() {
    final now = DateTime.now().toLocal();
    return MonthHour(now.month, now.hour);
  }
}
