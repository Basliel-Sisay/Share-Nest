import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
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
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).deleteAccount();
              if (!context.mounted) return;
              context.pushReplacement('/account-deleted');
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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

            if (authState.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  authState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            ElevatedButton(
              onPressed: (canDelete && !authState.isLoading) ? confirmDelete : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: authState.isLoading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text("Delete Account", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
