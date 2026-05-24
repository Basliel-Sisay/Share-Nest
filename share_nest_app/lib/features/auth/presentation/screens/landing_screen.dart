import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..forward().then((_) {
        if (mounted) {
          context.go('/login');
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 241, 242, 241),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 247, 243),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'SN',
                    style: TextStyle(
                      color: Color.fromARGB(255, 5, 110, 1),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'ShareNest',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Share Smarter, Waste Less',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(137, 0, 0, 0),
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _controller.value,
                          color: const Color.fromARGB(255, 2, 100, 5),
                          backgroundColor:
                              const Color.fromARGB(255, 232, 245, 233),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ENTERING SHARE NEST ...',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.security, size: 13, color: Colors.green),
                  SizedBox(width: 5),
                  Text(
                    'Trusted community network',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
