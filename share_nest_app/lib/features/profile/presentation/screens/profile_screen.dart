import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/app_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await ref.read(authProvider.notifier).updateProfileImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final resourcesAsync = ref.watch(resourcesProvider);
    final loansAsync = ref.watch(loansProvider);

    final resourceCount = resourcesAsync.asData?.value.length ?? 0;
    final loanCount = loansAsync.asData?.value.length ?? 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: (user?.imagePath != null)
                      ? (kIsWeb
                          ? NetworkImage(user!.imagePath!)
                          : File(user!.imagePath!).existsSync()
                              ? FileImage(File(user.imagePath!))
                              : null) as ImageProvider
                      : null,
                  child: (user?.imagePath == null ||
                          (!kIsWeb && !File(user!.imagePath!).existsSync()))
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
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
                  _StatBox(
                    title: "Resources",
                    value: "$resourceCount",
                    onTap: () => context.go('/browse'),
                  ),
                  _StatBox(
                    title: "Loans",
                    value: "$loanCount",
                    onTap: () => context.go('/history'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _menuItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () => context.push('/settings'),
              ),
              if (user?.role == 'admin')
                _menuItem(
                  icon: Icons.admin_panel_settings,
                  title: "Admin Dashboard",
                  onTap: () => context.push('/admin'),
                ),
              _menuItem(
                icon: Icons.history,
                title: "Sharing History",
                onTap: () => context.push('/history'),
              ),
              _menuItem(
                icon: Icons.help,
                title: "Help Center",
                onTap: () => context.push('/help-center'),
              ),
              const SizedBox(height: 88),
              if (authState.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (authState.error != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => ref.read(authProvider.notifier).logout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Logout"),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: authState.isLoading
                    ? null
                    : () => context.push('/delete-account'),
                child: const Text(
                  "Delete Account",
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
  final VoidCallback? onTap;

  const _StatBox({required this.title, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
