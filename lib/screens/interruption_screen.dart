import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InterruptionScreen extends StatefulWidget {
  final String packageName;
  final VoidCallback onActionComplete; // ESSENCIAL: Avisa o app para resetar o estado

  const InterruptionScreen({
    super.key,
    required this.packageName,
    required this.onActionComplete,
  });

  @override
  State<InterruptionScreen> createState() => _InterruptionScreenState();
}

class _InterruptionScreenState extends State<InterruptionScreen> {
  static const MethodChannel platform = MethodChannel("mindpause/intervention");
  int seconds = 10;
  Timer? timer;
  bool isOpeningApp = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds <= 1) {
          timer.cancel();
          setState(() {
            seconds = 0;
          });
        } else {
          setState(() {
            seconds--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> continueAnyway() async {
    if (isOpeningApp) return;
    setState(() {
      isOpeningApp = true;
    });

    try {
      final bool? success = await platform.invokeMethod(
        "openBlockedApp",
        {"packageName": widget.packageName},
      );
      
      if (success == true) {
        widget.onActionComplete(); // Reseta o estado do Flutter se deu certo no Android
      } else {
        setState(() {
          isOpeningApp = false;
        });
      }
    } catch (e) {
      debugPrint("Erro ao abrir app: $e");
      setState(() {
        isOpeningApp = false;
      });
    }
  }

  Future<void> closeApp() async {
    try {
      final bool? success = await platform.invokeMethod("goHome");
      if (success == true) {
        widget.onActionComplete(); // Limpa a tela de interrupção e volta o app internamente para a HomeScreen
      }
    } catch (e) {
      debugPrint("Erro ao voltar home: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.greenAccent,
                      width: 5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "$seconds",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 68,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Respire fundo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Você abriu ${widget.packageName.split('.').last}", // Mostra um nome mais amigável do app se desejar
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                if (seconds == 0)
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: isOpeningApp ? null : continueAnyway, // Desabilita o clique duplo acidental
                          child: isOpeningApp 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                              : const Text("Continuar mesmo assim", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: closeApp,
                          child: const Text(
                            "Fechar app",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}