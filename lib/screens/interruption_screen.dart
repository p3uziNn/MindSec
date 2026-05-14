import 'dart:async';
import 'package:flutter/material.dart';

class InterruptionScreen extends StatefulWidget {
  const InterruptionScreen({super.key});

  @override
  State<InterruptionScreen> createState() =>
      _InterruptionScreenState();
}

class _InterruptionScreenState
    extends State<InterruptionScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  int seconds = 10;

  final List<String> messages = [

    "Seu foco vale mais que o impulso.",

    "Respire antes de decidir.",

    "Você está no controle.",

    "Só alguns segundos de consciência.",

    "O automático não precisa decidir por você.",
  ];

  late String currentMessage;

  @override
  void initState() {
    super.initState();

    currentMessage = messages[
      DateTime.now().millisecond %
          messages.length
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 180,
      end: 250,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    startCountdown();
  }

  void startCountdown() {

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {

        if (seconds == 0) {
          timer.cancel();
          return;
        }

        setState(() {
          seconds--;
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF050505),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Spacer(),

              const Text(
                "Respire.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Uma pequena pausa antes de continuar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 70),

              AnimatedBuilder(
                animation: _animation,

                builder: (context, child) {

                  return Container(
                    width: _animation.value,
                    height: _animation.value,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      gradient: RadialGradient(
                        colors: [
                          Colors.greenAccent
                              .withOpacity(0.25),

                          Colors.greenAccent
                              .withOpacity(0.02),
                        ],
                      ),

                      boxShadow: [

                        BoxShadow(
                          color: Colors.greenAccent
                              .withOpacity(0.15),

                          blurRadius: 60,
                          spreadRadius: 10,
                        ),
                      ],
                    ),

                    child: Center(
                      child: Text(
                        "$seconds",

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 70),

              AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 400),

                child: Text(
                  seconds > 0
                      ? currentMessage
                      : "Você ainda quer abrir esse app?",

                  key: ValueKey(seconds),

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              AnimatedOpacity(
                opacity: seconds == 0 ? 1 : 0,
                duration:
                    const Duration(milliseconds: 500),

                child: seconds == 0
                    ? Column(
                        children: [

                          SizedBox(
                            width: double.infinity,
                            height: 56,

                            child: ElevatedButton(

                              style:
                                  ElevatedButton.styleFrom(

                                backgroundColor:
                                    Colors.greenAccent,

                                foregroundColor:
                                    Colors.black,

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                              ),

                              onPressed: () {

                                // liberar app
                              },

                              child: const Text(
                                "Entrar mesmo assim",

                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 56,

                            child: OutlinedButton(

                              style:
                                  OutlinedButton.styleFrom(

                                side: BorderSide(
                                  color: Colors.white
                                      .withOpacity(0.15),
                                ),

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                              ),

                              onPressed: () {

                                Navigator.pop(context);
                              },

                              child: const Text(
                                "Voltar",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(height: 128),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}