import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       color: const Color.fromARGB(255, 241, 242, 241),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () => context.go('/login'),
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.only(
                        top: 120,
                        right: 40,
                        left: 40,
                        bottom: 30
                        ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(31, 0, 0, 0),
                            blurRadius: 25,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          const SizedBox(height:10),
                          const Text(
                            'Share Smarter, Waste Less',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(137, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                LinearProgressIndicator(
                                  value: 0.3,
                                  color: const Color.fromARGB(255, 2, 100, 5),
                                  backgroundColor: const Color.fromARGB(255, 232, 245, 233),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'ENTERING SHARE NEST ...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                    color: const Color.fromARGB(255, 117, 117, 117),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.security,
                               size: 13,
                               color: Colors.green
                               ),
                              SizedBox(width: 5),
                              SizedBox(height: 70),
                              Text(
                                'Trusted community network',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                                  ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Tap anywhere to continue',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
