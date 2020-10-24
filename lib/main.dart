import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'providers.dart';
import 'settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Providers(
    sharedPreferences: await SharedPreferences.getInstance(),
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final typography = Typography.material2018();
    final darkTheme = ThemeData.dark();
    final pageTransitionsTheme = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    );

    return MaterialApp(
      title: 'Animal Cross-reference',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        typography: typography,
        pageTransitionsTheme: pageTransitionsTheme,
        platform: defaultTargetPlatform,
      ),
      darkTheme: darkTheme.copyWith(
        toggleableActiveColor: Colors.lightGreenAccent[200],
        accentColor: Colors.lightGreenAccent[200],
        textSelectionHandleColor: Colors.lightGreenAccent[400],
        chipTheme: darkTheme.chipTheme.copyWith(
          selectedColor: Colors.white.withOpacity(0.3),
        ),
        typography: typography,
        pageTransitionsTheme: pageTransitionsTheme,
        platform: defaultTargetPlatform,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        '/settings': (_) => SettingsPage(),
      },
    );
  }
}
