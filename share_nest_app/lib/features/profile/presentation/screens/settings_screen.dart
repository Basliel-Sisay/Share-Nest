import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifyNewProducts = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Account Preferences",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Manage your account settings",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _SimpleCard(
            icon: Icons.person,
            title: "Profile Settings",
            subtitle: "Update photo and info",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(blurRadius: 10, color: Colors.black12),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications),
                const SizedBox(width: 12),
                const Expanded(child: Text("Notify new products")),
                Switch(
                  value: notifyNewProducts,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleNotification(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SimpleCard(
            icon: Icons.lock,
            title: "Privacy & Security",
            subtitle: "Manage your security",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _SimpleCard(
            icon: Icons.language,
            title: "Language",
            subtitle: "English (US)",
            onTap: () {},
          ),
          const SizedBox(height: 30),
          const Text(
            "Danger Zone",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          _SimpleCard(
            icon: Icons.delete,
            title: "Delete Account",
            subtitle: "Permanently remove your account",
            onTap: () => context.push('/delete-account'),
          ),
        ],
      ),
    );
  }
}

class _SimpleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SimpleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
