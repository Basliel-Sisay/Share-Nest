import 'package:flutter/material.dart';

class AccountDeletedScreen extends StatefulWidget {
  const AccountDeletedScreen({super.key});

  @override
  State<AccountDeletedScreen> createState() => _AccountDeletedScreenState();
}

class _AccountDeletedScreenState extends State<AccountDeletedScreen> {

  @override
  void initState() {
    super.initState();
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),

            const SizedBox(height: 24),

            const Text(
              "Account Deleted",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Your account has been permanently removed.",
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: ElevatedButton(
                    onPressed: _goHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    child: const Text("Return to Home", style: TextStyle(color: Colors.white)),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
