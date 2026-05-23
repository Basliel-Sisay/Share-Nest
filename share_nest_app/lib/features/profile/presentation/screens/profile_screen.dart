import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 10),
              Text(
                user?.name ?? "User",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(user?.email ?? ""),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatBox(title: "Resources", value: "12"),
                  _StatBox(title: "Shares", value: "48"),
                ],
              ),
              const SizedBox(height: 30),
              _menuItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () => context.push('/settings'),
              ),
              _menuItem(
                icon: Icons.history,
                title: "Sharing History",
                onTap: () => context.push('/history'),
              ),
              _menuItem(icon: Icons.help, title: "Help Center", onTap: () {}),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.push('/delete-account'),
                child: const Text(
                  "Delete Account",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }
}
