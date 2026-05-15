import 'dart:async';

import 'package:flutter/material.dart';

class InterruptionScreen extends StatefulWidget {

  final String packageName;

  const InterruptionScreen({
    super.key,
    required this.packageName,
  });

  @override
  State<InterruptionScreen> createState() =>
      _InterruptionScreenState();
}

class _InterruptionScreenState
    extends State<InterruptionScreen> {

  int seconds = 10;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {

        if (seconds == 0) {
          timer.cancel();
        } else {
          setState(() {
            seconds--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF050505),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Spacer(),

              Container(
                width: 180,
                height: 180,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.greenAccent,
                    width: 4,
                  ),
                ),

                child: Center(
                  child: Text(
                    "$seconds",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Respire fundo",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Você abriu ${widget.packageName}",

                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              const Spacer(),

              if (seconds == 0)
                Column(
                  children: [

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.pop(
                            context,
                          );
                        },

                        child: const Text(
                          "Continuar mesmo assim",
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,

                      child: OutlinedButton(
                        onPressed: () {

                          Navigator.pop(
                            context,
                          );
                        },

                        child: const Text(
                          "Fechar app",
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}