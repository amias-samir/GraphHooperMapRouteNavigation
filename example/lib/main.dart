import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'bindings/http_overrides.dart';
import 'map_dashboard_screen.dart';

Future<void> main() async {
  // loads the env file if doesnt exist then throws error
  await dotenv.load(fileName: ".env.example");

  // ensures the initialization
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghaphhooper Map Route Navigation',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const MapDashboardScreen(),
    );
  }
}
