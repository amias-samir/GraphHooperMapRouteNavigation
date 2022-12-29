import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';


import 'package:flutter/services.dart';

import 'bindings/controller_binding.dart';
import 'bindings/http_overrides.dart';
import 'map_dashboard_screen.dart';



void main() async {
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
// loadEnvFile() async {
//   await DotEnv().load('.env');
//
// }
  // Platform messages are asynchronous, so we initialize in an async method.


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ghaphhooper Map Route Navigation',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home:  MapDashboardScreen(),
      initialBinding: ControllerBinding(),
    );
  }
}
