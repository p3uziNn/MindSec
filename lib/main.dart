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

// Adicionamos WidgetsBindingObserver para monitorar quando o app vai para o background/foreground
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const MethodChannel platform = MethodChannel("mindpause/intervention");
  String? blockedApp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Ativa o monitor do ciclo de vida
    checkInitialIntervention();

    platform.setMethodCallHandler(handleMethodCalls);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Desativa o monitor
    super.dispose();
  }

  // Se o usuário fechar o MindPause e depois abrir ele manualmente pelo ícone,
  // essa função roda e garante que ele caia na HomeScreen limpa se não houver bloqueio pendente
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkInitialIntervention();
    }
  }

  Future<void> checkInitialIntervention() async {
    try {
      final result = await platform.invokeMethod("getBlockedApp");
      if (result != null) {
        setState(() {
          blockedApp = result;
        });
      } else {
        // Se o nativo retornar null, garante que a tela de interrupção suma
        setState(() {
          blockedApp = null;
        });
      }
    } catch (e) {
      debugPrint("Erro ao pegar blocked app: $e");
    }
  }

  Future<dynamic> handleMethodCalls(MethodCall call) async {
    if (call.method == "newBlockedApp") {
      setState(() {
        blockedApp = call.arguments as String?;
      });
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
              // AJUSTE AQUI: Essa função limpa o estado do Flutter quando a ação termina no Android
              onActionComplete: () {
                setState(() {
                  blockedApp = null;
                });
              },
            ),
    );
  }
}