import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AccountDeletedScreen extends StatefulWidget {
  const AccountDeletedScreen({super.key});

  @override
  State<AccountDeletedScreen> createState() => _AccountDeletedScreenState();
}

class _AccountDeletedScreenState extends State<AccountDeletedScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 15,
              maxBlastForce: 20,
              minBlastForce: 10,
              gravity: 0.3,
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.green,
                ).animate().scale(duration: 600.ms).fadeIn(),

                const SizedBox(height: 24),

                const Text(
                  "Account Deleted",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 12),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Your account has been permanently removed.",
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 40),

                ElevatedButton(
                      onPressed: _goHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      child: const Text("Return to Home"),
                    )
                    .animate()
                    .fadeIn(delay: 700.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
