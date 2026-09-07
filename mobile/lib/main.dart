import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'provider/config_provider.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ConfigProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.green[500],
        brightness: Brightness.dark,
        appBarTheme: AppBarThemeData(
        ),
        scaffoldBackgroundColor: const Color.fromARGB(133, 60, 83, 51),
      ),
      routes: {
        "/": (context) => MainScreen(),
        "/config": (context) => ConfigScreen(),
      },
    );
  }
}
