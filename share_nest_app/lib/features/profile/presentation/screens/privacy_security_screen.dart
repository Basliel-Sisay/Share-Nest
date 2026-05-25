import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacySecurityScreen extends ConsumerWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy & Security")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Privacy Policy"),
            onTap: () => _showPrivacyPolicy(context),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: true, // Placeholder logic
            onChanged: (val) {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text("Clear Cached Data"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Privacy Policy"),
        content: const SingleChildScrollView(
          child: Text(
            "This is your privacy policy text. We value your privacy and are committed to protecting it. "
            "Our data practices are transparent and secure. By using ShareNest, you agree to these terms."
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
