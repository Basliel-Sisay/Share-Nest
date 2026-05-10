import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _resourceCount = 12;
  final int _shareCount = 48;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(child: _loading ? _buildLoading() : _buildContent()),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 50),
          ),

          const SizedBox(height: 10),

          const Text(
            "Tinsae Getaneh",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const Text("tinsae21@gmail.com"),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatBox(title: "Resources", value: "$_resourceCount"),
              _StatBox(title: "Shares", value: "$_shareCount"),
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
            onTap: () {},
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
        ],
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
