import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'screens/interruption_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const MethodChannel platform =
      MethodChannel(
        "mindpause/intervention",
      );

  String? blockedApp;

  @override
  void initState() {
    super.initState();

    checkInitialIntervention();
  }

  Future<void>
      checkInitialIntervention() async {

    try {

      final result =
          await platform.invokeMethod(
        "getBlockedApp",
      );

      if (result != null) {

        setState(() {
          blockedApp = result;
        });
      }

    } catch (e) {
      debugPrint(
        "Erro ao pegar blocked app: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: blockedApp == null
          ? const HomeScreen()
          : InterruptionScreen(
              packageName: blockedApp!,
            ),
    );
  }
}