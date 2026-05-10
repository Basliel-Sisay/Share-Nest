import 'package:flutter/material.dart';
import 'account_deleted_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _controller = TextEditingController();
  bool canDelete = false;

  void checkInput(String value) {
    setState(() {
      canDelete = value == "DELETE";
    });
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Final Warning"),
        content: const Text("This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AccountDeletedScreen()),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Account")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Type DELETE to confirm"),

            const SizedBox(height: 16),

            TextField(
              onChanged: checkInput,
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "DELETE",
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: canDelete ? confirmDelete : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete Account"),
            ),
          ],
        ),
      ),
    );
  }
}
