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

  @override
  void initState() {
    super.initState();

    // animação respirando
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 180,
      end: 240,
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
      backgroundColor: const Color(0xFF0D0D0D),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Text(
                "Respire.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 50),

              AnimatedBuilder(
                animation: _animation,

                builder: (context, child) {

                  return Container(
                    width: _animation.value,
                    height: _animation.value,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),

                    child: Center(
                      child: Text(
                        "$seconds",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 50),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32),

                child: Text(
                  seconds > 0
                      ? "Seu foco vale mais que o impulso."
                      : "Você ainda quer abrir esse app?",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              if (seconds == 0)
                Column(
                  children: [

                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            const Size(260, 55),
                      ),

                      onPressed: () {

                        // liberar acesso depois
                      },

                      child: const Text(
                        "Entrar mesmo assim",
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton(

                      style: OutlinedButton.styleFrom(
                        minimumSize:
                            const Size(260, 55),
                      ),

                      onPressed: () {

                        Navigator.pop(context);
                      },

                      child: const Text(
                        "Voltar",
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