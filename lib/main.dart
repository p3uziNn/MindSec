import 'package:flutter/material.dart';
import 'services/accessibility_service.dart';
import 'screens/interruption_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("TestApp"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            ElevatedButton(

              onPressed: () {
                AccessibilityService
                    .openAccessibilitySettings();
              },

              child: const Text(
                "Ativar monitoramento",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const InterruptionScreen(),
                  ),
                );
              },

              child: const Text(
                "Testar Intervenção",
              ),
            ),
          ],
        ),
      ),
    );
  }
}