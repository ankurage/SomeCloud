import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'backgroundService/service.dart';
import 'provider/config_provider.dart';
import 'screens/screens.dart';

Future<void> initializeService(ConfigProvider configProv) async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );

  service.on("getClipboard").listen((event) async {
    final clip = await Clipboard.getData(Clipboard.kTextPlain);
    service.invoke("clipboardResult", {
      "text": clip?.text,
      "receiverIp": configProv.ip,
      "portSync": configProv.port
    });
  });

  service.startService();
}

void main() async {
  // final background = BackgroundServiceProvider();
  final config = ConfigProvider();

  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context) => background
        // ),
        ChangeNotifierProvider(
          create: (context) => config
        ),
      ],
      child: const MyApp(),
    ),
  );

  await Hive.initFlutter();
  var box = await Hive.openBox("cfg");
  // box.clear();
  print(box.values);
  if (box.isEmpty) {
    box.add(
      {
        "receiverIp": "192.168.1.1",
        "portSync": 5000
      }
    );
  }
  var data = box.get(0);
  config.set(data["receiverIp"], data["portSync"]);

  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    }
  );

  await initializeService(config);
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
