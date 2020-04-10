import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donate.dart';
import 'filter.dart';
import 'fish.dart';
import 'fish_service.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(sharedPreferences: await SharedPreferences.getInstance()));
}

class App extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const App({Key key, this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<List<Fish>>(
          create: (_) => FishService().fish,
        ),
        ChangeNotifierProvider<FilterNotifier>(
          create: (_) => FilterNotifier(),
        ),
        ChangeNotifierProvider<DonateNotifier>(
          create: (_) => DonateNotifier(sharedPreferences),
        ),
        ChangeNotifierProvider<TextEditingController>(
          create: (_) => TextEditingController(),
        ),
        ProxyProvider<TextEditingController, String>(
          update: (_, query, __) => query.text.trim(),
        ),
        ProxyProvider4<FilterNotifier, DonateNotifier, String, List<Fish>,
            List<Fish>>(
          update: (context, filter, donate, query, fish, _) {
            if (fish == null) return null;
            var filtered = List<Fish>.from(fish);

            if (query.isNotEmpty) {
              filtered = filtered.where((f) {
                return f.name.toLowerCase().contains(query.toLowerCase());
              }).toList();
            }

            if (filter.time == Time.now) {
              filtered = filtered.where((f) => f.isAvailable).toList();
            }

            if (filter.location != Location.any) {
              filtered = filtered.where((f) {
                return f.location.contains(locationText[filter.location]);
              }).toList();
            }

            if (filter.fishSize != FishSize.any) {
              filtered = filtered.where((f) {
                return f.size == fishSizeText[filter.fishSize];
              }).toList();
            }

            if (filter.donate != Donate.any) {
              filtered = filtered.where((f) {
                return !donate.isDonated(f.name);
              }).toList();
            }

            if (filter.sort == Sort.bells) {
              filtered.sort((a, b) => b.price.compareTo(a.price));
            } else if (filter.sort == Sort.size) {
              filtered.sort((a, b) {
                return fishSizeIndex[b.size].compareTo(fishSizeIndex[a.size]);
              });
            }

            return filtered;
          },
        ),
      ],
      child: Builder(
        builder: (_) {
          final typography = Typography.material2018();
          final darkTheme = ThemeData.dark();
          return MaterialApp(
            title: 'Animal Cross-reference',
            theme: ThemeData(
              primarySwatch: Colors.lightGreen,
              typography: typography,
            ),
            darkTheme: darkTheme.copyWith(
              toggleableActiveColor: Colors.lightGreenAccent[200],
              accentColor: Colors.lightGreenAccent[200],
              textSelectionHandleColor: Colors.lightGreenAccent[400],
              chipTheme: darkTheme.chipTheme.copyWith(
                selectedColor: Colors.white.withOpacity(0.3),
              ),
              typography: typography,
            ),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
